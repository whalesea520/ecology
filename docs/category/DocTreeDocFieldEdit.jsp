
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.docs.category.DocTreeDocFieldConstant" %>

<%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="DocTreeDocFieldComInfo" class="weaver.docs.category.DocTreeDocFieldComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<%@ page import="weaver.docs.category.security.*" %>


<%
boolean onlyRead = false;
if(!HrmUserVarify.checkUserRight("DummyCata:Maint", user)){
    /*response.sendRedirect("/notice/noright.jsp");
    return;
    */
    onlyRead = true;
}
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
String from = Util.null2String(request.getParameter("from"));
String isentrydetail = Util.null2String(request.getParameter("isentrydetail"));
String qname = Util.null2String(request.getParameter("flowTitle"));
%>

<%
String treeDocFieldId=Util.null2String(request.getParameter("id"));
String err=Util.null2String(request.getParameter("err"));


String treeDocFieldName=DocTreeDocFieldComInfo.getTreeDocFieldName(treeDocFieldId);
String superiorFieldId = DocTreeDocFieldComInfo.getSuperiorFieldId(treeDocFieldId);
String showOrder = DocTreeDocFieldComInfo.getShowOrder(treeDocFieldId);

if(superiorFieldId.equals("0")){
	superiorFieldId = DocTreeDocFieldConstant.TREE_DOC_FIELD_ROOT_ID;
}

String treeDocFieldDesc = DocTreeDocFieldComInfo.getTreeDocFieldDesc(treeDocFieldId);
String mangerids = DocTreeDocFieldComInfo.getMangerids(treeDocFieldId);
String refresh = Util.null2String(request.getParameter("refresh"));
String optype = Util.null2String(request.getParameter("optype"));
if(isDialog.equals("1") && isclose.equals("1")){
	optype = "1";
	if(isentrydetail.equals("1")){
		optype="0";
	}
}
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script type='text/javascript' src='/dwr/interface/DocTreeDocFieldUtil.js'></script>
<script type='text/javascript' src='/dwr/engine.js'></script>
<script type='text/javascript' src='/dwr/util.js'></script>
<script type="text/javascript">
		try{
			parent.setTabObjName("<%= !treeDocFieldName.equals("")?treeDocFieldName:SystemEnv.getHtmlLabelName(20482,user.getLanguage()) %>");
		}catch(e){}
		jQuery(document).ready(function(){
			try{
				if("<%=optype%>"!="1"){
					jQuery("#sublist",parent.document).removeClass("current");
					jQuery("#baseinfo",parent.document).addClass("current");
				}
			}catch(e){
				
			}
		});
</script>
<script type="text/javascript">
	<%if(isDialog.equals("1")){%>
		var parentWin = parent.parent.getParentWindow(parent);
		var parentDialog = parent.parent.getDialog(parent);
	<%}%>
	if("<%=isclose%>"=="1"){
		<%if(!isentrydetail.equals("1")&&treeDocFieldId.equals(DocTreeDocFieldConstant.TREE_DOC_FIELD_ROOT_ID)){%>
			parentWin.location="DocTreeDocFieldRight.jsp?optype=1&refresh=1&superiorFieldId=<%=treeDocFieldId%>";
		<%}else{%>
			parentWin.parent.location="DocTreeTab.jsp?_fromURL=3&optype=<%=optype%>&refresh=1&id=<%=treeDocFieldId%>";
		<%}%>
		parentWin.closeDialog();	
	}
</script>
<script type="text/javascript">
function onBtnSearchClick(){
	jQuery("#searchfrm").submit();
}

function doDel(id){
	if(!id){
		id = _xtable_CheckedCheckboxId();
	}
	if(!id){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32568,user.getLanguage())%>");
		return;
	}
	if(id.match(/,$/)){
		id = id.substring(0,id.length-1);
	}
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(33435,user.getLanguage())%>",function() {
		//var idArr = id.split(",");
		//for(var i=0;i<idArr.length;i++){
			jQuery.ajax({
				url:"DocTreeDocFieldOperation.jsp?isdialog=1&operation=Delete",
				type:"post",
				data:{
					id:id
				},
				complete:function(xhr,status){
					//if(i==idArr.length-1){
						_table.reLoad();
						parent.parent.refreshTreeMain(<%=treeDocFieldId%>,null);
					//}
				}
			});
		//}
	});
}

var dialog = null;
function closeDialog(){
	if(dialog)
		dialog.close();
}

function openDialog(id){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	if(id==null){
		id="";
	}
	var url = "/docs/tabs/DocCommonTab.jsp?_fromURL=12&isdialog=1&superiorFieldId="+id;
	if(!!id){
		dialog.Title = "<%=SystemEnv.getHtmlLabelNames("93,32520",user.getLanguage())%>";
		url = "/docs/tabs/DocCommonTab.jsp?_fromURL=13&from=edit&isdialog=1&id="+id;
	}else{
		dialog.Title = "<%=SystemEnv.getHtmlLabelNames("82,32520",user.getLanguage())%>";
	}
	dialog.Width = 600;
	dialog.Height = 321;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}

function openDialog2(id){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "/docs/tabs/DocCommonTab.jsp?_fromURL=12&isdialog=1&id="+id;
	dialog.Title = "<%=SystemEnv.getHtmlLabelNames("82,32520",user.getLanguage())%>";
	dialog.Width = 600;
	dialog.Height = 321;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}

function openDialog3(id,isentrydetail){
	dialog = new window.top.Dialog();
	if(isentrydetail==null){
		isentrydetail = "0";
	}
	dialog.currentWindow = window;
	if(id==null){
		id="";
	}
	var url = "/docs/tabs/DocCommonTab.jsp?_fromURL=12&isdialog=1&superiorFieldId="+id+"&isentrydetail="+isentrydetail;
	dialog.Title = "<%=SystemEnv.getHtmlLabelNames("82,32520",user.getLanguage())%>";
	dialog.Width = 600;
	dialog.Height = 321;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}

function openDialog4(id){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "/docs/category/AddCategoryPermission.jsp?categoryid="+id+"&categorytype=<%=AclManager.CATEGORYTYPE_TREEFIELD%>&operationcode=<%=AclManager.OPERATION_TREEFIELDDIR%>";
	dialog.Title = "<%=SystemEnv.getHtmlLabelNames("611,1507,19467",user.getLanguage())%>";
	dialog.Width = 600;
	dialog.Height = 285;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.isIframe = false;
	dialog.show();
}

jQuery(document).ready(function(){
	<%if("1".equals(refresh)){%>
		parent.parent.refreshTreeMain(<%=treeDocFieldId%>,null);
	<%}else if("2".equals(refresh)){%>
		parent.parent.refreshTreeMain(<%=treeDocFieldId%>,null,{add:true});
	<%}%>
});

</script>
<%if(!from.equals("edit")){ %>
<script language=javascript src="/js/ecology8/docs/docSearchInit_wev8.js"></script>
<script language=javascript src="/js/ecology8/docs/docExt_wev8.js"></script>
<%} %>
</head>

<%

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(19410,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(93,user.getLanguage());
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
if(!"1".equals(isDialog)){ 
	if(!optype.equals("1")){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
		RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
	}else{  
		if(HrmUserVarify.checkUserRight("DummyCata:Maint", user)){
		    RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:openDialog3("+treeDocFieldId+"),_self} " ;
		    RCMenuHeight += RCMenuHeightStep ;
		    RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:doDel(),_self} " ;
		    RCMenuHeight += RCMenuHeightStep ;
		}
	}
	
}else{
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(0),_TOP} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(32159,user.getLanguage())+",javascript:onSave(1),_TOP} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>


<div id=divMessage style="color:red">
</div>
<%if(!from.equals("edit")){ %>
<form action="" name="searchfrm" id="searchfrm">
<input type=hidden name=id value="<%=treeDocFieldId%>">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<%if(HrmUserVarify.checkUserRight("DummyCata:Maint", user) && !onlyRead){ %>
				<%if(!optype.equals("1")){ %>
					<input type=button class="e8_btn_top" onclick="onSave();" value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage())%>"></input>
				<%}else{ %>
					<input type=button class="e8_btn_top" onclick="openDialog3(<%=treeDocFieldId %>,'-1')" value="<%=SystemEnv.getHtmlLabelName(82, user.getLanguage())%>"></input>
					<input type=button class="e8_btn_top" onclick="doDel();"  value="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>"></input>
				<%} %>
			<%} %>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
</form>
<%}else{ %>
	<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type=button class="e8_btn_top" onclick="onSave('0');" value="<%=SystemEnv.getHtmlLabelName(30986, user.getLanguage())%>"></input>
			<input type=button class="e8_btn_top" onclick="onSave(1);" value="<%=SystemEnv.getHtmlLabelName(32159, user.getLanguage())%>"></input>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<%} %>
<FORM id=weaver name=frmMain action="DocTreeDocFieldOperation.jsp" method=post target="_parent">
<input type="hidden" name="isdialog" value="<%=isDialog%>">
<input type="hidden" id = "isentrydetail" name="isentrydetail" value="<%=isentrydetail %>">
<input type="hidden" name="from" value="<%=from%>">
<input type="hidden" name="mangerids" value="<%=mangerids%>">
<%
	if("isUsed".equals(err) && !optype.equals("1")){ 
%>
		<script type="text/javascript">
			top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(20552,user.getLanguage())%>");
		</script>	
<%
	}
%>
	<wea:layout>
		<%if(!optype.equals("1")){ %>
			<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
				<wea:item><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></wea:item>
				<wea:item>
					<%if(!onlyRead){ %>
					<wea:required id="treeDocFieldNameImage" required="true" value='<%=treeDocFieldName%>'>
						<INPUT class=InputStyle id=treeDocFieldName  name=treeDocFieldName value="<%=treeDocFieldName%>" onchange='checkinput("treeDocFieldName","treeDocFieldNameImage")'>
					</wea:required>
					<%}else{ %>
						<%=treeDocFieldName %>
					<%} %>
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></wea:item>
				<wea:item>
					<%if(!onlyRead){ %>
						<INPUT class=InputStyle  name=treeDocFieldDesc value="<%=treeDocFieldDesc%>">
					<%}else{ %>
						<%=treeDocFieldDesc %>
					<%} %>
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(88,user.getLanguage())%></wea:item>
				<wea:item>
					<%if(!onlyRead){ %>
					<wea:required id="showOrderImage" required="true" value='<%=showOrder%>'>
						<INPUT style="width:50px;" class=InputStyle name=showOrder size=7 maxlength=7 value="<%=showOrder%>"   onKeyPress='ItemDecimal_KeyPress("showOrder",6,2)'  onBlur='checknumber("showOrder");checkDigit("showOrder",6,2);checkinput("showOrder","showOrderImage")' onchange='checkinput("showOrder","showOrderImage")'>
					</wea:required>
					<%}else{ %>
						<%=showOrder %>
					<%} %>
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(19411,user.getLanguage())%></wea:item>
				<wea:item>
					<span>
							<%String browserUrl = "/systeminfo/BrowserMain.jsp?mouldID=doc&url=/docs/category/DocTreeDocFieldBrowserSingle.jsp?excludeId="+treeDocFieldId+"&superiorFieldId="; %>
						   <brow:browser viewType="0" language='<%=""+user.getLanguage() %>' temptitle='<%=SystemEnv.getHtmlLabelName(19411,user.getLanguage()) %>' name="superiorFieldId" browserValue='<%=superiorFieldId%>' 
							browserUrl='<%=browserUrl %>' _callback="afterSuperiorField"
							hasInput="false" isSingle="true" hasBrowser = "true" isMustInput='<%=onlyRead?"0":"1" %>'
							completeUrl="/data.jsp" linkUrl="#"
							browserSpanValue='<%=DocTreeDocFieldComInfo.getAllSuperiorFieldName(""+superiorFieldId)%>'></brow:browser>
					</span>			
				</wea:item>
			</wea:group>
		<%}else{ %>
		<%if(!from.equals("edit")){ %>
		 <%
			String sqlWhere = "superiorFieldId="+treeDocFieldId;
			if(!qname.equals("")){
				sqlWhere += " and treeDocFieldName like '%"+qname+"%'";
			}							
			String  operateString= "";
			if(HrmUserVarify.checkUserRight("DummyCata:Maint", user)){
			operateString = "<operates width=\"20%\">";
					   operateString+=" <popedom transmethod=\"weaver.general.KnowledgeTransMethod.getVirDirOperate\"></popedom> ";
					   operateString+="     <operate href=\"javascript:openDialog();\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" index=\"0\"/>";
					   operateString+="     <operate href=\"javascript:doDel()\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" index=\"1\"/>";
					   operateString+="     <operate href=\"javascript:openDialog2()\" text=\""+SystemEnv.getHtmlLabelName(19413,user.getLanguage())+"\" index=\"2\"/>";
					   operateString+="     <operate href=\"javascript:openDialog3()\" text=\""+SystemEnv.getHtmlLabelName(19412,user.getLanguage())+"\" index=\"3\"/>";
					   operateString+="     <operate href=\"javascript:openDialog4()\" text=\""+SystemEnv.getHtmlLabelName(1507,user.getLanguage())+"\" index=\"4\"/>";
					   operateString+="</operates>";	
			 }	
			String tableString=""+
			   "<table pageId=\""+PageIdConst.DOC_TREECATEGORSUBLIST+"\" instanceid=\"docMouldTable\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.DOC_TREECATEGORSUBLIST,user.getUID(),PageIdConst.DOC)+"\" tabletype=\"checkbox\">"+
				" <checkboxpopedom  id=\"checkbox\" showmethod=\"weaver.general.KnowledgeTransMethod.getVirDirCheckbox\" popedompara = \"column:id\" />"+
			   "<sql backfields=\"*\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlform=\"DocTreeDocField\" sqlorderby=\"showOrder\"  sqlprimarykey=\"id\" sqlsortway=\"asc\"  sqldistinct=\"true\" />"+
			   operateString+
			   "<head>"+							 
					 "<col width=\"40%\" transmethod=\"weaver.general.KnowledgeTransMethod.forHtml\" text=\""+SystemEnv.getHtmlLabelName(24764,user.getLanguage())+"\"  href=\"/docs/category/DocTreeTab.jsp?_fromURL=3\" column=\"treeDocFieldName\" linkkey=\"id\" linkvaluecolumn=\"id\" target=\"_parent\" orderkey=\"treeDocFieldName\"/>"+
					 "<col width=\"40%\"  transmethod=\"weaver.general.KnowledgeTransMethod.forHtml\" text=\""+SystemEnv.getHtmlLabelName(433,user.getLanguage())+"\" column=\"treeDocFieldDesc\"/>"+
					 "<col width=\"20%\"  transmethod=\"weaver.general.KnowledgeTransMethod.forHtml\" text=\""+SystemEnv.getHtmlLabelName(15513,user.getLanguage())+"\" column=\"showOrder\"/>"+
			   "</head>"+
			   "</table>";
		%> 
		<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.DOC_TREECATEGORSUBLIST %>"/>
		<wea:group context='<%=SystemEnv.getHtmlLabelName(32866,user.getLanguage())%>' attributes="{'groupDisplay':'none'}">
				<wea:item attributes="{'isTableList':'true'}">
					<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run"  />
				</wea:item>
		</wea:group>
		<%}%>
	  <%} %>
	</wea:layout>

   <input type=hidden name=operation>
   <input type=hidden name=id value="<%=treeDocFieldId%>">
 </FORM>
<%if("1".equals(isDialog)){ %>
	</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
				<wea:item type="toolbar">
					<%if(!onlyRead){ %>
						<%--<input type="button" value="<%=SystemEnv.getHtmlLabelName(32159,user.getLanguage())%>" id="zd_btn_submit_0" class="zd_btn_submit" onclick="jQuery('#isentrydetail').val('1');onSave(this);">
						<span class="e8_sep_line">|</span>
						<%if(!from.equals("edit")){//弹出框编辑 %>
							<input type="button" value="<%=SystemEnv.getHtmlLabelName(30986,user.getLanguage())%>" id="zd_btn_submit" class="zd_btn_submit" onclick="jQuery('#isentrydetail').val('0');onSave(this);">
						<%}else{ %>
							<input type="button" value="<%=SystemEnv.getHtmlLabelName(30986,user.getLanguage())%>" id="zd_btn_submit" class="zd_btn_submit" onclick="onSave(this);">
						<%} %>
						<span class="e8_sep_line">|</span> --%>
					<%} %>
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



//o为错误类型 1:系统不支持10层以上的树状字段！
//           2:同级字段名称不能重复

function checkForEditSave(o){
	if(o=="1"){
		//alert("<%=SystemEnv.getHtmlLabelName(19414,user.getLanguage())%>");
		divMessage.innerHTML="<%=SystemEnv.getHtmlLabelName(19414,user.getLanguage())%>";
		return;
	}else if(o=="2"){
		//alert("<%=SystemEnv.getHtmlLabelName(19442,user.getLanguage())%>");
		divMessage.innerHTML="<%=SystemEnv.getHtmlLabelName(19442,user.getLanguage())%>";
		return;
	}else if(o==""){
		document.frmMain.operation.value="EditSave";
		document.frmMain.target = "_self";
		document.frmMain.submit();	
	}
}


function onSave(isEnterDetail){
	if(isEnterDetail!=null){
		jQuery('#isentrydetail').val(isEnterDetail);
	}
 	if(check_form(document.frmMain,'treeDocFieldName,showOrder')){
		var newTreeDocFieldId=<%=treeDocFieldId%>;
		var newTreeDocFieldName=document.getElementById("treeDocFieldName").value;
		var newSuperiorFieldId=document.getElementById("superiorFieldId").value;

        newTreeDocFieldName=escape(newTreeDocFieldName);
			DocTreeDocFieldUtil.whetherCanEditSave(newTreeDocFieldId,newTreeDocFieldName,newSuperiorFieldId,checkForEditSave);
	}

 }
 
//o为错误类型 1:当前字段有下级节点，不能删除。
//           2:该记录被引用,不能删除。
function checkForDelete(o){
	if(o=="1"){
		//alert("<%=SystemEnv.getHtmlLabelName(19441,user.getLanguage())%>");
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(19441,user.getLanguage())%>");
		return;
	}else if(o=="2"){
		//alert("<%=SystemEnv.getErrorMsgName(20,user.getLanguage())%>")
		top.Dialog.alert("<%=SystemEnv.getErrorMsgName(20,user.getLanguage())%>");
		return;
	}else if(o==""){
		document.frmMain.operation.value="Delete";
		document.frmMain.submit();	
	}
}


function onDelete(){
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>",function() {
		var treeDocFieldId=<%=treeDocFieldId%>;
		DocTreeDocFieldUtil.whetherCanDelete(treeDocFieldId,checkForDelete);
    });
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
	linkurl="javaScript:openhrm(";
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
	        frmMain.superiorFieldId.value=data.id
	    }else{
	       jQuery(superiorFieldSpan).html("");
	        frmMain.superiorFieldId.value="<%=DocTreeDocFieldConstant.TREE_DOC_FIELD_ROOT_ID%>"
	    }
	}
}
</script>
