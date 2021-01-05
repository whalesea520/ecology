
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CategoryUtil" class="weaver.docs.category.CategoryUtil" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<%
boolean canedit=false;
if(HrmUserVarify.checkUserRight("SendDoc:Manage",user)) {
	canedit=true;
   }
String id = ""+Util.getIntValue(request.getParameter("sendDocId"),0);
String subject= "";
String docIds="";
String docKind= "";
String docInstancyLevel= "";
String docSecretLevel= "";
String docNumber_1= "";
String docNumberYear_1= "";
String docNumberIssue_1= "";
String docNumber_2= "";
String docNumberYear_2= "";
String docNumberIssue_2= "";
String sendDate= "";
String sendDepartment= "";
String department_1= "";
String department_2= "";
String department_3= "";
String department_4= "";
String signer= "";
String signDate= "";
String requestLog= "";
String status= "";
String createDate= "";
ArrayList docIdsList=new ArrayList();
RecordSet.executeSql("select * from DocSendDocDetail where id="+id);
if(RecordSet.last()){
    subject= RecordSet.getString("subject");
    docIds= RecordSet.getString("docIds");
    docKind= RecordSet.getString("docKind");
    docInstancyLevel= RecordSet.getString("docInstancyLevel");
    docSecretLevel= RecordSet.getString("docSecretLevel");
    docNumber_1= RecordSet.getString("docNumber_1");
    docNumberYear_1= RecordSet.getString("docNumberYear_1");
    docNumberIssue_1= RecordSet.getString("docNumberIssue_1");
    docNumber_2= RecordSet.getString("docNumber_2");
    docNumberYear_2= RecordSet.getString("docNumberYear_2");
    docNumberIssue_2= RecordSet.getString("docNumberIssue_2");
    sendDate= RecordSet.getString("sendDate");
    sendDepartment= RecordSet.getString("sendDepartment");
    department_1= RecordSet.getString("department_1");
    department_2= RecordSet.getString("department_2");
    department_3= RecordSet.getString("department_3");
    department_4= RecordSet.getString("department_4");
    signer= RecordSet.getString("signer");
    signDate= RecordSet.getString("signDate");
    requestLog= RecordSet.getString("requestLog");
    status= RecordSet.getString("status");
    createDate= RecordSet.getString("createDate");
    docIdsList=Util.TokenizerString(docIds,",");
}
String checkStr="";
if(canedit&&(status.equals("0"))){
   checkStr+="docNumber_1,";
   checkStr+="docNumberYear_1,";
   checkStr+="docNumberIssue_1,";
   for(int i=0;i<docIdsList.size();i++)
   {
      checkStr+="secId_"+i+",";
   }
   checkStr=checkStr.substring(0,checkStr.length()-1);
}
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
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(canedit&&(status.equals("0"))){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:onSubmit(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:history.back(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
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
                  <form id=weaver name=weaver method=post action="docCheckOperation.jsp">
                  <input name="id" type="hidden" value="<%=id%>">
                  <input name="method" type="hidden">
                  <input name="docCount" type="hidden" value="<%=docIdsList.size()%>">
                  <TABLE class=ViewForm>
                  <COLGROUP>
                  <COL width="49%">
                  <COL width=10>
                  <COL width="49%">
                  <TBODY>
                  <TR>
                    <TD vAlign=top>
                      <TABLE class=ViewForm>
                        <COLGROUP>
                        <COL width="20%">
                        <COL width="80%">
                        <TBODY>
                        <TR class=Title>
                         <TH colSpan=2><%=SystemEnv.getHtmlLabelName(61,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(87,user.getLanguage())%></TH>
                         </TR>
                        <TR class=Spacing>
                          <TD class=Line1 colSpan=2></TD>
                        </TR>
                        <TR>
                          <TD><%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%></TD>
                          <TD class=Field><%=subject%></TD>
                        </TR>
                        <tr><td class=Line colspan=2></td></tr>
                        <TR>
                          <TD><%=SystemEnv.getHtmlLabelName(16971,user.getLanguage())%></TD>
                          <TD class=Field>
                          <%if(canedit&&(status.equals("0"))){%>
                          <select name=docNumber_1 size=1 style="width:125" onChange='checkinput("docNumber_1","docNumber_1Span")'>
                            <option value="" ></option>
                            <%
                            RecordSet.executeSql("select name from DocSendDocNumber order by id");
                            while(RecordSet.next()){
                            String temppagename=RecordSet.getString("name");
                            %>
						    <option value="<%=temppagename%>" ><%=temppagename%></option>
						    <%}%>
                          </select><SPAN id=docNumber_1Span ><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN>&nbsp;[<input name=docNumberYear_1 class=inputstyle size=4 onchange='checkinput("docNumberYear_1","docNumberYear_1Span")'><SPAN id=docNumberYear_1Span ><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN>]&nbsp;<%=SystemEnv.getHtmlLabelName(15323,user.getLanguage())%><input name=docNumberIssue_1 class=inputstyle size=4 onchange='checkinput("docNumberIssue_1","docNumberIssue_1Span")'><SPAN id=docNumberIssue_1Span ><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN><%=SystemEnv.getHtmlLabelName(16992,user.getLanguage())%>
                          <%}else{%>
                          <%=docNumber_1%>&nbsp;[<%=docNumberYear_1%>]&nbsp;<%=SystemEnv.getHtmlLabelName(15323,user.getLanguage())%><%=docNumberIssue_1%><%=SystemEnv.getHtmlLabelName(16992,user.getLanguage())%>
                          <%}%>
                          </TD>
                        </TR>
                        <tr><td class=Line colspan=2></td></tr>
                        <TR>
                          <TD><%=SystemEnv.getHtmlLabelName(16993,user.getLanguage())%></TD>
                          <TD class=Field><%=docNumber_2%>&nbsp;[<%=docNumberYear_2%>]&nbsp;<%=SystemEnv.getHtmlLabelName(15323,user.getLanguage())%><%=docNumberIssue_2%><%=SystemEnv.getHtmlLabelName(16992,user.getLanguage())%></TD>
                        </TR>
                        <tr><td class=Line colspan=2></td></tr>
                        <TR>
                          <TD><%=SystemEnv.getHtmlLabelName(15534,user.getLanguage())%></TD>
                          <TD class=Field><%=docInstancyLevel%></TD>
                        </TR>
                        <tr><td class=Line colspan=2></td></tr>
                        <TR>
                          <TD><%=SystemEnv.getHtmlLabelName(16972,user.getLanguage())%></TD>
                          <TD class=Field><%=docSecretLevel%></TD>
                        </TR>
                        <tr><td class=Line colspan=2></td></tr>
                        </TBODY>
                       </TABLE>
                     </TD>
                    <TD></TD>
                    <TD vAlign=top>
                        <TABLE class=ViewForm>
                        <COLGROUP>
                        <COL width="20%">
                        <COL width="80%">
                        <TBODY>
                        <TR class=Title>
                        <TH colSpan=2>&nbsp</TH>
                        </TR>
                        <TR class=Spacing>
                          <TD class=Line1 colSpan=2></TD></TR>
                        <TR>
                          <TD><%=SystemEnv.getHtmlLabelName(16973,user.getLanguage())%></TD>
                          <TD class=Field><%=docKind%></TD>
                        </TR>
                        <tr><td class=Line colspan=2></td></tr>
                         <TR>
                          <TD><%=SystemEnv.getHtmlLabelName(16994,user.getLanguage())%></TD>
                          <TD class=Field><%=sendDepartment%></TD>
                        </TR>
                        <tr><td class=Line colspan=2></td></tr>
                        <TR>
                          <TD><%=SystemEnv.getHtmlLabelName(16984,user.getLanguage())%></TD>
                          <TD class=Field><%=sendDate%></TD>
                        </TR>
                        <tr><td class=Line colspan=2></td></tr>
                        <%if(!status.equals("0")){%>
                        <TR>
                          <TD><%=SystemEnv.getHtmlLabelName(16995,user.getLanguage())%></TD>
                          <TD class=Field><%=ResourceComInfo.getResourcename(signer)%></TD>
                        </TR>
                        <tr><td class=Line colspan=2></td></tr>
                        <TR>
                          <TD><%=SystemEnv.getHtmlLabelName(16996,user.getLanguage())%></TD>
                          <TD class=Field><%=signDate%></TD>
                        </TR>
                        <tr><td class=Line colspan=2></td></tr>
                        <%}%>
                        </TBODY>
                       </TABLE>
                    </TD>
                    </TR>
                    <TR class=Title>
                     <TH colSpan=3><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%></TH>
                     </TR>
                    <TR class=Spacing>
                      <TD class=Line1 colSpan=3></TD>
                    </TR>
                    <TR>
                      <TD class=Field colSpan=3>
                       <TABLE class=ListStyle cellspacing=1 >
                       <COLGROUP>
                        <COL width="10%">
                        <COL width="65%">
                        <COL width="25%">
                       <TBODY>
                       <%
                        boolean isLight = false;
                        for(int i=0;i<docIdsList.size();i++)
                        {
                            if(isLight)
                            {
                            %>
                            <TR CLASS=DataDark>
                            <%		}else{%>
                            <TR CLASS=DataLight>
                            <%		}%>
                            <td><%=SystemEnv.getHtmlLabelName(1341,user.getLanguage())%></td>
                            <td><a href="/docs/docs/DocDsp.jsp?id=<%=(String)docIdsList.get(i)%>" ><%=DocComInfo.getDocname((String)docIdsList.get(i)) %></a></td>
                            <input name="docId_<%=i%>" type="hidden" value="<%=(String)docIdsList.get(i)%>">
                            <td>
                            <%if(canedit&&(status.equals("0"))){%>
                            <%=SystemEnv.getHtmlLabelName(15787,user.getLanguage())%>&nbsp;
                            <select name="secId_<%=i%>" size=1 style="width:125" onChange='checkinput("secId_<%=i%>","secSpan_<%=i%>")'>
                            <option value="" ></option>
                            <%
                            while(SecCategoryComInfo.next()){
                            String tempSecId=SecCategoryComInfo.getSecCategoryid();
                            String tempSecName=SecCategoryComInfo.getSecCategoryname();
                            %>
						    <option value="<%=tempSecId%>" ><%=tempSecName%></option>
						    <%}%>
                            </select>
                            <span id="secSpan_<%=i%>" name="secSpan_<%=i%>"><IMG src="/images/BacoError_wev8.gif" align=absMiddle></span>
                            <%}%>
                            </td>
                            </TR>
                        <%
                            isLight=!isLight;
                        }
                        %>
                        </TBODY>
                        </TABLE>
                      </TD>
                    </TR>
                    <TR class=Title>
                     <TH colSpan=3><%=SystemEnv.getHtmlLabelName(1008,user.getLanguage())%></TH>
                    </TR>
                    <TR class=Spacing>
                      <TD class=Line1 colSpan=3></TD>
                    </TR>
                    <TR>
                      <TD class=Field colSpan=3><%=requestLog%>&nbsp;</TD>
                    </TR>
                    </TBODY>
                   </TABLE>
            </form>
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
<script>
var toCheck="<%=checkStr%>";
function onSubmit() {
 if(check_form(weaver,toCheck)){
 weaver.method.value="save";
 weaver.submit();
 }
}
</script>