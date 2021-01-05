<!DOCTYPE html>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<%
	String formstr = Util.replaceString(SystemEnv.getHtmlLabelName(129449, user.getLanguage()),"${0}","<a onmouseover=\"showExplain(this,'prototypePattern')\" onmouseout=\"hiddenExplain()\">"+SystemEnv.getHtmlLabelNames("18017,16450",user.getLanguage())+"</a>");
	formstr = Util.replaceString(formstr,"${1}","<a onmouseover=\"showExplain(this,'htmlPattern')\" onmouseout=\"hiddenExplain()\">html"+SystemEnv.getHtmlLabelNames("19071,16450",user.getLanguage())+"</a>");
	
	String wfchartstr = Util.replaceString(SystemEnv.getHtmlLabelName(129450,user.getLanguage()),"${0}","<a onmouseover=\"showExplain(this,'mapedit')\" onmouseout=\"hiddenExplain()\">"+SystemEnv.getHtmlLabelName(16459, user.getLanguage())+"</a>");
	String wfchartstr2 = Util.replaceString(SystemEnv.getHtmlLabelName(129451, user.getLanguage()),"${0}","<a onmouseover=\"showExplain(this,'operator')\" onmouseout=\"hiddenExplain()\">"+SystemEnv.getHtmlLabelName(99, user.getLanguage())+"</a>");
	wfchartstr2 = Util.replaceString(wfchartstr2,"${1}","<a onmouseover=\"showExplain(this,'nodefield')\" onmouseout=\"hiddenExplain()\">"+SystemEnv.getHtmlLabelName(18887, user.getLanguage())+"</a>");
	
	String wftest = Util.replaceString(SystemEnv.getHtmlLabelName(129452, user.getLanguage()),"${0}","<a  onmouseover=\"showExplain(this,'operator')\" onmouseout=\"hiddenExplain()\">"+SystemEnv.getHtmlLabelName(99, user.getLanguage())+"</a>");
	wftest = Util.replaceString(wftest,"${1}","<a onmouseover=\"showExplain(this,'outletCondition')\" onmouseout=\"hiddenExplain()\">"+SystemEnv.getHtmlLabelName(33413, user.getLanguage())+"</a>");
	wftest = Util.replaceString(wftest,"${3}","<a style=\"display:inline-block;height:34px;vertical-align:middle;\" onmouseover=\"showExplain1(this,'wftest')\" onmouseout=\"hiddenExplainNew(this)\" onclick=\"onClick('wftest')\"><span class=\"leftspan\"></span><span class=\"centerspan\">"+SystemEnv.getHtmlLabelName(25497, user.getLanguage())+"</span><span class=\"rightspan\"></span></a>");
%>
<html>
<head>
    <title></title>
    <link rel="stylesheet" href="/css/ecology8/abutton_wev8.css" type="text/css" />
    <style>
        *{ margin:0; padding:0;}
        .help { padding: 20px; line-height: 18px; list-style: none; font-size: 12px;}
        .help td{color:#848585;}
         a{color:#1d98f8;cursor: pointer;} 
        .help .b{ height: 36px; font-weight: bold; line-height:36px;color:#373737;}
        .explain { padding: 10px; list-style: none;background-color: #FFFFFF; font-size: 12px;border-color: #adadad;border-style: solid;border-width: 1px;color:#848585;}

/* The header and footer */
.headfoot {display:block; height:auto; background:#ffffff; color:#000000; text-align:center; padding:5px;font-size:16px;}
.hfoot {display:block; height:auto; background:#ffffff; color:#000000; text-align:left; padding:5px;font-size:12px;}
/* This bit does all the work */
#container {position:relative; display:block; background:#ffffff; border-left:110px solid #ffffff; border-right:200px solid #ffffff;}
#inner {display:block; margin-left:-100px; margin-right:-100px; padding:5px;}
#left {
float:left;
margin-left:1px;
border:0px #ff0 solid;
height:auto;
width:33%;

}
.clear {clear:both;}
#topdiv {
	
}
    </style>

</head>
<body>
<div id="container">
<div id="inner">
<div id="left">
	<div class="headfoot"><img src="/images/ecology8/workflow/1_wev8.png" /></div>
	<div class="hfoot"><%=SystemEnv.getHtmlLabelName(129436, user.getLanguage())%>
				<%=SystemEnv.getHtmlLabelName(129437, user.getLanguage())%>(<a onmouseover="showExplain(this,'wftype')" onmouseout="hiddenExplain()"><%=SystemEnv.getHtmlLabelName(16579, user.getLanguage())%></a>、<a onmouseover="showExplain(this,'wfname')" onmouseout="hiddenExplain()"><%=SystemEnv.getHtmlLabelName(18104, user.getLanguage())%></a>)?
				<%=SystemEnv.getHtmlLabelName(129438, user.getLanguage())%>(<a onmouseover="showExplain(this,'wftable')" onmouseout="hiddenExplain()"><%=SystemEnv.getHtmlLabelName(700, user.getLanguage())%></a>、<a onmouseover="showExplain(this,'field')" onmouseout="hiddenExplain()"><%=SystemEnv.getHtmlLabelName(261, user.getLanguage())%></a>)?<br><br>
				<%=SystemEnv.getHtmlLabelName(129439, user.getLanguage())%>(<a onmouseover="showExplain(this,'node')" onmouseout="hiddenExplain()"><%=SystemEnv.getHtmlLabelName(15586, user.getLanguage())%></a>)?
				<%=Util.replaceString(SystemEnv.getHtmlLabelName(129440, user.getLanguage()),"${0}","<a onmouseover=\"showExplain(this,'outlet')\" onmouseout=\"hiddenExplain()\">"+SystemEnv.getHtmlLabelName(15587, user.getLanguage())+"</a>")%>
				<%=SystemEnv.getHtmlLabelName(129441, user.getLanguage())%>(<a onmouseover="showExplain(this,'outletCondition')" onmouseout="hiddenExplain()"><%=SystemEnv.getHtmlLabelName(33413, user.getLanguage())%></a>)?<br><br>
				<%=SystemEnv.getHtmlLabelName(129442, user.getLanguage())%>(<a onmouseover="showExplain(this,'operator')" onmouseout="hiddenExplain()"><%=SystemEnv.getHtmlLabelName(99, user.getLanguage())%></a>)?
				<%=SystemEnv.getHtmlLabelName(129443, user.getLanguage())%><br></div>
</div>
<div id="left">
	<div class="headfoot"><img src="/images/ecology8/workflow/2_wev8.png" /></div>
	<div class="hfoot"><%=SystemEnv.getHtmlLabelName(129444, user.getLanguage())%>&nbsp<a style="display:inline-block;height:34px;vertical-align:middle;" onmouseover="showExplain1(this,'wftype')" onmouseout="hiddenExplainNew(this)" onclick="onClick('wftype')">
					<span class="leftspan"></span>
					<span class="centerspan"><%=SystemEnv.getHtmlLabelName(16579, user.getLanguage())%></span>
					<span class="rightspan"></span>
					</a>&nbsp<%=SystemEnv.getHtmlLabelName(129446, user.getLanguage())%>&nbsp
					<a style="display:inline-block;height:34px;vertical-align:middle;" onmouseover="showExplainNew(this)" onmouseout="hiddenExplainNew(this)" onclick="newDialog()">
					<span class="leftspan"></span>
					<span class="centerspan"><%=SystemEnv.getHtmlLabelName(125044, user.getLanguage())%></span>
					<span class="rightspan"></span>
					</a>&nbsp，<%=SystemEnv.getHtmlLabelName(129445, user.getLanguage())%>。<br><br>
				<%=SystemEnv.getHtmlLabelName(83931, user.getLanguage())%>&nbsp<a style="display:inline-block;height:34px;vertical-align:middle;" onmouseover="showExplainNew(this)" onmouseout="hiddenExplainNew(this)" onclick="onClick('addwf')">
				<span class="leftspan"></span>
					<span class="centerspan"><%=SystemEnv.getHtmlLabelName(16392, user.getLanguage())%></span>
					<span class="rightspan"></span>
				</a>&nbsp<%=SystemEnv.getHtmlLabelName(129447, user.getLanguage())%>。	<br></div>
</div>
<div id="left">
	<div class="headfoot"><img src="/images/ecology8/workflow/3_wev8.png" /></div>
	<div class="hfoot"><%=Util.replaceString(SystemEnv.getHtmlLabelName(129448, user.getLanguage()),"${0}","<a onmouseover=\"showExplain(this,'field')\" onmouseout=\"hiddenExplain()\">"+SystemEnv.getHtmlLabelName(261, user.getLanguage())+"</a>")%>&nbsp
	<a style="display:inline-block;height:34px;vertical-align:middle;" onmouseover="showExplain1(this,'wftable')" onmouseout="hiddenExplainNew(this)" onclick="onClick('wffield')">
	<span class="leftspan"></span>
	<span class="centerspan"><%=SystemEnv.getHtmlLabelName(700, user.getLanguage()) %></span>
	<span class="rightspan"></span>
	</a>&nbsp。<br><br>
	<%=formstr%><br></div>
</div>
<div class="clear"></div>

<div id="aaa" style="border-top:1px dashed #cccccc;height: 1px;overflow:hidden;"><a href=""><%=SystemEnv.getHtmlLabelName(23000, user.getLanguage())%></a></div>

<div id="left">
	<div class="headfoot"><img src="/images/ecology8/workflow/4_wev8.png" /></div>
	<div class="hfoot"><%=wfchartstr %><br><br><%=wfchartstr2 %><br></div>
</div>
<div id="left"></div>
<div id="left">
<div class="headfoot"><img src="/images/ecology8/workflow/5_wev8.png" /></div>
<div class="hfoot"><%=wftest %></div>
</div>
<div class="clear"></div>

</div>
</div>
<div style="width: 280px;position: absolute;display:none;" id="cantent">
	<div style="position: relative;top:1px;display:none;height:17px;" id="topdiv">
		<img src="/images/ecology8/images/tips_wev8.png">
	</div>
	<div class="explain"></div>
	<div style="position: relative;bottom: 1px;display:none;height:7px;line-height:2px;" id="bottomdiv">
		<img src="/images/ecology8/images/tips2_wev8.png">
	</div>
</div>	
<script type="text/javascript">
//$(function(){
//	$("a1").hover(function(){
//		$(this).removeClass("a1 a1-style-1");
//		$(this).addClass("a2 a2-style-1");
//	});
//});
//onMouseOver  onMouseOut 

function showExplainNew(obj){
	$(obj).find(".leftspan").addClass("leftspan1");
	$(obj).find(".centerspan").addClass("centerspan1");
	$(obj).find(".rightspan").addClass("rightspan1");
}

function showExplain1(obj,type){
	$(obj).find(".leftspan").addClass("leftspan1");
	$(obj).find(".centerspan").addClass("centerspan1");
	$(obj).find(".rightspan").addClass("rightspan1");

	$("#topdiv").hide();
	$("#bottomdiv").hide();
	var content = "";
	content = ContentText(type);
	$(".explain").html("").html(content);
	var jqobj = $(obj);
	var offset =  jqobj.offset();
	var left = 0;
	if(offset.left>140){
		left = offset.left-140;
		$("#topdiv").css("padding-left",160);
		$("#bottomdiv").css("padding-left",160);
	}else{
		$("#topdiv").css("padding-left",offset.left);
		$("#bottomdiv").css("padding-left",offset.left);
	}
	var top = 0;
	var explainHeght = 	$("#cantent").height();
	var documentHeight =  document.body.scrollHeight;
	if(documentHeight-offset.top<120){
		top = offset.top-explainHeght-5;
		$("#bottomdiv").show();
	}else{
		top = offset.top+25;
		$("#topdiv").show();
	}
	$("#cantent").css("top",top);
	$("#cantent").css("left",left);
	$("#cantent").fadeIn();
}
//onmouseout="hiddenExplain()"

$(function () {
	$(".explain").hover(function () {}, function () {
		hiddenExplain();
		hiddenExplain1();
	} );
	
})

function showExplain(obj,type){
	$(obj).find(".leftspan").addClass("leftspan1");
	$(obj).find(".centerspan").addClass("centerspan1");
	$(obj).find(".rightspan").addClass("rightspan1");

	$("#topdiv").hide();
	$("#bottomdiv").hide();
	var content = "";
	content = ContentText(type);
	$(".explain").html("").html(content);
	var jqobj = $(obj);
	var offset =  jqobj.offset();
	var left = 0;
	
	if(offset.left>140){
		left = offset.left-140;
		$("#topdiv").css("padding-left",160);
		$("#bottomdiv").css("padding-left",160);
	}else{
		$("#topdiv").css("padding-left",offset.left);
		$("#bottomdiv").css("padding-left",offset.left);
	}
	var top = 0;
	var explainHeght = 	$("#cantent").height();
	var documentHeight =  document.body.scrollHeight;
	if(documentHeight-offset.top<120){
		top = offset.top-explainHeght-5;
		$("#bottomdiv").show();
	}else{
		top = offset.top+5;
		$("#topdiv").show();
	}
	$("#cantent").css("top",top);
	$("#cantent").css("left",left);
	$("#cantent").fadeIn();
}

function hiddenExplain(){
	$("#cantent").hide();
}

function hiddenExplainNew(obj){
	$(obj).find(".leftspan").removeClass("leftspan1");
	$(obj).find(".centerspan").removeClass("centerspan1");
	$(obj).find(".rightspan").removeClass("rightspan1");

	$("#cantent").hide();
}

function onClick(type){
	var href = "";
	if(type=="wftype"){
		href="/workflow/workflow/ListWorkType.jsp";
	}else if(type=="wftest"){
		href = "/workflow/request/RequestTypeByTest.jsp";
	}else if(type=="wffield"){
		href="/workflow/form/manageform_frm.jsp";
	}else if(type=="addwf"){
		href="/workflow/workflow/addwf.jsp?isTemplate=0";
	}
	if(href!="")
		window.parent.location = href;
}

function newDialog(){
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

function closeDialog(){
	diag_vote.close();
}

function ContentText(type){
	var text = "";
	if(type=="wftype"){
		text = "<%=SystemEnv.getHtmlLabelName(129453, user.getLanguage())%>";
	}else if(type =="wfname"){
		text = "<%=SystemEnv.getHtmlLabelName(129454, user.getLanguage())%>";
	}else if(type=="field"){
		text = "<%=SystemEnv.getHtmlLabelName(129455, user.getLanguage())%>";
	}else if(type=="wftable"){
		text = "<%=SystemEnv.getHtmlLabelName(129456, user.getLanguage())%>";
	}else if(type=="node"){
	    text = "<%=SystemEnv.getHtmlLabelName(129457, user.getLanguage())%>";
	}else if(type == "outlet"){
		text = "<%=SystemEnv.getHtmlLabelName(129458, user.getLanguage())%>";
	}else if(type == "mapedit"){
		text = "<%=SystemEnv.getHtmlLabelName(129459, user.getLanguage())%>";
	}else if(type=="wftest"){
		text = "<%=SystemEnv.getHtmlLabelName(129460, user.getLanguage())%>";
	}else if(type =="outletCondition"){
		text = "<%=SystemEnv.getHtmlLabelName(129461, user.getLanguage())%>";
	}else if(type == "operator"){
		text = "<%=SystemEnv.getHtmlLabelName(129466, user.getLanguage())%>";
	}else if(type=="prototypePattern"){
		text = "<%=SystemEnv.getHtmlLabelName(129467, user.getLanguage())%>";
	}else if(type=="htmlPattern"){
		text = "<%=SystemEnv.getHtmlLabelName(129468, user.getLanguage())%>";
	}else if(type=="nodefield"){
		text = "<%=SystemEnv.getHtmlLabelName(129470, user.getLanguage())%>";
	}
	
	return text;
}
</script>
</body>
</html>
