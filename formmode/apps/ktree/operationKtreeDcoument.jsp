<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.general.Util"%>

<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
User user = HrmUserVarify.getUser(request,response);
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
String versionid = Util.null2String(request.getParameter("versionid"));//版本id
String functionid = Util.null2String(request.getParameter("functionid"));//功能id
String tabid = Util.null2String(request.getParameter("tabid"));//标签id
String content = Util.null2String(request.getParameter("content"));//内容
String subject = Util.null2String(request.getParameter("subject"));//标题
String action = Util.null2String(request.getParameter("action"));//action
String digest = Util.null2String(request.getParameter("digest"));//摘要
String documentid = Util.null2String(request.getParameter("documentid"));//文档id
int max_doc_version = 1;
System.out.println(" action:"+action+" versionid:"+versionid);
if(!versionid.equals("")){
	String doc_version_sql="select max(doc_version) from uf_ktree_documentInformality where versionid="+versionid+" and functionid="+functionid+" and tabid="+tabid;
	RecordSet.executeSql(doc_version_sql);
	if(RecordSet.next()){
		max_doc_version = Util.getIntValue(Util.null2String(RecordSet.getInt(1)),0)+1;
	}
}
System.out.println("max_doc_version:"+max_doc_version);
int doc_status = 1;
Date nowDate = new Date();
SimpleDateFormat sdf = new SimpleDateFormat("yyyy年MM月dd日 HH时mm分");
String str_nowDate = sdf.format(nowDate);
String ymd = str_nowDate.substring(0,11);
String hm = str_nowDate.substring(12);
long updatedatetime = nowDate.getTime();
int userid = user.getUID();
if(action.equals("customer_create")){//用户创建申请
	doc_status=3;
	//新添加一个新的文档到历史文档记录表中
	String sql = "insert into uf_ktree_documentInformality "
	+"(versionid,functionid,tabid,subject,content,doc_version,doc_status,"
	+"creator,createdate,createtime,updater,updatedate,updatetime,updatedatetime,digest,opttype)values("
	+versionid+","+functionid+","+tabid+",'"+subject+"','"+content+"',"+max_doc_version+","+doc_status+","
	+userid+",'"+ymd+"','"+hm+"',"
	+userid+",'"+ymd+"','"+hm+"','"
	+updatedatetime+"','"+digest+"',1)";
	RecordSet.execute(sql);
	//转发页面
	String message = URLEncoder.encode("已提交至管理员审核！", "UTF-8");
	response.sendRedirect("/formmode/apps/ktree/viewdocument.jsp?versionid="+versionid+"&functionid="+functionid+"&tabid="+tabid+"&message="+message);
}else if(action.equals("customer_modify")){//用户修改申请
	String sql="select * from uf_ktree_document where id="+documentid;
	RecordSet.executeSql(sql);//查询出当前历史文档
	int creator=0;
	String createdate="";
	String createtime="";
	if(RecordSet.next()){
		creator = RecordSet.getInt("creator");
		createdate = RecordSet.getString("createdate");
		createtime = RecordSet.getString("createtime");
	}
	doc_status=3;
	//新添加一个新的文档到历史文档记录表中
	sql = "insert into uf_ktree_documentInformality "
	+"(versionid,functionid,tabid,subject,content,doc_version,doc_status,"
	+"creator,createdate,createtime,updater,updatedate,updatetime,updatedatetime,digest,opttype)values("
	+versionid+","+functionid+","+tabid+",'"+subject+"','"+content+"',"+max_doc_version+","+doc_status+","
	+creator+",'"+createdate+"','"+createtime+"',"
	+userid+",'"+ymd+"','"+hm+"','"
	+updatedatetime+"','"+digest+"',2)";
	RecordSet.execute(sql);
	//转发页面
	String message = URLEncoder.encode("已提交至管理员审核！", "UTF-8");
	response.sendRedirect("/formmode/apps/ktree/viewdocument.jsp?versionid="+versionid+"&functionid="+functionid+"&tabid="+tabid+"&message="+message);
}else if(action.equals("admin_checkOK")){//审核通过
	String sql="select * from uf_ktree_documentInformality where id="+documentid;
	RecordSet.executeSql(sql);//查询出当前历史文档
	if(RecordSet.next()){
		int new_versionid = RecordSet.getInt("versionid");
		int new_functionid = RecordSet.getInt("functionid");
		int new_tabid = RecordSet.getInt("tabid");
		String new_subject = RecordSet.getString("subject");
		String new_content = RecordSet.getString("content");
		int new_doc_version = RecordSet.getInt("doc_version");
		int new_doc_status = RecordSet.getInt("doc_status");
		new_doc_status = 1;
		int new_creator = RecordSet.getInt("creator");
		String new_createdate = RecordSet.getString("createdate");
		String new_createtime = RecordSet.getString("createtime");
		int new_updater = RecordSet.getInt("updater");
		String new_updatedate = RecordSet.getString("updatedate");
		String new_updatetime = RecordSet.getString("updatetime");
		int new_updatedatetime = RecordSet.getInt("updatedatetime");
		String new_digest = RecordSet.getString("digest");
		int opttype = RecordSet.getInt("opttype");
		sql="update uf_ktree_documentInformality set doc_status=2 where id="+documentid;
		RecordSet.execute(sql);//修改历史文档为已通过
		
		//将历史文档添加到正式文档表中，将原来有效的删除
		sql="delete from uf_ktree_document where versionid="+new_versionid+" and functionid="+new_functionid+" and tabid="+new_tabid;
		RecordSet.execute(sql);//删除原来的正式文档
		//插入新的正式文档
		sql = "insert into uf_ktree_document "
		+"(versionid,functionid,tabid,subject,content,doc_version,doc_status,"
		+"creator,createdate,createtime,updater,updatedate,updatetime,updatedatetime,digest,opttype)values("
		+new_versionid+","+new_functionid+","+new_tabid+",'"+new_subject+"','"+new_content+"',"+new_doc_version+","+new_doc_status+","
		+new_creator+",'"+new_createdate+"','"+new_createtime+"',"
		+new_updater+",'"+new_updatedate+"','"+new_updatetime+"','"
		+new_updatedatetime+"','"+new_digest+"',"+opttype+")";
		RecordSet.execute(sql);
		//文档生成新的修改时间戳
		createUpdateTimeStamp(new_versionid+"", new_functionid+"", new_tabid+"", ymd, hm, updatedatetime);
		//转发页面
		String message = URLEncoder.encode("审核通过！立即生效", "UTF-8");
		response.sendRedirect("/formmode/apps/ktree/viewdocument.jsp?versionid="+new_versionid+"&functionid="+new_functionid+"&tabid="+new_tabid+"&message="+message);
	}
}else if(action.equals("admin_checkNoOk")){//系统管理员审核不通过
	String sql="update uf_ktree_documentInformality set doc_status=4,approver="+userid
	+",approvedate='"+ymd+"',approvetime='"+hm+"' where id="+documentid;
	boolean success = RecordSet.execute(sql);//查询出当前历史文档
	if(success){
		out.println("执行成功");
	}
}else if(action.equals("admin_create")){//系统管理员创建 直接生效
	doc_status=2;
	//新添加一个新的文档到历史文档记录表中
	String sql = "insert into uf_ktree_documentInformality "
	+"(versionid,functionid,tabid,subject,content,doc_version,doc_status,"
	+"creator,createdate,createtime,updater,updatedate,updatetime,updatedatetime,digest,opttype)values("
	+versionid+","+functionid+","+tabid+",'"+subject+"','"+content+"',"+max_doc_version+","+doc_status+","
	+userid+",'"+ymd+"','"+hm+"',"
	+userid+",'"+ymd+"','"+hm+"','"
	+updatedatetime+"','"+digest+"',1)";
	RecordSet.execute(sql);
	
	//将历史文档添加到正式文档表中，将原来有效的删除
	sql="delete from uf_ktree_document where versionid="+versionid+" and functionid="+functionid+" and tabid="+tabid;
	RecordSet.execute(sql);//删除原来的正式文档
	doc_status =1;
	//插入新的正式文档
	sql = "insert into uf_ktree_document "
	+"(versionid,functionid,tabid,subject,content,doc_version,doc_status,"
	+"creator,createdate,createtime,updater,updatedate,updatetime,updatedatetime,digest,opttype)values("
	+versionid+","+functionid+","+tabid+",'"+subject+"','"+content+"',"+max_doc_version+","+doc_status+","
	+userid+",'"+ymd+"','"+hm+"',"
	+userid+",'"+ymd+"','"+hm+"','"
	+updatedatetime+"','"+digest+"',1)";
	RecordSet.execute(sql);
	//文档生成新的修改时间戳
	createUpdateTimeStamp(versionid, functionid, tabid, ymd, hm, updatedatetime);
	
	//转发页面
	String message = URLEncoder.encode("创建成功！立即生效", "UTF-8");
	response.sendRedirect("/formmode/apps/ktree/viewdocument.jsp?versionid="+versionid+"&functionid="+functionid+"&tabid="+tabid+"&message="+message);
}else if(action.equals("admin_modify")){//系统管理员修改 直接生效
	String sql="select * from uf_ktree_document where id="+documentid;
	RecordSet.executeSql(sql);//查询出当前历史文档
	int creator=0;
	String createdate="";
	String createtime="";
	if(RecordSet.next()){
		creator = RecordSet.getInt("creator");
		createdate = RecordSet.getString("createdate");
		createtime = RecordSet.getString("createtime");
	}
	doc_status=2;
	//新添加一个新的文档到历史文档记录表中
	sql = "insert into uf_ktree_documentInformality "
	+"(versionid,functionid,tabid,subject,content,doc_version,doc_status,"
	+"creator,createdate,createtime,updater,updatedate,updatetime,updatedatetime,digest,opttype)values("
	+versionid+","+functionid+","+tabid+",'"+subject+"','"+content+"',"+max_doc_version+","+doc_status+","
	+creator+",'"+createdate+"','"+createtime+"',"
	+userid+",'"+ymd+"','"+hm+"','"
	+updatedatetime+"','"+digest+"',2)";
	RecordSet.execute(sql);
	
	//将历史文档添加到正式文档表中，将原来有效的删除
	sql="delete from uf_ktree_document where versionid="+versionid+" and functionid="+functionid+" and tabid="+tabid;
	RecordSet.execute(sql);//删除原来的正式文档
	doc_status =1;
	//插入新的正式文档
	sql = "insert into uf_ktree_document "
	+"(versionid,functionid,tabid,subject,content,doc_version,doc_status,"
	+"creator,createdate,createtime,updater,updatedate,updatetime,updatedatetime,digest,opttype)values("
	+versionid+","+functionid+","+tabid+",'"+subject+"','"+content+"',"+max_doc_version+","+doc_status+","
	+creator+",'"+createdate+"','"+createtime+"',"
	+userid+",'"+ymd+"','"+hm+"','"
	+updatedatetime+"','"+digest+"',2)";
	RecordSet.execute(sql);
	//文档生成新的修改时间戳
	createUpdateTimeStamp(versionid, functionid, tabid, ymd, hm, updatedatetime);
	//转发页面
	String message = URLEncoder.encode("修改成功！立即生效", "UTF-8");
	response.sendRedirect("/formmode/apps/ktree/viewdocument.jsp?versionid="+versionid+"&functionid="+functionid+"&tabid="+tabid+"&message="+message);
}else if(action.equals("admin_rollback")){//系统管理员 回滚
	String sql="select * from uf_ktree_documentInformality where id="+documentid;
	RecordSet.executeSql(sql);//查询出当前历史文档
	if(RecordSet.next()){
		int new_versionid = RecordSet.getInt("versionid");
		int new_functionid = RecordSet.getInt("functionid");
		int new_tabid = RecordSet.getInt("tabid");
		String new_subject = RecordSet.getString("subject");
		String new_content = RecordSet.getString("content");
		int new_doc_version = RecordSet.getInt("doc_version");
		int new_doc_status = RecordSet.getInt("doc_status");
		new_doc_status = 1;
		int new_creator = RecordSet.getInt("creator");
		String new_createdate = RecordSet.getString("createdate");
		String new_createtime = RecordSet.getString("createtime");
		int new_updater = RecordSet.getInt("updater");
		String new_updatedate = RecordSet.getString("updatedate");
		String new_updatetime = RecordSet.getString("updatetime");
		int new_updatedatetime = RecordSet.getInt("updatedatetime");
		String new_digest = RecordSet.getString("digest");
		int opttype = RecordSet.getInt("opttype");
		sql="update uf_ktree_documentInformality set doc_status=2 where id="+documentid;
		RecordSet.execute(sql);//修改历史文档为已通过
		
		//将历史文档添加到正式文档表中，将原来有效的删除
		sql="delete from uf_ktree_document where versionid="+new_versionid+" and functionid="+new_functionid+" and tabid="+new_tabid;
		RecordSet.execute(sql);//删除原来的正式文档
		//插入新的正式文档
		sql = "insert into uf_ktree_document "
		+"(versionid,functionid,tabid,subject,content,doc_version,doc_status,"
		+"creator,createdate,createtime,updater,updatedate,updatetime,updatedatetime,digest,opttype)values("
		+new_versionid+","+new_functionid+","+new_tabid+",'"+new_subject+"','"+new_content+"',"+new_doc_version+","+new_doc_status+","
		+new_creator+",'"+new_createdate+"','"+new_createtime+"',"
		+new_updater+",'"+new_updatedate+"','"+new_updatetime+"','"
		+new_updatedatetime+"','"+new_digest+"',2)";
		RecordSet.execute(sql);
		//文档生成新的修改时间戳
		createUpdateTimeStamp(new_versionid+"", new_functionid+"", new_tabid+"", ymd, hm, updatedatetime);
		//转发页面
		String message = URLEncoder.encode("回滚成功！", "UTF-8");
		response.sendRedirect("/formmode/apps/ktree/viewdocument.jsp?versionid="+new_versionid+"&functionid="+new_functionid+"&tabid="+new_tabid+"&message="+message);
	}
}
%>
<%!
	public void createUpdateTimeStamp(String versionid,String functionid,String tabid,String ymd,String hm,long updatedatetime){
		RecordSet rs = new RecordSet();
// 		String sql="select pid from uf_ktree_function where id="+functionid;
// 		rs.executeSql(sql);
// 		int functionPid = 0;
// 		if(rs.next()){
// 			functionPid = Util.getIntValue(rs.getInt(1)+"",0);
// 		}
		String sql="select pid from uf_ktree_tabinfo where id="+tabid;
		rs.executeSql(sql);
		int tabPid = 0;
		if(rs.next()){
			tabPid = Util.getIntValue(rs.getInt(1)+"",0);
		}
		//更新二级功能点
		sql="select * from uf_ktree_functionModifyLog where versionid="+versionid+" and functionid="+functionid;
		rs.executeSql(sql);
		if(rs.next()){
			int id = rs.getInt("id");
			sql="update uf_ktree_functionModifyLog set updatedate='"+ymd+"',updatetime='"+hm+"',updatedatetime="+updatedatetime+" where id="+id;
			rs.execute(sql);
		}else{
			sql="insert into uf_ktree_functionModifyLog(versionid,functionid,updatedate,updatetime,updatedatetime)values("
			+versionid+","+functionid+",'"+ymd+"','"+hm+"',"+updatedatetime+")";
			rs.execute(sql);
		}
// 		if(functionPid!=0){
// 			更新一级功能点
// 			sql="select * from uf_ktree_functionModifyLog where versionid="+versionid+" and functionid="+functionPid;
// 			rs.executeSql(sql);
// 			if(rs.next()){
// 				int id = rs.getInt("id");
// 				sql="update uf_ktree_functionModifyLog set updatedate='"+ymd+"',updatetime='"+hm+"',updatedatetime="+updatedatetime+" where id="+id;
// 				rs.execute(sql);
// 			}else{
// 				sql="insert into uf_ktree_functionModifyLog(versionid,functionid,updatedate,updatetime,updatedatetime)values("
// 				+versionid+","+functionPid+",'"+ymd+"','"+hm+"',"+updatedatetime+")";
// 				rs.execute(sql);
// 			}
// 		}
		
		//更新二级标签
		sql="select * from uf_ktree_tabinfoModifyLog where versionid="+versionid+" and functionid="+functionid+" and tabId="+tabid;
		rs.executeSql(sql);
		if(rs.next()){
			int id = rs.getInt("id");
			sql="update uf_ktree_tabinfoModifyLog set updatedate='"+ymd+"',updatetime='"+hm+"',updatedatetime="+updatedatetime+" where id="+id;
			rs.execute(sql);
		}else{
			sql="insert into uf_ktree_tabinfoModifyLog(versionid,functionid,tabId,updatedate,updatetime,updatedatetime)values("
			+versionid+","+functionid+","+tabid+",'"+ymd+"','"+hm+"',"+updatedatetime+")";
			rs.execute(sql);
		}
		if(tabPid!=0){
// 			更新一级标签
			sql="select * from uf_ktree_tabinfoModifyLog where versionid="+versionid+" and functionid="+functionid+" and tabId="+tabPid;
			rs.executeSql(sql);
			if(rs.next()){
				int id = rs.getInt("id");
				sql="update uf_ktree_tabinfoModifyLog set updatedate='"+ymd+"',updatetime='"+hm+"' where id="+id;
				rs.execute(sql);
			}else{
				sql="insert into uf_ktree_tabinfoModifyLog(versionid,functionid,tabId,updatedate,updatetime,updatedatetime)values("
				+versionid+","+functionid+","+tabPid+",'"+ymd+"','"+hm+"',"+updatedatetime+")";
				rs.execute(sql);
			}
		}
	}
%>