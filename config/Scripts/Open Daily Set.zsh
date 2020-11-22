#!/usr/bin/env zsh
sites=(
	"1tamilmv.live"
	"macbb.org/whats-new/posts"
    "github.com"
    "mactorrent.co/torrents.php"
    "1337.root.yt/sort-search/qxr/time/desc/1/"
    "phoronix.com/scan.php?page=home"
    "www.anandtech.com"
    "arstechnica.com"
    "news.ycombinator.com"
)

for site in "${sites[@]}"; do
    open "https://$site"
done

open "https://${sites[1]}"
