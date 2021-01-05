<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.general.StaticObj,
                 weaver.general.Util" %>
<%@ page import="net.sf.json.*,com.sap.mw.jco.JCO" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/> 
<jsp:useBean id="BaseBean" class="weaver.general.BaseBean" scope="page"/> 
<%
	response.setHeader("cache-control", "no-cache");
	response.setHeader("pragma", "no-cache");
	response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
%>
<%
	String uploadExt = Util.null2String(request.getParameter("uploadExt"));
	String secid = Util.null2String(request.getParameter("secid"));
	String picfiletypes=BaseBean.getPropValue("PicFileTypes","PicFileTypes");
        
	boolean flag=false;
	    if(!"".equals(secid)){
	        String sql="select uploadExt from docseccategory where id="+secid;
			flag=rs.executeSql(sql);
			while(rs.next()){
				uploadExt=rs.getString("uploadExt");
			}
			JSONObject jsa = new JSONObject();
			if(flag){
				jsa.accumulate("message", uploadExt);
				jsa.accumulate("property", picfiletypes);
			}else{
				jsa.accumulate("message", "");
			}
			out.print(jsa);
	    }
%>