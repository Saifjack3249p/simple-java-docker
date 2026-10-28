# Simple Java Docker

A beginner-friendly project that packages and runs a small Java application in Docker. It is designed to practice Dockerfiles, image builds, containers, multi-stage builds, timezone configuration, and non-root execution.

> **Source acknowledgement:** This is a learning adaptation of [LondheShubham153/simple-java-docker](https://github.com/LondheShubham153/simple-java-docker). The Dockerfile has been updated to demonstrate a multi-stage build and non-root runtime. Review the original repository's license and preserve any required notices before redistributing source code.

## Project structure

```text
simple-java-docker/
├── Dockerfile
├── .dockerignore
├── .gitignore
├── README.md
└── src/
    └── Main.java
```

## Prerequisites

- Docker Engine or Docker Desktop
- Internet access to pull the base images the first time

You do not need to install Java on the host machine: Docker compiles the source code in the builder stage.

## Build the image

Run this command from the project root (the directory containing the Dockerfile):

```bash
docker build -t java-app:1.0 .
```

The final `.` is the Docker build context: files in this directory can be used by `COPY` instructions, except files excluded by `.dockerignore`.

## Run the container

```bash
docker run --rm java-app:1.0
```

Expected output resembles the following; the time and date will change on each run:

```text
Hello, Docker! Current date: Thu Oct 29 02:29:42 IST 2026
```

`--rm` tells Docker to remove the stopped container automatically.

## Useful commands

```bash
# Show local images
docker images

# Show running containers
docker ps

# Show all containers, including stopped ones
docker ps -a

# Inspect the built image
docker image inspect java-app:1.0
```

## How the Dockerfile works

1. `FROM eclipse-temurin:17-jdk-alpine AS builder` creates the build stage with the Java compiler.
2. `WORKDIR /app` sets the working directory for later instructions.
3. `COPY src/Main.java .` copies source code into the build stage.
4. `RUN javac Main.java` compiles `Main.java` into `Main.class` during the image build.
5. The second `FROM` starts a separate runtime stage based on a Java 17 JRE image.
6. `RUN apk add --no-cache tzdata` installs timezone data so the configured timezone is available.
7. `ENV TZ=Asia/Kolkata` sets the container's default timezone to IST.
8. `COPY --from=builder` copies only the compiled class file from the build stage.
9. `USER 10001:10001` runs the application without root privileges.
10. `CMD ["java", "Main"]` defines the default process started by the container.

## Why use a multi-stage build?

The builder stage contains the JDK and compiler. The final stage contains the JRE and compiled application, so the compiler is not carried into the runtime image. This can reduce the final image size and the number of tools available in the running container.

## Timezone note

The timezone affects how local date/time values are formatted. It does not change the underlying instant. UTC is commonly used for infrastructure and logs in production, with conversion to a user's timezone handled where needed. IST is configured here for learning purposes.

## Scope and limitations

This example assumes `Main.java` has no package declaration and uses no third-party dependencies. Larger Java applications may need to copy resource files or package a JAR with Maven or Gradle. Image tags should be reviewed and updated as needed; for reproducible production builds, consider pinning images by digest and using an image-scanning process.

## Learning goals

After completing this project, you should be able to explain:

- The difference between a Dockerfile, image, and container
- The difference between build-time `RUN` and startup-time `CMD`
- How multi-stage builds separate compilation from runtime
- Why containers should avoid running as root when possible
- How timezone configuration affects displayed timestamps

## Author

Saif Ali — Cloud and DevOps learning projects.
