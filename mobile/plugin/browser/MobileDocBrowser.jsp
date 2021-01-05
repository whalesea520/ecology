
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.conn.*" %>
<%@ page import="weaver.mobile.webservices.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.systeminfo.setting.*" %>
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="departmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="subCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="rolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page" />
<jsp:useBean id="docNewsComInfo" class="weaver.docs.news.DocNewsComInfo" scope="page" />
<jsp:useBean id="secCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="docTreeDocFieldComInfo" class="weaver.docs.category.DocTreeDocFieldComInfo" scope="page" />
<jsp:useBean id="docComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<%@ include file="MobileInit.jsp"%>
<%
request.setCharacterEncoding("UTF-8");
String module = fu.getParameter("module");
String scope = fu.getParameter("scope");
module="2";
String selectids = fu.getParameter("selectids");
String returnshowspan = fu.getParameter("returnshowspan");
String returnvalueinput = fu.getParameter("returnvalueinput");
String formids = fu.getParameter("formids");

String from = "";
String fromids = "";
String showstr = "";
String includereplay = "";
if(Util.getIntValue(module)==2||Util.getIntValue(module)==3&&selectids!=null&&!"".equals(selectids)) {
	
	String[] t = new String[]{"","",""};
	if(!"".equals(selectids)) t=Util.TokenizerString2(selectids,"|");
	
	if(t==null||t.length==0) t = new String[]{"","",""};
	if(t.length>2)
	{
		from = t[0];           //文档类型
		fromids = t[1];        //文档id
		includereplay = t[2];  //是否包含回复
	}
	showstr = "";

	if(fromids!=null&&!"".equals(fromids)){
		String[] tid = Util.TokenizerString2(fromids,",");
		for(int i=0;tid!=null&&i<tid.length;i++){
			if(tid[i]==null||"".equals(tid[i])) continue;
			if("1".equals(from)){
				showstr = showstr + docNewsComInfo.getDocNewsname(tid[i]) +"&nbsp;";
			} else if("2".equals(from)){
				showstr = showstr + secCategoryComInfo.getSecCategoryname(tid[i])+"&nbsp;";
			} else if("3".equals(from)){
				showstr = showstr + docTreeDocFieldComInfo.getTreeDocFieldName(tid[i])+"&nbsp;";
			} else if("4".equals(from)){
				showstr = showstr + docComInfo.getDocname(tid[i])+"&nbsp;";
			}
		}
	}
}
module="2";
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
		if("<%=from%>"=="1") {
			document.getElementById("news_0").checked = true;
			document.getElementById("news_0").value = "<%=fromids%>";
			document.getElementById("spannews_0").innerHTML = "<%=showstr%>";
		}
		
		if("<%=from%>"=="2") {
			document.getElementById("cate_0").checked = true;
			document.getElementById("cate_0").value = "<%=fromids%>";
			document.getElementById("spancate_0").innerHTML = "<%=showstr%>";
			if("<%=includereplay%>"=="1")
				document.getElementById("chkcate_0").checked = true;
			else
				document.getElementById("chkcate_0").checked = false;
		}
		
		if("<%=from%>"=="3") {
			document.getElementById("dummy_0").checked = true;
			document.getElementById("dummy_0").value = "<%=fromids%>";
			document.getElementById("spandummy_0").innerHTML = "<%=showstr%>";
			if("<%=includereplay%>"=="1")
				document.getElementById("chkdummy_0").checked = true;
			else
				document.getElementById("chkdummy_0").checked = false;
		}
		
		if("<%=from%>"=="4") {
			document.getElementById("docids_0").checked = true;
			document.getElementById("docids_0").value = "<%=fromids%>";
			document.getElementById("spandocids_0").innerHTML = "<%=showstr%>";
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
		var result = window.showModalDialog("/mobile/plugin/browser/MutilCategoryBrowser.jsp?selectids="+inputvalue);
		
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
		
		var result = from + "|" + fromids + "|" + includereplay;//类型|所需id序列|是否包含回复
		if(typeof window.parent.closeModalDialog == "function") {
			window.parent.closeModalDialog(result);
		} else {
			window.returnValue = result;
			window.close();
		}
	}
	
	function doClear(){
		if(typeof window.parent.closeModalDialog == "function") {
			window.parent.closeModalDialog("");
		} else {
			window.returnValue="";
			window.close();
		}
	}
	
	function doCancel() {
		if(typeof window.parent.closeModalDialog == "function") {
			window.parent.closeModalDialog();
		} else {
			window.close();
		}
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