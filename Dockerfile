FROM redis

ENV PATH /usr/local/bin:$PATH
WORKDIR /usr/src/app

RUN cd /usr/local/bin
RUN apt-get update
RUN apt-get install -y python3
RUN apt-get install -y python-pip

COPY requirements.txt ./
RUN pip install -r requirements.txt


COPY Redis-Python-Sample.py ./
CMD "redis-server"




