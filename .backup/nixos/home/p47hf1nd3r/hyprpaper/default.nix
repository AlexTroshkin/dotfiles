{ ... }:

{
  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [
        "~/.config/wallpapers/8ad7f03f-e803-466b-b012-a26523893ecc.jpeg"
        # "~/.config/wallpapers/9c031d6a-7193-45be-8db0-003c5ec817a2.jpeg"
      ];
      wallpaper = [
        ",~/.config/wallpapers/8ad7f03f-e803-466b-b012-a26523893ecc.jpeg"
        # ",~/.config/wallpapers/9c031d6a-7193-45be-8db0-003c5ec817a2.jpeg"
      ];
    };
  };
}
