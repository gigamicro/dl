# Requirements
- ffmpeg
- yt-dlp

# Scripts, Files, & Directories (alphabetical)
`archivecheck.sh`: finds downloads in `archivedir` with their IDs also in `basedir` (recursive); stdout is paths to each archive duplicate
`archivedir`: contains the location at which the archive will be kept
`basedir`: contains the location at which the downloads will be kept
`covercheck.sh`: finds duplicate and unnecessary covers in `basedir`/\*; stdout is either 'redundant: ' or 'missing  : ' followed by the path to each audio file
`dl.sh`: For a set of playlists (listed in `playlists.m3u`), will download to `basedir`/\<the playlist's name>/; lists the order in `basedir`/\<name>/\<name>.m3u
`faV.m3u`: individual song listing; listed in `playlists.m3u`
`faVduplicatecheck.sh`: find listings in `basedir`/faV/faV.m3u that correspond to listings in other folders and prints the offending line(s)
`fromfaV.sh`: comments lines from `faV.m3u` ending in lines from stdin; removes matching downloads from folder assuming video IDS
`ignore/`: contains yt-dlp `.archive`-format lists of videos to ignore, per playlist
`init.sh`: uses the other scripts; `init.sh z` for more aggressive
`LICENSE`: MIT License (may change?)
`m3ucheck.sh`: finds downloads in `basedir`/\* that are not listed in `basedir`/\*/\*.m3u
`music.sublime-project`: trivial Sublime Text project
`playlistalbums.sh`: prints the 'album' property of the songs in each playlist in `playlists.m3u`, in order of count
`playlistnames.sh`: prints 'channel' and 'playlist title' properties of each playlist in `playlists.m3u`
`playlists.m3u`: contains playlist locators, one per line; either .m3u or online
`README.md`: this readme
`recentinlog.sh`: gives ID and playlist name of all downloads in recent logs
`square.sh`: Crops image $1 to square, centered, inplace; required for `dl.sh` covers
`toarchive.sh`: moves \*/\* to `archivedir`/\*/\*
`tofaV.sh`: adds stdin to top of `faV.m3u`, converting YouTube links to youtu.be links
`toignore.sh`: adds $1 contents to `ignore/`\*.archive
`toplaylists.sh`: appends stdin to `playlists.m3u`, stripping certain parts of YouTube links
`untrash.sh`: renames android-style trashed files to no longer be trashed (ie '.trashed-##########-...' -> '...')
