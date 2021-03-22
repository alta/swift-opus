// swift-tools-version:5.3
import PackageDescription

let package = Package(
	name: "Opus",
	platforms: [
		.macOS(.v10_12),
		.iOS(.v12),
		.tvOS(.v12),
		.watchOS(.v6),
	],
	products: [
		.library(
			name: "Copus",
			targets: ["Copus"]
		),
		.library(
			name: "Opus",
			targets: ["Opus", "Copus"]
		),
	],
	dependencies: [],
	targets: [
		.target(
			name: "Copus",
			dependencies: [],
			exclude: [
				"AUTHORS",
				"autogen.sh",
				"celt_headers.mk",
				"celt_sources.mk",
				"celt/arm",
				"celt/dump_modes",
				"celt/meson.build",
				"celt/opus_custom_demo.c",
				"celt/tests",
				"celt/x86",
				"ChangeLog",
				"cmake",
				"CMakeLists.txt",
				"configure.ac",
				"COPYING",
				"doc",
				"include/meson.build",
				"LICENSE_PLEASE_READ.txt",
				"m4",
				"m4/opus-intrinsics.m4",
				"Makefile.am",
				"Makefile.mips",
				"Makefile.unix",
				"meson_options.txt",
				"meson.build",
				"meson",
				"NEWS",
				"opus_headers.mk",
				"opus_sources.mk",
				"opus-uninstalled.pc.in",
				"opus.m4",
				"opus.pc.in",
				"README.draft",
				"README",
				"releases.sha2",
				"scripts/dump_rnn.py",
				"scripts/rnn_train.py",
				"silk_headers.mk",
				"silk_sources.mk",
				"silk/arm",
				"silk/fixed",
				"silk/meson.build",
				"silk/mips",
				"silk/tests",
				"silk/x86",
				"src/meson.build",
				"src/opus_compare.c",
				"src/opus_demo.c",
				"src/repacketizer_demo.c",
				"tests",
				"training",
				"update_version",
				"win32",
			],
			publicHeadersPath: "include",
			cSettings: [
				.headerSearchPath("."),
				.headerSearchPath("celt"),
				.headerSearchPath("celt/x86"),
				.headerSearchPath("silk"),
				.headerSearchPath("silk/float"),

				.define("OPUS_BUILD"),
				.define("VAR_ARRAYS", to: "1"),
				.define("FLOATING_POINT"), // Enable Opus floating-point mode

				.define("HAVE_DLFCN_H", to: "1"),
				.define("HAVE_INTTYPES_H", to: "1"),
				.define("HAVE_LRINT", to: "1"),
				.define("HAVE_LRINTF", to: "1"),
				.define("HAVE_MEMORY_H", to: "1"),
				.define("HAVE_STDINT_H", to: "1"),
				.define("HAVE_STDLIB_H", to: "1"),
				.define("HAVE_STRING_H", to: "1"),
				.define("HAVE_STRINGS_H", to: "1"),
				.define("HAVE_SYS_STAT_H", to: "1"),
				.define("HAVE_SYS_TYPES_H", to: "1"),
				.define("HAVE_UNISTD_H", to: "1"),
			]
		),
		.target(
			name: "Opus",
			dependencies: ["Copus"]
		),
		.testTarget(
			name: "OpusTests",
			dependencies: ["Opus"],
			resources: [.copy("Resources")]
		),
	]
)
