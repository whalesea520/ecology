//刷新树菜单的布局的值
function changeUserLayout(objvalue){
	jQuery("#menu_userLayout").attr("value",objvalue);
}
//获得目标frame
function getFrame(){
	
	var mainframe=document.getElementById(targetFrame);
	if(!mainframe){
		mainframe=parent.document.getElementById(targetFrame);
	}
	if(!mainframe){
		mainframe=parent.parent.document.getElementById(targetFrame);
	}
	
	return mainframe;
}
//新建邮件
function addMail(type){
	var mainframe=getFrame();
	type = (type == null ? "":type);
	try{
		mainframe.contentWindow.addTab("1","/email/new/MailAdd.jsp?isInternal="+type,SystemEnv.getHtmlNoteName(30912,language));
	}catch(e){
		mainframe.src="/email/new/MailInBox.jsp?opNewEmail=1&folderid=0&isInternal="+type;
	}
}

//打开邮件地址
function openMailUrl(obj){
	stopEvent();
	var url=$(obj).attr("_url");
	var params="?";
	var tabTitle=$(obj).find(".title").text();
	var mainframe=getFrame();
	
	if(url){
		mainframe.src=url;
	}else{
		var menu_userLayout=$("#menu_userLayout").val();
		var url="/email/new/MailInboxList.jsp";
		if(menu_userLayout!=3){
			url="/email/new/MailInboxListMain.jsp";
		}
		var folderid=$(obj).attr("_folderid");
		var star=$(obj).attr("_star");
		var waitdeal=$(obj).attr("_waitdeal");
		var internal=$(obj).attr("_internal");
		var labelid=$(obj).attr("_labelid");
		var receivemailid=$(obj).attr("_receivemailid");
		if(folderid){
			params+="&folderid="+folderid;
			if(folderid==0){
				params+="&receivemail=true";
			}
		}
		if(internal){
			params+="&isInternal=1";
		}
		if(star){
			params+="&star=1";
		}
		if(labelid){
			params+="&labelid="+labelid;
		}
		if(receivemailid){
			params+="&receivemailid="+receivemailid;
			$(".btnGrayDropContent").hide();
		}
		if(waitdeal){
			params+="&waitdeal=1";
		}
		params+="&"+new Date().getTime();
		try{
			mainframe.contentWindow.refreshMailTab("2",url+params,tabTitle); 
		}catch(e){
			mainframe.src="/email/new/MailInBox.jsp"+params;
		}
	}
}

//阻止事件冒泡
function stopEvent() {
	try{
		if (event.stopPropagation) {  
			event.stopPropagation(); 
		}else{
			if (window.event) { 
				window.event.cancelBubble = true;  
			}
		}
	}catch(e){
		if (window.event) { 
			window.event.cancelBubble = true; 
		}
	}
}
//读取未读邮件
function mailUnreadUpdate(){
	$.post("/email/new/RefreshCountAjAX.jsp", {folderid:"0",status:"0"}, function(data){
				$("#unreadMailCount_id").html(data.unreadMailCount);
	},"json");
	//读取未处理待办邮件总数
	$.post("/email/new/RefreshCountAjAX.jsp", {waitdeal:"1",status:"0"}, function(data){
				$("#waitDealCount_id").html(data.totalMailCount);
	},"json");
}
