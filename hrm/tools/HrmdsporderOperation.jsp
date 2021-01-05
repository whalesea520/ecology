<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="OrganisationCom" class="weaver.rtx.OrganisationCom" scope="page" />

<%
int userid=user.getUID();

String method = request.getParameter("method");
String departmentid = Util.fromScreen(request.getParameter("departmentid"),user.getLanguage()) ;
String subcompanyid1 = Util.fromScreen2(request.getParameter("subcompanyid1"),user.getLanguage());
//String resourcename = Util.null2String(request.getParameter("resourcename")) ;
//if(!resourcename.equals("")) session.setAttribute("resourcenameAAA",resourcename);
if(method.equals("SaveOrder")){
	if(!HrmUserVarify.checkUserRight("Hrmdsporder:Add",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
	String ids=Util.fromScreen(request.getParameter("ids"),user.getLanguage()) ;
	String dsporderdb=Util.fromScreen(request.getParameter("dsporderdb"),user.getLanguage()) ;
	String id = "";
	String dsporderValue = "";
	String dsporderdbValue = "";
	ArrayList idsArray = Util.TokenizerString(ids, ",");
	ArrayList dsporderdbArray = Util.TokenizerString(dsporderdb, ",");
	for(int i=0;i<idsArray.size();i++){
        id = (String)idsArray.get(i);
        dsporderdbValue = (String)dsporderdbArray.get(i);//数据库里面的值
        dsporderValue = Util.null2String(request.getParameter("dsporder_"+id));//页面上的值
	    if(!dsporderdbValue.equals(dsporderValue)){
			String SaveOrdersql =  "update hrmresource set dsporder="+dsporderValue+" where id="+id;
			RecordSet.executeSql(SaveOrdersql) ;
			
				//同步RTX端的用户信息.
				boolean checkrtxuser = OrganisationCom.checkUser(Integer.parseInt(id));//检测用户是否存在
				if(checkrtxuser){   //存在就编辑，不存在就新增
					OrganisationCom.editUser(Integer.parseInt(id));//编辑
				} else {
					OrganisationCom.addUser(Integer.parseInt(id));//新增
				}
	   }
	}
	response.sendRedirect("/hrm/tools/Hrmdsporder.jsp?departmentid="+departmentid+"&subcompanyid1="+subcompanyid1) ;
}
else if(method.equals("Edit")){
	if(!HrmUserVarify.checkUserRight("HrmdsporderEdit:Edit",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
String id=Util.fromScreen(request.getParameter("id"),user.getLanguage()) ;
String dsporder=Util.fromScreen(request.getParameter("dsporder"),user.getLanguage()) ;
String sql="update hrmresource set dsporder="+dsporder+" where id="+id ;
RecordSet.executeSql(sql) ;

//同步RTX端的用户信息.
	boolean checkrtxuser = OrganisationCom.checkUser(Integer.parseInt(id));//检测用户是否存在
	if(checkrtxuser){   //存在就编辑，不存在就新增
		OrganisationCom.editUser(Integer.parseInt(id));//编辑
	} else {
		OrganisationCom.addUser(Integer.parseInt(id));//新增
	}
	out.write("<script>window.opener.location.href='/hrm/tools/Hrmdsporder.jsp';window.close();</script>");
//response.sendRedirect("Hrmdsporder.jsp") ;
}
%>