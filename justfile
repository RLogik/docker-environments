set shell := [ "bash", "-uc" ]
default:
    @just --list

container-hello:
    docker compose --env-file "first.env" up --build "hello"
container-busy:
    docker compose --env-file "first.env" up --build -d "busy"
    @docker attach "app_busy"
image-busy:
    @docker run -it "app:busy" bash
