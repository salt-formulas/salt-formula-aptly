{%- from "aptly/map.jinja" import server with context %}
{%- if server.api.enabled %}

include:
  - aptly.server

{%- if grains.init == 'systemd' %}
aptly_api_service_file:
  file.managed:
    - name: /etc/systemd/system/aptly-api.service
    - source: salt://aptly/files/aptly-api.service
    - template: jinja
    - user: root
    - group: root
    - require:
      - cmd: aptly_installed
{%- else %}
aptly_api_service_file:
  file.managed:
    - name: /etc/init.d/aptly-api
    - source: salt://aptly/files/init.d/aptly-api
    - user: root
    - group: root
    - mode: 755
    - template: jinja
    - require:
      - cmd: aptly_installed
{%- endif %}

aptly_api_config:
  file.managed:
    - name: /etc/default/aptly-api
    - source: salt://aptly/files/default-aptly-api
    - user: root
    - group: root
    - mode: 644
    - template: jinja

aptly_api_service:
  service.running:
  - name: aptly-api
  - watch:
    - file: aptly_api_service_file
    - file: aptly_api_config
    - file: aptly_conf
    - cmd: aptly_installed

{%- endif %}
