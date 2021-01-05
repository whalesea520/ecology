function doCheckusb(){
	var flag=1;
	while(flag!=0){
		flag = checkusb(usbserial0);
		if(flag==17){
			if(usblanguage=="7"){
				reply=confirm("请插入usb令牌!");
			}else if(usblanguage=="8"){
				reply=confirm("Please insert USB token!");
			}else if(usblanguage=="9"){
				reply=confirm("請插入usb令牌!");
			}
			if(reply==true){
				continue;
			}else{
				window.location="/login/Logout.jsp";
				break;
			}
		}
		if(flag>0){
			if(usblanguage=="7"){
				reply=confirm("usb令牌错误!");
			}else if(usblanguage=="8"){
				reply=confirm("Wrong USB token!");
			}else if(usblanguage=="9"){
				reply=confirm("usb令牌錯誤!");
			}
			if(reply==true){
				continue;
			}else{
				window.location="/login/Logout.jsp";
				break;
			}
		}
	}
}
function checkusb(serial){

	try{	 
		wk = new ActiveXObject("WIBUKEY.WIBUKEY");
		wk.FirmCode = ubsfirmcode0;
		wk.UserCode = usbusercode0;
		wk.UsedSubsystems = 1;
		wk.AccessSubSystem();
		if(wk.LastErrorCode==17){			
			return 17;
		}			
		if(wk.LastErrorCode>0){
			throw new Error(wk.LastErrorCode);
		}
		wk.UsedWibuBox.MoveFirst();
		if(wk.UsedWibuBox.SerialText==serial){
			return 0;
		}else{
			return 1;								
		}
	}catch(err){
		return 1;		
	}
}