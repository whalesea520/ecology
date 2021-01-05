
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.wechat.cache.*,weaver.wechat.bean.*"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<%@ include file="/systeminfo/init_wev8.jsp" %>

<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<HTML><HEAD>

<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<LINK href="/css/Weaver_wev8.css" type="text/css" rel="STYLESHEET">

</head>
<%
int userid=user.getUID();   //Util.getIntValue(request.getParameter("userid"),0);
String id=Util.null2String(request.getParameter("id"));
String publicid=Util.null2String(request.getParameter("publicid"));
if(!"".equals(id)){
	WeChatBean wc=PlatFormCache.getWeChatBeanById(id);
	publicid=wc.getPublicid();
}

String operate = Util.null2String(request.getParameter("operate"));
String state = Util.null2String(request.getParameter("state"));
String IDS = Util.null2String(request.getParameter("IDS"));
String eventkey=Util.null2String(request.getParameter("eventkey"));
String classname=Util.null2String(request.getParameter("classname"));

if(null != IDS && !"".equals(IDS)){
	String temStr="";
	if("del".equals(operate)){//删除
		RecordSet.executeSql("select * from wechat_action where type=2 and id in ("+IDS+")");
		while(RecordSet.next()){
			SysMaintenanceLog.resetParameter();
			SysMaintenanceLog.insSysLogInfo(user,RecordSet.getInt("id"),RecordSet.getString("eventkey")+" 点击事件("+RecordSet.getString("publicid")+")","删除菜单点击事件","214","3",0,Util.getIpAddr(request));
		}
		temStr = "delete wechat_action where type=2 and id in ("+IDS+")";
		RecordSet.executeSql(temStr);
	}
}

String sqlwhere="where ((publicid='"+publicid+"' and type=2) or (type=1)) ";
if(state!=null&&!"".equals(state)){
	sqlwhere+=" and type = '"+state+"' ";
}
if(eventkey!=null&&!"".equals(eventkey)){
	sqlwhere+=" and msgtype='event' and eventtype='click' and eventkey like  '%"+eventkey+"%' ";
}
if(classname!=null&&!"".equals(classname)){
	sqlwhere+=" and classname like '%"+classname+"%' ";
}

String perpage=PageIdConst.getPageSize(PageIdConst.Wechat_EventList,user.getUID());

String backFields = " id,msgtype, eventtype, eventkey, classname,type";
String sqlFrom = " wechat_action t1";
String sqlOrderBy = "type";
String tableString=""+
			  "<table  pagesize=\""+perpage+"\" instanceid=\"platformTable\" tabletype=\"checkbox\">"+
			  " <checkboxpopedom  popedompara=\"column:type\" showmethod=\"weaver.wechat.WechatTransMethod.getEventCheck\"  />"+
			  "<sql backfields=\""+backFields+"\" sqlorderby=\"" + sqlOrderBy + "\" sqlform=\""+Util.toHtmlForSplitPage(sqlFrom)+"\" sqlprimarykey=\"id\" sqlsortway=\"desc\"  sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\"/>"+
			  "<head>"+                             
					  "<col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(32693,user.getLanguage())+"\" column=\"msgtype\" transmethod=\"weaver.wechat.WechatTransMethod.getEventTypeName\" otherpara=\""+user.getLanguage()+"+column:eventtype+column:eventkey\"/>"+
					  "<col width=\"50%\"  text=\""+SystemEnv.getHtmlLabelName(20978,user.getLanguage())+"\" column=\"classname\" />"+
					  "<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(63,user.getLanguage())+"\"  column=\"type\" orderkey=\"type\" transmethod=\"weaver.wechat.WechatTransMethod.getClassType\" otherpara=\""+user.getLanguage()+"\"/>"+
			  "</head>";
 tableString +=  "<operates>"+
                "		<popedom column=\"id\" otherpara=\"column:type\" transmethod=\"weaver.wechat.WechatTransMethod.getEventOpt\"></popedom> "+
				"		<operate href=\"javascript:delEvent();\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" target=\"_self\" index=\"0\"/>"+
				"</operates>";
tableString += "</table>";
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(32639,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY style="overflow: hidden;">

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(611,user.getLanguage())+",javascript:doAdd(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:delSelectEvent(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; ">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage()) %>" class="e8_btn_top" onclick="doAdd()"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage()) %>" class="e8_btn_top" onclick="delSelectEvent()"/>
			<input type="text" class="searchInput" id="t_name" name="t_name" value=""  />
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage()) %></span>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu middle"></span>
		</td>
	</tr>
</table>
<div id="tabDiv" >
	<span id="hoverBtnSpan" class="hoverBtnSpan">
			
	</span>
</div>
<div class="advancedSearchDiv" id="advancedSearchDiv">
	<form id=weaverA name=weaverA method=post action="eventList.jsp">
	<input type="hidden" name="operate" value="">
	<input type="hidden" name="publicid" value="<%=publicid %>">
	<input type="hidden" name="IDS" value="">
		  	<wea:layout type="4col">
	     	<wea:group context='<%=SystemEnv.getHtmlLabelName(20331, user.getLanguage())%>'>
				
		      
		      <wea:item><%=SystemEnv.getHtmlLabelName(63,user.getLanguage()) %></wea:item>
		      <wea:item>
		       	  <select class=saveHistory id="state"  name="state">
					<option value=""><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
					<option value=1 <%if(state.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(28119,user.getLanguage()) %></option>
					<option value=2 <%if(state.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(19516,user.getLanguage()) %></option>
				 </select>
		      </wea:item>
		      
		      <wea:item><%=SystemEnv.getHtmlLabelName(20978,user.getLanguage()) %></wea:item>
		      <wea:item>
		       	  <input class="InputStyle" type="text" id="classname" name="classname" value="<%=classname %>">
		      </wea:item>
	      </wea:group>
		<!-- 操作 -->
	     <wea:group context="">
	    	<wea:item type="toolbar">
		        <input type="submit" class="e8_btn_submit" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"/>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>" class="e8_btn_cancel" onclick="resetCondtionAVS();"/>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
		    </wea:item>
	    </wea:group>
	    </wea:layout>
 </form>
</div>

<table width=100% border="0" cellspacing="0" cellpadding="0">
<tr>
	<td valign="top">
	  <input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.Wechat_EventList%>"/>
	  <wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" isShowTopInfo="true"/>
	</td>
</tr>
</table>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout type="2col">
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
 
 

</body>
<script language="javascript">
var publicid="<%=publicid%>";

$(document).ready(function() {
	 
});

var parentWin = null;
var dialog = null;
try{
parentWin = parent.parent.getParentWindow(parent);
}catch(e){}

function btn_cancle(){
	parentWin.closeDialog();
}
 
var diag_vote;
function closeDialog(){
	diag_vote.close();
}

function closeDlgARfsh(){
	diag_vote.close();
	_table.reLoad();
}

function doSubmit()
{
	document.forms[0].submit();
}

function delEvent(id){
	var str = "<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>";
 	window.top.Dialog.confirm(str,function(){
       jQuery("input[name=operate]").val("del");
       jQuery("input[name=IDS]").val(id);
       document.forms[0].submit();
    });
}

function delSelectEvent(){
	var deleteids = _xtable_CheckedCheckboxId();
	if(deleteids==""){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15543,user.getLanguage())%>");
		return;
	}else{
	    var str = "<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>";
   		window.top.Dialog.confirm(str,function(){
	        jQuery("input[name=operate]").val("del");
	        jQuery("input[name=IDS]").val(deleteids.substr(0,deleteids.length-1));
	        document.forms[0].submit();
	    });
    }
}

function doAdd(){
	if(window.top.Dialog){
		diag_vote = new window.top.Dialog();
	} else {
		diag_vote = new Dialog();
	};
	diag_vote.currentWindow = window;
	diag_vote.Width = 450;
	diag_vote.Height = 350;
	diag_vote.Modal = true;
	diag_vote.maxiumnable = false;
	diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())+SystemEnv.getHtmlLabelName(32693,user.getLanguage())%>";
	diag_vote.URL = "/wechat/eventAddTab.jsp?publicid="+publicid;
	diag_vote.show();
}         

  
function preDo(){
	//tabSelectChg();
	$("#topTitle").topMenuTitle({searchFn:onBtnSearchClick});
	$("#hoverBtnSpan").hoverBtn();
}

function onBtnSearchClick(){
	var name=$("input[name='t_name']",parent.document).val();
	$("#eventkey").val(name);
	doSubmit();
} 

function resetCondtionAVS(){
	$("#eventkey").val("");
	$("#classname").val("");
	jQuery("#state").val("");
	$("#state").selectbox('detach');
	$("#state").selectbox('attach');
	
}         
</script>

</html>
