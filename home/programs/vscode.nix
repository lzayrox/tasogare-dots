{ pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    package = (
      pkgs.vscode.override {
        commandLineArgs = "--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations";
      }
    );
  };
}
