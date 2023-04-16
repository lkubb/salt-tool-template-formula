# -*- coding: utf-8 -*-
# vim: ft=sls

{#-
    *Meta-state*.

    Performs all operations described in this formula according to the specified configuration.
#}

include:
  - .package
{!- if cookiecutter.needs_xdg_help == "y" !}
  - .xdg
{!- endif !}
{!- if cookiecutter.has_configsync == "y" or cookiecutter.has_config_template == "y" !}
  - .config
{!- endif !}
{!- if cookiecutter.has_service == "y" !}
  - .service
{!- endif !}
{!- if cookiecutter.has_completions != "n" !}
  - .completions
{!- endif !}
