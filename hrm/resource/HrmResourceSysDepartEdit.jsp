
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%
String resourceid = request.getParameter("resourceid");
String isclose = request.getParameter("isclose");
%>
<HTML>
<HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<script type="text/javascript">
var parentWin = parent.getParentWindow(window);
if("<%=isclose%>"=="1"){
	parentWin.onBtnSearchClick();
	parentWin.closeDialog();	
}
</script>
</HEAD>
<%
String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(33233,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<body>
<FORM id=weaver name=frmMain action="HrmResourceSysOperation.jsp" method=post >
	<input id="resourceid" name="resourceid" type="hidden" value="<%=resourceid %>">
	<input name="method" type="hidden" value="saveBattchDept">
	<div class="zDialog_div_content">
		<wea:layout type="2col">
			<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
				<wea:item><%=SystemEnv.getHtmlLabelNames("21673,124",user.getLanguage())%></wea:item>
            	<wea:item>
					<brow:browser viewType="0"  name="departmentid" browserValue=""
							 browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/company/DepartmentBrowser.jsp?selectedids="
						   hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
						   completeUrl="/data.jsp?type=4" width="165px"
						   browserSpanValue="">
					</brow:browser>
            	</wea:item>
			</wea:group>
		</wea:layout>		
	</div>
</FORM>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout type="2col">
	    <wea:group context="">
	    	<wea:item type="toolbar">
	    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" id="zd_btn_submit" class="zd_btn_submit" onclick="submitData();">
	    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="parentWin.closeDialog();">
	    	</wea:item>
	   	</wea:group>
	  </wea:layout>
	</div>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
</body>
<script language=javascript>  
function submitData() {
	var resourceid = $('#resourceid').val();
	var departmentid = $('#departmentid').val();
	
	
 if(check_form(frmMain,'departmentid')){
	 $.ajax({
		 url:"/js/hrm/getdata.jsp",
		 type:"post",
		 data:{cmd:"checkBatchNewDeptUsers",arg:departmentid,resourceid:resourceid},
		 dataType:"text",
		 success:function(result){
			if(result && $.trim(result) == "true"){
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(82466,user.getLanguage())%>");
				return false;
			}
			frmMain.submit();
		 }
	 });
 }
}
</script>
</HTML>