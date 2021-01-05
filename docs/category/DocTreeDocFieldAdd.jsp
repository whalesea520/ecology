
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.docs.category.DocTreeDocFieldConstant" %>

<jsp:useBean id="DocTreeDocFieldComInfo" class="weaver.docs.category.DocTreeDocFieldComInfo" scope="page" />



<%
if(!HrmUserVarify.checkUserRight("DummyCata:Maint", user)){
    response.sendRedirect("/notice/noright.jsp");
    return;
}
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
String from = Util.null2String(request.getParameter("from"));
String isEntryDetail = Util.null2String(request.getParameter("isentrydetail"));
if(isEntryDetail.equals(""))isEntryDetail = "0";
String optype = "1";
if(isEntryDetail.equals("1")){
	optype="0";
}
%>

<%

String superiorFieldId=Util.null2String(request.getParameter("superiorFieldId"));
String id = Util.null2String(request.getParameter("id"));
if(!id.equals("")&&superiorFieldId.equals("")){
	//新建同级目录
	superiorFieldId = DocTreeDocFieldComInfo.getSuperiorFieldId(id);
}
if(superiorFieldId.equals("")){
	superiorFieldId=DocTreeDocFieldConstant.TREE_DOC_FIELD_ROOT_ID;
}
%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script type='text/javascript' src='/dwr/interface/DocTreeDocFieldUtil.js'></script>
<script type='text/javascript' src='/dwr/engine.js'></script>
<script type='text/javascript' src='/dwr/util.js'></script>

<script type="text/javascript">
	var parentWin = parent.parent.getParentWindow(parent);
	var parentDialog = parent.parent.getDialog(parent);
	if("<%=isclose%>"=="1"){
		<%if(superiorFieldId.equals(DocTreeDocFieldConstant.TREE_DOC_FIELD_ROOT_ID)){%>
			parentWin.location="DocTreeDocFieldRight.jsp?optype=1&refresh=1&superiorFieldId=<%=superiorFieldId%>";
		<%}else if(isEntryDetail.equals("1")){%>
			parentWin.parent.location="DocTreeTab.jsp?_fromURL=3&optype=<%=optype%>&refresh=1&id=<%=superiorFieldId%>";
		<%}else{%>
			try{
				parentWin._table.reLoad();
				parentWin.parent.parent.refreshTreeMain(<%=superiorFieldId%>,null);
			}catch(e){}
		<%}%>
		parentWin.closeDialog();	
	}
</script>
</head>
<BODY>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
<%

String imagefilename = "/images/hdMaintenance_wev8.gif";

String titlename = SystemEnv.getHtmlLabelName(19410,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(365,user.getLanguage());
String needfav ="1";
String needhelp ="";

%>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave("+isEntryDetail+"),_TOP} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(32159,user.getLanguage())+",javascript:onSave(1),_TOP} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>


<div id=divMessage style="color:red">
</div>

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type=button class="e8_btn_top" onclick="onSave('<%= isEntryDetail%>');" value="<%=SystemEnv.getHtmlLabelName(30986, user.getLanguage())%>"></input>
			<input type=button class="e8_btn_top" onclick="onSave(1);" value="<%=SystemEnv.getHtmlLabelName(32159, user.getLanguage())%>"></input>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>

<FORM id=weaver name=frmMain action="DocTreeDocFieldOperation.jsp" method=post target="_parent">
		<input type="hidden" name="isdialog" value="<%=isDialog%>">
		<input type="hidden" id = "isentrydetail" name="isentrydetail" value="<%=isEntryDetail %>">
		<input type="hidden" name="from" value="<%=from%>">
		<wea:layout>
			<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
				<wea:item><%=SystemEnv.getHtmlLabelName(24764,user.getLanguage())%></wea:item>
				<wea:item>
					<wea:required id="treeDocFieldNameImage" required="true" >
						<INPUT temptitle="<%=SystemEnv.getHtmlLabelName(24764,user.getLanguage())%>" class=InputStyle id=treeDocFieldName  name=treeDocFieldName  onchange='checkinput("treeDocFieldName","treeDocFieldNameImage")'>
					</wea:required>
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></wea:item>
				<wea:item><INPUT class=InputStyle  name=treeDocFieldDesc></wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(19411,user.getLanguage())%></wea:item>
				<wea:item>
					<span>
							<%String browserUrl = "/systeminfo/BrowserMain.jsp?mouldID=doc&url=/docs/category/DocTreeDocFieldBrowserSingle.jsp?&superiorFieldId="; %>
						   <brow:browser viewType="0" name="superiorFieldId" browserValue='<%=superiorFieldId%>' 
							browserUrl='<%=browserUrl %>' _callback="afterSuperiorField"
							hasInput="false" isSingle="true" hasBrowser = "true" isMustInput='1' language='<%=""+user.getLanguage() %>'
							completeUrl="/data.jsp" linkUrl="#" temptitle='<%=SystemEnv.getHtmlLabelName(19411,user.getLanguage()) %>'
							browserSpanValue='<%=DocTreeDocFieldComInfo.getAllSuperiorFieldName(""+superiorFieldId)%>'></brow:browser>
					</span>			
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(88,user.getLanguage())%></wea:item>
				<wea:item>
					<wea:required id="showOrderImage" required="true" value="0.0">
						<INPUT style="width:50px;" temptitle="<%=SystemEnv.getHtmlLabelName(88,user.getLanguage()) %>" class=InputStyle name=showOrder size=7 maxlength=7   onKeyPress='ItemDecimal_KeyPress("showOrder",6,2)'  onBlur='checknumber("showOrder");checkDigit("showOrder",6,2);checkinput("showOrder","showOrderImage")' value="0.0" onchange='checkinput("showOrder","showOrderImage")'>
					</wea:required>
				</wea:item>
			</wea:group>
		</wea:layout>


   <input class=inputstyle type=hidden name=operation value="AddSave">
</FORM>
<%if("1".equals(isDialog)){ %>
	</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
				<wea:item type="toolbar">
					<%-- <input type="button" value="<%=SystemEnv.getHtmlLabelName(32159,user.getLanguage())%>" id="zd_btn_submit_0" class="zd_btn_submit" onclick="jQuery('#isentrydetail').val('1');onSave(this);">
					<span class="e8_sep_line">|</span>
						<input type="button" value="<%=SystemEnv.getHtmlLabelName(30986,user.getLanguage())%>" id="zd_btn_submit" class="zd_btn_submit" onclick="jQuery('#isentrydetail').val('<%= isEntryDetail%>');onSave(this);">
					
					<span class="e8_sep_line">|</span>--%>
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

//o为错误类型 1:系统不支持10层以上的树状字段！
//           2:同级字段名称不能重复

function checkForAddSave(o){
	if(o=="1"){
		//alert("<%=SystemEnv.getHtmlLabelName(19414,user.getLanguage())%>");
		divMessage.innerHTML="<%=SystemEnv.getHtmlLabelName(19414,user.getLanguage())%>";
		return;
	}else if(o=="2"){
		//alert("<%=SystemEnv.getHtmlLabelName(19442,user.getLanguage())%>");
		divMessage.innerHTML="<%=SystemEnv.getHtmlLabelName(19442,user.getLanguage())%>";
		return;
	}else if(o==""){
		document.frmMain.target = "_self";
		document.frmMain.submit();
	}
}

function onSave(isEnterDetail) {
    //obj.disabled = true ;
    if(isEnterDetail){
    	jQuery('#isentrydetail').val(isEnterDetail);
    }
	if(check_form(frmMain,'treeDocFieldName,showOrder')){
		var newTreeDocFieldName=document.getElementById("treeDocFieldName").value;
		var mewSuperiorFieldId=document.getElementById("superiorFieldId").value;
		newTreeDocFieldName=escape(newTreeDocFieldName);

		DocTreeDocFieldUtil.whetherCanAddSave(newTreeDocFieldName,mewSuperiorFieldId,checkForAddSave);
    }
}

function encode(str){
    return escape(str);
}

/*
p（精度）
指定小数点左边和右边可以存储的十进制数字的最大个数。精度必须是从 1 到最大精度之间的值。最大精度为 38。

s（小数位数）
指定小数点右边可以存储的十进制数字的最大个数。小数位数必须是从 0 到 p 之间的值。默认小数位数是 0，因而 0 <= s <= p。最大存储大小基于精度而变化。
*/
function checkDigit(elementName,p,s){
	tmpvalue = document.all(elementName).value;

    var len = -1;
    if(elementName){
		len = tmpvalue.length;
    }

	var integerCount=0;
	var afterDotCount=0;
	var hasDot=false;

    var newIntValue="";
	var newDecValue="";
    for(i = 0; i < len; i++){
		if(tmpvalue.charAt(i) == "."){ 
			hasDot=true;
		}else{
			if(hasDot==false){
				integerCount++;
				if(integerCount<=p-s){
					newIntValue+=tmpvalue.charAt(i);
				}
			}else{
				afterDotCount++;
				if(afterDotCount<=s){
					newDecValue+=tmpvalue.charAt(i);
				}
			}
		}		
    }

    var newValue="";
	if(newDecValue==""){
		newValue=newIntValue;
	}else{
		newValue=newIntValue+"."+newDecValue;
	}
    document.all(elementName).value=newValue;
}


function onShowManagerids(inputname,spanname){
	var opts={
			_dwidth:'550px',
			_dheight:'550px',
			_url:'about:blank',
			_scroll:"no",
			_dialogArguments:"",
			_displayTemplate:"#b{name}",
			_displaySelector:"",
			_required:"no",
			_displayText:"",
			value:""
		};
	var iTop = (window.screen.availHeight-30-parseInt(opts._dheight))/2+"px"; //获得窗口的垂直位置;
	var iLeft = (window.screen.availWidth-10-parseInt(opts._dwidth))/2+"px"; //获得窗口的水平位置;
	opts.top=iTop;
	opts.left=iLeft;
	
	linkurl="javaScript:openhrm('"
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="+inputname.value,"","addressbar=no;status=0;scroll="+opts._scroll+";dialogHeight="+opts._dheight+";dialogWidth="+opts._dwidth+";dialogLeft="+opts.left+";dialogTop="+opts.top+";resizable=0;center=1;");
	if (data) {
		if (data.id!="") {
		    resourceids = data.id.split(",")
			resourcename = data.name.split(",")
			sHtml = ""
			//resourceids = Mid(resourceids,2,len(resourceids))
			//resourcename = Mid(resourcename,2,len(resourcename))
			inputname.value= data.id
			for(var i=0;i<resourceids.length;i++){
				sHtml = sHtml+"<a href='"+linkurl+resourceids[i]+");' onclick='pointerXY(event);'>"+resourcename[i]+"</a>&nbsp"
			}
			
			//sHtml = sHtml&"<a href='&linkurl&resourceids&);' onclick='pointerXY(event);'>"&resourcename&"</a>&nbsp"
			spanname.innerHTML = sHtml
		}else{	
			spanname.innerHTML = ""
			inputname.value=""
		}
	}	
}

function afterSuperiorField(e,data,name){
	if(data){
		if(!data.id){
			jQuery("#"+name+"span").html("");
	        frmMain.superiorFieldId.value="<%=DocTreeDocFieldConstant.TREE_DOC_FIELD_ROOT_ID%>"
		}
	}
}

function onShowSuperiorField(input,superiorFieldSpan){
	var opts={
			_dwidth:'550px',
			_dheight:'550px',
			_url:'about:blank',
			_scroll:"no",
			_dialogArguments:"",
			_displayTemplate:"#b{name}",
			_displaySelector:"",
			_required:"no",
			_displayText:"",
			value:""
		};
	var iTop = (window.screen.availHeight-30-parseInt(opts._dheight))/2+"px"; //获得窗口的垂直位置;
	var iLeft = (window.screen.availWidth-10-parseInt(opts._dwidth))/2+"px"; //获得窗口的水平位置;
	opts.top=iTop;
	opts.left=iLeft;
	superiorFieldId=document.frmMain.superiorFieldId.value
	url="/docs/category/DocTreeDocFieldBrowserSingle.jsp?superiorFieldId="+superiorFieldId
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url,"","addressbar=no;status=0;scroll="+opts._scroll+";dialogHeight="+opts._dheight+";dialogWidth="+opts._dwidth+";dialogLeft="+opts.left+";dialogTop="+opts.top+";resizable=0;center=1;");
	
	if (data){
	    if (data.id != ""){
	        jQuery(superiorFieldSpan).html("<a href='#"+data.id+"'>"+data.name+"</a>");
	        frmMain.superiorFieldId.value=data.id;
	    }else{
	        jQuery(superiorFieldSpan).html("");
	        frmMain.superiorFieldId.value="<%=DocTreeDocFieldConstant.TREE_DOC_FIELD_ROOT_ID%>"
	    }
	}
}

</script>
