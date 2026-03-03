FROM judge0/compilers:1.4.0 AS production

ENV JUDGE0_HOMEPAGE "https://github.com/nonme/judge0-extended"
LABEL homepage=$JUDGE0_HOMEPAGE

ENV JUDGE0_SOURCE_CODE "https://github.com/nonme/judge0-extended"
LABEL source_code=$JUDGE0_SOURCE_CODE

ENV JUDGE0_MAINTAINER "nonme"
LABEL maintainer=$JUDGE0_MAINTAINER

# Install additional Go versions
RUN cd /usr/local && \
    curl -fsSL https://go.dev/dl/go1.18.5.linux-amd64.tar.gz | tar xz && \
    mv go go-1.18.5 && \
    curl -fsSL https://go.dev/dl/go1.22.10.linux-amd64.tar.gz | tar xz && \
    mv go go-1.22.10 && \
    curl -fsSL https://go.dev/dl/go1.23.5.linux-amd64.tar.gz | tar xz && \
    mv go go-1.23.5

ENV PATH "/usr/local/ruby-2.7.0/bin:/opt/.gem/bin:$PATH"
ENV GEM_HOME "/opt/.gem/"

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      cron \
      libpq-dev \
      sudo && \
    rm -rf /var/lib/apt/lists/* && \
    echo "gem: --no-document" > /root/.gemrc && \
    gem install bundler:2.1.4 && \
    npm install -g --unsafe-perm aglio@2.3.0

EXPOSE 2358

WORKDIR /api

COPY Gemfile* ./
RUN RAILS_ENV=production bundle

COPY cron /etc/cron.d
RUN cat /etc/cron.d/* | crontab -

COPY . .

ENTRYPOINT ["/api/docker-entrypoint.sh"]
CMD ["/api/scripts/server"]

RUN useradd -u 1000 -m -r judge0 && \
    echo "judge0 ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers && \
    chown judge0: /api/tmp/

USER judge0

ENV JUDGE0_VERSION "1.13.1-extended"
LABEL version=$JUDGE0_VERSION


FROM production AS development

CMD ["sleep", "infinity"]
