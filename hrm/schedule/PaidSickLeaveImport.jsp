
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.hrm.attendance.domain.HrmLeaveTypeColor"%>
<!-- modified by wcd 2014-08-06 [E7 to E8] -->
<%@ include file="/hrm/header.jsp" %>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="JobActivitiesComInfo" class="weaver.hrm.job.JobActivitiesComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session"/>
<jsp:useBean id="colorManager" class="weaver.hrm.attendance.manager.HrmLeaveTypeColorManager" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("PaidSickLeave:All", user)){
    response.sendRedirect("/notice/noright.jsp");
    return;
}

String leavetype = Util.null2String(request.getParameter("leavetype"));
int subcompanyid=Util.getIntValue(request.getParameter("subCompanyId"));//分部
int departmentid = Util.getIntValue(request.getParameter("departmentid"));//部门

String PSLyear = Util.null2String(request.getParameter("PSLyear"));
Calendar today = Calendar.getInstance() ; 
String currentyear = Util.add0(today.get(Calendar.YEAR),4) ;
String tempyear = currentyear;
if(!PSLyear.equals("")){
   session.setAttribute("PSLyear",PSLyear);
}
if(session.getAttribute("PSLyear")!=null){
   tempyear = session.getAttribute("PSLyear").toString();
}
StringBuffer mapSql = new StringBuffer("[map]").append("ispaidleave:1");
List<HrmLeaveTypeColor> leaveTypes = colorManager.find(mapSql.toString());

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
   sql = "select * from (select id,workcode,lastname,subcompanyid1,departmentid,jobtitle,dsporder from hrmresource where departmentid = " + departmentid + "  and (status = 0 or status = 1 or status = 2 or status = 3) and status != 10) a left join hrmPSLmanagement b on a.id = b.resourceid and PSLyear = '" + tempyear + "' "+(leavetype.length() > 0?(" and leavetype= "+leavetype):"")+"  order by dsporder,lastname,a.id";
}else{
   showname=SubCompanyComInfo.getSubCompanyname(""+subcompanyid)+"<b>("+SystemEnv.getHtmlLabelName(141,user.getLanguage())+")</b>";
   excelname=SubCompanyComInfo.getSubCompanyname(""+subcompanyid);
   sql = "select * from (select id,workcode,lastname,subcompanyid1,departmentid,jobtitle,dsporder from hrmresource where subcompanyid1 = " + subcompanyid + " and (status = 0 or status = 1 or status = 2 or status = 3) and status != 10) a left join hrmPSLmanagement b on a.id = b.resourceid and PSLyear = '" + tempyear + "' "+(leavetype.length() > 0?(" and leavetype= "+leavetype):"")+"  order by dsporder,lastname,a.id";
}
   
mapSql.setLength(0);
mapSql = new StringBuffer("[map]").append("field004:").append(leavetype);
List<HrmLeaveTypeColor> leaveTypeList = colorManager.find(mapSql.toString());
String leaveTypeName = "";
if(leaveTypeList.size() > 0){
	leaveTypeName = leaveTypeList.get(0).getField001();
}
String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(24047,user.getLanguage());
String needfav ="1";
String needhelp ="";

ExcelFile.init() ;
ExcelSheet es = new ExcelSheet();
//ExcelRow title = es.newExcelRow () ;
//title.addStringValue("");
//title.addStringValue(excelname+SystemEnv.getHtmlLabelName(1867,user.getLanguage())+SystemEnv.getHtmlLabelName(21602,user.getLanguage()));

//ExcelRow space = es.newExcelRow () ;

ExcelRow er = es.newExcelRow () ;

    er.addStringValue(SystemEnv.getHtmlLabelName(1867,user.getLanguage())+"ID");
    er.addStringValue(SystemEnv.getHtmlLabelName(1867,user.getLanguage())+SystemEnv.getHtmlLabelName(714,user.getLanguage()));
    er.addStringValue(SystemEnv.getHtmlLabelNames("30523,63",user.getLanguage()));
    er.addStringValue(SystemEnv.getHtmlLabelName(413,user.getLanguage()));
    er.addStringValue(SystemEnv.getHtmlLabelName(141,user.getLanguage()));
    er.addStringValue(SystemEnv.getHtmlLabelName(124,user.getLanguage()));
    er.addStringValue(SystemEnv.getHtmlLabelName(6086,user.getLanguage()));
    er.addStringValue(SystemEnv.getHtmlLabelName(30523,user.getLanguage())+SystemEnv.getHtmlLabelName(445,user.getLanguage()));
    er.addStringValue(SystemEnv.getHtmlLabelNames("30523,496",user.getLanguage()));

    rs.executeSql(sql);

    while(rs.next()){
        String id = rs.getString("id");
        String lastname = rs.getString("lastname");
        String workcode = rs.getString("workcode");
        String tempsubcompanyid = rs.getString("subcompanyid1");
        String tempdepartmentid = rs.getString("departmentid");
        String jobtitle = Util.null2String(rs.getString("jobtitle"));
        String tempPSLdays = Util.null2String(rs.getString("PSLdays"));

    if(departmentid>0){
       if(!tempdepartmentid.equals(departmentid+"")) continue;
    }else{
       if(!tempsubcompanyid.equals(subcompanyid+"")) continue;
    }
    
    if(jobtitle.equals("")) continue;
    
    er = es.newExcelRow () ;

    er.addStringValue(id);
    er.addStringValue(workcode);
    er.addStringValue(leaveTypeName);
    er.addStringValue(lastname);
    er.addStringValue(SubCompanyComInfo.getSubCompanyname(tempsubcompanyid));
    er.addStringValue(DepartmentComInfo.getDepartmentname(tempdepartmentid));
    er.addStringValue(JobTitlesComInfo.getJobTitlesname(jobtitle));
    er.addStringValue(tempyear);
    er.addStringValue(Util.round(Util.getFloatValue(tempPSLdays,0)+"",2));
    
    }
    
   ExcelFile.setFilename(Util.formatMultiLang(excelname, ""+user.getLanguage())+SystemEnv.getHtmlLabelName(1867,user.getLanguage())+tempyear+SystemEnv.getHtmlLabelName(445,user.getLanguage())+SystemEnv.getHtmlLabelName(30523,user.getLanguage())) ;
   ExcelFile.addSheet(Util.formatMultiLang(excelname, ""+user.getLanguage())+SystemEnv.getHtmlLabelName(1867,user.getLanguage())+SystemEnv.getHtmlLabelName(30523,user.getLanguage()),es) ;
%>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<script language=javascript>
				function onSubmit(obj){
				if(document.all("excelfile").value==""){
				   window.Dialog.alert("<%=SystemEnv.getHtmlLabelName(18618,user.getLanguage())%>");
				   return false;
				}
				frmmain.submit();
				obj.disabled = true;
			}
			function goBack(){
				frmmain.action="/hrm/schedule/PSLManagementEdit.jsp?PSLyear=<%=PSLyear%>&subCompanyId=<%=subcompanyid%>&departmentid=<%=departmentid%>&cmd=f";
				frmmain.submit();
			}
		</script>
	</HEAD>
	<BODY>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
			RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:onSubmit(this),_self}" ;
			RCMenuHeight += RCMenuHeightStep;
			RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goBack(),_self} " ;
			RCMenuHeight += RCMenuHeightStep;
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td></td>
				<td class="rightSearchSpan" style="text-align:right;">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(615,user.getLanguage())%>" class="e8_btn_top" onclick="onSubmit(this);">
					<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		<span><font color="red"><%
			String msg1[] = Util.TokenizerString2(Util.null2String(request.getParameter("msg1")),",");
			String msg2[] = Util.TokenizerString2(Util.null2String(request.getParameter("msg2")),",");
			String msg = Util.null2String(request.getParameter("msg"));
			if(msg1.length>0){
			  for(int i=0;i<msg1.length;i++){
				out.println(SystemEnv.getHtmlLabelName(18620,user.getLanguage())+msg1[i]+SystemEnv.getHtmlLabelName(18621,user.getLanguage())+msg2[i]+SystemEnv.getHtmlLabelName(19327,user.getLanguage())+" ");
			  }    
			}
			if(msg.equals("sucess")){
				out.println(SystemEnv.getHtmlLabelName(131571,user.getLanguage()));
			}else if("formatError".equals(msg)){
				out.println(SystemEnv.getHtmlLabelName(31460,user.getLanguage()));
			}
		 %> 
		</font></span>
		<FORM id=frmmain name=frmmain action="PaidSickLeaveImportOperation.jsp" method=post enctype="multipart/form-data">
			<input type="hidden" name="operation" value="import">
			<input type="hidden" name="subCompanyId" value="<%=subcompanyid%>">
			<input type="hidden" name="departmentid" value="<%=departmentid%>">
			<input type="hidden" name="PSLyear" value="<%=PSLyear%>">
			<input type="hidden" name="leavetype" value="<%=leavetype%>">
			<wea:layout type="2col">
				<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
					<wea:item><%=SystemEnv.getHtmlLabelNames("30523,445",user.getLanguage())%></wea:item>
					<wea:item>
						<%=tempyear%>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(16455,user.getLanguage())%></wea:item>
					<wea:item>
						<%=showname%>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelNames("30523,63",user.getLanguage())%></wea:item>
				   <wea:item><%=leaveTypeName%></wea:item>
				</wea:group>
			</wea:layout>
			<wea:layout type="2col">
				<wea:group context='<%=SystemEnv.getHtmlLabelNames("30523,563",user.getLanguage())%>'>
					<wea:item><%=SystemEnv.getHtmlLabelName(16699,user.getLanguage())%></wea:item>
					<wea:item>
						<input class=inputstyle type="file" name="excelfile">
					</wea:item>
				</wea:group>
			</wea:layout>
			<wea:layout type="2col">
				<wea:group context='<%=SystemEnv.getHtmlLabelName(22271,user.getLanguage())%>'>
					<wea:item>
						<table class=viewform>
							<COLGROUP> <COL width="20%"> <COL width="80%"><tbody> 
						   <tr> 
							  <td><%=SystemEnv.getHtmlLabelName(27625,user.getLanguage())%></td>
							  <td><a href='/weaver/weaver.file.ExcelOut'><font color="red"><%=SystemEnv.getHtmlLabelName(22273,user.getLanguage())%></font></a>&nbsp;</td>
							</tr> 
							<TR style="height:2px"><TD class=Line1 colSpan=2></TD></TR> 
							<tr> 
							  <td><%=SystemEnv.getHtmlLabelName(15736,user.getLanguage())%></td>
							  <td>
							   <%=SystemEnv.getHtmlLabelName(22274,user.getLanguage())%><br><br>
							   <%=SystemEnv.getHtmlLabelName(22275,user.getLanguage())%><br><br>
							   <%=SystemEnv.getHtmlLabelName(131603,user.getLanguage())%><br><br>
							   <%=SystemEnv.getHtmlLabelName(131604,user.getLanguage())%>
							  </td>
							</tr> 
							<TR style="height:2px"><TD class=Line1 colSpan=2></TD></TR> 
							</tbody> 
						  </table>
					</wea:item>
				</wea:group>
			</wea:layout>
		</form>
		<iframe id="ExcelOut" name="ExcelOut" border=0 frameborder=no noresize=NORESIZE height="10%" width="10%"></iframe>
	</BODY>
</HTML>
