
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/browser" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%
	//pagetype 为1：出口条件； 2：批次条件; 4:督办条件; 3:规则设计
	String pagetype = Util.null2String(request.getParameter("pagetype"));
	if(pagetype.equals("")) pagetype = "1";
	//pagetype = "2";
	//出口条件传过来的参数   start
	String formid = Util.null2String(request.getParameter("formid"));
	
	String isbill = Util.null2String(request.getParameter("isbill"));
	//System.out.println(formid+"+++"+isbill);
	String linkid = Util.null2String(request.getParameter("linkid"));
	
	String src = Util.null2String(request.getParameter("method"));
	String fshowname = Util.null2String(request.getParameter("fshowname"));
	String ftype = Util.null2String(request.getParameter("ftype"));
	if(ftype.equals(""))ftype="2";
		//出口条件传过来的参数   end
	
	
%>
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.bgiframe.min_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.ajaxQueue_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/jquery.autocomplete_wev8.css" />
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/browser_wev8.css" />
</HEAD>
<style>
	.background{
		background:#D7D7D7;
		width:420px;
		height:45px;
		display:block;
		text-align:center;
		margin:15px 10px 15px 250px
	}
	.centerFont{
		text-align:center;
		display:block;
		margin:20px 0px 20px 0px;
		padding:10px 0px 5px 0px
	}
	.cutLine{
		width:70%;
		background:#2E96FF;
		height:3px!important;
		TEXT-ALIGN: center;
		margin:0 auto
	}
</style>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="workflow" />
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(22981,user.getLanguage()) %>" />
</jsp:include>
<div class="zDialog_div_content">
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="/workflow/ruleDesign/showFieldBrowser.jsp" method=post>
<input type="hidden" name="method" value="search" >
<table id="topTitle" cellpadding="0" cellspacing="0" >
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan">
			<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table> 

	<div id="_xTable" class="_xTableSplit" style="background:#FFFFFF;padding:0px;width:100%" valign="top"> 
		<div class="background">
			<span class="centerFont"><font SIZE=3><%=SystemEnv.getHtmlLabelName(129401, user.getLanguage())%></font>
			</span>			
		</div>
		<!-- 分隔符 -->
		<div class="cutLine"></div>
		<div style="margin:40px 50px 50px 200px">
			<span >
				<font SIZE=2><%=SystemEnv.getHtmlLabelName(801, user.getLanguage())%>：</font>
				<input type="text" name="jingdu" value=0.0 style="width:200px"></input>
			</span>
			&nbsp;&nbsp;&nbsp;&nbsp;
			<span >
				<font SIZE=2><%=SystemEnv.getHtmlLabelName(802, user.getLanguage())%>：</font>
				<input type="text" name="weidu" value=0.0 style="width:200px"></input>
			</span>
			<br/><br/><br/>
			<span >
				<font SIZE=2><%=SystemEnv.getHtmlLabelName(110, user.getLanguage())%>：</font>
				<input type="text" name="addr" style="width:465px;" onblur="errorGifJudge()"></input>
				<img name="errorGif" style="padding-top:4px;" src="/images/BacoError_wev8.gif" align="absMiddle">
			</span>
		</div>
	</div>
</FORM>
</div>

<script language=javascript>
	var dialog = parent.parent.getDialog(parent);
	$(document).ready(function(){
  		resizeDialog(document);
	});
</script>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
		<wea:group context="" attributes="{groupDisplay:none}">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="comfirmClick();">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(311,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="submitClear();">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.close();">
	    </wea:item>
		</wea:group>
	</wea:layout>
</div>	
<script type="text/javascript">

function onSearch()
{
	SearchForm.submit();
}

function afterDoWhenLoaded(){
	ontrclick();
}

var weaverSplit = "||~WEAVERSPLIT~||";
function comfirmClick()
{	
	var jingdu = $("input[name='jingdu']").val();
	var weidu = $("input[name='weidu']").val();
	var addr = $("input[name='addr']").val();
	var reg = new RegExp("^\\d+(\\.\\d+)?$");
	if(jingdu <= "0.0"){
		alert("<%=SystemEnv.getHtmlLabelName(129402, user.getLanguage())%>");
		return;
	}else if(reg.test(jingdu)==false){
		alert("<%=SystemEnv.getHtmlLabelName(129403, user.getLanguage())%>");
		return;
	}else if(weidu <= "0.0"){
		alert("<%=SystemEnv.getHtmlLabelName(129404, user.getLanguage())%>");
		return;
	}else if(reg.test(weidu)==false){
		alert("<%=SystemEnv.getHtmlLabelName(129405, user.getLanguage())%>");
		return;
	}else if(addr == null || addr == ''){
		alert("<%=SystemEnv.getHtmlLabelName(129406, user.getLanguage())%>");
		return;
	}else if(reg.test(addr)==true){
		alert("<%=SystemEnv.getHtmlLabelName(129407, user.getLanguage())%>");
		return;
	}	
		
	var returnjson = {jingdu:jingdu,addr:addr,weidu:weidu,};
	if(dialog){
		dialog.callback(returnjson);
	}else
	{
		window.parent.parent.returnValue = returnjson;
	  	window.parent.parent.close();
	}
}

function submitClear()
{
	if(dialog) {
		dialog.callback({id:"",name:""});
	} else {
		window.parent.returnValue = {id:"",name:""};
		window.parent.close()
	}
}
function errorGifJudge(){
	if($("input[name='addr']").val() == ''){
		$("img[name='errorGif']").show();
	}else{
		$("img[name='errorGif']").hide();
	}
	
}

</script>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>
</BODY>
</HTML>

