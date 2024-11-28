FROM apache/airflow:2.6.3-python3.10

ARG dev_build="false"

USER root
RUN apt-get update \
  && apt-get install -y \
         build-essential \
         unixodbc-dev \
         libpq-dev \
         freetds-dev \
         freetds-bin \
         vim \
         unzip \
         git \
  && sed -i 's,^\(MinProtocol[ ]*=\).*,\1'TLSv1.0',g' /etc/ssl/openssl.cnf \
  && sed -i 's,^\(CipherString[ ]*=\).*,\1'DEFAULT@SECLEVEL=1',g' /etc/ssl/openssl.cnf \
  && curl -O http://acraiz.icpbrasil.gov.br/credenciadas/CertificadosAC-ICP-Brasil/ACcompactado.zip \
  && unzip ACcompactado.zip -d /usr/local/share/ca-certificates/ \
  && update-ca-certificates \
  && apt-get autoremove -yqq --purge \
  && apt-get clean \
  && rm -rf \
    /var/lib/apt/lists/* \
    /tmp/* \
    /var/tmp/* \
    /usr/share/man \
    /usr/share/doc \
    /usr/share/doc-base \
  && sed -i 's/^# en_US.UTF-8 UTF-8$/en_US.UTF-8 UTF-8/g' /etc/locale.gen \
  && sed -i 's/^# pt_BR.UTF-8 UTF-8$/pt_BR.UTF-8 UTF-8/g' /etc/locale.gen \
  && locale-gen en_US.UTF-8 pt_BR.UTF-8 \
  && update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

RUN apt-get update && apt-get install -y r-base-core

USER airflow
WORKDIR /airflow

COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir --user -r requirements.txt

COPY ./config-files/webserver_config.py /home/airflow/webserver_config.py

RUN \
  if [[ "${dev_build}" == "false" ]] ; \
  then \
    mv ~/webserver_config.py ${AIRFLOW_HOME}; \
  fi
