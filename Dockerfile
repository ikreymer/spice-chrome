FROM oldwebtoday/chrome:60

USER root

RUN apt-get -y update

RUN apt-get install -y spice-html5 xserver-xspice xserver-xspice-lts-xenial xserver-xorg-video-qxl pulseaudio paprefs pulseaudio-module-x11

RUN git clone https://gitlab.freedesktop.org/spice/spice-html5 /app/spice-html5

COPY spiceqxl.xorg.conf /etc/X11/

USER browser

COPY entry_point.sh /app/entry_point.sh
RUN sudo chown browser /app/entry_point.sh
RUN sudo chmod a+x /app/entry_point.sh


