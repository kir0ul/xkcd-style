FROM jupyter/minimal-notebook:latest
LABEL maintainer="Andrea PIERRÉ <andrea_pierre@brown.edu>"

# # Add Tini. Tini operates as a process subreaper for jupyter. This prevents
# # kernel crashes.
# ENV TINI_VERSION v0.6.0
# ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/bin/tini
# RUN chmod +x /usr/bin/tini
# ENTRYPOINT ["/usr/bin/tini", "--"]

# Copy dependencies file
COPY environment.yml /home/$NB_USER/tmp/

# Fix write persmissions
USER root
RUN chown jovyan:users /home/$NB_USER/tmp/
USER $NB_USER

# Default Conda environment name, otherwise we need to use some templating engine on the Dockerfile
ARG conda_env="Fleischmann"
RUN sed -i "s/name:.*/name: $conda_env/g" /home/$NB_USER/tmp/environment.yml

# Install dependencies from environment.yml file
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
RUN jupyter labextension install --no-build @jupyter-widgets/jupyterlab-manager \
    jupyter-matplotlib \
    @ryantam626/jupyterlab_code_formatter && \
    # jupyterlab-flake8 && \
    jupyter serverextension enable --py jupyterlab_code_formatter && \
    # jupyter labextension update --all && \
    jupyter lab clean && \
    jupyter lab build

WORKDIR /home/$NB_USER/work/
CMD ["start.sh", "jupyter", "lab"]