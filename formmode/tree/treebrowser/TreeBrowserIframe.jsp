
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.systeminfo.systemright.CheckSubCompanyRight" %>
<%@ page import="weaver.formmode.virtualform.VirtualFormHandler"%>
<%@ page import="weaver.workflow.form.FormManager"%>
<%@page import="com.weaver.formmodel.util.StringHelper"%>
<%@page import="com.weaver.formmodel.util.NumberHelper"%>
<%@page import="com.weaver.formmodel.util.DateHelper"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/formmode/pub_detach.jsp"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />


<jsp:useBean id="FormComInfo" class="weaver.workflow.form.FormComInfo" scope="page" />

<HTML><HEAD>
<%
int pageNo = 1;
int pageSize = 12;
String treename = Util.null2String(request.getParameter("treename"));
String appid = Util.null2String(request.getParameter("appid"));

%>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<link href="/formmode/css/formmode_wev8.css" type="text/css" rel="stylesheet" />
</HEAD>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_top} " ;//搜索
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:searchReset(),_top} " ;//重新设置
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:submitClear(),_top} " ;//清除
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.parent.close(),_top} " ;//取消
RCMenuHeight += RCMenuHeightStep ;

%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" onclick="submitData()" class="e8_btn_top" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"></input><!-- 搜索 -->
			<span title="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage()) %>" class="cornerMenu"></span><!-- 确定 -->
		</td>
	</tr>
</table>
<FORM NAME=SearchForm action="/formmode/tree/treebrowser/TreeBrowserIframe.jsp" method=post>
<table  width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
	<td ></td>
	<td valign="top">
	  <TABLE class=Shadow>
		<tr>
		  <td valign="top">
			 <table class="e8_tblForm" style="margin: 10px 0;">
			   <TR>
				 <TD width=20% class="e8_tblForm_label"><!-- 树形名称 -->
				   <%=SystemEnv.getHtmlLabelName(30209,user.getLanguage())%>
				 </TD>
				 <TD width=30% class="e8_tblForm_field"><input name="treename" value="<%=treename%>" class="InputStyle"></TD>
				 <TD width=20% class="e8_tblForm_label"  >
				    <%=SystemEnv.getHtmlLabelName(82186,user.getLanguage())%><!-- 所属应用 -->
				 </TD>
				 <TD width=30% class="e8_tblForm_field" >
					<select name="appid" id="appid">
					    <option value="" ></option>
					    <%
					    	String sql = "select distinct b.id as appid,b.treeFieldName as appname from mode_customtree a,modeTreeField b where a.appid=b.id and b.isdelete=0 and a.showtype=1 order by b.id";
					    	RecordSet.executeSql(sql);
					    	while(RecordSet.next()){
					    		String tempappid = RecordSet.getString("appid");
					    		String tempappname = RecordSet.getString("appname");
					    %>
							<option value="<%=tempappid %>" <%if(appid.equals(tempappid)) {%> selected <% }%>><%=tempappname %></option>
					    <%}%>
					</select>
				 </TD>
			    </TR>
			  </table>
			  <%
			  String perpage = "12";
			  String backFields = " a.id,a.treename,b.id as appid,b.treeFieldName as appname ";
			  String sqlFrom = " from mode_customtree a,modeTreeField b " ;
              String SqlWhere = " where a.appid=b.id and a.showtype=1 and b.isdelete=0 ";
              
			  if(!treename.equals("")){
				  SqlWhere += " and a.treename like '%"+treename+"%'";
			  }
			  if(!appid.equals("")){
				  SqlWhere += " and b.id="+appid+"";
			  }
			    
		  	 String tableString=""+
				"<table pagesize=\""+perpage+"\" tabletype=\"none\">"+
					"<sql backfields=\""+backFields+"\" sqlform=\""+sqlFrom+"\" sqlprimarykey=\"a.id\" sqlsortway=\"desc\" sqldistinct=\"true\" sqlwhere=\""+Util.toHtmlForSplitPage(SqlWhere)+"\"/>"+
						"<head>"+            //自定义表单
							"<col width=\"50%\"  text=\""+SystemEnv.getHtmlLabelName(30209,user.getLanguage())+"\" column=\"treename\" orderkey=\"treename\"   />"+
							//表单类型
							"<col width=\"50%\"  text=\""+SystemEnv.getHtmlLabelName(82186,user.getLanguage())+"\" column=\"appname\" orderkey=\"appname\" />"+
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
var parentWin = parent.parent.parent.getParentWindow(parent.parent);
var dialog = parent.parent.parent.getDialog(parent.parent);

function btnclear_onclick(){
	var returnjson = {id:"",name:""};
	if(dialog){
	    dialog.callback(returnjson);
	    if(parentWin.customDialogCallBack){
	    	parentWin.customDialogCallBack(0);
	    }
	}else{  
	    window.parent.returnValue  = returnjson;
	    window.parent.close();
	}
}

function BrowseTable_onmouseover(e){
	e=e||event;
   var target=e.srcElement||e.target;
   if("TD"==target.nodeName){
		jQuery(target).parents("tr")[0].className = "Selected";
   }else if("A"==target.nodeName){
		jQuery(target).parents("tr")[0].className = "Selected";
   }
}
function BrowseTable_onmouseout(e){
	var e=e||event;
   var target=e.srcElement||e.target;
   var p;
	if(target.nodeName == "TD" || target.nodeName == "A" ){
      p=jQuery(target).parents("tr")[0];
      if( p.rowIndex % 2 ==0){
         p.className = "DataDark"
      }else{
         p.className = "DataLight"
      }
   }
}
jQuery(document).ready(function(){
	$(".loading", window.document).hide();
	$("#_xTable").bind("click",BrowseTable_onclick);
	$("input[name='treename']").bind('keydown',function(event){
		if(event.keyCode == 13){    
			submitData();
		}
	});
	$("#appid").bind("change",function(){
		submitData();
	});
})
function BrowseTable_onclick(e){
	var e=e||event;
	var target=e.srcElement||e.target;

	if( target.nodeName =="TD"||target.nodeName =="A"  ){
		var tr ;
		if(target.nodeName=="TD"){
			tr = jQuery(target).parent();
		}else if(target.nodeName =="A" ){
			tr = jQuery(target).parent().parent();
		}
		var idValue = tr.find("input[type='checkbox']").val();
		var isvirtualform = 0;
		var vstr = tr.find("td:last").html();
   	 	var nameValue = "<a href=\"#\" onclick=\"toformtabFormChoosed('"+idValue+"_"+isvirtualform+"')\" style=\"color:blue;TEXT-DECORATION:none\">"+
   	 				 jQuery(jQuery(target).parents("tr")[0].cells[1]).text();
   	 	nameValue+="</a>";
		var returnjson = {id:idValue,name:nameValue};
		if(dialog){
				try {
					dialog.callback(returnjson);
				} catch(e) {}

				try {
					dialog.close(returnjson);
				} catch(e) {}
		}else{
	    	window.parent.returnValue  = returnjson;
	    	window.parent.close();
		}
	}
}
function submitData(){
	SearchForm.submit();
}

function submitClear()
{
	btnclear_onclick();
}

function nextPage(){
	document.all("pagenum").value=parseInt(document.all("pagenum").value)+1 ;
	SearchForm.submit();	
}

function perPage(){
	document.all("pagenum").value=document.all("pagenum").value-1 ;
	SearchForm.submit();
}

function searchReset() {
	$("input[name='treename']").val("");
	$("#appid").attr("selectedIndex", 0);
	submitData();
}
</script>


