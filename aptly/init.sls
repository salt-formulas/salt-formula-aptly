
include:
{%- if pillar.aptly.server is defined %}
- aptly.server
{%- endif %}
{%- if pillar.aptly.api is defined %}
- aptly.server.api
{%- endif %}
{%- if pillar.aptly.publisher is defined %}
- aptly.publisher
{%- endif %}
