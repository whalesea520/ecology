
<%@ page language="java" contentType="application/vnd.ms-excel; charset=UTF-8"%>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.*,weaver.hrm.*,java.util.*"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page"/>

<% 
response.setContentType("application/vnd.ms-excel;charset=UTF-8");
response.setHeader("Content-disposition", "attachment;filename=basedata_hrmroleexcel.xls");
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
String roleid=Util.fromScreen(request.getParameter("roleid"),user.getLanguage());
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
				  <COL width="20%"><COL width="20%"><COL width="30%"><COL width="20%">
				  <TBODY>
				  <TR class=Header >
				    <TH colspan="3"><%=SystemEnv.getHtmlLabelName(15066,user.getLanguage())%></TH>
				  </TR>
				  <TR class=Header>
				    <TD><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></TD>
					<TD><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></TD>
				    <TD><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%></TD>
				  </TR>
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
				    <TD><%=lastname%>&nbsp;</TD>
				    <td><%=rolesname%> ( <%if(rolelevel.equals("0")){%><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%> <%}%><%if(rolelevel.equals("1")){%><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%> <%}%><%if(rolelevel.equals("2")){%><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%> <%}%>)&nbsp;</td>
				    <TD><%=WorkflowComInfo.getWorkflowname(workflowid)%>&nbsp;</TD>
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
