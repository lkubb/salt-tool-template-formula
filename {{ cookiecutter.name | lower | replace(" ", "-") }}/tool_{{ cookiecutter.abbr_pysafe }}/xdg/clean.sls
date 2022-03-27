# -*- coding: utf-8 -*-
# vim: ft=sls

{% raw %}{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as {% endraw %}{{ cookiecutter.abbr_pysafe }}{% raw %} with context %}

{%- for user in {% endraw %}{{ cookiecutter.abbr_pysafe }}{% raw %}.users | rejectattr('xdg', 'sameas', False) | list %}

Existing {% endraw %}{{ cookiecutter.name }}{% raw %} configuration is reverted to default for user '{{ user.name }}':
  file.rename:
    - name: {{ salt["file.join"](user.home, {% endraw %}{{ cookiecutter.abbr_pysafe }}{% raw %}.default_confdir) }}
    - source: {{ salt["file.join"](user.xdg.config, {% endraw %}'{{ cookiecutter.abbr }}'{% raw %}) }}
    - onlyif:
      - test -e {{ salt["file.join"](user.xdg.config, {% endraw %}'{{ cookiecutter.abbr }}'{% raw %}) }}
    - makedirs: true

{% endraw %}{{ cookiecutter.name }}{% raw %} does not have its config file in XDG_CONFIG_HOME for user '{{ user.name }}':
  file.absent:
    - name: {{ salt["file.join"](user.xdg.config, {% endraw %}'{{ cookiecutter.abbr }}'{% raw %}, 'config') }}

{% endraw %}{{ cookiecutter.name }}{% raw %} does not use XDG dirs during this salt run:
  environ.setenv:
    - value:
        CONF: ''

  {%- if user.get('persistenv') %}
{% endraw %}{{ cookiecutter.name }}{% raw %} knows about XDG location for user '{{ user.name }}':
  file.replace:
    - name: {{ salt["file.join"](user.home, user.persistenv) }}
    - text: ^{{ 'export CONF="${XDG_CONFIG_HOME:-$HOME/.config}/{% endraw %}{{ cookiecutter.abbr }}{% raw %}"' | regex_escape }}$
    - repl: ''
    - ignore_if_missing: true
  {%- endif %}
{%- endfor %}{%- endraw %}
