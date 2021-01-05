<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.templetecheck.PropertiesUtil" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.templetecheck.*"%>
<%@ page import="org.dom4j.*"%>
<%@ page import="org.json.*"%>
<%@ page import="java.util.regex.*"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<link rel="stylesheet" href="/wui/theme/ecology8/weaveredittable/css/WeaverEditTable_wev8.css">
<script  src="/wui/theme/ecology8/weaveredittable/js/WeaverEditTable_wev8.js"></script>
<%
//判断只有管理员才有权限
int userid = user.getUID();
if(userid!=1) {
	response.sendRedirect("/notice/noright.jsp");
  return;
}
String attrname = Util.null2String(request.getParameter("attrname"));//属性名
String attrval = Util.null2String(request.getParameter("attrval"));//属性值
String attrdes = Util.null2String(request.getParameter("attrdes"));//注释
String path = Util.null2String(request.getParameter("fpath"));
String operate = Util.null2String(request.getParameter("operate"));

//编辑
if("1".equals(operate)) {
	PropertiesUtil prop = new PropertiesUtil();
	prop.load(path);
	attrval = prop.getPropertyVal(attrname);
	attrdes = prop.getPropertyNotes(attrname);
}
%>
<HTML>
<BODY style="overflow:auto;">
<input type="hidden" name="path" value="<%=path%>" id="path"></input>
<wea:layout>
	<wea:group context="属性">
		<wea:item>属性名</wea:item>
		<wea:item>
			<wea:required id="attrnameimage" required="true" value="<%=attrname %>">
				<input class=InputStyle name="attrname" id="attrname" value="<%=attrname%>" onchange='checkinput("attrname","attrnameimage")' />
			</wea:required>
		</wea:item>
		<wea:item>属性值</wea:item>
		<wea:item>
			<input class=InputStyle name="attrval" id="attrval" value="<%=attrval%>"/>
		</wea:item>
		<wea:item>说明（注释）</wea:item>
		<wea:item>
			<textarea class=InputStyle rows=5 name="attrdes" id="attrdes" style="width:60%;"><%=attrdes%></textarea>
			<br>
			注释请以“#”符号开头；如：#数据库用户名。多行注释每一行都以“#”开头。
		</wea:item>
	</wea:group>
</wea:layout>

	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout type="2col" needImportDefaultJsAndCss="false">
			<wea:group context="">
				<wea:item type="toolbar">
					<input type="button" class=zd_btn_submit accessKey=O  id=btnok onclick="onSave()" value="确定">
					<input type="button" class=zd_btn_submit class=btnReset  id=btncancel  onclick="btncancel_onclick();" value="取消">
				</wea:item>
			</wea:group>
		</wea:layout>
	</div>
</BODY>
<script type="text/javascript"> 

jQuery(document).ready(function(){
	jQuery("div.tablecontainer").css("padding-left","0px!important");
	
	//编辑的话 属性名不可编辑
	if("1" == "<%=operate%>") {
		$("#attrname").attr("disabled","disabled");
	}
});
var parentWin = null;
var dialog = null;
try{
	parentWin = parent.getParentWindow(window);
	dialog = parent.parent.getDialog(window);
}catch(e){}

function btncancel_onclick() {
	if(dialog){
		dialog.close();
	}else{
  	    window.parent.close();
	}  
}

function onSave() {
	var attrname = $("#attrname").val();
	var attrval = $("#attrval").val();
	var attrdes = $("#attrdes").val();
	var operate = "<%=operate%>";
	var fpath = $("#path").val();
	//alert(attrdes);
	//console.log(attrdes);
	attrdes = attrdes.trim();
	var attrarray = attrdes.split("\n");
	for(var i = 0; i < attrarray.length; i++) {
		var tempattr = attrarray[i];
		var index = tempattr.indexOf("#");
		if(index < 0 && tempattr != "") {
			top.Dialog.alert("注释请以“#”符号开头；如：#数据库用户名。多行注释每一行都以“#”开头。");
			return;
		} else {
			continue;
		}
	}
	$.ajax({
		url:"/templetecheck/EditPropertiesOperation.jsp",
		type:"post",
		dataType:"json",
		data:{
			"attrname":attrname,
			"attrvalue":attrval,
			"attrinfo":attrdes,
			"operate":operate,
			"filepath":fpath
		},
		success:function(data) {
			var res = data.status;
			if(res=="ok") {
				parentWin._table.reLoad();//必须先刷新父页面列表，否则IE下无法刷新
				if(dialog){
					dialog.closeByHand();
				}else{
					parentWin.closeDialog();
				} 
				
			} else {
				var message = "";
				if(operate=="0") {
					message = "新增属性失败";
				} else if(operate=="1") {
					message = "编辑属性失败";
				}
				top.Dialog.alert(message);
				return;
			}
		}
	});
}


</script>
<style>
.tablecontainer{
	padding-left:0px!important
}
</style>
</HTML>