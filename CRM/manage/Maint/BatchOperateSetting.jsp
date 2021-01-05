
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
	if(!HrmUserVarify.checkUserRight("CRM_BatchOperateSetting:Maint", user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	String method = Util.null2String(request.getParameter("method"));
  	String transferStart = "";
	String transferEnd = "";
	String transferCount = "";
	String importStart = "";
	String importEnd = "";
	String importCount = "";
  	if(method.equals("save")){
  		transferStart = Util.null2String(request.getParameter("transferStart"));
  		transferEnd = Util.null2String(request.getParameter("transferEnd"));
  		transferCount = Util.null2String(request.getParameter("transferCount"));
  		importStart = Util.null2String(request.getParameter("importStart"));
  		importEnd = Util.null2String(request.getParameter("importEnd"));
  		importCount = Util.null2String(request.getParameter("importCount"));
	  	RecordSet.executeSql("delete from CRM_BatchOperateSetting");
	  	RecordSet.executeSql("insert into CRM_BatchOperateSetting values("+transferStart+","+transferEnd+","+transferCount+","+importStart+","+importEnd+","+importCount+")"); 	
	  %>
    <script language=javascript>
	  alert("<%=SystemEnv.getHtmlLabelName(18758,user.getLanguage())%>");
	  window.location = "BatchOperateSetting.jsp";
    </script>
  <%}
  	int maxsize = 0;
  	RecordSet.executeSql("select transferStart,transferEnd,transferCount,importStart,importEnd,importCount from CRM_BatchOperateSetting");
	if(RecordSet.next()){
		transferStart = Util.null2String(RecordSet.getString(1));
		transferEnd = Util.null2String(RecordSet.getString(2));
		transferCount = Util.null2String(RecordSet.getString(3));
		
		importStart = Util.null2String(RecordSet.getString(4));
		importEnd = Util.null2String(RecordSet.getString(5));
		importCount = Util.null2String(RecordSet.getString(6));
	}
  %>
<HTML>
<HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(27244,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table width=100% height=90% border="0" cellspacing="0" cellpadding="0">
	<colgroup>
		<col width="10">
		<col width="">
		<col width="10">
	</colgroup>
	<tr>
		<td height="10" colspan="3"></td>
	</tr>
	<tr>
		<td></td>
		<td valign="top">
			<TABLE class=Shadow>
				<tr>
					<td valign="top">
						<FORM id=weaver name=weaver action="BatchOperateSetting.jsp" method=post>
							<input type=hidden id='method' name='method'>
							<TABLE class=Viewform>
								<COLGROUP>
							  		<COL width="15%">
							  		<COL width=20%>
							  		<COL width="65%">
							  	</COLGROUP>
							  	<TBODY>
							  		<TR class=Title>
										<TH colSpan=3>批量转移</TH>
									</TR>
									<TR class=spacing>
										<TD class=line1 colSpan=3></TD>
									</TR>
									<tr>
										<td>时间范围</td>
								    	<td class=field>
								    		<input class=inputstyle type=text size=5 maxlength="2" name=transferStart value="<%=transferStart %>" onKeyPress="ItemCount_KeyPress()" 
								    		onBlur="checkcount('transferStart');checkinput('transferStart','transferStartImage');checkHour('transferStart')"/>
			          						<SPAN id=transferStartImage><%if(transferStart.equals("")){%><IMG src='/images/BacoError_wev8.gif' align=absMiddle><%}%></SPAN>
			          						-
			          						<input class=inputstyle type=text size=5 maxlength="2" name=transferEnd value="<%=transferEnd %>" onKeyPress="ItemCount_KeyPress()" 
								    		onBlur="checkcount('transferEnd');checkinput('transferEnd','transferEndImage');checkHour('transferEnd')"/>
			          						<SPAN id=transferEndImage><%if(transferEnd.equals("")){%><IMG src='/images/BacoError_wev8.gif' align=absMiddle><%}%></SPAN>
								    	</td>
								    	<td class=field style="color: #800000">可进行批量转移操作的时间范围。输入9-18代表每天的9:00到18:00;输入18-9代表每天的18:00以后或9:00以前。</td>
								  	</tr>
							    	<TR><TD class=Line colSpan=3></TD></TR> 
							    	<tr>
										<td>最大条数/次</td>
								    	<td class=field>
								    		<input class=inputstyle type=text size=10 maxlength="5" name=transferCount value="<%=transferCount %>" onKeyPress="ItemCount_KeyPress()" 
								    		onBlur="checkcount('transferCount');checkinput('transferCount','transferCountImage');checkInt('transferCount')"/>
			          						<SPAN id=transferCountImage><%if(transferCount.equals("")){%><IMG src='/images/BacoError_wev8.gif' align=absMiddle><%}%></SPAN>
								    	</td>
								    	<td class=field style="color: #800000">每次可转移的最大记录数，输入正整数。</td>
								  	</tr>
							    	<TR><TD class=Line colSpan=3></TD></TR> 
							    	
							    	<TR class=Title>
										<TH colSpan=3>批量导入</TH>
									</TR>
									<TR class=spacing>
										<TD class=line1 colSpan=3></TD>
									</TR>
									<tr>
										<td>时间范围</td>
								    	<td class=field>
								    		<input class=inputstyle type=text size=5 maxlength="2" name=importStart value="<%=importStart %>" onKeyPress="ItemCount_KeyPress()" 
								    		onBlur="checkcount('importStart');checkinput('importStart','importStartImage');checkHour('importStart')"/>
			          						<SPAN id=importStartImage><%if(importStart.equals("")){%><IMG src='/images/BacoError_wev8.gif' align=absMiddle><%}%></SPAN>
			          						-
			          						<input class=inputstyle type=text size=5 maxlength="2" name=importEnd value="<%=importEnd %>" onKeyPress="ItemCount_KeyPress()" 
								    		onBlur="checkcount('importEnd');checkinput('importEnd','importEndImage');checkHour('importEnd')";/>
			          						<SPAN id=importEndImage><%if(importEnd.equals("")){%><IMG src='/images/BacoError_wev8.gif' align=absMiddle><%}%></SPAN>
								    	</td>
								        <td class=field style="color: #800000">可进行批量导入操作的时间范围。输入9-18代表每天的9:00到18:00;输入18-9代表每天的18:00以后或9:00以前。</td>
								  	</tr>
							    	<TR><TD class=Line colSpan=3></TD></TR> 
							    	<tr>
										<td>最大条数/次</td>
								    	<td class=field>
								    		<input class=inputstyle type=text size=10 maxlength="5" name=importCount value="<%=importCount %>" onKeyPress="ItemCount_KeyPress()" 
								    		onBlur="checkcount('importCount');checkinput('importCount','importCountImage');checkInt('importCount')"/>
			          						<SPAN id=importCountImage><%if(importCount.equals("")){%><IMG src='/images/BacoError_wev8.gif' align=absMiddle><%}%></SPAN>
								    	</td>
								    	<td class=field style="color: #800000">每次可导入的最大记录数，输入正整数。</td>
								  	</tr>
							    	<TR><TD class=Line colSpan=3></TD></TR> 
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
<script language=javascript>  
function submitData(){
	if(check_form(weaver,"transferStart,transferEnd,transferCount,importStart,importEnd,importCount")){
		document.all("method").value="save";
		weaver.submit();
	}
}
function checkHour(name){
	var value = document.all(name).value;
	if(value>23 || value.indexOf("-")>-1){
		alert("请输入0～23的数字！");
		document.all(name).value = "";
		document.all(name+"Image").innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
		document.all(name).focus();
	}
}
function checkInt(name){
	var value = document.all(name).value;
	if(value.indexOf("-")>-1){
		document.all(name).value = "";
		document.all(name+"Image").innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
		document.all(name).focus();
	}
}
</script>
