
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
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())+SystemEnv.getHtmlLabelName(119,user.getLanguage())%>"/>  
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

                            <form name="weaverA" method="post" action="WorkTaskShareOperation.jsp">
                              <INPUT TYPE="hidden" NAME="wtid" value="<%=wtid%>">           
                              <INPUT type="hidden" Name="method" value="addShare">
                              <input type="hidden" name="types" value="0">
			     

                <wea:layout type="2col">
                    <wea:group context='<%=SystemEnv.getHtmlLabelNames("407,68",user.getLanguage())%>' >
                        <!-- 计划任务状态 -->
						<wea:item><%=SystemEnv.getHtmlLabelName(21947, user.getLanguage())%></wea:item>
						<wea:item>
							<SELECT style="width:100px;" class="InputStyle" name="taskstatus" id="taskstatus" style="float:left">
							  <option selected value="-1"><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
							  <option  value="1"><%=SystemEnv.getHtmlLabelName(21948,user.getLanguage())%></option>
							  <option  value="2"><%=SystemEnv.getHtmlLabelName(21949,user.getLanguage())%></option>
							</SELECT>
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(21956, user.getLanguage())%>   </wea:item>
						<wea:item>
							<SELECT style="width:100px;" class="InputStyle" name="ssharetype" id="ssharetype" onchange="onChangeShareType2()" style="float:left">
							  <option   value="1"><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></option>
							  <option  value="2"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>
							  <option selected value="3"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
							  <option  value="4"><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></option>
							  <option  value="5"><%=SystemEnv.getHtmlLabelName(1340,user.getLanguage())%></option>
							 
							</SELECT>
						</wea:item>
						
						<wea:item attributes="{'samePair':\"planobjtr\"}" >
						   <span class="planobjtr"><%=SystemEnv.getHtmlLabelName(16539, user.getLanguage())+SystemEnv.getHtmlLabelName(882, user.getLanguage())%></span>
						  </wea:item>
						<wea:item attributes="{'samePair':\"planobjtr\"}" >	
						  <span class="planobjtr">
							<span id="ssubidsSP" style="float:left;">
							<brow:browser viewType="0" name="ssubids" browserValue="" 
							browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiSubcompanyBrowser.jsp?selectedids=" 
							hasInput="true"  isSingle="false" hasBrowser = "true" isMustInput='2'  width="200px"
							completeUrl="/data.jsp?type=164" linkUrl="/hrm/company/HrmSubCompanyDsp.jsp?id=" 
							browserSpanValue=""></brow:browser>
							</span>
							
							<span id="sdepartmentidSP" style="float:left;">
							<brow:browser viewType="0" name="sdepartmentid" browserValue="" 
							browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids=" 
							hasInput="true"  isSingle="false" hasBrowser = "true" isMustInput='2'  width="200px"
							completeUrl="/data.jsp?type=4" linkUrl="/hrm/company/HrmDepartmentDsp.jsp?id=" 
							browserSpanValue=""></brow:browser>
							</span>
							 
							<span id="suseridSP" style="float:left;">
							<brow:browser viewType="0" name="suserid" browserValue="" 
							browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids=" 
							hasInput="true"  isSingle="false" hasBrowser = "true" isMustInput='2'  width="200px"
							completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" 
							browserSpanValue=""></brow:browser>
							</span>
							
							<span id="sroleidSP" style="float:left;">
							<brow:browser viewType="0" name="sroleid" browserValue="" 
							browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp" 
							hasInput="true"  isSingle="true" hasBrowser = "true" isMustInput='2'  width="200px"
							completeUrl="/data.jsp?type=65" linkUrl="/hrm/roles/HrmRolesShowEdit.jsp?type=0&id=" 
							browserSpanValue=""></brow:browser>
							</span>
							
							<span id=sshowrolelevel name=sshowrolelevel style="float:left;width:180px;margin-left:10px;display:none">
							  <div style="float:left;margin-top:7px;height:17px;line-height:17px;">&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%>&nbsp;&nbsp;</div>
							  <SELECT class="InputStyle" name="srolelevel" id="srolelevel" style="width:60px;">
							    <option selected value="0"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
							    <option value="1"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>
							    <option value="2"><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>
							  </SELECT>
							</span>
						  </span>
						</wea:item>
						<!-- 安全级别 -->
						<wea:item attributes="{'samePair':'spansectr'}"><%=SystemEnv.getHtmlLabelName(683, user.getLanguage())%></wea:item>
						<wea:item attributes="{'samePair':'spansectr'}">
							<span id=sshowseclevel name=sshowseclevel style="display:''">
								<INPUT class="InputStyle" style="width:50px;" type=text id=sseclevel name=sseclevel size=6 value="0" onchange="checkinput('sseclevel','sseclevelimage')">
							    <SPAN id=sseclevelimage></SPAN>
							    
							</span>
						</wea:item>
					</wea:group>
			</wea:layout>
			
			<wea:layout type="2col">
					<wea:group context='<%=SystemEnv.getHtmlLabelName(2112, user.getLanguage())%>' >
					    <!-- 共享级别 -->
						<wea:item><%=SystemEnv.getHtmlLabelName(3005, user.getLanguage())%></wea:item>
						<wea:item>
							<SELECT style="width:100px;" class="InputStyle" name="sharelevel" id="sharelevel" style="float:left">
							  <option value="0"><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%></option>
							  <option  value="1"><%=SystemEnv.getHtmlLabelName(21950,user.getLanguage())%></option>
							</SELECT>
						</wea:item>
						<!-- 对象 -->
						<wea:item><%=SystemEnv.getHtmlLabelName(21956, user.getLanguage())%></wea:item>
						<wea:item>
							<SELECT style="width:100px;" class="InputStyle" name="sharetype" id="sharetype" onchange="onChangeShareType()" style="float:left">
							  <option value="1"><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></option>
							  <option  value="2"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>
							  <option selected  value="3"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
							  <option  value="4"><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></option>
							  <option  value="5"><%=SystemEnv.getHtmlLabelName(1340,user.getLanguage())%></option>
							  <option  value="6"><%=SystemEnv.getHtmlLabelName(18583,user.getLanguage())%></option>
							  <option  value="7"><%=SystemEnv.getHtmlLabelName(15081,user.getLanguage())%></option>
							  <option  value="8"><%=SystemEnv.getHtmlLabelName(18584,user.getLanguage())%></option>
							 
							</SELECT>
						</wea:item>
						<wea:item attributes="{'samePair':\"objtr\"}" ><%=SystemEnv.getHtmlLabelName(19117, user.getLanguage())%></wea:item>
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
							
							<span id=showrolelevel name=showrolelevel style="float:left;width:180px;margin-left:10px;display:none">
							  <div style="float:left;margin-top:7px;height:17px;line-height:17px;">&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%>&nbsp;&nbsp;</div>
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




function doSave(obj){
    if(check_by_sharetype() && check_by_sharetype2()){
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
	showTr("sectr");
	showTr("objtr");
 	
	if (thisvalue == 1) {
		jQuery($GetEle("subidsSP")).css("display","none");
		jQuery($GetEle("departmentidSP")).css("display","none");
		jQuery($GetEle("useridSP")).css("display","");
		jQuery($GetEle("roleidSP")).css("display","none");
		jQuery($GetEle("showrolelevel")).css("display","none");
		hideTr("sectr");
    }
	else if (thisvalue == 2) {
		jQuery($GetEle("subidsSP")).css("display","");
		jQuery($GetEle("departmentidSP")).css("display","none");
		jQuery($GetEle("useridSP")).css("display","none");
		jQuery($GetEle("roleidSP")).css("display","none");
		
		showTr("sectr");
	}
	else if (thisvalue == 3) {
		jQuery($GetEle("subidsSP")).css("display","none");
		jQuery($GetEle("departmentidSP")).css("display","");
		jQuery($GetEle("useridSP")).css("display","none");
		jQuery($GetEle("roleidSP")).css("display","none");
		jQuery($GetEle("showrolelevel")).css("display","none");
		showTr("sectr");
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
		showTr("sectr");
		hideTr("objtr");
	}else if (thisvalue == 6) {
		jQuery($GetEle("subidsSP")).css("display","none");
		jQuery($GetEle("departmentidSP")).css("display","none");
		jQuery($GetEle("useridSP")).css("display","none");
		jQuery($GetEle("roleidSP")).css("display","none");
		jQuery($GetEle("showrolelevel")).css("display","none");
		hideTr("sectr");
		hideTr("objtr");
	}else if (thisvalue == 7) {
		jQuery($GetEle("subidsSP")).css("display","none");
		jQuery($GetEle("departmentidSP")).css("display","none");
		jQuery($GetEle("useridSP")).css("display","none");
		jQuery($GetEle("roleidSP")).css("display","none");
		jQuery($GetEle("showrolelevel")).css("display","none");
		hideTr("sectr");
		hideTr("objtr");
	}else if (thisvalue == 8) {
		jQuery($GetEle("subidsSP")).css("display","none");
		jQuery($GetEle("departmentidSP")).css("display","none");
		jQuery($GetEle("useridSP")).css("display","none");
		jQuery($GetEle("roleidSP")).css("display","none");
		jQuery($GetEle("showrolelevel")).css("display","none");
		hideTr("sectr");
		hideTr("objtr");
	}
}


function onChangeShareType2() {
	thisvalue=jQuery("#ssharetype").val();
 	//jQuery($GetEle("sectr")).css("display","");
 	//jQuery($GetEle("secline")).css("display","");
	showTr("plansectr");
	showTr("planobjtr");
 	showTr("spansectr");
	if (thisvalue == 1) {
		jQuery($GetEle("ssubidsSP")).css("display","none");
		jQuery($GetEle("sdepartmentidSP")).css("display","none");
		jQuery($GetEle("suseridSP")).css("display","");
		jQuery($GetEle("sroleidSP")).css("display","none");
		jQuery($GetEle("sshowrolelevel")).css("display","none");
		hideTr("plansectr");
		hideTr("spansectr");
    }
	else if (thisvalue == 2) {
		jQuery($GetEle("ssubidsSP")).css("display","");
		jQuery($GetEle("sdepartmentidSP")).css("display","none");
		jQuery($GetEle("suseridSP")).css("display","none");
		jQuery($GetEle("sroleidSP")).css("display","none");
		
		showTr("plansectr");
	}
	else if (thisvalue == 3) {
		jQuery($GetEle("ssubidsSP")).css("display","none");
		jQuery($GetEle("sdepartmentidSP")).css("display","");
		jQuery($GetEle("suseridSP")).css("display","none");
		jQuery($GetEle("sroleidSP")).css("display","none");
		jQuery($GetEle("sshowrolelevel")).css("display","none");
		showTr("plansectr");
	}
	
	else if (thisvalue == 4) {
		jQuery($GetEle("ssubidsSP")).css("display","none");
		jQuery($GetEle("sdepartmentidSP")).css("display","none");
		jQuery($GetEle("suseridSP")).css("display","none");
		jQuery($GetEle("sroleidSP")).css("display","");
		jQuery($GetEle("sshowrolelevel")).css("display","");

	}
	else if (thisvalue == 5) {
		jQuery($GetEle("ssubidsSP")).css("display","none");
		jQuery($GetEle("sdepartmentidSP")).css("display","none");
		jQuery($GetEle("suseridSP")).css("display","none");
		jQuery($GetEle("sroleidSP")).css("display","none");
		jQuery($GetEle("sshowrolelevel")).css("display","none");
		showTr("plansectr");
		hideTr("planobjtr");
	}
}

//特定应用
function hideTr(attrvalue){
   $('td').each(function(){
	  if($(this).attr('_samepair')){
	     if($(this).attr('_samepair') === attrvalue){
	        $(this).parent("tr").hide();
	        $(this).parent("tr").prev("tr").hide();
	     }
	  }
   })
}

function showTr(attrvalue){
   $('td').each(function(){
	  if($(this).attr('_samepair')){
	     if($(this).attr('_samepair') === attrvalue){
	        $(this).parent("tr").show();
	        $(this).parent("tr").prev("tr").show();
	     }
	  }
   })
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
            window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(2245,user.getLanguage())%>")
            return false;
        }
        
        $("#sharevalue").val($("#roleid").val());
        $("#formseclevel").val($("#seclevel").val());
        $("#formrolelevel").val($("#rolelevel").val());
        return check_form(weaverA, "roleid, rolelevel, seclevel");
    } else if (thisvalue == 5) {
        if(!re.test(seclevel))  {
            window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(2245,user.getLanguage())%>")
            return false;
        }
        
        $("#formseclevel").val($("#seclevel").val());
        return check_form(weaverA, "seclevel");
    }else if(thisvalue == 6|| thisvalue == 7 || thisvalue == 8){
        return true;
    }else {
        return false;
    }
}

//计划任务设置 验证
function check_by_sharetype2() {
    var re=/^\d+$/;
    var thisvalue=jQuery("#ssharetype").val();
    var seclevel = jQuery("#sseclevel").val();
    
    $("#ssharetype").val(thisvalue);
    
    if (thisvalue == 1) {
        
        $("#ssharevalue").val($("#suserid").val());
        return check_form(weaverA, "suserid");
        
           
    } else if (thisvalue == 2) {
        if(!re.test(seclevel))  {
            window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(2245,user.getLanguage())%>")
            return false;
        }
        $("#ssharevalue").val($("#ssubids").val());
        $("#sformseclevel").val($("#sseclevel").val());
        return check_form(weaverA, "ssubids, sseclevel");

    } else if (thisvalue == 3) {
    
        if(!re.test(seclevel))  {
            window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(2245,user.getLanguage())%>")
            return false;
        }
        
        $("#ssharevalue").val($("#sdepartmentid").val());
        $("#sformseclevel").val($("#sseclevel").val());
        
        return check_form(weaverA, "sdepartmentid, sseclevel");     
        
        
    } else if (thisvalue == 4) {
    	if(!re.test(seclevel))  {
            window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(2245,user.getLanguage())%>")
            return false;
        }
        
        $("#ssharevalue").val($("#sroleid").val());
        $("#sformseclevel").val($("#sseclevel").val());
        $("#sformrolelevel").val($("#srolelevel").val());
        return check_form(weaverA, "sroleid, srolelevel, sseclevel");
    } else if (thisvalue == 5) {
        if(!re.test(seclevel))  {
            window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(2245,user.getLanguage())%>")
            return false;
        }
        
        $("#sformseclevel").val($("#sseclevel").val());
        return check_form(weaverA, "sseclevel");
    } else {
        return false;
    }
}

jQuery(document).ready(function(){
    onChangeShareType2();
	onChangeShareType();
	
});

</SCRIPT>


