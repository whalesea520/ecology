/*
 var  cu=new ChatUser({
		    	affiliation:affiliation,
		    	role:role,
		    	nick:nick,
		    	jid:jid,
		    	status:status
});		

*/
function  ChatUser(para){
	BaseUser.call(this,para)
	this.para=para;	
} 
ChatUser.prototype=new BaseUser();

ChatUser.prototype.isAdmin=function(){
	return this.para.affiliation=="owner";
}
ChatUser.prototype.getChatDivId=function(){
	return "ChatUserList_"+Util.cutResourceAtFlag(this.para.jid);
}


ChatUser.prototype.toString=function(){	
	var returnStr="";
	returnStr+="<div toJid='"+this.para.jid+"' id='"+this.getChatDivId()+"'>";
	returnStr+="	<img src='/messager/images/icon-available_wev8.gif'/>"+this.para.nick;	
	if(this.isAdmin()) 	returnStr+="(Admin)";	
	returnStr+="</div>";
	return returnStr;
}
