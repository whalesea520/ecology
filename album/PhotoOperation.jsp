<%@page import="weaver.conn.RecordSetTrans"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@page import="net.sf.json.JSONObject"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*,java.sql.*,java.io.*" %>
<%@ page import="weaver.general.*,weaver.album.PhotoSequence,weaver.file.FileManage" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs3" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="p" class="weaver.album.PhotoComInfo" scope="page" />
<%
User user=HrmUserVarify.getUser(request, response);
if(user==null){
	out.print("[]");
}

boolean hasPriv = HrmUserVarify.checkUserRight("Album:Maint", user);
if (!hasPriv) {
    response.sendRedirect("/notice/noright.jsp");
    return;
}
JSONObject jsonObject=new JSONObject();

String sql = "";
String id = Util.null2String (request.getParameter("id"));
if(id.startsWith(",")){
	id=id.substring(1);
}
if(id.endsWith (",")){
	id=id.substring(0,id.length()-1);
}

String settype = Util.null2String (request.getParameter("settype"));
String operation = Util.null2String(request.getParameter("operation"));



String realPath = GCONST.getRootPath();
realPath = realPath.substring(0,realPath.length()-1);


if(operation.equals("move")){//移动
	
	int fromsubcomid=0;
	int tosubcomid=0;
	double movedsize=0.0;
	
	int toid = Util.getIntValue(request.getParameter("toid"),0);
	
	String parentsubcom=""+toid;
	if(toid>0){//挂在分部的照片
		tosubcomid=toid;
	}else{
		parentsubcom=p.getAncestorId(""+toid);
		tosubcomid=Util.getIntValue( parentsubcom,0);
	}
	sql=" update AlbumPhotos set parentid="+toid+",subcompanyid='"+parentsubcom+"' where id in("+id+")";
	
	rs.executeSql(sql);
	
	//重算被移动相册数量
	String[] preparedIds=Util.TokenizerString2(id,",");
	for(int i=0;i<preparedIds.length;i++){
		
		if(!"1".equals( p.getIsFolder( preparedIds[i]))){//照片
			
			rs2.executeSql("select photosize from AlbumPhotos where id="+preparedIds[i]);
			if(rs2.next()){
				movedsize+=Util.getDoubleValue(rs2.getString("photosize"),0.0);
			}
			
			int parentId =Util.getIntValue ( p.getParentId(""+preparedIds[i]),0);
			if(parentId>0){//分部
				fromsubcomid=parentId;
			}else{//更新文件夹照片数量
				fromsubcomid=Util.getIntValue( p.getAncestorId(preparedIds[i]),0);
				String folderId=p.getParentId(preparedIds[i]);
				
				String sql1="update AlbumPhotos set photoCount=(select count(id) from AlbumPhotos where parentId="+folderId+" and isFolder<>'1') where id="+folderId;
				rs.executeSql(sql1);
			}
		
		}else{
			rs2.executeSql("select sum(photosize) as totalsize from AlbumPhotos where parentid="+preparedIds[i]);
			if(rs2.next()){
				movedsize+=Util.getDoubleValue(rs2.getString("totalsize"),0.0);
			}
			fromsubcomid=Util.getIntValue( p.getAncestorId(preparedIds[i]),0);
		}
		
		String folderId = p.getAncestorId(""+preparedIds[i]);
	}
	
	//重算移动至相册的数量
	if(toid>0){//分部
	}else if(toid<0){//相册
		String sql2="update AlbumPhotos set photoCount=(select count(id) from AlbumPhotos where parentId="+toid+" and isFolder<>'1') where id="+toid;
		rs2.executeSql(sql2);
	}
		
	//重算分部使用空间
	//System.out.println("fromsubcomid:"+fromsubcomid);
	//System.out.println("tosubcomid:"+tosubcomid);
	
	
	if(fromsubcomid!=tosubcomid&&fromsubcomid>0&&tosubcomid>0){
		RecordSetTrans rst=new RecordSetTrans();
		try{
			rst.setAutoCommit(false);
			String sql31="update AlbumSubcompany set albumSizeUsed=albumSizeUsed+"+movedsize+" where subcompanyid="+tosubcomid;
			String sql32="update AlbumSubcompany set albumSizeUsed=albumSizeUsed-"+movedsize+" where subcompanyid="+fromsubcomid;
			String sql33="update AlbumSubcompany set albumSizeUsed=0  where subcompanyid="+fromsubcomid+" and albumSizeUsed<0";
			rst.executeSql(sql31);
			rst.executeSql(sql32);
			rst.executeSql(sql33);
			rst.commit();
		}catch(Exception e){
			rst.rollback();
		}
	}
	
	p.removePhotoComInfoCache();
	
	out.print(jsonObject.toString());
	
}else if(operation.equals("delete")){
	String subIds = p.getSubIds(""+id);
	subIds = subIds + id;
	if(subIds.endsWith(",")) subIds=subIds.substring(0,subIds.length()-1);

	sql = "DELETE FROM AlbumPhotos WHERE id IN ("+subIds+")";
	rs.executeSql(sql);

	//sqlserver使用触发器
	String parentId = p.getParentId(""+id);
	String ancestorId = p.getAncestorId(""+id);
	if(rs.getDBType().equals("oracle")){
		p.updateCountAndSize(ancestorId, parentId);
	}

	String[] _ids = Util.TokenizerString2(subIds, ",");
	for(int i=0;i<_ids.length;i++){
		id = _ids[i];
		if(!p.getPhotoPath(""+id).equals("/images/xpfolder38_wev8.gif")){//不删除图片文件夹图标
			if(p.getPhotoPath(""+id).startsWith("/")){
				FileManage.DeleteFile(realPath + File.separator + "album" + File.separator + "UploadFolder" + File.separator + id);	
			}else{
				FileManage.DeleteFile(p.getPhotoPath(""+id));
			}
			FileManage.DeleteFile(realPath + File.separator + "album" + File.separator + "UploadFolder" + File.separator + "thumbnail" + File.separator + id);
		}
	}

	//p.updatePhotoInfoCache(p.getParentId(String.valueOf(id)));
	p.removePhotoComInfoCache();
	if(p.getIsFolder(""+id).equals("1"))	out.print("reloadTree");

//=======================================================================
}else if(operation.equals("edit")){
	String title = Util.null2String(request.getParameter("title"));
	title = Util.toHtml6(title);
	sql = "UPDATE AlbumPhotos SET photoName='"+title+"' WHERE id="+id+"";
	rs.executeSql(sql);

	p.updatePhotoInfoCache(""+id);
	if(p.getIsFolder(""+id).equals("1"))	out.print("reloadTree");

//=======================================================================
}else if(operation.equals("batchdelete")){
	String ancestorId = "";
	String parentId = "";

	String ids = Util.null2String(request.getParameter("ids"));
	String[] _ids = Util.TokenizerString2(ids, ",");
	for(int i=0;i<_ids.length;i++){
		ancestorId = p.getAncestorId(""+_ids[i]);
		parentId = p.getParentId(""+_ids[i]);
		ids += p.getSubIds(_ids[i]);
	}
	if(ids.endsWith(",")) ids=ids.substring(0,ids.length()-1);

	sql = "DELETE FROM AlbumPhotos WHERE id IN ("+ids+")";
	rs.executeSql(sql);

	//sqlserver使用触发器
	if(rs.getDBType().equals("oracle")){
		p.updateCountAndSize(ancestorId, parentId);
	}

	String[] idArray = Util.TokenizerString2(ids, ",");
	for(int i=0;i<idArray.length;i++){
		if(!p.getPhotoPath(""+id).equals("/images/xpfolder38_wev8.gif")){//不删除图片文件夹图标
			if(p.getPhotoPath(idArray[i]).startsWith("/")){
				FileManage.DeleteFile(realPath + File.separator + "album" + File.separator + "UploadFolder" + File.separator + idArray[i]);	
			}else{
				FileManage.DeleteFile(p.getPhotoPath(idArray[i]));
			}
			FileManage.DeleteFile(realPath + File.separator + "album" + File.separator + "UploadFolder" + File.separator + "thumbnail" + File.separator + idArray[i]);
		}
	}

	p.removePhotoComInfoCache();

//=======================================================================
}else if(operation.equals("updateAlbumSize")){
	if(!(user.getUID()==1)) {
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}
	double albumSize = Util.getDoubleValue(request.getParameter("albumSize"),0)*1000;
	if("1".equals( settype)){
		sql = "UPDATE AlbumSubcompany SET albumSize="+albumSize+" ";
	}else{
		sql = "UPDATE AlbumSubcompany SET albumSize="+albumSize+" WHERE subcompanyId in("+id+") ";
	}
	
	rs.executeSql(sql);
	out.print( jsonObject.toString() );
	//response.sendRedirect("AlbumSubcompany.jsp?id="+id+"");
}
%>