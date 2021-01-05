
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.ArrayList"%>
<%@ page import="weaver.docs.category.security.*" %>
<%@ page import="weaver.docs.category.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.docs.multidocupload.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DocChangeManager" class="weaver.docs.change.DocChangeManager" scope="page" />
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
String workflowtype="";
//String formid="";
String sql = "";
if(!sqlwhere.equals("")){

    String  tempWorkflowType=null;
    sql = "select distinct t1.workflowtype from workflow_base t1, workflow_createdoc t2 where t2.status='1' AND t2.flowDocField>0 AND t1.id=t2.workflowid and t1.isvalid=1 ";
    sql += " and t1.id in(select t1.id from workflow_base t1,workflow_fieldLable fieldLable,workflow_formField formField, workflow_formdict formDict"; 
    sql += " where fieldLable.formid = formField.formid ";
    sql += " and fieldLable.fieldid = formField.fieldid "; 
    sql += " and formField.fieldid = formDict.ID and (formField.isdetail<>'1' or formField.isdetail is null) "; 
    sql += " and formField.formid = t1.formid and fieldLable.langurageid = "+user.getLanguage(); 
    sql += " and formDict.fieldHtmlType = '3' and formDict.type = 9 ";
    sql += " group by t1.id) ";
    sql += " and t1.id not in(select workflowid from DocChangeWorkflow)" ;
 	//rs.executeSql("select distinct workflowtype from workflow_base "+sqlwhere+" and isvalid=1");
 	rs.executeSql(sql);
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
		sql += "select id,typename from workflow_type WHERE id in(";
		sql += "select distinct t1.workflowtype from workflow_base t1, workflow_createdoc t2 where t2.status='1' AND t2.flowDocField>0 AND t1.id=t2.workflowid and t1.isvalid=1 ";
		if(DocChangeManager.cversion.equals("4")) {
		    sql += " and t1.id in(select t1.id from workflow_base t1,workflow_fieldLable fieldLable,workflow_formField formField, workflow_formdict formDict"; 
		    sql += " where fieldLable.formid = formField.formid ";
		    sql += " and fieldLable.fieldid = formField.fieldid "; 
		    sql += " and formField.fieldid = formDict.ID and (formField.isdetail<>'1' or formField.isdetail is null) "; 
		    sql += " and formField.formid = t1.formid and fieldLable.langurageid = "+user.getLanguage(); 
		    sql += " and formDict.fieldHtmlType = '3' and formDict.type = 9 ";
		    sql += " group by t1.id) ";
		}
	    sql += ") order by dsporder";
		rs.executeSql(sql);
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
		sql += "select distinct t1.id,t1.workflowname from workflow_base t1, workflow_createdoc t2 where t2.status='1' AND t2.flowDocField>0 AND t1.id=t2.workflowid and t1.isvalid=1 ";
		sql += " and t1.workflowtype="+nodeId;
		if(DocChangeManager.cversion.equals("4")) {
		    sql += " and t1.id in(select t1.id from workflow_base t1,workflow_fieldLable fieldLable,workflow_formField formField, workflow_formdict formDict"; 
		    sql += " where fieldLable.formid = formField.formid ";
		    sql += " and fieldLable.fieldid = formField.fieldid "; 
		    sql += " and formField.fieldid = formDict.ID and (formField.isdetail<>'1' or formField.isdetail is null) "; 
		    sql += " and formField.formid = t1.formid and fieldLable.langurageid = "+user.getLanguage(); 
		    sql += " and formDict.fieldHtmlType = '3' and formDict.type = 9 ";
		    sql += " group by t1.id) ";
		}
		rs.executeSql(sql);
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



