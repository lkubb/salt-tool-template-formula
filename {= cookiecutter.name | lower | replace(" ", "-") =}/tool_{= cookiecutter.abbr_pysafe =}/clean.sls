# -*- coding: utf-8 -*-
# vim: ft=sls

include:
{!- if 'n' != cookiecutter.has_completions !}
  - .completions.clean
{!- endif !}
{!- if 'y' == cookiecutter.has_service !}
  - .service.clean
{!- endif !}
{!- if 'y' == cookiecutter.has_configsync or 'y' == cookiecutter.has_config_template !}
  - .config.clean
{!- endif !}
  - .package.clean
