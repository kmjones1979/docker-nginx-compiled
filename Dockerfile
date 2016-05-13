FROM centos:centos7

MAINTAINER "Kevin Jones - kevin@nginx.com"

ENV nginxVersion "1.9.15"
ENV tmp "/tmp/nginx/src"

# create nginx group and user
RUN groupadd -r nginx && useradd -r -g nginx nginx

# install dependencies
RUN yum install -y wget gcc gcc-c++ make zlib-devel pcre-devel openssl-devel

# download nginx source code
RUN mkdir -p $tmp
RUN wget http://nginx.org/download/nginx-$nginxVersion.tar.gz -P $tmp
RUN tar -zxvf $tmp/nginx-$nginxVersion.tar.gz -C $tmp

# build nginx from source
RUN cd $tmp/nginx-$nginxVersion && ./configure \
    --prefix=/etc/nginx/ \
    --sbin-path=/usr/sbin/nginx \
    --conf-path=/etc/nginx/nginx.conf \
    --error-log-path=/var/log/nginx/error.log \
    --http-log-path=/var/log/nginx/access.log \
    --pid-path=/var/run/nginx.pid \
    --lock-path=/var/run/nginx.lock \
    --user=nginx \
    --group=nginx \
    --with-http_v2_module \
    --with-http_ssl_module \
    --with-http_realip_module \
    --with-http_addition_module \
    --with-http_sub_module \
    --with-http_dav_module \
    --with-http_flv_module \
    --with-http_mp4_module \
    --with-http_gunzip_module \
    --with-http_gzip_static_module \
    --with-http_random_index_module \
    --with-http_secure_link_module \
    --with-http_stub_status_module \
    --with-http_auth_request_module \
    --with-mail \
    --with-mail_ssl_module \
    --with-file-aio \
    --with-ipv6
RUN cd $tmp/nginx-$nginxVersion && make && make install

# clean up
RUN rm -rf $tmp

# forward request logs to Docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

EXPOSE 80 443

CMD ["nginx" , "-g", "daemon off;"]
