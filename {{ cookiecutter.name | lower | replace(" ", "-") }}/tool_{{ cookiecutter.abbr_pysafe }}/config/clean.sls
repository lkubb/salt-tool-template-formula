# -*- coding: utf-8 -*-
# vim: ft=sls

{% raw %}{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_service_clean = tplroot ~ '.service.clean' %}
{%- from tplroot ~ "/map.jinja" import mapdata as {% endraw %}{{ cookiecutter.abbr_pysafe }}{% raw %} with context %}

include:
  - {{ sls_service_clean }}

{%- for user in {% endraw %}{{ cookiecutter.abbr_pysafe }}{% raw %}.users | selectattr('config', 'defined') | selectattr('config') %}

{% endraw %}{{ cookiecutter.name }}{% raw %} config file is managed for user '{{ user.name }}':
  file.managed:
    - name: {{ user['_' ~ tplroot[5:]].confdir | path_join(tplroot[5:], user['_' ~ tplroot[5:]].conffile) }}
    - source: {{ files_switch([user['_' ~ tplroot[5:]].conffile],
                              lookup='{% endraw %}{{ cookiecutter.name }}{% raw %} config file is managed for user \'{{ user.name }}\''
                 )
              }}
    - mode: '0600'
    - user: {{ user.name }}
    - group: {{ user.group }}
    - makedirs: True
    - dir_mode: '0700'
    - template: jinja
    - require:
      - sls: {{ sls_service_clean }}
    - context:
        user: {{ user | json }}
{%- endfor %}{% endraw %}

