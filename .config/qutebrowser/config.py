c.url.searchengines = { 'DEFAULT': 'https://searx.chriscohen.dev/searx/search?q={}&categories=general&language=en-US',
                       'aw': 'https://wiki.archlinux.org?search={}',
                       'yt': 'https://youtube.com/results?search_query={}',
                       'r': 'https://reddit.com/r/{}' }

config.load_autoconfig()
config.set("colors.webpage.darkmode.enabled", True)
config.bind("B", "spawn --userscript dmenu-bitwarden")
config.bind("X", "hint links userscript add-nextcloud-bookmarks")
config.bind("N", "open nextcloud.chriscohen.dev")
config.bind("P", "open app.plex.tv")
