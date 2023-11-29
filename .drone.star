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

def job(compiler, cxxstd, os, variant='', stdlib='', defines='', cxxflags='', linkflags='', asan=False, ubsan=False, tsan=False, install='', add_llvm=False, name='', arch='amd64', packages=None, buildtype='boost', buildscript='drone', environment={}, image=None, **kwargs):
  if not name:
    name = compiler.replace('-', ' ')
    if stdlib:
      name += ' ' + stdlib
    name += ' cxxstd:' + cxxstd
  cxx = compiler.replace('gcc-', 'g++-')
  if packages == None:
    packages = compiler.replace('gcc-', 'g++-')
    if install:
      packages += ' ' + install

  env = dict(globalenv)
  env.update({
    'B2_COMPILER': compiler,
    'B2_CXXSTD': cxxstd,
  })
  if asan:
    privileged = True
    env.update({
      'B2_ASAN': '1',
      'DRONE_EXTRA_PRIVILEGED': 'True',
    })
    if not variant:
      variant = 'debug'
    if not defines:
      env['B2_DEFINES'] = 'BOOST_NO_STRESS_TEST=1'
  else:
    privileged = False
  if ubsan:
    env['B2_UBSAN'] = '1'
  if tsan:
    env['B2_TSAN'] = '1'
  if variant:
    env['B2_VARIANT'] = variant
  if stdlib:
    env['B2_STDLIB'] = stdlib
  if defines:
    env['B2_DEFINES'] = defines
  if cxxflags:
    env['B2_CXXFLAGS'] = cxxflags
  if linkflags:
    env['B2_LINKFLAGS'] = linkflags
  env.update(environment)

  if os.startswith('ubuntu'):
    if not image:
      image = 'cppalliance/droneubuntu%s:1' % os.split('-')[1].replace('.', '')
      if arch != 'amd64' and image.endswith(':1'):
        image = image[0:-1] + 'multiarch'
    if add_llvm:
      names = {
        '1604': 'xenial',
        '1804': 'bionic',
        '2004': 'focal',
        '2204': 'jammy',
      }
      kwargs['llvm_os'] = names[image.split('ubuntu')[-1].split(':')[0]] # get part between 'ubuntu' and ':'
      kwargs['llvm_ver'] = compiler.split('-')[1]
    # CUSTOM: ICU
    packages += ' libicu-dev'

    return linux_cxx(name, cxx, packages=packages, buildtype=buildtype, buildscript=buildscript, image=image, environment=env, privileged=privileged, **kwargs)
  elif os.startswith('freebsd'):
    if not image:
      image = os.split('-')[1]
    return freebsd_cxx(name, cxx, buildtype=buildtype, buildscript=buildscript, freebsd_version=image, environment=env, **kwargs)
  elif os.startswith('osx'):
    version = os.split('-')
    if len(version) == 2: # osx-<version>
      kwargs['osx_version'] = version[1]
    elif len(version) == 3: # osx-xcode-<version>
      kwargs['xcode_version'] = version[2]
    else: # osx-<version>-xcode-<version>
      kwargs['osx_version'] = version[1]
      kwargs['xcode_version'] = version[3]
    return osx_cxx(name, cxx, packages='', buildtype=buildtype, buildscript=buildscript, environment=env, **kwargs)

def main(ctx):
  return [
    # FreeBSD
    job(compiler='clang-10',  cxxstd='11,14,17,20', os='freebsd-13.1'),
    job(compiler='clang-15',  cxxstd='11,14,17,20', os='freebsd-13.1'),
    job(compiler='gcc-11',    cxxstd='11,14,17,20', os='freebsd-13.1', linkflags='-Wl,-rpath=/usr/local/lib/gcc11'),
  ]

# from https://github.com/boostorg/boost-ci
load("@boost_ci//ci/drone/:functions.star", "linux_cxx","windows_cxx","osx_cxx","freebsd_cxx")
