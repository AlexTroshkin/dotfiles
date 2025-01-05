test:
    sudo nixos-rebuild test --flake .

switch:
    sudo nixos-rebuild switch --flake .

push:
    git add .
    git commit -m $(uuidgen)
    git push
