<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="CostcenterMainComInfo" class="weaver.hrm.company.CostcenterMainComInfo" scope="page" />
<jsp:useBean id="CostcenterSubComInfo" class="weaver.hrm.company.CostcenterSubComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
int id = Util.getIntValue(request.getParameter("id"),0);
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
String costcentermark="";
String costcentername="";
String departmentid="";
String ccsubcategory1="";

RecordSet.executeProc("HrmCostcenter_SelectByID",""+id);

if(RecordSet.next()){
	costcentermark = Util.toScreenToEdit(RecordSet.getString("costcentermark"),user.getLanguage());
	costcentername = Util.toScreenToEdit(RecordSet.getString("costcentername"),user.getLanguage());	
	departmentid= Util.toScreenToEdit(RecordSet.getString("departmentid"),user.getLanguage());
	ccsubcategory1 = Util.toScreenToEdit(RecordSet.getString("ccsubcategory1"),user.getLanguage());
	
}
String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(124,user.getLanguage())+SystemEnv.getHtmlLabelName(425,user.getLanguage())+SystemEnv.getHtmlLabelName(426,user.getLanguage())+":"+costcentermark+"-"+costcentername;
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<FORM id=weaver name=frmMain action="CcOperation.jsp" method=post>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(HrmUserVarify.checkUserRight("HrmCostCenterEdit:Edit", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("HrmCostCenterAdd:Add", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",/hrm/company/HrmCostcenterAdd.jsp?id="+departmentid+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("HrmCostCenterEdit:Delete", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
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

<%
if(msgid!=-1){
%>
<DIV>
<font color=red size=2>
<%=SystemEnv.getErrorMsgName(msgid,user.getLanguage())%>
</font>
</DIV>
<%}%>
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
    <input class=inputstyle type=hidden name=departmentid value="<%=departmentid%>">
    <TD class=FIELD id=Code><a href="HrmDepartmentDsp.jsp?id=<%=departmentid%>"><%=DepartmentComInfo.getDepartmentmark(departmentid)%>-<%=DepartmentComInfo.getDepartmentname(departmentid)%></a></TD>
  </TR>  
    <TR><TD class=Line colSpan=2></TD></TR> 
  <TR>
    <TD><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></TD>
    <TD class=FIELD id=Code>
      <input class=inputstyle type=text  name=costcentermark value="<%=costcentermark%>"></TD>
  </TR>
    <TR><TD class=Line colSpan=2></TD></TR> 
  <TR>
    <TD><%=SystemEnv.getHtmlLabelName(15767,user.getLanguage())%></TD>
    <TD class=FIELD>
      <input class=inputstyle size=50 name=costcentername value="<%=costcentername%>"onchange='checkinput("costcentername","costcenternameimage")'>
            <SPAN id=costcenternameimage></SPAN></TD>
  </TR>
    <TR><TD class=Line colSpan=2></TD></TR> 
  <TR>
    <TD><%=SystemEnv.getHtmlLabelName(15769,user.getLanguage())%></TD>
    <TD class=FIELD id=Code>    
            <select class=inputstyle name=ccsubcategory1 value="<%=ccsubcategory1%>">            
<%
String sql = "select * from HrmCostcenterSubCategory where ccmaincategoryid = 1";
rs.executeSql(sql);
while(rs.next()){

%>
        <option value=<%=rs.getString("id")%> <%if(rs.getString("id").equals(ccsubcategory1)){%>selected<%}%>>
          <%=rs.getString("ccsubcategoryname")%>
        </option>
<%
   }
%>
      </select>
   </TR>
   <TR><TD class=Line colSpan=2></TD></TR> 
<!--      <input class=inputstyle type=text maxLength=8 size=8 name=ccsubcategory1 value="<%=ccsubcategory1%>"></TD>
  </TR>
<TR>
    <TD colSpan=2><B><%=SystemEnv.getHtmlLabelName(92,user.getLanguage())%></B></TD></TR>
  <TR>
    <TD class=Sep2 colSpan=2></TD></TR>
  
         <%
         int subcompanyid = 0;
         while(CostcenterMainComInfo.next()){
         	subcompanyid+=1;
         	String curid=CostcenterMainComInfo.getCostcenterMainid();
         	String curname = CostcenterMainComInfo.getCostcenterMainname();
         %>
         <tr> 
            <td><%=curname%></td>
            <td class=FIELD> 
              <select class=inputstyle name="ccsubcategory<%=subcompanyid%>">
              <%
              	while(CostcenterSubComInfo.next()){
              		if(!CostcenterSubComInfo.getMaincategoryid().equals(curid))
              			continue;
              			String tmpid = "";
         	if(subcompanyid==1)
         		tmpid = ccsubcategory1;
         	
         		
              		String isselected="";
              		
	         	if(CostcenterSubComInfo.getCostcenterSubid().equals(tmpid))
	         		isselected=" selected";
              %>
                <option value="<%=CostcenterSubComInfo.getCostcenterSubid()%>" <%=isselected%>><%=CostcenterSubComInfo.getCostcenterSubname()%></option>
                <%}%>
              </select>
            </td>
          </tr>
          <%}%>
-->          
  </TBODY>
  </TABLE>
   <input class=inputstyle type=hidden name=operation>
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
 function onSave(){
 	if(check_form(document.frmMain,'costcentername')){
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