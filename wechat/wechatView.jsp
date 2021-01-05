
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WechatTransMethod" class="weaver.wechat.WechatTransMethod" scope="page" />
<HTML><HEAD>

<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<SCRIPT language="javascript" src="js/wechat_wev8.js"></script>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>

</head>
<%
int userid=user.getUID();   //Util.getIntValue(request.getParameter("userid"),0);
String id = Util.null2String(request.getParameter("id"));
String name="";
String touser="";
String msg="";
String state="";
String result="";
String statemsg="";
int msg_userid=-1;
rs.execute("select t1.name,t2.* from wechat_platform t1,wechat_msg t2 where t1.publicid=t2.publicid and t2.id="+id);
if(rs.next()){
	msg_userid=rs.getInt("userid");
	name=rs.getString("name");
	touser=WechatTransMethod.getHrmResources(rs.getString("touserid"),rs.getString("tousertype"));
	msg=rs.getString("msg");
	state=rs.getString("state");
	statemsg=WechatTransMethod.getMsgState(state,user.getLanguage()+"");
	result=rs.getString("result");
	
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
//只能删除自己的数据
if(userid==msg_userid){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:delMsg("+id+"),_self} " ;
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
						      <wea:item><%=SystemEnv.getHtmlLabelName(32689,user.getLanguage())+SystemEnv.getHtmlLabelName(195,user.getLanguage()) %></wea:item>
						      <wea:item>
						         <%=name%>
						      </wea:item>
						      
						      <wea:item><%=SystemEnv.getHtmlLabelName(15525,user.getLanguage()) %></wea:item>
						      <wea:item>
						      	<%=touser%>
						     </wea:item>
						     
						     <wea:item><%=SystemEnv.getHtmlLabelName(345,user.getLanguage()) %></wea:item>
						      <wea:item>
						      	<%=msg%>
						     </wea:item>
						     
						     <wea:item><%=SystemEnv.getHtmlLabelName(602,user.getLanguage()) %></wea:item>
						      <wea:item>
						      	<%=statemsg%>
						     </wea:item>
						     <%if("2".equals(state)){ %>
						     <wea:item><%=SystemEnv.getHtmlLabelName(27041,user.getLanguage()) %></wea:item>
						      <wea:item>
						      	<%=result%>
						     </wea:item>
						     <%} %>
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

function delMsg(id){
	var str = "<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>";
 	window.top.Dialog.confirm(str,function(){
        dialog.close();
        parentWin.childDelMsg(id);
       
    });
}

</script>

</html>
