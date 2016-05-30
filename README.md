# dockerw
A simple docker command wrapper for the rest of us.


# Usage

./dockerw [ build | run | stop | clean | env | help ]

| Command | Description |
|:--------|:------------|
| build | builds the docker image   |
| run   | runs a docker container in foreground based on the image |
| stop  | stops all running container based on the image and removes them |
| clean | calles "stop" and then removes all images |
| env   | list current environment variables |
| help  | display  help |

# env variables
| Name  | Description | Example |
|:------|:------------|:--------|
|BASE_NAME| the base name of the container |"jerady"|
|CONTAINER_NAME| the name of the container to be build |"$(basename \`pwd`)"|
|DOCKER_RUN| the docker run command to be called by ./dockerw run| "docker run -ti --name $CONTAINER_NAME $IMAGE_NAME" |