#!/bin/sh

URL='curl -s https://www.marketwatch.com/investing/stock/$companyName' #companies
URL2='curl -s https://www.marketwatch.com/investing/index/$companyName' #market
URL3='curl -s https://www.marketwatch.com/investing/future/$companyName' #future

companies()
{
    companyName="$1"
    final=$(eval "$URL")
    close=$(printf '%s' "$final" | grep '<meta name="price" content="' | cut -d'"' -f4)
    current=$(printf '%s' "$final" | grep '<bg-quote class="value" field="Last" format="0,0.00"' | cut -d">" -f2 | awk -F'<' '{print "$" $1}')
    percentage=$(printf '%s' "$final"| grep '<span class="change--percent--q"><bg-quote field="percentchange" format="0,0.00%"' | cut -d'>' -f3 | awk -F% '{print $1 FS}')
    printf '%-10s%-15s%-15s%-15s' "$companyName" "$current" "$close"  "$percentage" 
}

market()
{
    companyName="$1"
    final=$(eval "$URL2")
    close=$(printf '%s' "$final" | grep '<td class="table__cell u-semi">' |cut -d'>' -f2 | awk -F'<' '{print "$" $1}')
    current=$(printf '%s' "$final" | grep '<meta name="price" content=' | awk -F'"' '{print "$" $4}' )
    percentage=$(printf '%s' "$final" | grep '<meta name="priceChangePercent" content='| cut -d'"' -f4 )
    printf '%-10s%-15s%-15s%-15s' "$companyName" "$current" "$close"  "$percentage" 
}

future()
{
    companyName="$1"
    final=$(eval "$URL3")
    current=$(printf '%s' "$final" | grep '<meta name="price" content=' | cut -d\" -f4)
    close=$(printf '%s' "$final" | grep '<td class="table__cell u-semi">' | cut -d'>' -f2 | cut -d\< -f1) 
    percentage=$( printf '%s' "$final" | grep '<meta name="priceChangePercent" content='| cut -d'"' -f4 )
    companyName=$(printf '%s' "$companyName" | sed 's/%20/ /g')
    printf '%-10s%-15s%-15s%-15s' "$companyName" "$current" "$close"  "$percentage" 
}
printf '%-10s%-15s%-15s%-15s' "Name" "Current Price" "Close Price"  "Percentage" 
printf "\n"
future "crude%20oil"
printf "\n"
companies "beke"
printf "\n"
future "gold"
printf "\n"
market "spx"
printf "\n"
market "djia"
printf "\n"
market "comp"
printf "\n"
market "gdow"
printf "\n"
