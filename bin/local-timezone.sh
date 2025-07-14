TZ=Europe/Zurich # $(curl -s http://ip-api.com/json | jq -r .timezone)
localzone=`TZ="$TZ" date "+%m/%d %H:%M"`

if [ "$TZ" = "Asia/Seoul" ]; then
    echo ""
    return 0
fi

echo "$localzone"
