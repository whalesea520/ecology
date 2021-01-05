
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
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);//0:非政务系统，1：政务系统
String docsubject= "" ;
String sharedocids = Util.null2String(request.getParameter("sharedocids"));
String isclose = Util.null2String(request.getParameter("isclose"));

String sharingsessionkey = "sqlsharing_" + user.getLoginid() ;	
String sharingsessionkey2 = "2sqlsharing_" + user.getLoginid() ;	
String sqlwhere=Util.null2String((String)session.getAttribute(sharingsessionkey));
session.setAttribute(sharingsessionkey2,sqlwhere);
%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<script  src="/wui/theme/ecology8/weaveredittable/js/WeaverEditTable_wev8.js"></script>
<link rel="stylesheet" href="/wui/theme/ecology8/weaveredittable/css/WeaverEditTable_wev8.css">
<script type="text/javascript">
	var parentWin = parent.parent.getParentWindow(parent);
	var parentDialog = parent.parent.getDialog(parent);
	<%if(isclose.equals("1")){%>
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("17744,25008",user.getLanguage())%>");
		parentDialog.close();
	<%}%>
	function getBrowserUrlFn(){
		var type=jQuery("#sharetype").val();
		var url = "";
		if(type=="1"){
			url = "/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp";
		}else if(type=="2"){
			url = "/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp";
		}else if(type=="3"){
			url = "/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp";
		}else if(type=="4"){
			url = "/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp";
		}else if(type=="6"){
			url="/systeminfo/BrowserMain.jsp?url=/hrm/orggroup/HrmOrgGroupBrowser.jsp";
		}
		if(thisvalue==10){
		  url= "/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/MutiJobTitlesBrowser.jsp?selectedids="+jQuery("#relatedshareid").val();
	    }
		return url;
	}
</script>
</HEAD>
<%
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(17220,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(2112,user.getLanguage());
String needfav ="1";
String needhelp ="";
docsubject = Util.toScreen(docsubject,user.getLanguage(),"0");
String urlType = Util.null2String(request.getParameter("urlType"));
%>
<BODY style="overflow:hidden;">
<div class="zDialog_div_content">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
boolean canEdit = true ;
	/*if has Seccateory edit right, or has approve right(canapprove=1), or user is the document creater can edit documetn right.*/
/*if(HrmUserVarify.checkUserRight("DocSecCategoryEdit:Edit",user)||canapprove==1||user.getUID()==doccreaterid){
	canEdit = true;
    RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:doSave(),_top} " ;
    RCMenuHeight += RCMenuHeightStep ;
}
*/
if(sharedocids.equals("shareentire")){
RCMenu += "{"+SystemEnv.getHtmlLabelName(2191,user.getLanguage())+",javascript:doShareEntir(this),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
}else{
RCMenu += "{"+SystemEnv.getHtmlLabelName(urlType.equals("13")?119:2191,user.getLanguage())+",javascript:doShare(this),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<%if(sharedocids.equals("shareentire")){ %>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(2191,user.getLanguage()) %>" class="e8_btn_top" onclick="doShareEntir(this);">
			<%}else{ %>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(urlType.equals("13")?119:2191,user.getLanguage()) %>" class="e8_btn_top" onclick="doShare(this);">
			<%} %>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<FORM id=weaver name=weaver action="ShareManageDocOperation.jsp" method=post >
<input type="hidden" name="sharedocids" value="<%=sharedocids%>">
<input type="hidden" name="rownum" value="">
<input type="hidden" name="urlType" value="<%=urlType %>"/>
<%
    String isdisable = "";
    if(!canEdit) isdisable ="disabled";
%>
	<wea:layout>
		<wea:group context='<%=SystemEnv.getHtmlLabelName(2112,user.getLanguage())%>'>
			<wea:item>
			 <%=SystemEnv.getHtmlLabelName(21956,user.getLanguage())%>
		  </wea:item>
	 <%
                String ordisplay="";
                if(!canEdit) ordisplay = " style='display:none' ";
                %> 
          <wea:item>
          <span >
          	 <SELECT class=InputStyle id="sharetype" style="width:100px;"  name=sharetype onchange="onChangeSharetype()" <%=isdisable%>>
			  <option value="1"><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></option>
			  <option value="2"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>
			  <option value="3" selected><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
			  <option value="10"><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></option>
			  <option value="6"><%=SystemEnv.getHtmlLabelName(24002,user.getLanguage())%></option>
			  <option value="4"><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></option>
			  <option value="5"><%=SystemEnv.getHtmlLabelName(235,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(127,user.getLanguage())%></option>
              <%if(isgoveproj==0){%>
			  <option value="-1"><%=SystemEnv.getHtmlLabelName(1282,user.getLanguage())%></option>
			  <%}%>
			</SELECT>
			</span>
			
		
			
			

		  </wea:item >
		  <wea:item attributes="{'samePair':'objid'}" ><%=SystemEnv.getHtmlLabelName(106,user.getLanguage())%></wea:item>
		  <wea:item attributes="{'samePair':'objid'}">
		  <span id="browserBtn">
			<brow:browser width="170px" hasInput="true" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp" completeUrl="javascript:getAutocompleteUrl();" name="relatedshareid" viewType="0" getBrowserUrlFn="getBrowserUrlFn" isMustInput="2"  isSingle="false"></brow:browser>
			</span>
		     <span id="showcustype" name="showcustype" style="display:none">
				
					<SELECT  name="custype" id="custype" onchange="setRelate();">
						<%
					if(isgoveproj==0){
					while(CustomerTypeComInfo.next()){
									String curid=CustomerTypeComInfo.getCustomerTypeid();
									String curname=CustomerTypeComInfo.getCustomerTypename();
									String optionvalue="-"+curid;
					%>
					<option value="<%=optionvalue%>"><%=curname%></option>
					<%}
					}
					%>
				    </SELECT>
					
				</span>

				<span id="showincludesub" name="showincludesub" >
					  <input class='InputStyle' type='checkbox' name='includesub' id='includesub' value='' ><%=SystemEnv.getHtmlLabelName(33864,user.getLanguage())+SystemEnv.getHtmlLabelName(27170,user.getLanguage())%>
					
				</span>
				 <span id="showrolelevelname" name="showrolelevelname" style="display:none;">
				 <%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%>
				 </span>
		      <span id="showrolelevel" name="showrolelevel" style="display:none;">
					
				
					<SELECT  name=rolelevel style="align:right">
					<option value="0" selected><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
					<option value="1"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>
					<option value="2"><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>
				    </SELECT>
					
					
				</span>

			
		  </wea:item>
		  <wea:item attributes="{'samePair':'showsec'}">
		   <%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>
		  </wea:item>
		  <wea:item attributes="{'samePair':'showsec'}">
		
			 <span id="showseclevel" name="showseclevel" style="">
			<INPUT style="width:50px" type=text name=seclevel id=seclevel class=InputStyle size=6 value="10" onchange='checkinput("seclevel","seclevelimage")' <%=isdisable%>><SPAN id=seclevelimage></SPAN>-<INPUT style="width:50px" type=text name=seclevelmax id=seclevelmax class=InputStyle size=6 value="100" onchange='checkinput("seclevelmax","seclevelmaximage")' <%=isdisable%>>
			</span>
			
			<SPAN id=seclevelmaximage></SPAN>
		  </wea:item>

		  <wea:item  attributes="{'samePair':'_joblevel','itemAreaDisplay':'none','display':'none'}"><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%></wea:item>
<wea:item attributes="{'samePair':'_joblevel','itemAreaDisplay':'none','display':'none'}">
        <SELECT name=joblevel id=joblevel align="left" style="float:left" onchange="checkjoblevel()">
          <option value="1" selected><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%></option>
          <option value="2"><%=SystemEnv.getHtmlLabelName(19437,user.getLanguage())%></option>
          <option value="3"><%=SystemEnv.getHtmlLabelName(19438,user.getLanguage())%></option>
        </SELECT>
		<span id=jobsubcompanysapn style="display:none">
			<brow:browser viewType="0" name="jobsubcompany" browserValue="" 
          browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/company/SubcompanyBrowser.jsp?isedit=1&rightStr=HrmResourceAdd:Add"
          hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2' width="220px"  
          completeUrl="/data.jsp?type=164">
          </brow:browser>
         </span>
		
		  <brow:browser viewType="0" name="jobdepartment" browserValue="" 
          browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/company/DepartmentBrowser.jsp?excludeid=1"
          hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2' width="220px"
          completeUrl="/data.jsp?type=4"  display="none">
          </brow:browser>
		
</wea:item>

		  
          <wea:item>
			<%=SystemEnv.getHtmlLabelName(385,user.getLanguage())%>
		  </wea:item>
          <wea:item>
			<SELECT class=InputStyle id=sharelevel <%=isdisable%>  name=sharelevel <%=isdisable%>  onchange="onOptionChange('sharelevel')">
			  <option value="1"><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
			  <option value="2"><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
              <option value="3"><%=SystemEnv.getHtmlLabelName(17874,user.getLanguage())%>
            </SELECT>
		  	<input class='InputStyle' type='checkbox' name='chksharelevel' checked id='chksharelevel' style="display:''" onclick="setCheckbox(chksharelevel)" value="1">
          	<label for='lblsharelevel' id='lblsharelevel' style="display:''"><%=SystemEnv.getHtmlLabelName(23733,user.getLanguage())%></label>
		  </wea:item>
	</wea:group>
<!--文档共享条件-->
<wea:group context='<%=SystemEnv.getHtmlLabelName(1279,user.getLanguage())%>'>
	<wea:item type="groupHead">
		<input type="button" class="addbtn" onclick="addRow();" value=""></input>
		<input type="button" class="delbtn" onclick="CheckDel();" value=""></input>
	</wea:item>
	<%if(!urlType.equals("13")){ %>
		<wea:item attributes="{'colspan':'full'}">
			<div align="right">
			<span ><input name="defaultshare" type="checkbox" value="" onclick="setCheck(this)"/><%=SystemEnv.getHtmlLabelName(31805,user.getLanguage())%></span>
		    <span ><input name="nondefaultshare" type="checkbox" value="" onclick="setCheck(this)"/><%=SystemEnv.getHtmlLabelName(31806,user.getLanguage())%></span>
			<span ><input name="otherversion" type="checkbox" value="1"><%=SystemEnv.getHtmlLabelName(32764,user.getLanguage())%></span>
			</div>
		 </wea:item>
	<%} %>

     <wea:item attributes="{'isTableList':'true'}">
     	<div id="shareList"></div>
     	<script type="text/javascript">
			var group = null;
			jQuery(document).ready(function(){
				var items=[
					{width:"20%",colname:"<%=SystemEnv.getHtmlLabelNames("21956",user.getLanguage())%>",itemhtml:"<span type='span' name='shareTypespan'></span><input type='hidden' name='sharetype'></input>"},
					{width:"30%",colname:"<%=SystemEnv.getHtmlLabelNames("106",user.getLanguage())%>",itemhtml:"<span type='span' name='shareDetail'></span><input type='hidden' name='relatedshareid'></input></input><input type='hidden' name='rolelevel'></input><input type='hidden' name='includesub'><input type='hidden' name='joblevel'><input type='hidden' name='jobdepartment'><input type='hidden' name='jobsubcompany'></input><input type='hidden' name='custype'></input>"},
				    {width:"20%",colname:"<%=SystemEnv.getHtmlLabelNames("683",user.getLanguage())%>",itemhtml:"<span type='span' name='seclevelDetail'></span><input type='hidden' name='seclevel'></input><input type='hidden' name='seclevelmax'></input>"},
					{width:"15%",colname:"<%=SystemEnv.getHtmlLabelNames("385",user.getLanguage())%>",itemhtml:"<span type='span' name='sharelevelDetail'></span><input type='hidden' name='sharelevel'></input>"},
					{width:"15%",colname:"<%=SystemEnv.getHtmlLabelNames("32070",user.getLanguage())%>",itemhtml:"<span type='span' name='downloadlevelDetail'></span><input type='hidden' name='downloadlevel'></input>"}
					];
				var option = {
					basictitle:"",
					optionHeadDisplay:"none",
					colItems:items,
					container:"#shareList",
					toolbarshow:false,
					configCheckBox:true,
          			checkBoxItem:{"itemhtml":'<input name="mouldId" class="groupselectbox" type="checkbox" >',width:"5%"}
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
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
			jQuery("#showcustype").hide();
			jQuery("#showrolelevel").hide();
			jQuery("#showrolelevelname").hide();
		});
	</script>
<script language=javascript>


function getAutocompleteUrl(){
	var url = "/data.jsp?type=";
	var sharetype = parseInt(jQuery("#sharetype").val());
	if(sharetype==1){
		url += "1";
	}else if(sharetype==2){
		url+="164";
	}else if(sharetype==3){
		url+="4";
	}else if(sharetype==4){
		url+="65";
	}else if(sharetype==6){
		url+="hrmOrgGroup";
	}else if(thisvalue==10){
  		url+="24";
	}else{
		return "";
	}
	return url;
}
</script>
<script language=javascript>
 var diag_vote = new Dialog();
			diag_vote.Width = 300;
			diag_vote.Height = 100;
			diag_vote.Modal = false;
			diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(20240,user.getLanguage())%>";
			diag_vote.URL = "/docs/docs/ShareProcess.jsp";
			



function setCheck(a){
	
if(a.checked){

 a.value="1";

}else{
 a.value="";
}

}
function doShare(obj) {
	if(jQuery(".groupselectbox ").length==0){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(31809,user.getLanguage())%>");
		return false ;
	
	}
    $GetEle("rownum").value=jQuery("#weaverTableRows").val();
    obj.disabled=true;
    weaver.submit();
}
function doShareEntir(obj) {
	
	 

	if(jQuery(".groupselectbox ").length==0){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(31809,user.getLanguage())%>");
		return false ;
	
	}

	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(31810,user.getLanguage())%>",function(){	 
	 $GetEle("rownum").value=jQuery("#weaverTableRows").val();
	 
	   obj.disabled=true;
	     //diag_vote.show();
		 onListen();
	 
      });

} 
            
function onListen(){
			 	
			 	$.ajax({ cache:true,type: "POST",url:"ShareProcess2.jsp",
			 	data:$('#weaver').serialize(),// 你的formid              
			 	async: true,  
			 	beforeSend:function(){
					e8showAjaxTips("<%=SystemEnv.getHtmlLabelName(33592,user.getLanguage())%>",true);
				},
				complete:function(){
					e8showAjaxTips("",false);
				},      
			  error: function(request) {  
				//diag_vote.close();
			  	top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(31825,user.getLanguage())%>");              
			  	             
			  	     },              
			  success: function(data) {                
			  	  //diag_vote.close();
			  	  top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(31439,user.getLanguage())%>");
				  //window.location="/docs/search/DocSearchSharing.jsp?from=shareManageDoc";			  				  	   
	          	 parentDialog.close();
			         }          
			         
			     });
			   }


</script>
<script language="JavaScript" src="/js/addRowBg_wev8.js"></script>
<script language="javascript">
//===== 文档下载权限控制  开始========//
function onOptionChange(selObjName) {
    var selObj = document.getElementById(selObjName);//选择控件对象
	var oVal = selObj.options[selObj.selectedIndex].value;//选中值
	var chkObj = document.getElementById('chk'+selObjName);//复选框控件对象
    var lblObj = document.getElementById('lbl'+selObjName);//复选框控件对应标签对象
	if(oVal == 1) {//查看时显示	
		//chkObj.style.display = '';
		toggleBeautyCheckbox(chkObj,'');
		lblObj.style.display = '';
	} else {
		//chkObj.style.display = 'none';
		toggleBeautyCheckbox(chkObj,'none');
		lblObj.style.display = 'none';
	}
}
function setCheckbox(chkObj) {
	if(chkObj.checked == true) {
		chkObj.value = 1;
	} else {
		chkObj.value = 0;
	}
}
//===== 文档下载权限控制  结束========//
function setRelate() {
	relatedshareidspan.innerHTML =jQuery("#custype").find("option:selected").text();  
    document.weaver.relatedshareid.value=jQuery("#custype").find("option:selected").val();
}
	
  function onChangeSharetype(){
	thisvalue=document.weaver.sharetype.value;
		document.weaver.relatedshareid.value="";

	showEle("showsec");
	showEle("objid");
	jQuery("#showcustype").hide();
     hideEle("_joblevel");
	relatedshareidspanimg.innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	jQuery("#relatedshareidspan").html("");

	 if(thisvalue!=2||thisvalue!=3){
		jQuery("#showincludesub").hide();
    }
	if(thisvalue==1){
		hideEle("showsec");
		
		jQuery("#browserBtn").show();
		
	}
	if(thisvalue==2){
		jQuery("#showincludesub").show();
		jQuery("#browserBtn").show();
 		document.weaver.seclevel.value=10;
		document.weaver.seclevelmax.value=100;
	}
	else{
		document.weaver.seclevel.value=10;
		document.weaver.seclevelmax.value=100;
	}
	if(thisvalue==3){
		jQuery("#showincludesub").show();
		jQuery("#browserBtn").show();
 		document.weaver.seclevel.value=10;
		document.weaver.seclevelmax.value=100;
	}
	else{
		document.weaver.seclevel.value=10;
		document.weaver.seclevelmax.value=100;
	}
	 if(thisvalue==10){
		  hideEle("showsec");
		 $GetEle("seclevel").value=0;	
		  jQuery("#browserBtnn").show();
		 showEle("_joblevel");
	}
	if(thisvalue==4){
		jQuery("#browserBtn").show();
		jQuery("#showrolelevel").show();
		jQuery("#showrolelevelname").show();
		document.weaver.seclevel.value=10;
		document.weaver.seclevelmax.value=100;
	}
	else{
			jQuery("#showrolelevel").hide();
			jQuery("#showrolelevelname").hide();
		document.weaver.seclevel.value=10;
		document.weaver.seclevelmax.value=100;
    }
	if(thisvalue==5){
        hideEle("objid");
		relatedshareidspan.innerHTML = ""
		jQuery("#browserBtn").hide();
		document.weaver.relatedshareid.value=-1;
		document.weaver.seclevel.value=10;
		document.weaver.seclevelmax.value=100;
	}
	//TD18757
	if(thisvalue==6){
		jQuery("#browserBtn").show();
 		document.weaver.seclevel.value=10;
		document.weaver.seclevelmax.value=100;
		
	}
	else{
		document.weaver.seclevel.value=10;
		document.weaver.seclevelmax.value=100;
	}
	if(thisvalue<0){
		  
		
	  relatedshareidspan.innerHTML =jQuery("#custype").find("option:selected").text();  
      document.weaver.relatedshareid.value=jQuery("#custype").find("option:selected").val();
	
		jQuery("#browserBtn").hide();
		jQuery("#showcustype").show();
		document.weaver.seclevel.value=0;
		document.weaver.seclevelmax.value=100;
	}
}

function checkjoblevel(){

       if(jQuery("#joblevel  option:selected").val()=="2"){
		    jQuery("#jobsubcompanysapn").css("display","");
		   jQuery("#jobdepartment").closest("div.e8_os").css("display","none");
		}else if(jQuery("#joblevel  option:selected").val()=="3"){
		  jQuery("#jobsubcompanysapn").css("display","none");
		   jQuery("#jobdepartment").closest("div.e8_os").css("display","");
		}else{
		    jQuery("#jobsubcompanysapn").css("display","none");
		   jQuery("#jobdepartment").closest("div.e8_os").css("display","none");
		}
}

function checkValid(){
    if(($GetEle("seclevel").value==""&&$GetEle("showseclevel").style.display!="none")||($GetEle("seclevelmax").value==""&&$GetEle("seclevelmax").style.display!="none")){
        top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(23251,user.getLanguage())%>");
        return false;
    }
    if($("#relatedshareid").val()==""){
        top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(23252,user.getLanguage())%>");
        return false;
    }
	thisvalue=document.weaver.sharetype.value;
	if(thisvalue==10){

			if($GetEle("joblevel").value=="2"){
        
				 if ($GetEle("jobsubcompany").value==""){
                  top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(125704,user.getLanguage())%>");
                   return false;
				 }
			}else if($GetEle("joblevel").value=="3"){
				 if ($GetEle("jobdepartment").value==""){
                  top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83324,user.getLanguage())%>");
                   return false;
				 }
			}
    }
	
    return true;
}

var curindex=0;
function addRow(){
	  var seclevelmain = jQuery("#seclevel").val();
	  var seclevelmax = jQuery("#seclevelmax").val();
	  if(parseInt(seclevelmain)>parseInt(seclevelmax)){
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(82808,user.getLanguage())%>");
			    return;
	   }
    if(!checkValid()){
        return ;
    }
	var sharetype = parseInt(jQuery("#sharetype").val());	
    var shareDetail = jQuery("#relatedshareidspan").text();
	if(sharetype!=5&&sharetype!=-1){	
	var setvalue=jQuery("#relatedshareidspan").text();
	  setvalue=setvalue.substr(0,setvalue.length-1);
	  shareDetail=setvalue;
	}
	var includesub=0;
	var seclevelDetail = $GetEle("seclevel").value+"-"+$GetEle("seclevelmax").value;
	var sharelevelDetail = $GetEle("sharelevel").options[$GetEle("sharelevel").selectedIndex].text;	
	var downloadlevelDetail = "";
	if($GetEle("sharelevel").value==1){
	if($GetEle("chksharelevel").value=="1"){
	      downloadlevelDetail= " <%=SystemEnv.getHtmlLabelName(23733,user.getLanguage())%>";
	}else{
	     downloadlevelDetail= " <%=SystemEnv.getHtmlLabelName(23734,user.getLanguage())%>";
	   }
	}
    
   if(sharetype==4){
   
        shareDetail += "/"+$GetEle("rolelevel").options[$GetEle("rolelevel").selectedIndex].text;
    
   }
   if(sharetype==1){
        seclevelDetail ="";
		
   }
    if(sharetype==10){
        seclevelDetail ="";
		if($GetEle("joblevel").value=="1"){
        shareDetail += "/<%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>";
		}else if($GetEle("joblevel").value=="2"){
			var jobsharevalue=jQuery("#jobsubcompanyspan").text();
			 jobsharevalue=jobsharevalue.substr(0,jobsharevalue.length-1);
		     shareDetail += "/<%=SystemEnv.getHtmlLabelName(19437,user.getLanguage())%>("+jobsharevalue+")";
		}else if($GetEle("joblevel").value=="3"){
			var jobsharevalue=jQuery("#jobdepartmentspan").text();
			 jobsharevalue=jobsharevalue.substr(0,jobsharevalue.length-1);
		     shareDetail += "/<%=SystemEnv.getHtmlLabelName(19438,user.getLanguage())%>("+jobsharevalue+")";
		}
   }
     if (sharetype==2||sharetype==3){
		
	    if(jQuery("#includesub").attr("checked")){
	       includesub=1;
			  shareDetail +="(<%=SystemEnv.getHtmlLabelName(33864,user.getLanguage())+SystemEnv.getHtmlLabelName(27170,user.getLanguage())%>)";
	      }else{
		  includesub=0;
		     shareDetail +="(<%=SystemEnv.getHtmlLabelName(233,user.getLanguage())+SystemEnv.getHtmlLabelName(33864,user.getLanguage())+SystemEnv.getHtmlLabelName(27170,user.getLanguage())%>)";
		  }
		
   }

   
	
    var jsonArr = [
		{name:"shareTypespan",type:"span",value:$GetEle("sharetype").options[$GetEle("sharetype").selectedIndex].text,"iseditable":true},
		{name:"sharetype",type:"input",value:$GetEle("sharetype").value,"iseditable":true},
		{name:"shareDetail",type:"span",value:shareDetail,"iseditable":true},
		{name:"seclevelDetail",type:"span",value:seclevelDetail,"iseditable":true},
		{name:"sharelevelDetail",type:"span",value:sharelevelDetail,"iseditable":true},
		{name:"downloadlevelDetail",type:"span",value:downloadlevelDetail,"iseditable":true},
		{name:"relatedshareid",type:"input",value:jQuery("#relatedshareid").val(),"iseditable":true},
		{name:"rolelevel",type:"input",value:$GetEle("rolelevel").value,"iseditable":true},
		{name:"seclevel",type:"input",value:$GetEle("seclevel").value,"iseditable":true},
		{name:"seclevelmax",type:"input",value:$GetEle("seclevelmax").value,"iseditable":true},
		{name:"includesub",type:"input",value:includesub,"iseditable":true},
		{name:"joblevel",type:"input",value:$GetEle("joblevel").value,"iseditable":true},
		{name:"jobdepartment",type:"input",value:$GetEle("jobdepartment").value,"iseditable":true},
        {name:"jobsubcompany",type:"input",value:$GetEle("jobsubcompany").value,"iseditable":true},
		{name:"custype",type:"input",value:includesub,"iseditable":true},
		{name:"downloadlevel",type:"input",value:$GetEle("chksharelevel").value,"iseditable":true},
		{name:"sharelevel",type:"input",value:$GetEle("sharelevel").value,"iseditable":true}
	];
	group.addRow(jsonArr);
}
function CheckDel(){
	group.deleteRows();
}
</script>

<script type="text/javascript"> 
	function onShowDepartment(spanname,inputname){
	    linkurl="/hrm/company/HrmDepartmentDsp.jsp?id="
		datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp")
		if (datas) {
		    if (datas.id!= "") {
		        ids = datas.id.split(",");
			    names =datas.name.split(",");
			    sHtml = "";
			    for( var i=0;i<ids.length;i++){
				    if(ids[i]!=""){
				    	sHtml = sHtml+names[i]+"&nbsp";
				    }
			    }
			    $("#"+spanname).html(sHtml);
			    $("input[name="+inputname+"]").val(datas.id);
		    }
		    else	{
	    	     $("#"+spanname).html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
			    $("input[name="+inputname+"]").val("");
		    }
		}
	}
	
	
	function onShowSubcompany(spanname,inputname){
	    linkurl="/hrm/company/HrmSubCompanyDsp.jsp?id="
	    datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp")
		if (datas) {
		    if (datas.id!= "") {
		        ids = datas.id.split(",");
			    names =datas.name.split(",");
			    sHtml = "";
			    for( var i=0;i<ids.length;i++){
				    if(ids[i]!=""){
				    	sHtml = sHtml+names[i]+"&nbsp";
				    }
			    }
			    $("#"+spanname).html(sHtml);
			    $("input[name="+inputname+"]").val(datas.id);
		    }
		    else	{
	    	     $("#"+spanname).html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
			    $("input[name="+inputname+"]").val("");
		    }
		}
	}
	
	function onShowResource(spanname,inputname){
	    linkurl="javaScript:openhrm(";
		var iTop = (window.screen.availHeight-30-550)/2+"px"; //获得窗口的垂直位置;
		var iLeft = (window.screen.availWidth-10-550)/2+"px"; //获得窗口的水平位置;	
	    datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp","","dialogTop="+iTop+";dialogLeft="+iLeft+";dialogHeight=550px;dialogWidth=550px;")
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
			    }
			    else	{
		    	     $("#"+spanname).html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
				    $("input[name="+inputname+"]").val("");
			    }
			}
	}
	
	function onShowRole(tdname,inputename){
		datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp")
		if (datas){
		    if (datas.id!=""){
				$("#"+tdname).html(datas.name);
				$("input[name="+inputename+"]").val(datas.id);
			}
			else{
				$("#"+tdname).html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
				$("input[name="+inputename+"]").val("");
			}
		}
	}
	function onShowOrgGroup(inputname,spanname){
		linkurl="/hrm/orggroup/HrmOrgGroupRelated.jsp?orgGroupId=";
		url="/hrm/orggroup/HrmOrgGroupBrowser.jsp";
		datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url);
		if (datas) {
		    if (datas.id!= "") {
		        ids = datas.id.split(",");
			    names =datas.name.split(",");
			    sHtml = "";
			    for( var i=0;i<ids.length;i++){
				    if(ids[i]!=""){
				    	sHtml = sHtml+names[i]+"&nbsp";
				    }
			    }
			    $("#"+spanname).html(sHtml);
			    $("input[name="+inputname+"]").val(datas.id);
		    }
		    else	{
	    	     $("#"+spanname).html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
			    $("input[name="+inputname+"]").val("");
		    }
		}
	}
</script>

</BODY>
</HTML>
