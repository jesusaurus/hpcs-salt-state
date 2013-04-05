include:
  - git

devstack:
  git.latest:
    - name: https://github.com/openstack-dev/devstack.git
    - rev: stable/folsom
    - target: /tmp/devstack
    - runas: ubuntu
    - force: True
    - require:
      - pkg: git
  cmd.wait:
    - name: /tmp/devstack/stack.sh
    - cwd: /tmp/devstack
    - user: ubuntu
    - require:
      - file: /tmp/devstack/localrc
      - file: /tmp/devstack/local.sh
    - watch:
      - git: devstack

/tmp/devstack/localrc:
  file.managed:
    - source: salt://devstack/localrc
    - template: jinja
    - user: ubuntu
    - require:
      - git: devstack

/tmp/devstack/local.sh:
  file.managed:
    - source: salt://devstack/local.sh
    - template: jinja
    - user: ubuntu
    - mode: 755
    - require:
      - file: {{ pillar['devstack']['path'] }}/precise.img
      - file: {{ pillar['devstack']['path'] }}/f17.img

{{ pillar['devstack']['path'] }}/precise.img:
  file.managed:
    - source: http://uec-images.ubuntu.com/precise/current/precise-server-cloudimg-amd64-disk1.img
    - source_hash: md5=38116cb5ea396e51d6b36e27f01dd156
    - user: ubuntu
    - require:
      - git: devstack

{{ pillar['devstack']['path'] }}/f17.img:
  file.managed:
    - source: http://berrange.fedorapeople.org/images/2012-11-15/f17-x86_64-openstack-sda.qcow2
    - source_hash: md5=1f104b5667768964d5df8c4ad1d7cd27
    - user: ubuntu
    - require:
      - git: devstack
