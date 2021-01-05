
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.email.sequence.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<script type="text/javascript">
<%
String sql = "";
String operation = Util.null2String(request.getParameter("operation"));
String folderName = Util.null2String(request.getParameter("folderName"));
int parentId = Util.getIntValue(request.getParameter("parentId"), 0);
int userId = Util.getIntValue(request.getParameter("userId"));
int id = Util.getIntValue(request.getParameter("id"));
int maxFolderId = 0;

if(operation.equals("folderAdd")){
	int _folderId = MailFolderSequence.getInstance().get();
	sql = "INSERT INTO MailInboxFolder (id, userId, folderName, parentId, subCount) VALUES ("+_folderId+", "+userId+", '"+folderName+"', "+parentId+", 0)";
	rs.executeSql(sql);
	sql = "UPDATE MailInboxFolder SET subCount=subCount+1 WHERE id="+parentId+"";
	rs.executeSql(sql);

	maxFolderId = _folderId;
	out.print("parent.addTreeNode("+maxFolderId+", '"+folderName+"', 'folder');");
}else if(operation.equals("update")){

}else if(operation.equals("default")){

}else if(operation.equals("folderRename")){
	sql = "UPDATE MailInboxFolder SET folderName='"+folderName+"' WHERE id="+id+"";
	rs.executeSql(sql);

	out.print("parent.updateTreeNode('"+folderName+"');");
}else{
	//TODO Recursion
	String folderIds = "";
	folderIds = getInboxFolderTreeNode(id)+id;
	if(folderIds.endsWith(",")) folderIds = folderIds.substring(0, folderIds.length()-1);
	sql = "UPDATE MailResource SET folderId=-3 WHERE folderId IN ("+folderIds+")";
	rs.executeSql(sql);
	sql = "DELETE FROM MailInboxFolder WHERE id IN ("+folderIds+")";
	rs.executeSql(sql);
	return;
}

//out.println(maxFolderId);
%>
</script>

<%!
//=================================================================
// Tree Node Recursion
//=================================================================
String getInboxFolderTreeNode(int parentId){
	weaver.conn.RecordSet rs = new weaver.conn.RecordSet();
	String folderIds = "";
	String sql = "SELECT * FROM MailInboxFolder WHERE parentId="+parentId+" ORDER BY id";
	rs.executeSql(sql);
	while(rs.next()){
		folderIds += rs.getString("id") + ",";
		if(rs.getInt("subCount")!=0){
			folderIds += getInboxFolderTreeNode(rs.getInt("id"));
		}
	}
	return folderIds;
}
%>