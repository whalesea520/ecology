<%@ page import="weaver.general.Util,weaver.general.ExportExcelUtil" %>
<%@ page import="java.util.*,java.io.*,weaver.file.FileDownload" %>
<%@ page import="java.net.URLEncoder" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ErrorMsgComInfo" class="weaver.systeminfo.errormsg.ErrorMsgComInfo" scope="page"/>
<jsp:useBean id="systemEnv" class="weaver.systeminfo.SystemEnv" scope="page"/>
<jsp:useBean id="expExcel" class="weaver.general.ExportExcelUtil" scope="page"/>
<%
 char separator = Util.getSeparator() ;
  String operation = Util.null2String(request.getParameter("operation"));
  if(operation.equalsIgnoreCase("search")){
    String searchcon=request.getParameter("searchcon");	
    response.sendRedirect("ManageErrorMsg.jsp?searchcon="+searchcon);
  }
  
  //删除操作
  else if(operation.equalsIgnoreCase("deleteerrormsg")){ 
  	String[] delete_errormsg_id=request.getParameterValues("delete_errormsg_id");
	if (delete_errormsg_id!=null){
	
	 for(int i = 0; i < delete_errormsg_id.length; i++){
  	String deleteSql1="delete from ErrorMsgIndex where id=" + delete_errormsg_id[i];
  	String deleteSql2="delete from ErrorMsgInfo where indexid=" + delete_errormsg_id[i];
        rs.executeSql(deleteSql1);
        rs.executeSql(deleteSql2);
        }}
        ErrorMsgComInfo.removeErrorMsgCache();
  	response.sendRedirect("ManageErrorMsg.jsp");
  	return ;
  }
  
  //添加操作
  else if(operation.equalsIgnoreCase("adderrormsg")){ 
  	
	  rs.executeSql("select * from syslanguage  where activable=1 order by id asc");
	String indexdesc = Util.null2String(request.getParameter("indexdesc"));
  	systemEnv.setUser(user);
  	systemEnv.setClientAddress(request.getRemoteAddr());
  	Map<String,String> nameMap = new HashMap<String,String>();
  	while(rs.next()){
  		nameMap.put(rs.getString("id"),Util.null2String(request.getParameter("name_"+rs.getString("id"))));
  	}
  	//String msg = systemEnv.getHtmlNoteId(indexdesc,-1,cname,ename,twname);
  	String msg = systemEnv.getErrorMsgId(indexdesc,-1,nameMap);
  	systemEnv.setUser(user);
	  	if(msg.equals("error")){
	    	response.sendRedirect("AddErrorMsg.jsp?error=1");
	  	}else{
	  		response.sendRedirect("AddErrorMsg.jsp?isclose=1");
	  	}
  	return ;	

 }
//修改操作
 else if(operation.equalsIgnoreCase("editerrormsg")){ 
	 int id = Util.getIntValue(request.getParameter("id"),-1);
		String indexdesc = Util.null2String(request.getParameter("indexdesc"));
  	rs.executeSql("select * from syslanguage  where activable=1");
	  	systemEnv.setUser(user);
	  	systemEnv.setClientAddress(request.getRemoteAddr());
  	Map<String,String> nameMap = new HashMap<String,String>();
  	while(rs.next()){
  		nameMap.put(rs.getString("id"),Util.null2String(request.getParameter("name_"+rs.getString("id"))));
  	}
	  	//String msg = systemEnv.getHtmlNoteId(indexdesc,id,cname,ename,twname);
  	String msg = systemEnv.getErrorMsgId(indexdesc,id,nameMap);
  	if(msg.equals("error")){
  		response.sendRedirect("/systeminfo/errormsg/EditErrorMsg.jsp?id="+id+"&error=1");
  	}else{
 		response.sendRedirect("/systeminfo/errormsg/EditErrorMsg.jsp?isclose=1&id="+msg);
  	}
  }else if(operation.equalsIgnoreCase("export")){
 	//导出提示信息
 	String indexdesc = Util.null2String(request.getParameter("indexdesc"));
	String id = Util.null2String(request.getParameter("id"));
	List<String> languageids = new ArrayList<String>();
	String langids = "";
	rs.executeSql("select * from syslanguage where activable=1 order by id");
	List<String> heads = new ArrayList<String>();
	List<Map<String,String>> datas = new ArrayList<Map<String,String>>();
	heads.add("ID");
	heads.add(SystemEnv.getHtmlLabelName(433,user.getLanguage()));
	languageids.add("ID");
	languageids.add("indexdesc");
	while(rs.next()){
		heads.add(Util.null2String(rs.getString("language")));
		languageids.add(rs.getString("id"));
		if(langids.equals("")){
			langids = ""+rs.getInt("id");
		}else{
			langids += ","+rs.getInt("id");
		}
	}
	
	String sql = "select t2.indexdesc,t1.* from ErrorMsgInfo t1,ErrorMsgIndex t2 where t1.indexid = t2.id and languageid in ("+langids+")";
	if(!id.equals("")){
		sql = sql + " and indexid="+id;
	}
	if(!"".equals(indexdesc)){
		sql = sql + " and indexdesc like '%"+indexdesc+"%'";
	}
	
	sql += "order by indexid desc,languageid asc";
	
	rs.executeSql(sql);
	Map<String,String> data = new TreeMap<String,String>();
	int lastIndexId = -1;
	int curIdx = 0;
	boolean onlyOne = true;
	while(rs.next()){
		int indexId = rs.getInt("indexid");
		//System.out.println(curIdx+"===="+indexId+"======"+lastIndexId+"======="+rs.getCounts());
		if(lastIndexId==-1){
			data.put("ID",""+indexId);
			data.put("indexdesc",Util.null2String(rs.getString("indexdesc")));
		}else if(indexId==lastIndexId){
			if(curIdx==rs.getCounts()-1){
				datas.add(data);
			}
		}else{
			datas.add(data);
			data = new TreeMap<String,String>();
			data.put("ID",""+indexId);
			data.put("indexdesc",Util.null2String(rs.getString("indexdesc")));
			onlyOne = false;
		}
		data.put(""+rs.getInt("languageid"),Util.null2String(rs.getString("msgname")));
		lastIndexId = indexId;
		curIdx++;
	}
	//System.out.println(datas);
	String fileName = expExcel.exportExcel(heads,datas,languageids,"ErrorMsg_");
	response.sendRedirect("/filesystem/downloadBatch/"+fileName);
	//FileDownload fd = new FileDownload();
	//fd.toUpload(response,fileName);
	//fd.deleteFile(ExportExcelUtil.filePath+fileName);
 
 //删除操作
 }else{
 	//导入提示信息
 	String[] allowTypes = {".xls"};
 	expExcel.setUser(user);
 	String file = expExcel.uploadFile(request,allowTypes);
 	if(file==null){
 		response.sendRedirect("/systeminfo/errormsg/importErrorMsg.jsp?message=error&hasTab=1");
 	}else{
 		rs.executeSql("select * from syslanguage where activable=1 order by id");
		List<String> heads = new ArrayList<String>();
		heads.add("ID");
		heads.add("indexdesc");
		while(rs.next()){
			heads.add(Util.null2String(rs.getString("id")));
		}
 		List<Map<String,String>> datas = expExcel.parseExcel(file,true,heads);
 		if(datas==null || datas.size()==0){
 			response.sendRedirect("/systeminfo/errormsg/importErrorMsg.jsp?message=error&hasTab=1");
 		}else{
 			//System.out.println(datas);
 			systemEnv.setUser(user);
 			systemEnv.setClientAddress(request.getRemoteAddr());
 			systemEnv.updateErrorMsgBatch(datas);
 			response.sendRedirect("/systeminfo/errormsg/importErrorMsg.jsp?message=success&hasTab=1");
 		}
 	}
 }
%>
