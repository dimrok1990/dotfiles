# UNGOOGLED-CHROMIUM

## Options
- keep local cookies
- gtk theme
- font_size=very-large, minimum size=8
- add italian as spellchecking language
- block notifications globally from "Site settings"(!)
- setup search engines: choose a valid Searx from `searx.space`, and then add ddg (and keep nosearch)

## Flags
- force-dark-mode
- ext-mime-request-handling[always prompt]
- disable-search-engine-collection
- native notifications
- Compositor threaded scrollbar scrolling
- Web Platform Controls Dark Mode

## Bookmarks
- Import from file.

## Passwords manager
- [keepassxc+extension(backup)]

## theme
- sol ref dark(favs)
- gtk (gruvbox)

## Plugins
PACKAGED: `chromium-keepassxc-browser chromium-thegreatsuspender stylus-git chromium-ublock-origin chromium-extension-https-everywhere`
> Install plugin manager's .CRX for ung-chromium: https://github.com/NeverDecaf/chromium-web-store/tags

### Utils
vimium(bkp){allow file access}[ctrl+shift+v] vimium_helper Change_new_tab(url) autologin[backup]
- stylus(beta)[backup,alt+shift+s] gtransl(<C-R>)
- the_great_suspender(dark theme, capture top screen only, other:011)[ctrl+shift+s];Firenvim(ctrl+shift+f)

### Privacy-focused
- ublock Origin[ctrl+b block elements, ctrl+shift+u activate it]
- I don't care about cookies
- HTTPS Everywhere
- Terms of Service; Didn’t Read
- ClearURLs

searchengs:
{

a:	https://www.amazon.com/s/?field-keywords=%s Amazon
abs:	https://www.archlinux.org/packages/?q=%s,
alib:	https://www.alibaba.com/trade/search?fsb=y&IndexArea=product_en&CatId=&SearchText=%s alibaba
ali:	https://www.aliexpress.com/wholesale?&SearchText=%s aliexpress
ab:	http://www.amazon.it/s/?url=search-alias%3Dstripbooks&field-keywords=%s amazonbooks
ae:	http://www.amazon.it/s/?url=search-alias%3Delectronics&field-keywords=%s amazonelectronics
au:	http://askubuntu.com/search?q=%s askubuntu
aur:	https://aur.archlinux.org/packages.php?K=%s AUR
aw:	https://wiki.archlinux.org/index.php/Special:Search/%s archwiki
ax:	https://arxiv.org/search?query=%s&searchtype=all&source=header arxiv
bg:	https://it.banggood.com/search/%s.html bangood
bit:	https://btcache.me/torrent/%s bittorcache
cd:	javascript:location='http://www.google.com/search?num=100&q=site:'%20+%20escape(location.hostname)%20+%20'%20%S'%20;%20void%200 cd
cl: https://cadence.moe/cloudtube/search?q=%s&sort_by=relevance cloudtube
d: 	https://duckduckgo.com/?q=%s DuckDuckGo
dw:	http://www.merriam-webster.com/dictionary/%s Merriam-Webster
eb:	https://www.ebay.com/sch/i.html?_nkw=%s ebay
fb:	https://www.facebook.com/search/top/?q=%s facebook
g:	https://www.google.com/search?q=%s Google
gd:	https://drive.google.com/drive/search?q=%s gdrive
ge:	https://genius.com/search?q=%s Genius
gh:	https://github.com/search?q=%s GitHub
gi:	https://www.google.com/searchbyimage?image_url=%s Google Image Search
gm:	https://www.google.com/maps?q=%s Google maps
go:	https://www15.gogoanime.io//search.html?keyword=%s gogoanime
gt:	https://translate.google.com/?source=osdd#auto|auto|%s gtranslate
imslp:	https://www.google.com/search?q=site:imslp.org+%s imslp
j:	http://localhost:9117/UI/Dashboard#search=%s&tracker=&category= Jackett
ki:	https://kickass.cm/usearch/?q=%s kickass
ka:	https://kissanime.ac/Search/?s=%s kissanime
l:	http://93.174.95.27/search.php?req=%s&lg_topic=libgen&open=0&view=simple&res=25&phrase=1&column=def libgen
lk:	https://www.google.com/search?q=%s&btnI I'm feeling lucky...
lp:	https://launchpad.net/+search?field.text=%s launchpad
lt:	http://www.limetorrents.cc/search/all/%s/ limetorrents
mal:	https://myanimelist.net/anime.php?q=%s myanimelist
mo:	http://mathoverflow.net/search?q=%s mathoverflow
ms:	http://math.stackexchange.com/search?q=%s mathstackexchange
mw:	http://mathworld.wolfram.com/search/?query=%s mathworld
nh:	https://nhentai.net/search/?q=%s nh
oeis:	http://oeis.org/search?q=%s oeis
om:	https://www.openstreetmap.org/search?query=%s openstreetmap
pip:	https://www.openstreetmap.org/search?query=%s PyPI
r:	https://www.reddit.com/search/?q=%s Reddit
repo:	https://repology.org/projects/?search=%s repology
rt:	https://rutracker.net/forum/tracker.php?nm=%s rutracker
sc:	https://libgen.bban.top/s/%s scihub
se:	https://searx.fmac.xyz/search?q=%s Searx
tldr:	https://tldr.ostera.io/%s tldr
tp:	https://torrentproject.cc/?t=%s
ud:	https://www.urbandictionary.com/define.php?term=%s UrbanDictionary
w:	https://www.wikipedia.org/w/index.php?title=Special:Search&search=%s Wikipedia
wa:	https://www.wolframalpha.com/input/?i=%s Wolfram|Alpha
y:	https://www.youtube.com/results?search_query=%s Youtube
yr:	https://yandex.ru/search/?text=%s yandex.ru

}
