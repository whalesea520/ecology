
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.docs.category.CategoryUtil" %>
<%@ page import="weaver.docs.category.security.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />
<%@ taglib uri="/browserTag" prefix="brow"%>
<%
int categoryid = Util.getIntValue(request.getParameter("categoryid"),0);
int categorytype = Util.getIntValue(request.getParameter("categorytype"),0);
int operationcode = Util.getIntValue(request.getParameter("operationcode"),0);
String isclose = Util.null2String(request.getParameter("isclose"));
if (!CategoryUtil.checkCategoryExistence(categorytype, categoryid)) {
	response.sendRedirect("/base/error/DBError.jsp?type=FindData");
	return;
}
//QC61315
String authorityStr="";
MultiAclManager am = new MultiAclManager();
authorityStr=am.getAuthorityStr(categorytype);
int tempType = categorytype==MultiAclManager.CATEGORYTYPE_TREEFIELD?MultiAclManager.OPERATION_TREEFIELDDIR:MultiAclManager.OPERATION_CREATEDIR;
if (!HrmUserVarify.checkUserRight(authorityStr, user) && !am.hasPermission(categoryid, categorytype, user, tempType)) {
	response.sendRedirect("/notice/noright.jsp");
	return;
}
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<LINK href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type=text/css rel=STYLESHEET>
<script type="text/javascript">
	var parentWin = parent.getParentWindow(window);
	var dialog = parent.getDialog(window);
	if("<%=isclose%>"=="1"){
		<%if(categorytype==MultiAclManager.CATEGORYTYPE_TREEFIELD){%>
			try{
				parentWin._table.reLoad();
			}catch(e){}
		<%}else{%>
			var url = "<%=CategoryUtil.getCategoryEditPageNew(categorytype, categoryid,operationcode)%>";
			if(parentWin.refreshDialog){
				url += "&isdialog=1";
			}
			parentWin.location = url;
		<%}%>
		parentWin.closeDialog();	
	}
	jQuery(document).ready(function(){
		jQuery($GetEle("showrolelevel")).css("display","none");
		jQuery($GetEle("showusertype")).css("display","none");
		resizeDialog(document);
	});
</script>
</HEAD>
<%
String imagefilename = "/images/hdCRMAccount_wev8.gif";
String titlename = Util.null2String(request.getParameter("titlename"));
if("".equals(titlename)) titlename = SystemEnv.getHtmlLabelName(119,user.getLanguage());
if(categorytype==0)
    titlename += " - "+SystemEnv.getHtmlLabelName(65,user.getLanguage()) ;
else if(categorytype==1)
    titlename += " - "+SystemEnv.getHtmlLabelName(66,user.getLanguage()) ;
else
    titlename += " - "+SystemEnv.getHtmlLabelName(67,user.getLanguage()) ;
String needfav ="1";
String needhelp ="";
%>
<BODY style="overflow:hidden;">
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="doc"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(categorytype==MultiAclManager.CATEGORYTYPE_TREEFIELD?1507:385,user.getLanguage()) %>"/>
</jsp:include>
<div class="zDialog_div_content">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%

RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(this),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
/*
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:location.href='"+CategoryUtil.getCategoryEditPage(categorytype, categoryid)+"',_top} " ;
RCMenuHeight += RCMenuHeightStep ;
*/
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(30986,user.getLanguage())%>" class="e8_btn_top" onclick="doSave(this);">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>

<FORM id=mainform name=mainform action="PermissionOperation.jsp" method=post onsubmit='return check_by_permissiontype()'>
  <input type="hidden" name="method" value="add">
  <input type="hidden" name="categoryid" value="<%=categoryid%>">
  <input type="hidden" name="categorytype" value="<%=categorytype%>">
  <input type="hidden" name="operationcode" value="<%=operationcode%>">
  <input type="hidden" name="mutil" value="1">


<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(440,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(21956,user.getLanguage())%></wea:item>
		<wea:item>
				<SELECT style="width:160px;" class=InputStyle name=permissiontype onchange="onChangePermissionType()">
				  <option selected value="1"><%=SystemEnv.getHtmlLabelName(7175,user.getLanguage())%></option>
				  <option value="6"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>＋<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></option>
				  <option value="2"><%=SystemEnv.getHtmlLabelName(84166,user.getLanguage())%></option>
				  <option value="3"><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></option>
				  <option value="4"><%=SystemEnv.getHtmlLabelName(7178,user.getLanguage())%></option>
				  <option value="5"><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></option>
				  <option value="7"><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())+"+"+SystemEnv.getHtmlLabelName(28169,user.getLanguage())%></option>
			    </SELECT>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(106,user.getLanguage())%></wea:item>
		<wea:item>
			<span id="showsubcompany" style="display:none;">
				<brow:browser viewType="0" name="subcompanyid" browserValue="" 
						_callback="afterOnShowDepartment"
						browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp?selectedids=#id#&selectedDepartmentIds=#id#"
						hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='2'
						completeUrl="/data.jsp?type=164" temptitle='<%=SystemEnv.getHtmlLabelName(21957,user.getLanguage())%>'>
				</brow:browser>&nbsp;&nbsp; <input onclick="setCheckbox(1)"   class='InputStyle' type='checkbox' name='includesub1' id='includesub1' value='0' ><%=SystemEnv.getHtmlLabelName(33864,user.getLanguage())+SystemEnv.getHtmlLabelName(27170,user.getLanguage())%>
			</span>
			<span id="showjobs" style="display:none;">
				<brow:browser viewType="0" name="jobtitleid" browserValue="" 
				browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/MutiJobTitlesBrowser.jsp?"
				hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='2'
				completeUrl="/data.jsp?type=hrmjobtitles" />
			</span>
			<span id="showdepartment" style="display:'';">
				<brow:browser viewType="0" name="departmentid" browserValue="" 
						_callback="afterOnShowDepartment"
						browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids=#id#&selectedDepartmentIds=#id#"
						hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='2'
						completeUrl="/data.jsp?type=4" temptitle='<%=SystemEnv.getHtmlLabelName(21957,user.getLanguage())%>'>
				</brow:browser>&nbsp;&nbsp; <input onclick="setCheckbox(2)"  class='InputStyle' type='checkbox' name='includesub2' id='includesub2' value='0' ><%=SystemEnv.getHtmlLabelName(33864,user.getLanguage())+SystemEnv.getHtmlLabelName(27170,user.getLanguage())%>
			</span>
			<span id="showrole" style="display:none;">
				<brow:browser viewType="0" name="roleid" browserValue="" 
						browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp?selectedids=#id#"
						hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
						completeUrl="/data.jsp?type=65" width="50%" temptitle='<%=SystemEnv.getHtmlLabelName(21957,user.getLanguage())%>'>
				</brow:browser>
			</span>
			<span id="showrolelevel"   style="display:none;">
						<%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%>
						  <SELECT style="width:60px;" class=InputStyle name=rolelevel>
							<option selected value="0"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
							<option value="1"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>
							<option value="2"><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>
						  </SELECT>
					</span>
			<span id="showuser" style="display:none;">
			   <brow:browser viewType="0" name="userid" browserValue="" 
				browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids=#id#"
				hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='2'
				completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" temptitle='<%=SystemEnv.getHtmlLabelName(21957,user.getLanguage())%>'
				></brow:browser>
			</span>
			<span id=showusertype name=showusertype style="display:none">
	          <SELECT  class=InputStyle name=usertype id="usertype" onchange="onChangeUserType()">
	          <option selected value="0"><%=SystemEnv.getHtmlLabelName(362,user.getLanguage())%></option>
	          <%while(CustomerTypeComInfo.next()){
	        	  String curid=CustomerTypeComInfo.getCustomerTypeid();
	        	  String curname=CustomerTypeComInfo.getCustomerTypename();
	        	  String optionvalue=curid;
	          %>
	          <option value="<%=optionvalue%>"><%=Util.toScreen(curname,user.getLanguage())%></option>
	          <%}%>
	          </SELECT>
	        </span>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></wea:item>
		<wea:item>
			 <span id=showseclevel name=showseclevel style="display:''">
			<INPUT type=text id=seclevel class=InputStyle style="width:30px;" name=seclevel size=6 value="10" onchange="checkinput('seclevel','seclevelimage')"><SPAN id=seclevelimage></SPAN>-
			<INPUT type=text id=seclevelmax class=InputStyle style="width:30px;" name=seclevelmax size=6 value="100" onchange="checkinput('seclevelmax','seclevelmaximage')">	<SPAN id=seclevelmaximage></SPAN>
			</span>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(28169,user.getLanguage())%></wea:item>
		<wea:item>
			<select name="createsubtype" id="createsubtype" onchange="onSelectChanged(this, 'createsubid');" style="float:left;" _type="164" _formFieldType="164,194,169,170,4,57,167,168,1,17,165,166">
				<option value="1" selected ><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%></option>
				<option value="2"><%=SystemEnv.getHtmlLabelName(19437,user.getLanguage())%></option>
				<option value="3"><%=SystemEnv.getHtmlLabelName(19438,user.getLanguage())%></option>
			</select>
			<span id="showPosLevel" style="display:none">
				<brow:browser viewType="0" name="subcompanyid1" browserValue="" 
						_callback="afterOnShowDepartment"
						browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp?selectedids=#id#&selectedDepartmentIds=#id#"
						hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='2'
						completeUrl="/data.jsp?type=164" temptitle='<%=SystemEnv.getHtmlLabelName(21957,user.getLanguage())%>'>
				</brow:browser>
			</span>
			<span id="showDeptLevel" style="display:none">
				<brow:browser viewType="0" name="departmentid1" browserValue="" 
						_callback="afterOnShowDepartment"
						browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids=#id#&selectedDepartmentIds=#id#"
						hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='2'
						completeUrl="/data.jsp?type=4" temptitle='<%=SystemEnv.getHtmlLabelName(21957,user.getLanguage())%>'>
				</brow:browser>
			</span>
		</wea:item>
	</wea:group>
</wea:layout> 
</FORM>

<script language=javascript>
onChangePermissionType();
function setCheckbox(a) {
	if(jQuery("#includesub"+a).attr("checked")){
	     jQuery("#includesub"+a).val(1);
	 }	
}
function check_by_permissiontype() {
    if (document.mainform.permissiontype.value == 1) {
        return check_form(mainform, "departmentid,seclevel,seclevelmax")
    } else if (document.mainform.permissiontype.value == 2) {
        return check_form(mainform, "roleid,rolelevel,seclevel,seclevelmax");
    } else if (document.mainform.permissiontype.value == 3) {
        return check_form(mainform, "seclevel,seclevelmax");
    } else if (document.mainform.permissiontype.value == 4) {
        return check_form(mainform, "usertype,seclevel,seclevelmax");
    } else if (document.mainform.permissiontype.value == 5) {
        return check_form(mainform, "userid");
    } else if (document.mainform.permissiontype.value == 6) {
        return check_form(mainform, "subcompanyid,seclevel,seclevelmax");
    } else if (document.mainform.permissiontype.value == 7) {
    	var joblevel = jQuery("#createsubtype").val();
    	var jobtitleid = jQuery("#jobtitleid").val();
    	var subcompanyid = jQuery("#subcompanyid1").val();
    	var departmentid = jQuery("#departmentid1").val();
    	if(jobtitleid == "")
        {
        	window.top.Dialog.alert("&quot;"+"<%= SystemEnv.getHtmlLabelName(21957,user.getLanguage())%>"+"&quot;"+"<%=SystemEnv.getHtmlLabelName(21423,user.getLanguage())%>!");
        	return false;
        }
        if(joblevel=="2")
        {
        	if(subcompanyid == "")
	        {
	        	window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83526,user.getLanguage())%>!");
	        	return false;
	        }
        }
        if(joblevel=="3")
        {
        	if(departmentid == "")
	        {
	        	window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83527,user.getLanguage())%>!");
	        	return false;
	        }
        }
        return true;
    } else {
        return false;
    }
}

function doSave(obj) {
	  var seclevelmain = jQuery("#seclevel").val();
	  var seclevelmax = jQuery("#seclevelmax").val();
	  if(parseInt(seclevelmain)>parseInt(seclevelmax)){
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(82808,user.getLanguage())%>");
			    return;
	   }
    if (check_by_permissiontype()) {
    	obj.disabled=true;
	    document.mainform.submit();
	}
}

//选择对象类型
function onChangePermissionType() {
	thisvalue=document.mainform.permissiontype.value;
	//document.mainform.departmentid.value="";
	//document.mainform.roleid.value="";
	//document.mainform.userid.value="";
	if (thisvalue == 1) {
 		jQuery("#showdepartment,#includesub2").show();
 		jQuery("#showsubcompany,#showrole,#showrolelevel,#showusertype,#showrolelevelspan,#showuser,#showjobs,#includesub1").hide();
    }
	else if (thisvalue == 2) {
 		jQuery("#showrole,#showrolelevel,#showrolelevelspan").show();
 		jQuery("#showsubcompany,#showdepartment,#showusertype,#showuser,#showjobs").hide();
	}
	else if (thisvalue == 3) {
 		jQuery("#showrelatedsharename").html("");
 		jQuery("#showsubcompany,#showdepartment,#showrole,#showusertype,#showrolelevel,#showrolelevelspan,#showuser,#showjobs").hide();
 		jQuery("#showsubcompany").closest("tr").hide(); //隐藏对象所在行
	}
	else if (thisvalue == 4) {
 		jQuery("#showrelatedsharename").html("");
 		jQuery("#showusertype").show();
 		jQuery("#showsubcompany,#showdepartment,#showrole,#showrolelevel,#showrolelevelspan,#showuser,#showjobs").hide();
	}
	else if (thisvalue == 5) {
 		jQuery("#showuser").show();
 		jQuery("#showsubcompany,#showdepartment,#showrole,#showusertype,#showrolelevel,#showrolelevelspan,#showjobs").hide();
 		jQuery("#showseclevel").closest("tr").hide();//隐藏安全等级所在行
	}
	else if (thisvalue == 6) {
 		jQuery("#showsubcompany,#includesub1").show();
 		jQuery("#showdepartment,#showrole,#showusertype,#showrolelevel,#showrolelevelspan,#showuser,#showjobs,#includesub2").hide();
	}
	else if (thisvalue == 7) {
 		jQuery("#showjobs").show();
 		jQuery("#showsubcompany,#showdepartment,#showrole,#showusertype,#showrolelevel,#showuser").hide();
 		jQuery("#showsubcompany").hide();
 		jQuery("#createsubtype").next("span").width("19%").closest("tr").show();//显示岗位等级所在行	
 		jQuery("#showseclevel").closest("tr").hide();//隐藏安全等级所在行
	}
	
	if(thisvalue != 3)
		jQuery("#showsubcompany").closest("tr").show();//显示对象所在行
	if(thisvalue != 5 && thisvalue != 7)
		jQuery("#showseclevel").closest("tr").show();//显示安全等级所在行
	if(thisvalue != 7)
		jQuery("#createsubtype").closest("tr").hide();//隐藏岗位等级所在行
}

//选择岗位级别
function onSelectChanged(thi,id){
	if(thi.value == 1){
		jQuery("#showPosLevel,#showDeptLevel").hide();
	}else if(thi.value == 2){
		jQuery("#showPosLevel").show();
		jQuery("#showDeptLevel").hide();
	}else if(thi.value == 3){
		jQuery("#showPosLevel").hide();
		jQuery("#showDeptLevel").show();
	}
}

function onChangeUserType() {
    thisvalue = document.getElementById("usertype").value;
    if (thisvalue == "0") {
        document.getElementById("seclevel").value = "10";
    } else {
        document.getElementById("seclevel").value = "0";
    }
}
var opts={
		_dwidth:'550px',
		_dheight:'550px',
		_url:'about:blank',
		_scroll:"no",
		_dialogArguments:"",
		
		value:""
	};
var iTop = (window.screen.availHeight-30-parseInt(opts._dheight))/2+"px"; //获得窗口的垂直位置;
var iLeft = (window.screen.availWidth-10-parseInt(opts._dwidth))/2+"px"; //获得窗口的水平位置;
opts.top=iTop;
opts.left=iLeft;
function onShowResource(spanname,inputname){
	linkurl="javaScript:openhrm(";
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp","","addressbar=no;status=0;scroll="+opts._scroll+";dialogHeight="+opts._dheight+";dialogWidth="+opts._dwidth+";dialogLeft="+opts.left+";dialogTop="+opts.top+";resizable=0;center=1;");
	if (datas) {
		if (datas.id!= "") {
			ids = datas.id.split(",");
			names =datas.name.split(",");
			sHtml = "";
			for( var i=0;i<ids.length;i++){
				if(ids[i]!=""){
					sHtml = sHtml+"<a href="+linkurl+ids[i]+")  onclick='pointerXY(event);'>"+names[i]+"</a>&nbsp";
				}
			}
			$("#"+spanname).html(sHtml);
			$("input[name="+inputname+"]").val(datas.id);
		} else {
			$("#"+spanname).html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
			$("input[name="+inputname+"]").val("");
		}
	}
}
function onShowSubcompany(spanname,inputname)  {
	  linkurl="/hrm/company/HrmSubCompanyDsp.jsp?id=";
	      datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp?selectedids="+$("input[name="+inputname+"]").val()+"&selectedDepartmentIds="+$("input[name="+inputname+"]").val(),
	       "","addressbar=no;status=0;scroll="+opts._scroll+";dialogHeight="+opts._dheight+";dialogWidth="+opts._dwidth+";dialogLeft="+opts.left+";dialogTop="+opts.top+";resizable=0;center=1;");
	     if (datas) {
	      if (datas.id!= "") {
	          ids = datas.id.split(",");
	      names =datas.name.split(",");
	      sHtml = "";
	      for( var i=0;i<ids.length;i++){
	      if(ids[i]!=""){
	       sHtml = sHtml+"<a href='"+linkurl+ids[i]+"'  >"+names[i]+"</a>&nbsp";
	      }
	      }
	      $("#"+spanname).html(sHtml);
	      $("input[name="+inputname+"]").val(datas.id);
	      $GetEle("mutil").value = "1"
	      }
	      else {
	            $("#"+spanname).html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
	      		$("input[name="+inputname+"]").val("");
	      }
	  }
	  }

function onShowRole(tdname,inputename){
	  datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp","","addressbar=no;status=0;scroll="+opts._scroll+";dialogHeight="+opts._dheight+";dialogWidth="+opts._dwidth+";dialogLeft="+opts.left+";dialogTop="+opts.top+";resizable=0;center=1;");
	if(datas){
	    if (datas.id!=""){
		$("#"+tdname).html("<a href=\"#"+datas.id+"\">"+datas.name+"</a>");
		$("input[name="+inputename+"]").val(datas.id);
	    }else{
	    	$("#"+tdname).html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
	    	$("input[name="+inputename+"]").val("");
	    }
	}
}


function afterOnShowDepartment(e,datas,fieldid,params){
	if (datas) {
		$GetEle("mutil").value = "1"
	}else{
	
	}
}

function onShowDepartment(spanname,inputname){
	  
	  linkurl="/hrm/company/HrmDepartmentDsp.jsp?id=";
	  datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids="+$("input[name="+inputname+"]").val()+"&selectedDepartmentIds="+$("input[name="+inputname+"]").val(),
	  "","addressbar=no;status=0;scroll="+opts._scroll+";dialogHeight="+opts._dheight+";dialogWidth="+opts._dwidth+";dialogLeft="+opts.left+";dialogTop="+opts.top+";resizable=0;center=1;");
	   if (datas) {
	      if (datas.id!= "") {
	          ids = datas.id.split(",");
	      names =datas.name.split(",");
	      sHtml = "";
	      for( var i=0;i<ids.length;i++){
	      if(ids[i]!=""){
	       sHtml = sHtml+"<a href='"+linkurl+ids[i]+"'  >"+names[i]+"</a>&nbsp";
	      }
	      }
	      $("#"+spanname).html(sHtml);
	      $("input[name="+inputname+"]").val(datas.id);
	      $GetEle("mutil").value = "1"
	      }
	      else {
	            $("#"+spanname).html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
	      $("input[name="+inputname+"]").val("");
	      }
	  }
}
</script>
	</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{'groupDisplay':'none'}">
			<wea:item type="toolbar">
		    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand();">
			</wea:item>
		</wea:group>
	</wea:layout>
	
</div>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>  
</BODY>
</HTML>
