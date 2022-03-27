# -*- coding: utf-8 -*-
# vim: ft=sls

{% raw %}{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_config_file = tplroot ~ '.config.file' %}
{%- from tplroot ~ "/map.jinja" import mapdata as {% endraw %}{{ cookiecutter.abbr_pysafe }}{% raw %} with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

include:
  - {{ sls_config_file }}

tool-{% endraw %}{{ cookiecutter.abbr }}{% raw %}-subcomponent-config-file-file-managed:
  file.managed:
    - name: {{ {% endraw %}{{ cookiecutter.abbr_pysafe }}{% raw %}.subcomponent.config }}
    - source: {{ files_switch(['subcomponent-example.tmpl'],
                              lookup='tool-{% endraw %}{{ cookiecutter.abbr }}{% raw %}-subcomponent-config-file-file-managed',
                              use_subpath=True
                 )
              }}
    - mode: 644
    - user: root
    - group: {{ {% endraw %}{{ cookiecutter.abbr_pysafe }}{% raw %}.rootgroup }}
    - makedirs: True
    - template: jinja
    - require_in:
      - sls: {{ sls_config_file }}{% endraw %}
