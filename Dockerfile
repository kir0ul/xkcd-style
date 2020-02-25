FROM jupyter/minimal-notebook:latest
WORKDIR /repo
USER root
RUN chmod -R 777 /repo
COPY environment.yml environment.yml
RUN conda update -n base conda
RUN conda env create -f environment.yml
RUN conda run -n xkcd python -m ipykernel install --user --name=xkcd
RUN conda run -n xkcd jupyter labextension install @jupyter-widgets/jupyterlab-manager \
    jupyter-matplotlib @ryantam626/jupyterlab_code_formatter jupyterlab-flake8
RUN conda run -n xkcd jupyter serverextension enable --py jupyterlab_code_formatter
RUN chmod -R 777 /opt/conda/envs/
RUN chmod -R 777 ~/
USER $NB_UID
COPY . .
# RUN RUN echo $(conda run -n xkcd jupyter notebook list)
CMD ["conda", "run", "-n", "xkcd", "jupyter", "lab"]