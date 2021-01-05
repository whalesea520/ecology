
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.parseBrowser.SapBrowserComInfo"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
if(!HrmUserVarify.checkUserRight("SAPDataAuthSetting:Manage",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

String operation = Util.null2String(request.getParameter("operation"));
int settingid = Util.getIntValue(request.getParameter("settingid"),0);

if(operation.equals("baseset")){
	String name = Util.null2String(request.getParameter("name"));
	String[] browserids = request.getParameterValues("sapbrowserid");
	String[] sources = request.getParameterValues("sources");
	String resourcetype = Util.null2String(request.getParameter("resourcetype"));
	String resourceid = Util.null2String(request.getParameter("resourceid"));
	String roleid = Util.null2String(request.getParameter("roleid"));
	String wfid = Util.null2String(request.getParameter("wfid"));
	
	if(resourcetype.equals("0")){
		roleid = "";
	}else if(resourcetype.equals("1")){
		resourceid = "";
	}
	
	String browseridstr = "";
	if(browserids != null){
		for(int i = 0; i<browserids.length; i++){
			browseridstr += browserids[i] + ",";
		}
		if(browseridstr.length() > 0){
			browseridstr = browseridstr.substring(0,browseridstr.length()-1);
		}
	}
	String sourcestr = "";
	if(sources != null){
		for(int i = 0; i<sources.length; i++){
			sourcestr += sources[i] + ",";
		}
		if(sourcestr.length() > 0){
			sourcestr = sourcestr.substring(0,sourcestr.length()-1);
		}
	}
	
	if(settingid == 0){
		String sql = "insert into SAPData_Auth_setting (name,browserids,resourcetype,resourceids,roleids,wfids,sources) values ('"+name+"','"+browseridstr+"','"+resourcetype+"','"+resourceid+"','"+roleid+"','"+wfid+"','"+sourcestr+"')";
		rs.execute(sql);
		rs.execute("select max(id) from SAPData_Auth_setting");
		rs.next();
		settingid = rs.getInt(1);
		if(settingid <= 0){
			response.sendRedirect("SAPDataAuthSettingNew.jsp?saveFlag=E");
		}else{
			response.sendRedirect("SAPDataAuthSettingNew.jsp?saveFlag=S&settingid="+settingid);
		}
	}else{
		String sql = "update SAPData_Auth_setting set name='"+name+"',browserids='"+browseridstr+"',resourcetype='"+resourcetype+"',resourceids='"+resourceid+"',roleids='"+roleid+"',wfids='"+wfid+"',sources='"+sourcestr+"' where id="+settingid;
		if(rs.execute(sql)){
			response.sendRedirect("SAPDataAuthSettingNew.jsp?saveFlag=S&settingid="+settingid);
		}else{
			response.sendRedirect("SAPDataAuthSettingNew.jsp?saveFlag=E&settingid="+settingid);
		}
	}
}

if(operation.equals("delete")){
	settingid = Util.getIntValue(request.getParameter("settingid"),0);
	rs.execute("delete from SAPData_Auth_setting where id="+settingid);
	rs.execute("delete from SAPData_Auth_setting_detail where settingid="+settingid);
	response.sendRedirect("SAPDataAuthSetting.jsp");
}

if(operation.equals("savedetail")){
	
	//System.out.println("settingid========" + settingid);
	
	String sapbrowserid = Util.null2String(request.getParameter("sapbrowserid"));
	String filtertype = Util.null2String(request.getParameter("filtertype"));
	List sapcodeList = (List)session.getAttribute("Temp_SAPDataAuthSetting_SAPCodeList_"+settingid+"_"+sapbrowserid);
	if(sapcodeList == null){
		sapcodeList = new ArrayList();
	}
	String sapcodes = Util.null2String(request.getParameter("sapcodes"));
	//System.out.println("sapcode=======" + sapcodes);
	/**
	String[] sapcodearr = Util.TokenizerString2(sapcodes,",");
	for(int i = 0; i<sapcodearr.length; i++){
		if(!sapcodeList.contains(sapcodearr[i])){
			sapcodeList.add(sapcodearr[i]);	
		}
	}**/
	
	rs.execute("delete from SAPData_Auth_setting_detail where settingid='"+settingid + "' and browserid='"+sapbrowserid+"'");
	
	for(int i = 0; i<sapcodeList.size(); i++){
		String tmpsapcode = (String)sapcodeList.get(i);
		String sql = "insert into SAPData_Auth_setting_detail (settingid,filtertype,browserid,sapcode) values ('"+settingid+"','"+filtertype+"','"+sapbrowserid+"','"+tmpsapcode+"')";
		rs.execute(sql);
	}
	session.removeAttribute("Temp_SAPDataAuthSetting_SAPCodeList_"+settingid+"_"+sapbrowserid);
}

if(operation.equals("clear")){
	String sapbrowserid = Util.null2String(request.getParameter("sapbrowserid"));
	rs.execute("delete from SAPData_Auth_setting_detail where settingid='"+settingid + "' and browserid='"+sapbrowserid+"'");
	session.removeAttribute("Temp_SAPDataAuthSetting_SAPCodeList_"+settingid+"_"+sapbrowserid);
}

if(operation.equals("cancel")){
	String sapbrowserid = Util.null2String(request.getParameter("sapbrowserid"));
	session.removeAttribute("Temp_SAPDataAuthSetting_SAPCodeList_"+settingid+"_"+sapbrowserid);
}


%>