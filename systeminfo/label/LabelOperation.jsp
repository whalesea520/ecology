<%@ page import="weaver.general.Util,weaver.general.ExportExcelUtil" %>
<%@ page import="java.util.*,java.io.*,weaver.file.FileDownload" %>
<%@ page import="java.net.URLEncoder" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="LabelComInfo" class="weaver.systeminfo.label.LabelComInfo" scope="page"/>
<jsp:useBean id="systemEnv" class="weaver.systeminfo.SystemEnv" scope="page"/>
<jsp:useBean id="expExcel" class="weaver.general.ExportExcelUtil" scope="page"/>
<%
 char separator = Util.getSeparator() ;
  String operation = Util.null2String(request.getParameter("operation"));
  //搜索操作
  if(operation.equalsIgnoreCase("search")||operation.equalsIgnoreCase("onFirst")||operation.equalsIgnoreCase("onPrev")||operation.equalsIgnoreCase("onNext")||operation.equalsIgnoreCase("onLast")){
    String searchcon=request.getParameter("searchcon");
	searchcon=URLEncoder.encode(searchcon);//用response.sendRedirect来传递需要转码接收方需要解码
	String labelId=request.getParameter("labelId");
	int pageNum=Util.getIntValue(request.getParameter("pageNum"));	
    if (operation.equalsIgnoreCase("search")) pageNum=1;

response.sendRedirect("ManageLabel.jsp?searchcon="+searchcon+"&labelId="+labelId+"&pageNum="+pageNum);
    return ;
  }
//添加操作
    else if(operation.equalsIgnoreCase("addlabel")){ 
  	rs.executeSql("select * from syslanguage  where activable=1");
  	String indexdesc = Util.null2String(request.getParameter("indexdesc"));
  	systemEnv.setUser(user);
  	systemEnv.setClientAddress(request.getRemoteAddr());
  	Map<String,String> nameMap = new HashMap<String,String>();
  	while(rs.next()){
  		nameMap.put(rs.getString("id"),Util.null2String(request.getParameter("name_"+rs.getString("id"))));
  	}
  	//String msg = systemEnv.getHtmlLabelId(indexdesc,-1,cname,ename,twname);
  	String msg = systemEnv.getHtmlLabelId(indexdesc,-1,nameMap);
  	systemEnv.setUser(user);
  	if(msg.equals("error")){
    	response.sendRedirect("AddLabel.jsp?error=1");
  	}else{
  		response.sendRedirect("AddLabel.jsp?isclose=1");
  	}
  	return ;	
 }else if(operation.equalsIgnoreCase("export")){
 	//导出标签
 	String indexdesc = Util.null2String(request.getParameter("indexdesc"));
	String id = Util.null2String(request.getParameter("id"));
	List<String> languageids = new ArrayList<String>();
	String langids = "";
	rs.executeSql("select * from syslanguage where activable=1 order by id asc");
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
	
	String sql = "select t2.indexdesc,t1.* from HtmlLabelInfo t1,HtmlLabelIndex t2 where t1.indexid = t2.id and languageid in ("+langids+")";
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
		data.put(""+rs.getInt("languageid"),Util.null2String(rs.getString("labelname")));
		lastIndexId = indexId;
		curIdx++;
	}
	//System.out.println(datas);
	String fileName = expExcel.exportExcel(heads,datas,languageids,"Label_");
	response.sendRedirect("/filesystem/downloadBatch/"+fileName);
	//FileDownload fd = new FileDownload();
	//fd.toUpload(response,fileName);
	//fd.deleteFile(ExportExcelUtil.filePath+fileName);
	
 	
 //删除操作
 }else if(operation.equalsIgnoreCase("deletelabel")){
 	String[] delete_label_id=request.getParameterValues("delete_label_id");
 	if (delete_label_id!=null){
 	
	 for(int i = 0; i < delete_label_id.length; i++){
  	String deleteSql1="delete from HtmlLabelIndex where id=" + delete_label_id[i];
  	String deleteSql2="delete from HtmlLabelInfo where indexid=" + delete_label_id[i];
        rs.executeSql(deleteSql1);
        rs.executeSql(deleteSql2);
        LabelComInfo.removeLabeInfoCache(delete_label_id[i]);
             }}
  	response.sendRedirect("ManageLabel.jsp");
  	return ;

 }
 //修改--采用先删后加的形式
 else if(operation.equalsIgnoreCase("editLabel")){ 
	int id = Util.getIntValue(request.getParameter("id"),-1);
	String indexdesc = Util.null2String(request.getParameter("indexdesc"));
  	rs.executeSql("select * from syslanguage  where activable=1");
  	systemEnv.setUser(user);
  	systemEnv.setClientAddress(request.getRemoteAddr());
  	Map<String,String> nameMap = new HashMap<String,String>();
  	while(rs.next()){
  		nameMap.put(rs.getString("id"),Util.null2String(request.getParameter("name_"+rs.getString("id"))));
  	}
  	//String msg = systemEnv.getHtmlLabelId(indexdesc,id,cname,ename,twname);
  	String msg = systemEnv.getHtmlLabelId(indexdesc,id,nameMap);
  	if(msg.equals("error")){
  		response.sendRedirect("/systeminfo/label/EditLabel.jsp?id="+id+"&error=1");
  	}else{
 		response.sendRedirect("/systeminfo/label/EditLabel.jsp?isclose=1&id="+msg);
  	}
 }else{
 	//导入标签
 	String[] allowTypes = {".xls"};
 	expExcel.setUser(user);
 	String file = expExcel.uploadFile(request,allowTypes);
 	if(file==null){
 		response.sendRedirect("/systeminfo/label/importLabel.jsp?message=error&hasTab=1");
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
 			response.sendRedirect("/systeminfo/label/importLabel.jsp?message=error&hasTab=1");
 		}else{
 			//System.out.println(datas);
 			systemEnv.setUser(user);
 			systemEnv.setClientAddress(request.getRemoteAddr());
 			systemEnv.updateLabelBatch(datas);
 			response.sendRedirect("/systeminfo/label/importLabel.jsp?message=success&hasTab=1");
 		}
 	}
 }
%>