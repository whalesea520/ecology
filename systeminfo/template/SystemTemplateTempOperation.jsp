
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
	String templatetype = Util.null2String(request.getParameter("templatetype"));
	int subCompanyId = Util.getIntValue(request.getParameter("subCompanyId"));
	Map topiconmap = (Map)session.getAttribute("topicon_map");
	//System.out.println(method+"====================");
	if(method.equals("update")){
		String tbname = Util.null2String(request.getParameter("tbname"));
		String field = Util.null2String(request.getParameter("field"));
		String value = Util.null2String(request.getParameter("value"));
		if("hpmenuicon".equals(tbname)){
			topiconmap=topiconmap==null?new HashMap():topiconmap;
			String levelid = Util.null2String(request.getParameter("levelid"));
			topiconmap.put(levelid,value);
			session.setAttribute("topicon_map",topiconmap);
		}else{
			String updateSql = "update "+tbname+"Temp set "+field+" = '"+value+"'";
		
			rs.execute(updateSql);
		}

	}else if(method.equals("commit&enable")){
		String id = Util.null2String(request.getParameter("id"));
		doCommitTempDateAndEnable("SystemTemplate",id);
		if(topiconmap!=null&&topiconmap.size()>0){
			doCommitOrUpdateMenuIcon(topiconmap,templatetype,subCompanyId,id);
			session.removeAttribute("topicon_map");
		}
	}else if(method.equals("commit")){
		String id = Util.null2String(request.getParameter("id"));
		doCommitTempDate("SystemTemplate",id);
		if(topiconmap!=null&&topiconmap.size()>0){
			doCommitOrUpdateMenuIcon(topiconmap,templatetype,subCompanyId,id);
			session.removeAttribute("topicon_map");
		}
	}
%>

<%!
	public void doCommitTempDate(String table,String id){
		RecordSet rs = new RecordSet();
		RecordSet rs2 = new RecordSet();
		rs.execute("select * from "+table+"Temp where id="+id);
		String templatetype = "";
		if(rs.next()){
			templatetype = rs.getString("templatetype");
			String commitSql = "update "+table+" set templatename='"+rs.getString("templatename")+"'"
							+",templatetitle='"+rs.getString("templatetitle")+"'"
							+",logo='"+rs.getString("logo")+"'"
							+",logobottom='"+rs.getString("logobottom")+"'"
							+",extendtempletid='"+rs.getString("extendtempletid")+"'"
							+",topbgimage='"+rs.getString("topbgimage")+"'"
							+",toolbarbgimage='"+rs.getString("toolbarbgimage")+"'"
							+",leftbarbgimage='"+rs.getString("leftbarbgimage")+"'"
							+" where id="+id;
			rs2.execute(commitSql);			
		}
		
		if("custom".equals(templatetype)){
			
			rs.execute("select * from extendHpWebCustomTemp where templateId="+id);
			if(rs.next()){
				String commitSql = "update extendHpWebCustom set pagetemplateid='"+rs.getString("pagetemplateid")+"'"
							+",menuid='"+rs.getString("menuid")+"'"
							+",menustyleid='"+rs.getString("menustyleid")+"'"
							+",leftmenuid='"+rs.getString("leftmenuid")+"'"
							+",leftmenustyleid='"+rs.getString("leftmenustyleid")+"'"
							+",defaultshow='"+rs.getString("defaultshow")+"'"
							+",useVoting='"+rs.getString("useVoting")+"'"
							+",useRTX='"+rs.getString("useRTX")+"'"
							+",useWfNote='"+rs.getString("useWfNote")+"'"
							+",useBirthdayNote='"+rs.getString("useBirthdayNote")+"'"
							+",useDoc='"+rs.getString("useDoc")+"'"
						
							+" where templateId="+id;
				rs2.execute(commitSql);	
			}
		}
	}

	public void doCommitTempDateAndEnable(String table,String id){
		RecordSet rs = new RecordSet();
		RecordSet rs2 = new RecordSet();
		rs.execute("select * from "+table+"Temp where id="+id);
		if(rs.next()){
			String commitSql = "update "+table+" set templatename='"+rs.getString("templatename")+"'"
						+",templatetitle='"+rs.getString("templatetitle")+"'"
						+" where id="+id;
			rs2.execute(commitSql);			
			
			rs2.execute("update "+table+" set isopen='0' where isopen='1'");
			rs2.execute("update "+table+" set isopen='1' where id="+id);							
		}
	}
	
	public void doCommitOrUpdateMenuIcon(Map map,String templatetype,int subCompanyId,String templateid){
		RecordSet rs = new RecordSet();
		for (Object key : map.keySet()) {
			
			rs.executeSql("delete from hpmenuicon where templateid="+templateid+" menuid="+key+" and themetype='"+templatetype+"' and subCompanyId="+subCompanyId);
			Object value = map.get(key);
			rs.executeSql("insert into hpmenuicon(templateid,menuid,topicon32,themetype,subCompanyId) values("+templateid+","+key+",'"+value+"','"+templatetype+"',"+subCompanyId+")");
		}
	}

%>