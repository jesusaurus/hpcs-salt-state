include:
  - gems
  - git

bundler:
  gem:
    - installed
    - require:
      - pkg: rubygems

kibana:
  user:
    - present
    - home: /mnt/kibana
    - system: True
    - gid_from_name: True
    - require:
      - group: kibana
  group:
    - present
    - system: True
  git.latest:
    - name: https://github.com/rashidkpc/Kibana.git
    - rev: v0.2.0
    - target: /mnt/kibana
    - runas: kibana
    - require:
      - pkg: git
      - file: /mnt/kibana
  cmd.wait:
    - name: bundle install
    - cwd: /mnt/kibana
    - require:
      - gem: bundler
      - file: /mnt/kibana/KibanaConfig.rb
    - watch:
      - git: kibana
      - file: /mnt/kibana/KibanaConfig.rb
  service.running:
    - require:
      - file: /etc/init/kibana.conf
      - cmd: kibana
    - watch:
      - file: /etc/init/kibana.conf
      - file: /mnt/kibana/KibanaConfig.rb

/mnt/kibana:
  file.directory:
    - user: kibana
    - group: kibana

/mnt/kibana/KibanaConfig.rb:
  file.managed:
    - source: salt://kibana/config.rb
    - user: kibana
    - group: kibana
    - require:
      - user: kibana
      - group: kibana
      - git: kibana

/etc/init/kibana.conf:
  file.managed:
    - source: salt://kibana/kibana.init
    - user: root
    - group: root
    - mode: 0644
