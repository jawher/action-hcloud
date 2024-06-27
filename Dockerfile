FROM alpine:3.17 as downloader

ARG HCLOUD_VERSION=1.44.1

RUN apk update &&       \
    apk add --no-cache curl jq

RUN curl -fSsL `curl -fSsL https://api.github.com/repos/hetznercloud/cli/releases/tags/v$HCLOUD_VERSION | jq --raw-output '.assets[] | select(.name | test(".*-linux-amd64.tar.gz")).browser_download_url'` -o /tmp/hcloud-linux-amd64.tar.gz && \
    tar xzf /tmp/hcloud-linux-amd64.tar.gz -C /tmp && \
    ls -la /tmp/ && \
    chmod +x /tmp/hcloud

FROM alpine:3.17

COPY --from=downloader /tmp/hcloud /hcloud

LABEL "name"="action-hcloud"
LABEL "version"="$HCLOUD_VERSION"
LABEL "maintainer"="Jawher Moussa"
LABEL "repository"="https://github.com/jawher/action-hcloud"
LABEL "homepage"="https://github.com/jawher/action-hcloud"

COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
CMD [ "help" ]
