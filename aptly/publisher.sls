{%- from "aptly/map.jinja" import publisher with context %}
{%- if publisher.enabled %}

{%- if publisher.source.engine == 'pkg' %}

publisher_installed:
  pkg.installed:
  - names: {{ publisher.source.pkgs }}

{%- elif publisher.source.engine == 'pip' %}

publisher_python_pip:
  pkg.installed:
    - name: python-pip

publisher_installed:
  pip.installed:
    - name: python-aptly
    - require:
      - pkg: publisher_python_pip

{%- elif publisher.source.engine == 'docker' %}

publisher_wrapper:
  file.managed:
    - name: /usr/local/bin/aptly-publisher
    - source: salt://aptly/files/aptly-publisher
    - template: jinja
    - defaults:
        image: {{ publisher.source.image|default('tcpcloud/aptly-publisher') }}
    - mode: 755

publisher_installed:
  cmd.wait:
    - name: "/usr/local/bin/aptly-publisher --help"
    - watch:
      - file: publisher_wrapper

{%- endif %}

publisher_yaml:
  file.managed:
  - name: /etc/aptly-publisher.yaml
  - source: salt://aptly/files/aptly-publisher.yaml
  - template: jinja
  - user: root
  - group: root
  - mode: 664

{% endif %}
