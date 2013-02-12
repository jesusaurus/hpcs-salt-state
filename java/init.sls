java:
  pkg:
    - installed
    {% if grains['os_family'] == 'Debian'%}
    - name: default-jre
    {% endif %}
