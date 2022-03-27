# -*- coding: utf-8 -*-
# vim: ft=sls

{% raw %}{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as {% endraw %}{{ cookiecutter.abbr_pysafe }}{% raw %} with context %}


include:
  - {{ tplroot }}.package

{%- for user in {% endraw %}{{ cookiecutter.abbr_pysafe }}{% raw %}.users | rejectattr('xdg', 'sameas', False) | list %}

Existing {% endraw %}{{ cookiecutter.name }}{% raw %} configuration is migrated for user '{{ user.name }}':
  file.rename:
    - name: {{ salt["file.join"](user.xdg.config, {% endraw %}'{{ cookiecutter.abbr }}'{% raw %}) }}
    - source: {{ salt["file.join"](user.home, {% endraw %}{{ cookiecutter.abbr_pysafe }}{% raw %}.default_confdir) }}
    - onlyif:
      - test -e {{ salt["file.join"](user.home, {% endraw %}{{ cookiecutter.abbr_pysafe }}{% raw %}.default_confdir) }}
    - makedirs: true
    - require_in:
      - {% endraw %}{{ cookiecutter.name }}{% raw %} setup is completed

{% endraw %}{{ cookiecutter.name }}{% raw %} has its config file in XDG_CONFIG_HOME for user '{{ user.name }}':
  file.managed:
    - name: {{ salt["file.join"](user.xdg.config, {% endraw %}'{{ cookiecutter.abbr }}'{% raw %}, 'config') }}
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
        CONF: {{ salt["file.join"](user.xdg.config, {% endraw %}'{{ cookiecutter.abbr }}'{% raw %}, 'config') }}
    - require_in:
      - {% endraw %}{{ cookiecutter.name }}{% raw %} setup is completed

  {%- if user.get('persistenv') %}
{% endraw %}{{ cookiecutter.name }}{% raw %} knows about XDG location for user '{{ user.name }}':
  file.append:
    - name: {{ salt["file.join"](user.home, user.persistenv) }}
    - text: export CONF="${XDG_CONFIG_HOME:-$HOME/.config}/{% endraw %}{{ cookiecutter.abbr }}{% raw %}"
    - user: {{ user.name }}
    - group: {{ user.group }}
    - mode: '0600'
    - require_in:
      - {% endraw %}{{ cookiecutter.name }}{% raw %} setup is completed
  {%- endif %}
{%- endfor %}{%- endraw %}
