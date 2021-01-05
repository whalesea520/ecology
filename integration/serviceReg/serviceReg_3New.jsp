
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/integration/integrationinit.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="com.weaver.integration.params.*" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="IntegratedMethod" class="com.weaver.integration.util.IntegratedMethod" scope="page"/>
<jsp:useBean id="su" class="com.weaver.integration.util.SAPServcieUtil" scope="page"/>
<jsp:useBean id="SapUtil" class="com.weaver.integration.util.IntegratedUtil" scope="page"/>
<link href="/css/Weaver_wev8.css" type=text/css rel=stylesheet>
<link href="/integration/css/intepublic_wev8.css" type=text/css rel=stylesheet>
<link href="/integration/css/loading_wev8.css" type=text/css rel=stylesheet>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<html>
	<head>
		
	</head>
	<%
	
		String isNew=Util.null2String(request.getParameter("isNew"));
		String hpid=Util.null2String(request.getParameter("hpid"));//异构产品的id
		String id=Util.null2String(request.getParameter("id"))+"";//服务id
		String closeDialog=Util.null2String(request.getParameter("closeDialog"));
		boolean isCanUpdFlag = true;
		boolean isCanUpdFlag01= true;
		if(!"".equals(id)) {
			isCanUpdFlag01 = su.isExitParams(id);
		}
		
		String imagefilename = "/images/hdMaintenance_wev8.gif";
		String titlename = SystemEnv.getHtmlLabelName(30709,user.getLanguage());
		String opera="save";
		String poolid="";
		String funname="";
		String fundesc="";
		String loadmb="";
		String serdesc="";
		String regname="";
		ServiceParamModeBean spmb = null;
		String serviceParamModeId = "";
		String serviceParamModeName = "";
		String poolname="";
		String loadDate="";
		if("1".equals(isNew))
		{
			titlename =  SystemEnv.getHtmlLabelName(30710,user.getLanguage());
			opera="update";
			//查出默认值
			RecordSet.execute("select a.*,b.poolname from sap_service  a left join sap_datasource b on a.poolid=b.id where a.id='"+id+"'");
			if(RecordSet.next())
			{
				 regname=RecordSet.getString("regname");
				 poolid=RecordSet.getString("poolid");
				 serdesc=RecordSet.getString("serdesc");
				 funname=RecordSet.getString("funname");
				 fundesc=RecordSet.getString("fundesc");
				 hpid=RecordSet.getString("hpid");
				 poolname=RecordSet.getString("poolname");
				 loadmb=RecordSet.getString("loadmb");
				 loadDate=RecordSet.getString("loadDate");
			}
			spmb = ServiceParamModeUtil.getSerParModBeanById(id, false);
			if(spmb != null) {
				serviceParamModeName = spmb.getParamModeName();
				serviceParamModeId = spmb.getId();
				isCanUpdFlag01=false;//表示已经绑定了服务参数模板
			}
		}
		String needhelp ="";
	%>
	<body>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="integration"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(30624,user.getLanguage())%>"/> 
</jsp:include>
			<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
			<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
			<%
			if(isCanUpdFlag01)
			{
				RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSubmit(this),_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
				if(spmb == null) {
					RCMenu += "{"+SystemEnv.getHtmlLabelName(30711,user.getLanguage())+",javascript:doSubmitAndParseParams(this),_self} " ;
					RCMenuHeight += RCMenuHeightStep ;
				}
			}else
			{
				RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSubmit2(this),_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
			}
			//RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:doGoBack(this),_self} " ;
			//RCMenuHeight += RCMenuHeightStep ;
			if("1".equals(isNew)&&IntegratedMethod.getIsShowBox3(id).equals("true"))
			{
				RCMenu += "{"+SystemEnv.getHtmlLabelName(23777,user.getLanguage())+",javascript:doDelete(this,"+id+"),_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
			}
			%>
			<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0" width="100%">
	<tr>
		<td width="160px">
		</td>
		<td class="rightSearchSpan"
			style="text-align: right; width: 500px !important">
			<%if(isCanUpdFlag01){%>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" id="zd_btn_submit_0" class="e8_btn_top" onclick="doSubmit(this);">
				<%if(spmb == null) {%>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(30711,user.getLanguage())%>" class="e8_btn_top" onclick="doSubmitAndParseParams(this);">
				<%}%>
			<%}else{%>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" id="zd_btn_submit_0" class="e8_btn_top" onclick="doSubmit2(this);">
			<%}%>
			
			<%if("1".equals(isNew)&&IntegratedMethod.getIsShowBox3(id).equals("true")){%>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(23777,user.getLanguage())%>" class="e8_btn_top" onclick="doDelete(this,'<%=id%>')" />
			<%}%>&nbsp;&nbsp;&nbsp;
			<span title="<%=SystemEnv.getHtmlLabelName(82753,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>

			<form action="/integration/serviceReg/serviceReg_3Operation.jsp" method="post" name="datadml" id="datadml">
				<input type="hidden" name="opera"  id="opera" value="<%=opera%>">
				<input type="hidden" name="ids" value="<%=id%>">
				<input type="hidden" name="hpid" value="<%=hpid%>">
				<input type="hidden" name="serviceParamModeId" value="<%=serviceParamModeId%>">
				<input type="hidden" name="isParseParams" value="">
				<input type="hidden" name="isCheckFunction" value="">
				<input type="hidden" name="maxNums" value="">
<wea:layout type="2Col">
    <wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>' attributes="{'groupDisplay':\"\"}">
	<wea:item><%=SystemEnv.getHtmlLabelName(30672,user.getLanguage())%></wea:item>
    <wea:item>
        <wea:required id="regnamespan" required="true" value='<%=regname%>'>
         <input type="text" name="regname"  value="<%=regname%>"  onchange="checkinput('regname','regnamespan')" style="width:250px;" maxlength="80">
         </wea:required>
    </wea:item>
	<wea:item>SAP <%=SystemEnv.getHtmlLabelName(18076,user.getLanguage())%></wea:item>
    <wea:item>
        <wea:required id="poolidspan" required="true" value='<%=poolid%>'>
         <%if(!isCanUpdFlag01) {
				//如果该服务下存在函数模板，则不可删
				out.println(poolname);
				out.println("<input name='poolid' id='poolid' type='hidden' value="+poolid+">");
			 }else
			 {
				out.println(SapUtil.getDatasourceSelect("1","poolid","hideimg(this,poolidspan)",poolid,"selectmax_width","   ")); 
			 }
		%>
        </wea:required>
    </wea:item>
	<wea:item><%=SystemEnv.getHtmlLabelName(30713,user.getLanguage())%></wea:item>
    <wea:item>
        <wea:required id="funnamespan" required="true" value='<%=funname%>'>
         <%if(!isCanUpdFlag01) {
				//如果该服务下存在函数模板，则不可删
				out.println(funname);
				out.println("<input name='funname' id='funname' type='hidden' value="+funname+" maxlength=80>");
			 }else
			 {
		%>
			<input type="text" name="funname"  value="<%=funname%>" style="width:250px;" onchange="checkinput('funname','funnamespan'),getRegName(),upperCase(this)" maxlength=80>
		<%
			 }
		%>
        </wea:required>
		<input  id="btnFunCheck" class='e8_btn_submit' onclick="doTestFunction();"  value='<%=SystemEnv.getHtmlLabelName(30714,user.getLanguage())%>' type="button" <%if(!isCanUpdFlag) { %>disabled="disabled" <%} %>>
		<%if(!isCanUpdFlag01) {
		%>
			<input class='e8_btn_submit'  onclick="gerparfar();" value=' <%=SystemEnv.getHtmlLabelName(30716,user.getLanguage())%>' type="button">
		<%
			}
		%>
    </wea:item>
	<wea:item><%=SystemEnv.getHtmlLabelName(30717,user.getLanguage())%></wea:item>
    <wea:item>
        &nbsp;<input  id="servParamModeSetBtn" type="button" class="e8_btn_submit" value='<%=SystemEnv.getHtmlLabelName(30717,user.getLanguage())%>' onclick="servParamModeSetFunc();">
		<span id="servParamModeSetSpan"><%=serviceParamModeName %></span>
    </wea:item>
	<wea:item><%=SystemEnv.getHtmlLabelName(30719,user.getLanguage())%></wea:item>
    <wea:item>
        <input type="checkbox" value="1" name="loadmb" <%if("1".equals(loadmb)){out.println("checked='checked'");}%>>
    </wea:item>

	<wea:item><%=SystemEnv.getHtmlLabelName(125410,user.getLanguage())%></wea:item>
    <wea:item>
		<input type="checkbox" value="1" name="loadDate" <%if("1".equals(loadDate)){out.println("checked='checked'");}%>>
    </wea:item>

	<wea:item><%=SystemEnv.getHtmlLabelName(30720,user.getLanguage())%></wea:item>
    <wea:item>
        <textarea style="height: 100%;" name="serdesc" onpropertychange="checkLength(this,100);" oninput="checkLength(this,100);" ><%=serdesc%></textarea>
    </wea:item>
	</wea:group>
</wea:layout>
			</form>
			
	<DIV class=huotu_dialog_overlay id="hidediv">
			
	</DIV>
	<div  id="hidedivmsg" class="bd_dialog_main">
						
	</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
	<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
		<wea:item type="toolbar">
	    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="onCancel();">
	 	</wea:item>
	</wea:group>
	</wea:layout>
</div>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include> 
</body>
<script type="text/javascript">
		function onCancel(){
			var dialog = parent.getDialog(window);   //弹出窗口的引用，用于关闭页面
			dialog.close();
		}
		
		$(document).ready(function(){
			if("<%=closeDialog%>"=="close"){			
				var parentWin = parent.getParentWindow(window);
				parentWin.location.reload();
				onCancel();
			}
		});

		function upperCase(x)   {
            var y=x.value;
            x.value=y.toUpperCase();
        }
		function servParamModeSetFunc() {
			<%if(isCanUpdFlag01) {%>
				var temp=0;
				$(" span img").each(function (){
					if($(this).attr("align")=='absMiddle')
					{
						if($(this).css("display")=='inline')
						{
							temp++;
						}
					}
				});
				if(temp!=0)
				{
					alert("<%=SystemEnv.getHtmlLabelName(30622,user.getLanguage())%>");
					return;
				}
				//$("input[name='regname']").attr("value",$.trim($("#regnameSpan").html()));
				if($("input[name='regname']").attr("value") == '') {
					alert("<%=SystemEnv.getHtmlLabelName(30622,user.getLanguage())%>");
				}
				var ischeckfun = $("input[name='isCheckFunction']").attr("value");
				if(ischeckfun == 'no') {
						alert("<%=SystemEnv.getHtmlLabelName(30722,user.getLanguage())%>");
						return;
				}else if(ischeckfun == '') {
					var funName = $.trim($("input[name='funname']").attr("value"));
					var poolid = $("#poolid").val();
					$.post("/integration/serviceReg/checkSAPFunctionAjax.jsp",{funName:funName,poolid:poolid},function(data){ 
						if(!data["flag"]) {
							$("input[name='funname']").focus().select();
							$("input[name='isCheckFunction']").attr("value","no");
							alert("<%=SystemEnv.getHtmlLabelName(30722,user.getLanguage())%>");
						    return;
						}else {
							if(window.confirm("<%=SystemEnv.getHtmlLabelName(30729,user.getLanguage())%>"))
							{
								$("input[name='isCheckFunction']").attr("value","yes");
								$("input[name='isParseParams']").attr("value","yes");
								var a=(document.body.clientWidth)/2-140; 
								var b=(document.body.clientHeight)/2-40;
								$("#hidedivmsg").css("left",a);
								$("#hidedivmsg").css("top",b);
								$("#hidediv").show();
							
								$("#hidedivmsg").html("<%=SystemEnv.getHtmlLabelName(30730,user.getLanguage())%>").show();
								$("#datadml").submit();
							}
						}
					},"json");
				}else if(ischeckfun == 'yes') {
						if(window.confirm("<%=SystemEnv.getHtmlLabelName(30729,user.getLanguage())%>"))
					{
						$("input[name='isParseParams']").attr("value","yes");
						var a=(document.body.clientWidth)/2-140; 
						var b=(document.body.clientHeight)/2-40;
						$("#hidedivmsg").css("left",a);
						$("#hidedivmsg").css("top",b);
						$("#hidediv").show();
						$("#hidedivmsg").html("<%=SystemEnv.getHtmlLabelName(30730,user.getLanguage())%>").show();
						$("#datadml").submit();
					}
				}
			<%}else {%>
				var left = Math.ceil((screen.width - 1086) / 2);   //实现居中
		    	var top = Math.ceil((screen.height - 600) / 2);  //实现居中
		    	var serviceParamModeId = $.trim($("input[name='serviceParamModeId']").attr("value"));
		    	var urls ="/integration/serviceReg/serviceReg_3NewParamsMode.jsp?sid=3&poolid=<%=poolid%>&servId=<%=id%>&browserId="+serviceParamModeId;
					var tempstatus = "dialogWidth:1086px;dialogHeight:600px;scroll:yes;status:no;dialogLeft:"+left+";dialogTop:"+top+";";
		  		
				var dialog = new window.top.Dialog();
				dialog.currentWindow = window;   //传入当前window
				dialog.Width = 600;
				dialog.Height = 600;
				dialog.maxiumnable=true;
				dialog.DefaultMax = true;
				dialog.callbackfun=callvalue;
				//dialog.callbackfunParam=target;
				dialog.Modal = true;
				dialog.Title = "<%=SystemEnv.getHtmlLabelName(30717,user.getLanguage())%>"; 
				dialog.URL = urls;
				dialog.show();
				/*var temp = window.showModalDialog(urls,"",tempstatus);
		  		if(temp) {
		  			$("#servParamModeSetSpan").html("paramMode."+temp);
		  			$("input[name='serviceParamModeId']").attr("value",temp);
		  			$("#wf_show01").show();
		  			$("#wf_show02").show();
		  		}*/
			<%}%>
		}
		
		function callvalue(temp){
			if(temp){
				$("#servParamModeSetSpan").html("paramMode."+temp);
				$("input[name='serviceParamModeId']").attr("value",temp);
				$("#wf_show01").show();
				$("#wf_show02").show();
			}
		}
		
		function doSubmit2(obj)
		{
			//只保存，只修改sap注册服务描述里面的内容
			$("#opera").attr("value","updatedesc");
			$("#datadml").submit();
		}
		function doSubmit(obj)
		{
			$(obj).parent().find("button").attr("disabled","disabled");
			var temp=0;
			$(" span img").each(function (){
				if($(this).attr("align")=='absMiddle')
				{
					if($(this).css("display")=='inline')
					{
						temp++;
					}
				}
			});
			if(temp!=0)
			{
				alert("<%=SystemEnv.getHtmlLabelName(30622,user.getLanguage())%>");
				$(obj).parent().find("button").attr("disabled","");
				return;
			}
			//$("input[name='regname']").attr("value",$.trim($("#regnameSpan").html()));
			if($("input[name='regname']").attr("value") == '') {
				alert("<%=SystemEnv.getHtmlLabelName(30622,user.getLanguage())%>");
				return;
			}
			var ischeckfun = $("input[name='isCheckFunction']").attr("value");
			if(ischeckfun == 'no') {
				if(window.confirm("<%=SystemEnv.getHtmlLabelName(30734,user.getLanguage())%>")) {
					$("#datadml").submit();
				}else {
					$(obj).parent().find("button").attr("disabled","");
					return;
				}
			}else if(ischeckfun == '') {
				var funName = $.trim($("input[name='funname']").attr("value"));
				var poolid = $("#poolid").val();
				$.post("/integration/serviceReg/checkSAPFunctionAjax.jsp",{funName:funName,poolid:poolid},function(data){ 
					if(!data["flag"]) {
						$("input[name='funname']").focus().select();
						$("input[name='isCheckFunction']").attr("value","no");
							if(window.confirm("<%=SystemEnv.getHtmlLabelName(30734,user.getLanguage())%>")) {
							$("#datadml").submit();
						}else {
							$(obj).parent().find("button").attr("disabled","");
							return;
						}
					}else {
						$("input[name='isCheckFunction']").attr("value","yes");
						$("#datadml").submit();
					}
				},"json");
			}else if(ischeckfun == 'yes') {
				$("#datadml").submit();
			}
		}
		
		function doSubmitAndParseParams(obj)
		{
			$(obj).parent().find("button").attr("disabled","disabled");
			var temp=0;
			$(" span img").each(function (){
				if($(this).attr("align")=='absMiddle')
				{
					if($(this).css("display")=='inline')
					{
						temp++;
					}
				}
			});
			if(temp!=0)
			{
				alert("<%=SystemEnv.getHtmlLabelName(30622,user.getLanguage())%>");
				$(obj).parent().find("button").attr("disabled","");
				return;
			}
			//$("input[name='regname']").attr("value",$.trim($("#regnameSpan").html()));
			if($("input[name='regname']").attr("value") == '') {
				alert("<%=SystemEnv.getHtmlLabelName(30622,user.getLanguage())%>");
				return;
			}
			var ischeckfun = $("input[name='isCheckFunction']").attr("value");
			if(ischeckfun == 'no') {
							window.alert("<%=SystemEnv.getHtmlLabelName(30733,user.getLanguage())%>");
					$(obj).parent().find("button").attr("disabled","");
					return;
			}else if(ischeckfun == '') {
				var funName = $.trim($("input[name='funname']").attr("value"));
				var poolid = $("#poolid").val();
				$.post("/integration/serviceReg/checkSAPFunctionAjax.jsp",{funName:funName,poolid:poolid},function(data){ 
					if(!data["flag"]) {
						$("input[name='funname']").focus().select();
						$("input[name='isCheckFunction']").attr("value","no");
							window.alert("<%=SystemEnv.getHtmlLabelName(30733,user.getLanguage())%>");
							$(obj).parent().find("button").attr("disabled","");
							return;
					}else {
						if(window.confirm("<%=SystemEnv.getHtmlLabelName(30732,user.getLanguage())%>"))
						{
							$("input[name='isCheckFunction']").attr("value","yes");
							$("input[name='isParseParams']").attr("value","yes");
							$("#datadml").submit();
						}else
						{
							$(obj).parent().find("button").attr("disabled","");
						}
					}
				},"json");
			}else if(ischeckfun == 'yes') {
				$("input[name='isParseParams']").attr("value","yes");
				$("#datadml").submit();
			}
			
			
		}
		
		function doGoBack()
		{
			window.location.href="/integration/serviceReg/serviceReg_3list.jsp?hpid=<%=hpid%>";
		}
		function doDelete(obj,id)
		{
			if(window.confirm("<%=SystemEnv.getHtmlLabelName(30695,user.getLanguage())%>"))
			{
				window.location.href="/integration/serviceReg/serviceReg_3Operation.jsp?isDialog=1&opera=delete&ids="+id+"&hpid=<%=hpid%>";
			}
		}
		function gerparfar()
		{
			if(window.confirm("<%=SystemEnv.getHtmlLabelName(30731,user.getLanguage())%>"))
			{
				$("#opera").attr("value","refresh");
				$("input[name='isParseParams']").attr("value","yes");
				$("#datadml").submit();
			}
		}
		function hideimg(obj,objspan)
		{
			if(obj.value)
			{
				$(objspan).html("");
			}else
			{
				$(objspan).html("<img src='/images/BacoError_wev8.gif' align=absMiddle>");
			}
			
			if($.trim($("input[name='funname']").attr("value")) == '' || $("#poolid").val() == '') {
				//$("#regnameSpan").html("");
			}else {
				getRegNameNum();
			}
			$("input[name='isCheckFunction']").attr("value","");
		}
		
		function getRegName() {
			$("input[name='isCheckFunction']").attr("value","");
			if($.trim($("input[name='funname']").attr("value")) == '' ||  $("#poolid").val() == '') {
				$("#regnameSpan").html("");
			}else {
				getRegNameNum();
			}
		}
		
		function getRegNameNum() {
				var temp  = $.trim($("input[name='funname']").attr("value"))+"_";
				var maxNums = $("input[name='maxNums']").attr("value");
				if(maxNums == '') {
					$.post("/integration/serviceReg/getMaxSAPServcieNumsAjax.jsp",{hpid:'<%=hpid%>'},function(data){ 
						$("#regnameSpan").html("").html(temp+data["content"]);
					},"json");
				}else {
					$("#regnameSpan").html("").html(temp+maxNums);
				}
				
		}
		
		function doTestFunction() {
			$("#btnFunCheck").attr("disabled","disabled");
			
			var funName = $.trim($("input[name='funname']").attr("value"));
			var poolid = $("#poolid").val();
			if(funName == '' || poolid == '') {
				alert("<%=SystemEnv.getHtmlLabelName(30622,user.getLanguage())%>");
				$("#btnFunCheck").attr("disabled","");
				return;
			}
			
			$.post("/integration/serviceReg/checkSAPFunctionAjax.jsp",{funName:funName,poolid:poolid},function(data){ 
				alert(data["message"]);
				$("#btnFunCheck").attr("disabled","");
				if(!data["flag"]) {
					$("input[name='funname']").focus().select();
					$("input[name='isCheckFunction']").attr("value","no");
				}else {
					$("input[name='isCheckFunction']").attr("value","yes");
				}
			},"json");
		}
		
		//限制文本域的长度
		function checkLength(obj,maxlength){
		    if(obj.value.length > maxlength){
		        obj.value = obj.value.substring(0,maxlength);
		    }
		}
		
</script>
</html>

