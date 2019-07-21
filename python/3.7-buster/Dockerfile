FROM python:3.7.4-buster

ENV PYTHONUNBUFFERED=1 \
    PIP_REQUIRE_VIRTUALENV=false \
    PIPSI_HOME=/pipsi/venvs \
    PIPSI_BIN_DIR=/pipsi/bin \
    WORKON_HOME=/virtualenvs \
    PATH=/virtualenvs/app-4PlAip0Q/bin:/pipsi/bin:$PATH \
    PYTHONPATH=/app/src:/app:$PYTHONPATH \
    LC_ALL=C.UTF-8 \
    LANG=C.UTF-8

COPY stack /stack/base
RUN DEBIAN_FRONTEND=noninteractive /stack/base/install.sh

WORKDIR /app
VOLUME /data
EXPOSE 80/tcp 443/tcp
ENTRYPOINT ["/tini", "-g", "--"]
CMD ["python"]
