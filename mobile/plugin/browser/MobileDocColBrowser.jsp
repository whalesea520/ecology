
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ include file="MobileInit.jsp"%>
<%
request.setCharacterEncoding("UTF-8");
String module = fu.getParameter("module");
String scope = fu.getParameter("scope");

String columnid = fu.getParameter("columnid");
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="/mobile/plugin/browser/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script type='text/javascript' src='/js/jquery/jquery.js'></script>
<script type='text/javascript' src='/mobile/plugin/browser/js/browserUtil_wev8.js'></script>
</head>

<script type="text/javascript">
	$(document).ready(function() {
    	initDocumentForm();
	});
	
	function clearDocumentForm() {
		document.getElementById("news_0").value = "";
		document.getElementById("spannews_0").innerHTML = "";
		
		document.getElementById("cate_0").value = "";
		document.getElementById("spancate_0").innerHTML = "";
		document.getElementById("chkcate_0").checked = false;
		
		document.getElementById("dummy_0").value = "";
		document.getElementById("spandummy_0").innerHTML = "";
		document.getElementById("chkdummy_0").checked = false;
		
		document.getElementById("docids_0").value = "";
		document.getElementById("spandocids_0").innerHTML = "";
	}	
	
	function initDocumentForm() {
		var source = $("tr[columnid=<%=columnid%>] input[name=source]", window.opener.document).val();
		var docids = $("tr[columnid=<%=columnid%>] input[name=docids]", window.opener.document).val();
		var docnames = $("tr[columnid=<%=columnid%>] input[name=docnames]", window.opener.document).val();
		var isreplay = ("1" == $("tr[columnid=<%=columnid%>] input[name=isreplay]", window.opener.document).val());
		
		if(source=="1") {
			document.getElementById("news_0").checked = true;
			document.getElementById("news_0").value = docids;
			document.getElementById("spannews_0").innerHTML = docnames;
		}
		
		if(source=="2") {
			document.getElementById("cate_0").checked = true;
			document.getElementById("cate_0").value = docids;
			document.getElementById("spancate_0").innerHTML = docnames;
			document.getElementById("chkcate_0").checked = isreplay;
		}
		
		if(source=="3") {
			document.getElementById("dummy_0").checked = true;
			document.getElementById("dummy_0").value = docids;
			document.getElementById("spandummy_0").innerHTML = docnames;
			document.getElementById("chkdummy_0").checked = isreplay;
		}
		
		if(source=="4") {
			document.getElementById("docids_0").checked = true;
			document.getElementById("docids_0").value = docids;
			document.getElementById("spandocids_0").innerHTML = docnames;
		}
	}

	function onSelectNew(input,span) {
		document.getElementById("news_0").checked = true;
		var result = window.showModalDialog("/mobile/plugin/browser/NewsBrowser.jsp");
		
		if(result){
		   if(result.id!=""){
		      document.getElementById(span).innerHTML =result.name;
			  document.getElementById(input).value=result.id;
		   }else{
		      document.getElementById(span).innerHTML ="";
			  document.getElementById(input).value="";
		   }
		}
	}

	function onSelectMultiCatalog(input,span){
		document.getElementById("cate_0").checked = true;
		var inputvalue="";
		if(typeof(input.value) != "undefined" ){
		    inputvalue=input.value;
		}
		inputvalue=document.getElementById(input).value;
		var result = window.showModalDialog("/mobile/plugin/browser/MutilCategoryBrowser.jsp?para="+inputvalue);
		
		if(result){
		   if(result.id!=""){
		      var dummyidArray = result.id.split(",");
			  var dummynames = result.name.split(",");
			  
			  var sHtml = "";
			  for(var k=0;k<dummyidArray.length;k++){
				 if(dummyidArray[k]&&dummynames[k]&&dummyidArray[k]!=""&&dummynames[k]!="")
				    sHtml = sHtml+dummynames[k]+"&nbsp;";
			  }
			  document.getElementById(input).value=result.id;
			  document.getElementById(span).innerHTML=sHtml;
		   }else{
		   
		      document.getElementById(input).value="";
			  document.getElementById(span).innerHTML="";
		   
		   }
		}
		
	}

	function onSelectMutiDummy(input,span) {
		document.getElementById("dummy_0").checked = true;
		
		var inputvalue=document.getElementById(input).value;
		var result = window.showModalDialog("/mobile/plugin/browser/DocTreeDocFieldBrowserMulti.jsp?para="+inputvalue);
		
		if(result){
		   if(result.id!=""){
		        dummyidArray=result.id.split(",");
				dummynames=result.name.split(",");
				var sHtml = "";
				for(var k=0;k<dummyidArray.length;k++){
					if(dummyidArray[k]&&dummynames[k]&&dummyidArray[k]!=""&&dummynames[k]!="")
						sHtml = sHtml+dummynames[k]+"&nbsp;";
				}
				document.getElementById(input).value=result.id;
				document.getElementById(span).innerHTML=sHtml;
		   }else {
		       document.getElementById(input).value="";
			   document.getElementById(span).innerHTML="";
		   }
		}
	}

	function onSelectMDocs(input,span){
		document.getElementById("docids_0").checked = true;
		var inputvalue=document.getElementById(input).value;
		var result = window.showModalDialog("/mobile/plugin/browser/MutiDocBrowser.jsp?documentids="+inputvalue);
		
		if(result){
		   if(result.id!=""){
		    dummyidArray=result.id.split(",");
			dummynames=result.name.split(",");
			var sHtml = "";
			for(var k=0;k<dummyidArray.length;k++){
				if(dummyidArray[k]&&dummynames[k]&&dummyidArray[k]!=""&&dummynames[k]!="")
					sHtml = sHtml+dummynames[k]+"&nbsp;";
			}
			document.getElementById(input).value=result.id;
			document.getElementById(span).innerHTML = sHtml;
		   }else{
		    document.getElementById(input).value="";
			document.getElementById(span).innerHTML ="";
		   }
		}
	}
	
	
	function doSave(){
	    var from = "";
		var fromids = "";
		var includereplay = "";
		var showstr = "";
		
		if(document.getElementById("news_0").checked) {
			from = "1";
			fromids = document.getElementById("news_0").value;
			includereplay = "0";
			showstr = document.getElementById("spannews_0").innerHTML;
		}
		
		if(document.getElementById("cate_0").checked) {
			from = "2";
			fromids = document.getElementById("cate_0").value;
			includereplay = document.getElementById("chkcate_0").checked?"1":"0";
			showstr = document.getElementById("spancate_0").innerHTML;
		}
		
		if(document.getElementById("dummy_0").checked) {
			from = "3";
			fromids = document.getElementById("dummy_0").value;
			includereplay = document.getElementById("chkdummy_0").checked?"1":"0";
			showstr = document.getElementById("spandummy_0").innerHTML;
		}
		
		if(document.getElementById("docids_0").checked) {
			from = "4";
			fromids = document.getElementById("docids_0").value;
			includereplay = "0";
			showstr = document.getElementById("spandocids_0").innerHTML;
		}
		
		$("tr[columnid=<%=columnid%>] input[name=source]", window.opener.document).val(from);
		$("tr[columnid=<%=columnid%>] input[name=docids]", window.opener.document).val(fromids);
		$("tr[columnid=<%=columnid%>] input[name=docnames]", window.opener.document).val(showstr);
		$("tr[columnid=<%=columnid%>] input[name=isreplay]", window.opener.document).val(includereplay);
		window.close();
	}
	
	function doClear(){
		$("tr[columnid=<%=columnid%>] input[name=source]", window.opener.document).val("");
		$("tr[columnid=<%=columnid%>] input[name=docids]", window.opener.document).val("");
		$("tr[columnid=<%=columnid%>] input[name=docnames]", window.opener.document).val("");
		$("tr[columnid=<%=columnid%>] input[name=isreplay]", window.opener.document).val("");
		window.close();
	}
	
	function doCancel() {
		window.close();
	}
</script>

<body style="overflow-y: hidden;">

<div style="height: 450px;overflow: auto;">
	<table class=ViewForm width="100%">
		<colgroup>
			<col width='27%' />
			<col width='73%' />
		</colgroup>
		<TR>
			<TD>
				<label><input type=radio name=rdi_0 id=news_0 value=''> <%=SystemEnv.getHtmlLabelName(16356,user.getLanguage()) %></label><!--新闻中心-->
			</TD>
			<td class=field>
				<BUTTON class=Browser onclick='onSelectNew("news_0","spannews_0")'></BUTTON>
				<SPAN id="spannews_0"></SPAN>
			</TD>
		</TR>
		<TR style="height: 1px;"> 
	      <TD class=line1 colspan=2></TD>
	    </TR>
		<TR>
			<TD>
				<label><input type=radio name=rdi_0 id=cate_0 value=''> <%=SystemEnv.getHtmlLabelName(16398,user.getLanguage()) %></label><!--文档目录-->
			</TD>
			<TD class=field>
				<BUTTON class=Browser onclick='onSelectMultiCatalog("cate_0","spancate_0")'></BUTTON>
				<SPAN id=spancate_0></SPAN><br><label><input id=chkcate_0 type=checkbox name=chk_0><%=SystemEnv.getHtmlLabelName(20568,user.getLanguage()) %></label>
			</TD>
		</TR>
		<TR style="height: 1px;"> 
	      <TD class=line1 colspan=2></TD>
	    </TR>
		<TR>
			<TD>
				<label><input type=radio name=rdi_0 id=dummy_0 value=''> <%=SystemEnv.getHtmlLabelName(20482,user.getLanguage()) %></label><!--虚拟目录-->
			</TD>
			<TD class=field>
				<BUTTON class=Browser onClick='onSelectMutiDummy("dummy_0","spandummy_0")'></BUTTON>
				<SPAN id=spandummy_0></SPAN><br><label><input id=chkdummy_0 type=checkbox name=chk_0><%=SystemEnv.getHtmlLabelName(20568,user.getLanguage()) %></label>
			</TD>
		</TR>
		<TR style="height: 1px;"> 
	      <TD class=line1 colspan=2></TD>
	    </TR>
		<TR>
			<TD>
				<label><input type=radio name=rdi_0 id=docids_0 value=''> <%=SystemEnv.getHtmlLabelName(20533,user.getLanguage()) %></label><!--指定文档-->
			</TD>
			<TD class=field>
				<BUTTON class=Browser onclick='onSelectMDocs("docids_0","spandocids_0")'></BUTTON>
				<SPAN ID=spandocids_0></SPAN>
			</TD>
		</TR>
		<TR style="height: 1px;">
			<TD CLASS=LINE COLSPAN=2></TD>
		</TR>
	</table>
</div>	
<div align="center" style="background:rgb(246, 246, 246);vertical-align: middle;padding-top: 8px;border-top:#dadee5 solid 1px;">
     <BUTTON  accessKey= O id="okBtn" onclick="doSave()"><u>O</u>-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%></BUTTON>&nbsp;&nbsp;
     <BUTTON  accessKey= 2 id="clearBtn" onclick="doClear()"><u>2</u>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>&nbsp;&nbsp;
     <BUTTON  accessKey= T  id="cancelBtn" onclick="doCancel()"><u>T</u>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
</div>
</body>
</html>