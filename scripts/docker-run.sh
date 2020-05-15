echo \### docker-run $1 $2

ambiente=${1:-dev}
ports=${2:-8080:8080}
project=${PWD##*/}
image=$project-$ambiente

docker run -it --rm --name "$image" -p "$ports" -v "$(pwd):/app" "$image"
