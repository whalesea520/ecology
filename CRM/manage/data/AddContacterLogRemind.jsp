
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>


<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="RecordSetC" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<%
String CustomerID = Util.null2String(request.getParameter("CustomerID"));

RecordSetC.executeProc("CRM_ContacterLog_R_SById",CustomerID);
RecordSetC.next();
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<script language=javascript >
function checkSubmit(){
    if(check_form(weaver,'before')){
        if(document.all("isContact").value==1){
        	if(check_form(weaver,'contactDate')) weaver.submit();
        }else{
        	weaver.submit();
        }
    }
}
</script>
</HEAD>
<%
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(6061,user.getLanguage())+" - "+"<a href=/CRM/data/ViewCustomer.jsp?CustomerID="+CustomerID+">"+Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(CustomerID),user.getLanguage())+"</a>";
String needfav ="1";
String needhelp ="";
boolean isfromtab =  Util.null2String(request.getParameter("isfromtab")).equals("true")?true:false;
%>
<BODY>
<%if(!isfromtab) {%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%} %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:checkSubmit(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(589,user.getLanguage())+",javascript:document.weaver.reset(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
</colgroup>
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<%if(!isfromtab) {%>
		<TABLE class=Shadow>
		<%}else{ %>
		<TABLE width='100%'>
		<%} %>
		<tr>
		<td valign="top">

		<FORM id=weaver name=weaver action="ContacterLogRemindOperation.jsp" method=post onsubmit='return check_form(this,"before")'>
		<input type="hidden" name="CustomerID" value="<%=CustomerID%>">
		<input type="hidden" name="isfromtab" value="<%=isfromtab%>">
			  <TABLE class=ViewForm>
		        <COLGROUP>
				<COL width="20%">
		  		<COL width="80%">
		  		</COLGROUP>
		        <TBODY>        
		        <TR class=Spacing style="height: 1px">
		          <TD class=Line1 colSpan=2></TD></TR>
				  <TR>
		          <TD><%=SystemEnv.getHtmlLabelName(6078,user.getLanguage())%></TD>
		          <TD class=Field><INPUT type=checkbox name="isremind" value="0" <%if (RecordSetC.getString("isremind").equals("0")) {%>checked><%}%></TD>
		        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
		        <!--TR>          <TD><%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></TD>
		          <TD class=Field>
				  <select name="daytype">
					<option value="1" <%if (RecordSetC.getString("daytype").equals("1")) {%>selected <%}%>><%=SystemEnv.getHtmlLabelName(390,user.getLanguage())%></option>
					<option value="2" <%if (RecordSetC.getString("daytype").equals("2")) {%>selected <%}%>><%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%></option>
					</select></TD>
		        </TR-->    
		        <TR>
				 <TD><%=SystemEnv.getHtmlLabelName(6077,user.getLanguage())%>（<%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%>）</TD>
		          <TD class=Field><INPUT class=InputStyle maxLength=2 size=10 name="before" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("before")' onchange='checkinput("before","beforeimage")' value = "<%=RecordSetC.getString("before")%>"><SPAN id=beforeimage><%if (RecordSetC.getString("before").equals("")) {%><IMG src="/images/BacoError_wev8.gif" align=absMiddle><%}%></SPAN></TD>
		        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
		        
		        <%
		        	int invalid = 0;
		        	int isContact = 0;
		        	String contactDate = "";
		       		RecordSetC.executeSql("select invalid,isContact,contactDate from CRM_ContactSetting where customerId="+CustomerID);
		       		if(RecordSetC.next()){
		       			invalid = RecordSetC.getInt("invalid");
		       			isContact = RecordSetC.getInt("isContact");
		       			contactDate = RecordSetC.getString("contactDate");
		       		}
		        %>
		        
		        <!-- 增加联系无效及是否再联系设置 -->
		        <TR title="联系无效是指由于电话无效或无人接听等原因没有和客户的关键人员取得有效联系（在“客户查询”页面可按此字段进行查询客户）">
					<TD><%=SystemEnv.getHtmlLabelName(621,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(2245,user.getLanguage())%></TD>
		        	<TD class=Field><INPUT id="invalid" type=checkbox name="invalid" <%if(invalid==1){%> checked="checked" <%}%>></TD>
		        </TR>
		        <tr><td class=Line colspan=2></td></tr>
		        
		        <TR title="是否需再联系用于设置后续是否需要再次与该用户进行联系，并设置预计的联系日期（在“客户查询”页面可按此字段进行查询客户）">
		        	<TD title="">是否需再联系</TD>
		        	<TD class=Field>
						<select id="isContact" name="isContact" onchange="changeContactStatus()">
							<option value="0" <%if(isContact==0){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(161, user.getLanguage())%></option>
							<option value="1" <%if(isContact==1){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(163, user.getLanguage())%></option>
						</select>
						&nbsp;&nbsp;&nbsp;&nbsp;
						<span id="contactDateShow" <%if(isContact==0){%> style="display: none" <%}%>>
							再联系日期：&nbsp;&nbsp;
							<BUTTON type="button" id="contactBtn" class=Calendar onclick="gettheDate(contactDate,contactDateSpan)"></BUTTON>
							<SPAN id=contactDateSpan><%=contactDate %></SPAN>
							<input class=inputstyle type="hidden" id="contactDate" name="contactDate" value="<%=contactDate %>" onPropertyChange="checkinput('contactDate','contactDateImage');">
							<SPAN id=contactDateImage>
								<%if(contactDate.equals("")){%>
									<IMG src='/images/BacoError_wev8.gif' align=absMiddle>
								<%}%>
							</SPAN>
						</span>
					</TD>
				</TR>
				<tr><td class=Line colspan=2></td></tr>
		        </TBODY>
			  </TABLE>
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
<script type="text/javascript">
function changeContactStatus(){
	var v = jQuery("#isContact").val();
	if(v==1){
		jQuery("#contactDateShow").show();
		jQuery("#contactDate").val("");
		jQuery("#contactDateSpan").html("");
		jQuery("#contactDateImage").html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
		
	}else{
		jQuery("#contactDateShow").hide();
		jQuery("#contactDate").val("");
		jQuery("#contactDateSpan").html("");
		jQuery("#contactDateImage").html("");
	}
}
/**
function changeContactStatus(){
	var v = document.all("isContact").value;
	if(v==1){
		document.all("contactDateShow").style.display = "";
		document.all("contactDate").value = "";
		document.all("contactDateSpan").innerHTML = "";
		document.all("contactDateImage").innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
		
	}else{
		document.all("contactDateShow").style.display = "none";
		document.all("contactDate").value = "";
		document.all("contactDateSpan").innerHTML = "";
		document.all("contactDateImage").innerHTML = "";
	}
}*/

</script>
</HTML>
