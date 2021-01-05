<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="java.net.URLDecoder"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="com.weaver.formmodel.util.DateHelper" %>

<%@ page language="java" contentType="text/html; charset=utf-8" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<%
User user= HrmUserVarify.getUser(request, response);
if(user==null){
	return;
}
int customid = Util.getIntValue(request.getParameter("customid"),0);
int templateid = Util.getIntValue(request.getParameter("templateid"),0);
String method = Util.null2String(request.getParameter("method"));
String sourcetype = Util.null2String(request.getParameter("sourcetype"));//1高级搜索，2普通查询
String tempquerystring = Util.null2String(request.getQueryString()); 
if (tempquerystring.indexOf("&flag") > -1) {
	tempquerystring = tempquerystring.substring(0,tempquerystring.indexOf("&flag"));
}
if ("saveTemplate".equals(method)) {
	String templatename = Util.null2String(request.getParameter("templatename"));
	String templatetype = Util.null2String(request.getParameter("templatetype"));
	String displayorder = Util.null2String(request.getParameter("displayorder"));
	String currentdatetime = DateHelper.getCurDateTime();
	String sql = "insert into mode_TemplateInfo(customid,templatename,templatetype,displayorder,isdefault,sourcetype,createrid,createdate) values("+customid+",'"+templatename+"','"+templatetype+"','"+displayorder+"','0','"+sourcetype+"','"+user.getUID()+"','"+currentdatetime+"')";
	RecordSet.executeSql(sql);
	RecordSet.executeSql("select max(id) as templateid from mode_TemplateInfo where customid='"+customid+"'");
	if (RecordSet.next()) {
		templateid = RecordSet.getInt("templateid");
	}
	response.sendRedirect("/formmode/template/CreateTemplateIframe.jsp?isclose=1&templateid="+templateid);
} else if ("updateTemplate".equals(method)) {
	String templatename = Util.null2String(request.getParameter("templatename"));
	String templatetype = Util.null2String(request.getParameter("templatetype"));
	String displayorder = Util.null2String(request.getParameter("displayorder"));
	String currentdatetime = DateHelper.getCurDateTime();
	String sql = "update mode_TemplateInfo set templatename='"+templatename+"',templatetype='"+templatetype+"',displayorder='"+displayorder+"',createdate='"+currentdatetime+"' where id="+templateid;
	RecordSet.executeSql(sql);
	System.out.println("aaaaa:"+sql);
	response.sendRedirect("/formmode/template/UpdateTemplateIframe.jsp?isclose=1");
} else if ("saveTemplateField".equals(method)) {
	String valuearray = Util.null2String(request.getParameter("valuearray"));
	RecordSet.executeSql("update mode_TemplateDspField set isshow=0 where templateid="+templateid);
	String[] valuearrays = valuearray.split("\\+");
	for (int i = 0 ; i < valuearrays.length ; i++) {
		valuearray = valuearrays[i];
		if (!"".equals(valuearray)) {
			String[] valueObjs = valuearray.split(","); 
			String fieldid = valueObjs[0];
			if (fieldid.indexOf("_") > -1) continue;
			String isshow = valueObjs[1];
			String fieldorder = valueObjs[2];
			RecordSet.executeSql("select 1 from mode_TemplateDspField where fieldid="+fieldid+" and templateid="+templateid);
			if (RecordSet.next()) {
				String sql = "update mode_TemplateDspField set isshow=1,fieldorder="+fieldorder+" where fieldid="+fieldid+" and templateid="+templateid;
				RecordSet.executeSql(sql);
			} else {
				String sql = "insert into mode_TemplateDspField(templateid,fieldid,isshow,fieldorder) values("+templateid+",'"+fieldid+"','1','"+fieldorder+"')";
				RecordSet.executeSql(sql);
			}
		}
	}
	RecordSet.executeSql("delete mode_TemplateDspField where isshow=0 and templateid="+templateid);
	response.sendRedirect("/formmode/template/SetTemplateColumnIframe.jsp?isclose=1");
} else if ("saveTemplateValue".equals(method)) {
	String[] checkcons = request.getParameterValues("check_con");
	String returnType = Util.null2String(request.getParameter("returnType"));//1--高级搜索；2--普通查询；""--保存自定义
	if(checkcons!=null){
		for(int i=0;i<checkcons.length;i++){
			String tmpid = ""+checkcons[i];
			/**String tmpcolname = ""+Util.null2String(request.getParameter("con"+tmpid+"_colname"));
			String htmltype = ""+Util.null2String(request.getParameter("con"+tmpid+"_htmltype"));
			String type = ""+Util.null2String(request.getParameter("con"+tmpid+"_type"));
			String tmpopt = ""+Util.null2String(request.getParameter("con"+tmpid+"_opt"));
			String tmpvalue = ""+Util.null2String(request.getParameter("con"+tmpid+"_value"));
			String tmpname = ""+Util.null2String(request.getParameter("con"+tmpid+"_name"));
			String tmpopt1 = ""+Util.null2String(request.getParameter("con"+tmpid+"_opt1"));
			String tmpvalue1 = ""+Util.null2String(request.getParameter("con"+tmpid+"_value1"));
			int field_viewtype= Util.getIntValue(Util.null2String(request.getParameter("con"+tmpid+"_viewtype")));**/
			String tmpopt = ""+Util.null2String(request.getParameter("con"+tmpid+"_opt"));
			String tmpvalue = ""+Util.null2String(request.getParameter("con"+tmpid+"_value"));
			String tmpname = ""+Util.HTMLtoTxt(request.getParameter("con"+tmpid+"_name"));
			String tmpopt1 = ""+Util.null2String(request.getParameter("con"+tmpid+"_opt1"));
			String tmpvalue1 = ""+Util.null2String(request.getParameter("con"+tmpid+"_value1"));
			String multiselectValue_tmpvalue = Util.null2String(request.getParameter("multiselectValue_con"+tmpid+"_value"));
			if(!"".equals(multiselectValue_tmpvalue)){
				tmpvalue = multiselectValue_tmpvalue;
			}
			
			
			//String sql = "update mode_TemplateDspField set tcolname='"+tmpcolname+"',thtmltype='"+tmpcolname+"',ttype='"+type+"',tviewtype='"+field_viewtype+"',topt='"+tmpopt+"',topt1='"+tmpopt1+"',tvalue='"+tmpvalue+"',tvalue1='"+tmpvalue1+"',tname='"+tmpname+"' " +
			             //" where templateid="+templateid+" and fieldid="+tmpid;
			String sql = "update mode_TemplateDspField set topt='"+tmpopt+"',topt1='"+tmpopt1+"',tvalue='"+tmpvalue+"',tvalue1='"+tmpvalue1+"',tname='"+tmpname+"' " +
			             " where templateid="+templateid+" and fieldid="+tmpid;
			RecordSet.executeSql(sql);
		}
	}
	if ("1".equals(returnType)) {
		response.sendRedirect("/formmode/search/CustomSearchByAdvancedIframe.jsp?customid="+customid+"&templateid="+templateid+"&sourcetype="+sourcetype);
	} else if ("2".equals(returnType)) {
		response.sendRedirect("/formmode/search/CustomSearchBySimpleIframe.jsp?"+tempquerystring+"&flag=true&customid="+customid+"&searchMethod=1&templateid="+templateid+"&sourcetype="+sourcetype);
	} else {
		response.sendRedirect("/formmode/search/CustomSearchByAdvancedSave.jsp?customid="+customid+"&templateid="+templateid+"&sourcetype="+sourcetype);
	}
} else if ("saveTemplateValue2".equals(method)) {
	String[] checkcons = request.getParameterValues("check_con");
	if(checkcons!=null){
		for(int i=0;i<checkcons.length;i++){
			String tmpid = ""+checkcons[i];
			if (tmpid.indexOf("_") > -1) continue;
			/**String tmpcolname = ""+Util.null2String(request.getParameter("con"+tmpid+"_colname"));
			String htmltype = ""+Util.null2String(request.getParameter("con"+tmpid+"_htmltype"));
			String type = ""+Util.null2String(request.getParameter("con"+tmpid+"_type"));
			String tmpopt = ""+Util.null2String(request.getParameter("con"+tmpid+"_opt"));
			String tmpvalue = ""+Util.null2String(request.getParameter("con"+tmpid+"_value"));
			String tmpname = ""+Util.null2String(request.getParameter("con"+tmpid+"_name"));
			String tmpopt1 = ""+Util.null2String(request.getParameter("con"+tmpid+"_opt1"));
			String tmpvalue1 = ""+Util.null2String(request.getParameter("con"+tmpid+"_value1"));
			int field_viewtype= Util.getIntValue(Util.null2String(request.getParameter("con"+tmpid+"_viewtype")));**/
			String tmpopt = ""+Util.null2String(request.getParameter("con"+tmpid+"_opt"));
			String tmpvalue = ""+Util.null2String(request.getParameter("con"+tmpid+"_value"));
			String tmpname = ""+Util.HTMLtoTxt(request.getParameter("con"+tmpid+"_name"));
			String tmpopt1 = ""+Util.null2String(request.getParameter("con"+tmpid+"_opt1"));
			String tmpvalue1 = ""+Util.null2String(request.getParameter("con"+tmpid+"_value1"));
			String multiselectValue_tmpvalue = Util.null2String(request.getParameter("multiselectValue_con"+tmpid+"_value"));
			if(!"".equals(multiselectValue_tmpvalue)){
				tmpvalue = multiselectValue_tmpvalue;
			}
			
			//String sql = "insert into mode_TemplateDspField(templateid,fieldid,isshow,fieldorder,tcolname,thtmltype,ttype,tviewtype,topt,topt1,tvalue,tvalue1,tname) " + 
			             //"values("+templateid+",'"+tmpid+"','1','"+i+"','"+tmpcolname+"','"+htmltype+"','"+type+"','"+field_viewtype+"','"+tmpopt+"','"+tmpopt1+"','"+tmpvalue+"','"+tmpvalue1+"','"+tmpname+"')";
			String sql = "insert into mode_TemplateDspField(templateid,fieldid,isshow,fieldorder,topt,topt1,tvalue,tvalue1,tname) " + 
            "values("+templateid+",'"+tmpid+"','1','"+i+"','"+tmpopt+"','"+tmpopt1+"','"+tmpvalue+"','"+tmpvalue1+"','"+tmpname+"')";
			RecordSet.executeSql(sql);
		}
	}
	if ("1".equals(sourcetype)) { //高级搜索
		response.sendRedirect("/formmode/search/CustomSearchByAdvancedIframe.jsp?customid="+customid+"&templateid="+templateid);
	} else {
		response.sendRedirect("/formmode/search/CustomSearchBySimpleIframe.jsp?"+tempquerystring+"&flag=true&customid="+customid+"&searchMethod=1&templateid="+templateid);
	}
	
} else if ("ondelete".equals(method)) {
	RecordSet.executeSql("delete mode_TemplateInfo where id="+templateid);//删除模板主表
	RecordSet.executeSql("delete mode_TemplateDspField where templateid="+templateid);//删除字段关系模板表
	response.sendRedirect("/formmode/template/TemplateManageIframe.jsp?customid="+customid+"&sourcetype="+sourcetype);
} else if ("setDefault".equals(method)) {
	RecordSet.executeSql("update mode_TemplateInfo set isdefault=0 where customid="+customid+" and sourcetype='"+sourcetype+"' and createrid="+user.getUID());
	RecordSet.executeSql("update mode_TemplateInfo set isdefault=1 where id="+templateid);
	response.sendRedirect("/formmode/template/TemplateManageIframe.jsp?customid="+customid+"&sourcetype="+sourcetype);
}
%>