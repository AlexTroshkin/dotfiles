{ ... }:

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.shepard = {
    isNormalUser = true;
    description = "shepard";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = [];
  };
}