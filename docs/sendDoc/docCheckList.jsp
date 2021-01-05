
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<%
boolean canedit=false;
if(HrmUserVarify.checkUserRight("SendDoc:Manage",user)) {
	canedit=true;
   }
if (!canedit) response.sendRedirect("/notice/noright.jsp");
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(16991,user.getLanguage());
String needfav ="1";
String needhelp ="";


int pagenum=Util.getIntValue(request.getParameter("pagenum"),1);
int perpage=Util.getPerpageLog();
if(perpage<=1 )	perpage=15;
String sqlstr ="";
String sqltemp="";
String temptable = "docCheckTempTable"+ Util.getNumberRandom() ;
if(RecordSet.getDBType().equals("oracle")){
     sqlstr= "create table "+temptable+" as select * from (select id,subject,docKind,docInstancyLevel,docSecretLevel,sendDate from DocSendDocDetail where status='0' order by id desc ) where rownum<"+ (pagenum*perpage+2);
}else{
     sqlstr= "select top "+(pagenum*perpage+1)+" id,subject,docKind,docInstancyLevel,docSecretLevel,sendDate into "+temptable+" from  DocSendDocDetail where status='0' order by id desc ";
}
RecordSet.executeSql(sqlstr);
RecordSet.executeSql("Select count(id) RecordSetCounts from "+temptable);
boolean hasNextPage=false;
int RecordSetCounts = 0;
if(RecordSet.next()){
	RecordSetCounts = RecordSet.getInt("RecordSetCounts");
}
if(RecordSetCounts>pagenum*perpage){
	hasNextPage=true;
}

if(RecordSet.getDBType().equals("oracle")){
	sqltemp="select * from (select * from  "+temptable+" order by id asc ) where rownum< "+(RecordSetCounts-(pagenum-1)*perpage-1) ;
}else{
	sqltemp="select top "+(RecordSetCounts-(pagenum-1)*perpage)+" * from "+temptable+" order by id asc";
}
RecordSet.executeSql(sqltemp);
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%if(pagenum>1){
RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",javascript:OnSubmit("+(pagenum-1)+"),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
}
if(hasNextPage){
RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",javascript:OnSubmit("+(pagenum+1)+"),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
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
<TABLE class=Shadow>
<tr>
<td valign="top">

<TABLE class=ListStyle cellspacing=1 >
<TBODY>
<colgroup>
<col width="2%">
<col width="26%">
<col width="19%">
<col width="19%">
<col width="19%">
<col width="15%">
<TR class=Header>
    <th width=10>&nbsp;</th>
    <th><%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%></th>
    <th><%=SystemEnv.getHtmlLabelName(16973,user.getLanguage())%></th>
    <th><%=SystemEnv.getHtmlLabelName(15534,user.getLanguage())%></th>
    <th><%=SystemEnv.getHtmlLabelName(16972,user.getLanguage())%></th>
    <th><%=SystemEnv.getHtmlLabelName(16984,user.getLanguage())%></th>
</TR>
<TR class=Line><TD colspan="6" ></TD></TR>

<%
boolean isLight = false;
int totalline=1;
if(RecordSet.last()){
    do{
        String id=RecordSet.getString("id");
        String subject= RecordSet.getString("subject");
        String docKind= RecordSet.getString("docKind");
        String docInstancyLevel= RecordSet.getString("docInstancyLevel");
        String docSecretLevel= RecordSet.getString("docSecretLevel");
        String sendDate= RecordSet.getString("sendDate");
        if(isLight)
        {%>
        <TR CLASS=DataDark>
    <%		}else{%>
        <TR CLASS=DataLight>
    <%		}%>

                <th width=10><!--input class=inputstyle type=checkbox name=IDs value="<%=id%>"--></th>
                <td><a href="docCheckDetail.jsp?sendDocId=<%=id%>"><%=subject%></a></td>
                <td><%=docKind%></td>
                <td><%=docInstancyLevel%></td>
                <td><%=docSecretLevel%></td>
                <td><%=sendDate%></td>
        </tr>
    <%
        isLight = !isLight;
        if(hasNextPage){
            totalline+=1;
            if(totalline>perpage)	break;
	    }
    } while(RecordSet.previous());
}
RecordSet.executeSql("drop table "+temptable);
%>
</TBODY>
 </TABLE>
<form id=frmmain name=frmmain method=post action="docCheckList.jsp">
 <input type=hidden id=pagenum name=pagenum value="<%=pagenum%>">
</FORM>
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
</body>
</html>
<script language=javascript>
function OnSubmit(pagenum){
        document.frmmain.pagenum.value = pagenum;
		document.frmmain.submit();
}
</script>