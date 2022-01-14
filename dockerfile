// Tạo image
FROM centos:7
// nguoi chiu trach nhiem bao tri
MAINTAINER "AnhLuu"
// cai dat apache 
RUN yum upadte -y
RUN yum install - y sudo su -
RUN yum install -y epel-release
RUN yum install -y http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
RUN yum clean all
RUN yum -y install wget
RUN yum -y install httpd
RUN yum -y install --enablerepo=remi,remi-php71 php php-devel php-mbstring php-pdo php-gd php-xml php-mcrypt php-pgsql
#Thiet lap thu muc lam viec 
WORKDIR /var/www/html

#copy code tu thu muc code vao image
ADD ./code /var/www/html

# start httpd
CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"] 

EXPOSE 80

#Build image
docker build -t httpd_demo .

#Tạo và chạy container
docker run -d -p 80:80 httpd_demo
