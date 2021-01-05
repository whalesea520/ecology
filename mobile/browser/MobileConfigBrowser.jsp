
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.conn.*" %>
<%@ page import="weaver.mobile.webservices.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.systeminfo.setting.*" %>
<%
String username = request.getParameter("username");
String password = request.getParameter("password");

String flag = request.getParameter("flag");

RecordSet rs = new RecordSet() ;

User user = null;//HrmUserVarify.checkUser (request , response) ;
if(user == null){

	int logintype = 0;
	rs.execute("select * from mobileconfig where mc_type = 7");
	if(rs.next()) {
		logintype = Util.getIntValue(rs.getString("mc_value"),0);
	}
	
	MobileService ms = new MobileServiceImpl();
	if(ms.checkUserLogin(username, password, logintype)==1) {
		user = new User() ;
		rs.execute("SELECT id,firstname,lastname,systemlanguage,seclevel FROM HrmResourceManager WHERE loginid='"+username+"'");
		if(rs.next()){
			user.setUid(rs.getInt("id"));
			user.setLoginid(username);
			user.setFirstname(rs.getString("firstname"));
			user.setLastname(rs.getString("lastname"));
			user.setLanguage(Util.getIntValue(rs.getString("systemlanguage"),0));
			user.setSeclevel(rs.getString("seclevel"));
			user.setLogintype("1");
			request.getSession(true).setAttribute("weaver_user@bean",user) ;
		}
	} else {
		out.println("Login Error !");
		return;
	}
}
%>
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="departmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="subCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="rolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page" />
<jsp:useBean id="docNewsComInfo" class="weaver.docs.news.DocNewsComInfo" scope="page" />
<jsp:useBean id="secCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="docTreeDocFieldComInfo" class="weaver.docs.category.DocTreeDocFieldComInfo" scope="page" />
<jsp:useBean id="docComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<%
String module = request.getParameter("module");
String scope = request.getParameter("scope");

String initvalue = request.getParameter("initvalue");
String returnshowspan = request.getParameter("returnshowspan");
String returnvalueinput = request.getParameter("returnvalueinput");
String formids = request.getParameter("formids");

String from = "";
String fromids = "";
String showstr = "";
String includereplay = "";
if(Util.getIntValue(module)==2||Util.getIntValue(module)==3&&initvalue!=null&&!"".equals(initvalue)) {
	
	String[] t = new String[]{"","",""};
	if(!"".equals(initvalue)) t=Util.TokenizerString2(initvalue,"|");
	
	if(t==null||t.length==0) t = new String[]{"","",""};
	if(t.length>2)
	{
		from = t[0];
		fromids = t[1];
		includereplay = t[2];
	}
	showstr = "";

	if(fromids!=null&&!"".equals(fromids)){
		String[] tid = Util.TokenizerString2(fromids,",");
		for(int i=0;tid!=null&&i<tid.length;i++){
			if(tid[i]==null||"".equals(tid[i])) continue;
			if("1".equals(from)){
				showstr = showstr + "<a href='/docs/news/NewsDsp.jsp?id="+tid[i]+"'>" + docNewsComInfo.getDocNewsname(tid[i]) +"</a>&nbsp;";
			} else if("2".equals(from)){
				showstr = showstr + "<a href='/docs/search/DocSearchView.jsp?showtype=0&displayUsage=0&fromadvancedmenu=0&infoId=0&showDocs=0&showTitle=1&maincategory=&subcategory=&seccategory="+tid[i]+"'>"+secCategoryComInfo.getSecCategoryname(tid[i])+"</a>&nbsp;";
			} else if("3".equals(from)){
				showstr = showstr + "<a href='/docs/docdummy/DocDummyList.jsp?dummyId="+tid[i]+"'>"+docTreeDocFieldComInfo.getTreeDocFieldName(tid[i])+"</a>&nbsp";
			} else if("4".equals(from)){
				showstr = showstr + "<a href=/docs/docs/DocDsp.jsp?id="+tid[i]+"'>"+docComInfo.getDocname(tid[i])+"</a>&nbsp";
			}
		}
	}
}
%>
<html>
<head>
<link href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language="javascript" src="/js/weaver_wev8.js"></script>

<link rel='stylesheet' type='text/css' href='/js/extjs/resources/css/ext-all_wev8.css' />
<link rel='stylesheet' type='text/css' href='/css/weaver-ext_wev8.css' />
<link rel='stylesheet' type='text/css' href='/js/extjs/resources/css/xtheme-gray_wev8.css'/>
<link rel="stylesheet" type="text/css" href="/css/weaver-ext-grid_wev8.css" />

<script type='text/javascript' src='/js/jquery/jquery_wev8.js'></script>
<script type='text/javascript' src='/js/extjs/adapter/jquery/jquery_wev8.js'></script>
<script type='text/javascript' src='/js/extjs/adapter/jquery/ext-jquery-adapter_wev8.js'></script>
<script type='text/javascript' src='/js/extjs/ext-all_wev8.js'></script>

</head>
<%
	if (!HrmUserVarify.checkUserRight("Mobile:Setting", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>

<script type="text/javascript">
	$(document).ready(function() {
    	<% if(Util.getIntValue(module)==2||Util.getIntValue(module)==3) { %>
    	showDocumentFrom(<%=scope%>);
		<% } %>
    	<% if(Util.getIntValue(module)==1||Util.getIntValue(module)==7||Util.getIntValue(module)==8||Util.getIntValue(module)==9||Util.getIntValue(module)==10) { %>
    	showworkflowfrom(<%=scope%>);
		<% } %>
	});

	function showworkflowfrom(scope) {
		var pass = encodeURIComponent("<%=password%>");
		document.getElementById("ifrmViewType").src = "WorkflowCenterBrowser.jsp?scope="+scope+"&initvalue="+"<%=initvalue%>&username=<%=username%>&password="+pass+"&formids=<%=formids%>";
		var win;
		if(!win){
			win = new Ext.Window({
		           contentEl:"workflowwin",
		           x: 0,
		           y: 0,
		           width:500,
		           height:470,
		           modal:true,
		           closable:false,
		           resizable:false,
		           closeAction:"hide",
		           buttons:[{text:"<%=SystemEnv.getHtmlLabelName(826, user.getLanguage())%>",handler:function(){onWorkflowOk(scope);win.hide();}},{text:"<%=SystemEnv.getHtmlLabelName(201, user.getLanguage())%>",handler:function(){onWorkflowCancel(scope);win.hide();}}],
		           buttonAlign:"center",
		           title:"<%=SystemEnv.getHtmlLabelName(21672,user.getLanguage())%>"
		        });
		}
        win.show();
	}

	function onWorkflowOk(scope) {
		window.frames["ifrmViewType"].window.onGetChecked();
		
	 	var geturl = "MobileCrossFrameProxy.jsp?method=returnAddConfig"+
		"&flag=<%=flag%>"+
		"&returnvalueinput=<%=returnvalueinput%>"+
		"&returnvalue="+window.frames["ifrmViewType"].document.getElementById("flowids").value+
		"&click=ok"+
		"&callback=";
		
		$.getScript(geturl,function(data){
			eval(data);
			window.close();
		});
		
		//window.parent.document.getElementById("<%=returnvalueinput%>").value = window.frames["ifrmViewType"].document.getElementById("flowids").value;
		//window.parent.boxclose();
	}

	function onWorkflowCancel(scope) {
		document.getElementById("ifrmViewType").src = "";
		
	 	var geturl = "MobileCrossFrameProxy.jsp?method=returnAddConfig"+
		"&flag=<%=flag%>"+
		"&returnvalueinput=<%=returnvalueinput%>"+
		"&returnvalue="+
		"&click=cancel"+
		"&callback=";
		
		$.getScript(geturl,function(data){
			eval(data);
			window.close();
		});
		
		//window.parent.boxclose();
	}
	
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
	
	function initDocumentForm(scope) {
		if("<%=from%>"=="1") {
			document.getElementById("news_0").checked = true;
			document.getElementById("news_0").value = "<%=fromids%>";
			document.getElementById("spannews_0").innerHTML = "<%=showstr%>";
			document.getElementById("spannews_0").style.height="100px";
		}
		
		if("<%=from%>"=="2") {
			document.getElementById("cate_0").checked = true;
			document.getElementById("cate_0").value = "<%=fromids%>";
			document.getElementById("spancate_0").innerHTML = "<%=showstr%>";
			if("<%=includereplay%>"=="1")
				document.getElementById("chkcate_0").checked = true;
			else
				document.getElementById("chkcate_0").checked = false;
			document.getElementById("spancate_0").style.height="100px";
		}
		
		if("<%=from%>"=="3") {
			document.getElementById("dummy_0").checked = true;
			document.getElementById("dummy_0").value = "<%=fromids%>";
			document.getElementById("spandummy_0").innerHTML = "<%=showstr%>";
			if("<%=includereplay%>"=="1")
				document.getElementById("chkdummy_0").checked = true;
			else
				document.getElementById("chkdummy_0").checked = false;
			document.getElementById("spandummy_0").style.height="100px";
		}
		
		if("<%=from%>"=="4") {
			document.getElementById("docids_0").checked = true;
			document.getElementById("docids_0").value = "<%=fromids%>";
			document.getElementById("spandocids_0").innerHTML = "<%=showstr%>";
			document.getElementById("spandocids_0").style.height="100px";
		}
	}	
	
	function showDocumentFrom(scope) {
		var win;
		if(!win){
			win = new Ext.Window({
		           contentEl:"documentwin",
		           x: 0,
		           y: 0,
		           width:500,
		           height:400,
		           modal:true,
		           closable:false,
		           resizable:false,
		           closeAction:"hide",
		           buttons:[{text:"<%=SystemEnv.getHtmlLabelName(826, user.getLanguage())%>",handler:function(){onDocumentOk(scope);win.hide();}},{text:"<%=SystemEnv.getHtmlLabelName(201, user.getLanguage())%>",handler:function(){onDocumentCancel(scope);win.hide();}}],
		           buttonAlign:"center",
		           title:"<%=SystemEnv.getHtmlLabelName(20532,user.getLanguage())%>"
		        });
		}
        win.show();
		clearDocumentForm();
		initDocumentForm(scope);
	}

	function onDocumentOk(scope) {
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
		
	 	var geturl = "MobileCrossFrameProxy.jsp?method=returnAddConfig"+
		"&flag=<%=flag%>"+
		"&returnvalueinput=<%=returnvalueinput%>"+
		"&returnvalue="+from + "|" + fromids + "|" + includereplay +
		"&click=ok"+
		"&callback=clearDocumentForm()";
		
		$.getScript(geturl,function(data){
			eval(data);
			window.close();
		});
		
		//window.parent.document.getElementById("<%=returnvalueinput%>").value = from + "|" + fromids + "|" + includereplay;
		
		//clearDocumentForm();
		//window.parent.boxclose();
	}

	function onDocumentCancel(scope) {
	 	var geturl = "MobileCrossFrameProxy.jsp?method=returnAddConfig"+
		"&flag=<%=flag%>"+
		"&returnvalueinput=<%=returnvalueinput%>"+
		"&returnvalue="+
		"&click=cancel"+
		"&callback=clearDocumentForm()";
		
		$.getScript(geturl,function(data){
			eval(data);
			window.close();
		});

		//clearDocumentForm();
		//window.parent.boxclose();
	}

	function onSelectNew(input,span,scope) {
		var vbid = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/news/NewsBrowser.jsp");
		if(vbid) {
			clearDocumentForm();
			document.getElementById("news_0").checked = true;
			if (vbid.id!="") {
				document.getElementById(span).innerHTML = "<a href='/docs/news/NewsDsp.jsp?id="+vbid.id+"'>"+vbid.name+"</a>";
				document.getElementById(input).value=vbid.id;
			document.getElementById("spannews_0").style.height = "auto";
			document.getElementById("spancate_0").style.height = "auto";
			document.getElementById("spandummy_0").style.height = "auto";
			document.getElementById("spandocids_0").style.height = "auto";
			document.getElementById(span).style.height = "100px";
			} else { 
				document.getElementById(span).innerHtml = "";
				document.getElementById(input).value="0";
			}
		}
	}

	function onSelectMultiCatalog(input,span,scope){
		var vbid = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategorySingleBrowser.jsp?selectids="+$("#"+input).val(), "", "dialogHeight=550px;dialogWidth=550px;");
		if(vbid) {
			clearDocumentForm();
			document.getElementById("cate_0").checked = true;
			if (vbid.id!="") {
				var dummyidArray = vbid.id.split(",");
				var dummynames = vbid.name.split(",");
				var sHtml = "";
				for(var k=0;k<dummyidArray.length;k++){
					if(dummyidArray[k]&&dummynames[k]&&dummyidArray[k]!=""&&dummynames[k]!="")
						sHtml = sHtml+"<a href='/docs/search/DocSearchView.jsp?showtype=0&displayUsage=0&fromadvancedmenu=0&infoId=0&showDocs=0&showTitle=1&maincategory=&subcategory=&seccategory="+dummyidArray[k]+"'>"+dummynames[k]+"</a>&nbsp";
				}
				document.getElementById(input).value=vbid.id;
				document.getElementById(span).innerHTML=sHtml;
				document.getElementById("spannews_0").style.height = "auto";
			document.getElementById("spancate_0").style.height = "auto";
			document.getElementById("spandummy_0").style.height = "auto";
			document.getElementById("spandocids_0").style.height = "auto";
				document.getElementById(span).style.height = "100px";
			} else {			
				document.getElementById(input).value="0";
				document.getElementById(span).innerHTML="";
			}
		}
	}

	function onSelectMutiDummy(input,span,scope) {
		var vbid = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/DocTreeDocFieldBrowserMulti.jsp?para="+$("#"+input).val());
		if(vbid) {
			clearDocumentForm();
			document.getElementById("dummy_0").checked = true;
			if (vbid.id!="") {
				dummyidArray=vbid.id.split(",");
				dummynames=vbid.name.split(",");
				var sHtml = "";
				for(var k=0;k<dummyidArray.length;k++){
					if(dummyidArray[k]&&dummynames[k]&&dummyidArray[k]!=""&&dummynames[k]!="")
						sHtml = sHtml+"<a href='/docs/docdummy/DocDummyList.jsp?dummyId="+dummyidArray[k]+"'>"+dummynames[k]+"</a>&nbsp";
				}
				document.getElementById(input).value=vbid.id;
				document.getElementById(span).innerHTML=sHtml;
			document.getElementById("spannews_0").style.height = "auto";
			document.getElementById("spancate_0").style.height = "auto";
			document.getElementById("spandummy_0").style.height = "auto";
			document.getElementById("spandocids_0").style.height = "auto";
			document.getElementById(span).style.height = "100px";
			} else {			
				document.getElementById(input).value="0";
				document.getElementById(span).innerHTML="";
			}
		}
	}

	function onSelectMDocs(input,span,scope){
		var vbid = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp?documentids="+$("#"+input).val());
		if(vbid) {
			clearDocumentForm();
			document.getElementById("docids_0").checked = true;
			if (vbid.id!="") {
				dummyidArray=vbid.id.split(",");
				dummynames=vbid.name.split(",");
				var sHtml = "";
				for(var k=0;k<dummyidArray.length;k++){
					if(dummyidArray[k]&&dummynames[k]&&dummyidArray[k]!=""&&dummynames[k]!="")
						sHtml = sHtml+"<a href=/docs/docs/DocDsp.jsp?id="+dummyidArray[k]+"'>"+dummynames[k]+"</a>&nbsp";
				}
				document.getElementById(input).value=vbid.id;
				document.getElementById(span).innerHTML = sHtml;
			document.getElementById("spannews_0").style.height = "auto";
			document.getElementById("spancate_0").style.height = "auto";
			document.getElementById("spandummy_0").style.height = "auto";
			document.getElementById("spandocids_0").style.height = "auto";
			document.getElementById(span).style.height = "100px";
			} else {
				document.getElementById(input).value="0";
				document.getElementById(span).innerHTML ="";
			}
		}
	}
</script>

<body>

<div id="workflowwin" class="x-hidden">
<iframe BORDER=0 FRAMEBORDER='no' NORESIZE=NORESIZE id='ifrmViewType' name='ifrmViewType' width='100%' height='400px' scrolling='NO' src=''></iframe>
</div>

<div id="documentwin" class="x-hidden">
	<table class=viewform width="100%" height="100%">
		<colgroup>
			<col width='27%' />
			<col width='73%' />
		</colgroup>
		<TR>
			<TD WIDTH='27%'>
				<input type=radio name=rdi_0 id=news_0 value=''> <%=SystemEnv.getHtmlLabelName(16356,user.getLanguage()) %><!--新闻中心-->
			</TD>
			<TD WIDTH='73%'>
				<BUTTON class=Browser onclick='onSelectNew("news_0","spannews_0",0)'></BUTTON>
				<SPAN id="spannews_0" style="height:auto;width:350px;display:inline-block;overflow-y:auto;"></SPAN>
			</TD>
		</TR>
		<TR>
			<TD>
				<input type=radio name=rdi_0 id=cate_0 value=''> <%=SystemEnv.getHtmlLabelName(16398,user.getLanguage()) %><!--文档目录-->
			</TD>
			<TD>
				<BUTTON class=Browser onclick='onSelectMultiCatalog("cate_0","spancate_0",0)'></BUTTON>
				<SPAN id=spancate_0 style="height:auto;width:350px;display:inline-block;overflow-y:auto;"></SPAN><br><input id=chkcate_0 type=checkbox name=chk_0><%=SystemEnv.getHtmlLabelName(20568,user.getLanguage()) %></TD>
			</TD>
		</TR>
		<TR>
			<TD>
				<input type=radio name=rdi_0 id=dummy_0 value=''> <%=SystemEnv.getHtmlLabelName(20482,user.getLanguage()) %><!--虚拟目录-->
			</TD>
			<TD>
				<BUTTON class=Browser onClick='onSelectMutiDummy("dummy_0","spandummy_0",0)'></BUTTON>
				<SPAN id=spandummy_0 style="height:auto;width:350px;display:inline-block;overflow-y:auto;"></SPAN><br><input id=chkdummy_0 type=checkbox name=chk_0><%=SystemEnv.getHtmlLabelName(20568,user.getLanguage()) %></TD>
			</TD>
		</TR>
		<TR>
			<TD>
				<input type=radio name=rdi_0 id=docids_0 value=''> <%=SystemEnv.getHtmlLabelName(20533,user.getLanguage()) %><!--指定文档-->
			</TD>
			<TD>
				<BUTTON class=Browser onclick='onSelectMDocs("docids_0","spandocids_0",0)'></BUTTON>
				<SPAN ID=spandocids_0 style="height:auto;width:350px;display:inline-block;overflow-y:auto;"></SPAN>
			</TD>
		</TR>
		<TR>
			<TD CLASS=LINE COLSPAN=2></TD>
		</TR>
	</table>
</div>

</body>
</html>