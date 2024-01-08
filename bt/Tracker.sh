#!/usr/bin/env bash 


#切换进入当前目录
path=$0
first=${path:0:1}
if [[ $first == "/" ]]; then
	path=${path%/*}
	cd $path
fi





#数据源：
#		https://github.com/ngosang/trackerslist
#		https://github.com/XIU2/TrackersListCollection
#		https://trackerslist.com/all.txt
#  		https://www.cnblogs.com/marsggbo/p/12090703.html
#		https://cf.trackerslist.com/all.txt


# 数据下载
curl "https://raw.githubusercontent.com/ngosang/trackerslist/master/blacklist.txt" >tmp_list
curl "https://raw.githubusercontent.com/ngosang/trackerslist/master/trackers_all.txt" >>tmp_list
curl "https://raw.githubusercontent.com/ngosang/trackerslist/master/trackers_all_http.txt" >>tmp_list
curl "https://raw.githubusercontent.com/ngosang/trackerslist/master/trackers_all_https.txt" >>tmp_list
curl "https://raw.githubusercontent.com/ngosang/trackerslist/master/trackers_all_ip.txt" >>tmp_list
curl "https://raw.githubusercontent.com/ngosang/trackerslist/master/trackers_all_udp.txt" >>tmp_list
curl "https://raw.githubusercontent.com/ngosang/trackerslist/master/trackers_all_ws.txt" >>tmp_list
curl "https://raw.githubusercontent.com/ngosang/trackerslist/master/trackers_best.txt" >>tmp_list
curl "https://raw.githubusercontent.com/ngosang/trackerslist/master/trackers_best_ip.txt" >>tmp_list

curl "https://raw.githubusercontent.com/XIU2/TrackersListCollection/master/all.txt" >>tmp_list
curl "https://raw.githubusercontent.com/XIU2/TrackersListCollection/master/best.txt" >>tmp_list
curl "https://raw.githubusercontent.com/XIU2/TrackersListCollection/master/blacklist.txt" >>tmp_list
curl "https://raw.githubusercontent.com/XIU2/TrackersListCollection/master/http.txt" >>tmp_list

curl "https://trackerslist.com/all.txt" >>tmp_list

curl "https://cf.trackerslist.com/all.txt" >>tmp_list

curl "https://raw.githubusercontent.com/XIU2/TrackersListCollection/master/all_aria2.txt" >tmp_list_aria2
curl "https://raw.githubusercontent.com/XIU2/TrackersListCollection/master/best_aria2.txt" >>tmp_list_aria2
curl "https://raw.githubusercontent.com/XIU2/TrackersListCollection/master/http_aria2.txt" >>tmp_list_aria2



## 合并udp
# text=$(grep "udp://" tmp_list )
text=$(grep -Eoh "(udp)://+.*" tmp_list )
printf "$text" >trackers.tmp
sort -u trackers.tmp > ./tracker/trackers-udp.txt


## 合并http
text=$(grep -Eoh "(http)://+.*" tmp_list )
printf "$text" >trackers.tmp
sort -u trackers.tmp > ./tracker/trackers-http.txt

## 合并https
text=$(grep -Eoh "(https)://+.*" tmp_list )
printf "$text" >trackers.tmp
sort -u trackers.tmp > ./tracker/trackers-tls.txt


## 合并https+http
text=$(grep -Eoh ".*" ./tracker/trackers-http.txt )
printf "$text" >trackers.tmp
text=$(grep -Eoh ".*" ./tracker/trackers-tls.txt )
printf "$text" >>trackers.tmp
sort -u trackers.tmp > ./tracker/trackers-http-tls.txt

## 合并ws
text=$(grep -Eoh "(wss|ws)://+.*" tmp_list )
printf "$text" >trackers.tmp
sort -u trackers.tmp > ./tracker/trackers-ws.txt

## 合并aria2
text=$(grep -Eoh ".*" tmp_list_aria2 )
printf "$text" >trackers.tmp
sort -u trackers.tmp > ./tracker/trackers-aria2.txt

## 合并所有(aria2)除外
text=$(grep -Eoh ".*" ./tracker/trackers-udp.txt )
printf "$text" >trackers.tmp
text=$(grep -Eoh ".*" ./tracker/trackers-http-tls.txt )
printf "$text" >>trackers.tmp
text=$(grep -Eoh ".*" ./tracker/trackers-ws.txt )
printf "$text" >>trackers.tmp
sort -u trackers.tmp > ./tracker/trackers-all.txt



## 删除临时文件
rm -rf trackers.tmp
rm -rf tmp_list
rm -rf tmp_list_aria2


ls -l 
echo pwd:$(pwd)


### 拷贝到archive目录
cd ..
pwd
mkdir -p archive/bt
cp -r bt/tracker archive/bt/
cp -r bt/index.html archive/bt/


# #### 从文本中读取数据到text变量中
# #方式1
# text=`cat trackers-udp.txt`
# printf "$text" >trackers.tmp

# #方式2
# text=$(grep -Eoh ".*" trackers-udp.txt )
# printf "$text" >trackers.tmp

