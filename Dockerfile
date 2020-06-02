# =================== git-builder ==============
FROM alpine/git:latest AS git-builder

LABEL maintainer Claudius Teodorescu <claudius.teodorescu@gmail.com>

ARG git_credentials=claudius
ARG data_git_url=ssh://$git_credentials@188.212.37.221/home/git/solirom/tdrg-data.git
ARG ssh_pub_key
ARG ssh_prv_key

COPY ./ /angel/

RUN 	mkdir -p /root/.ssh/ && \
	chmod 0700 /root/.ssh && \
	ssh-keyscan 188.212.37.221 > /root/.ssh/known_hosts && \
	echo "$ssh_pub_key" > /root/.ssh/id_rsa.pub && \
	echo "${ssh_prv_key}" > /root/.ssh/id_rsa && \
    chmod 600 /root/.ssh/id_rsa && \
    chmod 600 /root/.ssh/id_rsa.pub && \    
	time git clone -b master --depth=1 $data_git_url /home/git/data && \
	rm -rf 'home/git/data/.git'

# =================== saxon-builder ==============
FROM klakegg/saxon:he AS saxon-builder

COPY --from=git-builder /home/git/data /git/data
COPY --from=git-builder /angel /angel

RUN cd /git/data && \
	for dir in $(ls -d */); \
	do \
		mkdir -p /angel/static/data/"$dir" && \
		time xslt -s:/git/data/"$dir" -xsl:/angel/static/modules/tei-to-html/tei-to-html.xsl -o:/angel/static/data/"$dir"; \
	done

# =================== alpine-builder ==============
FROM alpine:latest AS alpine-builder

RUN	addgroup -S angel && \
	adduser -S angel -G angel

COPY --from=saxon-builder --chown=angel:angel /angel /angel

# =================== scratch-builder ==============
FROM scratch

COPY --from=alpine-builder /etc/passwd /etc/passwd
COPY --from=alpine-builder /etc/group /etc/group
COPY --from=alpine-builder  /angel /angel

USER angel:angel

EXPOSE 7777

WORKDIR /angel

ENTRYPOINT ["/angel/tdrg-site"]

# go build -tags netgo -a -v
#
# time sudo docker build --build-arg ssh_prv_key="$(cat ~/.ssh/id_rsa)" --build-arg ssh_pub_key="$(cat ~/.ssh/id_rsa.pub)" -t tdrg .
#
# sudo docker run --publish 7001:7777 -a stderr tdrg:latest
#
# docker save tdrg:latest | gzip > /home/claudius/workspace/repositories/go/bin/tdrg-latest.tar.gz
#
# rsync -P -rsh=ssh /home/claudius/workspace/repositories/go/bin/tdrg-latest.tar.gz claudius@85.186.121.41:/home/claudius/
#
# === remote
#
# sudo docker load -i tdrg-latest.tar.gz
#
# sudo docker run --restart always --name tdrg -d -p 7001:7777 tdrg:latest
#
#
#
# /usr/sbin/setsebool -P httpd_can_network_connect 1
# sudo docker system prune