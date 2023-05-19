# Guidelines

## Naming
If there is no language specific guideline, use the following:
- Use pascal case for all variables, e.g. `MyVariable`.
- Constants should be all uppercase, e.g. `MY_CONSTANT`.

### Folders
If there is no technology specific guideline, use the following:
- Use kebab case for all folders, e.g. `my-folder`.

### Files
If there is no language specific guideline, use the following:
- Use kebab case for all files, e.g. `my-file.txt`.

## Formats

### Date
If there is no technology specific guideline, use the following:
- Use ISO 8601 format, e.g. `2021-01-01`.

### Time
If there is no language specific guideline, use the following:
- Use 24h format, e.g. `13:00`.

### DateTime
If there is no language specific guideline, use the following:
- Use ISO 8601 format, e.g. `2021-01-01T13:00:00`.

## Logging & Telemetry
If possible, always use the following:
- https://opentelemetry.io/
- https://learn.microsoft.com/en-us/azure/azure-monitor/app/opentelemetry-overview

## Authentication & Authorization
If possible, always use the following:
- OpenID Connect
- OAuth 2.0

If avoidable never use the following:
- Basic Authentication
- Key based Authentication
