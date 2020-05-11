ambiente=${1:-local}
./scripts/docker-build-image.sh "$ambiente" && ./scripts/docker-run.sh "$ambiente"
