"""
{= cookiecutter.abbr =} salt state module
======================================================

"""

# import logging
import salt.exceptions

# import salt.utils.platform

# log = logging.getLogger(__name__)

__virtualname__ = "{= cookiecutter.abbr =}"


def __virtual__():
    return __virtualname__


def installed(name, user=None):
    """
    Make sure program is installed with {= cookiecutter.abbr =}.

    CLI Example:

    .. code-block:: bash

        salt '*' {= cookiecutter.abbr =}.installed example user=user

    name
        The name of the program to install, if not installed already.

    user
        The username to install the program for. Defaults to salt user.

    """
    ret = {"name": name, "result": True, "comment": "", "changes": {}}

    try:
        if __salt__["test.is_installed"](name, user):
            ret["comment"] = "Program is already installed with test."
        elif __opts__["test"]:
            ret["result"] = None
            ret[
                "comment"
            ] = "Program '{}' would have been installed for user '{}'.".format(
                name, user
            )
            ret["changes"] = {"installed": name}
        elif __salt__["test.install"](name, user):
            ret["comment"] = "Program '{}' was installed for user '{}'.".format(
                name, user
            )
            ret["changes"] = {"installed": name}
        else:
            ret["result"] = False
            ret["comment"] = "Something went wrong while calling test."
    except salt.exceptions.CommandExecutionError as e:
        ret["result"] = False
        ret["comment"] = str(e)

    return ret


def latest(name, user=None):
    """
    Make sure program is installed with {= cookiecutter.abbr =} and is up to date.

    CLI Example:

    .. code-block:: bash

        salt '*' {= cookiecutter.abbr =}.latest example user=user

    name
        The name of the program to upgrade or install.

    user
        The username to install the program for. Defaults to salt user.

    """
    ret = {"name": name, "result": True, "comment": "", "changes": {}}

    try:
        if __salt__["test.is_installed"](name, user):
            if __opts__["test"]:
                ret["result"] = None
                ret[
                    "comment"
                ] = "Program '{}' would have been upgraded for user '{}'.".format(
                    name, user
                )
                ret["changes"] = {"installed": name}
            elif __salt__["test.upgrade"](name, user):
                ret["comment"] = "Program '{}' was upgraded for user '{}'.".format(
                    name, user
                )
                ret["changes"] = {"upgraded": name}
            else:
                ret["result"] = False
                ret["comment"] = "Something went wrong while calling mas."
        elif __opts__["test"]:
            ret["result"] = None
            ret[
                "comment"
            ] = "Program '{}' would have been installed for user '{}'.".format(
                name, user
            )
            ret["changes"] = {"installed": name}
        elif __salt__["test.install"](name, user):
            ret["comment"] = "Program '{}' was installed for user '{}'.".format(
                name, user
            )
            ret["changes"] = {"installed": name}
        else:
            ret["result"] = False
            ret["comment"] = "Something went wrong while calling test."
        return ret

    except salt.exceptions.CommandExecutionError as e:
        ret["result"] = False
        ret["comment"] = str(e)

    return ret


def absent(name, user=None):
    """
    Make sure {= cookiecutter.abbr =} installation of program is removed.

    CLI Example:

    .. code-block:: bash

        salt '*' {= cookiecutter.abbr =}.absent example user=user

    name
        The name of the program to remove, if installed.

    user
        The username to remove the program for. Defaults to salt user.

    """
    ret = {"name": name, "result": True, "comment": "", "changes": {}}

    try:
        if not __salt__["test.is_installed"](name, user):
            ret["comment"] = "Program is already absent from test."
        elif __opts__["test"]:
            ret["result"] = None
            ret[
                "comment"
            ] = "Program '{}' would have been removed for user '{}'.".format(name, user)
            ret["changes"] = {"installed": name}
        elif __salt__["test.remove"](name, user):
            ret["comment"] = "Program '{}' was removed for user '{}'.".format(
                name, user
            )
            ret["changes"] = {"installed": name}
        else:
            ret["result"] = False
            ret["comment"] = "Something went wrong while calling test."
    except salt.exceptions.CommandExecutionError as e:
        ret["result"] = False
        ret["comment"] = str(e)

    return ret
