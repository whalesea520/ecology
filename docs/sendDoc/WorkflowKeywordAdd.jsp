
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 

<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>

<jsp:useBean id="WorkflowKeywordComInfo" class="weaver.docs.senddoc.WorkflowKeywordComInfo" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<%
if(!HrmUserVarify.checkUserRight("SendDoc:Manage", user)){
    response.sendRedirect("/notice/noright.jsp");
    return;
}
%>

<%
int hisId=Util.getIntValue(request.getParameter("hisId"),0);
int  parentId=Util.getIntValue(request.getParameter("parentId"),0);
String from = Util.null2String(request.getParameter("from"));
if(parentId==-1){//新建子节点的同级节点
	RecordSet.executeSql("select parentid from Workflow_Keyword where id = "+hisId);
	if(RecordSet.next()){
		parentId = Util.getIntValue(RecordSet.getString(1),0);
	}
}
String isDialog = Util.null2String(request.getParameter("isdialog"));
%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script type="text/javascript">
	var parentWin = null;
	var dialog = null;
<%if(isDialog.equals("1")){%>
	parentWin = parent.parent.getParentWindow(parent);
	dialog = parent.parent.getDialog(parent);
<%}%>
</script>
</head>
<%

String imagefilename = "/images/hdMaintenance_wev8.gif";

String titlename = SystemEnv.getHtmlLabelName(16978,user.getLanguage())+"："+SystemEnv.getHtmlLabelName(365,user.getLanguage());
String needfav ="1";
String needhelp ="";
String isclose = Util.null2String(request.getParameter("isclose"));


%>
<BODY>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(0),_TOP} " ;
RCMenuHeight += RCMenuHeightStep ;
if(isDialog.equals("1")){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(32159,user.getLanguage())+",javascript:onSave(1),_TOP} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
if(!isDialog.equals("1")){
	if(hisId>0){
	    RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/docs/sendDoc/WorkflowKeywordDsp.jsp?id="+hisId+",_self} " ;
	    RCMenuHeight += RCMenuHeightStep ;
	}else{
	    RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/docs/sendDoc/WorkflowKeyword.jsp,_self} " ;
	    RCMenuHeight += RCMenuHeightStep ;
	}
} %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>


<div id=divMessage style="color:red">
</div>

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type=button class="e8_btn_top" onclick="onSave(0);" value="<%=SystemEnv.getHtmlLabelName(30986, user.getLanguage())%>"></input>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(32159,user.getLanguage())%>" id="zd_btn_submit" class="e8_btn_top" onclick="onSave(1);">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>

<FORM id=weaver name=frmMain action="WorkflowKeywordOperation.jsp" method=post>
<input type="hidden" name="isdialog" value="<%=isDialog%>">
<input type="hidden" id="optype" name="optype" value="1">
<input type="hidden" id = "isentrydetail" name="isentrydetail" value="">
<input type="hidden" name="from" value="<%=from%>">
<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(16261,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(21510,user.getLanguage())%></wea:item>
		<wea:item>
			<wea:required id="keywordNameImage" required="true">
				<INPUT temptitle="<%=SystemEnv.getHtmlLabelName(21510,user.getLanguage())%>" class=InputStyle id=keywordName  name=keywordName onchange='checkinput("keywordName","keywordNameImage")' value="">
			</wea:required>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(21511,user.getLanguage())%></wea:item>
		<wea:item><INPUT class=InputStyle  name=keywordDesc value=""></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(19411,user.getLanguage())%></wea:item>
		<wea:item>
			<%String url="/systeminfo/BrowserMain.jsp?url=/docs/sendDoc/WorkflowKeywordBrowserSingle.jsp?keywordId="+parentId; %>
			<%if(!from.equals("edit")&&!from.equals("nextedit")){ %>
              <span>
				<brow:browser viewType="0" name="parentId" browserValue='<%=""+parentId%>' 
						browserUrl='<%=url %>'
						linkUrl="#"
						language='<%=""+user.getLanguage() %>'
						hasInput="false" isSingle="true" hasBrowser = "true" isMustInput="1"
						completeUrl="/data.jsp?type=164" temptitle='<%= SystemEnv.getHtmlLabelName(19411,user.getLanguage())%>'
						browserSpanValue='<%=WorkflowKeywordComInfo.getKeywordName(""+parentId)%>'>
				</brow:browser>
			</span>
            <%}else{ %>
            	<brow:browser viewType="0" name="parentId" browserValue='<%=""+parentId%>' 
						browserUrl='<%=url %>'
						linkUrl="#" language='<%=""+user.getLanguage() %>'
						hasInput="false" isSingle="true" hasBrowser = "true" isMustInput="0"
						completeUrl="/data.jsp?type=164" temptitle='<%= SystemEnv.getHtmlLabelName(19411,user.getLanguage())%>'
						browserSpanValue='<%=WorkflowKeywordComInfo.getKeywordName(""+parentId)%>'>
				</brow:browser>
            <%} %> 
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(21512,user.getLanguage())%></wea:item>
		<wea:item>
			<select id="isKeyword" name="isKeyword" class=InputStyle>
				 <option value="0" <%=parentId<=0?"selected":""%>><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option>
				 <option value="1" <%=parentId>0?"selected":""%>><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option>
			 </select>			
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(15513,user.getLanguage())%></wea:item>
		<wea:item>
			<%
				double showOrder=0;
				RecordSet.executeSql("    select max(showOrder) as showOrder from Workflow_Keyword");
				if(RecordSet.next()){
					showOrder=Util.getDoubleValue(RecordSet.getString("showOrder"),0)+1.0;
				}
			%>
			<wea:required id="showOrderImage" required="true" value='<%=""+showOrder%>'>
				<INPUT style="width:50px;" temptitle="<%=SystemEnv.getHtmlLabelName(15513,user.getLanguage())%>" class=InputStyle id=showOrder name=showOrder value="<%=showOrder%>" size=7 maxlength=7  onKeyPress='ItemDecimal_KeyPress("showOrder",6,2)' onBlur='checknumber("showOrder");checkDigit("showOrder",6,2);checkinput("showOrder","showOrderImage")' onchange='checkinput("showOrder","showOrderImage")' >
			</wea:required>
		</wea:item>
	</wea:group>
</wea:layout>

   <input class=inputstyle type=hidden id=operation name=operation value="AddSave">
</FORM>

<iframe id="workflowKeywordIframe" frameborder=0 scrolling=no src=""  style="display:none"></iframe>
<%if("1".equals(isDialog)){ %>
	</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
				<wea:item type="toolbar">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand();">
				</wea:item>
			</wea:group>
		</wea:layout>
	
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
	if(o=="2"){
		divMessage.innerHTML="<%=SystemEnv.getHtmlLabelName(21515,user.getLanguage())%>";
		return;
	}else if(o==""){
		document.frmMain.submit();	
	}
}

function onSave(isEnterDetail) {
	if(check_form(frmMain,'keywordName,showOrder')){
		if(!isEnterDetail){isEnterDetail=0;}
		jQuery('#isentrydetail').val(isEnterDetail);
		if(isEnterDetail==1){
			jQuery('#optype').val(1);
		}
		var newKeywordName=document.getElementById("keywordName").value;
		var newParentId=document.getElementById("parentId").value;
		document.getElementById("workflowKeywordIframe").src="WorkflowKeywordIframe.jsp?operation=AddSave&newParentId="+newParentId+"&newKeywordName="+newKeywordName;
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

function onShowParent(){
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
	url="/docs/sendDoc/WorkflowKeywordBrowserSingle.jsp?keywordId="+parentId
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url,"","addressbar=no;status=0;scroll="+opts._scroll+";dialogHeight="+opts._dheight+";dialogWidth="+opts._dwidth+";dialogLeft="+opts.left+";dialogTop="+opts.top+";resizable=0;center=1;");
	
	if (data){
	    if (data.id!="") {
	        parentSpan.innerHtml = id(1)
	        frmMain.parentId.value=id(0)
	    }else{
	        parentSpan.innerHtml = ""
	        frmMain.parentId.value="0"
	    }
	}
}

</script>
