<%@page contentType="text/html; charset=utf-8"%>
<%@page import="java.util.*"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%
	response.setHeader("Pragma", "No-cache");
	response.setHeader("Cache-Control", "no-cache");
	//得到网段策略
	String str="";
	//ArrayList ips=new ArrayList();
	RecordSet rs=new RecordSet();
	String sql="select id,inceptipaddress,endipaddress from HrmnetworkSegStr order by id ";
	rs.executeSql(sql);
	while(rs.next()){
		String inceptipaddress=Util.null2String(rs.getString("inceptipaddress"));
		String endipaddress=Util.null2String(rs.getString("endipaddress"));
		//ips.add(inceptipaddress+"~"+endipaddress);
		String temp=inceptipaddress+"~"+endipaddress;
		str+="<option value='"+temp+"'>"+temp+"</option>";
	}
	out.print(str);
%>
