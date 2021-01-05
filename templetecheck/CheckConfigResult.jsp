<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.templetecheck.CheckConfigFile" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<link rel="stylesheet" href="/wui/theme/ecology8/weaveredittable/css/WeaverEditTable_wev8.css">
<script  src="/wui/theme/ecology8/weaveredittable/js/WeaverEditTable_wev8.js"></script>
<link href="/js/checkbox/jquery.tzCheckbox_wev8.css" type=text/css rel=STYLESHEET>
<script type="text/javascript" src="/js/ecology8/jNice/jNice/jquery.jNice_wev8.js"></script>
<%
%>
</head>
<%!
public String replaceStr(String str) {
	if(str != null) {
		str = str.replace("<","&lt;");
		str = str.replace(">","&gt;");
	}
	return str;
}
%>
<%
int userid = user.getUID();
if(userid!=1) {
	response.sendRedirect("/notice/noright.jsp");
    return;
}
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "集成登录设置";
String needfav ="1";
String needhelp ="";
String filetype = Util.null2String(request.getParameter("filetype"));
String ids = Util.null2String(request.getParameter("checkids"));
String status = Util.null2String(request.getParameter("status"),"0");
String filename  = replaceStr(Util.null2String(request.getParameter("filename")));
String attrname  = replaceStr(Util.null2String(request.getParameter("attrname")));
String attrvalue = replaceStr(Util.null2String(request.getParameter("attrvalue")));

%>
<script type="text/javascript">
// var parentWin = null;
// var dialog = null;
// try{
// parentWin = parent.getParentWindow(window);
// dialog = parent.parent.getDialog(window);
// }catch(e){}
 
</script>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{导出Excel,javascript:exportExcel(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
// RCMenu += "{返回,javascript:back(),_self} " ;
// RCMenuHeight += RCMenuHeightStep ;


String backFields = "";
String sql = "";
//status = "0";//0:全部的  1:所有的  2:未配置的
String sourceparams= "filetype:"+filetype;
sourceparams  = sourceparams + "+ids:"+ids+"+status:"+status+"+filename:"+filename+"+attrname:"+attrname+"+attrvalue:"+attrvalue;
 //System.out.println("------------------------------sourceparams-----------------------"+sourceparams);


String tableString = "<table instanceid=\"MATCH_LIST_CON\" pageId=\""+"checkConfigResultList"+"\" "+
	    	" pagesize=\""+PageIdConst.getPageSize("checkConfigResultList",user.getUID())+"\"  tabletype=\"none\" datasource=\"weaver.templetecheck.CheckConfigFile.getMatchResult\" sourceparams=\""+sourceparams+"\">"+
	      	"<sql backfields=\"*\" sqlform=\"tmpTable\" sqlsortway=\"asc\"  sqlprimarykey=\"detailid\"/>"+
	        "<head>"+
	       		 "<col width=\"0%\"  text=\""+"序号"+"\" column=\"detailid\" hide=\"true\"  />"+
	             "<col width=\"10%\"  text=\""+"文件类型"+"\" column=\"filetype\"  />"+
	             "<col width=\"10%\"  text=\""+"文件路径"+"\" column=\"filepath\"  />";
	       	      if(filetype.equals("1")) {
	       	    	tableString += "<col width=\"10%\" text=\""+"属性名"+"\" column=\"attrname\" />";
	       	      }
	       	   	 tableString += "<col width=\"10%\" text=\""+"标准配置"+"\" column=\"attrvalue\" />";
   	             if(filetype.equals("1")) {
   	            	tableString += "<col width=\"10%\" text =\""+"本地配置"+"\" column=\"localvalue\" />";
   	             }
   	          tableString += "<col width=\"10%\" text=\""+"是否系统必配"+"\" column=\"requisite\" />";
   	          tableString += "<col width=\"10%\"  text=\""+"配置状态"+"\" column=\"statusname\"  otherpara=\"column:statusname+column:statusname\" transmethod=\"weaver.templetecheck.CheckConfigFile.getConfigColor\"  />";
   	       tableString += "</head>"+
			"<operates>"+
			" <popedom transmethod=\"weaver.templetecheck.PageTransMethod.getOpratePopedom2\" otherpara=\"2+column:status+column:filetype\" ></popedom> ";
			if(filetype.equals("1")){
				tableString+="	<operate href=\"javascript:change();\" text=\""+"修改配置"+"\" otherpara=\"column:status\" index=\"0\"/> "+
				 			 "	<operate href=\"javascript:change();\" text=\""+"删除配置"+"\" otherpara=\"column:status\" index=\"1\"/> ";
			}
			if(filetype.equals("2")){
				tableString+="	<operate href=\"javascript:change();\" text=\""+"手动配置"+"\" otherpara=\"column:status\" index=\"0\"/> "+
							 "  <operate href=\"javascript:autoChange();\" text=\""+"自动配置"+"\" otherpara=\"column:status\" index=\"1\"/> "+
				 			 "	<operate href=\"javascript:change();\" text=\""+"删除配置"+"\" otherpara=\"column:status\" index=\"2\"/> ";
			}
				   
			tableString+= "</operates></table>";       
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<form action="CheckConfigResult.jsp" method="post" name="form1" id="form1" >
<input type="hidden" name="filetype" value=<%=filetype%> />
<input type="hidden" name="checkids" value=<%=ids%> />
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
		<input type="hidden" class="searchInput" id="flowTitle" name="flowTitle" value="" onchange=""/>
			<input type="button" value="导出Excel" class="e8_btn_top" onclick="exportExcel()"/>
<!-- 			<input type="button" value="一键配置" class="e8_btn_top" onclick="oneKeyConfig()"/> -->
			<span id="advancedSearch" class="advancedSearch">高级搜索</span>
			<span title="菜单" class="cornerMenu"></span>
			
		</td>
	</tr>
</table>
<div id="tabDiv" >
   <span style="font-size:14px;font-weight:bold;">LDAP账号列表（未分配部门）</span>
</div>
	
<div class="cornerMenuDiv"></div>
<div class="advancedSearchDiv" id="advancedSearchDiv">
	<wea:layout type="4col">
		<wea:group context="高级搜索">
			<wea:item>文件名称</wea:item>
			<wea:item><input type="text" name="filename" value="<%=filename%>"></wea:item>
			<wea:item>配置状态</wea:item>
			<wea:item>
				<select name="status">
				<option value="0" <%if("0".equals(status)){ %> selected<%} %>>全部</option>
				<option value="1" <%if("1".equals(status)){ %> selected<%} %>>已配置</option>
				<option value="2" <%if("2".equals(status)){ %> selected<%} %>>未配置</option>
				<% if(filetype.equals("1")) { %>
					<option value="3" <%if("3".equals(status)){ %> selected<%} %>>与标准不一致</option>

					<option value="5" <%if("5".equals(status)){ %> selected<%} %>>找到多个相同元素</option>

			  <%--  <option value="7" <%if("7".equals(status)){ %> selected<%} %>>配置内容不一致</option> --%>
					<option value="8" <%if("8".equals(status)){ %> selected<%} %>>已过期可忽略</option>
				<%}else if(filetype.equals("2")) { %>
				<option value="3" <%if("3".equals(status)){ %> selected<%} %>>与标准不一致</option>
				<option value="4" <%if("4".equals(status)){ %> selected<%} %>>解析出错</option>
				<option value="5" <%if("5".equals(status)){ %> selected<%} %>>找到多个相同元素</option>
				<option value="6" <%if("6".equals(status)){ %> selected<%} %>>配置内容不符合XML格式</option>
				<option value="7" <%if("7".equals(status)){ %> selected<%} %>>配置内容不一致</option>
				<option value="8" <%if("8".equals(status)){ %> selected<%} %>>已过期可忽略</option>
				<%}%>
				</select>
			</wea:item>
			<%if(filetype.equals("1")){ %>
			<wea:item>属性名</wea:item>
			<wea:item><input type="text" name="attrname" value="<%=attrname%>"></wea:item>
			<%}%>
			<wea:item>标准配置</wea:item>
			<wea:item><input type="text" name="attrvalue" value="<%=attrvalue%>"></wea:item>
		</wea:group>
		<wea:group context="" attributes="{'groupDisplay':'none'}">
			<wea:item type="toolbar">
					<input type="submit"  onclick="doRefresh()" value="搜索" class="zd_btn_submit"/>
					<input type="button" value="重置" class="e8_btn_cancel" onclick="resetCondtion();"/>
					<input type="button" value="取消" class="e8_btn_cancel" id="cancel"/>
			</wea:item>
		</wea:group>
	</wea:layout>
</div>

<TABLE width="100%">
    <tr>
        <td valign="top">  
        	<input type="hidden" name="pageId" id="pageId" value="checkConfigResultList"/>
           	<wea:SplitPageTag  tableString="<%=tableString %>" isShowTopInfo="true" mode="run" />
        </td>
    </tr>
</TABLE>

</form>
<iframe id="excels" src="" style="display:none"></iframe>
</BODY>
</HTML>
<script type="text/javascript">
$(document).ready(function(){
	//设置标题栏高级查询
	$("#topTitle").topMenuTitle({searchFn:doRefresh});
	$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
	$("#tabDiv").remove();
});


function back() {
	
}

function exportExcel() {
	document.getElementById("excels").src ="/templetecheck/ConfigExcel.jsp?filetype=<%=filetype%>&ids=<%=ids%>&status=<%=status%>&filename=<%=filename%>&attrname=<%=attrname%>&attrvalue=<%=attrvalue%>&from=CheckConfigResult";
}

function closeDialog(){
	if(dialog)
		dialog.close();
}

function showDialog(url,title){
	
	if(typeof dialog  == 'undefined' || dialog==null){
		dialog = new window.top.Dialog();
	}
	dialog.currentWindow = window;
	dialog.Title = title;
	dialog.Width =  600;
	dialog.Height =  550;
	dialog.Drag = true;
	dialog.maxiumnable = true;
	if(url.indexOf("selectXmlNode")!=-1){//跳转检查结果页后，关闭结果页，强制对该页面reload
		dialog.CancelEvent = function(){ 
			_table.reLoad()
			dialog.close()
			}
	}
	dialog.URL = url;
	try {
		dialog.show();
	}catch(e) {
	
	}
}

function doRefresh(){
	$("#form1").attr("action","CheckConfigResult.jsp");
	$("#form1").submit();
}

function change(id,status) {
	var detailid  = id;//配置明细表的id
	var type = "<%=filetype%>";
	var operate = (status =="1")?"2":"1";//1:编辑 2:删除
	var needRestart = false;
	var message = (status =="1")?"提示:是否确认删除配置?":"提示:是否确认修改配置?"
	if(type=="1") {//properties文件直接更新
		top.Dialog.confirm(message, function(){
		$.ajax({
			url : "/templetecheck/EditPropertiesOperation.jsp",
			dataType:'json',
			type:'post',
			data:{
				"detailid":detailid,
				"from":"checkconfig",
				"operate":operate
			},
			success:function(data){
				var result = data.status;
				if(result == "ok") {
					_table.reLoad();
					top.Dialog.alert("修改配置成功");
					return;
				} else {
					top.Dialog.alert("修改配置失败");
					return;
				}
			}
		});
		},function(){});
	} else if(type == "2"){
		if(operate == "1"){//修改配置
			showDialog("/templetecheck/selectXmlNode.jsp?from=checkconfig&detailid="+detailid+"&configtype="+type+"&operator="+operate,"选择XML元素父节点");
		}else if(operate == "2"){
			 $.ajax({
			 	sync:false,
				dataType:'json',
				type:'post',
				url:'/templetecheck/selectXmlNodeOperation.jsp',
				
				data:{
					'from':'needRestart',					
					'detailid': detailid
				},
				success:function(data){
					if(data) {
						var res =data.status;
						if(res=="ok"){
							message = message +"<span style=\"color:red\">(删除配置后系统将自动重启,需要重新登录系统)</span>";
							needRestart = true;
						}
					}
					top.Dialog.confirm(message, function(){
					$.ajax({
						url : "/templetecheck/selectXmlNodeOperation.jsp",
						dataType:'json',
						type:'post',
						data:{
							"detailid":detailid,
							"from":"autoChangeXmlNodeConfig",
							"operate":operate,
							"configtype":type
						},
						success:function(data){
							var result = data.status;
							if(result == "ok") {
								if(needRestart){
									top.Dialog.alert("删除配置成功<span style=\"color:red\">(稍后自动重启)</span>",320,320);
									setTimeout("top.location ='/login/Login.jsp'", 1500);
									return ;
								}
								_table.reLoad();
								top.Dialog.alert("删除配置成功");
								return;
							} else {
								_table.reLoad();
								top.Dialog.alert("删除配置失败");
								return;
							}
						},
						error:function(data){
							var errorif = data;
						}
					});
				},function(){});
			} });
		}else{
			top.Dialog.alert("参数不正确!");
			return;
		}
	}	
}


function autoChange(id,status) {
	var detailid  = id;//配置明细表的id
	var type = "<%=filetype%>";
	var operate = (status =="1")?"2":"1";//1:编辑 2:删除
	var message = "提示:是否确认修改配置?";
	var needRestart = false;
	 $.ajax({
		 	sync:false,
			dataType:'json',
			type:'post',
			url:'/templetecheck/selectXmlNodeOperation.jsp',
			
			data:{
				'from':'needRestart',					
				'detailid': detailid
			},
			success:function(data){
				if(data) {
					var res =data.status;
					if(res=="ok"){
						message = message +"<span style=\"color:red\">(自动配置后系统将自动重启,需要重新登录系统)</span>";
						needRestart = true;
					}
				}
				
				if(type == "2"){
					if(operate == "1"){//xml自动修改配置
						top.Dialog.confirm(message, function(){
							$.ajax({
								url : "/templetecheck/selectXmlNodeOperation.jsp",
								dataType:'json',
								type:'post',
								data:{
									"detailid":detailid,
									"from":"autoChangeXmlNodeConfig",
									"operate":operate,
									"configtype":type
								},
								success:function(data){
									var result = data.status;
									if(result == "ok") {
										if(needRestart){
											top.Dialog.alert("修改配置成功<span style=\"color:red\">(稍后自动重启)</span>",320,320);
											setTimeout("top.location ='/login/Login.jsp'", 1500);	
											return;
										}
										_table.reLoad();
										top.Dialog.alert("修改配置成功");
										return;
									} else {
										_table.reLoad();
										top.Dialog.alert("修改配置失败");
										return;
									}
								},
								error:function(data){
									var errorif = data;
								}
							});
							},function(){}
							);
					}
				
				}else{
					top.Dialog.alert("参数不正确!");
					return;
				}
			}
		});
	}

</script>
