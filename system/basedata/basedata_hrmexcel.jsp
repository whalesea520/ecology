
<%@ page language="java" contentType="application/vnd.ms-excel; charset=UTF-8"%>

<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.general.*,weaver.hrm.*,java.util.*"%>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page"/>

<% 
response.setContentType("application/vnd.ms-excel;charset=UTF-8");
response.setHeader("Content-disposition", "attachment;filename=basedata_hrmexcel.xls");
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;
if(! HrmUserVarify.checkUserRight("SystemSetEdit:Edit", user)) { 
    response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
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
	<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td valign="top">
			<TABLE class="Shadow">
			<tr>
			<td valign="top">
				<TABLE class=ListStyle cellspacing=1 border="1">
				  <COLGROUP>
				  <COL width="15%"><COL width="20%"><COL width="20%"><COL width="15%"><COL width="15%"><COL width="15%">
				  <TBODY>
				  <TR class=Header >
				    <TH colspan="6"><%=SystemEnv.getHtmlLabelName(15065,user.getLanguage())%></TH>
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
				        rolename+=","+rs.getString("rolesname");
				    }
				    if(!rolename.equals(""))    rolename=rolename.substring(1);
				%>
				  <tr class=datalight> 
				    <TD><b><%=RecordSet.getString("lastname")%></b>&nbsp;</TD>
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
			
			</TABLE>
			</td>
		</tr>
	</table>