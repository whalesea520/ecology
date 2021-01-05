
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.ArrayList"%>
<%@ page import="weaver.docs.category.security.*" %>
<%@ page import="weaver.docs.category.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.docs.multidocupload.*" %>
<%@ page import="weaver.systeminfo.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Monitor" class="weaver.workflow.monitor.Monitor" scope="page" />
<jsp:useBean id="User" class="weaver.hrm.User" scope="page" />
<%
StringBuffer sb=new  StringBuffer();
sb.append("[");
String workfowtypeid=Util.null2String(request.getParameter("wftypeid"));
//System.out.println("WFTypeBrowser_XML.jsp==>>>wftypeid>>"+workfowtypeid);
String id=Util.null2String(request.getParameter("id"));
String userid = Util.null2String(request.getParameter("userid"));
User user = new User();
user = User.getUser(Util.getIntValue(userid,-1),0);
if(!id.equals("")){
	id=(String)id.split("_")[1];
}

String wherestr=" where 1 = 1 ";

String sql = Monitor.getwftypeRightSql(userid,rs.getDBType());

String sql_wfid = Monitor.getwfidRightSql(userid,rs.getDBType());

if(!workfowtypeid.equals(""))
	wherestr = " and id="+workfowtypeid;
if(id.equals("")){
	if(workfowtypeid.equals(""))
		sb.append("{name:\""+SystemEnv.getHtmlLabelName(16579, user.getLanguage())+"\", id:\"q_0\", isParent:true ,open:true}");
	String tempsql = "select id,typename from workflow_type   "+wherestr+" and id in ("+sql+") order by dsporder";
	rs.executeSql(tempsql);
	while(rs.next()){
		String typeId=Util.null2String(rs.getString("id"));
		String typeName=Util.null2String(rs.getString("typename"));	
		   if(sb.toString().indexOf(",")>1){
			  sb.append(",{ id:\"q_"+typeId+"\", pId:\"q_0\", name:\""+typeName+"\",isParent:true}");
			}else{
				sb.append("{ id:\"q_"+typeId+"\", pId:\"q_0\", name:\""+typeName+"\",isParent:true,open:true}");
				if(!workfowtypeid.equals(""))
				{
					 rs1.executeSql("select id,workflowname from workflow_base where (isvalid='0' or isvalid='1' or isvalid='2' or isvalid='3') and workflowtype in("+workfowtypeid+") and id in ("+sql_wfid+") order by workflowname");
					 while(rs1.next()){
						String requestid=Util.null2String(rs1.getString("id"));
						String workflowname=Util.null2String(rs1.getString("workflowname"));	
						  if(sb.toString().indexOf(",")>1){
							 sb.append(",{ id:"+requestid+", pId:\"q_"+workfowtypeid+"\", name:\""+workflowname+"\"}");
							}else{
								sb.append("{ id:"+requestid+", pId:\"q_"+workfowtypeid+"\", name:\""+workflowname+"\"}");
							}
					}
				}
			}
	}
}else{
	 rs1.executeSql("select id,workflowname from workflow_base where (isvalid='0' or isvalid='1' or isvalid='2' or isvalid='3') and workflowtype in("+id+") and id in ("+sql_wfid+") order by workflowname");
	 while(rs1.next()){
		String requestid=Util.null2String(rs1.getString("id"));
		String workflowname=Util.null2String(rs1.getString("workflowname"));	
		  if(sb.toString().indexOf(",")>1){
			 sb.append(",{ id:"+requestid+", pId:\"q_"+id+"\", name:\""+workflowname+"\"}");
			}else{
				sb.append("{ id:"+requestid+", pId:\"q_"+id+"\", name:\""+workflowname+"\"}");
			}
	}
}
sb.append("] ");

//System.out.println("============:"+sb.toString());
out.println(sb.toString());
%>