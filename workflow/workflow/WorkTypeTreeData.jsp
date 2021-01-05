
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.ArrayList"%>
<%@ page import="weaver.docs.category.security.*" %>
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
	
	ArrayList returnList=new ArrayList();
	if("root".equals(nodeType)){
		rs.executeSql("select id,typename from workflow_type order by dsporder");
		while(rs.next()){
			String typeId=Util.null2String(rs.getString("id"));
			String typeName=Util.null2String(rs.getString("typename"));		
			
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



