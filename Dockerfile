# docker build -t geoff-nginx-php .
# docker run --name hipbot -d -p 80 geoff-nginx-php 
# map volume host src directory to docker /usr/share/nginx/html when running, i.e. -v src:/usr/share/nginx/html

FROM nginx:1.7.7

RUN apt-get update
RUN apt-get install -y php5-cli php5-fpm php5-mysql php5-pgsql php5-sqlite php5-curl\
		       php5-gd php5-mcrypt php5-intl php5-imap php5-tidy

RUN sed -i "s/;date.timezone =.*/date.timezone = UTC/" /etc/php5/fpm/php.ini
RUN sed -i "s/;date.timezone =.*/date.timezone = UTC/" /etc/php5/cli/php.ini

RUN sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php5/fpm/php-fpm.conf
RUN sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php5/fpm/php.ini

# unecessary since we wil ADD the conf file below
#RUN sed -i "s/listen.owner = www-data/listen.owner = nginx/" /etc/php5/fpm/pool.d/www.conf
#RUN sed -i "s/listen.group = www-data/listen.group = nginx/" /etc/php5/fpm/pool.d/www.conf

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir /etc/nginx/ssl

#ADD conf/nginx.key /etc/nginx/ssl/nginx.key
#ADD conf/nginx.crt /etc/nginx/ssl/nginx.crt
ADD conf/default.conf /etc/nginx/conf.d/default.conf
ADD conf/www.conf /etc/php5/fpm/pool.d/www.conf
ADD conf/startUp.sh /bin/startUp.sh
RUN chmod a+x /bin/startUp.sh

ADD src /usr/share/nginx/html

CMD ["/bin/startUp.sh"]
