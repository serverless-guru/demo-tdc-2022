FROM docker.hyattdev.com/docker/alpine3.8:pipeline-stable
WORKDIR /usr/src/app
RUN apk add curl zip
COPY ./ /tmp/source/
RUN chmod +x /tmp/source/run.sh
ENTRYPOINT []
CMD '/tmp/source/run.sh'
