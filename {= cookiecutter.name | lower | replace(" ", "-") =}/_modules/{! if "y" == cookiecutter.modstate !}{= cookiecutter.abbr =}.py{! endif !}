"""
{= cookiecutter.abbr =} salt execution module
======================================================

"""

import salt.utils.platform
from salt.exceptions import CommandExecutionError

__virtualname__ = "{= cookiecutter.abbr =}"


def __virtual__():
    return __virtualname__


def _which(user=None):
    if e := __salt__["cmd.run_stdout"]("command -v test", runas=user):
        return e
    if salt.utils.platform.is_darwin():
        if p := __salt__["cmd.run_stdout"]("brew --prefix test", runas=user):
            return p
        for f in ["/opt/homebrew/bin", "/usr/local/bin"]:
            if p := salt["cmd.run_stdout"](
                "test -s {}/test && echo {}/test".format(f, f), runas=user
            ):
                return p
    raise CommandExecutionError("Could not find test executable.")


def is_installed(name, user=None):
    """
    Checks whether a package with this name is installed by {= cookiecutter.abbr =}.

    name
        The name of the package to check.

    user
        The username to check for. Defaults to salt user.

    """
    return name in _list_installed(user)


def install(name, user=None):
    """
    Installs package with {= cookiecutter.abbr =}.

    name
        The name of the package to install.

    user
        The username to install the package for. Defaults to salt user.

    """
    e = _which(user)

    return not __salt__["cmd.retcode"]("{} install '{}'".format(e, name), runas=user)


def remove(name, user=None):
    """
    Removes package from {= cookiecutter.abbr =}.

    name
        The name of the package to remove.

    user
        The username to remove the package for. Defaults to salt user.

    """
    e = _which(user)

    return not __salt__["cmd.retcode"]("{} uninstall '{}'".format(e, name), runas=user)


def upgrade(name, user=None):
    """
    Upgrades package installed with {= cookiecutter.abbr =}.

    name
        The name of the package to upgrade.

    user
        The username to upgrade the package for. Defaults to salt user.

    """
    e = _which(user)

    return not __salt__["cmd.retcode"]("{} upgrade '{}'".format(e, name), runas=user)


def _list_installed(user=None):
    e = _which(user)
    out = json.loads(
        __salt__["cmd.run_stdout"]("{} list".format(e), runas=user, raise_err=True)
    )
    if out:
        return _parse(out)
    raise CommandExecutionError("Something went wrong while calling test.")


def _parse(installed):
    pass
