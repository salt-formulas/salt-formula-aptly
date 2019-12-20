{%- from "aptly/map.jinja" import server with context %}

{%- for repo_name, repo in server.repo.items() %}

{%- for gpgkey in repo.get('gpgkeys', []) %}

gpg_add_keys_{{ repo_name }}_{{ gpgkey }}:
  cmd.run:
  - name: gpg --no-tty {% if server.gpg.get('keyring') %} --no-default-keyring --keyring {{ server.gpg.keyring }} {% endif %}{% if server.gpg.get('homedir') %} --homedir {{ server.gpg.homedir }}{% endif %} --keyserver {{ repo.keyserver|default(server.gpg.keyserver) }} {% if server.gpg.get('http_proxy') %} --keyserver-options http-proxy={{ server.gpg.get('http_proxy') }} {% endif %} --recv-keys {{ gpgkey }}
  - user: {{ server.user.name }}
  - cwd: {{ server.home_dir }}
  - unless: gpg --no-tty {% if server.gpg.get('keyring') %} --no-default-keyring --keyring {{ server.gpg.keyring }} {% endif %}{% if server.gpg.get('homedir') %} --homedir {{ server.gpg.homedir }} {% endif %} {% if server.gpg.get('http_proxy') %} --keyserver-options http-proxy={{ server.gpg.get('http_proxy') }} {% endif %} --list-public-keys {{ gpgkey }}
  {%- if server.secure %}
  - require:
    - cmd: import_gpg_priv_key
    - cmd: import_gpg_pub_key
  {%- endif %}
  {%- if repo.changes_dir is defined and repo.changes_dir %}
  - require_in:
    - cmd: aptly_{{ repo_name }}_changes_add
  {%- endif %}

{%- endfor %}

aptly_{{ repo_name }}_repo_create:
  cmd.run:
  - name: aptly repo create -distribution="{{ repo.distribution }}" -component="{{ repo.component }}" -architectures="{{ repo.architectures }}" -comment="{{ repo.comment }}" {{ repo_name }}
  - unless: aptly repo show {{ repo_name }}
  {%- if server.source.engine != "docker" %}
  - user: {{ server.user.name }}
  {%- endif %}
  - require:
    - file: aptly_conf
  {%- if server.source.engine == "docker" %}
    - file: aptly_wrapper
  {%- endif %}

{%- if repo.pkg_dir is defined and repo.pkg_dir %}

pkgdir_{{ repo.pkg_dir }}:
  file.directory:
  - name: {{ repo.pkg_dir }}
  - user: {{ server.user.name }}
  - group: {{ server.user.group }}
  - makedirs: true

aptly_{{ repo_name }}_pkgs_add:
  cmd.run:
  - name: aptly repo add {% if repo.get('remove_files') %}-remove-files {% endif %}{{ repo_name }} {{ repo.pkg_dir }}
  {%- if server.source.engine != "docker" %}
  - user: {{ server.user.name }}
  {%- endif %}
  - onlyif: ls -1qA {{ repo.pkg_dir }} | grep -q .
  - require:
    - cmd: aptly_{{ repo_name }}_repo_create
    - file: pkgdir_{{ repo.pkg_dir }}
  {%- if server.source.engine == "docker" %}
    - file: aptly_wrapper
  {%- endif %}

{%- endif %}

{%- if repo.changes_dir is defined and repo.changes_dir %}

changesdir_{{ repo.changes_dir }}:
  file.directory:
  - name: {{ repo.changes_dir }}
  - user: {{ server.user.name }}
  - group: {{ server.user.group }}
  - makedirs: true

aptly_{{ repo_name }}_changes_add:
  cmd.run:
  - name: aptly repo include {% if repo.get('no_remove_files') %}-no-remove-files {% endif %}-repo {{ repo_name }} {{ repo.changes_dir }}
  {%- if server.source.engine != "docker" %}
  - user: {{ server.user.name }}
  {%- endif %}
  - onlyif: ls -1qA {{ repo.changes_dir }} | grep -q .
  - require:
    - cmd: aptly_{{ repo_name }}_repo_create
    - file: changesdir_{{ repo.changes_dir }}
  {%- if server.source.engine == "docker" %}
    - file: aptly_wrapper
  {%- endif %}
  {%- if server.secure %}
    - cmd: import_gpg_priv_key
    - cmd: import_gpg_pub_key
    {% if server.gpg.get('keyring') %}
    - cmd: gpg_add_keyring_pub_key
    {%- endif %}
  {%- endif %}

{%- endif %}

{%- for snapshot in repo.get('snapshots', []) %}

{%- if snapshot is mapping and snapshot.get('drop') %}

aptly_dropsnapshot_{{ repo_name }}_{{ snapshot.name }}:
  cmd.run:
  - name: aptly snapshot drop {{ snapshot.name }}
    {%- if server.source.engine != "docker" %}
  - user: {{ server.user.name }}
    {%- endif %}
  - onlyif: aptly snapshot show {{ snapshot.name }}
    {%- if server.source.engine == "docker" %}
  - require:
    - file: aptly_wrapper
    {%- endif %}

{%- else %}

{% set snapshot_name = snapshot.name if snapshot is mapping else snapshot %}
aptly_addsnapshot_{{ repo_name }}_{{ snapshot_name }}:
  cmd.run:
  - name: aptly snapshot create {{ snapshot_name }} from repo {{ repo_name }}
  {%- if server.source.engine != "docker" %}
  - user: {{ server.user.name }}
  {%- endif %}
  - unless: aptly snapshot show {{ snapshot_name }}
  - require:
  {%- if server.source.engine == "docker" %}
    - file: aptly_wrapper
  {%- endif %}

{%- endif %}

{%- endfor %}

{%- if repo.publish is defined and repo.publish == True %}
aptly_{{ repo_name }}_repo_publish:
  cmd.run:
  - name: aptly publish repo -batch=true -gpg-key='{{ server.gpg.keypair_id }}' -passphrase='{{ server.gpg.passphrase }}' {{ repo_name }}
  {%- if server.source.engine != "docker" %}
  - user: {{ server.user.name }}
  {%- endif %}
  - unless: aptly publish update -batch=true -gpg-key='{{ server.gpg.keypair_id }}' -passphrase='{{ server.gpg.passphrase }}' {{ repo.distribution }}
{%- endif %}
  {%- if server.source.engine == "docker" %}
  - require:
    - file: aptly_wrapper
  {%- endif %}

{%- endfor %}
