FROM python:3.9.6-slim

# Create user
ARG USERNAME="jupyter"
ARG USER_UID=1000
ARG USER_GID=$USER_UID

ADD ./src/requirements.txt \
    ./src/dev_requirements.txt \
    /src/

# User local alpine repositories
RUN sed -i "s/deb.debian.org/mirror.ps.kz/g" \
    /etc/apt/sources.list \
    && apt update \
    && apt install -y apt-utils \
# Upgrade pip
    && pip install --upgrade pip setuptools wheel \
# Add project dependencies
    && pip install \
    --no-cache-dir -Ur /src/requirements.txt \
    --no-cache-dir -Ur /src/dev_requirements.txt \
# Remove build dependencies
    && apt clean

# Create non-root user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME

USER $USERNAME

COPY ./src /src
WORKDIR /src
CMD jupyter lab --ip 0.0.0.0 --NotebookApp.token='' --NotebookApp.password=''

