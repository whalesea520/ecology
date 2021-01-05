function checkusb(){
	var tDialog = Dialog;
	try{
		var returnstr = getUserPIN();
		var serialNum = getRandomKey(randLong);
		if(returnstr!=undefined && returnstr!="" && serialNum!=undefined && serialNum!=""){
			if(returnstr==usbuserloginid && serialNum==ServerEncData){
				
			}else{
				var message = "";
				if(usblanguage == "7"){
					message = "请插入正确的usb Key !";
				}else if(usblanguage == "8"){
					message = "Please insert the real usb key !";
				}else if(usblanguage == "9"){
					message = "請插入正確的usb Key !";
				}
				if(message != "" && tDialog){
					tDialog.confirm(message,function(){
						checkusb();
					},function(){
						glbreply = false;
						window.location="/login/Logout.jsp";	
					});
				} else {
					if(message != "" && confirm(message)){
						checkusb();
					} else {
						glbreply = false;
						window.location="/login/Logout.jsp";
						return;
					}
				}
			}
		}else{
			var message = "";
			if(usblanguage == "7"){
				message = "请插入usb Key !";
			}else if(usblanguage == "8"){
				message = "Please insert your usb key !";
			}else if(usblanguage == "9"){
				message = "請插入usb Key !";
			}
			if(message != "" && tDialog){
				tDialog.confirm(message,function(){
					checkusb();
				},function(){
					glbreply = false;
					window.location="/login/Logout.jsp";	
				});
			} else {
				if(message != "" && confirm(message)){
					checkusb();
				} else {
					glbreply = false;
					window.location="/login/Logout.jsp";
					return;
				}
			}
		}
	}catch(err){
		var message = "";
		if(usblanguage == "7"){
			message = "请插入usb Key !";
		}else if(usblanguage == "8"){
			message = "Please insert your usb key !";
		}else if(usblanguage == "9"){
			message = "請插入usb Key !";
		}
		if(message != "" && tDialog){
			tDialog.confirm(message,function(){
				checkusb();
			},function(){
				glbreply = false;
				window.location="/login/Logout.jsp";	
			});
		} else {
			if(message != "" && confirm(message)){
				checkusb();
			} else {
				glbreply = false;
				window.location="/login/Logout.jsp";
				return;
			}
		}
		return;
	}
	window.setTimeout(function(){checkusb();},5000);
}