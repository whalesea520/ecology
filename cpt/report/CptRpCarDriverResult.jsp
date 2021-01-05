
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

int driver = Util.getIntValue(request.getParameter("driver"),0);
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
String titlename = SystemEnv.getHtmlLabelName(15328,user.getLanguage()) ;
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<DIV class=HdrProps></DIV>
<br>
<center><font size = 4><b><%=SystemEnv.getHtmlLabelName(15331,user.getLanguage())%></b></font></center>
<br>
<TABLE class=ListShort width=100%>
<TR class=Section>
<tH width=35%><%=SystemEnv.getHtmlLabelName(15330,user.getLanguage())%>:<%=Util.toScreen(ResourceComInfo.getResourcename(""+driver),user.getUID())%></th>
<tH width=30%><%=SystemEnv.getHtmlLabelName(15332,user.getLanguage())%>:<%=Util.toScreen(ResourceComInfo.getResourcename(""+user.getUID()),user.getUID())%></th>
<tH width=35%><%=SystemEnv.getHtmlLabelName(348,user.getLanguage())%><%=beginyear%><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%><%=beginmontd%><%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%><%=beginday%><%=SystemEnv.getHtmlLabelName(15333,user.getLanguage())%><%=endyear%><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%><%=endmontd%><%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%><%=endday%><%=SystemEnv.getHtmlLabelName(390,user.getLanguage())%></th>
</table>


 <%
   ArrayList drivers = new ArrayList();
   ArrayList oilfees = new ArrayList();
   ArrayList bridgefees = new ArrayList();
   ArrayList fixfees = new ArrayList();
   ArrayList phonefees = new ArrayList();
    sql = " select driver,sum(oilfee) as oilfee,sum(bridgefee) as bridgefee,sum(fixfee) as fixfee,sum(phonefee) as phonefee from bill_CptCarFee ";
   sql += " where usedate >='"+ begindate+"' and usedate <='"+enddate+"' ";
   if(driver!=0){
   	sql += " and driver = "+driver;
   }
   sql +=" group by driver order by driver";
   
	RecordSet.executeSql(sql);
	while(RecordSet.next()){
		drivers.add(RecordSet.getString("driver"));
		oilfees.add(RecordSet.getString("oilfee"));
		bridgefees.add(RecordSet.getString("bridgefee"));
		fixfees.add(RecordSet.getString("fixfee"));
		phonefees.add(RecordSet.getString("phonefee"));
	}
   
   ArrayList pubholidays = new ArrayList();
	sql = " SELECT * FROM HrmPubHoliday ";
	RecordSet.executeSql(sql);
	while(RecordSet.next()){
		pubholidays.add(Util.null2String(RecordSet.getString("holidaydate")));
	}
	
         sql = " select * from bill_CptCarOut ";
        sql += " where usedate >='"+ begindate+"' and usedate <='"+enddate+"' ";
	   if(driver!=0){
	   	sql += " and driver = "+driver;
	   }
	   sql +=" order by driver";
        RecordSet.executeSql(sql);
        
        ArrayList tmpdriver1s = new ArrayList();
        ArrayList count1s = new ArrayList();
	   ArrayList count2s = new ArrayList();
	   ArrayList count3s= new ArrayList();
	   ArrayList count4s = new ArrayList();
	   ArrayList allnumbers = new ArrayList();
	   ArrayList addfees = new ArrayList();
   
        int count1 = 0;
        int count2 = 0;
        int count3 = 0;
        int count4 = 0;
        float allnumber = 0;
        float addfee = 0;
        
        int curdriver = 0;
        
        Calendar tempday = Calendar.getInstance();
        
        while(RecordSet.next()){        	
        	int tmpdriver = RecordSet.getInt("driver");
        	
        	if(tmpdriver != curdriver && curdriver != 0){
        	    tmpdriver1s.add(""+curdriver);
	            count1s.add(""+count1);
		    count2s.add(""+count2);
		    count3s.add(""+count3);
		    count4s.add(""+count4);
		    allnumbers.add(""+allnumber);
		    addfees.add(""+addfee);
		    
		    count1=0;
		    count2=0;
		    count3=0;
		    count4=0;
		    allnumber=0;
		    addfee=0;
        	}
        	
        		allnumber += RecordSet.getFloat("number_n");
        		if(RecordSet.getInt("isotherplace") == 1)
        			count4 ++;
        			
        		String tmpbegindate = RecordSet.getString("begindate");
        		String tmpenddate = RecordSet.getString("enddate");
        		String tmpbegintime = RecordSet.getString("begintime");
        		String tmpendtime = RecordSet.getString("endtime");
        		
        		if(tmpbegindate.equals("") ||tmpenddate.equals("") ||tmpbegintime.equals("") ||tmpendtime.equals(""))
        			continue;
        		        		
        		int tmpendyear = Util.getIntValue(tmpenddate.substring(0,4));
			int tmpendmonth = Util.getIntValue(tmpenddate.substring(5,7))-1;
			int tmpendday = Util.getIntValue(tmpenddate.substring(8,10));
			float tmpendhour = Util.getFloatValue(tmpendtime.substring(0,2),0)+Util.getFloatValue(tmpendtime.substring(3,5),0)/60.0f;
			float tmpstarthour = Util.getFloatValue(tmpbegintime.substring(0,2),0)+Util.getFloatValue(tmpbegintime.substring(3,5),0)/60.0f;
			
			int daycount = 1;
			
			tempday.clear();
			tempday.set(Util.getIntValue(tmpbegindate.substring(0,4)),Util.getIntValue(tmpbegindate.substring(5,7))-1,Util.getIntValue(tmpbegindate.substring(8,10)));
			while(true){				
				if(tempday.getTime().getYear()==(tmpendyear-1900) && tempday.getTime().getMonth()==tmpendmonth && tempday.getTime().getDate()==tmpendday)
					break;
				tempday.add(Calendar.DATE,1);
				daycount ++;
			}
			
			tempday.clear();
			tempday.set(Util.getIntValue(tmpbegindate.substring(0,4)),Util.getIntValue(tmpbegindate.substring(5,7))-1,Util.getIntValue(tmpbegindate.substring(8,10)));
			
			if(pubholidays.indexOf(""+Util.add0(tempday.getTime().getYear()+1900,4)+"-"+Util.add0((tempday.getTime().getMonth()+1),2)+"-"+Util.add0(tempday.getTime().getDate(),2))!=-1) {
				if(tmpstarthour < 9){
					count3 ++;
					addfee += 90;
				}
				if(tmpstarthour < 12){
					count3 ++;
					addfee += 90;
				}
				if(tmpstarthour < 24){
					count3 ++;
					addfee += 90;
				}
			}
			else if((tempday.getTime().getDay()==0||tempday.getTime().getDay()==6)){
				if(tmpstarthour < 9){
					count3 ++;
					addfee += 60;
				}
				if(tmpstarthour < 12){
					count3 ++;
					addfee += 30;
				}
				if(tmpstarthour < 24){
					count3 ++;
					addfee += 30;
				}
			}
			else {
				if(tmpstarthour < 9){
					count2 ++;
					addfee += 40;
				}
				if(tmpstarthour < 12){
					count1 ++;
				}
				if(tmpstarthour < 17.5){
					count1 ++;
				}
				if(tmpstarthour < 24){
					count2 ++;
					addfee += 20;
				}
			}
			
			tempday.add(Calendar.DATE,1);
			
			while(daycount>1){				
				if(tempday.getTime().getYear()==(tmpendyear-1900) && tempday.getTime().getMonth()==tmpendmonth && tempday.getTime().getDate()==tmpendday)
					break;
					
				if(pubholidays.indexOf(""+Util.add0(tempday.getTime().getYear()+1900,4)+"-"+Util.add0((tempday.getTime().getMonth()+1),2)+"-"+Util.add0(tempday.getTime().getDate(),2))!=-1) {
					count3 += 3;
					addfee += 3*90;	
				}else if((tempday.getTime().getDay()==0||tempday.getTime().getDay()==6)){
					count3 += 3;
					addfee +=120;
				}else{
					count1+= 2;
					count2+= 2;
					addfee += 60;
				}
				tempday.add(Calendar.DATE,1);
			}
			if(daycount > 1){
				if(pubholidays.indexOf(""+Util.add0(tempday.getTime().getYear()+1900,4)+"-"+Util.add0((tempday.getTime().getMonth()+1),2)+"-"+Util.add0(tempday.getTime().getDate(),2))!=-1) {
					if(tmpendhour >= 9){
						count3 ++;
						addfee += 90;
					}
					if(tmpendhour >= 12){
						count3 ++;
						addfee += 90;
					}
					if(tmpendhour >= 24){
						count3 ++;
						addfee += 90;
					}
				}
				else if((tempday.getTime().getDay()==0||tempday.getTime().getDay()==6)){
					if(tmpendhour >= 9){
						count3 ++;
						addfee += 60;
					}
					if(tmpendhour >= 12){
						count3 ++;
						addfee += 30;
					}
					if(tmpendhour >= 24){
						count3 ++;
						addfee += 30;
					}
				}
				else {
					if(tmpendhour >= 9){
						count2 ++;
						addfee += 40;
					}
					if(tmpendhour >= 12){
						count1 ++;
					}
					if(tmpendhour >= 17.5){
						count1 ++;
					}
					if(tmpendhour >= 24){
						count2 ++;
						addfee += 20;
					}
				}	
			}	
        	
        curdriver = tmpdriver;
      }
      tmpdriver1s.add(""+curdriver);
	            count1s.add(""+count1);
		    count2s.add(""+count2);
		    count3s.add(""+count3);
		    count4s.add(""+count4);
		    allnumbers.add(""+allnumber);
		    addfees.add(""+addfee);
   %>

<TABLE class=ListShort>
  <COLGROUP> 
  <COL widtd="8%">
  <COL widtd="7%">
  <COL widtd="7%">
  <COL widtd="7%">
  <COL widtd="7%">
  <COL widtd="8%">
  <COL widtd="8%">
  <COL widtd="8%">
  <COL widtd="8%">
  <COL widtd="8%">
  <COL widtd="8%">
  <COL widtd="8%">
  <COL widtd="10%">
  <TBODY>
 <TR class=Header>
   <td><%=SystemEnv.getHtmlLabelName(15330,user.getLanguage())%></td>
   <td><%=SystemEnv.getHtmlLabelName(15334,user.getLanguage())%></td>
   <td><%=SystemEnv.getHtmlLabelName(15335,user.getLanguage())%></td>
   <td><%=SystemEnv.getHtmlLabelName(15336,user.getLanguage())%></td>
   <td><%=SystemEnv.getHtmlLabelName(15337,user.getLanguage())%></td>
   <td><%=SystemEnv.getHtmlLabelName(15338,user.getLanguage())%></td>
   <td><%=SystemEnv.getHtmlLabelName(15339,user.getLanguage())%></td>
   <td><%=SystemEnv.getHtmlLabelName(15340,user.getLanguage())%></td>
   <td><%=SystemEnv.getHtmlLabelName(15341,user.getLanguage())%></td>
   <td><%=SystemEnv.getHtmlLabelName(15342,user.getLanguage())%></td>
   <td><%=SystemEnv.getHtmlLabelName(15343,user.getLanguage())%></td>
   <td><%=SystemEnv.getHtmlLabelName(15344,user.getLanguage())%></td>
   <td><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></td>
   </tr>
<%
boolean isLight = false;
for(int i=0;i<tmpdriver1s.size();i++){
	if((""+tmpdriver1s.get(i)).equals("0"))
		continue;
	float tmpoilfee = 0;
	float tmpbridgefee = 0;
	float tmpfixfee = 0;
	float tmpphonefee = 0;
	
	int tmpindex = drivers.indexOf(""+tmpdriver1s.get(i));
	if(tmpindex !=-1){
		tmpoilfee = Util.getFloatValue(""+oilfees.get(tmpindex),0);
		tmpbridgefee = Util.getFloatValue(""+bridgefees.get(tmpindex),0);
		tmpfixfee = Util.getFloatValue(""+fixfees.get(tmpindex),0);
		tmpphonefee = Util.getFloatValue(""+phonefees.get(tmpindex),0);
	}
	%>	
          <tr <%if(isLight){%> class=datalight <%} else {%>  class=datadark <%}%>> 
   <td><%=Util.toScreen(ResourceComInfo.getResourcename(""+tmpdriver1s.get(i)),user.getUID())%></td>
   <td><%=count1s.get(i)%></td>
   <td><%=count2s.get(i)%></td>
   <td><%=count3s.get(i)%></td>
   <td><%=count4s.get(i)%></td>
   <td><%=allnumbers.get(i)%></td>
   <td><%=tmpoilfee%></td>
   <td><%=tmpbridgefee%></td>
   <td><%=tmpfixfee%></td>
   <td><%=tmpphonefee%></td>
   <td><%=addfees.get(i)%></td>
   <td> </td>
   <td> </td>
   </tr>
<%
isLight = !isLight;}%>
</TBODY>
</TABLE>

<script>
function onReSearch(){
	location.href="CptRpCarDriver.jsp";
}
</script>

</body>
</html>
