{ ... }:

{
  programs.firefox = {
    enable = true;

    policies = {
      ExtensionSettings = {
        "keepassxc-browser@keepassxc.org" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/file/4395146/keepassxc_browser-1.9.5.xpi";
          installation_mode = "force_installed";
        };
      };
    };
  };
}
