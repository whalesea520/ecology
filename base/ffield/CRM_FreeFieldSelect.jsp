
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
int index=Util.getIntValue(request.getParameter("index"));
String titlename = SystemEnv.getHtmlLabelName(32714,user.getLanguage());
%>
<HTML>
<HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link rel="stylesheet" href="/wui/theme/ecology8/weaveredittable/css/WeaverEditTable_wev8.css">
<link href="/js/checkbox/jquery.tzCheckbox_wev8.css" type=text/css rel=stylesheet>
<link href="/js/ecology8/jNice/jNice/jNice_wev8.css" type=text/css rel=stylesheet>
<link href="/js/ecology8/selectbox/css/jquery.selectbox_wev8.css" type=text/css rel=stylesheet>
<script language=javascript src="/js/ecology8/selectbox/js/jquery.selectbox-0.2_wev8.js"></script>
<link href="/js/checkbox/jquery.tzCheckbox_wev8.css" type=text/css rel=stylesheet>
<script language=javascript src="/js/checkbox/jquery.tzRadio_wev8.js"></script>
<link rel="stylesheet" href="/wui/theme/ecology8/skins/default/wui_wev8.css">
<script  src="/wui/theme/ecology8/weaveredittable/js/WeaverEditTable_wev8.js"></script>
<script language=javascript src="/js/checkbox/jquery.tzRadio_wev8.js"></script>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
</HEAD>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:jsOK();,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="customer"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(32714,user.getLanguage()) %>"/>
</jsp:include>

<div class="zDialog_div_content" style="height: 198px;">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%>" class="e8_btn_top" onclick="jsOK();">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<form name="myForm" action="" method="post">
<div id="customField" class="groupmain" style="width:100%"></div>
</form>
</div>

<script>
var dialog = parent.getDialog(window); 
var parentWin = parent.getParentWindow(window);
	
var group=null;
function jsOK(){
	var resultData = group.getTableJson();
	parentWin.setSelectOption(resultData);
	parentWin.closeDialog();	
}

var items=[
	{width:"60%",colname:"<%=SystemEnv.getHtmlLabelName(32715,user.getLanguage())%>",
	itemhtml:"<input name=selectitemid type=hidden value=-1><input class=inputstyle type=text style='width:80%' name='selectitemvalue'>"}
];

jQuery(function(){
	
	var select_options = parent.getParentWindow(window).jQuery("select[name=selectOption_<%=index%>").find("option");
	var ajaxData = "";
	if(select_options.length > 0){
		ajaxData = "[";
		for(var i = 0 ; i <select_options.length ;i++){
			if(i >= 1){ 
				ajaxData += ",";
			}
			ajaxData += "[{name:\"selectitemid\",value:\""+jQuery(select_options[i]).attr("value")+"\",iseditable:true,type:\"input\"},";
			ajaxData += "{name:\"selectitemvalue\",value:\""+jQuery(select_options[i]).html()+"\",iseditable:true,type:\"input\"}]";
			
		}
		ajaxData +="]";
	}
	if(ajaxData != ""){
		ajaxData = eval('('+ajaxData+')');
	}
	
	var option= {
			  openindex:false,
              basictitle:"<%=SystemEnv.getHtmlLabelName(32716,user.getLanguage())%>",
              toolbarshow:true,
              colItems:items,
              usesimpledata: true,
              addrowtitle:true,
              copyrowtitle: false,
              deleterowstitle: true,
              initdatas: ajaxData,
              addrowCallBack:function() {
				rownum=this.count;
              },
              copyrowsCallBack:function() {
				rownum=this.count;
              },
              configCheckBox:true,
              checkBoxItem:{"itemhtml":'<input name="check_node" class="groupselectbox" type="checkbox" >',width:"5%"}
            };
		group=new WeaverEditTable(option);
        jQuery("#customField").append(group.getContainer());

});

</script>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout>
		<wea:group context="" attributes="{groupDisplay:none}">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="parentWin.closeDialog();">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
</BODY>
</HTML>