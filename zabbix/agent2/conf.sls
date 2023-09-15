{% from "zabbix/map.jinja" import zabbix with context -%}
{% from "zabbix/libtofs.jinja" import files_switch with context -%}


include:
  - zabbix.agent2


{{ zabbix.agent2.config }}:
  file.managed:
    - source: {{ files_switch(['/etc/zabbix/zabbix_agent2.conf',
                               '/etc/zabbix/zabbix_agent2.conf.jinja'],
                              lookup='zabbix-agent2-config'
                 )
              }}
    - template: jinja
    - require:
      - pkg: zabbix-agent2
    - watch_in:
      - module: zabbix-agent2-restart
