# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as {= cookiecutter.abbr_pysafe =} with context %}

{%- for user in {= cookiecutter.abbr_pysafe =}.users | rejectattr('xdg', 'sameas', False) | list %}

{= cookiecutter.name =} configuration is cluttering $HOME for user '{{ user.name }}':
  file.rename:
    - name: {{ user.home | path_join({= cookiecutter.abbr_pysafe =}.lookup.config.default_confdir) }}
    - source: {{ user.xdg.config | path_join(tplroot[5:]) }}

{= cookiecutter.name =} does not have its config folder in XDG_CONFIG_HOME for user '{{ user.name }}':
  file.absent:
    - name: {{ user.xdg.config | path_join(tplroot[5:]) }}
    - require:
      - {= cookiecutter.name =} configuration is cluttering $HOME for user '{{ user.name }}'

{= cookiecutter.name =} does not use XDG dirs during this salt run:
  environ.setenv:
    - value:
        CONF: false
    - false_unsets: true

  {%- if user.get('persistenv') %}
{= cookiecutter.name =} is ignorant about XDG location for user '{{ user.name }}':
  file.replace:
    - name: {{ user.home | path_join(user.persistenv) }}
    - text: ^{{ 'export CONF="${XDG_CONFIG_HOME:-$HOME/.config}/' ~ tplroot[5:] ~ '"' | regex_escape }}$
    - repl: ''
    - ignore_if_missing: true
  {%- endif %}
{%- endfor %}
