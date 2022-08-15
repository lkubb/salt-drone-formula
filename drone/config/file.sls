# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_package_install = tplroot ~ '.package.install' %}
{%- from tplroot ~ "/map.jinja" import mapdata as drone with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

include:
  - {{ sls_package_install }}

Drone environment files are managed:
  file.managed:
    - names:
      - {{ drone.lookup.paths.config_drone }}:
        - source: {{ files_switch(['drone.env', 'drone.env.j2'],
                                  lookup='drone environment file is managed',
                                  indent_width=10,
                     )
                  }}
    - mode: '0640'
    - user: root
    - group: {{ drone.lookup.user.name }}
    - makedirs: True
    - template: jinja
    - require:
      - user: {{ drone.lookup.user.name }}
    - watch_in:
      - Drone is installed
    - context:
        drone: {{ drone | json }}
