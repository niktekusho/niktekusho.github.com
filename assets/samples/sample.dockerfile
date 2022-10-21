# This Dockerfile creates images for [redacted].
# This Dockerfile uses 3 build steps::
# 	1. download Gradle and dependencies from Artifactory
# 	2. compile Java code with Gradle
# 	3. copy compiled .war into Tomcat
# First step should run from scratch only on Gradle or dependencies updates.
# Manual build: "docker build --tag [redacted]:qa-latest --file qa-[redacted].dockerfile ."

# First build step: download Gradle and dependencies from Artifactory
FROM eclipse-temurin:11.0.15_10-jdk-alpine as build_cache

# Customize environment var used by Gradle to store the build cache.
ARG GRADLE_CACHE_DIR=/gradle-cache
ENV GRADLE_USER_HOME=$GRADLE_CACHE_DIR

# ...

# Gradle CLI arguments
ARG GRADLE_ARGS="--no-daemon --stacktrace"

# Run the Gradle Wrapper for the first time.
RUN cd $TARGET_DIR && ./gradlew $GRADLE_ARGS

# Second build step: compile Java code with Gradle
FROM eclipse-temurin:11.0.15_10-jdk-alpine as build

# An ARG instruction goes out of scope at the end of the build stage where it was defined.
# To use an arg in multiple stages, each stage must include the ARG instruction.
ARG GRADLE_CACHE_DIR=/gradle-cache
ARG TARGET_DIR=/app-code
ARG GRADLE_ARGS="--no-daemon --stacktrace"

### Copy files from previous step.

# Gradle cache must be put in the user home dir.
COPY --from=build_cache $GRADLE_CACHE_DIR .gradle

# ...

# Use gradle to create war.
RUN cd [redacted] && ./gradlew build $GRADLE_ARGS

# ...
