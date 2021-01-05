<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="org.json.JSONObject"%>
<%@ page import="weaver.conn.RecordSet"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<% 
String kx = Util.null2String(request.getParameter("kx"));
String bh = Util.null2String(request.getParameter("bh"));
String kxName = Util.null2String(request.getParameter("title0")).trim();
kxName = java.net.URLDecoder.decode(kxName,"UTF-8");
String kxName1 = Util.null2String(request.getParameter("title1"));
kxName1 = java.net.URLDecoder.decode(kxName1,"UTF-8");
String pbid = Util.null2String(request.getParameter("pbid"));
String sxzq = Util.null2String(request.getParameter("sxzq"));
String mqyp = "";
String kxtype = "";
RecordSet RecordSet = new RecordSet();
RecordSet.execute("select * from uf_xxcb_kxSet where id="+kx);
if(RecordSet.next()){
	if("".equals(kxName)){
		kxName = Util.null2String(RecordSet.getString("name"));
	}	
	kxtype = Util.null2String(RecordSet.getString("kxtype"));
	mqyp = Util.null2String(RecordSet.getString("mqyp"));
}
String sqlWhere = ("1".equals(kxtype)||"2".equals(kxtype))?("sxzq='"+sxzq+"' and "):"";
RecordSet.execute("select distinct periods from uf_xxcb_pbInfo where "+sqlWhere+" journal="+kx+" order by periods");
String yyqs = "";
while(RecordSet.next()){
	String periods = Util.null2String(RecordSet.getString("periods"));
	yyqs += ","+periods;
}
yyqs = "".equals(yyqs)?"":yyqs.substring(1);
String curPeriods = "";
if(!"".equals(pbid)){
	RecordSet.execute("select * from uf_xxcb_pbInfo where id='"+pbid+"'");
	if(RecordSet.next()){
		curPeriods = Util.null2String(RecordSet.getString("periods"));
	}
}
%>
<HTML><HEAD>
<style>
.titleInput{
	background: #f8f8f8;
    border: none !important;
    width: 30% !important;
    padding-bottom: 3px;
}
</style>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<!--以下是显示定制组件所需的js -->
<script language=javascript src="/workplan/calendar/src/Plugins/jquery.form_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
<script type="text/javascript" src="/js/dragBox/ajaxmanager_wev8.js"></script>
<script type="text/javascript" src="/js/dragBox/rightspluing_wev8.js"></script>
<script type="text/javascript" src="/js/dragBox/showcol_wev8.js"></script>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<LINK href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type=text/css rel=STYLESHEET>
</HEAD>
<body scroll="no">
<div class="e8_box demo2">
	<div class="e8_boxhead">
		<div class="div_e8_xtree" id="div_e8_xtree"></div>
        <div class="e8_tablogo" id="e8_tablogo"></div>
		<div class="e8_ultab">
			<div class="e8_navtab" id="e8_navtab">
				<span id="objName">调整期数</span>
			</div>
			<div>
			    <div id="rightBox" class="e8_rightBox">
			    </div>
			</div>
		</div>
	</div>
	    <div class="tab_box">
        <div>
        		<!-- <IFRAME name=frame1 id=frame1 width="100%" onload="update();" height="160px" frameborder=no scrolling=no></IFRAME>
         -->
         <%
         String billid = Util.null2String(request.getParameter("billid"));
         %>
           	<div class="zDialog_div_content" style="overflow-x:hidden;">
           	<form action="/formmode/apps/appointment/updateStatusOperation.jsp" name="frmmain" id="frmmain" >
           	<input type="hidden" name="billid" value="<%=billid%>" id="billid">
           	<wea:layout type="2col">
           		<wea:group context="">
				<wea:item>已经存在的编号</wea:item>
				<wea:item>
				<%
				RecordSet rs = new RecordSet();
				rs.executeSql("select * from uf_reservation_reco where id="+billid);
				String status = "";
				%>
				<textarea class="Inputstyle" readonly="readonly" temptype="1" viewtype="0" id="usedPeriods" name="usedPeriods" rows="4" onchange="" cols="40" style="width:80%;word-break:break-all;word-wrap:break-word"><%=yyqs %></textarea>
				</wea:item>
				<wea:item >当前编号</wea:item>
				<wea:item >
					<input fieldtype="1" datatype="text" viewtype="0" type="text" class="Inputstyle titleInput" temptitle="标题" id="title0" name="title0" value="<%=kxName %>">	
					<span id="periodsSpan">&nbsp;&nbsp;&nbsp;第<%=bh %>期</span>
					<input fieldtype="1" datatype="text" viewtype="0" type="text" class="Inputstyle titleInput" temptitle="标题" id="title1" name="title1" value="<%=kxName1 %>">
				</wea:item>
				<wea:item >调整期号为</wea:item>
				<wea:item >
					<input fieldtype="1" datatype="text" viewtype="0" type="text" class="Inputstyle" temptitle="期数" id="periods" name="periods" style="width:90%;" onkeyup="value=value.replace(/[^\d]/g,'')" value="">
				</wea:item>
				</wea:group>
			</wea:layout>
			</form>
			</div>
			<div id="zDialog_div_bottom" class="zDialog_div_bottom" style="text-align: center;">
				<wea:layout needImportDefaultJsAndCss="false">
						<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
							<wea:item type="toolbar">
								<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" id="zd_btn_submit" class="zd_btn_submit" onclick="javascript:changep();"/>
								<input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="parent.parent.getDialog(parent).close()">
				    </wea:item>
						</wea:group>
					</wea:layout>
			</div>
	    </div>
	</div>
</body>
</HTML>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<script type="text/javascript">
function changep(){
	<%if("0".equals(mqyp)){%>
	var periods = jQuery("#periods").val();
	var curPeriods = "<%=curPeriods%>";
	if(",<%=yyqs%>,".indexOf(","+periods+",")>-1 && periods!="" && periods != curPeriods){
		window.top.Dialog.alert("不能选择已有期数");
	}else{
		var periods = jQuery("#periods").val()?jQuery("#periods").val():"<%=bh%>";
		var dialog = parent.parent.getDialog(parent);
		dialog.callbackfun({periods:periods,titlepre:jQuery("#title0").val(),titleaft:jQuery("#title1").val()});
		dialog.close();
	}
	<%}else{%>
		var periods = jQuery("#periods").val()?jQuery("#periods").val():"<%=bh%>";
		var dialog = parent.parent.getDialog(parent);
		dialog.callbackfun({periods:periods,titlepre:jQuery("#title0").val(),titleaft:jQuery("#title1").val()});
		dialog.close();
	<%}%>
}
</script>