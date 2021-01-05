
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="AllManagers" class="weaver.hrm.resource.AllManagers" scope="page"/>

<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>

<%
String userid =""+user.getUID();
boolean canView = false;
ArrayList allCanView = new ArrayList();
String sql = "select resourceid from HrmRoleMembers where roleid = 7 ";
RecordSet.executeSql(sql);
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
Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                 Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                 Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;

String CurrentUser = ""+user.getUID();
String logintype = ""+user.getLogintype();
String ProcPara = "";
char flag = 2;

int car = Util.getIntValue(request.getParameter("car"),0);
String begindate = Util.null2String(request.getParameter("begindate"));
String enddate = Util.null2String(request.getParameter("enddate"));
if(begindate.equals(""))
	begindate = currentdate;
if(enddate.equals(""))
	enddate = currentdate;
	
String beginyear = begindate.substring(0,4);
String beginmontd = begindate.substring(5,7);
String beginday = begindate.substring(8,10);
String endyear = enddate.substring(0,4);
String endmontd = enddate.substring(5,7);
String endday = enddate.substring(8,10);

%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</HEAD>
<%
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(15345,user.getLanguage()) ;
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<DIV class=HdrProps></DIV>
<br>
<center><font size = 4><b><%= SystemEnv.getHtmlLabelName(15346,user.getLanguage()) %></b></font></center>
<br>
<TABLE class=ListShort width=100%>
<TR class=Section>
<tH width=35%><%=SystemEnv.getHtmlLabelName(920,user.getLanguage())%>:<%=Util.toScreen(CapitalComInfo.getCapitalname(""+car),user.getUID())%></th>
<tH width=30%><%=SystemEnv.getHtmlLabelName(15332,user.getLanguage())%>:<%=Util.toScreen(ResourceComInfo.getResourcename(""+user.getUID()),user.getUID())%></th>
<tH width=35%><%=SystemEnv.getHtmlLabelName(348,user.getLanguage())%><%=beginyear%><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%><%=beginmontd%><%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%><%=beginday%><%=SystemEnv.getHtmlLabelName(15333,user.getLanguage())%><%=endyear%><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%><%=endmontd%><%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%><%=endday%><%=SystemEnv.getHtmlLabelName(390,user.getLanguage())%></th>
</table>


 <%
   ArrayList ids = new ArrayList();               //id	
   ArrayList marks = new ArrayList();               //车辆编号
   ArrayList alldrivenumbers = new ArrayList();		//总行驶公里数
//   ArrayList beginnumbers = new ArrayList();		//期初数
   ArrayList endnumbers = new ArrayList();			//期末数
   ArrayList isotherplaces = new ArrayList();		//外地出车次数
   ArrayList mantantdates = new ArrayList();		//保养时间
   ArrayList mantantfees = new ArrayList();			//保养费用
   ArrayList fixdates = new ArrayList();			//维修时间
   ArrayList fixfees = new ArrayList();				//维修费用
   ArrayList cleanfees = new ArrayList();			//清洁费用
   
   sql = " select id,mark from CptCapital where isdata='2' and (capitalgroupid = 9 or capitalgroupid in (select id from CptCapitalAssortment where supassortmentstr like '%|9|%')) ";
   if(car!=0){
   		sql +=" and id ="+car;
   	}
   sql +=" order by mark ";

	RecordSet.executeSql(sql);
	while(RecordSet.next()){
		ids.add(RecordSet.getString("id"));
		marks.add(RecordSet.getString("mark"));
	}
	for(int i=0;i<ids.size();i++){
		String tempid = (String)ids.get(i);
		//总行驶公里数
		sql = " select sum(number) from bill_CptCarOut where carno="+tempid+" and enddate>='"+begindate+"' and enddate<='"+enddate+"' ";
		RecordSet.executeSql(sql);	
		if(RecordSet.next()){
			alldrivenumbers.add(""+Util.getDoubleValue(RecordSet.getString(1),0));
		}else{
			alldrivenumbers.add("0");
		}	
		//期初数(总-期末)
//		sql = " select top 1 endnumber from bill_CptCarOut where carno="+tempid+" and enddate<='"+begindate+"' order by enddate desc ";
//		RecordSet.executeSql(sql);	
//		if(RecordSet.next()){
//			beginnumbers.add(""+Util.getDoubleValue(RecordSet.getString("endnumber"),0));
//		}else{
//			beginnumbers.add("0");
//		}
		//期末数
	if(RecordSet.getDBType().equals("oracle")){
		sql = " select endnumber from (select  endnumber from bill_CptCarOut where carno="+tempid+" and enddate<='"+enddate+"' order by enddate,endtime desc) where rownum = 1";
	} else {
		sql = " select top 1 endnumber from bill_CptCarOut where carno="+tempid+" and enddate<='"+enddate+"' order by enddate,endtime desc ";
	}
		RecordSet.executeSql(sql);	
		if(RecordSet.next()){
			endnumbers.add(""+Util.getDoubleValue(RecordSet.getString("endnumber"),0));
		}else{
			endnumbers.add("0");
		}
		//外地出车次数
		sql = " select count(id) from bill_CptCarOut where carno="+tempid+" and isotherplace=1 and enddate>='"+begindate+"' and enddate<='"+enddate+"' ";
		RecordSet.executeSql(sql);	
		if(RecordSet.next()){
			isotherplaces.add(RecordSet.getString(1));
		}
		//保养时间和保养费用
		sql = " select usedate,mantantfee from bill_CptCarMantant where carno="+tempid+" and usedate>='"+begindate+"' and usedate<='"+enddate+"' ";
		RecordSet.executeSql(sql);	
		ArrayList tempdates1 = new ArrayList();
		ArrayList tempfees1  = new ArrayList();
		while(RecordSet.next()){
			tempdates1.add(RecordSet.getString("usedate"));
			tempfees1.add(RecordSet.getString("mantantfee"));
		}
		mantantdates.add(tempdates1);
		mantantfees.add(tempfees1);
		//维修时间和维修费用
		sql = " select usedate,fixfee from bill_CptCarFix where carno="+tempid+" and usedate>='"+begindate+"' and usedate<='"+enddate+"' ";
		RecordSet.executeSql(sql);	
		ArrayList tempdates2 = new ArrayList();
		ArrayList tempfees2  = new ArrayList();
		while(RecordSet.next()){
			tempdates2.add(RecordSet.getString("usedate"));
			tempfees2.add(RecordSet.getString("fixfee"));
		}
		fixdates.add(tempdates2);
		fixfees.add(tempfees2);
		//清洁费用
		sql = " select sum(cleanfee) from bill_CptCarFee where carno="+tempid+" and usedate>='"+begindate+"' and usedate<='"+enddate+"' "; 	
		RecordSet.executeSql(sql);	
		if(RecordSet.next()){
			cleanfees.add(""+Util.getDoubleValue(RecordSet.getString(1),0));
		}else{
			cleanfees.add("0");
		}
	}// end for
	
	ArrayList temparray = null;
	//得到保养的最大列数(mantantcol)
	int mantantcol = 1; 
	for(int i=0;i<mantantdates.size();i++){
		temparray = (ArrayList)mantantdates.get(i);
		if(temparray.size()>mantantcol){
			mantantcol = temparray.size();
		}
	}

	//得到维修的最大列数(fixcol)
	int fixcol = 1;
	for(int i=0;i<fixdates.size();i++){
		temparray = (ArrayList)fixdates.get(i);
		if(temparray.size()>fixcol){
			fixcol = temparray.size();
		}
	}	
//	
//   out.print("ids:"+ids);
//   out.print("marks:"+marks);
//   out.print("alldrivenumbers:"+alldrivenumbers);
//   out.print("beginnumbers:"+beginnumbers);
//   out.print("endnumbers:"+endnumbers);
//   out.print("isotherplaces:"+isotherplaces);
//   out.print("mantantdates:"+mantantdates);
//   out.print("fixdates:"+fixdates);
//   out.print("fixfees:"+fixfees);
//   out.print("cleanfees:"+cleanfees);
//	 out.print("mantantcol:"+mantantcol);
%>

<TABLE class=ListShort>
  <COLGROUP> 
  <COL width="8%">
  <COL width="7%">
  <COL width="7%">
  <COL width="7%">
  <COL width="7%">
  <% for(int i=0;i<mantantcol;i++){ %>
  <COL width="<%=24/mantantcol%>%">
  <%}%>
  <% for(int i=0;i<fixcol;i++){ %>
  <COL width="<%=24/fixcol%>%">
  <%}%>
  <COL width="7%">
  <COL width="9%">
  <TBODY>
 <TR class=Header>
   <td rowspan=2><p align=center><%=SystemEnv.getHtmlLabelName(15347,user.getLanguage())%></p></td>
   <td rowspan=2><p align=center><%=SystemEnv.getHtmlLabelName(15348,user.getLanguage())%></p></td>
   <td rowspan=2><p align=center><%=SystemEnv.getHtmlLabelName(1482,user.getLanguage())%></p></td>
   <td rowspan=2><p align=center><%=SystemEnv.getHtmlLabelName(1483,user.getLanguage())%></p></td>
   <td rowspan=2><p align=center><%=SystemEnv.getHtmlLabelName(15337,user.getLanguage())%></p></td>
   <td colspan=<%=mantantcol%>><p align=center><%=SystemEnv.getHtmlLabelName(15349,user.getLanguage())%></p></td>
   <td colspan=<%=fixcol%>><p align=center><%=SystemEnv.getHtmlLabelName(15350,user.getLanguage())%></p></td>
   <td rowspan=2><p align=center><%=SystemEnv.getHtmlLabelName(15351,user.getLanguage())%></p></td>
   <td rowspan=2><p align=center><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></p></td>
 </tr>
 <tr class=Header>
 <% for(int i=0;i<mantantcol;i++){ %>
 <td><p align=center><%=i+1%></p></td>
 <% } %>
 <% for(int i=0;i<fixcol;i++){ %>
 <td><p align=center><%=i+1%></p></td>
 <% } %>
 </tr>
<%
boolean isLight = false;
for(int i=0;i<ids.size();i++){
	String id    			 = (String)ids.get(i);
	String mark   	    	 = (String)marks.get(i);
	String alldrivenumber    = (String)alldrivenumbers.get(i);
	String endnumber    	 = (String)endnumbers.get(i);
	String beginnumber  	 = ""+(Util.getDoubleValue(endnumber,0)-Util.getDoubleValue(alldrivenumber,0));
	String isotherplace   	 = (String)isotherplaces.get(i);
	ArrayList mantantdate  	 = (ArrayList)mantantdates.get(i);
	ArrayList mantantfee   	 = (ArrayList)mantantfees.get(i);
	ArrayList fixdate   	 = (ArrayList)fixdates.get(i);
	ArrayList fixfee   		 = (ArrayList)fixfees.get(i);
	String cleanfee  	 	 = (String)cleanfees.get(i);
%>	
   <tr <%if(isLight){%> class=datalight <%} else {%>  class=datadark <%}%>> 
   <td><a href="../capital/CptCapital.jsp?id=<%=id%>"><%=mark%></a></td>
   <td><%=alldrivenumber%></td>
   <td><%=beginnumber%></td>
   <td><%=endnumber%></td>
   <td><%=isotherplace%></td>
  <% 
  for(int j=0;j<mantantcol;j++){ 	
  %>
 <td>
 <% if(j<mantantdate.size()){ %>
 <%=mantantdate.get(j)%>,<%=mantantfee.get(j)%>
 <%}%>
 </td>
 <%}%>
 <% for(int j=0;j<fixcol;j++){ %>
 <td>
 <% if(j<fixdate.size()){ %>
 <%=fixdate.get(j)%>,<%=fixfee.get(j)%>
 <%}%>
 </td>
 <% } %>
   <td><%=cleanfee%></td>
   <td></td>
   </tr>
<%
isLight = !isLight;
}
%>
</TBODY>
</TABLE>

<script>
function onReSearch(){
	location.href="CptRpCptCar.jsp";
}
</script>

</body>
</html>
