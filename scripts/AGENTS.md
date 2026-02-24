# SCRIPTS KNOWLEDGE BASE

## OVERVIEW
`scripts/` contains build, automation, and setup utilities, particularly around third-party integrations like RevenueCat.

## STRUCTURE
```text
scripts/
└── revenuecat/
    ├── setup_revenuecat_cli.sh    # Main API orchestration script
    └── revenuecat.config.json     # Declarative state for project/apps/catalog
```

## CONVENTIONS
- Keep scripts idempotent using API read-before-write checks (e.g., `lookup_key`).
- Require dependency validation early (jq, config file existence, env vars).
- Use `shopt -s inherit_errexit` or `set -e` to avoid silent cascade failures.

## ANTI-PATTERNS
- Do not commit `RC_V2_API_KEY` to JSON files or the repository.
- Do not assume successful creation without validating JSON ID extraction.
