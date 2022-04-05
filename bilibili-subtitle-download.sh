#https://cangshui.net/4935.html 沧水博客
#yum install -y p7zip*
#apt install -y p7zip*
rm -rf index*
rm -rf season*
echo "下载的字幕文件将会存放在season目录中，若文件皆为空白，则说明该番剧没有字幕文件！"
echo "输入番剧地址:(结尾为带md字眼的链接，如https://www.bilibili.com/bangumi/media/md28234736/"
read -p "请输入:" videourl
wget -N --no-check-certificate -O index.zip "$videourl" 
7z x index.zip
season_id=$( grep -o "season_id.........season_status" index )
season_id=`echo  "$season_id" | tr -cd "[0-9]" `
echo "season_id是:"$season_id
wget -N --no-check-certificate -O season.json "https://api.bilibili.com/pgc/web/season/section?season_id=$season_id"
sed -i 's/{\"aid/\n{\"aid/g' season.json
sed -i '1d' season.json
sed -i 's/{\"aid\"\:/◎◎◎/g' season.json
sed -i 's/\,\"badge\"\:/\n☆☆☆/g' season.json
sed -i 's/\"cid\"\:/\n△△△/g' season.json
sed -i 's/\,\"cover\"/\n☆☆☆/g' season.json
sed -i '/☆☆☆/d' season.json
sed -i 's/◎◎◎/https\:\/\/api.bilibili.com\/x\/player\/v2\?aid\=/g' season.json
sed -i 's/△△△/\&cid\=/g' season.json
sed -i ':a;N;s/\n//;ta' season.json
sed -i 's/https/\nhttps/g' season.json
sed -i '1d' season.json
ii="0"
cclink=""
rm -rf season
mkdir season
for line in $(cat season.json) 
do
  ii=`expr $ii + 1`
  echo 第$ii集$line
  wget -N --no-check-certificate -O ./season/"$ii" "$line"
  sed -i 's/\"subtitle_url\"\:\"/\nhttps\:/g' ./season/"$ii"
  sed -i 's/\"\,\"type/\n/g' ./season/"$ii"
  sed -i '/id_str/d' ./season/"$ii"
  sed -i '/bvid/d' ./season/"$ii"
  cclink=$( cat ./season/"$ii" | head -n 1 )
  wget -N --no-check-certificate -O ./season/"$ii".bcc "$cclink"
  rm -rf ./season/"$ii"
done
