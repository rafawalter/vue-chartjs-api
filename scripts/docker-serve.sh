echo \### docker-serve $1 $2

ambiente=${1:-dev}
ports=${2:-8080:8080}

./scripts/docker-build-image.sh "$ambiente" && ./scripts/docker-run.sh "$ambiente" "$ports"
