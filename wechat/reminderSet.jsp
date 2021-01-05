
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.general.Util,java.net.URLDecoder" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.wechat.bean.*,weaver.wechat.cache.*" %>
<HTML><HEAD>

<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>

</head>
<%
//预览测试内容
String conent=SystemEnv.getHtmlLabelName(345,user.getLanguage());
if(!HrmUserVarify.checkUserRight("Wechat:Set", user))
{
	response.sendRedirect("/notice/noright.jsp");
	return;
}
String id=Util.null2String(request.getParameter("id"));
ReminderBean rb=new ReminderBean();
if(!"".equals(id)){//有id 则是修改.
	rb=ReminderCache.getReminder(id);
}

String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(32787,user.getLanguage());
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
				<!-- 提醒设置 -->
			     <wea:group context='<%=SystemEnv.getHtmlLabelName(32787,user.getLanguage()) %>'>
				      <wea:item><%=SystemEnv.getHtmlLabelName(15148,user.getLanguage())+SystemEnv.getHtmlLabelName(63,user.getLanguage()) %></wea:item>
				      <wea:item>
							<%if(rb.getId()>0){%>
							  	<%=rb.getTypename() %>
							  	<input type="hidden" id="type" name="type" value="<%=rb.getType()%>">
							  <%}else{%>
							  	<brow:browser viewType="0" temptitle='<%=SystemEnv.getHtmlLabelName(15148,user.getLanguage())+SystemEnv.getHtmlLabelName(63,user.getLanguage()) %>' name="type" browserValue=""
									browserOnClick="" browserUrl="/wechat/bowser/mode/MutiModeBrowserTab.jsp?ids=" 
									hasInput="true"  isSingle="false" hasBrowser = "true" isMustInput='2' 
									completeUrl="/data.jsp?type=reminderMode" linkUrl="" 
									browserSpanValue=""></brow:browser>
							 <% } %>
				      </wea:item>
				      
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
			</wea:layout>
			<!-- 操作 -->
			<div id="zDialog_div_bottom" class="zDialog_div_bottom">
				<wea:layout type="2col">
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
<script src="/wechat/js/wechat_wev8.js" type="text/javascript"></script>
<script language="javascript">

$(document).ready(function() {
        reminderView();
});

var parentWin = null;
var dialog = null;
try{
parentWin = parent.parent.getParentWindow(parent);
}catch(e){}

function btn_cancle(){
	parentWin.closeDialog();
}

function btn_cancle(){
	parentWin.closeDialog();
}
	
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
	 if($('#type').val()==""){
         window.top.Dialog.alert ("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>") ;
         return false; 
     }else{
        rightMenu.style.visibility="hidden";
		$.post("wechatSetupOperate.jsp", 
		{"operate":"save","id":$('#reminderid').val(),"prefix":encodeURIComponent($('#prefix').val()),"suffix":encodeURIComponent($('#suffix').val()),
			"prefixConnector":encodeURIComponent($('#prefixConnector').val()),"suffixConnector":encodeURIComponent($('#suffixConnector').val()),
			"type":$("#type").val()},
	   	function(data){
			var data=data.replace(/[\r\n]/g,"").replace(/[ ]/g,"");
			 if(data=="true"){
			 	parentWin.closeDlgARfsh();
			 }else{
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22620,user.getLanguage())%>");
			 }
   		});
     }
}

function showType(){
	var param=encodeURIComponent("ids="+$('#type').val());
	var ret=window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/wechat/bowser/mode/MutiModeBrowser.jsp?"+param);
	if(ret){
		if(ret.id!="") {
			var ids =wuiUtil.getJsonValueByIndex(ret,0);
			var names =wuiUtil.getJsonValueByIndex(ret,1);
			$("#typeSpan").html(names);
            $("#type").val(ids);
		}else{
			$("#typeSpan").html('<IMG src="/images/BacoError_wev8.gif" align=absMiddle>');
            $("#type").val("");
		}
	}
} 
</script>

</html>
