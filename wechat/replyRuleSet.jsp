
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util,java.net.URLDecoder" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<HTML><HEAD>

<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>

</head>
<%
int userid=user.getUID();   //Util.getIntValue(request.getParameter("userid"),0);
String id=Util.null2String(request.getParameter("id"));



String perpage=PageIdConst.getPageSize(PageIdConst.Wechat_ReplyKeyList,user.getUID());

String sqlwhere="where replyid="+id+" ";
String backFields = " id,keyword,keytype ";
String sqlFrom = " wechat_reply_rule ";
String tableString=""+
			  "<table  pagesize=\""+perpage+"\" instanceid=\"keywordTable\" tabletype=\"checkbox\">"+
			  "<sql backfields=\""+backFields+"\" sqlform=\""+Util.toHtmlForSplitPage(sqlFrom)+"\"  sqlprimarykey=\"id\" sqlsortway=\"asc\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\"/>"+
			  "<head>"+                             
					  "<col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(24290,user.getLanguage())+"\"  column=\"keyword\" />"+
					  "<col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(19835,user.getLanguage())+"\"  column=\"keytype\" transmethod=\"weaver.wechat.WechatTransMethod.getKeytype\" otherpara=\""+user.getLanguage()+"\"/>"+//类型
			  "</head>";
 tableString +=  "<operates>"+
				"	<operate href=\"javascript:delKeyword();\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" target=\"_self\" index=\"0\"/>"+
				"</operates>";
tableString += "</table>";		  

String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(68,user.getLanguage())+SystemEnv.getHtmlLabelName(24290,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY style="overflow: hidden;">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(32136,user.getLanguage())+",javascript:doDelete(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; ">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(32136,user.getLanguage()) %>" class="e8_btn_top" onclick="doDelete()"/>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu middle"></span>
		</td>
	</tr>
</table>
<form name=frmmain method=post>
<table width=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="">
<tr>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">
			<wea:layout type="2Col">
			     <wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>' attributes="{'class':'e8_title e8_title_1'}" >
				      <wea:item><%=SystemEnv.getHtmlLabelName(19835,user.getLanguage()) %></wea:item>
				      <wea:item>
				        <select id="keytype" name="keytype" >
		              		<option value="0"><%=SystemEnv.getHtmlLabelName(32718,user.getLanguage()) %></option>
		              		<option value="1"><%=SystemEnv.getHtmlLabelName(32719,user.getLanguage()) %></option>
		              	</select>
				      </wea:item>
				      
				      <wea:item><%=SystemEnv.getHtmlLabelName(24290,user.getLanguage()) %></wea:item>
				      <wea:item>
		              	<input type="text" id="keyword" name="keyword" class="InputStyle" onchange='checkinput("keyword","keywordimage")'>
		              	<SPAN id=keywordimage><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN>
		              	&nbsp;&nbsp;
		              	<input type="button" value="<%=SystemEnv.getHtmlLabelName(611, user.getLanguage())%>"
									id="zd_btn_save" class="e8_btn_submit" onclick="doAdd()">
				      </wea:item>
				      
		              
			     </wea:group>
			     <wea:group context='<%=SystemEnv.getHtmlLabelName(24290,user.getLanguage())+SystemEnv.getHtmlLabelName(320,user.getLanguage()) %>' attributes="{'itemAreaDisplay':'inline-block'}">
						      <wea:item attributes="{'isTableList':'true'}">
									<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.Wechat_ReplyKeyList%>"/>
									<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" isShowTopInfo="false"/>
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
</tr>
</table>
</form>

</body>
<script language="javascript">
 
var id="<%=id%>";

var parentWin = null;
var dialog = null;
try{
parentWin = parent.parent.getParentWindow(parent);
}catch(e){}


function btn_cancle(){
	parentWin.closeDialog();
}

function doAdd()
{	
	if ($('#keyword').val()==""){
         window.top.Dialog.alert ("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>") ;
     }else{
     	$.post("replyOperate.jsp", 
		{"operate":"addKeyword", "replyid": id,"keyword":encodeURIComponent($('#keyword').val()),
			"keytype":$('#keytype').val()},
	   	function(data){
			var data=data.replace(/[\r\n]/g,"").replace(/[ ]/g,"");
			 if(data=="true"){
			 	 _table.reLoad();
			 	 parentWin.refreshTable();
			 	 $('#keyword').val("");
			 	 checkinput("keyword","keywordimage");
			 }else{
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22620,user.getLanguage())%>");
			 }
   		});
     }
}

function delKeyword(id)
{
    var str = "<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>";
 	window.top.Dialog.confirm(str,function(){
	    $.post("replyOperate.jsp", 
		{"operate":"delKeyword", "id": id},
	   	function(data){
			var data=data.replace(/[\r\n]/g,"").replace(/[ ]/g,"");
			 if(data=="true"){
			 	 _table.reLoad();
			 	 parentWin.refreshTable();
			 }else{
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22620,user.getLanguage())%>");
			 }
   		});
    });
}

function doDelete(){
	var deleteids = _xtable_CheckedCheckboxId();
	if(deleteids==""){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15543,user.getLanguage())%>");
		return;
	}else{
	    var str = "<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>";
   		window.top.Dialog.confirm(str,function(){
	        $.post("replyOperate.jsp", 
			{"operate":"delKeyword", "id": deleteids.substr(0,deleteids.length-1)},
		   	function(data){
				var data=data.replace(/[\r\n]/g,"").replace(/[ ]/g,"");
				 if(data=="true"){
				 	 _table.reLoad();
				 	 parentWin.refreshTable();
				 }else{
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22620,user.getLanguage())%>");
				 }
	   		});
	    });
    }
}

</script>

</html>
