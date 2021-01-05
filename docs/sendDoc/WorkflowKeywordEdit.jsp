
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="WorkflowKeywordComInfo" class="weaver.docs.senddoc.WorkflowKeywordComInfo" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<%
boolean onlyRead = false;
String optype=Util.null2String(request.getParameter("optype"));
if(!HrmUserVarify.checkUserRight("SendDoc:Manage", user)){
    /*response.sendRedirect("/notice/noright.jsp");
    return;*/
    onlyRead = true;
}
%>

<%
int id=Util.getIntValue(request.getParameter("id"),0);
String from = Util.null2String(request.getParameter("from"));
String keywordName="";
String keywordDesc="";
int parentId=0;
String isKeyword="";
double showOrder=0;

String refresh = Util.null2String(request.getParameter("refresh"));

RecordSet.executeSql("select * from Workflow_Keyword where id="+id);
if(RecordSet.next()){
	keywordName=Util.null2String(RecordSet.getString("keywordName"));
	keywordDesc=Util.null2String(RecordSet.getString("keywordDesc"));
	parentId=Util.getIntValue(RecordSet.getString("parentId"),0);
	isKeyword=Util.null2String(RecordSet.getString("isKeyword"));
	showOrder=Util.getDoubleValue(RecordSet.getString("showOrder"),0);
}
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));

%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script type="text/javascript">
function onBtnSearchClick(){
	jQuery("#searchMain").submit();
}

try{
	parent.setTabObjName("<%= keywordName %>");
}catch(e){}

var parentWin = null;
var parentDialog = null;
<%if(isDialog.equals("1")){%>
	parentWin = parent.parent.getParentWindow(parent);
	parentDialog = parent.parent.getDialog(parent);
<%}%>

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
		window.location.href="/docs/sendDoc/WorkflowKeywordOperation.jsp?fromId=<%=id%>&isdialog=1&operation=Delete&id="+id;
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
	var url = "/docs/tabs/DocCommonTab.jsp?_fromURL=38&isdialog=1&parentId=0&hisId=0&from=edit";
	if(!!id){
		dialog.Title = "<%=SystemEnv.getHtmlLabelNames("93,16978",user.getLanguage())%>";
		url = "/docs/tabs/DocCommonTab.jsp?_fromURL=39&isdialog=1&from=edit&id="+id;
	}else{
		dialog.Title = "<%=SystemEnv.getHtmlLabelNames("82,16978",user.getLanguage())%>";
	}
	dialog.Width = 600;
	dialog.Height = 321;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}

//新建同级节点
function openDialog2(id){
	if(dialog==null){
		dialog = new window.top.Dialog();
	}
	dialog.currentWindow = window;
	var url = "/docs/tabs/DocCommonTab.jsp?_fromURL=38&isdialog=1&from=edit&parentId=-1&hisId="+id;
	dialog.Title = "<%=SystemEnv.getHtmlLabelNames("82,16978",user.getLanguage())%>";
	dialog.Width = 600;
	dialog.Height = 321;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}

//新建下级节点
function openDialog3(id){
	if(dialog==null){
		dialog = new window.top.Dialog();
	}
	dialog.currentWindow = window;
	var url = "/docs/tabs/DocCommonTab.jsp?_fromURL=38&isdialog=1&from=nextedit&parentId="+id+"&hisId="+id;
	dialog.Title = "<%=SystemEnv.getHtmlLabelNames("82,16978",user.getLanguage())%>";
	dialog.Width = 600;
	dialog.Height = 321;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}

jQuery(document).ready(function(){
	<%if("1".equals(refresh)){%>
		parent.parent.refreshTreeMain(<%=id%>,<%=parentId==0?null:parentId%>);
	<%}else if("2".equals(refresh)){%>
		parent.parent.refreshTreeMain(<%=id%>,<%=parentId==0?null:parentId%>,{add:true});
	<%}%>
});

</script>
<script language=javascript src="/js/ecology8/docs/docSearchInit_wev8.js"></script>
<script language=javascript src="/js/ecology8/docs/docExt_wev8.js"></script>
</head>
<%

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(16978,user.getLanguage())+"："+SystemEnv.getHtmlLabelName(93,user.getLanguage());
String needfav ="1";
String needhelp ="";
String qname = Util.null2String(request.getParameter("flowTitle"));

%>
<BODY>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(!onlyRead){
	if(!optype.equals("1")){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(0),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
		if("1".equals(isDialog)){
			RCMenu += "{"+SystemEnv.getHtmlLabelName(32159,user.getLanguage())+",javascript:onSave(1),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
		}
	}else{
		if(!"1".equals(isDialog)){
			RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:openDialog3("+id+"),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:doDel(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
		}
	}
}
/*
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/docs/sendDoc/WorkflowKeywordDsp.jsp?id="+id+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;*/

%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>


<div id=divMessage style="color:red">
</div>
 <form action="" name="searchMain" id="searchMain">
 <input type=hidden name=id value="<%=id%>">
 <input type="hidden" name="optype" value="<%=optype%>">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<% if(HrmUserVarify.checkUserRight("SendDoc:Manage", user) && !onlyRead){ %>
				<%if(!optype.equals("1")){ %>
					<input type="button" class="e8_btn_top" onclick="onSave(0);" value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage())%>"/>
					<%if(isDialog.equals("1")){ %>
						<input type="button" value="<%=SystemEnv.getHtmlLabelName(32159,user.getLanguage())%>" id="zd_btn_submit" class="e8_btn_top" onclick="onSave(1);">
					<%} %>
				<%}else{ %>
					<%if(!"1".equals(isDialog)){ %>
					<input type=button class="e8_btn_top" onclick="openDialog3(<%=id %>);" value="<%=SystemEnv.getHtmlLabelName(82, user.getLanguage())%>"></input>
					<input type=button class="e8_btn_top" onclick="doDel();" value="<%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%>"></input>
					<input type="text" class="searchInput" name="flowTitle"  value="<%=qname %>"/>
					<%} %>
				<%} %>
			<%} %>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
</form>

<FORM id=weaver name=frmMain action="WorkflowKeywordOperation.jsp" method=post>
		<input type="hidden" name="isdialog" value="<%=isDialog%>">
<input type="hidden" id = "isentrydetail" name="isentrydetail" value="">

<input type="hidden" name="from" value="<%=from%>">
<wea:layout type='<%="1".equals(isDialog)?"2col":"4col"%>'>
	<%if("1".equals(isDialog)||!"1".equals(optype)){ %>
		<wea:group context='<%=SystemEnv.getHtmlLabelName(16261,user.getLanguage())%>'>
			<wea:item><%=SystemEnv.getHtmlLabelName(21510,user.getLanguage())%></wea:item>
			<wea:item>
				<%if(!onlyRead){ %>
					<wea:required id="keywordNameImage" required="true" value='<%=keywordName%>'>
						<INPUT temptitle="<%=SystemEnv.getHtmlLabelName(21510,user.getLanguage()) %>" class=InputStyle id=keywordName  name=keywordName value="<%=keywordName%>" onchange='checkinput("keywordName","keywordNameImage")' value="">
					</wea:required>
				<%}else{ %>
					<%= keywordName%>
				<%} %>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(21511,user.getLanguage())%></wea:item>
			<wea:item>
			<%if(!onlyRead){ %>
				<INPUT class=InputStyle  name=keywordDesc style="width:80%" value="<%=keywordDesc%>">
			<%}else{ %>
				<%= keywordDesc%>
			<%} %>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(19411,user.getLanguage())%></wea:item>
			<wea:item>
				<span>
						  <brow:browser viewType="0" name="parentId" browserValue='<%= ""+parentId %>' 
	                browserOnClick="onShowParent(parentId,parentIdspan)"
	                temptitle='<%=SystemEnv.getHtmlLabelName(19411,user.getLanguage())%>' language='<%=""+user.getLanguage() %>'
	                hasInput="false" isSingle="true" hasBrowser = "true" isMustInput='<%=onlyRead?"0":"1" %>'
	                browserSpanValue='<%=WorkflowKeywordComInfo.getKeywordName(""+parentId)%>'></brow:browser>
	                </span>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(21512,user.getLanguage())%></wea:item>
			<wea:item>
				 <select name="isKeyword" class=InputStyle <%=onlyRead?"disabled=disabled":"" %>>
					 <option value="0" <%="0".equals(isKeyword)?"selected":""%>><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option>
					 <option value="1" <%="1".equals(isKeyword)?"selected":""%>><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option>
				 </select>			
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(15513,user.getLanguage())%></wea:item>
			<wea:item>
				<%if(!onlyRead){ %>
					<wea:required id="showOrderImage" required="true" value='<%=""+showOrder%>'>
						<INPUT style="width:50px;" temptitle="<%=SystemEnv.getHtmlLabelName(15513,user.getLanguage()) %>" class=InputStyle id=showOrder name=showOrder value="<%=showOrder%>" size=7 maxlength=7  onKeyPress='ItemDecimal_KeyPress("showOrder",6,2)' onBlur='checknumber("showOrder");checkDigit("showOrder",6,2);checkinput("showOrder","showOrderImage")' onchange='checkinput("showOrder","showOrderImage")' >
					</wea:required>
				<%}else{ %>
					<%= showOrder%>
				<%} %>
			</wea:item>
		</wea:group>
	<%} %>
	<%if(!"1".equals(isDialog) && optype.equals("1")){ %>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(32866,user.getLanguage())%>' attributes="{'groupDisplay':'none'}">
		<wea:item attributes="{'isTableList':'true'}">
			
			 <!-- 显示该节点的下级节点 -->
			 <%
				String sqlWhere = "parentId="+id;
				if(!qname.equals("")){
					sqlWhere += " and keywordName like '%"+qname+"%'";
				}							
				String  operateString= "";
				if(HrmUserVarify.checkUserRight("SendDoc:Manage", user)){
				operateString = "<operates width=\"20%\">";
						   operateString+=" <popedom transmethod=\"weaver.general.KnowledgeTransMethod.getKeywordOperate\"></popedom> ";
						   operateString+="     <operate href=\"javascript:openDialog();\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" index=\"0\"/>";
						   operateString+="     <operate href=\"javascript:doDel()\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" index=\"1\"/>";
						   operateString+="     <operate href=\"javascript:openDialog2()\" text=\""+SystemEnv.getHtmlLabelName(19413,user.getLanguage())+"\" index=\"2\"/>";
						   operateString+="     <operate href=\"javascript:openDialog3()\" text=\""+SystemEnv.getHtmlLabelName(19412,user.getLanguage())+"\" index=\"3\"/>";
						   operateString+="</operates>";	
				 }	
				String tableString=""+
				   "<table instanceid=\"docMouldTable\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.DOC_DOCKEYWORDDETAILLIST,user.getUID(),PageIdConst.DOC)+"\" tabletype=\"checkbox\">"+
					" <checkboxpopedom  id=\"checkbox\" showmethod=\"weaver.general.KnowledgeTransMethod.getWfKeywordCheckbox\" popedompara = \"column:id\" />"+
				   "<sql backfields=\"*\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlform=\"Workflow_Keyword\" sqlorderby=\"id\"  sqlprimarykey=\"id\" sqlsortway=\"desc\"  sqldistinct=\"true\" />"+
				   operateString+
				   "<head>"+							 
						 "<col width=\"40%\" transmethod=\"weaver.general.KnowledgeTransMethod.forHtml\" text=\""+SystemEnv.getHtmlLabelName(195,user.getLanguage())+"\"  href=\"/docs/sendDoc/DocKeywordTab.jsp?_fromURL=3\" column=\"keywordName\" linkkey=\"id\" linkvaluecolumn=\"id\" target=\"_parent\" orderkey=\"keywordName\"/>"+
						 "<col width=\"40%\"  transmethod=\"weaver.general.KnowledgeTransMethod.forHtml\" text=\""+SystemEnv.getHtmlLabelName(433,user.getLanguage())+"\" column=\"keywordDesc\"/>"+
						 "<col width=\"20%\"  transmethod=\"weaver.general.KnowledgeTransMethod.forHtml\" text=\""+SystemEnv.getHtmlLabelName(15513 ,user.getLanguage())+"\" column=\"showOrder\"/>"+
				   "</head>"+
				   "</table>";
				   
			%> 
			<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.DOC_DOCKEYWORDDETAILLIST %>"/>
			<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run"  />

			
		</wea:item>
	</wea:group>
	<%} %>
</wea:layout>


   <input type=hidden name=operation>
   <input type=hidden name=id value="<%=id%>">
 </FORM>

 
<iframe name="workflowKeywordIframe" id="workflowKeywordIframe" frameborder=0 scrolling=no src=""  style="display:none"></iframe>
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

//o为错误类型 1:系统不支持10层以上的树状字段！
//           2:提示字段名称不能重复

function checkForEditSave(o){
    if(o=="2"){
		divMessage.innerHTML="<%=SystemEnv.getHtmlLabelName(21515,user.getLanguage())%>";
		return;
	}else if(o==""){
		document.frmMain.operation.value="EditSave";
		document.frmMain.submit();	
	}
}


function onSave(isEnterDetail){

 	if(check_form(document.frmMain,'keywordName,showOrder')){
 		if(!isEnterDetail){isEnterDetail=0;}
		jQuery('#isentrydetail').val(isEnterDetail);
		var newKeywordId=<%=id%>;
		var newKeywordName=document.all("keywordName").value;
		var newParentId=document.all("parentId").value;

		document.getElementById("workflowKeywordIframe").src="WorkflowKeywordIframe.jsp?operation=EditSave&newKeywordId="+newKeywordId+"&newParentId="+newParentId+"&newKeywordName="+newKeywordName;
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

function onShowParent(input,parentSpan){
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
	parentId=document.frmMain.parentId.value
	url="/docs/sendDoc/WorkflowKeywordBrowserSingle.jsp?excludeId=<%=id%>&keywordId="+parentId
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url,"","addressbar=no;status=0;scroll="+opts._scroll+";dialogHeight="+opts._dheight+";dialogWidth="+opts._dwidth+";dialogLeft="+opts.left+";dialogTop="+opts.top+";resizable=0;center=1;");
	
	if (data){
	    if (data.id!="") {
	        jQuery(parentSpan).html("<a href='#"+data.id+"'>"+data.name+"</a>");
	        frmMain.parentId.value=data.id
	    }else{
	       jQuery(parentSpan).html("");
	        frmMain.parentId.value="0"
	    }
	}
}

</script>
