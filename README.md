# Syself Chart Repo

This git repo contains our Helm Charts.

## Releasing

- Do your changes. But only change one helm chart in one PR.
- Bump the version in Chart.yaml by hand.
- Let the PR get approved.
- Merge your PR to main. **No** need for `export RELEASE_TAG=v0.0.23 && git tag -a $RELEASE_TAG -m $RELEASE_TAG && git push origin $RELEASE_TAG`.
- [Chart Releaser Action](https://github.com/helm/chart-releaser-action) will create a new version and release it.
- You will see your new release here: <https://github.com/syself/charts/releases>
