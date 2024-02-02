{ lib, ... }:
{
  composeOverlays = overlays: lib.foldl' lib.composeExtensions (_:_: { }) overlays;
  prefixOverlay =
    overlay: final: prev: {
      siruilu =
        if prev ? siruilu
        then prev.siruilu // overlay final prev
        else overlay final prev;
    };
}
