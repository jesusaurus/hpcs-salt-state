build_env:
  pkg.installed:
    - name: maven
  {% if grains['os_family'] == 'Debian' %}
  pkg.installed:
    - name: build-essential
  pkg.installed:
    - name: python-dev
  {% elif grains['os_family'] == 'RedHat' %}
  pkg.installed:
    - name: python-devel
  pkg.installed:
    - name: gcc
  pkg.installed:
    - name: gcc-c++
  pkg.installed:
    - name: make
  pkg.installed:
    - name: autoconf
  pkg.installed:
    - name: pkgconfig
  pkg.installed:
    - name: libtool
  {% endif %}
