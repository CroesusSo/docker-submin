Docker Submin
=================

SVN GUI Manager in Docker 

### Download ###
    get source from [git](https://github.com/CroesusSo/docker-submin)
    cd docker-submin

### Config Listening Port ###
    vim docker-compose.yaml. modify
    change 8080 to your listening port

    ports:
      - 8080:80 
    environment:
      - SUBMIN_EXTERNAL_PORT=8080 

### Config Host Name ####
    Change 127.0.0.1 to your own hostname
      - SUBMIN_HOSTNAME=127.0.0.1

### Config Email Address ###
      - SUBMIN_ADMIN_MAIL=admin@svn.local

### Config email server and port for send mail ###
      - SUBMIN_SMTP_HOSTNAME=localhost
      - SUBMIN_SMTP_PORT=25

### Default volume ###
    volumes:
      - ./svn/repos:/var/lib/svn
      - ./svn/log:/var/log/apache2


