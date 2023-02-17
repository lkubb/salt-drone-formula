# vim: ft=sls

{#-
    Removes the configuration of the drone containers
    and has a dependency on `drone.service.clean`_.

    This does not lead to the containers/services being rebuilt
    and thus differs from the usual behavior.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_service_clean = tplroot ~ ".service.clean" %}
{%- from tplroot ~ "/map.jinja" import mapdata as drone with context %}

include:
  - {{ sls_service_clean }}

Drone environment files are absent:
  file.absent:
    - names:
      - {{ drone.lookup.paths.config_drone }}
    - require:
      - sls: {{ sls_service_clean }}
