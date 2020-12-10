ARG BASE_IMAGE=
FROM ${BASE_IMAGE}
MAINTAINER Thingpedia Admins <thingpedia-admins@lists.stanford.edu>

USER root
RUN apt update && apt install -y file wget sudo python3 python3-pip curl

RUN curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -

RUN apt install -y nodejs

RUN curl -L "https://storage.googleapis.com/kubernetes-release/release/v1.17.13/bin/linux/amd64/kubectl" -o /usr/local/bin/kubectl && \
   chmod +x /usr/local/bin/kubectl

RUN python3 -m pip install -U pip

RUN pip3 install --use-feature=2020-resolver \
   jupyter jupyterlab jupyterlab-git matplotlib \
   kfp kubeflow-metadata awscli
RUN npm install -g tslab

# add user jovyan (jupyter notebook hardcoded user)
RUN useradd -ms /bin/bash -u 1001 jovyan && id jovyan

RUN adduser jovyan sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

RUN pip3 install torch==1.7.0+cu110 torchvision==0.8.1+cu110 torchaudio===0.7.0 -f https://download.pytorch.org/whl/torch_stable.html
RUN apt upgrade -y
# RUN echo 'y \n y \n' | unminimize
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=America/Pacific
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt install -y git zsh openssh-server

ENV TINI_VERSION v0.19.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/bin/tini
RUN chmod +x /usr/bin/tini
ENTRYPOINT ["/usr/bin/tini", "--"]

RUN pip3 install fvcore numpy simplejson av pyyaml tqdm psutil opencv-python tensorboard moviepy pandas pytorch_lightning pycocotools scipy
RUN git clone https://github.com/stanford-oval/epic-kitchen-lstm.git

RUN apt install -y nano rsync screen
RUN echo "GatewayPorts yes\n" >> /etc/ssh/sshd_config

ENV NB_USER=jovyan
ENV NB_UID=1001
ENV HOME=/home/jovyan
ENV NB_PREFIX /
ENV PATH=$HOME/.local/bin:$HOME/.yarn/bin:$PATH
ENV MINIO_ENDPOINT=minio-service.kubeflow:9000
ENV TZ=America/Pacific
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN python3 -m ipykernel.kernelspec
RUN tslab install --python=python3
RUN jupyter lab build

COPY download-dataset.sh download-pretrained.sh lib.sh sync-repo.sh ./

USER root
CMD ["bash"]

# USER jovyan
# RUN sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.1.1/zsh-in-docker.sh)" -t robbyrussell
# CMD ["bash", "-l", "-c", "jupyter lab --notebook-dir=/home/jovyan --ip=0.0.0.0 --no-browser --allow-root --port=8888 --NotebookApp.token='' --NotebookApp.password='' --NotebookApp.allow_origin='*' --NotebookApp.base_url=${NB_PREFIX}"]
