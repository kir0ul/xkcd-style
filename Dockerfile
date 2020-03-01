FROM jupyter/minimal-notebook:latest
MAINTAINER Andrea PIERRÉ <andrea_pierre@brown.edu>

# USER root
# RUN mkdir /repo
# RUN chown jovyan:users /repo
# WORKDIR /repo
# VOLUME ["/repo"]
# RUN chmod -R 777 /repo

# # Add Tini. Tini operates as a process subreaper for jupyter. This prevents
# # kernel crashes.
# ENV TINI_VERSION v0.6.0
# ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/bin/tini
# RUN chmod +x /usr/bin/tini
# ENTRYPOINT ["/usr/bin/tini", "--"]

# name your environment and choose python 3.x version
ARG conda_env=xkcd

# Install dependencies from environment.yml file
COPY environment.yml /home/$NB_USER/tmp/

# Fix write persmissions
USER root
RUN chown jovyan:users /home/$NB_USER/tmp/
USER $NB_USER

RUN cd /home/$NB_USER/tmp/ && \
    conda env create -p $CONDA_DIR/envs/$conda_env -f environment.yml && \
    conda clean --all -f -y

# create Python 3.x environment and link it to jupyter
RUN $CONDA_DIR/envs/${conda_env}/bin/python -m ipykernel install --user --name=${conda_env} && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

# prepend conda environment to path
ENV PATH $CONDA_DIR/envs/${conda_env}/bin:$PATH

# if you want this environment to be the default one, uncomment the following line:
ENV CONDA_DEFAULT_ENV ${conda_env}

# Install JupyterLab extensions
RUN jupyter labextension install @jupyter-widgets/jupyterlab-manager \
    jupyter-matplotlib @ryantam626/jupyterlab_code_formatter jupyterlab-flake8
RUN jupyter serverextension enable --py jupyterlab_code_formatter

WORKDIR /repo

CMD ["start.sh", "jupyter", "lab"]