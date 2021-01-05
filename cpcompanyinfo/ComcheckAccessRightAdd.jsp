
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />

<%
int comid = Util.getIntValue(request.getParameter("comid"),0);//公司id
//System.out.println("comid==="+comid);
int opertype = Util.getIntValue(request.getParameter("opertype"),1);//1是公司资源管理区后台维护权限|2是公司资源管理区证照维护权限..
//System.out.println("opertype===="+opertype);
int comallright=Util.getIntValue(request.getParameter("comallright"),0);//是否为全局的公司资料模块权限,1是全局的，0不是全局的
//System.out.println("comallright===="+comallright);

%>

<HTML><HEAD>

<script>
var parentDialog = parent.parent.getDialog(parent);
//var parentWin = parent.parent.getParentWindow(parent.window);
var parentWin = parent.getParentWindow(window);
</script>

<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<link href="/cpcompanyinfo/style/Operations_wev8.css" rel="stylesheet"type="text/css" />
<link href="/cpcompanyinfo/style/Public_wev8.css" rel="stylesheet" type="text/css" />
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</HEAD>

<BODY style="overflow:hidden;"> 
<%if(opertype==2){ %>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="task"/>
   <jsp:param name="navName" value='<%=SystemEnv.getHtmlLabelNames("30950",user.getLanguage()) %>'/>
</jsp:include>
<%} %>

<%if(opertype==3){ %>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="task"/>
   <jsp:param name="navName" value='<%=SystemEnv.getHtmlLabelNames("30955",user.getLanguage()) %>'/>
</jsp:include>
<%} %>

<div style="height: 250px;overflow-y: auto;overflow-x: none">
<FORM id=mainform name=mainform  action="/cpcompanyinfo/ComAccessRightManage.jsp" target="iff" method=post >
  <input type="hidden" name="method" value="add">
  <input type="hidden" name="comid" value="<%=comid%>">
  <input type="hidden" name="opertype" value="<%=opertype%>">
  <input type="hidden" name="comallright" value="<%=comallright%>">
  <input type="hidden" name="mutil"  id="mutil"  value="0">
 
 
 <wea:layout>

 	<wea:group context='<%=SystemEnv.getHtmlLabelName(385,user.getLanguage())%>' attributes="">

 
 	<wea:item>
 		<%= SystemEnv.getHtmlLabelName(16815,user.getLanguage())%>
 	</wea:item>
 	<wea:item>
 		 <SELECT class=InputStyle style="width:150px" name=permtype onchange="onChangeSharetype()" >
          <option selected value="1"><%=SystemEnv.getHtmlLabelName(7175,user.getLanguage())%></option>
          <option value="6"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>＋<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></option>
          <option value="2"><%=SystemEnv.getHtmlLabelName(7176,user.getLanguage())%></option>
          <option value="3"><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></option>
          <option value="5"><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></option>
        </SELECT>
 	</wea:item>
 	
 	
 	<wea:item attributes="{'samePair':'showdepartment','display':''}" >
 		<%= SystemEnv.getHtmlLabelName(106,user.getLanguage())%>
 	</wea:item>
 	<wea:item  attributes="{'samePair':'showdepartment','display':''}">
 		<brow:browser viewType="0" name="departmentid" browserValue="" browserSpanValue="" 
				browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp"
				hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2' width="180px"
				completeUrl="/data.jsp?type=4"  />
 	</wea:item>
 	
 	<wea:item attributes="{'samePair':'showsubcompany','display':'none'}" >
 		<%= SystemEnv.getHtmlLabelName(106,user.getLanguage())%>
 	</wea:item>
 	<wea:item  attributes="{'samePair':'showsubcompany','display':'none'}">
 		<brow:browser name="subcompanyid" viewType="0" browserValue="" hasInput="true"
	 		 isSingle="true" hasBrowser = "true" isMustInput='2' completeUrl="/data.jsp?type=164"  width="180px"
	 		 browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp" />
       <INPUT type=hidden name=subcompanyid  id=subcompanyid   value="">
 	</wea:item>
 	
 	<wea:item attributes="{'samePair':'showrole','display':'none'}" >
 		<%= SystemEnv.getHtmlLabelName(106,user.getLanguage())%>
 	</wea:item>
 	<wea:item  attributes="{'samePair':'showrole','display':'none'}">
 		<brow:browser name="roleid" viewType="0" browserValue="" hasInput="true"  width="180px"
	 		 isSingle="true" hasBrowser = "true" isMustInput='2' completeUrl="/data.jsp?type=65"
	 		 browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp" />
        <INPUT type=hidden name=roleid  value=""  id=roleid>
 	</wea:item>
 	
 		<wea:item attributes="{'samePair':'showuser','display':'none'}" >
 		<%= SystemEnv.getHtmlLabelName(106,user.getLanguage())%>
 	</wea:item>
 	<wea:item  attributes="{'samePair':'showuser','display':'none'}">
 		<brow:browser name="userid" viewType="0" browserValue="" hasInput="true"  width="180px"
	 		 isSingle="true" hasBrowser = "true" isMustInput='2' completeUrl="/data.jsp"
	 		 browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp" />
         <INPUT type=hidden name="userid"  id="userid" value="">
 	</wea:item>
 	
       
       <!-- <span id=showrelatedsharename name=showrelatedsharename></span>
        <span id=showusertype name=showusertype style="display:none"> --> 
 	<wea:item attributes="{'samePair':'showrolelevel','display':'none'}">
		<%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%> <!-- 级别 -->
		<span id=showrolelevel name=showrolelevel style="display:none">
	</wea:item>  
	<wea:item attributes="{'samePair':'showrolelevel','display':'none'}">
		<SELECT class=InputStyle style="width:150px" name=rolelevel id=rolelevel >
           <option selected value="0"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
           <option value="1"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>
           <option value="2"><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>
         </SELECT>
	</wea:item>    
 	<wea:item attributes="{'samePair':'showseclevel','display':''}">
 		 <%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%><!-- 安全级别 -->
 	</wea:item>
 	<wea:item attributes="{'samePair':'showseclevel','display':''}"> 
 		<span id=showseclevel name=showseclevel style="display:''">
 		 <INPUT type=text id=seclevel name=seclevel size=6 style="width:75px;" value="0" onblur="checkinput('seclevel','seclevelimage')" onKeyUp="this.value=this.value.replace(/\D/g,'')" onafterpaste="this.value=this.value.replace(/\D/g,'')" onkeydown="if(event.keyCode == 13){doSave();return false;}"  maxlength="3">
 		 &nbsp;&nbsp;-&nbsp;&nbsp;
 		 <INPUT type=text id=seclevel2 name=seclevel2 size=6 style="width:75px;" value="100" onblur="checkinput('seclevel','seclevelimage')" onKeyUp="this.value=this.value.replace(/\D/g,'')" onafterpaste="this.value=this.value.replace(/\D/g,'')" onkeydown="if(event.keyCode == 13){doSave();return false;}"  maxlength="3">
		   <SPAN id=seclevelimage></SPAN>
		 </span>
	</wea:item>  
	
	
	<%if(comallright==0){%>
		<wea:item>
			 <%= SystemEnv.getHtmlLabelName(30948,user.getLanguage())%>
		</wea:item>
		<wea:item>
		
			 <brow:browser name="rid" viewType="0" browserValue="" hasInput="false"  width="180px"
		 		 isSingle="false" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp" 
		 		 browserUrl="/systeminfo/BrowserMain.jsp?url=/cpcompanyinfo/ComMutiSubcompanyBrowser.jsp" />
		</wea:item>
		<%}%>
 	</wea:group>
 </wea:layout>
 
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
    <wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
			<wea:item type="toolbar">
		    	<input type="button" accessKey=2  id=btnclear value="<%="2-"+SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" id="zd_btn_submit" class="zd_btn_submit" onclick="doSave(this);">
		    	<input type="button" accessKey=T  id=btncancel value="<%="T-"+SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="doCancel(this)">
			</wea:item>
		</wea:group>
	</wea:layout>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
</div>
 
<iframe name="iff" id="iff" style="display: none"></iframe>
</FORM>
</div>
<script language=javascript>

function onChangeSharetype(){
	thisvalue = jQuery("select[name=permtype]").val();
	if(thisvalue==1){//部门+安全级别
		jQuery("#seclevelimage").html("");
		if(jQuery("input[name=seclevel]").val()==""){
			jQuery("input[name=seclevel]").val(10);
		}
		hideEle('showrolelevel');//级别
		showEle('showseclevel');//安全级别
		showEle('showdepartment');
		hideEle('showsubcompany');
		hideEle('showrole');
		hideEle('showuser');
		//jQuery("span[id=showdepartment]").show();//部门
		//jQuery("span[id=showsubcompany]").hide();//分部
		//jQuery("span[id=showrole]").hide();//角色
		//jQuery("span[id=showuser]").hide();//用户
	}else if(thisvalue==6){//分部+安全级别
		showEle('showseclevel');
		hideEle('showrolelevel');
		showEle('showsubcompany');
		hideEle('showdepartment');
		hideEle('showrole');
		hideEle('showuser');
	}else if(thisvalue==2){//角色+安全级别+级别
		showEle('showseclevel');
		showEle('showrolelevel');
		showEle('showrole');
		hideEle('showsubcompany');
		hideEle('showuser');
		hideEle('showdepartment');
	}else if(thisvalue==3){//安全级别
		showEle('showseclevel');
		hideEle('showrolelevel');
		hideEle('showdepartment');
		hideEle('showsubcompany');
		hideEle('showuser');
		hideEle('showrole');
	}else if(thisvalue==5){//人力资源
		hideEle('showseclevel');
		hideEle('showrolelevel');
		showEle('showuser');
		hideEle('showrole');
		hideEle('showsubcompany');
		hideEle('showdepartment');
	}
	
	
	//TD30060 切换时，增加对安全级别为空的提示；人力资源没有安全级别
//	if(jQuery("input[name=seclevel]").val()=="" && thisvalue!=1){
//		jQuery("#seclevelimage").html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
	//}
	//End TD30060
}



function doSave() {

	var seclevel = jQuery("#seclevel").val();
	var seclevel2 = jQuery("#seclevel2").val();
	
	if(Number(seclevel) > Number(seclevel2)){
		alert("<%=SystemEnv.getHtmlLabelNames("84065",user.getLanguage())%>");
		return;
	}
	thisvalue = jQuery("select[name=permtype]").val();
	if(thisvalue== 1 ){//部门+安全级别
			var deptid = jQuery("#departmentid").val();
			if(deptid==""){
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("15859",user.getLanguage())%>");
				return;
			}
			var rid = jQuery("#rid").val();
			var o4params ={
				method:"add",
				permtype:thisvalue,
				opertype:<%=opertype%>,
				comid:<%=comid%>,
			 	comallright:<%=comallright%>,
			 	seclevel:jQuery("#seclevel").val(),
			 	seclevel2:jQuery("#seclevel2").val(),
			 	subcompanyid:"",
			 	departmentid:deptid,
			 	roleid:"",
			 	userid:"",
			 	rolelevel:"",
			 	rid:rid,
			 	usertype:""
			 }
		
			 jQuery.post("/cpcompanyinfo/ComAccessRightManage.jsp",o4params,function(data){
				
			 	parentWin.location.reload();
			 	parentDialog.close();
								
			});
		}
		
	if(thisvalue== 6 ){//分部+安全级别
			 var subid = jQuery("#subcompanyid").val();
			 if(subid==""){
			 	window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("15859",user.getLanguage())%>");
			 	return;
			 }
			 var rid = jQuery("#rid").val();
			 var o4params ={
				method:"add",
				permtype:thisvalue,
				opertype:<%=opertype%>,
				comid:<%=comid%>,
			 	comallright:<%=comallright%>,
			 	seclevel:jQuery("#seclevel").val(),
			 	seclevel2:jQuery("#seclevel2").val(),
			 	subcompanyid:subid,
			 	departmentid:"",
			 	roleid:"",
			 	userid:"",
			 	rolelevel:"",
			 	rid:rid,
			 	usertype:""
			 }
		
			 jQuery.post("/cpcompanyinfo/ComAccessRightManage.jsp",o4params,function(data){
			 	parentWin.location.reload();
			 	parentDialog.close();
								
			});
		}
	
	if(thisvalue== 2 ){//角色+安全级别+级别
			 var roleid = jQuery("#roleid").val();
			 if(roleid==""){
			 	window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("15859",user.getLanguage())%>");
			 	return;
			 }			 
			 var rolelevel = $("#rolelevel").find("option:selected").val();
			 var rid = jQuery("#rid").val();
			 var o4params ={
				method:"add",
				permtype:thisvalue,
				opertype:<%=opertype%>,
				comid:<%=comid%>,
			 	comallright:<%=comallright%>,
			 	seclevel:jQuery("#seclevel").val(),
			 	seclevel2:jQuery("#seclevel2").val(),
			 	subcompanyid:"",
			 	departmentid:"",
			 	roleid:roleid,
			 	userid:"",
			 	rolelevel:rolelevel,
			 	rid:rid,
			 	usertype:""
			 }
		
			 jQuery.post("/cpcompanyinfo/ComAccessRightManage.jsp",o4params,function(data){
				
			 	parentWin.location.reload();
			 	parentDialog.close();
								
			});
		}
	
	if(thisvalue== 5 ){//人力资源
			 var userid = jQuery("#userid").val();
			 if(userid==""){
			 	window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("15859",user.getLanguage())%>");
			 	return;
			 }
			 var rid = jQuery("#rid").val();
			 var o4params ={
				method:"add",
				permtype:thisvalue,
				opertype:<%=opertype%>,
				comid:<%=comid%>,
			 	comallright:<%=comallright%>,
			 	seclevel:"",
			 	seclevel2:"",
			 	subcompanyid:"",
			 	departmentid:"",
			 	roleid:"",
			 	userid:userid,
			 	rolelevel:"",
			 	rid:rid,
			 	usertype:""
			 }
		
			 jQuery.post("/cpcompanyinfo/ComAccessRightManage.jsp",o4params,function(data){
			 	parentWin.location.reload();
			 	parentDialog.close();
								
			});
		}
	
	if(thisvalue== 3){//安全级别
	
		//document.mainform.submit();
		 ///cpcompanyinfo/ComAccessRightManage.jsp
		 //comid,comrright,permtype,seclevel,seclevel2,subcomid,depid,roleid,userid,rolelevel,usertype,comallright
		 
		var rid = jQuery("#rid").val();
		 var o4params ={
			method:"add",
			permtype:thisvalue,
			opertype:<%=opertype%>,
			comid:<%=comid%>,
		 	comallright:<%=comallright%>,
		 	seclevel:jQuery("#seclevel").val(),
		 	seclevel2:jQuery("#seclevel2").val(),
		 	subcompanyid:"",
		 	departmentid:"",
		 	roleid:"",
		 	userid:"",
		 	rolelevel:"",
		 	rid:rid,
		 	usertype:""
		 }
		 
		 jQuery.post("/cpcompanyinfo/ComAccessRightManage.jsp",o4params,function(data){
		 	parentWin.location.reload();
		 	parentDialog.close();
							
		}); 
		
	}
}

function doCancel(){
	parentDialog.close();
	//window.close();
}

</script>
</BODY>
		</td>
		</tr>
		</TABLE>
	</td>
	<td></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>
</HTML>
