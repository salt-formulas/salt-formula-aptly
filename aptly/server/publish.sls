{%- from "aptly/map.jinja" import server with context %}

{%- if server.publish is defined %}

{%- for pub in server.publish %}

aptly_drop_publish_{{ pub.snapshot }}_snapshot:
  cmd.run:
  - name: aptly publish drop {{ pub.distribution }}{% if pub.get('prefix') %} {{ pub.prefix }}{% endif %}
  {%- if pub.get('drop') %}
  - onlyif: aptly publish show {{ pub.distribution }}{% if pub.get('prefix') %} {{ pub.prefix }}{% endif %}
  {%- else %}
  - onlyif: 'aptly publish show {{ pub.distribution }}{% if pub.get("prefix") %} {{ pub.prefix }}{% endif %} | grep snapshot | grep -q -v ": {{ pub.snapshot }} "'
  {%- endif %}
  {%- if server.source.engine != "docker" %}
  - user: {{ server.user.name }}
  {%- endif %}
  {%- if server.source.engine == "docker" %}
  - require:
    - file: aptly_wrapper
  {%- endif %}

  {%- if not pub.get('drop') %}
aptly_publish_{{ pub.snapshot }}_snapshot:
  cmd.run:
  - name: aptly publish snapshot -batch=true -gpg-key='{{ server.gpg.keypair_id }}' -passphrase='{{ server.gpg.passphrase }}' -distribution={{ pub.distribution }}{% if pub.get('component') %} -component={{ pub.component }}{% endif %} {{ pub.snapshot }}{% if pub.get('prefix') %} {{ pub.prefix }}{% endif %} 
  - unless: aptly publish show {{ pub.distribution }}{% if pub.get('prefix') %} {{ pub.prefix }}{% endif %}
    {%- if server.source.engine != "docker" %}
  - user: {{ server.user.name }}
    {%- endif %}
  - require:
    - cmd: aptly_drop_publish_{{ pub.snapshot }}_snapshot
    {%- if server.source.engine == "docker" %}
    - file: aptly_wrapper
    {%- endif %}
  {%- endif %}

{%- endfor %}

{%- endif %}
