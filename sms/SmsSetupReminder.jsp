
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.sms.*" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<HTML><HEAD>

<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>

</head>
<%
if(!HrmUserVarify.checkUserRight("Sms:Set", user))
{
	response.sendRedirect("/notice/noright.jsp");
	return;
}

//预览测试内容
String conent=SystemEnv.getHtmlLabelName(345,user.getLanguage());

String operate=Util.null2String(request.getParameter("operate"));
if("save".equals(operate)){
	//保存默认提醒
	String reminderid = Util.null2String(request.getParameter("reminderid"));
	String prefix = Util.null2String(request.getParameter("prefix"));
	String prefixConnector = Util.null2String(request.getParameter("prefixConnector"));
	String suffix = Util.null2String(request.getParameter("suffix"));
	String suffixConnector = Util.null2String(request.getParameter("suffixConnector"));
	 
	if(!"".equals(reminderid)&&!"0".equals(reminderid)){//更新
		rs.executeSql("update sms_reminder_set set prefix='"+prefix+"', suffix='"+suffix+"',prefixConnector='"+prefixConnector+"',suffixConnector='"+suffixConnector+"' where id="+reminderid);
	}else{//新增
		rs.executeSql("insert into sms_reminder_set(prefix,suffix,prefixConnector,suffixConnector,type,def) values('"+prefix+"','"+suffix+"','"+prefixConnector+"','"+suffixConnector+"','ALL','1')");
	} 
	SysMaintenanceLog.resetParameter();
	SysMaintenanceLog.insSysLogInfo(user,0,"短信提醒设置","短信应用设置-提醒设置","316","2",0,Util.getIpAddr(request));  
}
 
//获取短信默认提醒
SmsReminderBean rb=SmsUtil.getDefaultReminder(); 
 
//是否启用特殊模块提醒
boolean showSpecial=false;
rs.execute("select 1 from sms_reminder_type");
if(rs.next()){
	showSpecial=true;
}


//获取特殊提醒配置
String perpage=PageIdConst.getPageSize(PageIdConst.Sms_ReminderList,user.getUID());

String sqlwhere=" where t1.type=t2.type and t2.modekey=t3.modekey and def='0'  ";
String backFields = " t1.*,t2.typename,t3.modename ";
String sqlFrom = " sms_reminder_set t1,sms_reminder_type t2,sms_reminder_mode t3 ";

String tableString=""+
			  "<table  pagesize=\""+perpage+"\" instanceid=\"wechatSetupTable\" tabletype=\"checkbox\">"+
			  "<sql backfields=\""+backFields+"\" sqlform=\""+Util.toHtmlForSplitPage(sqlFrom)+"\" sqlorderby=\"id\"  sqlprimarykey=\"id\" sqlsortway=\"asc\"  sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\"/>"+
			  "<head>"+                            
					  "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(15148,user.getLanguage())+SystemEnv.getHtmlLabelName(63,user.getLanguage())+"\" column=\"typename\" />"+
					  "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(19049,user.getLanguage())+"\" column=\"modename\"/>"+
					  "<col width=\"35%\"  text=\""+SystemEnv.getHtmlLabelName(32784,user.getLanguage())+"\"  column=\"prefix\"/>"+
					  "<col width=\"35%\"  text=\""+SystemEnv.getHtmlLabelName(32785,user.getLanguage())+"\"  column=\"suffix\"/>"+
			  "</head>";
tableString +=  "<operates>"+
                "		<operate href=\"javascript:editReminder();\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" target=\"_self\" index=\"0\"/>"+
				"		<operate href=\"javascript:delReminder();\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" target=\"_self\" index=\"1\"/>"+
				"</operates>";
tableString += "</table>";

String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(32776,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>

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
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" class="e8_btn_top middle" onclick="doSubmit()"/>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu middle"></span>
		</td>
	</tr>
</table>

<form name="frmmain" method="post" action="SmsSetupReminder.jsp">
<input type="hidden" name="operate" value="save">
<table width=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="">
<tr>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">
			<wea:layout type="2Col">
			     
			     <!-- 提醒设置 -->
			     <wea:group context='<%=SystemEnv.getHtmlLabelName(21946,user.getLanguage()) %>'  >
				      <wea:item><%=SystemEnv.getHtmlLabelName(32784,user.getLanguage()) %></wea:item>
				      <wea:item>
				          <input type="hidden" id="reminderid" name="reminderid" value="<%=rb.getId()%>">
			              <input type="text" id="prefix" name="prefix" value="<%=rb.getPrefix()%>" class="InputStyle" onchange="reminderView()">&nbsp;&nbsp;
			              <input type="hidden" id="prefixConnector" name="prefixConnector" value="">
				      </wea:item>
				      
				      <wea:item><%=SystemEnv.getHtmlLabelName(32785,user.getLanguage()) %></wea:item>
				      <wea:item>
				          <input type="text" id="suffix" name="suffix" value="<%=rb.getSuffix()%>" class="InputStyle" onchange="reminderView()">&nbsp;&nbsp;
              			  <input type="hidden" id="suffixConnector" name="suffixConnector" value="">
				      </wea:item>
				      <wea:item><%=SystemEnv.getHtmlLabelName(221,user.getLanguage()) %></wea:item>
				      <wea:item>
				          <SPAN id="reminderView"></SPAN>
				      </wea:item>
			     </wea:group>
			     
			     <%if(showSpecial){ %>
		          	<wea:group context='<%=SystemEnv.getHtmlLabelName(32787,user.getLanguage())%>' attributes="{'itemAreaDisplay':'inline-block'}">
				      <wea:item type="groupHead">
				         <input Class="addbtn" type="button" onclick="doAdd()" title="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>"></input>
						 <input Class="delbtn" type="button" onclick="doDel()" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>"></input>
				      </wea:item>
				      <wea:item attributes="{'isTableList':'true'}">
				      		<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.Sms_ReminderList%>"/>
				          <wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" isShowTopInfo="false"/>
				      </wea:item>
	     			</wea:group>
				      <%} %>
			</wea:layout>	
		</td>
		</tr>
		</TABLE>
	</td>
</tr>
</table>
</form>

</body>
<script src="/wechat/js/wechat_wev8.js" type="text/javascript"></script>
<script language="javascript">
 
var diag_vote;
function closeDialog(){
	diag_vote.close();
}

function closeDlgARfsh(){
	_table.reLoad();
	diag_vote.close();
}

function refreshTable(){
	_table.reLoad();
}

$(document).ready(function() {
	    reminderView();
});

var conent="<%=conent%>";



function reminderView(){
	var view=conent;
	if($("#prefix").val()!=''){
		view=$("#prefix").val()+$("#prefixConnector").val()+conent;
	}
	if($("#suffix").val()!=''){
		view+=$("#suffixConnector").val()+$("#suffix").val();
	}
	$('#reminderView').html(view);
}
 

function doSubmit()
{
	document.forms[0].submit();
}

function doAdd(){
	if(window.top.Dialog){
		diag_vote = new window.top.Dialog();
	} else {
		diag_vote = new Dialog();
	};
	diag_vote.currentWindow = window;
	diag_vote.Width = 550;
	diag_vote.Height = 300;
	diag_vote.Modal = true;
	diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(1421,user.getLanguage())+SystemEnv.getHtmlLabelName(32787,user.getLanguage())%>";
	diag_vote.URL = "/sms/SmsSetReminderTab.jsp";
	diag_vote.show();
}

function editReminder(id){
	if(window.top.Dialog){
		diag_vote = new window.top.Dialog();
	} else {
		diag_vote = new Dialog();
	};
	diag_vote.currentWindow = window;
	diag_vote.Width = 550;
	diag_vote.Height = 300;
	diag_vote.Modal = true;
	diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())+SystemEnv.getHtmlLabelName(32787,user.getLanguage())%>";
	diag_vote.URL = "/sms/SmsSetReminderTab.jsp?id="+id;
	diag_vote.show();
}

function delReminder(id){
	 window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>",function(){
	    $.post("SmsSetupOperate.jsp", 
		{"operate":"del", "IDS": id},
	   	function(data){
			var data=data.replace(/[\r\n]/g,"").replace(/[ ]/g,"");
			 if(data=="true"){
			 	 _table.reLoad();
			 }else{
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22620,user.getLanguage())%>");
			 }
   		});
    });
}

function doDel(){
	var deleteids = _xtable_CheckedCheckboxId();
	if(deleteids==""){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15543,user.getLanguage())%>");
		return;
	}else{
	    window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>",function(){
		    $.post("SmsSetupOperate.jsp", 
			{"operate":"del", "IDS": deleteids.substr(0,deleteids.length-1)},
		   	function(data){
				var data=data.replace(/[\r\n]/g,"").replace(/[ ]/g,"");
				 if(data=="true"){
				 	 _table.reLoad();
				 }else{
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22620,user.getLanguage())%>");
				 }
	   		});
	    });
    }
}

</script>

</html>
