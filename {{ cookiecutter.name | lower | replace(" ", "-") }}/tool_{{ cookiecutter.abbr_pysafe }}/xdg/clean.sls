# -*- coding: utf-8 -*-
# vim: ft=sls

{% raw %}{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as {% endraw %}{{ cookiecutter.abbr_pysafe }}{% raw %} with context %}

{%- for user in {% endraw %}{{ cookiecutter.abbr_pysafe }}{% raw %}.users | rejectattr('xdg', 'sameas', False) | list %}

{% endraw %}{{ cookiecutter.name }}{% raw %} configuration is cluttering $HOME for user '{{ user.name }}':
  file.rename:
    - name: {{ user.home | path_join({% endraw %}{{ cookiecutter.abbr_pysafe }}{% raw %}.lookup.config.default_confdir) }}
    - source: {{ user.xdg.config | path_join(tplroot[5:]) }}

{% endraw %}{{ cookiecutter.name }}{% raw %} does not have its config folder in XDG_CONFIG_HOME for user '{{ user.name }}':
  file.absent:
    - name: {{ user.xdg.config | path_join(tplroot[5:]) }}
    - require:
      - {% endraw %}{{ cookiecutter.name }}{% raw %} configuration is cluttering $HOME for user '{{ user.name }}'

{% endraw %}{{ cookiecutter.name }}{% raw %} does not use XDG dirs during this salt run:
  environ.setenv:
    - value:
        CONF: false
    - false_unsets: true

  {%- if user.get('persistenv') %}
{% endraw %}{{ cookiecutter.name }}{% raw %} is ignorant about XDG location for user '{{ user.name }}':
  file.replace:
    - name: {{ user.home | path_join(user.persistenv) }}
    - text: ^{{ 'export CONF="${XDG_CONFIG_HOME:-$HOME/.config}/' ~ tplroot[5:] ~ '"' | regex_escape }}$
    - repl: ''
    - ignore_if_missing: true
  {%- endif %}
{%- endfor %}{% endraw %}
