<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page"/>
<jsp:useBean id="CapitalAssortmentComInfo" class="weaver.cpt.maintenance.CapitalAssortmentComInfo" scope="page"/>

<%
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<SCRIPT language="javascript" src="/cpt/js/validate_wev8.js"></script>

<script type="text/javascript">
var parentWin;
if("<%=isDialog %>"=="1"){
	parentWin = parent.getParentWindow(window);
}


if("<%=isclose%>"=="1"){
	parentWin.onBtnSearchClick();
	parentWin.closeDialog();	
}
</script>
</head>

<%

String assortid = Util.fromScreen(request.getParameter("assortmentid"),user.getLanguage());
String assortname = Util.toScreen(CapitalAssortmentComInfo.getAssortmentName(assortid),user.getLanguage());
String remindsubmit = Util.fromScreen(request.getParameter("remindsubmit"),user.getLanguage());

boolean canedit = true;



%>


<%

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(119,user.getLanguage())+" - "+SystemEnv.getHtmlLabelName(535,user.getLanguage())+":<a href='/cpt/maintenance/CptAssortmentView.jsp?paraid="+assortid+"'>"+assortname+"</a>";
String needfav ="1";
String needhelp ="";

%>
<BODY  >
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="assest"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(2112,user.getLanguage()) %>"/>
</jsp:include>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<% 

RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

/**
RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:dosubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;


RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:back(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
**/

%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="onSubmit();">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<FORM id=weaver name=weaver action="/cpt/maintenance/AssortShareOperation.jsp" >
<input type="hidden" name="method" value="add">
<input type="hidden" name="assortid" value="<%=assortid%>">

<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelNames("2112",user.getLanguage())%>' attributes="" >
		<wea:item><%=SystemEnv.getHtmlLabelNames("21956",user.getLanguage())%></wea:item>
		<wea:item>
			<SELECT name=sharetype onchange="onChangeSharetype()" class=InputStyle>
			  <option value="1"><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></option>
			  <option value="2" selected><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
			  <option value="5"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>
			  <option value="3"><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></option>
			  <option value="4"><%=SystemEnv.getHtmlLabelName(235,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(127,user.getLanguage())%></option>
			  <option value="11"><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></option>
			</SELECT>
		</wea:item>
		
		<wea:item attributes="{'samePair':'browser_td','display':''}"><%=SystemEnv.getHtmlLabelNames("106",user.getLanguage())%></wea:item>
		<wea:item attributes="{'samePair':'browser_td','display':''}">
		
			<span id="showsubcom" style="display:none;">
				<brow:browser viewType="0" name="subcomid" browserValue="" 
						browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp"
						hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='2'
						completeUrl="/data.jsp?type=164" />
			</span>
			<span id="showdepartment" style="display:'';">
				<brow:browser viewType="0" name="deptid" browserValue="" 
						browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp"
						hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='2'
						completeUrl="/data.jsp?type=4"  />
			</span>
			<span id="showrole" style="display:none;">
				<brow:browser viewType="0" name="roleid" browserValue="" 
						browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp"
						hasInput="true" isSingle="true" width="50%" hasBrowser = "true" isMustInput='2'
						completeUrl="/data.jsp?type=65" />
			</span>
			<span id="showrolelevel"   style="display:none;">
						<%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%>
						  <SELECT style="width:60px;" class=InputStyle name=rolelevel>
							<option selected value="0"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
							<option value="1"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>
							<option value="2"><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>
						  </SELECT>
					</span>
			<span id="showresource" style="display:none;">
			   <brow:browser viewType="0" name="resourceid" browserValue="" 
				browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp"
				hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='2'
				completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" />
			</span>
			<span id="showrejob" style="display:none;">
			   <brow:browser viewType="0" name="jobtitleid" browserValue="" 
				browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/MutiJobTitlesBrowser.jsp?"
				hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='2'
				completeUrl="/data.jsp?type=hrmjobtitles" />
			</span>	 	 
				 
				 <INPUT type=hidden name=relatedshareid value="<%=user.getUserDepartment()%>">
		</wea:item>
		<wea:item attributes="{'samePair':'seclevel_td','display':''}"><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></wea:item>
		<wea:item attributes="{'samePair':'seclevel_td','display':''}">
			<wea:required id="seclevelimage" required="true">
				<INPUT class=InputStyle maxLength=3 size=5 name=seclevel onKeyPress="ItemCount_KeyPress()" 
					onBlur='checknumber("seclevel");checkinput("seclevel","seclevelimage")' value="10" style="width: 68px;">
			</wea:required>
				-
			<wea:required id="seclevelMaximage" required="true">
				<INPUT class=InputStyle maxLength=3 size=5 name=seclevelMax onKeyPress="ItemCount_KeyPress()" 
					onBlur='checknumber("seclevelMax");checkinput("seclevelMax","seclevelMaximage")' value="100" style="width: 68px;">
			</wea:required>
		</wea:item>
		<wea:item attributes="{'samePair':'jobtitlescope','display':'none'}"><%=SystemEnv.getHtmlLabelName(28169,user.getLanguage())%></wea:item>
		<wea:item attributes="{'samePair':'jobtitlescope','display':'none'}">
			  <SELECT style="width: 60px;float: left;" class=InputStyle name=joblevel onchange="getScope();">
				<option selected value="0"><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>
				<option value="1"><%=SystemEnv.getHtmlLabelName(19438,user.getLanguage())%>
				<option value="2"><%=SystemEnv.getHtmlLabelName(19437,user.getLanguage())%>
			  </SELECT>
			  <span id="showscopedept" style="display:none;">
			  <brow:browser viewType="0" name="scopedeptid" browserValue="" 
						browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids=#id#&selectedDepartmentIds=#id#"
						hasInput="true" isSingle="false" width="50%" hasBrowser = "true" isMustInput='2'
						completeUrl="/data.jsp?type=4"  />
			  </span>
			  <span id="showscopesub" style="display:none;">
			  <brow:browser viewType="0" name="scopesubcomid" browserValue="" 
						browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp?selectedids=#id#&selectedDepartmentIds=#id#"
						hasInput="true" isSingle="false" width="50%" hasBrowser = "true" isMustInput='2'
						completeUrl="/data.jsp?type=164" />
			  </span>
			  <INPUT type=hidden name=scopeid value="">
		</wea:item>
		
		
		<wea:item><%=SystemEnv.getHtmlLabelName(119,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%></wea:item>
		<wea:item>
			<SELECT name=sharelevel class=InputStyle>
			  <option value="1"><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
			  <option value="2"><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
			</SELECT>
		</wea:item>
		
	</wea:group>
</wea:layout>	
		<!-- 对话框底下的按钮 -->
<%if("1".equals(isDialog)){ %>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout>
	<wea:group context="">
    	<wea:item type="toolbar">
    		<input class="zd_btn_cancle" type="button" name="cancel" onclick="parentWin.closeDialog();"  value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>"/>
    	</wea:item>
    </wea:group>
</wea:layout>
</div>
<script type="text/javascript">
jQuery(document).ready(function(){
	resizeDialog(document);
	checkinput("seclevel","seclevelimage");
  	checkinput("seclevelMax","seclevelMaximage");
});
</script>
<%} %>
	




<script language=javascript>
  function onChangeSharetype(){
	thisvalue = jQuery("select[name=sharetype]").val();
	jQuery("input[name=relatedshareid]").val("");
	//jQuery("#showrelatedsharename").html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");

	if(thisvalue==1){//人力资源
		//TD30060 当安全级别为空时，选择人力资源，赋予安全级别默认值10，否则无法提交保存
		jQuery("#seclevelimage").html("");
		if(jQuery("input[name=seclevel]").val()==""){
			jQuery("input[name=seclevel]").val(10);
		}
		//End TD30060
		hideEle('seclevel_td');
		hideEle('jobtitlescope');
		showEle('browser_td');
		jQuery("span[id=showresource]").show();
		jQuery("span[id=showdepartment]").hide();
		jQuery("span[id=showrole]").hide();
		jQuery("span[id=showsubcom]").hide();
		jQuery("span[id=showrejob]").hide();
		jQuery("span[id=showrolelevel]").hide();
	}else if(thisvalue==4){//所有人
		showEle('seclevel_td');
		hideEle('jobtitlescope');
		hideEle('browser_td');
		jQuery("span[id=showdepartment]").hide();
		jQuery("span[id=showrole]").hide();
		jQuery("span[id=showsubcom]").hide();
		jQuery("span[id=showresource]").hide();
		jQuery("span[id=showrejob]").hide();
		jQuery("span[id=showrolelevel]").hide();
	}else if(thisvalue==2){//部门
		showEle('seclevel_td');
		hideEle('jobtitlescope');
		showEle('browser_td');
		jQuery("span[id=showdepartment]").show();
		jQuery("span[id=showrole]").hide();
		jQuery("span[id=showsubcom]").hide();
		jQuery("span[id=showresource]").hide();
		jQuery("span[id=showrejob]").hide();
		jQuery("span[id=showrolelevel]").hide();
	}else if(thisvalue==5){//分部
		showEle('seclevel_td');
		hideEle('jobtitlescope');
		showEle('browser_td');
		jQuery("span[id=showdepartment]").hide();
		jQuery("span[id=showrole]").hide();
		jQuery("span[id=showsubcom]").show();
		jQuery("span[id=showresource]").hide();
		jQuery("span[id=showrejob]").hide();
		jQuery("span[id=showrolelevel]").hide();
	}else if(thisvalue==3){//角色
		showEle('seclevel_td');
		hideEle('jobtitlescope');
		showEle('browser_td');
		jQuery("span[id=showdepartment]").hide();
		jQuery("span[id=showrole]").show();
		jQuery("span[id=showsubcom]").hide();
		jQuery("span[id=showresource]").hide();
		jQuery("span[id=showrejob]").hide();
		jQuery("span[id=showrolelevel]").show();
	}else if(thisvalue==11){//岗位
		hideEle('seclevel_td');
		showEle('jobtitlescope');
		showEle('browser_td');
		jQuery("span[id=showrejob]").show();
		jQuery("span[id=showdepartment]").hide();
		jQuery("span[id=showrole]").hide();
		jQuery("span[id=showsubcom]").hide();
		jQuery("span[id=showresource]").hide();
		jQuery("span[id=showrolelevel]").hide();
	}
	
	
	//TD30060 切换时，增加对安全级别为空的提示；人力资源没有安全级别
	if(jQuery("input[name=seclevel]").val()=="" && thisvalue!=1){
		jQuery("#seclevelimage").html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
	}
	//End TD30060
}

 function dosubmit(){
	document.weaver.method.value="submit";
	document.weaver.submit();
 }

 //add TD30059 用户没有所属部门，为空！部门选项要显示必填项
 function depisnull(){
 	if (jQuery("input[name=relatedshareid]").val()=="0"||jQuery("input[name=relatedshareid]").val()==""){
	 	var dep = "<%=Util.toScreen(DepartmentComInfo.getDepartmentname(""+user.getUserDepartment()),user.getLanguage())%>";
	 	jQuery("#showrelatedsharename").html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
	 } 	
 }
 //End TD30059
function getScope(){
	thisvalue = jQuery("select[name=joblevel]").val();
	jQuery("input[name=scopeid]").val("");
	if(thisvalue==0){
		jQuery("span[id=showscopesub]").hide();
		jQuery("span[id=showscopedept]").hide();
	}else if(thisvalue==1){
		jQuery("span[id=showscopesub]").hide();
		jQuery("span[id=showscopedept]").show();
	}else if(thisvalue==2){
		jQuery("span[id=showscopesub]").show();
		jQuery("span[id=showscopedept]").hide();
	}
}


 function onSubmit()
{
	 
	 var sharetype=jQuery("select[name=sharetype]").val();
	 switch(sharetype){
	 	case "1":
	 		jQuery("input[name=relatedshareid]").val(jQuery("#resourceid").val());
	 		break;
	 	case "2":
	 		jQuery("input[name=relatedshareid]").val(jQuery("#deptid").val());
	 		break;
	 	case "5":
	 		jQuery("input[name=relatedshareid]").val(jQuery("#subcomid").val());
	 		break;
	 	case "3":
	 		jQuery("input[name=relatedshareid]").val(jQuery("#roleid").val());
	 		break;
	 	case "4":
	 		jQuery("input[name=relatedshareid]").val('');
	 		break;
	 	case "11":
	 		jQuery("input[name=relatedshareid]").val(jQuery("#jobtitleid").val());
	 		var joblevel = jQuery("select[name=joblevel]").val();
	 		if(joblevel==1){
	 			jQuery("input[name=scopeid]").val(jQuery("#scopedeptid").val());
	 		}else if(joblevel==2){
	 			jQuery("input[name=scopeid]").val(jQuery("#scopesubcomid").val());
		 	}
	 		break;
	 	default:
	 		jQuery("input[name=relatedshareid]").val('');
 			break;
	 }
	 
	//add TD30059 当为部门选项时，用户没有所属部门为0，设置为空，阻止submit提交
	if(document.all("relatedshareid").value=="0"&&document.all("sharetype").value=="2"){
		document.all("relatedshareid").value="";
	}
	//End TD30059 
	
	var checkstr="";
	if(sharetype==1){
		checkstr="relatedshareid";
	}else if(sharetype==2){
		checkstr="relatedshareid,seclevel,seclevelMax";
	}else if(sharetype==3){
		checkstr="relatedshareid,seclevel,seclevelMax";
	}else if(sharetype==4){
		checkstr="seclevel,seclevelMax";
	}else if(sharetype==5){
		checkstr="relatedshareid,seclevel,seclevelMax";
	}else if(sharetype==11){
		checkstr="relatedshareid";
		var joblevel1 = jQuery("select[name=joblevel]").val();
		if(joblevel1==1){
			checkstr+=",scopedeptid";
		}else if(joblevel1==2){
			checkstr+=",scopesubcomid";
		}
		
	}
	
	if (check_form(weaver,checkstr)){
		//weaver.submit();
		
		var relateditem='<%=assortid %>'||0;
		var sharelevel=$("select[name=sharelevel]").val()||0;
		var sharetype=$("select[name=sharetype]").val()||0;
		var seclevel=$("input[name=seclevel]").val()||0;
		var seclevelmax=$("input[name=seclevelMax]").val()||100;
		var rolelevel=$("select[name=rolelevel]").val()||0;
		var relatedshareid=$("input[name=relatedshareid]").val()||0;
		var joblevel = $("select[name=joblevel]").val()||0;
		var scopeid=$("input[name=scopeid]").val()||0;
		var poststr=relateditem+"|"+sharelevel+"|"+sharetype+"|"+seclevel+"|"+rolelevel+"|"+relatedshareid+"|"+seclevelmax+"|"+joblevel+"|"+scopeid;
		//console.log("poststr:"+poststr);
		checkshareifexists("CptAssortmentShare",poststr,function(){
			var form=jQuery("#weaver");
			var form_data=form.serialize();
			var form_url=form.attr("action");
			
			//提示
			var diag_tooltip = new window.top.Dialog();
			diag_tooltip.ShowCloseButton=false;
			diag_tooltip.ShowMessageRow=false;
			//diag_tooltip.hideDraghandle = true;
			diag_tooltip.Width = 300;
			diag_tooltip.Height = 50;
			diag_tooltip.InnerHtml="<div style=\"font-size:12px;\" ><%=SystemEnv.getHtmlLabelName(33113,user.getLanguage()) %><br><img style='margin-top:-20px;' src='/images/ecology8/loadingSearch_wev8.gif' /></div>";
			diag_tooltip.show();
			
			jQuery.ajax({
				url : form_url,
				type : "post",
				async : true,
				data : form_data,
				dataType : "html",
				success: function do4Success(msg){
					diag_tooltip.close();
					parentWin._table.reLoad();
					parentWin.closeDialog();
				}
			});
		
		});
			
		
		
		
		
	}
	
}

 function back()
{
	window.history.back(-1);
}
</script>

</BODY>
</HTML>
