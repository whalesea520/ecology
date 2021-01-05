
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<script>
var parentdialog = null;
try{
	parentdialog = parent.parent.getDialog(window); 
}catch(e){}	
</script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(17599,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(16140,user.getLanguage());
String needfav ="1";
String needhelp ="";

String rightStr = "";
boolean canmaint=HrmUserVarify.checkUserRight("Voting:Maint", user);
if(canmaint){
  rightStr = "Voting:Maint";
}

String votingid=Util.fromScreen(request.getParameter("votingid"),user.getLanguage());
String votingname ="";
RecordSet.executeProc("Voting_SelectByID",votingid);
if(RecordSet.next()){
    votingname = RecordSet.getString("subject");
}

%>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<% 
    RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(this),_top} " ;
    RCMenuHeight += RCMenuHeightStep ;

    //RCMenu += "{"+SystemEnv.getHtmlLabelName(309,user.getLanguage())+",javascript:window.close(),_top} " ;
    //RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="voting"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(430, user.getLanguage())+SystemEnv.getHtmlLabelName(19467, user.getLanguage()) %>"/>
</jsp:include>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<span title="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" style="font-size: 12px;cursor: pointer;">
				<input class="e8_btn_top middle" onclick="doSave()" type="button" jQuery1392950000546="32" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>"/>
			</span>
			<span title="<%=SystemEnv.getHtmlLabelName(82753,user.getLanguage())%>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<FORM id=frmmain name=frmmain action="VotingShareOperation.jsp" method=post>
<input type="hidden" name="method" value="add">
<input type="hidden" name="votingid" value="<%=votingid%>">

<wea:layout type="3col" attributes="{'cw1':'20%','cw2':'40%','cw3':'40%'}">
  <wea:group context="<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>">
		<wea:item><%=SystemEnv.getHtmlLabelName(21956,user.getLanguage())%></wea:item>
		<wea:item attributes="{'colspan':'2'}"><SELECT name=sharetype onchange="onChangeSharetype()">
      <option value="1"><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></option>
      <option value="2"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>
      <option value="3" selected><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
      <option value="4"><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></option>
      <option value="5"><%=SystemEnv.getHtmlLabelName(1340,user.getLanguage())%></option>
	  <option value="6"><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></option>
    </SELECT></wea:item>
    
    <wea:item><%=SystemEnv.getHtmlLabelName(106,user.getLanguage())%></wea:item>
    <wea:item>
    <div id="showresource" style="display:none">
		  <brow:browser viewType="0" name="resource" browserValue="" 
			browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp"
			hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='2' _callback="afterCallBack"
			completeUrl="/data.jsp" linkUrl="" width="220px"
			browserSpanValue=""></brow:browser>
		</div>
		
		<div id="showsubcompany" style="display:none">
		   <brow:browser viewType="0" name="subcompany" browserValue="" 
			browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp"
			hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='2' _callback="afterCallBack"
			completeUrl="/data.jsp?type=164" linkUrl="" width="220px"
			browserSpanValue=""></brow:browser>
		</div>

		<div id="showjob" style="display:none">
		  <brow:browser viewType="0" name="jobtitles" browserValue="" 
          browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/jobtitles/MutiJobTitlesBrowser.jsp?selectedids="
          hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='2' width="220px"  _callback="afterCallBack" 
          completeUrl="/data.jsp?type=24" >
          </brow:browser>
		</div>
		
		<div id="showdepartment" >
			<brow:browser viewType="0" name="department" browserValue="" 
					browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp"
					hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='2' _callback="afterCallBack"
					completeUrl="/data.jsp?type=4"  width="220px"
					browserSpanValue="">
			</brow:browser>
		</div>
		
		<div id="showrole" style="display:none;">
			<brow:browser viewType="0" name="role" browserValue="" 
					browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp"
					hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2' _callback="afterCallBack"
					completeUrl="/data.jsp?type=65"  width="220px"
					browserSpanValue="">
			</brow:browser>
		</div>
		
		<INPUT type=hidden name=relatedshareid id="relatedshareid" value="">
		
    </wea:item>
    <wea:item>
    <div id=showrolelevel name=showrolelevel style="visibility:hidden">
        <%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%>:
        <SELECT name=rolelevel style="width:50px">
          <option value="0" selected><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
          <option value="1"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>
          <option value="2"><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%></option>
        </SELECT>
        </div>
    </wea:item>
    
    <wea:item attributes="{'samePair':'_seclevel','itemAreaDisplay':'none'}"><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></wea:item>
    <wea:item attributes="{'colspan':'2','samePair':'_seclevel','itemAreaDisplay':'none'}">
    	<span id="showseclevel" name="showseclevel" style="">
        <input type="text" class="inputStyle" name="seclevel" style="width:50px;" value="10" onchange='checkinput("seclevel","seclevelimage")'>
        <span id="seclevelimage"></span>
        &nbsp;--&nbsp;&nbsp;
        <input type="text" class="inputStyle" name="seclevelmax" style="width:50px;" value="100" >
			</span>
		</wea:item>
<wea:item  attributes="{'samePair':'_joblevel','itemAreaDisplay':'none','display':'none'}"><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%></wea:item>
<wea:item attributes="{'samePair':'_joblevel','itemAreaDisplay':'none','display':'none'}">
        <SELECT name=joblevel id=joblevel align="left" style="float:left" onchange="checkjoblevel()">
          <option value="0" selected><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%></option>
          <option value="1"><%=SystemEnv.getHtmlLabelName(19437,user.getLanguage())%></option>
          <option value="2"><%=SystemEnv.getHtmlLabelName(19438,user.getLanguage())%></option>
        </SELECT>
		<span id=jobsubcompanysapn style="display:none">
			<brow:browser viewType="0" name="jobsubcompany" browserValue="" 
          browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/company/SubcompanyBrowser3.jsp?selectedids=#id#&isedit=1&rightStr=HrmResourceAdd:Add"
          hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='2' width="220px"  
          completeUrl="/data.jsp?type=164">
          </brow:browser>
         </span>
		
		  <brow:browser viewType="0" name="jobdepartment" browserValue="" 
          browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids=#id#&excludeid=1"
          hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='2' width="220px"
          completeUrl="/data.jsp?type=4" display="none">
          </brow:browser>
		 
</wea:item>

  </wea:group>
</wea:layout>

</form>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
				<wea:item type="toolbar">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="parentdialog.closeByHand();">
				</wea:item>
			</wea:group>
		</wea:layout>
</div>
<script language=javascript>
var __submit = false;
function doSave(obj) {
	if(__submit){
		return;
	}
	__submit = true;
	thisvalue=document.frmmain.sharetype.value;
	checkThrough = false;
	if (thisvalue==1){
	    if(check_form(document.frmmain,'relatedshareid')){
	       $("input[name=relatedshareid]").val($("#resource").val());
          document.frmmain.submit();
          checkThrough = true;
	    }
	}else if (thisvalue==2){
	    if(check_form(document.frmmain,'relatedshareid,seclevel')){
	       $("input[name=relatedshareid]").val($("#subcompany").val());
          document.frmmain.submit();
          checkThrough = true;
	    }
	}else if (thisvalue==3){
	    if(check_form(document.frmmain,'relatedshareid,seclevel')){
	      $("input[name=relatedshareid]").val($("#department").val());
          document.frmmain.submit();
          checkThrough = true;
	    }
	}else if (thisvalue==4){
	    if(check_form(document.frmmain,'relatedshareid,seclevel')){
	       $("input[name=relatedshareid]").val($("#role").val());
          document.frmmain.submit();
          checkThrough = true;
	    }
	}else if (thisvalue==6){
	    if(check_form(document.frmmain,'relatedshareid')){
		 if(jQuery("#joblevel  option:selected").val()=="1"){
			if(check_form(document.frmmain,'jobsubcompany')){
	        $("input[name=relatedshareid]").val($("#jobtitles").val());
            document.frmmain.submit();
            checkThrough = true;
			}
		 }else  if(jQuery("#joblevel  option:selected").val()=="2"){
		   if(check_form(document.frmmain,'jobdepartment')){
	        $("input[name=relatedshareid]").val($("#jobtitles").val());
            document.frmmain.submit();
            checkThrough = true;
			}
		 
		 }else{
		    $("input[name=relatedshareid]").val($("#jobtitles").val());
            document.frmmain.submit();
            checkThrough = true;
		 }
	    }
	}else{
		if(check_form(document.frmmain,'seclevel')){
			document.frmmain.submit();
			checkThrough = true;
		}
	}
	if(checkThrough) {
		obj.disabled = true;
	}else{
		__submit = false;
	}
}
</script>
<script language=javascript>

   function afterCallBack(e,data,name){
      //console.log(data);
	  if(data && data.id != ""){
	     //$("#showrelatedsharename").html("");
	     $("input[name=relatedshareid]").val(data.id);
	  }else{
	     //$("#showrelatedsharename").html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
	     $("input[name=relatedshareid]").val("");
	  }
	  
  }

  function onChangeSharetype(){
	 
	thisvalue=document.frmmain.sharetype.value;
	document.frmmain.relatedshareid.value="";
	document.all("showseclevel").style.display='';

	//showrelatedsharename.innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"

	if(thisvalue==1){
	   jQuery("#showresource").css("display","");
	   jQuery("#showseclevel").css("display","none");
		 document.getElementById("seclevelimage").innerHTML="";
	}
	else{
	    jQuery("#showresource").css("display","none");
		showEle('_seclevel');
		hideEle('_joblevel');	
	}
	if(thisvalue==2){
	     jQuery("#showsubcompany").css("display","");
 		document.frmmain.seclevel.value=10;
 		document.getElementById("seclevelimage").innerHTML="";
	}
	else{
	    jQuery("#showsubcompany").css("display","none");
		document.frmmain.seclevel.value=10;
		showEle('_seclevel');
		hideEle('_joblevel');	
	}
	if(thisvalue==3){
	    jQuery("#showdepartment").css("display","");
 		document.frmmain.seclevel.value=10;
 		document.getElementById("seclevelimage").innerHTML="";
	}
	else{
	    jQuery("#showdepartment").css("display","none");
		document.frmmain.seclevel.value=10;
		showEle('_seclevel');
		hideEle('_joblevel');	
	}
	if(thisvalue==4){
	    jQuery("#showrole").css("display","");
	    jQuery("#showrolelevel").css("visibility","visible");
		document.frmmain.seclevel.value=10;
		document.getElementById("seclevelimage").innerHTML="";	
	}
	else{
	    jQuery("#showrole").css("display","none");
	    jQuery("#showrolelevel").css("visibility","hidden");
		document.frmmain.seclevel.value=10;
		showEle('_seclevel');
		hideEle('_joblevel');	
    }
	if(thisvalue==6){
	    jQuery("#showjob").css("display","");
 		document.frmmain.seclevel.value=10;
 		document.getElementById("seclevelimage").innerHTML="";
	    hideEle('_seclevel');
		showEle('_joblevel');
	}
	else{
	    jQuery("#showjob").css("display","none");
		document.frmmain.seclevel.value=10;
		showEle('_seclevel');
		hideEle('_joblevel');	
	}
	if(thisvalue==5){
		//showrelatedsharename.innerHTML = ""
		document.frmmain.relatedshareid.value=-1;
		document.frmmain.seclevel.value=10;
		document.getElementById("seclevelimage").innerHTML="";
	}
	if(thisvalue<0){
		//showrelatedsharename.innerHTML = ""
		document.frmmain.relatedshareid.value=-1;
		document.frmmain.seclevel.value=0;
		showEle('_seclevel');
		hideEle('_joblevel');	
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
  function checkjoblevel(){

       if(jQuery("#joblevel  option:selected").val()=="1"){
		    jQuery("#jobsubcompanysapn").css("display","");
		   jQuery("#jobdepartment").closest("div.e8_os").css("display","none");
		}else if(jQuery("#joblevel  option:selected").val()=="2"){
		  jQuery("#jobsubcompanysapn").css("display","none");
		   jQuery("#jobdepartment").closest("div.e8_os").css("display","");
		}else{
		    jQuery("#jobsubcompanysapn").css("display","none");
		   jQuery("#jobdepartment").closest("div.e8_os").css("display","none");
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
	      }
	      else {
	            $("#"+spanname).html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
	      $("input[name="+inputname+"]").val("");
	      }
	  }
  }
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
	     }
	     else {
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
	      }
	      else {
	            $("#"+spanname).html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
	      		$("input[name="+inputname+"]").val("");
	      }
	  }
	  }

  function onShowRole(spanname,inputname)  {
	  datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp","","addressbar=no;status=0;scroll="+opts._scroll+";dialogHeight="+opts._dheight+";dialogWidth="+opts._dwidth+";dialogLeft="+opts.left+";dialogTop="+opts.top+";resizable=0;center=1;");
	
		if(datas){
	    if (datas.id!=""){
	    	$("#"+spanname).html(datas.name);
		    $("input[name="+inputname+"]").val(datas.id);
	    }else{
	    	$("#"+spanname).html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
    		$("input[name="+inputname+"]").val("");
		}
	}
}
</script>

<SCRIPT language=VBS>


</SCRIPT>
</body>
</html>