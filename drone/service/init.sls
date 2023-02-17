# vim: ft=sls

{#-
    Starts the drone container services
    and enables them at boot time.
    Has a dependency on `drone.config`_.
#}

include:
  - .running
