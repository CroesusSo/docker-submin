#!/bin/bash

set -x

# use command submin
hostname="${SUBMIN_HOSTNAME:-submin.local}"
external_port="${SUBMIN_EXTERNAL_PORT:-80}"
data_dir="${SUBMIN_DATA_DIR:-/var/lib/submin}"
svn_repo="${SUBMIN_SVN_DIR:-/var/lib/svn}"
admin_mail="${SUBMIN_ADMIN_MAIL:-root@submin.local}"

# create config if it's brand new.
if [ ! -d ${data_dir}/conf ]; then
    echo -e "svn\n${svn_repo}\n${hostname}:${external_port}\n\n\n" \
        | submin2-admin ${data_dir} initenv ${admin_mail} >/dev/null

    if [ "$SUBMIN_SMTP_HOSTNAME" ]; then
        submin2-admin /var/lib/submin config set smtp_hostname $SUBMIN_SMTP_HOSTNAME
    fi

    if [ "$SUBMIN_SMTP_PORT" ]; then
        submin2-admin /var/lib/submin config set smtp_port "$SUBMIN_SMTP_PORT"
    fi

    if [ "$SUBMIN_SMTP_USER" ]; then
        submin2-admin /var/lib/submin config set smtp_username $SUBMIN_SMTP_USER
    fi

    if [ "$SUBMIN_SMTP_PASS" ]; then
        submin2-admin /var/lib/submin config set smtp_password "$SUBMIN_SMTP_PASS"
    fi


    submin2-admin ${data_dir} apacheconf create all >/dev/null 2>&1 || true

    ln -s ${data_dir}/conf/apache-2.4-webui-cgi.conf /etc/apache2/conf-available/
    ln -s ${data_dir}/conf/apache-2.4-svn.conf /etc/apache2/conf-available/

    {
        a2enconf apache-2.4-webui-cgi
        a2enconf apache-2.4-svn
        a2enmod authn_dbd
        a2enmod rewrite
        a2enmod cgid
    } >/dev/null 2>&1

    # disable git
    submin2-admin ${data_dir} config set vcs_plugins svn || true

    touch ${data_dir}/inited
    key=`echo "SELECT key FROM password_reset;" | sqlite3 ${data_dir}/conf/submin.db`
    echo "access http://${hostname}:${external_port}/submin/password/admin/${key} to reset password"
fi

if [ -e ${data_dir}/inited ]; then
    echo "Submin is already configured in ${data_dir}/conf"
else 
    submin2-admin /var/lib/submin config set http_vhost ${hostname}:${external_port}

    if [ "$SUBMIN_SMTP_HOSTNAME" ]; then
        submin2-admin /var/lib/submin config set smtp_hostname $SUBMIN_SMTP_HOSTNAME
    fi

    if [ "$SUBMIN_SMTP_PORT" ]; then
        submin2-admin /var/lib/submin config set smtp_port "$SUBMIN_SMTP_PORT"
    fi

    if [ "$SUBMIN_SMTP_USER" ]; then
        submin2-admin /var/lib/submin config set smtp_username $SUBMIN_SMTP_USER
    fi

    if [ "$SUBMIN_SMTP_PASS" ]; then
        submin2-admin /var/lib/submin config set smtp_password "$SUBMIN_SMTP_PASS"
    fi

    ln -s ${data_dir}/conf/apache-2.4-webui-cgi.conf /etc/apache2/conf-available/
    ln -s ${data_dir}/conf/apache-2.4-svn.conf /etc/apache2/conf-available/

    {
        a2enconf apache-2.4-webui-cgi
        a2enconf apache-2.4-svn
        a2enmod authn_dbd
        a2enmod rewrite
        a2enmod cgid
    } >/dev/null 2>&1
    touch ${data_dir}/inited

    echo "access http://${hostname}:${external_port}/submin for submin"
fi

service apache2 restart

tail -f /var/log/apache2/access.log /var/log/apache2/error.log
