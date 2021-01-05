
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

String sqlwhere=Util.null2String(request.getParameter("sqlwhere"));
String showvalid=Util.null2String(request.getParameter("showvalid"));
String showvalidSqlwhere = "(isvalid='1' or isvalid='2')";
if(showvalid.equals("1")){
	showvalidSqlwhere = "(isvalid='1')";;
}
String workflowtype="";
//String formid="";
if(!sqlwhere.equals("")){
//	formid=sqlwhere.substring(sqlwhere.indexOf("formid=")+7);
//	rs.executeSql("select workflowtype from workflow_base "+sqlwhere+" and isvalid=1");
//	if(rs.next()){
//		workflowtype = Util.null2String(rs.getString("workflowtype"));
//	}

    String  tempWorkflowType=null;
 	rs.executeSql("select distinct workflowtype from workflow_base "+sqlwhere+" and "+showvalidSqlwhere);
	while(rs.next()){
		tempWorkflowType= Util.null2String(rs.getString("workflowtype"));
		if(!(tempWorkflowType.trim().equals(""))){
			workflowtype +=","+ tempWorkflowType;
		}
	}
	if(!workflowtype.equals("")){
		workflowtype=workflowtype.substring(1);
	}
}
	
	ArrayList returnList=new ArrayList();
	if("root".equals(nodeType)){
//		if(sqlwhere.equals("")){
//		rs.executeSql("select id,typename from workflow_type order by dsporder");
//		}else{
//			rs.executeSql("select id,typename from workflow_type where id="+workflowtype+" order by dsporder");
//		}
		if(workflowtype.equals("")){
		    String sql = "select id,typename from workflow_type order by dsporder";
		    if (!"".equals(sqlwhere)) {
		        sql = "select id,typename from workflow_type where 1<>1 order by dsporder";
		    }
		    rs.executeSql(sql);
		}else{
			rs.executeSql("select id,typename from workflow_type where id in("+workflowtype+") order by dsporder");
		}
		while(rs.next()){
			String typeId=Util.null2String(rs.getString("id"));
			String typeName=Util.null2String(rs.getString("typename"));		
			
			DocCatagoryMenuBean dmb = new DocCatagoryMenuBean();
			dmb.setText(typeName);
			dmb.setLeaf(false);
			dmb.setId("workflow_"+typeId);
			dmb.setCls("folder");
			dmb.setDraggable(false);
			returnList.add(dmb);	
		}
	} else if("workflow".equals(nodeType)) {
		if(sqlwhere.equals("")){
		rs.executeSql("select id,workflowname from workflow_base where "+showvalidSqlwhere+" and workflowtype="+nodeId+" order by workflowname");
		}else{
			//rs.executeSql("select id,workflowname from workflow_base where isvalid=1 and workflowtype="+nodeId+" and formid="+formid+" order by workflowname");
			rs.executeSql("select id,workflowname from workflow_base "+sqlwhere+" and "+showvalidSqlwhere+" and workflowtype="+nodeId+" order by workflowname");
		}
		while(rs.next()){
			String requestid=Util.null2String(rs.getString("id"));
			String workflowname=Util.null2String(rs.getString("workflowname"));		
			
			DocCatagoryMenuBean dmb = new DocCatagoryMenuBean();
			dmb.setText(workflowname);
			dmb.setLeaf(true);
			dmb.setId("request_"+requestid);
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



