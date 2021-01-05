			function getUserPIN()
				Dim vbsserial
				dim hCard
				hCard = 0
				on   error   resume   next
				hCard = htactx.OpenDevice(1)'打开设备
				If Err.number<>0 or hCard = 0 then
					'alert("请确认您已经正确地安装了驱动程序并插入了usb令牌")
					Exit function
				End if
				dim UserName
				on   error   resume   next
				UserName = htactx.GetUserName(hCard)'获取用户名
				If Err.number<>0 Then
					'alert("请确认您已经正确地安装了驱动程序并插入了usb令牌2")
					htactx.CloseDevice hCard
					Exit function
				End if

				vbsserial = UserName
				htactx.CloseDevice hCard
				getUserPIN = vbsserial
			End function

			function getRandomKey(randnum)
				dim hCard
				hCard = 0	
				hCard = htactx.OpenDevice(1)'打开设备
				If Err.number<>0 or hCard = 0 then
					'alert("请确认您已经正确地安装了驱动程序并插入了usb令牌4")
					Exit function
				End if
				dim Digest
				Digest = 0
				on error resume next
					Digest = htactx.HTSHA1(randnum, len(randnum))
				if err.number<>0 then
						htactx.CloseDevice hCard
						Exit function
				end if

				on error resume next
					Digest = Digest&"04040404"'对SHA1数据进行补码
				if err.number<>0 then
						htactx.CloseDevice hCard
						Exit function
				end if

				htactx.VerifyUserPin hCard, CStr(password) '校验口令
				'alert HRESULT
				If Err.number<>0 Then
					'alert("HashToken compute")
					htactx.CloseDevice hCard
					Exit function
				End if
				dim EnData
				EnData = 0
				EnData = htactx.HTCrypt(hCard, 0, 0, Digest, len(Digest))'DES3加密SHA1后的数据
				If Err.number<>0 Then 
					'alert("HashToken compute")
					htactx.CloseDevice hCard
					Exit function
				End if
				htactx.CloseDevice hCard
				getRandomKey = EnData
				'alert "EnData = "&EnData
			End function
