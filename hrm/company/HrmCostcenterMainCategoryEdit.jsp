<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="CostcenterMainComInfo" class="weaver.hrm.company.CostcenterMainComInfo" scope="page" />
<jsp:useBean id="CostcenterSubComInfo" class="weaver.hrm.company.CostcenterSubComInfo" scope="page" />
<jsp:useBean id="BaseBean" class="weaver.general.BaseBean" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
int id = Util.getIntValue(request.getParameter("id"),0);
String ccmaincategoryname = CostcenterMainComInfo.getCostcenterMainname(""+id);
String ccmaincategorydesc = CostcenterMainComInfo.getCostcenterMaindesc(""+id);

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(6096,user.getLanguage())+":"+ccmaincategoryname;
String needfav ="1";
String needhelp ="";
boolean canEdit = false;
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(HrmUserVarify.checkUserRight("HrmCostCenterMainCategoryEdit:Edit", user)){
	canEdit = true;
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("HrmCostCenterMainCategory:Log", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem="+18+" and relatedid="+id+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{-}" ;	
if(HrmUserVarify.checkUserRight("HrmCostCenterSubCategoryAdd:Add", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",/hrm/company/HrmCostcenterSubCategoryAdd.jsp?id="+id+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("HrmCostCenterSubCategory:Log", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem="+19+",_self} " ;
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
<FORM id=weaver name=frmMain action="CcMainOperation.jsp" method=post >
<TABLE class=viewform>
  <COLGROUP>
  <COL width="20%">
  <COL width="80%">
  <TBODY>
  <TR class=title>
    <TH colSpan=2><%=SystemEnv.getHtmlLabelName(6096,user.getLanguage())%></TH></TR>
  <TR class=spacing>
    <TD class=line1 colSpan=2 ></TD></TR>
            <input class=inputstyle type=hidden name="id" value="<%=id%>">
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></TD>
          <TD class=Field><%if(canEdit){%>
           <INPUT class=inputStyle maxLength=60 size=50 name="ccmaincategoryname" value="<%=ccmaincategoryname%>" onchange='checkinput("ccmaincategoryname","ccmaincategorynameimage")'>
           <SPAN id=ccmaincategorynameimage></SPAN>
          <%}else{%><%=ccmaincategoryname%><%}%></TD>
        </TR>
        <TR><TD class=Line colSpan=2></TD></TR> 
           <TR>
          <TD><%=SystemEnv.getHtmlLabelName(15767,user.getLanguage())%></TD>
          <TD class=Field><%if(canEdit){%>
           <INPUT class=inputStyle maxLength=60 size=50 name="ccmaincategorydesc" value="<%=ccmaincategorydesc%>">           
          <%}else{%><%=ccmaincategoryname%><%}%></TD>
        </TR>
 </TBODY></TABLE>
 </form>

 <TABLE class=ListStyle cellspacing=1 >
  <COLGROUP>
  <COL width="40%">
  <COL width="60%">
  <TBODY>
  <TR class=Header>
    <TH colSpan=2><%=SystemEnv.getHtmlLabelName(6084,user.getLanguage())%></TH></TR>  
  
  <TR class=Header>
    <TD><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(15767,user.getLanguage())%></TD>
  </TR>
  <TR class=Line><TD colspan="2" ></TD></TR> 
<%
    int needchange = 0;
      while(CostcenterSubComInfo.next()){
      int ccmainid = Util.getIntValue(CostcenterSubComInfo.getMaincategoryid(),0);
      if(ccmainid != id) continue;
       try{
       	if(needchange ==0){
       		needchange = 1;
%>
  <TR class=datalight>
  <%
  	}else{
  		needchange=0;
  %><TR class=datadark>
  <%  	}%>
    <TD>  <a href="/hrm/company/HrmCostCenterSubCategoryEdit.jsp?id=<%=CostcenterSubComInfo.getCostcenterSubid()%>"><%=CostcenterSubComInfo.getCostcenterSubname()%></TD>
    <TD><%=CostcenterSubComInfo.getCostcenterSubdesc()%></a></TD>
    </TR>
<%
      }catch(Exception e){
        BaseBean.writeLog(e.toString());
      }
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
<script language=javascript>  
function submitData() {
 oif(check_form(frmMain,'ccmaincategoryname')){
 frmMain.submit();
 }
}
</script>
</BODY>
</HTML>