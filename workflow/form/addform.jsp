<!DOCTYPE html>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/browser" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<jsp:useBean id="FormManager" class="weaver.workflow.form.FormManager" scope="session"/>
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<html>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.bgiframe.min_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.ajaxQueue_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/jquery.autocomplete_wev8.css" />
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/browser_wev8.css" />
<script language=javascript src="/js/weaver_wev8.js"></script>

<%
	String formRightStr = "FormManage:All";
	int isFromMode = Util.getIntValue(request.getParameter("isFromMode"),0);
	if(isFromMode==1){
		formRightStr = "FORMMODEFORM:ALL";
	}
	
	if(!HrmUserVarify.checkUserRight(formRightStr, user))
	{
		response.sendRedirect("/notice/noright.jsp");
		
		return;
	}
%>

<%
    String ajax=Util.null2String(request.getParameter("ajax"));
    int isformadd = Util.getIntValue(request.getParameter("isformadd"),0);
    String isadd = Util.null2String(request.getParameter("isadd"));
    String dialog = Util.null2String(request.getParameter("dialog"));
    String isclose = Util.null2String(request.getParameter("isclose"));
    String isoldform = Util.null2String(request.getParameter("isoldform"));
    String appid = Util.null2String(request.getParameter("appid"));
%>

</head>
<%

	String type="";
	String formname="";
	String formdes="";
	int formid=0;
    String subCompanyId2 = "";
    String subCompanyId3 = "";
	formid=Util.getIntValue(Util.null2String(request.getParameter("formid")),0);
	type = Util.null2String(request.getParameter("src"));

    int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
    if(isFromMode==1){
    	detachable=Util.getIntValue(String.valueOf(session.getAttribute("fmdetachable")),0);
    }
    int subCompanyId= -1;
    int operatelevel=0;
    String tablename="";

	if(type=="")
		type = "addform";
	if(!type.equals("addform")){
		FormManager.setFormid(formid);
		FormManager.getFormInfo();
		formname=FormManager.getFormname();
        subCompanyId2 = ""+FormManager.getSubCompanyId2() ;
        subCompanyId3 = ""+FormManager.getSubCompanyId3() ;
		formdes=FormManager.getFormdes();
	}
	if(detachable==1){
    	if(isFromMode==1){
	        subCompanyId=Util.getIntValue(subCompanyId3,-1);
    	}else{
	        subCompanyId=Util.getIntValue(subCompanyId2,-1);
    	}
        if(subCompanyId == -1){
            subCompanyId=Util.getIntValue(String.valueOf(session.getAttribute("managefield_subCompanyId")),-1);
	        subCompanyId3=Util.null2String(String.valueOf(session.getAttribute("defaultSubCompanyId")),"-1");
	        if(subCompanyId < 0){
	            if(user.getUID() == 1){
	   	   	         RecordSet.executeProc("SystemSet_Select","");
	   	   	         if(RecordSet.next()){
	   	   	      		 subCompanyId = Util.getIntValue(RecordSet.getString("wfdftsubcomid"),0);
	   	   	         }
	            }else{
	                String hasRightSub = SubCompanyComInfo.getRightSubCompany(user.getUID(),"WorkflowManage:All",0);
	         	   if(!"".equals(hasRightSub)){
	         	      subCompanyId = Util.getIntValue(hasRightSub.split(",")[0]);
	         	   }
	            }
	        }
        }
        if(isFromMode==1){
        	 if(!subCompanyId3.equals("-1")){
		        operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),formRightStr,Util.getIntValue(subCompanyId3));
        	}else{
		        operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),formRightStr,subCompanyId);
        	}
        }else{
	        operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),formRightStr,subCompanyId);
        }
    }else{
        if(HrmUserVarify.checkUserRight(formRightStr, user))
            operatelevel=2;
    }
    if(subCompanyId == 0){
    	subCompanyId2 = "";
    	subCompanyId3 = "";
    }else {
    	subCompanyId2 = ""+subCompanyId;
    	if(isFromMode==1){
    		if(subCompanyId3.equals("-1")){
		    	subCompanyId3 = ""+subCompanyId;
    		}
    	}else{
	    	subCompanyId3 = ""+subCompanyId;
    	}
    }
    
	if(operatelevel < 0){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}

String message = Util.null2String(request.getParameter("message"));
if("issamename".equals(message)){ 
    message = SystemEnv.getHtmlLabelName(22750,user.getLanguage());
}
if("issametablename".equals(message)){
	message = SystemEnv.getHtmlLabelName(83147, user.getLanguage());
}

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(699,user.getLanguage())+":";
String needfav ="";
if(!ajax.equals("1"))
{
needfav ="1";
}
String needhelp ="";
if(type.equals("addform"))	titlename+=SystemEnv.getHtmlLabelName(611,user.getLanguage());
else titlename+=SystemEnv.getHtmlLabelName(93,user.getLanguage());
	
	String from = Util.null2String(request.getParameter("from"));
	
boolean candelete = true;
RecordSet.executeSql("select * from workflow_base where formid="+formid);
if(RecordSet.next()) candelete = false;
RecordSet.executeSql(" select namelabel from workflow_bill where id="+formid);
int namelabel=0;
if(RecordSet.next()){
	namelabel=RecordSet.getInt("namelabel");
}
%>  
<script type="text/javascript">
	
</script>
<body>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<form name="addformtabspecial" method="post" action="/workflow/form/form_operation.jsp" >
<%if(isformadd==1 && ajax.equals("1") && !type.equals("addform")){%>
<iframe src="/workflow/form/FormIframe.jsp?formname=<%=formname%>&formid=<%=formid%>" width=0 height=0></iframe>
<%}%>
<input type="hidden" value="<%=appid %>" name="appid">
<input type="hidden" value="<%=type%>" name="src">
<input type="hidden" value="<%=formid%>" name="formid">
<input type="hidden" value="<%=formid%>" name="delete_form_id">
<input type=hidden name="ajax" value="<%=ajax%>">
<input type="hidden" value="<%=isformadd%>" name="isformadd">
<input type="hidden" value="<%=from%>" name="from">
<input type="hidden" value="<%=isFromMode%>" name="isFromMode">
<input type="hidden" value="<%=dialog %>" name="dialog">
<input type="hidden" value="<%=isoldform %>" name="isoldform">
<input type="hidden" name="saveOrSet">
<%
    if(operatelevel>0){
        if(!ajax.equals("1"))
        RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(this),_self}" ;
        else if(from.equals("addDefineForm")){
        	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:addformtabsubmit1(this),_self}" ;
	    }else{
	        RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:addformtabsubmit1(this),_self}" ;
        }
	      RCMenuHeight += RCMenuHeightStep ;
    }
    if(type.equals("editform")&&operatelevel>0){
				if(formid != 14){
	        //RCMenu += "{"+SystemEnv.getHtmlLabelName(15449,user.getLanguage())+",addformfield.jsp?formid="+formid+",_self}" ;
	        //RCMenuHeight += RCMenuHeightStep ;
				}
				
        //RCMenu += "{"+SystemEnv.getHtmlLabelName(15450,user.getLanguage())+",addformfieldlabel.jsp?formid="+formid+",_self}" ;
        //RCMenuHeight += RCMenuHeightStep ;
        
				if(formid != 14){
        //RCMenu += "{"+SystemEnv.getHtmlLabelName(18368,user.getLanguage())+",addformrowcal.jsp?formid="+formid+",_self}" ;
        //RCMenuHeight += RCMenuHeightStep ;
        }
				if(formid != 14){
        //RCMenu += "{"+SystemEnv.getHtmlLabelName(18369,user.getLanguage())+",addformcolcal.jsp?formid="+formid+",_self}" ;
        //RCMenuHeight += RCMenuHeightStep ;
				}
        if(formid != 14 && candelete){
            RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:deleteform(),_self}" ;
            RCMenuHeight += RCMenuHeightStep ;
        }
    }
    //if(!ajax.equals("1"))
    //RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",manageform.jsp,_self}" ;
    //else
    //RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:addformtabretun(),_self}" ;
    //RCMenuHeight += RCMenuHeightStep ;
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td></td>
			<td class="rightSearchSpan" style="text-align:right; width:500px!important">
				<%if(operatelevel > 0){ %>
    			<input type="button" value="<%=SystemEnv.getHtmlLabelName(30986, user.getLanguage()) %>" id="zd_btn_submit" class="e8_btn_top" onclick="javascript:addformtabsubmit1(this)">
    			<%if(!isoldform.equals("1")){%>
    			<input type="button" value="<%=SystemEnv.getHtmlLabelName(32159, user.getLanguage()) %>" id="zd_btn_submit" class="e8_btn_top" onclick="javascript:addformtabsubmitSaveOrSet(this)">				
				<%}}%>
				<span title="<%=SystemEnv.getHtmlLabelName(81804 , user.getLanguage())%>" class="cornerMenu"></span>
			</td>
		</tr>
</table>  
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<tr>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">
		<font color=red><%=message%></font>
		<wea:layout type="twoCol">
		    <wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
		    	<wea:item><%=SystemEnv.getHtmlLabelName(15451,user.getLanguage())%></wea:item>
			    <wea:item> 
			        <%if(operatelevel>0){%>
				    	<input type="text" name="formname" class=Inputstyle style="width:260px;" value="<%=Util.toScreenToEdit(formname,user.getLanguage())%>"
				    	onChange="checkinput('formname','formnamespan')" maxlength="200">
				    	<span id=formnamespan><%if(formname.equals("")){%><IMG src="/images/BacoError_wev8.gif" align=absMiddle><%}%></span>
				    <%} else {%>
				    	<%=Util.toScreen(formname,user.getLanguage())%>
				    <%}%>
			    </wea:item>
			     <%if(isFromMode == 1){ %>
		    	<wea:item><%=SystemEnv.getHtmlLabelName(15190, user.getLanguage()) %></wea:item>
		    	<wea:item>
		    		 <%if("addform".equals(type)){//新建表单时 %>
				    	uf_<input type="text" name="tablename" id="tablename" class=Inputstyle style="width:243px;" value="" onChange="checkinput('tablename','tablenamespan');checktablename();" maxlength="16" >
				    	<span id="tablenamespan"><%if(tablename.equals("")){%><IMG src="/images/BacoError_wev8.gif" align=absMiddle><%}%></span>
				    	<span id="tablenamecheckspan"></span>
				    <%} else {%>
				    	<%=tablename%>
				    <%}%>
		    	</wea:item>
		    	 <%} %>
		    	<%//选择已有表单，只有新建表单时才有。TD10835
				if("addform".equals(type)){
				%>
		    	<wea:item><%=SystemEnv.getHtmlLabelName(23946,user.getLanguage())%></wea:item>
		    	<wea:item>
		    		<%if(operatelevel>0){%>
		    		<%if(isFromMode==1){%>
				        <brow:browser viewType="0" name="oldformid" browserValue="" 
		  		 		browserUrl="/systeminfo/BrowserMain.jsp?url=/formmode/setup/FormBrowser.jsp"
								hasInput="true" isSingle="true" hasBrowser = "true" isMustInput="1"
								completeUrl="/data.jsp?type=mdFormBrowser&rightStr=ModeSetting:All" linkUrl=""  width="260px"
								browserDialogWidth="510px"
								browserSpanValue=""
								></brow:browser>
		    		 <%}else{%>
						<brow:browser name="oldformid" viewType="0" hasBrowser="true" hasAdd="false" 
				                  browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/wfFormBrowser.jsp?isbill=0" isMustInput="1" isSingle="true" hasInput="true"
				                  completeUrl="/data.jsp?type=wfFormBrowser&isbill=0"  width="260px" browserValue="" browserSpanValue="" />
		    		 <%}%>
	                <%}%>
		    	</wea:item>
		    	<%}%>
		    	<%if(detachable==1){%> 
			    	<wea:item><%=SystemEnv.getHtmlLabelName(17868,user.getLanguage())%></wea:item>
			    	<wea:item>
			    	<%
			    		if(operatelevel > 0){
			    		    if(isFromMode==1){%>
			    		      	<brow:browser name="subcompanyid3" viewType="0" hasBrowser="true" hasAdd="false" 
			                  		browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser2.jsp?rightStr=FORMMODEFORM:ALL&selectedids="  isMustInput="2" isSingle="true" hasInput="true"
			                  		completeUrl="/data.jsp?type=164_1&rightStr=FORMMODEFORM:ALL"  width="260px" browserValue='<%=subCompanyId3%>' browserSpanValue='<%=SubCompanyComInfo.getSubCompanyname(subCompanyId3)%>' />	    	    
			    		    <%}else{%>
		      					<brow:browser name="subcompanyid" viewType="0" hasBrowser="true" hasAdd="false" 
			                 		browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser2.jsp?rightStr=FormManage:All&isedit=1&selectedids=" isMustInput='2' isSingle="true" hasInput="true"
			                  		completeUrl="/data.jsp?type=164&show_virtual_org=-1"  width="260px" browserValue='<%=subCompanyId2%>' browserSpanValue='<%=SubCompanyComInfo.getSubCompanyname(subCompanyId2)%>' />	    	    
			    		    <%}
			    		}else{
			    		    if(isFromMode==1){%>
			    		      	<brow:browser name="subcompanyid3" viewType="0" hasBrowser="true" hasAdd="false" 
			                  		browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser2.jsp?rightStr=FORMMODEFORM:ALL&selectedids="  isMustInput="0" isSingle="true" hasInput="true"
			                  		completeUrl="/data.jsp?type=164_1&rightStr=FORMMODEFORM:ALL"  width="260px" browserValue='<%=subCompanyId3%>' browserSpanValue='<%=SubCompanyComInfo.getSubCompanyname(subCompanyId3)%>' />	    	    
			    		    <%}else{%>
		      					<brow:browser name="subcompanyid" viewType="0" hasBrowser="true" hasAdd="false" 
		                 			browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser2.jsp?rightStr=WorkflowManage:All&selectedids=" isMustInput='0' isSingle="true" hasInput="true"
		                  			completeUrl="/data.jsp?type=164_1&rightStr=FORMMODEFORM:ALL"  width="260px" browserValue='<%=subCompanyId2%>' browserSpanValue='<%=SubCompanyComInfo.getSubCompanyname(subCompanyId2)%>' />	    	    
			    		    <%}
			    		}
			    	%>
		    	</wea:item>
		    	<%}%>
		    	<wea:item><%=SystemEnv.getHtmlLabelName(15452,user.getLanguage())%></wea:item>
		    	<wea:item>
		    		    <%if(operatelevel>0){%>
					    <textarea rows="3" name="formdes" cols="40" class=Inputstyle style="resize:none;margin-top: 2px;margin-bottom: 2px;"><%=Util.toScreenToEdit(formdes,user.getLanguage())%></textarea>
					    <%} else {%>
					    	<%=Util.toScreen(formdes,user.getLanguage())%>
					    <%}%>
		    	</wea:item>
		    </wea:group>
		</wea:layout>
	</td>
		</tr>
		</TABLE>
	</td>
</tr>
</table>
</form>
<script type="text/javascript">
try{
	var formnametp = "<%=Util.toScreenToEdit(formname,user.getLanguage()) %>";
	if(formnametp=="") formnametp = SystemEnv.getHtmlLabelName(82021, user.getLanguage());
	parent.parent.setTabObjName(formnametp);
}catch(e){}

var dialog = null;
var parentWin = null;
try{
 dialog = parent.parent.getDialog(parent);
 parentWin = parent.parent.getParentWindow(parent);
}catch(e){}
if("<%=dialog%>"==1){
	  function btn_cancle(){
		parentWin.closeDialog();
	 }
}

function wfAddReturnJSON(){			//创建流程时创建表单保存需返回json
	var result=true;
	var parentLoc=parentWin.location+"";
	//qc162558 增加了hrmAttProcSet考勤流程设置中调用
	if(parentLoc.indexOf("addwf0.jsp")!=-1 || parentLoc.indexOf("hrmAttProcSet")!=-1){			
		if(dialog){
			dialog.callback({id:"<%=formid %>",name:"<%=SystemEnv.getHtmlLabelName(namelabel,user.getLanguage()) %>"});
		}
		result=false;
	}
	if("<%=isFromMode%>" == 1){
	    try{
			parentWin.createFormCallBackFun("<%=formid%>","<%=SystemEnv.getHtmlLabelName(namelabel,user.getLanguage())%>");
		}catch(e){}
    }
	return result;
}

if("<%=isclose%>"==1){
	if("<%=isadd%>"=="true"){
	  	diag_vote = new window.top.Dialog();
      	diag_vote.currentWindow = window;
      	diag_vote.Width = 1020;
      	diag_vote.Height = 580;
      	diag_vote.Modal = true;
     	diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(82022, user.getLanguage())%>";
      	diag_vote.URL = "/workflow/form/addDefineForm.jsp?formid=<%=formid%>&isFromMode=<%=isFromMode%>&ajax=<%=ajax%>";
      	diag_vote.isIframe=false;   	
      	diag_vote.show();
      	wfAddReturnJSON();
	}else{
		if ("<%=isFromMode%>" == 1) {
			//window.parent.close();
			if(typeof(parentWin.refreshWithFormCreated)=="function"){
				parentWin.refreshWithFormCreated("<%=formid%>");
			}
			try{
				parentWin.createFormCallBackFun("<%=formid%>","<%=SystemEnv.getHtmlLabelName(namelabel,user.getLanguage())%>");
			}catch(e){}
		} else {
			if(wfAddReturnJSON()){
				parentWin.location="/workflow/form/manageform.jsp";
			}
		}
	}
	dialog.close();
}

function onShowOldFormid(inputName,spanName){
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/wfFormBrowser.jsp?isbill=0");
	if (datas){
		if (datas.id!=""){
			$(inputName).val(datas.id);
			$(spanName).html(datas.name);			
		}else{
			$(spanName).html( "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
			$(inputName).val( "");
		}
	}
}
function ajaxinit(){
    var ajax=false;
    try {
        ajax = new ActiveXObject("Msxml2.XMLHTTP");
    } catch (e) {
        try {
            ajax = new ActiveXObject("Microsoft.XMLHTTP");
        } catch (E) {
            ajax = false;
        }
    }
    if (!ajax && typeof XMLHttpRequest!='undefined') {
    ajax = new XMLHttpRequest();
    }
    return ajax;
}

/**
 * 设置同步，提交前需传入要执行的函数，把提交动作放在ajax返回成功后执行
 * @param {Object} successFun
 * @return {TypeName} 
 */
function checktablename(successFun){
	var $tablenamecheckspan = jQuery("#tablenamecheckspan");
	$tablenamecheckspan.removeClass("tablenameCheckLoading");
	$tablenamecheckspan.removeClass("tablenameCheckError");
	$tablenamecheckspan.removeClass("tablenameCheckSuccess");
	var tablename = document.getElementById("tablename");
	var tablenameVal = jQuery.trim(tablename.value);
	var statusFlag = false;
	if(tablenameVal != ""){
		$tablenamecheckspan.html("");
		tablenameVal = "uf_" + tablenameVal;
		var rep = /[^\w]/ig;
		if(rep.test(tablenameVal)){
			$tablenamecheckspan.addClass("tablenameCheckError");
	        $tablenamecheckspan.html("<%=SystemEnv.getHtmlLabelName(21900, user.getLanguage())%> "+tablenameVal+" <%=SystemEnv.getHtmlLabelName(129050, user.getLanguage())%><b><%=SystemEnv.getHtmlLabelName(129051, user.getLanguage())%></b>");
	        tablename.value = "";
			return false;
		}
		$tablenamecheckspan.addClass("tablenameCheckLoading");
		$tablenamecheckspan.html("正在验证表名...");
		tablename.disabled = true;
		var $rightMenuBtn = null;
		try{
			var rightMenuFrameDoc = jQuery("#rightMenu iframe")[0].contentWindow.document;
			$rightMenuBtn = jQuery("button", rightMenuFrameDoc);
			$rightMenuBtn.attr("disabled", true);
		}catch(e){}
		
		jQuery.ajax({
		   type: "POST",
		   url: "/formmode/setup/formSettingsAction.jsp",
		   data: "action=checktablename&tablename="+tablenameVal,
		   async: true,//同步请求
		   success: function(data){
	            try{
	            	if(data == "-1"){
	            		$tablenamecheckspan.addClass("tablenameCheckSuccess");
	            		$tablenamecheckspan.html("验证通过");
	            		statusFlag = true;
	            	}else{
	            		statusFlag = false;
	            		$tablenamecheckspan.addClass("tablenameCheckError");
	            		var errorMsg = "<%=SystemEnv.getHtmlLabelName(21900, user.getLanguage())%> "+tablenameVal+" <%=SystemEnv.getHtmlLabelName(129050, user.getLanguage())%>";
	            		if(data == "0"){
	            			errorMsg += "<b><%=SystemEnv.getHtmlLabelName(129053, user.getLanguage())%> </b>";
	            		}else if(data == "1"){
	            			errorMsg += "<b><%=SystemEnv.getHtmlLabelName(129054, user.getLanguage())%></b>";
	            		}else if(data == "2"){
	            			errorMsg += "<b><%=SystemEnv.getHtmlLabelName(129051, user.getLanguage())%></b>";
	            		}else{
	            			errorMsg += "<b><%=SystemEnv.getHtmlLabelName(463, user.getLanguage())%></b>";
	            		}
	            		$tablenamecheckspan.html(errorMsg);
	            		tablename.value = "";
	            	}
	            }catch(e){
	            	statusFlag = false;
	            }
	        tablename.disabled = false;
	        try{
	        	$rightMenuBtn.attr("disabled", false);
	        }catch(e){}
	        
	        if(statusFlag&&typeof(successFun)=="function"){//当验证通过后，再执行提交动作
	        	successFun();
	        }
	        
		   }
		});
	     
	}
	return statusFlag;
}
</script>
<%
if(!ajax.equals("1")){
%>
<script language="javascript">
function submitData(obj)
{
	if (check_form(addformtabspecial,'formname,subcompanyid')){
		addformtabspecial.submit();
        obj.disabled=true;
    }
}
function deleteform(){
    addformtabspecial.action = "/workflow/form/delforms.jsp";
    addformtabspecial.submit();
}
</script>
<%}else{%>
<script type="text/javascript">
var submitObj;
function addformtabsubmit1(obj){
	submitObj = obj;
	<%if(isFromMode == 1){ %>
		checktablename(addformtabsubmit1Aft);
	<%}else{%>
		addformtabsubmit1Aft()
	<%}%>
	//if(check_form(addformtabspecial,'formname,subcompanyid,tablename')){}
}

function addformtabsubmit1Aft(){
		var obj = submitObj;
		var checkstr = "formname,tablename";
		
		<%if(detachable==1 && operatelevel > 0){ %>
			<%if(isFromMode == 1){%>
				checkstr+=",subcompanyid3";
			<%}else{%>
				checkstr+=",subcompanyid";
			<%}
		}%>
		if(check_form(addformtabspecial,checkstr)){
	    	$G("saveOrSet").value='0';
			obj.disabled=true;
			addformtabspecial.submit();
		}
}

function addformtabsubmitSaveOrSet(obj){
	submitObj = obj;
	<%if(isFromMode == 1){ %>
		checktablename(addformtabsubmitSaveOrSetAft);
	<%}else{%>
		addformtabsubmitSaveOrSetAft();
	<%}%>
}

function addformtabsubmitSaveOrSetAft(){
	var obj = submitObj;
	var checkstr = "formname,tablename";
	
	<%if(detachable==1 && operatelevel > 0){ %>
		<%if(isFromMode == 1){%>
			checkstr+=",subcompanyid3";
		<%}else{%>
			checkstr+=",subcompanyid";
		<%}
	}%>
	if(check_form(addformtabspecial,checkstr)){
	    $G("saveOrSet").value='1';
		obj.disabled=true;
		addformtabspecial.submit();
	}
}


function addformtabretun(){
	//history.back(-1);
	
	dialog.close();
}
</script>
<%} %>
</body>
</html>
