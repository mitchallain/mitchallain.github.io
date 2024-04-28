{
  description = "Mitchell's personal blog";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };

      # https://nixos.org/manual/nixpkgs/stable/#developing-with-ruby
      gems = pkgs.bundlerEnv {
        name = "mallain-site";
        inherit (pkgs) ruby;
        gemfile = ./Gemfile;
        lockfile = ./Gemfile.lock;
        gemset = ./gemset.nix;
      };

    in
    {
      devShell.${system} = pkgs.mkShell { 
          packages = [ gems gems.wrappedRuby ]; 
      };
    };
}

