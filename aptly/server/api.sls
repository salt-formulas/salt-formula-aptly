{%- from "aptly/map.jinja" import server with context %}
{%- if server.api.enabled %}

include:
  - aptly.server

aptly_api_init_script:
  file.managed:
    - name: /etc/init.d/aptly-api
    - source: salt://aptly/files/init.d/aptly-api
    - user: root
    - group: root
    - mode: 755
    - template: jinja
    - require:
      - pkg: aptly_packages

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
    - file: aptly_api_init_script
    - file: aptly_api_config
    - file: aptly_conf
    - pkg: aptly_packages

{%- endif %}
