# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as {= cookiecutter.abbr_pysafe =} with context %}

include:
  - {{ tplroot }}.package


{%- for user in {= cookiecutter.abbr_pysafe =}.users | rejectattr("xdg", "sameas", false) %}

{%-   set user_default_conf = user.home | path_join({= cookiecutter.abbr_pysafe =}.lookup.paths.confdir{! if cookiecutter.has_conffile_only == "y" !}, {= cookiecutter.abbr_pysafe =}.lookup.paths.conffile{! endif !}) %}
{%-   set user_xdg_confdir = user.xdg.config | path_join({= cookiecutter.abbr_pysafe =}.lookup.paths.xdg_dirname) %}
{%-   set user_xdg_conffile = user_xdg_confdir | path_join({= cookiecutter.abbr_pysafe =}.lookup.paths.xdg_conffile) %}

# workaround for file.rename not supporting user/group/mode for makedirs
{= cookiecutter.name =} has its config dir in XDG_CONFIG_HOME for user '{{ user.name }}':
  file.directory:
    - name: {{ {= "user_xdg_confdir" if cookiecutter.has_conffile_only == "y" else "user.xdg.config" =} }}
    - user: {{ user.name }}
    - group: {{ user.group }}
    - mode: '0700'
    - makedirs: true
    - onlyif:
      - test -e '{{ user_default_conf }}'

Existing {= cookiecutter.name =} configuration is migrated for user '{{ user.name }}':
  file.rename:
    - name: {{ {= "user_xdg_confdir" if cookiecutter.has_conffile_only != "y" else "user_xdg_conffile" =} }}
    - source: {{ user_default_conf }}
    - require:
      - {= cookiecutter.name =} has its config dir in XDG_CONFIG_HOME for user '{{ user.name }}'
    - require_in:
      - {= cookiecutter.name =} setup is completed

{= cookiecutter.name =} has its config file in XDG_CONFIG_HOME for user '{{ user.name }}':
  file.managed:
    - name: {{ user_xdg_conffile }}
    - user: {{ user.name }}
    - group: {{ user.group }}
    - replace: false
    - makedirs: true
    - mode: '0600'
    - dir_mode: '0700'
    - require:
      - Existing {= cookiecutter.name =} configuration is migrated for user '{{ user.name }}'
    - require_in:
      - {= cookiecutter.name =} setup is completed

# @FIXME
# This actually does not make sense and might be harmful:
# Each file is executed for all users, thus this breaks
# when more than one is defined!
{= cookiecutter.name =} uses XDG dirs during this salt run:
  environ.setenv:
    - value:
        CONF: {{ user_xdg_conffile }}
    - require_in:
      - {= cookiecutter.name =} setup is completed

{%-   if user.get("persistenv") %}

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
    - text: export CONF="${XDG_CONFIG_HOME:-$HOME/.config}/{{ {= cookiecutter.abbr_pysafe =}.lookup.paths.xdg_dirname | path_join({= cookiecutter.abbr_pysafe =}.lookup.paths.xdg_conffile) }}"
    - require:
      - persistenv file for {= cookiecutter.name =} exists for user '{{ user.name }}'
    - require_in:
      - {= cookiecutter.name =} setup is completed
{%-   endif %}
{%- endfor %}
