#!/usr/bin/env python
import os,sys,re
# Actually I'm copying from epylint
from subprocess import Popen, PIPE

from pylint.lint import version
from distutils.version import StrictVersion

def lint(filename):
    """Pylint the given file.

    When run from emacs we will be in the directory of a file, and passed its filename.
    If this file is part of a package and is trying to import other modules from within
    its own package or another package rooted in a directory below it, pylint will classify
    it as a failed import.

    To get around this, we traverse down the directory tree to find the root of the package this
    module is in.  We then invoke pylint from this directory.

    Finally, we must correct the filenames in the output generated by pylint so Emacs doesn't
    become confused (it will expect just the original filename, while pylint may extend it with
    extra directories if we've traversed down the tree)
    """
    # traverse downwards until we are out of a python package
    fullPath = os.path.abspath(filename)
    parentPath, childPath = os.path.dirname(fullPath), os.path.basename(fullPath)

    while parentPath != "/" and os.path.exists(os.path.join(parentPath, '__init__.py')):
        childPath = os.path.join(os.path.basename(parentPath), childPath)
        parentPath = os.path.dirname(parentPath)

    # Start pylint
    if StrictVersion(version) > StrictVersion("0.21.0"):
        command = "pylint -f parseable -r n --disable=C,R,I '%s'"
    else:
        command = "pylint -f parseable -r n --disable-msg-cat=CRI '%s'" 

    process = Popen(command %
                    childPath, shell=True, stdout=PIPE, stderr=PIPE,
                    cwd=parentPath)
    
    p = process.stdout

    # The parseable line format is '%(path)s:%(line)s: [%(sigle)s%(obj)s] %(msg)s'
    # NOTE: This would be cleaner if we added an Emacs reporter to pylint.reporters.text ..
    regex = re.compile(r"\[(?P<type>[WE])(?P<remainder>.*?)\]")

    def _replacement(mObj):
        "Alter to include 'Error' or 'Warning'"
        if mObj.group("type") == "W":
            replacement = "Warning"
        else:
            replacement = "Error"
        # replace as "Warning (W0511, funcName): Warning Text"
        return "%s (%s%s):" % (replacement, mObj.group("type"), mObj.group("remainder"))

    for line in p:
        # remove pylintrc warning
        if line.startswith("No config file found"):
            continue
        line = regex.sub(_replacement, line, 1)
        # modify the file name thats output to reverse the path traversal we made
        parts = line.split(":")
        if parts and parts[0] == childPath:
            line = ":".join([filename] + parts[1:])
        print line,

    p.close()

if __name__ == '__main__':
    lint(sys.argv[1])
