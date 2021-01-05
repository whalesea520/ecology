
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.system.code.*"%>
<%@ page import="weaver.docs.category.security.MultiAclManager" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="scc" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="ManageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/ecology8/docs/docSearchInit_wev8.js"></script>
<script language=javascript src="/js/ecology8/docs/docExt_wev8.js"></script>
<script type="text/javascript">

function onBtnSearchClick(){
	jQuery("#searchfrm").submit();
}

function toggleSetting(obj){
	if(obj.checked){
		showEle("setting");
	}else{
		hideEle("setting");
	}
}
</script>
</HEAD>

<%
	String id = Util.null2String(request.getParameter("id"));
	RecordSet.executeProc("Doc_SecCategory_SelectByID",id+"");
	RecordSet.next();
	String subcategoryid=RecordSet.getString("subcategoryid");
	int mainid = Util.getIntValue(SubCategoryComInfo.getMainCategoryid(subcategoryid),0);
	//初始值
    boolean hasSubManageRight = false;
	boolean hasSecManageRight = false;
	MultiAclManager am = new MultiAclManager();
	//hasSubManageRight = am.hasPermission(mainid, MultiAclManager.CATEGORYTYPE_MAIN, user, MultiAclManager.OPERATION_CREATEDIR);
	int parentId = Util.getIntValue(scc.getParentId(id));
	if(parentId>0){
		hasSecManageRight = am.hasPermission(parentId, MultiAclManager.CATEGORYTYPE_SEC, user, MultiAclManager.OPERATION_CREATEDIR);
	}
    boolean canEdit = false ;
	if (HrmUserVarify.checkUserRight("DocSecCategoryEdit:Edit",user) || hasSecManageRight) {
		canEdit = true ;
	}
	String titlename = "";
  int detachable = ManageDetachComInfo.isUseDocManageDetach()?1:0;
  int operatelevel=0;
  if(detachable==1){
	   operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"DocSecCategoryEdit:Edit",Util.getIntValue(scc.getSubcompanyIdFQ(id+""),0));
  }else{
	   if(HrmUserVarify.checkUserRight("DocSecCategoryEdit:Edit", user) || hasSecManageRight)
	         operatelevel=2;
 }

if(operatelevel>0){
	 canEdit = true;
	
}else{
	 canEdit = false;
	
}
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
  //菜单
  if (canEdit){
	  RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(this),_top} " ;
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
			<%if(canEdit){ %>
				<input type=button class="e8_btn_top" onclick="onSave(this);" value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage())%>"></input>
			<%} %>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
</form>
<FORM METHOD="POST" name="frmEdition" ACTION="DocSecCategoryEditionOperation.jsp">
<INPUT TYPE="hidden" NAME="method" VALUE="save">
<INPUT TYPE="hidden" NAME="secCategoryId" value="<%=id%>">
<%
int currEditionIsOpen = 0;
String currEditionPrefix = "";
int currReaderCanViewHistoryEdition = 0;

int isNotDelHisAtt = 0;

RecordSet.executeSql("select * from DocSecCategory where id = " + id);
if(RecordSet.next()){
	currEditionIsOpen = RecordSet.getInt("editionIsOpen");
	currEditionPrefix = RecordSet.getString("editionPrefix");
	currReaderCanViewHistoryEdition = RecordSet.getInt("readerCanViewHistoryEdition");
	isNotDelHisAtt = Util.getIntValue(Util.null2String(RecordSet.getString("isNotDelHisAtt")),0);
}
%>
	
<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(33114,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(18095,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19450,user.getLanguage())%></wea:item>
		<wea:item><input onclick="toggleSetting(this);" class=InputStyle tzCheckbox="true" type=checkbox value=1 name=editionIsOpen <%=(currEditionIsOpen==1)?"checked":""%> <%if(!canEdit){%>disabled<%}%>></wea:item>
		<%
			String attrs = "{'isTableList':'true','samePair':'setting','display':'"+(currEditionIsOpen==1?"":"none")+"'}";
		%>
		<wea:item attributes='<%=attrs %>'>
			<wea:layout needImportDefaultJsAndCss="false">
				<wea:group context="" attributes="{'groupDisplay':'none'}">
					<wea:item><%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(583,user.getLanguage())%></wea:item>
					<wea:item><input class=InputStyle type="text" value='<%=currEditionPrefix%>' name="editionPrefix" <%if(!canEdit){%>disabled<%}%>></wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(19528,user.getLanguage())%></wea:item>
					<wea:item><input class=InputStyle tzCheckbox="true" type=checkbox value=1 name="readerCanViewHistoryEdition" <%=(currReaderCanViewHistoryEdition==1)?"checked":""%> <%if(!canEdit){%>disabled<%}%>></wea:item>
					
				</wea:group>
			</wea:layout>
		</wea:item>
	</wea:group>
</wea:layout>
	


<script>
function onSave(obj){
	document.frmEdition.submit();
	obj.disabled = true;
}
</SCRIPT>
</FORM>

</BODY>
</HTML>
