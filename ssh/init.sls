ssh:
  pkg.installed:
    - name: {{ pillar['package']['ssh'] }}
