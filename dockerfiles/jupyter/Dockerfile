FROM jupyterhub/jupyterhub

RUN apt-get update && apt install -y build-essential libpq-dev

RUN mkdir /comic

WORKDIR /comic

RUN git clone --depth 1 https://github.com/EYRA-Benchmark/comic.git

RUN pip install jupyter jupyterlab && \
    conda create -n py37 python=3.7 && \
    /opt/conda/envs/py37/bin/pip install jupyter ipykernel setuptools wheel ipywidgets pipenv && \
    /opt/conda/envs/py37/bin/pip install -r comic/requirements.txt && \
    /opt/conda/envs/py37/bin/python -m ipykernel install --prefix /opt/conda/

RUN jupyter labextension install @jupyterlab/hub-extension && \
    jupyter nbextension enable --py widgetsnbextension && \
    jupyter labextension install @jupyter-widgets/jupyterlab-manager


WORKDIR /comic/comic/app
RUN /opt/conda/envs/py37/bin/python setup.py install
WORKDIR /comic/

#COPY entrypoint.sh /entrypoint.sh
#RUN chmod a+x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

CMD jupyterhub -f /config/jupyterhub_config.py
