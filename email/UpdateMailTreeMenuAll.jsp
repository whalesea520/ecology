
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.*,weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
User user = HrmUserVarify.getUser(request,response);
if(user == null)  return ;
int userId = Util.getIntValue(request.getParameter("userId"));
int unReadMailCount = 0;
int folderId = 0;
String folderName = "";
String sql = "";
String sqlwhere = "";
String treeMenuNodeText = "";

sql = "SELECT COUNT(a.id) AS unReadMailCount,b.id,b.folderName FROM MailInboxFolder b LEFT JOIN MailResource a ON a.folderId=b.id AND a.resourceid="+userId+" AND a.status='0' WHERE b.userId="+userId+" GROUP BY b.id,b.folderName";
sql+= " UNION ";
sql+= "SELECT COUNT(id) AS unReadMailCount,folderId,'' FROM MailResource WHERE resourceid="+userId+" AND status='0' AND folderId IN (0,-1,-2,-3) GROUP BY folderId";
rs.executeSql(sql);
while(rs.next()){
	unReadMailCount = rs.getInt("unReadMailCount");
	folderId = rs.getInt("id");
	if(folderId==0){
		folderName = SystemEnv.getHtmlLabelName(19816,user.getLanguage());
	}else if(folderId==-1){
		folderName = SystemEnv.getHtmlLabelName(2038,user.getLanguage());
	}else if(folderId==-2){
		folderName = SystemEnv.getHtmlLabelName(220,user.getLanguage());
	}else if(folderId==-3){
		folderName = SystemEnv.getHtmlLabelName(19817,user.getLanguage());
	}else{
		folderName = Util.null2String(rs.getString("folderName"));
	}
	if(unReadMailCount==0){
		treeMenuNodeText += folderName;
	}else{
		treeMenuNodeText += folderName + "(" + unReadMailCount + ")";
	}
	treeMenuNodeText += "|" + folderId + "~";
}

if(treeMenuNodeText.indexOf("|-1")==-1){
	treeMenuNodeText += ""+SystemEnv.getHtmlLabelName(2038,user.getLanguage())+"|-1~";
}
if(treeMenuNodeText.indexOf("|-2")==-1){
	treeMenuNodeText += ""+SystemEnv.getHtmlLabelName(220,user.getLanguage())+"|-2~";
}
if(treeMenuNodeText.indexOf("|-3")==-1){
	treeMenuNodeText += ""+SystemEnv.getHtmlLabelName(19817,user.getLanguage())+"|-3~";
}
if(treeMenuNodeText.indexOf("|0")==-1){
	treeMenuNodeText += ""+SystemEnv.getHtmlLabelName(19816,user.getLanguage())+"|0~";
}

out.println(treeMenuNodeText);
%>