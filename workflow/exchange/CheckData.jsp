<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*,weaver.conn.RecordSet" %>
<%@ page import="weaver.workflow.exchange.DataSourceCols"%>
<%@page import="weaver.workflow.exchange.ExchangeUtil"%>
<%
out.clear();
String type = Util.null2String(request.getParameter("type"));
if(type.equals("checkdbfield")){
	DataSourceCols dsc = new DataSourceCols();
	String datasourceid = Util.null2String(request.getParameter("datasourceid"));
	String tablename = Util.null2String(request.getParameter("tablename"));
	String fieldname = Util.null2String(request.getParameter("fieldname"));
	ArrayList<String> Fieldlist = dsc.getAllColumns(datasourceid, tablename);
	//System.out.println("fieldname = "+fieldname+" datasourceid="+datasourceid+" tablename="+tablename);
	for(String s : Fieldlist){
		if(s.equalsIgnoreCase(fieldname)){
			out.println("1");
			break ;
		}		
	}
}else if(type.equals("checkset")){//检查设置
	String mainid = Util.null2String(request.getParameter("mainid"));
	String fieldid = Util.null2String(request.getParameter("fieldid"));
	String fieldtablename = Util.null2String(request.getParameter("tablename"));
	String changetype = Util.null2String(request.getParameter("changetype"));//1：发送  0：接收
	String tablename = "";
	String fieldname = "";
	if(changetype.equals("0")){
		tablename = "wfec_outdatasetdetail" ;
		fieldname = "wffieldid";
	}else if(changetype.equals("1")){
		tablename = "wfec_indatasetdetail" ;
		fieldname = "outerfieldname";
		if(fieldtablename.indexOf("_dt")!=-1){
			fieldid = fieldtablename+"."+fieldid ;
		}
	}
	//wffieldname,outerfieldname
	RecordSet rs = new RecordSet();
	String sql = "select count(id) from "+tablename+" where mainid="+mainid+" and "+fieldname+"='"+fieldid+"'" ;
	rs.executeSql(sql);
	rs.next();
	int count = rs.getInt(1);
	if(count>0){
		count = 1 ;
		/*
		if(changetype.equals("0")){
			rs.executeSql("select id from "+tablename+" where mainid="+mainid+" and "+fieldname+"='-7'");
			if(rs.getCounts()==0){
				count = 2;
			}
			
		}
		*/
	}
	out.println(count);
}
%>

