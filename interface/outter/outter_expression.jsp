<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%
if(!HrmUserVarify.checkUserRight("intergration:outtersyssetting", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
%>
<HTML><HEAD>

<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<link rel="stylesheet" href="/wui/theme/ecology8/weaveredittable/css/WeaverEditTable_wev8.css">
<script  src="/wui/theme/ecology8/weaveredittable/js/WeaverEditTable_wev8.js"></script>


<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/dragBox/parentShowcol_wev8.js"></script>
<link rel="stylesheet" href="/css/ecology8/request/requestView_wev8.css" type="text/css" />
</head>
<%
String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(20961,user.getLanguage());
String needfav ="1";
String needhelp ="";
String tiptitle = SystemEnv.getHtmlLabelName(32342,user.getLanguage());//"选择MD5加密解密时，我们会使用标准的MD5加密，如果填写了加密密钥，将可以进行解密还原出明文；如果选择的是自定义加密算法，那么需要填写加密程序的路径以及方法，传递的参数将只有需要加密的需求本身，返回值必须是加密后的数据。";
String typename = Util.null2String(request.getParameter("typename"));
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
String isDialog = "1";
//String expression = new String(Util.null2String(request.getParameter("expression")).getBytes("ISO8859-1"), "UTF-8");
String expression = new String(Util.null2String(request.getParameter("expression")).getBytes("ISO8859-1"), "UTF-8");
expression=java.net.URLDecoder.decode(expression,"UTF-8");
String names = new String(Util.null2String(request.getParameter("names")).getBytes("ISO8859-1"), "UTF-8");
names=java.net.URLDecoder.decode(names,"UTF-8");
String[] fieldNames=names.split(",");


String info=SystemEnv.getHtmlLabelName(125413,user.getLanguage())+"：<br>"+
	"1."+SystemEnv.getHtmlLabelName(125414,user.getLanguage())+".<br>"+
	"2."+SystemEnv.getHtmlLabelName(125415,user.getLanguage())+".<br>"+
	"3."+SystemEnv.getHtmlLabelName(125416,user.getLanguage())+".<br>"+
	"4."+SystemEnv.getHtmlLabelName(82159,user.getLanguage())+":loginid+\"|\"+userpassword(loginid"+SystemEnv.getHtmlLabelName(125417,user.getLanguage())+",userpassword"+SystemEnv.getHtmlLabelName(125418,user.getLanguage())+",\"|\""+SystemEnv.getHtmlLabelName(125419,user.getLanguage())+").";
	
%>
<BODY>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<script language=javascript >
var parentWin = parent.parent.getParentWindow(parent);
</script>
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(HrmUserVarify.checkUserRight("intergration:outtersyssetting", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<%if(HrmUserVarify.checkUserRight("intergration:outtersyssetting", user)){%>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86 ,user.getLanguage()) %>" class="e8_btn_top" onclick="submitData()"/>
			<%}%>
			<span id="advancedSearch" class="advancedSearch" style='display:none;'><%=SystemEnv.getHtmlLabelName(21995 ,user.getLanguage()) %></span>&nbsp;&nbsp;
			<span title="<%=SystemEnv.getHtmlLabelName(23036 ,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div id="tabDiv" >
   <span style="font-size:14px;font-weight:bold;"><%=titlename%></span> 
</div>
<div class="cornerMenuDiv"></div>
<div class="advancedSearchDiv" id="advancedSearchDiv" style='display:none;'>
</div>
<script language=javascript>
<%
if(msgid!=-1){
%>
top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(msgid,user.getLanguage())%>!');
<%}%>
</script>

<FORM id=weaver name=frmMain action="outter_expression.jsp" method=post >

<table height="200px" width="100%">
		<tr>
		<td align="left" valign="top"  height="200px">
			<table border="0" cellpadding="0" cellspacing="0" width="100%" height="200px">
			<colgroup>
			<col width="68%">
			<col width="1%">
			<col width="31%">
			</colgroup>
			<tr class="Title" valign="top"  style="width:200px; height:100px;">
					
		<td align="left" style="height:100px;">
		<wea:layout attributes="{'cw1':'30%'}">
		<wea:group context="<%=SystemEnv.getHtmlLabelName(81711,user.getLanguage())%>" attributes="{'samePair':'BaseInfo','groupOperDisplay':'none','groupSHBtnDisplay':'none'}">
		<wea:item><%=SystemEnv.getHtmlLabelName(15636,user.getLanguage())%></wea:item>
		
		<wea:item>
           <textarea class="InputStyle" id="expression" name="expression" rows="14" style="width:100%;height=200px" onkeydown="if(event.keyCode!=8) return false;" ><%=expression%></textarea>
		</wea:item>	
	
	</wea:group>
	</wea:layout>
	</td>
	<td></td>
	<td align="left"  style="height:100px;">
	<wea:layout >
		<wea:group context="<%=SystemEnv.getHtmlLabelName(125411,user.getLanguage())%>" attributes="{'groupSHBtnDisplay':'none','groupOperDisplay':'none'}">
		<wea:item attributes="{'colspan':'full'}">
		    <input class=inputstyle type=text style='width:100px!important;' size=10 maxlength="1" name="mark" id="mark"  value="" onkeyup="value=value.replace(/[\w\/]/ig,'')" onchange='' _noMultiLang='true' >  <a style="color:#00B2FC;" onclick="insertIntoTextarea1();"><%=SystemEnv.getHtmlLabelName(33415,user.getLanguage())%></a>
		</wea:item>
		</wea:group>
		<wea:group context="<%=SystemEnv.getHtmlLabelName(125412,user.getLanguage())%>" attributes="{'groupSHBtnDisplay':'none','groupOperDisplay':'none','itemAreaDisplay':'none'}">
		</wea:group>
	</wea:layout>
		<div style="width:170px; height:150px; overflow:scroll; overflow-x:hidden;">
		
		<% 
		if(fieldNames!=null&&fieldNames.length>0){
		for(int i=0;i<fieldNames.length;i++){
			if(!fieldNames[i].equals("")){
		%>
			<div id="<%=fieldNames[i]%>" onclick="insertMark(this)"><a style="color:#00B2FC;"><%=fieldNames[i]%></a></div>
		<% 
			}
		}
		}
		%>
		</div>
	</td>
     </tr>
</table>
 <wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(82743,user.getLanguage())%>' attributes="{'groupDisplay':'none','groupSHBtnDisplay':'none'}">
		<wea:item attributes="{'isTableList':'true'}">
		</wea:item>
       
	</wea:group>
	<wea:group context="<%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%>"  attributes="{'groupSHBtnDisplay':'none'}">
		<wea:item attributes="{'colspan':'full'}">
		 <%=info %>
		</wea:item>
	</wea:group>
</wea:layout>

 <%if("1".equals(isDialog)){ %>
 <input type="hidden" name="isdialog" value="<%=isDialog%>">
 <%} %>
 </form>

<script language=javascript>
jQuery(document).ready(function(){
	
});
function submitData() {

  
	var returnValue =$("#expression").val()+"###save";  

	var dialog = parent.parent.getDialog(parent);
	 dialog.callback(returnValue);
     dialog.close(returnValue);
	
}

function insertMark(obj){
	insertIntoTextarea(obj);
}

function insertIntoTextarea(obj1){
     var temp=$(obj1).attr("id");
    
    var textvalue=temp;
	var obj = document.getElementById("expression");
	obj.focus();
	
	//if(document.selection){
	   //alert(document.selection.createRange().text);
		//document.selection.createRange().text = textvalue;
	//}else{
	
	if(typeof(obj.selectionStart)!="undefined"&&obj.value.substr(0, obj.selectionStart).length>0){
	
	textvalue="+"+textvalue;
	}
	//alert(obj.value.substr(obj.selectionEnd).length);
	if(typeof(obj.selectionEnd)!="undefined"&&obj.value.substr(obj.selectionEnd).length>0){
	
	textvalue=textvalue + "+";
	}
	if(typeof(obj.selectionStart)=="undefined"||typeof(obj.selectionEnd)=="undefined"){
	
	   if(obj.value.length>0){
	   obj.value=obj.value+"+"+textvalue;
		
		}else{
		obj.value=obj.value+textvalue;
		}
		return;
	}
		obj.value = obj.value.substr(0, obj.selectionStart) +textvalue +  obj.value.substr(obj.selectionEnd);
	//}
}
function insertIntoTextarea1(){
     var temp=$("#mark").val();
    
    var textvalue="\""+temp+"\"";
	var obj = document.getElementById("expression");
	obj.focus();
	//if(document.selection){
	   //alert(document.selection.createRange().text);
		//document.selection.createRange().text = textvalue;
	//}else{
	
	if(typeof(obj.selectionStart)!="undefined"&&obj.value.substr(0, obj.selectionStart).length>0){
	textvalue="+"+textvalue;
	}
	//alert(obj.value.substr(obj.selectionEnd).length);
	if(typeof(obj.selectionEnd)!="undefined"&&obj.value.substr(obj.selectionEnd).length>0){
	textvalue=textvalue + "+";
	}
	if(typeof(obj.selectionStart)=="undefined"||typeof(obj.selectionEnd)=="undefined"){
	 if(obj.value.length>0){
	   obj.value=obj.value+"+"+textvalue;
		
		}else{
		obj.value=obj.value+textvalue;
		}
		return;
	}
	
		obj.value = obj.value.substr(0, obj.selectionStart) +textvalue +  obj.value.substr(obj.selectionEnd);
	//}
}
  
</script>
<%if("1".equals(isDialog)){ %>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<input type="button" style="display:none;" class=zd_btn_submit accessKey=S  id=btnsearch value="S-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"></input>
		<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context=""  attributes="{'groupDisplay':'none'}">
				<wea:item type="toolbar">
					<input type="button" class=zd_btn_cancle accessKey=T  id=btncancel value="T-<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" onclick=" parent.parent.getDialog(parent).close();"></input>
				</wea:item>
			</wea:group>
		</wea:layout>
		<script type="text/javascript">
			jQuery(document).ready(function(){
				resizeDialog(document);
			});
		</script>
	</div>
</div>
<%} %>
</BODY>
</HTML>
