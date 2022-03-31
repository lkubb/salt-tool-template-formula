# -*- coding: utf-8 -*-
# vim: ft=yaml
---
portage:
  sync_wait_one_day: true
tool_{= cookiecutter.abbr_pysafe =}:
  lookup:
    pkg:
      name: {= cookiecutter.pkg =}
    service:
      name: {= cookiecutter.pkg =}
