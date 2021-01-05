
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.RecordSetDataSource" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.workflow.dmlaction.*"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="FieldBase" class="weaver.workflow.dmlaction.commands.bases.FieldBase" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<HTML><HEAD>
<link href="/css/Weaver_wev8.css" rel="stylesheet" type="text/css" >
<link rel="stylesheet" href="/wui/common/jquery/plugin/zTree/css/zTreeStyle/zTreeStyle_wev8.css" type="text/css">
<LINK REL=stylesheet type=text/css HREF="/css/Weaver_wev8.css"></HEAD>
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css" type="text/css" />
<%
String formid = Util.null2String(request.getParameter("formid"));
String isbill = Util.null2String(request.getParameter("isbill"));
String fieldname = Util.null2String(request.getParameter("fieldname")).trim();
String fieldtype = Util.null2String(request.getParameter("fieldtype"));
String issearch = Util.null2String(request.getParameter("issearch"));

String showdetail = Util.null2String(request.getParameter("showdetail"));   //需要操作的是流程的明细表,显示明细表字段用于选择
String tableid = Util.null2String(request.getParameter("tableid"));   //明细表id

%>
<BODY>
<div class="zDialog_div_content">
    <DIV align=right>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
//RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onSubmit(),_self} " ;
//RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:onClear(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" onclick="onSubmit()" class="e8_btn_top" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"></input>
			<span title="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="/workflow/dmlaction/dmlFormFieldsBrowser.jsp" method=post>
	<input type="hidden" name=formid value="<%=formid %>">
	<input type="hidden" name=isbill value="<%=isbill %>">
	<input type="hidden" name=issearch value="1">
	<input type="hidden" name="showdetail" value="<%=showdetail%>">
	<input type="hidden" name="tableid" value="<%=tableid%>">
	<wea:layout type="4col">
		<wea:group context='<%= SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>' attributes="{'groupSHBtnDisplay':'none'}">
			<wea:item><%=SystemEnv.getHtmlLabelName(606,user.getLanguage())%></wea:item>
			<wea:item>
				<input type=text size=20 class=inputstyle maxlength=20 id="fieldname" name="fieldname" value="<%=fieldname%>">
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></wea:item>
			<wea:item>
				<SELECT class=InputStyle name="fieldtype"><!-- 选择类型 -->
			  		<option value=""></option> 
					<option value="1" <%if("1".equals(fieldtype)){out.print("selected");} %>><%=SystemEnv.getHtmlLabelName(83678,user.getLanguage())%></option><!-- 表单数据 -->
					<option value="2" <%if("2".equals(fieldtype)){out.print("selected");} %>><%=SystemEnv.getHtmlLabelName(83679,user.getLanguage())%></option><!-- 请求数据 -->
					<option value="3" <%if("3".equals(fieldtype)){out.print("selected");} %>><%=SystemEnv.getHtmlLabelName(83680,user.getLanguage())%></option><!-- 节点操作者数据 -->
				</SELECT> 
			</wea:item>
		</wea:group>
	</wea:layout>
	<wea:layout>
	<wea:group context='<%= SystemEnv.getHtmlLabelName(33046,user.getLanguage())%>'>
	    <wea:item attributes="{'colspan':'full','isTableList':'true'}">
		<% 
			String PageId = "dmlFormFieldsBrowser";
			String tableString=""+
							"<table  datasource=\"weaver.workflow.action.ActionDataSource.getDMLFormField\" sourceparams=\"formid:"+formid+"+isbill:"+isbill+"+fieldname:"+fieldname+"+fieldtype:"+fieldtype+"+issearch:"+issearch+"+showdetail:" + showdetail + "+tableid:" + tableid + "\" instanceid=\"Table\" pagesize=\""+PageIdConst.getPageSize(PageId,user.getUID())+"\" tabletype=\"none\">"+
							    " <checkboxpopedom  id=\"none\" />"+
							   "<sql backfields=\"*\"  sqlform=\"tmptable\" sqlorderby=\"id\"  sqlprimarykey=\"id\" sqlsortway=\"asc\"  sqldistinct=\"true\" />"+
							   "<head>"+
									 "<col width=\"0%\" hide=\"true\" transmethod=\"weaver.general.KnowledgeTransMethod.forHidden\" text=\"\" column=\"bean\"/>"+
									 "<col width=\"50%\" hide=\"false\" transmethod=\"weaver.general.KnowledgeTransMethod.forHtml\" text=\""+SystemEnv.getHtmlLabelName(15456,user.getLanguage())+"\" column=\"jfieldlabel\"/>"+
									 "<col width=\"50%\" hide=\"false\" transmethod=\"weaver.general.KnowledgeTransMethod.forHtml\" text=\""+SystemEnv.getHtmlLabelName(685,user.getLanguage())+"\" column=\"jfieldname\"/>"+
									 "<col width=\"50%\" hide=\"false\" transmethod=\"weaver.general.KnowledgeTransMethod.forHtml\" text=\""+SystemEnv.getHtmlLabelName(686,user.getLanguage())+"\" column=\"jfielddbtype\"/>"+
									 "<col width=\"50%\" hide=\"false\" transmethod=\"weaver.general.KnowledgeTransMethod.forHtml\" text=\""+SystemEnv.getHtmlLabelName(83682,user.getLanguage())+"\" column=\"fielddesc\"/>"+
								"</head>"+
							   "</table>";
		%>
			<wea:SplitPageTag  tableString='<%=tableString%>' isShowTopInfo="false"  mode="run"/>
			<input type="hidden" name="pageId" id="pageId" value="<%=PageId %>"/>
		</wea:item>
		</wea:group>
	</wea:layout>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	    <wea:layout needImportDefaultJsAndCss="false">
			<wea:group context=""  attributes="{'groupDisplay':'none'}">
				<wea:item type="toolbar">
			    	<input type="button" class=zd_btn_cancle accessKey=2  id=btnclear value="2-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" onclick='onClear();'></input>
	        		<input type="button" class=zd_btn_cancle accessKey=T  id=btncancel value="T-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" onclick='closeDialog();'></input>
				</wea:item>
			</wea:group>
		</wea:layout>
		<script type="text/javascript">
			jQuery(document).ready(function(){
				resizeDialog(document);
			});
		</script>
	</div>
</FORM>
</DIV>
</BODY>
</HTML>

<script type="text/javascript">
	try{
		parent.setTabObjName("<%=SystemEnv.getHtmlLabelName(83684,user.getLanguage())%>");
	}catch(e){
		if(window.console)console.log(e);
	}
</script>
<script language="javascript">
var parentWin = null;
var dialog = null;
try{
	parentWin = parent.parent.getParentWindow(parent);
	dialog = parent.parent.getDialog(parent);
}
catch(e)
{}
function afterDoWhenLoaded(){
	//hideTH();
	jQuery(".ListStyle").children("tbody").find("tr[class!='Spacing']").bind("click",function(){
		//alert('sdfsdfdf');
		//alert($(this).find("td:first").text())
		//alert($(this).find("td:first").next().next().text()+"  - "+$(this).find("td:first").next().next().next().text()+" - "+$(this).find("td:first").next().next().next().next().text())
		var jsonval = jQuery(this).find("td:eq(1)>input").val();    //这个隐藏域中存储了一个字段信息的json
		//var returnjson = {id:$(this).find("td:first").next().next().text(),name:$(this).find("td:first").next().next().next().text(),a1:$(this).find("td:first").next().next().next().next().text()};
		var returnjson = eval('(' + jsonval + ')');
		returnjson.id = returnjson.labelname;
		returnjson.name = returnjson.fieldname;
		if(dialog){
		    dialog.callback(returnjson);
		}else{  
		    window.parent.returnValue  = returnjson;
		    window.parent.close();
		}		
	});
	/*if(dialog){
    	dialog.callback({
   		 id:jQuery(curTr.cells[0]).text(),
   		 name:jQuery(curTr.cells[1]).text(),
   		 a1:jQuery(curTr.cells[2]).text()});
	}else{
	    window.parent.returnValue = {
   		 id:jQuery(curTr.cells[0]).text(),
   		 name:jQuery(curTr.cells[1]).text(),
   		 a1:jQuery(curTr.cells[2]).text()
      };
      window.parent.close();
	}*/
};


function submitClear()
{
	var returnjson ={id:"",name:"",type:""};
	if(dialog){
	    dialog.callback(returnjson);
	}else{  
	    window.parent.returnValue  = returnjson;
	    window.parent.close();
	}
}

function btnclear_onclick(){
	var returnjson = {id:"",name:"",type:""};
	if(dialog){
	    dialog.callback(returnjson);
	}else{  
	    window.parent.returnValue  = returnjson;
	    window.parent.close();
	}	
}


function onClear()
{
	btnclear_onclick() ;
}
function onSubmit()
{
	SearchForm.submit();
}
function closeDialog()
{	
	if(dialog){
		dialog.close();
	}else{
		window.parent.close() ;
	}
}
</script>
