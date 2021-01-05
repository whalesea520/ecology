<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.RecordSet"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/formmode/pub_detach.jsp"%>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<HTML><HEAD>
<%
int pageNo = 1;
int pageSize = 12;
String eid = Util.null2String(request.getParameter("eid"));
String reportId = Util.null2String(request.getParameter("reportId"));
String customedListName = Util.null2String(request.getParameter("customedListName"));
String modeid=Util.null2String(request.getParameter("modeid"));
String modeidspan = "";

String modename = "";
String sql = "";
if(!modeid.equals("")){
	sql = "select modename from modeinfo where id = " + modeid;
	rs.executeSql(sql);
	while(rs.next()){
		modename = Util.null2String(rs.getString("modename"));
	}
}

RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_top} " ;//搜索
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:searchReset(),_top} " ;//重新设置
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:submitClear(),_top} " ;//清除
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:closeDialog(),_top} " ;//取消
RCMenuHeight += RCMenuHeightStep ;

%>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<link href="/formmode/css/formmode_wev8.css" type="text/css" rel="stylesheet" />
</HEAD>
<BODY>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<FORM NAME=SearchForm action="custom_search_browser.jsp" method=post>
<input type="hidden" name="eid" value="<%=eid %>">
<table  width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<tr>
	<td valign="top">
	  <TABLE class=Shadow>
		<tr>
		  <td valign="top">
		  	   <table class="e8_tblForm" style="margin: 0 0 0 10px;">
			   <TR>
				 <TD width=20% class="e8_tblForm_label"><!-- 自定义查询名称 -->
				   	<%=SystemEnv.getHtmlLabelName(20773,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%>
				 </TD>
				 <TD class="e8_tblForm_field"><input name=customedListName value="<%=customedListName%>" class="InputStyle"></TD>
			    <TD width=15% class="e8_tblForm_label">
				<%=SystemEnv.getHtmlLabelName(28485,user.getLanguage())%><!-- 模块名称 -->
				</td>
				<TD width=35% class=e8_tblForm_field>
			 		 <button type="button" class=Browser id=formidSelect onClick="onShowModeSelect(modeid,modeidspan)" name=formidSelect></BUTTON>
			 		 <span id=modeidspan><%=modename%></span>
			 		 <input type="hidden" name="modeid" id="modeid" value="<%=modeid%>">
				</td>
				</TR>
			  </table>
			  <%
			  String perpage = "12";
			  String backFields = "c.id, c.customname,(select modename from modeinfo where id=c.modeid ) as modename,c.customdesc";
			  String sqlFrom = "from mode_customsearch c,modeTreeField f ";
			  String SqlWhere = "where c.appid=f.id and (f.isdelete<>1 or f.isdelete is null)";		//  order by c.customname
			  
			  if(!customedListName.equals("")) {
				  SqlWhere += " and c.customname like '%" + customedListName + "%'";
			  }
			  if(!modeid.equals("")&&!modeid.equals("0")){
				  SqlWhere = SqlWhere + " and c.modeid = '"+modeid+"'";
			  }
		     //自定义列表
		  	 String tableString=""+
				"<table pagesize=\""+perpage+"\" tabletype=\"none\">"+
					"<sql backfields=\""+backFields+"\" sqlform=\""+sqlFrom+"\" sqlprimarykey=\"c.id\" sqlsortway=\"desc\" sqldistinct=\"true\" sqlwhere=\""+Util.toHtmlForSplitPage(SqlWhere)+"\"/>"+
						"<head>"+            
						"<col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(19049,user.getLanguage())+SystemEnv.getHtmlLabelName(195,user.getLanguage())+"\" column=\"modename\" orderkey=\"modename\"  otherpara=\"" +user.getLanguage()+ "\" />"+
						"<col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(20773,user.getLanguage())+SystemEnv.getHtmlLabelName(195,user.getLanguage())+"\" column=\"customname\" orderkey=\"customname\"  otherpara=\"" +user.getLanguage()+ "\" />"+
						"<col width=\"40%\"  text=\""+SystemEnv.getHtmlLabelName(20773,user.getLanguage())+SystemEnv.getHtmlLabelName(433,user.getLanguage())+"\" column=\"customdesc\" orderkey=\"customdesc\"  otherpara=\"" +user.getLanguage()+ "\" />"+
						"</head>"+
				"</table>";
			  %>
			  <wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" isShowTopInfo="true"/>
			</td>
		  </tr>
		</TABLE>
	 </td>
	 <td></td>
  </tr>
</table>
</FORM>
</BODY></HTML>

<script type="text/javascript">
var parentWin = parent.getParentWindow(window);
var dialog = parent.getDialog(window);

jQuery(document).ready(function(){
	$("#_xTable").bind("click",BrowseTable_onclick);
	$("input[name='customedListName']").bind('keydown',function(event){
		if(event.keyCode == 13){    
			submitData();
		}
	});
})

function BrowseTable_onclick(e){
	var e=e||event;
	var target=e.srcElement||e.target;

	if(target.nodeName =="TD" || target.nodeName =="A"){
		var tr ;
		if(target.nodeName=="TD"){
			tr = jQuery(target).parent();
		}else if(target.nodeName =="A" ){
			tr = jQuery(target).parent().parent();
		}
		var idValue = tr.find("input[type='checkbox']").val();
		var nameValue = jQuery(jQuery(target).parents("tr")[0].cells[2]).text();
		
		parentWin.document.getElementById("reportId").value = idValue;
		parentWin.document.getElementById("reportIdspan").innerHTML = nameValue;
		if (!(navigator.userAgent.indexOf("MSIE") > 0)) { 
			parentWin.loadReportFieldsHandler();
		}
		closeDialog();
	}
}

function closeDialog() {
	dialog.close();
}

function submitData(){
	SearchForm.submit();
}

function searchReset() {
	SearchForm.customedListName.value="";
}

function submitClear(){
	parentWin.document.getElementById("reportId").value = "";
	parentWin.document.getElementById("reportIdspan").innerHTML = "";
	closeDialog();
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
</script>
