{%- from "aptly/map.jinja" import server with context %}

{%- if server.mirror_update.enabled %}

aptly_mirror_update_cron:
  cron.present:
  - name: "service aptly-api stop >/dev/null;sleep 5;su aptly -c '/usr/local/bin/aptly_mirror_update.sh -s';service aptly-api start >/dev/null"
  - identifier: aptly_mirror_update
  - hour: "{{ server.mirror_update.hour }}"
  - minute: "{{ server.mirror_update.minute }}"
  - user: root
  - require:
    - file: aptly_mirror_update_script
    - user: aptly_user

cron_path:
  cron.env_present:
    - name: PATH
    - value: "/bin:/sbin:/usr/bin:/usr/sbin"

{%- else %}

aptly_mirror_update_cron:
  cron.absent:
  - identifier: aptly_mirror_update
  - user: root

{% endif %}


{%- if server.mirror is defined %}

{%- for mirror_name, mirror in server.mirror.iteritems() %}

{%- for gpgkey in mirror.get('gpgkeys', []) %}

gpg_add_keys_{{ mirror_name }}_{{ gpgkey }}:
  cmd.run:
  - name: gpg --no-tty --no-default-keyring --keyring {{ server.gpg.keyring }} --keyserver {{ mirror.keyserver|default(server.gpg.keyserver) }} --recv-keys {{ gpgkey }}
  {%- if server.source.engine != "docker" %}
  - user: aptly
  {%- endif %}
  - unless: gpg --no-tty --no-default-keyring --keyring {{ server.gpg.keyring }} --list-public-keys {{gpgkey}}

{%- endfor %}

{%- for snapshot in mirror.get('snapshots', []) %}

aptly_addsnapshot_{{ mirror_name }}_{{ snapshot }}:
  cmd.run:
  - name: aptly snapshot create {{ snapshot }} from mirror {{ mirror_name }}
  {%- if server.source.engine != "docker" %}
  - user: aptly
  {%- endif %}
  - unless: aptly snapshot show {{ snapshot }}
  - require:
    - cmd: aptly_{{ mirror_name }}_update

{%- endfor %}

aptly_{{ mirror_name }}_mirror:
  cmd.run:
  - name: aptly mirror create {% if mirror.get('udebs', False) %}-with-udebs=true {% endif %}{% if mirror.get('sources', False) %}-with-sources=true {% endif %}-architectures={{ mirror.architectures }} {{ mirror_name }} {{ mirror.source }} {{ mirror.distribution }} {{ mirror.components }}
  {%- if server.source.engine != "docker" %}
  - user: aptly
  {%- endif %}
  - unless: aptly mirror show {{ mirror_name }}

{%- if mirror.get('update', False) == True %}
aptly_{{ mirror_name }}_update:
  cmd.run:
  - name: aptly mirror update {{ mirror_name }}
  {%- if server.source.engine != "docker" %}
  - user: aptly
  {%- endif %}
  - require:
    - cmd: aptly_{{ mirror_name }}_mirror
{%- endif %}

{%- if mirror.publish is defined %}
aptly_publish_{{ server.mirror[mirror_name].publish }}_snapshot:
  cmd.run:
  - name: aptly publish snapshot -batch=true -gpg-key='{{ server.gpg.keypair_id }}' -passphrase='{{ server.gpg.passphrase }}' {{ server.mirror[mirror_name].publish }}
  {%- if server.source.engine != "docker" %}
  - user: aptly
  {%- endif %}
{% endif %}

{%- endfor %}

{%- endif %}
