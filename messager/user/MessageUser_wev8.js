/*
var mu=new MessageUser({
			    	userid:n.useid,
			    	loginid:n.loginid,
			    	lastname:n.lastname,
			    	sex:n.sex,
			    	departmentid:n.departmentid,
			    	departmentname:n.departmentname,
			    	telephone:n.telephone,
			    	mobile:n.mobile,
			    	mobilecall:n.mobilecall,
			    	email:n.email		    	
			    });	
jid,subscription,groups,name,type
*/
function  MessageUser(para){
	BaseUser.call(this,para)
	this.para=para;	
} 
MessageUser.prototype=new BaseUser();

MessageUser.prototype.showTo=function(type){
	$("."+type+" .divLoading").before(this.toString());	
	this._bindEvent(type);
}
MessageUser.prototype.insertBeforeFirst=function(type){	
	$("."+type).children("div:first").before(this.toString());
	this._bindEvent(type);
}
MessageUser.prototype._bindEvent=function(type){
	$("."+type).children("div[toJid='"+this.para.loginid+"@"+Config.JABBERSERVER+"']").dblclick(function () {
		
		var toJid=$(this).attr("toJid");			

		var msgName=$(this).find("#username").html()	
		var logoImg=$(this).find("#imgState").attr("src");	
		var userImg=$(this).find("#userImg").attr("src");	
		
		
		var win=ControlWindow.getWindow(toJid,msgName,logoImg,userImg);			
		win.show();				
	});		
	$("."+type).children("div[toJid='"+this.para.loginid+"@"+Config.JABBERSERVER+"']").hover(
		function () {
			$(this).css("background-color","#D6D9E5");
		},
		function () {
			$(this).css("background-color","#ffffff");
		}
	);
}
MessageUser.prototype.dblclick=function(){
	$("#User_"+this.para.loginid).trigger("dblclick");
}

MessageUser.prototype.toString=function(){
	var tempJid=this.para.loginid+"@"+Config.JABBERSERVER;
	var imgStr="/messager/images/icon-offline_wev8.gif";	
	if(ControlUser.isUserOnline(this.para.loginid)) imgStr="/messager/images/icon-available_wev8.gif";
	var imgIcon="/messager/images/icon-blue_wev8.gif";
	if(this.para.messagerurl!="") imgIcon=this.para.messagerurl;
	
	var returnStr=
	"<div class='divBlock' id=\"User_"+this.para.loginid+"\" toJid='"+tempJid+"'>"+
		  "<table width='100%'>" +
		  "	<tr>" +
		  "		<td style='width:24px;' valign='top' style='padding-top:6px'><img id='imgState' height='20px' src='"+imgStr+"' class='imgOnlineState_"+this.para.loginid+"'/></td>" +
		  "		<td>" +
		  "			<div style='padding-top:0px' id='username'>"+this.para.lastname+"</div>"+
		  "			<div class='txtState' style='color:#808080'>"+this.para.departmentname+"</div>"+
		  "		</td>" +
		  "		<td style='width:32px;'><img id='userImg' src='"+imgIcon+"' width='32px'/></td>" +
		  "	</tr>" +
		  "</table>"+		 
	"</div>";	
	return returnStr;
}

