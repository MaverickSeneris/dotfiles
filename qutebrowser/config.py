# Load settings made via :set
config.load_autoconfig()

# Enable dark mode on all websites
config.set("colors.webpage.darkmode.enabled", True)

# Optional tweaks for nicer dark look
config.set("colors.webpage.darkmode.policy.images", "smart")   # Don't destroy all images
config.set("colors.webpage.darkmode.policy.page", "smart")     # Smarter inversion
config.set("colors.webpage.bg", "black")                       # Background fallback

# Toggle tab positions + auto adjust width
config.bind("<Ctrl-t>", 
    "config-cycle tabs.position top left right; "
    "config-cycle -p tabs.width 100% 180px")

# Toggle tab visibility
config.bind('<Ctrl-t>', 'config-cycle tabs.show always never switching')

# Transparent tabs
config.set("colors.tabs.bar.bg", "rgba(0,0,0,0)")
config.set("colors.tabs.even.bg", "rgba(0,0,0,0)")
config.set("colors.tabs.odd.bg", "rgba(0,0,0,0)")
config.set("colors.tabs.selected.even.bg", "rgba(40,40,40,0.6)")
config.set("colors.tabs.selected.odd.bg", "rgba(40,40,40,0.6)")

# Gruvbox dark hard theme
bg0 = "#1d2021"
bg1 = "#282828"
fg0 = "#ebdbb2"
fg1 = "#d5c4a1"
yellow = "#d79921"
orange = "#d65d0e"
purple = "#b16286"
aqua = "#689d6a"

config.set("colors.tabs.bar.bg", bg0)

config.set("colors.tabs.even.bg", bg1)
config.set("colors.tabs.odd.bg", bg1)
config.set("colors.tabs.even.fg", fg0)
config.set("colors.tabs.odd.fg", fg0)

config.set("colors.tabs.selected.even.bg", orange)
config.set("colors.tabs.selected.odd.bg", orange)
config.set("colors.tabs.selected.even.fg", bg0)
config.set("colors.tabs.selected.odd.fg", bg0)

# URL bar
config.set("colors.statusbar.normal.bg", bg0)
config.set("colors.statusbar.normal.fg", fg0)
config.set("colors.statusbar.command.bg", bg1)
config.set("colors.statusbar.command.fg", fg0)

# Completion menu
# config.set("colors.completion.bg", bg0)
config.set("colors.completion.fg", fg0)
config.set("colors.completion.item.selected.bg", orange)
config.set("colors.completion.item.selected.fg", bg0)

# Search engines
c.url.searchengines = {
    "DEFAULT": "https://www.google.com/search?q={}",
    "!yt": "https://www.youtube.com/results?search_query={}",
    "!ai": "https://chat.openai.com/?q={}",
    "!gh": "https://github.com/search?q={}",
}


config.bind('<Ctrl-l>', 'set tabs.position left')
config.bind('<Ctrl-u>', 'set tabs.position top')

# Optional: press 'o' to open search with suggestions
c.completion.web_history.max_items = -1
