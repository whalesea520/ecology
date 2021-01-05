
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetL" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="RecordSetShare" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="RecordSetV" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SptmForCrmModiRecord" class="weaver.crm.SptmForCrmModiRecord" scope="page" />

<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page"/>

<%
String CustomerID = Util.null2String(request.getParameter("CustomerID"));
String log=Util.null2String(request.getParameter("log"));
boolean isfromtab =  Util.null2String(request.getParameter("isfromtab")).equals("true")?true:false;
RecordSetL.executeProc("CRM_Log_Select",CustomerID);

RecordSet.executeProc("CRM_CustomerInfo_SelectByID",CustomerID);
if(RecordSet.getCounts()<=0)
{
	response.sendRedirect("/base/error/DBError.jsp?type=FindData");
	return;
}
RecordSet.first();

/*check right begin*/

String useridcheck=""+user.getUID();
String customerDepartment=""+RecordSet.getString("department") ;

boolean canview=false;
boolean canedit=false;
boolean canviewlog=false;
boolean canmailmerge=false;
boolean canapprove=false;

int sharelevel = CrmShareBase.getRightLevelForCRM(""+user.getUID(),CustomerID);
if(sharelevel>0){
     canview=true;
     canviewlog=true;
     canmailmerge=true;
     if(sharelevel==2) canedit=true;
     if(sharelevel==3||sharelevel==4){
         canedit=true;
         canapprove=true;
     }
}

if(useridcheck.equals(RecordSet.getString("agent"))) {
	 canview=true;
	 canedit=true;
	 canviewlog=true;
	 canmailmerge=true;
 }

if(RecordSet.getInt("status")==7 || RecordSet.getInt("status")==8){
	canedit=false;
}

/*check right end*/

if(!canview){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
%>

<HTML><HEAD>
<%if(isfromtab) {%>
<base target='_blank'/>
<%} %>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</HEAD>
<%
String imagefilename = "/images/hdReport_wev8.gif";
String titlename =  SystemEnv.getHtmlLabelName(103,user.getLanguage())+SystemEnv.getHtmlLabelName(264,user.getLanguage())+" - <a href='/CRM/data/ViewModify.jsp?log="+log+"&CustomerID="+RecordSet.getString("id")+"'>"+SystemEnv.getHtmlLabelName(361,user.getLanguage())+"</a>"+" - "+SystemEnv.getHtmlLabelName(136,user.getLanguage())+":<a href='/CRM/data/ViewCustomer.jsp?log="+log+"&CustomerID="+RecordSet.getString("id")+"'>"+Util.toScreen(RecordSet.getString("name"),user.getLanguage())+"</a>";
String needfav ="1";
String needhelp ="";
%>
<BODY>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(!isfromtab){
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goBack(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
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
		<% if(!isfromtab){%>
		<TABLE class=Shadow>
		<%}else{ %>
		<TABLE width='100%'>
		<%} %>
		<tr>
		<td valign="top">
	  <TABLE class=ListStyle cellspacing=1>
        <COLGROUP>
		<COL width="20%">
  		<COL width="15%">
  		<COL width="15%">
		<COL width="10%">
  		<COL width="40%">
        <TBODY>
	    <TR class=Header>
	      <th><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></th>
	      <th><%=SystemEnv.getHtmlLabelName(616,user.getLanguage())%></th>
	      <th>IP Address</th>
	      <th><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></th>
          <th>修改日志</th>
	    </TR>
<TR class=Line><TD colSpan=5 style="padding: 0"></TD></TR>
<%
boolean isLight = false;
int nLogCount=0;
while(RecordSetL.next())
{
	String modifytime = RecordSetL.getString("submittime");
	String modifydata = RecordSetL.getString("submitdate");
	String contentmp = "";
	nLogCount++;
		if(isLight)
		{%>	
	<TR CLASS=DataLight>
<%		}else{%>
	<TR CLASS=DataDark>
<%		}%>
          <TD><%=modifydata%> <%=modifytime%></TD>
          <TD>
	<%if(!user.getLogintype().equals("2")) {%>
		<%if(!RecordSetL.getString("submitertype").equals("2")) {%>		  
			<a href="/hrm/resource/HrmResource.jsp?id=<%=RecordSetL.getString("submiter")%>"><%=Util.toScreen(ResourceComInfo.getResourcename(RecordSetL.getString("submiter")),user.getLanguage())%></a>
		<%}else{%>
			<a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=RecordSetL.getString("submiter")%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(RecordSetL.getString("submiter")),user.getLanguage())%></a>		
		<%}%>
	<%}else{%>
		<%if(!RecordSetL.getString("submitertype").equals("2")) {%>		  
			<%=Util.toScreen(ResourceComInfo.getResourcename(RecordSetL.getString("submiter")),user.getLanguage())%>
		<%}else{%>
			<a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=RecordSetL.getString("submiter")%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(RecordSetL.getString("submiter")),user.getLanguage())%></a>		
		<%}%>	
	<%}%>
		  </TD>
          <TD><%=RecordSetL.getString("clientip")%></TD>
		  <TD>
<%
	String strTemp1 = RecordSetL.getString("logtype");
	String strTemp2 = "";
	if(strTemp1.substring(0,1).equals("n"))
	{
		%><%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%><%
	}
		else if(strTemp1.substring(0,1).equals("d"))
	{
		%><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%><%
	}
	else if(strTemp1.substring(0,1).equals("a"))
	{
		%><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%><%
	}
	else if(strTemp1.substring(0,1).equals("p"))
	{
		%><%=SystemEnv.getHtmlLabelName(582,user.getLanguage())%><%
	}
	else if(strTemp1.substring(0,1).equals("m"))
	{
		%><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%><%
	}
	else if(strTemp1.substring(0,1).equals("u"))
	{
		contentmp = RecordSetL.getString("logcontent");
		%><%=SystemEnv.getHtmlLabelName(216,user.getLanguage())%>
 
		<!-加入合并客户的信息-->
		 
		<%
		//如果是客户管理员
		
		//if (rs.next())
		{
		String unitcrm=RecordSetL.getString("logcontent");
		 try { contentmp="相关客户(";
		 
		   unitcrm=unitcrm.substring(unitcrm.indexOf(": ")+1);
		//out.print(unitcrm);
		ArrayList crmnameArray=Util.TokenizerString(unitcrm,",");
		for(int k=0;k<crmnameArray.size();k++)
		{
		String tempcrmname=""+crmnameArray.get(k);
		 
		rs.execute("select id from crm_customerinfo where deleted='1' and name='"+tempcrmname.trim()+"' ");
		//out.print("select id from crm_customerinfo where name='"+tempcrmname.trim()+"' ");
		while (rs.next()) 
		{ String temcrmid=rs.getString(1);
		contentmp+="<a href='/CRM/data/ViewCustomer.jsp?CustomerID="+temcrmid+"' target='_news'>"+tempcrmname+"</a> 　";
		}
		 
		 
		}
		 contentmp+=")";
		 }
		 catch (Exception ee)
		{}
		}
 
	}	
	if(strTemp1.length()>1)
	{
		if(strTemp1.substring(1).equals("c"))
		{
			%>: <%=SystemEnv.getHtmlLabelName(572,user.getLanguage())%><%
		}else if(strTemp1.substring(1).equals("a"))
		{
			%>: <%=SystemEnv.getHtmlLabelName(110,user.getLanguage())%><%
		}else if(strTemp1.substring(1).equals("s"))
		{
			%>: <%=SystemEnv.getHtmlLabelName(119,user.getLanguage())%><%
		}
	}
		%>&nbsp;<%
%>
		  </TD>   
		  <TD>
		      <%
			     
			     RecordSetV.executeSql("select fieldname,original,modified from CRM_Modify where customerid = "+CustomerID+" and modifydate='"+modifydata+"' and modifytime='"+modifytime+"' and fieldname <> '中介机构' order by modifydate,modifytime desc");
		         while (RecordSetV.next()) {

					 String fieldname = Util.null2String(RecordSetV.getString("fieldname"));
                     String original = RecordSetV.getString("original");
					 String modified = RecordSetV.getString("modified");

					 String oldstr = "";
					 String newstr = "";
					 if(!"".equals(original)) {
					    oldstr = SptmForCrmModiRecord.getCrmModiInfo(fieldname,original);
					 }
					 if(!"".equals(modified)) {
					    newstr = SptmForCrmModiRecord.getCrmModiInfo(fieldname,modified);
					 }
					 if(!"".equals(oldstr) || !"".equals(newstr)) {
						if("".equals(oldstr)) oldstr = "&nbsp;&nbsp;";
                        contentmp += fieldname +"由<font color=red>\"" + oldstr + "\"</font>改成:<font color=red>'"+ newstr +"'</font> </br>";
					 } else {
						 if("".equals(original)) original = "&nbsp;&nbsp;";
						 contentmp += fieldname +"由<font color=red>\"" + original + "\"</font>改成:<font color=red>'"+ modified +"'</font> </br>";
					 }
				 }
		      %>
			  <%=contentmp%>
		  </TD>
        </TR>
<%
	isLight = !isLight;
}
%>
	  </TBODY>
	  </TABLE>
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
<SCRIPT language="JavaScript">
function goBack() {
	window.location.href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=CustomerID%>";
}
</SCRIPT>
</BODY>
</HTML>
