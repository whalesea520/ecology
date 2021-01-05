
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util,java.net.URLDecoder" %>
<%@ page import="java.util.*,weaver.wechat.request.menu.*,weaver.wechat.cache.*,weaver.wechat.util.Const.MENU_TYPE" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>

<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>

</head>
<%
int userid=user.getUID();   //Util.getIntValue(request.getParameter("userid"),0);
String id=Util.null2String(request.getParameter("id"));
String publicid = Util.null2String(request.getParameter("publicid"));
String level ="1";

Menu menu=MenuCache.getMenu(publicid); 
List<Button> btns=new ArrayList<Button>();
String[] ids=id.split("_");
Button currentBtn=new Button();
String parentName="";
boolean https=false;
boolean clickclassname=false;
String classname="";

if(ids.length==2){
	btns=menu.getButton();
	currentBtn=btns.get(Integer.parseInt(ids[1]));
	level="1";
}else if(ids.length==3){
	parentName=menu.getButton().get(Integer.parseInt(ids[1])).getName();
	btns=menu.getButton().get(Integer.parseInt(ids[1])).getSub_button();
	currentBtn=btns.get(Integer.parseInt(ids[2]));
	level="2";
}

boolean clicktype=MENU_TYPE.click.equals(currentBtn.getType());
String keyurl=Util.null2String(clicktype?currentBtn.getKey():currentBtn.getUrl());
if(clicktype){
	rs.execute("select classname from wechat_action where publicid='"+publicid+"' and type=2 and msgtype='event' and eventtype='click' and eventkey='"+keyurl+"'");
	if(rs.next()){
		classname=rs.getString("classname");
		clickclassname=true;
	}
}else{
	if(keyurl!=null&&keyurl.indexOf("https://open.weixin.qq.com/connect/oauth2/authorize")>-1){
		String s="redirect_uri=";
		keyurl=keyurl.substring(keyurl.indexOf(s)+s.length());
		keyurl=keyurl.substring(0,keyurl.indexOf("&"));
		keyurl=keyurl.replaceAll("%3A",":").replaceAll("%2F","/").replaceAll("%3F","?").replace("%3D","=").replace("%26","&");
		https=true;
	}
}
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(32639,user.getLanguage())+"---"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+("1".equals(level)?SystemEnv.getHtmlLabelName(20015,user.getLanguage()):SystemEnv.getHtmlLabelName(20016,user.getLanguage()));
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

<form name="weaverA" method="post">
<table width=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="">
<tr>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">
			<wea:layout type="2col">
			     <wea:group context='<%=("1".equals(level)?SystemEnv.getHtmlLabelName(20015,user.getLanguage()):SystemEnv.getHtmlLabelName(20016,user.getLanguage()))%>'>
				      <wea:item><%=SystemEnv.getHtmlLabelName(18390,user.getLanguage()) %></wea:item>
				      <wea:item>
				         <input type="text" id="name" name="name" value="<%=currentBtn.getName() %>" class="InputStyle" onchange='checkinput("name","nameimage")'>
						 <input type="hidden" id="parentId" name="parentId" value="<%=id%>">
					  	 <SPAN id=nameimage><%=currentBtn.getName()==null||"".equals(currentBtn.getName())?"<IMG src=\"/images/BacoError_wev8.gif\" align=absMiddle>":""%></SPAN>
				      </wea:item>
				      
				      <wea:item><%=SystemEnv.getHtmlLabelName(19054,user.getLanguage()) %></wea:item>
				      <wea:item>
				      	<select id="btntype" name="btntype" onchange="changeType()" style="width:40%">
	              			<option value="click" <%=MENU_TYPE.click.equals(currentBtn.getType())?"selected":"" %>>click</option>
	              			<option value="view" <%=MENU_TYPE.view.equals(currentBtn.getType())?"selected":"" %>>view</option>
	              		</select>
	              		&nbsp;&nbsp;<span id="httpspan" style="display:none"><input type="checkbox" id="https" name="https" <%=https?"checked":"" %> value="1"><%=SystemEnv.getHtmlLabelName(18599,user.getLanguage()) %></span>
	              		<span id="keyeventspan"><input type="checkbox" id="keyevent" name="keyevent" value="1" <%=clickclassname?"checked":"" %> onclick="showkeyevent()"><%=SystemEnv.getHtmlLabelName(32693,user.getLanguage()) %></span>
	               	</wea:item>
				      
				      <wea:item attributes="{'id':'keyurlspan'}">key</wea:item>
				      <wea:item>
				        <input type="text" id="keyurl" name="keyurl" value="<%=keyurl %>"  class="InputStyle" onchange='checkinput("keyurl","keyurlimage")'>
			  			<SPAN id=keyurlimage><%=keyurl==null||"".equals(keyurl)?"<IMG src=\"/images/BacoError_wev8.gif\" align=absMiddle>":""%></SPAN>
				      </wea:item>
				      
				      <wea:item attributes="{'samePair':'keyevent','display':'none'}"><%=SystemEnv.getHtmlLabelName(20978,user.getLanguage()) %></wea:item>
				      <wea:item attributes="{'samePair':'keyevent','display':'none'}">
				       	<input type="text" id="classname" name="classname" value="<%=classname %>"  class="InputStyle">
					  	<SPAN id=classnameimage title="<%=SystemEnv.getHtmlLabelName(367,user.getLanguage())+SystemEnv.getHtmlLabelName(20978,user.getLanguage()) %>">
					  	<IMG src="images/search_wev8.png" align=absMiddle onclick="queryClassname()"></SPAN>
				      </wea:item>
				      
				      
				      
				      <%if(!"".equals(parentName)){ %>
					  <wea:item><%=SystemEnv.getHtmlLabelName(32699,user.getLanguage()) %></wea:item>
				      <wea:item><%=parentName %></wea:item>
		              <%} %>
              
             		 <wea:item>
             		 	<br>
						<%=SystemEnv.getHtmlLabelName(85,user.getLanguage()) %>:<br>
						1.<strong>click：</strong>
						<%=SystemEnv.getHtmlLabelName(32917,user.getLanguage())+SystemEnv.getHtmlLabelName(32921,user.getLanguage()) %><br><br>
						2.<strong>view：</strong>
						<%=SystemEnv.getHtmlLabelName(32918,user.getLanguage()) %><br><br>
					  	3.<strong><%=SystemEnv.getHtmlLabelName(18739,user.getLanguage()) %>：</strong>
						<%=SystemEnv.getHtmlLabelName(32919,user.getLanguage()) %><br><br>
					</wea:item>
				      
			     </wea:group>
			</wea:layout>
		</td>
		</tr>
		</TABLE>
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
	</td>
</tr>
</table>
</form>

</body>
<script language="javascript">
var publicid="<%=publicid %>";
var level="<%=level %>";
var menuLen=level=="1"?8:14;

var parentWin = null;
var dialog = null;
try{
parentWin = parent.parent.getParentWindow(parent);
dialog = parent.parent.getDialog(parent);
}catch(e){}

function btn_cancle(){
	dialog.close();
}

$(document).ready(function() {
       	changeType();
	     
});

function changeType(){
	if("view"==$('#btntype').val()){
		$('#httpspan').show();
		$('#keyeventspan').hide();
		$("#keyevent").removeAttr("checked");
		changeCheckboxStatus($("#keyevent"));
		$('#keyurlspan').html("url");
	}else{
		$('#httpspan').hide();
		$('#keyeventspan').show();
		$("#https").removeAttr("checked");
		changeCheckboxStatus($("#https"));
		$('#keyurlspan').html("key");
	}
	showkeyevent();
}

function showkeyevent(){
	if($("#keyevent").attr("checked")){
		showEle('keyevent');
	}else{
		hideEle('keyevent');
		$('#classname').val("");
	}
}

function doSubmit()
{
	rightMenu.style.visibility="hidden";
	if (onCheckForm("name","keyurl")){
		$.post("menuOperate.jsp", 
		{"operate":"edit", "publicid": publicid,"name":encodeURIComponent($('#name').val()),
			"btntype":$('#btntype').val(),"keyurl":encodeURIComponent($('#keyurl').val()),"id":$('#parentId').val(),
			"https":$("#https").attr("checked"),"keyevent":$("#keyevent").attr("checked"),"classname":$("#classname").val()},
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

function onCheckForm(objectname0,objectname1)
{	
     if(!check_form(weaverA,'name,keyurl')){
		return false;
	}
   	if(getByteLen($('#name').val())>menuLen){
   	 	window.top.Dialog.alert ("<%=SystemEnv.getHtmlLabelName(32743,user.getLanguage())%>"+menuLen+"<%=SystemEnv.getHtmlLabelName(20075,user.getLanguage())%>") ;
       	return false;
   	 };
    return true;
}

function getByteLen(val) {
	var arr = val.split("");//全部分割   
	var len = 0; 
	for (var i = 0; i < arr.length; i++) { 
	if (arr[i].match(/[^\x00-\xff]/ig) != null) //全角 
		len += 2; 
	else 
		len += 1; 
	} 
	return len; 
} 

function queryClassname(){
	$('#classname').val("");
	if($('#keyurl').value!=''){
		$.post("menuOperate.jsp", 
		{"operate":"queryClass", "publicid": publicid,"keyurl":$('#keyurl').val()},
	   	function(data){
			var data=data.replace(/[\r\n]/g,"").replace(/[ ]/g,"");
			$('#classname').val(data);  
   		});
	}
}
</script>

</html>
