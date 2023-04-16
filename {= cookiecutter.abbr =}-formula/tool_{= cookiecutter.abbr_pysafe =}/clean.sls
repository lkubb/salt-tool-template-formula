# -*- coding: utf-8 -*-
# vim: ft=sls

{#-
    *Meta-state*.

    Undoes everything performed in the ``tool_{= cookiecutter.abbr_pysafe =}`` meta-state
    in reverse order.
#}

include:
{!- if cookiecutter.has_completions != "n" !}
  - .completions.clean
{!- endif !}
{!- if cookiecutter.has_service == "y" !}
  - .service.clean
{!- endif !}
{!- if cookiecutter.has_configsync == "y" or cookiecutter.has_config_template == "y" !}
  - .config.clean
{!- endif !}
  - .package.clean
