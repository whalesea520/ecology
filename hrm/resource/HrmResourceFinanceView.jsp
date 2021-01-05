
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="BankComInfo" class="weaver.hrm.finance.BankComInfo" scope= "page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="SalaryComInfo" class="weaver.hrm.finance.SalaryComInfo" scope="page" />
<jsp:useBean id="HrmListValidate" class="weaver.hrm.resource.HrmListValidate" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<HTML>
<%
//added by hubo,20060113
 String id = Util.null2String(request.getParameter("id"));
boolean isfromtab =  Util.null2String(request.getParameter("isfromtab")).equals("true")?true:true;//169644 因为要保持E7 E8功能一致，就不能区分是不是卡片上的
if(id.equals("")) id=String.valueOf(user.getUID());
Calendar thedate = Calendar.getInstance ();
String yearmonth = Util.add0(thedate.get(thedate.YEAR), 4) +"-"+Util.add0(thedate.get(thedate.MONTH) + 1, 2) ;
 int hrmid = user.getUID();
 int isView = Util.getIntValue(request.getParameter("isView"));
 int departmentid = user.getUserDepartment();

int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
int hrmdetachable=Util.getIntValue(String.valueOf(session.getAttribute("hrmdetachable")),0);
int operatelevel=0;
if(hrmdetachable==1){
    String deptid=ResourceComInfo.getDepartmentID(id);
    String subcompanyid=DepartmentComInfo.getSubcompanyid1(deptid)  ;
	if(subcompanyid == null || subcompanyid.equals("")){
		subcompanyid = "0";
	}
    operatelevel=CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"HrmResourceWelfareEdit:Edit",Integer.parseInt(subcompanyid));
}else{
    if(HrmUserVarify.checkUserRight("HrmResourceWelfareEdit:Edit", user))
        operatelevel=2;
}

 boolean ism = ResourceComInfo.isManager(hrmid,id);
 boolean iss = ResourceComInfo.isSysInfoView(hrmid,id);
 boolean isf = ResourceComInfo.isFinInfoView(hrmid,id);
 boolean isc = ResourceComInfo.isCapInfoView(hrmid,id);
 //boolean iscre = ResourceComInfo.isCreaterOfResource(hrmid,id);
 boolean ishe = (hrmid == Util.getIntValue(id));
 boolean ishr = (HrmUserVarify.checkUserRight("HrmResourceEdit:Edit",user,departmentid));
 boolean ishasF =HrmUserVarify.checkUserRight("HrmResourceWelfareEdit:Edit",user);
 //if(!ishe&&!ishr ){
if(!ishe && operatelevel<=0 ){
    response.sendRedirect("/notice/noright.jsp") ;
    return;
}
 
 if(isfromtab&&!HrmListValidate.isValidate(13)){
   response.sendRedirect("/notice/noright.jsp") ;
   return;
 }
 
 String sqlstatus = "select status from HrmResource where id = "+id;
rs.executeSql(sqlstatus);
rs.next();
int status = rs.getInt("status");
int idx =-1;
if(HrmListValidate.isValidate(61)){
	idx=0;
}else{
	if(HrmListValidate.isValidate(62)){
		idx=1;
	}else{
		if(HrmListValidate.isValidate(63)){
 		idx=2;
 	}
	}
}
%>
<HEAD>
  <LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
  <script type="text/javascript">	
	jQuery(document).ready(function(){
		<%if(isfromtab){
			if(idx == 1){
%>
		jQuery("#mytabcontentframe").attr("src","/hrm/HrmTab.jsp?_fromURL=HrmResourceSalaryList&resourceid=<%=id %>&from=psersonalView&isfromtab=true");
<%				
			}else if(idx == 2){
	%>
		jQuery("#mytabcontentframe").attr("src","/hrm/HrmTab.jsp?_fromURL=HrmResourceChangeLog&resourceid=<%=id %>&from=psersonalView&isfromtab=true");	
	<%		
			}else if(idx == 0){
		%>
		jQuery("#mytabcontentframe").attr("src","/hrm/HrmTab.jsp?_fromURL=HrmResourceSalaryLog&resourceid=<%=id %>&from=psersonalView&isfromtab=true");		
		<%	
			}
		%>
		<%}else{%>
		jQuery("#mytabcontentframe").attr("src","/hrm/HrmTab.jsp?_fromURL=HrmResourceSalaryLog&resourceid=<%=id %>&from=psersonalView&isfromtab=false");
		<%}%>
	});
</script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(367,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(189,user.getLanguage())+SystemEnv.getHtmlLabelName(87,user.getLanguage());
String needfav ="1";
String needhelp ="";

%>
<BODY>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
//if(isf&& status!= 10&&operatelevel>0){
if(operatelevel>0){
RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",javascript:edit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
/*
if(ishe||ishr){
RCMenu += "{"+SystemEnv.getHtmlLabelName(19599,user.getLanguage())+",javascript:onChangLog(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(19576,user.getLanguage())+",javascript:onHistory(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}

if(!isfromtab){
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:viewBasicInfo(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

}*/
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<%if(operatelevel>0){ %>
				<input type=button class="e8_btn_top" onclick="edit();" value="<%=SystemEnv.getHtmlLabelName(93, user.getLanguage())%>"></input>
			<%}%>
		  <span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<%if(!isfromtab){ %>
<TABLE class=Shadow>
<%}else{ %>
<TABLE width='100%'>
<%} %>
<tr>
<td valign="top">
<FORM name=resourcefinanceinfo id=resource action="HrmResourceOperation.jsp" method=post enctype="multipart/form-data">
<% 
if(isfromtab&&!HrmListValidate.isValidate(59)){
	
}else{
	if(ishe||ishasF ){ // 财务信息只能本人和人力资源管理员看到 %>
<%
  String sql = "";
  sql = "select bankid1,accountid1,accumfundaccount,accountname from HrmResource where id = "+id;
  rs.executeSql(sql);
  if(rs.next()){
    String bankid1 = Util.null2String(rs.getString("bankid1"));
    String accountid1 = Util.null2String(rs.getString("accountid1"));
    String accumfundaccount = Util.null2String(rs.getString("accumfundaccount"));
    String accountname = Util.null2String(rs.getString("accountname"));
%>
<wea:layout type="2col">
<wea:group context='<%=SystemEnv.getHtmlLabelName(15805,user.getLanguage())%>'>
<wea:item><%=SystemEnv.getHtmlLabelName(83353,user.getLanguage())%></wea:item>
<wea:item><%=accountname%></wea:item>
<wea:item><%=SystemEnv.getHtmlLabelName(15812,user.getLanguage())%></wea:item>
<wea:item><%=BankComInfo.getBankname(bankid1)%></wea:item>
<wea:item><%=SystemEnv.getHtmlLabelName(16016,user.getLanguage())%></wea:item>
<wea:item><%=accountid1%></wea:item>
<wea:item><%=SystemEnv.getHtmlLabelName(16085,user.getLanguage())%></wea:item>
<wea:item><%=accumfundaccount%></wea:item>
</wea:group>
</wea:layout>
<% }%>
<%}}%>
<iframe src="" id="mytabcontentframe" name="mytabcontentframe" class="flowFrame" frameborder="0" height="500px" width="100%"></iframe>
</td>
</tr>
</TABLE>

<script language=javascript>
  function edit(){
    location = "/hrm/resource/HrmResourceFinanceEdit.jsp?isfromtab=<%=isfromtab%>&id=<%=id%>&isView=<%=isView%>";
  }
  function viewBasicInfo(){
    if(<%=isView%> == 0){
      location = "/hrm/employee/EmployeeManage.jsp?hrmid=<%=id%>";
    }else{
      location = "/hrm/resource/HrmResource.jsp?id=<%=id%>";
    }
  }
  function onChangLog(){
    location = "/hrm/resource/HrmResourceChangeLog.jsp?isfromtab=<%=isfromtab%>&id=<%=id%>&isView=<%=isView%>";
  }
  function onHistory(){
    location = "/hrm/resource/HrmResourceSalaryList.jsp?isfromtab=<%=isfromtab%>&id=<%=id%>&isView=<%=isView%>";
  }
  function viewPersonalInfo(){
    location = "/hrm/resource/HrmResourcePersonalView.jsp?id=<%=id%>&isView=<%=isView%>";
  }
  function viewWorkInfo(){
    location = "/hrm/resource/HrmResourceWorkView.jsp?id=<%=id%>&isView=<%=isView%>";
  }
  function viewSystemInfo(){
    location = "/hrm/resource/HrmResourceSystemView.jsp?id=<%=id%>&isView=<%=isView%>";
  }
  function viewCapitalInfo(){
    location = "/cpt/search/CptMyCapital.jsp?id=<%=id%>";
  }
</script>
</BODY>
</HTML>
