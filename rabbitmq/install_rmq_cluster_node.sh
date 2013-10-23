#!/bin/bash
#
# This script installs independent RabbitMQ Sever locally on a single server 
# as the first step to install a RabbitMQ cluster. Intended to be run within 
# an hpcloud Nova instance as root, with the following files and folders 
# deployed by Salt over to the target directories
#   - rabbitmq.config
#   - ssl containing three SSL key files

die () {
    echo >&2 "$@"
    exit 1
}

[ "$#" -eq 0 ] || die "Usage: $0"

turn_off_byobu() {
  su ubuntu -c byobu-disable
}

prepare() {
  echo
  echo "===== Proprocess for easy install"
  apt-get update
  apt-get -y install ntp
  turn_off_byobu

  # clean up the rabbitmq leftover if previously installed
  ps aux | grep erlang | cut -d' ' -f 2 > erlang_proc.txt
  # read erlang proc ID's from file into an array
  IFS=$'\r\n' ERLANG_PROC=($(cat erlang_proc.txt))
  rm ./erlang_proc.txt
  for i in ${ERLANG_PROC[@]}; do
    echo "killing Erlang process $i"
    kill -9 $i
  done
  # remove old RMQ DB
  if [ -d /mnt/rabbitmq ]; then rm -r /mnt/rabbitmq; fi
}

install_rabbit() {
  echo
  echo "===== Download and install base RabbitMQ server"
  # set path to RMQ apt repo and add RMQ apt key for download
  echo 'deb http://www.rabbitmq.com/debian/ testing main' >> /etc/apt/sources.list
  wget http://www.rabbitmq.com/rabbitmq-signing-key-public.asc
  apt-key add rabbitmq-signing-key-public.asc
  apt-get update
  # install the latest official RMQ package
  apt-get install rabbitmq-server -y
}

apply_config() {
  echo
  echo "===== Apply custom configuration for RabbitMQ cluster"
  # setup rabbitmq.config
  cp rabbitmq.config /etc/rabbitmq

  # setup SSL
  cp -r ssl /etc/rabbitmq

  # enable the management api on the rabbit server
  rabbitmq-plugins enable rabbitmq_management

  # redirect RMQ server to use the new Mnesia and log paths
  echo "RABBITMQ_MNESIA_BASE=/mnt/rabbitmq/mnesia" > /etc/rabbitmq/rabbitmq-env.conf
  echo "RABBITMQ_LOG_BASE=/mnt/rabbitmq/log" >> /etc/rabbitmq/rabbitmq-env.conf

  # raise file descriptor limit (rabbitmq picks this up)
echo "ulimit -n 8192" > /etc/default/rabbitmq-server

  # move RMQ Mnesia partition and logging to /mnt for sufficient disk space
  mkdir /mnt/rabbitmq
  mkdir /mnt/rabbitmq/log
  mkdir /mnt/rabbitmq/mnesia
  chown -R rabbitmq:rabbitmq /mnt/rabbitmq

  # restart RMQ service to make above configurations take effect
  /etc/init.d/rabbitmq-server restart

  # replace default user and password
  rabbitmqctl add_user {{pillar['rabbit_admin_user']}} {{pillar['rabbit_admin_password']}}
  rabbitmqctl set_permissions -p / {{pillar['rabbit_admin_user']}} ".*" ".*" ".*"
  rabbitmqctl set_user_tags {{pillar['rabbit_admin_user']}} administrator
  rabbitmqctl delete_user guest

  # enable queue mirroring for all queues
  rabbitmqctl set_policy ha-all '.*' '{"ha-mode":"all", "ha-sync-mode":"automatic"}'
}

# test rabbitmq service status and ports
validate_rmq() {
  echo
  echo "===== Validate RabbitMQ node status"
  rabbitmqctl status
  netstat -an | grep 5672
}

# clean up
clean_up() {
  cd
  rm rabbitmq*
  rm install_rmq_cluster_node.sh
  rm -r ssl*
}


prepare
install_rabbit
apply_config
validate_rmq
clean_up

echo "RabbitMQ node deployment complete"
