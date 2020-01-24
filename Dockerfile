# command for ----  docker build --build-arg http_proxy=$env:HTTP_PROXY --build-arg https_proxy=$env:HTTPS_PROXY .
FROM python:3.7-alpine
MAINTAINER Annliz Ltd

ENV PYTHONUNBUFFERED 1
ARG http_proxy
ARG https_proxy

ENV HTTP_PROXY=$http_proxy HTTPS_PROXY=$https_proxy

COPY ./requirements.txt /requirements.txt
RUN apk add --update --no-cache postgresql-client
RUN apk add --update --no-cache --virtual .tmp-build-deps\
      gcc libc-dev linux-headers postgresql-dev

RUN pip install -r /requirements.txt
RUN apk del .tmp-build-deps

RUN mkdir /app
WORKDIR /app
COPY ./app /app

RUN adduser -D user
USER user
