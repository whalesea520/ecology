<%@page import="weaver.general.TimeUtil"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.Calendar" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CptDwrUtil" class="weaver.cpt.util.CptDwrUtil" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>

<%
String nameQuery = Util.null2String(request.getParameter("nameQuery"));
String rightStr = "";
if(!HrmUserVarify.checkUserRight("CptCapital:Mend", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}else{
		rightStr = "CptCapital:Mend";
		session.setAttribute("cptuser",rightStr);
	}
String capitalid =Util.null2String( request.getParameter("capitalid"));
%>
<%
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<link rel="stylesheet" href="/wui/theme/ecology8/weaveredittable/css/WeaverEditTable_wev8.css">
<script  src="/wui/theme/ecology8/weaveredittable/js/WeaverEditTable_wev8.js"></script>
<script type="text/javascript">
var parentWin;
if("<%=isDialog %>"=="1"){
	parentWin = parent.parent.getParentWindow(parent.window);
	var parentDialog = parent.parent.getDialog(parent);
}
if("<%=isclose%>"=="1"){
	parentWin.onBtnSearchClick();
	parentWin.closeDialog();	
}
</script>
</head>
<%
Calendar current = Calendar.getInstance();
String currDate = Util.add0(current.get(Calendar.YEAR), 4) +"-"+
                 Util.add0(current.get(Calendar.MONTH) + 1, 2) +"-"+
                 Util.add0(current.get(Calendar.DAY_OF_MONTH), 2) ;
String currentdate = TimeUtil.getCurrentDateString();
String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(22459,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelNames("83602",user.getLanguage())+",javascript:onSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<FORM id=frmain name=frmain method=post >

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelNames("83602",user.getLanguage())%>" class="e8_btn_top" onclick="onSubmit()"/>
			<span id="advancedSearch" class="advancedSearch" style="display:none;"><%=SystemEnv.getHtmlLabelNames("347",user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelNames("23036",user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>		
<div class="advancedSearchDiv" id="advancedSearchDiv"></div>
<%
HashMap cptMap=CptDwrUtil.getCptInfoMap(capitalid);
if(cptMap==null){
	response.sendRedirect("/notice/noright.jsp");
}
%>

<%
	rs.executeSql("select blongdepartment from cptcapital where id = "+capitalid);
	String blongdeptid = "";
	if(rs.next()){
		blongdeptid = rs.getString("blongdepartment");
	}
	
%>

<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelNames("22459",user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelNames("33016",user.getLanguage())%></wea:item>
		<wea:item><%=CapitalComInfo.getCapitalname(capitalid) %>
			<input type=hidden name="capitalid" value="<%=capitalid %>" />
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("15393",user.getLanguage())%></wea:item>
		<wea:item><%=DepartmentComInfo.getDepartmentname(blongdeptid) %></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("904",user.getLanguage())%></wea:item>
		<wea:item><%=Util.null2String( cptMap.get("capitalspec")) %></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("602",user.getLanguage())%></wea:item>
		<wea:item><%=Util.null2String( cptMap.get("statename")) %></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("1399",user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="maintaincompany" 
				browserValue="" 
				browserSpanValue=""
				browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp?sqlwhere=where t1.type=2"
				hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
				completeUrl="/data.jsp?type=7"  />
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("1409",user.getLanguage())%></wea:item>
		<wea:item><input name='menddate' type='hidden' value='<%=TimeUtil.getCurrentDateString() %>'   class='wuiDate'   _span='menddate_span' _button='menddate_btn' _callback='' ></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("22457",user.getLanguage())%></wea:item>
		<wea:item><input name='mendperioddate' type='hidden' value=''   class='wuiDate'   _span='mendperioddate_span' _button='mendperioddate_btn' _callback='' ></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("1393",user.getLanguage())%></wea:item>
		<wea:item><input type='text' style='width:50px!important;' name='cost' id='cost' size='10' maxlength='10' onkeypress="return event.keyCode>=4&&event.keyCode<=57" /></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("1047",user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="operator" 
				browserValue="" 
				browserSpanValue=""
				browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
				hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
				completeUrl="/data.jsp"  />
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("454",user.getLanguage())%></wea:item>
		<wea:item><input type='text'  name='remark' id='remark' /></wea:item>
	</wea:group>
</wea:layout>


 </form>
 <script language="javascript">

 
function onSubmit()
{
	if(check_form(document.frmain,'maintaincompany')) {
		
		document.frmain.action="CapitalMendOperation.jsp?from=one";
		document.frmain.submit();
	}
}



</script>

<%
if("1".equals(isDialog)){
	%>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout>
	<wea:group context="">
    	<wea:item type="toolbar">
    		<input class="zd_btn_cancle" type="button" name="cancel" onclick="parentDialog.closeByHand();"  value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>"/>
    	</wea:item>
    </wea:group>
</wea:layout>
</div>	
	
	<%
}
%>

</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>
