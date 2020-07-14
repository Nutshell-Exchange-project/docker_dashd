FROM ubuntu:bionic
ENV USER_ID ${USER_ID:-1000}
ENV GROUP_ID ${GROUP_ID:-1000}
ENV DASHCORE_DATA=/home/dashcore/.dashcore

RUN groupadd -g ${GROUP_ID} dashcore \
	&& useradd -u ${USER_ID} -g dashcore -s /bin/bash -m -d /dashcore dashcore

RUN apt-get update -y

RUN apt-get upgrade -y

RUN apt-get install -y apt-utils curl cmake wget

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

RUN apt-get install -y dialog apt-utils git nano

RUN apt-get install -y --no-install-recommends \
        cron \
        gosu \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update -y

RUN apt-get install -y -q build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils default-jdk default-jre libgmp-dev python3

RUN apt-get install -y libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-program-options-dev libboost-test-dev libboost-thread-dev

RUN apt-get install software-properties-common -y

RUN add-apt-repository ppa:bitcoin/bitcoin -y

RUN apt-get update -y

RUN apt-get install libdb4.8-dev libdb4.8++-dev -y

RUN apt-get install -y libminiupnpc-dev

RUN apt-get install -y libzmq3-dev

RUN cd /tmp && wget https://github.com/dashpay/dash/releases/download/v0.15.0.0/dashcore-0.15.0.0-x86_64-linux-gnu.tar.gz && tar -zxvf dashcore-0.15.0.0-x86_64-linux-gnu.tar.gz && cd dashcore-0.15.0/bin/ && mv ./dash* /usr/local/bin

RUN rm -rf /tmp/dash*

EXPOSE 9998 9999

VOLUME ["/home/dashcore/.dashcore"]

COPY ./docker-entrypoint.sh /usr/local/bin/

RUN chmod 777 /usr/local/bin/docker-entrypoint.sh \
    && ln -s /usr/local/bin/docker-entrypoint.sh /

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["dashd"]
