{ pkgs, inputs, ... }:
{
  fonts.packages =
    with pkgs;
    [
      nerd-fonts.jetbrains-mono
      font-awesome
      noto-fonts-color-emoji
    ]
    ++ (with inputs.apple-fonts.packages.${pkgs.stdenv.hostPlatform.system}; [
      sf-mono
      sf-mono-nerd
      sf-pro
    ]);
}
