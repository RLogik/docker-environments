################################################################
# BUILD STAGE 0
################################################################
FROM bash:latest

ARG WORKDIR
ARG CITY

COPY . ${WORKDIR}
WORKDIR ${WORKDIR}

# This won't expand:
RUN echo "continent=${CONTINENT}"
# This will expand:
RUN echo "city=${CITY}"
