FROM tensorflow/tensorflow:1.12.3-gpu-py3

RUN rm /etc/apt/sources.list.d/nvidia-ml.list
RUN apt-key del 7fa2af80
RUN apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/3bf863cc.pub
RUN apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1604/x86_64/7fa2af80.pub

RUN apt-get -q update && apt-get -y --no-install-recommends install make build-essential \
	libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget llvm libncurses5-dev \
	libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev bison byacc git \
	libgdbm-dev libnss3-dev libedit-dev libc6-dev python-pydot python-pydot-ng graphviz

# Install Python 3.6 
RUN mkdir -p /tmp/
WORKDIR /tmp
RUN wget https://www.python.org/ftp/python/3.6.15/Python-3.6.15.tgz
RUN tar -xzf Python-3.6.15.tgz
WORKDIR /tmp/Python-3.6.15
RUN ./configure --enable-optimizations --with-ssl
RUN make -j 20 # adjust for number of your CPU cores
RUN make install
RUN ln -s /usr/local/bin/python3.6 /usr/local/bin/python
RUN rm /usr/local/bin/pip && rm /usr/local/bin/pip3
RUN ln -s /usr/local/bin/pip3.6 /usr/local/bin/pip && ln -s /usr/local/bin/pip3.6 /usr/local/bin/pip3
RUN pip3 install --upgrade pip

# Install dependencies
RUN pip3 install --no-cache-dir setuptools==59.6.0 cython snakemake==6.12.3 h5py==2.10.0 pysam==0.16.0.1 scikit-learn \
scipy==1.5.3 numpy==1.18.5 statsmodels==0.11.1 pybigwig==0.3.18 fastqsplitter==1.2.0 keras==2.2.4 keras-preprocessing==1.1.0 \
tensorflow==1.12.3 tensorflow-gpu==1.12.3 six==1.15.0 tqdm matplotlib seaborn nanofilt==2.8.0
 
# Install htslib
WORKDIR /tmp
RUN wget https://github.com/samtools/htslib/releases/download/1.12/htslib-1.12.tar.bz2
RUN tar -jxvf htslib-1.12.tar.bz2
WORKDIR /tmp/htslib-1.12
RUN ./configure --prefix=/opt/htslib
RUN make -j 20 # adjust for number of your CPU cores
RUN make install

# Install samtools
WORKDIR /tmp
RUN wget https://github.com/samtools/samtools/releases/download/1.12/samtools-1.12.tar.bz2
RUN tar -jxvf samtools-1.12.tar.bz2
WORKDIR /tmp/samtools-1.12
RUN ./configure --prefix=/opt/samtools
RUN make -j 20 # adjust for number of your CPU cores
RUN make install

# Install minimap2
WORKDIR /opt
RUN wget https://github.com/lh3/minimap2/releases/download/v2.20/minimap2-2.20.tar.bz2
RUN tar -jxvf minimap2-2.20.tar.bz2
WORKDIR /opt/minimap2-2.20
RUN make -j 20 # adjust for number of your CPU cores

# Install nanopolish 
WORKDIR /opt
RUN git clone --recursive https://github.com/jts/nanopolish.git
WORKDIR /opt/nanopolish
RUN rm -rf slow5lib
RUN git clone https://github.com/hasindu2008/slow5lib
WORKDIR /opt/nanopolish/slow5lib
RUN make
WORKDIR /opt/nanopolish
RUN make all

# Install bedtools 
WORKDIR /opt
RUN wget https://github.com/arq5x/bedtools2/releases/download/v2.30.0/bedtools-2.30.0.tar.gz
RUN tar -zxvf bedtools-2.30.0.tar.gz
RUN rm bedtools-2.30.0.tar.gz
WORKDIR /opt/bedtools2
RUN make -j 20 # adjust for number of your CPU cores

# Install seqtk 
WORKDIR /opt
RUN git clone https://github.com/lh3/seqtk.git
WORKDIR /opt/seqtk
RUN make

# Install bioawk 
WORKDIR /opt
RUN git clone https://github.com/lh3/bioawk.git
WORKDIR /opt/bioawk
RUN make

# Install perl 
WORKDIR /opt
RUN wget https://www.cpan.org/src/5.0/perl-5.32.1.tar.gz
RUN tar -xzf perl-5.32.1.tar.gz
RUN rm perl-5.32.1.tar.gz
WORKDIR /opt/perl-5.32.1
RUN ./Configure -des -Dprefix=$HOME/localperl
RUN make -j 20
RUN make install
RUN rm -rf /usr/bin/perl
RUN ln -s /opt/perl-5.32.1/perl /usr/bin/perl

# Install gawk 
WORKDIR /opt
RUN wget https://ftp.gnu.org/gnu/gawk/gawk-5.1.0.tar.xz
RUN tar -Jxf gawk-5.1.0.tar.xz
RUN rm gawk-5.1.0.tar.xz
WORKDIR /opt/gawk-5.1.0
RUN ./configure
RUN make -j 20
RUN make install

RUN rm -rf /tmp

ENV PATH=/usr/local/nvidia/bin:/usr/local/cuda/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/htslib/bin/:/opt/samtools/bin/:/opt/minimap2-2.20/:/opt/nanopolish/:/opt/bedtools2/bin/:/opt/seqtk/:/opt/bioawk/:$PATH

WORKDIR /opt
RUN mkdir redd
WORKDIR /opt/redd
COPY . .

CMD [ "bash"]

