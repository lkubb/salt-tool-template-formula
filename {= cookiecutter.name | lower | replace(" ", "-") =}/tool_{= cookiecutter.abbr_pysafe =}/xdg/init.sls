# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as {= cookiecutter.abbr_pysafe =} with context %}


include:
  - {{ tplroot }}.package

{%- for user in {= cookiecutter.abbr_pysafe =}.users | rejectattr('xdg', 'sameas', False) | list %}

# workaround for file.rename not supporting user/group/mode for makedirs
{= cookiecutter.name =} has its config dir in XDG_CONFIG_HOME for user '{{ user.name }}':
  file.directory:
    - name: {{ user.xdg.config | path_join('{= cookiecutter.pkg =}') }}
    - user: {{ user.name }}
    - group: {{ user.group }}
    - mode: '0700'
    - makedirs: true
    - onlyif:
      - test -e '{{ user.home | path_join({= cookiecutter.abbr_pysafe =}.lookup.config.default_confdir) }}'

Existing {= cookiecutter.name =} configuration is migrated for user '{{ user.name }}':
  file.rename:
    - name: {{ user.xdg.config | path_join('{= cookiecutter.pkg =}'{! if 'y' == cookiecutter.has_conffile_only !}{= ', ' ~ cookiecutter.abbr_pysafe ~ '.lookup.config.default_xdg_conffile' =}{! endif !}) }}
    - source: {{ user.home | path_join({= cookiecutter.abbr_pysafe =}.lookup.config.default_conf{= 'file' if 'y' == cookiecutter.has_conffile_only else 'dir' =}) }}
    - require:
      - {= cookiecutter.name =} has its config dir in XDG_CONFIG_HOME for user '{{ user.name }}'
    - require_in:
      - {= cookiecutter.name =} setup is completed

{= cookiecutter.name =} has its config file in XDG_CONFIG_HOME for user '{{ user.name }}':
  file.managed:
    - name: {{ user.xdg.config | path_join('{= cookiecutter.pkg =}', {= cookiecutter.abbr_pysafe =}.lookup.config.default_xdg_conffile) }}
    - user: {{ user.name }}
    - group: {{ user.group }}
    - replace: False
    - makedirs: True
    - mode: '0600'
    - dir_mode: '0700'
    - require:
      - Existing {= cookiecutter.name =} configuration is migrated for user '{{ user.name }}'
    - require_in:
      - {= cookiecutter.name =} setup is completed

{= cookiecutter.name =} uses XDG dirs during this salt run:
  environ.setenv:
    - value:
        CONF: {{ user.xdg.config | path_join('{= cookiecutter.pkg =}', {= cookiecutter.abbr_pysafe =}.lookup.config.default_xdg_conffile) }}
    - require_in:
      - {= cookiecutter.name =} setup is completed

  {%- if user.get('persistenv') %}

persistenv file for {= cookiecutter.name =} exists for user '{{ user.name }}':
  file.managed:
    - name: {{ user.home | path_join(user.persistenv) }}
    - user: {{ user.name }}
    - group: {{ user.group }}
    - replace: false
    - mode: '0600'
    - dir_mode: '0700'
    - makedirs: true

{= cookiecutter.name =} knows about XDG location for user '{{ user.name }}':
  file.append:
    - name: {{ user.home | path_join(user.persistenv) }}
    - text: export CONF="${XDG_CONFIG_HOME:-$HOME/.config}/{= cookiecutter.pkg =}"
    - user: {{ user.name }}
    - group: {{ user.group }}
    - mode: '0600'
    - require_in:
      - {= cookiecutter.name =} setup is completed
  {%- endif %}
{%- endfor %}
