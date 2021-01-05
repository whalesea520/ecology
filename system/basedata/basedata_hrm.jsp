<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
if(! HrmUserVarify.checkUserRight("SystemSetEdit:Edit", user)) { 
    response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(17688,user.getLanguage()) + ":" +SystemEnv.getHtmlLabelName(179,user.getLanguage());
String needfav ="1";
String needhelp ="";

%>
<%
int pagepos=Util.getIntValue(Util.null2String(request.getParameter("pagepos")),1);
String resourceid=Util.fromScreen(request.getParameter("resourceid"),user.getLanguage());
String resourcename=Util.fromScreen(request.getParameter("resourcename"),user.getLanguage());
String subcompanyid=Util.fromScreen(request.getParameter("subcompanyid"),user.getLanguage());
String departmentid=Util.fromScreen(request.getParameter("departmentid"),user.getLanguage());
String status=Util.fromScreen(request.getParameter("status"),user.getLanguage());
if(status.equals(""))   status="1" ;
if(subcompanyid.equals("0"))    subcompanyid="";
if(departmentid.equals("0"))    departmentid="";

Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                 Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                 Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
%>
<BODY>
    <%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
    <%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{" + "Excel,javascript:exportXSL(),_self} ";
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onSearch(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(364,user.getLanguage())+",javascript:doSearchAgain(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:doBack(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
    <%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

	<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
		<colgroup>
		<col width="10">
		<col width="">
		<col width="10">
	
		<tr>
			<td height="10" colspan="3"></td>
		</tr>
		<tr>
			<td ></td>
			<td valign="top">
			
			<TABLE class="Shadow">
			<tr>
			<td valign="top">
			
<form action="basedata_hrm.jsp" method="post" name="frmmain">
<INPUT type="hidden" name=pagepos value="">
<table class=form>
  <tr>
    <td width="10%"><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></td>
    <td width="15%" class=field>
    <INPUT class=saveHistory type=text name=resourcename style="width:80%" value=<%=resourcename%>>
    </td>
    <td width="10%"><%=SystemEnv.getHtmlLabelName(1851,user.getLanguage())%></td>
    <td width="15%" class=field><BUTTON class=Browser onClick="onShowCompany()"></BUTTON> 
    <span id=companyspan><%=SubCompanyComInfo.getSubCompanyname(subcompanyid)%></span> 
    <INPUT class=saveHistory type=hidden name=subcompanyid value=<%=subcompanyid%>>
    </td>
    <td width="10%"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></td>
    <td width="15%" class=field><BUTTON class=Browser onClick="onShowDepartment()"></BUTTON> 
    <span id=departmentspan><%=DepartmentComInfo.getDepartmentname(departmentid)%></span> 
    <INPUT class=saveHistory type=hidden name=departmentid value=<%=departmentid%>>
    </td>
    <td width="10%"><%=SystemEnv.getHtmlLabelName(169,user.getLanguage())%></td>
    <td width="15%" class=field>
    <select name="status" size="1">
        <option <%if(status.equals("0")){%> selected <%}%> value="0"><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
        <option <%if(status.equals("1")){%> selected <%}%> value="1"><%=SystemEnv.getHtmlLabelName(155,user.getLanguage())%></option>
        <option <%if(status.equals("2")){%> selected <%}%> value="2"><%=SystemEnv.getHtmlLabelName(415,user.getLanguage())%></option>
    </select>
    </td>
  </tr>
</table>
</form>
<script language=vbs>
sub onShowCompany()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?selectedids="&frmmain.subcompanyid.value)
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	companyspan.innerHtml = id(1)
	frmmain.subcompanyid.value=id(0)
	else 
	companyspan.innerHtml = ""
	frmmain.subcompanyid.value=""
	end if
	end if
end sub
sub onShowDepartment()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="&frmmain.departmentid.value)
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	departmentspan.innerHtml = id(1)
	frmmain.departmentid.value=id(0)
	else 
	departmentspan.innerHtml = ""
	frmmain.departmentid.value=""
	end if
	end if
end sub
</script>

<br>
<TABLE class=ListStyle cellspacing=1>

  <COLGROUP>
  <COL width="15%"><COL width="20%"><COL width="20%"><COL width="15%"><COL width="15%"><COL width="15%">
  <TBODY>
  <TR class=separator>
    <TD class=Sep1 colSpan=6 ></TD></TR>
  <TR class=Header >
    <TH colspan="9"><%=SystemEnv.getHtmlLabelName(15065,user.getLanguage())%></TH>
  </TR>

  <TR class=Header>
    <TD ><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></TD>
	<TD><%=SystemEnv.getHtmlLabelName(1851,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(596,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></TD>
  </TR>
  <TR class=Header>
    <TD><%=SystemEnv.getHtmlLabelName(421,user.getLanguage())%></TD>
	<TD><%=SystemEnv.getHtmlLabelName(6005,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(494,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(422,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(420,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(477,user.getLanguage())%></TD>
  </TR>
    <TR class=Line><TD colspan="6" ></TD></TR>
<%
int countsize = 0;
int pagesizes = 0;
int currentpagestart = 0;
int currentpageend = 0;
boolean islight=true ;
String sql = "";
String sqlWhere = "";
if(!resourceid.equals(""))
	sqlWhere+= " and id ="+resourceid ;
if(!resourcename.equals(""))
	sqlWhere+= " and lastname like '%"+Util.fromScreen2(resourcename,7)+"%'" ;
if(!subcompanyid.equals(""))
	sqlWhere+= " and subcompanyid1="+subcompanyid ;
if(!departmentid.equals(""))
	sqlWhere+= " and departmentid="+departmentid ;
if(!status.equals("0")){
    if(status.equals("1")) 
    	sqlWhere += " and (( startdate='' and enddate= '') or (startdate<='"+currentdate+"' and enddate>='"+currentdate+"') or (startdate='' and enddate>='"+currentdate+"') or ( startdate<='"+currentdate+"' and enddate='')) ";
    if(status.equals("2")) 
    	sqlWhere += " and ((startdate != '' and startdate>'"+currentdate+"') or (enddate != '' and enddate<'"+currentdate+"'))";
}

sql = "select count(*) from hrmresource where id<>1 "+sqlWhere;
RecordSet.executeSql(sql);
if(RecordSet.next())
{
	countsize = RecordSet.getInt(1);
}
pagesizes = countsize%30==0?countsize/30:(countsize/30+1);
if(pagepos<=0)
{
	pagepos = 1;
}
if(pagepos>=pagesizes)
{
	pagepos = pagesizes;
}
currentpagestart = (pagepos-1)*30<0?0:(pagepos-1)*30;
currentpageend = (pagepos*30>countsize)?countsize:pagepos*30;
int currentpagesize = currentpageend-currentpagestart;

if(RecordSet.getDBType().equals("oracle"))
{
	sql = " select * from hrmresource where id<>1 "+sqlWhere;
	sql+=" order by dsporder,id ";
	sql = "select * "+
		  "	  from (select rownum as rowno, r.* "+
		  "	          from ("+sql+") r) c "+
		  "	 where c.rowno <= "+currentpageend+
		  "	   and c.rowno > "+currentpagestart;
		  
}
else
{
	sql = " select top "+currentpageend+" * from hrmresource where id<>1 "+sqlWhere;
	sql+=" order by dsporder,id ";
	sql = "select top "+currentpagesize+" c.* "+
	  "	  from (select top "+currentpagesize+" r.* "+
	  "	          from ("+sql+") r order by dsporder desc,id desc ) c "+
	  "	  order by dsporder asc,id asc";
}
//out.println(sql);
RecordSet.executeSql(sql);

while(RecordSet.next()){
    String tmpid=RecordSet.getString("id") ;
    String rolename="";
    String tmpsql="select t1.* from hrmroles t1,hrmrolemembers t2 where t1.id=t2.roleid and t2.resourceid="+tmpid ;
    rs.executeSql(tmpsql) ;
    while(rs.next()){
        String tmproleid=rs.getString("id");
        rolename+=",<a href='basedata_role.jsp?roleid="+tmproleid+"'>"+rs.getString("rolesname")+"</a>";
    }
    if(!rolename.equals(""))    rolename=rolename.substring(1);
%>
  <tr class=datalight> 
    <TD><b><a href="/hrm/resource/HrmResource.jsp?id=<%=tmpid%>"><%=RecordSet.getString("lastname")%></a></b>&nbsp;</TD>
    <TD><%=SubCompanyComInfo.getSubCompanyname(RecordSet.getString("subcompanyid1"))%>&nbsp;</TD>
    <TD><%=DepartmentComInfo.getDepartmentname(RecordSet.getString("departmentid"))%>&nbsp;</TD>
    <TD><%=ResourceComInfo.getResourcename(RecordSet.getString("managerid"))%>&nbsp;</TD>
    <TD><%=RecordSet.getString("seclevel")%>&nbsp;</TD>
    <TD><%=rolename%>&nbsp;</TD>
  </TR>
  <tr class=datadark> 
    <TD><%=RecordSet.getString("telephone")%>&nbsp;</TD>
    <TD><%=RecordSet.getString("extphone")%>&nbsp;</TD>
    <TD><%=RecordSet.getString("mobilecall")%>&nbsp;</TD>
    <TD><%=RecordSet.getString("mobile")%>&nbsp;</TD>
    <TD><%=RecordSet.getString("workroom")%>&nbsp;</TD>
    <TD><%=RecordSet.getString("email")%>&nbsp;</TD>
  </TR>
<%
     
    }
%>  
    </tbody>
    </table>

			
			</td>
			</tr>
			<TR class=separator><TD class=Sep1 colSpan=14 ></TD></TR>
			<TR>
				<TD colspan="14">
					<DIV class=xTable_info>
					<DIV>
						<TABLE width="100%">
							<TBODY>
								<TR>
									<TD></TD>
									<TD>
										<DIV align=right>
											<input id=currentpage name=currentpage type="hidden" value="<%=pagepos %>">
											<%=SystemEnv.getHtmlLabelName(18609,user.getLanguage())%><!-- 共 --><%=countsize%><%=SystemEnv.getHtmlLabelName(18256,user.getLanguage())%><!-- 条 --><%=SystemEnv.getHtmlLabelName(264,user.getLanguage())%><!-- 记录 -->
											&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(265,user.getLanguage())%><!-- 每页 -->30<%=SystemEnv.getHtmlLabelName(18256,user.getLanguage())%><!-- 条 -->
											&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(18609,user.getLanguage())%><!-- 共 --><%=pagesizes %><%=SystemEnv.getHtmlLabelName(23161,user.getLanguage())%><!-- 页 -->
											&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(524,user.getLanguage())%><!-- 当前 --><%=SystemEnv.getHtmlLabelName(15323,user.getLanguage())%><!-- 第 --><%=pagepos %><%=SystemEnv.getHtmlLabelName(23161,user.getLanguage())%><!-- 页 -->&nbsp;&nbsp;
											<A style="CURSOR: hand; TEXT-DECORATION: none"
												id=pagenext onclick="goToPage('f')"><SPAN><%=SystemEnv.getHtmlLabelName(18363,user.getLanguage())%><!-- 首页 --></SPAN>
											</A>
											<A style="CURSOR: hand; TEXT-DECORATION: none"
												id=pagenext onclick="goToPage('u')"><SPAN><%=SystemEnv.getHtmlLabelName(1258,user.getLanguage())%><!-- 上一页 --></SPAN>
											</A>
											<A style="CURSOR: hand; TEXT-DECORATION: none"
												id=pagenext onclick="goToPage('d')"><SPAN><%=SystemEnv.getHtmlLabelName(1259,user.getLanguage())%><!-- 下一页 --></SPAN>
											</A>
											<A style="CURSOR: hand; TEXT-DECORATION: none" id=pagelast onclick="goToPage('l')"><SPAN><%=SystemEnv.getHtmlLabelName(18362,user.getLanguage())%><!-- 尾页 --></SPAN>
											</A>&nbsp;
											<BUTTON id=goPageBotton onclick="goPage()">
												<%=SystemEnv.getHtmlLabelName(23162,user.getLanguage())%><!-- 转到 -->
											</BUTTON>
											&nbsp;<%=SystemEnv.getHtmlLabelName(15323,user.getLanguage())%><!-- 第 --><INPUT style="TEXT-ALIGN: right" id=gopage name=gopage class=text value=<%=pagepos %> size=2><%=SystemEnv.getHtmlLabelName(23161,user.getLanguage())%><!-- 页 -->
										</DIV>
									</TD>
								</TR>
							</TBODY>
						</TABLE>
					</DIV>
				</DIV>
				</TD>
			</TR>
			</TABLE>
			
			</td>
			<td></td>
		</tr>
		<tr>
			<td height="10" colspan="3"></td>
		</tr>
	</table>
	<iframe id="iframeExcel" style="display: none"></iframe>
<SCRIPT language=javascript>
function onSearch(){
	frmmain.submit();
}
function goToPage(forward)
{
	var currentpage = document.getElementById("currentpage").value;
	var actionpage = "";
	if(forward=="f")
	{
		actionpage = 1;
	}
	else if(forward=="u")
	{
		actionpage = currentpage*1-1;
	}
	else if(forward=="d")
	{
		actionpage = currentpage*1+1;
	}
	else if(forward=="l")
	{
		actionpage = '<%=pagesizes %>';
	}
	document.frmmain.pagepos.value=actionpage;
	frmmain.submit();
}
function goPage()
{
	var gopage = document.getElementById("gopage").value;
	if(gopage=="")
	{
		gopage = "1";
	}
	document.frmmain.pagepos.value=gopage;
	frmmain.submit();
}
function exportXSL()
{
	document.getElementById("iframeExcel").src = "/system/basedata/basedata_hrmexcel.jsp?pagepos=<%=pagepos%>&resourceid=<%=resourceid%>&resourcename=<%=resourcename%>&subcompanyid=<%=subcompanyid%>&departmentid=<%=departmentid%>&status=<%=status%>";
}
function doSearchAgain()
{
	document.location.href = "basedata_hrm.jsp";
}
function doBack()
{
	document.location.href = "basedata.jsp";
}
</SCRIPT>
</BODY></HTML>
