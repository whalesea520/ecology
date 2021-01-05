<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.hrm.train.TrainLayoutComInfo" %>
<%@ page import='java.util.*'%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
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
String trainid = request.getParameter("trainid");

/**
 * Added By Charoes Huang on May 18,2004
 * Get the startDate and endDate of the HrmTrain
  */
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

// TD 24259 add by yangdacheng 20111216
String sql ="";

ArrayList trainAct= new ArrayList();
if(!trainid.equals(""))
{
	sql = "select traindate from  HrmTrainDay where trainid = '"+trainid+"'";
	rs.execute(sql);
	while(rs.next())
	{
		trainAct.add(rs.getString("traindate"));
	}
	
}



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
String titlename = SystemEnv.getHtmlLabelName(532,user.getLanguage())+SystemEnv.getHtmlLabelName(678,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(611,user.getLanguage())+SystemEnv.getHtmlLabelName(532,user.getLanguage())+SystemEnv.getHtmlLabelName(1867,user.getLanguage());
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
<FORM id=weaver name=frmMain action="TrainOtherOperation.jsp" method=post >
<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
	  <wea:item><%=SystemEnv.getHtmlLabelName(16140,user.getLanguage())%> </wea:item>
	  <wea:item>
	    <brow:browser viewType="0" name="actor" browserValue=""
	      browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp"
	      hasInput="true" isSingle="false" hasBrowser="true" isMustInput='2'
	      completeUrl="/data.jsp">
	    </brow:browser>
	  </wea:item>	   
    <wea:item><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%></wea:item>
    <wea:item>
      <BUTTON class=Calendar type="button" id=selectstartdate onclick="getDatejd(startspan,startdate_)"></BUTTON> 
      <SPAN id=startspan ><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN> 
      <input class=inputstyle type="hidden" id="startdate_" name="startdate_" onchange="checkinput(startdate_,startspan)">            
    </wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%></wea:item>
    <wea:item>
      <BUTTON class=Calendar type="button" id=selectenddate onclick="getDatejd(endspan,enddate_)"></BUTTON> 
      <SPAN id="endspan" ><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN> 
      <input class=inputstyle type="hidden" id="enddate_" name="enddate_" onchange="checkinput(enddate_,endspan)">            
    </wea:item>  
	</wea:group>
</wea:layout>
<input class=inputstyle type="hidden" name=operation> 
<input class=inputstyle type=hidden name=trainid value=<%=trainid%>>
</form>
    <%if("1".equals(isDialog)){ %>
   </div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout>
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


function onShowResource(inputname,spanname){
	 var id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp");
	 if((id.id!="")){
	  var resourceids = id.id;
	  var resourcename = id.name;
	  var sHtml = "";
	  var ids=resourceids.split(",");
	  var names=resourcename.split(",");
	  inputname.value= resourceids.substring(1,resourceids.length);
	 for(var i=1;i<ids.length;i++){
	   sHtml += "<a href='javascript:window.showModalDialog(\"../../../hrm/resource/HrmResourceBase.jsp?id="+ids[i]+"\");'>"+names[i]+"</a>&nbsp;";
	  }
	  spanname.innerHTML = sHtml;
	 }else{
		 spanname.innerHTML = "<IMG src=\"/images/BacoError_wev8.gif\" align=absMiddle>";
	     inputname.value="0";
	}
}

function dosave(){
  if(check_form(document.frmMain,"startdate_","enddate_")&&checkDateValidity()){
    document.frmMain.operation.value="addactor";
    document.frmMain.submit();
  }
}

/* 
* TD 24259 add by yangdacheng 20111216
*/


function checkDateValidity(){
    var isValid = false;
    var startdate_ = frmMain.startdate_.value;
    var enddate_ = frmMain.enddate_.value;
    var startDate ="<%=startDate%>";
    var endDate ="<%=endDate%>";
    var trainDate ="";
    
    var my_array = new Array();
    <%
    for(int i = 0; i<trainAct.size(); i++)
    {
    %>
    	my_array[<%=i%>] = '<%=Util.null2String((String)trainAct.get(i))%>';
    <%
    }
    %>
   	if(compareDate(startdate_,enddate_,startDate,endDate)&&compareDate2(my_array,startdate_,enddate_))
   	{
   		isValid = true;
   	}
    
 
    return isValid;
}




function compareDate(pstartdate,penddate,started,endend){

	var ischeck = false;
    var startDate ="<%=startDate%>";
    var endDate ="<%=endDate%>";
    

    if(pstartdate>penddate){
    window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(16721,user.getLanguage())%>");
     
     }
	else if(started<=pstartdate&&penddate<=endend)

	{
		ischeck = true;
	}
	else
	{
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83881,user.getLanguage())%>"+startDate+"<%=SystemEnv.getHtmlLabelName(31052,user.getLanguage())%>"+endDate+"<%=SystemEnv.getHtmlLabelName(83882,user.getLanguage())%>");
	}

    return ischeck;
}

function compareDate2(obj,startdate,endend){

	var ischeck = false;
	for(var i=0;i<obj.length; i++)
	{
		var date1=obj[i];
		if(date1>=startdate&&date1<=endend)
		{
			ischeck = true;
			break;
		}
	}
	if(!ischeck)
	{
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(27623,user.getLanguage())%>");
	}
    return ischeck;
}

 </script>

</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>
