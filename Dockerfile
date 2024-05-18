
# Dockerfile

FROM ubuntu:20.04

# Install dependencies
RUN apt-get update && \
    apt-get install -y wget gnupg2 software-properties-common && \
    apt-get install -y build-essential libtool autotools-dev automake pkg-config bsdmainutils python3 libevent-dev libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-test-dev libboost-thread-dev libssl-dev libzmq3-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Add Bitcoin repository
RUN add-apt-repository ppa:bitcoin/bitcoin && \
    apt-get update && \
    apt-get install -y bitcoind

# Install Dogecoin from source
RUN git clone https://github.com/dogecoin/dogecoin.git && \
    cd dogecoin && \
    git checkout 1.14.5 && \
    ./autogen.sh && \
    ./configure --without-gui && \
    make && \
    make install

# Create data directory
RUN mkdir /dogecoin

# Expose ports
EXPOSE 22556 22555

# Start Dogecoin node
CMD ["dogecoind", "-datadir=/dogecoin"]
