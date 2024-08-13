FROM golang:1.22-alpine as builder
WORKDIR /myapp

COPY go.mod . 
COPY go.sum .

RUN apk add --no-cache ca-certificates git

# Get dependancies - will also be cached if we won't change mod/sum
RUN go mod download

COPY . .
RUN go install .

# FROM bengreenier/docker-xvfb:stable
# ENV LANG="C.UTF-8"

FROM ubuntu:jammy-20240125
ENV LANG="C.UTF-8"
ENV DEBIAN_FRONTEND=noninteractive

# install utilities
RUN apt-get update
RUN apt-get -y install wget --fix-missing
RUN apt-get -y install xvfb xorg xvfb firefox dbus-x11 xfonts-100dpi xfonts-75dpi xfonts-cyrillic --fix-missing # chrome will use this to run headlessly
RUN apt-get -y install unzip --fix-missing

# install go
RUN wget -O - 'https://storage.googleapis.com/golang/go1.22.0.linux-amd64.tar.gz' | tar xz -C /usr/local/
ENV PATH="$PATH:/usr/local/go/bin"

# install dbus - chromedriver needs this to talk to google-chrome
RUN apt-get -y install dbus --fix-missing
RUN apt-get -y install dbus-x11 --fix-missing
# RUN ln -s /bin/dbus-daemon /usr/bin/dbus-daemon     # /etc/init.d/dbus has the wrong location
# RUN ln -s /bin/dbus-uuidgen /usr/bin/dbus-uuidgen   # /etc/init.d/dbus has the wrong location

# install sound
RUN apt-get -y install libasound2 libasound2-plugins alsa-utils alsa-oss --fix-missing
RUN apt-get -y install pulseaudio pulseaudio-utils --fix-missing
# RUN usermod -aG pulse,pulse-access root
RUN adduser root pulse-access
RUN adduser root pulse

# install chrome - ARM without snap
RUN apt install -y software-properties-common
RUN add-apt-repository ppa:xtradeb/apps -y
RUN apt install -y chromium

# install chromedriver
# NOTE: this is a relatively old version.  Try a newer version if this does not work.
RUN wget -N http://chromedriver.storage.googleapis.com/2.25/chromedriver_linux64.zip
RUN unzip chromedriver_linux64.zip
RUN chmod +x chromedriver
RUN mv -f chromedriver /usr/local/bin/chromedriver

RUN apt-get -y install libx264-dev
RUN apt-get -y install ffmpeg
# COPY ffmpeg .
# RUN chmod +x ffmpeg

ENV DISPLAY=:99
ENV XVFB_WHD=800x700x24

RUN apt-get install -y ca-certificates tzdata
COPY --from=builder /go/bin /bin
COPY /entrypoint.sh /
RUN chmod +x /entrypoint.sh
CMD ["./entrypoint.sh"]
