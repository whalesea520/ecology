
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<jsp:useBean id="CheckSubCompanyRight"
	class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="hpu" class="weaver.homepage.HomepageUtil" scope="page" />

<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
	if(!HrmUserVarify.checkUserRight("homepage:Maint", user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	String portalname = Util.null2String(request.getParameter("flowTitle"));
	String tempWhere = "";
	if(!"".equals(portalname))tempWhere+=" and infoname like '%"+portalname+"%'";

	String titlename = SystemEnv.getHtmlLabelName(23017, user.getLanguage());
	//得到分部ID
	String message = Util.null2String(request.getParameter("message"));
	//页标题
	int operatelevel = 0;
	
	if (HrmUserVarify.checkUserRight("homepage:Maint", user))
		operatelevel = 2;
	boolean canEdit = false;
	if (operatelevel > 0)
		canEdit = true;
%>
<HTML>
<HEAD>
	<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
	<script type="text/javascript">
	$(document).ready(function(){
		jQuery("#topTitle").topMenuTitle({searchFn:onSearch});
		
	});
	</script>
</head>
<BODY>
<jsp:include page="/systeminfo/commonTabHead.jsp">
		   <jsp:param name="mouldID" value="portal"/>
		   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(23017,user.getLanguage()) %>"/> 
		</jsp:include>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	if (canEdit){
		RCMenu += "{" + SystemEnv.getHtmlLabelName(82, user.getLanguage())
				+ ",javascript:onNew(),_self} ";
		RCMenuHeight += RCMenuHeightStep;
		
		RCMenu += "{" + SystemEnv.getHtmlLabelName(86, user.getLanguage())
		+ ",javascript:onSave(),_self} ";
		RCMenuHeight += RCMenuHeightStep;
		
		RCMenu += "{" + SystemEnv.getHtmlLabelName(32136, user.getLanguage())
		+ ",javascript:onDelAll(),_self} ";
		RCMenuHeight += RCMenuHeightStep;
	}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<form name="searchPortalForm" method="post" action="LoginPageContent.jsp">
	<table id="topTitle" cellpadding="0" cellspacing="0" width="100%">
		<tr>
			<td width="75px">					
			</td>
			<td class="rightSearchSpan" style="text-align:right; width:500px!important">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>" class="e8_btn_top" onclick="onNew();" />
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top"  onclick="onSave();"/>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(32136,user.getLanguage())%>" class="e8_btn_top" onclick="onDelAll();"/>				
				<input type="text" class="searchInput" name="flowTitle"  value="<%=portalname %>"/>
				<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
				
			</td>
		</tr>
	</table>
	
	<div class="advancedSearchDiv" id="advancedSearchDiv">
	</div>
</form>
<form name="frmAdd" method="post" action="LoginMaintOperate.jsp">
<input name="method" type="hidden">
<TEXTAREA id="areaResult" NAME="areaResult" ROWS="2" COLS="30" style="display:none"></TEXTAREA>
	<!--列表部分-->
	<%
	//得到pageNum 与 perpage
	int perpage = 10;
	//设置好搜索条件
	
	String sqlWhere = "";
	if ("sqlserver".equals(rs.getDBType())){
		sqlWhere = " where creatortype=0 and subcompanyid=-1 and infoname != ''";
	}else{
		sqlWhere = " where creatortype=0 and subcompanyid=-1 and infoname is not null";
	}
	sqlWhere+=tempWhere;
	String tableString = "<table  pagesize=\""+ perpage+ "\" tabletype=\"checkbox\" valign=\"top\">"
						+ "<checkboxpopedom popedompara=\"column:id\" showmethod=\"weaver.splitepage.transform.SptmForHomepage.getPortalDel\"/>"
						+ "<sql backfields=\"id,infoname,creatorid,hpcreatorid,infodesc,styleid,layoutid,subcompanyid,isuse,hplastdate\" sqlform=\" from hpinfo \"  sqlorderby=\"subcompanyid\"  sqlprimarykey=\"id\" sqlsortway=\"asc\" sqlwhere=\""+ Util.toHtmlForSplitPage(sqlWhere)+ "\" sqldistinct=\"true\" />"
						+ "<head >"
						+ "<col width=\"5%\"  text=\"ID\"   column=\"id\" orderkey=\"id\" />"
						+ "<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(195,user.getLanguage())+"\"  column=\"infoname\" orderkey=\"infoname\" />"
					  	+ "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(18095,user.getLanguage())+"\" column=\"isUse\" orderkey=\"isUse\" transmethod=\"weaver.splitepage.transform.SptmForHomepage.getIsUseStr\" otherpara=\"column:id\"/>"
						+ "<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(882,user.getLanguage())+"\" column=\"hpcreatorid\" transmethod=\"weaver.splitepage.transform.SptmForHomepage.getPortalCreator\" />"								  
						+ "<col width=\"25%\" text=\""+SystemEnv.getHtmlLabelName(19520,user.getLanguage())+"\" column=\"hplastdate\" />"
						+ "</head>" 
						+ "<operates width=\"20%\" >";
	if (operatelevel > 0){
		tableString += " <popedom otherpara=\"column:id\" transmethod=\"weaver.splitepage.transform.SptmForHomepage.getOperate\"></popedom> " 
			+ "<operate href=\"javascript:doSetElement();\" text=\""+SystemEnv.getHtmlLabelName(19650,user.getLanguage())+"\" target=\"_self\"  index=\"0\"/>"
						 + "<operate href=\"javascript:doPriview();\" text=\""+SystemEnv.getHtmlLabelName(221,user.getLanguage())+"\" target=\"_self\"  index=\"1\"/>"
						 + "<operate href=\"javascript:doEdit();\" text=\""+SystemEnv.getHtmlLabelName(26473,user.getLanguage())+"\" target=\"_blank\"  index=\"2\"/>"
						 + "<operate href=\"javascript:saveNew();\" text=\""+SystemEnv.getHtmlLabelName(350,user.getLanguage())+"\" target=\"_self\"  index=\"3\"/>"
						 + "<operate href=\"javascript:doDel();\" text=\""+SystemEnv.getHtmlLabelName(23777,user.getLanguage())+"\" target=\"_self\"  index=\"4\"/>";
	}else{
		tableString += "  <operate  text=\"" + SystemEnv.getHtmlLabelName(221, user.getLanguage()) + "\" />" 
				+ "  <operate   text=\""+ SystemEnv.getHtmlLabelName(26473, user.getLanguage()) + "\" />" 
				+ "  <operate  text=\""+ SystemEnv.getHtmlLabelName(350, user.getLanguage()) + "\" />" 
				+ "  <operate   text=\""+ SystemEnv.getHtmlLabelName(23777, user.getLanguage()) + "\"/>";
	}
	
	tableString += "</operates></table>";
	%>
	<TABLE width="100%">
		<TR>
			<TD valign="top">
				<wea:SplitPageTag tableString='<%=tableString%>' mode="run" isShowTopInfo="true" isShowBottomInfo="true" />
			</TD>
		</TR>
	</TABLE>
</form>	
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include> 

</BODY>
</HTML>
<SCRIPT LANGUAGE="JavaScript">
	function onSearch(){
		searchPortalForm.submit();		
	}
    
    
    function onSave(){
		//得到所设置的结果    hpid_isuse_ischecked||hpid_isuse_ischecked||...
		var chkUses=document.getElementsByName("chkUse");
		var returnStr="";
		for(var i=0;i<chkUses.length;i++) {
			var tmepChkUse=chkUses[i];
			var hpid=jQuery(tmepChkUse).attr("hpid");
			var isuse=tmepChkUse.checked?1:0;

			var isuse=tmepChkUse.checked?1:0;
			var ischecked=1;

			returnStr+=hpid+"_"+isuse+"_"+ischecked+"||"
		}
		if (returnStr!="") returnStr=returnStr.substr(0,returnStr.length-2);
		frmAdd.areaResult.value=returnStr;

		frmAdd.method.value="save";
		frmAdd.submit()
	}
	
	
	
	
	function onNew(){
	 	var title = "<%=SystemEnv.getHtmlLabelName(365,user.getLanguage())%>"; 
	 	var url = "/homepage/maint/LoginPageEdit.jsp?method=ref";
	 	showDialog(title,url,900,600,true);
	}
	
	function saveNew(hpid){
	 	var title = "<%=SystemEnv.getHtmlLabelName(350,user.getLanguage())%>"; 
	 	var url = "/homepage/maint/LoginPageEdit.jsp?method=saveNew&hpid="+hpid;
	 	showDialog(title,url,900,600,false);
	}
	
	function doEdit(hpid){
	 	var title = "<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>"; 
	 	var url = "/homepage/maint/LoginPageEdit.jsp?opt=edit&method=savebase&hpid="+hpid;
	 	showDialog(title,url,900,600,true);
	}
	
	function doSetElement(hpid){
	 	var title = "<%=SystemEnv.getHtmlLabelName(19650,user.getLanguage())%>"; 
	 	//var url = "/homepage/Homepage.jsp?isSetting=true&hpid="+hpid+"&from=setElement&pagetype=loginview&opt=edit";
	 	var url = "/homepage/maint/HomepageTabs.jsp?_fromURL=ElementSetting&isSetting=true&hpid="+hpid+"&from=setElement&subCompanyId=-1&pagetype=loginview&opt=edit";
	 	//var url = "/homepage/maint/HomepageTabs.jsp?_fromURL=ElementSetting&isSetting=true&hpid="+hpid+"&from=setElement&pagetype=&opt=edit&subCompanyId="+subCompanyId;
	 	showDialog(title,url,top.document.body.clientWidth,top.document.body.clientHeight,true);
	}
	
	function doPriview(hpid){
	 	var title = "<%=SystemEnv.getHtmlLabelName(221,user.getLanguage())%>"; 
	 	var url="/homepage/LoginHomepage.jsp?hpid="+hpid+"&subCompanyId=-1&opt=privew";
	 	showDialog(title,url,top.document.body.clientWidth,top.document.body.clientHeight,true);
	}
	
	
	function showDialog(title,url,width,height,showMax){
		var Show_dialog = new window.top.Dialog();
		Show_dialog.currentWindow = window;   //传入当前window
	 	Show_dialog.Width = width;
	 	Show_dialog.Height = height;
	 	Show_dialog.maxiumnable=showMax;
	 	Show_dialog.Modal = true;
	 	Show_dialog.Title = title;
	 	Show_dialog.URL = url;
	 	Show_dialog.show();
	}
	
	function doDel(hpid){
		top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>",function(){
			jQuery.post("/homepage/maint/LoginMaintOperate.jsp?method=delhp&hpid="+hpid,
			function(data){if(data.indexOf("OK")!=-1) location.reload();});
		});
	}
	
	function onDelAll(){
		var hpids = _xtable_CheckedCheckboxId();
		if(hpids==""){
		   window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(30993,user.getLanguage())%>");
		   return;
		}else{
		   doDel(hpids);
		}
	}
	
	function onSave(){
		var chkUses=jQuery("input[name=chkUse]");
		var returnStr="";
		for(var i=0;i<chkUses.length;i++){
			var tmepChkUse=chkUses[i];
			var hpid=jQuery(tmepChkUse).attr("hpid");

			var isuse=tmepChkUse.checked?1:0;
			returnStr+=hpid+"_"+isuse+"||"
		}		
		if (returnStr!="") returnStr=returnStr.substr(0,returnStr.length-2);
		frmAdd.areaResult.value=returnStr;

		frmAdd.method.value="save";
		frmAdd.submit();
	}

	function onTran2(subid,hpid){
	 	onTran(hpid,subid);
	}

	function onTran(hpid,subid){
		datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?subid=-1")
		
		if (datas){
			if(datas.id){
				targetSubid=datas.id;
				url="/homepage/maint/HomepageMaintOperate.jsp?method=tran&srcSubid="+subid+"&tranHpid="+hpid+"&targetSubid="+targetSubid+"&fromSubid=<%=-1%>&subCompanyId=-1"
				window.location.replace(url);
			}
		}
	}
</SCRIPT>
