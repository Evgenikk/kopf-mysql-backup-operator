FROM python:3.7
COPY mysql-operator.py /mysql-operator.py
RUN pip install kopf kubernetes pyyaml
CMD kopf run  /mysql-operator.py