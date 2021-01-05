
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="BaseBean" class="weaver.general.BaseBean" scope="page" />
<jsp:useBean id="DocFTPConfigComInfo" class="weaver.docs.category.DocFTPConfigComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("WorkflowManage:All", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
}
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
String id = Util.null2String(request.getParameter("id"));
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/weaver_wev8.js"></script>
<script language=javascript >

var parentWin = parent.parent.getParentWindow(parent);
var dialog = parent.parent.getDialog(parent);
if("<%=isclose%>"=="1"){
	try{
		parentWin._table.reLoad();
	}catch(e){}
	dialog.close();	
}
function onSave(){
	if(check_form(weaver,"label")){
		weaver.submit();
	}
}

</script>

<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(65,user.getLanguage());
String needfav ="1";
String needhelp ="";
int linkType = 1;
rs.executeSql("select * from workflow_processdefine where id="+id);
String label = "";
String sortorder = "0.00";
int showlabelid = -1;
String nameSim = "";
String nameEn = "";
String nameTrand = "";
int isSys = 0;
if(rs.next()){
	label = Util.null2String(rs.getString("label"));
	sortorder = rs.getString("sortorder");
	showlabelid = Util.getIntValue(rs.getString("shownamelabel"),-1);
	isSys = Util.getIntValue(rs.getString("isSys"),0);
	if(showlabelid!=-1){
		nameSim = SystemEnv.getHtmlLabelName(showlabelid,7,true);
		nameEn = SystemEnv.getHtmlLabelName(showlabelid,8,true);
		nameTrand = SystemEnv.getHtmlLabelName(showlabelid,9,true);
	}
	linkType = Util.getIntValue(rs.getString("linktype"),1);
}

%>
<script type="text/javascript">
	try{
		parent.setTabObjName("<%=label+SystemEnv.getHtmlLabelNames("33691,22409",user.getLanguage())%>");
	}catch(e){
	}
	var isDefaultPlugin = {
		type:"checkbox",
		addIndex:false,
		options:[
			{text:"",value:"1",name:"isdefault"},
		],
		bind:[
			{type:"click",fn:function(){
					var isdefault = jQuery(this).attr("checked")?"1":"0";
					var id = jQuery(this).closest("tr").children("td:first").find("input[type='checkbox']").attr("checkboxid");
					jQuery.ajax({
						url:"/workflow/workflow/officalwf_operation.jsp",
						type:"post",
						dataType:"json",
						data:{
							wfid:id,
							isdefault:isdefault,
							pdid:<%=id%>,
							operation:"setProcessInstDefault"
						},
						beforeSend:function(){
							e8showAjaxTips("<%=SystemEnv.getHtmlLabelName(33592,user.getLanguage())%>",true);
						},
						complete:function(){
							e8showAjaxTips("",false);
						},
						success:function(data){
							_table.reLoad();
						}
					});
				}
			}]
	};
	
	function afterDoWhenLoaded(){
		dialog.getPageData(dialog,"initData",0);
	}
	function openDialog(id){
		var dialog = new window.top.Dialog();
		dialog.currentWindow = window;
		var url = "/workflow/workflow/UserPhraseEdit.jsp?pdid=<%=id%>"
		if(id) url += ('&id=' + id);	
		
		var title = "<%= SystemEnv.getHtmlLabelName(22409,user.getLanguage())%>";
		dialog.Title = id? ("<%= SystemEnv.getHtmlLabelName(26473,user.getLanguage())%>" + title) : ("<%= SystemEnv.getHtmlLabelName(611,user.getLanguage())%>" + title);
		dialog.Width = 850;
		dialog.Height = 500;
		dialog.Drag = true;
		dialog.URL = url;
		dialog.show();
	}
	function doDel(id){
	if(!id){
		id = _xtable_CheckedCheckboxId();
	}
	if(!id){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32568,user.getLanguage())%>");
		return;
	}
	if(id.match(/,$/)){
		id = id.substring(0,id.length-1);
	}
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(33435,user.getLanguage())%>",function(){
		jQuery.ajax({
			url:"/workflow/workflow/officalwf_operation.jsp",
			type:"post",
			dataType:"json",
			data:{
				wfid:id,
				operation:"delProcessInst"
			},
			beforeSend:function(){
				e8showAjaxTips("<%=SystemEnv.getHtmlLabelName(33592,user.getLanguage())%>",true);
			},
			complete:function(){
				e8showAjaxTips("",false);
			},
			success:function(data){
				_table.reLoad();
			}
		});
	});
}
</script>
</head>
<BODY>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(!"1".equals(isDialog)){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:window.history.go(-1),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
}else{
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>



<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>

<FORM id=weaver name="weaver" action="processOperation.jsp" method=post>
	<wea:layout>
		<wea:group context='<%= SystemEnv.getHtmlLabelName(22409,user.getLanguage())%>'>
			<wea:item type="groupHead">
				<input type=button class=addbtn onclick="openDialog()" title="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>"></input>
				<input type=button class=delbtn onclick="doDel();" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>"></input>
			</wea:item>
			<wea:item attributes="{'isTableList':'true'}">
				<%
	String  operateString= "";
	String sqlWhere = "pd_id = "+id;
	operateString = "<operates width=\"20%\">";
	 	       operateString+=" <popedom></popedom> ";
	 	       operateString+="     <operate isalwaysshow=\"true\" href=\"javascript:openDialog();\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" index=\"0\"/>";
	 	       operateString+="     <operate isalwaysshow=\"true\" href=\"javascript:doDel()\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" index=\"1\"/>";
	 	       operateString+="</operates>";	
	String tabletype = "checkbox";
	String tableString=""+
	   "<table  instanceid=\"docMouldTable\" needPage=\"false\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.WF_WORKFLOW_PROCESSINSTSET,user.getUID())+"\" tabletype=\""+tabletype+"\">"+
	   "<sql backfields=\"*\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlform=\"workflow_processinst\" sqlorderby=\"sortorder\"  sqlprimarykey=\"id\" sqlsortway=\"asc\"  sqldistinct=\"true\" />"+
	   operateString+
	   "<head>"+							 
			"		<col width='30%' name='phraseShort' text='"+SystemEnv.getHtmlLabelName(18774,user.getLanguage())+"' column='phraseShort'></col>"+
			"<col width='30%' name='phraseDesc' text='"+SystemEnv.getHtmlLabelName(18775,user.getLanguage())+"' column='phraseDesc' ></col>"+
			"<col width='10%' editPlugin=\"isDefaultPlugin\" name='isdefault' text='"+SystemEnv.getHtmlLabelName(33731,user.getLanguage())+"' column='isdefault' ></col>"+
	   "</head>"+
	   "</table>";
%> 
<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run"  />
			</wea:item>
		</wea:group>
	</wea:layout>
<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.WF_WORKFLOW_PROCESSINSTSET %>"/>
			<input type="hidden" name="isdialog" value="<%=isDialog%>">
		<input type="hidden" id = "id" name="id" value="<%=id %>">
          <input type=hidden value="processInstSet" name="src">
</FORM>
<%if("1".equals(isDialog)){ %>
	</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
				<wea:item type="toolbar">
			    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand()">
				</wea:item>
			</wea:group>
		</wea:layout>
	</div>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
<%} %>
</BODY></HTML>

