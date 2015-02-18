FROM phusion/baseimage
MAINTAINER chosenken@gmail.com

# Run as root
USER root

# Update the image
RUN apt-get update && apt-get upgrade -y
RUN apt-get -y install lib32gcc1 lib32z1 lib32ncurses5 lib32bz2-1.0 lib32stdc++6 gdb wget curl build-essential libxml2-dev libxslt-dev screen

# Create the user 'appuser' that steamcmd will run under
RUN groupadd -r appuser && useradd -r -m -g appuser appuser
RUN echo "appuser ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers

# Add the scripts to the path
ENV PATH /opt/scripts/:$PATH

# Create the data folder
ENV DATA_FOLDER /opt/data/
RUN mkdir -p $DATA_FOLDER

# Change owner of data folder to appuser
RUN chown -R appuser:appuser /opt/data/
RUN chmod g+w /opt
RUN chown appuser:appuser -R /opt

# Run as appuser
USER appuser
ENV USERNAME appuser
ENV HOME /home/$USERNAME

# set up env
RUN mkdir -p /opt/steam
RUN mkdir -p /opt/server
RUN mkdir -p /opt/data

# Sent environmental variables
ENV STEAMDIR /opt/steam
ENV SERVERDIR /opt/server
RUN mkdir -p $STEAMDIR

# Add the server scripts to path
ENV PATH /opt/server/scripts/:$PATH

# download steamcmd
RUN wget -O - http://media.steampowered.com/client/steamcmd_linux.tar.gz | tar -C $STEAMDIR -xvz

# install steamcmd
RUN $STEAMDIR/steamcmd.sh +quit
RUN mkdir -p $HOME/.steam/sdk32
RUN ln -s $STEAMDIR/linux32/steamclient.so /$HOME/.steam/sdk32/steamclient.so

# Add the steamcmd.sh to path
ENV PATH $STEAMDIR/:$PATH
