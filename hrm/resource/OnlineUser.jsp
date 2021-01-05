
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.general.Util"%>
<%@ page import="java.util.*,weaver.hrm.appdetach.*"%>
<%@page import="weaver.hrm.online.HrmUserOnlineMap"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
Integer lg=(Integer)user.getLanguage();
weaver.general.AccountType.langId.set(lg);
//weaver.general.AccountType.langId.set(user.getLanguage());
%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="departmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="AccountType" class="weaver.general.AccountType" scope="page" />
<jsp:useBean id="LicenseCheckLogin" class="weaver.login.LicenseCheckLogin" scope="page" />
<HTML>
<HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script type="text/javascript" src="/appres/hrm/js/mfcommon_wev8.js"></script>
<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
<style>
.checkbox {
	display: none
}
</style>
</head>
<%
String imagefilename = "/images/hdReport_wev8.gif";
String titlename =SystemEnv.getHtmlLabelName(20536,user.getLanguage());
String needfav ="1";
String needhelp ="";
boolean flagaccount = weaver.general.GCONST.getMOREACCOUNTLANDING();
String departmentid_para = Util.null2String(request.getParameter("departmentid")) ;
String subcompanyid_para=Util.null2String(request.getParameter("subcompanyid1"));//分部
String companyid_para = Util.null2String(request.getParameter("companyid")) ;
if("0".equals(subcompanyid_para)) subcompanyid_para = "";
String chkSubCompany=Util.null2o(request.getParameter("chkSubCompany"));//子分部是否包含
String uworkcode=Util.null2String(request.getParameter("uworkcode"));//编号
String uname=Util.null2String(request.getParameter("uname"));//姓名
String utel=Util.null2String(request.getParameter("utel"));//电话
String umobile=Util.null2String(request.getParameter("umobile"));//移动电话
String uemail=Util.null2String(request.getParameter("uemail"));//电子邮件
String serverip_para=Util.null2String(request.getParameter("serverip"));//服务器地址
String qname=Util.null2String(request.getParameter("flowTitle"));

LicenseCheckLogin.checkOnlineUser();//检测用户在线情况

String navName = "";
if(departmentid_para.length()>0){
	navName = departmentComInfo.getDepartmentName(departmentid_para);
}else if(subcompanyid_para.length()>0){
	navName = SubCompanyComInfo.getSubCompanyname(subcompanyid_para);
}else if(companyid_para.length()>0){
	navName = CompanyComInfo.getCompanyname(companyid_para);
}

weaver.hrm.online.HrmUserOnlineMap HrmUserOnlineMap = weaver.hrm.online.HrmUserOnlineMap.getInstance();
List<String> listAllActiveMachine = HrmUserOnlineMap.getAllActiveMachine();
%>
<script type="text/javascript">
	var common = new MFCommon();
jQuery(document).ready(function(){
	<%if(navName.length()>0){%>
	parent.setTabObjName("<%= navName %>");
	<%}%>
	});
	function forcedOffline(id){
		window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(81904,user.getLanguage())%>", function(){
			jQuery.ajax({
				url:"/js/hrm/getdata.jsp?cmd=userOffline&uid="+id,
				type:"post",
				async:false,
				complete:function(xhr,status){
						_table.reLoad();
				}
			});
			//common.ajax("cmd=userOffline&uid="+id);
			//location.reload();
			//_table.reLoad();
		});
	}
</script>
<BODY>
<div id="tabDiv">
	<span class="toggleLeft" id="toggleLeft" title="<%=SystemEnv.getHtmlLabelName(32814,user.getLanguage()) %>"><%=SystemEnv.getHtmlLabelName(20536,user.getLanguage()) %></span>
</div>
<div id="dialog">
 <div id='colShow'></div>
</div>
<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.HRM_ONLINEUSER %>"/>
	<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onBtnSearchClick(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

%>
	<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
	<FORM id=report name=report action=OnlineUser.jsp method=post>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td></td>
				<td class="rightSearchSpan" style="text-align:right;"><input
					type="text" class="searchInput" name="flowTitle"
					value="<%=qname %>" /> 			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span><span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
					</td>
			</tr>
		</table>
		<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;">
<wea:layout type="4col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
	  <wea:item><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></wea:item>
    <wea:item><INPUT name=uname class='InputStyle' size="30" value='<%=uname%>'></wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></wea:item>
    <wea:item><INPUT name=uworkcode class='InputStyle' size="30" value='<%=uworkcode%>'></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0"  name="subcompanyid1" browserValue='<%=subcompanyid_para %>' 
            browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/company/SubcompanyBrowser.jsp?selectedids="
            hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
            completeUrl="/data.jsp?type=164" width="120px" _callback="makechecked"
            browserSpanValue='<%=SubCompanyComInfo.getSubCompanyname(subcompanyid_para)%>'>
      </brow:browser>
      <!-- 
      <INPUT class='InputStyle' id='chkSubCompany' name='chkSubCompany'
							type='checkbox' value='<%=chkSubCompany%>'
							onclick="setCheckbox(this)" <%if("1".equals(chkSubCompany)){%>
							checked <%}%> <%if("".equals(subcompanyid_para)){%>
							style="display:none" <%}%>><LABEL FOR='chkSubCompany'
							id='lblSubCompany' <%if("".equals(subcompanyid_para)){%>
							style="display:none" <%}%>><%=SystemEnv.getHtmlLabelName(18921,user.getLanguage())%></LABEL>
			 -->
    </wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></wea:item>
    <wea:item>
    	<brow:browser viewType="0"  name="departmentid" browserValue='<%=departmentid_para %>' 
      browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/company/DepartmentBrowser.jsp?selectedids="
      hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
      completeUrl="/data.jsp?type=4" width="120px"
      linkUrl="/hrm/company/HrmDepartmentDsp.jsp?id="
      browserSpanValue='<%=departmentComInfo.getDepartmentname(departmentid_para)%>'>
      </brow:browser>
    </wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(421,user.getLanguage())%></wea:item>
    <wea:item><INPUT name=utel class='InputStyle' size="30" value='<%=utel%>'></wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(620,user.getLanguage())%></wea:item>
    <wea:item><INPUT name=umobile class='InputStyle' size="30" value='<%=umobile%>'></wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(477,user.getLanguage())%></wea:item>
    <wea:item><INPUT name=uemail class='InputStyle' size="30" value='<%=uemail%>'></wea:item>
    <%if(listAllActiveMachine!=null&&listAllActiveMachine.size()>0){ %>
    <wea:item><%=SystemEnv.getHtmlLabelName(32286,user.getLanguage())%></wea:item>
    <wea:item>
	    <select name="serverip" style="width: 130px">
	    	<option value=""><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
	    	<%
	    	String showname = "";
	    	for(String serverip:listAllActiveMachine) {
	    		showname = serverip;
		    	if(HrmUserOnlineMap.islocalMachine(serverip)){
		    		showname = showname + "("+SystemEnv.getHtmlLabelName(129592,user.getLanguage())+")";
		    	}
	    	%>
	    	<option value="<%=serverip %>" <%=serverip.equals(serverip_para)?"selected":"" %>><%=showname %></option>
	    	<%} %>
	    </select>
    <% %>
    </wea:item>
    <%} %>
	</wea:group>
	<wea:group context="">
		<wea:item type="toolbar">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(30947,user.getLanguage())%>" class="e8_btn_submit" onclick="onBtnSearchClick();"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
		</wea:item>
	</wea:group>
</wea:layout>
		</div>
	</FORM>
	<%
//发送邮件    发送短信    新建日程    新建协作
//操作字符串
String tableString = "";
String operateString= "";
operateString = "<operates width=\"20%\">"+
 	        	    " <popedom transmethod=\"weaver.hrm.common.SplitPageTagOperate.getBasicOperate\" otherpara=\"[OnlineUser;+column:id+,"+user.getUID()+","+String.valueOf(user.isAdmin())+"]:true:true:true:true\"></popedom> "+
						"     <operate href=\"javascript:forcedOffline()\" text=\""+SystemEnv.getHtmlLabelName(81903,user.getLanguage())+"\" index=\"0\"/>"+
				 	    "     <operate href=\"/email/new/MailInBox.jsp\" linkkey=\"opNewEmail=1&amp;isInternal=1&amp;internalto\" linkvaluecolumn=\"id\" text=\""+SystemEnv.getHtmlLabelName(2051,user.getLanguage())+"\" target=\"_fullwindow\" isalwaysshow='true' index=\"1\"/>"+
				 		"     <operate href=\"/sms/SmsMessageEdit.jsp\" text=\""+SystemEnv.getHtmlLabelName(16635,user.getLanguage())+"\" linkkey=\"hrmid\" linkvaluecolumn=\"id\" target=\"_fullwindow\" isalwaysshow='true' index=\"2\"/>"+
				        "     <operate href=\"/workplan/data/WorkPlan.jsp\" linkkey=\"id\" linkvaluecolumn=\"id\" text=\""+SystemEnv.getHtmlLabelName(18481,user.getLanguage())+"\" target=\"_fullwindow\" isalwaysshow='true' index=\"3\"/>"+
				        "     <operate href=\"/cowork/AddCoWork.jsp\" linkkey=\"hrmid\" linkvaluecolumn=\"id\" text=\""+SystemEnv.getHtmlLabelName(18034,user.getLanguage())+"\" target=\"_fullwindow\" isalwaysshow='true' index=\"4\"/>"+
 	       				"</operates>";
String params ="serverip:"+serverip_para
							+"+workcode:"+uworkcode
							+"+lastname:"+uname
							+"+subcompanyid:"+subcompanyid_para
							+"+departmentid:"+departmentid_para
							+"+telephone:"+utel
							+"+mobile:"+umobile
							+"+email:"+uemail
							+"+qname:"+qname;
//System.out.println(params);
tableString =" <table tabletype=\"none\" pagesize=\""+ PageIdConst.getPageSize(PageIdConst.HRM_ONLINEUSER,user.getUID(),PageIdConst.HRM)+"\" datasource=\"weaver.hrm.HrmDataSource.getOnLineUserList\" sourceparams=\""+params+"\" pageId=\""+PageIdConst.HRM_ONLINEUSER+"\">"+
		"	   <sql backfields=\"\" sqlform=\"\" sqlwhere=\"\"  sqlorderby=\"\"  sqlprimarykey=\"id\" sqlsortway=\"Asc\" sqlisdistinct=\"false\"/>"+
    operateString+
    "			<head>";
		if(flagaccount){
			tableString +="				<col width=\"10%\" labelid=\"17745\" text=\""+SystemEnv.getHtmlLabelName(17745,user.getLanguage()) +"\" column=\"accounttype\" orderkey=\"accounttype\" transmethod=\"weaver.general.AccountType.getAccountType\" otherpara=\""+user.getLanguage()+"\" />";
		}
		tableString+="				<col width=\"10%\" labelid=\"714\" text=\""+SystemEnv.getHtmlLabelName(714,user.getLanguage()) +"\" column=\"workcode\" orderkey=\"workcode\"/>"+
	  "				<col width=\"10%\" labelid=\"413\" text=\""+SystemEnv.getHtmlLabelName(413,user.getLanguage()) +"\" column=\"lastname\" orderkey=\"lastname\" linkvaluecolumn=\"id\" linkkey=\"id\" href=\"/hrm/resource/HrmResource.jsp?1=1\" target=\"_fullwindow\" />"+
	  "				<col width=\"10%\" labelid=\"141\" text=\""+SystemEnv.getHtmlLabelName(141,user.getLanguage()) +"\" column=\"subcompanyid1\" orderkey=\"subcompanyid1\" transmethod=\"weaver.hrm.company.SubCompanyComInfo.getSubCompanyname\" href=\"/hrm/company/HrmDepartment.jsp\"  linkkey=\"subcompanyid\" target=\"_fullwindow\"/>"+
	  "				<col width=\"10%\" labelid=\"124\" text=\""+SystemEnv.getHtmlLabelName(124,user.getLanguage()) +"\" column=\"departmentid\" orderkey=\"departmentid\" transmethod=\"weaver.hrm.company.DepartmentComInfo.getDepartmentname\" href=\"/hrm/company/HrmDepartmentDsp.jsp\" linkkey=\"id\" target=\"_fullwindow\"/>"+
	  "				<col width=\"15%\" labelid=\"421\" text=\""+SystemEnv.getHtmlLabelName(421,user.getLanguage()) +"\" column=\"telephone\" orderkey=\"telephone\"/>"+
	  "				<col width=\"15%\" labelid=\"620\" text=\""+SystemEnv.getHtmlLabelName(620,user.getLanguage()) +"\" column=\"id\" transmethod=\"weaver.hrm.resource.ResourceComInfo.getMobileShow\" otherpara=\""+user.getUID()+"\" />"+
    "				<col width=\"20%\" labelid=\"477\" text=\""+SystemEnv.getHtmlLabelName(477,user.getLanguage()) +"\" column=\"email\" orderkey=\"email\"/>"+
    "			</head>"+
    " </table>"; 
%>
	<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run" />
	<script type="text/javascript">
	function onShowSubcompanyid1(){
		data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp");
		if (data!=null){
			if (data.id!= ""){
				jQuery("#subcompanyid1span").html(data.name);
				jQuery("#subcompanyid1").val(data.id);
				makechecked();
			}else{
				jQuery("#subcompanyid1span").html("");
				jQuery("#subcompanyid1").val("");
			}
		}
	}
	
	function onShowDepartmentid(){
		data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp");
		if (data!=null){
			if (data.id!= ""){
				jQuery("#departmentidspan").html(data.name);
				jQuery("#departmentid").val(data.id);
				makechecked();
			}else{
				jQuery("#departmentidspan").html("");
				jQuery("#departmentid").val("");
			}
		}
	}
	
		function makechecked() {
			if ($GetEle("subcompanyid1").value != "") {
				$($GetEle("chkSubCompany")).css("display", "");
				$($GetEle("lblSubCompany")).css("display", "");
			} else {
				$($GetEle("chkSubCompany")).css("display", "none");
				$($GetEle("chkSubCompany")).attr("checked", "");
				$($GetEle("lblSubCompany")).css("display", "none");
			}
			jQuery("body").jNice();
		}
		function onBtnSearchClick() {
			report.submit();
		}
		function setCheckbox(chkObj) {
			if (chkObj.checked == true) {
				chkObj.value = 1;
			} else {
				chkObj.value = 0;
			}
		}
		
		function showColDialog(){
		 	var  dialog = new top.Dialog();
		   	dialog.currentWindow = window;
		   	dialog.okLabel = "<%=SystemEnv.getHtmlLabelName(30986,user.getLanguage())%>";
		   	dialog.cancelLabel = "<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>";
		   	dialog.Drag = true;
		   	dialog.Title = "<%=SystemEnv.getHtmlLabelName(32535,user.getLanguage())%>";
		   	dialog.Width = 600;
		   	dialog.Height = 400;
		   	dialog.URL = "/showCol.jsp";
			dialog.show();
		}
	</script>
</BODY>
</HTML>
