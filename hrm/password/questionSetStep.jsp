
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<!-- Added by wcd 2014-12-17 [密保设置] -->
<%@ include file="/hrm/header.jsp" %>
<%@ page import="weaver.hrm.passwordprotection.domain.HrmPasswordProtectionQuestion" %>
<jsp:useBean id="questionManager" class="weaver.hrm.passwordprotection.manager.HrmPasswordProtectionQuestionManager" scope="page"/>
<%
	String isDialog = Tools.vString(request.getParameter("isdialog"),"1");
	int pStep = Tools.parseToInt(request.getParameter("pStep"),1);
	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(81605,user.getLanguage());
	String needfav ="1";
	String needhelp ="";
	boolean isVerifyPswd = true;
	User userVerifyPswd = (User)session.getAttribute("verifyPswd");	
		if(userVerifyPswd == null) {
		isVerifyPswd = false;
		out.println("system error!");
		return;
	}
	Map map = new HashMap();
	map.put("userId", String.valueOf(user.getUID()));
	if(pStep == 2){
		map.put("sqlorderby",rs.getDBType().equals("oracle") ? "t.id * dbms_random.value()" : "newid()");
	} else {
		map.put("sqlorderby","t.id asc");
	}
	List list = questionManager.find(map);
	int qSize = list == null ? 0 : list.size();
	HrmPasswordProtectionQuestion question = null;
%>
<HTML>
	<HEAD>
		<link type="text/css" rel="stylesheet" href="/css/Weaver_wev8.css" />
		<script language="javascript" src="/js/weaver_wev8.js"></script>
		<link type="text/css" rel="stylesheet" href="/appres/hrm/css/mfcommon_wev8.css" />
		<script language="javascript" type="text/javascript" src="/appres/hrm/js/mfcommon_wev8.js"></script>
		<script language="javascript" src="/js/ecology8/request/e8.browser_wev8.js"></script>
		<link type="text/css" href="/js/ecology8/base/jquery-ui_wev8.css" rel="stylesheet">
		<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
		<script src="/wui/theme/ecology8/weaveredittable/js/WeaverEditTable_wev8.js"></script>
		<link rel="stylesheet" href="/wui/theme/ecology8/weaveredittable/css/WeaverEditTable_wev8.css">
		<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
		<script language="javascript">
			var common = new MFCommon();
			var pStep = "<%=pStep%>";
			var qSize = "<%=qSize%>";
			var isVerifyPswd = "<%=isVerifyPswd%>";
			var parentWin = parent.parent.getParentWindow(parent);
			var parentDialog = parent.parent.getDialog(parent);
			$(function(){
				if(isVerifyPswd != "true"){
					parentWin.close();
				}
			});
			
			function doBack(){
				$GetEle("pStep").value = Number(pStep)-1;
				document.frmMain.submit();
			}
			
			function doNext(){
				if(pStep == 1){
					if(checkCount()){
						if(checkValue()){
							if(checkSpecial()) {
								window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(129871,user.getLanguage())%>");
								return;
							}
							$GetEle("pStep").value = Number(pStep)+1;
							document.frmMain.submit();
						} else {
							window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(30933,user.getLanguage())%>");
						}
					} else {
						window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(81609,user.getLanguage())%>");
					}
				} else if(pStep == 2){
					if(checkAnswer()){
						$GetEle("pStep").value = Number(pStep)+1;
						document.frmMain.submit();
						window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("81605,16746",user.getLanguage())%>",function(){
							parentWin.close($GetEle("pStep").value);
						});
					}
				}
			}
			
			function checkInput(input, span){
				if(input.value != ""){
					$GetEle(span).innerHTML = "";
				} else {
					$GetEle(span).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align='absMiddle'>";
				}
			}
			
			function checkInput1(input, span){
				if(input.value != ""){
					$GetEle(span).style.display = "none";
				} else {
					$GetEle(span).style.display = "block";
				}
			}
			
			function checkAnswer(){
				var rAnswer = "", vAnswer = "", errorMessage = "<%=SystemEnv.getHtmlLabelName(81613,user.getLanguage())%>";
				for(var i=0; i<qSize; i++){
					rAnswer = $GetEle("answer"+i) ? $GetEle("answer"+i).value : "";
					if(!rAnswer){
						window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(30933,user.getLanguage())%>");
						return false;
					}
				}
				for(var i=0; i<qSize; i++){
					rAnswer = $GetEle("answer"+i) ? $GetEle("answer"+i).value : "";
					vAnswer = $GetEle("v_answer"+i) ? $GetEle("v_answer"+i).value : "";
					if(rAnswer != vAnswer){
						window.top.Dialog.alert(errorMessage.replace("{param}"," "+(i+1)+" "));
						return false;
					}
				}
				return true;
			}
		</script>
	</HEAD>
	<BODY>
		<%if("1".equals(isDialog)){ %>
			<div class="zDialog_div_content">
		<%} %>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
			if(pStep == 2 || pStep == 3){
				RCMenu += "{"+SystemEnv.getHtmlLabelName(1876,user.getLanguage())+",javascript:doBack(),_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
			}
			if(pStep == 1 || pStep == 2){
				RCMenu += "{"+SystemEnv.getHtmlLabelName(1402,user.getLanguage())+",javascript:doNext(),_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
			}
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td></td>
				<td class="rightSearchSpan" style="text-align:right;">
					<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		<form id="weaver" name="frmMain" action="" method="post">
			<input type="hidden" name="userId" value="<%=String.valueOf(user.getUID())%>">
			<input type="hidden" name="pStep" value="<%=pStep%>">
			<div style="text-align:center;margin:auto;width:100%;height:100px;">
				<%if(user.getLanguage()==7){%>
					<div style="background:url(/appres/hrm/image/password/step<%=pStep%>_wev8.gif) no-repeat;" class="step_image"></div>
				<%}else{%>
					<div style="background:url(/appres/hrm/image/password/en_step<%=pStep%>_wev8.gif) no-repeat;" class="step_image"></div>
				<%}%>
			</div>
			<div id="questions" class="groupmain" style="width: 100%;"></div>
			<%
				StringBuilder datas = new StringBuilder();
				for(int i=0; i<qSize; i++){
					question = (HrmPasswordProtectionQuestion)list.get(i);
					datas.append("[")
					.append("{name:'question',value:'").append(question.getQuestion()).append("',iseditable:true,type:'input'},")
					.append("{name:'answer',value:'").append(question.getAnswer()).append("',iseditable:true,type:'input'}")
					.append("],");
				}
				if(pStep == 1 && qSize == 0){
					datas.append("[")
					.append("{name:'question',value:'',iseditable:true,type:'input'},")
					.append("{name:'answer',value:'',iseditable:true,type:'input'}")
					.append("],");
				}
				String ajaxData = datas.toString();
				if(ajaxData.length() > 0){
					ajaxData = ajaxData.substring(0,ajaxData.length()-1);
				}
				ajaxData = "["+ajaxData+"]";
			%>
			<%if(pStep == 1){%>
			<script>
				var items=[
				{width:"40%",tdclass:"desclass",colname:"<%=SystemEnv.getHtmlLabelName(24419,user.getLanguage())%>",itemhtml:"<input class=inputstyle type=text style='width:90%' name='question' onblur='checkInput1(this,\"questionspan\")'/><span id='questionspan' class='mustinput'></span>"},
				{width:"55%",colname:"<%=SystemEnv.getHtmlLabelName(24122,user.getLanguage())%>",itemhtml:"<input class=inputstyle type=text style='width:90%' name='answer' onblur='checkInput1(this,\"answerspan\")' /><span id='answerspan' class='mustinput'></span>"}];
				
				var option= {
					openindex:true,
					navcolor:"#003399",
					basictitle:"<%=SystemEnv.getHtmlLabelName(81611,user.getLanguage())%>",
					toolbarshow:true,
					colItems:items,
					addrowtitle:"<%=SystemEnv.getHtmlLabelNames("611,81605",user.getLanguage())%>",
					deleterowstitle:"<%=SystemEnv.getHtmlLabelNames("91,81605",user.getLanguage())%>",
					usesimpledata: true,
					initdatas:eval("<%=ajaxData%>"),
					canDrag:false,
					addrowCallBack:function(that,tr,entry) {
						if($GetEle("weaverTableRealRows") && Number($GetEle("weaverTableRealRows").value) >= 6){
							common.removeEditTableTr(group, tr);
							window.top.Dialog.alert("<%=Tools.replace(SystemEnv.getHtmlLabelName(81610,user.getLanguage()),"{param}","5")%>");
						}
					},
					configCheckBox:true,
					checkBoxItem:{"itemhtml":'<input name="check_node" class="groupselectbox" type="checkbox" >',width:"5%"}
				};
				
				var group = new WeaverEditTable(option);
				$("#questions").append(group.getContainer());
				
				function checkCount(){
					return group && group.realCount > 0;
				}
			   
				function checkValue(){
					var result = true;
					var inputItems = group.container.find(".grouptable").find("input[type='text']");
					for(var i= 0;i<inputItems.length;i++) {
						if(escape($(inputItems[i]).val()).trim() == ""){
							result = false;
							break;
						}
					}
					if(result){
						var inputParams = "", params = "cmd=insertQuestion&userid=<%=user.getUID()%>";
						for(var i = 0;i<inputItems.length;i++) {
							inputParams += "&" + $(inputItems[i]).attr("name")+"="+escape($(inputItems[i]).val());
						}
						common.ajax(params+inputParams, true);
					}
					return result;
				}

				function checkSpecial() {
					var result = false;
					var inputItems = group.container.find(".grouptable").find("input[type='text']");
					for(var i= 0;i<inputItems.length;i++) {
						if(i % 2 == 1) {
							var pattern = new RegExp("[`~!@#$^&*()=|{}':;',\\[\\].<>/?~！@#￥……&*（）——|{}【】‘；：”“'。，、？]");
							if(pattern.test($(inputItems[i]).val().trim())) {
								result = true;
								break;
							}
						}
					}
					return result;
				}
			</script>
			<%} else if(pStep == 2){%>
				<wea:layout type="2col" attributes="{'expandAllGroup':'true'}">
					<wea:group context='<%=SystemEnv.getHtmlLabelName(81612,user.getLanguage())%>' attributes="{'groupOperDisplay':'none'}">
						<%
						for(int i=0; i<qSize; i++){
							question = (HrmPasswordProtectionQuestion)list.get(i);
						%>
						<wea:item><%=SystemEnv.getHtmlLabelName(24419,user.getLanguage())+(i+1)%>:</wea:item>
						<wea:item><%=question.getQuestion()%>&nbsp;</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(24122,user.getLanguage())+(i+1)%>:</wea:item>
						<wea:item>
							<input type="text" class="InputStyle" id="answer<%=i%>" name="answer<%=i%>" style="width:60%" onblur='checkInput(this,"mustinput<%=i%>")'>
							<input type="hidden" id="v_answer<%=i%>" name="v_answer<%=i%>" value="<%=question.getAnswer()%>">
							<span id='mustinput<%=i%>' name='mustinput<%=i%>'><img align="absMiddle" src="/images/BacoError_wev8.gif"/></span>
						</wea:item>
						<%}%>
					</wea:group>
				</wea:layout>
			<%}%>
		</form>
<%if("1".equals(isDialog)){ %>
	</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout type="2col">
	    	<wea:group context="">
		    	<wea:item type="toolbar">
					<%if(pStep == 2){%>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(1876,user.getLanguage())%>" class="e8_btn_cancel" onclick="doBack()">
					<%}%>
					<%if(pStep == 1 || pStep == 2){%>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(1402,user.getLanguage())%>" class="e8_btn_cancel" onclick="doNext()">
					<%}%>
		    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" class="e8_btn_cancel" onclick="parentWin.close(pStep);">
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
