
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.ArrayList"%>
<%@ page import="weaver.docs.category.security.*,weaver.workflow.request.todo.RequestUtil" %>
<%@ page import="weaver.docs.category.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.docs.multidocupload.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
	User user = HrmUserVarify.getUser (request , response) ;
	if(user == null)  return ;
	String node=request.getParameter("node");
	String nodeType = "";
	String nodeId = "";
	String nodeArgs[] = Util.TokenizerString2(node, "_");
	nodeType = nodeArgs[0];
	nodeId = nodeArgs[1];

	String worktype=Util.null2String(request.getParameter("worktype"));	
	boolean isopenos = RequestUtil.isOpenOtherSystemToDo();
	ArrayList returnList=new ArrayList();
	if("root".equals(nodeType)){
		if(worktype.equals("")){
			if(isopenos){
				rs.executeSql("select id,workflowname from (select id,workflowname from workflow_base where isvalid=1 union select workflowid as id ,workflowname from ofs_workflow where cancel=0 ) a order by workflowname");
			}else{
				rs.executeSql("select id,workflowname from workflow_base where isvalid=1 order by workflowname");
			}
		}else{
			if(isopenos){
				rs.executeSql("select id,workflowname from (select id,workflowname from workflow_base where isvalid=1 and workflowtype="+worktype+" union select workflowid as id ,workflowname from ofs_workflow where cancel=0 and sysid="+worktype+") a order by workflowname");
			}else{
				rs.executeSql("select id,workflowname from workflow_base where isvalid=1 and workflowtype="+worktype+" order by workflowname");
			}
		}
		while(rs.next()){
			String typeId=Util.null2String(rs.getString("id"));
			String typeName=Util.null2String(rs.getString("workflowname"));		
			
			DocCatagoryMenuBean dmb = new DocCatagoryMenuBean();
			dmb.setText(typeName);
			dmb.setLeaf(true);
			dmb.setId("workflow_"+typeId);
			dmb.setCls("file");
			dmb.setDraggable(false);
			returnList.add(dmb);	
		}
	}
	String menuString="[";
	for(int i=0;i<returnList.size();i++){
		DocCatagoryMenuBean dmb = (DocCatagoryMenuBean)returnList.get(i);
		if(dmb!=null) {
			if(i==0) {
				menuString+="{";			
			} else {
				menuString+=",{";
			}
			menuString+="\"cls\":\""+dmb.getCls()+"\",";
			menuString+="\"draggable\":"+dmb.isDraggable()+",";
			menuString+="\"id\":\""+dmb.getId()+"\",";
			menuString+="\"leaf\":"+dmb.isLeaf()+",";
			menuString+="\"text\":\""+dmb.getText()+"\"";
			menuString+="}";
		}
	}
	menuString+="]";
	out.println(menuString);
%>



