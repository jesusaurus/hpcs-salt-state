net.ipv4.tcp_keepalive_time:
  sysctl.present:
    - value: 300

net.ipv4.tcp_keepalive_intvl:
  sysctl.present:
    - value: 5

net.ipv4.tcp_keepalive_probes:
  sysctl.present:
    - value: 6

networking:
  service:
    - running
    - watch:
       - sysctl: net.ipv4.tcp_keepalive_time
       - sysctl: net.ipv4.tcp_keepalive_intvl
       - sysctl: net.ipv4.tcp_keepalive_probes

/root/rabbitmq.config:
  file.managed:
    - source: salt://{{pillar['salt_state_root']}}rabbitmq/cluster/rabbitmq.config
    - template: jinja

/root/ssl:
  file.recurse:
    - source: salt://{{pillar['salt_state_root']}}rabbitmq/ssl
    - clean: True
    - template: jinja

/root/install_rmq_cluster_node.sh:
  file.managed:
    - source: salt://{{pillar['salt_state_root']}}rabbitmq/cluster/install_rmq_cluster_node.sh
    - template: jinja
    - mode: 755

install_rmq_node:
  cmd.run:
    - name: './install_rmq_cluster_node.sh'
    - cwd: /root
    - user: root
    - require:
      - file: /root/install_rmq_cluster_node.sh
      - file: /root/ssl
      - file: /root/rabbitmq.config
      - service: networking

{% for server_hostname, server_ip in pillar['rabbit_host_ip_list'].iteritems() %}
{% if server_hostname != grains['host'] %}
host_add_{{ server_hostname }}:
  host.present:
    - names:
      - {{ server_hostname }}.localdomain
      - {{ server_hostname }}
    - ip: {{ server_ip }}
    - require:
      - cmd: install_rmq_node
    - require_in:
      - cmd: stop_rabbitmq_service

{% else %}
host_remove_{{ server_hostname }}:
  host.absent:
    - names:
      - {{ server_hostname }}.localdomain
      - {{ server_hostname }}
    - ip: {{ server_ip }}
    - require:
      - cmd: install_rmq_node
    - require_in:
      - cmd: stop_rabbitmq_service

{% endif %}
{% endfor %}

sleep_before_stop:
  cmd.run:
    - name: sleep 10
    - user: root
    - require:
      - cmd: install_rmq_node

stop_rabbitmq_service:
  cmd.run:
    - name: /etc/init.d/rabbitmq-server stop
    - user: root
    - require:
      - cmd: sleep_before_stop 

{% if salt['pillar.get']('run_from_jenkins') %}
{% if pillar['rabbit_cluster_master'] != grains['host'] %}
# If run_from_jenkins exists AND we're not on master then do this
/var/lib/rabbitmq/.erlang.cookie:
  file.managed:
    - source: salt://{{pillar['salt_state_root']}}rabbitmq/cluster/erlang.cookie
    - template: jinja
    - user: rabbitmq
    - group: rabbitmq
    - mode: 400
    - require_in:
      - cmd: sleep_before_start
    - require:
      - cmd: stop_rabbitmq_service
{% endif %}
{% else %}
#If run_from_jenkins doesn't exist then do this for all servers
/var/lib/rabbitmq/.erlang.cookie:
  file.managed:
    - source: salt://{{pillar['salt_state_root']}}rabbitmq/cluster/erlang.cookie
    - template: jinja
    - user: rabbitmq
    - group: rabbitmq
    - mode: 400
    - require_in:
      - cmd: sleep_before_start
    - require:
      - cmd: stop_rabbitmq_service

{% endif %}

sleep_before_start:
  cmd.run:
    - name: sleep 10
    - user: root
    - require:
      - cmd: stop_rabbitmq_service
 
start_rabbit_service:
  cmd.run:
    - name: /etc/init.d/rabbitmq-server start
    - user: root
    - require:
      - cmd: sleep_before_start


{% if pillar['rabbit_cluster_master'] != grains['host'] %}
stop_rabbit_app:
  cmd.run:
    - name: rabbitmqctl stop_app
    - user: root
    - require:
      - cmd: install_rmq_node
      - cmd: start_rabbit_service
      - file: /var/lib/rabbitmq/.erlang.cookie

rabbit_reset:
  cmd.run:
    - name: rabbitmqctl reset
    - user: root
    - require:
      - cmd: stop_rabbit_app
      - cmd: start_rabbit_service
      - file: /var/lib/rabbitmq/.erlang.cookie

join_rabbit_cluster:
  cmd.run:
    - name: rabbitmqctl join_cluster rabbit@{{pillar['rabbit_cluster_master']}}
    - user: root
    - require:
      - cmd: rabbit_reset
      - cmd: start_rabbit_service
      - file: /var/lib/rabbitmq/.erlang.cookie

start_rabbit_app:
  cmd.run:
    - name: rabbitmqctl start_app
    - user: root
    - require:
      - cmd: join_rabbit_cluster
      - cmd: start_rabbit_service
      - file: /var/lib/rabbitmq/.erlang.cookie

{% endif %}
