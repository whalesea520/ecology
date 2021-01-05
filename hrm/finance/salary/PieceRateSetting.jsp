
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<%
boolean hasright=true;
if(!HrmUserVarify.checkUserRight("PieceRate:setting", user)){
    response.sendRedirect("/notice/noright.jsp");
    return;
}
int subcompanyid=Util.getIntValue(request.getParameter("subCompanyId"));
//是否分权系统，如不是，则不显示框架，直接转向到列表页面
int detachable=Util.getIntValue((String)session.getAttribute("detachable"));
if(detachable==1){
    if(subcompanyid>0){
    int operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"PieceRate:setting",subcompanyid);
    if(operatelevel<1){
        hasright=false;
        if(operatelevel==-1){
            response.sendRedirect("/notice/noright.jsp");
            return;
        }
    }
    }else{
       hasright=false;
    }
}
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
String imagefilename = "/images/hdHRM_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(19376,user.getLanguage())+":"+SubCompanyComInfo.getSubCompanyname(""+subcompanyid);
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(hasright){
RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",PieceRateSettingEdit.jsp?subCompanyId="+subcompanyid+",_self} " ;
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
<TABLE class=ListStyle>
  <COLGROUP>
  <COL width="10%">
  <COL width="15%">
  <COL width="20%">
  <COL width="20%">
  <COL width="15%">
  <COL width="20%">
  <TBODY>
  <TR class=Header >
  <TH><%=SystemEnv.getHtmlLabelName(15486,user.getLanguage())%></TH>
  <TH><%=SystemEnv.getHtmlLabelName(19383,user.getLanguage())%></TH>
  <TH><%=SystemEnv.getHtmlLabelName(19384,user.getLanguage())%></TH>
  <TH><%=SystemEnv.getHtmlLabelName(19385,user.getLanguage())%></TH>
  <TH><%=SystemEnv.getHtmlLabelName(1330,user.getLanguage())%></TH>
  <TH><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></TH>
  </TR>
  <%
  RecordSet.executeSql("select * from HRM_PieceRateSetting where subcompanyid="+subcompanyid+" order by id");
  int i=0;
  while(RecordSet.next()){
      i++;
  if(i%2==0){
  %>
  <TR class="DataDark">
  <%}else{%>
  <TR class="DataLight">
  <%}%>
      <TD><%=i%></TD>
      <TD><%=RecordSet.getString("PieceRateNo")%></TD>
      <TD><%=RecordSet.getString("PieceRateName")%></TD>
      <TD><%=RecordSet.getString("workingpro")%></TD>
      <TD><%=RecordSet.getString("price")%></TD>
      <TD><%=RecordSet.getString("memo")%></TD>
  </TR>
  <%}%>
 </TBODY></TABLE>
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
</BODY>
</HTML>