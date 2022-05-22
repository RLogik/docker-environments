# Docker and environment variables #

This repository is simply designed to experimentally observe and verify
how environment variables are treated by docker.
The official documentation can be found here <https://docs.docker.com/compose/environment-variables>.

## Sources of environment variables ##

There are three sources for environment variables:

- cli parameters to be used with `docker compose ...` command:
  - `--env-file` - optional, defaults to `.env`
- arguments that can be used in services in `docker-compose.yaml`:
  - `env_file:` - optional, path to some env file.
  - `environment:` - optional dictionary of variables.

For the sake of clarity, we shall set all of these to different values:

- `... --env-file first.env ...`
- `env_file: second.env`
- `environment: # ...` (keys set, which are not in any `.env` file)

We also set up a `.env` file with keys that are not in any other env file.

## What is available when, and what takes priority? ##

- Substitution (`${...}`) in `docker-compose.yaml`:
  1. only from `--env-file`
- During build:
  1. [--env-file --->] docker-compose > build > args
- Run time:
  1. [--env-file --->] docker-compose > build > environment
  2. docker-compose > build > env_file

## Try it out ##

Call
```bash
just container-hello
```
and observe the logs
to verify that the `.env` file is ignored, when `--env-file first.env` is set.

Call
```bash
just container-busy
```
and observe the logs
and call within the container
```bash
pwd # should be path from first.env, not second.env
ls # should have successfully mounted ./docs to correct path
echo $TOKEN # should be from dco.yaml > build > environments, not second.env
echo $COLOUR # should be from dco.yaml > build > environments, not second.env
echo $CONTINENT # should be from dco.yaml > build > environments
echo $CITY # should be from second.env, not first.env
echo $GALAXY # should be empty, as first.env not loaded at runtime
echo $PLANET # should be empty, as .env not loaded at runtime
```

Call
```bash
just image-busy
```
to verify that no environment variables are passed in from any of the environments.
