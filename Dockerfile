FROM clojure:temurin-22-lein-jammy

WORKDIR /usr/src/app

RUN apt-get update && \
    apt-get install -y git && \
    rm -rf /var/lib/apt/lists/*

RUN ln -s "/opt/java/openjdk/bin/java" "/bin/iplant-groups"

COPY project.clj /usr/src/app/
RUN lein deps

COPY conf/main/logback.xml /usr/src/app/
COPY . /usr/src/app

RUN lein do clean, uberjar && \
    cp target/iplant-groups-standalone.jar .

ENTRYPOINT ["iplant-groups", "-Dlogback.configurationFile=/usr/src/app/logback.xml", "-cp", ".:iplant-groups-standalone.jar:/", "iplant_groups.core"]
CMD ["--help"]

ARG git_commit=unknown
ARG version=unknown
ARG descriptive_version=unknown

LABEL org.cyverse.git-ref="$git_commit"
LABEL org.cyverse.version="$version"
LABEL org.cyverse.descriptive-version="$descriptive_version"
LABEL org.label-schema.vcs-ref="$git_commit"
LABEL org.label-schema.vcs-url="https://github.com/cyverse-de/iplant-groups"
LABEL org.label-schema.version="$descriptive_version"
