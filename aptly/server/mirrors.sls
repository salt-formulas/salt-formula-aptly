{%- from "aptly/map.jinja" import server with context %}

{%- if server.mirror_update.enabled %}

aptly_mirror_update_cron:
  cron.present:
  - name: "/usr/local/bin/aptly_mirror_update.sh -s"
  - identifier: aptly_mirror_update
  - hour: "{{ server.mirror_update.hour }}"
  - minute: "{{ server.mirror_update.minute }}"
  {%- if server.source.engine != "docker" %}
  - user: {{ server.user.name }}
  {%- else %}
  - user: root
  {%- endif %}
  - require:
    - file: aptly_mirror_update_script
    - user: aptly_user

cron_path:
  cron.env_present:
    - name: PATH
    - value: "/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin"

{%- else %}

aptly_mirror_update_cron:
  cron.absent:
  - identifier: aptly_mirror_update
  {%- if server.source.engine != "docker" %}
  - user: {{ server.user.name }}
  {%- else %}
  - user: root
  {%- endif %}

{% endif %}


{%- if server.mirror is defined %}

{%- for mirror_name, mirror in server.mirror.iteritems() %}

{%- set _gpg_attributes="--no-tty --no-default-keyring{% if server.gpg.get('keyring', None) %} --keyring {{ server.gpg.keyring }} {% endif %}{% if server.gpg.get('homedir', None) %} --homedir {{ server.gpg.homedir }} {% endif %}" %}

{%- for gpgkey in mirror.get('gpgkeys', []) %}
gpg_add_keys_{{ mirror_name }}_{{ gpgkey }}:
  cmd.run:
  {%- if gpgkey|length > 1 %}
  - name: echo "{{ gpgkey|indent(0, true)}}" | gpg --import {{ _gpg_attributes }}
  {%- else %}
  - name: gpg {{ _gpg_attributes }} --keyserver {{ mirror.keyserver|default(server.gpg.keyserver) }} --recv-keys {{ gpgkey }}
  - unless: gpg  {{ _gpg_attributes }} --list-public-keys {{ gpgkey }}
  {%- endif %}
  - user: {{ server.user.name }}
  - cwd: {{ server.home_dir }}
  {%- if server.secure %}
  - require:
    - cmd: import_gpg_priv_key
    - cmd: import_gpg_pub_key
  - require_in:
    - cmd: aptly_{{ mirror_name }}_mirror
  {%- endif %}

{%- endfor %}

{%- for snapshot in mirror.get('snapshots', []) %}

aptly_addsnapshot_{{ mirror_name }}_{{ snapshot }}:
  cmd.run:
  - name: aptly snapshot create {{ snapshot }} from mirror {{ mirror_name }}
  {%- if server.source.engine != "docker" %}
  - user: {{ server.user.name }}
  {%- endif %}
  - unless: aptly snapshot show {{ snapshot }}
  - require:
    - cmd: aptly_{{ mirror_name }}_update

{%- endfor %}

aptly_{{ mirror_name }}_mirror:
  cmd.run:
  - name: aptly mirror create {% if mirror.get('udebs', False) %}-with-udebs=true {% endif %}{% if mirror.get('sources', False) %}-with-sources=true {% endif %}-architectures={{ mirror.architectures }} {{ mirror_name }} {{ mirror.source }} {{ mirror.distribution }} {{ mirror.components }}
  {%- if server.source.engine != "docker" %}
  - user: {{ server.user.name }}
  {%- endif %}
  - unless: aptly mirror show {{ mirror_name }}

{%- if mirror.get('update', False) == True %}
aptly_{{ mirror_name }}_update:
  cmd.run:
  - name: aptly mirror update {{ mirror_name }}
  {%- if server.source.engine != "docker" %}
  - user: {{ server.user.name }}
  {%- endif %}
  - require:
    - cmd: aptly_{{ mirror_name }}_mirror
{%- endif %}

{%- if mirror.publish is defined %}
aptly_publish_{{ server.mirror[mirror_name].publish }}_snapshot:
  cmd.run:
  - name: aptly publish snapshot -batch=true -gpg-key='{{ server.gpg.keypair_id }}' -passphrase='{{ server.gpg.passphrase }}' {{ server.mirror[mirror_name].publish }}
  {%- if server.source.engine != "docker" %}
  - user: {{ server.user.name }}
  {%- endif %}
{% endif %}

{%- endfor %}

{%- endif %}
