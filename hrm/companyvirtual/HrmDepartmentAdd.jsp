
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="DepartmentVirtualComInfo" class="weaver.hrm.companyvirtual.DepartmentVirtualComInfo" scope="page" />
<jsp:useBean id="SubCompanyVirtualComInfo" class="weaver.hrm.companyvirtual.SubCompanyVirtualComInfo" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
String virtualtype = Util.null2String(request.getParameter("virtualtype"));
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script type="text/javascript">
var parentWin = parent.parent.getParentWindow(parent);
var dialog = parent.parent.getDialog(parent);
if("<%=isclose%>"=="1"){
	parentWin.onBtnSearchClick();
	parentWin.closeDialog();	
}
</script>
</head>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
String titlename = SystemEnv.getHtmlLabelName(124,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(365,user.getLanguage());
String needfav ="1";
String needhelp ="";

String cmd = Util.null2String(request.getParameter("cmd"));
int id = Util.getIntValue(request.getParameter("id"),0);
int subcompanyid = 0;
int supdepid = 0;
if(cmd.equals("addSiblingDepartment")){
	//同级部门
	subcompanyid = Util.getIntValue(DepartmentVirtualComInfo.getSubcompanyid1(""+id),0);
	supdepid = Util.getIntValue(DepartmentVirtualComInfo.getDepartmentsupdepid(""+id),0);
}else if(cmd.equals("addChildDepartment")){
	//下级级部门
	subcompanyid = Util.getIntValue(DepartmentVirtualComInfo.getSubcompanyid1(""+id),0);
	supdepid = id;
}else{
	//部门
	subcompanyid = Util.getIntValue(request.getParameter("subcompanyid"),0);
}
%>
<BODY>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(HrmUserVarify.checkUserRight("HrmDepartmentAdd:Add", user)){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_TOP} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<%if(HrmUserVarify.checkUserRight("HrmDepartmentAdd:Add", user)){ %>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="submitData();">
			<%} %>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<FORM id=weaver name=frmMain action="DepartmentOperation.jsp" method=post>
   <input class=inputstyle type=hidden name=operation value="add">
   <wea:layout type="2col">
   	<wea:group context="<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>">
	    <wea:item><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></wea:item>
	    <wea:item> 
      	<INPUT class=InputStyle id=departmentmark name=departmentmark maxLength=60  onblur="checkLength('departmentmark',60,'','<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>')" onchange='checkinput("departmentmark","departmentmarkimage")' value="">
        <SPAN id=departmentmarkimage><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN>
      </wea:item>
      <wea:item><%=SystemEnv.getHtmlLabelName(15767,user.getLanguage())%></wea:item>
      <wea:item>
        <INPUT class=InputStyle id=departmentname name=departmentname maxLength=60  onblur="checkLength('departmentname',60,'','<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>')" onchange='checkinput("departmentname","departmentnameimage")' value="">
        <SPAN id=departmentnameimage><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN> 
			</wea:item>
  		<wea:item><%=SystemEnv.getHtmlLabelName(19799,user.getLanguage())%></wea:item>
     	<wea:item>
     		<%
     		String url = "/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/companyvirtual/SubCompanyBrowser.jsp?virtualtype="+virtualtype+"&selectedids=";
     		String completeurl = "/data.jsp?type=hrmsubcompanyvirtual&virtualtype="+virtualtype;
     		%>
	   		<brow:browser viewType="0" id="subcompanyid1" name="subcompanyid1" browserValue='<%=""+subcompanyid %>'
	      	browserUrl="<%=url %>"
	      	hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
	       	completeUrl="<%=completeurl %>" width="200px"
	       	browserSpanValue='<%=SubCompanyVirtualComInfo.getSubCompanyname(""+subcompanyid) %>'
	       	_callback="onDepartmentChange"
	       	>
	      </brow:browser>
       </wea:item>
       <wea:item><%=SystemEnv.getHtmlLabelName(15772,user.getLanguage())%></wea:item>
       <wea:item>
				 <brow:browser viewType="0" id="supdepid" name="supdepid" browserValue='<%=""+supdepid %>'
	       getBrowserUrlFn="getDepartmentUrl"
	       hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
	       completeUrl="javascript:getDepartmentCompleteUrl()" width="200px"
	       browserSpanValue='<%=DepartmentVirtualComInfo.getDepartmentname(""+supdepid)%>'>
       	</brow:browser>                  
       </wea:item>
       <wea:item><%=SystemEnv.getHtmlLabelName(88,user.getLanguage())%></wea:item>
       <wea:item> 
         <INPUT class=InputStyle name=showorder size=4 maxlength=4  onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("showorder")' onchange='checkinput("showorder","showorderimage")' value="0">
         <SPAN id=showorderimage></SPAN>
       </wea:item>
       <wea:item><%=SystemEnv.getHtmlLabelName(15391,user.getLanguage())%></wea:item>
       <wea:item>
         <INPUT class=InputStyle name=departmentcode size=20 maxlength=100 value="">
       </wea:item>
   	</wea:group>
   </wea:layout>
</FORM>
  <%if("1".equals(isDialog)){ %>
  </div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout type="2col">
	    <wea:group context="">
	    	<wea:item type="toolbar">
	    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand();">
</wea:item>
</wea:group>
</wea:layout>
	</div>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
<%} %> 
<script language=javascript>
function submitData() {
	if(check_form(frmMain,'departmentmark,departmentname,subcompanyid1')){
			var subcompanyid = jQuery("#subcompanyid1").val();
		 	var departmentmark = jQuery("#departmentmark").val();
		 	var departmentname = jQuery("#departmentname").val();
		 	jQuery.ajax({
				url:"/hrm/ajaxData.jsp?cmd=checkdepartmentname&subcompanyid="+subcompanyid+"&departmentmark="+departmentmark+"&departmentname="+departmentname,
				type:"post",
				async:true,
				success:function(data,status){
					if(jQuery.trim(data)=="1"){
						document.frmMain.submit();
					}else{
						window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(26603, user.getLanguage())%>");
					}
				},
			});
	}
}

function getDepartmentUrl(){
	var subcompanyid = jQuery("#subcompanyid1").val();
	var url = "/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/companyvirtual/DepartmentBrowser2.jsp?virtualtype=<%=virtualtype%>&allselect=all&notCompany=1&isedit=1&selectedids=";
	url+="&subcompanyid="+subcompanyid;
	return url;
}

function getDepartmentCompleteUrl(){
	var subcompanyid = jQuery("#subcompanyid1").val();
	var url = "/data.jsp?type=hrmdepartmentvirtual&virtualtype=<%=virtualtype%>";
	url+="&whereClause=subcompanyid1="+subcompanyid;
	return url;
}

function onDepartmentChange(e,datas,name){
	_writeBackData('supdepid','1',{'id':'','name':''}); 
}
</script>
</BODY>
</HTML>