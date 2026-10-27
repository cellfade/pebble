# Pebble identity

Selected by the owner: the soft, tilted cobalt companion (concept 01, Pebble). The final product name is Pebble. Peek and the earlier lantern directions are unused explorations.

- `pebble.svg`: editable color vector mark, paths and simple gradients with no embedded raster.
- `pebble-mono.svg`: currentColor single-ink version.
- `../../Resources/AppIcon-source.png`: original generated raster icon; built-in image generation was used, then resized mechanically for packaging.
- `../../Resources/AppIcon.icns`: macOS icon set generated from the raster.
- `../../Resources/MenuBarMark.pdf`: vector template mark drawn from the same mono silhouette.

Palette: cobalt #2257EB, deep cobalt #1237A3, navy #11264B, cream #FFFAF0, amber #FFB43A. App interface uses system-adaptive surfaces and semantic contrast; cobalt is the active accent, not an opaque wash behind body text. Artwork can be dimensional; the SVG is a deliberately simplified brand rendition rather than an automatic vector trace.

Rebuild resources with `./script/build_icons.sh`. App Store icon renditions are checked into Resources/Assets.xcassets. Keep those in sync if the source icon changes. The icon character was created as an original design; do not introduce borrowed franchise silhouettes.

Generation prompt: refine the selected left Pebble concept into one macOS app icon; smooth cobalt pebble/egg body, diagonal warm ceramic face, two navy oval eyes, tiny amber cheek light and feet, no ears/visor/antenna/arms/cube body, pale icy-blue glass rounded-square tile, no text, transparent outside tile. Exact project prompt and the concept boards are retained in the local brand-exploration deliverable.
