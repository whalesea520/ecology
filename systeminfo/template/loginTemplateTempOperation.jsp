
<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="java.security.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.conn.RecordSet" %>

<%@ page import="org.apache.commons.fileupload.*" %>

<%@ include file="/page/maint/common/initNoCache.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<%
	String method = Util.null2String(request.getParameter("method"));
	if(method.equals("update")){
		String tbname = Util.null2String(request.getParameter("tbname"));
		String field = Util.null2String(request.getParameter("field"));
		String value = Util.null2String(request.getParameter("value"));
		
		String updateSql = "update "+tbname+"Temp set "+field+" = '"+value+"'";
		rs.execute(updateSql);

	}else if(method.equals("commit&enable")){
		String id = Util.null2String(request.getParameter("loginTemplateId"));
		doCommitTempDateAndEnable("SystemLoginTemplate",id);
	}else if(method.equals("commit")){
		String id = Util.null2String(request.getParameter("loginTemplateId"));
		doCommitTempDate("SystemLoginTemplate",id);
	}else if(method.equals("delete")){
		String id = Util.null2String(request.getParameter("loginTemplateId"));
		//doCommitTempDate("SystemLoginTemplate",id);
		String updateSql = "delete from  SystemLoginTemplate where logintemplateid="+id;
		rs.execute(updateSql);
		
		
	}
%>

<%!
	public void doCommitTempDate(String table,String id){
		RecordSet rs = new RecordSet();
		RecordSet rs2 = new RecordSet();
		rs.execute("select * from "+table+"Temp where logintemplateid="+id);
		if(rs.next()){
			String commitSql = "update "+table+" set logintemplatename='"+rs.getString("logintemplatename")+"'"
							+",logintemplatetitle='"+rs.getString("logintemplatetitle")+"'"
							+",templatetype='"+rs.getString("templatetype")+"'"
							+",imageid='"+rs.getString("imageid")+"'"
							+",modeid='"+rs.getString("modeid")+"'"
							+",imageid2='"+rs.getString("imageid2")+"'"
							+",menuId='"+rs.getString("menuId")+"'"
							+",menuType='"+rs.getString("menuType")+"'"
							+",menuTypeId='"+rs.getString("menuTypeId")+"'"
							+",defaultshow='"+rs.getString("defaultshow")+"'"
							+",leftmenuid='"+rs.getString("leftmenuid")+"'"
							+",leftmenustyleid='"+rs.getString("leftmenustyleid")+"'"
							+",lasteditdate='"+TimeUtil.getCurrentDateString()+"'"
							+",domainName='"+rs.getString("domainName")+"'"
							+",recordcode='"+rs.getString("recordcode")+"'"
							+" where logintemplateid="+id;
			rs2.execute(commitSql);			
		}
	}

	public void doCommitTempDateAndEnable(String table,String id){
		RecordSet rs = new RecordSet();
		RecordSet rs2 = new RecordSet();
		rs.execute("select * from "+table+"Temp where logintemplateid="+id);
		if(rs.next()){
			String commitSql = "update "+table+" set logintemplatename='"+rs.getString("logintemplatename")+"'"
							+",logintemplatetitle='"+rs.getString("logintemplatetitle")+"'"
							+",templatetype='"+rs.getString("templatetype")+"'"
							+",modeid='"+rs.getString("modeid")+"'"
							+",imageid='"+rs.getString("imageid")+"'"
							+",imageid2='"+rs.getString("imageid2")+"'"
							+",menuId='"+rs.getString("menuId")+"'"
							+",menuType='"+rs.getString("menuType")+"'"
							+",menuTypeId='"+rs.getString("menuTypeId")+"'"
							+",defaultshow='"+rs.getString("defaultshow")+"'"
							+",leftmenuid='"+rs.getString("leftmenuid")+"'"
							+",leftmenustyleid='"+rs.getString("leftmenustyleid")+"'"
						+",lasteditdate='"+TimeUtil.getCurrentDateString()+"'"
						+",domainName='"+rs.getString("domainName")+"'"
						+",recordcode='"+rs.getString("recordcode")+"'"
						+" where logintemplateid="+id;
			rs2.execute(commitSql);			
			
									
		}
		rs2.execute("update SystemLoginTemplate set iscurrent='0' where iscurrent='1'");
		rs2.execute("update SystemLoginTemplate set iscurrent='1' where logintemplateid="+id);	
	}

%>