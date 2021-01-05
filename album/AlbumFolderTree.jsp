
<%@ page language="java" contentType="text/xml; charset=UTF-8" %><%@page import="weaver.general.*,weaver.hrm.*"%><jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" /><?xml version="1.0" encoding="UTF-8"?><tree><%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;

int parentId = Util.getIntValue(request.getParameter("id"));
int id=0, photoCount=0;
String name="", str="";
int subFolderCount = 0;
rs.executeSql("SELECT * FROM AlbumPhotos WHERE isFolder='1' AND parentId="+parentId+"");
while(rs.next()){
	id = rs.getInt("id");
	photoCount = rs.getInt("photoCount");
	if(photoCount>0){
		name = rs.getString("photoName") + "("+ photoCount +")";
	}else{
		name = rs.getString("photoName");
	}
	//add TD29472 增加转义，防止xml出错
	if (!name.equals("") ){
		char c[] = name.toCharArray();
		char ch;
		int j = 0;
		StringBuffer buf = new StringBuffer();
		
		while (j < c.length) {
			ch = c[j++];
		    if (ch == '&'){
		        buf.append("&amp;");
		    }else{
		        buf.append(ch);
		    }
		}
		name = buf.toString();
	}
	//End TD29472
	str += "<tree text=\""+name+"\" action=\"AlbumList.jsp?id="+id+"\" icon=\"/images/xp/folder_wev8.png\" openIcon=\"/images/xp/folder_wev8.png\" ";
	if(rs.getInt("subFolderCount")!=0){
		str += "src=\"AlbumFolderTree.jsp?id="+id+"\" ";
	}
	str += "/>";
}
out.print(str+"</tree>");
%>