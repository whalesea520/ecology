<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.file.FileUpload" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.hrm.*"%>
<%@ page import="weaver.conn.RecordSetTrans"%>
<%@page import="java.util.List"%>
<jsp:useBean id="CusFormSettingComInfo" class="weaver.system.CusFormSettingComInfo" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%
	response.setHeader("cache-control", "no-cache");
	response.setHeader("pragma", "no-cache");
	response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
	//增加登录验证
	User user = HrmUserVarify.getUser (request , response) ;
	if(user==null)return;
	
	FileUpload fu = new FileUpload(request,"utf-8");
	
	String cmd=fu.getParameter("cmd");
	if(cmd.equals("delete")){
		String fileId=Util.null2String(fu.getParameter("fileId"));
		String fieldname=Util.null2String(fu.getParameter("fieldname"));
		int scopeid=Util.getIntValue(fu.getParameter("scopeid"),0);
		String defined_datatable = CusFormSettingComInfo.getCusFormSetting("hrm", scopeid).getDefined_datatable();
		if(fileId.length()>0){
      RecordSetTrans rst = new RecordSetTrans();
			String id = "";
			String fieldvalue = "";
			rs.executeSql("SELECT id,"+fieldname+" as fieldvalue  FROM "+defined_datatable+" WHERE ','+"+fieldname+"+',' LIKE '%,"+fileId+",%' ");
			if(rs.next()){
				id= rs.getString("id");
				fieldvalue= rs.getString("fieldvalue");
			}
			
			List<String> fileids = Util.TokenizerString(fieldvalue,",");
			fileids.remove(fileId);
			String strFileids = "";
			if(fileids.size()>0){
				for(String fileid : fileids){
					if(strFileids.length()>0)strFileids+=",";
					strFileids+=fileid;
				}
			}
			
			try{
      	rst.setAutoCommit(false);
      	rst.executeSql("delete from imagefile where imagefileid="+fileId);
      	
  			rst.executeSql("UPDATE "+defined_datatable+" SET "+fieldname+" ='"+strFileids+"' WHERE id= "+id);
      	rst.commit();
      }catch(Exception e){
      	rst.rollback();
      }  
			out.print(strFileids);
		}
	}
	else if(cmd.equals("save")){
		int docid = Util.getIntValue(fu.uploadFiles("Filedata"), 0);
		out.print(docid);
	}
%>
