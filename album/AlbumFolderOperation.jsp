
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.album.PhotoSequence" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="p" class="weaver.album.PhotoComInfo" scope="page" />
<%
String sql = "";
int parentId = Util.getIntValue(request.getParameter("parentId"));
String ancestorId = p.getAncestorId(""+parentId);
String operation = Util.null2String(request.getParameter("operation"));
String folderName = Util.null2String(request.getParameter("folderName"));
String photoDescription = Util.null2String(request.getParameter("photoDescription"));
int orderNum = Util.getIntValue(request.getParameter("orderNum"));
if(orderNum>0){
	orderNum = orderNum * -1;
}

if(operation.equals("add")){
	int folderId = PhotoSequence.getInstance().get();
	sql = "INSERT INTO AlbumPhotos (id,parentId,isFolder,subFolderCount,photoName,photoDescription,photoPath,thumbnailPath,subcompanyId,orderNum) VALUES ("+folderId+","+parentId+",'1',0,'"+folderName+"','"+photoDescription+"','/images/xpfolder38_wev8.gif','/images/xpfolder38_wev8.gif',"+ancestorId+","+orderNum+")";
	rs.executeSql(sql);
	sql = "UPDATE AlbumPhotos SET subFolderCount=subFolderCount+1 WHERE id="+parentId+"";
	rs.executeSql(sql);

	//p.addPhotoInfoCache(String.valueOf(folderId));
	p.removePhotoComInfoCache();
	response.sendRedirect("/album/AlbumFolderAdd.jsp?folderid="+folderId+"&isclose=1");
	return;
//=======================================================================
}else if(operation.equals("delete")){


//=======================================================================
}else if(operation.equals("edit")){
	int folderId = Util.getIntValue(request.getParameter("id"));
	sql = "UPDATE AlbumPhotos SET photoName='"+folderName+"',photoDescription='"+photoDescription+"',orderNum="+orderNum+" WHERE id="+folderId+"";
	rs.executeSql(sql);

	p.removePhotoComInfoCache();
	parentId = Util.getIntValue(p.getParentId(""+folderId));
	
	response.sendRedirect("/album/AlbumFolderEdit.jsp?folderid="+folderId+"&isclose=1");
	return;
}

out.print("<script type='text/javascript'>parent.parent.leftframe.document.location.reload();parent.location.href='AlbumList.jsp?paraid="+parentId+"';</script>");
%>