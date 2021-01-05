<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="ManageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css></HEAD>
</head>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(67,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(19456,user.getLanguage());
String needfav ="1";
String needhelp ="";
String name = Util.null2String(request.getParameter("flowTitle"));
String subcompanyId = Util.null2String(String.valueOf(session.getAttribute("dirMould_subcompanyid")));

boolean hasDocSecCategoryEditRight=false;
if(HrmUserVarify.checkUserRight("DocSecCategoryEdit:Edit", user)){
	hasDocSecCategoryEditRight=true;
}


int detachable = ManageDetachComInfo.isUseDocManageDetach()?1:0;
  int operatelevel=0;
  if(detachable==1){
	   operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"DocSecCategoryEdit:Edit",Util.getIntValue(subcompanyId));
  }else{
	   if(HrmUserVarify.checkUserRight("DocSecCategoryEdit:Edit", user) )
	         operatelevel=2;
 }

if(operatelevel>0){
	 hasDocSecCategoryEditRight = true;
	
}else{
	 hasDocSecCategoryEditRight = false;
	
}
%>

<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<script language=javascript src="/js/ecology8/docs/docSearchInit_wev8.js"></script>
<script language=javascript src="/js/ecology8/docs/docExt_wev8.js"></script>
<form action="" name="frmmain" id="frmmain">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
<%
        if(hasDocSecCategoryEditRight){
%>
			<input type="button" name="multiDel" class="e8_btn_top" onclick="onDelete();" value="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage()) %>"/>
<%
        }
%>
			<input type="text" class="searchInput" name="flowTitle"  value="<%= name %>"/>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
</form>
<%


String operateString = "<operates>";
operateString+=" <popedom transmethod=\"weaver.general.KnowledgeTransMethod.getDirOperate\"></popedom> ";
        if(hasDocSecCategoryEditRight){
operateString += "<operate href=\"javascript:onDelete();\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" target=\"_self\"  index=\"0\"/>";
        }
operateString += "</operates>";
String sqlWhere = "1=1";
if(!name.equals("")){
	sqlWhere = " name like '%"+name+"%'";
}
if(Util.getIntValue(String.valueOf(session.getAttribute("docdetachable")),0)==1){
	sqlWhere += " and subcompanyid in("+subcompanyId+")";
}	
String tableString=""+
  "<table pageId=\""+PageIdConst.DOC_DIRMOULDLIST+"\" instanceid=\"docMouldTable\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.DOC_DIRMOULDLIST,user.getUID(),PageIdConst.DOC)+"\" tabletype=\"checkbox\">"+
  " <checkboxpopedom showmethod=\"weaver.general.KnowledgeTransMethod.getDirCheckbox\"  id=\"checkbox\"  popedompara=\"column:id\" />"+
  "<sql backfields=\"*\" sqlwhere=\""+sqlWhere+"\" sqlform=\"DocSecCategoryTemplate\" sqlorderby=\"id\"  sqlprimarykey=\"id\" sqlsortway=\"asc\"  sqldistinct=\"true\" />"+
  "<head>"+							 
	 "<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(84,user.getLanguage())+"\" column=\"id\" linkkey=\"id\" linkvaluecolumn=\"id\"  orderkey=\"id\"  target=\"_self\"/>"+
	 "<col width=\"60%\" text=\""+SystemEnv.getHtmlLabelName(195,user.getLanguage())+"\" column=\"name\" linkkey=\"id\" linkvaluecolumn=\"id\" target=\"_self\" orderkey=\"name\"/>"+
	 "<col width=\"20%\" text=\""+SystemEnv.getHtmlLabelName(19996,user.getLanguage())+"\" column=\"fromdir\" transmethod=\"weaver.general.KnowledgeTransMethod.getDir\"/>"+						
  "</head>"+ operateString+
  "</table>"; 
%>
<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.DOC_DIRMOULDLIST %>"/>
<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run"  />
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(hasDocSecCategoryEditRight){
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
}

RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:_onViewLog(272),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
 %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</BODY>
<script type="text/javascript">
function onDelete(id){
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
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>",function(){
		location.href="/docs/category/DocSecCategorySaveAsTmplOperation.jsp?tmplId="+id+"&method=deletetmpl";
	});
}

function onBtnSearchClick(){
		jQuery("#frmmain").submit();
	}
</script>
</HTML>
