
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ScheduleXML" class="weaver.servicefiles.ScheduleXML" scope="page" />
<HTML><HEAD>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css" type="text/css" />
</head>
<%
if(!HrmUserVarify.checkUserRight("intergration:schedulesetting",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

String imagefilename = "/images/hdSystem_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(23663,user.getLanguage());
String needfav ="1";
String needhelp ="";

String parascheduleid = Util.null2String(request.getParameter("scheduleid"));

String moduleid = ScheduleXML.getModuleId();
ArrayList pointArrayList = ScheduleXML.getPointArrayList();
Hashtable dataHST = ScheduleXML.getDataHST();
String scheduleOPTIONS = "";
String thisClass = "";
String thisCronExpr = "";

String checkString = "";
%>

<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:add(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<FORM style="MARGIN-TOP: 0px" name=frmMain method=post action="schedulesetting.jsp">
<input type="hidden" id="operation" name="operation">
<input type="hidden" id="method" name="method">
<input type="hidden" id="sdnums" name="sdnums" value="<%=pointArrayList.size()%>">
	<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td></td>
			<td class="rightSearchSpan" style="text-align:right; width:500px!important">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>" class="e8_btn_top" onclick="add()"/>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="onSubmit()"/>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" class="e8_btn_top" onclick="onDelete()"/>
				<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
			</td>
		</tr>
	</table>
	<div id="tabDiv" >
	   <span style="font-size:14px;font-weight:bold;"><%=titlename%></span> 
	</div>
	
	<div class="cornerMenuDiv"></div>
	<div class="advancedSearchDiv" id="advancedSearchDiv">
	</div>
	<TABLE class="ListStyle" cellspacing=1>
		<COLGROUP> 
			<COL width="4%"> 
			<COL width="26%"> 
			<COL width="40%">
			<COL width="30%">
		<TBODY>
		
		<TR class=header>
		  <th><INPUT type="checkbox" name="chkAll" onClick="chkAllClick(this)"></th>
		  <th><nobr><%=SystemEnv.getHtmlLabelName(31801,user.getLanguage())%></nobr></th>
		  <th><nobr><%=SystemEnv.getHtmlLabelName(16539,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></nobr></th>
		  <th><nobr><%=SystemEnv.getHtmlLabelName(23673,user.getLanguage())%></nobr></th>
		  <th><nobr><%=SystemEnv.getHtmlLabelName(23674,user.getLanguage())%></nobr></th>
		</TR>
		
		<%
		int colorindex = 0;
		int rowindex = 0;
		for(int i=0;i<pointArrayList.size();i++){
		    String pointid = (String)pointArrayList.get(i);
		    if(pointid.equals("")) continue;
		    checkString += "scheduleid_"+rowindex+",";
		    Hashtable thisDetailHST = (Hashtable)dataHST.get(pointid);
		    if(thisDetailHST!=null){
		        thisClass = (String)thisDetailHST.get("construct");
		        thisCronExpr = (String)thisDetailHST.get("cronExpr");
		    }
		    if(colorindex==0){
		    %>
		    <tr class="DataDark">
		    <%
		        colorindex=1;
		    }else{
		    %>
		    <tr class="DataLight">
		    <%
		        colorindex=0;
		    }%>
		    <td><input type="checkbox" id="del_<%=rowindex%>" name="del_<%=rowindex%>" value="0" onclick="if(this.checked){this.value=1;}else{this.value=0;}"></td>
		    <td>
		    <%=rowindex+1 %>
		    <span id="Rownumspan_<%=rowindex%>"></span>
		    </td>
		    <td>
		    	<input class="inputstyle" type=text id="scheduleid_<%=rowindex%>" name="scheduleid_<%=rowindex%>" size=20 maxlength="50" value="<%=pointid%>" onChange="checkinput('scheduleid_<%=rowindex%>','scheduleidspan_<%=rowindex%>')" onblur="checkSID(this.value,<%=rowindex%>)">
		    	<span id="scheduleidspan_<%=rowindex%>"></span>
		    	<input class="inputstyle" type=hidden id="oldscheduleid_<%=rowindex%>" name="oldscheduleid_<%=rowindex%>"value="<%=pointid%>">
		    </td>
		    <td><input class="inputstyle schedulesClass" type=text id="ClassName_<%=rowindex%>" name="ClassName_<%=rowindex%>" size=40 value="<%=thisClass%>" onChange="checkinput('ClassName_<%=rowindex%>','ClassNamespan_<%=rowindex%>')" >
		    	<span id="ClassNamespan_<%=rowindex%>"></span>
		    </td>
		    <td><input class="inputstyle schedulesCron" type=text id="CronExpr_<%=rowindex%>" name="CronExpr_<%=rowindex%>" size=30 value="<%=thisCronExpr%>" onChange="checkinput('CronExpr_<%=rowindex%>','CronExprspan_<%=rowindex%>')" >
		    	<span id="CronExprspan_<%=rowindex%>"></span>
		    </td>
		  	</tr>
		<%
		    rowindex++; 
		}
		%>
		  </TBODY>
		</TABLE>
		<br>
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
</BODY>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script language="javascript">
jQuery(document).ready(function () {
	$("#topTitle").topMenuTitle();
	$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
	$("#tabDiv").remove();
	$("#advancedSearch").bind("click", function(){
	  $(".searchInput").val('');
	});
});
function chkAllClick(obj)
{
    var dsnums = document.getElementById("sdnums").value;
    for(var i=0;i<dsnums;i++){
        var chk = document.getElementById("del_"+i);;
        if(chk)
        {
	        chk.checked = obj.checked;
	        if(chk.checked)
	        {
	        	chk.value = "1";
	        }
	        else
	        {
	        	chk.value = "0";
	        }
	        try
           	{
           		if(chk.checked)
           			jQuery(chk.nextSibling).addClass("jNiceChecked");
           		else
           			jQuery(chk.nextSibling).removeClass("jNiceChecked");
           	}
           	catch(e)
           	{
           	}
        }
    }
}
var dialog = null;
function closeDialog(){
	if(dialog)
		dialog.close();
}
//新建子目录
function openDialog(url,title,width,height){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = url;
	dialog.Title = title;
	dialog.Width = width;
	dialog.Height = height;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}
function add()
{
	var url = "/integration/integrationTab.jsp?urlType=12&isdialog=1";
	var title = "<%=SystemEnv.getHtmlLabelName(21927,user.getLanguage())%>";
	openDialog(url,title,600,350);
}
function onSubmit(){
    if(check_form(frmMain,"<%=checkString%>")){
    	var param ={"operation":"schedule","method":"checkSchedule"};
    	var clasz = new Array();
    	var cron = new Array();
    	jQuery(".schedulesClass").each(function(){clasz.push(this.value);});;
    	jQuery(".schedulesCron").each(function(){cron.push(this.value);});
    	param.clasz = clasz;
    	param.cron = cron;
    
	    jQuery.post("XMLFileOperation.jsp",param ,function(msg){
		    if(msg.ok){
		        frmMain.action="XMLFileOperation.jsp";
		        frmMain.operation.value="schedule";
		        frmMain.method.value="edit";
		        frmMain.submit();
		    }else{
		    	top.Dialog.alert(msg.msg);
		    }
	    },"json");
    }
}

function onDelete(){
	var isselected = false;
	var dsnums = document.getElementById("sdnums").value;
    for(var i=0;i<dsnums;i++){
        var chk = document.getElementById("del_"+i);;
        if(chk)
        {
	        if(chk.checked)
	        {
	        	isselected = true;
	        }
        }
    }
    if(!isselected)
   	{
   		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22686,user.getLanguage()) %>");
		return ;
   	}
    top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function (){
        frmMain.action="/servicesetting/XMLFileOperation.jsp";
        frmMain.operation.value="schedule";
        frmMain.method.value="delete";
        frmMain.submit();
    }, function () {}, 320, 90);
}
function checkSID(thisvalue,rowindex){
	thisvalue = $.trim(thisvalue);
    sdnums = document.getElementById("sdnums").value;
    var tempotherdsname = document.getElementById("oldscheduleid_"+rowindex).value;
    if(thisvalue!=""){
    	if(isSpecialChar(thisvalue)){
    		//计划任务名称包含特殊字段，请重新输入！
    		//top.Dialog.alert(thisvalue+"<%=SystemEnv.getHtmlLabelNames("16539,128458",user.getLanguage())%>");
			top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("16539,128458",user.getLanguage())%>");
    		document.getElementById("scheduleid_"+rowindex).value = "";
    		document.getElementById("scheduleidspan_"+rowindex).innerHTML = "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
    		
    		return false;
    	}
    	if(isChineseChar(thisvalue)){
    		//计划任务名称包含中文，请重新输入！
    		//top.Dialog.alert(thisvalue+"<%=SystemEnv.getHtmlLabelNames("16539,128459",user.getLanguage())%>");
			top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("16539,128459",user.getLanguage())%>");
    		document.getElementById("scheduleid_"+rowindex).value = "";
    		document.getElementById("scheduleidspan_"+rowindex).innerHTML = "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
    		
    		return false;
    	}
    	if(isFullwidthChar(thisvalue)){
    		//计划任务包含全角符号，请重新输入！
    		//top.Dialog.alert(thisvalue+"<%=SystemEnv.getHtmlLabelNames("16539,128460",user.getLanguage())%>");
			top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("16539,128460",user.getLanguage())%>");
    		document.getElementById("scheduleid").value = "";
    		document.getElementById("scheduleidspan_"+rowindex).innerHTML = "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
    		
    		return false;
    	}
        for(var i=0;i<sdnums;i++){
            if(i!=rowindex){
                otherdsname = document.getElementById("scheduleid_"+i).value;
                if(thisvalue==otherdsname){
                    top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(23994,user.getLanguage())%>");//该计划任务已存在！
                    document.getElementById("scheduleid_"+rowindex).value = tempotherdsname;
                }
            }
        }
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
</script>

</HTML>
