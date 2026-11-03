# AGENTS.md — Mapa y Guía Arquitectónica de `~/dotfiles`

Este archivo proporciona contexto estructural y reglas operativas para cualquier agente de IA (como Antigravity) o desarrollador que navegue o modifique este repositorio de NixOS + Home Manager.

---

## 1. Visión General del Sistema

* **OS:** NixOS (`nixos-unstable`) gestionado mediante **Flakes** y **Home Manager** como módulo de NixOS.
* **Host principal:** `nixos` (`x86_64-linux`), usuario `lzirox`.
* **Compositor Wayland:** **Hyprland** (con configuración nativa en **Lua** y gestionado por **UWSM** — *Universal Wayland Session Manager*).
* **Display Manager / Login:** **Greetd** ejecutando **Cage** + **Quickshell** (`home/config/quickshell/greetd/`), que al autenticar lanza `uwsm start hyprland-uwsm.desktop`.
* **Shell / Barra de Estado:** **Quickshell** (`home/config/quickshell/`) + **Fish** como shell interactiva.
* **Theming Dinámico:** **Matugen** genera paletas Material You a partir del wallpaper hacia Quickshell, Greetd y Hyprland (`colors.lua`).
* **Edición en caliente (`mkOutOfStoreSymlink`):** Las carpetas dentro de `home/config/` están enlazadas directamente desde `~/.config/<app>` hacia `~/dotfiles/home/config/<app>`. **No requieren reconstruir NixOS (`nh os switch`)** al editar archivos `.lua`, `.qml`, `.conf` o `.toml`.

---

## 2. Mapa del Repositorio

```text
~/dotfiles/
├── flake.nix                      # Punto de entrada del Flake (inputs: nixpkgs, hyprland, home-manager, nixvim, trcc, flatpak, etc.)
├── flake.lock                     # Lockfile de versiones de inputs
│
├── hosts/
│   └── nixos/
│       ├── default.nix            # Orquestador principal de módulos del host `nixos`
│       └── hardware.nix           # Configuración generada de hardware, discos, kernel y GPU
│
├── modules/                       # Módulos de nivel Sistema (NixOS)
│   ├── core/
│   │   ├── boot.nix               # Bootloader (systemd-boot / Plymouth / kernel params)
│   │   ├── docker.nix             # Demonio de Docker y permisos
│   │   ├── locale.nix             # Zona horaria e idioma
│   │   ├── network.nix            # Hostname, NetworkManager y firewall
│   │   ├── nix.nix                # Experimental features (flakes), garbage collection y substituters
│   │   ├── nix-ld.nix             # Soporte para binarios dinámicos no-Nix
│   │   ├── packages.nix           # Paquetes base a nivel sistema
│   │   └── users.nix              # Definición del usuario `lzirox`, grupos y shell por defecto (fish)
│   ├── desktop/
│   │   ├── audio.nix              # PipeWire, WirePlumber y rtkit
│   │   ├── fonts.nix              # Fuentes del sistema (Nerd Fonts, Apple Fonts, etc.)
│   │   └── hyprland.nix           # FUENTE DE VERDAD GRÁFICA: Hyprland + UWSM, variables de sesión/cursores, Greetd + Cage + Quickshell
│   └── services/
│       ├── flatpak.nix            # Habilitación del servicio Flatpak a nivel sistema
│       └── trcc.nix               # Servicio para pantalla térmica Thermalright (trcc-linux)
│
├── programs/                      # Programas declarativos a nivel sistema
│   └── nixvim/                    # Configuración modular de Neovim mediante Nixvim
│       ├── default.nix            # Punto de entrada de Nixvim y tema
│       ├── keymaps.nix            # Atajos de teclado de Neovim
│       ├── options.nix            # Opciones generales de vim (`vim.opt`)
│       └── plugins/               # Plugins modulares
│           ├── cmp.nix            # Autocompletado (nvim-cmp)
│           ├── conform.nix        # Formateo de código
│           ├── lsp.nix            # Servidores LSP (nixd, qmlls, lua_ls, ts_ls, etc.)
│           ├── markdown.nix       # Renderizado de Markdown
│           ├── telescope.nix      # Buscador difuso
│           ├── toggleterm.nix     # Terminal flotante/integrada
│           └── ui.nix             # Interfaz (lualine, neo-tree, bufferline, etc.)
│
└── home/                          # Configuración de usuario (`lzirox`) vía Home Manager
    ├── default.nix                # Paquetes de usuario, variables (`NH_FLAKE`), Flatpaks declarativos e imports de Home Manager
    ├── programs/
    │   ├── desktop.nix            # Enlaces `mkOutOfStoreSymlink` de `home/config/*` hacia `~/.config/*`
    │   ├── firefox.nix            # Configuración declarativa de Firefox
    │   └── vscode.nix             # Configuración declarativa de VS Code
    ├── shell/
    │   ├── fish.nix               # Alias del sistema (`nswitch`, `ntest`, `cdnix`, `deskconf`) e inicialización de Fish
    │   └── scripts/
    │       └── agy.fish           # Wrapper inteligente y autocompletado para Antigravity CLI (`agy`)
    └── config/                    # DOTFILES EN CALIENTE (Symlinked a ~/.config/)
        ├── hypr/                  # Configuración de Hyprland en Lua
        │   ├── hyprland.lua       # Punto de entrada que hace `require("conf.*")`
        │   └── conf/
        │       ├── animation.lua  # Curvas bezier y animaciones de ventanas/workspaces
        │       ├── appearance.lua # Bordes, gaps, blur, sombras y redondeo
        │       ├── autostart.lua  # Procesos al iniciar sesión (quickshell, etc.)
        │       ├── colors.lua     # [AUTO-GENERADO POR MATUGEN] Paleta de colores Lua
        │       ├── env.lua        # Variables de entorno específicas de Hyprland
        │       ├── input.lua      # Teclado, ratón y touchpad
        │       ├── keybinds.lua   # Atajos de teclado de Hyprland
        │       ├── monitors.lua   # Resolución, escala y posición de monitores
        │       ├── permissions.lua# Permisos del ecosistema Hyprland
        │       ├── programs.lua   # Definición de programas base ($terminal, $menu, etc.)
        │       └── rules.lua      # Reglas de ventanas y capas (windowrules / layerrules)
        ├── kitty/
        │   └── kitty.conf         # Configuración del emulador de terminal Kitty
        ├── matugen/
        │   ├── config.toml        # Orquestador de plantillas de color y hooks de recarga
        │   └── templates/         # Plantillas base (colors.json, colors.lua, Theme.qml, tasogare.json)
        └── quickshell/
            ├── shell.qml          # Punto de entrada de la interfaz de escritorio (Bar + Wallpaper)
            ├── Bar.qml            # Barra superior/estado del escritorio
            ├── Config.qml         # Configuración general de Quickshell
            ├── Matugen.qml        # Lector reactivo de colores generados en `~/.local/state/quickshell/colors.json`
            ├── Theme.qml          # Tokens de diseño, tipografía y colores del escritorio
            ├── Wallpaper.qml      # Gestor de fondo de pantalla del escritorio
            ├── modules/           # Widgets de la barra (Workspaces, Clock, Volume, Network, Battery)
            └── greetd/            # INTERFAZ DE LOGIN (Greeter ejecutado por Greetd + Cage)
                ├── shell.qml      # Punto de entrada de la pantalla de login
                ├── AuthService.qml# Conexión con Greetd PAM y lanzamiento de `uwsm start hyprland-uwsm.desktop`
                ├── LoginCard.qml  # Tarjeta interactiva de usuario/contraseña y botones de energía
                ├── ClockWidget.qml# Reloj de la pantalla de bloqueo/login
                ├── Wallpaper.qml  # Fondo con blur dinámico al escribir contraseña
                ├── Animation.qml  # Animaciones de entrada y salida de sesión
                ├── Strings.qml    # Textos localizados del login
                ├── Theme.qml      # [AUTO-GENERADO POR MATUGEN] Colores del greeter
                └── Assets/        # Iconos SVG (User, Password, Shutdown, Reboot, Suspend, Hibernate)
```

---

## 3. Flujos Clave de Arquitectura

### A. Flujo de Arranque y Sesión Gráfica (`Greetd` → `UWSM` → `Hyprland`)
1. `modules/desktop/hyprland.nix` levanta `services.greetd` con el usuario `greeter`.
2. El script de `greetd` detecta las GPUs (`/dev/dri/by-path/...`), exporta `WLR_DRM_DEVICES` y ejecuta `cage -s -- quickshell -p .../home/config/quickshell/greetd`.
3. Cuando el usuario introduce su contraseña en `LoginCard.qml`, `AuthService.qml` valida contra Greetd y al recibir `GreetdState.ReadyToLaunch` ejecuta:
   ```qml
   Greetd.launch(["uwsm", "start", "hyprland-uwsm.desktop"]);
   ```
4. **UWSM** envuelve a Hyprland en unidades de `systemd --user` (`wayland-wm@hyprland\x2duwsm.desktop.service`) e importa las variables definidas en `modules/desktop/hyprland.nix` (`environment.sessionVariables`).

### B. Flujo de Colores Dinámicos (`Matugen`)
Cuando se ejecuta `matugen image <ruta-wallpaper>`:
1. Lee `~/.config/matugen/config.toml` (`home/config/matugen/config.toml`).
2. Genera `~/.local/state/quickshell/colors.json` → leído en vivo por `home/config/quickshell/Matugen.qml`.
3. Genera `~/.config/quickshell/greetd/Theme.qml` → actualiza el tema de la pantalla de login.
4. Genera `~/.config/hypr/conf/colors.lua` y ejecuta `hyprctl reload`.

---

## 4. Reglas Operativas para el Agente

1. **¿Cuándo reconstruir NixOS vs Edición Directa?**
   * **Archivos `.nix` (`modules/`, `hosts/`, `home/*.nix`, `programs/`):** Requieren aplicar cambios con `nswitch` (`git -C ~/dotfiles add -A && nh os switch`) o `ntest`. **Nota:** En Flakes con Git, cualquier archivo `.nix` nuevo debe estar al menos en `git add` para que Nix lo vea.
   * **Archivos en `home/config/` (`hypr/`, `quickshell/`, `kitty/`, `matugen/`):** Están conectados mediante `mkOutOfStoreSymlink` (`home/programs/desktop.nix`). Los cambios son **instantáneos** en `~/.config/` sin hacer rebuild de NixOS.
2. **Única Fuente de Verdad para Variables de Entorno y Cursores:**
   * Todas las variables globales de Wayland y cursores (`HYPRCURSOR_*`, `XCURSOR_*`, `UWSM_SILENT_START`) viven en `modules/desktop/hyprland.nix` bajo `environment.sessionVariables`. Evita duplicarlas innecesariamente en otros módulos.
3. **Archivos Auto-generados por Matugen:**
   * No edites manualmente los colores hardcodeados en `home/config/hypr/conf/colors.lua` ni en `home/config/quickshell/greetd/Theme.qml` esperando que persistan tras cambiar de wallpaper; edita sus plantillas en `home/config/matugen/templates/`.
4. **Comandos y Alias Útiles (definidos en `home/shell/fish.nix`):**
   * `nswitch`: `git add -A` + `nh os switch`
   * `ntest`: `git add -A` + `nh os test`
   * `ndry`: `git add -A` + `nh os switch --dry` (ideal para verificar que la configuración compila sin aplicarla)
   * `deskconf [carpeta]`: Abre Neovim directamente en `~/dotfiles/home/config/<carpeta>`
   * `agy dot`: Abre Antigravity CLI directamente sobre `~/dotfiles`
5. **Regla de Diseño Estricta para Contenidos de Paneles en Islas (`Dynamic Island` / `BarSection`):**
   * **Sin Título ni Encabezado:** No incluir textos con nombres del panel ("Control Center", "Panel", "Dashboard", etc.).
   * **Sin Botón de Cierre ni Cruz ('X'):** No incluir botones para cerrar; el cierre se gestiona mediante interacción con la propia isla, clics exteriores o atajos globales.
   * **Solo Elementos Internos Funcionales:** Exclusivamente controles de acción directa (botones, sliders, interruptores rápidos, selectores).
   * **Sin Doble Fondo (No Double Background):** La superficie de cristal la aporta exclusivamente el canvas/contenedor de la isla (`islandCanvas` en `BarSection.qml`). El componente interno (`panels/*Content.qml`) debe ser un `Item` transparente con layout directo (`ColumnLayout` / `GridLayout`), sin envolventes `Rectangle` ni `GlassPanel` que dupliquen capas visuales.
6. **Prohibición de Valores Mágicos (Uso Estricto de `Config` y Tokens):**
   * Siempre que existan valores de diseño, dimensiones o animaciones disponibles en `Config` (`config.json` / `Config.qml`) o `Theme` (`Theme.qml`), **está estrictamente prohibido usar valores numéricos mágicos hardcodeados** (tales como duraciones `420`, `380`, `260`, desplazamientos `50`, `-50`, radios o márgenes arbitrarios).
   * **Animaciones:** Usar siempre los tokens declarativos de `Config.anim` (`Config.anim.fast`, `Config.anim.normal`, `Config.anim.morph`, `Config.anim.slow`).
   * **Dimensiones y Márgenes:** Usar las propiedades de `Config.bar`, `Config.bottomBar`, `Config.panels` o calcular proporciones relativas a ellas (ej. `Math.round(Config.bar.height / 2)`, `Config.bar.height + Config.bar.islandMarginTop`).
   * **Colores:** Usar exclusivamente tokens semánticos de `Theme` generados por Matugen.
