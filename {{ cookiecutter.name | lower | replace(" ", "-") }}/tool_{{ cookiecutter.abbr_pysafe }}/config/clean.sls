# -*- coding: utf-8 -*-
# vim: ft=sls

{% raw %}{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_service_clean = tplroot ~ '.service.clean' %}
{%- from tplroot ~ "/map.jinja" import mapdata as {% endraw %}{{ cookiecutter.abbr_pysafe }}{% raw %} with context %}

include:
  - {{ sls_service_clean }}

{%- for user in {% endraw %}{{ cookiecutter.abbr_pysafe }}{% raw %}.users | selectattr('config', 'defined') | selectattr('config') %}

{% endraw %}{{ cookiecutter.name }}{% raw %} config file is cleaned for user '{{ user.name }}':
  file.absent:
    - name: {{ user['_' ~ tplroot[5:]].confdir | path_join(user['_' ~ tplroot[5:]].conffile) }}
    - require:
      - sls: {{ sls_service_clean }}
{%- endfor %}{% endraw %}

