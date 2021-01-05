
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="oracle.sql.CLOB" %>
<%@ page import="java.io.Writer" %>
<jsp:useBean id="exports" class="weaver.workflow.exports.services.WorkflowDataService" scope="page"/>

<%
  User user = HrmUserVarify.getUser (request , response) ;
  if(user == null)  return ;
  String src = Util.null2String(request.getParameter("src"));
  ////得到标记信息
  if(src.equalsIgnoreCase("export"))
  {
	   String wfid=Util.null2String(Util.null2String(request.getParameter("wfid")));
	   String result = exports.exportWorkflowById(wfid);
	   out.println(result);
  }
  else
  {
	  ConnStatement statement=new ConnStatement();
	  int flag = 0;
	  try
	  {
		  String sql = "";
		  boolean isoracle = (statement.getDBType()).equals("oracle");
		  String modeid=Util.null2String(request.getParameter("modeid"));
		  String isform=Util.null2String(request.getParameter("isform"));
		  String isprint=Util.null2String(request.getParameter("isprint"));
		  String modestr=Util.null2String(request.getParameter("modestring"));
		  
		  if(isoracle)
		  {
			  if(!modeid.equals(""))
			  {
				  if(isform.equals("1"))
		          	sql="update workflow_formmode set isprint=? where isprint='"+isprint+"' and id="+modeid;
				  else
					  sql="update workflow_nodemode set isprint=? where isprint='"+isprint+"' and id="+modeid;
		          statement.setStatementSql(sql);
		          statement.setString(1 , isprint);
		          flag=statement.executeUpdate();
		          
		          if(isform.equals("1"))
		          	  sql = "select modedesc from workflow_formmode where isprint='"+isprint+"' and id="+modeid;
		          else
		        	  sql = "select modedesc from workflow_nodemode where isprint='"+isprint+"' and id="+modeid;
		          
		          statement.setStatementSql(sql, false);
		          statement.executeQuery();
		          if(statement.next())
		          {
		              CLOB theclob = statement.getClob(1);
		              char[] contentchar = modestr.toCharArray();
		              Writer contentwrite = theclob.getCharacterOutputStream();
		              contentwrite.write(contentchar);
		              contentwrite.flush();
		              contentwrite.close();
		          }
			  }
	      }
		  else
	      {
			  if(!modeid.equals(""))
			  {
				  if(isform.equals("1"))
					  sql="update workflow_formmode set modedesc=? where isprint='"+isprint+"' and id="+modeid;
				  else
					  sql="update workflow_nodemode set modedesc=? where isprint='"+isprint+"' and id="+modeid;
				  
		          statement.setStatementSql(sql);
		          statement.setString(1 , modestr);
		          flag=statement.executeUpdate();
			  }
	      }
	  }
	  catch(Exception e)
	  {
		    flag=0;
		    e.printStackTrace();    
	  }
	  finally
	  {
		statement.close();
	  }
  }
%>
