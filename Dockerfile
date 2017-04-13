FROM python:3.6
WORKDIR /opt
ADD main /opt/github-issues-csv
WORKDIR /opt/github-issues-csv
RUN pip install -r requirements.txt
