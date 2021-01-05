function getUserPIN() {
	try {
		var vbsserial = "";
		var hCard = htactx.OpenDevice(1);//打开设备
		if (hCard == 0) {
			alert("请确认您已经正确地安装了驱动程序并插入了usb令牌")
			return vbsserial;
		}

		try {
			vbsserial = htactx.GetUserName(hCard);//获取用户名
			htactx.CloseDevice(hCard);
			return vbsserial;
		} catch (e) {
			alert("请确认您已经正确地安装了驱动程序并插入了usb令牌2");
			htactx.CloseDevice(hCard);
			return vbsserial;
		}
	} catch (e) {
		alert("请确认您已经正确地安装了驱动程序并插入了usb令牌");
		htactx.CloseDevice(hCard);
		return vbsserial;
	}
}

function getRandomKey(randnum) {
	try {
		var hCard = htactx.OpenDevice(1);//打开设备
		if (hCard == 0) {
			alert("请确认您已经正确地安装了驱动程序并插入了usb令牌4");
			return "";
		}
		try {
			var Digest = htactx.HTSHA1(randnum, ("" + randnum).length);
			Digest = Digest + "04040404"; //对SHA1数据进行补码
			htactx.VerifyUserPin(hCard, password); //校验口令
			var EnData = htactx.HTCrypt(hCard, 0, 0, Digest, Digest.length);//DES3加密SHA1后的数据
			htactx.CloseDevice(hCard);
			return EnData;
		} catch (e) {
			alert("请确认您已经正确地安装了驱动程序并插入了usb令牌5");
			htactx.CloseDevice(hCard);
			return "";
		}
	} catch (e) {
		alert("请确认您已经正确地安装了驱动程序并插入了usb令牌4");
		return "";
	}
}
