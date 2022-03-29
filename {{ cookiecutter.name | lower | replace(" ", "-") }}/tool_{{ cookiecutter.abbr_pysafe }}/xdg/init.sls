# -*- coding: utf-8 -*-
# vim: ft=sls

{% raw %}{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as {% endraw %}{{ cookiecutter.abbr_pysafe }}{% raw %} with context %}


include:
  - {{ tplroot }}.package

{%- for user in {% endraw %}{{ cookiecutter.abbr_pysafe }}{% raw %}.users | rejectattr('xdg', 'sameas', False) | list %}

{% endraw %}{{ cookiecutter.name }}{% raw %} has its config dir in XDG_CONFIG_HOME for user '{{ user.name }}':
  file.directory:
    - name: {{ user.xdg.config | path_join(tplroot[5:]) }}
    - user: {{ user.name }}
    - group: {{ user.group }}
    - mode: '0700'
    - makedirs: true
    - onlyif:
      - test -e '{{ user.home | path_join({% endraw %}{{ cookiecutter.abbr_pysafe }}{% raw %}.lookup.config.default_confdir) }}'

Existing {% endraw %}{{ cookiecutter.name }}{% raw %} configuration is migrated for user '{{ user.name }}':
  file.rename:
    - name: {{ user.xdg.config | path_join(tplroot[5:]) }}
    - source: {{ user.home | path_join({% endraw %}{{ cookiecutter.abbr_pysafe }}{% raw %}.lookup.config.default_confdir) }}
    - require:
      - {% endraw %}{{ cookiecutter.name }}{% raw %} has its config dir in XDG_CONFIG_HOME for user '{{ user.name }}'
    - require_in:
      - {% endraw %}{{ cookiecutter.name }}{% raw %} setup is completed

{% endraw %}{{ cookiecutter.name }}{% raw %} has its config file in XDG_CONFIG_HOME for user '{{ user.name }}':
  file.managed:
    - name: {{ user.xdg.config | path_join(tplroot[5:], {% endraw %}{{ cookiecutter.abbr_pysafe }}{% raw %}.lookup.config.default_xdg_conffile) }}
    - user: {{ user.name }}
    - group: {{ user.group }}
    - replace: False
    - makedirs: True
    - mode: '0600'
    - dir_mode: '0700'
    - require_in:
      - {% endraw %}{{ cookiecutter.name }}{% raw %} setup is completed

{% endraw %}{{ cookiecutter.name }}{% raw %} uses XDG dirs during this salt run:
  environ.setenv:
    - value:
        CONF: {{ user.xdg.config | path_join(tplroot[5:] | {% endraw %}{{ cookiecutter.abbr_pysafe }}{% raw %}.lookup.config.default_xdg_conffile) }}
    - require_in:
      - {% endraw %}{{ cookiecutter.name }}{% raw %} setup is completed

  {%- if user.get('persistenv') %}
{% endraw %}{{ cookiecutter.name }}{% raw %} knows about XDG location for user '{{ user.name }}':
  file.append:
    - name: {{ user.home | path_join(user.persistenv) }}
    - text: export CONF="${XDG_CONFIG_HOME:-$HOME/.config}/{{ tplroot[5:] }}"
    - user: {{ user.name }}
    - group: {{ user.group }}
    - mode: '0600'
    - require_in:
      - {% endraw %}{{ cookiecutter.name }}{% raw %} setup is completed
  {%- endif %}
{%- endfor %}{%- endraw %}
