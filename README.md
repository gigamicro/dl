# Requirements
- ffmpeg
- yt-dlp
- jq
- opustools

# Scripts
`dl.all.log.sh (flag)`: Entry point (rm:remove folder)

`. dl.main.sh "(playlist settings)"`: For a single long playlist (hardcoded), will download to ./dl/
`dl.c.main.sh`: For a set of playlists (listed in `dlcplaylists.txt`), will download to ./dlc/(name)/

`dl.playlist.sh (pid)`: Downloads all videos in a playlist (limited to 42 concurrent downloads)

`dl.single.sh (id) (track?)`: Downloads video, audio, and metadata to (title)-(id).opus; omits image + adds track number if provided

`dl.single.audio.sh (id)`: Downloads opus audio track from video

`dl.single.image.sh (id)`: Downloads png image at 50% mark of video
