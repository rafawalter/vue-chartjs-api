echo \### docker-build-image $1

ambiente="$1"
project=${PWD##*/}
image=$project-$ambiente

docker build -f ./docker/"$ambiente".dockerfile -t "$image" .
