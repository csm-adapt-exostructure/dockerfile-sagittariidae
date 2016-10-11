# -*- docker-image-name: "sagittariidae" -*-

FROM csm-adapt/sagittariidae-base:0.0.0
MAINTAINER Docker <docker@adapt.mines.edu>

# Runtime environment setup. It requires `root` privileges so it is done before
# setting up the user as which the application will run.

# Application requirements
RUN apk --progress add \
    python=2.7.12-r0 \
    py-pip=8.1.2-r0 \
    sqlite=3.13.0-r0

# Assume the `run as` user identity.
USER ${SVCUSER}
ENV WS=${HOME}/sagittariidae-ws.git
WORKDIR ${HOME}

# Fetch application artefacts.
RUN git clone \
    https://github.com/sinistral/csm-adapt.sagittariidae.git \
    ${WS} \
    && cd ${WS} \
    && git checkout -b ${WSVER} ${WSVER} \
    && cd -

# TODO: Run as application hook.
WORKDIR ${WS}
RUN pip install \
    --user \
    --requirement requirements.txt

RUN for job in sweep-staged-files sweep-completed-file-dirs; do \
    chmod u+x ${WS}/cron/$job; \
    done \
    && crontab cron/crontab

USER root
ENV LOCKDIR=/var/lock/sagittariidae
RUN mkdir -p ${LOCKDIR}
RUN for LOCKFILE in sweep-staged-files sweep-completed-file-dirs; do \
    touch ${LOCKDIR}/${LOCKFILE}.lock \
    && chown adapt-sagittariidae ${LOCKDIR}/${LOCKFILE}.lock; \
    done

CMD ["crond", "-f", "-L", "/var/log/crond", "-l", "4"]
