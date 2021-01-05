
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rsExtend" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="pack" class="weaver.general.ParameterPackage" scope="page"/>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(23142,user.getLanguage());
String needfav ="1";
String needhelp ="";

if(!HrmUserVarify.checkUserRight("LoginPageMaint", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}

String url="";
HashMap kv = (HashMap)pack.packageParams(request, HashMap.class);
String _fromURL = Util.null2String((String)kv.get("_fromURL"));
String loginview = Util.null2String((String)kv.get("loginview"));
String templateid = Util.null2String((String)kv.get("id"));

String tempatename="";
String templateType = "";
String loginTemplateTitle = "";
String domainName = "";

rs.executeSql("select * from SystemLoginTemplate where logintemplateid = "+templateid);
if(rs.next()){
	templateType = rs.getString("templateType");
	loginTemplateTitle = rs.getString("loginTemplateTitle");
	tempatename = rs.getString("loginTemplateName");
	domainName = rs.getString("domainName");
}

url="/systeminfo/template/loginTemplateEditor.jsp?loginTemplateId="+templateid;
	
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<link href="/css/Weaver_wev8.css" type=text/css rel=stylesheet>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>

<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>

<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>





</head>
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%/*
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:checkSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;*/
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<div class="e8_box demo2">
	<div class="e8_boxhead">
		<div class="div_e8_xtree" id="div_e8_xtree"></div>
        <div class="e8_tablogo" id="e8_tablogo"></div>
		<div class="e8_ultab">
			<div class="e8_navtab" id="e8_navtab">
				<span id="objName"></span>
			</div>
			<div>
	
    <ul class="tab_menu">
    	 <li class="current">
        	<a href="javascript:showBaseInfo()" target="">
        		<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage()) %>
        	</a>
        </li>
    	 <li class="">
        	<a href="javascript:showStyleInfo()" target="">
        		<%=SystemEnv.getHtmlLabelName(172,user.getLanguage())+SystemEnv.getHtmlLabelName(1014,user.getLanguage()) %>
        	</a>
        </li>
    </ul>
    <div id="rightBox" class="e8_rightBox"></div>
    		</div>
		</div>
	</div>
    
<div class="tab_box">
    	
<div id="baseInfo" >
<wea:layout type="4Col">
    <wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>' attributes="{'groupDisplay':\"none\"}">
    <wea:item><%=SystemEnv.getHtmlLabelName(32533,user.getLanguage()) %></wea:item>
	<wea:item>
		<input type="text" class="inputstyle" name="templatename" id ="templatename" value="<%=tempatename %>" style="width:200px!important" onchange="checkinput('templatename','saveAsNameSpan')">
		<%
			String display="none";
			if(tempatename.equals("")){
				display = "";
			} 
		%>
        <span id="saveAsNameSpan" style='display:<%=display %>'><img src="/images/BacoError_wev8.gif" align="absMiddle"></span>
	</wea:item>
	 <wea:item><%=SystemEnv.getHtmlLabelName(129976,user.getLanguage()) %></wea:item>
	<wea:item>
		<input type="text" class="inputstyle" name="domainName" id ="domainName" value="<%=domainName %>" style="width:200px!important">
	</wea:item>
	</wea:group>
</wea:layout>
</div>

<div id="typeInfo" class="hide">
	<div style="height:85px;position:relative">
		<div class="templateType" style="left:10px;" type='V'>
			<img src="/images/ecology8/homepage/login-v_wev8.png" style="margin-top: 3px;">
		</div>
		<div class="templateType" style="left:120px;" type='H'>
			<img src='/images/ecology8/homepage/login-h_wev8.png' style="margin-top: 3px;">
		</div>
		<div class="templateType " style="left:230px;" type='H2'>
			<img src='/images/ecology8/homepage/login-h2_wev8.png' style="margin-top: 3px;">
		</div>
		<div class="templateType " style="left:340px;" type='E8'>
			<img src='/images/ecology8/homepage/login-e8_wev8.png' style="margin-top: 3px;">
		</div>
		<div class="templateType " style="left:450px;" type='site'>
			<img src='/images/ecology8/homepage/custemplate_wev8.png'  style="margin-top: 3px;width:92px;height:57px">
		</div>
	</div>
</div>

<div id="winTitle" style="height:30px;background-color:#4f81bd;position:relative;">
	<div style="color:#fff;padding-top:5px;padding-left:10px;" class='editor' id="templateTitle" type='text'>
		<%=loginTemplateTitle %>
	</div>
	<div style="color:#fff;padding-top:2px;padding-left:10px;" id="templateTitleEditor" class="hide" >
		<input class='inputstyle' type='text' value='<%=loginTemplateTitle %>'>
	</div>
</div>    
      
	<iframe style='' onload="update();" src="<%=url %>&init=true" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;" ></iframe>
</div>
</div>
</body>
</html>

<script language="javascript">
jQuery(function(){
    jQuery('.e8_box').Tabs({
        getLine:1,
        iframe:"tabcontentframe",
        mouldID:"<%= MouldIDConst.getID("portal")%>",
        staticOnLoad:true,
        objName:"<%=SystemEnv.getHtmlLabelName(32459,user.getLanguage()) %>"
    });
    
    $(".templateType").bind("click",function(){
    	$(".select").removeClass("select");
    	$(this).addClass("select");
		$.post("/systeminfo/template/loginTemplateTempOperation.jsp",{method:'update',tbname:'SystemLoginTemplate',field:'templatetype',value:$(this).attr('type')},function(){
			
			$("#tabcontentframe").attr("src","<%=url %>")
		});

    });
    
    
    
    $("#templateTitle").click(
		 function(){
		 	$(this).hide();
		 	$("#templateTitleEditor").show();
		 }
	);
	$("#templateTitle").hover(
		function(){jQuery(this).css({"border":"1px dashed red","cursor":"pointer"})},
		function(){jQuery(this).css({"border":"0","cursor":"normal"})}
	) 
	
    $(".templateType[type='<%=templateType%>']").addClass("select");
    
    $("#templateTitleEditor").find("input").bind("blur",function(){
    	$this = $(this);
    	if($this.val()!=$("#templateTitle").text()){
    		$.post("/systeminfo/template/loginTemplateTempOperation.jsp",{method:'update',tbname:'SystemLoginTemplate',field:'loginTemplateTitle',value:$(this).val()},function(data){
				data = $.parseJSON(data);
				if(data.__result__===false){
					top.Dialog.alert(data.__msg__);
				}
			});
    	}
    	$("#templateTitle").text($this.val())
		$("#templateTitleEditor").hide();
		$("#templateTitle").show();
    	
    });
    
    $("#templatename").bind("change",function(){
    	$this = $(this);
    	$.post("/systeminfo/template/loginTemplateTempOperation.jsp",{method:'update',tbname:'SystemLoginTemplate',field:'loginTemplateName',value:$this.val()},function(data){
			data = $.parseJSON(data);
			if(data.__result__===false){
				top.Dialog.alert(data.__msg__);
			}
		});
    });
	
	$("#domainName").bind("change",function(){
    	$this = $(this);
    	$.post("/systeminfo/template/loginTemplateTempOperation.jsp",{method:'update',tbname:'SystemLoginTemplate',field:'domainName',value:$this.val()},function(data){
			data = $.parseJSON(data);
			if(data.__result__===false){
				top.Dialog.alert(data.__msg__);
			}
		});
    });
    
    jQuery("#tabcontentframe").height(jQuery("div.e8_box div.tab_box").height()-jQuery("#baseInfo").height()-30);
});

function showBaseInfo(){
	$("#baseInfo").parent().show();
	$("#baseInfo").show();
	$("#typeInfo").hide();
	$("#winTitle").show();
	jQuery("#tabcontentframe").height(jQuery("div.e8_box div.tab_box").height()-jQuery("#baseInfo").height()-30);
}

	
function showStyleInfo(){
	$("#baseInfo").parent().show();
	$("#baseInfo").hide();
	$("#typeInfo").show();
	$("#winTitle").show();
	jQuery("#tabcontentframe").height(jQuery("div.e8_box div.tab_box").height()-jQuery("#typeInfo").height()-30);
}

function refreshTab(){
	var f = window.parent.oTd1.style.display;
	if (f != null) {
		if(f==''){
			window.parent.oTd1.style.display='none';
		}else{ 
			window.parent.oTd1.style.display='';
			window.parent.wfleftFrame.setHeight();
		}
	}
}


function getLoginTemplateName(){
	return $("#templatename").val();
}


</script>

<style>
	.templateType{
		position:absolute;
		height:65px;
		width:100px;
		top:5px;
		text-align:center;
		cursor:pointer;
	}
	
	.select{
		background:#2690e3;
	}
	
	#templateTitle{
		cursor:text;
	}
</style>
