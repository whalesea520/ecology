<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%
/*权限判断,管理员和有会议自定义卡片权限的人*/
if(!HrmUserVarify.checkUserRight("Meeting:fieldDefined", user))
{
	response.sendRedirect("/notice/noright.jsp");
	return;
} 
/*权限判断结束*/

int item_id=Util.getIntValue(request.getParameter("item_id"));
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
	var resultData = group.getTableJson();
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
var items=[{width:"80%",colname:"<%=SystemEnv.getHtmlLabelName(32715,user.getLanguage())%>",itemhtml:"<input name=selectitemid type=hidden value=-1><input class=inputstyle type=text style='width:98%' name='selectitemvalue'>"}];

<%	//初始化值
	int rownum = 0;
	rs.executeSql("select * from meeting_selectitem where isdel=0 and fieldid=" + (""+item_id) + " order by listorder");
	StringBuffer ajaxData = new StringBuffer();
	ajaxData.append("[");
	while(rs.next()){
  		String selectitemid = rs.getString("selectvalue");
		String selectitemvalue = "".equals(rs.getString("selectlabel"))?rs.getString("selectname"):SystemEnv.getHtmlLabelName(Util.getIntValue(rs.getString("selectlabel")),7);
		rownum++;
		if(rownum>1)ajaxData.append(",");
		ajaxData.append("[{name:\"selectitemid\",value:\""+selectitemid+"\",iseditable:true,type:\"input\"},");
		ajaxData.append("{name:\"selectitemvalue\",value:\""+selectitemvalue+"\",iseditable:true,type:\"input\"}]");
  }
  ajaxData.append("]");
%>
var ajaxdata=<%=ajaxData.toString()%>;
var option= {
 		  openindex:false,
          basictitle:"<%=SystemEnv.getHtmlLabelName(32716,user.getLanguage())%>",
          toolbarshow:true,
          colItems:items,
          usesimpledata: true,
          initdatas: ajaxdata,
          addrowCallBack:function() {
				rownum=this.count;
          },
          copyrowsCallBack:function() {
				rownum=this.count;
          },
          addrowtitle:"<%=SystemEnv.getHtmlLabelName(21690,user.getLanguage()) %>",
          deleterowstitle:"<%=SystemEnv.getHtmlLabelName(16182,user.getLanguage()) %>",
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