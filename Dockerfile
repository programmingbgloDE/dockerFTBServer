FROM ubuntu:latest

ARG JAVA_VERSION

RUN apt update && apt upgrade -y
RUN apt install openjdk-$JAVA_VERSION-jre wget -y

RUN mkdir /modserver /tools
RUN echo "$(arch)"
RUN if [ "$(arch)" = "aarch64" ]; then wget -O /tools/serverinstall "https://api.modpacks.ch/public/modpack/103/11446/server/arm/linux"; fi
RUN if [ "$(arch)" = "x86_64" ]; then wget -O /tools/serverinstall "https://api.modpacks.ch/public/modpack/25/123/server/linux"; fi
RUN chmod +x /tools/serverinstall

COPY ./startscript.sh /tools/

ENTRYPOINT ["bash", "/tools/startscript.sh"]
