
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@page import="weaver.general.*"%>
<HTML><HEAD>
<title>设置</title>
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

StringBuffer ajaxdata = new StringBuffer();


OrderProperties prop = new OrderProperties();
String propfile = GCONST.getRootPath()+"WEB-INF"+File.separator+"prop"+File.separator+"SolveKBQuestion.properties";
List<String> classes = new ArrayList<String>();

prop.load(propfile);
String execStatus = Util.null2String(prop.getProperty("execStatus"));//获取执行状态

List<String> keys = prop.getKeys();
int no = 1;
for(int i= 0; i < keys.size(); i++) {
	String key = keys.get(i);
	String classname  = Util.null2String(prop.getProperty(key));
	if("".equals(classname)||"execStatus".equals(key)) {
		continue;
	} else {
	    ajaxdata.append("[");
		ajaxdata.append("{name:'classname',value:'"+classname+"',iseditable:true,type:'input'},");
	    ajaxdata.append("],");
	}
}

String tempajaxdata = ajaxdata.toString();
if(!"".equals(tempajaxdata))
{
	tempajaxdata = tempajaxdata.substring(0,(tempajaxdata.length()-1));
}
tempajaxdata = "["+tempajaxdata+"]";

String note = "类中必须包含executeSql(),executeOperation()两个方法";
%>
<script type="text/javascript">
var group = null;
jQuery(document).ready(function(){
	
	//alert(jQuery("#encrypttype").val());
	group=new WeaverEditTable(option);
    jQuery("#tabs").append(group.getContainer());
    var params=group.getTableSeriaData();
    jQuery(".optionhead").hide();
   
});

var items=[
           {width:"80%",colname:"执行类全路径",itemhtml:"<input class='inputstyle' style='width:80%' name='classname'></input><SPAN style='CURSOR: hand' id=remind><IMG id=ext-gen124  title='<%=note%>' align=absMiddle src='/images/remind_wev8.png'>"},
          ];
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
		   checkBoxItem:{"itemhtml":"<INPUT class='groupselectbox' type='checkbox' name='paramid'><INPUT type='hidden' name='paramids' value='-1'>","width":"2%"},
		   initdatas:eval("<%=tempajaxdata%>")
};
 
function addRow(v){
	group.addRow(null);

}
function removeRow(v){
	group.deleteRows();
}

</script>
<style type="text/css">
.tablecontainer{
	padding-left:0px;
}
</style>
</head>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";
String sourceparams = "";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<jsp:include page="/systeminfo/commonTabHead.jsp">
			<jsp:param name="mouldID" value="question" />
			<jsp:param name="navName" value="执行类设置" />
</jsp:include>
<%

RCMenu += "{保存,javascript:save(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<form action="editoperation.jsp" method="post" name="form1" id="form1" >

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="保存" class="e8_btn_top" onclick="save()"/>
		</td>
	</tr>
</table>

<wea:layout>
<%
String tabname = "执行类设置";
%>
<wea:group context="执行状态">
	<wea:item>执行</wea:item>
	<wea:item>
		 <input class="inputstyle" type=checkbox tzCheckbox='true' id="execStatuscheck" name="execStatuscheck" value="1" <%if(!execStatus.equals("1"))out.println("checked"); %>>
		 <input class="inputstyle" id="execStatus" name="execStatus" value="1" type="hidden"/>
	</wea:item>

	</wea:group>
<wea:group context="<%=tabname%>"  attributes="{'groupOperDisplay':'none','itemAreaDisplay':'block',id='tabsgroup'}">
	  <wea:item type="groupHead">
		  <div style='float:right;'>
			<input id='addbutton' type="button" title="添加(ALT+A)" onClick="addRow('tabs')" ACCESSKEY="A" class="addbtn"/>
			<input type="button" title="删除(ALT+G)" onClick="removeRow('tabs')" ACCESSKEY="G" class="delbtn"/>
		  </div>
	  </wea:item>
	  <wea:item attributes="{'colspan':'2','isTableList':'true'}">
	  	<div id="tabs">
		</div>
	  </wea:item>
</wea:group>
</wea:layout>
</form>
</BODY>
</HTML>
<script type="text/javascript">
//保存自定义规则
function save() {
	var cansubmit = true;
	var arr = Array();
	var i = 0;
	jQuery("#tabs input[name='classname']").each(function(){
		if($(this).val()==""){
			top.Dialog.alert("类名不能为空!");
			cansubmit = false;
			return;
		} else {
			//检查class
			var classname = $(this).val();
			$.ajax({
				url:"checkclass.jsp",
				async: false,
				data:{
					"classname":classname
				},
				type:"post",
				dataType:"json",
				success:function(data){
					var res = data.status;
					if(res == "no") {
						cansubmit = false;
						top.Dialog.alert(classname+"类不存在!");
						return;
					}
				}
			});
			
			//检查重复
			var val = $(this).val();
			if(arr.indexOf(val)>-1) {
				top.Dialog.alert("类名不能重复!");
				cansubmit = false;
				return;
			} else {
				arr[i] = $(this).val();
			}
			i++;
		}

	});
	
	if(cansubmit) {
		var execStatus = $("#execStatuscheck").attr("checked") == true ? "0":"1";
		$("#execStatus").val(execStatus);
		$("#form1").submit();
	}
}

function checkClass(classname) {
	$.ajax({
		url:"checkclass.jsp",
		data:{
			"classname":classname
		},
		type:"post",
		dataType:"json",
		success:function(data){
			var res = data.status;
			if(res == "no") {
				top.Dialog.alert(classname+"类不存在!");
				return "no";
			}
		}
	});
}

function delete2(){
	removeRow("tabs");
}

</script>