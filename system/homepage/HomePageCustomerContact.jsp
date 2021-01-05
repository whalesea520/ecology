<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.*,java.sql.Timestamp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="SearchClause" class="weaver.search.SearchClause" scope="session" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="ContacterTitleComInfo" class="weaver.crm.Maint.ContacterTitleComInfo" scope="page" />

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%
String needfav ="1";
String needhelp ="";

int userid=user.getUID();
String CurrentUser = ""+user.getUID();
String logintype = ""+user.getLogintype();
String sqlstr = "";
String para = "";
char flag = 2;

Calendar newsnow = Calendar.getInstance();
String today=Util.add0(newsnow.get(Calendar.YEAR), 4) +"-"+
	Util.add0(newsnow.get(Calendar.MONTH) + 1, 2) +"-"+
        Util.add0(newsnow.get(Calendar.DAY_OF_MONTH), 2) ;


ArrayList crmids01=new ArrayList();
ArrayList contactdate01=new ArrayList();

ArrayList crmids02=new ArrayList();
ArrayList beforedate02=new ArrayList();

ArrayList crmids=new ArrayList();
ArrayList lastcontactdate=new ArrayList();

//从客户表中读取没提醒记录的客户(id 和 建立时间)

sqlstr="select t2.customerid , max(t2.contactdate) contactdate from crm_customerinfo t1 , CRM_ContactLog t2  where t1.id = t2.customerid and t1.manager="+userid+" and t1.deleted<>1 group by t2.customerid ";


RecordSet.executeSql(sqlstr);
while(RecordSet.next())
{

	crmids01.add(RecordSet.getString(1));
	contactdate01.add(RecordSet.getString(2));
}


sqlstr="select customerid, before from CRM_ContacterLog_Remind  where isremind=0";


RecordSet.executeSql(sqlstr);
while(RecordSet.next())
{
	crmids02.add(RecordSet.getString(1));
	beforedate02.add(RecordSet.getString(2));
}



for (int i=0 ; i<crmids01.size();i++)
{
	String crmid01Temp=(String)crmids01.get(i);

	String contactdate01Temp=(String)contactdate01.get(i);
	for (int j=0 ; j<crmids02.size();j++){
		String crmid02Temp=(String)crmids02.get(j);
		String beforedate02Temp=(String)beforedate02.get(j);
		if (crmid01Temp.equals(crmid02Temp)) 
			{
			Calendar nowdate = Calendar.getInstance();
			nowdate.add(Calendar.DATE,Util.getIntValue(beforedate02Temp,0)*-1);
			String contactdate01Temp2=Util.add0(nowdate.get(Calendar.YEAR), 4) +"-"+
			Util.add0(nowdate.get(Calendar.MONTH) + 1, 2) +"-"+
			Util.add0(nowdate.get(Calendar.DAY_OF_MONTH), 2) ;
			if (contactdate01Temp.compareTo(contactdate01Temp2)<=0) {
				crmids.add(crmid01Temp);
				lastcontactdate.add(contactdate01Temp);
			}

			}

	}

}



%>

<table class=ListStyle id=tblReport cellspacing=1>

    <tbody> 
    <tr class=Header> 
      <th colspan = 2><%=SystemEnv.getHtmlLabelName(6061,user.getLanguage())%></th>
    </tr>
	<%
boolean isLight = false;   
for (int i=0 ; i<crmids.size();i++){
	String crmidsStr = (String)crmids.get(i);
	String lastcontactdateStr = (String)lastcontactdate.get(i);
		if(isLight)
		{%>	
	<TR CLASS=DataDark>
<%		}else{%>
	<TR CLASS=DataLight>
<%		}%>
	<TD><a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=crmidsStr%>" target ="mainFrame"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(crmidsStr),user.getLanguage())%></a></TD>
    <TD><%=lastcontactdateStr%></TD>

    
  </TR>
<%
 isLight = !isLight;	
}
%>  
</table>

</body>
</html>