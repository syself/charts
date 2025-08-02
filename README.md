# Syself Chart Repo

This git repo contains our Helm Charts.

## Releasing

Just merge your PR to main. Then [Chart Releaser Action](https://github.com/helm/chart-releaser-action) will do the rest.

No need for `export RELEASE_TAG=vX.Y.Z`.

Soon after the merge the corresponding git tag will be set and the chart will be available.
