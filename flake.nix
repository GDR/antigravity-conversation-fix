{
  description = "Antigravity Conversation Fix — rebuilds conversation index";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in
    {
      packages = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.writeShellApplication {
            name = "antigravity-conversation-fix";
            runtimeInputs = [ pkgs.python3 ];
            text = ''
              exec python3 "${./rebuild_conversations.py}" "$@"
            '';
          };
        });

      # `nix run` target
      apps = forAllSystems (system: {
        default = {
          type = "app";
          program = "${self.packages.${system}.default}/bin/antigravity-conversation-fix";
        };
      });
    };
}
