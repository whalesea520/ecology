<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="CostcenterMainComInfo" class="weaver.hrm.company.CostcenterMainComInfo" scope="page" />
<jsp:useBean id="CostcenterSubComInfo" class="weaver.hrm.company.CostcenterSubComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
int id = Util.getIntValue(request.getParameter("id"),0);
String costcentermark="";
String costcentername="";
String departmentid="";
String ccsubcategory1="";

RecordSet.executeProc("HrmCostcenter_SelectByID",""+id);

if(RecordSet.next()){
	costcentermark = Util.toScreen(RecordSet.getString("costcentermark"),user.getLanguage());
	costcentername = Util.toScreen(RecordSet.getString("costcentername"),user.getLanguage());	
	departmentid= Util.toScreen(RecordSet.getString("departmentid"),user.getLanguage());
	ccsubcategory1 = Util.toScreen(RecordSet.getString("ccsubcategory1"),user.getLanguage());
	
}
String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(124,user.getLanguage())+SystemEnv.getHtmlLabelName(425,user.getLanguage())+SystemEnv.getHtmlLabelName(426,user.getLanguage())+":"+costcentermark+"-"+costcentername;
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(HrmUserVarify.checkUserRight("HrmCostCenterEdit:Edit", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(179,user.getLanguage())+",/hrm/search/HrmResourceSearchTmp.jsp?costcenter="+id+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
if(HrmUserVarify.checkUserRight("HrmCostCenter:Log", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem="+20+" and relatedid="+id+",_self} " ;
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

<FORM id=weaver name=frmMain action="HrmCostcenterEdit.jsp" method=post>
  <TABLE class=viewForm width="100%" border=0>
  <COLGROUP>
  <COL width="30%">
  <COL width=70%>
  <TBODY>
  <TR>
    <TD colSpan=2><B><%=SystemEnv.getHtmlLabelName(15729,user.getLanguage())%></B></TD>
  </TR>
  <TR>
  <TD class=line1 colSpan=2></TD></TR>
  
  <TR>
    <TD><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
    <TD class=FIELD id=Code><a href="HrmDepartmentDsp.jsp?id=<%=departmentid%>"><%=DepartmentComInfo.getDepartmentmark(departmentid)%>-<%=DepartmentComInfo.getDepartmentname(departmentid)%></a></TD>
  </TR>
  <TR><TD class=Line colSpan=2></TD></TR> 
  <TR>
    <TD><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></TD>
    <TD class=FIELD id=Code><%=costcentermark%></TD>
  </TR>
  <TR><TD class=Line colSpan=2></TD></TR> 
  <TR>
    <TD><%=SystemEnv.getHtmlLabelName(15767,user.getLanguage())%></TD>
    <TD class=FIELD><%=costcentername%></TD>
  </TR>
  <TR><TD class=Line colSpan=2></TD></TR> 
  <TR>
    <TD><%=SystemEnv.getHtmlLabelName(15769,user.getLanguage())%></TD>
    <TD class=FIELD id=Code><%=CostcenterSubComInfo.getCostcenterSubname(ccsubcategory1)%></TD>
  </TR>
  <TR><TD class=Line colSpan=2></TD></TR> 
<!--  <TR>
    <TD colSpan=2><B><%=SystemEnv.getHtmlLabelName(92,user.getLanguage())%></B></TD></TR>
  <TR>
    <TD class=Sep2 colSpan=2></TD></TR>
  
         <%
         int subcompanyid = 0;
         while(CostcenterMainComInfo.next()){
         	subcompanyid+=1;
         	String curid=CostcenterMainComInfo.getCostcenterMainid();
         	String curname = CostcenterMainComInfo.getCostcenterMainname();
         	String tmpid  = ccsubcategory1;         	
         %>
        <tr> 
            <td><%=curname%></td>
            <td class=FIELD> 
            <%=CostcenterSubComInfo.getCostcenterSubname(tmpid)%>              
            </td>
          </tr>
          <%}%>
-->
  </TBODY>
  </TABLE>
  <input class=inputstyle type=hidden name=id value="<%=id%>">
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
<script language=javascript>  
function submitData() {
 frmMain.submit();
}
</script>
</BODY>
</HTML>