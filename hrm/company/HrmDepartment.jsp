<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
int companyid = Util.getIntValue(request.getParameter("companyid"),1);
int subcompanyid = Util.getIntValue(request.getParameter("subcompanyid"),0);

//如果不是来自HrmTab页，增加页面跳转
//if(!Util.null2String(request.getParameter("fromHrmTab")).equals("1")){}
String url = "/hrm/HrmTab.jsp?_fromURL=HrmSubCompanyDsp&id="+subcompanyid+"&hasTree=false";
response.sendRedirect(url.toString()) ;
if(1==1)return;


String canceled = "";
rs.executeSql("select canceled from HrmSubCompany where id="+subcompanyid);
if(rs.next()){
 canceled = rs.getString("canceled");
}

Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String nowdate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(140,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(124,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
/*
if(HrmUserVarify.checkUserRight("HrmDepartmentAdd:Add", user) && ("0".equals(canceled) || "".equals(canceled))){
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",/hrm/company/HrmDepartmentAdd.jsp?subcompanyid="+subcompanyid+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}

if(HrmUserVarify.checkUserRight("HrmDepartment:Log", user)){
    if(rs.getDBType().equals("db2")){
        RCMenu += "{"+SystemEnv.getHtmlLabelName(124,user.getLanguage())+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where int(operateitem)="+12+",_self} " ;
    }else{
RCMenu += "{"+SystemEnv.getHtmlLabelName(124,user.getLanguage())+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem="+12+",_self} " ;
    }
RCMenuHeight += RCMenuHeightStep ;
}
*/
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
		  <span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<FORM id=weaver name=frmMain action="HrmDepartment.jsp" method=post>
<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
    <wea:item><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%></wea:item>
    <wea:item>
    <%
    while(CompanyComInfo.next()){
      String companyname = "";
      String curid = CompanyComInfo.getCompanyid();
      if(Util.getIntValue(curid,0)==companyid){
        companyname = CompanyComInfo.getCompanyname();
      }
    %>
       <a href="/hrm/company/HrmCompanyEdit.jsp?id=<%=companyid%>"><%= companyname%></a>
     <%
     }
     %>
    </wea:item>
    <wea:item attributes="{'colspan':'full'}"></wea:item>
	</wea:group>
</wea:layout>
</form>
<% 
int hasshowrow = 0;
%>
<wea:layout type="table" attributes="{'cols':'2','expandAllGroup':'true'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>' attributes="{'groupDisplay':'none'}">
    <wea:item type="thead"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></wea:item>
    <wea:item type="thead"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></wea:item>
<%
    while(SubCompanyComInfo.next()){
    	int isfirst = 1;
    	String tmpcompanyid = SubCompanyComInfo.getCompanyid().trim();
    	if(Util.getIntValue(tmpcompanyid,0)!=companyid) continue;

    	String tmpid = SubCompanyComInfo.getSubCompanyid().trim();
    	if(subcompanyid!=0 && Util.getIntValue(tmpid,0)!=subcompanyid) continue;
        String tmpname = SubCompanyComInfo.getSubCompanyname();
      while(DepartmentComInfo.next()){
      	String cursubcompanyid = "";
      	if(companyid==1)
      		cursubcompanyid = DepartmentComInfo.getSubcompanyid1();

      	if(!tmpid.equals(cursubcompanyid)) continue;


       try{
    	    String caceledstate = "";
	        String caceled = "";
	        rs.executeSql("select canceled from HrmDepartment where id = "+DepartmentComInfo.getDepartmentid());
	        if(rs.next()) caceled = rs.getString("canceled");
	        if("1".equals(caceled))
	        {
	      	   caceledstate = "<span><font color=\"red\">("+SystemEnv.getHtmlLabelName(22205,user.getLanguage())+")</font></span>";
	        }
%>
    <wea:item><a href="/hrm/company/HrmSubCompanyEdit.jsp?id=<%=cursubcompanyid%>"><%=isfirst==1?tmpname:""%></a></wea:item>
    <wea:item><a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=DepartmentComInfo.getDepartmentid()%>"><%=DepartmentComInfo.getDepartmentmark()%></a><%=caceledstate %></wea:item>    
<%isfirst=0;
hasshowrow=1;
      }catch(Exception e){
        rs.writeLog(e.toString());
      }
    }
%>
<%}%>
</wea:group>
</wea:layout>
 <%
if(hasshowrow==0){
%>
<DIV class=HdrProps><font color=red>
<%=SystemEnv.getHtmlNoteName(12,user.getLanguage())%></font>
</DIV>
<%}%>

</BODY></HTML>
