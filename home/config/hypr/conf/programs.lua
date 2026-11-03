local home = os.getenv("HOME")

return {
    shell       = home .. "/.config/quickshell/bin/tsg",
    terminal    = "kitty",
    fileManager = "dolphin",
    browser     = "app.zen_browser.zen",
    menu        = home .. "/.config/quickshell/bin/tsg launcher"
}
