# Distribution

The preview is an ad hoc signed Apple-silicon build. It has not been notarized. macOS may refuse to open a downloaded preview. The source-build path is the supported fallback until a Developer ID release is available. Do not disable Gatekeeper or remove quarantine attributes as a routine installation step.

## Repeatable build

```sh
./script/build_app.sh debug
./script/package.sh
```

Artifacts are written to dist/ with a SHA-256 checksum. The package script compiles release mode; it does not stop a running app. No Ollama executable or model weights are bundled. The source currently targets macOS 14+, and native builds follow the build machine's architecture. The preview here is arm64; Intel builds require their own compilation and validation.

## Trusted distribution

Provide a valid Apple Developer ID Application signing identity in the keychain and a preconfigured notarytool keychain profile. The repository never contains these credentials.

```sh
SIGNING_IDENTITY='Developer ID Application: Your Name (TEAMID)' \
NOTARY_PROFILE='your-notary-profile' ./script/package.sh
```

The script applies hardened-runtime signing with microphone audio-input entitlement, submits the ZIP, waits for acceptance, staples and validates the ticket, then creates the final ZIP. Verify the shipped artifact with codesign, spctl, and stapler. No identity or notarization credentials were available during the first preview build; do not label its assets notarized.

## Release checklist

- Run offline checks and live Ollama smoke checks.
- Check first launch on a second Mac with no previous permissions/defaults.
- Check keyboard, voice permissions, unsupported recognition locale, empty/offline runtime, and image-model selection.
- Verify the actual Control-Space chord outside the app.
- Review only public-safe screenshots and demo content.
- Verify package checksums and inspect GitHub CI status.
- Publish a prerelease with known limits; promote only after signed/notarized artifacts and fresh-machine checks are complete.
