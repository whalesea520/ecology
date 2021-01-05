
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="com.weaver.formmodel.mobile.model.MobileAppBaseInfo" %>
<%@ page import="com.weaver.formmodel.mobile.model.MobileAppModelInfo" %>
<%@ page import="com.weaver.formmodel.mobile.manager.MobileAppModelManager" %>
<%@ page import="com.weaver.formmodel.mobile.manager.MobileAppBaseManager" %>
<%@page import="weaver.formmode.service.ModelInfoService"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
String appid=Util.null2String(request.getParameter("appid"));
String id=Util.null2String(request.getParameter("id"));
int appidInt = Util.getIntValue(appid,0);
int idInt = Util.getIntValue(id, 0);
MobileAppBaseInfo appbaseInfo = MobileAppBaseManager.getInstance().get(appidInt);
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "模块设置";//SystemEnv.getHtmlLabelName(23669,user.getLanguage());
String needfav ="1";
String needhelp ="";
String err=Util.null2String(request.getParameter("err"));
String refresh = Util.null2o(request.getParameter("refresh"));
int formlabelId = Util.getIntValue(appbaseInfo.getFormname(),0);
String formlabelName = SystemEnv.getHtmlLabelName(formlabelId,user.getLanguage());
MobileAppModelInfo appModelInfo = MobileAppModelManager.getInstance().getAppFormInfo(idInt);
String modeinfoname="";
if(appModelInfo.getId()!=null){
	ModelInfoService modelInfoService=new ModelInfoService();
	modeinfoname=modelInfoService.getModelInfoNameByModelInfoId(appModelInfo.getModelId());
}
%>


<HTML><HEAD>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<style>
.loading{
    position:absolute;
    left:45%;
    background:#ffffff;
    top:40%;
    padding:8px;
    z-index:20001;
    height:auto;
    border:1px solid #ccc;
}
</style>
<script type="text/javascript">
if('<%=refresh%>'=='1'){
	parent.refreshWithMobileAppModelCreated();
}
</script>
<script>
function onSave(){
	if(check_form(frmMain,"formId")){
		enableAllmenu();
		$(".loading").show(); 
		document.frmMain.action='/weaver/com.weaver.formmodel.mobile.servlet.AppFormAction?action=create';
		document.frmMain.submit();
	}
}
function onDelete(){
	if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
		enableAllmenu();
		$(".loading").show(); 
		document.frmMain.action='/weaver/com.weaver.formmodel.mobile.servlet.AppFormAction?action=delete';
		document.frmMain.submit();
	}
}

function onShowModelSelect(inputName,spanName){
	var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/formmode/browser/ModeBrowser.jsp");
	if (datas){
	    if(datas.id!=""){
		    $(inputName).val(datas.id);
			if ($(inputName).val()==datas.id){
		    	$(spanName).html(datas.name);
			}
	    }else{
		    $(inputName).val("");
			$(spanName).html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
		}
	} 
}
function toformtab(formid){
	var height = document.body.clientHeight;
	var width = document.body.clientWidth;
	var parm = "&formid="+formid;
	if(formid=='') 
		parm = '';
	var url = "/workflow/form/addDefineForm.jsp?isFromMode=1"+parm;
	var handw = "dialogHeight="+height+";dialogWidth="+width;
	//window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+escape(url),window,handw);
	window.open(url);
}

</script>
</HEAD>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
    RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_self} " ;
    RCMenuHeight += RCMenuHeightStep ;
    if(idInt > 0) {
    	RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} ";
    	RCMenuHeight += RCMenuHeightStep ;
    }
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<body scroll="no">
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
<td height="10" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">
<div id=divMessage style="color:red">
</div>
<FORM id=weaver name=frmMain method=post target="_self">
<%

if("1".equals(err)){ 
	out.println("<font color=#FF0000>"+SystemEnv.getHtmlLabelName(28472,user.getLanguage())+"</a>");		
}else if("2".equals(err)){ 
	out.println("<font color=#FF0000>"+SystemEnv.getHtmlLabelName(21089,user.getLanguage())+"</a>");		
}
%>

        <TABLE class=ViewForm width="100%">
          <COLGROUP>
          <COL width="30%">
          <COL width="70%">
          <TBODY>
          <TR class=Title>
            <TH><%=SystemEnv.getHtmlLabelName(16261,user.getLanguage())%></TH>
          </TR>
          <TR class=Spacing style="height: 1px!important;">
            <TD class=line1 colSpan=2></TD>
          </TR>
          <TR>
            <TD>所属应用</TD><!-- 名称 -->
            <TD class=FIELD>
                 <SPAN><%=Util.null2String(appbaseInfo.getAppname()) %></SPAN>
              </TD>
          </TR>
          <TR>
            <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD><!-- 名称 -->
            <TD class=FIELD>
                 <INPUT class=InputStyle type="text" id="entityName" name=entityName value="<%=Util.null2String(appModelInfo.getEntityName())%>">
              </TD>
          </TR>
           <TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
            <TR>
            <TD>模型数据来源</TD><!--模型数据来源-->
            <TD class=FIELD>
              <select id="datafrom" name="datafrom">
              <option>系统</option>
              <option>外部</option>
              </select>
              </TD>
          </TR>
           <TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
           <TR>
            <TD><%=SystemEnv.getHtmlLabelName(28485,user.getLanguage())%></TD><!-- 类别 -->
            <TD class=FIELD>
            <button type="button" class=Browser id=formidSelect onClick="onShowModelSelect( modelId, formidSelectSpan)" name=formidSelect></BUTTON>
  		 	<span name="formidSelectSpan" id=formidSelectSpan><%=modeinfoname%></span>    
              <INPUT class=InputStyle type="hidden" id="modelId" name=modelId value="<%=appModelInfo.getModelId()%>" maxlength="40" >
                 <SPAN id=treeFieldNameImage></SPAN>
              </TD>
          </TR>
          <TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
           <TR>
            <TD><%=SystemEnv.getHtmlLabelName(88,user.getLanguage())%></TD><!-- 顺序-->
            <TD class=FIELD>
              <INPUT class=InputStyle  name="showOrder" id="showOrder" value="<%=appModelInfo.getShowOrder() %>" maxlength="40" >
                 <SPAN id=treeFieldNameImage></SPAN>
              </TD>
          </TR>
         <TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
          </TBODY>
        </TABLE>
   <input type=hidden name=operation>
   <input type=hidden name=appId value="<%=appid%>">
   <input type=hidden name=id value="<%=id%>">
 </FORM>

</td>
</tr>
</TABLE>
</td>
<td></td>
</tr>
<tr>
<td height="10" colspan="3"></td>
</tr>
</table>
 </body>
</html>