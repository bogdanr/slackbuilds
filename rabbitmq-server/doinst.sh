config() {
  NEW="$1"
  OLD="$(dirname $NEW)/$(basename $NEW .new)"
  # If there's no config file by that name, mv it over:
  if [ ! -r $OLD ]; then
    mv $NEW $OLD
  elif [ "$(cat $OLD | md5sum)" = "$(cat $NEW | md5sum)" ]; then
    # toss the redundant copy
    rm $NEW
  fi
  # Otherwise, we leave the .new copy for the admin to consider...
}

preserve_perms() {
  NEW="$1"
  OLD="$(dirname $NEW)/$(basename $NEW .new)"
  if [ -e $OLD ]; then
    cp -a $OLD ${NEW}.incoming
    cat $NEW > ${NEW}.incoming
    mv ${NEW}.incoming $NEW
  fi
  config $NEW
}

create_user() {
  if [ "$(grep ^rabbitmq /etc/passwd)" = "" -o "$(grep ^rabbitmq /etc/group)" = "" ] ; then
    echo "Creating the rabbitmq user and group."
    groupadd -g 264 rabbitmq
    useradd -d /var/lib/rabbitmq -s /bin/sh -u 264 -g rabbitmq rabbitmq
  fi
}

preserve_perms etc/rc.d/rc.rabbitmq.new
config etc/rabbitmq/rabbitmq-env.conf.new
config lib/systemd/system/rabbitmq.service.new
create_user
