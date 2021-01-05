<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page"/>
<%@ page import="weaver.systeminfo.role.StructureRightHandler,weaver.systeminfo.role.StructureRightInfo"%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
if(! HrmUserVarify.checkUserRight("SystemSetEdit:Edit", user)) { 
    response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(17688,user.getLanguage()) + ":" +SystemEnv.getHtmlLabelName(15052,user.getLanguage());

String needfav ="1";
String needhelp ="";

%>
<%
rs.executeSql("select detachable from SystemSet");
int detachable=0;
if(rs.next()){
    detachable=Util.getIntValue(rs.getString("detachable"),0);
    session.setAttribute("detachable",String.valueOf(detachable));
}

int pagepos=Util.getIntValue(Util.null2String(request.getParameter("pagepos")),1);
String resourceid=Util.fromScreen(request.getParameter("resourceid"),user.getLanguage());
String roleid=Util.fromScreen(request.getParameter("roleid"),user.getLanguage());
String lastname=Util.fromScreen(request.getParameter("lastname"),user.getLanguage());
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
			
<form action="basedata_role.jsp" method="post" name="frmmain">
<INPUT type="hidden" name=pagepos value="">
<table class=form>
  <tr>
    <td width="15%"><%=SystemEnv.getHtmlLabelName(15068,user.getLanguage())%></td>
    <td width="85%" class=field>
    <INPUT class=saveHistory type=text name=rolesmark value=<%=rolesmark%>>
    </td>
    <%--<td width="15%"><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></td>
    <td width="35%" class=field><BUTTON class=Browser onClick="onShowRole()"></BUTTON> 
    <span id=rolespan><%=RolesComInfo.getRolesname(roleid)%></span> 
    <INPUT class=saveHistory type=hidden name=roleid value=<%=roleid%>>
    </td>--%>
  </tr>
</table>
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
  <COL width="20%"><COL width="10%"><COL width="10%"><COL width="15%"><COL width="15%"><COL width="30%">
  <TBODY>
  <TR class=Header >
    <TH colspan="6"><%=SystemEnv.getHtmlLabelName(15067,user.getLanguage())%></TH>
  </TR>
  <TR class=separator>
    <TD class=Sep1 colSpan=6></TD></TR>
  <TR class=Header>
    <TD><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(17868,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(17865,user.getLanguage())%></TD>
	<TD><%=SystemEnv.getHtmlLabelName(431,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(385,user.getLanguage())%></TD>
  </TR>
    <TR class=Line><TD colspan="6"></TD></TR>
<%
int countsize = 0;
int pagesizes = 0;
int currentpagestart = 0;
int currentpageend = 0;

boolean islight=true ;
String sql = "select * from hrmroles ";
String sqlWhere = " where 1=1 ";
if(detachable!=1){
	sqlWhere+=" and type=0 ";
}
if(!roleid.equals("")){
	sqlWhere+=" and id="+roleid;
}
if(!rolesmark.equals("")){
	sqlWhere+=" and rolesmark like '%"+Util.fromScreen2(rolesmark,7)+"%'";
}
sql = "select count(*) from hrmroles "+sqlWhere;
RecordSet.executeSql(sql);
if(RecordSet.next())
{
	countsize = RecordSet.getInt(1);
}
pagesizes = countsize%10==0?countsize/10:(countsize/10+1);
if(pagepos<=0)
{
	pagepos = 1;
}
if(pagepos>=pagesizes)
{
	pagepos = pagesizes;
}
currentpagestart = (pagepos-1)*10<0?0:(pagepos-1)*10;
currentpageend = (pagepos*10>countsize)?countsize:pagepos*10;
int currentpagesize = currentpageend-currentpagestart;
if(RecordSet.getDBType().equals("oracle"))
{
	
	sql = "select * "+
		  "	  from (select rownum as rowno, r.* "+
		  "	          from (select * from hrmroles "+sqlWhere+
		  "	                 order by id asc) r) c "+
		  "	 where c.rowno <= "+currentpageend+
		  "	   and c.rowno > "+currentpagestart;
		  
}
else
{
	sql = "select top "+currentpagesize+" c.* "+
	  "	  from (select top "+currentpagesize+" r.* "+
	  "	          from (select top "+currentpageend+" * from hrmroles "+sqlWhere+
	  "	                 order by id asc ) r order by r.id desc ) c "+
	  "	 order by c.id asc";
}
//out.println(sql);
RecordSet.executeSql(sql);
while(RecordSet.next()){
    String tmproleid=RecordSet.getString("id") ;
    String rolename=RecordSet.getString("rolesmark");
    String subcompanyid=RecordSet.getString("subcompanyid");
    int roletype = Util.getIntValue(Util.null2String(RecordSet.getString("type"))); 
    String tmpright="" ;
    String tmpresources="" ;
    String rolelevel="" ;
    String tmpcompanys = "";
    StructureRightInfo mSri=null;
    StructureRightHandler mSriHander=new StructureRightHandler();
    mSriHander.StructureRightInfoDo(Util.getIntValue(tmproleid,-1),user.getUID());
    int structureCount=mSriHander.size();
    for(int j=0;j<structureCount;j++)
    {
    	mSri=mSriHander.get(j);
    	
    	if(mSri.getNodetype()==1)
    	{
        	if(mSri.getBeChecked()==1) 
        	{
        		for(int k=0;k<mSri.getTabNo();k++){
            		tmpcompanys+="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                }
        		tmpcompanys +=Util.toScreen(SubCompanyComInfo.getSubCompanyname(mSri.getId()),user.getLanguage());
        		if(mSri.getOperateType_select()==0){
        			tmpcompanys += "(<b>"+SystemEnv.getHtmlLabelName(17873,user.getLanguage())+"</b>)<br>";
	            }
	            if(mSri.getOperateType_select()==1){              
	            	tmpcompanys +="(<b>"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"</b>)<br>";
	            }
	            if(mSri.getOperateType_select()==2){
	            	tmpcompanys +="(<b>"+SystemEnv.getHtmlLabelName(17874,user.getLanguage())+"</b>)<br>";
	            }
        	}
        }
    	
    }
    String tmpsql="select t1.*,t2.rolelevel from systemrights t1,systemrightroles t2 "+
                  "where t1.id=t2.rightid and t2.roleid="+tmproleid;
    //out.println(tmpsql);
    rs.executeSql(tmpsql) ;
    
    while(rs.next()){
    	int level=rs.getInt("rolelevel");
        String rightlevel = "";
        switch(level){
    		case 0:rightlevel=SystemEnv.getHtmlLabelName(124,user.getLanguage());
    			break;
    		case 1:rightlevel=SystemEnv.getHtmlLabelName(141,user.getLanguage());
    			break;
    		case 2:rightlevel=SystemEnv.getHtmlLabelName(140,user.getLanguage());
    	}
        tmpright+="<br>"+rs.getString("rightdesc");
        if(!rightlevel.equals(""))
        {
        	tmpright+="("+rightlevel+")";
        }
    }
    if(!tmpright.equals(""))    
    	tmpright=tmpright.substring(4);
    tmpsql="select * from hrmrolemembers where roleid="+tmproleid;
    //out.println(tmpsql);
    rs.executeSql(tmpsql) ;
    while(rs.next())
    {
    	rolelevel = Util.null2String(rs.getString("rolelevel"));
    	String resourcename = ResourceComInfo.getResourcename(rs.getString("resourceid"));
    	if(!resourcename.equals(""))
    	{
    		tmpresources+="<br><a href='basedata_hrm.jsp?resourceid="+rs.getString("resourceid")+"'>"+ResourceComInfo.getResourcename(rs.getString("resourceid"))+"</a>";
    	    if(rolelevel.equals("0")){
    	    	tmpresources += " ("+SystemEnv.getHtmlLabelName(124,user.getLanguage())+")";
    	    }else if(rolelevel.equals("1")){
    	    	tmpresources += " ("+SystemEnv.getHtmlLabelName(141,user.getLanguage())+")";
    	    }else if(rolelevel.equals("2")){
    	    	tmpresources += " ("+SystemEnv.getHtmlLabelName(140,user.getLanguage())+")";
    	    }
    	}
    }
    //System.out.println(tmpresources);
    if(!tmpresources.equals(""))    
    	tmpresources=tmpresources.substring(4);
%>
  <tr <%if(islight){%>class=datalight <%} else {%> class=datadark <%}%>> 
    <TD valign=top><%=rolename%>&nbsp;(<a href="basedata_hrmrole.jsp?roleid=<%=tmproleid%>"><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%></a>)</TD>
    <TD valign=top><%if(detachable==1){ %><%=Util.toScreen(SubCompanyComInfo.getSubCompanyname(subcompanyid),user.getLanguage())%><%} %>&nbsp;</TD>
    <TD valign=top><%if(detachable==1){ %><%if(roletype==0){%><%=SystemEnv.getHtmlLabelName(17866,user.getLanguage())%><%}else if(roletype==1){%><%=SystemEnv.getHtmlLabelName(17867,user.getLanguage())%><%}}%></TD>
    <TD valign=top><%=detachable==1?tmpcompanys:""%>&nbsp;</TD>
    <TD valign=top><%=tmpresources%>&nbsp;</TD>
    <TD valign=top><%=tmpright%>&nbsp;</TD>
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
											&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(265,user.getLanguage())%><!-- 每页 -->10<%=SystemEnv.getHtmlLabelName(18256,user.getLanguage())%><!-- 条 -->
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
	document.getElementById("iframeExcel").src = "/system/basedata/basedata_roleexcel.jsp?pagepos=<%=pagepos%>&resourceid=<%=resourceid%>&roleid=<%=roleid%>&lastname=<%=lastname%>&rolesmark=<%=rolesmark%>";
}
function doSearchAgain()
{
	document.location.href = "basedata_role.jsp";
}
function doBack()
{
	document.location.href = "basedata.jsp";
}
</SCRIPT>

</BODY></HTML>
