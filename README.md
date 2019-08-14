# Docker Compose - HANIoT Deployment

Repository with configuration files needed for the rapid implementation of the HANIoT platform using docker-compose.

We strongly recommend that you use this deployment option only in development and testing environment.

## Prerequisites

- Docker Engine 18.06.0+

  - **Linux:** Follow all the steps present in the [official documentation](https://docs.docker.com/install/linux/docker-ce/ubuntu/#install-docker-ce)

  - **Windows:** Follow all the steps present in the [official documentation](https://docs.docker.com/docker-for-windows/install/#about-windows-containers)
- Docker Compose 1.22.0+
  -  Follow all the steps present in the [official documentation](https://docs.docker.com/compose/install/)
## Set the environment variables

To ensure flexibility and increase the security of the platform, the HANIoT services receive some parameters through environment variables, e.g. IPs, credentials (username and password), etc.

The file `.env.example` contains all the environment variables required by the services being deployed. 

Copy and paste with the file `.env.example` with the name `.env` to make the Docker Compose use the environment variables defined in this file:

```sh
cp .env.example .env
```

Just to begin, an environment variable configuration example is provided below, where the value of the HTTP and HTTPS port of the Api Gateway is set (in this case, 8080 and 8081):
 
```
AG_PORT_HTTP=8080
AG_PORT_HTTPS=8081
```
 
#### Set certificates

If you already have valid HTTPS certificates to use on the platform, you need to point the path of each of them in the appropriate environment variables, they are:

`SSL_KEY_PATH`, `SSL_CERT_PATH`, `JWT_PRIVATE_KEY_PATH`, `JWT_PUBLIC_KEY_PATH` 

These certificates will be used by all microservices of the platform and must be valid for everything to function normally.
But if you are in a development/testing environment, you can generate self-signed certificates. To do this, run the `create-self-signed-certs.sh` script:
```sh
./create-self-signed-certs.sh
```
A subdirectory named `.certs` will be created. Now just point the paths of such files to the environment variables mentioned above in `.env`.

**Note:** *Do not use self-signed certificates in the production environment. It is highly recommended for the production environment that certificates are obtained by a valid certificate authority (CA)*
## Building and Deploying the containers

```sh
docker-compose up --build
 ```

It will build the containers and run the platform as specified in the file `docker-compose.yml`, opening a log screen with the logs of all the services started. 

## Stopping the execution

If you are still in the log screen press `Ctrl + C` just one time for graceful stop, two times to force stop

To stop all containers created by docker-compose, you need to go to the folder where docker-compose.yml is and run:
```sh
docker-compose down
 ```

To stop just one container:

```ssh
docker stop my_container
 ```

## Other useful commands

Restarts Docker. Useful in critical situations:

```sh
sudo service docker restart
 ``` 

Check all containers and its status:

```sh
docker container ls
 ```

Enter in the shell or bash of a particular container:

```sh
docker exec -it container_id /bin/bash
 ```

Stop all containers:

```sh
docker stop $(docker ps -a -q)
 ```

Delete all containers:

```sh
docker rm -f $(docker ps -a -q)
 ``` 
 
Delete all volumes:

```sh
docker volume rm $(docker volume ls -q)
```

Delete all container images:

```sh
docker rmi -f $(sudo docker images -q)
```
