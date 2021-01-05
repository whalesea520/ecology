
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.docs.docs.CustomFieldManager,weaver.general.GCONST"%> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<%
int id=Util.getIntValue(request.getParameter("id"),0);
int item_id=Util.getIntValue(request.getParameter("item_id"));
String alloption=Util.null2String(request.getParameter("alloption")).trim();
if(!"".equals(alloption)){
	alloption = alloption.substring(1);
}
if(alloption.startsWith(",")){
	alloption = "";
}
String[] alloptionArr = Util.TokenizerString2(alloption, "|");
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
<script type="text/javascript">
var parentWin = parent.parent.getParentWindow(parent);
var dialog = parent.parent.getDialog(parent);	
var group=null;
function jsOK(){
	//var resultData = group.getTableJson();
	var resultData = [];
	 var  trs=jQuery("#customField").find(".grouptable  tbody  .contenttr");
	 trs.each(function(i,obj){
		   var con=jQuery(obj);
		   var data = {};
		   data.selectitemid = con.find("input[name='selectitemid']").val();
		   data.selectitemvalue = con.find("input[name='selectitemvalue']").val();
		   data.__multilangpre_selectitemvalue = con.find("input[name='__multilangpre_selectitemvalue']").val();
		   resultData[i] = data;
		  // console.log(data);
	 });
	parentWin.setSelectOption(resultData);
	parentWin.closeDialog();	
}
</script>
</HEAD>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:jsOK();,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<div class="zDialog_div_content">
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
<input name="item_id" type="hidden" value="<%=item_id %>">
<div id="customField" class="groupmain" style="width:100%"></div>
<script>
var items=[
{width:"60%",colname:"<%=SystemEnv.getHtmlLabelName(32715,user.getLanguage())%>",itemhtml:"<input name=selectitemid type=hidden value=-1><input class=inputstyle type=text style='width:98%' name='selectitemvalue'>"}];
<%
	int rownum = 0;
	StringBuffer ajaxData = new StringBuffer();
	ajaxData.append("[");
	for(int i=0;i<alloptionArr.length;i++){
		String[] optionArr = Util.TokenizerString2(alloptionArr[i], ",");
		String selectitemid = "";
		String selectitemvalue = "";
		if(optionArr!=null){
			if(optionArr.length>1){
				selectitemid = Util.null2String(optionArr[0]).trim();
				selectitemvalue = Util.null2String(optionArr[1]).trim();
			}else{
				selectitemid = Util.null2String(optionArr[0]).trim();
			}
		}
		rownum++;
		if(rownum>1)ajaxData.append(",");
		ajaxData.append("[{name:\"selectitemid\",value:\""+selectitemid+"\",iseditable:true,type:\"input\"},");
		ajaxData.append("{name:\"selectitemvalue\",value:\""+selectitemvalue+"\",iseditable:true,type:\"input\"}]");
	}
  ajaxData.append("]");
%>
var ajaxdata=<%=ajaxData.toString()%>;
var LANG_CONTENT_PREFIX = "<%=GCONST.LANG_CONTENT_PREFIX%>";
var LANG_CONTENT_SPLITTER1 = "<%=GCONST.LANG_CONTENT_SPLITTER1%>";
function __multiLangRand(){
 
  var text="";
  var possible="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
  for(var i=0;i<10;i++) text+=possible.charAt(Math.floor(Math.random()*possible.length));
  return text;
 
}
var option= {
							openindex:false,
              basictitle:"<%=SystemEnv.getHtmlLabelName(32716,user.getLanguage())%>",
              toolbarshow:true,
              colItems:items,
              usesimpledata: true,
              initdatas: ajaxdata,
              addrowCallBack:function(that,tr,entry) {
								var oriValue = null;
								for(var j=0;entry && j<entry.length;j++){
									if(entry[j].name=="selectitemvalue"){
										oriValue = entry[j].value;
									}	
								}
								if(oriValue && oriValue.indexOf(LANG_CONTENT_PREFIX)!=-1){
									//拆分数据
									var value =oriValue.substring(oriValue.indexOf("7 ")+2,oriValue.indexOf(LANG_CONTENT_SPLITTER1+"8 "));
									var rnd_lang_tag = __multiLangRand();
									var selectitemvalueinput = tr.find("input[name='selectitemvalue']");
									selectitemvalueinput.attr("rnd_lang_tag",rnd_lang_tag);
									selectitemvalueinput.val(value);
									selectitemvalueinput.after("<input type='hidden' name='__multilangpre_selectitemvalue' id='__multilangpre_selectitemvalue"+rnd_lang_tag+"' value='"+oriValue+"'></input>");

								}
								rownum=this.count;
              },
              copyrowsCallBack:function() {
								rownum=this.count;
              },
             	configCheckBox:true,
             	checkBoxItem:{"itemhtml":'<input name="check_node" class="groupselectbox" type="checkbox" >',width:"5%"}
            };
						group=new WeaverEditTable(option);
           $("#customField").append(group.getContainer());
       </script>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<table width="100%">
	    <tr><td style="text-align:center;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand();">
	    </td></tr>
	</table>
</div>
</form>
</BODY>
</HTML>