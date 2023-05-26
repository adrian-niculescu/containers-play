# Docker cheatsheet

## Commands

### Show images

```bash
sudo docker images
```

### Show docker containers (processes)

```bash
sudo docker ps
```

Show **all** (the stopped ones too):

```bash
sudo docker ps -a
```

### Remove all containers

```bash
all=$(sudo docker container ls -qa) && [ -n "${all}" ] && sudo docker container rm -f $all
```

with check;

```bash
all=$(sudo docker container ls -qa) && [ -n "${all}" ] && sudo docker container rm -f $all; sudo docker ps -a
```

### Remove all images

```bash
all=$(sudo docker image ls -q) && [ -n "${all}" ] && sudo docker image rm -f $all
```

with check:

```bash
all=$(sudo docker image ls -q) && [ -n "${all}" ] && sudo docker image rm -f $all; docker images
```

### Run interactive

```bash
sudo docker run -it ubuntu
```

### Run as daemon

```bash
sudo docker run -d <image>
```

### Stop

```bash
sudo docker stop <container id / name>
```

### Remove

Remove from ps -a (won't even show up as terminated):

```bash
sudo docker rm <container id / name>
```

### Add a tag

```bash
docker image tag react-app:latest react-app:1
```

### Remove tag

```bash
sudo docker image remove <TAG>
```

### Save and load an image

```bash
sudo docker image save -o react-app.tar react-app:3
sudo docker image load -i react-app.tar
sudo docker images
```

### Logs

Example

Run the React demo:

```bash
cd react-app
sudo docker build -t react-app .
sudo docker container run -d --name react1 react-app
```

Let's see the logs of the container:

```bash
sudo docker logs react1
```

Follow (show and keep showing):

```bash
sudo docker logs -f react1
```

With timestamp:

```bash
sudo docker logs -t react1
```

combined:

```bash
sudo docker logs -f -t react1
```

### Volumes

Example:

```bash
sudo docker volume create app-data
sudo docker volume inspect app-data
```

Run the React demo:

```bash
cd react-app
sudo docker build -t react-app .
```

Run the container named `c1` with a volume called `app-data` mounted at `/app/data`:

```bash
docker run -d -p 4000:3000 -v app-data:/app/data --name c1 react-app
```

### Copying files between host and container

Example

```bash
cd react-app
sudo docker build -t react-app .
sudo docker run -d -v app-data:/app/data --name c2 react-app
```

```bash
echo hello > log.txt
sudo docker cp log.txt cp:/app/log.txt
```

```bash
sudo docker cp c2:/app/log.txt .
```

### Avoid rebuild for dev changes

Mount the current working directory (given by `pwd`), assuming that's where you have your code, in the container.

```bash
sudo docker run -d -p 5001:3000 --name c4 -v $(pwd):/app react-app
```
