#!/usr/bin/env bash 

# 获取当前脚本的绝对路径，并进入目录
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"
#
#


echo "更新Adpro-Team......"
curl "https://raw.githubusercontent.com/Adpro-Team/GKD_subscription/refs/heads/main/dist/Adpro_gkd.json5" > "Adpro-Team/gkd.json5"
curl "https://raw.githubusercontent.com/Adpro-Team/GKD_subscription/refs/heads/main/dist/Adpro_gkd.version.json5" > "Adpro-Team/gkd.version.json5"
echo ""


echo "更新AIsouler......"
curl "https://raw.githubusercontent.com/AIsouler/GKD_subscription/main/dist/AIsouler_gkd.json5" > "AIsouler/gkd.json5"
curl "https://raw.githubusercontent.com/AIsouler/GKD_subscription/main/dist/AIsouler_gkd.version.json5" > "AIsouler/gkd.version.json5"
echo ""


echo "更新aoguai......"
curl "https://raw.githubusercontent.com/aoguai/subscription/custom/dist/aoguai_gkd.json5" > "aoguai/gkd.json5"
curl "https://raw.githubusercontent.com/aoguai/subscription/custom/dist/aoguai_gkd.version.json5" > "aoguai/gkd.version.json5"
echo ""


echo "更新ganlinte......"
curl "https://raw.githubusercontent.com/ganlinte/GKD-subscription/main/dist/ganlin_gkd.json5" > "ganlinte/gkd.json5"
curl "https://raw.githubusercontent.com/ganlinte/GKD-subscription/main/dist/ganlin_gkd.version.json5" > "ganlinte/gkd.version.json5"
echo ""



echo "更新gkd-sub-repo......"
curl "https://raw.githubusercontent.com/gkd-sub-repo/114514_subscription/main/dist/114514_gkd.json5" > "gkd-sub-repo/gkd.json5"
curl "https://raw.githubusercontent.com/gkd-sub-repo/114514_subscription/main/dist/114514_gkd.version.json5" > "gkd-sub-repo/gkd.version.json5"
echo ""


echo "MengNianxiaoyao......"
curl "https://raw.githubusercontent.com/MengNianxiaoyao/gkd-subscription/main/dist/gkd.json5" > "MengNianxiaoyao/gkd.json5"
curl "https://raw.githubusercontent.com/MengNianxiaoyao/gkd-subscription/main/dist/gkd.version.json5" > "MengNianxiaoyao/gkd.version.json5"
echo ""



echo "更新YaChengMu......"
curl "https://raw.githubusercontent.com/YaChengMu/subscription/main/dist/gkd.json5" > "YaChengMu/gkd.json5"
curl "https://raw.githubusercontent.com/YaChengMu/subscription/main/dist/gkd.version.json5" > "YaChengMu/gkd.version.json5"
echo ""