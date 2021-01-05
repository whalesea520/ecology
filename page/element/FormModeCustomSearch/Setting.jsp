<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%--以下为支持JBOSS应用服务器校验语法，作出如下改动，将<wea:layout>和<wea:group>标签头移入此页面保证标签有始有终--%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<%@ include file="/page/element/settingCommon_params.jsp"%>
<%@ include file="common.jsp"%>
<wea:layout type="2Col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>' attributes="{'class':\"e8_title e8_title_1\"}">
<%@ include file="/page/element/settingCommon_dom.jsp"%>

<%--以上，为支持JBOSS应用服务器校验语法，作出如下改动，将<wea:layout>和<wea:group>标签头移入此页面保证标签有始有终--%>

<%
String recordCount = (String)valueList.get(nameList.indexOf("recordCount"));
String linkMode = (String)valueList.get(nameList.indexOf("linkMode"));
// String reportId = (String)valueList.get(nameList.indexOf("reportId"));
// String fields = (String)valueList.get(nameList.indexOf("fields"));	
// String fieldsWidth = (String)valueList.get(nameList.indexOf("fieldsWidth"));

int isshowtitle = Util.getIntValue((String)valueList.get(nameList.indexOf("isshowtitle")),1);
String rolltype = Util.null2String(valueList.get(nameList.indexOf("rolltype")));

String searchid = Util.null2String(valueList.get(nameList.indexOf("searchid")));

String fieldId = "";
String fieldLabel = "";
HashMap hmFields = new HashMap();
String sqlBizListSetting = "";

%>

<html>
<head>
<title></title>
<link href="/formmode/css/formmode_wev8.css" type="text/css" rel="stylesheet" />
<link href="/mobilemode/css/mec/handler/Navigation_wev8.css" type="text/css" rel="stylesheet" />
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET> 
<script language=javascript src="/js/weaver_wev8.js"></script>
<script type="text/javascript" src="/formmode/js/FormmodeUtil_wev8.js"></script>
<script type="text/javascript" src="/formmode/js/jquery/jquery-1.8.3.min_wev8.js"></script>

</head>
<body>
<style>
	.weavertabs-content div{
		display:inline;
	}
</style>
<wea:item>
<%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(83023,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%>
</wea:item><!-- 标题是否显示 -->
<wea:item>
<input type="checkbox"  <%=isshowtitle==1?"checked":"" %> onclick="isshowtitlechange_<%=eid %>(this,'<%=eid %>')"  name="isshowtitle_<%=eid%>_checkbox"/>
<input type="hidden" value="<%=isshowtitle %>" name="isshowtitle_<%=eid%>" id="isshowtitle_<%=eid%>" />
</wea:item>
<wea:item><%=SystemEnv.getHtmlLabelName(24598,user.getLanguage())%></wea:item><!-- 滚动 -->
<wea:item>
<select id="rolltype_<%=eid%>" name="rolltype_<%=eid%>">
	<option value=""      <%=rolltype.equals("")?"selected":"" %> ><%=SystemEnv.getHtmlLabelName(127228,user.getLanguage())%></option><!-- 无 -->
	<option value="Left"  <%=rolltype.equals("Left")?"selected":"" %> ><%=SystemEnv.getHtmlLabelName(20282,user.getLanguage())%></option><!-- 向左 -->
	<option value="Right" <%=rolltype.equals("Right")?"selected":"" %> ><%=SystemEnv.getHtmlLabelName(20283,user.getLanguage())%></option><!-- 向右 -->
	<option value="Up"    <%=rolltype.equals("Up")?"selected":"" %> ><%=SystemEnv.getHtmlLabelName(20284,user.getLanguage())%></option><!-- 向上 -->
	<option value="Down"  <%=rolltype.equals("Down")?"selected":"" %> ><%=SystemEnv.getHtmlLabelName(20285,user.getLanguage())%></option><!-- 向下 -->
</select>
</wea:item>
<wea:item>
<%=SystemEnv.getHtmlLabelName(527,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(320,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15240,user.getLanguage())%>
</wea:item>
<wea:item>
<a href="javascript:addDetil_<%=eid%>()" style="color: #0088d8; "><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></a><!-- 添加 -->
<br/>
<input type="hidden" name="searchid" id="searchid" value="<%=searchid %>" />
<div id="searchdiv_<%=eid%>" style="display:inline">
	<%
		rs_common.executeSql("select * from formmodeelement where eid in("+eid+") order by disorder");
		while(rs_common.next()){
			String searchtitle = rs_common.getString("searchtitle");
			String id = rs_common.getString("id");
			%>
			<span id="searchid<%=id%>" style=""><%=searchtitle %>
			&nbsp;&nbsp;&nbsp;<a href="javascript:delDetil_<%=eid %>('<%=id%>')" style="color: #0088d8"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a>
			&nbsp;<a href="javascript:addDetil_<%=eid%>('<%=id%>')" style="color: #0088d8"><%=SystemEnv.getHtmlLabelName(68,user.getLanguage())%></a>
			</br></span>
			<%
		}
	 %>
</div>


</wea:item>
<wea:item>
<script type="text/javascript">
function isshowtitlechange_<%=eid %>(ele,eid){
	if(ele.checked){
		document.getElementById("isshowtitle_"+eid).value="1";
	}else{
		document.getElementById("isshowtitle_"+eid).value="0";
	}
}

function addDetil_<%=eid%>(id){
	showDailog('<%=eid%>','','','<%="/page/element/FormModeCustomSearch/SettingDetil.jsp?eid=" + eid %>'+'&id='+id,'<%=ebaseid %>');
}

function delDetil_<%=eid%>(id){
	if(confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>")){
		jQuery.ajax({
             type: "GET",
             url: "/page/element/FormModeCustomSearch/SettingDetilAjax.jsp?action=delete&id="+id,
             data: "",
             dataType: "text",
             success: function(data){
             	if(jQuery.trim(data)=='ok'){
             		jQuery("#searchid"+id).remove();
             	}
             }
         });
     }
}

function showDailog(eid,method,tabId,url,ebaseid){
	// 更换弹出窗口为zDialog
	var tab_dialog = new window.top.Dialog();
	tab_dialog.currentWindow = window;   //传入当前window
	tab_dialog.Width = 830;
	tab_dialog.Height = 500;
	tab_dialog.Modal = true;
	tab_dialog.Title = "<%=SystemEnv.getHtmlLabelName(19480,user.getLanguage()) %>"; 
	tab_dialog.URL = url+"&ebaseid="+ebaseid+"&method="+method;
	tab_dialog.show();
	
}
</script>
</wea:item>
	</wea:group>
</wea:layout>

</html>
