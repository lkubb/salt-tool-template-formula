# -*- coding: utf-8 -*-
# vim: ft=sls

include:
  - .package
{!- if 'y' == cookiecutter.needs_xdg_help !}
  - .xdg
{!- endif !}
{!- if 'y' == cookiecutter.has_configsync or 'y' == cookiecutter.has_config_template !}
  - .config
{!- endif !}
{!- if 'y' == cookiecutter.has_service !}
  - .service
{!- endif !}
{!- if 'n' != cookiecutter.has_completions !}
  - .completions
{!- endif !}
