final: prev: {
  stack-upload = prev.callPackage ./stack-upload.nix { };
  stack-upload-doc = prev.callPackage ./stack-upload-doc.nix { };
}
