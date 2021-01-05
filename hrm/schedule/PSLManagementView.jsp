
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.hrm.attendance.domain.HrmLeaveTypeColor"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util,weaver.file.*" %>
<%@ page import="java.util.*,weaver.hrm.common.*" %>
<%@ page import="weaver.hrm.schedule.HrmPaidSickManagement"%>
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

String PSLyear = Util.null2String(request.getParameter("PSLyear"));
Calendar today = Calendar.getInstance() ; 
String currentyear = Util.add0(today.get(Calendar.YEAR),4) ;
String currentdate = Util.add0(today.get(Calendar.YEAR),4) + "-" + Util.add0(today.get(Calendar.MONTH)+1,2) + "-" + Util.add0(today.get(Calendar.DAY_OF_MONTH),2);
String tempyear = currentyear;
if(!PSLyear.equals("")){
   session.setAttribute("annualyear",PSLyear);
}
if(session.getAttribute("annualyear")!=null){
   tempyear = session.getAttribute("annualyear").toString();
}

if(subcompanyid!=-1||departmentid!=0)cmd="f";

StringBuffer mapSql = new StringBuffer("[map]").append("ispaidleave:1");
List<HrmLeaveTypeColor> leaveTypes = colorManager.find(mapSql.toString());

String leaveTypeName = "";
if(leaveTypes.size() > 0 && leavetype.length() == 0 ){
	leavetype = ""+leaveTypes.get(0).getField004();
}
String showname="";
String excelname="";
String sql="";
if(departmentid>0){
   subcompanyid=Util.getIntValue(DepartmentComInfo.getSubcompanyid1(""+departmentid));
   showname=DepartmentComInfo.getDepartmentname(""+departmentid)+"<b>("+SystemEnv.getHtmlLabelName(124,user.getLanguage())+")</b>";
   excelname=DepartmentComInfo.getDepartmentname(""+departmentid);
   sql = "select * from (select workcode,id,lastname,subcompanyid1,departmentid,jobtitle,dsporder,startdate,enddate from hrmresource where departmentid = " + departmentid + "  and (status = 0 or status = 1 or status = 2 or status = 3) and status != 10) a left join hrmPSLmanagement b on a.id = b.resourceid and PSLyear = '" + tempyear + "' "+(leavetype.length() > 0?(" and leavetype= "+leavetype):"")+" order by dsporder,lastname,a.id";
}else{
   showname=SubCompanyComInfo.getSubCompanyname(""+subcompanyid)+"<b>("+SystemEnv.getHtmlLabelName(141,user.getLanguage())+")</b>";
   excelname=SubCompanyComInfo.getSubCompanyname(""+subcompanyid);
   sql = "select * from (select workcode,id,lastname,subcompanyid1,departmentid,jobtitle,dsporder,startdate,enddate from hrmresource where 1=1 "+((cmd.length()==0||subcompanyid==-1)?"":("and subcompanyid1 = " + subcompanyid))+" and (status = 0 or status = 1 or status = 2 or status = 3) and status != 10) a left join hrmPSLmanagement b on a.id = b.resourceid and PSLyear = '" + tempyear + "' "+(leavetype.length() > 0?(" and leavetype= "+leavetype):"")+" order by dsporder,lastname,a.id";
}

String PSLperiod = "";
try{PSLperiod = HrmPaidSickManagement.getPaidSickPeriod(subcompanyid+"",tempyear,leavetype);}catch(Exception e){}
String enddate = Util.TokenizerString2(PSLperiod,"#")[1];
String navName = "";
//if(departmentid!=-1) navName = DepartmentComInfo.getDepartmentName(""+departmentid);
//else if(subcompanyid!=-1) navName = SubCompanyComInfo.getSubCompanyname(""+subcompanyid);

if(departmentid !=-1){
	navName =DepartmentComInfo.getDepartmentName(""+departmentid);
}else if(subcompanyid!=-1){
	if(cmd.length()==0){
		navName =SystemEnv.getHtmlLabelName(131557,user.getLanguage());
	}else{
		navName = SubCompanyComInfo.getSubCompanyname(""+subcompanyid);
	}
	
}
%>

<%    
String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename =SystemEnv.getHtmlLabelName(131557,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script type="text/javascript">
jQuery(document).ready(function(){
<%if(navName.length()>0){%>
 parent.setTabObjName('<%=navName%>')
 <%}%>
});
</script>
</HEAD>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(cmd.length()>0&&HrmUserVarify.checkUserRight("PaidSickLeave:All", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",javascript:onEdit(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
}
if(enddate.compareTo(currentdate)>-1){
RCMenu += "{"+SystemEnv.getHtmlLabelName(17416,user.getLanguage())+"Excel,/weaver/weaver.file.ExcelOut,ExcelOut} " ;
RCMenuHeight += RCMenuHeightStep;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form id=frmmain name=frmmain method=post action="HrmSalaryManageView.jsp">
<input class=inputstyle type="hidden" name="method" value="">
<input class=inputstyle type="hidden" name="cmd" value="<%=cmd%>">
<input type="hidden" name="subCompanyId" value="<%=subcompanyid%>">
<input type="hidden" name="departmentid" value="<%=departmentid%>">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<%if(cmd.length()>0&&HrmUserVarify.checkUserRight("PaidSickLeave:All", user)){ %>
				<input type=button class="e8_btn_top" onclick="onEdit();" value="<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>"></input>
			<%}%>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<wea:layout type="4col" attributes="{'expandAllGroup':'true'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(30523,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%></wea:item>
    <wea:item>
      <select id="PSLyear" name="PSLyear" onchange="changeyear(this)" style="width: 120px;">
      <%//输出的列表为，2005年到当前年加10年，
       int length = Integer.parseInt(currentyear)-2005+10;           
       for(int i=0;i<length;i++){
          String str = "<option value="+(2005+i)+">"+(2005+i)+"</option>";   
          if(2005+i==Integer.parseInt(tempyear)) str="<option value="+(2005+i)+" selected>"+(2005+i)+"</option>";
          out.println(str);
       } 
      %>   
      </select>
    </wea:item>
	<wea:item><%=SystemEnv.getHtmlLabelNames("30523,63",user.getLanguage())%></wea:item>
   	<wea:item>
      <select id="leavetype" name="leavetype" onchange="changeLeaveType(this)" style="width: 120px;">
	      <%
	      //输出带薪假列表
	       for(int i=0;i<leaveTypes.size();i++){
	       	  int field004 = leaveTypes.get(i).getField004();
	       	   if(leavetype.equals(""+field004)){
	       	  	leaveTypeName = leaveTypes.get(i).getField001();
	       	   }
	          String str = "<option value='"+(field004)+"' "+(leavetype.equals(""+field004)?"selected":"")+" >"+(leaveTypes.get(i).getField001())+"</option>";   
	          out.println(str);
	       } 
	      %>   
      </select>
   	</wea:item>
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
		    ExcelFile.init();
		    ExcelSheet es = new ExcelSheet();
		
		    ExcelRow er = es.newExcelRow ();
		
		    er.addStringValue(SystemEnv.getHtmlLabelName(1867,user.getLanguage())+"ID");
		    er.addStringValue(SystemEnv.getHtmlLabelName(1867,user.getLanguage())+SystemEnv.getHtmlLabelName(714,user.getLanguage()));
		    er.addStringValue(SystemEnv.getHtmlLabelNames("30523,63",user.getLanguage()));
		    er.addStringValue(SystemEnv.getHtmlLabelName(413,user.getLanguage()));
		    er.addStringValue(SystemEnv.getHtmlLabelName(141,user.getLanguage()));
		    er.addStringValue(SystemEnv.getHtmlLabelName(124,user.getLanguage()));
		    er.addStringValue(SystemEnv.getHtmlLabelNames("33611,15878",user.getLanguage()));
		    er.addStringValue(SystemEnv.getHtmlLabelName(30523,user.getLanguage())+SystemEnv.getHtmlLabelName(445,user.getLanguage()));
		    er.addStringValue(SystemEnv.getHtmlLabelNames("30523,496",user.getLanguage()));
		    
		    RecordSet.executeSql(sql);
		    while(RecordSet.next()){
		        String workcode = Util.null2String(RecordSet.getString("workcode"));
		        String id = RecordSet.getString("id");
		        String lastname = RecordSet.getString("lastname");
		        String tempsubcompanyid = RecordSet.getString("subcompanyid1");
		        String tempdepartmentid = RecordSet.getString("departmentid");
		        String jobtitle = Util.null2String(RecordSet.getString("jobtitle"));
				String workStartDate = Tools.vString(RecordSet.getString("startdate"));
				String workyear = "0.0";
				if(Tools.isNotNull(workStartDate)){
					String[] currentDate = Tools.getCurrentDate().split("-");
					double _wy = Tools.round(Tools.compDate(workStartDate, tempyear + "-" + currentDate[1] + "-" + currentDate[2])/365, 1);
					if(_wy < 0){
						_wy = 0;
					}
					workyear = String.valueOf(_wy);
				}
				String tempPSLdays = Util.round(Util.null2String(RecordSet.getString("PSLdays")),2);
		        String tempPaidleavedays = Util.null2String(RecordSet.getString("paidleavedays"));
		
		    if(departmentid>0){
		       if(!tempdepartmentid.equals(departmentid+"")) continue;
		    }else{
				if(cmd.length()!=0&&subcompanyid!=-1){
					if(!tempsubcompanyid.equals(subcompanyid+"")) continue;
				}
		    }
		    
		    if(jobtitle.equals("")) continue;
		    
		    er = es.newExcelRow () ;
		
		    er.addStringValue(id);
		    er.addStringValue(workcode);
		    er.addStringValue(leaveTypeName);
		    er.addStringValue(lastname);
		    er.addStringValue(SubCompanyComInfo.getSubCompanyname(tempsubcompanyid));
		    er.addStringValue(DepartmentComInfo.getDepartmentname(tempdepartmentid));
		    er.addStringValue(workyear);
		    er.addStringValue(tempyear);
		    er.addStringValue(Util.getFloatValue(tempPSLdays,0)+"");
		  %>
		     <wea:item><a href=javascript:this.openFullWindowForXtable('/hrm/HrmTab.jsp?_fromURL=HrmResource&id=<%=id%>')><%=lastname%></a></wea:item>
		     <wea:item><a href=javascript:this.openFullWindowForXtable('/hrm/HrmTab.jsp?_fromURL=HrmDepartment&subcompanyid=<%=tempsubcompanyid%>')><%=SubCompanyComInfo.getSubCompanyname(tempsubcompanyid)%></a></wea:item>
		     <wea:item><a href=javascript:this.openFullWindowForXtable('/hrm/HrmTab.jsp?_fromURL=HrmDepartmentDsp&id=<%=tempdepartmentid%>')><%=DepartmentComInfo.getDepartmentname(tempdepartmentid)%></a></wea:item>
		     <wea:item><%=workyear%></wea:item>
		     <wea:item><%=Util.getFloatValue(tempPSLdays,0)%></wea:item>
		  <%
		    }
		   ExcelFile.setFilename(Util.formatMultiLang(excelname, ""+user.getLanguage())+SystemEnv.getHtmlLabelName(1867,user.getLanguage())+tempyear+SystemEnv.getHtmlLabelName(445,user.getLanguage())+SystemEnv.getHtmlLabelName(30523,user.getLanguage())) ;
		   ExcelFile.addSheet(Util.formatMultiLang(excelname, ""+user.getLanguage())+SystemEnv.getHtmlLabelName(1867,user.getLanguage())+SystemEnv.getHtmlLabelName(30523,user.getLanguage()),es) ;
		  %>
			</wea:group>
		</wea:layout>
 </wea:item>
 </wea:group>
 </wea:layout>
</form>

<iframe id="ExcelOut" name="ExcelOut" border=0 frameborder=no noresize=NORESIZE height="10%" width="10%"></iframe>
<script language=javascript>
function onEdit(){
    frmmain.action="PSLManagementEdit.jsp";
    frmmain.submit();
}
function changeyear(){
    frmmain.action="PSLManagementView.jsp";
    frmmain.submit();
}
function changeLeaveType(obj){
    frmmain.action="PSLManagementView.jsp?leavetype="+obj.value;
    frmmain.submit();
}
</script>

</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>
