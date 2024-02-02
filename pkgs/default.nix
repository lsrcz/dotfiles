{ siruilu, ... }:
siruilu.overlays.prefixOverlay
  (siruilu.overlays.composeOverlays [ (import ./stack) ])
