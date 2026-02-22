#!/usr/bin/env bash
set -euo pipefail
shopt -s inherit_errexit 2>/dev/null || true

CONFIG_PATH="${1:-scripts/revenuecat/revenuecat.config.json}"
RC_API_KEY="${RC_V2_API_KEY:-}"

if [ ! -f "$CONFIG_PATH" ]; then
  echo "Config file not found: $CONFIG_PATH" >&2
  exit 1
fi

if [ -z "$RC_API_KEY" ]; then
  echo "RC_V2_API_KEY is required" >&2
  exit 1
fi

if ! command -v jq >/dev/null 2>&1; then
  echo "jq is required" >&2
  exit 1
fi

API_BASE="$(jq -r '.api_base // "https://api.revenuecat.com/v2"' "$CONFIG_PATH")"
TMP_FILES=()

cleanup() {
  local file
  for file in "${TMP_FILES[@]:-}"; do
    [ -n "$file" ] && [ -f "$file" ] && rm -f "$file"
  done
}
trap cleanup EXIT

request() {
  local method="$1"
  local path="$2"
  local payload="${3:-}"
  local response

  if [ -n "$payload" ]; then
    response="$(curl -sS -X "$method" "$API_BASE$path" -H "Authorization: Bearer $RC_API_KEY" -H "Content-Type: application/json" -d "$payload" -w "\n%{http_code}")"
  else
    response="$(curl -sS -X "$method" "$API_BASE$path" -H "Authorization: Bearer $RC_API_KEY" -w "\n%{http_code}")"
  fi

  local body="${response%$'\n'*}"
  local code="${response##*$'\n'}"

  if [ "$code" -lt 200 ] || [ "$code" -ge 300 ]; then
    echo "Request failed: $method $path ($code)" >&2
    echo "$body" >&2
    exit 1
  fi

  printf '%s' "$body"
}

upsert_project() {
  local project_id
  project_id="$(jq -r '.project.id // ""' "$CONFIG_PATH")"
  if [ -n "$project_id" ]; then
    printf '%s' "$project_id"
    return
  fi

  local app_ids inferred_project app_id app_body app_project
  app_ids="$(jq -r '.apps[]? | .id // empty' "$CONFIG_PATH")"
  inferred_project=""
  while IFS= read -r app_id; do
    [ -z "$app_id" ] && continue
    app_body="$(request GET "/apps/$app_id")"
    app_project="$(printf '%s' "$app_body" | jq -r '.project_id // .project.id // ""')"
    if [ -z "$app_project" ]; then
      echo "Unable to determine project for app id: $app_id" >&2
      exit 1
    fi
    if [ -z "$inferred_project" ]; then
      inferred_project="$app_project"
    elif [ "$inferred_project" != "$app_project" ]; then
      echo "Configured app IDs belong to different projects" >&2
      exit 1
    fi
  done <<< "$app_ids"

  if [ -n "$inferred_project" ]; then
    printf '%s' "$inferred_project"
    return
  fi

  local project_name
  project_name="$(jq -r '.project.name // ""' "$CONFIG_PATH")"
  if [ -z "$project_name" ]; then
    echo "project.id or project.name is required" >&2
    exit 1
  fi

  local list existing created
  list="$(request GET "/projects?limit=200")"
  existing="$(printf '%s' "$list" | jq -r --arg n "$project_name" '.items[]? | select(.name == $n) | .id' | head -n1)"
  if [ -n "$existing" ]; then
    printf '%s' "$existing"
    return
  fi

  created="$(request POST "/projects" "$(jq -n --arg n "$project_name" '{name:$n}')")"
  printf '%s' "$(printf '%s' "$created" | jq -r '.id')"
}

upsert_app() {
  local project_id="$1"
  local app_json="$2"

  local app_id name type
  app_id="$(printf '%s' "$app_json" | jq -r '.id // ""')"
  if [ -n "$app_id" ]; then
    printf '%s' "$app_id"
    return
  fi

  name="$(printf '%s' "$app_json" | jq -r '.name')"
  type="$(printf '%s' "$app_json" | jq -r '.type')"

  local list existing created payload
  list="$(request GET "/projects/$project_id/apps?limit=200")"
  existing="$(printf '%s' "$list" | jq -r --arg n "$name" '.items[]? | select(.name == $n) | .id' | head -n1)"
  if [ -n "$existing" ]; then
    printf '%s' "$existing"
    return
  fi

  case "$type" in
    app_store)
      payload="$(printf '%s' "$app_json" | jq -c '{name:.name,type:"app_store",app_store:{bundle_id:.bundle_id}}')"
      ;;
    play_store)
      payload="$(printf '%s' "$app_json" | jq -c '{name:.name,type:"play_store",play_store:{package_name:.package_name}}')"
      ;;
    mac_app_store)
      payload="$(printf '%s' "$app_json" | jq -c '{name:.name,type:"mac_app_store",mac_app_store:{bundle_id:.bundle_id}}')"
      ;;
    rc_billing)
      payload="$(printf '%s' "$app_json" | jq -c '{name:.name,type:"rc_billing",rc_billing:{app_name:(.app_name // .name),default_currency:(.default_currency // "USD")}}')"
      ;;
    *)
      echo "Unsupported app type in config: $type" >&2
      exit 1
      ;;
  esac

  created="$(request POST "/projects/$project_id/apps" "$payload")"
  printf '%s' "$(printf '%s' "$created" | jq -r '.id')"
}

upsert_entitlement() {
  local project_id="$1"
  local lookup_key="$2"
  local display_name="$3"

  local list existing created
  list="$(request GET "/projects/$project_id/entitlements?limit=200")"
  existing="$(printf '%s' "$list" | jq -r --arg k "$lookup_key" '.items[]? | select(.lookup_key == $k) | .id' | head -n1)"
  if [ -n "$existing" ]; then
    printf '%s' "$existing"
    return
  fi

  created="$(request POST "/projects/$project_id/entitlements" "$(jq -n --arg k "$lookup_key" --arg d "$display_name" '{lookup_key:$k,display_name:$d}')")"
  printf '%s' "$(printf '%s' "$created" | jq -r '.id')"
}

upsert_offering() {
  local project_id="$1"
  local lookup_key="$2"
  local display_name="$3"
  local is_current="$4"

  local list existing created offering_id
  list="$(request GET "/projects/$project_id/offerings?limit=200")"
  existing="$(printf '%s' "$list" | jq -r --arg k "$lookup_key" '.items[]? | select(.lookup_key == $k) | .id' | head -n1)"
  if [ -n "$existing" ]; then
    offering_id="$existing"
  else
    created="$(request POST "/projects/$project_id/offerings" "$(jq -n --arg k "$lookup_key" --arg d "$display_name" '{lookup_key:$k,display_name:$d}')")"
    offering_id="$(printf '%s' "$created" | jq -r '.id')"
  fi

  if [ "$is_current" = "true" ]; then
    request POST "/projects/$project_id/offerings/$offering_id" "$(jq -n --arg d "$display_name" '{display_name:$d,is_current:true}')" >/dev/null
  fi

  printf '%s' "$offering_id"
}

upsert_product() {
  local project_id="$1"
  local app_id="$2"
  local store_identifier="$3"
  local product_type="$4"
  local display_name="$5"

  local list existing created payload
  list="$(request GET "/projects/$project_id/products?app_id=$app_id&limit=200")"
  existing="$(printf '%s' "$list" | jq -r --arg s "$store_identifier" '.items[]? | select(.store_identifier == $s) | .id' | head -n1)"
  if [ -n "$existing" ]; then
    printf '%s' "$existing"
    return
  fi

  payload="$(jq -n --arg sid "$store_identifier" --arg aid "$app_id" --arg t "$product_type" --arg d "$display_name" '{store_identifier:$sid,app_id:$aid,type:$t,display_name:$d}')"
  created="$(request POST "/projects/$project_id/products" "$payload")"
  printf '%s' "$(printf '%s' "$created" | jq -r '.id')"
}

upsert_package() {
  local project_id="$1"
  local offering_id="$2"
  local lookup_key="$3"
  local display_name="$4"
  local position="$5"

  local list existing created
  list="$(request GET "/projects/$project_id/offerings/$offering_id/packages?limit=200")"
  existing="$(printf '%s' "$list" | jq -r --arg k "$lookup_key" '.items[]? | select(.lookup_key == $k) | .id' | head -n1)"
  if [ -n "$existing" ]; then
    printf '%s' "$existing"
    return
  fi

  created="$(request POST "/projects/$project_id/offerings/$offering_id/packages" "$(jq -n --arg k "$lookup_key" --arg d "$display_name" --argjson p "$position" '{lookup_key:$k,display_name:$d,position:$p}')")"
  printf '%s' "$(printf '%s' "$created" | jq -r '.id')"
}

append_product_id() {
  local map_file="$1"
  local key="$2"
  local product_id="$3"
  if [ -z "$product_id" ]; then
    echo "Cannot append empty product ID for catalog key: $key" >&2
    exit 1
  fi
  local tmp
  tmp="$(mktemp)"
  TMP_FILES+=("$tmp")
  jq --arg k "$key" --arg id "$product_id" '.[$k] = (((.[$k] // []) + [$id]) | unique)' "$map_file" > "$tmp"
  mv "$tmp" "$map_file"
}

attach_products_to_entitlement() {
  local project_id="$1"
  local entitlement_id="$2"
  local product_ids_json="$3"
  request POST "/projects/$project_id/entitlements/$entitlement_id/actions/attach_products" \
    "$(jq -n --argjson ids "$product_ids_json" '{product_ids:$ids}')" >/dev/null
}

attach_products_to_package() {
  local _project_id="$1"
  local package_id="$2"
  local product_ids_json="$3"
  request POST "/packages/$package_id/actions/attach_products" \
    "$(jq -n --argjson ids "$product_ids_json" '{product_ids:$ids}')" >/dev/null
}

resolve_product_ids_from_keys() {
  local map_file="$1"
  local keys_json="$2"
  jq -n --slurpfile map "$map_file" --argjson keys "$keys_json" '[
    $keys[]
    | ($map[0][.] // [])[]
  ] | unique'
}

require_config_array() {
  local key="$1"
  if [ "$(jq -r --arg k "$key" 'has($k) and (.[$k] | type == "array")' "$CONFIG_PATH")" != "true" ]; then
    echo "Config must include array: $key" >&2
    exit 1
  fi
}

require_config_array "apps"
require_config_array "catalog"
require_config_array "entitlements"
require_config_array "packages"

PROJECT_ID="$(upsert_project)"
if [ -z "$PROJECT_ID" ]; then
  echo "Failed to resolve RevenueCat project ID" >&2
  exit 1
fi
OFFERING_LOOKUP="$(jq -r '.offering.lookup_key' "$CONFIG_PATH")"
OFFERING_NAME="$(jq -r '.offering.display_name' "$CONFIG_PATH")"
OFFERING_CURRENT="$(jq -r '.offering.is_current // true' "$CONFIG_PATH")"
OFFERING_ID="$(upsert_offering "$PROJECT_ID" "$OFFERING_LOOKUP" "$OFFERING_NAME" "$OFFERING_CURRENT")"
if [ -z "$OFFERING_ID" ]; then
  echo "Failed to resolve RevenueCat offering ID" >&2
  exit 1
fi

PRODUCT_MAP_FILE="$(mktemp)"
TMP_FILES+=("$PRODUCT_MAP_FILE")
printf '{}' > "$PRODUCT_MAP_FILE"

while IFS= read -r app_json; do
  APP_ID="$(upsert_app "$PROJECT_ID" "$app_json")" || exit 1
  APP_TYPE="$(printf '%s' "$app_json" | jq -r '.type')"

  while IFS= read -r cat_json; do
    KEY="$(printf '%s' "$cat_json" | jq -r '.key')"
    STORE_ID="$(printf '%s' "$app_json" | jq -r --arg key "$KEY" '.store_identifiers[$key] // ""')"

    if [ -z "$STORE_ID" ]; then
      continue
    fi

    TYPE="$(printf '%s' "$cat_json" | jq -r '.product_type')"
    DISPLAY="$(printf '%s' "$cat_json" | jq -r '.display_name')"

    if [ "$APP_TYPE" = "play_store" ] && [ "$TYPE" = "subscription" ]; then
      case "$STORE_ID" in
        *:*) ;;
        *)
          echo "Invalid Play Store subscription store identifier for '$KEY': '$STORE_ID'. Expected 'subscriptionId:basePlanId'." >&2
          exit 1
          ;;
      esac
    fi

    PRODUCT_ID="$(upsert_product "$PROJECT_ID" "$APP_ID" "$STORE_ID" "$TYPE" "$DISPLAY")" || exit 1
    if [ -z "$PRODUCT_ID" ]; then
      echo "Failed to resolve product ID for catalog key: $KEY" >&2
      exit 1
    fi
    append_product_id "$PRODUCT_MAP_FILE" "$KEY" "$PRODUCT_ID"
  done < <(jq -c '.catalog[]' "$CONFIG_PATH")
done < <(jq -c '.apps[]' "$CONFIG_PATH")

while IFS= read -r ent_json; do
  ENT_KEY="$(printf '%s' "$ent_json" | jq -r '.lookup_key')"
  ENT_NAME="$(printf '%s' "$ent_json" | jq -r '.display_name')"
  ENT_ID="$(upsert_entitlement "$PROJECT_ID" "$ENT_KEY" "$ENT_NAME")" || exit 1

  PRODUCT_IDS="$(jq -n --slurpfile cfg "$CONFIG_PATH" --slurpfile map "$PRODUCT_MAP_FILE" --arg ent "$ENT_KEY" '[
    $cfg[0].catalog[]
    | select((.entitlements // []) | index($ent))
    | .key
    | $map[0][.][]?
  ] | unique')"

  if [ "$(printf '%s' "$PRODUCT_IDS" | jq 'length')" -gt 0 ]; then
    attach_products_to_entitlement "$PROJECT_ID" "$ENT_ID" "$PRODUCT_IDS"
  fi
done < <(jq -c '.entitlements[]' "$CONFIG_PATH")

while IFS= read -r pkg_json; do
  PKG_LOOKUP="$(printf '%s' "$pkg_json" | jq -r '.lookup_key')"
  PKG_NAME="$(printf '%s' "$pkg_json" | jq -r '.display_name')"
  PKG_POSITION="$(printf '%s' "$pkg_json" | jq -r '.position // 0')"
  PRODUCT_KEYS="$(printf '%s' "$pkg_json" | jq -c '.product_keys // []')"

  PKG_ID="$(upsert_package "$PROJECT_ID" "$OFFERING_ID" "$PKG_LOOKUP" "$PKG_NAME" "$PKG_POSITION")" || exit 1
  PKG_PRODUCT_IDS="$(resolve_product_ids_from_keys "$PRODUCT_MAP_FILE" "$PRODUCT_KEYS")"

  if [ "$(printf '%s' "$PKG_PRODUCT_IDS" | jq 'length')" -gt 0 ]; then
    attach_products_to_package "$PROJECT_ID" "$PKG_ID" "$PKG_PRODUCT_IDS"
  fi
done < <(jq -c '.packages[]' "$CONFIG_PATH")

echo "RevenueCat setup complete"
echo "Project ID: $PROJECT_ID"
echo "Offering ID: $OFFERING_ID"
