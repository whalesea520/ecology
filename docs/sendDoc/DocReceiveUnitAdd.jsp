

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.file.Prop" %>
<%@ page import="java.text.DecimalFormat" %>

<jsp:useBean id="DocReceiveUnitComInfo" class="weaver.docs.senddoc.DocReceiveUnitComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>


<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<%
String rightStr = "SRDoc:Edit";
if(!HrmUserVarify.checkUserRight(rightStr, user)){
    response.sendRedirect("/notice/noright.jsp");
    return;
}
%>

<%
String showOrder = "0";
RecordSet.executeSql("SELECT MAX(showOrder)+1 FROM DocReceiveUnit");
if(RecordSet.next()){
	double showOrder_d = Util.getDoubleValue(RecordSet.getString(1));
	DecimalFormat df = new DecimalFormat("#.00");
	showOrder = df.format(showOrder_d);
}


Prop prop = Prop.getInstance();
//boolean docchangeEnabled = Util.null2String(prop.getPropValue("DocChange", "Enabled")).equals("Y");
String strDocChgEnabled = Util.null2String(prop.getPropValue("DocChange", "Enabled"));
boolean docchangeEnabled = false;
if("Y".equalsIgnoreCase(strDocChgEnabled) || "1".equals(strDocChgEnabled)) {
    docchangeEnabled = true;
}
int subcompanyid = Util.getIntValue(request.getParameter("subcompanyid"), 0);

int superiorUnitId = Util.getIntValue(request.getParameter("superiorUnitId"),0);

String _thisId = Util.null2String(request.getParameter("_thisId"));
if(!"".equals(_thisId)){//新建同级单位
	superiorUnitId = Util.getIntValue(DocReceiveUnitComInfo.getSuperiorUnitId(_thisId),0);
	subcompanyid = Util.getIntValue(DocReceiveUnitComInfo.getSubcompanyid(_thisId),0);
}

String _superiorUnitId = Util.null2String(request.getParameter("_superiorUnitId"));
if(!"".equals(_superiorUnitId)){
	superiorUnitId = Util.getIntValue(_superiorUnitId,0);
	subcompanyid = Util.getIntValue(DocReceiveUnitComInfo.getSubcompanyid(_superiorUnitId),0);
}

String subcompanyname = SubCompanyComInfo.getSubCompanyname(""+subcompanyid);
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
</script>
</head>
<%

String imagefilename = "/images/hdMaintenance_wev8.gif";

String titlename = SystemEnv.getHtmlLabelName(19309,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(365,user.getLanguage());
String needfav ="1";
String needhelp ="";

%>
<BODY>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type=button class="e8_btn_top" onclick="onSave();" value="<%=SystemEnv.getHtmlLabelName(30986, user.getLanguage())%>"></input>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_TOP} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<div id=divMessage style="color:red">
</div>

<FORM id=weaver name=frmMain action="DocReceiveUnitOperation.jsp" method=post  <%if(!isDialog.equals("1")){ %>target="_parent"<%} %>>
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
								_callback="afterShowSubcompanyid" linkUrl="#" temptitle='<%=SystemEnv.getHtmlLabelName(17868,user.getLanguage())%>'
								language='<%=""+user.getLanguage() %>'
								hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
								completeUrl="/data.jsp?type=164" 
								browserSpanValue='<%=subcompanyname%>'>
						</brow:browser>
					</span>
				</wea:item>
				<%if(docchangeEnabled){%>
					<wea:item><%=SystemEnv.getHtmlLabelName(22880,user.getLanguage())%></wea:item>
					<wea:item>
						<%if(!isWfDoc.equals("1")){ %>
							<select id="companyType" name="companyType" onchange="changeType(this.value)">
								<option value="0"><%=SystemEnv.getHtmlLabelName(1994,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(1329,user.getLanguage())%></option>
								<option value="1"><%=SystemEnv.getHtmlLabelName(1995,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(1329,user.getLanguage())%></option>
							</select>
						<%}else{ %>
							<input type="hidden" id="companyType"  name="companyType" value="1"/>
							<%=SystemEnv.getHtmlLabelName(1995,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(1329,user.getLanguage())%>
						<%} %>
					</wea:item>
				<%}%>
				<wea:item><%=SystemEnv.getHtmlLabelName(19309,user.getLanguage())%></wea:item>
				<wea:item>
					<wea:required id="receiveUnitNameImage" required="true">
						<INPUT temptitle="<%=SystemEnv.getHtmlLabelName(19309,user.getLanguage())%>" class=InputStyle  name=receiveUnitName onchange='checkinput("receiveUnitName","receiveUnitNameImage")' value="">
					</wea:required>
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(19310,user.getLanguage())%></wea:item>
				<wea:item>
					<span>
					  <brow:browser viewType="0" name="superiorUnitId" browserValue='<%=""+superiorUnitId %>'
					browserUrl='<%="/systeminfo/BrowserMain.jsp?mouldID=doc&url=/docs/sendDoc/DocReceiveUnitBrowserSingle.jsp?rightStr="+rightStr+"&superiorUnitId="%>'
					_callback="showSuperiorUnit" temptitle='<%=SystemEnv.getHtmlLabelName(19310,user.getLanguage())%>' language='<%=""+user.getLanguage() %>'
					hasInput="false" isSingle="true" hasBrowser = "true" isMustInput='1'
					browserSpanValue='<%=DocReceiveUnitComInfo.getReceiveUnitName(""+superiorUnitId)%>'></brow:browser>
					</span>
				</wea:item>
				<wea:item attributes="{'samePair':'HrmTR1'}"><%=SystemEnv.getHtmlLabelName(19311,user.getLanguage())%></wea:item>
				<wea:item attributes="{'samePair':'HrmTR1'}">
					<span>
					  <brow:browser viewType="0" name="receiverIds"
				browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="
                hasInput="true" temptitle='<%=SystemEnv.getHtmlLabelName(19311,user.getLanguage())%>' language='<%=""+user.getLanguage() %>' isSingle="false" hasBrowser = "true" isMustInput='2' completeUrl="/data.jsp"
                ></brow:browser>
                </span>
				</wea:item>
				<%if(docchangeEnabled){%>
					<wea:item attributes="{'samePair':'CpnTR1','display':'none'}"><%=SystemEnv.getHtmlLabelName(22879,user.getLanguage())%></wea:item>
					<wea:item attributes="{'samePair':'CpnTR1','display':'none'}">
						<wea:required id="changeDirImage" required="true">
							<INPUT temptitle="<%=SystemEnv.getHtmlLabelName(22879,user.getLanguage())%>" class=InputStyle  name=changeDir id="changeDir" value="" onchange='checkinput("changeDir","changeDirImage")'>
						</wea:required>
					</wea:item>
					<wea:item attributes="{'samePair':'CpnTR3','display':'none'}"><%=SystemEnv.getHtmlLabelName(23090,user.getLanguage())%></wea:item>
					<wea:item attributes="{'samePair':'CpnTR3','display':'none'}">
						<select id="isMain" name="isMain">
							<option value="0"><%=SystemEnv.getHtmlLabelName(23092,user.getLanguage())%></option>
							<option value="1"><%=SystemEnv.getHtmlLabelName(23091,user.getLanguage())%></option>
						</select>
					</wea:item>
				 <%}%>
				<wea:item><%=SystemEnv.getHtmlLabelName(22904,user.getLanguage())%></wea:item>
				<wea:item>
					<select class=inputstyle  name = canStartChildRequest>
						<option value=1 ><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option>
						<option value=0 ><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option>
					</select>   
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(88,user.getLanguage())%></wea:item>
				<wea:item>
					<wea:required id="showOrderImage" required="true" value="0">
                        <INPUT style="width:100px;" temptitle="<%=SystemEnv.getHtmlLabelName(88,user.getLanguage())%>" class="InputStyle" id="showOrder" name="showOrder" value="<%=showOrder %>" size="20" maxlength="20"  onKeyPress="ItemDecimal_KeyPress('showOrder',10,2)" onBlur='checknumber("showOrder");checkinput("showOrder","showOrderImage")' onchange='checkinput("showOrder","showOrderImage")' >
					</wea:required>
				</wea:item>
			</wea:group>
		</wea:layout>

   <input class=inputstyle type=hidden name=method value="AddSave">
   <input class=inputstyle type=hidden name=isWfDoc value="<%=isWfDoc %>">
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
</BODY>
</HTML>


<script language=javascript>

//o为错误类型 1:系统不支持10层以上的收文单位！
//           2:同级单位名称不能重复

function checkForAddSave(o){
	if(o=="1"){
		//alert("<%=SystemEnv.getHtmlLabelName(19319,user.getLanguage())%>");
		divMessage.innerHTML="<%=SystemEnv.getHtmlLabelName(19319,user.getLanguage())%>";
		return;
	}else if(o=="2"){
		//alert("<%=SystemEnv.getHtmlLabelName(19366,user.getLanguage())%>");
		divMessage.innerHTML="<%=SystemEnv.getHtmlLabelName(19366,user.getLanguage())%>";
		return;
	}else if(o==""){
		document.frmMain.submit();		
	}
}

function onSave() {
	if(check_form(frmMain,'receiveUnitName,subcompanyid,showOrder')){
		var newReceiveUnitName=$G("receiveUnitName").value;
		var mewSuperiorUnitId=$G("superiorUnitId").value;
		var newsubcompanyId=$G("subcompanyid").value;
		newReceiveUnitName=escape(newReceiveUnitName);

		if(document.getElementById("companyType")!=null && document.getElementById("companyType").value=='1') {
			var dirvalue = document.getElementById('changeDir').value;
            var isMain = jQuery("#isMain").val();
			if(!dirvalue.isValidString()) {
				alert('<%=SystemEnv.getHtmlLabelName(22879,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(22945,user.getLanguage())%>!');
				return;
			}
			if(!check_form(document.frmMain,'changeDir')) return;
			var _data;
			DocReceiveUnitUtil.checkChangeDir('', newsubcompanyId+","+dirvalue+","+isMain, callBackFun);
			//回调函数    
			function callBackFun(data) {
				_data = data;
                if(_data == "0") {
                    DocReceiveUnitUtil.whetherCanAddSave(newReceiveUnitName,mewSuperiorUnitId,newsubcompanyId,checkForAddSave);
                } else {
                    alert('<%=SystemEnv.getHtmlLabelName(22943,user.getLanguage())%>!');
                }
			}
		}
		else {
			if(!check_form(frmMain,'receiverIds')) return;
			DocReceiveUnitUtil.whetherCanAddSave(newReceiveUnitName,mewSuperiorUnitId,newsubcompanyId,checkForAddSave);
		}

		//DocReceiveUnitUtil.whetherCanAddSave(newReceiveUnitName,mewSuperiorUnitId,newsubcompanyId,checkForAddSave);
    }
}
function onChangeSubmit(type){
	document.getElementById("changetype").value = type;
	if(type == 0){
		document.getElementById("changeid").value = document.getElementById("superiorUnitId").value;
	}else if(type == 1){
		document.getElementById("changeid").value = document.getElementById("subcompanyid").value;
	}
	document.frmMain.action = "DocReceiveUnitAdd.jsp?isWfDoc=<%=isWfDoc%>";
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
		<%if(docchangeEnabled){%>
			hideEle("CpnTR1");
			hideEle("CpnTR3");
		<%}%>
		if(!isfirst) {
			if(document.getElementById('receiverIdsSpan').innerHTML=='')
				checkinput("receiverIds","receiverIdsSpan");
		}
	}
	else {
		hideEle("HrmTR1");
		<%if(docchangeEnabled){%>
			showEle("CpnTR1");
			showEle("CpnTR3");
			checkinput("changeDir","changeDirImage");
		<%}%>
	}
}
<%if(isWfDoc.equals("1")){ %>
changeType('1', true);
<%}else{ %>
changeType('0', true);
<%} %>
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
	url="/docs/sendDoc/DocReceiveUnitBrowserSingle.jsp?superiorUnitId="+superiorUnitId+"&rightStr=<%=rightStr%>";
	
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url,"","addressbar=no;status=0;scroll="+opts._scroll+";dialogHeight="+opts._dheight+";dialogWidth="+opts._dwidth+";dialogLeft="+opts.left+";dialogTop="+opts.top+";resizable=0;center=1;");
	issame = false
	if (data) {
		if (data.id!=""){
			if (data.id == frmMain.superiorUnitId.value){
				issame = true
			}
			jQuery(superiorUnitSpan).html("<a href='#"+data.id+"'>"+data.name+"</a>");
			frmMain.superiorUnitId.value=data.id
			onChangeSubmit(0);
		}else{
			jQuery(superiorUnitSpan).html("");
			frmMain.superiorUnitId.value="0"
			onChangeSubmit(0);
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

//显示所属机构
function showSuperiorUnit(e,data,name,params){
	jQuery.ajax({
		url:'DocReceiveUnitAddOperation.jsp',
		data:{superiorUnitId:jQuery("#"+name).val(),method:'getSubcompanyid'},
		type:'POST',
		dataType:'json',
		async:true,
		success:function(data){
			if(data){
				_writeBackData('subcompanyid',1,{id:data.subcompanyid+',',name:data.subcompanyname},{isSingle:true,replace:true});
			}
		},
		error: function (XMLHttpRequest, textStatus, errorThrown){
			alert(errorThrown);
		}
		
	});
    changeType('0', true);
}

function onShowSubcompanyid(inputname,spanname){
	data= window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser2.jsp?rightStr=<%=rightStr%>&isedit=1&selectedids="+inputname.value,"","addressbar=no;status=0;scroll="+opts._scroll+";dialogHeight="+opts._dheight+";dialogWidth="+opts._dwidth+";dialogLeft="+opts.left+";dialogTop="+opts.top+";resizable=0;center=1;");
	issame = false
	if (data) {
		if(data.id!=""){
			if (data.id== inputname.value){
				issame = true
			}
			spanname.innerHtml = data.name
			inputname.value = data.id
			onChangeSubmit(1)
		}else{
			spanname.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
			inputname.value = ""
			onChangeSubmit(1)
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
</script>
