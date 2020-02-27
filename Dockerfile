FROM jupyter/minimal-notebook:latest
MAINTAINER Andrea PIERRÉ <andrea_pierre@brown.edu>

USER root
RUN mkdir /repo
RUN chown jovyan:users /repo
WORKDIR /repo
VOLUME ["/repo"]

COPY environment.yml environment.yml
# RUN conda update -n base conda
RUN conda env create -f environment.yml
RUN conda run -n xkcd python -m ipykernel install --user --name=xkcd
RUN conda run -n xkcd jupyter labextension install @jupyter-widgets/jupyterlab-manager \
    jupyter-matplotlib @ryantam626/jupyterlab_code_formatter jupyterlab-flake8
RUN conda run -n xkcd jupyter serverextension enable --py jupyterlab_code_formatter
RUN chmod -R 777 /opt/conda/envs/

# COPY . .
# RUN chmod -R 777 /repo
RUN echo $(conda run -n xkcd jupyter notebook list)
RUN echo "To show JupyterLab, open this URL in your browser: http://localhost:1984/"
RUN echo "To show the debugger, open this URL in your browser: http://localhost:8890/lab"

# Add Tini. Tini operates as a process subreaper for jupyter. This prevents
# kernel crashes.
ENV TINI_VERSION v0.6.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/bin/tini
RUN chmod +x /usr/bin/tini
ENTRYPOINT ["/usr/bin/tini", "--"]

RUN chmod -R 777 /home/jovyan
USER $NB_UID

EXPOSE 8888
CMD ["conda", "run", "-n", "xkcd", "jupyter", "lab", "--port=8888", "--no-browser", "--ip=0.0.0.0"]