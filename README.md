# gh-cc-test — Harborline Navigator (demo)

Playground repository driven by the AI control plane POC, now seeded with a **high-fidelity Flutter** cruise companion demo.

## What lives here

| Path | Role |
| --- | --- |
| `app/` | **Harborline Navigator** Flutter app (fictional brand) |
| `.github/workflows/control-plane-doorbell.yml` | Forwards GitHub events to the control plane |
| `.github/workflows/ci.yml` | Lightweight PR smoke |

Stages are triggered by `stage:<phase>:ready` labels. Stage logic lives in the control plane, not in YAML.

## Brand & legal

This is a **fictional** cruise product (**Harborline** / **Aether of the Seas**).  
IA is inspired by architecture/sitemap examples under the control-plane repo’s `docs/examples/` (**structure only**).  
No Disney / DCL trademarks, characters, logos, or assets.

## Run the Flutter app

Requires Flutter SDK **3.13+** (built with 3.13.1).

```bash
cd app
flutter pub get
flutter analyze
flutter test
flutter run -d macos   # or chrome / ios / android
```

Min targets: iOS 16+ / recent Android (Flutter defaults). Client also has native/Unity islands — out of scope here.

## Design

See [`app/docs/UI.md`](app/docs/UI.md) for palette and components.  
Architecture map: [`app/docs/ARCHITECTURE.md`](app/docs/ARCHITECTURE.md).

## Layout for agents

```
app/lib/
  features/   # screens by tab
  services/   # mock Auth, Profile, Payments, Hybrid, facades
  data/       # models + MockCatalog
  theme/      # tokens + ThemeData
  ui/widgets/ # shared chrome
```

## Demo stories (extension hooks)

Small PRs an agent can land against this baseline:

1. **Home quick action** — add a card on Home (e.g. “Spa holds”) that navigates to an existing Plans child route.
2. **Explore filter chip** — add a category chip that filters `MockCatalog.venues` on Explore.
3. **Messages inbox category** — surface a new inbox `kind` section with 1–2 sample items in `MockCatalog`.

## Control-plane demos

Later Code → Review → Explore runs assume this tree exists on `main`, so agents open real `.dart` files instead of an empty repo.
