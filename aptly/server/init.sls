{%- from "aptly/map.jinja" import server with context %}
{%- if server.enabled %}

{% set gpgprivfile = '{}/.gnupg/secret.gpg'.format(server.home_dir) %}
{% set gpgpubfile = '{}/public/public.gpg'.format(server.root_dir) %}

include:
- aptly.server.repos
- aptly.server.mirrors

{%- if server.source.engine == 'pkg' %}

aptly_packages:
  pkg.installed:
  - names: {{ server.source.pkgs }}
  - refresh: true
  - require_in:
    - user: aptly_user

aptly_installed:
  cmd.wait:
    - name: "aptly version"
    - watch:
      - pkg: aptly_packages
    - require:
      - user: aptly_user

{%- elif server.source.engine == 'docker' %}

aptly_wrapper:
  file.managed:
    - name: /usr/local/bin/aptly
    - source: salt://aptly/files/aptly
    - template: jinja
    - defaults:
        image: {{ server.source.image|default('tcpcloud/aptly') }}
        aptly_home: {{ server.home_dir }}
        aptly_root: {{ server.root_dir }}
    - mode: 755

aptly_installed:
  cmd.wait:
    - name: "/usr/local/bin/aptly version"
    - watch:
      - file: aptly_wrapper
    - require:
      - user: aptly_user
      - file: aptly_root_dir
      - file: aptly_home_dir

{%- endif %}

aptly_user:
  user.present:
  - name: {{ server.user.name }}
  - home: {{ server.home_dir }}
  - shell: /bin/bash
  {%- if server.user.uid is defined %}
  - uid: {{ server.user.uid }}
  {%- endif %}
  {%- if server.user.gid is defined %}
  - gid: {{ server.user.gid }}
  {%- endif %}
  - system: True
  - groups:
    - aptly

aptly_group:
  group.present:
  - name: {{ server.user.group }}
  {%- if server.user.gid is defined %}
  - gid: {{ server.user.gid }}
  {%- endif %}
  - system: True
  - require_in:
    - user: aptly_user

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
    - file: aptly_root_dir

{%- if server.no_config|default(False) == True %}
aptly_conf:
  file.directory:
    - name: {{ server.home_dir }}
{%- else %}
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
{%- endif %}

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
  - contents: {{ server.gpg.private_key|yaml }}
  - user: aptly
  - group: aptly
  - mode: 600
  - require:
    - file: aptly_gpg_key_dir

gpg_pub_key:
  file.managed:
  - name: {{ gpgpubfile }}
  - contents: {{ server.gpg.public_key|yaml }}
  - user: aptly
  - group: aptly
  - mode: 644
  - require:
    - file: aptly_gpg_key_dir

import_gpg_pub_key:
  cmd.run:
  - name: gpg --no-tty --import {{ gpgpubfile }}
  - user: aptly
  - unless: gpg --no-tty{% if server.gpg.get('homedir', None) %} --homedir {{ server.gpg.homedir }}{% endif %} --list-keys | grep '{{ server.gpg.keypair_id }}'
  - require:
    - file: aptly_gpg_key_dir
    - file: gpg_pub_key

import_gpg_priv_key:
  cmd.run:
  - name: gpg --no-tty --allow-secret-key-import{% if server.gpg.get('homedir', None) %} --homedir {{ server.gpg.homedir }}{% endif %} --import {{ gpgprivfile }}
  - user: aptly
  - unless: gpg --no-tty{% if server.gpg.get('homedir', None) %} --homedir {{ server.gpg.homedir }}{% endif %} --list-secret-keys | grep '{{ server.gpg.keypair_id }}'
  - require:
    - file: aptly_gpg_key_dir
    - file: gpg_priv_key
  - require_in:
    - cmd: aptly_installed

{%- endif %}

{%- endif %}

