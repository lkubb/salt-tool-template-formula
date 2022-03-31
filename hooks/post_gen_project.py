import os
import shutil

# hooks are not respecting jinja env vars atm
tool_root = 'tool_{{ cookiecutter.abbr_pysafe }}'

QUESTION_PATH_RM = [
    ('{{ cookiecutter.modstate }}', [
        '_modules',
        '_states',
        'docs/modules_execution',
        'docs/modules_state',
    ]),
    ('{{ cookiecutter.needs_repo }}', [tool_root + '/package/repo']),
    ('{{ cookiecutter.has_service }}', [tool_root + '/service']),
    ('{{ cookiecutter.has_configsync }}', [tool_root + '/config/sync.sls']),
    ('{{ cookiecutter.has_config_template }}', [tool_root + '/config/file.sls']),
    ('{{ "n" if cookiecutter.has_config_template == cookiecutter.has_configsync == "n" else "y" }}', [tool_root + '/config']),
    ('{{ cookiecutter.needs_xdg_help }}', [tool_root + '/xdg']),
    ('{{ cookiecutter.has_tests }}', ['test', 'kitchen.yml', 'Gemfile', 'Gemfile.lock', '.travis.yml', '.rubocop.yml'])
]


def remove(filepath):
    if os.path.isfile(filepath):
        os.remove(filepath)
    elif os.path.isdir(filepath):
        shutil.rmtree(filepath)


for question in QUESTION_PATH_RM:
    answer, paths = question

    if 'y' != answer:
        for path in paths:
            remove(path)
