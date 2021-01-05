<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="CostcenterMainComInfo" class="weaver.hrm.company.CostcenterMainComInfo" scope="page" />
<jsp:useBean id="CostcenterSubComInfo" class="weaver.hrm.company.CostcenterSubComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script LANGUAGE="JavaScript" SRC="/js/checkinput_wev8.js"></script>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</head>
<%
int id = Util.getIntValue(request.getParameter("id"),0);
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
String ccsubcategoryname= CostcenterSubComInfo.getCostcenterSubname(""+id);
String ccsubcategorydesc = CostcenterSubComInfo.getCostcenterSubdesc(""+id);
String ccmaincategoryid = CostcenterSubComInfo.getMaincategoryid(""+id);
String isdefault = CostcenterSubComInfo.getIsdefault(""+id);
String ccmaincategoryname = CostcenterMainComInfo.getCostcenterMainname(ccmaincategoryid);


String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(6084,user.getLanguage())+":"+ccmaincategoryname+"-"+ccsubcategoryname;
String needfav ="1";
String needhelp ="";
boolean canEdit = false;
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(HrmUserVarify.checkUserRight("HrmCostCenterSubCategoryEdit:Edit", user)){
	canEdit = true;
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("HrmCostCenterSubCategoryAdd:Add", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",/hrm/company/HrmCostcenterSubCategoryAdd.jsp?id="+ccmaincategoryid+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("HrmCostCenterSubCategoryEdit:Delete", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("HrmCostCenterSubCategory:Log", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem="+19+" and relatedid="+id+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{-}" ;	
if(HrmUserVarify.checkUserRight("HrmCostCenterAdd:Add", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(15770,user.getLanguage())+",/hrm/company/HrmCostCenterAdd.jsp?subccid="+id+",_self} " ;
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

<FORM id=weaver name=frmMain action="CcSubOperation.jsp" method=post>
<%
if(msgid!=-1){
%>
<DIV>
<font color=red size=2>
<%=SystemEnv.getErrorMsgName(msgid,user.getLanguage())%>
</font>
</DIV>
<%}%>
<TABLE class=viewform>
  <COLGROUP>
  <COL width="20%">
  <COL width="80%">
  <TBODY>
  <TR class=title>
    <TH colSpan=2><%=SystemEnv.getHtmlLabelName(6084,user.getLanguage())%></TH></TR>
  <TR class=spacing>
    <TD class=line1 colSpan=2 ></TD></TR>
  <TR>
          <TD><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></TD>
            <TD class=Field><%if(canEdit){%><input class=inputstyle size=50 name="ccsubcategoryname" value="<%=ccsubcategoryname%>" onchange='checkinput("ccsubcategoryname","ccsubcategorynameimage")'>
            <SPAN id=ccsubcategorynameimage></SPAN>
            <%}else{%><%=ccsubcategoryname%><%}%></TD>
        </TR>
       <TR><TD class=Line colSpan=2></TD></TR> 
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(15767,user.getLanguage())%></TD>
          <TD class=Field><%if(canEdit){%><input class=inputstyle size=50 name="ccsubcategorydesc" value="<%=ccsubcategorydesc%>" onchange='checkinput("ccsubcategorydesc","ccsubcategorydescimage")'>
            <SPAN id=ccsubcategorydescimage></SPAN><%}else{%><%=ccsubcategorydesc%><%}%></TD>
        </TR>
 </TBODY>
  </TABLE>
 <TABLE class=ListStyle cellspacing=1 >
  <COLGROUP>
  <COL width="40%">   
  <COL width="60%">
  <TBODY>
  <TR class=Header>
    <TH colSpan=3><%=SystemEnv.getHtmlLabelName(425,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(426,user.getLanguage())%></TH>
   </TR>
    <TR class=Header>    
    <TD><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(15767,user.getLanguage())%></TD>
  </TR>
<TR class=Line><TD colspan="2" ></TD></TR> 
<%  
    int line=0;
    String sql = "select * from HrmCostcenter where ccsubcategory1 ="+id;
    rs.executeSql(sql);    
    while(rs.next()){ 
      if(line%2 == 0){     
%> 
   <TR class=datalight>       
<%
   }else{
%>   
    <TR class=datadark>
<%
   }
%>
    <TD class=Field><a href="/hrm/company/HrmCostcenterDsp.jsp?id=<%=rs.getInt("id")%>"><%=rs.getString("costcentermark")%></a></TD>
    <TD class=Field><%=rs.getString("costcentername")%></TD>    
  </TR>
<%  
   line++;     
   }   
%>  
 </TBODY></TABLE>

 <input class=inputstyle type=hidden name=operation>
 <input class=inputstyle type=hidden name=ccmaincategoryid value="<%=ccmaincategoryid%>">
 <input class=inputstyle type=hidden name=id value="<%=id%>">
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

 <script>
 function onSave(){
 	if(check_form(document.frmMain,'ccsubcategoryname,ccsubcategorydesc')){
	 	document.frmMain.operation.value="edit";
		document.frmMain.submit();
	}
 }
 
 function onDelete(){ 	
		if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
			document.frmMain.operation.value="delete";
			document.frmMain.submit();
		}	
}
 </script>
</BODY>
</HTML>