include:
  - git

devstack:
  git.latest:
    - name: https://github.com/openstack-dev/devstack.git
    - rev: stable/folsom
    - target: /tmp/devstack
    - require:
      - pkg: git
  cmd.wait:
    - name: /tmp/devstack/stack.sh
    - cwd: /tmp/devstack
    - require:
      - file: /tmp/devstack/localrc
    - watch:
      - git: devstack

/tmp/devstack/localrc:
  file.managed:
    - source: salt://devstack/localrc
    - template: jinja
    - require:
      - git: devstack

