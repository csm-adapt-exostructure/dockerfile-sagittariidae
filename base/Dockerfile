# -*- docker-image-name: "sagittariidae" -*-

FROM csm-adapt/base:0.1.0
MAINTAINER Docker <docker@adapt.mines.edu>

# Runtime environment setup. It requires `root` privileges so it is done before
# setting up the user as which the application will run.

# Base image
RUN apk add --progress --update \
    git

ENV WSVER=3c308c2115ff35f2097c69cab8f0e0dc166e9885
ENV FEVER=9de2e6d91467b417e2ccf6b2b38f9bd9f484283c

# TODO: The user name is essentially meaningless (it's human-readable sugar).
# All permissions magic is actually performed using the UID.  If we're going to
# be accessing service data from multiple containers (for backups, log
# shipping, etc), do we need to sync the UID across multiple containers.  Does
# this imply the need for a UID registry (both for human and system users)?
RUN /usr/sbin/addgroup -g 9001 adapt-custodians
RUN /usr/sbin/addgroup -g 9002 adapt-archivists

# Create under which the service will run.  In keeping with generally accepted
# best practices we don't run as root, which limits the attack vector if the
# container is compromised through the service.
ENV SERVICE=sagittariidae
ENV SVCUSER=adapt-${SERVICE}
ENV HOME=/home/${SERVICE}

RUN /usr/sbin/adduser \
    -u 30001 \
    -D \
    -h /home/${SERVICE} \
    -s /sbin/nologin \
    -g "ADAPT's data management (web) service" \
    ${SVCUSER} \
    && /usr/sbin/adduser ${SVCUSER} adapt-archivists

# Ensure that the file system resources required by the service exist and have
# the appropriate permissions.
# TODO: Run as application hook
RUN LOG_FILE=/var/log/${SERVICE}.log; DB_DIR=/var/db/${SERVICE}; \
    (touch ${LOG_FILE} \
    && chown ${SVCUSER}:adapt-custodians /var/log/${SERVICE}.log) \
    && (([ -d ${DB_DIR} ] || mkdir -p ${DB_DIR}) \
    && touch ${DB_DIR}/${SERVICE}.db \
    && ([ -d ${DB_DIR}/db_repository ] || mkdir ${DB_DIR}/db_repository) \
    && chown -R ${SVCUSER} ${DB_DIR})

# Note: Where the `VOLUME` directive appears in the build is important;
# cf. https://docs.docker.com/engine/reference/builder/#/volume.  TL;DR: it
# must appear *after* the changes that are expected to appear in the volume.
VOLUME ["/var/log", "/var/db", "/mnt/adapt"]
