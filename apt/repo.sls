reprepro:
  pkg:
    - installed

{% macro repo(label, desc, release, arch, path) %}

{% for name in [ 'conf', 'dists', 'incoming', 'indices', 'logs', 'pool', 'project', 'tmp' ] %}

{{ path }}/{{ name }}:
  file.directory:
    - makedirs: True

{% endfor %}

{{ path }}/conf/distributions:
  file.managed:
    - source: salt://apt/distro
    - template: jinja
    - context: {
      label: {{ label }},
      desc: {{ desc }},
      arch: {{ arch }},
      release: {{ release }} }
    - require:
      - file: {{ path }}/conf

{{ path }}/conf/updates:
  file.managed:
    - source: salt://apt/updates
    - template: jinja
    - context: {
      arch: {{ arch }} }
    - require:
      - file: {{ path }}/conf

{{ path }}/conf/options:
  file.managed:
    - source: salt://apt/options
    - require:
      - file: {{ path }}/conf

'reprepro --silent update':
  cron.present:
    - minute: 0
    - hour: 0

/usr/local/bin/{{ label }}-{{ release }}-{{ arch }}.cron:
  file.managed:
    - mode: 755
    - source: salt://apt/incoming.cron
    - template: jinja
    - context: {
      release: {{ release }},
      path: {{ path }} }
    - require:
      - file: {{ path }}/incoming

  cron.present:
    - minute: '*/5'
    - require:
      - file: /usr/local/bin/{{ label }}-{{ release }}-{{ arch }}.cron

{% endmacro %}
