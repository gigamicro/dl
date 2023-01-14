# Requirements
- ffmpeg
- yt-dlp

# Scripts
`dl.sh`: For a set of playlists (listed in `$scriptdir/dlcplaylists.txt`), will download to $basedir/$name/
`square.sh`: Crops image $1 to square, centered, inplace

# Dirs
`covers/`: contains manual .png covers and individual-cover markers for `dl.sh`
`ignore`: contains yt-dlp `.archive`-format lists of videos to ignore, per playlist
