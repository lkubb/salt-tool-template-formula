# -*- coding: utf-8 -*-
# vim: ft=sls

{#-
    Removes {= cookiecutter.name =} XDG compatibility crutches for all managed users.
#}

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as {= cookiecutter.abbr_pysafe =} with context %}


{%- for user in {= cookiecutter.abbr_pysafe =}.users | rejectattr('xdg', 'sameas', false) %}

{%-   set user_default_conf = user.home | path_join({= cookiecutter.abbr_pysafe =}.lookup.paths.confdir{! if 'y' == cookiecutter.has_conffile_only !}, {= cookiecutter.abbr_pysafe =}.lookup.paths.conffile{! endif !}) %}
{%-   set user_xdg_confdir = user.xdg.config | path_join({= cookiecutter.abbr_pysafe =}.lookup.paths.xdg_dirname) %}
{%-   set user_xdg_conffile = user_xdg_confdir | path_join({= cookiecutter.abbr_pysafe =}.lookup.paths.xdg_conffile) %}

{= cookiecutter.name =} configuration is cluttering $HOME for user '{{ user.name }}':
  file.rename:
    - name: {{ user_default_conf }}
    - source: {{ {= 'user_xdg_conffile' if 'y' == cookiecutter.has_conffile_only else 'user_xdg_confdir' =} }}

{= cookiecutter.name =} does not have its config folder in XDG_CONFIG_HOME for user '{{ user.name }}':
  file.absent:
    - name: {{ user_xdg_confdir }}
    - require:
      - {= cookiecutter.name =} configuration is cluttering $HOME for user '{{ user.name }}'

{= cookiecutter.name =} does not use XDG dirs during this salt run:
  environ.setenv:
    - value:
        CONF: false
    - false_unsets: true

{%-   if user.get('persistenv') %}

{= cookiecutter.name =} is ignorant about XDG location for user '{{ user.name }}':
  file.replace:
    - name: {{ user.home | path_join(user.persistenv) }}
    - text: ^{{ 'export CONF="${XDG_CONFIG_HOME:-$HOME/.config}/' ~ {= cookiecutter.abbr_pysafe =}.lookup.paths.xdg_dirname |
                path_join({= cookiecutter.abbr_pysafe =}.lookup.paths.xdg_conffile) ~ '"' | regex_escape }}$
    - repl: ''
    - ignore_if_missing: true
{%-   endif %}
{%- endfor %}
