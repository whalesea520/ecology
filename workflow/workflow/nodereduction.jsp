<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@page import="org.json.JSONObject"%>
<%@ page import="org.apache.commons.lang.StringUtils"%>
<%@ page import="weaver.workflow.workflow.WFNodeMainManager" %>
<jsp:useBean id="rst" class="weaver.conn.RecordSetTrans" scope="page" />
<%
	int nodeid = Util.getIntValue(request.getParameter("nodeid"));
	int wfid = Util.getIntValue(request.getParameter("wfid"));
	String nodename = Util.null2String(request.getParameter("nodename"));
	int nodetype = Util.getIntValue(request.getParameter("nodetype"),-1);
	String src = Util.null2String(request.getParameter("src"));
	JSONObject result = new JSONObject();
	
	if(!"".equals(nodeid) && !"".equals(wfid)){
	    try{
		    //判断节点名称
		    rst.executeQuery("select a.nodename from workflow_nodebase a left join workflow_flownode b on a.id = b.nodeid where a.nodename = ? and b.workflowid = ?",nodename,wfid);
		    String msg = "2" ;
			if(rst.next()){
			    msg = "0";
			}
			
			
			//判断流程是否已存在创建节点
			if(!"0".equals(msg)){
				rst.executeQuery("select a.nodetype from workflow_flownode a where a.workflowid = ? and a.nodetype = '0' and  exists (select 1 from workflow_flownode_dellog b where a.workflowid = b.workflowid and b.nodeid = ? and a.nodetype = b.nodetype)",wfid,nodeid);
				if(rst.next()){
				    msg = "1";
				}
			}
			
			if("submit".equals(src)){
			    if(StringUtils.isNotBlank(nodename)){
			        //修改节点名称
			        rst.executeUpdate("update workflow_nodebase set nodename = ? where id = ?",nodename,nodeid);
			    }
			    
			    if(nodetype > -1){
			        //修改删除的节点类型,然后再执行恢复
			        rst.executeUpdate("update workflow_flownode_dellog set nodetype = ? where workflowid = ? and nodeid = ?",nodetype,wfid,nodeid);
			    }
			    
				
				
				//恢复节点数据
				String columntemp = WFNodeMainManager.getTableColumn("workflow_flownode");
				rst.executeUpdate("insert into workflow_flownode("+columntemp+") select " +columntemp+" from workflow_flownode_dellog where workflowid = ? and nodeid = ?",wfid,nodeid);
			
				rst.executeUpdate("delete from workflow_flownode_dellog where workflowid = ? and nodeid = ?",wfid,nodeid);
				rst.commit();
				//成功
			    response.sendRedirect("/workflow/workflow/DeleteNodeList.jsp?wfid="+wfid+"&nodeid="+nodeid+"&status=2");
			}else{
			    result.put("status",msg);
			    out.write(result.toString());
			}
		}catch(Exception e){
		    //失败
			e.printStackTrace();
			rst.rollback();
			response.sendRedirect("/workflow/workflow/DeleteNodeList.jsp?wfid="+wfid+"&nodeid="+nodeid+"&status=3");
		}
	}
%>
