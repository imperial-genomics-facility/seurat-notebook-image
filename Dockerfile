FROM imperialgenomicsfacility/base-notebook-image:release-v0.0.5
LABEL maintainer="imperialgenomicsfacility"
LABEL version="0.0.2"
LABEL description="Docker image for running Seurat based single cell analysis"
ENV NB_USER vmuser
ENV NB_UID 1000
USER root
WORKDIR /
RUN apt-get -y update &&  \
    apt-get install --no-install-recommends -y curl && \
    curl -sL https://deb.nodesource.com/setup_15.x |bash - && \
    apt-get install --no-install-recommends -y nodejs && \
    apt-get purge -y --auto-remove && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
USER $NB_USER
WORKDIR /home/$NB_USER
RUN rm -rf /home/$NB_USER/examples && \
    rm -f /home/$NB_USER/environment.yml && \
    rm -f /home/$NB_USER/Dockerfile
COPY Dockerfile /home/$NB_USER/Dockerfile
COPY environment.yml /home/$NB_USER/environment.yml
COPY examples /home/$NB_USER/examples
USER root
RUN chown ${NB_UID} /home/$NB_USER/environment.yml && \
    chown ${NB_UID} /home/$NB_USER/Dockerfile && \
    chown -R ${NB_UID} /home/$NB_USER/examples
USER $NB_USER
WORKDIR /home/$NB_USER
ENV PATH=$PATH:/home/$NB_USER/miniconda3/bin/
RUN . /home/$NB_USER/miniconda3/etc/profile.d/conda.sh && \
    conda config --set safety_checks disabled && \
    conda env update -q -n notebook-env --file /home/$NB_USER/environment.yml && \
    conda clean -a -y && \
    /home/vmuser/miniconda3/envs/notebook-env/bin/jupyter labextension install @techrah/text-shortcuts && \
    rm -rf /home/$NB_USER/.cache && \
    rm -rf /tmp/* && \
    rm -rf ${TMPDIR} && \
    mkdir -p ${TMPDIR} && \
    mkdir -p /home/$NB_USER/.cache && \
    find miniconda3/ -type f -name *.pyc -exec rm -f {} \; 
EXPOSE 8888
CMD [ "notebook" ]
