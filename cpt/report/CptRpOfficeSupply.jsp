<%@ page import="weaver.general.Util,weaver.file.*" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CapitalStateComInfo" class="weaver.cpt.maintenance.CapitalStateComInfo" scope="page"/>
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
<jsp:useBean id="CapitalAssortmentComInfo" class="weaver.cpt.maintenance.CapitalAssortmentComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="AllManagers" class="weaver.hrm.resource.AllManagers" scope="page"/>
<jsp:useBean id="AssetUnitComInfo" class="weaver.lgc.maintenance.AssetUnitComInfo" scope="page"/>
<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session"/>



<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/weaver_wev8.js"></script>
</head>
<%
String capitalgroupid=Util.null2String(request.getParameter("capitalgroupid"));
if(capitalgroupid.equals("")) capitalgroupid = "12" ;

String userid =""+user.getUID();

/*权限判断,资产管理员以及其所有上级*/
boolean canView = false;
ArrayList allCanView = new ArrayList();
String sql = "select resourceid from HrmRoleMembers where roleid = 7 ";
rs.executeSql(sql);
while(rs.next()){
	String tempid = rs.getString("resourceid");
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

int month = Util.getIntValue(request.getParameter("month"),0);
int year  = Util.getIntValue(request.getParameter("year"),0);

Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
                     
int currentyear = today.get(Calendar.YEAR);

if(year==0){
	year=currentyear;
}
if(month==0){
	month=today.get(Calendar.MONTH)+1;
}

rs.execute("select supassortmentstr from CptCapitalAssortment where supassortmentstr like '%|"+capitalgroupid+"|%'");
if (rs.next()){
    if((rs.getString("supassortmentstr")).indexOf("|12|") == -1)   capitalgroupid = "12" ;
}

sql ="select * from CptCapital where capitalgroupid in ( select id from CptCapitalAssortment where supassortmentstr like '%|"+capitalgroupid+"|%' and subassortmentcount=0) and isdata='2' ";


String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(1513,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<DIV class=HdrProps></DIV>
<FORM id=weaver name=frmain action="CptRpOfficeSupply.jsp" method=post>

<BUTTON class=BtnRefresh id=cmdRefresh accessKey=R 
      type="submit" name=cmdRefresh><U>R</U>-<%=SystemEnv.getHtmlLabelName(354,user.getLanguage())%></BUTTON> 
<BUTTON class=BtnLog accessKey=E name=button2 onclick="location='/weaver/weaver.file.ExcelOut'"><U>E</U>-Excel</BUTTON>
<table class=form>
  <colgroup> 
  <col width="8%"><col width="8%"><col width="8%"><col width="8%">
  <col width="17%"><col width="17%"><col width="17%"><col width="17%">
  <tbody> 
   <TR class=Section>
   <tr> 
      <td>年份</td>
    <td class=Field>
    <select class=saveHistory id=year name=year>
    <% for(int i=0;i<10;i++){ 	
    	%>
        <option value=<%=currentyear-i%> <% if(year==(currentyear-i)) {%>selected<%}%>><%=currentyear-i%></option>
    <%}%>            
    </select>
    </td>
    <td>月份</td>
    <td class=Field>
   <select class=saveHistory id=month name=month>
    <% for(int i=1;i<=12;i++){ %>
        <option value="<%=i%>" <% if(month==i) {%>selected<%}%>><%=i%></option>
    <%}%>            
    </select>
    </td>  
    <td><%=SystemEnv.getHtmlLabelName(831,user.getLanguage())%></td>
      <td class=Field> <button class=Browser onClick="onShowCapitalgroupid()"></button> 
        <span id=capitalgroupidspan><%=Util.toScreen(CapitalAssortmentComInfo.getAssortmentName(capitalgroupid),user.getLanguage())%></span> 
        <input class=saveHistory id=capitalgroupid type=hidden name=capitalgroupid value=<%=capitalgroupid%>>
      </td>
    <td>&nbsp;</td>
    <td ><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%>:<%=currentdate%>
    </td>
  </tr>
  
  </tbody> 
</table>
<table border="1" width=100%>
<tr>
<td>
<TABLE class=ListShort>
  <COLGROUP>
  <col width="12%"><col width="12%"><col width="8%"><col width="8%"><col width="10%"> 
  <col width="10%"><col width="8%"><col width="8%"><col width="14%">  
  <TBODY>
 <TR class=separator>
    <TD class=Sep1 colSpan=10 ></TD></TR>
  <TR class=Header>
    <TD><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(1329,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(1330,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(1520,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(1521,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(1522,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(1523,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(1524,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></TD>
 </TR>
 
<%
 ExcelSheet es = new ExcelSheet() ;
 ExcelRow er = es.newExcelRow () ;
  
 er.addStringValue(SystemEnv.getHtmlLabelName(714,user.getLanguage())) ;
 er.addStringValue(SystemEnv.getHtmlLabelName(195,user.getLanguage())) ;
 er.addStringValue(SystemEnv.getHtmlLabelName(1329,user.getLanguage())) ;
 er.addStringValue(SystemEnv.getHtmlLabelName(1330,user.getLanguage())) ;
 er.addStringValue(SystemEnv.getHtmlLabelName(1520,user.getLanguage())) ;
 er.addStringValue(SystemEnv.getHtmlLabelName(1521,user.getLanguage())) ;
 er.addStringValue(SystemEnv.getHtmlLabelName(1522,user.getLanguage())) ;
 er.addStringValue(SystemEnv.getHtmlLabelName(1523,user.getLanguage())) ;
 er.addStringValue(SystemEnv.getHtmlLabelName(1524,user.getLanguage())) ;
 er.addStringValue(SystemEnv.getHtmlLabelName(454,user.getLanguage())) ;
 
 es.addExcelRow(er);



rs.execute(sql);   
int needchange = 0;
      while(rs.next()){
        String  capitalid = rs.getString("id");
        String  mark  = Util.toScreen(rs.getString("mark"),user.getLanguage());
        String	name= Util.toScreen(rs.getString("name"),user.getLanguage());
		String	unitid=rs.getString("unitid");
        double  startprice = Util.getDoubleValue(rs.getString("startprice"),0);
        double  capitalnum = Util.getDoubleValue(rs.getString("capitalnum"),0);
        try{
        //得到日期信息
        String startdate = ""+year+"-"+Util.add0(month,2)+"-01";
        today.set(year,month,1);
        String enddate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
                
        //得到进出库和库存信息 
        double lastmonthnum = 0;  //上月盘存数
        double thismonthin  = 0;  //本月进货数
        double thismonthout = 0;  //本月领用数
        double thismonthnum = 0;  //月末库存
        double usepriceall  = 0;  //领用总价
        double innum1 = 0;
        double innum2 = 0;
        double use1 = 0;
        double use2 = 0;
        
        sql=" select sum(usecount) from CptUseLog where usestatus='1' and usedate >= '"+startdate+"' and capitalid = "+capitalid;
        rs2.execute(sql);   
		if(rs2.next()){
			innum1 = Util.getDoubleValue(rs2.getString(1),0);
		}
		sql=" select sum(usecount) from CptUseLog where usestatus='1' and usedate >= '"+enddate+"' and capitalid = "+capitalid;
        rs2.execute(sql);   
		if(rs2.next()){
			innum2 = Util.getDoubleValue(rs2.getString(1),0);
		}
		sql=" select sum(usecount) from CptUseLog where usestatus='2' and usedate >= '"+startdate+"' and capitalid = "+capitalid;
        rs2.execute(sql);   
		if(rs2.next()){
			use1 = Util.getDoubleValue(rs2.getString(1),0);
		}
		sql=" select sum(usecount) from CptUseLog where usestatus='2' and usedate >= '"+enddate+"' and capitalid = "+capitalid;
        rs2.execute(sql);   
		if(rs2.next()){
			use2 = Util.getDoubleValue(rs2.getString(1),0);
		}
		
		lastmonthnum = capitalnum+use1-innum1;
		thismonthin  = innum1-innum2;
		thismonthout = use1-use2;
		thismonthnum = capitalnum+use2-innum2;
		usepriceall  = startprice*(use1-use2);
		
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
      <TD><A HREF="../capital/CptCapital.jsp?id=<%=capitalid%>"><%=mark%></A></TD>
      <TD><%=name%></TD>
      <TD><%=Util.toScreen(AssetUnitComInfo.getAssetUnitname(unitid),user.getLanguage())%> </TD>
      <TD  align=right><%=startprice%></TD>
      <TD><%=(int)lastmonthnum%></TD>
       <TD><%=(int)thismonthin%></TD>
       <TD><%=(int)thismonthout%></TD>
       <TD  align=right><%=usepriceall%></TD>
       <TD><%=(int)thismonthnum%></TD>
       <TD></TD>
     </TR>
<%
	er=es.newExcelRow () ;
	
    er.addStringValue(mark) ;
    er.addStringValue(name) ;
    er.addStringValue(Util.toScreen(AssetUnitComInfo.getAssetUnitname(unitid),user.getLanguage())) ;
    er.addValue(startprice) ;
    er.addValue((int)lastmonthnum) ;
    er.addValue((int)thismonthin) ;
    er.addValue((int)thismonthout) ;
    er.addValue(usepriceall) ;
    er.addValue((int)thismonthnum) ;
    er.addValue("") ;
	es.addExcelRow(er);
      }catch(Exception e){
        //System.out.println(e.toString());
      }
    }
    
 ExcelFile.init() ;
 ExcelFile.setFilename(SystemEnv.getHtmlLabelName(1513,user.getLanguage())) ;
 ExcelFile.addSheet(SystemEnv.getHtmlLabelName(1513,user.getLanguage()), es) ;
    
%>  
 </TBODY></TABLE>
 </td>
 </tr>
 </table>
 </FORM>
  <script language=vbs>
sub onShowCapitalgroupid()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/cpt/maintenance/CptAssortmentBrowser.jsp?supassortmentid=12")
	if (Not IsEmpty(id)) then
	if id(0)<> "0" then
	capitalgroupidspan.innerHtml = id(1)
	frmain.capitalgroupid.value=id(0)
	else
	capitalgroupidspan.innerHtml = ""
	frmain.capitalgroupid.value=""
	end if
	end if
end sub
</script>

</BODY></HTML>
