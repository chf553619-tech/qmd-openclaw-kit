# Release checklist

## Before tagging

- [ ] `bash -n scripts/*.sh`
- [ ] rerun `./scripts/bootstrap-collections.sh`
- [ ] verify README and README.zh-CN are in sync at a high level
- [ ] verify examples still match current scripts
- [ ] confirm current token/account is the intended release identity

## Release steps

- [ ] update `CHANGELOG.md`
- [ ] create annotated tag
- [ ] push branch and tag
- [ ] create GitHub Release notes

## After release

- [ ] verify README renders correctly on GitHub
- [ ] verify examples and docs links resolve
- [ ] verify CI workflow is visible
