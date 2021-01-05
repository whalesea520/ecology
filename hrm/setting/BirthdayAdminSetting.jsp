
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
	String isclose = Util.null2String(request.getParameter("isclose"));
	String isDialog = Util.null2String(request.getParameter("isdialog"));

	String cmd = Util.null2String(request.getParameter("cmd"));
	
	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = Util.null2String(request.getParameter("titlename"));
%>
<HTML>
<HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<LINK href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type=text/css rel=STYLESHEET>
<script type="text/javascript">
try{
	parent.setTabObjName("<%=SystemEnv.getHtmlLabelName(17869,user.getLanguage())%>");
}catch(e){
	if(window.console)console.log(e+"-->BirthdayAdminBrowser.jsp");
}
var parentWin = parent.parent.getParentWindow(parent);
var dialog = parent.parent.getDialog(parent);
if("<%=isclose%>"=="1"){
	parentWin.reflashAdminTable();
	dialog.close();	
}

jQuery(function(){
	onChangeSharetype();
});

function onChangeSharetype(){
	thisvalue=document.weaver.sharetype.value;
	document.weaver.relatedshareid.value="";
	document.all("showseclevel").style.display='';
	
	document.all("showresource").style.display='none';
	document.all("showsubcompany").style.display='none';
	document.all("showdepartment").style.display='none';
	document.all("showrole").style.display='none';
	if(thisvalue==1){
		document.all("showseclevel").style.display='none';
		document.all("showresource").style.display='';
		//$("#relatedshareid").attr("_url","/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp");
		
		//TD33012 当安全级别为空时，选择人力资源，赋予安全级别默认值10，否则无法提交保存
		seclevelimage.innerHTML = ""
		if(document.all("seclevel").value==""){
			document.all("seclevel").value=10;
		}
		//End TD33012
	}
	if(thisvalue==2){
		document.weaver.seclevel.value=10;
		//$("#relatedshareid").attr("_url","/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp");
		document.all("showsubcompany").style.display='';
	}
	else{
		document.weaver.seclevel.value=10;
	}
	if(thisvalue==3){
		document.weaver.seclevel.value=10;
		//$("#relatedshareid").attr("_url","/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp");
		document.all("showdepartment").style.display='';
	}
	else{
		document.weaver.seclevel.value=10;
	}
	if(thisvalue==4){
		document.all("showrolelevel").style.display='none';
		//$("#relatedshareid").attr("_url","/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp");
		document.all("showrole").style.display='';
		document.weaver.seclevel.value=10;
	}
	else{
		document.all("showrolelevel").style.visibility='hidden';
		document.weaver.seclevel.value=10;
  	}
	if(thisvalue==5){
		document.weaver.relatedshareid.value=-1;
		document.weaver.seclevel.value=10;
		$("#relatedshareidBtn").hide();
		$("#relatedshareidSpan").hide();
	}else{
		$("#relatedshareidBtn").show();
		$("#relatedshareidSpan").show();
	}
	if(thisvalue<0){
		document.weaver.relatedshareid.value=-1;
		document.weaver.seclevel.value=0;
	}
}


function doSave() {
	var checkstr="relatedshareid";
	if(check_form(document.weaver,checkstr)){
		document.weaver.submit();
	}
}


function jsSetRelatedshareid(e,datas,name){
	jQuery("#relatedshareid").val(datas.id);
}
function jsAfterDelCallback(text,fieldid,params){
	jQuery("#relatedshareid").val("");
}
</script>
</head>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
	<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td>
			</td>
			<td class="rightSearchSpan" style="text-align:right;">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" id="zd_btn_submit" class="e8_btn_top" onclick="doSave();">
				<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu"></span>
			</td>
		</tr>
	</table>
<BODY>
	<%if("1".equals(isDialog)){ %>
	<div class="zDialog_div_content">
	<%} %>
	<FORM style="MARGIN-TOP: 0px" name=weaver method=post action="BirthdayAdminSettingOperation.jsp">
		<input type="hidden" name="method" value="add">
		<input id="relatedshareid" name="relatedshareid" type="hidden" value="">
		<wea:layout type="2col">
			<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
				<wea:item><%=SystemEnv.getHtmlLabelName(22256,user.getLanguage())%></wea:item>
				<wea:item>
	        <SELECT class=inputstyle name=sharetype onchange="onChangeSharetype()" >
		        <option value="1" selected><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></option>
		        <option value="2"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>
		        <option value="3"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
		        <option value="4"><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></option>
		        <option value="5"><%=SystemEnv.getHtmlLabelName(1340,user.getLanguage())%></option>
		    	</SELECT>
			  </wea:item>
			  <wea:item><%=SystemEnv.getHtmlLabelName(106,user.getLanguage())%></wea:item>
			  <wea:item>
	      	<span id="showsubcompany" style="display:none;">
        	 	<brow:browser viewType="0" name="subcompanyid" browserValue="" 
                browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/company/SubcompanyBrowserByDec.jsp?selectedids="
                hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
                _callback="jsSetRelatedshareid" afterDelCallback="jsAfterDelCallback"
                completeUrl="/data.jsp?type=164" width="150px">
        		</brow:browser>
					</span>
      		<span id="showdepartment" style="display:none;">
        		<brow:browser viewType="0" name="departmentid" browserValue="" 
                browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/company/DepartmentBrowser.jsp?selectedids="
                hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='2'
                _callback="jsSetRelatedshareid" afterDelCallback="jsAfterDelCallback"
                completeUrl="/data.jsp?type=4" width="150px">
        		</brow:browser>
					</span>
				  <span id="showrole" style="display:none;">
		        <brow:browser viewType="0" name="roleid" browserValue="" 
               browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/roles/HrmRolesBrowser.jsp"
               hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
               _callback="jsSetRelatedshareid" afterDelCallback="jsAfterDelCallback"
               completeUrl="/data.jsp?type=65" width="150px">
		      	</brow:browser>
					</span>
					<span id="showresource" style="display:;">
             <brow:browser viewType="0" name="resourceid" browserValue="" 
              browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
              hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='2'
              _callback="jsSetRelatedshareid" afterDelCallback="jsAfterDelCallback"
              completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" width="150px">
              </brow:browser>
			   </span>
			  </wea:item>
			  <wea:item><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></wea:item>
				<wea:item>
					<span id=showrolelevel name=showrolelevel style="display: none">
					<%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%>:
					<select class=inputstyle  name=rolelevel  >
					  <option value="0" selected><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
					  <option value="1"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>
					  <option value="2"><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>
					</SELECT>
					</span>
					<span id=showseclevel name=showseclevel>
					<INPUT type=text class="InputStyle" name=seclevel size=6 value="10" onchange='checkinput("seclevel","seclevelimage")' >
					</span>
					<SPAN id=seclevelimage></SPAN>
				</wea:item>
				<!-- 本部门、本部门及上级部门、本部门及下级部门、本分部、本分部及上级分部、本分部及下级分部 -->
				<wea:item><%=SystemEnv.getHtmlLabelNames("26928,139",user.getLanguage())%></wea:item>
				<wea:item attributes="{'colspan':'2'}">
					<select class=inputstyle  name=sharelevel onchange="onChangeShareLevel(event)">
						<option value="0" selected><%=SystemEnv.getHtmlLabelName(21837,user.getLanguage())%></option>
					  <option value="1"><%=SystemEnv.getHtmlLabelName(27640,user.getLanguage())%></option>
					  <option value="2"><%=SystemEnv.getHtmlLabelName(30343,user.getLanguage())%></option>
            <option value="3"><%=SystemEnv.getHtmlLabelName(30792,user.getLanguage())%></option>
            <option value="4"><%=SystemEnv.getHtmlLabelName(27189,user.getLanguage())%></option>
            <option value="5"><%=SystemEnv.getHtmlLabelName(19436,user.getLanguage())%></option>
            <option value="6"><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%></option>
					</select>
				</wea:item>
			</wea:group>
		</wea:layout>
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
	</FORM>
</BODY>
</HTML>
