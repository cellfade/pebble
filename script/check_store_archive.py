#!/usr/bin/env python3
"""Inspect an actual unsigned archive; never label it submittable."""
import json, pathlib, plistlib, subprocess, sys
archive = pathlib.Path(sys.argv[1])
app = archive / 'Products/Applications/Pebble.app'
info = plistlib.loads((app / 'Contents/Info.plist').read_bytes())
assert info['LSMinimumSystemVersion'].startswith('26.'), 'Wrong Store minimum OS'
assert info['CFBundlePackageType'] == 'APPL'
assert '-' not in info['CFBundleShortVersionString'], 'Store version must be numeric'
executable = app / 'Contents/MacOS' / info['CFBundleExecutable']
architectures = subprocess.check_output(['lipo', '-archs', str(executable)], text=True).strip()
assert 'arm64' in architectures, 'Apple Intelligence Store edition requires arm64'
resources = app / 'Contents/Resources'
assert (resources / 'Assets.car').exists(), 'Compiled asset catalog missing'
assert (resources / 'PrivacyInfo.xcprivacy').exists(), 'Privacy manifest missing'
for name in ['AppIcon.png', 'MenuBarMark.pdf']:
    assert (resources / name).stat().st_size > 0, f'Packaged {name} missing'
manifest = plistlib.loads((resources / 'PrivacyInfo.xcprivacy').read_bytes())
assert manifest['NSPrivacyTracking'] is False
assert not manifest['NSPrivacyCollectedDataTypes']
reasons = {entry['NSPrivacyAccessedAPIType']: set(entry['NSPrivacyAccessedAPITypeReasons']) for entry in manifest['NSPrivacyAccessedAPITypes']}
assert 'CA92.1' in reasons.get('NSPrivacyAccessedAPICategoryUserDefaults', set())
assert '85F4.1' in reasons.get('NSPrivacyAccessedAPICategoryDiskSpace', set())
archive_info = plistlib.loads((archive / 'Info.plist').read_bytes())
assert archive_info['ApplicationProperties']['ApplicationPath'] == 'Applications/Pebble.app', 'Not an application archive'
build_info = subprocess.check_output(['xcrun', 'vtool', '-show-build', str(executable)], text=True)
assert 'minos 26.' in build_info, 'Mach-O deployment target must be macOS26'

entitlements = plistlib.loads(pathlib.Path('Resources/AppStore.entitlements').read_bytes())
assert entitlements['com.apple.security.app-sandbox'] is True
assert not entitlements.get('com.apple.security.network.client', False)
report = dict(status='unsigned_not_submittable', version=info['CFBundleShortVersionString'],
              build=info['CFBundleVersion'], architectures=architectures,
              minimumOS=info['LSMinimumSystemVersion'],
              checks=['actual application Xcode archive', 'arm64 executable and macOS26 Mach-O deployment', 'compiled assets and packaged avatar/menu mark', 'privacy manifest and required API reasons', 'declared Store entitlements'],
              remaining=['distribution signature and provisioning', 'Organizer validation', 'signed runtime UAT', 'App Store Connect submission'])
(archive.parent / 'store-archive-validation.json').write_text(json.dumps(report, indent=2) + '\n')
print(json.dumps(report, indent=2))
