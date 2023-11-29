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

# Wrapper function to apply the globalenv to all jobs
def job(
        # job specific environment options
        env={},
        **kwargs):
  real_env = dict(globalenv)
  real_env.update(env)
  return job_impl(env=real_env, **kwargs)

def main(ctx):
  return [
    # FreeBSD
    job(compiler='clang-10',  cxxstd='11,14,17,20', os='freebsd-13.1'),
    job(compiler='clang-11',  cxxstd='11,14,17,20', os='freebsd-13.1'),
    job(compiler='clang-12',  cxxstd='11,14,17,20', os='freebsd-13.1'),
    job(compiler='clang-13',  cxxstd='11,14,17,20', os='freebsd-13.1'),
    job(compiler='clang-14',  cxxstd='11,14,17,20', os='freebsd-13.1'),
    job(compiler='clang-15',  cxxstd='11,14,17,20', os='freebsd-13.1'),
    job(compiler='gcc-8',    cxxstd='11,14,17,20', os='freebsd-13.1', linkflags='-Wl,-rpath=/usr/local/lib/gcc8'),
    job(compiler='gcc-9',    cxxstd='11,14,17,20', os='freebsd-13.1', linkflags='-Wl,-rpath=/usr/local/lib/gcc9'),
    job(compiler='gcc-10',    cxxstd='11,14,17,20', os='freebsd-13.1', linkflags='-Wl,-rpath=/usr/local/lib/gcc10'),
    job(compiler='gcc-11',    cxxstd='11,14,17,20', os='freebsd-13.1', linkflags='-Wl,-rpath=/usr/local/lib/gcc11'),
  ]

# from https://github.com/boostorg/boost-ci
load("@boost_ci//ci/drone/:functions.star", "linux_cxx", "windows_cxx", "osx_cxx", "freebsd_cxx", "job_impl")