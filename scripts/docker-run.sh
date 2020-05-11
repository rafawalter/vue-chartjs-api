ambiente="$1"
project=${PWD##*/}
image=$project-$ambiente
docker run -it --rm --name "$image" -p 8080:8080 -v "$(pwd):/source" "$image"
