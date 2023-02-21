FROM nvidia/cuda:11.7.0-base-ubuntu20.04
ENV DEBIAN_FRONTEND=noninteractive

# Install some basic utilities.
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    ca-certificates \
    sudo \
    git \
    bzip2 \
    openssh-server \
    vim

# install zsh
RUN sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.1.5/zsh-in-docker.sh)" -- \
    -t robbyrussell \
    -p git \
    -p https://github.com/zsh-users/zsh-autosuggestions \
    -p https://github.com/zsh-users/zsh-completions

# set zsh as default shell
RUN chsh -s /bin/zsh

# Install miniconda
ENV CONDA_DIR /opt/conda
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-py310_23.1.0-1-Linux-x86_64.sh -O ~/miniconda.sh \
    && /bin/bash ~/miniconda.sh -b -p /opt/conda
# Put conda in path so we can use conda activate
ENV PATH=$PATH:$CONDA_DIR/bin
RUN conda create -n torch -y
# activate conda env
RUN conda init zsh
RUN exec zsh
RUN conda activate torch

# Install python libs
RUN pip install tqdm simpletransformers networkx pyelftools wandb pwntools ipython \
         GPUtil sqlalchemy matplotlib einops dataset torch torchvision torchaudio
# Install DGL
RUN pip install --pre dgl -f https://data.dgl.ai/wheels/cu117/repo.html \
    && pip install --pre dglgo -f https://data.dgl.ai/wheels-test/repo.html

# Create a working directory.
RUN mkdir /workspace
WORKDIR /workspace

# init
COPY ./init.sh /root/init.sh
RUN chmod +x /root/init.sh
CMD ["/root/init.sh"]
