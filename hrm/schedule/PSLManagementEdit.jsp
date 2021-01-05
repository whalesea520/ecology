
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.hrm.attendance.domain.HrmLeaveTypeColor"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util,weaver.file.*" %>
<%@ page import="java.util.*,weaver.hrm.common.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="JobActivitiesComInfo" class="weaver.hrm.job.JobActivitiesComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session"/>
<jsp:useBean id="colorManager" class="weaver.hrm.attendance.manager.HrmLeaveTypeColorManager" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%
if(!HrmUserVarify.checkUserRight("PaidSickLeave:All", user)){
    response.sendRedirect("/notice/noright.jsp");
    return;
}
String cmd = Util.null2String(request.getParameter("cmd"));
int subcompanyid=Util.getIntValue(request.getParameter("subCompanyId"));//分部
int departmentid = Util.getIntValue(request.getParameter("departmentid"));//部门
String leavetype = Util.null2String(request.getParameter("leavetype"));
int message = Util.getIntValue(request.getParameter("message"),-1);
String PSLyear = Util.null2String(request.getParameter("PSLyear"));
String tempyear = PSLyear;
String showname="";
String sql="";
StringBuffer mapSql = new StringBuffer("[map]").append("ispaidleave:1");
List<HrmLeaveTypeColor> leaveTypes = colorManager.find(mapSql.toString());
if(leaveTypes.size() > 0 && leavetype.length() == 0 ){
	leavetype = ""+leaveTypes.get(0).getField004();
}
if(departmentid>0){
   subcompanyid=Util.getIntValue(DepartmentComInfo.getSubcompanyid1(""+departmentid));
   showname=DepartmentComInfo.getDepartmentname(""+departmentid)+"<b>("+SystemEnv.getHtmlLabelName(124,user.getLanguage())+")</b>";
   sql = "select * from (select id,lastname,subcompanyid1,departmentid,jobtitle,dsporder,startdate,enddate from hrmresource where departmentid = " + departmentid + "  and (status = 0 or status = 1 or status = 2 or status = 3) and status != 10) a left join hrmPSLmanagement b on a.id = b.resourceid and PSLyear = '" + tempyear + "' "+(leavetype.length() > 0?(" and leavetype= "+leavetype):"")+" order by dsporder,lastname,a.id";
}else{
   showname=SubCompanyComInfo.getSubCompanyname(""+subcompanyid)+"<b>("+SystemEnv.getHtmlLabelName(141,user.getLanguage())+")</b>";
   sql = "select * from (select id,lastname,subcompanyid1,departmentid,jobtitle,dsporder,startdate,enddate from hrmresource where 1=1 "+((cmd.length()==0||subcompanyid==-1)?"":("and subcompanyid1 = " + subcompanyid))+" and (status = 0 or status = 1 or status = 2 or status = 3) and status != 10) a left join hrmPSLmanagement b on a.id = b.resourceid and PSLyear = '" + tempyear + "' "+(leavetype.length() > 0?(" and leavetype= "+leavetype):"")+" order by dsporder,lastname,a.id";
}
mapSql.setLength(0);
mapSql = new StringBuffer("[map]").append("field004:").append(leavetype);
List<HrmLeaveTypeColor> leaveTypeList = colorManager.find(mapSql.toString());
String leaveTypeName = "";
if(leaveTypeList.size() > 0){
	leaveTypeName = leaveTypeList.get(0).getField001();
}
%>

<%    
String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename =SystemEnv.getHtmlLabelName(131556,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</HEAD>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(this),_self} " ;
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(21611,user.getLanguage())+",javascript:BatchProcess(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(131570,user.getLanguage())+",javascript:onImport(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form id=frmmain name=frmmain method=post action="PSLManagementOperation.jsp">
<input class=inputstyle type="hidden" name="method" value="">
<input class=inputstyle type="hidden" name="cmd" value="<%=cmd%>">
<input type="hidden" name="subCompanyId" value="<%=subcompanyid%>">
<input type="hidden" name="departmentid" value="<%=departmentid%>">
<input type="hidden" name="PSLyear" value="<%=PSLyear%>">
<input type="hidden" name="leavetype" value="<%=leavetype%>">
<input type="hidden" name="operation" value="edit">
<%if(message==12){%>
<span><font color='red'><%=SystemEnv.getHtmlLabelName(24042,user.getLanguage())%></font></span>
<%}%>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<%if(HrmUserVarify.checkUserRight("PaidSickLeave:All", user)){ %>
				<input type=button class="e8_btn_top" onclick="onSave(this);" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>"></input>
				<input type=button class="e8_btn_top" onclick="BatchProcess();" value="<%=SystemEnv.getHtmlLabelName(21611,user.getLanguage())%>"></input>
			<%}%>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<wea:layout type="4col" attributes="{'expandAllGroup':'true'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
	 <wea:item><%=SystemEnv.getHtmlLabelName(30523,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%></wea:item>
   <wea:item><%=PSLyear%></wea:item>
	<wea:item><%=SystemEnv.getHtmlLabelNames("30523,63",user.getLanguage())%></wea:item>
   <wea:item><%=leaveTypeName%></wea:item>
	</wea:group>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(30523,user.getLanguage())+SystemEnv.getHtmlLabelName(87,user.getLanguage())%>' attributes="{'groupOperDisplay':'none'}">
	 <wea:item attributes="{'isTableList':'true'}">
	 	<wea:layout type="table" attributes="{'cols':'5','cws':'20%,20%,20%,20%,20%'}">
	 		<wea:group context="" attributes="{'groupDisplay':'none'}">
		 		<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></wea:item>
		    <wea:item type="thead"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></wea:item>
		    <wea:item type="thead"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></wea:item>
		    <wea:item type="thead"><%=SystemEnv.getHtmlLabelNames("33611,15878",user.getLanguage())%></wea:item>
		    <wea:item type="thead"><%=SystemEnv.getHtmlLabelNames("30523,496",user.getLanguage())%></wea:item>
		    <%
		    RecordSet.executeSql(sql);
		    while(RecordSet.next()){
		        String id = RecordSet.getString("id");
		        String lastname = RecordSet.getString("lastname");
		        String tempsubcompanyid = RecordSet.getString("subcompanyid1");
		        String tempdepartmentid = RecordSet.getString("departmentid");
		        String jobtitle = RecordSet.getString("jobtitle");
				String workStartDate = Tools.vString(RecordSet.getString("startdate"));
				String workyear = "0.0";
				if(Tools.isNotNull(workStartDate)){
					String[] currentDate = Tools.getCurrentDate().split("-");
					//double _wy = Tools.round((double)Tools.compDate(workStartDate, tempyear + "-" + currentDate[1] + "-" + currentDate[2])/(double)365, 1);
					double _wy = Tools.round(Tools.compDate(workStartDate, tempyear + "-" + currentDate[1] + "-" + currentDate[2])/365, 1);
					if(_wy < 0){
						_wy = 0;
					}
					workyear = String.valueOf(_wy);
				}
		        String tempPSLdays = Util.null2String(RecordSet.getString("PSLdays"));
		        String tempPaidleavedays = Util.null2String(RecordSet.getString("paidleavedays"));
		
		    if(departmentid>0){
		       if(!tempdepartmentid.equals(departmentid+"")) continue;
		    }else{
				if(cmd.length()!=0&&subcompanyid!=-1){
					if(!tempsubcompanyid.equals(subcompanyid+"")) continue;
				}
		    }
		   
		    if(jobtitle.equals("")) continue;
		   
		  %>
		     <wea:item><a href=javascript:this.openFullWindowForXtable('/hrm/resource/HrmResource.jsp?id=<%=id%>')><%=lastname%></a></wea:item>
		     <wea:item><a href=javascript:this.openFullWindowForXtable('/hrm/company/HrmDepartment.jsp?subcompanyid=<%=tempsubcompanyid%>')><%=SubCompanyComInfo.getSubCompanyname(tempsubcompanyid)%></a></wea:item>
		     <wea:item><a href=javascript:this.openFullWindowForXtable('/hrm/company/HrmDepartmentDsp.jsp?id=<%=tempdepartmentid%>')><%=DepartmentComInfo.getDepartmentname(tempdepartmentid)%></a></wea:item>
		     <wea:item><%=workyear%></wea:item>
			 <wea:item><input type=text size=4 class=inputstyle name=PSLdays value='<%=Util.round(Util.getFloatValue(tempPSLdays,0)+"",2)%>'>
		     	<input type=hidden size=4 class=inputstyle name=resourceid value="<%=id%>">
		     </wea:item>
		  <%
		    }
		  %>
	 		</wea:group>
	 	</wea:layout>
	 </wea:item>
	</wea:group>
</wea:layout>

</form>
<script language=javascript>
function onSave(obj){
	var PSLdays = document.getElementsByName("PSLdays");
	var patt1=new RegExp("^[0-9].*$");
	for(var i=0;i<PSLdays.length;i++){
		var pSLday = PSLdays[i].value;
		if(!pSLday || pSLday.replace(/(^\s+)|(\s+$)/g,'') == "") continue;
		if(!patt1.test(pSLday)){
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(131712,user.getLanguage())%>");
			return;
		}
	}
	obj.disable=true;
    frmmain.submit();
}
function goBack(){
    frmmain.action="PSLManagementView.jsp?subCompanyId=<%=subcompanyid%>&departmentid=<%=departmentid%>";
    frmmain.submit();
}
function BatchProcess(){
    document.frmmain.operation.value="batchprocess";
    frmmain.submit();
}
function onImport(){
    location="PaidSickLeaveImport.jsp?PSLyear=<%=PSLyear%>&subCompanyId=<%=subcompanyid%>&departmentid=<%=departmentid%>&leavetype=<%=leavetype%>";
}
</script>
</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>
