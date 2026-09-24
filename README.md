# gh-cc-test

Playground repository driven end-to-end by the AI control plane POC.

- Stages are triggered by `stage:<phase>:ready` labels.
- `.github/workflows/control-plane-doorbell.yml` is the only workflow: it forwards events to the control plane.
- All stage logic lives in the control plane state machine, not in YAML.
