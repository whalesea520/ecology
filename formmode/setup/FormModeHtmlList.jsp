
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.io.File" %>
<%@ page import="weaver.conn.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/formmode/pub_detach.jsp"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML>
<HEAD>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<link href="/formmode/css/formmode_wev8.css" type="text/css" rel="stylesheet" />
</HEAD>
<body>
<%
	if (!HrmUserVarify.checkUserRight("ModeSetting:All", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}

	//============================================删除数据====================================
	String method=Util.null2String(request.getParameter("method"));
	String deletebillid=Util.null2String(request.getParameter("deletebillid"));
	String titlename = SystemEnv.getHtmlLabelName(30091,user.getLanguage());//页面扩展设置
	String layoutname = Util.null2String(request.getParameter("layoutname"));
	String modeid=Util.null2String(request.getParameter("id"));
	int formid = Util.getIntValue(Util.null2String(request.getParameter("formId")));
	String version = Util.null2String(request.getParameter("version"));
	
	String sql = "select subCompanyId from modeinfo where id="+modeid;
	RecordSet recordSet = new RecordSet();
	recordSet.executeSql(sql);
	int subCompanyId = -1;
	if(recordSet.next()){
		subCompanyId = recordSet.getInt("subCompanyId");
	}
	String userRightStr = "ModeSetting:All";
	Map rightMap = getCheckRightSubCompanyParam(userRightStr,user,fmdetachable, subCompanyId,"",request,response,session);
	int operatelevel = Util.getIntValue(Util.null2String(rightMap.get("operatelevel")),-1);
	subCompanyId = Util.getIntValue(Util.null2String(rightMap.get("subCompanyId")),-1);
	
	if(method.equals("del")){//删除数据
		String layoutids[] = deletebillid.split(",");
		for(int i=0;i<layoutids.length;i++){
			String id = Util.null2String(layoutids[i]);
			rs.executeSql("delete from modeformfield where layoutid="+id);//删除字段表		
			rs.executeSql("delete from modefieldattr where layoutid="+id);//删除字段属性
			rs.executeSql("select * from modehtmllayout where id="+id);
			String src = "";
			if(rs.next()){
				src = Util.null2String(rs.getString("syspath"));
			}
			try{
				File f = new File(src);
				if (f.exists()) {
					f.delete();
				}
			}catch(Exception e){
			}
			rs.executeSql("delete from modehtmllayout where id="+id);
			rs.executeSql("delete from modeformgroup where id="+id);
		}
	}
	
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javaScript:doSearch(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

if(operatelevel>0){
	//新建布局
	RCMenu += "{"+SystemEnv.getHtmlLabelName(365,user.getLanguage())+SystemEnv.getHtmlLabelName(82134,user.getLanguage())+",javaScript:doAdd(0),_self} " ;//新建显示布局
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(365,user.getLanguage())+SystemEnv.getHtmlLabelName(82135,user.getLanguage())+",javaScript:doAdd(1),_self} " ;//新建新建布局
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(365,user.getLanguage())+SystemEnv.getHtmlLabelName(82136,user.getLanguage())+",javaScript:doAdd(2),_self} " ;//新建编辑布局
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(365,user.getLanguage())+SystemEnv.getHtmlLabelName(82137,user.getLanguage())+",javaScript:doAdd(3),_self} " ;//新建监控布局
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(365,user.getLanguage())+SystemEnv.getHtmlLabelName(82138,user.getLanguage())+",javaScript:doAdd(4),_self} " ;//新建打印布局
	RCMenuHeight += RCMenuHeightStep ;
}
if(operatelevel>1){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javaScript:Del(),_self} " ;//删除
	RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<form name="frmSearch" method="post" action="/formmode/setup/FormModeHtmlList.jsp" onSubmit="return false;">
<input type="hidden" name="id" id="id" value="<%=modeid%>">
<input type="hidden" name="formId" id="formId" value="<%=formid%>">
<table class="e8_tblForm">
<tr>
	<td class="e8_tblForm_label" width="15%">
		<%=SystemEnv.getHtmlLabelName(23731,user.getLanguage())%><!-- 布局名称 -->
	</td>
	<td class="e8_tblForm_field" width="35%">
		<input class="inputstyle" id="layoutname" name="layoutname" type="text" value="<%=layoutname%>" style="width:80%">
	</td>
	<td class="e8_tblForm_label" width="15%">
		<%=SystemEnv.getHtmlLabelNames("19407,19071",user.getLanguage())%><!-- 布局模式 -->
	</td>
	<td class="e8_tblForm_field" width="35%">
		<select id="version" name="version" onchange="versionChangeFun()">
			<option value=""></option>
			<option value="0" <%if("0".equals(version)){%>selected<%} %>><%=SystemEnv.getHtmlLabelName(84089,user.getLanguage())%></option>
			<option value="2" <%if("2".equals(version)){%>selected<%} %>><%="excel"+SystemEnv.getHtmlLabelNames("19071,64",user.getLanguage())%></option>
		</select>
	</td>
</tr>
</table>
</form>
<br/>

<%
String SqlWhere = " where 1=1";
if(!layoutname.equals("")){
	SqlWhere += " and a.layoutname like '%"+layoutname+"%' ";
}
if(!modeid.equals("")){
	SqlWhere += " and a.modeid = "+modeid+" and a.formid="+formid;
}
if(!"".equals(version)){
	SqlWhere += " and a.version = "+version;
}

String perpage = "10";
String backFields = "a.id,a.modeid,a.formid,a.type,a.layoutname,a.isdefault,a.version ";
String sqlFrom = "from modehtmllayout a ";
String orderby = " a.type asc ";

String tableString=""+
	"<table  pagesize=\""+perpage+"\" tabletype=\"checkbox\">"+
		"<sql backfields=\""+backFields+"\" sqlform=\""+sqlFrom+"\" sqlorderby=\""+orderby+"\" sqlprimarykey=\"a.id\" sqlsortway=\"desc\" sqldistinct=\"true\" sqlwhere=\""+Util.toHtmlForSplitPage(SqlWhere)+"\"/>"+
		"<checkboxpopedom showmethod=\"weaver.formmode.interfaces.InterfaceTransmethod.getIscheckbox\" popedompara=\"column:isdefault\"/>"+
			"<head>"+                             //布局名称
				"<col width=\"55%\"  text=\""+SystemEnv.getHtmlLabelName(23731,user.getLanguage())+"\" column=\"layoutname\" orderkey=\"layoutname\" otherpara=\"column:id+column:modeid+column:formid+column:type+column:version\" transmethod=\"weaver.formmode.interfaces.InterfaceTransmethod.getLayoutNameUrl\"/>"+
				//布局类型
				"<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(23721,user.getLanguage())+"\" column=\"type\" orderkey=\"type\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.formmode.interfaces.InterfaceTransmethod.getLayoutType\"/>"+
				//是否默认布局
				"<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(82139,user.getLanguage())+"\" column=\"isdefault\" orderkey=\"isdefault\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.formmode.interfaces.InterfaceTransmethod.getIsShow\"/>"+
				//布局模式
				"<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelNames("19407,19071",user.getLanguage())+"\" column=\"version\" orderkey=\"version\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.formmode.interfaces.InterfaceTransmethod.getLayoutModel\"/>"+
			"</head>"+
	"</table>";
%>

<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" isShowTopInfo="true"/>

<script type="text/javascript">
$(document).ready(function(){//onload事件
	$(".loading", window.parent.document).hide(); //隐藏加载图片
	$("#layoutname").keyup(function(e){
		if(e.keyCode == 13 ){
			doSearch();
		}
	});
})

function versionChangeFun(){
	doSearch();
}

function doSearch(){
    frmSearch.submit();
}

function doAdd(layouttype){
	var dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	dialog.Width = 260 ;
	dialog.Height = 180;
	dialog.normalDialog = false;
	dialog.URL = "/formmode/setup/chooseLayoutModelBrowser.jsp";
	dialog.callbackfun = function (paramobj, returnjson) {
		var layoutmodel = returnjson.layoutmodel;
		var initexcellayout = returnjson.initexcellayout;
		openCreatePage(layouttype,layoutmodel,initexcellayout);
	} ;
	dialog.Title = "<%=SystemEnv.getHtmlLabelNames("18214,19407,19071",user.getLanguage())%>";//请选择布局模式
	dialog.Drag = true;
	dialog.show();
}
   
function onShowModeSelect(inputName, spanName){
	var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/formmode/browser/ModeBrowser.jsp");
	if (datas){
	    if(datas.id!=""){
		    $(inputName).val(datas.id);
			if ($(inputName).val()==datas.id){
		    	$(spanName).html(datas.name);
			}
	    }else{
		    $(inputName).val("");
			$(spanName).html("");
		}
	} 
}

function Del(){
	var CheckedCheckboxId = _xtable_CheckedCheckboxId();
	if(CheckedCheckboxId!=""){
		window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(33435,user.getLanguage())%>",function(){
			var layoutname = $G("layoutname").value ;
      			location.href ="/formmode/setup/FormModeHtmlList.jsp?id=<%=modeid%>&formId=<%=formid%>&layoutname="+layoutname+"&method=del&deletebillid="+CheckedCheckboxId;
		});
	}else{
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(20149,user.getLanguage())%>");
		return;
	}
}

function openCreatePage(layouttype,layoutmodel,initexcellayout){
	if(layoutmodel==0){
		var url = "/formmode/setup/LayoutEdit.jsp?type="+layouttype+"&modeId="+<%=modeid%>+"&formId="+<%=formid%>;
		openFullWindowHaveBar(url);
	}else{
		if(initexcellayout){
			batchSetExcelField(layouttype);
		}else{
			onshowExcelDesign(layouttype,"0");
		}
	}
}

//新表单设计器-批量设置表单字段
function batchSetExcelField(layouttype){
	var dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "/formmode/exceldesign/excelInitModule.jsp?modeid=<%=modeid%>&formid=<%=formid%>&layouttype="+layouttype+"&isdefault=0&fromwhere=batchset";;
	dialog.Title = "设置单元格格式";
	dialog.Width = 810;
	dialog.Height = 570;
	dialog.hideDraghandle = true;	
	dialog.URL = url;
	dialog.show();
}
	
//打开新表单设计器
function onshowExcelDesign(layouttype, layoutid){
	var dlg=new window.top.Dialog();//定义Dialog对象
	dlg.currentWindow=window;
	dlg.Model=true;
    if ($.browser.msie && parseInt($.browser.version, 10) < 9) {		//run for ie7/8
    	dlg.maxiumnable=false;
    	dlg.Width = 1000;
		dlg.Height = 600;
    	dlg.URL="/wui/common/page/sysRemind.jsp?labelid=124796";
    	dlg.hideDraghandle = false;
    }else{
    	dlg.maxiumnable=true;
    	dlg.Width = $(window.top).width()-60;
		dlg.Height = $(window.top).height()-80;
    	dlg.URL="/formmode/exceldesign/excelMain.jsp?modeid=<%=modeid%>&formid=<%=formid%>&layoutid="+layoutid+"&layouttype="+layouttype;
    	dlg.hideDraghandle = true;
    } 
	dlg.Title="新版流程模式设计器";
	dlg.closeHandle = function (paramobj, datas){
		window.location.reload();
	}
　　 dlg.show();
}
</script>

</BODY>
</HTML>
