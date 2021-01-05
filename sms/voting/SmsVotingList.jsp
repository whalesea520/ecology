
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.PageManagerUtil " %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />

<jsp:useBean id="UserDefaultManager" class="weaver.docs.tools.UserDefaultManager" scope="session" />

<%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(22304,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(320,user.getLanguage());
String needfav ="1";
String needhelp ="";

String userid = user.getUID()+"";

String status = Util.null2String(request.getParameter("status"));
String subject = Util.null2String(request.getParameter("subject"));


if(!HrmUserVarify.checkUserRight("SmsVoting:Manager", user)){
	response.sendRedirect("/notice/noright.jsp");
	return ;
}

 
//设置好搜索条件
String backFields =" s.id as id, subject, senddate, sendtime, creater, s.status, createdate, createtime ";
String fromSql = " smsvoting s ";
String sqlWhere = " where (creater="+user.getUID()+" or (isseeresult=0 and exists(select h.id from smsvotinghrm h where h.smsvotingid=s.id and h.userid="+user.getUID()+" )))";

if(!"".equals(status)){
	sqlWhere+=" and s.status ='"+status+"'";
}

if(!"".equals(subject)){
	sqlWhere+=" and s.subject like '%"+subject+"%'";
}

String orderBy = " createdate, createtime ";
String tableString=""+
			"<table pagesize=\""+PageIdConst.getPageSize(PageIdConst.SMS_SmsVotingList,user.getUID())+"\" tabletype=\"none\">"+
			"<sql backfields=\""+backFields+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlorderby=\""+orderBy+"\"  sqlprimarykey=\"id\" sqlsortway=\"Desc\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" />"+
			"<head>"+
				"<col width=\"25%\"  text=\""+SystemEnv.getHtmlLabelName(195,user.getLanguage())+"\" column=\"subject\" orderkey=\"subject\" otherpara=\"column:id\" transmethod=\"weaver.splitepage.transform.SptmForSmsVoting.getSmsVotinglink\" />"+
				"<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(882,user.getLanguage())+"\" column=\"creater\" orderkey=\"creater\" transmethod=\"weaver.hrm.resource.ResourceComInfo.getResourcename\"/>"+
				"<col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(18961,user.getLanguage())+"\" column=\"senddate\" otherpara=\"column:sendtime\" orderkey=\"senddate, sendtime \" />"+
				"<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"\" column=\"status\" orderkey=\"status\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.splitepage.transform.SptmForSmsVoting.getSmsVotingStatus\"/>"+
			"</head>"+
			"<operates width=\"15%\">"+
			"<popedom transmethod=\"weaver.splitepage.transform.SptmForSmsVoting.getSmsVotingOpt\"  otherpara=\"column:status+column:creater+"+user.getUID()+"\"></popedom>"+
			"	<operate href=\"javascript:onEdit()\"  text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\"  index=\"0\"/>"+
			"	<operate href=\"javascript:onDel()\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\"  index=\"1\"/>"+
			"</operates>"+
			"</table>";
				 
				
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%

RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:add(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;

%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
	   <td>
	    </td>
		<td class="rightSearchSpan" style="text-align:right; ">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage()) %>" class="e8_btn_top middle" onclick="add()"/>
			<input type="text" class="searchInput" id="t_name" name="t_name" value=""  />
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage()) %></span>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu middle"></span>
		</td>
	</tr>
</table>

<div class="advancedSearchDiv" id="advancedSearchDiv">
	<form id="weaverA" name="weaverA" method="post" action="SmsVotingList.jsp">
		  	<wea:layout type="4col">
	     	<wea:group context="" attributes="{'groupDisplay':'none'}">
		      <wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
		      <wea:item>
		        	<input type="text" id="subject" name="subject" value="<%=subject %>" class="InputStyle">
		      </wea:item>
		      
		      <wea:item><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></wea:item>
		      <wea:item>
		       	  <select id="status"  name="status">
					<option value=""><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
					<option value=0 <%if(status.equals("0")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1979,user.getLanguage())%></option>
					<option value=1 <%if(status.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1960,user.getLanguage())%></option>
					<option value=2 <%if(status.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(22348,user.getLanguage())%></option>
				 </select>
		      </wea:item>
	      </wea:group>
	      
		<!-- 操作 -->
	     <wea:group context="">
	    	<wea:item type="toolbar">
		        <input type="submit" class="e8_btn_submit" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"/>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>" class="e8_btn_cancel" onclick="resetCondtion();"/>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
		    </wea:item>
	    </wea:group>
	    </wea:layout>
 </form>
</div>

<table width=100% border="0" cellspacing="0" cellpadding="0">
<tr>
	<td valign="top">
		<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.Wechat_wechatList%>"/>
		<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run"/>
	</td>
</tr>
</table>


</BODY>
</HTML>
<SCRIPT LANGUAGE="JavaScript">
var diag_vote;

function closeDialog(){
	diag_vote.close();
}

function closeDlgARfsh(){
	diag_vote.close();
	window.location="SmsVotingList.jsp";
}

function add(){
	if(window.top.Dialog){
		diag_vote = new window.top.Dialog();
	} else {
		diag_vote = new Dialog();
	}
	diag_vote.currentWindow = window;
	diag_vote.Width = 600;
	diag_vote.Height = 550;
	diag_vote.Modal = true;
	diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(22304,user.getLanguage())%>";
	diag_vote.URL = "/sms/voting/SmsVotingAddTab.jsp";
	diag_vote.show();
}

function onEdit(id){
	if(window.top.Dialog){
		diag_vote = new window.top.Dialog();
	} else {
		diag_vote = new Dialog();
	}
	diag_vote.currentWindow = window;
	diag_vote.Width = 600;
	diag_vote.Height = 550;
	diag_vote.Modal = true;
	diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(22304,user.getLanguage())%>";
	diag_vote.URL = '/sms/voting/SmsVotingEditTab.jsp?id='+id;
	diag_vote.show();
}
function view(id){
	if(window.top.Dialog){
		diag_vote = new window.top.Dialog();
	} else {
		diag_vote = new Dialog();
	}
	diag_vote.currentWindow = window;
	diag_vote.Width = 600;
	diag_vote.Height = 550;
	diag_vote.Modal = true;
	diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(22304,user.getLanguage())%>";
	diag_vote.URL = '/sms/voting/SmsVotingView.jsp?id='+id;
	diag_vote.show();
}

function showDlg(title,url,diag,_window)
 {
            if(diag){
            	diag.close();
            }
            
			diag.currentWindow = _window;
			diag.Width = 600;
			diag.Height = 550;
			diag.Modal = true;
			diag.maxiumnable = true;
			diag.Title = title;
			diag.URL = url;
			diag.show();
} 

function onDel(id){
	var str = "<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>";
   	window.top.Dialog.confirm(str,function(){
		$.post("/sms/voting/SmsVotingOperation.jsp",{method:"delete",id:id},function(datas){
			window.location="SmsVotingList.jsp";
		});
		enableAllmenu();
	});
}

function preDo(){
	//tabSelectChg();
	$("#topTitle").topMenuTitle({searchFn:onBtnSearchClick});
	$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
	$("#tabDiv").remove();
	$("#hoverBtnSpan").hoverBtn();
}
function onBtnSearchClick(){
	var name=$("input[name='t_name']",parent.document).val();
	$("#subject").val(name);
	document.weaverA.submit();
} 
</SCRIPT>
