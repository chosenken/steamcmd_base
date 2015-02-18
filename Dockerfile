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

# Change owner of opt folder to appuser
RUN chmod g+w /opt
RUN chown appuser:appuser -R /opt

# Run as appuser
USER appuser
ENV USERNAME appuser
ENV HOME /home/$USERNAME


# Sent environmental variables
ENV STEAMDIR 	/opt/steam
ENV SCRIPTSDIR 	/opt/scripts
ENV DATADIR 	/opt/data/
RUN mkdir -p $STEAMDIR
RUN mkdir -p $SCRIPTSDIR
RUN mkdir -p $DATADIR

# Add the server scripts to path
ENV PATH $SCRIPTSDIR:$PATH

# download steamcmd
RUN wget -O - http://media.steampowered.com/client/steamcmd_linux.tar.gz | tar -C $STEAMDIR -xvz

# install steamcmd
RUN $STEAMDIR/steamcmd.sh +quit
RUN mkdir -p $HOME/.steam/sdk32
RUN ln -s $STEAMDIR/linux32/steamclient.so /$HOME/.steam/sdk32/steamclient.so

# Add the steamcmd.sh to path
ENV PATH $STEAMDIR/:$PATH
