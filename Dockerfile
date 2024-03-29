# Build a docker image from latest YaCy sources

# Base image : latest Debian stable official jdk 8 image from Docker
FROM arm32v7/adoptopenjdk

# Install needed packages not in base image 
# (curl for sh scripts in /bin, and wkhtmltopdf,imagemagick,xvfb and ghostscript to enable PDF and image snapshot generation)
RUN apt-get update && apt-get install -yq curl wkhtmltopdf imagemagick xvfb ghostscript && \
  rm -rf /var/lib/apt/lists/*

# trace java version
RUN java -version

# set current working dir
WORKDIR /opt

# All in one step to reduce image size growth :
# - install ant and git packages
# - clone main YaCy git repository (we need to clone git repository to generate correct version when building from source)
# - Compile with ant
# - remove unnecessary and size consuming .git directory
# - remove ant and git packages

# Possible alternative : copy directly your current sources an remove git clone command from the following RUN
# COPY . /opt/yacy_search_server/

RUN apt-get update && \
	apt-get install -yq ant git && \
	git clone https://github.com/yacy/yacy_search_server.git && \
	ant compile -f /opt/yacy_search_server/build.xml && \
	rm -rf /opt/yacy_search_server/.git && \
	apt-get purge -yq --auto-remove ant git && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

RUN \
# Set initial admin password : "docker" (encoded with custom yacy md5 function net.yacy.cora.order.Digest.encodeMD5Hex())
	sed -i "/adminAccountBase64MD5=/c\adminAccountBase64MD5=MD5:e672161ffdce91be4678605f4f4e6786" /opt/yacy_search_server/defaults/yacy.init && \
# Intially enable HTTPS : this is the most secure option for remote administrator authentication
	sed -i "/server.https=false/c\server.https=true" /opt/yacy_search_server/defaults/yacy.init && \
# Create user and group yacy : this user will be used to run YaCy main process
	adduser --system --group --no-create-home --disabled-password yacy && \
# Set ownership of yacy install directory to yacy user/group
	chown yacy:yacy -R /opt/yacy_search_server

# Expose HTTP and HTTPS default ports
EXPOSE 8090 8443

# Set data volume : yacy data and configuration will persist aven after container stop or destruction
VOLUME ["/opt/yacy_search_server/DATA"]

# Next commands run as yacy as non-root user for improved security
USER yacy

# Start yacy as a foreground process (-f) to display console logs and to wait for yacy process
CMD ["/bin/sh","/opt/yacy_search_server/startYACY.sh","-f"]
