#https://cangshui.net/4964.html 沧水博客
rm -rf index*
rm -rf season*
echo "下载的字幕文件将会存放在season目录中"
echo "输入剧集地址:(链接中为带titles字眼的链接，如https://www.kktv.me/titles/06001246"
read -p "请输入:" videourl
wget -N --no-check-certificate -O index.html "$videourl"
subhls_num=$( grep -o "_sub_hls.m3u8" index.html | wc -l )
hls_num=$( grep -o "_hls.m3u8" index.html | wc -l )
if [[ $hls_num -eq '0' ]]
  then
    echo 该剧集可能没有字幕文件
  else
      if [[ $subhls_num -eq $hls_num ]]
      then
        echo 该剧集存在字幕文件
      else
        echo 该剧集可能没有字幕文件
      fi
fi

sed -i 's/theater\.kktv\.com\.tw/\n△△△/g' index.html
sed -i 's/\_sub\_hls\.m3u8/◎◎◎\n/g' index.html
grep '◎◎◎' index.html > index.txt
sed -i 's/◎◎◎/\_sub\_sub\/zh-Hant\.vtt/g' index.txt
sed -i 's/△△△/https\:\/\/theater-kktv\.cdn\.hinet\.net/g' index.txt

ii="0"
rm -rf season
mkdir season
for line in $(cat index.txt) 
do
  ii=`expr $ii + 1`
  ep=$( printf "%02d\n" $ii )
  wget -N --no-check-certificate -O ./season/EP"$ep".srt  "$line"
  sed -i '1d' ./season/EP"$ep".srt 
done