# -*- coding: utf-8 -*-
# vim: ft=yaml
---
drone:
  lookup:
    master: template-master
    # Just for testing purposes
    winner: lookup
    added_in_lookup: lookup_value
    compose:
      create_pod: null
      pod_args: null
      project_name: drone
      remove_orphans: true
      service:
        container_prefix: null
        ephemeral: true
        pod_prefix: null
        restart_policy: on-failure
        restart_sec: 2
        separator: null
        stop_timeout: null
    paths:
      base: /opt/containers/drone
      compose: docker-compose.yml
      config_drone: drone.env
      data: data
    user:
      groups: []
      home: null
      name: drone
      shell: /usr/sbin/nologin
      uid: null
      gid: null
    containers:
      drone:
        image: docker.io/drone/drone:latest
  install:
    rootless: true
    remove_all_data_for_sure: false
  config:
    bitbucket:
      client_id: null
      client_secret: null
      debug: null
    cleanup:
      deadline_pending: null
      deadline_running: null
      disabled: null
      interval: null
    convert_plugin:
      endpoint: null
      extension: null
      secret: null
      skip_verify: null
    cookie:
      secret: null
      timeout: null
    cron:
      disabled: null
      interval: null
    database:
      datasource: null
      driver: null
      max_connections: null
      secret: null
    git:
      always_auth: null
      password: null
      username: null
    gitea:
      client_id: null
      client_secret: null
      server: null
      skip_verify: null
    gitee:
      redirect_url: null
      scope: null
      skip_verify: null
    github:
      client_id: null
      client_secret: null
      scope: null
      server: null
      skip_verify: null
    gitlab:
      client_id: null
      client_secret: null
      server: null
      skip_verify: null
    gogs:
      server: null
      skip_verify: null
    jsonnet_enabled: null
    license: null
    logs:
      color: null
      debug: null
      pretty: null
      text: null
      trace: null
    prometheus_anonymous_access: null
    registration_closed: null
    repository_filter: null
    rpc_secret: null
    s3:
      bucket: null
      endpoint: null
      path_style: null
      prefix: null
    server:
      host: null
      proto: null
      proxy_host: null
      proxy_proto: null
    starlark:
      enabled: null
      step_limit: null
    stash:
      consumer_key: null
      private_key: null
      server: null
      skip_verify: null
    status:
      disabled: null
      name: null
    tls:
      autocert: null
      cert: null
      key: null
    user:
      create: null
      filter: null
    validate_plugin:
      endpoint: null
      secret: null
      skip_verify: null
    webhook:
      endpoint: null
      events: null
      secret: null
      skip_verify: null
  container:
    listen: 4803
    listen_https: 4804

  tofs:
    # The files_switch key serves as a selector for alternative
    # directories under the formula files directory. See TOFS pattern
    # doc for more info.
    # Note: Any value not evaluated by `config.get` will be used literally.
    # This can be used to set custom paths, as many levels deep as required.
    files_switch:
      - any/path/can/be/used/here
      - id
      - roles
      - osfinger
      - os
      - os_family
    # All aspects of path/file resolution are customisable using the options below.
    # This is unnecessary in most cases; there are sensible defaults.
    # Default path: salt://< path_prefix >/< dirs.files >/< dirs.default >
    #         I.e.: salt://drone/files/default
    # path_prefix: template_alt
    # dirs:
    #   files: files_alt
    #   default: default_alt
    # The entries under `source_files` are prepended to the default source files
    # given for the state
    # source_files:
    #   drone-config-file-file-managed:
    #     - 'example_alt.tmpl'
    #     - 'example_alt.tmpl.jinja'

    # For testing purposes
    source_files:
      Drone environment file is managed:
      - drone.env.j2

  # Just for testing purposes
  winner: pillar
  added_in_pillar: pillar_value
