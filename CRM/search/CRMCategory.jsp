
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSetMM" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page"/>
<jsp:useBean id="CustomerDescComInfo" class="weaver.crm.Maint.CustomerDescComInfo" scope="page"/>
<jsp:useBean id="CustomerStatusComInfo" class="weaver.crm.Maint.CustomerStatusComInfo" scope="page"/>
<jsp:useBean id="CustomerSizeComInfo" class="weaver.crm.Maint.CustomerSizeComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
<jsp:useBean id="CustomerContacterComInfo" class="weaver.crm.Maint.CustomerContacterComInfo" scope="page"/>
<jsp:useBean id="AssetComInfo" class="weaver.lgc.asset.AssetComInfo" scope="page" />
<jsp:useBean id="ContractComInfo" class="weaver.crm.Maint.ContractComInfo" scope="page"/>
<jsp:useBean id="SellstatusComInfo" class="weaver.crm.sellchance.SellstatusComInfo" scope="page"/>
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page" />

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
int userid=user.getUID();
boolean isLight = false;   
String username=ResourceComInfo.getResourcename(userid+"");
String main=Util.fromScreen(request.getParameter("main"),user.getLanguage());
String sub=Util.fromScreen(request.getParameter("sub"),user.getLanguage());

if(main.equals(""))	main="status";
if(sub.equals(""))	sub="description";
String othermain=main;
String othersub=sub;
String con1="";
String con2="";
if(main.equals("type"))		con1="CustomerTypes";
if(main.equals("description"))	con1="CustomerDesc";
if(main.equals("status"))	con1="CustomerStatus";
if(main.equals("size"))		con1="CustomerSize";
if(main.equals("size"))		othermain="size_n";

if(sub.equals("type"))		con2="CustomerTypes";
if(sub.equals("description"))	con2="CustomerDesc";
if(sub.equals("status"))	con2="CustomerStatus";
if(sub.equals("size"))		con2="CustomerSize";
if(sub.equals("size"))		othersub="size_n";
%>
<%
String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(147,user.getLanguage())+":"+Util.toScreen(username,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:document.frmmain.submit(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>

<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">
<form id=frmmain name=frmmain method=post action="CRMCategory.jsp">

<table class=ViewForm>
  <colgroup>
  <col width="15%">
  <col width="35%">
  <col width="15%">
  <col width="35%">
<TR style="height: 1px"><TD class=Line1 colSpan=4></TD></TR>
  <tr>
  	<td><%=SystemEnv.getHtmlLabelName(863,user.getLanguage())%></td>
  	<td class=field>
  	<select class=InputStyle  size=1 name=main style="width:95%" onChange="checkSame()">
  	<option value="type" <%if(main.equals("type")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(1282,user.getLanguage())%></option>
  	<option value="description" <%if(main.equals("description")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(1283,user.getLanguage())%></option>
  	<option value="status" <%if(main.equals("status")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15078,user.getLanguage())%></option>
  	<option value="size" <%if(main.equals("size")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(1285,user.getLanguage())%></option>
  	</select>
  	</td>
  	<td><%=SystemEnv.getHtmlLabelName(1281,user.getLanguage())%></td>
  	<td class=field>
  	<select class=InputStyle  size=1 name=sub style="width:95%" onChange="checkSame()">
  	<option value="type" <%if(sub.equals("type")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(1282,user.getLanguage())%></option>
  	<option value="description" <%if(sub.equals("description")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(1283,user.getLanguage())%></option>
  	<option value="status" <%if(sub.equals("status")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15078,user.getLanguage())%></option>
  	<option value="size" <%if(sub.equals("size")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(1285,user.getLanguage())%></option>
  	</select>
  	</td>
  </TR><tr style="height: 1px"><td class=Line colspan=4></td></tr>
</table>
<script language=javascript>
	function checkSame(){
		if(frmmain.main.value==frmmain.sub.value)
			if(frmmain.main.options[0].selected)
				frmmain.sub.options[1].selected=true;
			else
				frmmain.sub.options[0].selected=true;
	}
</script>
<%
String leftjointable = CrmShareBase.getTempTable2(user.getLogintype(),""+user.getUID());
String sql="";
ArrayList maincounts=new ArrayList();
ArrayList mainids=new ArrayList();
if(!user.getLogintype().equals("2")){
  sql="select count(distinct id) count,"+othermain+ 
  " from CRM_CustomerInfo t1 left join "+leftjointable+" t2 on t1.id = t2.relateditemid"+ 
  " where deleted=0 and manager="+userid+" and t1.id = t2.relateditemid group by "+othermain+" order by "+othermain;
}else{
  sql="select count(distinct id) count,"+othermain+ 
  " from CRM_CustomerInfo t1 left join "+leftjointable+" t2 on t1.id = t2.relateditemid"+ 
  " where deleted=0 and agent="+userid+" and t1.id = t2.relateditemid group by "+othermain+" order by "+othermain;
}
RecordSet.executeSql(sql);
while(RecordSet.next()){
	maincounts.add(RecordSet.getString(1));
	mainids.add(RecordSet.getString(2));
}
ArrayList subcounts=new ArrayList();
ArrayList subids=new ArrayList();
ArrayList sub_mainids=new ArrayList();
if(!user.getLogintype().equals("2")){
  sql="select count(distinct id),"+othermain+","+othersub+ 
  " from CRM_CustomerInfo t1 left join "+leftjointable+" t2 on t1.id = t2.relateditemid"+
  " where deleted=0 and manager="+userid+" and t1.id = t2.relateditemid group by "+othermain+","+othersub+" order by "+othermain+","+othersub;
}else{
  sql="select count(distinct id),"+othermain+","+othersub+ 
  " from CRM_CustomerInfo t1 left join "+leftjointable+" t2 on t1.id = t2.relateditemid"+
  " where deleted=0 and agent="+userid+" and t1.id = t2.relateditemid group by "+othermain+","+othersub+" order by "+othermain+","+othersub;
}
//out.print("sql=="+sql);
RecordSet.executeSql(sql);
while(RecordSet.next()){
	subcounts.add(RecordSet.getString(1));
	subids.add(RecordSet.getString(3));
	sub_mainids.add(RecordSet.getString(2));
}

int mainnum=mainids.size();
int rownum = (mainnum+1)/2;
%>
<table class=ViewForm>

  <tr><td colspan=2>&nbsp;</td></tr>
<TR style="height: 1px"><TD class=Line1 colSpan=2></TD></TR>
  <tr>
     <td width="50%" align=left valign=top>
<%
 	int needtd=rownum;
 	for(int i=0;i<mainids.size();i++){
 		String mainid = (String)mainids.get(i);
 		String maincount=(String)maincounts.get(i);
 		if(maincount.equals(""))	maincount="0";
 		String mainname="";
 		if(main.equals("type"))		mainname=CustomerTypeComInfo.getCustomerTypename(mainid);
 		if(main.equals("description"))	mainname=CustomerDescComInfo.getCustomerDescname(mainid);
 		if(main.equals("status"))	mainname=CustomerStatusComInfo.getCustomerStatusname(mainid);
 		if(main.equals("size"))		mainname=CustomerSizeComInfo.getCustomerSizename(mainid);
 		needtd--;
%>
	<table><tr><td>
	<ul><li>
	<%if(!maincount.equals("0")){%>
		<%if(!user.getLogintype().equals("2")){%>		
			<a href="SearchOperation.jsp?<%=con1%>=<%=mainid%>&AccountManager=<%=userid%>&searchtype=baseOnCustomerStatus"> <%--td1761 xwj 2005-05-24--%>
		<%}else{%>
			<a href="SearchOperation.jsp?<%=con1%>=<%=mainid%>&CustomerOrigin=<%=userid%>&searchtype=baseOnCustomerStatus"> <%--td1761 xwj 2005-05-24--%>
		<%}%>
	<%}%>
	<%=Util.toScreen(mainname,user.getLanguage())%>(<%=maincount%>)<%if(!maincount.equals("0")){%></a><%}%>
<%
		for(int j=0;j<subids.size();j++){
			String subid=(String)subids.get(j);
			String subcount=(String)subcounts.get(j);
 			if(subcount.equals(""))	subcount="0";
 			String sub_mainid=(String)sub_mainids.get(j);
 			if(!sub_mainid.equals(mainid))	continue;
 			String subname="";
	 		if(sub.equals("type"))		subname=CustomerTypeComInfo.getCustomerTypename(subid);
	 		if(sub.equals("description"))	subname=CustomerDescComInfo.getCustomerDescname(subid);
	 		if(sub.equals("status"))	subname=CustomerStatusComInfo.getCustomerStatusname(subid);
	 		if(sub.equals("size"))		subname=CustomerSizeComInfo.getCustomerSizedesc(subid);
 		%>
 		<ul><li>
 		<%if(!subcount.equals("0")){%>
			<%if(!user.getLogintype().equals("2")){%>		
				<a href="SearchOperation.jsp?<%=con1%>=<%=mainid%>&<%=con2%>=<%=subid%>&AccountManager=<%=userid%>&searchtype=baseOnCustomerStatus"><%--td1761 xwj 2005-05-24--%>
			<%}else{%>
				<a href="SearchOperation.jsp?<%=con1%>=<%=mainid%>&<%=con2%>=<%=subid%>&CustomerOrigin=<%=userid%>&searchtype=baseOnCustomerStatus"><%--td1761 xwj 2005-05-24--%>
			<%}%>
		<%}%>
 		<%=Util.toScreen(subname,user.getLanguage())%>(<%=subcount%>)<%if(!subcount.equals("0")){%></a><%}%></li></ul>
 		<%
		}
%>
	</li></ul></td></TR></table>
	<%
		if(needtd==0){
			needtd=mainnum/2;
	%>
		</td><td align=left valign=top>
	<%
		}
	}
%>
<TR style="height: 1px"><TD class=Line colSpan=2></TD></TR>
</table>
</form>
<!--客户联系计划begin-->
<!--removed by lupeng 2004-07-14-->
<!--客户联系计划end-->



<!--客户联系提醒begin-->
<!--moved to CRMContactRemind.jsp file by lupeng 2004-07-14-->
<%
String sqlstr = "";
Calendar cal = Calendar.getInstance();
String today = Util.add0(cal.get(Calendar.YEAR), 4) +"-"+
	Util.add0(cal.get(Calendar.MONTH) + 1, 2) +"-"+
        Util.add0(cal.get(Calendar.DAY_OF_MONTH), 2) ;
%>
<!--客户联系提醒end-->

<%if(!user.getLogintype().equals("2")) {%>
<!--客户交货提醒begin-->

<%

//条件：合同为签单，未完成，提醒，客户经理及其经理有权限查看
sqlstr="select t1.* , t2.crmId from CRM_ContractProduct t1 , CRM_Contract t2  where t1.contractId = t2.id and t2.status = 2 and t2.manager="+userid+" and t1.isFinish = 1 and t1.isRemind = 0 ";

ArrayList ContractProduct01=new ArrayList();
ArrayList ContractCrmId01=new ArrayList();
ArrayList ContractId01=new ArrayList();
ArrayList ContractLgc01=new ArrayList();
ArrayList ContractLgcNum01=new ArrayList();
ArrayList ContractPlanDate01=new ArrayList();

RecordSet.executeSql(sqlstr);
while(RecordSet.next())
{
	ContractProduct01.add(RecordSet.getString("id"));
	ContractCrmId01.add(RecordSet.getString("crmId"));
	ContractId01.add(RecordSet.getString("contractId"));
	ContractLgc01.add(RecordSet.getString("productId"));
	ContractLgcNum01.add(RecordSet.getString("number_n"));
	ContractPlanDate01.add(RecordSet.getString("planDate"));
}

for (int i=0 ; i<ContractProduct01.size();i++)
{
			String ContractDateTemp01 = (String)ContractPlanDate01.get(i);
			Calendar Todaydate = Calendar.getInstance();
			int ThisYear = Util.getIntValue(ContractDateTemp01.substring(0,4));
			int ThisMonth = Util.getIntValue(ContractDateTemp01.substring(5,7))-1;
			int ThisDay = Util.getIntValue(ContractDateTemp01.substring(8,10));
			Todaydate.set(ThisYear,ThisMonth,ThisDay);
			Todaydate.add(Calendar.DATE,-1);
			String ContractDateTemp02=Util.add0(Todaydate.get(Calendar.YEAR), 4) +"-"+
			Util.add0(Todaydate.get(Calendar.MONTH) + 1, 2) +"-"+
			Util.add0(Todaydate.get(Calendar.DAY_OF_MONTH), 2) ;
			
			if (ContractDateTemp02.compareTo(today)>0) {
			ContractProduct01.remove(i);	
			ContractCrmId01.remove(i);
			ContractId01.remove(i);
			ContractLgc01.remove(i);
			ContractLgcNum01.remove(i);
			ContractPlanDate01.remove(i);
			}

}

if (ContractProduct01.size()>0) {
%>
<BR><BR>
<table class=ListStyle id=tblReport cellspacing=1>

    <tbody> 
    <tr class=Header> 
      <th ><b><%=SystemEnv.getHtmlLabelName(15233,user.getLanguage())%></b></th>
	  <td><%=SystemEnv.getHtmlLabelName(614,user.getLanguage())%></td>
	  <td><%=SystemEnv.getHtmlLabelName(15115,user.getLanguage())%></td>
	  <td><%=SystemEnv.getHtmlLabelName(1331,user.getLanguage())%></td>
	  <td><%=SystemEnv.getHtmlLabelName(1050,user.getLanguage())%></td>
    </tr>
<TR class=Line style="height: 1px"><TD colSpan=5></TD></TR>
	<%

for (int i=0 ; i<ContractProduct01.size();i++){
	String ContractProductStr = (String)ContractProduct01.get(i);
	String ContractCrmIdStr = (String)ContractCrmId01.get(i);
	String ContractIdStr = (String)ContractId01.get(i);	
	String ContractLgcStr = (String)ContractLgc01.get(i);
	String ContractLgcNumStr = (String)ContractLgcNum01.get(i);	
	String ContractPlanDateStr = (String)ContractPlanDate01.get(i);	
		if(isLight)
		{%>	
	<TR CLASS=DataDark>
<%		}else{%>
	<TR CLASS=DataLight>
<%		}%>
	<TD><a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=ContractCrmIdStr%>" ><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(ContractCrmIdStr),user.getLanguage())%></a></TD>
    <TD><a href="/CRM/data/ContractView.jsp?CustomerID=<%=ContractCrmIdStr%>&id=<%=ContractIdStr%>" ><%=ContractComInfo.getContractname(ContractIdStr)%></a></TD>
	<TD><a href = "/lgc/asset/LgcAsset.jsp?paraid=<%=ContractLgcStr%>"><%=AssetComInfo.getAssetName(ContractLgcStr)%></a></TD>
	<TD><%=ContractLgcNumStr%></TD>
	<TD><%=ContractPlanDateStr%></TD>	

  </TR>
<%
 isLight = !isLight;	
}
%>  
</table>
<%}%>

<!--客户交货提醒end-->


<!--客户付款提醒begin-->

<%

//条件：合同为签单，未完成，提醒，客户经理及其经理有权限查看
sqlstr="select t1.* , t2.crmId from CRM_ContractPayMethod t1 , CRM_Contract t2 where t1.contractId = t2.id and t2.status = 2 and t2.manager="+userid+" and t1.isFinish = 1 and t1.isRemind = 0 ";

ArrayList ContractPayMethod02=new ArrayList();
ArrayList ContractCrmId02=new ArrayList();
ArrayList ContractId02=new ArrayList();
ArrayList ContractPrjName02=new ArrayList();
ArrayList ContractTypeId02=new ArrayList();
ArrayList ContractPayPrice02=new ArrayList();
ArrayList ContractPayDate02=new ArrayList();

RecordSet.executeSql(sqlstr);
while(RecordSet.next())
{
	ContractPayMethod02.add(RecordSet.getString("id"));
	ContractCrmId02.add(RecordSet.getString("crmId"));
	ContractId02.add(RecordSet.getString("contractId"));
	ContractPrjName02.add(RecordSet.getString("prjName"));
	ContractTypeId02.add(RecordSet.getString("typeId"));
	ContractPayPrice02.add(RecordSet.getString("payPrice"));
	ContractPayDate02.add(RecordSet.getString("payDate"));
}

for (int i=0 ; i<ContractPayMethod02.size();i++)
{
			String ContractDateTemp01 = (String)ContractPayDate02.get(i);
			Calendar Todaydate = Calendar.getInstance();
			int ThisYear = Util.getIntValue(ContractDateTemp01.substring(0,4));
			int ThisMonth = Util.getIntValue(ContractDateTemp01.substring(5,7))-1;
			int ThisDay = Util.getIntValue(ContractDateTemp01.substring(8,10));
			Todaydate.set(ThisYear,ThisMonth,ThisDay);
			Todaydate.add(Calendar.DATE,-1);
			String ContractDateTemp02=Util.add0(Todaydate.get(Calendar.YEAR), 4) +"-"+
			Util.add0(Todaydate.get(Calendar.MONTH) + 1, 2) +"-"+
			Util.add0(Todaydate.get(Calendar.DAY_OF_MONTH), 2) ;
			
			if (ContractDateTemp02.compareTo(today)>0) {
			ContractPayMethod02.remove(i);	
			ContractCrmId02.remove(i);
			ContractId02.remove(i);
			ContractPrjName02.remove(i);
			ContractTypeId02.remove(i);
			ContractPayPrice02.remove(i);
			ContractPayDate02.remove(i);
			}

}

if (ContractPayMethod02.size()>0) {
%>
<BR><BR>
<table class=ListStyle id=tblReport cellspacing=1>

    <tbody> 
    <tr class=Header> 
      <th ><b><%=SystemEnv.getHtmlLabelName(15234,user.getLanguage())%></b></th>
	  <td><%=SystemEnv.getHtmlLabelName(614,user.getLanguage())%></td>
	  <td><%=SystemEnv.getHtmlLabelName(15132,user.getLanguage())%></td>
	  <td><%=SystemEnv.getHtmlLabelName(15133,user.getLanguage())%></td>
	  <td><%=SystemEnv.getHtmlLabelName(15134,user.getLanguage())%></td>
	  <td><%=SystemEnv.getHtmlLabelName(15135,user.getLanguage())%></td>
    </tr>
<TR class=Line style="height: 1px"><TD colSpan=6></TD></TR>
	<%

for (int i=0 ; i<ContractPayMethod02.size();i++){
	String ContractPayMethod02Str = (String)ContractPayMethod02.get(i);
	String ContractCrmId02Str = (String)ContractCrmId02.get(i);
	String ContractId02Str = (String)ContractId02.get(i);	
	String ContractPrjName02Str = (String)ContractPrjName02.get(i);
	String ContractTypeId02Str = (String)ContractTypeId02.get(i);	
	String ContractPayPrice02Str = (String)ContractPayPrice02.get(i);	
	String ContractPayDate02Str = (String)ContractPayDate02.get(i);
		if(isLight)
		{%>	
	<TR CLASS=DataDark>
<%		}else{%>
	<TR CLASS=DataLight>
<%		}%>
	<TD><a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=ContractCrmId02Str%>" ><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(ContractCrmId02Str),user.getLanguage())%></a></TD>
    <TD><a href="/CRM/data/ContractView.jsp?CustomerID=<%=ContractCrmId02Str%>&id=<%=ContractId02Str%>" ><%=ContractComInfo.getContractname(ContractId02Str)%></a></TD>
	<TD><%=ContractPrjName02Str%></TD>
	<TD><% if (ContractTypeId02Str.equals("1")) {%><%=SystemEnv.getHtmlLabelName(15137,user.getLanguage())%><%} else {%><%=SystemEnv.getHtmlLabelName(15138,user.getLanguage())%><%}%></TD>
	<TD><%=ContractPayPrice02Str%></TD>	
	<TD><%=ContractPayDate02Str%></TD>	
  </TR>
<%
 isLight = !isLight;	
}
%>  
</table>
<%}%>

<!--客户付款提醒end-->



<!--客户合同到期提醒begin-->

<%

//条件：合同为签单，提醒，客户经理及其经理有权限查看
sqlstr="select t1.* from CRM_Contract t1  where t1.status = 2 and t1.manager="+userid+" and t1.isRemind = 0 ";

ArrayList ContractId03=new ArrayList();
ArrayList ContractCrmId03=new ArrayList();
ArrayList ContractEndDate03=new ArrayList();
ArrayList ContractRemindDay03=new ArrayList();

RecordSet.executeSql(sqlstr);

while(RecordSet.next())
{
	ContractId03.add(RecordSet.getString("id"));
	ContractCrmId03.add(RecordSet.getString("crmId"));
	ContractEndDate03.add(RecordSet.getString("endDate"));
	ContractRemindDay03.add(RecordSet.getString("remindDay"));
}

for (int i=0 ; i<ContractId03.size();i++)
{
			String ContractDateTemp01 = (String)ContractEndDate03.get(i);
			int RemindDayTemp = Util.getIntValue((String)ContractRemindDay03.get(i),0);
			Calendar Todaydate = Calendar.getInstance();
			int ThisYear = Util.getIntValue(ContractDateTemp01.substring(0,4));
			int ThisMonth = Util.getIntValue(ContractDateTemp01.substring(5,7))-1;
			int ThisDay = Util.getIntValue(ContractDateTemp01.substring(8,10));
			Todaydate.set(ThisYear,ThisMonth,ThisDay);
			Todaydate.add(Calendar.DATE,-1*RemindDayTemp);
			String ContractDateTemp02=Util.add0(Todaydate.get(Calendar.YEAR), 4) +"-"+
			Util.add0(Todaydate.get(Calendar.MONTH) + 1, 2) +"-"+
			Util.add0(Todaydate.get(Calendar.DAY_OF_MONTH), 2) ;
			
			
			if (ContractDateTemp02.compareTo(today)>0) {
			ContractId03.remove(i);	
			ContractCrmId03.remove(i);
			ContractEndDate03.remove(i);
			ContractRemindDay03.remove(i);
			}

}

if (ContractId03.size()>0) {
	
%>
<BR><BR>
<table class=ListStyle id=tblReport cellspacing=1>

    <tbody> 
    <tr class=Header> 
      <th ><b><%=SystemEnv.getHtmlLabelName(15235,user.getLanguage())%></b></th>
	  <td><%=SystemEnv.getHtmlLabelName(614,user.getLanguage())%></td>
	  <td><%=SystemEnv.getHtmlLabelName(15236,user.getLanguage())%></td>
    </tr>
<TR class=Line style="height: 1px"><TD colSpan=3></TD></TR>
	<%

for (int i=0 ; i<ContractId03.size();i++){
	String ContractId03Str = (String)ContractId03.get(i);
	String ContractCrmId03Str = (String)ContractCrmId03.get(i);
	String ContractEndDate03Str = (String)ContractEndDate03.get(i);	
		if(isLight)
		{%>	
	<TR CLASS=DataDark>
<%		}else{%>
	<TR CLASS=DataLight>
<%		}%>
	<TD><a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=ContractCrmId03Str%>" ><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(ContractCrmId03Str),user.getLanguage())%></a></TD>
    <TD><a href="/CRM/data/ContractView.jsp?CustomerID=<%=ContractCrmId03Str%>&id=<%=ContractId03Str%>" ><%=ContractComInfo.getContractname(ContractId03Str)%></a></TD>
	<TD><%=ContractEndDate03Str%></TD>	
  </TR>
<%
 isLight = !isLight;	
}
%>  
</table>
<%}%>

<!--客户合同到期提醒end-->

<%}%>

<br></br>

<!--销售机会到期提醒begin-->
<%
Calendar today0 = Calendar.getInstance();
String currentdate0 = Util.add0(today0.get(Calendar.YEAR), 4) +"-"+
                     Util.add0(today0.get(Calendar.MONTH) + 1, 2) +"-"+
                     Util.add0(today0.get(Calendar.DAY_OF_MONTH), 2) ;
String sql_M="";
if(!user.getLogintype().equals("2")) {
	sql_M="select t2.* from crm_customerinfo t1,CRM_Sellchance t2 where t1.id=t2.customerid and t2.endtatusid=0 and deleted=0 and t1.manager =" + userid +" and t2.predate <='"+currentdate0+"'";
}else{
	sql_M="select t2.* from crm_customerinfo t1,CRM_Sellchance t2 where t1.id=t2.customerid and t2.endtatusid=0 and deleted=0 and t1.agent =" + userid +" and t2.predate <='"+currentdate0+"'";
}
rs.executeSql(sql_M);
if(rs.getCounts()>0){
%>

<DIV>
<TABLE class=ListStyle cellspacing=1>
    <COLGROUP>
    <COL width="35%">
    <COL width="15%">
    <COL width="15%">    
    <COL width="10%">   
    <COL width="10%">
    <COL width="15%">
        <TBODY>
   
    <TR class=header><th colspan=6>
        <%=SystemEnv.getHtmlLabelName(2227,user.getLanguage())%></th>
    </TR>
	    <TR class=Header>
        <th><%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%></th>
        <th><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%></th>
        <th><%=SystemEnv.getHtmlLabelName(2248,user.getLanguage())%></th>
        <th><%=SystemEnv.getHtmlLabelName(2249,user.getLanguage())%></th>         
        <th><%=SystemEnv.getHtmlLabelName(2250,user.getLanguage())%></th>         
        <th><%=SystemEnv.getHtmlLabelName(2247,user.getLanguage())%></th>
	    </TR>
<TR class=Line style="height: 1px"><TD colSpan=6></TD></TR>
<%
 isLight = false;
while(rs.next()){
        if(isLight = !isLight)
		{%>	
	    <TR CLASS=DataLight>
        <%		}else{%>
	    <TR CLASS=DataDark>
        <%		}%>

        <TD><a href="/CRM/sellchance/ViewSellChance.jsp?id=<%=rs.getString(1)%>&CustomerID=<%=rs.getString("customerid")%>"><%=Util.toScreen(rs.getString("subject"),user.getLanguage())%></a></TD>
        <TD>  <a href="/CRM/data/ViewCustomer.jsp?log=n&CustomerID=<%=rs.getString("customerid")%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(rs.getString("customerid")),user.getLanguage())%></a>            

       </TD>
         <TD>
        <%=Util.toScreen(rs.getString("preyield"),user.getLanguage())%>
        </TD>
        <TD>
        <%=Util.toScreen(rs.getString("probability"),user.getLanguage())%>
        </TD> 
        <TD>
        
        <%=Util.toScreen(SellstatusComInfo.getSellStatusname(rs.getString("sellstatusid")),user.getLanguage())%>
        </TD>         
        <TD>
        <%=Util.toScreen(rs.getString("predate"),user.getLanguage())%>
        </TD>
	</TR>
<%}%>   
</TABLE>
</DIV>
<%}%>
<!--销售机会到期提醒end-->

		</td>
		</tr>
		</TABLE>
	</td>
	<td></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</body>
</html>