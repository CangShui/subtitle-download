#https://cangshui.net/ 沧水博客
rm -rf index*
rm -rf season*
echo "下载的字幕文件将会存放在season目录中"
echo "输入剧集地址:(链接中为带“vod/数字”的链接，任意一集皆可，如https://www.viu.com/ott/hk/zh-hk/vod/430585/"
read -p "请输入:" videourl
wget -N --no-check-certificate -O index.html "$videourl"
sed -i 's/javascript\:initVideoPlay/javascript\:initVideoPlay\n◎◎◎/g' index.html
grep '◎◎◎' index.html > index.txt
sed -i 's/\,/\n\,/g' index.txt
grep '◎◎◎' index.txt > index2.txt
sed -i 's/^..........//' index2.txt
awk '{print "https://www.viu.com/ott/hk/index.php?area_id=1&language_flag_id=1&r=vod/ajax-detail&platform_flag_label=web&product_id=" $0}' index2.txt > index3.txt



ii=$(awk '{print NR}' index3.txt|tail -n1)
ep=""
rm -rf season
mkdir season
for line in $(cat index3.txt) 
do
  ep=$( printf "%02d\n" $ii )
  wget -N --no-check-certificate -O ./season/EP"$ep".html  "$line"
  sed -i 's/\,\"url\"\:\"/\nVVV/g' ./season/EP"$ep".html
  sed -i 's/\"\,\"subtitle_url/\n/g' ./season/EP"$ep".html
  grep 'VVV' ./season/EP"$ep".html > ./season/EP"$ep"A.html
  sed -i 's/VVV//g' ./season/EP"$ep"A.html
  sed -i "s:\\\::g" ./season/EP"$ep"A.html
  srturl=$(cat ./season/EP"$ep"A.html)
  wget -N --no-check-certificate -O ./season/EP"$ep".srt  "$srturl"
  ii=`expr $ii - 1`
done
rm -rf ./season/*.html
sizeA=$(du -h --max-depth=1 ./season | awk '{print $1}' | tr -d "a-zA-Z" |sed "s/\..*//g")
sizeB=$(find ./season  -type f | wc -l)
sizeB=`expr $sizeB \* 2`
if [[ $sizeA -le $sizeB ]]
  then
    echo "该剧集可能没有字幕文件"
  else
    echo ""
fi
