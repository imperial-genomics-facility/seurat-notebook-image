FROM imperialgenomicsfacility/scanpy-notebook-image:release-v0.0.1
LABEL maintainer="imperialgenomicsfacility"
LABEL version="0.0.1"
LABEL description="Docker image for running Seurat based single cell analysis"
ENV NB_USER vmuser
ENV NB_UID 1000
USER root
WORKDIR /
RUN apt-get -y update &&  \
    apt-get purge -y --auto-remove && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
RUN rm -rf /home/$NB_USER/examples && \
    rm -f /home/$NB_USER/Dockerfile
COPY Dockerfile /home/$NB_USER/Dockerfile
COPY examples /home/$NB_USER/examples
RUN chown ${NB_UID} /home/$NB_USER/Dockerfile && \
    chown -R ${NB_UID} /home/$NB_USER/examples
USER $NB_USER
WORKDIR /home/$NB_USER
RUN conda install -n notebook-env -c anaconda gxx_linux-64 -y && \
    /home/vmuser/miniconda3/envs/notebook-env/bin/Rscript -e \
      'install.packages("Seurat", repos="https://cloud.r-project.org/", dependencies=TRUE, type="source")'
EXPOSE 8888
CMD [ "notebook" ]
