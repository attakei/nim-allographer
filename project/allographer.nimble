# Package

version       = "0.2.0"
author        = "Hidenobu Itsumura"
description   = "A Nim query builder library inspired by Laravel/PHP and Orator/Python"
license       = "MIT"
srcDir        = "project/src"

backend       = "cpp"

# Dependencies

requires "nim >= 1.0.0"
requires "bcrypt >= 0.2.1"
requires "cligen >= 0.9.38"

# skipDirs = @["tests"]
# skipExt = @["sh"]