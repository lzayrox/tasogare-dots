# ❄️ NixOS Dotfiles (`lzirox`)

Configuración modular de **NixOS (`nixos-unstable`)** con **Flakes**, **Home Manager**, **Hyprland (Lua + UWSM)**, **Quickshell** (barra de escritorio y pantalla de login con **Greetd**) y **Nixvim**.

> [!TIP]
> Para detalles internos de arquitectura, flujos de sesión y reglas para agentes de IA, consulta [`AGENTS.md`](./AGENTS.md).

---

## Estructura Principal

| Ruta | Propósito | ¿Requiere `nswitch`? |
| :--- | :--- | :---: |
| [`flake.nix`](./flake.nix) | Inputs del sistema (`nixpkgs`, `hyprland`, `home-manager`, `nixvim`, `trcc-linux`, etc.) | Sí |
| [`hosts/nixos/`](./hosts/nixos/default.nix) | Punto de entrada del host `nixos` y configuración de hardware | Sí |
| [`modules/core/`](./modules/core/) | Boot, kernel, red, audio, usuarios, Docker, `nix-ld` y paquetes base | Sí |
| [`modules/desktop/`](./modules/desktop/) | **Hyprland + UWSM**, **Greetd**, cursores, variables Wayland, PipeWire y fuentes | Sí |
| [`modules/services/`](./modules/services/) | Servicios del sistema (`flatpak`, pantalla térmica `trcc`) | Sí |
| [`programs/nixvim/`](./programs/nixvim/default.nix) | Configuración completa de Neovim declarativa (LSP, Telescope, CMP, UI) | Sí |
| [`home/`](./home/default.nix) | Home Manager (`lzirox`), paquetes de usuario, Fish shell y wrappers (`agy`) | Sí |
| [`home/config/`](./home/config/) | **Dotfiles en vivo** (`hypr`, `quickshell`, `matugen`, `kitty`) vía `mkOutOfStoreSymlink` | **No (En caliente)** |

---

## Atajos Rápidos (Fish Shell)

Definidos en [`home/shell/fish.nix`](./home/shell/fish.nix):

* `nswitch` — Añade cambios al stage (`git add -A`) y reconstruye el sistema (`nh os switch`).
* `ntest` — Prueba la configuración en vivo sin añadir entradas al arranque (`nh os test`).
* `ndry` — Verifica que el Flake evalúe y construya sin aplicar cambios (`nh os switch --dry`).
* `nupdate` — Actualiza el `flake.lock` y reconstruye el sistema (`nh os switch -u`).
* `ngc` — Limpia generaciones antiguas conservando las últimas 3 (`nh clean all --keep 3`).
* `cdnix` — Abre Neovim en la raíz de `~/dotfiles`.
* `deskconf [modulo]` — Abre Neovim en `~/dotfiles/home/config` (ej. `deskconf hypr` o `deskconf quickshell`).
* `agy dot` — Inicia Antigravity CLI directamente sobre este repositorio.

---

## Flujo Gráfico y Theming

1. **Login (`Greetd` + `Cage` + `Quickshell`):** Configurado en [`modules/desktop/hyprland.nix`](./modules/desktop/hyprland.nix) y renderizado por [`home/config/quickshell/greetd/shell.qml`](./home/config/quickshell/greetd/shell.qml).
2. **Sesión (`UWSM` + `Hyprland Lua`):** Al iniciar sesión, [`AuthService.qml`](./home/config/quickshell/greetd/AuthService.qml) lanza `uwsm start hyprland-uwsm.desktop`, que carga [`home/config/hypr/hyprland.lua`](./home/config/hypr/hyprland.lua).
3. **Colores Dinámicos (`Matugen`):** Configurado en [`home/config/matugen/config.toml`](./home/config/matugen/config.toml), sincroniza automáticamente la paleta de colores con Hyprland (`colors.lua`), el escritorio Quickshell (`colors.json`) y el Greeter (`Theme.qml`).
