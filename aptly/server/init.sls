{%- from "aptly/map.jinja" import server with context %}
{%- if server.enabled %}

{% set gpgprivfile = '{}/.gnupg/secret.gpg'.format(server.home_dir) %}
{% set gpgpubfile = '{}/public/public.gpg'.format(server.root_dir) %}

include:
- aptly.server.repos
- aptly.server.mirrors

aptly_packages:
  pkg.installed:
  - names: {{ server.pkgs }}
  - refresh: true

aptly_user:
  user.present:
  - name: aptly
  - shell: /bin/bash
  - home: {{ server.home_dir }}
  - require:
    - pkg: aptly_packages

aptly_home_dir:
  file.directory:
  - name: {{ server.home_dir }}
  - user: aptly
  - group: aptly
  - mode: 755
  - require:
    - user: aptly_user

aptly_root_dir:
  file.directory:
  - name: {{ server.root_dir }}
  - user: aptly
  - group: aptly
  - mode: 755
  - require:
    - user: aptly_user

aptly_pub_dir:
  file.directory:
  - name: {{ server.root_dir }}/public
  - user: aptly
  - group: aptly
  - require:
    - file: aptly_home_dir

aptly_conf:
  file.managed:
  - name: {{ server.home_dir }}/.aptly.conf
  - source: salt://aptly/files/aptly.conf
  - template: jinja
  - user: aptly
  - group: aptly
  - mode: 664
  - require:
    - file: aptly_pub_dir

aptly_mirror_update_script:
  file.managed:
  - name: /usr/local/bin/aptly_mirror_update.sh
  - source: salt://aptly/files/aptly_mirror_update.sh
  - user: root
  - group: root
  - mode: 755

{%- if server.secure %}

aptly_gpg_key_dir:
  file.directory:
  - name: {{ server.home_dir }}/.gnupg
  - user: aptly
  - group: aptly
  - mode: 700
  - require:
    - file: aptly_home_dir


gpg_priv_key:
  file.managed:
  - name: {{ gpgprivfile }}
  - contents_pillar: aptly:server:gpg_private_key
  - user: aptly
  - group: aptly
  - mode: 600
  - require:
    - file: aptly_gpg_key_dir

gpg_pub_key:
  file.managed:
  - name: {{ gpgpubfile }}
  - contents_pillar: aptly:server:gpg_public_key
  - user: aptly
  - group: aptly
  - mode: 644
  - require:
    - file: aptly_gpg_key_dir

import_gpg_pub_key:
  cmd.run:
  - name: gpg --no-tty --import {{ gpgpubfile }}
  - user: aptly
  - unless: gpg --no-tty --list-keys | grep '{{ server.gpg_keypair_id }}'
  - require:
    - file: aptly_gpg_key_dir

import_gpg_priv_key:
  cmd.run:
  - name: gpg --no-tty --allow-secret-key-import --import {{ gpgprivfile }}
  - user: aptly
  - unless: gpg --no-tty --list-secret-keys | grep '{{ server.gpg_keypair_id }}'
  - require:
    - file: aptly_gpg_key_dir

{%- endif %}

{#
  FIXME: Hack to be able to use aptly commands when API server is running
  https://github.com/smira/aptly/issues/234

aptly_clean_lock:
  file.absent:
    - name: /srv/aptly/db/LOCK
#}

{%- endif %}
