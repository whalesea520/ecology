
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="javax.servlet.http.HttpServletRequest" %>

<%@ page import="java.text.*" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.User" %>
<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@ page import="weaver.docs.docs.ShareManageDocOperation" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetShare" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />

<%
String ids = Util.null2String(request.getParameter("ids"));
String isclose = Util.null2String(request.getParameter("isclose"));
%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<script  src="/wui/theme/ecology8/weaveredittable/js/WeaverEditTable_wev8.js"></script>
<link rel="stylesheet" href="/wui/theme/ecology8/weaveredittable/css/WeaverEditTable_wev8.css">
<script type="text/javascript">
	var parentWin = parent.parent.getParentWindow(window);
	var parentDialog = parent.parent.getDialog(window);
	<%if(isclose.equals("1")){%>
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("86,25008",user.getLanguage())%>");
		//parentDialog.close();
		//alert(parentDialog);
		parentDialog.closeByHand();
	<%}%>
</script>
</HEAD>
<%
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(2112,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY style="overflow:hidden;">
<div class="zDialog_div_content">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
boolean canEdit = true ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(119,user.getLanguage())+",javascript:doShare(this),_top} " ;
RCMenuHeight += RCMenuHeightStep ;

%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="workflow"/>
   <jsp:param name="navName" value="<%=titlename %>"/>
</jsp:include>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(119,user.getLanguage()) %>" class="e8_btn_top" onclick="doShare(this);">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<FORM id=weaver name=weaver action="AddWorkflowShareOperation.jsp" method=post >
<input type="hidden" name="ids" value="<%=ids%>">
<input type="hidden" name="rownum" value="">

	<wea:layout>
		<wea:group context='<%=SystemEnv.getHtmlLabelName(18645,user.getLanguage())%>'>
			<wea:item><%=SystemEnv.getHtmlLabelName(21956, user.getLanguage())%></wea:item>
						<wea:item>
							<SELECT style="width:100px;" class="InputStyle" name="permissiontype" id="permissiontype" onchange="onChangePermissionType()" style="float:left">
							  <option selected value="1"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
							  <option value="6"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>
							  <option value="3"><%=SystemEnv.getHtmlLabelName(1340,user.getLanguage())%></option>
							  <option value="5"><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></option>
							  <option value="2"><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></option>
							</SELECT>
						</wea:item>
						<wea:item attributes="{'samePair':\"objtr\"}" ><%=SystemEnv.getHtmlLabelName(106, user.getLanguage())%></wea:item>
						<wea:item attributes="{'samePair':\"objtr\"}" >	
							<span id="subidsSP" style="float:left;">
							<brow:browser viewType="0" name="subids" browserValue="" 
							browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?selectedids=" 
							hasInput="true"  isSingle="true" hasBrowser = "true" isMustInput='2'  width="200px"
							completeUrl="/data.jsp?type=164" linkUrl="/hrm/company/HrmSubCompanyDsp.jsp?id=" 
							browserSpanValue=""></brow:browser>
							</span>
							
							<span id="departmentidSP" style="float:left;">
							<brow:browser viewType="0" name="departmentid" browserValue="" 
							browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids=" 
							hasInput="true"  isSingle="true" hasBrowser = "true" isMustInput='2'  width="200px"
							completeUrl="/data.jsp?type=4" linkUrl="/hrm/company/HrmDepartmentDsp.jsp?id=" 
							browserSpanValue=""></brow:browser>
							</span>
							
							<span id="useridSP" style="float:left;">
							<brow:browser viewType="0" name="userid" browserValue="" 
							browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?resourceids=" 
							hasInput="true"  isSingle="true" hasBrowser = "true" isMustInput='2'  width="200px"
							completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" 
							browserSpanValue=""></brow:browser>
							</span>
							
							<span id="roleidSP" style="float:left;">
							<brow:browser viewType="0" name="roleid" browserValue="" 
							browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp" 
							hasInput="true"  isSingle="true" hasBrowser = "true" isMustInput='2'  width="200px"
							completeUrl="/data.jsp?type=65" linkUrl="/hrm/roles/HrmRolesShowEdit.jsp?type=0&id=" 
							browserSpanValue=""></brow:browser>
							</span>
							
							<span id=showrolelevel name=showrolelevel style="float:left;margin-left:10px;display:none;width:120px;">
							  <div style="float:left;margin-top:7px;height:17px;line-height:17px;">&nbsp;&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%>&nbsp;&nbsp;</div>
							  <SELECT class="InputStyle" name="rolelevel" id="rolelevel" style="width:40px !important;">
							    <option selected value="0"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
							    <option value="1"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>
							    <option value="2"><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>
							  </SELECT>
							</span>
						</wea:item>
						<!-- 安全级别 -->
						<wea:item attributes="{'samePair':\"sectr\"}"><%=SystemEnv.getHtmlLabelName(683, user.getLanguage())%></wea:item>
						<wea:item attributes="{'samePair':\"sectr\"}">
							<span id=showseclevel name=showseclevel style="display:''">
								<INPUT class="InputStyle" style="width:50px;" type=text id=seclevel name=seclevel size=6 value="0" onchange="checkinput('seclevel','seclevelimage')">
							    <SPAN id=seclevelimage></SPAN>
							        - <INPUT class="InputStyle" style="width:50px;" type=text id=seclevelMax name=seclevelMax size=6 value="100" onchange="checkinput('seclevelMax','seclevelimage2')">
							    <SPAN id=seclevelimage2></SPAN>
							</span>
						</wea:item>
						<!-- 可查看 -->
						<wea:item><%=SystemEnv.getHtmlLabelName(1380, user.getLanguage())+SystemEnv.getHtmlLabelName(504, user.getLanguage())%></wea:item>
						<wea:item>
							<span id=showiscanread name=showiscanread style="display:''">
								<SELECT class="InputStyle" name="iscanread" id="iscanread" style="width:60px !important;">
							    <option selected value="1"><%=SystemEnv.getHtmlLabelName(20306,user.getLanguage())%>
							    <option value="0"><%=SystemEnv.getHtmlLabelName(82613,user.getLanguage())%>
							  </SELECT>
							</span>
						</wea:item>
	</wea:group>
<!--文档共享条件-->
<wea:group context='<%=SystemEnv.getHtmlLabelName(1279,user.getLanguage())%>'>
	<wea:item type="groupHead">
		<input type="button" class="addbtn" onclick="addRow();" value=""></input>
		<input type="button" class="delbtn" onclick="CheckDel();" value=""></input>
	</wea:item>


     <wea:item attributes="{'isTableList':'true'}">
     	<div id="shareList"></div>
     	<script type="text/javascript">
			var group = null;
			jQuery(document).ready(function(){
				var items=[
					{width:"25%",colname:"<%=SystemEnv.getHtmlLabelNames("21956",user.getLanguage())%>",itemhtml:"<span type='span' name='permissiontypespan'></span><input type='hidden' name='permissiontype'></input>"},
					{width:"20%",colname:"<%=SystemEnv.getHtmlLabelNames("106",user.getLanguage())%>",itemhtml:"<span type='span' name='shareDetail'></span><input type='hidden' name='subids'></input><input type='hidden' name='departmentid'></input><input type='hidden' name='userid'></input><input type='hidden' name='roleid'></input><input type='hidden' name='rolelevel'></input>"},
					{width:"20%",colname:"<%=SystemEnv.getHtmlLabelNames("683",user.getLanguage())%>",itemhtml:"<span type='span' name='showseclevel'></span><input type='hidden' name='seclevel'></input><input type='hidden' name='seclevelMax'></input>"},
					{width:"25%",colname:"<%=SystemEnv.getHtmlLabelNames("1380",user.getLanguage()) + SystemEnv.getHtmlLabelNames("504",user.getLanguage())%>",itemhtml:"<span type='span' name='showiscanread'></span><input type='hidden' name='iscanread'></input>"},
					];
				var option = {
					basictitle:"",
					optionHeadDisplay:"none",
					colItems:items,
					container:"#shareList",
					toolbarshow:false,
					configCheckBox:true,
          			checkBoxItem:{"itemhtml":'<input name="id" class="groupselectbox" type="checkbox" >',width:"10%"}
				};
				group=new WeaverEditTable(option);
				jQuery("#shareList").append(group.getContainer());
				});
		</script>
     </wea:item>
	</wea:group>
</wea:layout>
</form>
</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="parentDialog.closeByHand();">
	   		</wea:item>
		</wea:group>
	</wea:layout>
</div>

<script language=javascript>

function doShare(obj) {
	if(jQuery(".groupselectbox ").length==0){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(31809,user.getLanguage())%>");
		return false ;
	}
    $GetEle("rownum").value=jQuery("#weaverTableRows").val;
    obj.disabled=true;
    weaver.submit();
}

function onChangePermissionType() {
	thisvalue=jQuery("#permissiontype").val();
 	//jQuery($GetEle("sectr")).css("display","");
 	//jQuery($GetEle("secline")).css("display","");
	showEle("sectr");
	showEle("objtr");
 	
	if (thisvalue == 1) {
		jQuery($GetEle("subidsSP")).css("display","none");
		jQuery($GetEle("departmentidSP")).css("display","");
		jQuery($GetEle("useridSP")).css("display","none");
		jQuery($GetEle("roleidSP")).css("display","none");
		jQuery($GetEle("showrolelevel")).css("display","none");
		showEle("sectr");
    }
	else if (thisvalue == 2) {
		jQuery($GetEle("subidsSP")).css("display","none");
		jQuery($GetEle("departmentidSP")).css("display","none");
		jQuery($GetEle("useridSP")).css("display","none");
		jQuery($GetEle("roleidSP")).css("display","");
		jQuery($GetEle("showrolelevel")).css("display","");
		showEle("sectr");
	}
	else if (thisvalue == 3) {
		jQuery($GetEle("subidsSP")).css("display","none");
		jQuery($GetEle("departmentidSP")).css("display","none");
		jQuery($GetEle("useridSP")).css("display","none");
		jQuery($GetEle("roleidSP")).css("display","none");
		jQuery($GetEle("showrolelevel")).css("display","none");
		showEle("sectr");
		hideEle("objtr", true);
	}
	
	else if (thisvalue == 5) {
		jQuery($GetEle("subidsSP")).css("display","none");
		jQuery($GetEle("departmentidSP")).css("display","none");
		jQuery($GetEle("useridSP")).css("display","");
		jQuery($GetEle("roleidSP")).css("display","none");
		jQuery($GetEle("showrolelevel")).css("display","none");
		hideEle("sectr", true);
	}
	else if (thisvalue == 6) {
		jQuery($GetEle("subidsSP")).css("display","");
		jQuery($GetEle("departmentidSP")).css("display","none");
		jQuery($GetEle("useridSP")).css("display","none");
		jQuery($GetEle("roleidSP")).css("display","none");
		jQuery($GetEle("showrolelevel")).css("display","none");
		showEle("sectr");
	}
}

jQuery(document).ready(function(){
	onChangePermissionType();
});


function check_by_permissiontype() {
    var re=/^\d+$/;
    var thisvalue=jQuery("#permissiontype").val();
    var seclevel = jQuery("#seclevel").val();
    var seclevelMax = jQuery("#seclevelMax").val();
    if (thisvalue == 1) {
        if(!re.test(seclevel) || !re.test(seclevelMax) || parseInt(seclevel)>parseInt(seclevelMax))  {
            Dialog.alert("<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(2245,user.getLanguage())%>")
            return false;
        }
        return check_form(weaver, "departmentid, seclevel, seclevelMax")
    } else if (thisvalue == 2) {
    	 if(!re.test(seclevel) || !re.test(seclevelMax) || parseInt(seclevel)>parseInt(seclevelMax))  {
            Dialog.alert("<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(2245,user.getLanguage())%>")
            return false;
        }
        return check_form(weaver, "roleid, rolelevel, seclevel, seclevelMax");
    } else if (thisvalue == 3) {
        if(!re.test(seclevel) || !re.test(seclevelMax) || parseInt(seclevel)>parseInt(seclevelMax))  {
            Dialog.alert("<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(2245,user.getLanguage())%>")
            return false;
        }
        return check_form(weaver, "seclevel, seclevelMax");
    } else if (thisvalue == 5) {
        return check_form(weaver, "userid");
    } else if (thisvalue == 6) {
        if(!re.test(seclevel) || !re.test(seclevelMax) || parseInt(seclevel)>parseInt(seclevelMax))  {
            Dialog.alert("<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(2245,user.getLanguage())%>")
            return false;
        }
        return check_form(weaver, "subids, seclevel, seclevelMax")
    } else {
        return false;
    }
}


var curindex=0;
function addRow(){
    if(!check_by_permissiontype()){
        return ;
    }
    
    var shareDetail = "";//对象
    var subids = "";//分部
    var departmentid = "";//部门
    var userid = "";//人力资源
    var roleid = "";//角色
    var rolelevel = "";//角色级别
    var showseclevel = "";//安全级别
    var seclevel = "";//min
    var seclevelMax = "";//max
    var showiscanread = "";//流转意见
    var iscanread = "";//是否可查看
    
    var permissiontype = jQuery("#permissiontype").val();//对象类型
    if(permissiontype == "1"){//部门
    	shareDetail = jQuery("#departmentidspan").text();
		departmentid = jQuery("#departmentid").val();
		seclevel = jQuery("#seclevel").val();
		seclevelMax = jQuery("#seclevelMax").val();
		showseclevel = seclevel + "-" + seclevelMax;
		showiscanread = jQuery("#iscanread option:selected").text();
		iscanread = jQuery("#iscanread").val();
	    if(shareDetail != ""){
	    	shareDetail = shareDetail.substring(0, shareDetail.length-1);
	    }
    }else if(permissiontype == "2"){//角色
    	shareDetail = jQuery("#roleidspan").text();
        if(shareDetail != ""){
        	shareDetail = shareDetail.substring(0, shareDetail.length-1) +"/"+jQuery("#rolelevel option:selected").text();
        }
    	roleid = jQuery("#roleid").val();
    	rolelevel = jQuery("#rolelevel").val();
    	seclevel = jQuery("#seclevel").val();
		seclevelMax = jQuery("#seclevelMax").val();
		showseclevel = seclevel + "-" + seclevelMax;
		showiscanread = jQuery("#iscanread option:selected").text();
		iscanread = jQuery("#iscanread").val();
    }else if(permissiontype == "3"){//所有人
    	seclevel = jQuery("#seclevel").val();
		seclevelMax = jQuery("#seclevelMax").val();
		showseclevel = seclevel + "-" + seclevelMax;
		showiscanread = jQuery("#iscanread option:selected").text();
		iscanread = jQuery("#iscanread").val();
    }else if(permissiontype == "5"){//人力资源
    	shareDetail = jQuery("#useridspan").text();
    	userid = jQuery("#userid").val();
    	showiscanread = jQuery("#iscanread option:selected").text();
		iscanread = jQuery("#iscanread").val();
	    if(shareDetail != ""){
	    	shareDetail = shareDetail.substring(0, shareDetail.length-1);
	    }
    }else if(permissiontype == "6"){//分部
    	shareDetail = jQuery("#subidsspan").text();
    	subids = jQuery("#subids").val();
    	seclevel = jQuery("#seclevel").val();
		seclevelMax = jQuery("#seclevelMax").val();
		showseclevel = seclevel + "-" + seclevelMax;
		showiscanread = jQuery("#iscanread option:selected").text();
		iscanread = jQuery("#iscanread").val();
	    if(shareDetail != ""){
	    	shareDetail = shareDetail.substring(0, shareDetail.length-1);
	    }
    }
    
    var jsonArr = [
		{name:"permissiontypespan",type:"span",value:$GetEle("permissiontype").options[$GetEle("permissiontype").selectedIndex].text,"iseditable":true},
		{name:"permissiontype",type:"input",value:permissiontype,"iseditable":true},
		{name:"shareDetail",type:"span",value:shareDetail,"iseditable":true},
		{name:"subids",type:"input",value:subids,"iseditable":true},
		{name:"departmentid",type:"input",value:departmentid,"iseditable":true},
		{name:"userid",type:"input",value:userid,"iseditable":true},
		{name:"roleid",type:"input",value:roleid,"iseditable":true},
		{name:"rolelevel",type:"input",value:rolelevel,"iseditable":true},
		{name:"showseclevel",type:"span",value:showseclevel,"iseditable":true},
		{name:"seclevel",type:"input",value:seclevel,"iseditable":true},
		{name:"seclevelMax",type:"input",value:seclevelMax,"iseditable":true},
		{name:"showiscanread",type:"span",value:showiscanread,"iseditable":true},
		{name:"iscanread",type:"input",value:iscanread,"iseditable":true},
	];
	group.addRow(jsonArr);
    
}
function CheckDel(){
	group.deleteRows();
}
</script>
</BODY>
</HTML>
