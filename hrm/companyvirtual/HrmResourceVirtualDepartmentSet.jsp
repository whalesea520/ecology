<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="CompanyVirtualComInfo" class="weaver.hrm.companyvirtual.CompanyVirtualComInfo" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%
	String isclose = Util.null2String(request.getParameter("isclose"));
	String isDialog = Util.null2String(request.getParameter("isdialog"));
	String resourceids = Util.null2String(request.getParameter("resourceids"));//需要设置的resourceid
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
String titlename = "";
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(HrmUserVarify.checkUserRight("HrmResourceAdd:Add", user)){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave();,_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<%if(HrmUserVarify.checkUserRight("HrmResourceAdd:Add", user)){ %>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="onSave();">
			<%} %>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<FORM id=weaver name=frmMain action="ResourceOperation.jsp" method=post >
   <input type=hidden name=operation>
   <input type=hidden id=resourceids name=resourceids value="<%=resourceids%>">
	<wea:layout type="2col">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
      <wea:item><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%></wea:item>
      <wea:item><%=ResourceComInfo.getLastnameAllStatus(resourceids)%></wea:item>
      <wea:item><%=SystemEnv.getHtmlLabelName(82531,user.getLanguage())%></wea:item>
      <wea:item>
      	<wea:required id="virtualtypespan" required="true">
     		<select id=virtualtype name=virtualtype style="width: 100px" onchange="checkinput('virtualtype','virtualtypespan');jsChangevirtualtype(this);">
     		<option value=""></option>
    		<%
    		CompanyVirtualComInfo.setTofirstRow();
    		while(CompanyVirtualComInfo.next()){
    		%>
    		<option value="<%=CompanyVirtualComInfo.getCompanyid() %>" ><%=CompanyVirtualComInfo.getVirtualType() %></option>
    		<%} %>
				</select>
				</wea:required>
      </wea:item>
     	<wea:item attributes="{'samePair':'itemdepartmentid','display':'none'}"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></wea:item>
			<wea:item attributes="{'samePair':'itemdepartmentid','display':'none'}">
				<brow:browser viewType="0" id="departmentid" name="departmentid" browserValue="" 
				 getBrowserUrlFn="onShowDepartment" 
	       hasInput="true" isSingle="false" hasBrowser="true" isMustInput='2'
	       completeUrl="javascript:getcompleteurl()" width="200px"
	       browserSpanValue="">
       	</brow:browser>               
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
 function onShowDepartment(){
 	var virtualtype = jQuery("#virtualtype").val();
	return "/systeminfo/BrowserMain.jsp?url=/hrm/companyvirtual/DepartmentBrowser.jsp?virtualtype="+virtualtype+"&selectedids="+jQuery("#departmentid").val()
 }
 
 function getcompleteurl(){
 	var virtualtype = jQuery("#virtualtype").val();
 	var completeurl = "/data.jsp?type=hrmdepartmentvirtual&virtualtype="+virtualtype;
	return completeurl;
 }
 
function onSave(){
	if(check_form(document.frmMain,'virtualtype,departmentid')){
		//增加唯一校验
		jQuery.ajax({
				url:"/hrm/ajaxData.jsp",
				type:"POST",
				dataType:"json",
				async:true,
				data:{
					cmd:"checkResourceVirtual",
					virtualtype:jQuery("#virtualtype").val(),
					resourceids:jQuery("#resourceids").val()
				},
				success:function(datas){
					var errInfo = "";
					for (var i = 0; i < datas.length; i++) {
						var dataitem = datas[i];
						if(errInfo.length>0)errInfo+="<br>";
						<%if(user.getLanguage()==8){%>
						errInfo += dataitem["lastname"]+"has in"+dataitem["virtualtypename"]"
						<%}else if(user.getLanguage()==9){%>
						errInfo += dataitem["lastname"]+"<%=SystemEnv.getHtmlLabelName(83474,user.getLanguage())%>"+dataitem["virtualtypename"]+"<%=SystemEnv.getHtmlLabelName(16330, user.getLanguage())%>"
						<%}else{%>
						errInfo += dataitem["lastname"]+"<%=SystemEnv.getHtmlLabelName(83474,user.getLanguage())%>"+dataitem["virtualtypename"]+"<%=SystemEnv.getHtmlLabelName(16330, user.getLanguage())%>"
						<%}%>
					}
					if(i==0){
						document.frmMain.operation.value="setDepartmentVirtual";
						document.frmMain.submit();
					}else{
						//数据异常提示
							window.top.Dialog.alert(errInfo);
							document.frmMain.operation.value="setDepartmentVirtual";
							document.frmMain.submit();
					}
				}
		});
	}
}

function jsChangevirtualtype(obj){
	_writeBackData('departmentid','2',{'id':'','name':''});
	if(obj.value==""){
		hideEle("itemdepartmentid");
	}
	else {
		showEle("itemdepartmentid");
	} 
}
</script>
</BODY></HTML>
