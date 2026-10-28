# Stage 1: Compile the Java application with the JDK
FROM eclipse-temurin:17-jdk-alpine AS builder

WORKDIR /app
COPY src/Main.java .
RUN javac Main.java

# Stage 2: Run the compiled app with the smaller JRE image
FROM eclipse-temurin:17-jre-alpine

# Install timezone data so TZ=Asia/Kolkata is honored
RUN apk add --no-cache tzdata
ENV TZ=Asia/Kolkata

WORKDIR /app
COPY --from=builder --chown=10001:10001 /app/Main.class .

# Run as a non-root user
USER 10001:10001

CMD ["java", "Main"]
