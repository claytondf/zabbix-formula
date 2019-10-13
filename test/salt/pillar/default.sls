# -*- coding: utf-8 -*-
# vim: ft=yaml
---
zabbix:
  # Overrides map.jinja
  lookup:
    version_repo: '4.4'
  #  agent:
  #    version: xxx
  #  frontend:
  #    version: xxx
  #  server:
  #    version: xxx

  tofs:
    # The files_switch key serves as a selector for alternative
    # directories under the formula files directory. See TOFS pattern
    # doc for more info.
    # Note: Any value not evaluated by `config.get` will be used literally.
    # This can be used to set custom paths, as many levels deep as required.
    # files_switch:
    #   - any/path/can/be/used/here
    #   - id
    #   - roles
    #   - osfinger
    #   - os
    #   - os_family
    # All aspects of path/file resolution are customisable using the options below.
    # This is unnecessary in most cases; there are sensible defaults.
    # Default path: salt://< path_prefix >/< dirs.files >/< dirs.default >
    #         I.e.: salt://template/files/default
    # path_prefix: template_alt
    # dirs:
    #   files: files_alt
    #   default: default_alt
    # The entries under `source_files` are prepended to the default source files
    # given for the state
    source_files:
      zabbix-agent-config:
        - '/etc/zabbix/alt_zabbix_agentd.conf'
      zabbix-frontend-config:
        - '/etc/zabbix/web/alt_zabbix.conf.php'
      zabbix-server-mysql:
        - '/usr/share/zabbix-server-mysql/alt_salt-provided-create-34.sql'
      zabbix-server-pgsql:
        - '/usr/share/doc/zabbix-server-pgsql/alt_custom.sql.gz'
      zabbix-proxy-config:
        - '/etc/zabbix/alt_zabbix_proxy.conf'
      zabbix-server-config:
        - '/etc/zabbix/alt_zabbix_server.conf'

  # Zabbix user has to be member of some groups in order to have permissions to
  # execute or read some things
  user_groups:
    - adm

zabbix-agent:
  server:
    - localhost
  serveractive:
    - localhost
  listenip: 0.0.0.0
  listenport: 10050
  hostmetadata: c9767034-22c6-4d3d-a886-5fcaf1386b77
  logfile: /var/log/zabbix/zabbix_agentd.log
  logfilesize: 0
  # include: /etc/zabbix/zabbix_agentd.d/
  # Or multiple "Include" options
  includes:
    - /etc/zabbix/zabbix_agentd.d/
  userparameters:
    - net.ping[*],/usr/bin/fping -q -c3 $1 2>&1 | sed 's,.*/\([0-9.]*\)/.*,\1,'
    - custom.vfs.dev.discovery,/usr/local/bin/dev-discovery.sh
  extra_conf: |
    # Here we can set extra agent configuration lines

zabbix-server:
  listenip: 0.0.0.0
  listenport: 10051
  dbhost: localhost
  dbname: zabbix
  dbuser: zabbixuser
  dbpassword: zabbixpass
  extra_conf: |
    # Here we can set extra server configuration lines

zabbix-mysql:
  dbhost: localhost
  dbname: zabbix
  dbuser: zabbixuser
  dbpassword: zabbixpass
  dbuser_host: '%'
  # Optionally specify this for a non-local dbhost
  # dbroot_user: 'root'
  # dbroot_pass: 'rootpass'

zabbix-frontend:
  dbtype: MYSQL
  dbhost: localhost
  dbname: zabbix
  dbuser: zabbixuser
  dbpassword: zabbixpass
  zbxserver: localhost
  zbxserverport: 10051
  zbxservername: 'Zabbix installed with saltstack'

zabbix-proxy:
  proxymode: 0
  server: localhost
  serverport: 10051
  hostname: localhost
  hostnameitem: system.hostname
  listenport: 10051
  sourceip: 127.0.0.1
  logfile: syslog
  logfilesize: 0
  debugelevel: 3
  pidfile: /tmp/zabbix_proxy.pid
  dbhost: localhost
  dbname: /var/lib/zabbix/zabbix_proxy.db
  dbuser: zabbix
  include: /etc/zabbix/zabbix_proxy.d/
