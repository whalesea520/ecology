
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<%
boolean hasright=true;
int subcompanyid=Util.getIntValue(request.getParameter("subCompanyId"));
int departmentid=Util.getIntValue(request.getParameter("departmentid"));
String PieceYear =Util.null2String(request.getParameter("PieceYear"));
String PieceMonth =Util.null2String(request.getParameter("PieceMonth"));

String showname="";
//是否分权系统，如不是，则不显示框架，直接转向到列表页面
int detachable=Util.getIntValue((String)session.getAttribute("detachable"));
if(detachable==1){
    if(subcompanyid>0){
    int operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"PieceRate:maintenance",subcompanyid);
    if(operatelevel<0){
        hasright=false;
    }
    }else{
       hasright=false;
    }
}
if(!HrmUserVarify.checkUserRight("PieceRate:maintenance", user) && !hasright){
    response.sendRedirect("/notice/noright.jsp");
    return;
}
if(departmentid>0){
    showname=DepartmentComInfo.getDepartmentname(""+departmentid);
}else if(subcompanyid>0){
    showname=SubCompanyComInfo.getSubCompanyname(""+subcompanyid);
}else{
    hasright=false;
}
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</head>
<%
String imagefilename = "/images/hdHRM_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(19377,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(hasright){
RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",PieceRateMaintenanceEdit.jsp?isedit=1&subCompanyId="+subcompanyid+"&departmentid="+departmentid+"&PieceYear="+PieceYear+"&PieceMonth="+PieceMonth+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",PieceRateMaintenance.jsp?subCompanyId="+subcompanyid+"&departmentid="+departmentid+",_self} " ;
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
<FORM id=weaver name=frmMain action="PieceRateMaintOperation.jsp" method=post enctype="multipart/form-data" >
<input type="hidden" id="option" name="option" value="">
<TABLE class=viewform>
  <COLGROUP>
  <COL width="20%">
  <COL width="80%">
  <TBODY>
  <TR class=Title>
    <TH colSpan=2><%=SystemEnv.getHtmlLabelName(19399,user.getLanguage())%></TH></TR>
  <TR class=spacing>
    <TD class=line1 colSpan=2 ></TD></TR>
  <TR>
          <TD><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(18939,user.getLanguage())%></TD>
          <TD class=Field><%=showname%><input class=inputstyle type="hidden"  name="subcompanyid" value="<%=subcompanyid%>">
              <input class=inputstyle type="hidden"  name="departmentid" value="<%=departmentid%>"></TD>
   </TR>
   <TR class= Spacing><TD class=Line colSpan=2></TD></TR>
  <TR>
          <TD><%=SystemEnv.getHtmlLabelName(19400,user.getLanguage())%></TD>
          <TD class=Field><%=PieceYear%><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%><%=PieceMonth%><%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%></TD>
   </TR>

 <TR class= Spacing><TD class=Line1 colSpan=2></TD></TR>
 </TBODY></TABLE>

 <br>
<TABLE class=ListStyle cellspacing=1 id="oTable" >
  <COLGROUP>
  <COL width="6%">
  <COL width="15%">
  <COL width="9%">
  <COL width="15%">
  <COL width="15%">
  <COL width="15%">
  <COL width="10%">
  <COL width="15%">
  <TBODY>
  <TR class=Header >
  <TH><%=SystemEnv.getHtmlLabelName(15486,user.getLanguage())%></TH>
  <TH><%=SystemEnv.getHtmlLabelName(19401,user.getLanguage())%></TH>
  <TH><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></TH>
  <TH><%=SystemEnv.getHtmlLabelName(19383,user.getLanguage())%></TH>
  <TH><%=SystemEnv.getHtmlLabelName(19384,user.getLanguage())%></TH>
  <TH><%=SystemEnv.getHtmlLabelName(16221,user.getLanguage())%></TH>
  <TH><%=SystemEnv.getHtmlLabelName(1331,user.getLanguage())%></TH>
  <TH><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></TH>
  </TR>
  <%
  String sql="";
  int i=1;
  if(departmentid>0){
      sql="select a.*,b.PieceRateName,c.lastname from HRM_PieceRateInfo a,HRM_PieceRateSetting b,hrmresource c where a.UserCode=c.workcode and a.subcompanyid=c.subcompanyid1 and a.departmentid=c.departmentid and a.PieceRateNo=b.PieceRateNo and a.subcompanyid=b.subcompanyid and a.subcompanyid="+subcompanyid+" and a.departmentid="+departmentid+" and a.PieceYear="+Util.getIntValue(PieceYear)+" and a.PieceMonth="+Util.getIntValue(PieceMonth)+" order by a.UserCode";
  }else if(subcompanyid>0){
      sql="select a.*,b.PieceRateName,c.lastname from HRM_PieceRateInfo a,HRM_PieceRateSetting b,hrmresource c where a.UserCode=c.workcode and a.subcompanyid=c.subcompanyid1 and a.departmentid=c.departmentid and a.PieceRateNo=b.PieceRateNo and a.subcompanyid=b.subcompanyid and a.subcompanyid="+subcompanyid+" and a.PieceYear="+Util.getIntValue(PieceYear)+" and a.PieceMonth="+Util.getIntValue(PieceMonth)+" order by a.UserCode";
  }
  RecordSet.executeSql(sql);
  while(RecordSet.next()){
      if(i%2==0){
  %>
  <TR CLASS="DataDark">
  <%}else{%>
  <TR CLASS="DataLight">
  <%}%>
      <TD><%=i%></TD>
      <TD><%=RecordSet.getString("UserCode")%></TD>
      <TD><%=RecordSet.getString("lastname")%></TD>
      <TD><%=RecordSet.getString("PieceRateNo")%></TD>
      <TD><%=RecordSet.getString("PieceRateName")%></TD>
      <TD><%=RecordSet.getString("PieceRateDate")%></TD>
      <TD><%=RecordSet.getString("PieceNum")%></TD>
      <TD><%=RecordSet.getString("memo")%></TD>
  </TR>
  <%i++;}%>
 </TBODY></TABLE>
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
</BODY>
</HTML>