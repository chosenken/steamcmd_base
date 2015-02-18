FROM phusion/baseimage
MAINTAINER chosenken@gmail.com

USER root

RUN apt-get update && apt-get upgrade -y
RUN apt-get -y install lib32gcc1 lib32z1 lib32ncurses5 lib32bz2-1.0 lib32stdc++6 gdb wget curl build-essential libxml2-dev libxslt-dev screen

RUN groupadd -r appuser && useradd -r -m -g appuser appuser
RUN echo "appuser ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers

ENV PATH /opt/scripts/:$PATH

ENV DATA_FOLDER /opt/data/
RUN mkdir -p $DATA_FOLDER

RUN chown -R appuser:appuser /opt/data/
RUN chmod g+w /opt
RUN chown appuser:appuser -R /opt

USER appuser
ENV USERNAME appuser
ENV HOME /home/$USERNAME

# set up env
RUN mkdir -p /opt/steam
RUN mkdir -p /opt/server
RUN mkdir -p /opt/data

ENV STEAMDIR /opt/steam
ENV SERVERDIR /opt/server
RUN mkdir -p $STEAMDIR

ENV PATH /opt/server/scripts/:$PATH

# download steamcmd
RUN wget -O - http://media.steampowered.com/client/steamcmd_linux.tar.gz | tar -C $STEAMDIR -xvz

# install steamcmd
RUN $STEAMDIR/steamcmd.sh +quit
RUN mkdir -p $HOME/.steam/sdk32
RUN ln -s $STEAMDIR/linux32/steamclient.so /$HOME/.steam/sdk32/steamclient.so

ENV PATH $STEAMDIR/:$PATH
