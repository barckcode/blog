FROM python:3.9

WORKDIR /app

COPY ./requirements.txt /app

ENV FLASK_APP=main.py
ENV FLASK_ENV=development

RUN pip3 install -r requirements.txt
