{ ... }:
{
  programs.nixvim.keymaps = [
    {
      mode = [
        "n"
        "i"
        "v"
      ];
      key = "<C-s>";
      action = "<cmd>w<CR>";
      options.desc = "Guardar archivo";
    }
    {
      mode = [
        "n"
        "v"
      ];
      key = "<C-z>";
      action = "u";
      options.desc = "Deshacer";
    }
    {
      mode = "i";
      key = "<C-z>";
      action = "<C-o>u";
      options.desc = "Deshacer en inserción";
    }
    {
      mode = [
        "v"
        "x"
      ];
      key = "<C-c>";
      action = "\"+y";
      options.desc = "Copiar al portapapeles";
    }
    {
      mode = [
        "v"
        "x"
      ];
      key = "<C-x>";
      action = "\"+d";
      options.desc = "Cortar al portapapeles";
    }
    {
      mode = "n";
      key = "<leader>e";
      action = ":Neotree toggle<CR>";
      options = {
        silent = true;
        desc = "Explorador de archivos (Neotree)";
      };
    }
    {
      mode = "n";
      key = "<leader>f";
      action = "<cmd>lua vim.lsp.buf.format()<CR>";
      options = {
        silent = true;
        desc = "Formatear archivo";
      };
    }
    {
      mode = "n";
      key = "<S-l>";
      action = ":BufferLineCycleNext<CR>";
      options = {
        silent = true;
        desc = "Siguiente pestaña";
      };
    }
    {
      mode = "n";
      key = "<S-h>";
      action = ":BufferLineCyclePrev<CR>";
      options = {
        silent = true;
        desc = "Pestaña anterior";
      };
    }
    {
      mode = "n";
      key = "<leader>x";
      action.__raw = ''
        function()
          local bufs = vim.fn.getbufinfo({ buflisted = 1 })
          if #bufs <= 1 then
            vim.cmd("confirm qa")
          else
            require("bufdelete").bufdelete(0, false)
          end
        end
      '';
      options = {
        silent = true;
        desc = "Cerrar pestaña";
      };
    }
    {
      mode = "n";
      key = "[d";
      action = "<cmd>lua vim.diagnostic.jump({ count = -1 })<CR>";
      options = {
        silent = true;
        desc = "Diagnóstico anterior";
      };
    }
    {
      mode = "n";
      key = "]d";
      action = "<cmd>lua vim.diagnostic.jump({ count = 1 })<CR>";
      options = {
        silent = true;
        desc = "Diagnóstico siguiente";
      };
    }
    {
      mode = [
        "n"
        "t"
      ];
      key = "<leader>t";
      action = "<cmd>ToggleTerm<CR>";
      options = {
        silent = true;
        desc = "Alternar terminal inferior";
      };
    }
    {
      mode = "n";
      key = "<leader>mp";
      action = ":MarkdownPreviewToggle<CR>";
      options = {
        silent = true;
        desc = "Alternar vista previa Markdown en navegador";
      };
    }
  ];
}
