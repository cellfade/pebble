# Actual Store archive CI validation

Pass 3 · 29 October 2026, America/Denver. This route has now run successfully with the actual Xcode project. It produces an **unsigned, not-submittable** Store archive; it does not replace signing, provisioning, Organizer validation or App Review.

## Verified clean-runner result

[GitHub Actions run 40976673954](https://github.com/cellfade/pebble/actions/runs/40976673954) completed successfully for source `5f7a043ffdca377dd669428961db2a4c7fa07ee6`. Both the direct `build` job and `store-archive` job passed. The Store job selected `/Applications/Xcode_26.3.app/Contents/Developer`; its log reports Xcode26.3, SDK26.2 compile paths, `-DAPP_STORE`, arm64 macOS26.0 target, `actool` resource compilation and **ARCHIVE SUCCEEDED**.

The job invokes `script/validate_store_archive.sh`, which checks full Xcode major version, archives AppStore with `ARCHS=arm64`, and disables code signing explicitly. Its post-archive checker reported:

```json
{
  "status": "unsigned_not_submittable",
  "version": "0.3.0",
  "build": "4",
  "architectures": "arm64",
  "minimumOS": "26.0"
}
```

The `unsigned-store-validation` CI artifact contains the actual `Pebble-Unsigned.xcarchive` and `store-archive-validation.json`. Preserve the exact source/run identity when downloading or testing it. Later source changes require a new matching run rather than reusing this green status.

## Proven checks and precise limits

The checker reads the actual `Products/Applications/Pebble.app`, its Info.plist and executable architecture, requires compiled `Assets.car`, checks the packaged privacy manifest's no-tracking/no-collection fields, and verifies the declared Store entitlement file includes sandbox but no network-client permission. The archive log also records PNG, PDF and privacy resource copy steps. After download, the release owner ran the enhanced checker against the same archive; it additionally verified application-archive Info.plist type/path, nonempty packaged AppIcon.png/MenuBarMark.pdf, CA92.1/85F4.1 required-reason entries, and actual Mach-O macOS26 deployment. The Store reviewer independently inspected the archive/app plists, enhanced JSON and `otool -L` output, confirming the FoundationModels framework is linked.

These checks do **not** establish an Apple distribution signature, signed entitlements, a provisioning profile, export validation, Connect processing or App Review acceptance. The original CI checker was narrower; the enhanced checker and downloaded-artifact inspection extend that evidence as described above. Nonempty assets and compiled catalog presence do not prove every icon rendition is visually correct. Signed-runtime acceptance remains separate. Source entitlements are not evidence of a signed export's entitlements.

No model download or live Foundation Models test is implied. A macOS15 hosted runner can cross-archive the macOS26 target with the supported SDK; it cannot establish eligible hardware, model readiness, permissions, Safari effects, accessibility or real signed-device behavior.

## Repeatable owner route

```sh
DEVELOPER_DIR=/Applications/Xcode_26.3.app/Contents/Developer \
  ./script/validate_store_archive.sh
```

The [official runner inventory](https://github.com/actions/runner-images/blob/main/images/macos/macos-15-Readme.md) lists the selected toolchain; its default Xcode16.4 is insufficient. Toolchain availability can change, so fail loudly rather than silently skipping this gate.

A later signed archive uses the owner-selected team/profile/identity and the Apple-supported validation/distribution workflow. Keep Developer ID notarization for direct download separate from App Store distribution. Do not publish this unsigned archive as a consumer download.

## Final pass boundary

This is the third and final Store review pass for the requested cycle. Source5f7a043 has verified CI/archive evidence; a subsequent compact-UI and accessibility-announcement refactor needs its own matching clean-runner result before the final candidate can inherit this archive status. No fourth review pass is implied. The signed archive script now also fails fast when selected Xcode major version is below26.
