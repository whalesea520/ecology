<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<jsp:useBean id="WorkflowKeywordComInfo" class="weaver.docs.senddoc.WorkflowKeywordComInfo" scope="page" />
<jsp:useBean id="WorkflowKeywordManager" class="weaver.docs.senddoc.WorkflowKeywordManager" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="log" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />

<%@ include file="/systeminfo/init_wev8.jsp" %>

<%
if(!HrmUserVarify.checkUserRight("SendDoc:Manage", user)){
    response.sendRedirect("/notice/noright.jsp");
    return;
}

String operation=Util.null2String(request.getParameter("operation"));

String id=Util.null2String(request.getParameter("id"));
String keywordName = Util.fromScreen(request.getParameter("keywordName"),user.getLanguage());
String keywordDesc = Util.fromScreen(request.getParameter("keywordDesc"),user.getLanguage());
int parentId=Util.getIntValue(request.getParameter("parentId"),0);
String isKeyword = Util.null2String(request.getParameter("isKeyword"));
double showOrder=Util.getDoubleValue(request.getParameter("showOrder"),0);
String isentrydetail = Util.null2String(request.getParameter("isentrydetail"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
String from = Util.null2String(request.getParameter("from"));
String optype = Util.null2String(request.getParameter("optype"));
if(keywordName!=null){
	keywordName=keywordName.trim();
}
if(operation.equals("AddSave")){
    //将上级的是否末级改为否
	WorkflowKeywordManager.updateDataOfNewParent(""+parentId);
	
    //插入数据
    String sql = "insert into  Workflow_Keyword(keywordName,keywordDesc,parentId,isLast,isKeyword,showOrder) values('"+keywordName+"','"+keywordDesc+"',"+parentId+",'1','"+isKeyword+"',"+showOrder+")";
	RecordSet.executeSql(sql);

    //获得记录的id
	RecordSet.executeSql(" select max(id) from Workflow_Keyword ");

	if(RecordSet.next()){
		id=Util.null2String(RecordSet.getString(1));
	}
	log.insSysLogInfo(user, Util.getIntValue(id), keywordName, sql, "343", "1", 0, request.getRemoteAddr());
    //清除缓存中的内容
    WorkflowKeywordComInfo.removeWorkflowKeywordCache();
    if(isDialog.equals("1")){
	    if(isentrydetail.equals("1")){
	    	 out.println("<html><script type='text/javascript'>parent.parent.getParentWindow(parent).parent.location.href='/docs/sendDoc/DocKeywordTab.jsp?_fromURL=2&optype=0&refresh=2&id="+id+"';parent.parent.getParentWindow(parent).closeDialog();</script></html>");
		}else{
			if(from.equals("edit")){//从编辑页面过来新建同级节点
				out.println("<html><script type='text/javascript'>parent.parent.getParentWindow(parent).location.href='/docs/sendDoc/WorkflowKeywordEdit.jsp?optype=1&refresh=2&id="+parentId+"';parent.parent.getParentWindow(parent).closeDialog();</script></html>");
			}else if(from.equals("nextedit")){//从编辑页面过来新建下级节点
				RecordSet.executeSql(" select parentId from Workflow_Keyword where id="+parentId);
				id = "";
				if(RecordSet.next()){
					id=Util.null2String(RecordSet.getString(1));
				}
				if("".equals(id) || id.equals("0")){//如果没有父节点
					out.println("<html><script type='text/javascript'>parent.parent.getParentWindow(parent).location.href='/docs/sendDoc/WorkflowKeywordEdit.jsp?optype=1&refresh=2&id="+parentId+"';parent.parent.getParentWindow(parent).closeDialog();</script></html>");
				}else{
					out.println("<html><script type='text/javascript'>parent.parent.getParentWindow(parent).parent.location.href='/docs/sendDoc/DocKeywordTab.jsp?_fromURL=2&optype=1&refresh=2&id="+id+"';parent.parent.getParentWindow(parent).closeDialog();</script></html>");
				}
			}else{
				out.println("<html><script type='text/javascript'>parent.parent.getParentWindow(parent).parent.location.href='/docs/sendDoc/DocKeywordTab.jsp?_fromURL=1&refresh=1';parent.parent.getParentWindow(parent).closeDialog();</script></html>");
			}
		}
    }else{
    	response.sendRedirect("WorkflowKeywordEdit.jsp?refresh=1&keywordId="+id);
    }
	return;
 }
 else if(operation.equals("EditSave")){

    String hisParentId=WorkflowKeywordComInfo.getParentId(""+id);
    //在上级改变的情况下,更新原来的上级的值,
    if(!(""+parentId).equals(hisParentId)){
		WorkflowKeywordManager.updateDataOfNewParent(""+parentId);//将上级的是否末级改为否
		WorkflowKeywordManager.updateDataOfHisParent(""+id,hisParentId);
	}
	String sql = "update Workflow_Keyword set keywordName='"+keywordName+"',keywordDesc='"+keywordDesc+"',parentId="+parentId+",isKeyword='"+isKeyword+"',showOrder="+showOrder+" where id="+id;
	RecordSet.executeSql(sql);
	log.insSysLogInfo(user, Util.getIntValue(id), keywordName, sql, "343", "2", 0, request.getRemoteAddr());
    //清除缓存中的内容
    WorkflowKeywordComInfo.removeWorkflowKeywordCache();

    if(isDialog.equals("1")){
	    if(isentrydetail.equals("1")){
	    	 out.println("<html><script type='text/javascript'>parent.parent.getParentWindow(parent).parent.location.href='/docs/sendDoc/DocKeywordTab.jsp?_fromURL=2&refresh=1&id="+id+"';parent.parent.getParentWindow(parent).closeDialog();</script></html>");
		}else{
			if(from.equals("edit")){//从编辑页面过来新建同级节点
				out.println("<html><script type='text/javascript'>parent.parent.getParentWindow(parent).location.href='/docs/sendDoc/WorkflowKeywordEdit.jsp?optype=1&refresh=1&id="+parentId+"';parent.parent.getParentWindow(parent).closeDialog();</script></html>");
			}else if(from.equals("nextedit")){//从编辑页面过来新建下级节点
				RecordSet.executeSql(" select parentId from Workflow_Keyword where id="+parentId);
				id = "";
				if(RecordSet.next()){
					id=Util.null2String(RecordSet.getString(1));
				}
				if("".equals(id) || id.equals("0")){//如果没有父节点
					out.println("<html><script type='text/javascript'>parent.parent.getParentWindow(parent).parent.location.href='/docs/sendDoc/DocKeywordTab.jsp?_fromURL=2&refresh=1&id="+parentId+"';parent.parent.getParentWindow(parent).closeDialog();</script></html>");
				}else{
					out.println("<html><script type='text/javascript'>parent.parent.getParentWindow(parent).location.href='/docs/sendDoc/WorkflowKeywordEdit.jsp?optype=1&refresh=1&id="+id+"';parent.parent.getParentWindow(parent).closeDialog();</script></html>");
				}
			}else{
				out.println("<html><script type='text/javascript'>parent.parent.getParentWindow(parent).parent.location.href='/docs/sendDoc/DocKeywordTab.jsp?_fromURL=1&refresh=1';parent.parent.getParentWindow(parent).closeDialog();</script></html>");
			}
		}
    }else{
    	response.sendRedirect("WorkflowKeywordEdit.jsp?refresh=1&id="+id);
    }

	return;
 } else if(operation.equals("Delete")){  
	String[] ids = id.split(",");
	String fromId = Util.null2String(request.getParameter("fromId"));
	for(int i=0;i<ids.length;i++){
		id = ids[i];
		String hisParentId=WorkflowKeywordComInfo.getParentId(""+id);
		WorkflowKeywordManager.updateDataOfHisParent(""+id,hisParentId);
		String sql =  "delete from Workflow_Keyword where id="+id;
		RecordSet.executeSql(sql);
		log.insSysLogInfo(user, Util.getIntValue(id), WorkflowKeywordComInfo.getKeywordName(id), sql, "343", "3", 0, request.getRemoteAddr());
	    //清除缓存中的内容
	    WorkflowKeywordComInfo.removeWorkflowKeywordCache();
    }
    if("".equals(fromId)){
    	out.println("1");
    }else{
    	response.sendRedirect("WorkflowKeywordEdit.jsp?refresh=1&id="+fromId);
    }
    return;
 }
%>
