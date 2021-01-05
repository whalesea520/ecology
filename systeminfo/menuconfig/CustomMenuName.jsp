
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.systeminfo.menuconfig.*" %>

<%
int userid=0;
userid=user.getUID();

int id = Util.getIntValue(request.getParameter("id"));
int resourceId = Util.getIntValue(request.getParameter("resourceId"));
String resourceType = Util.null2String(request.getParameter("resourceType"));
String type = Util.null2String(request.getParameter("type"));
int sync = Util.getIntValue(request.getParameter("sync"),1);

String closeDialog = Util.null2String(request.getParameter("closeDialog"));
String subCompanyId = Util.null2String(request.getParameter("subCompanyId"));
String selectids = Util.null2String(request.getParameter("selectids"));


MenuMaint  mm=new MenuMaint(type,Util.getIntValue(resourceType),resourceId,user.getLanguage());

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";
if(resourceType.equalsIgnoreCase("3"))
	titlename = SystemEnv.getHtmlLabelName(17594,user.getLanguage())+" - " + SystemEnv.getHtmlLabelName(17596,user.getLanguage())+" - " + SystemEnv.getHtmlLabelName(17607,user.getLanguage());
else {
	titlename += SystemEnv.getHtmlLabelName(18986, user.getLanguage())+" - " + SystemEnv.getHtmlLabelName(17607,user.getLanguage());
}
String needfav ="1";
String needhelp ="";    


MenuConfigBean mcb = mm.getMenuConfigBeanByInfoId(id);
MenuInfoBean info = mcb.getMenuInfoBean();

int labelId = info.getLabelId();
String infoCustomName = Util.null2String(info.getCustomName());
String isCustomMenu = Util.null2String(info.getIsCustom());

boolean useCustomName = mcb.isUseCustomName();
String customName = mcb.getCustomName();
String 	customName_e = mcb.getCustomName_e();
String 	customName_t = mcb.getCustomName_t();
String topmenuname = mcb.getTopMenuName();
String topname_e = mcb.getTopName_e();
String topname_t = mcb.getTopName_t();
String targetFrame=mcb.getMenuInfoBean().getTargetBase();
if(!HrmUserVarify.checkUserRight("HeadMenu:Maint", user)){
	if("1".equals(resourceType)){
		response.sendRedirect("/notice/noright.jsp");
        return;
	}
}
if(!HrmUserVarify.checkUserRight("SubMenu:Maint", user)){
	if("2".equals(resourceType)){
		response.sendRedirect("/notice/noright.jsp");
        return;
	}
}


String navName = "";
if(type.equals("left")){
	navName =  SystemEnv.getHtmlLabelName(33675, user.getLanguage());
}else{
	navName =  SystemEnv.getHtmlLabelName(33676, user.getLanguage());
}
%> 

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <link href="/css/Weaver_wev8.css" type=text/css rel=stylesheet>
	<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
  </head>
  
  <body>
  <jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="portal"/>
   <jsp:param name="navName" value="<%=navName %>"/> 
</jsp:include>
  <%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
  
  <%
  RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:checkSubmit(),_self} " ;
  RCMenuHeight += RCMenuHeightStep ;
  %>
  
  <%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td width="160px">
				</td>
				<td class="rightSearchSpan"
					style="text-align: right; width: 500px !important">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(30986,user.getLanguage())%>" class="e8_btn_top"
						onclick="checkSubmit(this,event);" />
					&nbsp;&nbsp;&nbsp;
					<span title="<%=SystemEnv.getHtmlLabelName(83721,user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
	<FORM style="MARGIN-TOP: 0px" name=frmMain method=post action="CustomMenuNameOperation.jsp" onsubmit='return doCheck_form()'>
		<input type=hidden name=id value=<%=id%>>
		<input type=hidden name=subCompanyId value=<%=subCompanyId%>>
		<input type=hidden name=resourceId value=<%=resourceId%>>
		<input type=hidden name=resourceType value=<%=resourceType%>>
		<input type=hidden name=sync value=<%=sync%>>
		<input type=hidden name=type value=<%=type%>>
<wea:layout type="2Col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>' attributes="{'class':\"e8_title e8_title_1\"}">
		<wea:item><%=SystemEnv.getHtmlLabelName(17609,user.getLanguage())%></wea:item>
		<wea:item>
			<%if(isCustomMenu.equals("2")){%>
			<%=infoCustomName%>
			<%}else if(isCustomMenu.equals("1")){%>
			<%=customName%>
			<%}else{%>
			<%=SystemEnv.getHtmlLabelName(labelId,user.getLanguage())%>
			<%}%>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(20235,user.getLanguage())%></wea:item>
		<wea:item>
			<select style="width:85px;"  name="basetarget">
				<option value="" <%if("".equals(targetFrame)) out.println(" selected ");%>><%=SystemEnv.getHtmlLabelName(20597,user.getLanguage())%></option>
				<option value="_blank" <%if(!"".equals(targetFrame)) out.println(" selected ");%>><%=SystemEnv.getHtmlLabelName(18717,user.getLanguage())%></option>
			</select>							
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(17610,user.getLanguage())%></wea:item>
		<wea:item>			
		<select name="changelang" style="width:85px;" id="changelang">
     		<option value="customName"><%=SystemEnv.getHtmlLabelName(1997,user.getLanguage())%></option>
         	<option value="customName_e"><%=SystemEnv.getHtmlLabelName(642,user.getLanguage())%></option>
         	<option value="customName_t"><%=SystemEnv.getHtmlLabelName(21866,user.getLanguage())%></option> 
         </select>
         <INPUT class="InputStyle menuname" style="width:200px;" onchange='doCheck_Input()' maxLength=50 name="customName" id="customName" value="<%=customName %>" >
         <SPAN id=customNamespan><%if(useCustomName&&customName.equals("")){%><IMG src='/images/BacoError_wev8.gif' align=absMiddle><%}%></SPAN>
         
         <INPUT class="InputStyle menuname" style="width:200px;display:none" maxLength=50 id="customName_e" name="customName_e" value="<%=customName_e %>">
         <INPUT class="InputStyle menuname" style="width:200px;display:none" maxLength=50 id="customName_t" name="customName_t" value="<%=customName_t %>">
        
		</wea:item>
		
	 <%if(type.equals("left")){ %>
      <wea:item><%=SystemEnv.getHtmlLabelName(33472,user.getLanguage())%></wea:item>
      <wea:item>
         <select name="changetoplang" style="width:85px;" id="changetoplang">
         	<option value="topMenuName"><%=SystemEnv.getHtmlLabelName(1997,user.getLanguage())%></option>
         	<option value="topName_e"><%=SystemEnv.getHtmlLabelName(642,user.getLanguage())%></option>
         	<option value="topName_t"><%=SystemEnv.getHtmlLabelName(21866,user.getLanguage())%></option> 
        
         </select>
         <INPUT class="InputStyle topmenuname" style="width:200px;" maxLength=50 name="topMenuName" id="topMenuName" value="<%=topmenuname %>" >
         <INPUT class="InputStyle topmenuname" style="width:200px;display:none" maxLength=50 id="topName_e" name="topName_e" value="<%=topname_e %>">
         <INPUT class="InputStyle topmenuname" style="width:200px;display:none" maxLength=50 id="topName_t" name="topName_t" value="<%=topname_t %>">
      </wea:item>
     <%} %>
	
		<wea:item><%=SystemEnv.getHtmlLabelName(17611,user.getLanguage())%></wea:item>
		<wea:item>
            <%if(useCustomName){%>
              	<input type="checkbox" tzCheckbox="true" name=useCustom  value="1" onclick='doCheck_Input()' checked>
            <%}else{%>
				<input type="checkbox" tzCheckbox="true" name=useCustom  value="1" onclick='doCheck_Input()'>
            <%}%>
		</wea:item>
	</wea:group>
</wea:layout>
    </FORM>

<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<table width="100%">
	    <tr><td style="text-align:center;">
	    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="onCancel();">
	    </td></tr>
	</table>
</div>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include> 
</body>

<script LANGUAGE="JavaScript">

function checkSubmit(){

	if(frmMain.useCustom.checked){
		if(check_form(frmMain,'customName')){
			frmMain.submit();
		}
	}
	else{
		frmMain.submit();
	}
}

function doCheck_form(){
	if(frmMain.useCustom.checked){
		return check_form(frmMain,'customName');
	}
	else{
		return true;
	}
}

function doCheck_Input(){
	if(frmMain.useCustom.checked){
		checkinput("customName","customNameSpan");
	}
	else{
		document.all("customNameSpan").innerHTML='';
	}
}

function onCancel(){
	var dialog = parent.getDialog(window);	
	dialog.close();
}

jQuery(document).ready(function(){
	resizeDialog(document);
	if("<%=closeDialog%>"=="close"){
		var parentWin = parent.getParentWindow(window); 
		parentWin.location.href="/page/maint/menu/SystemMenuMaintList.jsp?type=<%=type%>&resourceType=<%=resourceType%>&resourceId=<%=resourceId%>&mode=visible&subCompanyId=<%=subCompanyId%>&opend=1&selectids=<%=selectids%>";
		onCancel();
	}
	
	$("#changelang").bind("change",function(){
		$(".menuname").hide();
		if($(this).val()!="customName"){
			$("#customNamespan").hide();
		}else{
			$("#customNamespan").show();
		}
		$("#"+$(this).val()).show();
	})
	$("#changetoplang").bind("change",function(){
		$(".topmenuname").hide();
		$("#"+$(this).val()).show();
	})
})
</script>

</html>

