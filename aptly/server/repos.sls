{%- from "aptly/map.jinja" import server with context %}

{%- for repo_name, repo in server.repo.iteritems() %}

aptly_{{ repo_name }}_repo_create:
  cmd.run:
  - name: aptly repo create -distribution="{{ repo.distribution }}" -component="{{ repo.component }}" -architectures="{{ repo.architectures }}" -comment="{{ repo.comment }}" {{ repo_name }}
  - unless: aptly repo show {{ repo_name }}
  - user: aptly
  - require:
    - file: aptly_conf

{%- if repo.pkg_dir is defined and repo.pkg_dir %}

pkgdir:
  file.directory:
  - name: {{ repo.pkg_dir }}
  - user: aptly
  - group: aptly
  - makedirs: true

aptly_{{ repo_name }}_pkgs_add:
  cmd.run:
  - name: aptly repo add {{ repo_name }} {{ repo.pkg_dir }}
  - user: aptly
  - require:
    - cmd: aptly_{{ repo_name }}_repo_create
    - file: pkgdir

{%- endif %}

{%- if repo.publish is defined and repo.publish == True %}
aptly_{{ repo_name }}_repo_publish:
  cmd.run:
  - name: aptly publish repo -batch=true -gpg-key='{{ server.gpg_keypair_id }}' -passphrase='{{ server.gpg_passphrase }}' {{ repo_name }}
  - user: aptly
  - unless: aptly publish update -batch=true -gpg-key='{{ server.gpg_keypair_id }}' -passphrase='{{ server.gpg_passphrase }}' {{ repo.distribution }}
{%- endif %}

{%- endfor %}
