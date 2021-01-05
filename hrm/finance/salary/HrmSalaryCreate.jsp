
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import = "weaver.general.Util,java.util.*" %>
<%@ page import="weaver.conn.*" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />


<HTML>
<HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</head>

<%
String currentdate = Util.null2String(request.getParameter("currentdate")) ;
String salarybegindate = Util.null2String(request.getParameter("salarybegindate"));       // 工资开始计算日期
String salaryenddate = Util.null2String(request.getParameter("salaryenddate"));       // 工资截至计算日期
String payid = Util.null2String(request.getParameter("payid")) ;
String fromdepartment = Util.null2String(request.getParameter("fromdepartment")) ;

Calendar thedate = Calendar.getInstance ();
String theday = Util.add0(thedate.get(thedate.YEAR), 4) +"-"
                +Util.add0(thedate.get(thedate.MONTH) + 1, 2) +"-"
                +Util.add0(thedate.get(thedate.DAY_OF_MONTH), 2) ;

String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(503 , user.getLanguage()) ; 
String needfav ="1";
String needhelp ="";

%>

<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:doCreate(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

if(fromdepartment.equals("1")) {            // 返回部门工资单页面
    RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",HrmDepSalaryPay.jsp?currentdate=" + currentdate+",_self} " ;
    RCMenuHeight += RCMenuHeightStep ;
}
else {                                      // 返回个人工资单页面
    RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",HrmSalaryPay.jsp?currentdate=" + currentdate+",_self} " ;
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
<FORM id=frmmain name=frmmain method=post action="HrmSalaryOperation.jsp">
<input type="hidden" name="method" value="createpay">
<input type="hidden" name="currentdate" value="<%=currentdate%>">
<input type="hidden" name="salarybegindate" value="<%=salarybegindate%>">
<input type="hidden" name="salaryenddate" value="<%=salaryenddate%>">
<input type="hidden" name="payid" value="<%=payid%>">
<input type="hidden" name="fromdepartment" value="<%=fromdepartment%>">

<table class=viewform>
  <colgroup>
  <col width="30%">
  <col width="70%">    
  <tbody>
    <tr class=Title>
      <TH colSpan=5><%=SystemEnv.getHtmlLabelName(503,user.getLanguage())%></TH>
    </TR>
    <TR class=Spacing> 
      <TD class=Line1 colSpan=5></TD>
    </TR>
      
    <TR>
          <TD><%=SystemEnv.getHtmlLabelName(599,user.getLanguage())%></TD> 
		    <TD class=Field>
              <input type="radio" name="createtype" value="1"> <%=SystemEnv.getHtmlLabelName(17091,user.getLanguage())%>&nbsp;
              <input type="radio" name="createtype" value="2" checked> <%=SystemEnv.getHtmlLabelName(407,user.getLanguage())%>
            </TD>
		</TR>
    <TR><TD class=Line colSpan=2></TD></TR> 
    <tr>
      <td><%=SystemEnv.getHtmlLabelName(17092,user.getLanguage())%></td>
      <td class=field>
         <BUTTON class=Calendar type="button" id=selectstartdate onclick="getDate(plandatespan,plandate)"></BUTTON> 
         <span id="plandatespan"></span>
         <input class=inputstyle type="hidden" id="plandate" name="plandate" value="">
      </td>
    </tr>
    <TR><TD class=Line colSpan=2></TD></TR> 
   </tbody>
</table>
</form>

<br>
<TABLE class = ListStyle cellspacing=1>
  <COLGROUP>
  <COL width = "25%">
  <COL width = "50%">
  <COL width = "20%">
  <COL width = "5%">
  <TBODY>
  <TR class = Header>
  <th colspan=4><%=SystemEnv.getHtmlLabelName(15746 , user.getLanguage())%></th>
  </tr>
  <TR class = Header>
  <th><%=SystemEnv.getHtmlLabelName(887 , user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(97 , user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(17092 , user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(104 , user.getLanguage())%></th>
  </tr>
  <TR class=Line><TD colspan="4" ></TD></TR> 
<%
    boolean isLight = false ; 
    RecordSet.executeProc("HrmSalaryCreateInfo_Select", "0") ;  // 未执行的计划
	while(RecordSet.next()) {
        String idrs = Util.null2String(RecordSet.getString("id")) ; 
        String currentdaters = Util.null2String(RecordSet.getString("currentdate")) ; 
        String salarybegindaters = Util.null2String(RecordSet.getString("salarybegindate")) ; 
        String salaryenddaters = Util.null2String(RecordSet.getString("salaryenddate")) ; 
        String plandaters = Util.null2String(RecordSet.getString("plandate")) ; 

		isLight = !isLight ;
  %>
     <tr class='<%=( isLight ? "datalight" : "datadark" )%>'>
		<TD><%=currentdaters%></TD>
        <TD><%=salarybegindaters%> ~ <%=salaryenddaters%></TD>
		<TD><%=plandaters%></TD>
		<TD>
			<a href="HrmSalaryOperation.jsp?method=deleteplan&planid=<%=idrs%>&currentdate=<%=currentdate%>&salarybegindate=<%=salarybegindate%>&salaryenddate=<%=salaryenddate%>&payid=<%=payid%>&fromdepartment=<%=fromdepartment%>" ><img border=0 src="/images/icon_delete_wev8.gif"></a>
        </TD>
	</TR>
<%} %>
</TABLE>

<br>
<TABLE class = ListStyle cellspacing=1>
  <COLGROUP>
  <COL width = "25%">
  <COL width = "50%">
  <COL width = "20%">
  <COL width = "5%">
  <TBODY>
  <TR class = Header>
  <th colspan=4><%=SystemEnv.getHtmlLabelName(1454 , user.getLanguage())%></th>
  </tr>
  <TR class = Header>
  <th><%=SystemEnv.getHtmlLabelName(887 , user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(97 , user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(17092 , user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(104 , user.getLanguage())%></th>
  </tr>
  <TR class=Line><TD colspan="4" ></TD></TR> 
<%
    RecordSet.executeProc("HrmSalaryCreateInfo_Select", "1") ;  // 已执行的计划
	while(RecordSet.next()) {
        String idrs = Util.null2String(RecordSet.getString("id")) ; 
        String currentdaters = Util.null2String(RecordSet.getString("currentdate")) ; 
        String salarybegindaters = Util.null2String(RecordSet.getString("salarybegindate")) ; 
        String salaryenddaters = Util.null2String(RecordSet.getString("salaryenddate")) ; 
        String plandaters = Util.null2String(RecordSet.getString("plandate")) ; 

		isLight = !isLight ;
  %>
     <tr class='<%=( isLight ? "datalight" : "datadark" )%>'>
		<TD><%=currentdaters%></TD>
        <TD><%=salarybegindaters%> ~ <%=salaryenddaters%></TD>
		<TD><%=plandaters%></TD>
		<TD>
			<a href="HrmSalaryOperation.jsp?method=deleteplan&planid=<%=idrs%>&currentdate=<%=currentdate%>&salarybegindate=<%=salarybegindate%>&salaryenddate=<%=salaryenddate%>&payid=<%=payid%>&fromdepartment=<%=fromdepartment%>" ><img border=0 src="/images/icon_delete_wev8.gif"></a>
        </TD>
	</TR>
<%} %>
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
 function doCreate(obj){
     if(document.frmmain.createtype[1].checked && document.frmmain.plandate.value == ''){
     	 window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(23262,user.getLanguage())%>！") ;
         return ;
     }
     else if(document.frmmain.createtype[1].checked && document.frmmain.plandate.value <= '<%=theday%>'){
     	 window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(23263,user.getLanguage())%>！") ;
         return ;
     }
     else {
         obj.disabled = true ;
         document.frmmain.submit();
     } 
 }

</script>
</body>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</html>