# vim: ft=sls

{#-
    Removes the {= cookiecutter.name =} package.
{!- if cookiecutter.has_config_template == "y" or cookiecutter.has_configsync == "y" !}
    Has a dependency on `tool_{= cookiecutter.abbr_pysafe =}.config.clean`_.
{!- endif !}
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_config_clean = tplroot ~ ".config.clean" %}
{%- from tplroot ~ "/map.jinja" import mapdata as {= cookiecutter.abbr_pysafe =} with context %}

include:
  - {{ sls_config_clean }}
{!- if cookiecutter.needs_repo == "y" !}
  - {{ slsdotpath }}.repo.clean
{!- endif !}


{= cookiecutter.name =} is removed:
  pkg.removed:
    - name: {{ {= cookiecutter.abbr_pysafe =}.lookup.pkg.name }}
    - require:
      - sls: {{ sls_config_clean }}
