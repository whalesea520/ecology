<%@page import="weaver.fna.general.FnaSplitPageTransmethod"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.general.*"%>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
	String checkid = Util.null2String(request.getParameter("checkid"));
	String str = "";
	
	//验证
	if(!checkid.equals("")){
		ArrayList list = Util.TokenizerString(checkid, ",");
		if(list!=null && list.size()>0){
			FnaSplitPageTransmethod fnaSplitPageTransmethod = new FnaSplitPageTransmethod();
			for(int i=0;i<list.size();i++){
				String onlyid = (String)list.get(i);
				List resultList = fnaSplitPageTransmethod.getCostCenterViewInner_popedom(onlyid+"", "1");
				boolean allowDel = "true".equals((String)resultList.get(3));
				if(!allowDel){
					str = "1";
					break;
				}
			}
		}
	}
	out.print(str);
%>
