<%@ page import="weaver.general.Util,weaver.conn.RecordSet" %>
<%@ page import="weaver.templetecheck.CheckUtil" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML>
<HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/WEB-INF/tld/browser.tld" prefix="brow"%>
<link rel="stylesheet" href="/wui/theme/ecology8/weaveredittable/css/WeaverEditTable_wev8.css">
<script  src="/wui/theme/ecology8/weaveredittable/js/WeaverEditTable_wev8.js"></script>


<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/dragBox/parentShowcol_wev8.js"></script>
<link rel="stylesheet" href="/css/ecology8/request/requestView_wev8.css" type="text/css" />
<%
//判断只有管理员才有权限
int userid = user.getUID();
if(userid!=1) {
	response.sendRedirect("/notice/noright.jsp");
  return;
}

// String imagefilename = "/images/hdHRMCard_wev8.gif";
String filepathnote = "路径为ecology下的子路径，如：\\WEB-INF\\prop\\ldap.properties";
String titlename = "";
int filetype=0 ;
String filename = "";
String filepath = "";
String kbversion = "";
String fileinfo = "";
String method = "";
//String qcnumber = "";
int id = 0;
method =  Util.null2String(request.getParameter("method"));
id =  Util.getIntValue(Util.null2String(request.getParameter("id")));
RecordSet rs = new RecordSet();
if(method.equals("edit")&&id!=0){
	rs.execute("select * from configFileManager where isdelete=0 and id = "+id);
	if(rs.next()){
		filename = Util.null2String(rs.getString("titlename"));
		filetype =  Util.getIntValue(rs.getString("filetype"));
		filename = Util.null2String(rs.getString("filename"));
		filepath = Util.null2String(rs.getString("filepath"));
		kbversion = Util.null2String(rs.getString("kbversion"));
		fileinfo = Util.null2String(rs.getString("fileinfo"));
	//	qcnumber = Util.null2String(rs.getString("qcnumber"));
	}
}else{
	rs.execute("select * from license");
	if(rs.next()){
		String cversion = Util.null2String(rs.getString("cversion"));
		kbversion = cversion.substring(cversion.indexOf("+")+1,cversion.length());
	}
}



String note = "根据配置输入对应的版本号，如果是KB补丁包请输入补丁包版本，如：KB81001508；如果是非KB补丁包，请输入版本号，如：8.100.0531。";
%>
<script type="text/javascript">

var parentWin = null;
var dialog = null;
var method = null;
var id = <%=id%>;
try{
	parentWin = parent.getParentWindow(window);
	dialog = parent.getDialog(window);
}catch(e){}
$(document).ready(function(){
	method = "<%=method%>";
	checkinput("filetype","filetypeimage")
	
});

/*
 * 动态获得url地址
 */
function onShowKBVersion() {
	var url = "/systeminfo/BrowserMain.jsp?url=/templetecheck/KBBrowser.jsp?";
	return url;
}

// function checkfilename(filename,filenameimage){
// 	checkinput(filename,filenameimage);
// 	//alert(tempname+"===="+tempname.indexOf(".properties"))
// 	var tempname = $("#filename").val();
// 	if(tempname.indexOf(".properties")==-1&&tempname.indexOf(".xml")==-1){
		
// 		alert("文件后缀名不正确");
// 		setTimeout(function() {
// 			$("#filename").focus();
// 		}, 100);
		
// 	}	
// 		//$("#filetype option:contains('XML')").	
// };

// function checkfilepath(filepath,filepathimage){
// 	checkinput(filepath,filepathimage);
// 	var temppath = $("#filepath").val();
// 	$.ajax({
// 		type: "post",
// 			url:"/templetecheck/ConfigOperation.jsp",
// 			async: true,
// 			data:{
// 				method:"checkpath",
// 				filepath:temppath
// 			},
// 			success:function(data){
// 				alert(data)
// 				if(data.trim()== "ok"){
// 				}else{
// 					alert("输入的路不存在");
// 					$("#filepath").val("")
// 				}
// 				//onRefresh();
// 			}
// 		});
// };


function submitData() {
	if(!check_form(frmMain,"filename,filetype,filepath")) {
		return;
	}
	
	var tempname = $("#filename").val();
	var temptype =  $("#filetype option:selected").text().toLowerCase();
	if(tempname.indexOf(".properties")==-1&&tempname.indexOf(".xml")==-1){
		 $("#filename").focus();
		alert("文件后缀名不正确");
		return;
	}
	
	if(tempname.indexOf(temptype)==-1){
		alert("文件类型与文件不匹配");
		return;
	}
	
	var temppath=$("#filepath").val();
	
	if(temppath.indexOf(tempname)!=-1){
		temppath = temppath;
	}else if(temppath.substr(temppath.length-1,1) == "\\"){
		temppath = temppath+tempname;
	}else{
		temppath = temppath+"\\"+tempname;
	}
	
	$.ajax({
		type: "post",
			url:"/templetecheck/ConfigOperation.jsp",
			async: true,
			dataType:'json',
			type:'post',
			data:{
				method:"checkpath",
				filepath:temppath
			},
			success:function(data){
				if(data.status== "ok"){
					$.ajax({
						url:'/ConfigOperation.jsp',
						dataType:'json',
						type:'post',
						data:{
							'method':method,
							'id':id,
							'filename':$("#filename").val(),
							'filetype':$("#filetype").val(),
							'filepath':temppath,
							'fileinfo':$("#fileinfo").val(),
							'kbversion':$("#kbversion").val()
						},
						success:function(data){
							if(data) {
								
						
								//var res = eval("("+data+")").status;
								var res = data.status;
								//alert("res"+res)
								if(res == "ok") {
									parentWin._table.reLoad();
									top.Dialog.alert("保存成功！");
									if(dialog){
										dialog.closeByHand();
									}else{
										parentWin.closeDialog();
									} 
								}else if(res == "no"){
									top.Dialog.alert("更新失败!");
									return;
								}
							}
						}
					});
				}else{
					
					$("#filepath").focus();
					alert(data.errorinfo);
					return;
				}
				//onRefresh();
			}
		});

}
</script>
</HEAD>
<BODY>
<div class="zDialog_div_content">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{保存,javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="check"/>
   <jsp:param name="navName" value="添加配置信息"/>
</jsp:include>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="保存" class="e8_btn_top" onclick="submitData()"/>
<%--			<span id="advancedSearch" class="advancedSearch" style='display:none;'>高级搜索</span>&nbsp;&nbsp; --%>
			<span title="30947" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div id="tabDiv" >
   <span style="font-size:14px;font-weight:bold;"></span> 
</div>
<div class="cornerMenuDiv"></div>
<div class="advancedSearchDiv" id="advancedSearchDiv" style='display:none;'></div>
<FORM id=weaver name=frmMain action="ConfigOperation.jsp" method=post>
<input type="hidden" name="method" id="method" value="<%=method%>">
<%-- <input type="hidden" name="method" id="qcnumber" value="<%=qcnumber%>"> --%>


<wea:layout>
	<wea:group context="基本信息">
	

		<wea:item>文件名称</wea:item>
		<wea:item>
			<wea:required id="filenameimage" required="true" value="<%=filename%>">
				<input class=inputstyle type="text" style="width: 90%" name="filename" id="filename" value="<%=filename%>" onchange='checkinput("filename","filenameimage")'></input>
			</wea:required>
		</wea:item>
		
		<wea:item>文件路径</wea:item>
		<wea:item>
			<wea:required id="filepathimage" required="true" value="<%=filepath%>">
				<input class=inputstyle type="text" style="width: 90%" name="filepath" id="filepath" value="<%=filepath%>" onchange='checkinput("filepath","filepathimage")'></input>
				<SPAN style='CURSOR: hand' id=remind title=''><IMG id=ext-gen124  title='<%=filepathnote%>' align=absMiddle src='/images/remind_wev8.png'></SPAN>
			</wea:required>
		</wea:item>
		
			<wea:item>文件类型</wea:item>
		<wea:item>
		<wea:required id="filetypeimage" required="true" >
		<%if(filetype==0){%> 
			<select name=filetype id="filetype"  onchange='checkinput("filetype","filetypeimage")'>
				<option value="">请选择文件类型</option>
				<option value="1" >Properties</option>
				<option value="2" >XML</option>
			</select>
		
		<%}else {%>
			<select name=filetype id="filetype"  onchange='checkinput("filetype","filetypeimage")'>
				<option value="">请选择文件类型</option>
				<option value="1" <%if(filetype==1){%> selected="selected" <%}%> >Properties</option>
				<option value="2"  <%if(filetype==2){%> selected="selected" <%}%>>XML</option>
			</select>
			<%}%>
				</wea:required>
		</wea:item>

		<wea:item>KB版本</wea:item>
			<wea:item>
				<brow:browser viewType="0"  id="kbversion" name="kbversion" browserValue="<%=kbversion %>" 
			    browserUrl="" getBrowserUrlFn='onShowKBVersion'
			    hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1'
			    width="165px" browserSpanValue="<%=kbversion %>"></brow:browser>
			</wea:item>
		<wea:item>功能说明</wea:item>
		<wea:item>
			<textarea class=inputstyle style="width: 90%" rows='6' id="fileinfo"><%=fileinfo %></textarea>
		</wea:item>
	</wea:group>
</wea:layout>

</FORM>
</div>
</BODY>
</HTML>