
<%@ page language="java" contentType="application/vnd.ms-excel; charset=UTF-8"%>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.*,weaver.hrm.*,java.util.*"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page"/>
<%@ page import="weaver.systeminfo.role.StructureRightHandler,weaver.systeminfo.role.StructureRightInfo"%>
<% 
response.setContentType("application/vnd.ms-excel;charset=UTF-8");
response.setHeader("Content-disposition", "attachment;filename=basedata_roleexcel.xls");
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;
if(! HrmUserVarify.checkUserRight("SystemSetEdit:Edit", user)) { 
    response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
%>
<%
int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);

int pagepos=Util.getIntValue(Util.null2String(request.getParameter("pagepos")),1);
String resourceid=Util.fromScreen(request.getParameter("resourceid"),user.getLanguage());
String roleid=Util.fromScreen(request.getParameter("roleid"),user.getLanguage());
String lastname=Util.fromScreen(request.getParameter("lastname"),user.getLanguage());
String rolesmark=Util.fromScreen(request.getParameter("rolesmark"),user.getLanguage());
%>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<style type="text/css">
	TABLE {
		FONT-SIZE: 9pt; FONT-FAMILY: Verdana
	}
	TABLE.Shadow {
		border: #000000 ;
		width:100% ;
		height:100% ;
		BORDER-color:#ffffff;
		BORDER-TOP: 3px outset #ffffff;
		BORDER-RIGHT: 3px outset #000000;
		BORDER-BOTTOM: 3px outset #000000;
		BORDER-LEFT: 3px outset #ffffff;
		BACKGROUND-COLOR:#FFFFFF;
		table-layout:fixed;
	}
	TABLE.ListStyle {
		width:100% ;
		table-layout:fixed;
		BACKGROUND-COLOR: #FFFFFF ;
		BORDER-Spacing:1pt ; 
	}
	
	TABLE.ListStyle TR.Title TH {
		TEXT-ALIGN: left
	}
	TABLE.ListStyle TR.Spacing {
		HEIGHT: 1px
	}
	TABLE.ListStyle TR.Header {
		COLOR: #003366; BACKGROUND-COLOR: #C8C8C8 ; HEIGHT: 30px ;BORDER-Spacing:1pt
	}
	TABLE.ListStyle TR.Header TD {
		COLOR: #003366;
		TEXT-ALIGN: left;
	}
	TABLE.ListStyle TR.Header TH {
		COLOR: #003366 ;
		TEXT-ALIGN: left;
	}
	
	TABLE.ListStyle TR.DataDark {
		BACKGROUND-COLOR: #F7F7F7 ; HEIGHT: 22px ; BORDER-Spacing:1pt
	}
	TABLE.ListStyle TR.DataDark TD {
		PADDING-RIGHT: 0pt; PADDING-LEFT: 0pt; LINE: 100%
	}
	
	TABLE.ListStyle TR.DataLight {
		BACKGROUND-COLOR: #FFFFFF ; HEIGHT: 22px ; BORDER-Spacing:1pt 
	}
	TABLE.ListStyle TR.DataLight TD {
		PADDING-RIGHT: 0pt; PADDING-LEFT: 0pt; LINE: 100%
	}
	TABLE.ListStyle TR.Selected {
		BACKGROUND-COLOR: #EAEAEA ; HEIGHT: 22px ; BORDER-Spacing:1pt 
	}
	TABLE.ListStyle TR.Selected TD {
		PADDING-RIGHT: 0pt; PADDING-LEFT: 0pt; LINE: 100%
	}
	</style>
	<table width=100% height=90% border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td valign="top">
			<TABLE class="Shadow">
			<tr>
				<td valign="top">
				<TABLE class=ListStyle cellspacing=1 border="1">
				
				  <COLGROUP>
				  <COL width="20%"><COL width="10%"><COL width="10%"><COL width="15%"><COL width="15%"><COL width="30%">
				  <TBODY>
				  <TR class=Header >
				    <TH colspan="6"><%=SystemEnv.getHtmlLabelName(15067,user.getLanguage())%></TH>
				  </TR>
				  <TR class=Header>
				    <TD><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></TD>
				    <TD><%=SystemEnv.getHtmlLabelName(17868,user.getLanguage())%></TD>
				    <TD><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></TD>
				    <TD><%=SystemEnv.getHtmlLabelName(17865,user.getLanguage())%></TD>
					<TD><%=SystemEnv.getHtmlLabelName(431,user.getLanguage())%></TD>
				    <TD><%=SystemEnv.getHtmlLabelName(385,user.getLanguage())%></TD>
				  </TR>
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
				    String _rolesmark=RecordSet.getString("rolesmark");
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
				    		tmpresources+="<br>"+ResourceComInfo.getResourcename(rs.getString("resourceid"));
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
				    <TD valign=top><%=_rolesmark%>&nbsp;(<%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%>)</TD>
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
			</TABLE>
			</td>
		</tr>
	</table>
