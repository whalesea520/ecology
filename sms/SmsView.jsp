
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SptmForSms" class="weaver.splitepage.transform.SptmForSms" scope="page" />
<HTML><HEAD>

<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<SCRIPT language="javascript" src="js/wechat_wev8.js"></script>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>

</head>
<%
boolean canView=HrmUserVarify.checkUserRight("SmsManage:View",user);

int userid=user.getUID();   //Util.getIntValue(request.getParameter("userid"),0);
String id = Util.null2String(request.getParameter("id"));
String from = Util.null2String(request.getParameter("from"));
String name="";
String touser="";
String sendUser="";
String msg="";
String state="";
String result="";
String statemsg="";
boolean canResend=false;
rs.execute("select * from Sms_message where "+(canView?"id="+id:"id="+id+ "and userid="+userid));
if(rs.next()){
	String messageType=rs.getString("messageType");
	String UserType=rs.getString("UserType");
	String UserID=rs.getString("UserID");
	String sendNumber=rs.getString("sendNumber");
	String toUserType=rs.getString("toUserType");
	String toUserID=rs.getString("toUserID");
	String recieveNumber=rs.getString("recieveNumber");
	String messageStatus=rs.getString("messageStatus");
	if(null==sendNumber||"".equals(sendNumber)){
		sendNumber=" ";
	}
	if(null==recieveNumber||"".equals(recieveNumber)){
		recieveNumber=" ";
	}
 
	sendUser=SptmForSms.getSend(messageType,UserType+"+"+UserID+"+"+sendNumber+"+"+toUserType+"+"+toUserID);
	touser=SptmForSms.getRecieve(messageType,toUserType+"+"+toUserID+"+"+recieveNumber+"+"+UserType+"+"+UserID);
	msg=rs.getString("message");
	
	statemsg=SptmForSms.getPersonalViewMessageStatus(messageStatus,user.getLanguage()+"+"+rs.getString("isdelete"));
	
	canResend="0".equals(messageStatus)||"3".equals(messageStatus);
} 
 
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(32640,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%

if(canResend){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(22408,user.getLanguage())+",javascript:resendSms("+id+"),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}

if(canView&&"mrg".equals(from)){
	RCMenu += "{" + SystemEnv.getHtmlLabelName(2031, user.getLanguage()) + ",javascript:doDelete("+id+"),_self} ";
	RCMenuHeight += RCMenuHeightStep;
}else if("view".equals(from)){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:doDelete("+id+"),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}


	


RCMenu += "{"+SystemEnv.getHtmlLabelName(309,user.getLanguage())+",javascript:doSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
	   <td>
	    </td>
		<td class="rightSearchSpan" style="text-align:right; ">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu middle"></span>
		</td>
	</tr>
</table>

<form name=frmmain method=post action="platformAdd.jsp">
<input type="hidden" name="operate" value="save">
<table width=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="">
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">
			 <div class="zDialog_div_content" style="overflow:auto;">
				 <wea:layout type="2Col">
					     <wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>' attributes="{'class':'e8_title e8_title_1'}" >
						      
						      <wea:item><%=SystemEnv.getHtmlLabelName(16975,user.getLanguage()) %></wea:item>
						      <wea:item>
						      	<%=sendUser%>
						     </wea:item>
						     
						      <wea:item><%=SystemEnv.getHtmlLabelName(15525,user.getLanguage()) %></wea:item>
						      <wea:item>
						      	<%=touser%>
						     </wea:item>
						     
						     <wea:item><%=SystemEnv.getHtmlLabelName(18529,user.getLanguage()) %></wea:item>
						      <wea:item>
						      	<%=msg%>
						     </wea:item>
						     
						     <wea:item><%=SystemEnv.getHtmlLabelName(18523,user.getLanguage()) %></wea:item>
						      <wea:item>
						      	<%=statemsg%>
						     </wea:item>
						 </wea:group>
				</wea:layout>
			</div>
			<div id="zDialog_div_bottom" class="zDialog_div_bottom">
					<wea:layout type="2Col">
						<!-- 操作 -->
					     <wea:group context="">
					    	<wea:item type="toolbar">
							  <input type="button"
								value="<%=SystemEnv.getHtmlLabelName(309, user.getLanguage())%>"
								id="zd_btn_cancle" class="e8_btn_cancel" onclick="btn_cancle()">
						    </wea:item>
					    </wea:group>
				    </wea:layout>
				</div>
		</td>
		</tr>
		</TABLE>
	</td>
</tr>
</table>
</form>

</body>
<script language="javascript">
$(document).ready(function() {
	resizeDialog(document);
});

var parentWin = null;
var dialog = null;
try{
parentWin = parent.parent.getParentWindow(parent);
dialog = parent.parent.getDialog(parent);
}catch(e){}

function btn_cancle(){
	dialog.close();
}

function doSubmit()
{
	btn_cancle();
}

function doDelete(id){
	var str = "<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>";
 	window.top.Dialog.confirm(str,function(){
        dialog.close();
        parentWin.childDelMsg(id);
       
    });
}

function resendSms(id){
	var str = "<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())+SystemEnv.getHtmlLabelName(22408,user.getLanguage())%>?";
 	window.top.Dialog.confirm(str,function(){
		 dialog.close();
		 parentWin.childResendSms(id);
    });
}
</script>

</html>
