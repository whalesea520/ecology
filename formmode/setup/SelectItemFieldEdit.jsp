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
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />


<jsp:useBean id="FormComInfo" class="weaver.workflow.form.FormComInfo" scope="page" />

<HTML><HEAD>
<%
int fieldid = Util.getIntValue(Util.null2String(request.getParameter("fieldid")),-1);
int formid = 0;
String sql = "select * from workflow_billfield where id="+fieldid;
rs.executeSql(sql);
int selectitem = 0;
int linkfield = 0;
String selectitemname = "";
String linkfieldStr = "";
String detailtable = "";
if(rs.next()){
	selectitem = Util.getIntValue(rs.getString("pubchoiceid"),0);
	linkfield = Util.getIntValue(rs.getString("linkfield"),0);
	formid = Util.getIntValue(rs.getString("billid"),0);
	detailtable = rs.getString("detailtable");
}
String selectitemStr = selectitem+"";
if(selectitem>0){
	String selectSql = "select a.id,a.selectitemname from mode_selectitempage a where a.id="+selectitem+" ";
	rs.executeSql(selectSql);
	while(rs.next()){
		selectitemname = rs.getString("selectitemname");
	}
}
if(linkfield>0){
	 String selectSql = "select a.id,b.labelname from workflow_billfield a,HtmlLabelInfo b where a.id="+linkfield+" and a.fieldlabel=b.indexid and b.languageid="+user.getLanguage();
	 rs.executeSql(selectSql);
	 if(rs.next()){
		 linkfieldStr = rs.getString("labelname");
	 }
}
%>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<link href="/formmode/css/formmode_wev8.css" type="text/css" rel="stylesheet" />
</HEAD>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:submitData(),_top} " ;//确定
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:submitCancel(),_top} " ;//取消
RCMenuHeight += RCMenuHeightStep ;
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<FORM NAME=SearchForm action="SelectItemBrowser.jsp" method=post>
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
				 <TD width=20% class="e8_tblForm_label"><!--  选择项名称 -->
				 	<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>
				 </TD>
				 <TD width=30% class="e8_tblForm_field">
					<brow:browser name="selectType" viewType="0" isMustInput="1" browserUrl="/formmode/setup/SelectItemBrowser.jsp?fromDialog=1" completeUrl="/data.jsp?type=pubChoice" hasInput="true" isSingle="true" browserValue="<%=selectitemStr %>"  browserSpanValue="<%=selectitemname %>" />
				 </TD>
			    </TR>
			    <TR>
				    <TD width=20% class="e8_tblForm_label"><!--  选择项名称 -->
					 	<%=SystemEnv.getHtmlLabelName(22662,user.getLanguage())%>
					 </TD>
					  <TD width=30% class="e8_tblForm_field">
					  	<button type='button' id='showChildFieldBotton' class=Browser onClick="onShowChildField('linkfield','linkfieldSpan')"></BUTTON>
		 		        <span id='linkfieldSpan'><%=linkfieldStr %></span>
		 		        <input type='hidden'  name='linkfield' id='linkfield' value="<%=linkfield %>">
					  </TD>
			    </TR>
			  </table>
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
var parentWin = parent.parent.getParentWindow(parent);
var dialog = parent.parent.getDialog(parent);

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

jQuery(document).ready(function(){
	$(".loading", window.document).hide();
})
function submitData(){
	var selectType = jQuery("#selectType").val();
	var selectTypeText = jQuery("#selectTypespan span a").text();
	var linkfield = jQuery("#linkfield").val();
	var linkfieldText = "<%=SystemEnv.getHtmlLabelName(22662,user.getLanguage())%>:"+jQuery("#linkfieldSpan").html();
	if((selectType==""||selectType=="0")&&linkfield==""){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(128174, user.getLanguage()) %>");
		return;
	}
	
	var returnjson = {
		id:"<%=fieldid%>",
		selectType:selectType,
		selectTypeText:selectTypeText,
		linkfield:linkfield,
		linkfieldText:linkfieldText
	};
		if(dialog){
			 try{
			     dialog.callback(returnjson);
			 }catch(e){}
			 
			 try{
			     dialog.close(returnjson);
			 }catch(e){}
		}else{  
			window.parent.parent.returnValue=returnjson;
			window.parent.parent.close();
		}
}

function submitCancel(){
	if(dialog){
		dialog.close();
	}else{
		window.parent.close()
	}
}

function onShowChildField(inputname,spanname) {
	var oldvalue = $G(inputname).value
	var detailTableSql = "";
	var isdetail = 0;
	if("<%=detailtable%>"!=""){
		isdetail = 1;
	}
	if(isdetail==1){
		detailTableSql = " and detailtable='<%=detailtable%>' ";
	}
	var url = escape("/workflow/workflow/fieldBrowser.jsp?sqlwhere=where fieldhtmltype=5 and (pubchoiceid is not null or pubchoiceid!='') and billid=<%=formid%> and id!=<%=fieldid%> " + detailTableSql + "&isdetail=" + isdetail + "&isbill=1")+" ";
	$('#_DialogDiv_SeleteItemDialog_3').css('z-index',1002);
	__browserNamespace__.showModalDialogForBrowser(event,"/systeminfo/BrowserMain.jsp?url=" + url,'#','hrefid',true,1,'',
			{name:'hrefid',hasInput:false,zDialog:true,needHidden:true,dialogTitle:'<%=SystemEnv.getHtmlLabelName(22662,user.getLanguage())%>',dialogWidth:600,arguments:'dialogWidth=500px',
			_callback:function(event,datas,name,_callbackParams){
				var rid = wuiUtil.getJsonValueByIndex(datas, 0);
				var rname = wuiUtil.getJsonValueByIndex(datas, 1);
				if (rid != "") {
					$G(inputname).value = rid;
					$G(spanname).innerHTML = rname;
				} else {
					$G(inputname).value = "";
					$G(spanname).innerHTML = "";
				}
	}});
}

function showModalDialogSelectItem(objid,objSpanid){
	var url = "/formmode/setup/SelectItemBrowser.jsp";
	url = escape(url);
	var myid = showModalDialog("/systeminfo/BrowserMain.jsp?url=" + url);
	if(myid){
		if (wuiUtil.getJsonValueByIndex(myid,0) != "") {
            	var ids = wuiUtil.getJsonValueByIndex(myid,0);
				var names = wuiUtil.getJsonValueByIndex(myid, 1);
				jQuery(objid).val(ids);
				jQuery(objSpanid).val(jQuery(names).text());
            }else{
				jQuery(objid).val("");
				jQuery(objSpanid).val("");
            }
	}
}
</script>