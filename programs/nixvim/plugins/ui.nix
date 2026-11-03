{ ... }:
{
  programs.nixvim = {
    colorschemes.kanagawa = {
      enable = true;
      settings = {
        theme = "wave";
        transparent = true;
      };
    };

    autoCmd = [
      {
        event = [ "QuitPre" ];
        callback = {
          __raw = ''
            function()
              local tree_wins = {}
              local floating_wins = {}
              local wins = vim.api.nvim_list_wins()
              for _, w in ipairs(wins) do
                local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(w))
                if bufname:match("neo%-tree") then
                  table.insert(tree_wins, w)
                end
                if vim.api.nvim_win_get_config(w).relative ~= "" then
                  table.insert(floating_wins, w)
                end
              end
              if 1 == #wins - #floating_wins - #tree_wins then
                for _, w in ipairs(tree_wins) do
                  vim.api.nvim_win_close(w, true)
                end
              end
            end
          '';
        };
      }
    ];

    plugins = {
      which-key.enable = true;
      bufdelete.enable = true;
      treesitter = {
        enable = true;
        highlight.enable = true;
        indent.enable = true;
      };
      web-devicons.enable = true;

      neo-tree = {
        enable = true;
        settings.close_if_last_window = true;
      };

      indent-blankline = {
        enable = true;
        settings.scope = {
          show_start = true;
          show_end = false;
        };
      };

      bufferline = {
        enable = true;
        settings = {
          options = {
            mode = "buffers";
            separator_style = "slant"; # "slant" | "slope" | "thick" | "thin"
            always_show_bufferline = false;
            show_buffer_close_icons = true;
            show_close_icon = false;
            diagnostics = "nvim_lsp"; # Muestra alertas/errores en la pestaña
          close_command = "Bdelete! %d";
          right_mouse_command = "Bdelete! %d";
            offsets = [
              {
                filetype = "neo-tree";
                text = "Explorador";
                highlight = "Directory";
                text_align = "left";
              }
            ];
          };
        };
      };
    };
  };
}
