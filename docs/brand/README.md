# Pebble identity

The owner selected the simple stone-and-ink character: a small, smooth neutral pebble, two floating black ink-dot eyes, and a single curved ink smile. There is no robot body, visor, antenna, coloured cheek light, or separate face panel. The cobalt robot and Peek directions are historical explorations, not active product artwork.

## Canonical assets

- `pebble.svg`: editable colour vector mark, with a neutral stone gradient and ink face. It contains real paths rather than embedded raster pixels.
- `pebble-mono.svg`: single-ink outline and face using `currentColor`.
- `../../Resources/AppIcon-source.png`: approved 1254×1254 raster master. Built-in image generation created the stone icon; packaging only resizes the approved image mechanically.
- `../../Resources/AppIcon.png`: 256×256 in-app rendition.
- `../../Resources/AppIcon.icns`: complete macOS icon set, from 16 pixels through 1024 pixels.
- `../../Resources/Assets.xcassets/AppIcon.appiconset`: the ten matching Mac App Store/Xcode icon renditions and catalog manifest.
- `../../Resources/MenuBarMark.pdf`: vector template mark rendered directly from the canonical monochrome SVG. The app treats it as a template so macOS supplies the correct light/dark ink colour.

The dimensional raster icon and SVG intentionally differ in finish: the raster has tactile stone and a pale glass tile, while the SVG is a simplified, editable rendition of the same stone silhouette and ink expression. The SVG is not presented as a generated vector trace.

## Colour and treatment

The character stays neutral: stone #F4F2EC / #DEDFDC / #BBC6D4 and ink #141619. The approved raster's glass backing carries a restrained cool-blue reflection. Cobalt may remain an interface accent, but the character is no longer a cobalt robot. Keep a real stone silhouette, asymmetrical dot eyes, and one simple smiling stroke. Do not reintroduce robot components or add facial panels.

Use the colour mark on quiet, high-contrast backgrounds. Use the monochrome mark for small navigation, menu bar, print, and accessibility contexts. Native controls and semantic foreground colours determine app text contrast; decorative glass should not reduce legibility.

## Rebuilding and validation

Run:

```sh
./script/build_icons.sh
```

The script regenerates the ICNS, 256-pixel in-app image, all ten asset-catalog PNGs and their manifest, and the vector template PDF. The renderer reads `pebble-mono.svg`, so its geometry cannot silently drift from the canonical mark.

Validation checks the PNG/ICNS/PDF signatures, a square master of at least 1024 pixels, the 256-pixel in-app image, and every expected asset-catalog rendition and dimension. Developer previews of the mono mark at 16, 32 and 256 pixels are written to `.build/icons/previews/` on white backgrounds for contrast inspection; those are not the active template assets. The approved raster, its 16/32-pixel renditions, and these vector previews were visually inspected during packaging.

Rebuild the app afterward and take fresh product screenshots. Resource validation does not establish that an already-running app has refreshed its icon cache.
