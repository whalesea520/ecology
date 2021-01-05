/*
 * A JavaScript implementation of GUID.
 * 
 * Copyright (C) 2008-2009 HanZhiyang <sea_deep@163.com> This library is free.
 * You can redistribute it and/or modify it. 示例：
 * alert($System.Math.IntUtil.genGUID());
 * alert($System.Math.IntUtil.genGUIDV4());
 * alert($System.Math.IntUtil.genRandomString(5));
 */
$System = {
	"Math" : {},
	"DS" : {},
	"Type" : {}
};

// 判断类型的工具类。
$System.Type.TypeUtil = function() {
	throw new Error("$System.Type.TypeUtil is a static class.");
}

$System.Type.TypeUtil.isString = function(value) {
	return ((typeof(value) == "string") || ((typeof value == "object") && (value instanceof String)));
}
$System.Type.TypeUtil.isDate = function(value) {
	return ((typeof value == "object") && (value instanceof Date));
}
$System.Type.TypeUtil.isRegExp = function(value) {
	return ((typeof value == "object") && (value instanceof RegExp));
}
$System.Type.TypeUtil.isArray = function(value) {
	return ((typeof value == "object") && (value instanceof Array));
}
$System.Type.TypeUtil.isNumber = function(value) {
	return !isNaN(value);
}
$System.Type.TypeUtil.isBoolean = function(value) {
	return ((typeof(value) == "boolean") || ((typeof value == "object") && (value instanceof Boolean)));
}
$System.Type.TypeUtil.isFunction = function(value) {
	return ((typeof value == "function") || ((typeof value == "object") && (value instanceof Function)));
}
$System.Type.TypeUtil.isInteger = function(value) {
	return ($System.Type.TypeUtil.isNumber(value) && (Math.round(value) == value));
}

$System.Type.TypeUtil.isFloat = function(value) {
	if ($System.Type.TypeUtil.isString(value)) {
		return false;
	}
	return ($System.Type.TypeUtil.isNumber(value) && (Math.round(value) != value));
}

$System.Type.TypeUtil.isError = function(value) {
	return ((typeof value == "object") && (value instanceof Error));
}

// 哈希表类
$System.DS.HashTable = function() {
	this.o = {};
	for (key in this.o) {
		delete this.o[key];
	}
	this.size = 0;
}
// 获取元素数目
$System.DS.HashTable.prototype.getSize = function() {
	return this.size;
}
// 添加键值对
$System.DS.HashTable.prototype.set = $System.DS.HashTable.prototype.add = function(
		key, value) {
	if (!(key in this.o)) {
		this.size++;
	}
	this.o[key] = {
		"v" : value
	};

}
// 取值
$System.DS.HashTable.prototype.get = function(key) {
	if (key in this.o) {
		return this.o[key]["v"];
	}
	return null;
}
// 检查值是否存在
$System.DS.HashTable.prototype.hasThisKey = function(key) {
	return (key in this.o);
}
// 取值相同的键名数组
$System.DS.HashTable.prototype.getKeyListByValue = function(value) {
	var list = [];
	for (key in this.o) {
		if (this.o[key]["v"] == value) {
			list.push(key);
		}
	}
	return list;
}
// 删除
$System.DS.HashTable.prototype.remove = function(key) {
	if (key in this.o) {
		this.size--;
		delete this.o[key]["v"];
		delete this.o[key];
	}
}
// 删除所有
$System.DS.HashTable.prototype.removeAll = function() {
	for (key in this.o) {
		delete this.o[key]["v"];
		delete this.o[key];
	}
	this.size = 0;
}

$System.DS.HashTable.prototype.getO = function() {
	return this.o;
}
// 当str1="=",str2="&"的时候，组织查询字符串
$System.DS.HashTable.prototype.join = function(str1, str2) {
	var a = new Array();
	for (key in this.o) {
		a.push(key + str1 + this.get(key));
	}
	return a.join(str2);
}
// 销毁
$System.DS.HashTable.dispose = function(oht) {
	oht.dispose();
	oht = null;

}
// 销毁
$System.DS.HashTable.prototype.dispose = function() {
	this.removeAll();
}

// 整数工具类（还有大整数类，加密类，md5类等等以后慢慢贴上来）
$System.Math.IntUtil = function() {
	throw new Error("$System.Math.IntUtil is a static class.")
}

// 十进制到二机制转换，注释里面的方式也可以用，下同。依赖js中的整数范围，不可靠。
$System.Math.IntUtil.dec2Bin = function(decInt) {
	/*
	 * var m = 0; var s = 0; var binStr = ""; if(decInt == 0){ return "0"; }
	 * while(decInt != 0){ m = decInt % 2; decInt = (decInt - m) /2; binStr = m +
	 * binStr; } return binStr;
	 */
	return decInt.toString(2);
}

$System.Math.IntUtil.hexNumArray = new Array("0", "1", "2", "3", "4", "5", "6",
		"7", "8", "9", "A", "B", "C", "D", "E", "F");
// 十进制到十六进制转换。
$System.Math.IntUtil.dec2Hex = function(decInt) {
	// var hexNumArray = new Array("0" , "1" , "2" , "3" , "4" , "5" , "6" , "7"
	// , "8" , "9" , "A" , "B" , "C" , "D" , "E" , "F");
	/*
	 * var hexNumArray = $System.Math.IntUtil.hexNumArray; var m = 0; var s = 0;
	 * var hexStr = ""; if(decInt == 0){ return "0"; } while(decInt != 0){ m =
	 * decInt % 16; decInt = (decInt - m) / 16; hexStr = hexNumArray[m] +
	 * hexStr; } return hexStr;
	 */
	return decInt.toString(16).toUpperCase();
}

$System.Math.IntUtil.numHexArray = {
	"0" : "0",
	"1" : "1",
	"2" : "2",
	"3" : "3",
	"4" : "4",
	"5" : "5",
	"6" : "6",
	"7" : "7",
	"8" : "8",
	"9" : "9",
	"A" : "10",
	"B" : "11",
	"C" : "12",
	"D" : "13",
	"E" : "14",
	"F" : "15"
};
// 十六进制到十进制转换。
$System.Math.IntUtil.hex2Dec = function(oriHexStr) {
	// var numHexArray = {"0" : "0" , "1" : "1" , "2" : "2" , "3" : "3" , "4" :
	// "4" , "5" : "5" , "6" : "6" , "7" : "7" , "8" : "8" , "9" : "9" , "A" :
	// "10" , "B" : "11" , "C" : "12" , "D" : "13" , "E" : "14" , "F" : "15"};
	/*
	 * var numHexArray = $System.Math.IntUtil.numHexArray; hexStr =
	 * oriHexStr.toUpperCase(); var iniArray = hexStr.split(""); var numArray =
	 * iniArray.reverse(); var len = numArray.length; var decInt = 0; var num =
	 * 0; for(var i = 0 ; i < len ; i ++){ num +=
	 * parseInt(numHexArray[numArray[i]]) * Math.pow(16 , i); } return num;
	 */
	return parseInt(oriHexStr, 16);
}
// 二进制到十进制转换。
$System.Math.IntUtil.bin2Dec = function(binStr) {
	/*
	 * var iniArray = binStr.split(""); var numArray = iniArray.reverse(); var
	 * len = numArray.length; var decInt = 0; var num = 0; for(var i = 0 ; i <
	 * len ; i ++){ num += parseInt(numArray[i]) * Math.pow(2 , i); } return
	 * num;
	 */
	return parseInt(binStr, 2);
}

$System.Math.IntUtil.binHexArray = {
	"0000" : "0",
	"0001" : "1",
	"0010" : "2",
	"0011" : "3",
	"0100" : "4",
	"0101" : "5",
	"0110" : "6",
	"0111" : "7",
	"1000" : "8",
	"1001" : "9",
	"1010" : "A",
	"1011" : "B",
	"1100" : "C",
	"1101" : "D",
	"1110" : "E",
	"1111" : "F"
};
// 二进制到十六进制转换，这个很可靠，因为是字符串，不受整数类型范围限制。
$System.Math.IntUtil.bin2Hex = function(binStr) {
	var n = 0;
	while (binStr.charAt(n) == "0") {
		n++;
	}
	if (n > 0) {
		binStr = binStr.substring(n, binStr.length);
	}
	var i, hexStrArray = [], binHexArray = $System.Math.IntUtil.binHexArray, len = binStr.length;
	for (i = len; i > 3; i = i - 4) {
		hexStrArray.push(binHexArray[binStr.substring(i - 4, i)]);
	}
	hexStrArray.push(binHexArray[$System.Math.IntUtil.fillZero(binStr
					.substring(i - 4, i), 4)]);
	return hexStrArray.reverse().join("");
}

$System.Math.IntUtil.hexBinArray = {
	"0" : "0000",
	"1" : "0001",
	"2" : "0010",
	"3" : "0011",
	"4" : "0100",
	"5" : "0101",
	"6" : "0110",
	"7" : "0111",
	"8" : "1000",
	"9" : "1001",
	"A" : "1010",
	"B" : "1011",
	"C" : "1100",
	"D" : "1101",
	"E" : "1110",
	"F" : "1111"
};
// 十六进制到二进制转换。
$System.Math.IntUtil.hex2Bin = function(hexStr) {
	var n = 0;
	while (hexStr.charAt(n) == "0") {
		n++;
	}
	if (n > 0) {
		hexStr = hexStr.substring(n, hexStr.length);
	}
	var hexStrArray = hexStr.split(""), len = hexStrArray.length, binStrArray = [], hexBinArray = $System.Math.IntUtil.hexBinArray;
	for (var i = 0; i < len; i++) {
		binStrArray.push(hexBinArray[hexStrArray[i]]);
	}
	return binStrArray.join("");
}

// 补零的方法。
$System.Math.IntUtil.fillZero = function(str, stdLength, allowEmpty) {
	if (str == "" && !allowEmpty) {
		return "";
	}
	c = stdLength - str.length;
	var str0 = ""
	for (var i = 0; i < c; i++) {
		str0 = "0" + str0;
	}
	return str0 + str;
}

/*
 * $System.Math.IntUtil.__GUIDPool = {}; for(key in
 * $System.Math.IntUtil.__GUIDPool){ delete
 * $System.Math.IntUtil.__GUIDPool[key]; }
 * 
 * $System.Math.IntUtil.__GUIDCheckAndAdd = function(guid){
 * if(!$System.Math.IntUtil.__GUIDPool[guid]){ return
 * $System.Math.IntUtil.__GUIDPool[guid] = true; } else{ return false; } }
 */
// guid池，避免重复guid。
$System.Math.IntUtil.__GUIDPool = new $System.DS.HashTable();

$System.Math.IntUtil.__GUIDCheckAndAdd = function(guid) {
	if (!$System.Math.IntUtil.__GUIDPool.hasThisKey(guid)) {
		$System.Math.IntUtil.__GUIDPool.set(guid, true);
		return true;
	} else {
		return false;
	}
}

// 不补零的guid。
$System.Math.IntUtil.__genGUID = function() {
	var part1 = $System.Math.IntUtil.dec2Hex(Math.floor(Math.random()
			* ($System.Math.IntUtil.hex2Dec("FFFFFFFF") + 1)));
	var part2 = $System.Math.IntUtil.dec2Hex(Math.floor(Math.random() * 65536));
	var str4 = $System.Math.IntUtil.fillZero($System.Math.IntUtil.dec2Bin(Math
			.floor(Math.random() * 256)));
	var part3 = $System.Math.IntUtil.dec2Hex(Math.floor(Math.random() * 65536));
	// var part4 =
	// $System.Math.IntUtil.dec2Hex($System.Math.IntUtil.bin2Dec(str4.substr(0 ,
	// 5) + "01" + str4.substr(7 , 1)));
	var part4 = $System.Math.IntUtil.bin2Hex(str4.substr(0, 5) + "01"
			+ str4.substr(7, 1));
	var part5 = $System.Math.IntUtil.dec2Hex(Math.floor(Math.random() * 256));
	var part6 = $System.Math.IntUtil.dec2Hex(Math.floor(Math.random()
			* ($System.Math.IntUtil.hex2Dec("FFFFFFFFFFFF") + 1)));
	var guid = "GUID_" + part1 + "_" + part2 + "_" + part3 + "_" + part4
			+ part5 + "_" + part6;
	if ($System.Math.IntUtil.__GUIDCheckAndAdd(guid)) {
		return guid;
	} else {
		return $System.Math.IntUtil.__genGUID();
	}
}
// 补了零的标准的guid格式（当然多了个“guid_”前缀,以及使用“_”代替“-”）。
$System.Math.IntUtil.genGUID = function() {
	var part1 = $System.Math.IntUtil.dec2Hex(Math.floor(Math.random()
			* ($System.Math.IntUtil.hex2Dec("FFFFFFFF") + 1)));
	var part2 = $System.Math.IntUtil.dec2Hex(Math.floor(Math.random() * 65536));
	var str4 = $System.Math.IntUtil.fillZero($System.Math.IntUtil.dec2Bin(Math
			.floor(Math.random() * 256)));
	var part3 = $System.Math.IntUtil.dec2Hex(Math.floor(Math.random() * 65536));
	// var part4 =
	// $System.Math.IntUtil.dec2Hex($System.Math.IntUtil.bin2Dec(str4.substr(0 ,
	// 5) + "01" + str4.substr(7 , 1)));
	var part4 = $System.Math.IntUtil.bin2Hex(str4.substr(0, 5) + "01"
			+ str4.substr(7, 1));
	var part5 = $System.Math.IntUtil.dec2Hex(Math.floor(Math.random() * 256));
	var part6 = $System.Math.IntUtil.dec2Hex(Math.floor(Math.random()
			* ($System.Math.IntUtil.hex2Dec("FFFFFFFFFFFF") + 1)));
	part1 = $System.Math.IntUtil.fillZero(part1, 8);
	part2 = $System.Math.IntUtil.fillZero(part2, 4);
	part3 = $System.Math.IntUtil.fillZero(part3, 4);
	part4 = $System.Math.IntUtil.fillZero(part4, 2);
	part5 = $System.Math.IntUtil.fillZero(part5, 2);
	part6 = $System.Math.IntUtil.fillZero(part6, 12);
	var guid = "GUID_" + part1 + "_" + part2 + "_" + part3 + "_" + part4
			+ part5 + "_" + part6;
	if ($System.Math.IntUtil.__GUIDCheckAndAdd(guid)) {
		return guid;
	} else {
		return $System.Math.IntUtil.genGUID();
	}
}
// V4的guid。
$System.Math.IntUtil.genGUIDV4 = function() {
	var part1 = $System.Math.IntUtil.dec2Hex(Math.floor(Math.random()
			* ($System.Math.IntUtil.hex2Dec("FFFFFFFF") + 1)));
	var part2 = $System.Math.IntUtil.dec2Hex(Math.floor(Math.random() * 65536));
	var str3 = $System.Math.IntUtil.fillZero($System.Math.IntUtil.dec2Bin(Math
					.floor(Math.random() * 65536)), 16);
	// var part3 =
	// $System.Math.IntUtil.dec2Hex($System.Math.IntUtil.bin2Dec(str3.substr(0 ,
	// 12) + "0100"));
	var part3 = $System.Math.IntUtil.bin2Hex(str3.substr(0, 12) + "0100");
	var str4 = $System.Math.IntUtil.fillZero($System.Math.IntUtil.dec2Bin(Math
			.floor(Math.random() * 256)));
	// var part4 =
	// $System.Math.IntUtil.dec2Hex($System.Math.IntUtil.bin2Dec(str4.substr(0 ,
	// 5) + "01" + str4.substr(7 , 1)));
	var part4 = $System.Math.IntUtil.bin2Hex(str4.substr(0, 5) + "01"
			+ str4.substr(7, 1));
	var part5 = $System.Math.IntUtil.dec2Hex(Math.floor(Math.random() * 256));
	var part6 = $System.Math.IntUtil.dec2Hex(Math.floor(Math.random()
			* ($System.Math.IntUtil.hex2Dec("FFFFFFFFFFFF") + 1)));
	part1 = $System.Math.IntUtil.fillZero(part1, 8);
	part2 = $System.Math.IntUtil.fillZero(part2, 4);
	part3 = $System.Math.IntUtil.fillZero(part3, 4);
	part4 = $System.Math.IntUtil.fillZero(part4, 2);
	part5 = $System.Math.IntUtil.fillZero(part5, 2);
	part6 = $System.Math.IntUtil.fillZero(part6, 12);
	var guid = "GUID_" + part1 + "_" + part2 + "_" + part3 + "_" + part4
			+ part5 + "_" + part6;
	if ($System.Math.IntUtil.__GUIDCheckAndAdd(guid)) {
		return guid;
	} else {
		return $System.Math.IntUtil.genGUIDV4();
	}
}
// V4的guid。
$System.Math.IntUtil.genGUIDV4_v2 = function() {
	var part1 = $System.Math.IntUtil.dec2Hex(Math.floor(Math.random()
			* ($System.Math.IntUtil.hex2Dec("FFFFFFFF") + 1)));
	var part2 = $System.Math.IntUtil.dec2Hex(Math.floor(Math.random() * 65536));
	var str3 = $System.Math.IntUtil.fillZero($System.Math.IntUtil.dec2Bin(Math
					.floor(Math.random() * 65536)), 16);
	// var part3 =
	// $System.Math.IntUtil.dec2Hex($System.Math.IntUtil.bin2Dec(str3.substr(0 ,
	// 12) + "0100"));
	var part3 = $System.Math.IntUtil.bin2Hex(str3.substr(0, 12) + "0100");
	var str4 = $System.Math.IntUtil.fillZero($System.Math.IntUtil.dec2Bin(Math
			.floor(Math.random() * 256)));
	// var part4 =
	// $System.Math.IntUtil.dec2Hex($System.Math.IntUtil.bin2Dec(str4.substr(0 ,
	// 5) + "01" + str4.substr(7 , 1)));
	var part4 = $System.Math.IntUtil.bin2Hex(str4.substr(0, 5) + "01"
			+ str4.substr(7, 1));
	var part5 = $System.Math.IntUtil.dec2Hex(Math.floor(Math.random() * 256));
	var part6 = $System.Math.IntUtil.dec2Hex(Math.floor(Math.random()
			* ($System.Math.IntUtil.hex2Dec("FFFFFFFFFFFF") + 1)));
	part1 = $System.Math.IntUtil.fillZero(part1, 8);
	part2 = $System.Math.IntUtil.fillZero(part2, 4);
	part3 = $System.Math.IntUtil.fillZero(part3, 4);
	part4 = $System.Math.IntUtil.fillZero(part4, 2);
	part5 = $System.Math.IntUtil.fillZero(part5, 2);
	part6 = $System.Math.IntUtil.fillZero(part6, 12);
	var guid = part1 + "-" + part2 + "-" + part3 + "-" + part4
			+ part5 + "-" + part6;
	if ($System.Math.IntUtil.__GUIDCheckAndAdd(guid)) {
		return guid;
	} else {
		return $System.Math.IntUtil.genGUIDV4();
	}
}
// V4的guid。
$System.Math.IntUtil.genGUIDV4_v3 = function() {
	var part1 = $System.Math.IntUtil.dec2Hex(Math.floor(Math.random()
			* ($System.Math.IntUtil.hex2Dec("FFFFFFFF") + 1)));
	var part2 = $System.Math.IntUtil.dec2Hex(Math.floor(Math.random() * 65536));
	var str3 = $System.Math.IntUtil.fillZero($System.Math.IntUtil.dec2Bin(Math
					.floor(Math.random() * 65536)), 16);
	// var part3 =
	// $System.Math.IntUtil.dec2Hex($System.Math.IntUtil.bin2Dec(str3.substr(0 ,
	// 12) + "0100"));
	var part3 = $System.Math.IntUtil.bin2Hex(str3.substr(0, 12) + "0100");
	var str4 = $System.Math.IntUtil.fillZero($System.Math.IntUtil.dec2Bin(Math
			.floor(Math.random() * 256)));
	// var part4 =
	// $System.Math.IntUtil.dec2Hex($System.Math.IntUtil.bin2Dec(str4.substr(0 ,
	// 5) + "01" + str4.substr(7 , 1)));
	var part4 = $System.Math.IntUtil.bin2Hex(str4.substr(0, 5) + "01"
			+ str4.substr(7, 1));
	var part5 = $System.Math.IntUtil.dec2Hex(Math.floor(Math.random() * 256));
	var part6 = $System.Math.IntUtil.dec2Hex(Math.floor(Math.random()
			* ($System.Math.IntUtil.hex2Dec("FFFFFFFFFFFF") + 1)));
	part1 = $System.Math.IntUtil.fillZero(part1, 8);
	part2 = $System.Math.IntUtil.fillZero(part2, 4);
	part3 = $System.Math.IntUtil.fillZero(part3, 4);
	part4 = $System.Math.IntUtil.fillZero(part4, 2);
	part5 = $System.Math.IntUtil.fillZero(part5, 2);
	part6 = $System.Math.IntUtil.fillZero(part6, 12);
	var guid = part1 + part2 + part3 + part4
			+ part5 + part6;
	if ($System.Math.IntUtil.__GUIDCheckAndAdd(guid)) {
		return guid;
	} else {
		return $System.Math.IntUtil.genGUIDV4();
	}
}
// 获取一个guid长度的随机字符串。
$System.Math.IntUtil.__genRandomString = function() {
	var part1 = $System.Math.IntUtil.dec2Hex(Math.floor(Math.random()
			* ($System.Math.IntUtil.hex2Dec("FFFFFFFF") + 1)));
	var part2 = $System.Math.IntUtil.dec2Hex(Math.floor(Math.random() * 65536));
	var str4 = $System.Math.IntUtil.fillZero($System.Math.IntUtil.dec2Bin(Math
			.floor(Math.random() * 256)));
	var part3 = $System.Math.IntUtil.dec2Hex(Math.floor(Math.random() * 65536));
	// var part4 =
	// $System.Math.IntUtil.dec2Hex($System.Math.IntUtil.bin2Dec(str4.substr(0 ,
	// 5) + "01" + str4.substr(7 , 1)));
	var part4 = $System.Math.IntUtil.bin2Hex(str4.substr(0, 5) + "01"
			+ str4.substr(7, 1));
	var part5 = $System.Math.IntUtil.dec2Hex(Math.floor(Math.random() * 256));
	var part6 = $System.Math.IntUtil.dec2Hex(Math.floor(Math.random()
			* ($System.Math.IntUtil.hex2Dec("FFFFFFFFFFFF") + 1)));
	part1 = $System.Math.IntUtil.fillZero(part1, 8);
	part2 = $System.Math.IntUtil.fillZero(part2, 4);
	part3 = $System.Math.IntUtil.fillZero(part3, 4);
	part4 = $System.Math.IntUtil.fillZero(part4, 2);
	part5 = $System.Math.IntUtil.fillZero(part5, 2);
	part6 = $System.Math.IntUtil.fillZero(part6, 12);
	var guid = part1 + part2 + part3 + part4 + part5 + part6;
	return guid;
}
// 获取任意长度的随机字符串。
$System.Math.IntUtil.genRandomString = function(len) {
	if (!($System.Type.TypeUtil.isInteger(len) && len > 0)) {
		len = 2;
	}
	var rnd = "";
	for (var i = 0; i < len; i++) {
		rnd += $System.Math.IntUtil.__genRandomString();
	}
	return "RND_" + rnd;
}