# Requirements
- ffmpeg
- yt-dlp
- jq
- opustools

# Scripts
`. dl.c.main.sh "(playlist settings)"`: For a set of playlists (listed in `dlcplaylists.txt`, max playlist length \~50 videos), will download to ./dlc/(album name)/

`. dl.main.sh "(playlist settings)"`: For a single long playlist (hardcoded), will download to ./dl/


## Other scripts:

`dl.playlist.sh (pid) "(playlist settings)"`:<!--  "(dl.single.audio.sh settings)" "(dl.single.image.sh settings)" --> Downloads all videos in a playlist (limited to 42 concurrent processes)

`dl.single.sh (id)`:<!--  "(dl.single.audio.sh settings)" "(dl.single.image.sh settings)" --> Downloads video, audio, and metadata to (title)-(id).opus

`dl.single.audio.sh (id)`: Downloads opus audio track from video

`dl.single.image.sh (id)`: Downloads png image at ten seconds into video
