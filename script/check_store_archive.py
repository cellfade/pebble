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
manifest = plistlib.loads((resources / 'PrivacyInfo.xcprivacy').read_bytes())
assert manifest['NSPrivacyTracking'] is False
assert not manifest['NSPrivacyCollectedDataTypes']
entitlements = plistlib.loads(pathlib.Path('Resources/AppStore.entitlements').read_bytes())
assert entitlements['com.apple.security.app-sandbox'] is True
assert not entitlements.get('com.apple.security.network.client', False)
report = dict(status='unsigned_not_submittable', version=info['CFBundleShortVersionString'],
              build=info['CFBundleVersion'], architectures=architectures,
              minimumOS=info['LSMinimumSystemVersion'],
              checks=['actual Xcode archive', 'arm64 executable', 'compiled assets', 'privacy manifest', 'declared Store entitlements'],
              remaining=['distribution signature and provisioning', 'Organizer validation', 'signed runtime UAT', 'App Store Connect submission'])
(archive.parent / 'store-archive-validation.json').write_text(json.dumps(report, indent=2) + '\n')
print(json.dumps(report, indent=2))
