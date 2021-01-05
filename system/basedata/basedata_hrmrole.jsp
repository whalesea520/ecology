<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
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
String titlename = SystemEnv.getHtmlLabelName(17688,user.getLanguage()) + ":" +SystemEnv.getHtmlLabelName(15053,user.getLanguage());

String needfav ="1";
String needhelp ="";

%>
<%
int pagepos=Util.getIntValue(Util.null2String(request.getParameter("pagepos")),1);
String resourceid=Util.fromScreen(request.getParameter("resourceid"),user.getLanguage());
String roleid=Util.fromScreen(request.getParameter("roleid"),user.getLanguage());
String rolesmark=Util.fromScreen(request.getParameter("rolesmark"),user.getLanguage());
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

	<table width=100% height=90% border="0" cellspacing="0" cellpadding="0">
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
			
<form action="basedata_hrmrole.jsp" method="post" name="frmmain">
<INPUT type="hidden" name=pagepos value="">

<wea:layout type="4col" attributes="{'expandAllGroup':'true'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>' attributes="{'isColspan':'false'}">
	<wea:item><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></wea:item>
	<wea:item>
		<brow:browser viewType="0"  name="resourceid" browserValue='<%=resourceid %>'
					  browserOnClick=""
					  browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?selectedids="
					  hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1' linkUrl="javascript:openhrm($id$)"
					  completeUrl="/data.jsp" width="165px"
					  browserSpanValue='<%=Util.toScreen(ResourceComInfo.getResourcename(resourceid),user.getLanguage())%>'></brow:browser>
	</wea:item>
	<wea:item><%=SystemEnv.getHtmlLabelName(15068,user.getLanguage())%></wea:item>
	<wea:item>
		<INPUT class=saveHistory type=text name=rolesmark value=<%=rolesmark%>>
	</wea:item>
	</wea:group>
</wea:layout>

<%--<table class=form>--%>
  <%--<tr>--%>

    <%--<td width="15%"><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></td>--%>
    <%--<td width="35%" class=field><BUTTON class=Browser onClick="onShowResource()"></BUTTON>--%>
    <%--<span id=resourcespan><%=ResourceComInfo.getResourcename(resourceid)%></span> --%>
    <%--<INPUT class=saveHistory type=hidden name=resourceid value=<%=resourceid%>>--%>
    <%--</td>--%>
    <%--<td width="15%"><%=SystemEnv.getHtmlLabelName(15068,user.getLanguage())%></td>--%>
    <%--<td width="35%" class=field>--%>
    <%--<INPUT class=saveHistory type=text name=rolesmark value=<%=rolesmark%>>--%>
    <%--<BUTTON class=Browser onClick="onShowRole()"></BUTTON> 
    <span id=rolespan><%=RolesComInfo.getRolesname(roleid)%></span> 
    <INPUT class=saveHistory type=hidden name=roleid value=<%=roleid%>>--%>
    <%--</td>--%>
  <%--</tr>--%>
<%--</table>--%>
</form>
<script language=vbs>
sub onShowResource()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	resourcespan.innerHtml = id(1)
	frmmain.resourceid.value=id(0)
	else 
	resourcespan.innerHtml = ""
	frmmain.resourceid.value=""
	end if
	end if
end sub
sub onShowRole()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	rolespan.innerHtml = id(1)
	frmmain.roleid.value=id(0)
	else 
	rolespan.innerHtml = ""
	frmmain.roleid.value=""
	end if
	end if
end sub
</script>

<br>
<TABLE class=ListStyle cellspacing=1>

  <COLGROUP>
  <COL width="20%"><COL width="20%"><COL width="30%"><COL width="20%">
  <TBODY>
  <TR class=Header >
    <TH colspan="3"><%=SystemEnv.getHtmlLabelName(15066,user.getLanguage())%></TH>
  </TR>
  <TR class=separator>
    <TD class=Sep1 colSpan=3></TD></TR>
  <TR class=Header>
    <TD><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></TD>
	<TD><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%></TD>
  </TR>
    <TR class=Line><TD colspan="3" ></TD></TR>
<%
int countsize = 0;
int pagesizes = 0;
int currentpagestart = 0;
int currentpageend = 0;
boolean islight=true ;
String sql = "";
String sqlWhere = "";
if(!resourceid.equals(""))  sqlWhere+=" and t1.id="+resourceid;
if(!roleid.equals(""))  sqlWhere+=" and t2.id="+roleid;
if(!rolesmark.equals("")){
	sqlWhere+=" and t2.rolesmark like '%"+Util.fromScreen2(rolesmark,7)+"%'";
}
sql = "select count(*) "+
		"from hrmresource t1,hrmroles t2,hrmrolemembers t3,workflow_groupdetail t4,"+
		"workflow_nodegroup t5,workflow_nodebase t6,workflow_flownode t7,workflow_base t8 "+
		"where t1.id=t3.resourceid and t2.id=t3.roleid and t3.roleid=t4.objid and "+
		"t4.type=2 and t4.groupid=t5.id and (t6.IsFreeNode is null or t6.IsFreeNode!='1') and t5.nodeid=t6.id "+
		"and t5.nodeid= t7.nodeid and t7.workflowid=t8.id and t8.isvalid='1'"+sqlWhere;
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
	sql = "select t1.id,t1.lastname,t2.rolesmark,t3.rolelevel,t3.roleid,t7.workflowid,t6.nodename "+
			"from hrmresource t1,hrmroles t2,hrmrolemembers t3,workflow_groupdetail t4,"+
			"workflow_nodegroup t5,workflow_nodebase t6,workflow_flownode t7,workflow_base t8 "+
			"where t1.id=t3.resourceid and t2.id=t3.roleid and t3.roleid=t4.objid and "+
			"t4.type=2 and t4.groupid=t5.id and (t6.IsFreeNode is null or t6.IsFreeNode!='1') and t5.nodeid=t6.id "+
			"and t5.nodeid= t7.nodeid and t7.workflowid=t8.id and t8.isvalid='1'"+sqlWhere;
	sql+=" order by t1.dsporder,t2.id,t7.workflowid,t6.id ";
	sql = "select * "+
		  "	  from (select rownum as rowno, r.* "+
		  "	          from ("+sql+") r) c "+
		  "	 where c.rowno <= "+currentpageend+
		  "	   and c.rowno > "+currentpagestart;
		  
}
else
{
	sql = "select top "+currentpageend+" t1.id as id,t1.dsporder,t1.lastname,t2.id as t2id ,t2.rolesmark,t3.rolelevel,t3.roleid,t7.workflowid,t6.id as t6id,t6.nodename "+
			"from hrmresource t1,hrmroles t2,hrmrolemembers t3,workflow_groupdetail t4,"+
			"workflow_nodegroup t5,workflow_nodebase t6,workflow_flownode t7,workflow_base t8 "+
			"where t1.id=t3.resourceid and t2.id=t3.roleid and t3.roleid=t4.objid and "+
			"t4.type=2 and t4.groupid=t5.id and (t6.IsFreeNode is null or t6.IsFreeNode!='1') and t5.nodeid=t6.id "+
			"and t5.nodeid= t7.nodeid and t7.workflowid=t8.id and t8.isvalid='1'"+sqlWhere;
	sql+=" order by t1.dsporder,t2.id,t7.workflowid,t6.id ";
	sql = "select top "+currentpagesize+" c.* "+
	  "	  from (select top "+currentpagesize+" r.* "+
	  "	          from ("+sql+") r order by r.dsporder desc,r.t2id desc,r.workflowid desc,r.t6id desc ) c "+
	  "	  order by c.dsporder asc,c.t2id asc,c.workflowid asc,c.t6id asc";
}
//out.println(sql);

RecordSet.executeSql(sql);
while(RecordSet.next()){
    String tmpresourceid=RecordSet.getString("id") ;
    String lastname=RecordSet.getString("lastname") ;
    String rolesname=RecordSet.getString("rolesmark");
    String tmproleid=RecordSet.getString("roleid");
    String rolelevel=RecordSet.getString("rolelevel");
    String workflowid=RecordSet.getString("workflowid");
    String nodename=RecordSet.getString("nodename");
%>
  <tr <%if(islight){%>class=datalight <%} else {%> class=datadark <%}%>> 
    <TD><a href="basedata_hrm.jsp?resourceid=<%=tmpresourceid%>"><%=lastname%></a>&nbsp;</TD>
    <td><a href="basedata_role.jsp?roleid=<%=tmproleid%>"><%=rolesname%></a> ( <%if(rolelevel.equals("0")){%><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%> <%}%><%if(rolelevel.equals("1")){%><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%> <%}%><%if(rolelevel.equals("2")){%><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%> <%}%>)&nbsp;</td>
    <TD><a href="basedata_workflow.jsp?wfid=<%=workflowid%>"><%=WorkflowComInfo.getWorkflowname(workflowid)%></a>&nbsp;</TD>
  </TR>
<%
        islight=!islight ;
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
	document.getElementById("iframeExcel").src = "/system/basedata/basedata_hrmroleexcel.jsp?pagepos=<%=pagepos%>&resourceid=<%=resourceid%>&roleid=<%=roleid%>&rolesmark=<%=rolesmark%>";
}
function doSearchAgain()
{
	document.location.href = "basedata_hrmrole.jsp";
}
function doBack()
{
	document.location.href = "basedata.jsp";
}
</SCRIPT>

</BODY></HTML>
