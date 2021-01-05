
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />

<%
String userid = ""+user.getUID();
String logintype = ""+user.getLogintype();

char flag=Util.getSeparator() ;
String ProcPara = "";

String recorderid = Util.null2String(request.getParameter("recorderid"));
String meetingid = Util.null2String(request.getParameter("meetingid"));
    
RecordSet.executeSql("select * from meeting_topic where id="+recorderid) ;
if(RecordSet.next())
    meetingid=RecordSet.getString("meetingid") ;

String meetingdate="" ;
RecordSet.executeSql("select * from meeting where id="+meetingid) ;
if(RecordSet.next())
    meetingdate=RecordSet.getString("begindate") ;
%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
<LINK href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type=text/css rel=STYLESHEET>
<LINK href="/css/ecology8/request/seachBody_wev8.css" type=text/css rel=STYLESHEET>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(2108,user.getLanguage());
String needfav ="1";
String needhelp ="";

String needcheck="";
int decisionrows=0;

%>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(1),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(309,user.getLanguage())+",javascript:btn_cancle(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
	   <td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; ">
			<input type="button"
				value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage())%>"
				class="e8_btn_top middle" onclick="doSave(1)">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu middle"></span>
		</td>
	</tr>
</table>
<div id="tabDiv" >
	<span id="hoverBtnSpan" class="hoverBtnSpan">
			<span></span>
	</span>
</div>
<div class="advancedSearchDiv" id="advancedSearchDiv">
</div>
<div class="zDialog_div_content">
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">

<tr>
<td valign="top">
<FORM id=weaver name=weaver action="/meeting/data/MeetingTopicDateOperation.jsp" method=post >
<input type="hidden" name="method" value="edit">
<input type="hidden" name="meetingid" value="<%=meetingid%>">
<input type="hidden" name="recorderid" value="<%=recorderid%>">
<input type="hidden" name="decisionrows" value="0">
	  <TABLE width=100% class="ViewForm">
        <TBODY>
        <TR class="Title">
            <TH><%=SystemEnv.getHtmlLabelName(2192,user.getLanguage())%></TH>
            <Td class="Field" align="right">
            	<input class="addbtn" accesskey="A" onclick="addRow();" title="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>" type="button">
				<input class="delbtn" accesskey="E" onclick="deleteRow1()" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" type="button">
			</Td>
          </TR>
      <TR class="Spacing" style="height:1px!important;">
          <TD class="Line1" colspan=2></TD></TR>
        <TR>
          <TD class="Field" colspan=2> 
		  
	  <TABLE width=100% class="ListStyle LayoutTable" cellspacing=0 cellpadding=0  cols=5 id="oTable">

        <TBODY>
		<tr class="header">
			<th width=4%>&nbsp;</th>
			<th width=24%><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%></th>
			<th width=24%><%=SystemEnv.getHtmlLabelName(742,user.getLanguage())%></th>
			<th width=24%><%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%></th>
			<th width=24%><%=SystemEnv.getHtmlLabelName(743,user.getLanguage())%></th>
		</tr>
<%
RecordSet.executeProc("Meeting_TopicDate_SelectAll",meetingid+flag+recorderid);
while(RecordSet.next()){
%>
		<tr class="DataDark">
			<td class="Field"><input class="inputstyle" type='checkbox' name='check_node' value='0'></td>
			<td class="Field">
				<button type='button' class="Clock" onclick="getDate(begindate_<%=decisionrows%>span,begindate_<%=decisionrows%>)"></button><span id="begindate_<%=decisionrows%>span"><%=RecordSet.getString("begindate")%></span><input type="hidden" name="begindate_<%=decisionrows%>" value="<%=RecordSet.getString("begindate")%>">
			</td>
			<td class="Field">
				<button type='button' class="Clock" onclick="onshowMeetingTime(BeginTime_<%=decisionrows%>span,begintime_<%=decisionrows%>)"></button><span id="BeginTime_<%=decisionrows%>span"><%=RecordSet.getString("begintime")%></span><input  type="hidden" name="begintime_<%=decisionrows%>" value="<%=RecordSet.getString("begintime")%>">
			</td>
			<td class="Field">
				<button type='button' class="Clock" onclick="getDate(enddate_<%=decisionrows%>span,enddate_<%=decisionrows%>)"></button><span id="enddate_<%=decisionrows%>span"><%=RecordSet.getString("enddate")%></span><input type="hidden" name="enddate_<%=decisionrows%>" value="<%=RecordSet.getString("enddate")%>">
			</td>
			<td class="Field">
				<button type='button' class="Clock" onclick="onshowMeetingTime(EndTime_<%=decisionrows%>span,endtime_<%=decisionrows%>)"></button><span id="EndTime_<%=decisionrows%>span"><%=RecordSet.getString("endtime")%></span><input type="hidden" name="endtime_<%=decisionrows%>" value="<%=RecordSet.getString("endtime")%>">
			</td>
		</tr>
<%
decisionrows = decisionrows +1;
}
%>
        </TBODY>
	  </TABLE>		  


</td>
</tr>
</TABLE>
</FORM>
</td>
</tr>
<tr>
<td height="10" colspan="5"></td>
</tr>
</table>

</div>

<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout type="2col">
		<wea:group context="">
			<wea:item type="toolbar">
				<input type="button"
					value="<%=SystemEnv.getHtmlLabelName(309, user.getLanguage())%>"
					id="zd_btn_cancle" class="zd_btn_cancle" onclick="btn_cancle()">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<script language="JavaScript" src="/js/addRowBg_wev8.js" >   
</script>  
<script language=javascript>  
var rowindex = "<%=decisionrows%>";
var rowColor="" ;
function addRow()
{
    //var oTable=document.getElementById("oTable");
    //alert(oTable);
	//var ncol = oTable.cols;
	//var oRow = oTable.insertRow();
	//alert(12);
	rowColor = getRowBg();
	
	var htmlstr="";
	htmlstr=htmlstr+"<tr class='DataDark'>";
	htmlstr=htmlstr+"<td class='Field' style='background:"+rowColor+"'><input class='inputstyle' type='checkbox' name='check_node' value='0'></td>";
	htmlstr=htmlstr+"<td class='Field' style='background:"+rowColor+"'><button type='button' class='Clock' onclick=getDate(begindate_"+rowindex+"span,begindate_"+rowindex+")></button><span id='begindate_"+rowindex+"span'></span><input class='inputstyle' type=hidden name='begindate_"+rowindex+"'></td>";
	htmlstr=htmlstr+"<td class='Field' style='background:"+rowColor+"'><button type='button' class='Clock' onclick=onshowMeetingTime(BeginTime_"+rowindex+"span,begintime_"+rowindex+")></button><span id='BeginTime_"+rowindex+"span'></span><input class='inputstyle' type='hidden' name='begintime_"+rowindex+"'></td>";
	htmlstr=htmlstr+"<td class='Field' style='background:"+rowColor+"'><button type='button' class='Clock' onclick=getDate(enddate_"+rowindex+"span,enddate_"+rowindex+")></button><span id='enddate_"+rowindex+"span'></span><input class='inputstyle' type='hidden' name='enddate_"+rowindex+"'></td>";
	htmlstr=htmlstr+"<td class='Field' style='background:"+rowColor+"'><button type='button' class='Clock' onclick=onshowMeetingTime(EndTime_"+rowindex+"span,endtime_"+rowindex+")></button><span id='EndTime_"+rowindex+"span'></span><input class='inputstyle' type=hidden name='endtime_"+rowindex+"'></td>";
	htmlstr=htmlstr+"</tr>";
	
	jQuery("#oTable tbody").append(htmlstr);
	rowindex = rowindex*1 +1;
	jQuery("body").jNice();
	/*
	alert(rowColor);
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell();
		oCell.style.height=24;
		oCell.style.background= rowColor;
		switch(j) {
			case 0:
				var oDiv = document.createElement("div");
				var sHtml = "<input class=inputstyle type='checkbox' name='check_node' value='0'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 1:
				var oDiv = document.createElement("div");
				var sHtml = "<button class=Clock onclick=getDate(begindate_"+rowindex+"span,begindate_"+rowindex+")></button><span id='begindate_"+rowindex+"span'></span><input class=inputstyle type=hidden name='begindate_"+rowindex+"'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 2:
				var oDiv = document.createElement("div");
				var sHtml = "<button class=Clock onclick=onShowTime(BeginTime_"+rowindex+"span,begintime_"+rowindex+")></button><span id='BeginTime_"+rowindex+"span'></span><input class=inputstyle type=hidden name='begintime_"+rowindex+"'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 3:
				var oDiv = document.createElement("div");
				var sHtml = "<button class=Clock onclick=getDate(enddate_"+rowindex+"span,enddate_"+rowindex+")></button><span id='enddate_"+rowindex+"span'></span><input class=inputstyle type=hidden name='enddate_"+rowindex+"'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 4:
				var oDiv = document.createElement("div");
				var sHtml = "<button class=Clock onclick=onShowTime(EndTime_"+rowindex+"span,endtime_"+rowindex+")></button><span id='EndTime_"+rowindex+"span'></span><input class=inputstyle type=hidden name='endtime_"+rowindex+"'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;

		}
	}
	rowindex = rowindex*1 +1;
    */
}
function deleteRow1()
{
	Dialog.confirm("<%=SystemEnv.getHtmlLabelName(16344, user.getLanguage())%>", function (){
		dodeleteRow1();	
	}, function () {}, 320, 90,false);
}
function dodeleteRow1()
{
	len = document.forms[0].elements.length;
	var i=0;
	var rowsum1 = 1;
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_node')
			rowsum1 += 1;
	}
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_node'){
			if(document.forms[0].elements[i].checked==true) {
				oTable.deleteRow(rowsum1 - 1);
			}
			rowsum1 -=1;
		}

	}
}

function doSave(savemethod){
    if(savemethod==1) savemethod="edit";
	if(check_form(document.weaver,'<%=needcheck%>')){
		document.weaver.method.value=savemethod;
		document.weaver.decisionrows.value=rowindex;
		document.weaver.submit();
	}
}

function btn_cancle(){
	 var parentWin = parent.parent.getParentWindow(window.parent);
     parentWin.diag_vote.close();
}

jQuery(document).ready(function(){
	resizeDialog(document);
});

</script>

</body>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>
</html>

