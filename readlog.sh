#! /bin/bash
tail --pid "$(cat ~/Music/logs/pid)" -f ~/Music/logs/all/"$(ls -1 -r ~/Music/logs/all/ | head -c 27)"
