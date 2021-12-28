FROM python:3.9

WORKDIR /app

COPY ./blog/ /app/

RUN pip3 install -r requirements.txt

CMD [ "flask", "run", "--host=0.0.0.0" ]
