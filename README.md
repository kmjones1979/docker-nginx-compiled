## NGINX Dockerfile Install via nginx.org

Clone
```
git clone git@github.com:kmjones1979/docker-nginx-compiled.git
```

Build
```
docker build --no-cache -t <docker_image_name> .
```

Run
```
docker run -i -t --name <container_name> -P -d <docker_image_name>
```

Requirements:
Docker

