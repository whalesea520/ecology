<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.Calendar" %>
<%
	response.setHeader("cache-control", "no-cache");
	response.setHeader("pragma", "no-cache");
	response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
	
	String downloaduid = Util.null2String(request.getHeader("downloaduid"));
	String clientguid = Util.null2String(request.getHeader("clientguid"));
	int isSystemDoc = Util.getIntValue(request.getHeader("isSystemDoc"),0);
	RecordSet rs = new RecordSet();
	if(!downloaduid.isEmpty())
	{
		Calendar today = Calendar.getInstance();
        String lastDate = Util.add0(today.get(Calendar.YEAR), 4) + "-"
                + Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-"
                + Util.add0(today.get(Calendar.DAY_OF_MONTH), 2);
        String lastTime = Util.add0(today.get(Calendar.HOUR_OF_DAY), 2) + ":"
                + Util.add0(today.get(Calendar.MINUTE), 2) + ":" + Util.add0(today.get(Calendar.SECOND), 2);
		
		String sql = "delete DownloadFileTemp where downloadfileguid = '"+downloaduid+"'";
		if(isSystemDoc == 1){
		    sql += " and isSystemDoc=1";
		}else{
		    sql += " and (isSystemDoc=0 or isSystemDoc is null)";
		}
		rs.executeSql(sql);
	}
	response.setHeader("deletestatus","1");
%>