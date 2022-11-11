c.url.searchengines = { 'DEFAULT': 'https://searx.chriscohen.dev/searx/search?q={}&categories=general&language=en-US' }
config.load_autoconfig()
config.set("colors.webpage.darkmode.enabled", True)
config.bind("B", "spawn --userscript qute-bitwarden --dmenu-invocation='dmenu -p \"Select an entry:\" -nb \"#1e1e1e\" -sf \"#aaff77\" -sb \"#333333\" -nf \"#ffffff\" -l 10'")
config.bind('X', 'hint links userscript add-nextcloud-bookmarks')
config.bind("N", "open nextcloud.chriscohen.dev")
config.bind("P", "open app.plex.tv")
