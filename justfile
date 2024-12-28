test:
    sudo nixos-rebuild test --flake .

switch:
    sudo nixos-rebuild switch --flake .

commit-all:
    git add .
    git commit -m $(uuidgen)
