
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<HTML><HEAD>

<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>

</head>
<%
int userid=user.getUID();   //Util.getIntValue(request.getParameter("userid"),0);
String publicid = Util.null2String(request.getParameter("publicid"));
String keyurl=Util.null2String(request.getParameter("keyurl"));
String classname=Util.null2String(request.getParameter("classname"));

String operate = Util.null2String(request.getParameter("operate"));
String op="";
if("save".equals(operate)){//新增
	if(classname!=null&&!"".equals(classname)&&keyurl!=null&&!"".equals(keyurl)){//删除
		rs.execute("delete wechat_action where type=2 and publicid='"+publicid+"' and msgtype='event' and eventtype='click' and eventkey='"+keyurl+"'"); 
		String datasql="insert into wechat_action(publicid,msgtype,eventtype,eventkey,classname,type) values('"+publicid+"','event','click','"+keyurl+"','"+classname+"',2)";
		if(rs.executeSql(datasql)){
			SysMaintenanceLog.resetParameter();
			SysMaintenanceLog.insSysLogInfo(user,0,keyurl+" 点击事件("+publicid+")","新增菜单点击事件","214","1",0,Util.getIpAddr(request));
			op="close";
		};
	}
}

String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(32639,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY style="overflow: hidden;">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; ">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" class="e8_btn_top" onclick="doSubmit()"/>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu middle"></span>
		</td>
	</tr>
</table>

<form name=weaverA method=post action="eventAdd.jsp">
<input type="hidden" name="operate" value="save">
<input type="hidden" name="publicid" value="<%=publicid %>">
<table width=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="">
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">
			<wea:layout type="2col">
	     	<wea:group context='<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())+SystemEnv.getHtmlLabelName(32693,user.getLanguage()) %>'>
		      <wea:item>key</wea:item>
		      <wea:item>
		      <input class="InputStyle" type="text" id="keyurl" name="keyurl" value="<%=keyurl %>" onchange='checkinput("keyurl","keyurlimage")'>
			  	<SPAN id=keyurlimage><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN>
			  </wea:item>
			  
			  <wea:item><%=SystemEnv.getHtmlLabelName(20978,user.getLanguage()) %></wea:item> 
		      <wea:item>
		       	 	<input class="InputStyle" type="text" id="classname" name="classname" value="<%=classname %>" onchange='checkinput("classname","classnameimage")'>
			  		<SPAN id=classnameimage><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN>
			  		<SPAN title="<%=SystemEnv.getHtmlLabelName(367,user.getLanguage())+SystemEnv.getHtmlLabelName(20978,user.getLanguage()) %>">
			  		<IMG src="images/search_wev8.png" align=absMiddle onclick="queryClassname()"></SPAN>
		      </wea:item>
		      
		      <wea:item>
           		 	<br>
				<%=SystemEnv.getHtmlLabelName(85,user.getLanguage()) %>:<br>
				<%=SystemEnv.getHtmlLabelName(32921,user.getLanguage()) %><br><br>
			 </wea:item>
	        </wea:group>
	        </wea:layout>
			<!-- 操作 -->
			<div id="zDialog_div_bottom" class="zDialog_div_bottom">
				<wea:layout type="2col">
			     <wea:group context="">
			    	<wea:item type="toolbar">
						<input type="button" value="<%=SystemEnv.getHtmlLabelName(309, user.getLanguage())%>"
									id="zd_btn_cancle" class="e8_btn_cancel" onclick="btn_cancle()">
				    </wea:item>
			    </wea:group>
			    </wea:layout>
		    </div>
		</td>
		</tr>
		</TABLE>
	</td>
	<td><br></td>
</tr>
</table>
</form>

</body>
<script language="javascript">
var publicid="<%=publicid %>";

var parentWin = null;
var dialog = null;
try{
parentWin = parent.parent.getParentWindow(parent);
dialog = parent.parent.getDialog(parent);
}catch(e){}

function btn_cancle(){
	dialog.close();
}

if("<%=op%>"=="close"){
	parentWin.closeDlgARfsh();
}


function queryClassname(){
	$('#classname').val("");
	if($('#keyurl').val()!=''){
		$.post("menuOperate.jsp", 
		{"operate":"queryClass", "publicid": publicid,"keyurl":$('#keyurl').val()},
	   	function(data){
			var data=data.replace(/[\r\n]/g,"").replace(/[ ]/g,"");
			$('#classname').val(data);
			checkinput("classname","classnameimage");
   		});
	}
}


function doSubmit()
{	
	rightMenu.style.visibility="hidden";
	if (onCheckForm()){
        document.forms[0].submit();
    }
}

function onCheckForm()
{
	if(!check_form(weaverA,'name,classname')){
		return false;
	}
    return true;
}

 
</script>

</html>
