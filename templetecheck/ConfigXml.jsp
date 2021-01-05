<%@ page import="weaver.general.Util,weaver.conn.RecordSet" %>
<%@ page import="weaver.templetecheck.CheckUtil" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML>
<HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/dragBox/parentShowcol_wev8.js"></script>
<link rel="stylesheet" href="/css/ecology8/request/requestView_wev8.css" type="text/css" />

<script src="/js/ecology8/jquery_wev8.js"></script>

<!--checkbox组件 -->
<link href="/js/ecology8/jNice/jNice/jNice_wev8.css" type=text/css rel=stylesheet>
<script language=javascript src="/js/ecology8/jNice/jNice/jquery.jNice_wev8.js"></script>
<!-- 下拉框美化组件 -->
<link href="/js/ecology8/selectbox/css/jquery.selectbox_wev8.css" type=text/css rel=stylesheet>
<script language=javascript src="/js/ecology8/selectbox/js/jquery.selectbox-0.2_wev8.js"></script>

<!-- 泛微可编辑表格组件 -->
<link rel="stylesheet" href="/wui/theme/ecology8/weaveredittable/css/WeaverEditTable_wev8.css">
<script  src="/wui/theme/ecology8/weaveredittable/js/WeaverEditTable_wev8.js"></script>

<style type="text/css">
.tablecontainer {
	padding-left: 0px !important;
}
</style>

<%
	//判断只有管理员才有权限
	int userid = user.getUID();
	if (userid != 1) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	String titlename = "";
	int filetype = 0;
	String filename = "";
	String filepath = "";
	String kbversion = "";
	String fileinfo = "";
	int mainId = 0;
	mainId = Util.getIntValue(Util.null2String(request.getParameter("id")));
	String successful =  Util.null2String(request.getParameter("successful"));
	if (mainId != 0) {
		RecordSet rs = new RecordSet();
		rs.execute("select * from configFileManager where isdelete=0 and id = " + mainId);
		if (rs.next()) {
	filename = Util.null2String(rs.getString("titlename"));
	filetype = Util.getIntValue(rs.getString("filetype"));
	filename = Util.null2String(rs.getString("filename"));
	filepath = Util.null2String(rs.getString("filepath"));
	kbversion = Util.null2String(rs.getString("kbversion"));
	fileinfo = Util.null2String(rs.getString("fileinfo"));
		}
	}

	StringBuffer ajaxdata = new StringBuffer();
	RecordSet rs1 = new RecordSet();
	String sqlStr = "select * from configXmlFile where configfileid="+mainId +" and (isdelete = '0' or  isdelete is null) order by id asc ";
	rs1.execute(sqlStr);
	int lineNum=0;
	while(rs1.next()){
		String attrname = Util.null2String(rs1.getString("attrname"));
		String attrvalue  = Util.null2String(rs1.getString("attrvalue"));
		String attrnotes  = Util.null2String(rs1.getString("attrnotes"));
		String xpath = Util.null2String(rs1.getString("xpath")).replace("'","\\\\'");
		int attrid = Util.getIntValue(rs1.getString("id"));
		int issystem = Util.getIntValue(rs1.getString("issystem"));
		String requisite = Util.null2String(rs1.getString("requisite"));
		String iseditable = "true";
		if(issystem == 1){
			iseditable = "false";
		}
		ajaxdata.append("[");
		ajaxdata.append("{name:'issystem',value:'" + issystem + "',iseditable:" + iseditable + ",type:'input'},");
		ajaxdata.append("{name:'id',value:'" + attrid + "',iseditable:" + iseditable + ",type:'input'},");
		ajaxdata.append("{name:'lineNum',value:'" + lineNum + "',iseditable:false,type:'span'},");
		ajaxdata.append("{name:'attrvalue',value:'" + attrvalue.replace("\\","\\\\\\\\").replaceAll("\n","\\\\\\\\n").replaceAll("\r","\\\\\\\\r").replaceAll("\"","\\\\\\\"").replace("'","\\\\'") + "',iseditable:" + iseditable + ",type:'textarea'},");
		ajaxdata.append("{name:'xpath',value:'" + xpath + "',iseditable:" + iseditable + ",type:'textarea'},");
		ajaxdata.append("{name:'attrnotes',value:'" + attrnotes.replace("\\","\\\\\\\\").replaceAll("\n","\\\\\\\\n").replaceAll("\r","\\\\\\\\r").replaceAll("\"","\\\\\\\"").replace("'","\\\\'") + "',iseditable:" + iseditable + ",type:'textarea'},");
		ajaxdata.append("{name:'requisite',value:'" + requisite + "',iseditable:" + iseditable + ",type:'select'},");
		ajaxdata.append("],");
	}

	
	String tempajaxdata = ajaxdata.toString();
	if (!"".equals(tempajaxdata)) {
		tempajaxdata = tempajaxdata.substring(0, (tempajaxdata.length() - 1));
	}
	tempajaxdata = "[" + tempajaxdata + "]";
	
	String note = "根据配置输入对应的版本号，如果是KB补丁包请输入补丁包版本，如：KB81001508；如果是非KB补丁包，请输入版本号，如：8.100.0531。";
	
	//测试xpath是否正确的地址
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
	String testxpath = basePath+"templetecheck/CheckXpath.jsp";
	
	String note2 = "请输入XPath;XPath的指向的元素，必须是配置项的根节点\\n如：/web-app/servlet/servlet-name[text()=&apos;InitServer&apos;]/parent::*；";
	note2 = note2 +"\\n查询servlet-name=InitServerd的servlet元素。";
	note2 = note2 +"\\n如果配置项包含多个同层级的元素，指定其中一个元素即可。";
	note2 = note2 +"\\n如：配置项包含servlet和servlet-mapping，xpath指定到servlet元素即可。";
%>
<script type="text/javascript">

var parentWin = null;
var dialog = null;
var mainId = <%=mainId%>;
var group = null;
try{
	parentWin = parent.getParentWindow(window);
	dialog = parent.getDialog(window);
}catch(e){}
$(document).ready(function(){
	group=new WeaverEditTable(option);
    jQuery("#tabs").append(group.getContainer());
    var params=group.getTableSeriaData();
    jQuery(".optionhead").hide();
	jQuery("td[_samepair='configlist']").css("padding","0px!important");
	if("<%=successful%>"=="1"){
		top.Dialog.alert("保存成功！");
	}
	
});


var items=[
	 	   {width:"0",colname:"",itemhtml:"<input class='inputstyle' style='width:98%' name='issystem' type='hidden'></input>"},
	 	   {width:"0",colname:"",itemhtml:"<input class='inputstyle' style='width:98%' name='id' type='hidden'></input>"},
	 	   {width:"2%",colname:"序号",itemhtml:"<span name='lineNum'></span>"},
           {width:"40%",colname:"配置内容",itemhtml:"<textarea  class='inputstyle' rows='4' style='width:98%' name='attrvalue'></textarea>"},
           {width:"25%",colname:"XPath<a target='_blank' style='color:red' href='<%=testxpath %>'>(点击进入XPath测试页面)</a><SPAN style='CURSOR: hand' id=remind title=''><IMG id=ext-gen124  title='<%=note2%>' align=absMiddle src='/images/remind_wev8.png'></SPAN>",itemhtml:"<textarea  class='inputstyle' rows='4' style='width:98%' name='xpath'></textarea>"},
           {width:"23%",colname:"说明(注释)",itemhtml:"<textarea class='inputstyle'  rows='4' style='width:98%' name='attrnotes'></textarea>"},
           {width:"10%",colname:"是否系统必配",itemhtml:"<select class='inputstyle' style='width:98%' name='requisite'> <option value ='0'>否</option><option value ='1'>是</option></select>"}
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
 	setTimeout(showLineNum(), 200);
}
function removeRow(v)
{
	var count = 0;//删除数据选中个数
	var i = 0;
	var flage = true;
	jQuery("#"+v+" input[name='paramid']").each(function(){
		if($(this).is(':checked')){
			var v1=jQuery("#"+v+" input[name='issystem']")[i].value;
			 if(v1==1||v1=="1") {
				 top.Dialog.alert("系统属性禁止删除!");
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

function batchdelete(){
	removeRow('tabs');
}
//保存自定义规则
function save() {
	var requisiteArray =""
		jQuery("#tabs select[name='requisite']").each(function(){
			requisiteArray = requisiteArray+ $(this).val()+",";
		});
	jQuery("#requisiteArray").val(requisiteArray);
	var arr = Array();
	var i = 0;
	var cansubmit = true;
	$("#tabs textarea[name='attrvalue']").each(function(){
		if(!cansubmit)return;
		if($(this).val()==""){
			alert("第"+(i+1)+"行配置项不能为空!");
			$("#tabs textarea[name='attrvalue']")[i].focus();
			cansubmit = false;
			return false;
		} else {
			var val = $(this).val();
			if(val.toUpperCase().indexOf("[CDATA[")>-1){
    			top.Dialog.alert("第"+(i+1)+"行配置项不合法，不支持[CDATA写法！");
    			$("#tabs textarea[name='attrvalue']")[i].focus();
				cansubmit = false;
				return false;
    		}
			if(arr.indexOf(val)>-1) {
				alert("第"+(i+1)+"行配置项内容重复！");
				$("#tabs textarea[name='attrvalue']")[i].focus();
				cansubmit = false;
				return false;
			} else {
				//alert("this1.val====attrvalue:"+$(this).val());
				arr[i] = $(this).val();
				$.ajax({
					url:'ConfigXmlOperation.jsp',
					dataType:'json',
					type:'post',
					async:false,
					data:{
						'method':"checkxmlvalue",
						'checkvalue':""+arr[i],
					},
					success:function(data){
						if(data) {
							var res = data.status;
							if(res == "no") {
								alert("第"+(i+1)+"行输入的配置项值不符合xml语法!");
								$("#tabs textarea[name='attrvalue']")[i].focus();
								cansubmit = false;
								return false;
							} else{
							}
						}
					}
				});
			}
			i++;
		}
	});
	
	if(!cansubmit) {
		return false;
	}
	
// 	arr = Array();
// 	i = 0;
// 	jQuery("#tabs textarea[name='attrnotes']").each(function(){
// 		if($(this).val()==""){
// 			top.Dialog.alert("说明(注释)不能为空!");
// 			cansubmit = false;
// 			return false;
// 		} else {
// 			arr[i] = $(this).val();
// 			i++;
// 		}
// 	});
	
	if(!cansubmit) {
		return false;
	}
	$("#form1").submit();
}


</script>
</HEAD>
<BODY>
<div class="zDialog_div_content">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{保存,javascript:save(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{新建属性,javascript:addRow(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{批量删除,javascript:batchdelete(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="check"/>
   <jsp:param name="navName" value="Xml配置项设置"/>
</jsp:include>

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="保存" class="e8_btn_top" onclick="save()"/>
			<span id="advancedSearch" class="advancedSearch" style='display:none;'>高级搜索</span>&nbsp;&nbsp;
			<span title="菜单" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div id="tabDiv" >
   <span style="font-size:14px;font-weight:bold;"></span> 
</div>
<div class="cornerMenuDiv"></div>
<div class="advancedSearchDiv" id="advancedSearchDiv" style='display:none;'></div>

<form action="ConfigXmlOperation.jsp" method="post" name="form1" id="form1" >
<wea:layout>
	<wea:group context="基本信息">
	

		<wea:item>文件名</wea:item>
		<wea:item>
			<wea:required id="filenameimage" required="true" value="<%=filename%>">
				<input class=inputstyle type="text" style="width: 90%" name="filename" id="filename" value="<%=filename%>" readonly></input>
			</wea:required>
		</wea:item>
		
		<wea:item>文件路径</wea:item>
		<wea:item>
			<wea:required id="filepathimage" required="true" value="<%=filepath%>">
				<input class=inputstyle type="text" style="width: 90%" name="filepath" id="filepath" value="<%=filepath%>" readonly></input>
			</wea:required>
		</wea:item>
		<wea:item>功能说明</wea:item>
		<wea:item>
			<textarea class=inputstyle style="width: 90%" rows='6' id="fileinfo" readonly><%=fileinfo %></textarea>
		</wea:item>
	</wea:group>
	
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
<input type="hidden" id="mainId" name ="mainId"  value=<%=mainId %> />
<input type="hidden" id="method" name ="method"  value="save" />
<input type="hidden" id="requisiteArray" name ="requisiteArray"  value="" />
</FORM>
</div>
</BODY>
<script type="text/javascript">
// 由于控件不支持textarea添加iseditable属性，在加载完成后遍历添加readonly属性
window.onload = function (){
	showLineNum();
	var arr = Array();
	var i = 0;
	jQuery("#tabs input[name='issystem']").each(function(){
		arr[i] = $(this).val();
		i++;
	});
	
	i=0;
	jQuery("#tabs textarea[name='attrvalue']").each(function(){
		if(arr[i] == "1"){
			$(this).attr("readonly","readonly")
			 $(this).attr("unselectable","on")
		}
		i++;
	});
	i=0;
	jQuery("#tabs textarea[name='xpath']").each(function(){
		if(arr[i] == "1"){
			$(this).attr("readonly","readonly")
			 $(this).attr("unselectable","on")
		}
		i++;
	});
	i=0;
	jQuery("#tabs textarea[name='attrnotes']").each(function(){
		if(arr[i] == "1"){
			$(this).attr("readonly","readonly")
			 $(this).attr("unselectable","on")
		}
		i++;
	});

}


function showLineNum(){
	var i = 0;
	jQuery("#tabs span[name='lineNum']").each(function(){
		i++;
		$(this).html(i+"");
	});
}
</script>
</HTML>