#!/usr/bin/env bash 

## 生成Shadoweocket使用的conf文件
## 根据输入list生成DOMAIN-SUFFIX,REJECT -> [Rule]
##
## 过滤广告
## DOMAIN-SUFFIX：后面最加域名
## REJECT：该模式直接返回404
## REJECT-DROP: 直接丢弃IP包
## Rule：中配置需要拦截广告的站点
##


inputFile="/Users/kimi/Desktop/ads_kimi_domains.list"
yamlOutputFile="/Users/kimi/Desktop/广告过滤.yaml"

confOutputFile="/Users/kimi/Desktop/广告过滤.conf"
confOutputFileLite="/Users/kimi/Desktop/广告过滤Lite.conf"



## 将变量的值写入文件方法
# rule="Text"
# printf "%s" "$rule" >> "$confOutputFile"
# echo "$rule" >> "$confOutputFile"


##
# 需求：
# 读取输入文件 ads_kimi_domains.list
# 每行前面加：DOMAIN-SUFFIX,
# 每行后面加：,REJECT
# 写入输出文件 ads_kimi_domains.yaml
# 并且过滤掉空行
# sed '/^\s*$/d; s/^/- DOMAIN-SUFFIX,/; s/$/,REJECT/' "$inputFile" > "$outputFile"




## ------------------------------------生成Shadoweocket使用的conf文件------------------------------------
Rule="# 该规则用于Shadoweocket自定义的广告过滤
# 并且该配置文件用于其它配置的文件的子规则
# [General]
# bypass-system = true
# skip-proxy = 192.168.0.0/16, 10.0.0.0/8, 172.16.0.0/12, localhost, *.local, captive.apple.com
# # tun-excluded-routes = 10.0.0.0/8, 100.64.0.0/10, 127.0.0.0/8, 169.254.0.0/16, 172.16.0.0/12, 192.0.0.0/24, 192.0.2.0/24, 192.88.99.0/24, 192.168.0.0/16, 198.51.100.0/24, 203.0.113.0/24, 224.0.0.0/4, 255.255.255.255/32, 239.255.255.250/32
# dns-server = system
# fallback-dns-server = system
# ipv6 = true
# prefer-ipv6 = false
# dns-direct-system = false
# icmp-auto-reply = true
# always-reject-url-rewrite = false
# private-ip-answer = true

# # direct domain fail to resolve use proxy rule
# dns-direct-fallback-proxy = true

# # The fallback behavior when UDP traffic matches a policy that doesn't support the UDP relay. Possible values: DIRECT, REJECT.
# udp-policy-not-supported-behaviour = REJECT


[Proxy Group]
🛑 广告拦截 = select,REJECT



# 过滤广告
# DOMAIN-SUFFIX：后面最加域名
# REJECT：该模式直接返回404
# REJECT-DROP: 直接丢弃IP包
# Rule：中配置需要拦截广告的站点
#
# ermaozi-tiktok.conf中的示例。
# RULE-SET,https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/BanProgramAD.list,🛑 广告拦截
# 
[Rule]

# 自定义规则"
echo "$Rule" > "$confOutputFile"
echo "$Rule" > "$confOutputFileLite"




## 将list中手动过滤的站点按行写入输出文件
sed '/^\s*$/d; s/^/DOMAIN-SUFFIX,/; s/$/,REJECT/' "$inputFile" >> "$confOutputFile"
sed '/^\s*$/d; s/^/DOMAIN-SUFFIX,/; s/$/,REJECT/' "$inputFile" >> "$confOutputFileLite"




Rule="



## ------------------------------------adblockfilters------------------------------------
## 广告过滤规则站点:
## https://github.com/217heidai/adblockfilters
## https://github.com/TG-Twilight/AWAvenue-Ads-Rule
## 老旧未更新的规则示例：RULE-SET,https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/BanProgramAD.list,🛑 广告拦截
## 
"
echo "$Rule" >> "$confOutputFile"
echo "$Rule" >> "$confOutputFileLite"





Rule="##
## AdBlock Loon
## Homepage: https://github.com/217heidai/adblockfilters
## https://gh-proxy.com/https://raw.githubusercontent.com/217heidai/adblockfilters/main/rules/adblockloon.list
## https://gh-proxy.com/https://raw.githubusercontent.com/217heidai/adblockfilters/main/rules/adblockloonlite.list
## Description: 适用于 Shadowrocket 的去广告合并规则，每 8 个小时更新一次。规则源：AdGuard Base filter、AdGuard Chinese filter、AdGuard Mobile Ads filter、AdGuard DNS filter、AdRules DNS List、CJX's Annoyance List、EasyList、EasyList China、EasyPrivacy、xinggsf mv、jiekouAD、AWAvenue Ads Rule、DNS-Blocklists Light、Hblock、OISD Basic、StevenBlack hosts、Pollock hosts。Lite 版仅针对国内域名拦截。
## Lite 版仅针对国内域名拦截。
## adblockloon内容结构：
## DOMAIN-SUFFIX,0070tv.com
## 该规则在Shadowrocket中需要RULE-SET，示例 --> RULE-SET,https://gh-proxy.com/https://raw.githubusercontent.com/217heidai/adblockfilters/main/rules/adblockloon.list,🛑 广告拦截
##
## RULE-SET,https://gh-proxy.com/https://raw.githubusercontent.com/217heidai/adblockfilters/main/rules/adblockloonlite.list,🛑 广告拦截
## RULE-SET,https://gh-proxy.com/https://raw.githubusercontent.com/217heidai/adblockfilters/main/rules/adblockloon.list,🛑 广告拦截

## AdBlock Shadowrocket
## Homepage: https://github.com/217heidai/adblockfilters
## https://gh-proxy.com/https://raw.githubusercontent.com/217heidai/adblockfilters/main/rules/adblockclash.list
## https://gh-proxy.com/https://raw.githubusercontent.com/217heidai/adblockfilters/main/rules/adblockclashlite.list
## Description: 适用于 Shadowrocket 的去广告合并规则，每 8 个小时更新一次。规则源：AdGuard Base filter、AdGuard Chinese filter、AdGuard Mobile Ads filter、AdGuard DNS filter、AdRules DNS List、CJX's Annoyance List、EasyList、EasyList China、EasyPrivacy、xinggsf mv、jiekouAD、AWAvenue Ads Rule、DNS-Blocklists Light、Hblock、OISD Basic、StevenBlack hosts、Pollock hosts。
## Lite 版仅针对国内域名拦截。
## adblockclash内容结构：
## [Rule]
## DOMAIN-SUFFIX,0-0.fr,REJECT-DROP
## 该规则Shadowrocket可以直接使用
##
## ------------------------------------adblockfilters------------------------------------

## 设置远程分组"
echo "$Rule" >> "$confOutputFile"
echo "$Rule" >> "$confOutputFileLite"



Rule="RULE-SET,https://gh-proxy.com/https://raw.githubusercontent.com/217heidai/adblockfilters/main/rules/adblockloon.list,🛑 广告拦截

"
echo "$Rule" >> "$confOutputFile"


Rule="RULE-SET,https://gh-proxy.com/https://raw.githubusercontent.com/217heidai/adblockfilters/main/rules/adblockloonlite.list,🛑 广告拦截

"
echo "$Rule" >> "$confOutputFileLite"





## ------------------------------------生成Clash使用的yaml文件------------------------------------
# echo "" > "$yamlOutputFile"
# sed '/^\s*$/d; s/^/- DOMAIN-SUFFIX,/; s/$/,REJECT-DROP/' "$inputFile" >> "$yamlOutputFile"
# echo "
# " >> "$yamlOutputFile"


Rule="# 该规则用于Clash自定义的广告过滤
[Proxy Group]
🛑 广告拦截 = select,REJECT



# 过滤广告
# DOMAIN-SUFFIX：后面最加域名
# REJECT：该模式直接返回404
# REJECT-DROP: 直接丢弃IP包
# Rule：中配置需要拦截广告的站点
#
# ermaozi-tiktok.conf中的示例。
# RULE-SET,https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/BanProgramAD.list,🛑 广告拦截
# 
[Rule]

# 自定义规则"
echo "$Rule" > "$yamlOutputFile"


## 将list中手动过滤的站点按行写入输出文件
sed '/^\s*$/d; s/^/- DOMAIN-SUFFIX,/; s/$/,REJECT/' "$inputFile" >> "$yamlOutputFile"


Rule="##
## AdBlock Loon
## Homepage: https://github.com/217heidai/adblockfilters
## https://gh-proxy.com/https://raw.githubusercontent.com/217heidai/adblockfilters/main/rules/adblockloon.list
## https://gh-proxy.com/https://raw.githubusercontent.com/217heidai/adblockfilters/main/rules/adblockloonlite.list
## Description: 适用于 Shadowrocket 的去广告合并规则，每 8 个小时更新一次。规则源：AdGuard Base filter、AdGuard Chinese filter、AdGuard Mobile Ads filter、AdGuard DNS filter、AdRules DNS List、CJX's Annoyance List、EasyList、EasyList China、EasyPrivacy、xinggsf mv、jiekouAD、AWAvenue Ads Rule、DNS-Blocklists Light、Hblock、OISD Basic、StevenBlack hosts、Pollock hosts。Lite 版仅针对国内域名拦截。
## Lite 版仅针对国内域名拦截。
## adblockloon内容结构：
## DOMAIN-SUFFIX,0070tv.com
## 该规则在Shadowrocket中需要RULE-SET，示例 --> RULE-SET,https://gh-proxy.com/https://raw.githubusercontent.com/217heidai/adblockfilters/main/rules/adblockloon.list,🛑 广告拦截
##
## RULE-SET,https://gh-proxy.com/https://raw.githubusercontent.com/217heidai/adblockfilters/main/rules/adblockloonlite.list,🛑 广告拦截
## RULE-SET,https://gh-proxy.com/https://raw.githubusercontent.com/217heidai/adblockfilters/main/rules/adblockloon.list,🛑 广告拦截

## AdBlock Shadowrocket
## Homepage: https://github.com/217heidai/adblockfilters
## https://gh-proxy.com/https://raw.githubusercontent.com/217heidai/adblockfilters/main/rules/adblockclash.list
## https://gh-proxy.com/https://raw.githubusercontent.com/217heidai/adblockfilters/main/rules/adblockclashlite.list
## Description: 适用于 Shadowrocket 的去广告合并规则，每 8 个小时更新一次。规则源：AdGuard Base filter、AdGuard Chinese filter、AdGuard Mobile Ads filter、AdGuard DNS filter、AdRules DNS List、CJX's Annoyance List、EasyList、EasyList China、EasyPrivacy、xinggsf mv、jiekouAD、AWAvenue Ads Rule、DNS-Blocklists Light、Hblock、OISD Basic、StevenBlack hosts、Pollock hosts。
## Lite 版仅针对国内域名拦截。
## adblockclash内容结构：
## [Rule]
## DOMAIN-SUFFIX,0-0.fr,REJECT-DROP
## 该规则Shadowrocket可以直接使用
##
## ------------------------------------adblockfilters------------------------------------

## 设置远程分组"
echo "$Rule" >> "$yamlOutputFile"



Rule="RULE-SET,https://gh-proxy.com/https://raw.githubusercontent.com/217heidai/adblockfilters/main/rules/adblockclash.list,🛑 广告拦截

"
echo "$Rule" >> "$yamlOutputFile"




