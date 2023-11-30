# Use, modification, and distribution are
# subject to the Boost Software License, Version 1.0. (See accompanying
# file LICENSE.txt)
#
# Copyright Rene Rivera 2020.

# For Drone CI we use the Starlark scripting language to reduce duplication.
# As the yaml syntax for Drone CI is rather limited.
#
#
globalenv={'B2_CI_VERSION': '1', 'B2_VARIANT': 'release'}

def main(ctx):

  return generate(
        # Compilers
        ['gcc >=8.0',
         'clang >=10',
         # 'msvc >=14.1',
         'arm64-gcc latest',
         's390x-gcc latest',
         'freebsd-gcc latest',
         'apple-clang latest',
         'arm64-clang latest',
         # 's390x-clang latest',
         'freebsd-clang latest',
         # 'x86-msvc latest'
        ],
        # Standards
        '>=11',
        docs=False, ubsan=False, asan=False
  )


# from https://github.com/boostorg/boost-ci
load("@ci_automation//ci/drone/:functions.star", "linux_cxx","windows_cxx","osx_cxx","freebsd_cxx", "generate")
