
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

if(!HrmUserVarify.checkUserRight("HrmMailMerge:Merge", user)){
    response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

int userid=user.getUID();   //Util.getIntValue(request.getParameter("userid"),0);
int pagenum=Util.getIntValue(request.getParameter("pagenum"),1);
int perpage=Util.getPerpageLog();
//System.out.println("perpage:"+perpage);
if(perpage<=1 )	perpage=10;
String useridname=ResourceComInfo.getResourcename(userid+"");
//String fromdate=Util.null2String(request.getParameter("fromdate"));
//String enddate=Util.null2String(request.getParameter("enddate"));
//String isfinished=Util.null2String(request.getParameter("isfinished"));
//String subject=Util.null2String(request.getParameter("subject"));
//String mailtype=Util.null2String(request.getParameter("mailtype"));
String id=Util.null2String(request.getParameter("id"));

//String isDelete = Util.null2String(request.getParameter("isDelete"));
//String[] deleteItems = request.getParameterValues("deleteItem");
//String deleteItem = "";
//if("true".equals(isDelete)&&deleteItems!=null&&deleteItems.length>0){
//    for(int i=0; i<deleteItems.length; i++){
//        deleteItem += ","+deleteItems[i];
//    }
//    deleteItem = deleteItem.substring(1);
//    String temStr = "update MailSendRecord set isdeleted='1' where id in ("+deleteItem+")";
//    //System.out.println("temStr = " + temStr);
//    RecordSet.executeSql(temStr);
//}

String tempSql = "";

String sqlwhere="where t1.id = "+id+" and t1.id=t2.id ";
//if(userid!=0){
//	if(sqlwhere.equals(""))	sqlwhere+=" where sender="+userid;
//	else	sqlwhere+=" and sender="+userid;
//}
//if(!fromdate.equals("")){
//	if(sqlwhere.equals(""))	sqlwhere+=" where senddate>='"+fromdate+"'";
//	else 	sqlwhere+=" and senddate>='"+fromdate+"'";
//}
//if(!enddate.equals("")){
//	if(sqlwhere.equals(""))	sqlwhere+=" where senddate<='"+enddate+"'";
//	else 	sqlwhere+=" and senddate<='"+enddate+"'";
//}
//
//if(!isfinished.equals("")){
//	if(sqlwhere.equals(""))	sqlwhere+=" where isfinished = '"+isfinished+"'";
//	else 	sqlwhere+=" and isfinished = '"+isfinished+"'";
//
//}
//if(!subject.equals("")){
//	if(sqlwhere.equals(""))	sqlwhere+=" where subject like '%"+subject+"%'";
//	else 	sqlwhere+=" and subject like '%"+subject+"%'";
//
//}
//
//if(!mailtype.equals("")){
//	if(sqlwhere.equals(""))	sqlwhere+=" where sendtotype ='%"+mailtype+"%'";
//	else 	sqlwhere+=" and sendtotype like '%"+mailtype+"%'";
//
//}


    //System.out.println("sqlwhere = " + sqlwhere);

String sqlstr = "";

String temptable = "temptable"+ Util.getNumberRandom() ;

if(RecordSet.getDBType().equals("oracle")){
		sqlstr = "create table "+temptable+"  as select * from (select t1.sendto,t1.subject,t1.sendtoid,t2.* from MailSendRecord t1,MailSendMain t2  "+ sqlwhere +"   order by sendto) where rownum<"+ (pagenum*perpage+2);

}else{
		sqlstr = "select top "+(pagenum*perpage+1)+" t1.sendto,t1.subject,t1.sendtoid,t2.* into "+temptable+" from MailSendRecord t1,MailSendMain t2  "+ sqlwhere  + "  order by sendto";
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
//RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:doSubmit(),_self} " ;
//RCMenuHeight += RCMenuHeightStep ;

//RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:doDelete(),_self} " ;
//RCMenuHeight += RCMenuHeightStep ;

if(pagenum>1){
//RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",SendMailPlanSearch.jsp?pagenum="+(pagenum-1)+"&fromdate="+fromdate+"&enddate="+enddate+"&subject="+subject+"&isfinished=" + isfinished + "&mailtype="+mailtype+",_self} " ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",SendMailPlanSearch.jsp?pagenum="+(pagenum-1)+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}

if(hasNextPage){
//RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",SendMailPlanSearch.jsp?pagenum="+(pagenum+1)+"&fromdate="+fromdate+"&enddate="+enddate+"&subject="+subject+"&isfinished=" + isfinished + "&mailtype="+mailtype+",_self} " ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",SendMailPlanSearch.jsp?pagenum="+(pagenum+1)+",_self} " ;
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



			<TABLE class=ListStyle cellspacing="1">
			  <COLGROUP>
              <COL width="30%">
              <COL width="70%">
			  <TBODY>
			  <TR class=Header>
			  <th><%=SystemEnv.getHtmlLabelName(15525,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(110,user.getLanguage())%></th>
			  <th><%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%></th>
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
                    <TD><%=RecordSet.getString("sendto")%>&nbsp;&nbsp;&nbsp;&nbsp;
<%
    if(RecordSet.getString("sendtotype").equals("1")){
%>
<a href="/hrm/resource/HrmResource.jsp?id=<%=RecordSet.getString("sendtoid")%>">
<%=ResourceComInfo.getLastname(RecordSet.getString("sendtoid"))%>
</a>
<%
    }else if(RecordSet.getString("sendtotype").equals("2")){
%>
<a href="/hrm/career/HrmCareerApplyEdit.jsp?applyid=<%=RecordSet.getString("sendtoid")%>">
<%
        tempSql = "select lastname from HrmCareerApply where id = "+RecordSet.getString("sendtoid");
        RecordSet2.executeSql(tempSql);
        if(RecordSet2.next()){
%>
<%=RecordSet2.getString("lastname")%>
<%
        }
%>
</a>
<%
    }else if(RecordSet.getString("sendtotype").equals("5")){
%>
<a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=RecordSet.getString("sendtoid")%>">
<%=CustomerInfoComInfo.getCustomerInfoname(RecordSet.getString("sendtoid"))%>
</a>
<%
    }else if(RecordSet.getString("sendtotype").equals("6")){
%>
<a href="/CRM/data/ViewContacter.jsp?log=n&canedit=false&ContacterID=<%=RecordSet.getString("sendtoid")%>">
<%=CustomerContacterComInfo.getCustomerContactername(RecordSet.getString("sendtoid"))%>
</a>
<%
    }else{
%>
<%
    }
%>

                    </TD>
					<TD><%=Util.toScreen(RecordSet.getString("subject"),user.getLanguage())%></TD>
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
</html>