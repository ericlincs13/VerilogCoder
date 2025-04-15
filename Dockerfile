FROM continuumio/miniconda3

# Set up the working directory
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install necessary build tools and pip
RUN apt-get update && \
    apt-get install -y git autoconf gperf build-essential flex bison && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install prerequisite tools
RUN git clone https://github.com/steveicarus/iverilog.git && cd iverilog \
    && sh ./autoconf.sh && ./configure --prefix=/usr/local && make -j4 && make install

# Set environment variables
ENV PATH=/opt/conda/bin:$PATH

# Create conda environment
RUN conda create -n hardware_agent python=3.10.13 && \
    echo "source activate hardware_agent" > ~/.bashrc && \
    /bin/bash -c "source ~/.bashrc && conda activate hardware_agent && \
    pip install -e . && \
    pip install -r requirements.txt"

# Set environment variables
ENV PYTHONPATH=/app
