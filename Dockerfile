FROM ubuntu:22.04

ARG FORGE_VERSION
ARG MEMORY_ALLOCATION

WORKDIR /minecraft

RUN apt-get update && apt-get install -y \
    openjdk-21-jdk \
    wget \
    && rm -rf /var/lib/apt/lists/*

RUN wget -O installer.jar https://maven.minecraftforge.net/net/minecraftforge/forge/$FORGE_VERSION/forge-$FORGE_VERSION-installer.jar
RUN java -jar installer.jar --installServer
RUN rm installer.jar
RUN rm run.bat

RUN ./run.sh || true
RUN echo "eula=true" > eula.txt
RUN echo "-Xmx$MEMORY_ALLOCATION" > user_jvm_args.txt

COPY mods/ mods/
RUN rm mods/mods.txt || true

EXPOSE 25565

CMD ["./run.sh", "nogui" ]