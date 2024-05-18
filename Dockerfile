# Dockerfile

FROM ubuntu:20.04

# Install dependencies
RUN apt-get update && \
    apt-get install -y wget gnupg2 software-properties-common && \
    apt-get install -y build-essential libtool autotools-dev automake pkg-config bsdmainutils python3 libevent-dev libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-test-dev libboost-thread-dev libssl-dev libzmq3-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Dogecoin binaries
RUN wget https://github.com/dogecoin/dogecoin/releases/download/v1.14.6/dogecoin-1.14.6-x86_64-linux-gnu.tar.gz && \
    tar -xzvf dogecoin-1.14.6-x86_64-linux-gnu.tar.gz && \
    cp dogecoin-1.14.6/bin/* /usr/local/bin/ && \
    rm -rf dogecoin-1.14.6-x86_64-linux-gnu.tar.gz dogecoin-1.14.6

# Create data directory
RUN mkdir /dogecoin

# Expose ports
EXPOSE 22556 22555

# Start Dogecoin node
CMD ["dogecoind", "-datadir=/dogecoin"]
