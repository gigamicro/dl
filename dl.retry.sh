cd ~/Music
# (mkdir logs; mkdir logs/ret) 2> /dev/null
# ; mkdir logs/ret/all
# (
for i in dl*.err; do
    f="../$(sed -e 's/\.err//g' -e 's/\./\//g' <<< "$i")/"
    l="$(sed -e 's/\.err//g' -e 's/\..*//g' <<< "$i")/"
    echo "$i -> $f ($l)"

    cd ~/Music/"$l"
    while read v; do
        echo " $v:"
        (
        true
        # bash <(sed -e '^youtube.* | \\$' < ../dl.playlist.sh)
        rm "$f"*"$v".* 2>/dev/null && echo "Download removed" >&2 || echo "Undownloaded" >&2
        # rm ../logs/*/$v.* 2>/dev/null && echo "Log removed" >&2 || echo "Unlogged" >&2
        . ../dl.single.sh "$v"
        mv ./*$v. 2>/dev/null || echo "Nothing downloaded" >&2
        ) #2>&1 | tee "logs/ret/$i.log" #1>/dev/null
    done < ../$i
    # mv ../logs/*.log ../logs/*.json ../logs/ret 2>/dev/null || echo "No ignored logs" >&2
    rm "../$i" 2>/dev/null
    mv err "../$i" 2>/dev/null || echo "No err" >&2
    cd ~/Music
done
echo dl*.err still exists? >&2
# )1>"logs/ret/all/$(date +"%Y%m%d%H%M%S%N").log" 2>&1