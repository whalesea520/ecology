<!DOCTYPE html>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<html>
<head>
    <title></title>
    <style>
        *{ margin:0; padding:0;}
        .aa{ width: 980px;}
        .help{ padding-left: 50px; padding-right: 50px; line-height: 18px; list-style: none; font-size: 12px; width:80%;}
		.help li{color:#848585; padding-left: 25px; }
        .help .b{ height: 40px; font-weight: bold; line-height:40px;color:#373737;padding-left: 0px; cursor: pointer;}
        .help .b2{ height: 40px; font-weight: bold; line-height:40px;color:#373737;padding-left: 0px; cursor: pointer;background-color: #def0ff;}
        .help .a{padding-left: 0px;display:none;}
        /*img {position: relative;top:3px;}*/
         img{ vertical-align:middle;margin-top:0px;}
        .helpbutton{width:42px;height:40px;border: 0px;float: left;font-size: 12px;color:#FFFFFF;cursor: pointer;}
        .helpbutton2{width:42px;height:40px;border: 0px;float: left;font-size: 12px;color:#FFFFFF;cursor: pointer;}
    </style>

</head>
<body>
<div class="aa">

<ul class="help">
    <li class="b" onmouseover="onLiOver(this)" onmouseout="onLiOut(this)" name="wftype"><img src="/images/ecology8/workflow/workflowtype_wev8.png" /><img name="blank" src="/images/ecology8/workflow/blank_wev8.jpg"><%=SystemEnv.getHtmlLabelName(16579, user.getLanguage())%></li>
    <li><%=SystemEnv.getHtmlLabelName(129453, user.getLanguage())%></li>
    <li class="b" onmouseover="onLiOver(this)" onmouseout="onLiOut(this)" name="wfname"><img src="/images/ecology8/workflow/workflowname_wev8.png" /><img name="blank" src="/images/ecology8/workflow/blank_wev8.jpg"><%=SystemEnv.getHtmlLabelName(18104, user.getLanguage())%></li>
    <li><%=SystemEnv.getHtmlLabelName(129454, user.getLanguage())%></li>    
    <li class="b" onclick="showHidden(this,'field')" onmouseover="onLiOver(this)" onmouseout="onLiOut(this)" name="field"><img src="/images/ecology8/workflow/field_wev8.png" /><img name="pointto" src="/images/ecology8/workflow/pointto_wev8.png"><%=SystemEnv.getHtmlLabelName(261, user.getLanguage())%></li>
    <li><%=SystemEnv.getHtmlLabelName(129455, user.getLanguage())%></li>
    <li class="a" id="field">
    	<ul class="help">
    		<li class="b" onmouseover="onLiOver(this)" onmouseout="onLiOut(this)" name="mainfield"><%=SystemEnv.getHtmlLabelName(18549, user.getLanguage())%></li>
    		<li><%=SystemEnv.getHtmlLabelName(129479, user.getLanguage())%></li>  
    		<li class="b" onmouseover="onLiOver(this)" onmouseout="onLiOut(this)" name="detailfield"><%=SystemEnv.getHtmlLabelName(18550, user.getLanguage())%></li>
    		<li><%=SystemEnv.getHtmlLabelName(129480, user.getLanguage())%></li>     		  		
    	</ul>
    </li>
    <li class="b" onclick="showHidden(this,'wftable')" onmouseover="onLiOver(this)" onmouseout="onLiOut(this)" name="wftable"><img src="/images/ecology8/workflow/form_wev8.png" /><img name="pointto" src="/images/ecology8/workflow/pointto_wev8.png"><%=SystemEnv.getHtmlLabelName(700, user.getLanguage())%></li>
    <li><%=SystemEnv.getHtmlLabelName(129456, user.getLanguage())%></li>
    <li class="a" id="wftable">
    	<ul class="help">
    		<li class="b"><%=SystemEnv.getHtmlLabelName(18368, user.getLanguage())%></li>
    		<li><%=SystemEnv.getHtmlLabelName(129481, user.getLanguage())%></li>  
    		<li class="b"><%=SystemEnv.getHtmlLabelName(18369, user.getLanguage())%></li>
    		<li><%=SystemEnv.getHtmlLabelName(129482, user.getLanguage())%></li>     		  		
    		<li class="b"><%=SystemEnv.getHtmlLabelName(18017, user.getLanguage())%></li>
    		<li><%=SystemEnv.getHtmlLabelName(129467, user.getLanguage())%></li>
    		<li class="b">html<%=SystemEnv.getHtmlLabelName(19071, user.getLanguage())%></li>
    		<li><%=SystemEnv.getHtmlLabelName(129468, user.getLanguage())%></li>
    		<li class="b"><%=SystemEnv.getHtmlLabelName(16450, user.getLanguage())%></li>
    		<li><%=SystemEnv.getHtmlLabelName(129483, user.getLanguage())%></li>
    		<li class="b"><%=SystemEnv.getHtmlLabelName(128952, user.getLanguage())%></li>
    		<li><%=SystemEnv.getHtmlLabelName(129484, user.getLanguage())%></li>
    	</ul>    
    </li>
    <li class="b" onclick="showHidden(this,'node')"><img src="/images/ecology8/workflow/node_wev8.png" /><img name="pointto" src="/images/ecology8/workflow/pointto_wev8.png"><%=SystemEnv.getHtmlLabelName(15586, user.getLanguage())%></li>
    <li><%=SystemEnv.getHtmlLabelName(129457, user.getLanguage())%></li>
    <li class="a" id="node">
    	<ul class="help">
    		<li class="b"><%=SystemEnv.getHtmlLabelNames("125,15586",user.getLanguage()) %></li>
    		<li><%=SystemEnv.getHtmlLabelName(129485, user.getLanguage())%></li>  
    		<li class="b"><%=SystemEnv.getHtmlLabelNames("359,15586",user.getLanguage()) %></li>
    		<li><%=SystemEnv.getHtmlLabelName(129486, user.getLanguage())%></li>     		  		
    		<li class="b"><%=SystemEnv.getHtmlLabelNames("553,15586",user.getLanguage()) %></li>
    		<li><%=SystemEnv.getHtmlLabelName(129487, user.getLanguage())%></li>
    		<li class="b"><%=SystemEnv.getHtmlLabelNames("251,15586",user.getLanguage()) %></li>
    		<li><%=SystemEnv.getHtmlLabelName(129488, user.getLanguage())%></li>
    		<li class="b"><%=SystemEnv.getHtmlLabelName(99, user.getLanguage())%></li>
    		<li><%=SystemEnv.getHtmlLabelName(129466, user.getLanguage())%></li>
    		<li class="b"><%=SystemEnv.getHtmlLabelName(15072, user.getLanguage())%></li>
    		<li><%=SystemEnv.getHtmlLabelName(129492, user.getLanguage())%></li>
    		<li class="b"><%=SystemEnv.getHtmlLabelName(18887, user.getLanguage())%></li>
    		<li><%=SystemEnv.getHtmlLabelName(129470, user.getLanguage())%></li>
    	</ul>    
    </li> 
    <li class="b" onclick="showHidden(this,'outlet')"><img src="/images/ecology8/workflow/out_wev8.png" /><img name="pointto" src="/images/ecology8/workflow/pointto_wev8.png"><%=SystemEnv.getHtmlLabelName(15587, user.getLanguage())%></li>
    <li><%=SystemEnv.getHtmlLabelName(129458, user.getLanguage())%></li>
    <li class="a" id="outlet">
    	<ul class="help">
    		<li class="b"><%=SystemEnv.getHtmlLabelName(33413, user.getLanguage())%></li>
    		<li><%=SystemEnv.getHtmlLabelName(129461, user.getLanguage())%></li>  
    	</ul>    
    </li>  
    <li class="b"><img src="/images/ecology8/workflow/editpicture_wev8.png" /><img src="/images/ecology8/workflow/blank_wev8.jpg"><%=SystemEnv.getHtmlLabelName(16459, user.getLanguage())%></li>
    <li><%=SystemEnv.getHtmlLabelName(129459, user.getLanguage())%></li>  
    <li class="b" onclick="showHidden(this,'wftest')"><img src="/images/ecology8/workflow/workflowtest_wev8.png" /><img name="pointto" src="/images/ecology8/workflow/pointto_wev8.png"><%=SystemEnv.getHtmlLabelName(25497, user.getLanguage())%></li>
    <li><%=SystemEnv.getHtmlLabelName(129460, user.getLanguage())%></li>
    <li class="a" id="wftest">
    	<ul class="help">
    		<li class="b"><%=SystemEnv.getHtmlLabelNames("81855,25496",user.getLanguage()) %></li>
    		<li><%=SystemEnv.getHtmlLabelName(129493, user.getLanguage())%></li>  
    		<li class="b" onmouseover="onLiOver(this)" onmouseout="onLiOut(this)" name="wftest"><%=SystemEnv.getHtmlLabelName(129495, user.getLanguage())%></li>
    		<li><%=SystemEnv.getHtmlLabelName(129494, user.getLanguage())%></li>      		
    	</ul>    
    </li>              
</ul>
</div>
<div style="height:40px;width:100px;padding-left:12px;position: absolute;display:none;" id="caozuoDiv">
	<img  id="addNew"  class="helpbutton" onmouseover="onButtonOver(this,'addtype')" onmouseout="onButtonOut(this,'addtype')" src="/images/ecology8/workflow/add_wev8.png">
	<img  id="maintain" class="helpbutton" onmouseover="onButtonOver(this,'edittype')" onmouseout="onButtonOut(this,'edittype')" src="/images/ecology8/workflow/setup_wev8.png">
</div>
<script type="text/javascript">
function onButtonOver(obj,type){
	if(type=="addtype"){
		$(obj).attr("src","/images/ecology8/workflow/add-hot_wev8.png");
	}else{
		$(obj).attr("src","/images/ecology8/workflow/setup-hot_wev8.png");
	}
	//$(obj).removeClass("helpbutton").addClass("helpbutton2");
}

function onButtonOut(obj,type){
	if(type=="addtype"){
		$(obj).attr("src","/images/ecology8/workflow/add_wev8.png");
	}else{
		$(obj).attr("src","/images/ecology8/workflow/setup_wev8.png");
	}
	//$(obj).removeClass("helpbutton2").addClass("helpbutton");
}

function showHidden(obj,type){
	var text = $(obj).html();
		text = text.substring(1);
	var display = $("#"+type).css("display")
	if(display=="none"){
		$(obj).find("img[name='pointto']").attr("src","/images/ecology8/workflow/pointto1_wev8.png");
	}else{
		$(obj).find("img[name='pointto']").attr("src","/images/ecology8/workflow/pointto_wev8.png");
	}
	$("#"+type).slideToggle("normal");
}

function onLiOver(obj){
	$("#addNew").show();
	var caozuoDiv =  $("#caozuoDiv");
	var offset = $(obj).offset();
	$(obj).append(caozuoDiv);
	caozuoDiv.css("width",100).css("top",offset.top).css("left",offset.left+100);
	caozuoDiv.show();
	if($(obj).attr("name")=="field"){
		$("#addNew").hide();
		caozuoDiv.css("width",58).css("left",offset.left+65);
	}else if($(obj).attr("name")=="wftable"){
		caozuoDiv.css("width",100).css("left",offset.left+65);
	}else if($(obj).attr("name")=="mainfield"){
		caozuoDiv.css("width",100).css("left",offset.left+40);
	}else if($(obj).attr("name")=="detailfield"){
		caozuoDiv.css("width",100).css("left",offset.left+55);
	}
	$(obj).removeClass("b").addClass("b2")
	$(obj).find("img[name='blank']").attr("src","/images/ecology8/workflow/blank-hot_wev8.jpg");
} 
function onLiOut(obj){
	$("#caozuoDiv").hide();
	$(obj).removeClass("b2").addClass("b")
	$(obj).find("img[name='blank']").attr("src","/images/ecology8/workflow/blank_wev8.jpg");
}

$("#addNew").click(function(){
    var type = $(this).parent().parent().attr("name");
	forward(type,"1");
});

$("#maintain").click(function(){
    var type = $(this).parent().parent().attr("name");
	forward(type,"2");
});

function forward(type,type2){
	var href = "";
	if(type=="wftype"){
		if(type2=="1"){
			newwftype();
		}else{
			href="/workflow/workflow/ListWorkType.jsp";
		}		
	}else if(type=="wfname"){
		if(type2=="1"){
			href="/workflow/workflow/addwf.jsp?isTemplate=0";
		}else{
			href="/workflow/workflow/managewf_frm.jsp";
		}			
	}else if(type=="field"){
			href="/workflow/field/managefieldTab.jsp";		
	}else if(type=="mainfield"){
		if(type2=="1"){
			newFlied("mainfield");
		}else{
			href="/workflow/field/managefieldTab.jsp?current=0";
		}			
	}else if(type=="detailfield"){
		if(type2=="1"){
			newFlied("detailfield");
		}else{
			href="/workflow/field/managefieldTab.jsp?current=1";
		}			
	}else if(type=="wftable"){
		if(type2=="1"){
			href="/workflow/form/addDefineForm.jsp";
		}else{
			href="/workflow/form/manageform_frm.jsp";
		}			
	}else if(type=="wftest"){
		if(type2=="1"){
			href = "/workflow/request/RequestTypeByTest.jsp";		
		}else{
			href = "/workflow/search/RequestTestList.jsp";
		}
	}else if(type=="wffield"){
		href="/workflow/form/manageform_frm.jsp";
	}
	if(href!="")
		window.parent.location = href;
}


function newwftype(){
	//diag_vote = new Dialog();
	var title = "";
	var url = "";
	title = "<%=SystemEnv.getHtmlLabelName(125044, user.getLanguage())%>";
	url="/workflow/workflow/AddWorkType.jsp?dialog=1";
	diag_vote = new window.top.Dialog();
	diag_vote.currentWindow = window;
	diag_vote.Width = 500;
	diag_vote.Height = 230;
	diag_vote.Modal = true;
	diag_vote.Title = title;
	diag_vote.URL = url;
	diag_vote.show();
}

function newFlied(type){
	diag_vote = new window.top.Dialog();
	diag_vote.currentWindow = window;
	diag_vote.Width = 1000;
	diag_vote.Height = 320;
	diag_vote.Modal = true;
	diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(125019, user.getLanguage())%>";
	diag_vote.URL = "/workflow/field/addfield.jsp?dialog=1&srcType="+type;
	diag_vote.show();
	//window.location = "/workflow/field/addfield.jsp?srcType=mainfield";
}

function closeDialog(){
	diag_vote.close();
}
</script>
</body>
</html>
