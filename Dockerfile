FROM alpine/git AS base

ARG TAG=latest
RUN git clone https://github.com/fmhy/edit.git && \
    cd edit && \
    ([[ "$TAG" = "latest" ]] || git checkout ${TAG}) && \
    rm -rf .git

FROM --platform=$BUILDPLATFORM node:alpine AS build

WORKDIR /edit
COPY --from=base /git/edit .
RUN npm install --global pnpm && \
    pnpm install && \
    pnpm docs:build

FROM joseluisq/static-web-server

COPY --from=build /edit/docs/.vitepress/dist ./public
