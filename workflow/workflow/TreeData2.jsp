
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.ArrayList"%>
<%@ page import="weaver.docs.category.security.*" %>
<%@ page import="weaver.docs.category.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.docs.multidocupload.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
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
 String wfid=Util.null2String(request.getParameter("wfid"));
    String workflowtype="";
	ArrayList returnList=new ArrayList();
	if("root".equals(nodeType)){
		String sql="select id,typename from workflow_type where id in(select workflowtype from workflow_base where formid in(select formid from workflow_base where id='"+wfid+"'))  order by dsporder";
		rs.executeSql(sql);
		//System.out.println("select id,typename from workflow_type where id in(select workflowtype from workflow_base where formid in(select formid from workflow_base where id='"+wfid+"'))  order by dsporder");
		while(rs.next()){
			String typeId=Util.null2String(rs.getString("id"));
			String typeName=Util.null2String(rs.getString("typename"));	
			String sql01="select id,workflowname from workflow_base where (isvalid='1' or isvalid='2')  and id in(select id from workflow_base where formid in(select formid from  workflow_base where id='"+wfid+"'))   and workflowtype='"+typeId+"' order by workflowname ";
			rs1.executeSql(sql01);
			while(rs1.next()){
			  String id=Util.null2String(rs1.getString("id"));
			   if(!id.equals(""+wfid)){
			    DocCatagoryMenuBean dmb = new DocCatagoryMenuBean();
				dmb.setText(""+typeName);
				dmb.setLeaf(false);
				dmb.setId("workflow_"+typeId);
				dmb.setCls("folder");
				dmb.setDraggable(false);
				returnList.add(dmb);
				break;
			   }
			}
		}
	} else if("workflow".equals(nodeType)) {
		if(sqlwhere.equals("")){
		rs.executeSql("select id,workflowname from workflow_base where (isvalid='1' or isvalid='2') and id in(select id from workflow_base where formid in(select formid from workflow_base where id='"+wfid+"')) and workflowtype="+nodeId+" order by workflowname");
		}else{
			//rs.executeSql("select id,workflowname from workflow_base where isvalid=1 and workflowtype="+nodeId+" and formid="+formid+" order by workflowname");
			rs.executeSql("select id,workflowname from workflow_base "+sqlwhere+" and (isvalid='1' or isvalid='2') and id in(select id from workflow_base where formid in(select formid from workflow_base where id='"+wfid+"')) and workflowtype="+nodeId+" order by workflowname");
		}
		while(rs.next()){
			String requestid=Util.null2String(rs.getString("id"));
			String workflowname=Util.null2String(rs.getString("workflowname"));		
        if(!requestid.equals(wfid)){			
			DocCatagoryMenuBean dmb = new DocCatagoryMenuBean();
			dmb.setText(workflowname);
			dmb.setLeaf(true);
			dmb.setId("request_"+requestid);
			dmb.setCls("file");
			dmb.setDraggable(false);
			returnList.add(dmb);
          }
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



