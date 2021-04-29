FROM gcr.io/google.com/cloudsdktool/cloud-sdk:slim

RUN apt-get update && \
	apt-get -y install unzip kubectl \
	&& \
	git clone https://github.com/tfutils/tfenv.git ~/.tfenv && \
	ln -s /root/.tfenv/bin/* /usr/local/bin \
	&& \
	tfenv install 0.12.31 && tfenv install 0.14.11

ENV TFENV_AUTO_INSTALL=false
ENTRYPOINT ["/bin/bash"]