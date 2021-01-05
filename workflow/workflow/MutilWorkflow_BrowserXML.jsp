
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
<jsp:useBean id="User" class="weaver.hrm.User" scope="page" />
<jsp:useBean id="requestutil" class="weaver.workflow.request.todo.RequestUtil" scope="page" />
<%
StringBuffer sb=new  StringBuffer();
sb.append("[");
String workfowtypeid=Util.null2String(request.getParameter("wftypeid"));
String reportwfid=Util.null2String(request.getParameter("reportwfid"));
//System.out.println("WFTypeBrowser_XML.jsp==>>>wftypeid>>"+workfowtypeid);
String id=Util.null2String(request.getParameter("id"));
String userid = Util.null2String(request.getParameter("userid"));

String showos = Util.null2String(request.getParameter("showos"));

int isopenos = requestutil.getOfsSetting().getIsuse();
String showtype = requestutil.getOfsSetting().getShowsysname() ;


User user = new User();
user = User.getUser(Util.getIntValue(userid,-1),0);
if(!id.equals("")){
	id=(String)id.split("_")[1];
}

// System.out.println("============id:"+id);
String wherestr="";
String wherestr1="";
if(!workfowtypeid.equals("")){
	wherestr = " where id="+workfowtypeid;
	wherestr1 = " and sysid="+workfowtypeid;
}

String isvalid = "1,2";
if(!"".equals(reportwfid)){
    if("".equals(wherestr)){
        wherestr = " where exists (select 1 from workflow_base b where a.id = b.workflowtype and b.id in ("+reportwfid+")) ";
		if(isopenos==1){
	        wherestr1 = " and exists (select 1 from ofs_workflow b where a.sysid = b.sysid and b.sysid in ("+reportwfid+")) ";
        }
    }else{
        wherestr = " and exists (select 1 from workflow_base b where a.id = b.workflowtype and b.id in ("+reportwfid+")) ";
		if(isopenos==1){
	        wherestr1 = " and exists (select 1 from ofs_workflow b where a.sysid = b.sysid and b.sysid in ("+reportwfid+")) ";
        }
    }
    isvalid = "1,2,3";
}
if(id.equals("")){
	if(workfowtypeid.equals(""))
		sb.append("{name:\""+SystemEnv.getHtmlLabelName(16579, user.getLanguage())+"\", id:\"q_0\", isParent:true ,open:true}");
	String tempsql = "select id,typename from workflow_type a  "+wherestr+"   order by dsporder";
	if(isopenos==1&&showos.equals("1")){
		tempsql = "select * from ( select id,typename,typedesc,dsporder from workflow_type "+wherestr+"  union (select * from (select sysid as id ,sysshortname as typename,sysfullname as typdesc, 9999 as dsporder from ofs_sysinfo where cancel=0 "+wherestr1+" ) a ) ) a  order by dsporder " ;
	}
	rs.executeSql(tempsql);
	while(rs.next()){
		String typeId=Util.null2String(rs.getString("id"));
		String typeName=Util.null2String(rs.getString("typename"));	
		String showname = requestutil.getSysname(Util.getIntValue(typeId),showtype);
        if(!showname.equals("")&&showos.equals("1")){
            typeName = "["+showname+"]"+typeName;
        }
		   if(sb.toString().indexOf(",")>1){
			  sb.append(",{ id:\"q_"+typeId+"\", pId:\"q_0\", name:\""+typeName+"\",isParent:true}");
			}else{
				sb.append("{ id:\"q_"+typeId+"\", pId:\"q_0\", name:\""+typeName+"\",isParent:true,open:true}");
				if(!workfowtypeid.equals(""))
				{
					 if(isopenos==1&&showos.equals("1")){
                         rs1.executeSql("select * from (select id,workflowname from workflow_base where (isvalid='1' or isvalid='2') and workflowtype in("+workfowtypeid+")  union select workflowid as id ,workflowname from ofs_workflow where cancel=0 and sysid in ("+workfowtypeid+")) a order by workflowname");
					 }else{
						rs1.executeSql("select id,workflowname from workflow_base where isvalid in ("+isvalid+") and workflowtype in("+workfowtypeid+") order by workflowname");
					 }
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
    String sql = "";
    if(isopenos==1&&showos.equals("1")){
        sql = "select * from (select id,workflowname from workflow_base where (isvalid='1' or isvalid='2') and workflowtype in("+id+") ";
        if(!"".equals(reportwfid)){
            sql += " and id in ("+reportwfid+")";
        }
        sql += " union select workflowid as id ,workflowname from ofs_workflow where cancel=0 and sysid in ("+id+")";
        if(!"".equals(reportwfid)){
            sql += " and workflowid in ("+reportwfid+")";
        }
        sql += ") a order by workflowname ";
	}else{
        sql = "select id,workflowname from workflow_base where isvalid in ("+isvalid+") and workflowtype in("+id+") ";
        if(!"".equals(reportwfid)){
            sql += " and id in ("+reportwfid+")";
        }
        sql +=" order by workflowname";
	}
	 rs1.executeSql(sql);
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