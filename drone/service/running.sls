# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_config_file = tplroot ~ '.config.file' %}
{%- from tplroot ~ "/map.jinja" import mapdata as drone with context %}

include:
  - {{ sls_config_file }}

Drone service is enabled:
  compose.enabled:
    - name: {{ drone.lookup.paths.compose }}
{%- for param in ["project_name", "container_prefix", "pod_prefix", "separator"] %}
{%-   if drone.lookup.compose.get(param) is not none %}
    - {{ param }}: {{ drone.lookup.compose[param] }}
{%-   endif %}
{%- endfor %}
    - require:
      - Drone is installed
{%- if drone.install.rootless %}
    - user: {{ drone.lookup.user.name }}
{%- endif %}

Drone service is running:
  compose.running:
    - name: {{ drone.lookup.paths.compose }}
{%- for param in ["project_name", "container_prefix", "pod_prefix", "separator"] %}
{%-   if drone.lookup.compose.get(param) is not none %}
    - {{ param }}: {{ drone.lookup.compose[param] }}
{%-   endif %}
{%- endfor %}
{%- if drone.install.rootless %}
    - user: {{ drone.lookup.user.name }}
{%- endif %}
    - watch:
      - Drone is installed
