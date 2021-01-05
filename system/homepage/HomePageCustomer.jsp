<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page"/>
<jsp:useBean id="CustomerStatusComInfo" class="weaver.crm.Maint.CustomerStatusComInfo" scope="page"/>
<jsp:useBean id="CustomerContacterComInfo" class="weaver.crm.Maint.CustomerContacterComInfo" scope="page"/>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%
int userid=user.getUID();
String CurrentUser = ""+user.getUID();
String logintype = ""+user.getLogintype();
String sql="";

String main="status";
String con1="CustomerStatus";
String sub="type";
String con2="CustomerTypes";

ArrayList maincounts=new ArrayList();
ArrayList mainids=new ArrayList();
ArrayList sublist = new ArrayList();

while (CustomerStatusComInfo.next()) 
{
mainids.add(CustomerStatusComInfo.getCustomerStatusid());
maincounts.add("0");
}
while (CustomerTypeComInfo.next()) 
{
sublist.add(CustomerTypeComInfo.getCustomerTypeid());
}


if(!user.getLogintype().equals("2")){
sql="select count(*) count,"+main+" from crm_customerinfo where manager="+userid+" and deleted<>1 group by "+main+" order by "+main;
}else{
sql="select count(*) count,"+main+" from crm_customerinfo where agent="+userid+" and deleted<>1 group by "+main+" order by "+main;
}
RecordSet.executeSql(sql);

while(RecordSet.next()){
	int tempindex = mainids.indexOf(RecordSet.getString(2)) ;
    if( tempindex != -1 ) maincounts.set(tempindex,RecordSet.getString(1)) ;
}
ArrayList subcounts=new ArrayList();
ArrayList subids=new ArrayList();
ArrayList sub_mainids=new ArrayList();
if(!user.getLogintype().equals("2")){
sql="select count(*),"+main+","+sub+" from crm_customerinfo where manager="+userid+" and deleted<>1 group by "+main+","+sub+" order by "+main+","+sub;
}else{
sql="select count(*),"+main+","+sub+" from crm_customerinfo where agent="+userid+" and deleted<>1 group by "+main+","+sub+" order by "+main+","+sub;
}
RecordSet.executeSql(sql);
//out.print(sql);
while(RecordSet.next()){
	subcounts.add(RecordSet.getString(1));
	subids.add(RecordSet.getString(3));
	sub_mainids.add(RecordSet.getString(2));
}

int mainnum=mainids.size();
%>

<table class=ListStyle id=tblReport cellspacing=1>
    <tbody> 
	 <colgroup>
  <col width="50">
  <col width="50%">
    <tr class=Header> 
      <th colspan = "2"><%=SystemEnv.getHtmlLabelName(6059,user.getLanguage())%></th>
    </tr>
	<%
	boolean haveTR = false;
	String mainname= "";
	String mainid = "";
	String maincount = "";
	for(int j=0;j<4;j++){ 
	mainid = (String)mainids.get(j);
 	maincount=(String)maincounts.get(j);
	if(maincount.equals(""))	maincount="0";
	mainname=CustomerStatusComInfo.getCustomerStatusname(mainid);
	if ((j+1)%2 != 0) haveTR = true ;
	if (haveTR) {%>
	<tr class="datalight">	
	<%}%>
	<td valign = "top" >
	<ul><li><%if(!maincount.equals("0")){%>
		<%if(!user.getLogintype().equals("2")){%>		
			<a href="/CRM/search/SearchOperation.jsp?<%=con1%>=<%=mainid%>&AccountManager=<%=userid%>" target = "mainFrame">
		<%}else{%>
			<a href="/CRM/search/SearchOperation.jsp?<%=con1%>=<%=mainid%>&CustomerOrigin=<%=userid%>" target = "mainFrame">
		<%}%>
	<%}%>
	<%=Util.toScreen(mainname,user.getLanguage())%>(<%=maincount%>)<%if(!maincount.equals("0")){%></a><%}%>
	
	
	<%
	String subname="";
	String subid="";
	String subcount="";
	String sub_mainid="";
	%> 		
	<table>
	<%
	for(int i=0;i<subids.size();i++){
			subid=(String)subids.get(i);
			subcount=(String)subcounts.get(i);
 			if(subcount.equals(""))	subcount="0";
 			sub_mainid=(String)sub_mainids.get(i);
 			if(!sub_mainid.equals(mainid))	continue; 			
	 		subname=CustomerTypeComInfo.getCustomerTypename(subid);
 		%>
	<tr><td>
 		<%if(!subcount.equals("0")){%>
			<%if(!user.getLogintype().equals("2")){%>		
				<a href="/CRM/search/SearchOperation.jsp?<%=con1%>=<%=mainid%>&<%=con2%>=<%=subid%>&AccountManager=<%=userid%>" target = "mainFrame">
			<%}else{%>
				<a href="/CRM/search/SearchOperation.jsp?<%=con1%>=<%=mainid%>&<%=con2%>=<%=subid%>&CustomerOrigin=<%=userid%>" target = "mainFrame">
			<%}%>
		<%}%>
 		<%=Util.toScreen(subname,user.getLanguage())%>(<%=subcount%>)<%if(!subcount.equals("0")){%></a><%}%>
 		</td></tr>
		<%}%>
	</table>
	</td>
	<% if (!haveTR) {%>
	</tr>	
	<%}
	haveTR = false;
	}%>
</table>

</body>
</html>