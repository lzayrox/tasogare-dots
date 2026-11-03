{ ... }:
{
  programs.nixvim = {
    plugins.toggleterm = {
      enable = true;
      settings = {
        direction = "horizontal";
        size = 12; # Altura en líneas de la terminal
        open_mapping = "[[<C-\\>]]"; # Ctrl + \ para ocultar/mostrar
        hide_numbers = true;
        start_in_insert = true;
      };
    };
  };
}
