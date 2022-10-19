FROM ubuntu:latest

RUN apt update && apt upgrade -y
RUN apt install openjdk-8-jre wget -y

RUN mkdir /modserver /tools
RUN wget -O /tools/serverinstall https://api.modpacks.ch/public/modpack/25/123/server/linux
RUN chmod +x /tools/serverinstall

COPY ./startscript.sh /tools/

ENTRYPOINT ["bash", "/tools/startscript.sh"]