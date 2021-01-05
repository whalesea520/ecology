
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="CustomerContacterComInfo" class="weaver.crm.Maint.CustomerContacterComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="HrmCareerApplyComInfo" class="weaver.hrm.career.HrmCareerApplyComInfo" scope="page" />

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
boolean canEditHrm = false;
boolean canEditCrm = false;

if(!HrmUserVarify.checkUserRight("HrmMailMerge:Merge", user)&&!HrmUserVarify.checkUserRight("MailMerge:Merge", user)){
    response.sendRedirect("/notice/noright.jsp") ;
	return ;
}else if(HrmUserVarify.checkUserRight("HrmMailMerge:Merge", user)&&HrmUserVarify.checkUserRight("MailMerge:Merge", user)){
    canEditCrm = true;
    canEditHrm = true;
}else if(HrmUserVarify.checkUserRight("HrmMailMerge:Merge", user)){
    canEditHrm = true;
}else if(HrmUserVarify.checkUserRight("MailMerge:Merge", user)){
    canEditCrm = true;
}

int userid=user.getUID();   //Util.getIntValue(request.getParameter("userid"),0);
int pagenum=Util.getIntValue(request.getParameter("pagenum"),1);
int perpage=Util.getPerpageLog();

if(perpage<=1 )	perpage=10;
String useridname=ResourceComInfo.getResourcename(userid+"");
String fromdate=Util.null2String(request.getParameter("fromdate"));
String enddate=Util.null2String(request.getParameter("enddate"));
String isfinished=Util.null2String(request.getParameter("isfinished"));
String subject=Util.null2String(request.getParameter("subject"));
String mailtype=Util.null2String(request.getParameter("mailtype"));

String isDelete = Util.null2String(request.getParameter("isDelete"));
String[] deleteItems = request.getParameterValues("deleteItem");
String deleteItem = "";
if("true".equals(isDelete)&&deleteItems!=null&&deleteItems.length>0){
    for(int i=0; i<deleteItems.length; i++){
        deleteItem += ","+deleteItems[i];
    }
    deleteItem = deleteItem.substring(1);
    String temStr = "delete from MailSendMain where id in ("+deleteItem+")";
    RecordSet.executeSql(temStr);
    temStr = "delete from MailSendRecord where id in ("+deleteItem+")";
    RecordSet.executeSql(temStr);
}

String tempSql = "";

String sqlwhere="";
if(canEditHrm&&canEditCrm){
    sqlwhere = "";
}else if(canEditHrm){
    sqlwhere = " where sendtotype in ('1','2') ";
}else if(canEditCrm){
    sqlwhere = " where sendtotype in ('5','6','0') ";
}

//if(userid!=0){
//	if(sqlwhere.equals(""))	sqlwhere+=" where sender="+userid;
//	else	sqlwhere+=" and sender="+userid;
//}
if(!fromdate.equals("")){
	if(sqlwhere.equals(""))	sqlwhere+=" where senddate>='"+fromdate+"'";
	else 	sqlwhere+=" and senddate>='"+fromdate+"'";
}
if(!enddate.equals("")){
	if(sqlwhere.equals(""))	sqlwhere+=" where senddate<='"+enddate+"'";
	else 	sqlwhere+=" and senddate<='"+enddate+"'";
}

if(!isfinished.equals("")){
	if(sqlwhere.equals(""))	sqlwhere+=" where isfinished = '"+isfinished+"'";
	else 	sqlwhere+=" and isfinished = '"+isfinished+"'";

}

if(!mailtype.equals("")){
	if(sqlwhere.equals(""))	sqlwhere+=" where sendtotype ='%"+mailtype+"%'";
	else 	sqlwhere+=" and sendtotype like '%"+mailtype+"%'";

}




/*
if(user.getLogintype().equals("2")){
	if(sqlwhere.equals(""))	sqlwhere+=" where agentid!='' and  agentid!='0'";
	else 	sqlwhere+=" and  agentid!='' and  agentid!='0'";
}
*/
String sqlstr = "";

String temptable = "temptable"+ Util.getNumberRandom() ;

if(RecordSet.getDBType().equals("oracle")){
		sqlstr = "create table "+temptable+"  as select * from (select * from MailSendMain   "+ sqlwhere +"   order by id desc) where rownum<"+ (pagenum*perpage+2);
}else if(RecordSet.getDBType().equals("db2")){
		sqlstr = "create table "+temptable+"  as (  select * from MailSendMain  ) definition only";
        RecordSet.executeSql(sqlstr);
        sqlstr = "insert into "+temptable+" (   select * from MailSendMain   "+ sqlwhere +"   order by id desc fetch first "+(pagenum*perpage+1)+"  rows only)";
}else{
		sqlstr = "select top "+(pagenum*perpage+1)+" * into "+temptable+" from MailSendMain "+ sqlwhere  + "  order by id desc";
}



RecordSet.executeSql(sqlstr);


String smsnum = "";
RecordSet.executeSql("Select count(id) RecordSetCounts from "+temptable);
boolean hasNextPage=false;
int RecordSetCounts = 0;
if(RecordSet.next()){
	RecordSetCounts = RecordSet.getInt("RecordSetCounts");
}

if(RecordSetCounts>pagenum*perpage){
	hasNextPage=true;
}
	String sqltemp="";
if(RecordSet.getDBType().equals("oracle")){
	sqltemp="select * from (select * from  "+temptable+" order by id) where rownum< "+(RecordSetCounts-(pagenum-1)*perpage+1);
}else if(RecordSet.getDBType().equals("db2")){
	sqltemp="select *  from  "+temptable+" order by id fetch first  "+(RecordSetCounts-(pagenum-1)*perpage+1)+"  rows only";
}else{
	sqltemp="select top "+(RecordSetCounts-(pagenum-1)*perpage)+" * from "+temptable+"  order by id";
}
RecordSet.executeSql(sqltemp);


String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(16441,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:doSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:doDelete(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

if(pagenum>1){
RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",SendMailPlanSearch.jsp?pagenum="+(pagenum-1)+"&fromdate="+fromdate+"&enddate="+enddate+"&subject="+subject+"&isfinished=" + isfinished + "&mailtype="+mailtype+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}

if(hasNextPage){
RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",SendMailPlanSearch.jsp?pagenum="+(pagenum+1)+"&fromdate="+fromdate+"&enddate="+enddate+"&subject="+subject+"&isfinished=" + isfinished + "&mailtype="+mailtype+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}

%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<form name=frmmain method=post action="SendMailPlanSearch.jsp">
<input type="hidden" name="isDelete" value="false">
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


			<table class=ViewForm>
			  <colgroup>
			  <col width="10%">
			  <col width="30%">
			  <col width="10%">
			  <col width="20%">
			  <col width="8%">
			  <col width="22%">
			  <tbody>
			  <tr>

			  <td><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></td>
			  <td class=field>
			  <BUTTON class=calendar id=SelectDate onclick=getDate(fromdatespan,fromdate)></BUTTON>&nbsp;
			  <SPAN id=fromdatespan ><%=Util.toScreen(fromdate,user.getLanguage())%></SPAN>
			  <input type="hidden" name="fromdate" value=<%=fromdate%>>
			  －<BUTTON class=calendar id=SelectDate onclick=getDate(enddatespan,enddate)></BUTTON>&nbsp;
			  <SPAN id=enddatespan ><%=Util.toScreen(enddate,user.getLanguage())%></SPAN>
			  <input type="hidden" name="enddate" value=<%=enddate%>>
			  </td>
              <td><%=SystemEnv.getHtmlLabelName(18958,user.getLanguage())%></td>
              <td>
              <select class=saveHistory id=isfinished  name=isfinished>
				<option value=""></option>
				<option value=0 <%if(isfinished.equals("0")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18525,user.getLanguage())%></option>
				<option value=1 <%if(isfinished.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18524,user.getLanguage())%></option>
			 </select>
              </td>
              <td><%=SystemEnv.getHtmlLabelName(18959,user.getLanguage())%></td>
              <td>
              <select class=saveHistory id=mailtype  name=mailtype>
				<option value=""></option>
				<option value=1 <%if(mailtype.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(362,user.getLanguage())%></option>
				<option value=2 <%if(mailtype.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(773,user.getLanguage())%></option>
				<option value=5 <%if(mailtype.equals("5")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%></option>
				<option value=6 <%if(mailtype.equals("6")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(17129,user.getLanguage())%></option>
				<option value=0 <%if(mailtype.equals("0")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(375,user.getLanguage())%></option>
			 </select>
              </td>
			  </tr>
			  <TR><TD class=Line colSpan=6></TD></TR>
			<script language=vbs>
			sub onShowuserid()
				id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
				if (Not IsEmpty(id)) then
				if id(0)<> "" then
				useridspan.innerHtml = "<A href='Hrmuserid.jsp?id="&id(0)&"'>"&id(1)&"</A>"
				frmmain.userid.value=id(0)
				else
				useridspan.innerHtml = ""
				frmmain.userid.value=""
				end if
				end if
			end sub
			</script>
			</tbody>
			</table>
			<BR>
			<TABLE class=ListStyle cellspacing="1">
			  <COLGROUP>
              <COL width="3%">
              <COL width="40%">
			  <COL width="6%">
              <COL width="18%">
              <COL width="15%">

			  <TBODY>
			  <TR class=Header>
              <th></th>
              <th><%=SystemEnv.getHtmlLabelName(18960,user.getLanguage())%></th>
              <th><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></th>
              <th><%=SystemEnv.getHtmlLabelName(18961,user.getLanguage())%></th>
              <th></th>
			  </tr>
			  <TR class=Line1><TH colspan="6" ></TH></TR>
			<%
			boolean islight=true;
			int totalline=1;
			if(RecordSet.last()){
				do{
			if (islight) {
			%>
			<tr class=datadark>
			<%}else{%>
			<tr class=datalight>
			<%}%>
                    <TD><input type="checkbox" name="deleteItem" value="<%=RecordSet.getString("id")%>"></TD>
					<TD>
        <%=RecordSet.getString("sendfrom")%>&nbsp;&nbsp;&nbsp;&nbsp;
        <a href="/hrm/resource/HrmResource.jsp?id=<%=RecordSet.getString("sender")%>">
        <%=ResourceComInfo.getLastname(RecordSet.getString("sender"))%>
        </a>
                    </TD>

                    <TD>
                    <%if(RecordSet.getString("isfinished").equals("0")){%>
					<%=SystemEnv.getHtmlLabelName(18525,user.getLanguage())%>
                    <%}else if(RecordSet.getString("isfinished").equals("1")){%>
                    <%=SystemEnv.getHtmlLabelName(18524,user.getLanguage())%>
                    <%}%>
                    </TD>
					<TD><%=Util.toScreen(RecordSet.getString("senddate"),user.getLanguage())%>&nbsp;&nbsp;<%=Util.toScreen(RecordSet.getString("sendtime"),user.getLanguage())%></TD>
                    <td>
                    <a href="/sendmail/SendMailPlanDetail.jsp?id=<%=RecordSet.getString("id")%>">
                    <%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
                    </a>
                    </td>
			</tr>

			<%
				islight=!islight;
				if(hasNextPage){
					totalline+=1;
					if(totalline>perpage)	break;
				}
			}while(RecordSet.previous());
			}
			RecordSet.executeSql("drop table "+temptable);
			%>

			</table>
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

</form>
</body>
<script language="javascript">
function doDelete(){
    if(isdel()){
        document.frmmain.isDelete.value="true";
        document.frmmain.submit();
    }
}
function doSubmit()
{
	document.frmmain.submit();
}
</script>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</html>