
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>

<%
    int wtid = Util.getIntValue(request.getParameter("wtid"),0); 

    String isclose = Util.null2String(request.getParameter("isclose"));
    
    //System.out.println("isclose==============="+isclose);
    String titlename = "";
%>

<html>
<HEAD> 
    <LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
    <SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</HEAD>
<body>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="worktask"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())+SystemEnv.getHtmlLabelName(271,user.getLanguage())%>"/>  
</jsp:include>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
    RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(this),_top} " ;
    RCMenuHeight += RCMenuHeightStep ;
   
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
			   <td>
				</td>
				<td class="rightSearchSpan" style="text-align:right; ">
					<input type="button"
						value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage())%>"
						class="e8_btn_top middle" onclick="doSave(this);">
					<span title="<%=SystemEnv.getHtmlLabelName(2104,user.getLanguage()) %>" class="cornerMenu middle"></span>
				</td>
			</tr>
		</table>
		<div id="tabDiv" >
			<span id="hoverBtnSpan" class="hoverBtnSpan">
					<span></span>
			</span>
		</div>
		<div class="advancedSearchDiv" id="advancedSearchDiv">
		</div>
	
		<div class="zDialog_div_content">

                            <form name="weaverA" method="post" action="ShareOperation.jsp">
                              <INPUT TYPE="hidden" NAME="wtid" value="<%=wtid%>">           
                              <INPUT type="hidden" Name="method" value="addCreator">
							  

                <wea:layout type="2col">
					<wea:group context='<%=SystemEnv.getHtmlLabelName(1361, user.getLanguage())%>' >
						<!-- 对象 -->
						<wea:item><%=SystemEnv.getHtmlLabelName(21956, user.getLanguage())%></wea:item>
						<wea:item>
							<SELECT style="width:100px;" class="InputStyle" name="sharetype" id="sharetype" onchange="onChangeShareType()" style="float:left">
							  <option selected value="1"><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></option>
							  <option  value="2"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>
							  <option  value="3"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
							  <option  value="4"><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></option>
							  <option  value="5"><%=SystemEnv.getHtmlLabelName(1340,user.getLanguage())%></option>
							 
							</SELECT>
						</wea:item>
						<wea:item attributes="{'samePair':\"objtr\"}" ><%=SystemEnv.getHtmlLabelName(106, user.getLanguage())%></wea:item>
						<wea:item attributes="{'samePair':\"objtr\"}" >	
							<span id="subidsSP" style="float:left;">
							<brow:browser viewType="0" name="subids" browserValue="" 
							browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiSubcompanyBrowser.jsp?selectedids=" 
							hasInput="true"  isSingle="false" hasBrowser = "true" isMustInput='2'  width="200px"
							completeUrl="/data.jsp?type=164" linkUrl="/hrm/company/HrmSubCompanyDsp.jsp?id=" 
							browserSpanValue=""></brow:browser>
							</span>
							
							<span id="departmentidSP" style="float:left;">
							<brow:browser viewType="0" name="departmentid" browserValue="" 
							browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids=" 
							hasInput="true"  isSingle="false" hasBrowser = "true" isMustInput='2'  width="200px"
							completeUrl="/data.jsp?type=4" linkUrl="/hrm/company/HrmDepartmentDsp.jsp?id=" 
							browserSpanValue=""></brow:browser>
							</span>
							 
							<span id="useridSP" style="float:left;">
							<brow:browser viewType="0" name="userid" browserValue="" 
							browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids=" 
							hasInput="true"  isSingle="false" hasBrowser = "true" isMustInput='2'  width="200px"
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
							
							<span id=showrolelevel name=showrolelevel style="float:left;width:150px;margin-left:10px;display:none">
							  <div style="float:left;margin-top:7px;height:17px;line-height:17px;">&nbsp;&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%>&nbsp;&nbsp;</div>
							  <SELECT class="InputStyle" name="rolelevel" id="rolelevel" style="width:60px;">
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
							    
							</span>
						</wea:item>
					</wea:group>
				</wea:layout>
                </form>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout type="2col">
		<wea:group context="">
			<wea:item type="toolbar">
				<input type="button"
					value="<%=SystemEnv.getHtmlLabelName(309, user.getLanguage())%>"
					id="zd_btn_cancle" class="zd_btn_cancle" onclick="btn_cancle()">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
</body>
</html>


<SCRIPT LANGUAGE="JavaScript">
 
if("<%=isclose%>"=="1"){
    //alert("<%=isclose%>");
	var dialog = parent.getDialog(window);
	dialog.currentWindow.location.reload()
	dialog.close();	
}
 

  function onChangeMainttype(seleObj,txtObj,spanObj){
	var thisvalue=seleObj.value;	
    var strAlert= "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	
	if(thisvalue==1){  //人员
 		document.getElementById("btnRelatedHrm").style.display='';
		document.getElementById("btnRelatedSubcompany").style.display='none';
		document.getElementById("btnRelatedDepartment").style.display='none';
		txtObj.value="";		
		spanObj.innerHTML=strAlert;	
	} else if (thisvalue==2)	{ //分部
		document.getElementById("btnRelatedHrm").style.display='none';
		document.getElementById("btnRelatedSubcompany").style.display='';
		document.getElementById("btnRelatedDepartment").style.display='none';
		txtObj.value="";
		spanObj.innerHTML=strAlert;	
	}else if (thisvalue==3)	{ //部门
		document.getElementById("btnRelatedHrm").style.display='none';
		document.getElementById("btnRelatedSubcompany").style.display='none';
		document.getElementById("btnRelatedDepartment").style.display='';
		txtObj.value="";
		spanObj.innerHTML=strAlert;	
	}else if (thisvalue==5)	{ //所有人
		document.getElementById("btnRelatedHrm").style.display='none';
		document.getElementById("btnRelatedSubcompany").style.display='none';
		document.getElementById("btnRelatedDepartment").style.display='none';
		txtObj.value="";
		spanObj.innerHTML="";
	}
	
}
function removeValue(){
    var chks = document.getElementsByName("chkMaintDetail");
    for (var i=chks.length-1;i>=0;i--){
        var chk = chks[i];
        if (chk.checked)
            oTable.deleteRow(chk.parentElement.parentElement.parentElement.rowIndex)
    }
}

function addValue(){
   var thisvalue=document.getElementById("mainttype").value;

   var maintTypeValue = thisvalue;
   var mainType=$("#mainttype")[0];
   var maintTypeText = $(mainType.options[mainType.selectedIndex]).text();


    //人力资源(1),分部(2),部门(3),具体客户(9),角色后的那个选项值不能为空(4)
    var relatedMaintIds="0";
    var relatedMaintNames="";
    if (thisvalue==1 || thisvalue==2 || thisvalue==3) {
        if(!check_form(document.weaverA,'relatedmaintid')) {
            return ;
        }
        relatedMaintIds = document.all("relatedmaintid").value;
        relatedMaintNames= document.all("showrelatedmaintname").innerHTML;
    }

   //共享类型 + 共享者ID
   var totalValue=maintTypeValue+"_"+relatedMaintIds
   if(thisvalue==5) relatedMaintNames=maintTypeText;  //所有人

   var oRow = oTable.insertRow(-1);
   var oRowIndex = oRow.rowIndex;

   if (oRowIndex%2==0) oRow.className="dataLight";
   else oRow.className="dataDark";
	//alert(relatedMaintIds);
   for (var i =1; i <=3; i++) {   //生成一行中的每一列
      oCell = oRow.insertCell(-1);
      var oDiv = document.createElement("div");
      if (i==1) oDiv.innerHTML="<input class='inputStyle' type='checkbox' name='chkMaintDetail' value='"+totalValue+"'><input type='hidden' name='txtMaintDetail' value='"+relatedMaintIds+"'>";
      else if (i==2) oDiv.innerHTML=maintTypeText;
	  else if (i==3) oDiv.innerHTML=relatedMaintNames;
      oCell.appendChild(oDiv);
   }
   jQuery("body").jNice();
}

function chkAllClick(obj){
	 var chkboxElems= document.getElementsByName("chkMaintDetail");
	    for (j=0;j<chkboxElems.length;j++)
	    {
	        if (obj.checked) 
	        {
	        	if(chkboxElems[j].style.display!='none'){
	            	chkboxElems[j].checked = true ;		
	            }	
	        } 
	        else 
	        {       
	            chkboxElems[j].checked = false ;
	        }
	    }
}

function onShowSubcompany(inputname,spanname){  
    linkurl="/hrm/company/HrmSubCompanyDsp.jsp?id="
    datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp?selectedids="&inputname.value)

	if(datas){
	    if(datas.id){       
			resourceids = datas.id;
			resourcename = datas.name;
			sHtml = ""
			resourceids =resourceids.substr(1);
			resourcenames = resourcename.substr(1);
			var resourceidsAray=resourceids.split(",");
			var resourcenamesArray=resourcenames.split(",");
			for(var i=0;i<resourceidsAray.length;i++){
				sHtml+="<a href="+linkurl+resourceidsAray[i]+">"+resourcenamesArray[i]+"</a>&nbsp";
			}
			$(spanname).html(sHtml) ;
			$(inputname).val(resourceids);
	    }else{
			$(spanname).html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
			$(inputname).val("");
	    }
	}
}

function onShowDepartment(inputname,spanname){
    linkurl="/hrm/company/HrmDepartmentDsp.jsp?id="
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids="&inputname.value)
	if(datas){
	    if(datas.id){       
			resourceids = datas.id;
			resourcename = datas.name;
			sHtml = ""
			resourceids =resourceids.substr(1);
			resourcenames = resourcename.substr(1);
			var resourceidsAray=resourceids.split(",");
			var resourcenamesArray=resourcenames.split(",");
			for(var i=0;i<resourceidsAray.length;i++){
				sHtml+="<a href="+linkurl+resourceidsAray[i]+">"+resourcenamesArray[i]+"</a>&nbsp";
			}
			$(spanname).html(sHtml) ;
			$(inputname).val(resourceids);
	    }else{
			$(spanname).html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
			$(inputname).val("");
	    }
	}
}

function onShowResource(inputname,spanname){
    linkurl="javaScript:openhrm("
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp")
	if(datas){
	    if(datas.id){       
			resourceids = datas.id;
			resourcename = datas.name;
			sHtml = ""
			resourceids =resourceids.substr(1);
			resourcenames = resourcename.substr(1);
			var resourceidsAray=resourceids.split(",");
			var resourcenamesArray=resourcenames.split(",");
			for(var i=0;i<resourceidsAray.length;i++){
				sHtml+="<a href="+linkurl+resourceidsAray[i]+">"+resourcenamesArray[i]+"</a>&nbsp";
			}
			$(spanname).html(sHtml) ;
			$(inputname).val(resourceids);
	    }else{
			$(spanname).html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
			$(inputname).val("");
	    }
	}
}


function doSave(obj){
    if(check_by_sharetype()){
       obj.disabled=true;
       weaverA.submit(); 
    }
	   
}
function btn_cancle(){
		var dialog = parent.getDialog(window);
		dialog.close();
}
function onChangeShareType() {
	thisvalue=jQuery("#sharetype").val();
 	//jQuery($GetEle("sectr")).css("display","");
 	//jQuery($GetEle("secline")).css("display","");
	showEle("sectr");
	showEle("objtr");
 	
	if (thisvalue == 1) {
		jQuery($GetEle("subidsSP")).css("display","none");
		jQuery($GetEle("departmentidSP")).css("display","none");
		jQuery($GetEle("useridSP")).css("display","");
		jQuery($GetEle("roleidSP")).css("display","none");
		jQuery($GetEle("showrolelevel")).css("display","none");
		hideEle("sectr", true);
    }
	else if (thisvalue == 2) {
		jQuery($GetEle("subidsSP")).css("display","");
		jQuery($GetEle("departmentidSP")).css("display","none");
		jQuery($GetEle("useridSP")).css("display","none");
		jQuery($GetEle("roleidSP")).css("display","none");
		
		showEle("sectr");
	}
	else if (thisvalue == 3) {
		jQuery($GetEle("subidsSP")).css("display","none");
		jQuery($GetEle("departmentidSP")).css("display","");
		jQuery($GetEle("useridSP")).css("display","none");
		jQuery($GetEle("roleidSP")).css("display","none");
		jQuery($GetEle("showrolelevel")).css("display","none");
		showEle("sectr");
	}
	
	else if (thisvalue == 4) {
		jQuery($GetEle("subidsSP")).css("display","none");
		jQuery($GetEle("departmentidSP")).css("display","none");
		jQuery($GetEle("useridSP")).css("display","none");
		jQuery($GetEle("roleidSP")).css("display","");
		jQuery($GetEle("showrolelevel")).css("display","");

	}
	else if (thisvalue == 5) {
		jQuery($GetEle("subidsSP")).css("display","none");
		jQuery($GetEle("departmentidSP")).css("display","none");
		jQuery($GetEle("useridSP")).css("display","none");
		jQuery($GetEle("roleidSP")).css("display","none");
		jQuery($GetEle("showrolelevel")).css("display","none");
		showEle("sectr");
		hideEle("objtr", true);
	}
}

function check_by_sharetype() {
    var re=/^\d+$/;
    var thisvalue=jQuery("#sharetype").val();
    var seclevel = jQuery("#seclevel").val();
    
    $("#sharetype").val(thisvalue);
    
    if (thisvalue == 1) {
        
        $("#sharevalue").val($("#userid").val());
        return check_form(weaverA, "userid");
        
           
    } else if (thisvalue == 2) {
        if(!re.test(seclevel))  {
            window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(2245,user.getLanguage())%>")
            return false;
        }
        $("#sharevalue").val($("#subids").val());
        $("#formseclevel").val($("#seclevel").val());
        return check_form(weaverA, "subids, seclevel");

    } else if (thisvalue == 3) {
    
        if(!re.test(seclevel))  {
            window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(2245,user.getLanguage())%>")
            return false;
        }
        
        $("#sharevalue").val($("#departmentid").val());
        $("#formseclevel").val($("#seclevel").val());
        
        return check_form(weaverA, "departmentid, seclevel");     
        
        
    } else if (thisvalue == 4) {
    	if(!re.test(seclevel))  {
            window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(2245,user.getLanguage())%>");
            return false;
        }
        
        $("#sharevalue").val($("#roleid").val());
        $("#formseclevel").val($("#seclevel").val());
        $("#formrolelevel").val($("#rolelevel").val());
        if($("#roleid").val() == 0){
           window.top.Dialog.alert('<%=SystemEnv.getHtmlLabelNames("18214,33401",user.getLanguage())%>');
           return false;
        }
        return check_form(weaverA, "roleid, rolelevel, seclevel");
    } else if (thisvalue == 5) {
        if(!re.test(seclevel))  {
            window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(2245,user.getLanguage())%>")
            return false;
        }
        
        $("#formseclevel").val($("#seclevel").val());
        return check_form(weaverA, "seclevel");
    } else {
        return false;
    }
}
jQuery(document).ready(function(){
	onChangeShareType();
});

</SCRIPT>


