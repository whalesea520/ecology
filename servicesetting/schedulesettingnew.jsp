
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ScheduleXML" class="weaver.servicefiles.ScheduleXML" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
</head>
<%
if(!HrmUserVarify.checkUserRight("intergration:schedulesetting",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
String isDialog = Util.null2String(request.getParameter("isdialog"));
String imagefilename = "/images/hdSystem_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(23663,user.getLanguage());
String needfav ="1";
String needhelp ="";

ArrayList pointArrayList = ScheduleXML.getPointArrayList();
String pointids = ",";
for(int i=0;i<pointArrayList.size();i++){
    String pointid = (String)pointArrayList.get(i);
    pointids += pointid+",";
}
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
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86 ,user.getLanguage()) %>" class="e8_btn_top" onclick="onSubmit()"/>
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
<FORM style="MARGIN-TOP: 0px" name=frmMain method=post action="XMLFileOperation.jsp">
	<input type="hidden" id="operation" name="operation" value="schedule">
	<input type="hidden" id="method" name="method" value="add">
	<input type="hidden" name="isdialog" value="<%=isDialog%>">
	<wea:layout>
		<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>' attributes="{'samePair':'BaseInfo','groupOperDisplay':'none'}">
		  <wea:item><%=SystemEnv.getHtmlLabelName(16539,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></wea:item>
		  <wea:item>
		  	<wea:required id="scheduleidspan" required="true" value="">
		  		<input class="inputstyle" type=text style='width:280px!important;' id="scheduleid"  maxlength="50" name="scheduleid" onChange="checkinput('scheduleid','scheduleidspan')" onblur="isExist(this.value)">
		  	</wea:required>
		  </wea:item>
		  <wea:item><%=SystemEnv.getHtmlLabelName(23673,user.getLanguage())%></wea:item>
		  <wea:item>
		  	<input class="inputstyle" type=text style='width:400px!important;' id="ClassName" name="ClassName" size=50  onChange="checkinput('ClassName','ClassNamespan')">
			<span id="ClassNamespan"><img src="/images/BacoError_wev8.gif" align=absmiddle></span>
		  </wea:item>
		  <wea:item><%=SystemEnv.getHtmlLabelName(23674,user.getLanguage())%></wea:item>
		  <wea:item>
		  	<input class="inputstyle" type=text style='width:280px!important;' id="CronExpr" name="CronExpr" size=50  onChange="checkinput('CronExpr','CronExprspan')">
			<span id="CronExprspan"><img src="/images/BacoError_wev8.gif" align=absmiddle></span>
		  </wea:item>
	
	</wea:group>
	</wea:layout>
	<wea:layout>
		<wea:group context='<%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%>' attributes="{'samePair':'RemarkInfo','groupOperDisplay':'none','itemAreaDisplay':'block'}">
		  <wea:item attributes="{'colspan':'2'}">
			1.<%=SystemEnv.getHtmlLabelName(23970,user.getLanguage())%>；
			<BR>
			2.<%=SystemEnv.getHtmlLabelName(382355,user.getLanguage())%>；
			<BR>
			3.<%=SystemEnv.getHtmlLabelName(23972,user.getLanguage())%>。
		  </wea:item>
		</wea:group>
	</wea:layout>
  </FORM>
  <%if("1".equals(isDialog)){ %>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<input type="button" style="display:none;" class=zd_btn_submit accessKey=S  id=btnsearch value="S-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"></input>
		<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context=""  attributes="{'groupDisplay':'none'}">
				<wea:item type="toolbar">
					<input type="button" class=zd_btn_cancle accessKey=T  id=btncancel value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" onclick='onBack();'></input>
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
<script language="javascript">
function onSubmit(){
    if(check_form(frmMain,"scheduleid,ClassName,CronExpr")){
    	var param ={"operation":"schedule","method":"checkSchedule"};
   		param.clasz = [jQuery("#ClassName").val()];
    	param.cron = [jQuery("#CronExpr").val()];
     	jQuery.post("XMLFileOperation.jsp",param ,function(msg){
		    if(msg.ok){
		        frmMain.submit();
		    }else{
		    	top.Dialog.alert(msg.msg);
		    }
	    },"json")
    } 
}
function onBack()
{
	parentWin.closeDialog();
}
function isExist(newvalue){
	newvalue = $.trim(newvalue);
	if(isSpecialChar(newvalue)){
		//计划任务名称包含特殊字段，请重新输入！
		//top.Dialog.alert(newvalue+"<%=SystemEnv.getHtmlLabelNames("16539,128458",user.getLanguage())%>");
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("16539,128458",user.getLanguage())%>");
		document.getElementById("scheduleid").value = "";
		checkinput('scheduleid','scheduleidspan');
		
		return false;
	}
	if(isChineseChar(newvalue)){
		//计划任务名称包含中文，请重新输入！
		//top.Dialog.alert(newvalue+"<%=SystemEnv.getHtmlLabelNames("16539,128459",user.getLanguage())%>");
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("16539,128459",user.getLanguage())%>");
		document.getElementById("scheduleid").value = "";
		checkinput('scheduleid','scheduleidspan');
		
		return false;
	}
	if(isFullwidthChar(newvalue)){
		//计划任务包含全角符号，请重新输入！
		//top.Dialog.alert(newvalue+"<%=SystemEnv.getHtmlLabelNames("16539,128460",user.getLanguage())%>");
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("16539,128460",user.getLanguage())%>");
		document.getElementById("scheduleid").value = "";
		checkinput('scheduleid','scheduleidspan');
		
		return false;
	}
    var pointids = "<%=pointids%>";
    if(pointids.indexOf(","+newvalue+",")>-1){
        top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(23994,user.getLanguage())%>");
        document.getElementById("scheduleid").value = "";
        checkinput('scheduleid','scheduleidspan');
    }
}
//是否包含特殊字段
function isSpecialChar(str){
	var reg = /[-\+=\`~!@#$%^&\*\(\)\[\]{};:'",.<>\/\?\\|]/;
	return reg.test(str);
}
//是否含有中文（也包含日文和韩文）
function isChineseChar(str){   
   var reg = /[\u4E00-\u9FA5\uF900-\uFA2D]/;
   return reg.test(str);
}
//是否含有全角符号的函数
function isFullwidthChar(str){
   var reg = /[\uFF00-\uFFEF]/;
   return reg.test(str);
}
jQuery(document).ready(function () {
	$("#topTitle").topMenuTitle();
	$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
	$("#tabDiv").remove();
	$("#advancedSearch").bind("click", function(){
	  $(".searchInput").val('');
	});
});
</script>

</HTML>
