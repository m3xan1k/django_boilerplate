FROM python:3.10-slim

ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE 1

WORKDIR /usr/src/app

RUN apt-get update && apt-get install git -y
COPY ./requirements.txt .
RUN pip install --upgrade pip && pip install -r requirements.txt

COPY . .
