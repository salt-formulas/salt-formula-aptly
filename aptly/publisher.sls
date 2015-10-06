{%- from "aptly/map.jinja" import publisher with context %}
{%- if publisher.enabled %}

publisher_packages:
  pkg.latest:
  - names: ['python-aptly']

publisher_yaml:
  file.managed:
  - name: /etc/aptly-publisher.yaml
  - source: salt://aptly/files/aptly-publisher.yaml
  - template: jinja
  - user: root
  - group: root
  - mode: 664

{% endif %}
