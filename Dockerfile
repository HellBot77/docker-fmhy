FROM alpine/git AS base

ARG TAG=latest
RUN git clone https://github.com/fmhy/edit.git && \
    cd edit && \
    ([[ "$TAG" = "latest" ]] || git checkout ${TAG}) && \
    rm -rf .git

FROM node:alpine AS build

WORKDIR /edit
COPY --from=base /git/edit .
RUN npm install --global pnpm && \
    pnpm install && \
    pnpm docs:build

FROM lipanski/docker-static-website

COPY --from=build /edit/docs/.vitepress/dist .
