# Requirements
- ffmpeg
- yt-dlp

# Scripts, Files, & Directories (alphabetical)
`.gitignore`: ignore \*.sublime-workspace

`albums.m3u`: `playlists.m3u` for albums

`archivecheck.sh`: finds downloads in `archivedir` with their IDs also in `basedir` (recursive); stdout is paths to each archive duplicate

`archivecheckloose.sh`: finds downloads in `archivedir` with their titles also in `basedir`, with similar metadata

`archivecheckstrict.sh`: finds downloads in `archivedir` with their filenames also in `basedir` (recursive); stdout is paths to each archive duplicate

`archivedir`: contains the location at which the archive will be kept

`archiveduplicatecheck.sh`: finds downloads in `archivedir` with their IDs in `archivedir` at least twice (recursive); stdout is paths to all but one of each ID

`artists.m3u`: `playlists.m3u` for artists

`basedir`: contains the location at which the downloads will be kept

`covercheck.sh`: finds duplicate and unnecessary covers in `basedir`/\*; stdout is either 'redundant: ' or 'missing  : ' followed by the path to each audio file

`crossdupecheck.sh`: lists items in `basedir` with the same id, in a different subfolder

`cull.sh`: deletes directories in $1, ignoring cover.\*, \*.m3u, and \*.archive

`dl.sh`: For a set of playlists (listed in `playlists.m3u`), will download to `basedir`/\<the playlist's name>/; lists the order in `basedir`/\<name>/\<name>.m3u

`duplicatecheck.sh`: lists items in `basedir` with the same id, in the same subfolder

`faV.m3u`: individual song listing; listed in `playlists.m3u`

`faVduplicatecheck.sh`: finds and prints listings that are duplicates between `basedir`/faV/faV.m3u and `basedir`/\*/\*.m3u

`fromfaV.sh`: comments lines from `faV.m3u` ending in lines from stdin; removes downloads with matching video IDs from `basedir`/faV/

`ignore/`: contains yt-dlp `.archive`-format lists of videos to ignore, per playlist

`init.sh`: uses the other scripts; `init.sh z` to enable changes other than `dl.sh` and more minor cleanups

`LICENSE`: MIT License (may change?)

`m3ucheck.sh`: finds files (apart from cover.\* & \*.m3u) in `basedir`/\* that are not listed in `basedir`/\*/\*.m3u

`music.sublime-project`: trivial Sublime Text project

`nametoignores.sh`: turns list of filenames from stdin to ytdl .archive list

`playlists.m3u`: contains playlist locators, one per line; either .m3u or online

`README.md`: this readme

`recentinlog.sh`: follows logs in /tmp/dl/link/\* and prints download numbers until program with pid $1 exits

`square.sh`: Crops image $1 to square, centered, inplace; required for `dl.sh` covers

`squarecheck.sh`: finds downloads with non-square covers in `basedir`

`tailexisting.sh`: tail log of currently running pids in waitlist

`toalbums.sh`: `tolists.sh` `albums.m3u`

`toarchive.sh`: moves \*/\* (from stdin) to `archivedir`/\*/\*

`toartists.sh`: `tolists.sh` `artists.m3u`

`TODO`: list of things to do at some point

`tofaV.sh`: adds stdin to top of `faV.m3u`, converting YouTube links to youtu.be links

`toignore.sh`: adds stdin elements to `ignore/`\*.archive

`tolists.sh`: adds stdin to $1`.m3u`, stripping certain parts of YouTube links

`toplaylists.sh`: `tolists.sh` `playlists.m3u`

`untouchedcheck.sh`: lists m3u files that weren't touched since $1 (unix timestamp) or one hour ago

`untrash.sh`: renames android-style trashed files to no longer be trashed (ie '.trashed-##########-...' -> '...')

`whichlogs.sh`: which log files have not yet created a log link?
