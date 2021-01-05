<%@page import="net.sf.json.JSONArray"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.TimeUtil" %>
<%@ page import="weaver.formmode.cuspage.cpt.util.Formula" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>

<%
User user=HrmUserVarify.getUser(request, response);
if(user==null){
	return;
}
if(!HrmUserVarify.checkUserRight("Cpt4Mode:DeprecationSettings", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
JSONObject obj=new JSONObject();
String method = Util.null2String (request.getParameter("method"));
String currentDate= TimeUtil.getCurrentDateString();
String currentTime=TimeUtil.getOnlyCurrentTimeString();
if("add".equalsIgnoreCase(method)){
	String deprename=Util.null2String (request.getParameter("deprename"));
	String depremethod=Util.null2String (request.getParameter("depremethod"));
	String sptcount=Util.null2String (request.getParameter("wftype"));
	String isopen=Util.null2String (request.getParameter("isopen"));
	String guid1=UUID.randomUUID().toString();
	String sql=" insert into uf4mode_cptdepreconf(deprename, depremethod, sptcount, isopen, creater, createdate, createtime, guid1,lastmoddate,lastmodtime) "+
	" values('"+deprename+"','"+depremethod+"','"+sptcount+"','"+isopen+"','"+user.getUID()+"','"+currentDate+"','"+currentTime+"','"+guid1+"','"+currentDate+"','"+currentTime+"') ";

	rs.executeSql(sql);
	if("1".equals(isopen)){
		sql="select id from uf4mode_cptdepreconf where guid1='"+guid1+"' ";
		rs.executeSql(sql);
		if(rs.next()){
			String newid=rs.getString("id");
			sql="update uf4mode_cptdepreconf set isopen='0' where sptcount='"+sptcount+"' and id not in("+newid+") ";
			rs.executeSql(sql);
		}
	}

}else if("edit".equalsIgnoreCase(method)){
	String id = Util.null2String (request.getParameter("id"));
	String deprename=Util.null2String (request.getParameter("deprename"));
	String depremethod=Util.null2String (request.getParameter("depremethod"));
	String sptcount=Util.null2String (request.getParameter("wftype"));
	String isopen=Util.null2String (request.getParameter("isopen"));
	String sql=" update uf4mode_cptdepreconf set deprename='"+deprename+"', depremethod='"+depremethod+"', sptcount='"+sptcount+"', isopen='"+isopen+"', lastmoddate='"+currentDate+"',lastmodtime='"+currentTime+"' where id='"+id+"'  ";

	rs.executeSql(sql);
	if("1".equals(isopen)){
		sql="update uf4mode_cptdepreconf set isopen='0' where sptcount='"+sptcount+"' and id not in("+id+") ";
		rs.executeSql(sql);
	}

}else if("toggleuse".equalsIgnoreCase(method)){
	String id = Util.null2String (request.getParameter("id"));
	String isopen = Util.null2String (request.getParameter("isopen"));
	String sql="update uf4mode_cptdepreconf set isopen='"+isopen+"' where id="+id;
	rs.executeSql(sql);
	if("1".equals(isopen)){
		sql="select sptcount from uf4mode_cptdepreconf where id='"+id+"' ";
		rs.executeSql(sql);
		if(rs.next()){
			String sptcount=rs.getString("sptcount");
			sql="update uf4mode_cptdepreconf set isopen='0' where sptcount='"+sptcount+"' and id not in("+id+") ";
			rs.executeSql(sql);
		}
	}
}else if (method.equals("delete")) {
	String ids = Util.null2String(request.getParameter("id"));
	rs.executeSql("delete uf4mode_cptdepreconf where id=" + ids);

}else if (method.equals("batchdelete")) {
	String ids = Util.null2String(request.getParameter("id"));
	String[] arr = Util.TokenizerString2(ids, ",");
	for (int i = 0; i < arr.length; i++) {
		String id1 = "" + Util.getIntValue(arr[i]);
		rs.executeSql("delete uf4mode_cptdepreconf where id=" + id1);
	}
}else if(method.equals("checkformula")){
	String formulastr=Util.null2String(request.getParameter("depremethod"));
	Object[] info= Formula.isValidFormula(formulastr, user);
	if(info!=null&&info.length>=2){
		if(Boolean.getBoolean((String)info[0])==false){
			obj.put("msg",info[1]);
		}
	}

}else if(method.equals("calculate")){
	String msg=Formula.reCalculateCurrentVal(user);
	obj.put("msg",msg);
}
out.println(obj.toString());
%>