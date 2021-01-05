
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!-- modified by wcd 2014-08-06 [E7 to E8] -->
<%@ include file="/hrm/header.jsp" %>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="JobActivitiesComInfo" class="weaver.hrm.job.JobActivitiesComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session"/>
<%
if(!HrmUserVarify.checkUserRight("AnnualLeave:All", user)){
    response.sendRedirect("/notice/noright.jsp");
    return;
}

int subcompanyid=Util.getIntValue(request.getParameter("subCompanyId"));//分部
int departmentid = Util.getIntValue(request.getParameter("departmentid"));//部门

String annualyear = Util.null2String(request.getParameter("annualyear"));
Calendar today = Calendar.getInstance() ; 
String currentyear = Util.add0(today.get(Calendar.YEAR),4) ;
String tempyear = currentyear;
if(!annualyear.equals("")){
   session.setAttribute("annualyear",annualyear);
}
if(session.getAttribute("annualyear")!=null){
   tempyear = session.getAttribute("annualyear").toString();
}

String showname="";
String excelname="";
String sql="";
if(departmentid>0){
   subcompanyid=Util.getIntValue(DepartmentComInfo.getSubcompanyid1(""+departmentid));
   showname=DepartmentComInfo.getDepartmentname(""+departmentid)+"<b>("+SystemEnv.getHtmlLabelName(124,user.getLanguage())+")</b>";
   excelname=DepartmentComInfo.getDepartmentname(""+departmentid);
   sql = "select * from (select id,workcode,lastname,subcompanyid1,departmentid,jobtitle,dsporder from hrmresource where departmentid = " + departmentid + "  and (status = 0 or status = 1 or status = 2 or status = 3) and status != 10) a left join hrmannualmanagement b on a.id = b.resourceid and annualyear = '" + tempyear + "' and b.status <> 0 order by dsporder,lastname,a.id";
}else{
   showname=SubCompanyComInfo.getSubCompanyname(""+subcompanyid)+"<b>("+SystemEnv.getHtmlLabelName(141,user.getLanguage())+")</b>";
   excelname=SubCompanyComInfo.getSubCompanyname(""+subcompanyid);
   sql = "select * from (select id,workcode,lastname,subcompanyid1,departmentid,jobtitle,dsporder from hrmresource where subcompanyid1 = " + subcompanyid + " and (status = 0 or status = 1 or status = 2 or status = 3) and status != 10) a left join hrmannualmanagement b on a.id = b.resourceid and annualyear = '" + tempyear + "' and b.status <> 0 order by dsporder,lastname,a.id";
}

String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(21602,user.getLanguage()) + SystemEnv.getHtmlLabelName(18596,user.getLanguage());
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
    er.addStringValue(SystemEnv.getHtmlLabelName(413,user.getLanguage()));
    er.addStringValue(SystemEnv.getHtmlLabelName(141,user.getLanguage()));
    er.addStringValue(SystemEnv.getHtmlLabelName(124,user.getLanguage()));
    er.addStringValue(SystemEnv.getHtmlLabelName(6086,user.getLanguage()));
    er.addStringValue(SystemEnv.getHtmlLabelName(21602,user.getLanguage())+SystemEnv.getHtmlLabelName(445,user.getLanguage()));
    er.addStringValue(SystemEnv.getHtmlLabelName(19517,user.getLanguage()));

    rs.executeSql(sql);

    while(rs.next()){
        String id = rs.getString("id");
        String workcode = rs.getString("workcode");
        String lastname = rs.getString("lastname");
        String tempsubcompanyid = rs.getString("subcompanyid1");
        String tempdepartmentid = rs.getString("departmentid");
        String jobtitle = Util.null2String(rs.getString("jobtitle"));
        String tempannualdays = Util.null2String(rs.getString("annualdays"));

    if(departmentid>0){
       if(!tempdepartmentid.equals(departmentid+"")) continue;
    }else{
       if(!tempsubcompanyid.equals(subcompanyid+"")) continue;
    }
    
    if(jobtitle.equals("")) continue;
    
    er = es.newExcelRow () ;

    er.addStringValue(id);
    er.addStringValue(workcode);
    er.addStringValue(lastname);
    er.addStringValue(SubCompanyComInfo.getSubCompanyname(tempsubcompanyid));
    er.addStringValue(DepartmentComInfo.getDepartmentname(tempdepartmentid));
    er.addStringValue(JobTitlesComInfo.getJobTitlesname(jobtitle));
    er.addStringValue(tempyear);
    er.addStringValue(Util.round(Util.getFloatValue(tempannualdays,0)+"",2));
    
    }
    
   ExcelFile.setFilename(Util.formatMultiLang(excelname, ""+user.getLanguage())+SystemEnv.getHtmlLabelName(1867,user.getLanguage())+tempyear+SystemEnv.getHtmlLabelName(445,user.getLanguage())+SystemEnv.getHtmlLabelName(21602,user.getLanguage())) ;
  //如果sheet的名字超过31会报错，直接用getByteNumString把sheet名字截断
   ExcelFile.addSheet(Util.getByteNumString(Util.formatMultiLang(excelname, ""+user.getLanguage())+SystemEnv.getHtmlLabelName(1867,user.getLanguage())+SystemEnv.getHtmlLabelName(21602,user.getLanguage()),30),es) ;
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
				frmmain.action="AnnualManagementEdit.jsp?annualyear=<%=annualyear%>&subCompanyId=<%=subcompanyid%>&departmentid=<%=departmentid%>&cmd=f";
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
				out.println(SystemEnv.getHtmlLabelName(21620,user.getLanguage()));
			}else if("formatError".equals(msg)){
				out.println(SystemEnv.getHtmlLabelName(31460,user.getLanguage()));
			}
		 %> 
		</font></span>
		<FORM id=frmmain name=frmmain action="AnnualManagementImportOperation.jsp" method=post enctype="multipart/form-data">
			<input type="hidden" name="operation" value="import">
			<input type="hidden" name="subCompanyId" value="<%=subcompanyid%>">
			<input type="hidden" name="departmentid" value="<%=departmentid%>">
			<input type="hidden" name="annualyear" value="<%=annualyear%>">
			<wea:layout type="2col">
				<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
					<wea:item><%=SystemEnv.getHtmlLabelNames("21602,445",user.getLanguage())%></wea:item>
					<wea:item>
						<%=tempyear%>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(16455,user.getLanguage())%></wea:item>
					<wea:item>
						<%=showname%>
					</wea:item>
				</wea:group>
			</wea:layout>
			<wea:layout type="2col">
				<wea:group context='<%=SystemEnv.getHtmlLabelNames("21602,563",user.getLanguage())%>'>
					<wea:item><%=SystemEnv.getHtmlLabelName(16699,user.getLanguage())%></wea:item>
					<wea:item>
						<input class=inputstyle type="file" id="excelfile" name="excelfile">
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
							   <%=SystemEnv.getHtmlLabelName(83025,user.getLanguage())%><br><br>
							   <%=SystemEnv.getHtmlLabelName(83026,user.getLanguage())%><br><br>
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
