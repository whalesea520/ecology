
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
%>
<html>
<HEAD> 
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
</HEAD>
<%
if(!HrmUserVarify.checkUserRight("GroupsSet:Maintenance", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
    int orgGroupId = Util.getIntValue(request.getParameter("orgGroupId"),0); 
	
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename =SystemEnv.getHtmlLabelName(82,user.getLanguage()) + "：" + SystemEnv.getHtmlLabelName(24662,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>


<body>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave();,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="doSave();">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
	<form name="weaver" method="post">
		<INPUT TYPE="hidden" NAME="orgGroupId" value="<%=orgGroupId%>"> 
		<INPUT type="hidden" name="relatedshareid" id="relatedshareid" value="">          
		<INPUT type="hidden" Name="operation" value="addMutil">
		<wea:layout type="2col">
			<wea:group context='<%=SystemEnv.getHtmlLabelName(24663,user.getLanguage())%>'>
	      <wea:item><%=SystemEnv.getHtmlLabelName(24663,user.getLanguage())%></wea:item>
	      <wea:item>
	          <SELECT class=InputStyle id="sharetype" name="sharetype" onChange="onChangeSharetype(this)" style="float: left !important;" >   
	              <option value="2"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>
	              <option value="3"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
	          </SELECT>
	      </wea:item>	
			<wea:item><span id="spanName"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></span></wea:item>
			<wea:item>
				<span id="subcompany" >
	    	  	 <brow:browser viewType="0" name="showsubcompany" browserValue=''
	            browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/company/SubcompanyBrowser.jsp?selectedids="
	            hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1' _callback="jsSetRelatedname"
	            completeUrl="/data.jsp?type=164" width="210px" >
	            </brow:browser>
				</span>
				<span id="department" style="display: none">
		   	  <brow:browser viewType="0" name="showdepartment" browserValue='' 
		       browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/company/DepartmentBrowser.jsp?selectedids="
		       hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1' _callback="jsSetRelatedname"
		       completeUrl="/data.jsp?type=4" width="210px" >
		       </brow:browser>
		    </span>
			</wea:item>		  
	      <wea:item attributes="{'samePair':'showseclevel'}"><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></wea:item>
        <wea:item attributes="{'samePair':'showseclevel'}">
             <INPUT type=text name=seclevel class=InputStyle style="width: 60px" size=6 value="0" onchange='checkinput("seclevel","seclevelimage")' onKeyPress="ItemCount_KeyPress()">
             <span id=seclevelimage></span>
							&nbsp;&nbsp;-&nbsp;&nbsp;
             <INPUT type=text name=secLevelTo class=InputStyle style="width: 60px" size=6 value="100" onchange='checkinput("secLevelTo","secLevelToimage")' onKeyPress="ItemCount_KeyPress()">
             <span id=secLevelToimage></span>											  
        </wea:item>
			</wea:group>
		</wea:layout>
   </form>
   <%if("1".equals(isDialog)){ %>
 </div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout>
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
</body>
</html>

<SCRIPT LANGUAGE="JavaScript">

function onChangeSharetype(obj){
	var thisvalue = obj.value;
	jQuery("#relatedshareid").val("");
	showEle("showseclevel");

/**
	jQuery(showrelatedsharename).html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
	if(thisvalue==1){
		jQuery("#showresource").show();
		hideEle("#showseclevel");
		jQuery("input[name=seclevel]").val(0);
	}else{
		jQuery("#showresource").hide();
	}
**/	

	jQuery("#subcompany").hide();
	jQuery("#department").hide();
	
	if(thisvalue==2){
		jQuery("#spanName").html("<%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>");
 		jQuery("#subcompany").show();
		
 		jQuery("input[name=seclevel]").val(0);
 		jQuery("input[name=seclevelTo]").val(100);
	}else if(thisvalue==3){
		jQuery("#spanName").html("<%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>");
 		jQuery("#department").show();
		
 		jQuery("input[name=seclevel]").val(0);
 		jQuery("input[name=seclevelTo]").val(100);
	}
	
/**
	if(thisvalue==4){
 		jQuery("#showrole").show();
		jQuery("#showrolelevel").show();
    jQuery("#showrolelevel_line").show();
    jQuery("#rolelevel").show();
    jQuery("input[name=seclevel]").val(0);
		jQuery("input[name=seclevelTo]").val(100);
	}
	else{
		jQuery("#showrole").hide();
		jQuery("#showrolelevel").hide();
    jQuery("#showrolelevel_line").hide();
    jQuery("#rolelevel").hide();
    jQuery("input[name=seclevel]").val(0);
		jQuery("input[name=seclevelTo]").val(100);
    }
	if(thisvalue==5){
		jQuery(showrelatedsharename).html("");
		jQuery("#relatedshareid").val(-1);
		jQuery("input[name=seclevel]").val(0);
 		jQuery("input[name=seclevelTo]").val(100);
	}
	if(thisvalue<0){
		jQuery(showrelatedsharename).html("");
		jQuery("#relatedshareid").val(-1);
		jQuery("input[name=seclevel]").val(0);
 		jQuery("input[name=seclevelTo]").val(100);
	}
	**/
}
</SCRIPT>
<script type="text/javascript">
function onShowSubcompany(tdname,inputname){
linkurl="/hrm/company/HrmSubCompanyDsp.jsp?id="
data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp");
if (data!=null) {
    if (data.id!= "") { 	
    	ids = data.id.split(",");
			names =data.name.split(",");
        sHtml = "";
      	for(var i=0;i<ids.length;i++){
      		if(ids!=""){
            sHtml = sHtml+"<a href=javaScript:openFullWindowHaveBar('"+linkurl+ids[i]+"')>"+names[i]+"</a>&nbsp;";
      		}        
      	}
        jQuery("#"+tdname).html(sHtml);
        jQuery("input[name="+inputname+"]").val(data.id);
        }else{
        	jQuery("#"+tdname).html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
	    jQuery("input[name="+inputname+"]").val("");
	    }
	}
}

function onShowDepartment(inputname,spanname){
	linkurl="/hrm/company/HrmDepartmentDsp.jsp?id=";
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp");
	if (data!=null) {
		if (data.id!= "" ) { 	
			ids = data.id.split(",");
			names =data.name.split(",");
			sHtml = "";
			for(var i=0;i<ids.length;i++){
				if(ids!=""){
					sHtml = sHtml+"<a href=javaScript:openFullWindowHaveBar('"+linkurl+ids[i]+"')>"+names[i]+"</a>&nbsp;";
				}
			}
			jQuery("#"+spanname).html(sHtml);
			jQuery("input[name="+inputname+"]").val(data.id);
		}else{
			jQuery("#"+spanname).html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
			jQuery("input[name="+inputname+"]").val("");
		}
	}
}

function doSave(){
 	if(check_form(document.weaver,'relatedshareid')){
  document.weaver.action="/hrm/orggroup/HrmOrgGroupRelatedOperation.jsp?orgGroupId=<%=orgGroupId%>";
	document.weaver.submit();
 	}
}


function jsSetRelatedname(e,datas, name){
  jQuery("input[name=relatedshareid]").val(datas.id);
}
</script>
