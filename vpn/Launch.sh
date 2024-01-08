#!/usr/bin/env bash 

# 切换进入当前目录
toProjectDir()
{
    path=$0
    first=${path:0:1}
    if [[ $first == "/" ]]; then
        path=${path%/*}
        cd "$path"
    fi
}
toProjectDir
clear



launchRun()
{
	echo "launchRun"
	VPNParser/Run
}

launchSubconver()
{
	#延迟执行，防止被VPNParser/Run kill掉
	sleep 3
	echo "launchSubconver"
	subconverter/subconverter
}

launchYaml()
{
	#注意:
	#在Github Action 中 VPNParser/Run解析VPN节点后不回调Block执行ParserDone.command脚本
	#并且VPNParser/Run只执行了几秒钟(5)就结束了,Github Action给定的任务时间并不能将程序执行完毕。
	#目前的解决方法就是执行下面的代码为shell脚本执行一段延时操作,让VPNParser/Run有足够的时间执行完毕。

	echo "launchYaml"
	sleep 90
	cd VPNParser
	./clash.sh

	# #重新获取获取最新clash.sh
	sleep 2
	curl "http://127.0.0.1:25505/builder/clash.sh"
	exit
}


addPermission(){
	echo "为需要执行的脚本添加可执行权限"

	chmod +x VPNParser/clash.sh
	chmod -R +x VPNParser/Resources/Tasks/

}


addPermission
launchRun  & launchSubconver & launchYaml 

