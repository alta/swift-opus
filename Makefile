all:
	swift test --generate-linuxmain
	swiftformat .
	swift test
