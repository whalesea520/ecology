<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util,java.util.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%
	String importtype = Util.null2String(request.getParameter("importtype"));
/*已在外部控制
if (!HrmUserVarify.checkUserRight("HrmResourceEdit:Edit",user)) {
	response.sendRedirect("/notice/noright.jsp");
	return;
}*/
%>
<HTML>
<HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<link href="/js/jquery/ui/jquery-ui_wev8.css" type="text/css" rel=stylesheet>
<script language="javascript" src="/js/checkinput_wev8.js"></script>
<script language=javascript src="/js/ecology8/hrm/hrmSearchInit_wev8.js"></script>
<script type="text/javascript">
var parentWin = parent.parent.getParentWindow(parent);
var dialog = parent.parent.getDialog(parent);
function onBtnSearchClick(){
	//jQuery("#searchfrm").submit();
}
</script>
<STYLE type=text/css>
#loading{
    position:absolute;
    left:45%;
    background:#ffffff;
    top:40%;
    padding:8px;
    z-index:20001;
    height:auto;
    border:1px solid #ccc;
    display:none;
}
</STYLE>

</head>
<%
	String imagefilename = "/images/hdHRMCard_wev8.gif";
	String title = Util.null2String(request.getParameter("title"));
	String titlename = SystemEnv.getHtmlLabelNames(title, user.getLanguage());
	String needfav = "1";
	String needhelp = "";
	String isDialog = Util.null2String(request.getParameter("isdialog"));

	List<Integer> lsPromptLabel = new ArrayList<Integer>(); //提示信息
	if(importtype.equals("company")){
		lsPromptLabel.add(34275);
		lsPromptLabel.add(125452);
		lsPromptLabel.add(125466);
		lsPromptLabel.add(125467);
	}else if(importtype.equals("jobtitle")){
		lsPromptLabel.add(34275);
		lsPromptLabel.add(125452);
	}else if(importtype.equals("group")){
		lsPromptLabel.add(34275);
		lsPromptLabel.add(125452);
		lsPromptLabel.add(125462);
		lsPromptLabel.add(125463);
		lsPromptLabel.add(125464);
		lsPromptLabel.add(125465);
	}else if(importtype.equals("resourcedetial")){
		lsPromptLabel.add(34275);
		lsPromptLabel.add(125452);
		lsPromptLabel.add(125453);
		lsPromptLabel.add(125454);
		lsPromptLabel.add(125455);
		lsPromptLabel.add(125456);
		lsPromptLabel.add(125457);
		lsPromptLabel.add(125458);
		lsPromptLabel.add(125459);
		lsPromptLabel.add(125902);
		lsPromptLabel.add(125461);
	}else if(importtype.equals("city")){
		lsPromptLabel.add(34275);
		lsPromptLabel.add(125452);
	}else if(importtype.equals("location")){
		lsPromptLabel.add(34275);
		lsPromptLabel.add(125452);
		lsPromptLabel.add(125468);
		lsPromptLabel.add(125469);
		lsPromptLabel.add(125470);
	}else if(importtype.equals("special")){
		lsPromptLabel.add(34275);
		lsPromptLabel.add(125452);
	}else if(importtype.equals("area")){
		lsPromptLabel.add(126163);
		lsPromptLabel.add(126164);
		lsPromptLabel.add(126165);
		lsPromptLabel.add(126166);
	}
%>
<BODY>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:dosubmit(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(24644,user.getLanguage())+",javascript:openHistoryLog(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
	<td></td>
	<td class="rightSearchSpan" style="text-align:right;">
		<input type=button class="e8_btn_top" onClick="dosubmit(this)" value="<%=SystemEnv.getHtmlLabelName(615, user.getLanguage())%>">
		<input type=button class="e8_btn_top" onClick="openHistoryLog()" value="<%=SystemEnv.getHtmlLabelName(24644, user.getLanguage())%>">
		<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
	</td>
	</tr>
</table>
<FORM id=frmMain name=frmMain action="HrmBasicDataImportProcess.jsp" method=post enctype="multipart/form-data" target="subframe">
<input id="importtype" name="importtype" type="hidden" value="<%=importtype %>">
<input id="creater" name="creater" type="hidden" value="<%=user.getUID() %>">
<input id="userlanguage" name="userlanguage" type="hidden" value="<%=user.getLanguage() %>">
	<wea:layout type="2col">
		<wea:group context="<%=SystemEnv.getHtmlLabelName(1361, user.getLanguage())%>" attributes="{'groupOperDisplay':'none','itemAreaDisplay':'block','groupSHBtnDisplay':'none'}">
			<%if(importtype.equals("group")){ %>
			<wea:item><%=SystemEnv.getHtmlLabelName(24638, user.getLanguage())%></wea:item>
      <wea:item>
        <select name="keyField" id="keyField" style="width: 80px;" onchange="changeTempletFile()">
           <option value="workcode"><%=SystemEnv.getHtmlLabelName(714, user.getLanguage())%></option>
           <%if(HrmUserVarify.checkUserRight("CustomGroup:Edit",user)){ %>
           <option value="loginid"><%=SystemEnv.getHtmlLabelName(412, user.getLanguage())%></option>
           <%} %>
        </select>
      </wea:item>
      <%} %>
      <wea:item><%=SystemEnv.getHtmlLabelName(19971, user.getLanguage())%></wea:item>
      <wea:item><a href='templet/<%=importtype %>.xls' class="templetfile" style="color: #30b5ff"><%=SystemEnv.getHtmlLabelName(28576, user.getLanguage())%></a></wea:item>
      <wea:item><%=SystemEnv.getHtmlLabelName(16699, user.getLanguage())%></wea:item>
      <wea:item>
        <input class=inputstyle style="width: 360px" type="file" name="excelfile" accept="application/vnd.ms-excel" onchange='checkinput("excelfile","excelfilespan");this.value=trim(this.value)'><SPAN id=excelfilespan>
         <IMG src="/images/BacoError_wev8.gif" align=absMiddle>
        </SPAN>
      </wea:item>
		</wea:group>
	</wea:layout> 
	
	<wea:layout>
		<wea:group context="<%=SystemEnv.getHtmlLabelName(18596,user.getLanguage())+SystemEnv.getHtmlLabelName(85,user.getLanguage())%>" attributes="{'samePair':'RemarkInfo','groupOperDisplay':'none','itemAreaDisplay':'block','groupSHBtnDisplay':'none'}">
		  <wea:item attributes="{'colspan':'2'}">
			<%for(int i=0;i<lsPromptLabel.size();i++){ %>
			<span style="display:block;width: 780px;line-height:25px;"><%=(i+1)+"、"+SystemEnv.getHtmlLabelName(lsPromptLabel.get(i), user.getLanguage())%>
				<%if(i==0){ %>
				<a href='templet/<%=importtype %>.xls' class="templetfile" style="color: #30b5ff"><%=SystemEnv.getHtmlLabelName(28576, user.getLanguage()) %></a>
				<%} %>
			</span>
			<%} %>
		</wea:item>
		</wea:group>
	</wea:layout>	
	<!-- 隐藏提交iframe -->
	<iframe name='subframe' id="subframe" style='display:none'></iframe>
  <%if("1".equals(isDialog)){ %>
  </div>
  <div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout type="2col">
	    <wea:group context="">
	    	<wea:item type="toolbar">
	    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.close();">
	    	</wea:item>
	   	</wea:group>
	  </wea:layout>
	</div>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
<%} %>
</form>
</div>
<script language=javascript>
function check_form(frm)
{
	if(document.frmMain.excelfile.value==""){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>！");
		return false;
	}
	return true;
}

function dosubmit(obj) {
  if(check_form(document.frmMain)) {
  	var dialog = new window.top.Dialog();
		dialog.currentWindow = window;
		dialog.Title = "<%=SystemEnv.getHtmlLabelNames(title, user.getLanguage())%>";
		dialog.Width = 650;
		dialog.Height = 400;
		dialog.Drag = true;
		dialog.URL = "/hrm/HrmDialogTab.jsp?_fromURL=HrmBasicDataImportLog&importtype="+jQuery("#importtype").val();
		dialog.show();
  	document.frmMain.submit() ; 
  }
}

/*打开历史导入记录*/
function openHistoryLog(){
	var dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(24644, user.getLanguage())%>";
	dialog.Width = 650;
	dialog.Height = 400;
	dialog.Drag = true;
	dialog.URL = "/hrm/HrmDialogTab.jsp?_fromURL=HrmBasicDataImportHistoryLog&importtype="+jQuery("#importtype").val();
	dialog.show();
}

function changeTempletFile(){
	var keyField = "";
	if(jQuery("#importtype").val()=="group")keyField = jQuery("#keyField").val();
	jQuery(".templetfile").attr("href","templet/"+jQuery("#importtype").val()+keyField+".xls");
}

function afterreload(){
	var parentWin = parent.parent.getParentWindow(parent);
	try{
		parentWin.reloadTable();
	}catch(e){
	}
}

jQuery(document).ready(function(){
	changeTempletFile();
})
</script>
</BODY>
</HTML>