<?xml version="1.0" encoding="UTF-8"?>

<%@ page language="java" contentType="text/xml; charset=UTF-8" %>
<%@page import="weaver.hrm.*,weaver.systeminfo.*,weaver.general.*"%>
<jsp:useBean id="rs" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="p" class="weaver.album.PhotoComInfo" scope="page" />
<jsp:useBean id="chk" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<tree>
<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");

User user = HrmUserVarify.getUser(request,response);
if(user == null)  return ;
int userId = user.getUID();
//int[] ids = chk.getSubComByUserEditRightId(userId, "Album:Maint");
int[] ids = chk.getSubComByUserRightId(userId, "Album:Maint");
String parentid = Util.null2String(request.getParameter("id"));
if(parentid.equals("")){
	parentid = "0";
}
String pid="", id="", name="", isFolder="0";
int photoCount = 0;
String str="";

//如果系统未启用分权管理，而当前用户没有相册维护权限，则可查看分部调整为空
RecordSet.executeSql("select detachable from SystemSet");
int detachable=0;
if(RecordSet.next()){
	detachable=RecordSet.getInt("detachable");
}

if(detachable!=1){
	if(!HrmUserVarify.checkUserRight("Album:Maint", user)){
		ids=new int[0];
	}
}

if(ids.length==0){
	id = String.valueOf(user.getUserSubCompany1());
	name = rs.getSubCompanyname(id);
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
	out.print("<tree text=\""+name+"\" action=\"AlbumList.jsp?id="+id+"\" icon=\"/images/treeimages/home16_wev8.gif\" openIcon=\"/images/treeimages/home16_wev8.gif\" src=\"AlbumFolderTree.jsp?id="+id+"\" /></tree>");
	return;
}

String _ids = ",";
for(int i=0;i<ids.length;i++){
	_ids += ids[i] + ",";
}

_ids += ""+user.getUserSubCompany1() + ",";

rs.setTofirstRow();
while(rs.next()){
	pid = rs.getSupsubcomid();
	String cancelstr = rs.getCompanyiscanceled();
	if("1".equals(cancelstr)) continue;
	if(!pid.equals(parentid)) continue;//
	id = rs.getSubCompanyid();
	if(_ids.indexOf(","+id+",")==-1) continue;//判断机构权限

	name = rs.getSubCompanyname();
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
	str += "<tree text=\""+name+"\" action=\"AlbumList.jsp?id="+id+"\" icon=\"/images/treeimages/home16_wev8.gif\" openIcon=\"/images/treeimages/home16_wev8.gif\" ";
	if(!rs.getSubCompanyTreeStr(id).equals("")){
		str += "src=\"AlbumMenuTree.jsp?id="+id+"\" ";
	}else{
		if(!p.getSubIds(id).equals("")){
			str += "src=\"AlbumMenuTree.jsp?id="+id+"\" ";
		}
	}
	str += "/>";
}

//System.out.println("str1:\n"+str);

p.setTofirstRow();
while(p.next()){
	pid = p.getParentId();
	if(!pid.equals(parentid) || !p.getIsFolder().equals("1")) continue;//
	id = p.getId();
	photoCount = Util.getIntValue(p.getPhotoCount());
	name = p.getPhotoName();
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
	if(photoCount>0){
		name = name + "(" + photoCount + ")";
	}
	str += "<tree text=\""+name+"\" action=\"AlbumList.jsp?id="+id+"\" icon=\"/images/xp/folder_wev8.png\" openIcon=\"/images/xp/folder_wev8.png\" ";
	if(!p.getSubFolderIds(id).equals("")){
		str += "src=\"AlbumMenuTree.jsp?id="+id+"\" ";
	}
	str += "/>";
}

//System.out.println("str2:\n"+str);

out.print(str+"</tree>");
%>