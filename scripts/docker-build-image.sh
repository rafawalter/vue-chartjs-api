ambiente="$1"
project=${PWD##*/}
image=$project-$ambiente
echo $image
docker build -f ./docker/"$ambiente".dockerfile -t "$image" .
