FROM quay.io/cdis/golang:1.8.3-alpine as builder

ENV HUGO_VERSION 0.41
ENV HUGO_BINARY hugo_${HUGO_VERSION}_linux-64bit
ENV PATH=/usr/local/hugo:${PATH}

RUN set -x \
    && apk upgrade --update \
    && apk add --update ca-certificates bash curl wget \
    && rm -rf /var/cache/apk/* \
    && mkdir /usr/local/hugo \
    && wget https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/${HUGO_BINARY}.tar.gz -O /usr/local/hugo/${HUGO_BINARY}.tar.gz \
    && tar xzf /usr/local/hugo/${HUGO_BINARY}.tar.gz -C /usr/local/hugo/ \
  && rm /usr/local/hugo/${HUGO_BINARY}.tar.gz \
    && rm -rf /tmp/* /var/cache/apk/*

COPY . /dataguids.org
WORKDIR /dataguids.org
RUN hugo

FROM quay.io/cdis/nginx:stable

COPY --from=builder /dataguids.org/public /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d
COPY dockerStart.sh ./dockerStart.sh
