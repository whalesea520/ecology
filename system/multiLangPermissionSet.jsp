
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<%@ taglib uri="/browserTag" prefix="brow"%>
<HTML><HEAD>

<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script type="text/javascript">
var dialog = parent.parent.getDialog(parent);
function onBtnSearchClick(){
	jQuery("#searchfrm").submit();
}

jQuery(document).ready(function(){
	jQuery(".e8tips").wTooltip({html:true});
});

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
			url:"/system/MultiLangPermissionSetOperation.jsp",
			type:"post",
			dataType:"json",
			data:{
				operation:"delete",
				ids:id
			},
			beforeSend:function(){
				e8showAjaxTips("<%=SystemEnv.getHtmlLabelName(33592,user.getLanguage())%>",true);
			},
			complete:function(){
				e8showAjaxTips("",false);
			},
			success:function(data){
				if(data.result==1){
					_table.reLoad();
				}else{
					top.Dialog.alert("删除失败！");
				}
			}
		});
	});
}

var dialog = null;

function setList(type){
	if(type==1){
		changeSwitchStatus("#whiteList",false);
	}else{
		changeSwitchStatus("#blackList",false);
	}
	window.location.href="/system/multiLangPermissionSet.jsp?wbList="+type;
}

function doSave(){
	var checked = jQuery("input[class='listClass']:checked").val();
	jQuery.ajax({
		url:"/system/MultiLangPermissionSetOperation.jsp",
		type:"post",
		dataType:"json",
		data:{
			operation:"save",
			wbList:checked
		},
		beforeSend:function(){
			e8showAjaxTips("<%=SystemEnv.getHtmlLabelName(33592,user.getLanguage())%>",true);
		},
		complete:function(){
			e8showAjaxTips("",false);
		},
		success:function(data){
			if(data.result==1){
				top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22619,user.getLanguage())%>");
			}else{
				top.Dialog.alert("保存失败！");
			}
		}
	});
}

function addResource(){
	var checked = jQuery("input[class='listClass']:checked")
	if(checked.length>0){
		jQuery("button.e8_browflow").trigger("click");
	}else{
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(33592,user.getLanguage())%>");
	}
}

function afterSelectResource(e,datas,name,params){
	if(datas){
		if(datas.id){
			var checked = jQuery("input[type='checkbox']:checked").val();
			jQuery.ajax({
				url:"/system/MultiLangPermissionSetOperation.jsp",
				type:"post",
				dataType:"json",
				data:{
					operation:"add",
					resourceids:datas.id,
					wbList:checked
				},
				beforeSend:function(){
					e8showAjaxTips("<%=SystemEnv.getHtmlLabelName(33592,user.getLanguage())%>",true);
				},
				complete:function(){
					e8showAjaxTips("",false);
				},
				success:function(data){
					if(data.result==1){
						_table.reLoad();
					}else{
						top.Dialog.alert("添加失败！");
					}
				}
			});
		}
	}
}

</script>
<script language=javascript src="/js/ecology8/docs/docSearchInit_wev8.js"></script>
<script language=javascript src="/js/ecology8/docs/docExt_wev8.js"></script>
</head>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(93,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(65,user.getLanguage());
String needfav ="1";
String needhelp ="";
String qname = Util.null2String(request.getParameter("flowTitle"));
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(HrmUserVarify.checkUserRight("SystemSetEdit:Edit", user)){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
 %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form action="" name="searchfrm" id="searchfrm">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<%if(HrmUserVarify.checkUserRight("SystemSetEdit:Edit", user)){ %>
				<input type=button class="e8_btn_top" onclick="doSave()" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>"></input>
			<%}%>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
</form>

<%					
	String  operateString= "";
	String sql = "select wbList from SystemSet";
	int wbList = 0;
	int wbListp = Util.getIntValue(request.getParameter("wbList"),-1);
	if(wbListp==-1){
		RecordSet.executeSql(sql);
		if(RecordSet.next()){
			wbList = Util.getIntValue(RecordSet.getString(1),0);
		}
	}else{
		wbList = wbListp;
	}
	String sqlWhere = "wbList=0";
	if(wbList==1){
		sqlWhere = "wbList=1";
	}
	operateString = "<operates width=\"20%\">";
	 	       operateString+=" <popedom></popedom> ";
	 	       operateString+="     <operate isalwaysshow=\"true\" href=\"javascript:doDel()\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" index=\"0\"/>";
	 	       operateString+="</operates>";	
	 String tabletype="checkbox";
	String tableString=""+
	   "<table pageId=\""+PageIdConst.SYS_MULTILANGPERMISSIONLIST+"\" instanceid=\"docMouldTable\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.SYS_MULTILANGPERMISSIONLIST,user.getUID())+"\" tabletype=\""+tabletype+"\">"+
	   "<sql backfields=\"*\" sqlwhere=\""+sqlWhere+"\" sqlform=\"multilang_permission_list\" sqlorderby=\"id\"  sqlprimarykey=\"id\" sqlsortway=\"asc\"  sqldistinct=\"true\" />"+
	   operateString+
	   "<head>"+							 
			 "<col width=\"20%\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getName\" otherpara=\"1\" text=\""+SystemEnv.getHtmlLabelName(413,user.getLanguage())+"\" column=\"userid\"/>"+
			 "<col width=\"30%\"  transmethod=\"weaver.splitepage.transform.SptmForDoc.getDepartmentName\" column=\"userid\" text=\""+SystemEnv.getHtmlLabelName(27511,user.getLanguage())+"\"/>"+
			 "<col width=\"30%\"  transmethod=\"weaver.splitepage.transform.SptmForDoc.getSubcompanyName\" text=\""+SystemEnv.getHtmlLabelName(33553,user.getLanguage())+"\" column=\"userid\"/>"+
	   "</head>"+
	   "</table>";
%> 
<input type="hidden" name="pageId" id="pageId" _showCol="false" value="<%= PageIdConst.SYS_MULTILANGPERMISSIONLIST %>"/>
<div style="display:none">
	<brow:browser name="resourceids" viewType="0" isMustInput="1" browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/resource/MutiResourceBrowser.jsp" _callback="afterSelectResource"></brow:browser>
</div>
<div class="zDialog_div_content">
<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelNames("34032,599",user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelNames("34037",user.getLanguage())%></wea:item>
		<wea:item><input type="checkbox" class="listClass" name="whiteList" onclick="setList(0);" id="whiteList" value="0" tzCheckbox="true" <%=wbList==0?"checked":"" %>></input>
		<span class="e8tips" title="<%=SystemEnv.getHtmlLabelNames("34043",user.getLanguage()) %>"><img src="/images/tooltip_wev8.png" align="absMiddle"/></span>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("31859",user.getLanguage())%></wea:item>
		<wea:item><input type="checkbox" class="listClass" name="blackList" id="blackList" onclick="setList(1);" value="1" tzCheckbox="true" <%=wbList==1?"checked":"" %>></input>
			<span class="e8tips" title="<%=SystemEnv.getHtmlLabelNames("34045",user.getLanguage()) %>"><img src="/images/tooltip_wev8.png" align="absMiddle"/></span>
		</wea:item>
	</wea:group>
	<wea:group context='<%=SystemEnv.getHtmlLabelNames("34038",user.getLanguage())%>'>
		<wea:item type="groupHead">
			<input type="button" class="addbtn" title="<%= SystemEnv.getHtmlLabelName(611,user.getLanguage())%>" onclick="addResource();"/>
			<input type="button" class="delbtn" title="<%= SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" onclick="doDel();"/>
		</wea:item>
		
		<wea:item attributes="{'isTableList':'true'}">
			<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run"  />
		</wea:item>
	</wea:group>
</wea:layout>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
    <wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
			<wea:item type="toolbar">
		    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand()">
			</wea:item>
		</wea:group>
	</wea:layout>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
</div>
</BODY>
</HTML>
