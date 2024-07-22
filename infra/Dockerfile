# syntax=docker.io/docker/dockerfile:1

# For building elixir releases.
# These are the base images that update rarely, and specifically for OS or core library updates.

# The Phoenix team recommends using debian instead of alpine to avoid
# DNS issues.
ARG DEBIAN_VERSION=bullseye-20240701-slim

ARG ELIXIR_VERSION=1.17.2
ARG OTP_VERSION=27.0.1

ARG BUILDER_IMAGE="hexpm/elixir:${ELIXIR_VERSION}-erlang-${OTP_VERSION}-debian-${DEBIAN_VERSION}"
ARG RUNNER_IMAGE="debian:${DEBIAN_VERSION}"

# Used for compiling elixir code into BEAM.
FROM ${BUILDER_IMAGE} AS builder

WORKDIR /app

# Install build dependencies
RUN apt-get update -y \
 && apt-get install -y \
    build-essential \
    git \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*_* \
 && mix do local.hex --force, local.rebar --force \
 && mkdir -p /app/config

# Used to run the compiled BEAM code.
FROM ${RUNNER_IMAGE} AS runner

RUN apt-get update -y \
 && apt-get install -y \
    libstdc++6 \
    openssl \
    libncurses5 \
    locales \
    ca-certificates \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*_*
