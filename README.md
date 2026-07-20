# Player UI Docker Build Images

This repo contains the Dockerfiles for the various images the Player-UI repositories use for builds

# Full
On top of `cimg/openjdk:8.0-node` and used for full Player polyglot builds. Contains:
- bazelisk
- rbenv
- Android SDK & NDK
- gh

# Slim
On top of `cimg/node:22.21` and used for only builds that are just js. Contains: 
- bazelisk