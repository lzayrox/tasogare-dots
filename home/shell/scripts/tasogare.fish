fish_add_path -g ~/.config/quickshell/bin

for cmd in tsg tasogare
    complete -c $cmd -f
    complete -c $cmd -n "__fish_is_first_arg" -a "start reload restart stop log ipc launcher wallpapers control-center notifications workspaces close island volume audio media brightness theme notifs session help"

    complete -c $cmd -n "__fish_seen_subcommand_from island" -a "toggle open close"
    complete -c $cmd -n "__fish_seen_subcommand_from toggle open" -a "left center right bottomLeft bottomCenter bottomRight"

    complete -c $cmd -n "__fish_seen_subcommand_from volume audio" -a "up down mute mic-mute set"
    complete -c $cmd -n "__fish_seen_subcommand_from media" -a "play-pause next prev"
    complete -c $cmd -n "__fish_seen_subcommand_from brightness" -a "up down"
    complete -c $cmd -n "__fish_seen_subcommand_from theme" -a "toggle dark light wallpaper seed"
    complete -c $cmd -n "__fish_seen_subcommand_from notifs" -a "panel dnd clear test"
    complete -c $cmd -n "__fish_seen_subcommand_from test" -a "normal critical low suite"
    complete -c $cmd -n "__fish_seen_subcommand_from session" -a "exit"
end
