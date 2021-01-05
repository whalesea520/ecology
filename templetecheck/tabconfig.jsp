<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.Map.Entry" %>

<%@ page import="weaver.templetecheck.ConfigUtil" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<HTML><HEAD>
<title>文件检测--检测项配置</title>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/dragBox/parentShowcol_wev8.js"></script>
<link rel="stylesheet" href="/css/ecology8/request/requestView_wev8.css" type="text/css" />
<link rel="stylesheet" href="/wui/theme/ecology8/weaveredittable/css/WeaverEditTable_wev8.css">
<script  src="/wui/theme/ecology8/weaveredittable/js/WeaverEditTable_wev8.js"></script>
<link href="/js/checkbox/jquery.tzCheckbox_wev8.css" type=text/css rel=STYLESHEET>
<script type="text/javascript" src="/js/ecology8/jNice/jNice/jquery.jNice_wev8.js"></script>
<%
//判断只有管理员才有权限
int userid = user.getUID();
if(userid!=1) {
	response.sendRedirect("/notice/noright.jsp");
  return;
}

StringBuffer ajaxdata = new StringBuffer();

//文件检测下拉选项设置
String checklist = "";

ConfigUtil configUtil = new ConfigUtil();
LinkedHashMap<String,ArrayList<String>>  tabs = configUtil.getalltabs();
Iterator ite = tabs.entrySet().iterator();
String tishtml = "0";
String t_tabname = "";
checklist = checklist + "<li><span class='title'>检测流程模板</span></li>";
while(ite.hasNext()) {
	Map.Entry entry = (Entry)ite.next();
	String key  = (String)entry.getKey();
	ArrayList<String> value  = (ArrayList<String>)entry.getValue();
	String name = value.get(0);
	String ishtml  = value.get(1);
	
    ajaxdata.append("[");
    if(key.equals("checkwebxml")|| key.equals("checkaction") || key.equals("checkservice") || key.equals("checkhtml")|| key.equals("checkmobilemodehtml") || key.equals("checkmodehtml") || key.equals("searchcustompage")) {
    	 ajaxdata.append("{name:'id',value:'"+key+"',iseditable:false,type:'input'},");
    } else {
    	 ajaxdata.append("{name:'id',value:'"+key+"',iseditable:true,type:'input'},");
    }
   
    ajaxdata.append("{name:'tabname',value:'"+name+"',iseditable:true,type:'input'},");
	ajaxdata.append("{name:'ishtml',value:'"+ishtml+"',iseditable:true,type:'select'},");
    ajaxdata.append("],");
    
	if("0".equals(ishtml)) {
		t_tabname = "检测表单流程模板";
	} else if("1".equals(ishtml)) {
		t_tabname = "检测配置文件";
		continue;//检查配置项的内容  从文件检测中移除
	} else if("2".equals(ishtml)) {
		t_tabname = "检测web.xml";
	} else if("3".equals(ishtml)) {
		t_tabname = "其他";
	} else if("4".equals(ishtml)) {
		t_tabname = "检测移动引擎模板";
	} else if("5".equals(ishtml)) {
		t_tabname = "检测表单建模模板";
	} else if("6".equals(ishtml)) {
		t_tabname = "流程自定义页面查询";
	}
	
    //文件检测下拉选项设置
	if(tishtml.equals(ishtml)) {
		checklist = checklist + "<li><a href=\\\"javascript:checkfile('"+key+"','"+ishtml+"','"+name+"')\\\">"+name+"</a></li>";
	} else {
		checklist = checklist + "<li><span class='title'>"+t_tabname+":</span></li>"; 
		checklist = checklist + "<li><a href=\\\"javascript:checkfile('"+key+"','"+ishtml+"','"+name+"')\\\">"+name+"</a></li>";
	}
	tishtml = ishtml;
}
//添加check页面设置
checklist = checklist +"<li><span class='title'>检测项设置:</span></li>";
checklist= checklist+"<li><a href='javascript:checkconfig()'>文件检测项设置</a></li>";

String tempajaxdata = ajaxdata.toString();
if(!"".equals(tempajaxdata))
{
	tempajaxdata = tempajaxdata.substring(0,(tempajaxdata.length()-1));
}
tempajaxdata = "["+tempajaxdata+"]";

%>
<script type="text/javascript">
var group = null;
jQuery(document).ready(function(){
	
	//alert(jQuery("#encrypttype").val());
	group=new WeaverEditTable(option);
    jQuery("#tabs").append(group.getContainer());
    var params=group.getTableSeriaData();
    jQuery(".optionhead").hide();
    
    //设置文件检测 下拉选项
    $(parent.window.checklist).html("<%=checklist%>");
    //alert(eval("[[{name:'content',value:'qwe<>',iseditable:true,type:'textarea'},{name:'replacecontent',value:'1230000\"我们\\'',iseditable:true,type:'textarea'}]]"));
});

var items=[
           {width:"40%",colname:"标识",itemhtml:"<input class='inputstyle' style='width:98%' name='id'></input>"},
           {width:"40%",colname:"标签页名称",itemhtml:"<input class='inputstyle' style='width:98%' name='tabname'></input>"},
           {width:"20%",colname:"检测类型",itemhtml:"<select class='inputstyle'  type='select' style='width:300px' value='0' name='ishtml'>"
           +"<option value='0'>检测表单流程模板</option>"
           //+"<option value='1'>检测配置文件</option>"
          // +"<option value='2'>检测web.xml</option>"---不需要此类型"
           +"<option value='4' selected>检测移动引擎模板</option>"
           +"<option value='5' selected>检测表单建模模板</option>"
           +"<option value='6' selected>流程自定义页面查询</option>"
           +"<option value='3' selected>其他</option>"
           +"</select>"}
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
function removeRow(v)
{
	var count = 0;//删除数据选中个数
	var i = 0;
	var flage = true;
	jQuery("#"+v+" input[name='paramid']").each(function(){
		
		if($(this).is(':checked')){
			
			var v1=jQuery("#"+v+" input[name='id']")[i].value;
			 if(v1=="checkwebxml"|| v1=="checkaction" || v1=="checkservice" || v1 == "checkhtml" || v1 == "checkmobilemodehtml" || v1 == "checkmodehtml" || v1 == "searchcustompage") {
				 top.Dialog.alert("checkwebxml,checkaction,checkservice,checkhtml禁止删除");
				 flage = false;
				 return false;
			 }
			count++;
		}
		i++;
	});
	if(!flage) {
		return;
	}
	if(count==0){
		top.Dialog.alert("请选择需要删除的数据!");
		return;
	}else{
		group.deleteRows();
		//$("#form1").submit();
	}
}

</script>
</head>
<%
if(!HrmUserVarify.checkUserRight("SystemSetEdit:Edit", user)){
 	//response.sendRedirect("/notice/noright.jsp");
 	//return;
}
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "集成登录设置";
String needfav ="1";
String needhelp ="";
String sourceparams = "";
String type = Util.null2String(request.getParameter("type"));
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<jsp:include page="/systeminfo/commonTabHead.jsp">
			<jsp:param name="mouldID" value="upgrade" />
			<jsp:param name="navName" value="文件检测项设置" />
</jsp:include>
<%

RCMenu += "{保存,javascript:save(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<form action="taboperation.jsp" method="post" name="form1" id="form1" >

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
//String tabname = "标签页设置";
String tabname = "文件检测项设置";
%>

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
<input name="ishtmlval" id="ishtmlval" value="" type="hidden"></input>
</form>
</BODY>
</HTML>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script type="text/javascript">
//保存自定义规则
function save() {
	var arr = Array();
	var i = 0;
	var cansubmit = true;
	jQuery("#tabs input[name='id']").each(function(){
		if($(this).val()==""){
			top.Dialog.alert("标识必填!");
			cansubmit = false;
			return;
		} else {
			var val = $(this).val();
			if(arr.indexOf(val)>-1) {
				top.Dialog.alert("标识重复!");
				cansubmit = false;
				return;
			} else {
				arr[i] = $(this).val();
			}
			i++;
		}
	});
	if(!cansubmit) {
		return;
	}
	
	arr = Array();
	i = 0;
	jQuery("#tabs input[name='tabname']").each(function(){
		if($(this).val()==""){
			top.Dialog.alert("标签页必填!");
			cansubmit = false;
			return;
		} else {
			var val = $(this).val();
			if(arr.indexOf(val)>-1) {
				top.Dialog.alert("标签页名称重复!");
				cansubmit = false;
				return;
			} else {
				arr[i] = $(this).val();
			}
			i++;
		}
	});
	
	if(!cansubmit) {
		return;
	}
	var ishtmls="";
	jQuery("#tabs select[name='ishtml'] option:selected").each(function(){
		ishtmls = ishtmls + "," + $(this).val();
	});
	$("#ishtmlval").val(ishtmls);
	$("#form1").submit();
}

function delete2(){
	removeRow("tabs");
}

</script>