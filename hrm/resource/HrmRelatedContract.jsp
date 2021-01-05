<%--
	Created By Charoes Huang On May 28,2004

--%>


<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*,weaver.general.Util,weaver.conn.*" %>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="ContractTypeComInfo" class="weaver.hrm.contract.ContractTypeComInfo" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<%
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;
String id = Util.null2String(request.getParameter("id"));
if("".equals(id)) return;

 int hrmid = user.getUID();
 boolean ism = ResourceComInfo.isManager(hrmid,id);

 int departmentid = user.getUserDepartment();
 /*
 boolean iss = ResourceComInfo.isSysInfoView(hrmid,id);
 boolean isf = ResourceComInfo.isFinInfoView(hrmid,id);
 boolean isc = ResourceComInfo.isCapInfoView(hrmid,id);
 boolean iscre = ResourceComInfo.isCreaterOfResource(hrmid,id);
 */
 boolean ishe = (hrmid == Util.getIntValue(id));
 boolean ishr = (HrmUserVarify.checkUserRight("HrmResourceEdit:Edit",user,departmentid));



 if(!(ism || ishe || ishr)) return; //如果不是上级，或本人，或人力资源管理员就不能查看合同信息

String sqlStr = "Select * From HrmContract WHERE ContractMan ="+id;
RecordSet rs = new RecordSet();
rs.executeSql(sqlStr);
%>
<wea:layout type="table" needImportDefaultJsAndCss="false" attributes="{'cols':'4','cws':'16%,16%,16%,52%'}">
<wea:group context="" attributes="{'groupDisplay':'none'}">
		<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(614,user.getLanguage())%></wea:item>
		<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(15775,user.getLanguage())%></wea:item>
		<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(1970,user.getLanguage())%></wea:item>
		<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(15236,user.getLanguage())%></wea:item> 
		  <%while(rs.next()){
			  String contractid = Util.null2String(rs.getString("id"));
				String name  = Util.null2String(rs.getString("contractname"));
				String typeid  = Util.null2String(rs.getString("contracttypeid"));
				String typename = ContractTypeComInfo.getContractTypename(typeid);
				String man  = Util.null2String(rs.getString("contractman"));
				String startdate  = Util.null2String(rs.getString("contractstartdate"));
				String enddate  = Util.null2String(rs.getString("contractenddate"));
			  %>
		  
					<wea:item><a href=javascript:openFullWindowForXtable("/hrm/contract/contract/HrmContractView.jsp?id=<%=contractid%>") target='_self'><%=name%></a></wea:item>
					<wea:item><%=typename%></wea:item>
					<wea:item><%=startdate%></wea:item>
					<wea:item><%=enddate%></wea:item>
		  <%}%>
	</wea:group>
</wea:layout>