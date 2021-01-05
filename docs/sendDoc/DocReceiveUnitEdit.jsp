
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.file.Prop" %>
<%@ page import="java.text.DecimalFormat" %>

<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DocReceiveUnitComInfo" class="weaver.docs.senddoc.DocReceiveUnitComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />

<%
String rightStr = "SRDoc:Edit";
boolean onlyRead = false;
if(!HrmUserVarify.checkUserRight(rightStr, user)){
    /*response.sendRedirect("/notice/noright.jsp");
    return;*/
    onlyRead = true;
}

%>

<%
String receiveUnitId=Util.null2String(request.getParameter("id"));

String receiveUnitName=DocReceiveUnitComInfo.getReceiveUnitName(receiveUnitId);
int superiorUnitId = Util.getIntValue(DocReceiveUnitComInfo.getSuperiorUnitId(receiveUnitId),0);
String receiverIds = DocReceiveUnitComInfo.getReceiverIds(receiveUnitId);
double showOrder_d = Util.getDoubleValue(DocReceiveUnitComInfo.getShowOrder(receiveUnitId));
DecimalFormat df = new DecimalFormat("#.00");
String showOrder = df.format(showOrder_d);
int subcompanyid = Util.getIntValue(DocReceiveUnitComInfo.getSubcompanyid(receiveUnitId),0);
String subcompanyname = SubCompanyComInfo.getSubCompanyname(""+subcompanyid);
String companyType = DocReceiveUnitComInfo.getCompanyType(receiveUnitId);
String changeDir = DocReceiveUnitComInfo.getChangeDir(receiveUnitId);
String isMain = DocReceiveUnitComInfo.getIsMain(receiveUnitId);
Prop prop = Prop.getInstance();
//boolean docchangeEnabled = Util.null2String(prop.getPropValue("DocChange", "Enabled")).equals("Y");
String strDocChgEnabled = Util.null2String(prop.getPropValue("DocChange", "Enabled"));
boolean docchangeEnabled = false;
if("Y".equalsIgnoreCase(strDocChgEnabled) || "1".equals(strDocChgEnabled)) {
    docchangeEnabled = true;
}
String canStartChildRequest = Util.null2String(DocReceiveUnitComInfo.getCanStartChildRequest(receiveUnitId));

String changetype = Util.null2String(request.getParameter("changetype"));
int changeid = Util.getIntValue(request.getParameter("changeid"), 0);
if(!"".equals(changetype)){
	if("0".equals(changetype)){
		superiorUnitId = changeid;
		subcompanyid = Util.getIntValue(DocReceiveUnitComInfo.getSubcompanyid(""+superiorUnitId), 0);
		subcompanyname = SubCompanyComInfo.getSubCompanyname(""+subcompanyid);
	}else if("1".equals(changetype)){
		subcompanyid = Util.getIntValue(request.getParameter("subcompanyid"),0);
		subcompanyname = SubCompanyComInfo.getSubCompanyname(""+subcompanyid);
		int supSubcompanyid = Util.getIntValue(DocReceiveUnitComInfo.getSubcompanyid(""+superiorUnitId), 0);
		if(supSubcompanyid != subcompanyid){
			superiorUnitId = 0;
		}
	}
}
String isClose = Util.null2String(request.getParameter("isclose"));
String from = Util.null2String(request.getParameter("from"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
String refresh = Util.null2String(request.getParameter("refresh"));
String isWfDoc = Util.null2String(request.getParameter("isWfDoc"));

%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script type='text/javascript' src='/dwr/interface/DocReceiveUnitUtil.js'></script>
<script type='text/javascript' src='/dwr/engine.js'></script>
<script type='text/javascript' src='/dwr/util.js'></script>
<script type="text/javascript">

	var parentWin = null;
	var parentDialog = null;
	<%if(isClose.equals("1")||isDialog.equals("1")){%>
		parentWin = parent.parent.getParentWindow(parent);
		parentDialog = parent.parent.getDialog(parent);
	<%}%>
	<%if(isClose.equals("1")){%>
		parentWin.parent.parent.refreshTreeMain(<%=subcompanyid%>,<%=subcompanyid%>);
		parentWin.onBtnSearchClick();
		parentWin.closeDialog();
	<%}%>
	
	jQuery(document).ready(function(){
		<% if(refresh.equals("1")){%>
			<%if(superiorUnitId!=0){%>
				parent.parent.refreshTreeMain(<%=receiveUnitId%>,<%=superiorUnitId%>);
			<%}else{%>
				parent.parent.refreshTreeMain(<%=receiveUnitId%>,<%=subcompanyid%>);
			<%}%>
		<%}%>
	});
	
</script>
</head>
<%

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(19309,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(!onlyRead){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
if(!"1".equals(isDialog)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
}

%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<%if(!onlyRead){ %>
				<input type=button class="e8_btn_top" onclick="onSave();" value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage())%>"></input>
				<%if(!"1".equals(isDialog)){ %>
					<input type=button class="e8_btn_top" onclick="onDelete();" value="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>"></input>
				<%} %>
			<%} %>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div id=divMessage style="color:red">
</div>

<FORM id=weaver name=frmMain action="DocReceiveUnitOperation.jsp" method=post>
		<input class=inputstyle type=hidden name=isWfDoc value="<%=isWfDoc %>">
		<%if("1".equals(isDialog)){ %>
		<input type="hidden" name="isdialog" value="<%=isDialog%>">
		<input type="hidden" name="from" value="<%=from%>">
		<%} %>

		<wea:layout>
			<wea:group context='<%=SystemEnv.getHtmlLabelName(16261,user.getLanguage())%>'>
				<wea:item><%=SystemEnv.getHtmlLabelName(17868,user.getLanguage())%></wea:item>
				<wea:item>
					<span>
						<brow:browser viewType="0" name="subcompanyid" browserValue='<%= subcompanyid>0?(""+subcompanyid):"" %>' 
								browserUrl='<%="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser2.jsp?rightStr="+rightStr+"&isedit=1&selectedids="%>'
								_callback="afterShowSubcompanyid" linkUrl="#"
								language='<%=""+user.getLanguage() %>' temptitle='<%=SystemEnv.getHtmlLabelName(17868,user.getLanguage())%>'
								hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='<%=onlyRead?"0":"2" %>'
								completeUrl="/data.jsp?type=164"
								browserSpanValue='<%=subcompanyname%>'>
						</brow:browser>
					</span>
				</wea:item>
				<%if(docchangeEnabled){%>
					<wea:item><%=SystemEnv.getHtmlLabelName(22880,user.getLanguage())%></wea:item>
					<wea:item>
						<%if(!isWfDoc.equals("1")){ %>
							<select id="companyType" name="companyType" onchange="changeType(this.value)" <%=onlyRead?"disabled=disabled":"" %>>
								<option value="0" <%if(companyType.equals("0")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1994,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(1329,user.getLanguage())%></option>
								<option value="1" <%if(companyType.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1995,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(1329,user.getLanguage())%></option>
							</select>
						<%}else{ %>
							<input type="hidden" id="companyType"  name="companyType" value="1"/>
							<%=SystemEnv.getHtmlLabelName(1995,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(1329,user.getLanguage())%>
						<%} %>
					</wea:item>
				<%}%>
				<wea:item><%=SystemEnv.getHtmlLabelName(19309,user.getLanguage())%></wea:item>
				<wea:item>
					<%if(!onlyRead){ %>
						<wea:required id="receiveUnitNameImage" required="true" value='<%=receiveUnitName%>'>
							<INPUT temptitle="<%=SystemEnv.getHtmlLabelName(19309,user.getLanguage())%>" class=InputStyle  name=receiveUnitName  value="<%=receiveUnitName%>" onchange='checkinput("receiveUnitName","receiveUnitNameImage")' value="">
						</wea:required>
					<%}else{ %>
						<%= receiveUnitName%>
					<%} %>
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(19310,user.getLanguage())%></wea:item>
				<wea:item>
					<span>
					  <brow:browser viewType="0" name="superiorUnitId" browserValue='<%=""+superiorUnitId %>'
					browserUrl='<%="/systeminfo/BrowserMain.jsp?mouldID=doc&url=/docs/sendDoc/DocReceiveUnitBrowserSingle.jsp?rightStr="+rightStr+"&superiorUnitId="%>'
					_callback="afterShowSuperiorUnit" temptitle='<%=SystemEnv.getHtmlLabelName(19310,user.getLanguage())%>' language='<%=""+user.getLanguage() %>'
					hasInput="false" isSingle="true" hasBrowser = "true" isMustInput='<%=onlyRead?"0":"1" %>'
					browserSpanValue='<%=DocReceiveUnitComInfo.getReceiveUnitName(""+superiorUnitId)%>'></brow:browser>
					</span>
				</wea:item>
				<wea:item attributes="{'samePair':'HrmTR1'}"><%=SystemEnv.getHtmlLabelName(19311,user.getLanguage())%></wea:item>
				<wea:item attributes="{'samePair':'HrmTR1'}">
					<%
					String tmpname = Util.null2String(ResourceComInfo.getMulResourcename1(receiverIds,","));
					tmpname = tmpname.replaceAll("'","");
					tmpname = tmpname.replaceAll("\"","'");
					%>
					<span>
					  <brow:browser viewType="0" name="receiverIds" browserValue='<%= receiverIds%>'
				browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="
				temptitle='<%=SystemEnv.getHtmlLabelName(19311,user.getLanguage())%>' language='<%=""+user.getLanguage() %>'
                hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='<%=onlyRead?"0":"2" %>' completeUrl="/data.jsp"
                browserSpanValue='<%=tmpname %>'></brow:browser>
                </span>
				</wea:item>
				<%if(docchangeEnabled){%>
					<wea:item attributes="{'samePair':'CpnTR1'}"><%=SystemEnv.getHtmlLabelName(22879,user.getLanguage())%></wea:item>
					<wea:item attributes="{'samePair':'CpnTR1'}">
						<%if(!onlyRead){ %>
							<wea:required id="changeDirImage" required="false">
								<INPUT temptitle="<%=SystemEnv.getHtmlLabelName(22879,user.getLanguage())%>" class=InputStyle value="<%=changeDir%>"  name=changeDir value="" onchange='checkinput("changeDir","changeDirImage")'>
							</wea:required>
						<%}else{ %>
							<%= changeDir%>
						<%} %>
					</wea:item>
					<wea:item attributes="{'samePair':'CpnTR3'}"><%=SystemEnv.getHtmlLabelName(23090,user.getLanguage())%></wea:item>
					<wea:item attributes="{'samePair':'CpnTR3'}">
						<select name="isMain" id="isMain" <%=onlyRead?"disabled=disabled":"" %>>
							<option value="0" <%if(isMain.equals("0")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(23092,user.getLanguage())%></option>
							<option value="1" <%if(isMain.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(23091,user.getLanguage())%></option>
						</select>
					</wea:item>
				 <%}%>
				
				<wea:item><%=SystemEnv.getHtmlLabelName(22904,user.getLanguage())%></wea:item>
				<wea:item>
					<select class=inputstyle  name = canStartChildRequest <%=onlyRead?"disabled=disabled":"" %>>
						<option value=1 <%if(canStartChildRequest.equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option>
						<option value=0 <%if(canStartChildRequest.equals("0")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option>
					</select>   
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(88,user.getLanguage())%></wea:item>
				<wea:item>
					<%if(!onlyRead){ %>
						<wea:required id="showOrderImage" required="true" value='<%=""+showOrder%>'>
							<INPUT style="width:100px;" temptitle="<%=SystemEnv.getHtmlLabelName(88,user.getLanguage())%>" class="InputStyle" id="showOrder" name="showOrder" value="<%=showOrder %>" size="20" maxlength="20" onKeyPress="ItemDecimal_KeyPress('showOrder',10,2)" onBlur='checknumber("showOrder");checkinput("showOrder","showOrderImage")' onchange='checkinput("showOrder","showOrderImage")' >
                        </wea:required>
					<%}else{ %>
						<%= showOrder%>
					<%} %>
				</wea:item>
			</wea:group>
		</wea:layout>

       


   <input type=hidden name=method>
   <input type=hidden name=id value="<%=receiveUnitId%>">
	<input type="hidden" id="changetype" name="changetype" value="">
	<input type="hidden" id="changeid" name="changeid" value="">
 </FORM>
<%if("1".equals(isDialog)){ %>
	</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
				<wea:item type="toolbar">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="parentDialog.closeByHand();">
				</wea:item>
			</wea:group>
		</wea:layout>
</div>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
<%} %>
</BODY></HTML>


<script language=javascript>


try{
	parent.setTabObjName("<%= receiveUnitName %>");
}catch(e){}

//o为错误类型 1:系统不支持10层以上的收文单位！
//           2:同级单位名称不能重复

function checkForEditSave(o){
	if(o=="1"){
		//alert("<%=SystemEnv.getHtmlLabelName(19319,user.getLanguage())%>");
		divMessage.innerHTML="<%=SystemEnv.getHtmlLabelName(19319,user.getLanguage())%>";
		return;
	}else if(o=="2"){
		//alert("<%=SystemEnv.getHtmlLabelName(19366,user.getLanguage())%>");
		divMessage.innerHTML="<%=SystemEnv.getHtmlLabelName(19366,user.getLanguage())%>";
		return;
	}else if(o==""){
		document.frmMain.method.value="EditSave";
		document.frmMain.submit();	
	}
}

function onSave(){
	if(document.frmMain.superiorUnitId.value==<%=receiveUnitId%>){
		//alert("<%=SystemEnv.getHtmlLabelName(19315,user.getLanguage())%>");
		divMessage.innerHTML="<%=SystemEnv.getHtmlLabelName(19315,user.getLanguage())%>";
	}else{
		if(check_form(document.frmMain,'receiveUnitName,showOrder')){
			if(document.getElementById("companyType")!=null && document.frmMain.companyType.value=='1') {
				var dirvalue = document.frmMain.changeDir.value;
				if(!dirvalue.isValidString()) {
					top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(22879,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(22945,user.getLanguage())%>!');
					return;
				}
				if(!check_form(document.frmMain,'changeDir,subcompanyid')) return;
				var _data;
                var newsubcompanyId = jQuery("#subcompanyid").val();;
                var isMain = jQuery("#isMain").val();
				DocReceiveUnitUtil.checkChangeDir('<%=receiveUnitId%>', newsubcompanyId+","+dirvalue+","+isMain, callBackFun);
			}
			else {
				if(!check_form(document.frmMain,'receiverIds,subcompanyid')) return;
				saveAction();
			}
		}
	}
}

//回调函数    
function callBackFun(data) {
	_data = data;
    if(_data == "0") {
        saveAction();
    } else {
        top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(22943,user.getLanguage())%>!');
    }
}

function saveAction() {
	var newReceiveUnitId=<%=receiveUnitId%>;
	var newReceiveUnitName=$GetEle("receiveUnitName").value;
	var newSuperiorUnitId=$GetEle("superiorUnitId").value;
	var newsubcompanyId=$GetEle("subcompanyid").value;
    newReceiveUnitName=escape(newReceiveUnitName);
	DocReceiveUnitUtil.whetherCanEditSave(newReceiveUnitId,newReceiveUnitName,newSuperiorUnitId,newsubcompanyId,checkForEditSave);
}
 
//o为错误类型 1:当前单位有下级单位，不能删除。
//           2:该记录被引用,不能删除。
function checkForDelete(o){
	if(o=="1"){
		//alert("<%=SystemEnv.getHtmlLabelName(19365,user.getLanguage())%>");
		divMessage.innerHTML="<%=SystemEnv.getHtmlLabelName(19365,user.getLanguage())%>";
		return;
	}else if(o=="2"){
		//alert("<%=SystemEnv.getErrorMsgName(20,user.getLanguage())%>")
		divMessage.innerHTML="<%=SystemEnv.getErrorMsgName(20,user.getLanguage())%>";
		return;
	}else if(o==""){
		document.frmMain.method.value="Delete";
		document.frmMain.submit();	
	}
}


function onDelete(){
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>",function(){
		var receiveUnitId=<%=receiveUnitId%>;
		DocReceiveUnitUtil.whetherCanDelete(receiveUnitId,checkForDelete);
    });
}
function onChangeSubmit(type){
	document.getElementById("changetype").value = type;
	if(type == 0){
		document.getElementById("changeid").value = document.getElementById("superiorUnitId").value;
	}else if(type == 1){
		document.getElementById("changeid").value = document.getElementById("subcompanyid").value;
	}
	document.frmMain.action = "DocReceiveUnitEdit.jsp";
	document.frmMain.target = "";
	document.frmMain.submit();
}
function encode(str){
    return escape(str);
}
//by alan 切换单位类型
function changeType(f, isfirst) {
	if(f==0) {
		showEle("HrmTR1");
		hideEle("CpnTR1");
		hideEle("CpnTR3");
		//document.getElementById('CpnTR4').style.display = 'none';
		if(!isfirst) {
			if(document.getElementById('receiverIdsSpan').innerHTML=='')
				checkinput("receiverIds","receiverIdsSpan");
		}
	}
	else {
		hideEle("HrmTR1");
		showEle("CpnTR1");
		showEle("CpnTR3");
		checkinput("changeDir","changeDirImage");
	}
}
<%if(docchangeEnabled){%>
changeType('<%if(companyType.equals("")){out.print("0");}else{out.print(companyType);}%>', true);
<%}%>

//检查是否符合字符规定 by alan
String.prototype.isValidString=function()
{
	try {
	var result=this.match(/^[a-zA-Z0-9\-_]+$/);
	if(result==null) return false;
	return true;
	}
	catch(e) {
		alert(e);
	}
}

function onShowReceiverIds(inputname,spanname){
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
	    
	     jQuery("#"+spanname).html(sHtml);
	     jQuery("input[name="+inputname+"]").val(datas.id);
	     }
	     else {
	    	 jQuery("#"+spanname).html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
	    	 jQuery("input[name="+inputname+"]").val("");
	     }
	 }
	 }

function onShowSuperiorUnit(input,superiorUnitSpan){
	superiorUnitId=document.frmMain.superiorUnitId.value
	url=encode("/docs/sendDoc/DocReceiveUnitBrowserSingle.jsp?rightStr=<%=rightStr%>&transferValue=<%=receiveUnitId%>_"+superiorUnitId)
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url);
	var issame = false
	if (data){
		if(data.id!=""){
			if (data.id == frmMain.superiorUnitId.value){
				issame = true
			}
			jQuery(superiorUnitSpan).html("<a href='#"+data.id+"'>"+data.name+"</a>");
			frmMain.superiorUnitId.value=data.id
			onChangeSubmit(0)
		}else{
			jQuery(superiorUnitSpan).html("");
			frmMain.superiorUnitId.value="0"
		}
	}
}

function afterShowSuperiorUnit(e,data,name,params){
	issame = false;
	if (data) {
		if (data.id!=""){
			if (data.id == jQuery("#"+name).val()){
				issame = true;
			}
			onChangeSubmit(0);
		}else{
			onChangeSubmit(0);
		}
	}
}

function onShowSubcompanyid(inputname,spanname){
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser2.jsp?rightStr=<%=rightStr%>&isedit=1&selectedids="+inputname.value)
	var issame = false
	if (data){
		if (data.id!=0){
			if (data.id == inputname.value){
				issame = true
			}
			spanname.innerHTML = data.name
			inputname.value = data.id
			onChangeSubmit(1)
		}else{
			spanname.innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
			inputname.value = ""
		}
	}
}

function afterShowSubcompanyid(e,data,name,params){
	issame = false;
	if (data) {
		if(data.id!=""){
			if (data.id== jQuery("#"+name).val()){
				issame = true;
			}
			onChangeSubmit(1);
		}else{
			onChangeSubmit(1);
		}
	}
}

jQuery(document).ready(function(){

	//jQuery(".wuiBrowser").modalDialog();
});
 </script>

