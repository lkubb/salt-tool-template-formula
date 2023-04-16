# vim: ft=sls

{#-
    Removes the configuration of the {= cookiecutter.name =} {! if cookiecutter.has_service == "y" !}service and has a
    dependency on `tool_{= cookiecutter.abbr_pysafe =}.service.clean`_{! else !}package{! endif !}.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{!- if cookiecutter.has_service == "y" !}
{%- set sls_service_clean = tplroot ~ ".service.clean" %}
{!- endif !}
{%- from tplroot ~ "/map.jinja" import mapdata as {= cookiecutter.abbr_pysafe =} with context %}

{!- if cookiecutter.has_service == "y" !}

include:
  - {{ sls_service_clean }}
{!- endif !}


{%- for user in {= cookiecutter.abbr_pysafe =}.users {! if cookiecutter.has_config_template == "y" !}| selectattr("{= cookiecutter.abbr_pysafe =}.config", "defined") | selectattr("{= cookiecutter.abbr_pysafe =}.config") {! endif !}%}

{= cookiecutter.name =} config file is cleaned for user '{{ user.name }}':
  file.absent:
    - name: {{ user["_{= cookiecutter.abbr_pysafe =}"].conffile }}
{!- if cookiecutter.has_service == "y" !}
    - require:
      - sls: {{ sls_service_clean }}
{!- endif !}

{!- if cookiecutter.has_conffile_only == "n" or cookiecutter.has_xdg == "y" !}
{!-   if cookiecutter.has_xdg == "y" and cookiecutter.needs_xdg_help == "y" !}

{%-   if user.xdg %}
{!-   endif !}

{= cookiecutter.name =} config dir is absent for user '{{ user.name }}':
  file.absent:
    - name: {{ user["_{= cookiecutter.abbr_pysafe =}"].confdir }}
{!-   if cookiecutter.has_xdg == "y" and cookiecutter.needs_xdg_help == "y" !}
{%-   endif %}
{!-   endif !}
{!- endif !}
{%- endfor %}
