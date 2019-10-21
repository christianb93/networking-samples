# This Dockerfile assembles a Docker image for networking tests
# It uses NGINX and adds a few networking tools
# To build and push:
# docker built -t christianb93/networking .
# docker push christianb93/networking
FROM  nginx:latest

# Install inetutils-ping and net-tools
RUN apt-get update && apt-get install -y inetutils-ping net-tools
