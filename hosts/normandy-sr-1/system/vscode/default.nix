{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    (vscode-with-extensions.override {
      vscodeExtensions = with vscode-extensions; [

      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "nix-ide";
          publisher = "jnoortheen";
          version = "0.2.2";
          sha256 = "8f038cfba2e71f20a4be13935524d466f831efb8c083a845082a41a98f00c488";
        }
      ];
    })
  ];
}