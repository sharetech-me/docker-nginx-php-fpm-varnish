FROM ubuntu:20.04


ENV VARNISH_BACKEND_PORT 8080
ENV VARNISH_BACKEND_IP 127.0.0.1
ENV VARNISH_PORT 80

# Surpress Upstart errors/warning
# Let the conatiner know that there is no tty
ENV DEBIAN_FRONTEND noninteractive

# Update base image
# Add sources for latest nginx
# Install software requirements
RUN apt-get update -y
RUN apt-get install nginx -y
RUN apt-get install varnish -y
RUN apt-get install supervisor -y
# nginx site conf


#RUN rm -f /etc/nginx/sites-available/default
#RUN rm -f /etc/nginx/sites-enabled/default
#ADD ./nginx-site.conf /etc/nginx/sites-available/default
#RUN ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default
RUN sed -i 's/listen 80 default_server/listen 8080 default_server/g' /etc/nginx/sites-available/default
RUN sed -i '/::/d' /etc/nginx/sites-available/default
RUN mkdir -p /etc/varnish/sites
ADD default.vcl /etc/varnish/default.vcl

# Supervisor Config
ADD ./supervisord.conf /etc/supervisord.conf
RUN apt-get install vim net-tools -y
# Start Supervisord
ADD ./start.sh /start.sh
RUN chmod 755 /start.sh


# add test PHP file
ADD ./index.php /usr/share/nginx/html/index.php



# Expose Ports
EXPOSE 443
EXPOSE 80

CMD ["/bin/bash", "/start.sh"]
