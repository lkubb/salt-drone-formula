# vim: ft=sls

{#-
    Removes the drone containers
    and the corresponding user account and service units.
    Has a depency on `drone.config.clean`_.
    If ``remove_all_data_for_sure`` was set, also removes all data.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_config_clean = tplroot ~ ".config.clean" %}
{%- from tplroot ~ "/map.jinja" import mapdata as drone with context %}

include:
  - {{ sls_config_clean }}

{%- if drone.install.autoupdate_service %}

Podman autoupdate service is disabled for Drone:
{%-   if drone.install.rootless %}
  compose.systemd_service_disabled:
    - user: {{ drone.lookup.user.name }}
{%-   else %}
  service.disabled:
{%-   endif %}
    - name: podman-auto-update.timer
{%- endif %}

Drone is absent:
  compose.removed:
    - name: {{ drone.lookup.paths.compose }}
    - volumes: {{ drone.install.remove_all_data_for_sure }}
{%- for param in ["project_name", "container_prefix", "pod_prefix", "separator"] %}
{%-   if drone.lookup.compose.get(param) is not none %}
    - {{ param }}: {{ drone.lookup.compose[param] }}
{%-   endif %}
{%- endfor %}
{%- if drone.install.rootless %}
    - user: {{ drone.lookup.user.name }}
{%- endif %}
    - require:
      - sls: {{ sls_config_clean }}

Drone compose file is absent:
  file.absent:
    - name: {{ drone.lookup.paths.compose }}
    - require:
      - Drone is absent

{%- if drone.install.podman_api %}

Drone podman API is unavailable:
  compose.systemd_service_dead:
    - name: podman.socket
    - user: {{ drone.lookup.user.name }}
    - onlyif:
      - fun: user.info
        name: {{ drone.lookup.user.name }}

Drone podman API is disabled:
  compose.systemd_service_disabled:
    - name: podman.socket
    - user: {{ drone.lookup.user.name }}
    - onlyif:
      - fun: user.info
        name: {{ drone.lookup.user.name }}
{%- endif %}

Drone user session is not initialized at boot:
  compose.lingering_managed:
    - name: {{ drone.lookup.user.name }}
    - enable: false
    - onlyif:
      - fun: user.info
        name: {{ drone.lookup.user.name }}

Drone user account is absent:
  user.absent:
    - name: {{ drone.lookup.user.name }}
    - purge: {{ drone.install.remove_all_data_for_sure }}
    - require:
      - Drone is absent
    - retry:
        attempts: 5
        interval: 2

{%- if drone.install.remove_all_data_for_sure %}

Drone paths are absent:
  file.absent:
    - names:
      - {{ drone.lookup.paths.base }}
    - require:
      - Drone is absent
{%- endif %}
