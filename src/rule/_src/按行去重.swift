//
// Untitled 4.txt
// Created by kimi on 2026/2/11.

/**
* 文件路径:/Volumes/ExData/Remote-ExData/Z---本地工具集/AutoTask/src/rule/-src/按行去重.swift
**/

import Foundation

let input = "/Volumes/ExData/Remote-ExData/Z---本地工具集/AutoTask/src/rule/_src/ads_kimi_domains.list"


let KimiCustomADListPath = "/Volumes/ExData/Remote-ExData/Z---本地工具集/AutoTask/src/rule/ads/KimiCustomAD.list"

let clashRulePath = "/Volumes/ExData/Remote-ExData/Z---本地工具集/AutoTask/src/rule/_src/output/rule-clash.list"
let shadowrocketRulePath = "/Volumes/ExData/Remote-ExData/Z---本地工具集/AutoTask/src/rule/_src/output/rule-shadowrocket.list"
let domainRulePath = "/Volumes/ExData/Remote-ExData/Z---本地工具集/AutoTask/src/rule/_src/output/rule-domain.list"



//按行添加的前缀
var Prefix = ""
Prefix = "DOMAIN-SUFFIX,"
Prefix = "- DOMAIN-SUFFIX,"

//按行添加的后缀
var Suffix = ""
Suffix = ",⛔️ 广告拦截"


print("-------------------------------按行去重-------------------------------")

extension String {
	/**
	* 将字符串按行分割，并去除首尾空格，
	**/
	func filteredLines() -> [String] {
		return self
			.components(separatedBy: .newlines) //按行分割
			.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) } // 去掉首尾空白
			.filter { !$0.isEmpty }          // 去空行
			.filter { !$0.hasPrefix("#") }   // 去除开头字符为#的行
			.filter { !$0.hasPrefix("[Rule]") }   // 去除开头字符为[Rule]的行
	}
	
	/// 去除开头指定前缀
	func removingPrefix(_ prefix: String) -> String {
		guard self.hasPrefix(prefix) else { return self }
		return String(self.dropFirst(prefix.count))
	}
	
	/// 去除结尾指定后缀
	func removingSuffix(_ suffix: String) -> String {
		guard self.hasSuffix(suffix) else { return self }
		return String(self.dropLast(suffix.count))
	}
}

extension Array where Element: Hashable {
	/**
	* 去重（保持原数组顺序）
	**/
	func uniqued() -> [Element] {
		var seen = Set<Element>()
		return self.filter { seen.insert($0).inserted }
	}
}

extension Array where Element == String {
	/**
	* separator:按行分割的分隔符
	* prefix: 每行开头添加的字符
	* suffix: 每行结尾处添加的字符
	**/
	func joinedLines(separator:String = "\n", prefix:String = "",suffix:String = "") -> String{
		let newLines = self.map { prefix + String($0) + suffix }
		return newLines.joined(separator: separator)
	}
}



//解析文件
guard let fileStr = try? String(contentsOfFile: input, encoding: .utf8) else {
	print("文件打开失败！ file:\(input)")
	exit(0)
}

//按行分割，并去重
var lines = fileStr.filteredLines().uniqued()
//去除首尾前缀，只保留域名
lines = lines.map({ (newLine) in
	newLine
	.removingPrefix(Prefix)
	.removingPrefix("DOMAIN-SUFFIX,")
	.removingPrefix("-DOMAIN-SUFFIX,")
	.removingPrefix("- DOMAIN-SUFFIX,")
	.removingSuffix(Suffix)
	.removingSuffix(",🔰 节点选择")
	.removingSuffix(",♻️ 自动选择")
	.removingSuffix(",⛔️ 广告拦截")
	.removingSuffix(",🚫 运营劫持")
	.removingSuffix(",🇨🇳 国内直连")
	.removingSuffix(",🌍 国外直连")
	.removingSuffix(",🌍 国外代理")
	.removingSuffix(",🌐 代理加速")
	.removingSuffix(",🌩️ Cloudflare")
	.removingSuffix(",🍎 苹果服务")
	.removingSuffix(",🎯 全球直连")
	.removingSuffix(",🛑 全球拦截")
	.removingSuffix(",🐟 漏网之鱼")
	.removingSuffix(",🛑 拦截广告")
	.removingSuffix(",DIRECT")
	.removingSuffix(",REJECT")
})
//再次去重
lines = lines.uniqued()



let domainRule = lines.joined(separator: "\n")
let clashRule = lines.joinedLines(separator: "\n", prefix: "- DOMAIN-SUFFIX,", suffix: ",⛔️ 广告拦截")
let shadowrocketRule = lines.joinedLines(separator: "\n", prefix: "DOMAIN-SUFFIX,", suffix: ",⛔️ 广告拦截")
var KimiCustomADList = lines.joinedLines(separator: "\n", prefix: "DOMAIN-SUFFIX,", suffix: "")

var head = """
##
## KimiCustomAD.list
## 自定义的广告屏蔽域名，路由规则一般选“⛔️ 广告拦截”
## 数量：\(lines.count)
##




"""
KimiCustomADList = head + KimiCustomADList



print("总行数：\(lines.count)")
do{
//	try domainRule.write(toFile: input, atomically: true, encoding: .utf8)
	try domainRule.write(toFile: domainRulePath, atomically: true, encoding: .utf8)
		
	try clashRule.write(toFile: clashRulePath, atomically: true, encoding: .utf8)
	try shadowrocketRule.write(toFile: shadowrocketRulePath, atomically: true, encoding: .utf8)
	try KimiCustomADList.write(toFile: KimiCustomADListPath, atomically: true, encoding: .utf8)
	
	print("保存成功! file:\(domainRulePath)")
	print("保存成功! file:\(clashRulePath)")
	print("保存成功! file:\(shadowrocketRulePath)")
	print("保存成功! file:\(KimiCustomADListPath)")
}catch {
	print("保存错误，error:\(error)")
}

