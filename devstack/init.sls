include:
  - git

devstack:
  git.latest:
    - name: https://github.com/openstack-dev/devstack.git
    - rev: stable/folsom
    - target: /tmp/devstack
    - runas: ubuntu
    - require:
      - pkg: git
  cmd.wait:
    - name: /tmp/devstack/stack.sh
    - cwd: /tmp/devstack
    - user: ubuntu
    - require:
      - file: /tmp/devstack/localrc
    - watch:
      - git: devstack

/tmp/devstack/localrc:
  file.managed:
    - source: salt://devstack/localrc
    - template: jinja
    - user: ubuntu
    - require:
      - git: devstack

