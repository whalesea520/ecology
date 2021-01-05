<%@ page language="java" contentType="text/html; charset=UTF-8"%>

<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.templetecheck.*"%>
<%@ page import="org.dom4j.*"%>
<%@ page import="org.json.*"%>
<%@ page import="java.util.regex.*"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<LINK href="/css/Weaver_wev8.css" type="text/css" rel=STYLESHEET>
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

String nodename = Util.null2String(request.getParameter("nodename"));
String xpath = Util.null2String(request.getParameter("xpath"));
String path = Util.null2String(request.getParameter("fpath"));
String isedit = Util.null2String(request.getParameter("isedit"));
String nodecontent ="";//节点内容
String tempajaxdata= "";//节点属性值

XMLUtil xmlutil = new XMLUtil(path);
Element element = xmlutil.getNodeByXpath(xpath);
String operate = "";
String nodenamedisabled = "";
if("1".equals(isedit)) {//编辑
	operate = "edit";
	nodenamedisabled = " disabled = 'disabled' ";
	nodename = element.getName();
	nodecontent = element.asXML();
	//nodecontent.replaceAll("");
	

	//System.out.println("nodecontent:"+nodecontent);
	//先把该元素标签给替换掉  只获得标签的内容
	String match1 = "(?i)(<"+nodename+".*?>)";
	Pattern p = Pattern.compile(match1);
	Matcher m = p.matcher(nodecontent);
	if(m.find()) {
		nodecontent = m.replaceFirst("");//只替换第一个
	}
	String match2 = "(?i)(</"+nodename+">)";
	Pattern p2 = Pattern.compile(match2);
	Matcher m2 = p2.matcher(nodecontent);
	if(m2.find()) {
		nodecontent = m2.replaceFirst("");//只替换第一个
	}
	nodecontent = nodecontent.replaceAll("<p>","");
	nodecontent = nodecontent.replaceAll("</p>","");
	nodecontent = nodecontent.replaceAll("<br>","\n");
	nodecontent = nodecontent.replaceAll("<","&lt;");
	nodecontent = nodecontent.replaceAll(">","&gt;");

	//属性  数据
	StringBuffer ajaxdata = new StringBuffer();
	JSONObject attrobject  = xmlutil.getAttrsJson(element);
	Iterator ite = attrobject.keys();
	while(ite.hasNext()) {
		String tempkey = (String)ite.next();
		String value = (String)attrobject.get(tempkey);
		ajaxdata.append("[");
		ajaxdata.append("{name:'attr',value:'"+tempkey+"',iseditable:true,type:'input'},");
		ajaxdata.append("{name:'attrval',value:'"+value+"',iseditable:true,type:'input'},");
		ajaxdata.append("],");
	}


	tempajaxdata = ajaxdata.toString();
	if(!"".equals(tempajaxdata))
	{
		tempajaxdata = tempajaxdata.substring(0,(tempajaxdata.length()-1));
	}
	tempajaxdata = "["+tempajaxdata+"]";
} else {//新增子节点
	operate = "add";
	nodename = "";
}



%>
<HTML>
<script type="text/javascript">
var items=[  
           {width:"40%",colname:"属性名",itemhtml:"<INPUT class='Inputstyle' type='text' name='attr'  value='' >"},
           {width:"60%",colname:"属性值",itemhtml:"<INPUT class='Inputstyle' type='text' name='attrval' style='width:100%!important' value='' >"}];

var option= {
		   navcolor:"#003399",
		   basictitle:"",
		   toolbarshow:true,
		   colItems:items,
		   addrowtitle:"添加",
		   deleterowstitle:"删除",
		   usesimpledata:true,
		   openindex:false,
		   addrowCallBack:function() {
		   },
		   configCheckBox:true,
		   checkBoxItem:{"itemhtml":"<INPUT class='groupselectbox' type='checkbox' name='paramid'><INPUT type='hidden' name='paramids' value='-1'>","width":"6%"},
		   initdatas:eval("<%=tempajaxdata%>")
		};
		
var group=null;
jQuery(document).ready(function(){
	//alert(jQuery("#encrypttype").val());
	group=new WeaverEditTable(option);
    jQuery("#attrsetting").append(group.getContainer());
    var params=group.getTableSeriaData();
    
    $("#tableitem").removeClass("fieldName");
    
});

</script>
<BODY style="overflow:auto;">
<wea:layout>
	<wea:group context="标签名">
		<wea:item>标签名称</wea:item>
		<wea:item>
			<wea:required id="nodenameimage" required="true" value="<%=nodename %>">
				<input class=InputStyle name="nodename" id="nodename" value="<%=nodename%>" <%=nodenamedisabled%> onchange='checkinput("nodename","nodenameimage")'/>
			</wea:required>
		</wea:item>
	</wea:group>
	<wea:group context="节点属性值">
	<wea:item attributes="{colspan:'full',id:'tableitem'}">
			<div width="100%" id="attrsetting">
			</div>
	</wea:item>

	</wea:group>
	<wea:group context="节点内容">
	<wea:item>
		节点内容
	</wea:item>
	<wea:item>
		<textarea class=InputStyle rows=10 name="nodecontent" id="nodecontent" style="width:90%;"><%=nodecontent%></textarea>
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
});
var parentWin = null;
var dialog = null;
try{
	parentWin = parent.getParentWindow(window);
	dialog = parent.parent.getDialog(window);
}catch(e){}


function onSave() {
	var nodename = $("#nodename").val();//节点名称
	var nodecontent = $("#nodecontent").val();//节点内容
	//节点属性值

	var attrsobj = $("input[name='attr']");
	var attrvalsobj = $("input[name='attrval']");
	var attrs = new Array(attrsobj.length);
	var attrvals = new Array(attrsobj.length);
	for(var i = 0; i < attrsobj.length; i++) {
		var v1 = attrvalsobj[i].value;
		var attr1 = attrsobj[i].value;
		if(v1!=""&&attr1=="") {
			top.Dialog.alert("属性名称为必填项！");
			return;
		}
	}
	
	for(var i = 0; i < attrsobj.length; i++) {
		attrs[i] = attrsobj[i].value;
		attrvals[i] = attrvalsobj[i].value;
	}
	
	//保存数据
	$.ajax({
		url : "/templetecheck/EditXmlOperation.jsp?attrs="+attrs+"&attrvals="+attrvals,
		data :  {
			fpath : "<%=path%>",
			xpath : "<%=xpath%>",
			operate : "<%=operate%>",
			nodename : nodename,
			nodecontent : nodecontent,
		},
		type : "post",
		dateType : "json",
		success : function(res){
			var data = eval("("+res+")");
			if(data.status=="ok") {
				parentWin.showxmltree();
				btncancel_onclick();
		  	   
				return;
			} else {
				top.Dialog.alert("添加子节点失败！");
				return;
			}
		}
	});
	
}

function btncancel_onclick() {
	if(dialog){
		dialog.close();
	}else{
  	    window.parent.close();
	}  
}
</script>
<style>
.tablecontainer{
	padding-left:0px!important
}
</style>
</HTML>