
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="DocChangeManager" class="weaver.docs.change.DocChangeManager" scope="page" />
<jsp:useBean id="secCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
</head>
<%
if(!HrmUserVarify.checkUserRight("DocChange:Setting", user)){
    response.sendRedirect("/notice/noright.jsp") ;
    return ;
}
String imagefilename = "/images/hdSystem_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(23098,user.getLanguage()) ;
String needfav ="1";
String needhelp ="";
DocChangeManager.setSettingCache();

String autoSend = (String) staticobj.getObject("DocChangeSetting.autoSend");
String autoSendTime = (String) staticobj.getObject("DocChangeSetting.autoSendTime");
if(autoSendTime.equals("")||autoSendTime.equals("0"))autoSendTime = "1";
String autoReceive = (String) staticobj.getObject("DocChangeSetting.autoReceive");
String autoReceiveTime = (String) staticobj.getObject("DocChangeSetting.autoReceiveTime");
if(autoReceiveTime.equals("")||autoReceiveTime.equals("0"))autoReceiveTime = "1";
String serverURL = (String) staticobj.getObject("DocChangeSetting.serverURL");
int serverPort = Util.getIntValue((String) staticobj.getObject("DocChangeSetting.serverPort"), 21);
String serverUser = (String) staticobj.getObject("DocChangeSetting.serverUser");
String serverPwd = (String) staticobj.getObject("DocChangeSetting.serverPwd");
String changeMode = (String) staticobj.getObject("DocChangeSetting.changeMode");
int maincategory = Util.getIntValue((String) staticobj.getObject("DocChangeSetting.maincategory"), 0);
int subcategory = Util.getIntValue((String) staticobj.getObject("DocChangeSetting.subcategory"), 0);
int seccategory = Util.getIntValue((String) staticobj.getObject("DocChangeSetting.seccategory"), 0);
//String pathcategory = Util.null2String((String) staticobj.getObject("DocChangeSetting.pathcategory"));
String pathcategory = secCategoryComInfo.getAllParentName(""+seccategory,true);
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:_onViewLog(346),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86 ,user.getLanguage()) %>" class="e8_btn_top" onclick="doSave(this)"/>
			<input id="ftpTestBtn" type="button" value="<%=SystemEnv.getHtmlLabelName(25496 ,user.getLanguage()) %>" class="e8_btn_top" onclick="doTestFtp()"/>
			<span id="advancedSearch" class="advancedSearch" style='display:none;'><%=SystemEnv.getHtmlLabelName(21995 ,user.getLanguage()) %></span>&nbsp;&nbsp;
			<span title="<%=SystemEnv.getHtmlLabelName(23036 ,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>

<FORM style="MARGIN-TOP: 0px" name=frmMain method=post action="DocChangeSystemSetOpterator.jsp">
<input type=hidden id='pathcategory' name='pathcategory' value="<%=pathcategory%>">
<input type=hidden id='maincategory' name='maincategory' value="<%=maincategory%>">
<INPUT type=hidden id='subcategory' name='subcategory' value="<%=subcategory%>">
<%
String temptitle = SystemEnv.getHtmlLabelName(1361,user.getLanguage())+"("+SystemEnv.getHtmlLabelName(21760,user.getLanguage())+")";
%>
<div id="exchangeInfo" style="display:none;">
	<wea:layout>
		<wea:group context='<%=temptitle%>' attributes="{'samePair':'SetInfo1','groupOperDisplay':'none'}">
			<wea:item><%=SystemEnv.getHtmlLabelName(23100,user.getLanguage())%></wea:item>
			  <wea:item>
				<input type="checkbox" tzCheckbox="true" onclick="toggleAutoSR(this,'autoSendTime')" name="autoSend"  value="1" <%if(autoSend.equals("1")){%>checked<%}%>>
			  </wea:item>
			  <%String attr = "{'samePair':'autoSendTime','display':'"+(autoSend.equals("1")?"":"none")+"'}"; %>
			  <wea:item attributes='<%=attr %>'><%=SystemEnv.getHtmlLabelName(23102,user.getLanguage())%></wea:item>
			  <wea:item attributes='<%=attr %>'>
				<input type="text" name="autoSendTime" style='width:50px!important;'  value="<%=autoSendTime%>" maxlength="50" onKeyPress="ItemCount_KeyPress()" onBlur='checkcount1(this)' style="width :60" class="InputStyle">
				<%=SystemEnv.getHtmlLabelName(15049,user.getLanguage())%>
			  </wea:item>
			  <wea:item><%=SystemEnv.getHtmlLabelName(23099,user.getLanguage())%></wea:item>
			  <wea:item>
				<input type="checkbox" tzCheckbox="true" onclick="toggleAutoSR(this,'autoReceiveTime')" name="autoReceive"  value="1" <%if(autoReceive.equals("1")){%>checked<%}%>>
			  </wea:item>
			  <%attr = "{'samePair':'autoReceiveTime','display':'"+(autoReceive.equals("1")?"":"none")+"'}"; %>
			  <wea:item attributes='<%=attr %>'><%=SystemEnv.getHtmlLabelName(23101,user.getLanguage())%></wea:item>
			  <wea:item attributes='<%=attr %>'>
				<input type="text" name="autoReceiveTime" style='width:50px!important;' value="<%=autoReceiveTime%>" maxlength="50" onKeyPress="ItemCount_KeyPress()" onBlur='checkcount1(this)' style="width :60" class="InputStyle">
				<%=SystemEnv.getHtmlLabelName(15049,user.getLanguage())%>
			  </wea:item>
			  <wea:item><%=SystemEnv.getHtmlLabelName(18526,user.getLanguage()) + SystemEnv.getHtmlLabelName(15046,user.getLanguage())%></wea:item>
			  <wea:item>
		 		 <brow:browser name="seccategory" viewType="0" hasBrowser="true" hasAdd="false" 
		         			browserUrl="/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategorySingleBrowser.jsp" isMustInput="1" isSingle="true" hasInput="true"
		         			completeUrl="/data.jsp?type=categoryBrowser" _callback="onShowCatalogData" idKey="id" nameKey="path" width="300px" browserValue='<%=""+seccategory%>' browserSpanValue='<%=pathcategory%>' />
		         		    
			  </wea:item>
		</wea:group>
	</wea:layout>
</div>
<div id="ftpInfo" style="display:none;">
	<wea:layout needImportDefaultJsAndCss="false">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>' attributes="{'samePair':'SetInfo2','groupOperDisplay':'none'}">
			  <wea:item><%=SystemEnv.getHtmlLabelName(20519,user.getLanguage())%></wea:item>
			  <wea:item>
				<input type="text" name="serverURL" id="serverURL" style='width:280px!important;' onChange="checkinput('serverURL','serverURLspan')" value="<%=serverURL%>" maxlength="50" style="width :50%" class="InputStyle">
				<span id="serverURLspan"></span>
			  </wea:item>
			  <wea:item><%=SystemEnv.getHtmlLabelName(18782,user.getLanguage())%></wea:item>
			  <wea:item>
				<input type="text" name="serverPort" id="serverPort" style='width:280px!important;' maxlength="50" size=5 onKeyPress="ItemCount_KeyPress()" onBlur='checkcount1(this)' onChange="checkinput('serverPort','serverPortspan')" value="<%=serverPort%>" maxlength="50" style="width :50%" class="InputStyle">
				<span id="serverPortspan"></span>
			  </wea:item>
			  <wea:item><%=SystemEnv.getHtmlLabelName(2072,user.getLanguage())%></wea:item>
			  <wea:item>
				<input type="text" name="serverUser" id="serverUser" style='width:280px!important;' onChange="checkinput('serverUser','serverUserspan')" value="<%=serverUser%>" maxlength="50" style="width :50%" class="InputStyle">
				<span id="serverUserspan"></span>
			  </wea:item>
			  <wea:item><%=SystemEnv.getHtmlLabelName(409,user.getLanguage())%></wea:item>
			  <wea:item>
				<input type="password" name="serverPwd" id="serverPwd" style='width:280px!important;' onChange="checkinput('serverPwd','serverPwdspan')" value="<%=serverPwd%>" maxlength="50" style="width :50%" class="InputStyle">
				<span id="serverPwdspan"></span>
			  </wea:item>
		</wea:group>
	</wea:layout>
</div>
  </FORM>
</BODY>
</HTML>
<script>
jQuery(document).ready(function(){
	try{
		var current = jQuery("li.current",parent.document);
		var id = current.children("a").attr("id").replace(/Tab/g,"");
		jQuery("#exchangeInfo").hide();
		jQuery("#ftpInfo",_document).hide();
		jQuery("#"+id).show();
		if(id=="exchangeInfo"){
			jQuery("#ftpTestBtn").hide();
		}
		var _document = document;
		parent.registerClickEventForOfficalChange(null,_document);
	}catch(e){
		jQuery("#exchangeInfo").hide();
		jQuery("#ftpInfo").hide();
		jQuery("#ftpTestBtn").show();
		jQuery("#ftpInfo").show();
	}
});

function toggleAutoSR(obj,samePair){
	if(jQuery(obj).attr("checked")){
		showEle(samePair);
	}else{
		hideEle(samePair);
	}
}

function doSave() {
	if(check_form($GetEle("frmMain"), 'serverURL,serverPort,serverUser,serverPwd')) {
		$GetEle("frmMain").submit();
		enableAllmenu();
	}
}
function doTestFtp(){
	jQuery.ajax({
		url:"/workflow/workflow/officalwf_operation.jsp",
		data:{
			serverURL:jQuery("#serverURL").val(),
			serverPort:jQuery("#serverPort").val(),
			serverUser:jQuery("#serverUser").val(),
			serverPwd:jQuery("#serverPwd").val(),
			operation:"testFtp"
		},
		dataType:"json",
		type:"post",
		beforeSend:function(){
			e8showAjaxTips("<%=SystemEnv.getHtmlLabelName(33478,user.getLanguage())%>",true);
		},
		success:function(data){
			if(data.result==1){
				top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32359,user.getLanguage())%>");
			}else{
				top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32296,user.getLanguage())%>");
			}
		},
		complete:function(xhr){
			e8showAjaxTips("",false);
		}
	});
}
function onShowCatalogData(event,datas,name,paras){
     if (datas != null)  {
         var mainid = datas.mainid;
         var subid = datas.subid;
         if(!mainid)mainid = -1;
         if(!subid)subid = -1;
         $GetEle("maincategory").value=mainid;
         $GetEle("subcategory").value=subid;
     }
     else{
         $GetEle("maincategory").value="";
         $GetEle("subcategory").value="";
     }
}
function onShowCatalog(spanName) {
    var result = showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategorySingleBrowser.jsp", "", "dialogWidth:550px;dialogHeight:550px;");
    if (result != null) {
        if (result != null)  {
            spanName.innerHTML=wuiUtil.getJsonValueByIndex(result, 2);
            $GetEle("pathcategory").value = wuiUtil.getJsonValueByIndex(result, 2);
            $GetEle("maincategory").value=wuiUtil.getJsonValueByIndex(result, 3);
            $GetEle("subcategory").value=wuiUtil.getJsonValueByIndex(result, 4);
            $GetEle("seccategory").value=wuiUtil.getJsonValueByIndex(result, 1);
        }
        else{
            spanName.innerHTML="";
            $GetEle("pathcategory").value="";
            $GetEle("maincategory").value="";
            $GetEle("subcategory").value="";
            $GetEle("seccategory").value="";
        }
    }
}
</script>
