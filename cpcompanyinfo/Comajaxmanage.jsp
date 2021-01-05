
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util,java.sql.Timestamp,java.util.*" %>
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<%@ page import="weaver.hrm.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%	
		
		 String selevalue=Util.null2String(request.getParameter("selevalue"));
		 String tempv[]=selevalue.split(",");
		 List list=new ArrayList();
		 for(int i=0;i<tempv.length;i++)
		 {
		 	list.add(tempv[i]);
		 }
		 String sql="select companyname,companyid,archivenum from CPCOMPANYINFO where isdel='T' and  businesstype != 8  order by companyid,archivenum";
		 StringBuffer sb=new  StringBuffer();
		 sb.append("<?xml version='1.0' encoding='").append(weaver.general.GCONST.XML_UTF8).append("'?>");
		 sb.append("<tree  id='-1'>");
		 sb.append("<item  id='0' text='"+SystemEnv.getHtmlLabelName(1976,user.getLanguage())+"' open='1'  call='1' select='1'>");

		 rs.execute(sql);
		 while(rs.next())
		 {
		 	 if(list.contains(rs.getString("companyid")))
		 	 {
		 	 	sb.append("<item child='0' id='"+rs.getString("companyid")+"' text='"+"["+rs.getString("archivenum")+"]"+rs.getString("companyname")+"' checked='1'></item>");
		 	 }else
		 	 {
		 	 	sb.append("<item child='0' id='"+rs.getString("companyid")+"' text='"+"["+rs.getString("archivenum")+"]"+rs.getString("companyname")+"' ></item>");
		 	 }
		 	 
		 }
		 sb.append(" </item>");
		 sb.append("  </tree>");
		 out.clear();
		 //加了这句话，是这个js控件兼容火狐浏览器了
		 response.setContentType("text/xml");
		 out.println(sb.toString());
	
%>
