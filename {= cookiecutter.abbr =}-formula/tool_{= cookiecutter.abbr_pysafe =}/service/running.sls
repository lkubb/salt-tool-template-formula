# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{!- if cookiecutter.has_configsync == "y" or cookiecutter.has_config_template == "y" !}
{%- set sls_config_file = tplroot ~ ".config" %}
{!- endif !}
{%- from tplroot ~ "/map.jinja" import mapdata as {= cookiecutter.abbr_pysafe =} with context %}

{!- if cookiecutter.has_configsync == "y" or cookiecutter.has_config_template == "y" !}

include:
  - {{ sls_config_file }}
{!- endif !}


{= cookiecutter.name =} service is running:
  service.running:
    - name: {{ {= cookiecutter.abbr_pysafe =}.lookup.service.name }}
    - enable: true
{!- if cookiecutter.has_configsync == "y" or cookiecutter.has_config_template == "y" !}
    - watch:
      - sls: {{ sls_config_file }}
{!- endif !}
