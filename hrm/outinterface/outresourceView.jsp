<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentVirtualComInfo" class="weaver.hrm.companyvirtual.DepartmentVirtualComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%
String id = request.getParameter("id");
%>
<html>
<head>
  <LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
  <SCRIPT language="javascript" src="/js/checkinput_wev8.js"></script>
  <SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
  <script type="text/javascript">
  function edit(){
		window.location.href="/hrm/outinterface/outresourceEdit.jsp?id=<%=id%>";
	}
  </script>
</head>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(93,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(61,user.getLanguage())+SystemEnv.getHtmlLabelName(87,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",javascript:edit();,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type=button class="e8_btn_top" onclick="edit();" value="<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>"></input>
		  <span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<%
  String sql = "";
	String customid = "";
  sql = " select a.lastname,a.loginid,c.departmentid,a.mobile,a.email,a.seclevel,b.wxname,"+ 
  			"	b.wxopenid,b.wxuuid,b.country,b.province,b.city,b.customid,b.customfrom,isoutmanager " +
  			" from HrmResource a, hrmresourceout b, HrmResourceVirtual c " +
  			" WHERE a.id=b.resourceid AND a.id=c.resourceid and a.id = "+Util.getIntValue(id,-1);
  String lastname = "";
  rs.executeSql(sql);
  if(rs.next()){
    lastname = Util.null2String(rs.getString("lastname"));
    lastname = lastname.endsWith("\\")&&!lastname.endsWith("\\\\") == true ? lastname+ "\\" :lastname;
    String loginid = Util.null2String(rs.getString("loginid"));
    String password = Util.null2String(rs.getString("password"));
    String seclevel = Util.null2String(rs.getString("seclevel"));
    String isoutmanager = Util.null2String(rs.getString("isoutmanager"));
		String departmentid = Util.null2String(rs.getString("departmentid"));
    String mobile = Util.null2String(rs.getString("mobile"));
    String email = Util.null2String(rs.getString("email"));
		String wxname = Util.null2String(rs.getString("wxname"));
    String wxopenid = Util.null2String(rs.getString("wxopenid"));
    String wxuuid = Util.null2String(rs.getString("wxuuid"));
		String country = Util.null2String(rs.getString("country"));
		String province = Util.null2String(rs.getString("province"));
    String city = Util.null2String(rs.getString("city"));
    customid = Util.null2String(rs.getString("customid"));
    String customfrom = Util.null2String(rs.getString("customfrom"));
%>
	<wea:layout type="2col" attributes="{'expandAllGroup':'true'}">     
	<wea:group context="<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>">
		<wea:item><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></wea:item>
		<wea:item><%=lastname%></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></wea:item>
		<wea:item><%=DepartmentVirtualComInfo.getDepartmentname(departmentid)%></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(620,user.getLanguage())%></wea:item>
		<wea:item><%=mobile%></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(477,user.getLanguage())%></wea:item>
		<wea:item><%=email%></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(125933,user.getLanguage())%></wea:item>
		<wea:item><%=wxname%></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(125934,user.getLanguage())%>OpenId</wea:item>
		<wea:item><%=wxopenid%></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(125934,user.getLanguage())%>UUID</wea:item>
		<wea:item><%=wxuuid%></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(125935,user.getLanguage())%></wea:item>
		<wea:item><%=country%></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(125936,user.getLanguage())%></wea:item>
		<wea:item><%=province%></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(125937,user.getLanguage())%></wea:item>
		<wea:item><%=city%></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(25542,user.getLanguage())%></wea:item>
		<wea:item><%=customfrom%></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(27382,user.getLanguage())%></wea:item>
		<wea:item><%=CustomerInfoComInfo.getCustomerInfoname(customid)%></wea:item>
	</wea:group>
	<wea:group context="<%=SystemEnv.getHtmlLabelName(15804,user.getLanguage())%>">
		<wea:item><%=SystemEnv.getHtmlLabelName(412,user.getLanguage())%></wea:item>
		<wea:item><%=loginid%></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></wea:item>
		<wea:item><%=seclevel %></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(125939,user.getLanguage())%></wea:item>
		<wea:item><%=isoutmanager.equals("1")?"是":"否" %></wea:item>
	</wea:group>
	</wea:layout>
<%} %>
</body>
</html>