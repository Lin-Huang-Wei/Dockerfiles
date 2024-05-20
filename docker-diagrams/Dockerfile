From python:3.9.19-slim-bookworm

# Update: 2024-05-16
LABEL maintainer="Daniel Lin"

COPY requirements.txt ./

RUN apt-get update -y  \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    graphviz

RUN pip install --no-cache-dir -r requirements.txt

##############################
# Clean apt-get cache
##############################

RUN apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/*

##############################
# Create work directory
##############################

ENV TERM=xterm-256color

RUN mkdir -p /diagrams/scripts/

WORKDIR /diagrams/scripts/

ENTRYPOINT ["python"]
CMD ["-c", "print('Pass python script file path to container to create diagrams. See https://hub.docker.com/r/daniel/diagrams')"]
