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
#clear


echo $(pwd)
mkdir -p list-yaml
cd list-yaml


## github.free.sync 
curl "http://127.0.0.1:25500/sub?target=clashr&url=http://127.0.0.1:25505/github.free.sync/all.base64&insert=false&list=false&emoji=true&sort=true&fdn=true&tfo=true&udp=true&scv=false&tls13=true&append_type=true" > "github.free.sync.all.yaml" 
curl "http://127.0.0.1:25500/sub?target=clashr&url=http://127.0.0.1:25505/github.free.sync/ss.base64&insert=false&list=false&emoji=true&sort=true&fdn=true&tfo=true&udp=true&scv=false&tls13=true&append_type=true" > "github.free.sync.ss.yaml" 
curl "http://127.0.0.1:25500/sub?target=clashr&url=http://127.0.0.1:25505/github.free.sync/ssr.base64&insert=false&list=false&emoji=true&sort=true&fdn=true&tfo=true&udp=true&scv=false&tls13=true&append_type=true" > "github.free.sync.ssr.yaml" 
curl "http://127.0.0.1:25500/sub?target=clashr&url=http://127.0.0.1:25505/github.free.sync/trojan.base64&insert=false&list=false&emoji=true&sort=true&fdn=true&tfo=true&udp=true&scv=false&tls13=true&append_type=true" > "github.free.sync.trojan.yaml" 
curl "http://127.0.0.1:25500/sub?target=clashr&url=http://127.0.0.1:25505/github.free.sync/vmess.base64&insert=false&list=false&emoji=true&sort=true&fdn=true&tfo=true&udp=true&scv=false&tls13=true&append_type=true" > "github.free.sync.vmess.yaml" 
curl "http://127.0.0.1:25500/sub?target=clashr&url=http://127.0.0.1:25505/github.free.sync/vless.base64&insert=false&list=false&emoji=true&sort=true&fdn=true&tfo=true&udp=true&scv=false&tls13=true&append_type=true" > "github.free.sync.vless.yaml" 



## github.free.merge 
curl "http://127.0.0.1:25500/sub?target=clashr&url=http://127.0.0.1:25505/github.free.merge/all.base64&insert=false&list=false&emoji=true&sort=true&fdn=true&tfo=true&udp=true&scv=false&tls13=true&append_type=true" > "github.free.merge.all.yaml" 
curl "http://127.0.0.1:25500/sub?target=clashr&url=http://127.0.0.1:25505/github.free.merge/ss.base64&insert=false&list=false&emoji=true&sort=true&fdn=true&tfo=true&udp=true&scv=false&tls13=true&append_type=true" > "github.free.merge.ss.yaml" 
curl "http://127.0.0.1:25500/sub?target=clashr&url=http://127.0.0.1:25505/github.free.merge/ssr.base64&insert=false&list=false&emoji=true&sort=true&fdn=true&tfo=true&udp=true&scv=false&tls13=true&append_type=true" > "github.free.merge.ssr.yaml" 
curl "http://127.0.0.1:25500/sub?target=clashr&url=http://127.0.0.1:25505/github.free.merge/trojan.base64&insert=false&list=false&emoji=true&sort=true&fdn=true&tfo=true&udp=true&scv=false&tls13=true&append_type=true" > "github.free.merge.trojan.yaml" 
curl "http://127.0.0.1:25500/sub?target=clashr&url=http://127.0.0.1:25505/github.free.merge/vmess.base64&insert=false&list=false&emoji=true&sort=true&fdn=true&tfo=true&udp=true&scv=false&tls13=true&append_type=true" > "github.free.merge.vmess.yaml" 
curl "http://127.0.0.1:25500/sub?target=clashr&url=http://127.0.0.1:25505/github.free.merge/vless.base64&insert=false&list=false&emoji=true&sort=true&fdn=true&tfo=true&udp=true&scv=false&tls13=true&append_type=true" > "github.free.merge.vless.yaml" 



## freefq.com 
curl "http://127.0.0.1:25500/sub?target=clashr&url=http://127.0.0.1:25505/freefq.com/all.base64&insert=false&list=false&emoji=true&sort=true&fdn=true&tfo=true&udp=true&scv=false&tls13=true&append_type=true" > "freefq.com.all.yaml" 
curl "http://127.0.0.1:25500/sub?target=clashr&url=http://127.0.0.1:25505/freefq.com/ss.base64&insert=false&list=false&emoji=true&sort=true&fdn=true&tfo=true&udp=true&scv=false&tls13=true&append_type=true" > "freefq.com.ss.yaml" 
curl "http://127.0.0.1:25500/sub?target=clashr&url=http://127.0.0.1:25505/freefq.com/ssr.base64&insert=false&list=false&emoji=true&sort=true&fdn=true&tfo=true&udp=true&scv=false&tls13=true&append_type=true" > "freefq.com.ssr.yaml" 
curl "http://127.0.0.1:25500/sub?target=clashr&url=http://127.0.0.1:25505/freefq.com/trojan.base64&insert=false&list=false&emoji=true&sort=true&fdn=true&tfo=true&udp=true&scv=false&tls13=true&append_type=true" > "freefq.com.trojan.yaml" 
curl "http://127.0.0.1:25500/sub?target=clashr&url=http://127.0.0.1:25505/freefq.com/vmess.base64&insert=false&list=false&emoji=true&sort=true&fdn=true&tfo=true&udp=true&scv=false&tls13=true&append_type=true" > "freefq.com.vmess.yaml" 
curl "http://127.0.0.1:25500/sub?target=clashr&url=http://127.0.0.1:25505/freefq.com/vless.base64&insert=false&list=false&emoji=true&sort=true&fdn=true&tfo=true&udp=true&scv=false&tls13=true&append_type=true" > "freefq.com.vless.yaml" 



## youneed.win 
curl "http://127.0.0.1:25500/sub?target=clashr&url=http://127.0.0.1:25505/youneed.win/all.base64&insert=false&list=false&emoji=true&sort=true&fdn=true&tfo=true&udp=true&scv=false&tls13=true&append_type=true" > "youneed.win.all.yaml" 
curl "http://127.0.0.1:25500/sub?target=clashr&url=http://127.0.0.1:25505/youneed.win/ss.base64&insert=false&list=false&emoji=true&sort=true&fdn=true&tfo=true&udp=true&scv=false&tls13=true&append_type=true" > "youneed.win.ss.yaml" 
curl "http://127.0.0.1:25500/sub?target=clashr&url=http://127.0.0.1:25505/youneed.win/ssr.base64&insert=false&list=false&emoji=true&sort=true&fdn=true&tfo=true&udp=true&scv=false&tls13=true&append_type=true" > "youneed.win.ssr.yaml" 
curl "http://127.0.0.1:25500/sub?target=clashr&url=http://127.0.0.1:25505/youneed.win/trojan.base64&insert=false&list=false&emoji=true&sort=true&fdn=true&tfo=true&udp=true&scv=false&tls13=true&append_type=true" > "youneed.win.trojan.yaml" 
curl "http://127.0.0.1:25500/sub?target=clashr&url=http://127.0.0.1:25505/youneed.win/vmess.base64&insert=false&list=false&emoji=true&sort=true&fdn=true&tfo=true&udp=true&scv=false&tls13=true&append_type=true" > "youneed.win.vmess.yaml" 
curl "http://127.0.0.1:25500/sub?target=clashr&url=http://127.0.0.1:25505/youneed.win/vless.base64&insert=false&list=false&emoji=true&sort=true&fdn=true&tfo=true&udp=true&scv=false&tls13=true&append_type=true" > "youneed.win.vless.yaml" 



## v2rayshare.com 
curl "http://127.0.0.1:25500/sub?target=clashr&url=http://127.0.0.1:25505/v2rayshare.com/level1&insert=false&list=false&emoji=true&sort=true&fdn=true&tfo=true&udp=true&scv=false&tls13=true&append_type=true" > "v2rayshare.com.level1.yaml" 
curl "http://127.0.0.1:25500/sub?target=clashr&url=http://127.0.0.1:25505/v2rayshare.com/level2&insert=false&list=false&emoji=true&sort=true&fdn=true&tfo=true&udp=true&scv=false&tls13=true&append_type=true" > "v2rayshare.com.level2.yaml" 
curl "http://127.0.0.1:25500/sub?target=clashr&url=http://127.0.0.1:25505/v2rayshare.com/level3&insert=false&list=false&emoji=true&sort=true&fdn=true&tfo=true&udp=true&scv=false&tls13=true&append_type=true" > "v2rayshare.com.level3.yaml" 
curl "http://127.0.0.1:25500/sub?target=clashr&url=http://127.0.0.1:25505/v2rayshare.com/level4&insert=false&list=false&emoji=true&sort=true&fdn=true&tfo=true&udp=true&scv=false&tls13=true&append_type=true" > "v2rayshare.com.level4.yaml" 
curl "http://127.0.0.1:25500/sub?target=clashr&url=http://127.0.0.1:25505/v2rayshare.com/level5&insert=false&list=false&emoji=true&sort=true&fdn=true&tfo=true&udp=true&scv=false&tls13=true&append_type=true" > "v2rayshare.com.level5.yaml" 



