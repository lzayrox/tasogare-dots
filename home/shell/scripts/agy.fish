# ==============================================================================
# Wrapper inteligente para Antigravity CLI (agy)
# ==============================================================================

# Autocompletado contextual en Fish
complete -c agy -f
complete -c agy -n "__fish_is_first_arg" -a "agent agents changelog help install mcp mic-serve models plugin plugins remote-control update" -d "Comando nativo agy"
complete -c agy -n "__fish_is_first_arg" -a "chat dot dotfiles scratch (ls -d ~/Projects/*/ 2>/dev/null | xargs -n1 basename)" -d "Workspace"

function agy --description "Wrapper de agy con soporte de workspaces y proyectos"
    # 1. Sin argumentos: ejecutar en la carpeta actual
    if test (count $argv) -eq 0
        command agy
        return
    end

    # 2. Si empieza por guion (-c, --help, etc.), pasar directo al binario
    if string match -q -- "-*" $argv[1]
        command agy $argv
        return
    end

    # 3. Proteger subcomandos oficiales de agy
    set -l reserved_subcommands agent agents changelog help install mcp mic-serve models plugin plugins remote-control update
    if contains -- $argv[1] $reserved_subcommands
        command agy $argv
        return
    end

    # 4. Enrutamiento de carpetas / workspaces
    set -l target_dir ""
    set -l extra_args $argv[2..-1]

    switch $argv[1]
        case chat
            set target_dir ~/Documents/chat
        case dot dotfiles
            set target_dir ~/dotfiles
        case scratch
            set target_dir ~/Projects/scratch
        case '*'
            if test -d ~/Projects/$argv[1]
                set target_dir ~/Projects/$argv[1]
            else
                # Argumento regular hacia agy en la carpeta actual
                command agy $argv
                return
            end
    end

    # 5. Ejecutar dentro del directorio destino y regresar al salir
    if test -n "$target_dir"
        mkdir -p $target_dir
        pushd $target_dir > /dev/null
        command agy $extra_args
        popd > /dev/null
    end
end
