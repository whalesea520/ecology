
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.*" %>
<%@ page import="java.util.*,java.sql.Timestamp" %>
<%@ page import="weaver.general.GCONST" %>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@page import="org.json.JSONObject"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
//获取选中的年和月份有多少天
StringBuffer result = new StringBuffer("{");
BaseBean bean=new BaseBean();
User user = HrmUserVarify.getUser (request , response) ;
if(user == null){
}else{
	try{
		String retustr="";
		//2012_53_31/12/2012_6/1/2013_2013-01-07
		String types = Util.null2String(request.getParameter("types"));
		String valuetype = Util.null2String(request.getParameter("valuetype"));
		String valuestr= Util.null2String(request.getParameter("valuestr"));
		
		String jc="";
		String qc="";
		String bh="";
		//System.out.println("==types:"+types);
	    if(types.equals("sub")){
	    	if(valuestr.equals("")){
				valuestr=""+user.getUserSubCompany1();	
			} 
	    	RecordSet.executeSql("select subcompanyname,subcompanydesc,subcompanycode from HrmSubCompanyAllView where id='"+valuestr+"'");
    		if(RecordSet.next()){
    			jc=Util.null2String(RecordSet.getString("subcompanyname"));
    			qc=Util.null2String(RecordSet.getString("subcompanydesc"));
    			bh=Util.null2String(RecordSet.getString("subcompanycode"));
    		}
	    	if(valuetype.equals("0")){//简称
	    		retustr=jc;
	    	}if(valuetype.equals("1")){//全称
	    		retustr=qc;
	    	}if(valuetype.equals("2")){//编号
	    		retustr=bh;
	    	}
	    } 
	    
	    
			    int _cnt=0;
			    result.append("\"data"+_cnt+"\":{");
			    result.append("\"types\":"+JSONObject.quote(Util.null2String(types))+",");
			    result.append("\"retustr\":"+JSONObject.quote(Util.null2String(retustr))+",");
				result.append("\"dbFieldEnd\":0},");
			 
		result.append("\"done\":{\"success\":\"success\",\"info\":\"\"}");
	}catch(Exception e){
		result.append("\"done\":{\"success\":\"failed\",\"info\":\""+e.getMessage()+"\"}");
	}
}
result.append("}");

// System.out.println(result.toString());
%><%=result.toString() %>
