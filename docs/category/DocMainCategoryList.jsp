
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.docs.category.security.*" %>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil"/>
<jsp:useBean id="scc" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="ManageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
<HTML><HEAD>
<%
String parentid = Util.null2String(request.getParameter("parentid")); 
//是否开启分权
boolean isUseDocManageDetach=ManageDetachComInfo.isUseDocManageDetach();
%>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script type="text/javascript">
function onBtnSearchClick(){
	jQuery("#searchfrm").submit();
}

function doDel(id){
	if(!id){
		id = _xtable_CheckedCheckboxId();
	}
	if(!id){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32568,user.getLanguage())%>");
		return;
	}
	if(id.match(/,$/)){
		id = id.substring(0,id.length-1);
	}
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(33435,user.getLanguage())%>",function(){
		var idArr = id.split(",");
		var msg = "";
		var ajaxNum = 0;
		for(var i=0;i<idArr.length;i++){
			ajaxNum++;
			jQuery.ajax({
				url:"SecCategoryOperation.jsp?isdialog=1&operation=delete&id="+idArr[i],
				type:"post",
				beforeSend:function(){
					e8showAjaxTips("<%=SystemEnv.getHtmlLabelName(33592,user.getLanguage())%>",true);
				},
				success:function(data){
					try{
						var message = data.match(/~~~~\d+~~~~/);
						if(message){
							message = message[0];
							if(message){
								message = message.match(/\d+/)[0];
								if(parseInt(message)=="87"){
									msg = "<%=SystemEnv.getHtmlLabelName(21536,user.getLanguage())%>";
								}
							}
						}
					}catch(e){
						if(window.console)console.log(e,"DocMainCategoryList.jsp#doDel");
					}
				},
				complete:function(xhr,status){
					ajaxNum--;
					if(ajaxNum==0){
						_table.reLoad();
						parent.parent.refreshTreeMain(0,"undefined");
						e8showAjaxTips("",false);
						if(msg){
							top.Dialog.alert(msg);
						}
					}
				}
			});
		}
	});
}

var dialog = null;
function closeDialog(){
	if(dialog)
		dialog.close();
}

function openDialog(id){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	if(id==null){
		id="";
	}
	var url = "/docs/tabs/DocCommonTab.jsp?_fromURL=8&isdialog=1&from=subedit";
	<%if(!parentid.equals("")){%>
		url += "&id=<%=parentid%>";
	<%}%>
	if(!!id){
		dialog.Title = "<%=SystemEnv.getHtmlLabelNames("26473,32452",user.getLanguage())%>";
		dialog.Height = 400;
		url = "/docs/tabs/DocCommonTab.jsp?_fromURL=9&isdialog=1&id="+id;
	}else{
		dialog.Title = "<%=SystemEnv.getHtmlLabelNames("82,32452",user.getLanguage())%>";
		dialog.Height = 400;
	}
	dialog.Width = 600;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}


function onExportExcel(id) {
	if(!id){
		id = _xtable_CheckedCheckboxId();
	}
	if(!id){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(20551,user.getLanguage())%>");
		return;
	}
	if(id.match(/,$/)){
		id = id.substring(0,id.length-1);
	}
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "/docs/category/SecCategoryExport.jsp?isall=1";
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(24960,user.getLanguage())%>";
	dialog.Width = 360;
	dialog.Height = 120;
	dialog.normalDialog=false;
	dialog.Drag = true;
	dialog.OKEvent = function(){
		if(dialog.innerFrame.contentWindow.document.getElementById('isinclude').checked){
			window.location.href="/docs/category/SecCategoryExportProcess.jsp?ids="+id+"&isinclude=1";
		}else{
			window.location.href="/docs/category/SecCategoryExportProcess.jsp?ids="+id;
		}
	dialog.close();
	};//点击确定后调用的方法
	dialog.URL = url;
	dialog.show();
}
//新建分目录
function openDialog3(id){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	if(id==null){
		id="";
	}
	var url = "/docs/tabs/DocCommonTab.jsp?_fromURL=8&from=subedit&isdialog=1&id="+id;
	dialog.Title = "<%=SystemEnv.getHtmlLabelNames("82,32452",user.getLanguage())%>";
	dialog.Width = 600;
	dialog.Height = 400;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}

//目录权限维护
function openDialog4(id){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	if(id==null){
		return;
	}
	var url="/docs/category/DocSecCategoryRightEdit.jsp?from=tab&_fromURL=5&id="+id;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(19174,user.getLanguage())%>";
	dialog.Width = jQuery(window).width();
	dialog.Height = 472;
	dialog.Drag = true;
	dialog.maxiumnable = true;
	dialog.checkDataChange = false;
	dialog.URL = url;
	dialog.show();
}

function onLog(id){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "/docs/tabs/DocCommonTab.jsp?_fromURL=3&isdialog=1&secid=65&sqlwhere=<%=xssUtil.put("where operateitem=3 and relatedid=")%>&relatedid="+id;
	dialog.Title = "<%=SystemEnv.getHtmlLabelNames("17480",user.getLanguage())%>";
	dialog.Width = jQuery(window).width();
	dialog.Height = 610;
	dialog.Drag = true;
	dialog.checkDataChange = false;
	dialog.maxiumnable = true;
	dialog.URL = url;
	dialog.show();
}

</script>
<script type="text/javascript">
	<%if(parentid.equals("")){%>
		try{
			parent.setTabObjName("<%=SystemEnv.getHtmlLabelName(16398,user.getLanguage())%>");
		}catch(e){}
	<%}%>
</script>
<script language=javascript src="/js/ecology8/docs/docSearchInit_wev8.js"></script>
<script language=javascript src="/js/ecology8/docs/docExt_wev8.js"></script>
</head>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(93,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(65,user.getLanguage());
String needfav ="1";
String needhelp ="";
String qname = Util.null2String(request.getParameter("flowTitle"));
String subcompanyId = Util.null2String(request.getParameter("subCompanyId")); 
boolean hasRightExcel=true;
if(isUseDocManageDetach&&Util.getIntValue(subcompanyId)<=0){
	hasRightExcel=false;
}
if(Util.getIntValue(subcompanyId)<=0){
	subcompanyId = Util.null2String(String.valueOf(session.getAttribute("maincategory_subcompanyid")));
	String hasRightSub = Util.null2String(session.getAttribute("hasRightSub2"));
	if(!hasRightSub.equals("")){
	subcompanyId=hasRightSub;
	}
	session.removeAttribute("hasRightSub2");
}
int detach = ManageDetachComInfo.isUseDocManageDetach()?1:0;
MultiAclManager am = new MultiAclManager();
int parentId = Util.getIntValue(parentid);
boolean hasSecRightManage = false;
if(parentId>0)
	hasSecRightManage = am.hasPermission(parentId, MultiAclManager.CATEGORYTYPE_SEC, user, MultiAclManager.OPERATION_CREATEDIR);

 int operatelevel=0;
 if(detach==1){
	  operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"DocSecCategoryEdit:Edit",Util.getIntValue(subcompanyId,0));
 }else{    
	  operatelevel=2;
 }
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if((HrmUserVarify.checkUserRight("DocSecCategoryAdd:Add", user)||hasSecRightManage)&&operatelevel>0){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:openDialog(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
if((HrmUserVarify.checkUserRight("DocSecCategoryEdit:Delete", user)||hasSecRightManage)&&operatelevel>0){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:doDel(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
 %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form action="" name="searchfrm" id="searchfrm">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<%if((HrmUserVarify.checkUserRight("DocSecCategoryAdd:Add", user)||hasSecRightManage)&&operatelevel>0){ %>
				<input type=button class="e8_btn_top" onclick="openDialog();" value="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>"></input>
			<%}if(hasRightExcel&&(HrmUserVarify.checkUserRight("DocSecCategoryAdd:Add", user))&&operatelevel>0){ %>
				<input type=button class="e8_btn_top" onclick="onImportExcel();" value="Excel<%=SystemEnv.getHtmlLabelName(18596,user.getLanguage())%>"></input>
				<input type=button class="e8_btn_top" onclick="onExportExcel();" value="<%=SystemEnv.getHtmlLabelName(17416,user.getLanguage())%>Excel"></input>
			<%}%>
			<input type="text" class="searchInput" name="flowTitle"  value="<%=qname %>"/>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
</form>
<%
	String sqlWhere = "(parentid is null or parentid<=0)";
	if(!parentid.equals("")){
		sqlWhere = " parentid = "+parentid;
	}
	if(!qname.equals("")){
		sqlWhere += " and categoryname like '%"+qname+"%'";
	}
	if(detach==1 && parentid.equals("")&&!subcompanyId.equals("")){
		sqlWhere += " and subcompanyid in("+subcompanyId+")";
	}							
	String  operateString= "";
	if((HrmUserVarify.checkUserRight("DocSecCategoryAdd:Add", user)||hasSecRightManage)&&operatelevel>0) {
	operateString = "<operates width=\"20%\">";
	 	       operateString+=" <popedom transmethod=\"weaver.general.KnowledgeTransMethod.getDocDirOperate\" otherpara=\""+((HrmUserVarify.checkUserRight("DocSecCategoryEdit:Edit", user)||hasSecRightManage)&&operatelevel>0)+"\" otherpara2=\""+((HrmUserVarify.checkUserRight("DocSecCategoryEdit:Delete", user)||hasSecRightManage)&&operatelevel>0)+":"+((HrmUserVarify.checkUserRight("DocSecCategory:log", user)||hasSecRightManage)&&operatelevel>0)+":"+((HrmUserVarify.checkUserRight("DocSecCategoryAdd:Add", user)||hasSecRightManage)&&operatelevel>0)+":"+user.getUID()+"\"></popedom> ";
	 	       operateString+="     <operate href=\"javascript:openDialog();\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" index=\"0\"/>";
	 	       operateString+="     <operate href=\"javascript:doDel()\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" index=\"1\"/>";
	 	       operateString+="     <operate href=\"javascript:onLog()\" text=\""+SystemEnv.getHtmlLabelName(83,user.getLanguage())+"\" index=\"2\"/>";
	 	       operateString+="     <operate href=\"javascript:openDialog3()\" text=\""+SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(33112,user.getLanguage())+"\" index=\"3\"/>";
	 	       operateString+="     <operate href=\"javascript:openDialog4();\" text=\""+SystemEnv.getHtmlLabelName(19174,user.getLanguage())+"\" index=\"4\"/>";
	 	       operateString+="</operates>";
	}			   
	 String tabletype="none";
	 if((HrmUserVarify.checkUserRight("DocSecCategoryEdit:Delete", user) || hasSecRightManage)&&operatelevel>0){
	 	tabletype = "checkbox";
	 }
	String tableString=""+
	   "<table pageId=\""+PageIdConst.DOC_MAINCATEGORYLIST+"\" instanceid=\"docMouldTable\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.DOC_MAINCATEGORYLIST,user.getUID(),PageIdConst.DOC)+"\" tabletype=\""+tabletype+"\">"+
	    " <checkboxpopedom  id=\"checkbox\" showmethod=\"weaver.general.KnowledgeTransMethod.getDirCheckbox\" popedompara = \"column:id\" />"+
	   "<sql backfields=\"*\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlform=\"DocSecCategory\" sqlorderby=\"secorder\"  sqlprimarykey=\"id\" sqlsortway=\"asc\"  sqldistinct=\"true\" />"+
	   operateString+
	   "<head>"+							 
			 "<col pkey=\"id+weaver.general.KnowledgeTransMethod.forHtml\" width=\"10%\" text=\"ID\" column=\"id\"  orderkey=\"id\"/>"+
			 "<col pkey=\"categoryname+weaver.general.KnowledgeTransMethod.forHtml\" width=\"30%\" href=\""+Util.toHtmlForSplitPage("/docs/category/DocCategoryTab.jsp?_fromURL=3&refresh=1")+"\" column=\"categoryname\" linkkey=\"id\" linkvaluecolumn=\"id\" target=\"_parent\" text=\""+SystemEnv.getHtmlLabelName(24764,user.getLanguage())+"\"/>"+
			 "<col pkey=\"coder+weaver.general.KnowledgeTransMethod.forHtml\" width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(81529,user.getLanguage())+"\" column=\"coder\"/>";
			 tableString += "<col pkey=\"secorder+weaver.general.KnowledgeTransMethod.forHtml\" width=\"20%\" text=\""+SystemEnv.getHtmlLabelName(15513,user.getLanguage())+"\" column=\"secorder\"/>";
			 if(detach==1 && Util.getIntValue(parentid)<=0){
				 tableString += "<col pkey=\"subcompanyid\" width=\"20%\" transmethod=\"weaver.hrm.company.SubCompanyComInfo.getSubCompanyname\" text=\""+SystemEnv.getHtmlLabelName(17868,user.getLanguage())+"\" column=\"subcompanyid\"/>";
			 }
	   tableString += "</head>"+
	   "</table>";
%> 
<script type="text/javascript">
function onImportExcel(){
	var url = "/docs/tabs/DocCommonTab.jsp?_fromURL=100&isdialog=1&subcompanyid=<%=subcompanyId%>";
	dialog = new window.top.Dialog();
	dialog.currentWindow = window; 
	dialog.Title = "Excel<%=SystemEnv.getHtmlLabelName(18596,user.getLanguage())%>";
	dialog.Width = 800;
	dialog.Height = 600;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.CancelEvent = function(){
		if(dialog.innerWin.tabcontentframe.location.href.indexOf("SecCategoryImportResult.jsp") > -1){
			parent.parent.location.href = parent.parent.location.href;
		}
		dialog.close();
	};
	dialog.show();
}
</script>
<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.DOC_MAINCATEGORYLIST %>"/>
<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run"  />
</BODY>
</HTML>
