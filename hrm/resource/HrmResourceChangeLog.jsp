
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="BankComInfo" class="weaver.hrm.finance.BankComInfo" scope= "page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="SalaryComInfo" class="weaver.hrm.finance.SalaryComInfo" scope="page" />
<jsp:useBean id="HrmListValidate" class="weaver.hrm.resource.HrmListValidate" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<HTML>
<%
//added by hubo,20060113
 String id = Util.null2String(request.getParameter("id"));
if(id.equals("")) id=String.valueOf(user.getUID());

 int hrmid = user.getUID();
 int isView = Util.getIntValue(request.getParameter("isView"));
 boolean isfromtab =  Util.null2String(request.getParameter("isfromtab")).equals("true")?true:false;
 int departmentid = user.getUserDepartment();
 boolean ishe = (hrmid == Util.getIntValue(id));
 boolean ishr = (HrmUserVarify.checkUserRight("HrmResourceEdit:Edit",user,departmentid));
 boolean ishasF =HrmUserVarify.checkUserRight("HrmResourceWelfareEdit:Edit",user);
 //if(!ishe&&!ishr ){
 if(!ishe&&!ishasF ){
    response.sendRedirect("/notice/noright.jsp") ;
    return;
}
%>
<HEAD>
  <LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(367,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(19599,user.getLanguage());
String needfav ="1";
String needhelp ="";

%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<FORM name=resourcefinanceinfo id=resource action="HrmResourceOperation.jsp" method=post enctype="multipart/form-data">
<%
boolean show = false;
if(isfromtab){
	if(HrmListValidate.isValidate(63))show= true;
}else{
	show = true;
}
if(show){%>
<TABLE class=ListStyle cellspacing=1 >
  <COLGROUP>
  <TBODY>
  <TR class="HeaderForXtalbe intervalTR">
  <th><%=SystemEnv.getHtmlLabelName(15819,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(15820,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(19603,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(15821,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(15822,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(19604,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(1897,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(15823,user.getLanguage())%></th>
  </tr>

<%
    rs.executeSql("select * from HrmSalaryChange where multresourceid like '%," + id +",%' order by id desc");
    boolean isLight = false;
	while(rs.next())
	{
        String itemid = Util.null2String(rs.getString("itemid")) ;
        String changedate = Util.null2String(rs.getString("changedate")) ;
        String changetype = Util.null2String(rs.getString("changetype")) ;
        String salary = Util.null2String(rs.getString("salary")) ;
        String changeresion = Util.toScreen(rs.getString("changeresion"),user.getLanguage()) ;
        String changeuser = Util.null2String(rs.getString("changeuser")) ;
        String oldsalary = Util.null2String(rs.getString("oldvalue")) ;
        String newsalary = Util.null2String(rs.getString("newvalue")) ;
		if(isLight = !isLight)
		{%>
	<TR CLASS=DataLight>
<%		}else{%>
	<TR CLASS=DataDark>
<%		}%>
        <TD><%=Util.toScreen(SalaryComInfo.getSalaryname(itemid),user.getLanguage())%></TD>
        <TD><%=changedate%></TD>
        <TD align=right><%=oldsalary%></TD>
        <TD>
            <%if(changetype.equals("1")){%><%=SystemEnv.getHtmlLabelName(456,user.getLanguage())%>
            <%} else if(changetype.equals("2")){%><%=SystemEnv.getHtmlLabelName(457,user.getLanguage())%>
            <%} else if(changetype.equals("3")){%><%=SystemEnv.getHtmlLabelName(15816,user.getLanguage())%><%}%>
        </TD>
		<TD align=right><%=salary%></TD>
        <TD align=right><%=newsalary%></TD>
           <TD><%=changeresion%></TD>
        <TD><%=Util.toScreen(ResourceComInfo.getResourcename(changeuser),user.getLanguage())%></TD>
	</TR>
<%
	}
%>
 </TABLE>
<%}%>

<script language=javascript>
  function goBack(){
      location = "/hrm/resource/HrmResourceFinanceView.jsp?isfromtab=<%=isfromtab%>&isView=<%=isView%>";
  }
</script>
</BODY>
</HTML>