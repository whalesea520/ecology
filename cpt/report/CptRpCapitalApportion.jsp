<%@ page import="weaver.general.Util,weaver.file.*" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="CapitalAssortmentComInfo" class="weaver.cpt.maintenance.CapitalAssortmentComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="AllManagers" class="weaver.hrm.resource.AllManagers" scope="page"/>
<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session"/>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
String userid =""+user.getUID();

/*权限判断,资产管理员以及其所有上级*/
boolean canView = false;
ArrayList allCanView = new ArrayList();
String tempsql = "select resourceid from HrmRoleMembers where roleid = 7 ";
RecordSet.executeSql(tempsql);
while(RecordSet.next()){
	String tempid = RecordSet.getString("resourceid");
	allCanView.add(tempid);
	AllManagers.getAll(tempid);
	while(AllManagers.next()){
		allCanView.add(AllManagers.getManagerID());
	}
}// end while

for (int i=0;i<allCanView.size();i++){
	if(userid.equals((String)allCanView.get(i))){
		canView = true;
	}
}

if(!canView) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
/*权限判断结束*/


String isrefresh = Util.null2String(request.getParameter("isrefresh"));

int TotalCount = Util.getIntValue(request.getParameter("TotalCount"),0);

String sql="";
String capitalid = Util.null2String(request.getParameter("capitalid"));
String sqlwhere1 = Util.null2String(request.getParameter("sqlwhere"));
String departmentid = Util.null2String(request.getParameter("departmentid"));
String resourceid = Util.null2String(request.getParameter("resourceid"));
String stateid = Util.null2String(request.getParameter("stateid"));
String location = Util.null2String(request.getParameter("location"));
String fromdate = Util.null2String(request.getParameter("fromdate"));
String todate = Util.null2String(request.getParameter("todate"));
String capitalgroupid = Util.null2String(request.getParameter("capitalgroupid"));
String counttype = Util.null2String(request.getParameter("counttype"));

//分页相关
//int pagenum=Util.getIntValue(request.getParameter("pagenum"),1);
//int perpage=Util.getIntValue(request.getParameter("perpage"),0);
//if(perpage<=1 )	perpage=10;
//
//String temptable = "cpttemptable"+ Util.getRandom() ;

int ishead = 0 ;

if(! sqlwhere1.equals("")) {
	sql = sqlwhere1 ;
	ishead = 1 ;
}

if(! departmentid.equals("")) {
	if(ishead == 0) {
		sql += " where usedeptid = " + departmentid ;
		ishead = 1;
	}
	else sql += " and usedeptid = " + departmentid ;
}

if(! resourceid.equals("")) {
	if(ishead == 0) {
		sql += " where useresourceid = " + resourceid ;
		ishead = 1;
	}
	else sql += " and useresourceid = " + resourceid ;
}

if(! counttype.equals("0")) {
	if(counttype.equals("3")){
		if(ishead == 0) {
		sql += " where capitalid in (select id from CptCapital where counttype = '1' or counttype = '2') ";
		ishead = 1;
		}
		else sql += " and  capitalid in (select id from CptCapital where counttype = '1' or counttype = '2') ";
	}
	else{
		if(ishead == 0) {
			sql += " where capitalid in (select id from CptCapital where counttype = '" + counttype + "' ) " ;
			ishead = 1;
		}
		else sql += " and capitalid in (select id from CptCapital where counttype = '" + counttype + "' ) " ;
	}
}

if(! capitalgroupid.equals("")&&!capitalgroupid.equals("0")) {
	if(ishead == 0) {
		sql += " where capitalid in (select id from CptCapital where capitalgroupid = "+capitalgroupid+" or capitalgroupid in(select id from CptCapitalAssortment where supassortmentstr like '%|"+capitalgroupid+"|%'))";
		ishead = 1;
	}
	else sql += " and capitalid in (select id from CptCapital where capitalgroupid = "+capitalgroupid+" or capitalgroupid in(select id from CptCapitalAssortment where supassortmentstr like '%|"+capitalgroupid+"|%'))";
}

if(! fromdate.equals("")) {
	if(ishead == 0) {
		sql += " where usedate >= '" + fromdate + "' " ;
		ishead = 1;
	}
	else sql += " and usedate >= '" + fromdate + "' " ;
}

if(! todate.equals("")) {
	if(ishead == 0) {
		sql += " where usedate <= '" + todate + "' " ;
		ishead = 1;
	}
	else sql += " and usedate <= '" + todate + "' " ;
}

if(ishead == 0) {
		sql += " where usestatus = '2' " ;
		ishead = 1;
}
else{
		sql += " and usestatus = '2' " ;
}

String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(1511,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<DIV class=HdrProps></DIV>
<FORM id=weaver name=frmain action="CptRpCapitalApportion.jsp?isrefresh=1" method=post>
<input type="hidden" id=sqlwhere1 name="sqlwhere1" value="<%=xssUtil.put(sqlwhere1)%>">

<BUTTON class=BtnRefresh id=cmdRefresh accessKey=R 
      type="submit" name=cmdRefresh><U>R</U>-<%=SystemEnv.getHtmlLabelName(354,user.getLanguage())%></BUTTON> 
<BUTTON class=BtnLog accessKey=E name=button2 onclick="window.location='/weaver/weaver.file.ExcelOut'"><U>E</U>-Excel</BUTTON>
  <table class=form>
    <colgroup> 
	<col width="7%"> <col width="18%"> <col width="10%"> <col width="25%">
    <col width="7%"> <col width="13%"><col width="7%"><col width="13%">
	<tbody> 
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></td>
      <td class=Field><button class=Browser id=SelectDepartmentID onClick="onShowDepartmentID()"></button> 
        <span id=departmentidspan><%=Util.toScreen(DepartmentComInfo.getDepartmentname(departmentid),user.getLanguage())%></span> 
        <input class=saveHistory id=departmentid type=hidden name=departmentid value="<%=departmentid%>">
      </td>
      <td><%=SystemEnv.getHtmlLabelName(1394,user.getLanguage())%></td>
      <td class=Field><button class=calendar id=SelectDate onClick="gettheDate(fromdate,fromdatespan)"></button>&nbsp; 
        <span id=fromdatespan ><%=fromdate%></span> 
        -&nbsp;&nbsp;<button class=calendar 
      id=SelectDate2 onClick="gettheDate(todate,todatespan)"></button>&nbsp; <span id=todatespan  ><%=todate%></span> 
        <input type="hidden" id=fromdate name="fromdate" value="<%=fromdate%>">
        <input type="hidden" id=todate name="todate" value="<%=todate%>">
      </td>
      <td><%=SystemEnv.getHtmlLabelName(831,user.getLanguage())%></td>
      <td class=Field> <button class=Browser onClick="onShowCapitalgroupid()"></button> 
        <span id=capitalgroupidspan><%=CapitalAssortmentComInfo.getAssortmentName(capitalgroupid)%></span> 
        <input type=hidden name=capitalgroupid value=<%=capitalgroupid%>>
      </td>
      <td><%=SystemEnv.getHtmlLabelName(178,user.getLanguage())%></td>
      <td class=Field> 
        <select class=saveHistory id=counttype name=counttype>
          <option value=0 <% if(counttype.equals("0")){%>selected<%}%>></option>
          <!--option value=3 <% if(counttype.equals("3")){%>selected<%}%>>库存</option-->
          <option value=1 <% if(counttype.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15320,user.getLanguage())%></option>
          <option value=2 <% if(counttype.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15321,user.getLanguage())%></option>
        </select>
      </td>
    </tr>
    </tbody> 
  </table>
<% if(isrefresh.equals("1")){%>
  <table border="1" width=100%>
  <tr>
  	<td>
  <TABLE class=ListShort>
    <COLGROUP> <COL width="12%"> <COL width="15%"> <COL width="13%"> <COL width="12%"> 
    <COL width="12%"> <COL width="12%"> <COL width="12%"> <COL width="12%"> <TBODY> 
<TR class=Section>
    <TH colSpan=9><%=SystemEnv.getHtmlLabelName(1501,user.getLanguage())%></TH></TR>

 <TR class=separator>
    <TD class=Sep1 colSpan=9 ></TD></TR>
  <TR class=Header>
    <TD><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(1378,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(1512,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(1331,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(534,user.getLanguage())%></TD>
  </TR>
 
<%
 ExcelSheet es = new ExcelSheet() ;
 ExcelRow er = es.newExcelRow () ;
 
 er.addStringValue(SystemEnv.getHtmlLabelName(124,user.getLanguage())) ;
 er.addStringValue(SystemEnv.getHtmlLabelName(714,user.getLanguage())) ;
 er.addStringValue(SystemEnv.getHtmlLabelName(195,user.getLanguage())) ;
 er.addStringValue(SystemEnv.getHtmlLabelName(1378,user.getLanguage())+SystemEnv.getHtmlLabelName(97,user.getLanguage())) ;
 er.addStringValue(SystemEnv.getHtmlLabelName(1512,user.getLanguage())) ;
 er.addStringValue(SystemEnv.getHtmlLabelName(1331,user.getLanguage())) ;
 er.addStringValue(SystemEnv.getHtmlLabelName(534,user.getLanguage())) ;
 
 es.addExcelRow(er) ;

//sql = "select top "+(pagenum*perpage+1)+" * into "+temptable+" from CptUseLog "+sql+" order by usedate desc";
//rs.execute(sql);   
//
//rs.executeSql("Select count(id) RecordSetCounts from "+temptable);
//boolean hasNextPage=false;
//int RecordSetCounts = 0;
//if(rs.next()){
//	RecordSetCounts = rs.getInt("RecordSetCounts");
//}
//if(RecordSetCounts>pagenum*perpage){
//	hasNextPage=true;
//}
//String sqltemp="select top "+(RecordSetCounts-(pagenum-1)*perpage)+" * from "+temptable+"  order by usedate";
//rs.executeSql(sqltemp);(被下面的搜索语句代替)

sql = "select * from CptUseLog "+sql+" order by usedeptid,usedate desc";
rs.executeSql(sql);
//out.print(sql);
boolean start = true;
String olddepartmentid = "";
double usecountall = 0;
double usecountdept = 0;
double feeall = 0;
double feedept = 0;
int needchange = 0;
    while(rs.next()){
        int  id = rs.getInt("id");
        String	tempcapitalid=Util.toScreen(rs.getString("capitalid"),user.getLanguage());
        String	usedate=Util.toScreen(rs.getString("usedate"),user.getLanguage());
        String	olddeptid=rs.getString("olddeptid");
		String	usedeptid=rs.getString("usedeptid");
        String  useresourceid = rs.getString("useresourceid");
        String  usestatus = rs.getString("usestatus");
        String  usecount = Util.toScreen(rs.getString("usecount"),user.getLanguage());
        String  useaddress = Util.toScreen(rs.getString("useaddress"),user.getLanguage());
        String  fee = Util.toScreen(rs.getString("fee"),user.getLanguage());
       
       try{
       	
//部门统计
	if(!start) {
		if(!olddepartmentid.equals(usedeptid)){
%>  
	<TR class=datadark>
    <TD></TD>
    <TD></TD>
    <TD></TD>
    <TD></TD>
    <TD><font color=red><%=SystemEnv.getHtmlLabelName(523,user.getLanguage())%></font></TD>
    <TD><font color=red><%=(int)usecountdept%></font></TD>
    <TD><font color=red><%=feedept%></font></TD>
    </TR>

<%		usecountall += usecountdept;
        feeall += feedept;
		usecountdept = 0;
		feedept = 0;
		}
	}
	
	if(needchange ==0){
       		needchange = 1;
%>  

  <TR class=datalight>
  <%
  	}else{
  		needchange=0;
  %><TR class=datadark>
  <%  	}
  %>
      <TD bgcolor="white">
      <% if(!olddepartmentid.equals(usedeptid)){%>
      <%=Util.toScreen(DepartmentComInfo.getDepartmentname(usedeptid),user.getLanguage())%> 
      <%}%>
      </TD>
      <TD><%=Util.toScreen(CapitalComInfo.getMark(tempcapitalid),user.getLanguage())%></TD>
      <TD><A HREF="../capital/CptCapital.jsp?id=<%=""+tempcapitalid%>"><%=Util.toScreen(CapitalComInfo.getCapitalname(tempcapitalid),user.getLanguage())%></A></TD>
      <TD><%=usedate%></TD>
      <TD><%=Util.toScreen(ResourceComInfo.getResourcename(useresourceid),user.getLanguage())%></TD>
      <TD><%=(int)Util.getDoubleValue(usecount,0)%></TD>
       <TD><%=fee%></TD>
    
  </TR>
<%
	er = es.newExcelRow () ;
	if(!olddepartmentid.equals(usedeptid)){
		er.addStringValue(Util.toScreen(DepartmentComInfo.getDepartmentname(usedeptid),user.getLanguage())) ;
	}
	else{
		er.addStringValue("") ;
	}
	er.addStringValue(Util.toScreen(CapitalComInfo.getMark(tempcapitalid),user.getLanguage())) ;
	er.addStringValue(Util.toScreen(CapitalComInfo.getCapitalname(tempcapitalid),user.getLanguage())) ;
	er.addStringValue(usedate) ;
	er.addStringValue(Util.toScreen(ResourceComInfo.getResourcename(useresourceid),user.getLanguage())) ;
	er.addValue(usecount) ;
	er.addValue(fee) ;
	es.addExcelRow(er);
	
//	 if(hasNextPage){
//		totalline+=1;
//		if(totalline>perpage)	break;
//	 }	
		start = false;
		olddepartmentid = usedeptid;
		usecountdept +=Util.getDoubleValue(usecount,0);;
		feedept += Util.getDoubleValue(fee,0);
	   }catch(Exception e){
        //System.out.println(e.toString());
      }
    };
// rs.executeSql("drop table "+temptable);
%>  
	<TR class=datadark>
    <TD></TD>
    <TD></TD>
    <TD></TD>
    <TD></TD>
    <TD><font color=red><%=SystemEnv.getHtmlLabelName(523,user.getLanguage())%></font></TD>
    <TD><font color=red><%=(int)usecountdept%></font></TD>
    <TD><font color=red><%=feedept%></font></TD>
    </TR>

<%		
	usecountall += usecountdept;
    feeall += feedept;
	usecountdept = 0;
	feedept = 0;
%>    
  
<TR class=datadark>
    <TD></TD>
    <TD></TD>
    <TD></TD>
    <TD></TD>
    <TD><font color=red><%=SystemEnv.getHtmlLabelName(523,user.getLanguage())%></font></TD>
    <TD><font color=red><%=(int)usecountall%></font></TD>
    <TD><font color=red><%=feeall%></font></TD>
  </TR>
 </TBODY></TABLE>
 </td></tr>
 </table>
<% 
 ExcelFile.init() ;
 ExcelFile.setFilename(SystemEnv.getHtmlLabelName(1511,user.getLanguage())) ;
 ExcelFile.addSheet(SystemEnv.getHtmlLabelName(1511,user.getLanguage()), es) ;
}//end of judge if it is first in %>
 </FORM>
 <script language=vbs>
sub onShowResourceID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	resourceidspan.innerHtml = "<A href='/hrm/resource/HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	frmain.resourceid.value=id(0)
	else 
	resourceidspan.innerHtml = ""
	frmain.resourceid.value=""
	end if
	end if
end sub

 sub onShowDepartmentID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="&frmain.departmentid.value)
	issame = false 
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	if id(0) = frmain.departmentid.value then
		issame = true 
	end if
	departmentidspan.innerHtml = id(1)
	frmain.departmentid.value=id(0)
	else
	departmentidspan.innerHtml = ""
	frmain.departmentid.value=""
	end if
	end if
end sub

sub onShowStateID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/cpt/maintenance/CapitalStateBrowser.jsp?from=flowview")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	stateidspan.innerHtml = id(1)
	frmain.stateid.value=id(0)
	else 
	stateidspan.innerHtml = ""
	frmain.stateid.value=""
	end if
	end if
end sub

sub onShowCapitalID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/cpt/capital/CapitalBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	capitalidspan.innerHtml = id(1)
	frmain.capitalid.value=id(0)
	else 
	capitalidspan.innerHtml = ""
	frmain.capitalid.value=""
	end if
	end if
end sub

sub onShowCapitalgroupid()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/cpt/maintenance/CptAssortmentBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	capitalgroupidspan.innerHtml = id(1)
	frmain.capitalgroupid.value=id(0)
	else
	capitalgroupidspan.innerHtml = ""
	frmain.capitalgroupid.value=""
	end if
	end if
end sub

</script>
</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>
