<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.hrm.train.TrainLayoutComInfo" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="TrainTypeComInfo" class="weaver.hrm.tools.TrainTypeComInfo" scope="page" />
<jsp:useBean id="TrainPlanComInfo" class="weaver.hrm.train.TrainPlanComInfo" scope="page" />
<jsp:useBean id="TrainResourceComInfo" class="weaver.hrm.train.TrainResourceComInfo" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%
/*if(!HrmUserVarify.checkUserRight("HrmTrainEdit:Edit", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}*/
%>	
<html>
<%	
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
String id = request.getParameter("id");
String trainid = "";
String aim = "";
String content = "";
String effect = "";
String plain = "";
String day = "";
String starttime = "";
String endtime = "";

String sql = "select * from HrmTrainDay where id = "+id;	
rs.executeSql(sql);
while(rs.next()){
  trainid = Util.null2String(rs.getString("trainid"));
  aim = Util.toScreenToEdit(rs.getString("daytrainaim"),user.getLanguage());//Util.null2String(rs.getString("daytrainaim"));
  content = Util.toScreenToEdit(rs.getString("daytraincontent"),user.getLanguage());//Util.null2String(rs.getString("daytraincontent"));
  effect = Util.null2String(rs.getString("daytraineffect"));
  plain = Util.null2String(rs.getString("daytrainplain"));
  day = Util.null2String(rs.getString("traindate"));
  starttime = Util.null2String(rs.getString("starttime"));
  endtime = Util.null2String(rs.getString("endtime"));
}


String sqlstr ="";
String startDate ="";
String endDate ="";
if(!trainid.equals("")){
    sqlstr = "Select startdate,enddate from HrmTrain WHERE id="+trainid;
    rs.executeSql(sqlstr);
    rs.next();
    startDate = rs.getString("startdate");
    endDate = rs.getString("enddate");
}
String actor = "";
sql = "select planactor from HrmTrainPlan where id = (select planid from HrmTrain where id = "+trainid+")";	
rs.executeSql(sql);
rs.next();
actor = rs.getString("planactor");
%>
<HTML>
<HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script type="text/javascript">
var parentWin = parent.parent.getParentWindow(parent);
var dialog = parent.parent.getDialog(parent);
if("<%=isclose%>"=="1"){
	parentWin.onBtnSearchClick();
	parentWin.closeDialog();	
}
</script>
</head>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(532,user.getLanguage())+SystemEnv.getHtmlLabelName(678,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+SystemEnv.getHtmlLabelName(532,user.getLanguage())+SystemEnv.getHtmlLabelName(2211,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:dosave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:dodelete(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
//RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/train/train/HrmTrainEdit.jsp?id="+trainid+",_self} " ;
//RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="dosave();">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<FORM id=weaver name=frmMain action="TrainDayOperation.jsp" method=post >
<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
	  <wea:item><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></wea:item>
	  <wea:item>
	    <BUTTON type="button" class=Calendar id=selectstartdate onclick="getDatejd(dayspan,day)" onchange='checkinput("day","dayspan")'></BUTTON> 
	    <SPAN id=dayspan ><%=day%></SPAN> 
	    <input type="hidden" id="day" name="day" value=<%=day%>>            
	  </wea:item>
	  <wea:item><%=SystemEnv.getHtmlLabelName(742,user.getLanguage())%></wea:item>
	  <wea:item>
			<BUTTON class=Calendar type=button onclick='onShowTime(starttimespan, starttime)' onchange='checkinput("starttime","starttimespan")'></BUTTON>
			<SPAN id='starttimespan'><%=starttime %></SPAN>
			<input class=inputstyle type=hidden id='starttime' name='starttime' value="<%=starttime %>">
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(743,user.getLanguage())%></wea:item>
		<wea:item>
			<BUTTON class=Calendar type=button onclick='onShowTime(endtimespan, endtime)' onchange='checkinput("endtime","endtimespan")'></BUTTON>
			<SPAN id='endtimespan'><%=endtime %></SPAN>
			<input class=inputstyle type=hidden id='endtime' name='endtime' value="<%=endtime %>">
		</wea:item>
	  <wea:item><%=SystemEnv.getHtmlLabelName(345,user.getLanguage())%></wea:item>
	  <wea:item>
	    <textarea class=inputstyle cols=50 rows=4 style="width: 80%" name=content value=<%=content%>><%=content%></textarea>
	  </wea:item>
	  <wea:item><%=SystemEnv.getHtmlLabelName(16142,user.getLanguage())%> </wea:item>
	  <wea:item>
	    <textarea class=inputstyle  cols=50 rows=4 style="width: 80%" name=aim value=<%=aim%>><%=aim%></textarea>            
	  </wea:item>
	  <wea:item><%=SystemEnv.getHtmlLabelName(16145,user.getLanguage())%> </wea:item>
	  <wea:item>
	    <textarea class=inputstyle cols=50 rows=4 style="width: 80%" name=effect value=<%=effect%>><%=effect%></textarea>            
	  </wea:item>
	  <wea:item><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%> </wea:item>
	  <wea:item>
	    <textarea class=inputstyle cols=50 rows=4 style="width: 80%" name=plain value=<%=plain%>><%=plain%></textarea>            
	  </wea:item> 
	</wea:group>
</wea:layout>
<input type="hidden" name=operation> 
<input type=hidden name=id value=<%=id%>>
<input type=hidden name=trainid value=<%=trainid%>>
 </form>
 <%if("1".equals(isDialog)){ %>
  </div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout type="2col">
	    <wea:group context="">
	    	<wea:item type="toolbar">
	    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand();">
	    	</wea:item>
	   	</wea:group>
	  </wea:layout>
	</div>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
<%} %>
<script language=javascript>

function getDatejd(spanname,inputname){  
		WdatePicker({lang:languageStr,el:spanname,onpicked:function(dp){
			var returnvalue = dp.cal.getDateStr();
			$dp.$(inputname).value = returnvalue;
			},
			oncleared:function(dp){
			$dp.$(inputname).value = ''
			checkinputjd(inputname,spanname)
			}
			});
	
}

function checkinputjd(inputname,spanname){
	if(jQuery(inputname).val()==""){
		spanname.innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
	}else{
		spanname.innerHTML = "";
	}
}
function dosave(){
if(check_form(document.frmMain,'day')&&checkDateValidity()){        
    document.frmMain.operation.value="edit";
    document.frmMain.submit();
    }
} 
function dodelete(){ 
  if(confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>")){     
    document.frmMain.operation.value="delete";
    document.frmMain.submit();
  }
}   

function checkDateValidity(){
    var isValid = true;
    var selectDay = frmMain.day.value;
    var startDate ="<%=startDate%>";
    var endDate ="<%=endDate%>";
    if(compareDate(startDate,selectDay)==1 || compareDate(selectDay,endDate)==1){
        alert("<%=SystemEnv.getHtmlLabelName(83883,user.getLanguage())%>"+startDate+"<%=SystemEnv.getHtmlLabelName(31052,user.getLanguage())%>"+endDate+"<%=SystemEnv.getHtmlLabelName(83882,user.getLanguage())%>");
        isValid = false;
    }
    return isValid;
}
/**
 *Author: Charoes Huang
 *compare two date string ,the date format is: yyyy-mm-dd hh:mm
 *return 0 if date1==date2
 *       1 if date1>date2
 *       -1 if date1<date2
*/
function compareDate(date1,date2){
	//format the date format to "mm-dd-yyyy hh:mm"
	var ss1 = date1.split("-",3);
	var ss2 = date2.split("-",3);

	date1 = ss1[1]+"-"+ss1[2]+"-"+ss1[0];
	date2 = ss2[1]+"-"+ss2[2]+"-"+ss2[0];

	var t1,t2;
	t1 = Date.parse(date1);
	t2 = Date.parse(date2);
	if(t1==t2) return 0;
	if(t1>t2) return 1;
	if(t1<t2) return -1;

    return 0;
}
 
 </script>
 </BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<script type="text/javascript" src="/js/selectDateTime_wev8.js"></script>
 </HTML>
