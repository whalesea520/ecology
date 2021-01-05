
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="SocialSetting" class="weaver.social.SocialSetting" scope="page" />
<script language=javascript src="/js/weaver_wev8.js"></script>
<html>
<head>
<%

String userid=""+user.getUID();
String discussName = Util.null2String(request.getParameter("discussName"));
String targetid = Util.null2String(request.getParameter("targetid"));
String creatorid = Util.null2String(request.getParameter("creatorid"));
String targetType = Util.null2String(request.getParameter("targetType"));
String isCreator=userid.equals(creatorid)?"1":"0";
//out.println("userid:"+userid+" creatorid:"+creatorid+" isCreator:"+isCreator);
String remindType="1";
Map<String,String> result=SocialSetting.getImSetting(userid,targetid);
if(result!=null){
	remindType=result.get("remindType");
}
%>

</head>

<body scroll="no">
<!-- 设置 -->
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="social"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(68, user.getLanguage())%>"/>
</jsp:include>

    <!-- 群组名称  弹出提醒-->
	<wea:layout>
		<wea:group context="" attributes="{'groupDisplay':'none'}">
			<%if(targetType.equals("1")&&isCreator.equals("1")){%>
				<wea:item><%=SystemEnv.getHtmlLabelName(24679, user.getLanguage())%></wea:item>
				<wea:item >
					<wea:required id="titlenamespan" required="true" value="<%=discussName%>">
						<input class=inputstyle type=text name="titlename" id="titlename" value="<%=discussName%>"
							onkeydown="if(window.event.keyCode==13) return false;" onChange="checkinput('titlename','titlenamespan')" style="width:80%" >
					</wea:required> 
				</wea:item>
			<%}%> 
			<wea:item><%=SystemEnv.getHtmlLabelName(126976, user.getLanguage())%></wea:item>
			<wea:item >
				 <input type="checkbox" name="remindType" <%=remindType.equals("1")?"checked":""%> value="1" id="remindType"/>
			</wea:item>
		</wea:group>
	</wea:layout>	
	
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout>
			<wea:group context="" attributes="{groupDisplay:none}">
				<wea:item type="toolbar">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage()) %>" id="zd_btn_confirm" class="zd_btn_cancle" onclick="doSave()"/>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="parent.getDialog(window).close();">
				</wea:item>
			</wea:group>
		</wea:layout>
	</div>
</body>

<script type="text/javascript">
	var parentWin=parent.getParentWindow(window);
	var isCreater=<%=isCreator%>;
	var discussid="<%=targetid%>";
	var targetType="<%=targetType%>";
	var targetid="<%=targetid%>";
	function doSave(){
		if(targetType==1&&isCreater==1){
			changeDiscussTitle();
		}else{
			editIMSetting();
		}
	}
	
	function editIMSetting(){
		var remindType=$("#remindType").attr("checked")?"1":"0";
		$.post("/social/im/SocialIMOperation.jsp?operation=editIMSetting",{"targetid":targetid,"targetType":targetType,"remindType":remindType},function(data){
			var settingInfo=eval("("+data+")");
			parentWin.refreshDiscussSetting(settingInfo);
			parent.getDialog(window).close();
		})
	}
	
	function changeDiscussTitle(){
	  	var discusstitle = '<%=discussName%>';
	  	var discussid = '<%=targetid%>';
	   	var newDiscusstitle = $('#titlename').val();
	   	if(newDiscusstitle==""){
            // 请填写群组名称
	   		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(126964, user.getLanguage())%>",function(){
	   			$('#titlename').focus();
	   		});
	   	}else if($.trim(newDiscusstitle) == discusstitle){
	   		editIMSetting();
	   	}else{
	   		parentWin.client.setDiscussionName(discussid, newDiscusstitle, function(){
	   			parentWin.refreshDiscussTitle(discussid);
	   			editIMSetting();
	   		});
	   	}
	  }
</script>  
</html>

