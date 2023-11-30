{ nixpkgs, config, lib, ... }:

(self: super: {
  obsidian = super.obsidian.override {
    electron = self.electron_24;
  };
})
