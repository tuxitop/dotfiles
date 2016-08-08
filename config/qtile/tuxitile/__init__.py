# Copyright (c) 2014 Rock Neurotiko
# Copyright (c) 2014 roger
# Copyright (c) 2015 David R. Andersen
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
import logging
import traceback
import importlib
logger = logging.getLogger('qtile')


def safe_import(module_name, class_name):
    """
    try to import a module, and if it fails because an ImporError
    it logs on WARNING, and logs the traceback on DEBUG level
    """
    if type(class_name) is list:
        for name in class_name:
            safe_import(module_name, name)
        return
    package = __package__
    # python 3.2 don't set __package__
    if not package:
        package = __name__
    try:
        module = importlib.import_module(module_name, package)
        globals()[class_name] = getattr(module, class_name)
    except ImportError as error:
        msg = "Can't Import Widget: '%s.%s', %s"
        logger.warn(msg % (module_name, class_name, error))
        logger.debug(traceback.format_exc())

safe_import(".keyboardkbdd", "KeyboardKbdd")
safe_import(".check_updates", "CheckUpdates")
