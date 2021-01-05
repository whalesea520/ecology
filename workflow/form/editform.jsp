<!DOCTYPE html>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/browser" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.workflow.workflow.UserWFOperateLevel" %>
<jsp:useBean id="FormManager" class="weaver.workflow.form.FormManager" scope="session"/>
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<html>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>

<%
String formRightStr = "FormManage:All";
int isFromMode = Util.getIntValue(request.getParameter("isFromMode"),0);
if(isFromMode==1){
	formRightStr = "FORMMODEFORM:ALL";
}
String isclose = Util.null2String(request.getParameter("isclose"));
int formid=Util.getIntValue(Util.null2String(request.getParameter("formid")),0);
int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
int isbill=Util.getIntValue(Util.null2String(request.getParameter("isbill")),-1);
int operateLevel = UserWFOperateLevel.checkWfFormOperateLevel(detachable,user,formRightStr,formid,isbill);

	if(!"1".equals(isclose)){
		if(!HrmUserVarify.checkUserRight(formRightStr, user) || operateLevel < 0){
			response.sendRedirect("/notice/noright.jsp");
			return;
		}
	}

    String ajax=Util.null2String(request.getParameter("ajax"));
    int isformadd = Util.getIntValue(request.getParameter("isformadd"),0);
    String dialog = Util.null2String(request.getParameter("dialog"));
    String isValue = Util.null2String(request.getParameter("isValue"));
%>
<!-- add by xhheng @20050204 for TD 1538-->
<script language=javascript src="/js/weaver_wev8.js"></script>
</head>
<%

	String type="";
	String formname="";
	String formdes="";
	
    String subCompanyId2 = "";
    String subCompanyId3 = "";
	
	
	RecordSet.executeSql("select isvirtualform from ModeFormExtend where formid="+formid);
	int isvirtualform = 0;
	if(RecordSet.next()){
		isvirtualform = RecordSet.getInt("isvirtualform");
	}
	
    if(isFromMode==1){
    	detachable=Util.getIntValue(String.valueOf(session.getAttribute("fmdetachable")),0);
    }
    int subCompanyId= -1;
    int operatelevel=0;
    String tablename="";
 
	RecordSet.executeSql("select * from workflow_bill where id="+formid);
	if(RecordSet.next()){
		formname = Util.null2String(SystemEnv.getHtmlLabelName(RecordSet.getInt("namelabel"),user.getLanguage()));
		formname = formname.replaceAll("<","＜").replaceAll(">","＞").replaceAll("'","''");
		formdes = RecordSet.getString("formdes");
		formdes = formdes.replaceAll("<","＜").replaceAll(">","＞").replaceAll("'","''");
		subCompanyId = RecordSet.getInt("subcompanyid");
		subCompanyId2 = ""+subCompanyId;
		subCompanyId3 = RecordSet.getString("subcompanyid3");
		tablename = RecordSet.getString("tablename");
	}

boolean candelete = true;
RecordSet.executeSql("select * from workflow_base where formid="+formid);
if(RecordSet.next()) candelete = false;

RecordSet.executeSql("select * from modeinfo where formid="+formid);
if(RecordSet.next()) candelete = false;

if(isvirtualform==1){
	candelete = false;
}
    if(detachable==1){  
        //subCompanyId=Util.getIntValue(String.valueOf(session.getAttribute("managefield_subCompanyId")),-1);
        if(isFromMode==1){
	        if(subCompanyId3.equals("")){
	        	subCompanyId3 = ""+user.getUserSubCompany1();
	        }
	        operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),formRightStr,Util.getIntValue(subCompanyId3,-1));
        }else{
	        operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),formRightStr,subCompanyId);
        }
    }else{
        if(HrmUserVarify.checkUserRight(formRightStr, user))
            operatelevel=2;
    }

if(operatelevel<2){//无完全控制权限，不能删除
	candelete = false;
}
String message = Util.null2String(request.getParameter("message"));
if("issamename".equals(message)){ 
    message = SystemEnv.getHtmlLabelName(22750,user.getLanguage());
}  
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(699,user.getLanguage())+":";
String needfav ="";
if(!ajax.equals("1")){
needfav ="1";
}
String needhelp ="";
titlename+=SystemEnv.getHtmlLabelName(93,user.getLanguage());

String countSql = "select count(1) as num from modeinfo where formid="+formid;
RecordSet.executeSql(countSql);
int count = 0;
if(RecordSet.next()){//删除主表
	count = RecordSet.getInt("num");
}
%>  
<body style="overflow-y:hidden;">
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<form name="addformtabspecial" method="post" action="/workflow/form/form_operation.jsp" >
<!--<iframe src="/workflow/form/FormIframe0.jsp?formname=<%=formname%>&formid=<%=formid%>" width=0 height=0></iframe>-->
<input type="hidden" value="eidtform" name="src">
<input type="hidden" value="<%=formid%>" name="formid">
<input type="hidden" value="<%=formid%>" name="delete_newform_id">
<input type=hidden name="ajax" value="<%=ajax%>">
<input type="hidden" value="<%=dialog %>" name="dialog">
<input type="hidden" value="<%=isFromMode %>" name="isFromMode">
<%if(detachable==0){%>
<input type="hidden" value="<%=subCompanyId2 %>" name="subcompanyid">
<input type="hidden" value="<%=subCompanyId2 %>" name="subcompanyid3">
<%}%>
<%
    if(operatelevel>0){
    	if(ajax.equals("1"))
        RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:addformtabsubmit0(this),_self}" ;
        RCMenuHeight += RCMenuHeightStep ;
    }
    if(ajax.equals("1")){
	    //RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:addformtabretun(),_self}" ;
	    //RCMenuHeight += RCMenuHeightStep ;
	    if(candelete){
	        RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:deleteform(),_self}" ;
	        RCMenuHeight += RCMenuHeightStep ;
	    }
	  }
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<font color=red><%=message%></font>
<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td></td>
			<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<%
			if (operatelevel > 0) {
			%>
    			<input type="button" value="<%=SystemEnv.getHtmlLabelName(30986, user.getLanguage()) %>" id="zd_btn_submit" class="e8_btn_top" onclick="javascript:addformtabsubmit0(this)">
    			
    			<%} %>
    			<%if(candelete){%> 
    			<input type="button" value="<%=SystemEnv.getHtmlLabelName(91, user.getLanguage()) %>" id="zd_btn_submit" class="e8_btn_top" onclick="deleteform()">				
				<%} %>
				<span title="<%=SystemEnv.getHtmlLabelName(81804, user.getLanguage()) %>" class="cornerMenu"></span>
			</td>
		</tr>
</table>
<wea:layout type="twoCol">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(324,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(15451,user.getLanguage())%></wea:item>
		<wea:item>
			<wea:required id="formnamespan" required="true" value='<%=formname%>'>
		    	<input type="text" name="formname" class=Inputstyle size=40 value="<%=Util.toScreenToEdit(formname,user.getLanguage())%>" onChange="checkinput('formname','formnamespan')" maxlength="200">
	    	</wea:required>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(15190, user.getLanguage()) %></wea:item>
		<wea:item><%=tablename %></wea:item>
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
	                 			completeUrl="/data.jsp?type=wfFormBrowser&isbill=0"  width="260px" browserValue='<%=subCompanyId2%>' browserSpanValue='<%=SubCompanyComInfo.getSubCompanyname(subCompanyId2)%>' />	    	    
	    		    <%}
	    		}
	    	%>
	   		</wea:item>
	   	<%}%>
		<wea:item><%=SystemEnv.getHtmlLabelName(15452,user.getLanguage())%></wea:item>
		<wea:item>
			<%if(operatelevel>0){%>
		    <textarea rows="3" name="formdes" class=Inputstyle cols="40" style="resize:none;margin-top: 2px;margin-bottom: 2px;"><%=Util.toScreenToEdit(formdes,user.getLanguage())%></textarea>
		    <%} else {%>
		    	<%=Util.toScreen(formdes,user.getLanguage())%>
		    <%}%>
		</wea:item>
	</wea:group>
</wea:layout>
</form>
<%
if(!ajax.equals("1")){
%>
<script language="javascript">
function submitData(obj)
{
	if (check_form(addformtabf,'formname,subcompanyid')){
		addformtabf.submit();
        obj.disabled=true;
    }
}
</script>
<%} else {%>
<script type="text/javascript">
function addformtabsubmit0(obj){
	var checkstr = "formname";
	<%if(detachable==1 && operatelevel > 0){ %>
		<%if(isFromMode == 1){%>
			checkstr+=",subcompanyid3";
		<%}else{%>
			checkstr+=",subcompanyid";
		<%}
	}%>
	if(check_form(addformtabspecial,checkstr)){
		addformtabspecial.submit();
        obj.disabled=true;
	}
}
</script>
<%} %>
<script type="text/javascript">

function addformtabretun(){
	window.parent.parent.location ="/workflow/form/manageformTab.jsp?ajax=1";
}

if("<%=dialog%>"==1){
	var dialog = parent.getDialog(window);
	var parentWin = parent.getParentWindow(window);
	  function btn_cancle(){
		parentWin.closeDialog();
	 }
}

if("<%=isclose%>"==1){
		var dialog = parent.parent.getDialog(window);
		var parentWin = parent.parent.getParentWindow(window);
		if("<%=isValue%>" == 1){
		 parent.parentWin.location="/workflow/form/manageform.jsp";
		}
		//parent.parentWin.closeDialog();
		parent.dialog.close();
}

function adfonShowSubcompany(){
	 datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser2.jsp?rightStr=WorkflowManage:All&isedit=1&selectedids="+$GetEle("subcompanyid").value);
	 issame = false;
	 if(datas){
		 if(datas.id!="0"&&datas.id!=""){
			 if(datas.id ==  $GetEle("subcompanyid").value){
			  issame = true;
			 }
			 $GetEle("subcompanyspan1").innerHTML = datas.name;
			 $GetEle("subcompanyid").value=datas.id;
		 }else{
			 $GetEle("subcompanyspan1").innerHTML = "";
			 $GetEle("subcompanyid").value="";
		 }
	 }
}

function deleteform(){
	if(<%=count%>>0){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(82105, user.getLanguage())%>");
		return;
	}
    var formidValue = "<%=formid%>";
    var oldformids = "";
	var newformids = "";
	if(formidValue > 0){
	   oldformids = formidValue;
	}else{
	   newformids =formidValue;
	}
	if(oldformids=="" && newformids=="") return ;
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function (){
				addformtabspecial.action = "/workflow/form/delforms.jsp?oldformids="+oldformids+"&newformids="+newformids+"dialog=1";
				addformtabspecial.submit();}, function () {}, 320, 90,true);
}

</script>
</body>
</html>
