<!DOCTYPE html>
<%@page import="weaver.workflow.workflow.WfRightManager"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.workflow.workflow.UserWFOperateLevel" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WFManager" class="weaver.workflow.workflow.WFManager" scope="session"/>
<jsp:useBean id="FormComInfo" class="weaver.workflow.form.FormComInfo" scope="page" />
<jsp:useBean id="BillComInfo" class="weaver.workflow.workflow.BillComInfo" scope="page" />
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page" />
<jsp:useBean id="wfrm" class="weaver.workflow.workflow.WfRightManager" scope="page" />
<%
    String ajax=Util.null2String(request.getParameter("ajax"));
	int wfid = Util.getIntValue(Util.null2String(request.getParameter("wfid")),0);
	String rightStr = "WorkFlowPlanSet:All";
	if (!HrmUserVarify.checkUserRight(rightStr, user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	
	String wfname="";
	String wfdes="";
	String title="";
	String isbill = "";
	String iscust = "";
	String frequencyt="";
	String status="1";
	String dateType="";
	String timeSet="";
	String dateSum="0";
	String alertType="0";
	
	int formid=0;
	title="edit";
	WFManager.setWfid(wfid);
	WFManager.getWfInfo();
	wfname=WFManager.getWfname();
	wfdes=WFManager.getWfdes();
	formid = WFManager.getFormid();
	isbill = WFManager.getIsBill();
	iscust = WFManager.getIsCust();
	int typeid = 0;
	typeid = WFManager.getTypeid();
	int rowsum=0;
    int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
    int subCompanyId= -1;
    int operatelevel=0;
	if(detachable==1){  
        //如果开启分权，管理员
        subCompanyId=WFManager.getSubCompanyId2();
    }
	boolean haspermission = wfrm.hasPermission3(wfid, 0, user, WfRightManager.OPERATION_CREATEDIR);
	operatelevel = UserWFOperateLevel.checkUserWfOperateLevel(detachable,subCompanyId,user,haspermission,rightStr);
	String titlename = SystemEnv.getHtmlLabelName(259,user.getLanguage());
%>
<%@ include file="/workflow/workflow/addwf_checktetachable.jsp" %>
<html>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link href="/js/checkbox/jquery.tzCheckbox_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script language=javascript src="/js/checkbox/jquery.tzCheckbox_wev8.js"></script>
</head>
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
 if(operatelevel>0){
    if(!ajax.equals("1"))
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:selectall(),_self} " ;
    else
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:flowPlanSave(this),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
    if(!ajax.equals("1")) {
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",addwf.jsp?src=editwf&wfid="+wfid+",_self} " ;

RCMenuHeight += RCMenuHeightStep;
    }
%>

<%
    if(!ajax.equals("1")){
if(RecordSet.getDBType().equals("db2")){
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where int(operateitem)=88 and relatedid="+wfid+",_self} " ;
}else{
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem=88 and relatedid="+wfid+",_self} " ;

}

RCMenuHeight += RCMenuHeightStep ;
    }
    }
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form id="flowPlanForm" name="flowPlanForm" method=post action="WorkFlowPlanSetOperation.jsp" >
<%
if(ajax.equals("1")){
%>
<input type="hidden" name="ajax" value="1">
<%}%>

<wea:layout type="twoCol">
<%if(!ajax.equals("1")){%>
    <wea:group context='<%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%>'>
    	<wea:item><%=SystemEnv.getHtmlLabelName(2079,user.getLanguage())%></wea:item>
	    <wea:item><%=wfname%></wea:item>
    	<wea:item><%=SystemEnv.getHtmlLabelName(15433,user.getLanguage())%></wea:item>
    	<wea:item><%=WorkTypeComInfo.getWorkTypename(""+typeid)%></wea:item>
    	<%if(isPortalOK){%>
    	<wea:item><%=SystemEnv.getHtmlLabelName(15588,user.getLanguage())%></wea:item>
    	<wea:item><%if(iscust.equals("0")){%><%=SystemEnv.getHtmlLabelName(15589,user.getLanguage())%><%}else{%><%=SystemEnv.getHtmlLabelName(15554,user.getLanguage())%><%}%></wea:item>
    	<%}%>
    	<wea:item><%=SystemEnv.getHtmlLabelName(15600,user.getLanguage())%></wea:item>
    	<wea:item>
    	    <%if(isbill.equals("0")){%>
            <%=FormComInfo.getFormname(""+formid)%>
            <%}else if(isbill.equals("1")){
            	int labelid = Util.getIntValue(BillComInfo.getBillLabel(""+formid));
            %>
            <%=SystemEnv.getHtmlLabelName(labelid,user.getLanguage())%>
            <%}else{%>
            <%=" "%>
            <%}%>
    	</wea:item>
    	<wea:item><%=SystemEnv.getHtmlLabelName(15594,user.getLanguage())%></wea:item>
    	<wea:item><%=wfdes%></wea:item>
    </wea:group>
<%} %>   
	<wea:group context='<%=SystemEnv.getHtmlLabelName(18812,user.getLanguage())%>'>
	<%
	RecordSet.execute("select * from WorkFlowPlanSet where flowid="+wfid);
	if(RecordSet.next()){
		 status=RecordSet.getString("status");
		 frequencyt=RecordSet.getString("frequencyt");
		 dateType=RecordSet.getString("dateType");
		 timeSet=RecordSet.getString("timeSet");
		 dateSum=RecordSet.getString("dateSum");
		 alertType=RecordSet.getString("alertType");
	}
	%>
		<wea:item><%=SystemEnv.getHtmlLabelName(18095,user.getLanguage())+SystemEnv.getHtmlLabelName(18812,user.getLanguage())%></wea:item>
		<wea:item><input class=inputstyle tzCheckbox="true" type="checkbox" name="status" value="0" <%if (status.equals("0")) {%>checked<%}%> ></wea:item>
	</wea:group>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(16498,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(18813,user.getLanguage())%></wea:item>
		<wea:item>
	        <select class=inputstyle  name="frequencyt" onchange="changeset(this)" style="width: 150px;">
		        <option value="4" <%if (frequencyt.equals("4")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(539,user.getLanguage())%></option><!--每日-->
		        <option value="0" <%if (frequencyt.equals("0")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(545,user.getLanguage())%></option><!--每周-->
		        <option value="1" <%if (frequencyt.equals("1")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(541,user.getLanguage())%></option><!--每月-->
		        <option value="2" <%if (frequencyt.equals("2")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(543,user.getLanguage())%></option><!--每季度-->
		        <option value="3" <%if (frequencyt.equals("3")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(546,user.getLanguage())%></option><!--每年-->          
	        </select>		
		</wea:item>
		<%
			String  dateTypeShow = "{'samePair':'dateTypeShow','display':''}";
			if(frequencyt.equals("4")||frequencyt.equals("")||frequencyt.equals("0")) dateTypeShow = "{'samePair':'dateTypeShow','display':'none'}";
		 %>
		<wea:item attributes='<%=dateTypeShow %>'><%=SystemEnv.getHtmlLabelName(18814,user.getLanguage())%></wea:item>
		<wea:item attributes='<%=dateTypeShow %>'>
            <select class=inputstyle name="dateType" style="float: left;width: 150px;">
	            <option value="0" <%if (dateType.equals("0")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(18817,user.getLanguage())%></option><!--正数-->
	            <option value="1" <%if (dateType.equals("1")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(18816,user.getLanguage())%></option><!--倒数-->
            </select>
            &nbsp;&nbsp;&nbsp;
            <%=SystemEnv.getHtmlLabelName(15323,user.getLanguage())%>
            <input class=inputstyle value="<%=dateSum%>" name="dateSum"  maxLength=3 size=3  onchange="checkint('dateSum')" style="width: 50px!important;"><%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%>	
		</wea:item>
		
		<!-- 2014-07-15 -->	
		<%
			String  weekTypeShow = "{'samePair':'weekTypeShow','display':'none'}";
			if(frequencyt.equals("0")) weekTypeShow = "{'samePair':'weekTypeShow','display':''}";
		 %>

		<wea:item attributes='<%=weekTypeShow %>'><%=SystemEnv.getHtmlLabelName(18814,user.getLanguage())%></wea:item>
		<wea:item attributes='<%=weekTypeShow %>'>
				<select class=inputstyle name="dateSumWeek" style="float: left;width: 150px;">
	            <option value="1" <%if (dateSum.equals("1")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(16100,user.getLanguage())%></option><!--周一-->
	            <option value="2" <%if (dateSum.equals("2")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(16101,user.getLanguage())%></option><!--周二-->
	            <option value="3" <%if (dateSum.equals("3")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(16102,user.getLanguage())%></option><!--周三-->
	            <option value="4" <%if (dateSum.equals("4")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(16103,user.getLanguage())%></option><!--周四-->
	            <option value="5" <%if (dateSum.equals("5")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(16104,user.getLanguage())%></option><!--周五-->
	            <option value="6" <%if (dateSum.equals("6")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(16105,user.getLanguage())%></option><!--周六-->
	            <option value="7" <%if (dateSum.equals("7")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(16106,user.getLanguage())%></option><!--周日-->
            </select>
		</wea:item>
		<!-- 2014-07-15 -->	
		
		<wea:item><%=SystemEnv.getHtmlLabelName(16498,user.getLanguage())%></wea:item>
		<wea:item>
			<button type="button" class=Clock onclick="onShowTime(timesetspan,timeSet)"></button>
			<span id=timesetspan><%=timeSet%></span>
			<input type=hidden class=inputstyle name="timeSet"  maxLength=2 size=2 value="<%=timeSet%>">
		</wea:item>
	</wea:group> 
	<wea:group context='<%=SystemEnv.getHtmlLabelName(15148,user.getLanguage())+SystemEnv.getHtmlLabelName(68,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(17586,user.getLanguage())%></wea:item>
		<wea:item> <input class=inputstyle tzCheckbox="true" type="checkbox" name="alertType1" value="1" <%if (alertType.equals("1")||alertType.equals("3")) {%>checked<%}%>></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(71,user.getLanguage())+SystemEnv.getHtmlLabelName(15148,user.getLanguage())%></wea:item>
		<wea:item><input class=inputstyle tzCheckbox="true" type="checkbox" name="alertType2" value="2" <%if (alertType.equals("2")||alertType.equals("3")) {%>checked<%}%>></wea:item>
	</wea:group>
</wea:layout>
<center>
<input type="hidden" value="<%=wfid%>" name="wfid">
<center>
</form>
<script language="JavaScript" src="/js/addRowBg_wev8.js" ></script>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>
<script type="text/javascript">
jQuery("input[type=checkbox]").each(function(){
	if(jQuery(this).attr("tzCheckbox")=="true"){
		jQuery(this).tzCheckbox({labels:['','']});
	}
});
</script>
<%if(!ajax.equals("1")){%>
<script language=javascript>
var rowColor="" ;
rowindex = "<%=rowsum%>";
delids = "";

function selectall(){
	document.forms[0].nodessum.value=rowindex;
	document.forms[0].delids.value=delids;

	window.document.portform.submit();
}

</script>
<%}else{%>
<div id=portrowsum style="display:none;"><%=rowsum%></div>
<script type="text/javascript">
function flowPlanSave(obj){
	var type=$("select[name=frequencyt]").val();
	var sum=$("input[name=dateSum]").val();
	var sumweek=$("select[name=dateSumWeek]").val();
	if ((type=="0"&&sumweek>7)||(type=="1"&&sum>30)||(type=="2"&&sum>90)||(type=="3"&&sum>365))
    {
		alert('<%=SystemEnv.getHtmlLabelName(18819, user.getLanguage())%>');
		return;
    }
	if(type=="0"){
		$("input[name=dateSum]").val(sumweek);
	}
    obj.disabled=true;
    flowPlanForm.submit();
}

function changeset(obj){
   if(obj.value==4){
	  hideEle("dateTypeShow");
	  hideEle("weekTypeShow");   
   }else if(obj.value==0){
	  hideEle("dateTypeShow");
	  showEle("weekTypeShow");
   }
   else{
	  showEle("dateTypeShow");
	  hideEle("weekTypeShow"); 
   }
}
</script>
<%}%>
</body>
</html>
