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

{% set publisherImage = (publisher.source.image|default('tcpcloud/aptly-publisher')).split(':') %}
{% set publisherImageTag = publisherImage[1] if publisherImage|length > 1 else 'latest' %}
{% set registry = publisher.source.registry + "/" if publisher.source.registry is defined else "" %}

{{ publisherImage[0] }}:
{%- if grains['saltversioninfo'] < [2017, 7] %}
  dockerng.image_present:
{%- else %}
  docker_image.present:
{%- endif %}
    - name: {{ registry }}{{ publisherImage[0] }}:{{ publisherImageTag}}
      force: true
    - require_in:
      - file: publisher_wrapper

publisher_wrapper:
  file.managed:
    - name: /usr/local/bin/aptly-publisher
    - source: salt://aptly/files/aptly-publisher
    - defaults:
        image: {{ registry }}{{ publisherImage[0] }}:{{ publisherImageTag}}
    - template: jinja
    - mode: 755

publisher_installed:
  cmd.wait:
    - name: "/usr/local/bin/aptly-publisher --help"
    - watch:
      - file: publisher_wrapper

{%- endif %}

aptly_publish_script:
  file.managed:
  - name: /usr/local/bin/aptly_publish_update.sh
  - source: salt://aptly/files/aptly_publish_update.sh
  - user: root
  - group: root
  - mode: 755

publisher_yaml:
  file.managed:
  - name: /etc/aptly-publisher.yaml
  - source: salt://aptly/files/aptly-publisher.yaml
  - template: jinja
  - user: root
  - group: root
  - mode: 664

{% endif %}
