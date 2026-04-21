Pod::Spec.new do |s|
  s.name = 'Opus'
  s.version = '1.0.0'
  s.summary = 'Type-safe Swift bindings for the Opus audio codec on Apple platforms.'
  s.description = <<-DESC
    Swift Opus wraps the upstream Opus C sources and exposes a small Swift API
    for encoding and decoding AVAudioPCMBuffer values on Apple platforms.
  DESC
  s.homepage = 'https://github.com/alta/swift-opus'
  s.license = { :type => 'BSD-3-Clause', :file => 'LICENSE' }
  s.author = 'ydnar'
  s.source = {
    :git => 'https://github.com/alta/swift-opus.git',
    :tag => s.version.to_s,
    :submodules => true
  }

  s.swift_version = '5.3'
  s.platforms = {
    :ios => '12.0',
    :osx => '10.12',
    :tvos => '12.0',
    :watchos => '6.0'
  }

  s.source_files = 'Sources/Opus/**/*.swift', 'Sources/Copus/**/*.c', 'Sources/Copus/**/*.h'
  s.public_header_files = 'Sources/Copus/include/**/*.h'
  s.private_header_files = 'Sources/Copus/{celt,silk,src}/**/*.h', 'Sources/Copus/silk/float/**/*.h'
  s.pod_target_xcconfig = {
    'HEADER_SEARCH_PATHS' => [
      '"$(PODS_TARGET_SRCROOT)/Sources/Copus"',
      '"$(PODS_TARGET_SRCROOT)/Sources/Copus/celt"',
      '"$(PODS_TARGET_SRCROOT)/Sources/Copus/silk"',
      '"$(PODS_TARGET_SRCROOT)/Sources/Copus/silk/float"'
    ].join(' '),
    'OTHER_CFLAGS' => [
      '-DOPUS_BUILD',
      '-DVAR_ARRAYS=1',
      '-DFLOATING_POINT',
      '-DHAVE_DLFCN_H=1',
      '-DHAVE_INTTYPES_H=1',
      '-DHAVE_LRINT=1',
      '-DHAVE_LRINTF=1',
      '-DHAVE_MEMORY_H=1',
      '-DHAVE_STDINT_H=1',
      '-DHAVE_STDLIB_H=1',
      '-DHAVE_STRING_H=1',
      '-DHAVE_STRINGS_H=1',
      '-DHAVE_SYS_STAT_H=1',
      '-DHAVE_SYS_TYPES_H=1',
      '-DHAVE_UNISTD_H=1'
    ].join(' ')
  }

  s.exclude_files = [
    'Sources/Copus/AUTHORS',
    'Sources/Copus/autogen.sh',
    'Sources/Copus/celt_headers.mk',
    'Sources/Copus/celt_sources.mk',
    'Sources/Copus/celt/arm',
    'Sources/Copus/celt/dump_modes',
    'Sources/Copus/celt/meson.build',
    'Sources/Copus/celt/opus_custom_demo.c',
    'Sources/Copus/celt/tests',
    'Sources/Copus/celt/x86',
    'Sources/Copus/ChangeLog',
    'Sources/Copus/cmake',
    'Sources/Copus/CMakeLists.txt',
    'Sources/Copus/configure.ac',
    'Sources/Copus/COPYING',
    'Sources/Copus/doc',
    'Sources/Copus/include/meson.build',
    'Sources/Copus/LICENSE_PLEASE_READ.txt',
    'Sources/Copus/m4',
    'Sources/Copus/Makefile*',
    'Sources/Copus/meson*',
    'Sources/Copus/NEWS',
    'Sources/Copus/opus_headers.mk',
    'Sources/Copus/opus_sources.mk',
    'Sources/Copus/opus*.pc*',
    'Sources/Copus/README*',
    'Sources/Copus/releases.sha2',
    'Sources/Copus/scripts/*',
    'Sources/Copus/silk_headers.mk',
    'Sources/Copus/silk_sources.mk',
    'Sources/Copus/silk/arm',
    'Sources/Copus/silk/fixed',
    'Sources/Copus/silk/meson.build',
    'Sources/Copus/silk/mips',
    'Sources/Copus/silk/tests',
    'Sources/Copus/silk/x86',
    'Sources/Copus/src/meson.build',
    'Sources/Copus/src/opus_compare.c',
    'Sources/Copus/src/opus_demo.c',
    'Sources/Copus/src/repacketizer_demo.c',
    'Sources/Copus/tests',
    'Sources/Copus/training',
    'Sources/Copus/update_version',
    'Sources/Copus/win32'
  ]
end
