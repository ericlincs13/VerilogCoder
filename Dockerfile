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
    pip install -r requirements.txt"

# Set environment variables
ENV PYTHONPATH=/app

CMD ["/bin/bash", "-c",\
    "python                 hardware_agent/examples/VerilogCoder/run_verilog_coder.py \
    --generate_plan_dir     artifacts/plans/ \
    --generate_verilog_dir  artifacts/generate_verilog/ \
    --verilog_tmp_dir       artifacts/verilog_tmp_dir/ \
    --verilog_example_dir   hardware_agent/examples/VerilogCoder/verilog-eval-v2/dataset_dumpall/ \
    > artifacts/logs/output.log 2>&1"]