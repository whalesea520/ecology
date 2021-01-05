<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="CostcenterComInfo" class="weaver.hrm.company.CostCenterComInfo" scope="page"/>
<jsp:useBean id="CurrencyComInfo" class="weaver.fna.maintenance.CurrencyComInfo" scope="page"/>
<jsp:useBean id="CapitalAssortmentComInfo" class="weaver.cpt.maintenance.CapitalAssortmentComInfo" scope="page"/>
<jsp:useBean id="CapitalStateComInfo" class="weaver.cpt.maintenance.CapitalStateComInfo" scope="page"/>
<jsp:useBean id="CapitalTypeComInfo" class="weaver.cpt.maintenance.CapitalTypeComInfo" scope="page"/>
<jsp:useBean id="AssetUnitComInfo" class="weaver.lgc.maintenance.AssetUnitComInfo" scope="page"/>
<jsp:useBean id="AssetComInfo" class="weaver.lgc.asset.AssetComInfo" scope="page"/>
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
<jsp:useBean id="DepreMethodComInfo" class="weaver.cpt.maintenance.DepreMethodComInfo" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
String name=Util.fromScreen(request.getParameter("name"),user.getLanguage());
String mark=Util.fromScreen(request.getParameter("mark"),user.getLanguage());
String resourceid=Util.fromScreen(request.getParameter("resourceid"),user.getLanguage());
String departmentid=Util.fromScreen(request.getParameter("departmentid"),user.getLanguage());
String capitalgroupid=Util.fromScreen(request.getParameter("capitalgroupid"),user.getLanguage());
String capitalgroupname=Util.fromScreen(request.getParameter("capitalgroupname"),user.getLanguage());
if(departmentid.equals("0"))    departmentid="";
if(capitalgroupid.equals("0"))    capitalgroupid="";
%>
<form action="basedata_cpt.jsp" method="post" name="frmmain">
<div><button class=btnSearch accessKey=S type=submit><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></button></div>
<table class=form>
  <tr>
    <td width="15%"><%=SystemEnv.getHtmlLabelName(1445,user.getLanguage())%></td>
    <td width="35%" class=field>
    <INPUT class=saveHistory type=text name=name style="width:80%" value=<%=name%>>
    </td>
    <td width="15%"><%=SystemEnv.getHtmlLabelName(903,user.getLanguage())%></td>
    <td width="35%" class=field>
    <INPUT class=saveHistory type=text name=mark style="width:80%" value=<%=mark%>>
    </td>
  </tr>
</table>
<table class=form>
  <tr>
    <td width="15%"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></td>
    <td width="20%" class=field><BUTTON class=Browser onClick="onShowDepartment()"></BUTTON> 
    <span id=departmentspan><%=DepartmentComInfo.getDepartmentname(departmentid)%></span> 
    <INPUT class=saveHistory type=hidden name=departmentid value=<%=departmentid%>>
    </td>
    <td width="15%"><%=SystemEnv.getHtmlLabelName(1508,user.getLanguage())%></td>
    <td width="15%" class=field><BUTTON class=Browser onClick="onShowResource()"></BUTTON> 
    <span id=resourcespan><%=ResourceComInfo.getResourcename(resourceid)%></span> 
    <INPUT class=saveHistory type=hidden name=resourceid value=<%=resourceid%>>
    </td>
    <td width="15%"><%=SystemEnv.getHtmlLabelName(831,user.getLanguage())%></td>
    <td width="20%" class=field><button class=Browser onClick="onShowCapitalgroupid()"></button> 
    <span id=capitalgroupidspan><%=capitalgroupname%></span> 
    <input type=hidden name=capitalgroupid value="<%=capitalgroupid%>">
    <input type=hidden name=capitalgroupname value="<%=capitalgroupname%>">
    </td>
  </tr>
</table>
</form>
<script language=vbs>
sub onShowCapitalgroupid()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/cpt/maintenance/CptAssortmentBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	capitalgroupidspan.innerHtml = id(1)
	frmmain.capitalgroupid.value=id(0)
	frmmain.capitalgroupname.value=id(1)
	else
	capitalgroupidspan.innerHtml = ""
	frmmain.capitalgroupid.value=""
	frmmain.capitalgroupname.value=""
	end if
	end if
end sub
sub onShowResource()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	resourcespan.innerHtml = id(1)
	frmmain.resourceid.value=id(0)
	else 
	resourcespan.innerHtml = ""
	frmmain.resourceid.value=""
	end if
	end if
end sub
sub onShowDepartment()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="&frmmain.departmentid.value)
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	departmentspan.innerHtml = id(1)
	frmmain.departmentid.value=id(0)
	else 
	departmentspan.innerHtml = ""
	frmmain.departmentid.value=""
	end if
	end if
end sub
</script>
<BODY>
<DIV class=HdrProps align=center>
 <font size=4><b> 
<br><%=SystemEnv.getHtmlLabelName(15054,user.getLanguage())%><br></b></font>
</DIV>
<%
String sql="select t1.* from CptCapital as t1 where isdata = '2' ";
if(!name.equals(""))
    sql+=" and name like '%"+Util.fromScreen2(name,7)+"%' ";
if(!mark.equals(""))
    sql+=" and mark like '%"+Util.fromScreen2(mark,7)+"%' ";
if(!resourceid.equals(""))
    sql+=" and resourceid ="+resourceid;
if(!capitalgroupid.equals(""))
    sql+=" and (capitalgroupid ="+capitalgroupid+" or capitalgroupid in (select id from CptCapitalAssortment where supassortmentstr like '%|"+capitalgroupid+"|%' )) ";
if(!departmentid.equals(""))
    sql+=" and departmentid ="+departmentid;

sql+=" order by t1.id";

%>
<TABLE class=ListShort border=1>
  <COLGROUP>
  <COL width="15%">
  <COL width="15%">
  <COL width="15%">
  <COL width="15%">
  <COL width="15%">
  <COL width="25%">
  
  <TBODY>
  <TR class=Header>
    <TD><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(904,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(831,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(1508,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
  </TR>
<%
    boolean islight=true ;
    RecordSet.executeSql(sql) ;
    while(RecordSet.next()){
    	String tempid = RecordSet.getString("id");
    	String tempmark = RecordSet.getString("mark");
    	String tempname = RecordSet.getString("name");
    	String tempcapitalspec = RecordSet.getString("capitalspec");
    	String tempcapitalgroupid = RecordSet.getString("capitalgroupid");
    	String tempresourceid = RecordSet.getString("resourceid");
    	String tempdepartmentid = RecordSet.getString("departmentid");
    	String tempstateid =  RecordSet.getString("stateid");
%>
  <TR <%if(islight){%>class=datalight <%} else {%> class=datadark <%}%>>
    <TD><%=Util.toScreen(tempmark,user.getLanguage())%>&nbsp;</TD>
    <TD><%=Util.toScreen(tempname,user.getLanguage())%>&nbsp;</TD>
    <TD><%=Util.toScreen(tempcapitalspec,user.getLanguage())%>&nbsp;</TD>
    <TD><%=Util.toScreen(CapitalAssortmentComInfo.getAssortmentName(tempcapitalgroupid),user.getLanguage())%>&nbsp;</TD>
    <TD><a href="basedata_hrm?resourceid=<%=tempresourceid%>"><%=Util.toScreen(ResourceComInfo.getResourcename(tempresourceid),user.getLanguage())%></a>&nbsp;</TD>
    <TD><%=Util.toScreen(DepartmentComInfo.getDepartmentname(tempdepartmentid),user.getLanguage())%>&nbsp;</TD>
  </TR>
<%	
}
%>  
</TBODY>
</TABLE>
</BODY></HTML>
