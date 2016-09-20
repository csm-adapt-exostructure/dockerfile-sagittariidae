# -*- docker-image-name: "sagittariidae" -*-

FROM csm-adapt/sagittariidae-base:0.0.0
MAINTAINER Docker <docker@adapt.mines.edu>

# Application requirements
RUN apk --progress add \
    nodejs=6.2.0-r0 \
    openjdk8-jre-base=8.92.14-r1 \
    python=2.7.12-r0 \
    py-pip=8.1.2-r0

RUN npm install -g bower@1.7.9
RUN cd /usr/local/bin \
    && wget -O boot https://github.com/boot-clj/boot-bin/releases/download/2.5.2/boot.sh \
    && chmod 755 boot
# The Boot shell script requires bash
RUN apk --progress add bash

# Assume the `run as` user identity.
USER ${SVCUSER}
ENV FE=${HOME}/sagittariidae-fe.git
ENV WS=${HOME}/sagittariidae-ws.git
WORKDIR ${HOME}

# Fetch application artefacts.
RUN git clone \
    https://github.com/sinistral/csm-adapt.sagittariidae.git \
    ${WS} \
    && cd ${WS} \
    && git checkout -b ${WSVER} ${WSVER} \
    && cd -
RUN git clone \
    https://github.com/sinistral/csm-adapt.sagittariidae-fe.git \
    ${FE} \
    && cd ${FE} \
    && git checkout -b ${FEVER} ${FEVER} \
    && cd -

# TODO: Run as application hook.
WORKDIR ${FE}
ENV BOOT_VERSION=2.5.2
ENV BOOT_EMIT_TARGET=no
RUN boot build

# TODO: Run as application hook.
WORKDIR ${WS}
RUN pip install \
    --user \
    --requirement requirements.txt
ENV PATH=${PATH}:${HOME}/.local/bin
RUN ln -s ${FE}/target static
ENV PYTHONPATH=${WS}

ENV FLASK_APP=app/app.py
EXPOSE 5000
CMD ["flask", "run", "--host=0.0.0.0", "--port=5000"]

HEALTHCHECK --interval=1m --timeout=3s \
    CMD curl -f http://localhost:5000/projects || exit 1
