#download
version=1.22.0
echo ============download nginx code.
cd ../
curl -O http://nginx.org/download/nginx-$version.tar.gz
tar -zxf nginx-$version.tar.gz
pwd;ls
cd nginx-$version

echo ============apply patch
git apply ../ngx_healthcheck_module/nginx_healthcheck_for_nginx_1.19+.patch

#check dependency
# dpkg -l |grep libpcre3-dev
# dpkg -l|grep zlib1g-dev
# dpkg -l|grep openssl
ls auto/
echo ===========begin build nginx
./configure --prefix=../nginx \
            --with-debug \
            --with-stream \
            --with-stream_ssl_module \
            --with-http_ssl_module \
            --with-openssl=../openssl-1.1.1w \
            --with-pcre=../pcre-8.45 \
            --add-module=../ngx_healthcheck_module
make
make install

echo ===========start nginx
sudo cp -f ../ngx_healthcheck_module/nginx.conf.example ../nginx/conf/nginx.conf
# sudo ln -s /usr/local/nginx/sbin/nginx /usr/sbin/
# sudo nginx -T
# sudo nginx -t
# sudo nginx &
#test
ps -ef | grep nginx
# curl localhost
curl http://localhost:8080/status

echo finish!
