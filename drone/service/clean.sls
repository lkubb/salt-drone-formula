# vim: ft=sls


{#-
    Stops the drone container services
    and disables them at boot time.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as drone with context %}

drone service is dead:
  compose.dead:
    - name: {{ drone.lookup.paths.compose }}
{%- for param in ["project_name", "container_prefix", "pod_prefix", "separator"] %}
{%-   if drone.lookup.compose.get(param) is not none %}
    - {{ param }}: {{ drone.lookup.compose[param] }}
{%-   endif %}
{%- endfor %}
{%- if drone.install.rootless %}
    - user: {{ drone.lookup.user.name }}
{%- endif %}

drone service is disabled:
  compose.disabled:
    - name: {{ drone.lookup.paths.compose }}
{%- for param in ["project_name", "container_prefix", "pod_prefix", "separator"] %}
{%-   if drone.lookup.compose.get(param) is not none %}
    - {{ param }}: {{ drone.lookup.compose[param] }}
{%-   endif %}
{%- endfor %}
{%- if drone.install.rootless %}
    - user: {{ drone.lookup.user.name }}
{%- endif %}
