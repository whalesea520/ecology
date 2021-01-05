<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.*"%>
<jsp:useBean id="rs_c" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<%
	StaticObj staticobj = StaticObj.getInstance();
	String docsecid = Util.null2String((String)staticobj.getObject("docsecid"));
	if("".equals(docsecid)){
		String sql = "select * from TM_BaseSetting";
		rs_c.executeSql(sql);
		if(rs_c.next()){
			docsecid = Util.null2String(rs_c.getString("docsecid"));  
		}
		staticobj.putObject("docsecid",docsecid);
	}
	boolean canupload = false;
	String subid = "";
	String mainid = "";
	String maxsize = "0";
	if(!docsecid.equals("")&&!docsecid.equals("0")){
		subid = SecCategoryComInfo.getSubCategoryid(docsecid);
		mainid = SubCategoryComInfo.getMainCategoryid(subid);
		rs_c.executeSql("select maxUploadFileSize from DocSecCategory where id=" + docsecid);
		if(rs_c.next()) maxsize = Util.null2String(rs_c.getString(1));
		canupload = true;
	}
%>