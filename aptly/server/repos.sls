{%- from "aptly/map.jinja" import server with context %}

{%- for repo_name, repo in server.repo.iteritems() %}

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

pkgdir:
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
    - file: pkgdir
  {%- if server.source.engine == "docker" %}
    - file: aptly_wrapper
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
