c.url.searchengines = { 'DEFAULT': 'https://searx.chriscohen.dev/searx/search?q={}&categories=general&language=en-US',
                       'aw': 'https://wiki.archlinux.org?search={}',
                       'yt': 'https://youtube.com/results?search_query={}',
                       'r': 'https://reddit.com/r/{}',
                       'ddg': 'https://duckduckgo.com/?q={}&t=h_&ia=web',
                       'g': 'https://google.com/search?q={}'}

config.load_autoconfig()
config.set("colors.webpage.preferred_color_scheme", "dark")
config.set("downloads.location.directory", "~/Downloads")
config.bind("B", "spawn --userscript qute-bitwarden -d='dmenu -nb \"#1e1e1e\" -sf \"#aaff77\" -sb \"#333333\" -nf \"#ffffff\" -p Bitwarden'")
config.bind("X", "hint links userscript add-nextcloud-bookmarks")
config.bind("N", "open nextcloud.chriscohen.dev")
config.bind("P", "open app.plex.tv")
