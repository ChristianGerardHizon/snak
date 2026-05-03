# Snak

Snak is a school project — a Flutter app built for academic purposes.

## Live demo

Deployed at: https://christiangerardhizon.github.io/snak/

The web build is published automatically via GitHub Actions on every merge to `main`. See [.github/workflows/deploy.yml](.github/workflows/deploy.yml).

## Tech stack

- Flutter (web target for the deployed build)
- Hooks Riverpod for state management
- GoRouter for navigation
- Supabase as the backend

## Running locally

```bash
dart pub get
dart run build_runner build --delete-conflicting-outputs --low-resources-mode
flutter run
```
