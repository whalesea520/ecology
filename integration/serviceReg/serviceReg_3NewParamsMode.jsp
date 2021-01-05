
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="com.weaver.integration.params.*,com.weaver.integration.datesource.*,com.weaver.integration.util.*" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<link href="/css/Weaver_wev8.css" type=text/css rel=stylesheet>
<link href="/integration/css/intepublic_wev8.css" type=text/css rel=stylesheet>
<link href="/integration/css/loading_wev8.css" type=text/css rel=stylesheet>
<jsp:useBean id="SapUtil" class="com.weaver.integration.util.IntegratedUtil" scope="page"/>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<%
			String servId = Util.null2String(request.getParameter("servId"));
			String browserId = Util.null2String(request.getParameter("browserId"));
			String poolid = Util.null2String(request.getParameter("poolid"));
			
			SAPInterationBean sib = SAPInterationDateSourceUtil.getSAPBean(poolid);
			String poolname = "";
			String serviceName = "";
			String sapfunname = "";
			String browserName = "";
			ServiceParamModeBean spmb = null;
			if(!"".equals(browserId)) {
				spmb = ServiceParamModeUtil.getSerParModBeanById(browserId, true);
			}
			if(spmb != null) {
				browserName = spmb.getParamModeName();
			}
			browserName = "".equals(browserName)?SystemEnv.getHtmlLabelName(30737,user.getLanguage()):SystemEnv.getHtmlLabelName(30736,user.getLanguage())+"-"+browserName;
			if(sib != null) {
				poolname = sib.getPoolname();
			}
			SAPServiceBean ssb = new SAPServcieUtil().getRegNameAndSAPFunctionById(servId);
			if(ssb != null) {
				serviceName = ssb.getRegname();
				sapfunname = ssb.getFunname();
			}
			
%>
<html>
	<head>
		<title><%=SystemEnv.getHtmlLabelName(30735,user.getLanguage())%>-<%=browserName %></title>
		<style type="text/css">
			.selectItemCss {
				width:250px;
				margin-right: 0px;
			}
		</style>
	</head>
	<body>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="integration"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(30735,user.getLanguage())%>"/> 
</jsp:include>
		
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
		RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSubmit(this,1),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
		//RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:doGoBack(this),_self} " ;
		//RCMenuHeight += RCMenuHeightStep ;
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0" width="100%">
	<tr>
		<td width="160px">
		</td>
		<td class="rightSearchSpan"
			style="text-align: right; width: 500px !important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" id="zd_btn_submit_0" class="e8_btn_top" onclick="doSubmit(this,1);">
			&nbsp;&nbsp;&nbsp;
			<span title="<%=SystemEnv.getHtmlLabelName(82753,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>

<wea:layout type="2Col">
    <wea:group context='<%=SystemEnv.getHtmlLabelName(30735,user.getLanguage())+"-"+browserName%>' attributes="{'groupDisplay':\"\"}">
	<wea:item>SAP <%=SystemEnv.getHtmlLabelName(30660,user.getLanguage())%></wea:item>
    <wea:item>
        <select id="poolid" disabled="disabled" style="width:250px;">
			<option value="<%=poolid %>"><%=poolname %></option>
		</select>
    </wea:item>
	<wea:item><%=SystemEnv.getHtmlLabelName(30738,user.getLanguage())%></wea:item>
    <wea:item >
        <select id="servId" disabled="disabled" style="width:250px;">
			<option value="<%=servId %>"><%=serviceName %></option>
		</select>
    </wea:item>
	<wea:item><%=SystemEnv.getHtmlLabelName(30739,user.getLanguage())%></wea:item>
    <wea:item>
        <%=sapfunname%>
		<input type="hidden" style="width:250px;height:30px;" name="sapfunname" value="<%=sapfunname%>">
		<input type="hidden" id="marktemp" name="marktemp" value="<%=browserId%>">
    </wea:item>
	</wea:group>
</wea:layout>

		<div style="width: 99%;padding: 10px;">
		<iframe src="/integration/serviceReg/serviceReg_3NewParamsModeSet.jsp?browserId=<%=browserId %>&servId=<%=servId %>&poolid=<%=poolid %>" style="width: 100%;height: 400px;" frameborder="0" scrolling="no" id="maindiv">
		</iframe>
		</div>
		
	
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
		<script type="text/javascript">
			var temp=document.body.clientWidth;
			$("#hidediv").css("height",temp);
			var h2=$("#hidedivmsg").css("height");
			var w2=$("#hidedivmsg").css("width");
			var a=(document.body.clientWidth)/2-140; 
			var b=(document.body.clientHeight)/2-40;
			$("#hidedivmsg").css("left",a);
			$("#hidedivmsg").css("top",b);
			$("#hidediv").show();
			$("#hidedivmsg").html("<%=SystemEnv.getHtmlLabelName(20240,user.getLanguage())%> ").show();
		</script>
		<script type="text/javascript">
			var dialog = top.getDialog(window);
			function closeWindow(id)
			 {
			 	
			 	if(dialog){
						
					  		try{
						     dialog.callbackfun(id);
						
						 }catch(e){alert(e)}
					  	try{
						     dialog.close(id);
						
						 }catch(e){alert(e)}
					}else{
			 	 		window.returnValue=id;
			 	 		window.close();
			 	 	}
				
			 }
			 
			 function doGoBack() {
			 	
			  	if(dialog){
				 	dialog.close();
				 }else{
				 	window.close();
				 }
			 }
		
			function onCancel(){
				var dialog = parent.getDialog(window);   //弹出窗口的引用，用于关闭页面
				dialog.close();
			}
			//数据提交
			function doSubmit(obj,dataauth)
			{
			
				//验证外层页面的数据必填性
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
					alert("<%=SystemEnv.getHtmlLabelName(30622,user.getLanguage()) %>!");
					return;
				}
				
				//验证内层页面的数据必填性
				
				var tempDoc = window.frames["maindiv"];
				tempDoc =$("#maindiv")[0].contentWindow;
				//alert(tempDoc);
				if(tempDoc.checkRequired())
				{
					//alert($("#mark").val()+"__"+$("#hpid").val());
				
			
					//判断是否显示数据授权界面
					var temp=document.body.clientWidth;
					$("#hidediv").css("height",temp);
					var h2=$("#hidedivmsg").css("height");
					var w2=$("#hidedivmsg").css("width");
					var a=(document.body.clientWidth)/2-140; 
					var b=(document.body.clientHeight)/2-40;
					$("#hidedivmsg").css("left",a);
					$("#hidedivmsg").css("top",b);
					$("#hidediv").show();
					$("#hidedivmsg").html("<%=SystemEnv.getHtmlLabelName(20240,user.getLanguage())%>").show();
					tempDoc.document.getElementById("weaver").submit();
				}
			}
			 $(window).unload(function () {
			 	 if($("#marktemp").val()!="")
			 	 {	
			 	 	window.returnValue=$("#marktemp").val();
			 	 }	
			 });
			 function changeurl(utlstr)
			 {
			 	//参考http://www.jb51.net/article/21139.htm
			 	window.name = "__self"; 
				window.open(utlstr, "__self"); 
				
			 }
			 
			 function doGoBack() {
				 window.close();
			 }
		</script>
	</body>
</html>

