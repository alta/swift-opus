Pod::Spec.new do |s|
  s.name             = 'Opus'
  s.version          = '1.0.0'
  s.summary          = 'Swift + C implementation of the Opus audio codec.'
  s.description      = 'Contains the Opus C core (Copus) and a Swift wrapper (Opus).'
  s.homepage         = 'https://github.com/yourname/Opus'
  s.license          = { :type => 'BSD', :file => 'LICENSE' }
  s.author           = { 'Your Name' => 'your@email.com' }
  s.source           = { :git => 'https://github.com/yourname/Opus.git', :tag => s.version.to_s }

  # ✅ 支持的 Swift 版本
  s.swift_versions   = ['5.3', '5.4', '5.5', '5.6']

  # ✅ 平台
  s.platform     = :ios, '12.0'
  s.ios.deployment_target = '12.0'
  s.osx.deployment_target = '10.12'
  s.tvos.deployment_target = '12.0'
  s.watchos.deployment_target = '6.0'

  # ===========================================================
  # 子库 1️⃣：Copus (C 层)
  # ===========================================================
  s.subspec 'Copus' do |ss|
    ss.source_files = 'Sources/Copus/**/*.{c,h}'
    ss.public_header_files = 'Sources/Copus/include/**/*.h'
    ss.requires_arc = false

    ss.pod_target_xcconfig = {
      'HEADER_SEARCH_PATHS' => [
	'$(PODS_TARGET_SRCROOT)/Sources/Copus',
	'$(PODS_TARGET_SRCROOT)/Sources/Copus/celt',
	'$(PODS_TARGET_SRCROOT)/Sources/Copus/silk',
	'$(PODS_TARGET_SRCROOT)/Sources/Copus/silk/float'
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

    ss.exclude_files = [
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

  # ===========================================================
  # 子库 2️⃣：Opus (Swift 层)
  # ===========================================================
  s.subspec 'Swift' do |ss|
    ss.source_files = 'Sources/Opus/**/*.{swift,h}'
    ss.dependency 'Opus/Copus'
  end
end
