
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<script type="text/javascript">
	var dialog = parent.getDialog(window); 
	var parentWin = parent.getParentWindow(window);
	jQuery(document).ready(function(){
		resizeDialog(document);
	});
</script>
<% 
	String txtSql = Util.null2String(request.getParameter("txtSql"));
	String txtDocs = Util.null2String(request.getParameter("txtDocs"));
	String txtStatus = Util.null2String(request.getParameter("txtStatus"));
	String method = Util.null2String(request.getParameter("method"));
	int dummyId=Util.getIntValue(request.getParameter("txtDummy"),1);
	if(method.equals(""))method="add";
%>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="doc"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(20482,user.getLanguage()) %>"/>
</jsp:include>
<div class="zDialog_div_content">
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%

RCMenu += "{"+SystemEnv.getHtmlLabelName(20487,user.getLanguage())+",javascript:onImporting(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(20487,user.getLanguage())%>" id="zd_btn_submit_0" class="e8_btn_top" onclick="onImporting();">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<wea:layout attributes="{'layoutTableId':'tblSetting'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(20484,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(20482,user.getLanguage())%></wea:item>
		<wea:item>
			<span>
		        <brow:browser viewType="0" name='<%=method.equalsIgnoreCase("add")?"txtDummy":"tdummy" %>' 
		                browserUrl="/systeminfo/BrowserMain.jsp?url=/docs/category/DocTreeDocFieldBrowserMulti.jsp?para=#id#_1"
		                hasInput="false" isSingle="false" hasBrowser = "true" isMustInput="2" linkUrl="/docs/docdummy/DocDummyList.jsp?id=#id#&dummyId=#id#"
		                width="80%" temptitle='<%= SystemEnv.getHtmlLabelName(20482,user.getLanguage())%>'>
		        </brow:browser>
	       </span>
		</wea:item>
	</wea:group>
</wea:layout>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
			<wea:item type="toolbar">
		    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.close()">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>

<input type="hidden" id="txtSql"  name="txtSql" value="<%= txtSql %>">
<input type="hidden" id="txtDocs"  name="txtDocs" value="<%= txtDocs %>">
<input type="hidden" id="txtStatus"  name="txtStatus" value="<%= txtStatus %>">

<script language="javaScript">
	
   function onImporting(){
   		var txtDummy = jQuery("#<%=method.equals("add")?"txtDummy":"tdummy"%>").val();
   		if(!txtDummy || txtDummy==","){
   			window.top.Dialog.alert("\"<%=SystemEnv.getHtmlLabelName(20482,user.getLanguage())%>\""+"<%=SystemEnv.getHtmlLabelName(21423,user.getLanguage())%>");
   			return false;
   		}
	  	var actionUrl="/docs/search/DocUpToDummy.jsp?method=<%=method%>&txtDummy="+jQuery("#txtDummy").val()+"&txtSql="+txtSql.value+"&txtDocs="+txtDocs.value+"&txtStatus="+txtStatus.value;
		<%if(!method.equals("add")){%>
			actionUrl="/docs/search/DocUpToDummy.jsp?txtDummy=<%=dummyId%>&method=<%=method%>&tdummy="+jQuery("#tdummy").val()+"&txtDocs="+txtDocs.value;
		<%}%>	
		jQuery.ajax({
			url:actionUrl,
			type:"get",
			dataType:"text",
			beforeSend:function(){
				e8showAjaxTips("<%=SystemEnv.getHtmlLabelName(19819,user.getLanguage())+"..."%>",true);
			},
			complete:function(){
				e8showAjaxTips("",false);
			},
			success:function(msg){
				msg = msg.replace(/(^\s*)|(\s*$)/g, "");
				if(msg=="success"){
					<%if(!method.equals("add")){%>
						parentWin._table.reLoad();
					<%}%>
					top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(28450,user.getLanguage())%>");
					dialog.close();
				}else{
					top.Dialog.alert(txt);
				}
			}
		});
   }
   
</script>


