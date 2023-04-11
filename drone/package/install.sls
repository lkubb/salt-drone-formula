# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as drone with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

Drone user account is present:
  user.present:
{%- for param, val in drone.lookup.user.items() %}
{%-   if val is not none and param != "groups" %}
    - {{ param }}: {{ val }}
{%-   endif %}
{%- endfor %}
    - usergroup: true
    - createhome: true
    - groups: {{ drone.lookup.user.groups | json }}
    # (on Debian 11) subuid/subgid are only added automatically for non-system users
    - system: false

Drone user session is initialized at boot:
  compose.lingering_managed:
    - name: {{ drone.lookup.user.name }}
    - enable: {{ drone.install.rootless }}
    - require:
      - user: {{ drone.lookup.user.name }}

Drone paths are present:
  file.directory:
    - names:
      - {{ drone.lookup.paths.base }}
    - user: {{ drone.lookup.user.name }}
    - group: {{ drone.lookup.user.name }}
    - makedirs: true
    - require:
      - user: {{ drone.lookup.user.name }}

{%- if drone.install.podman_api %}

Drone podman API is enabled:
  compose.systemd_service_enabled:
    - name: podman.socket
    - user: {{ drone.lookup.user.name }}
    - require:
      - Drone user session is initialized at boot

Drone podman API is available:
  compose.systemd_service_running:
    - name: podman.socket
    - user: {{ drone.lookup.user.name }}
    - require:
      - Drone user session is initialized at boot
{%- endif %}

Drone compose file is managed:
  file.managed:
    - name: {{ drone.lookup.paths.compose }}
    - source: {{ files_switch(["docker-compose.yml", "docker-compose.yml.j2"],
                              lookup="Drone compose file is present"
                 )
              }}
    - mode: '0644'
    - user: root
    - group: {{ drone.lookup.rootgroup }}
    - makedirs: True
    - template: jinja
    - makedirs: true
    - context:
        drone: {{ drone | json }}

Drone is installed:
  compose.installed:
    - name: {{ drone.lookup.paths.compose }}
{%- for param, val in drone.lookup.compose.items() %}
{%-   if val is not none and param != "service" %}
    - {{ param }}: {{ val }}
{%-   endif %}
{%- endfor %}
{%- for param, val in drone.lookup.compose.service.items() %}
{%-   if val is not none %}
    - {{ param }}: {{ val }}
{%-   endif %}
{%- endfor %}
    - watch:
      - file: {{ drone.lookup.paths.compose }}
{%- if drone.install.rootless %}
    - user: {{ drone.lookup.user.name }}
    - require:
      - user: {{ drone.lookup.user.name }}
{%- endif %}

{%- if drone.install.autoupdate_service is not none %}

Podman autoupdate service is managed for Drone:
{%-   if drone.install.rootless %}
  compose.systemd_service_{{ "enabled" if drone.install.autoupdate_service else "disabled" }}:
    - user: {{ drone.lookup.user.name }}
{%-   else %}
  service.{{ "enabled" if drone.install.autoupdate_service else "disabled" }}:
{%-   endif %}
    - name: podman-auto-update.timer
{%- endif %}
