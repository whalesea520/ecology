<!DOCTYPE html>
<%@page import="weaver.formmode.exceldesign.HtmlLayoutOperate"%>
<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
	HtmlLayoutOperate htmlLayoutOperate = new HtmlLayoutOperate();
	int modeid = Util.getIntValue(request.getParameter("modeid"),0);
	int layouttype = Util.getIntValue(request.getParameter("layouttype"), -1);
	int from_layoutid = Util.getIntValue(request.getParameter("from_layoutid"), 0);
	int isdefault = Util.getIntValue(request.getParameter("isdefault"), 0);
	int isclose = Util.getIntValue(request.getParameter("isclose"), 0);
%>
<HTML>
<HEAD>
	<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
	<script type="text/javascript">
		var parentWin = parent.getParentWindow(window);
		var dialog = parent.getDialog(window);
		
		var isclose="<%=isclose %>";
		if(isclose=="1"){
			parentWin.location.reload();
		    dialog.close();
		}
	</script>
</HEAD>
<BODY>
<div class="zDialog_div_content" style="height: 100%!important;">
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:onSure(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
//RCMenu += "{"+SystemEnv.getHtmlLabelName(21738,user.getLanguage())+",javascript:onSyncAllNodes(),_top} " ;
//RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:onClose(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="workflow"/>
   <jsp:param name="navName" value="将模板引用到以下类型布局"/>
</jsp:include>
<TABLE id="browserTable" class=ListStyle cellspacing=0 STYLE="margin-top:0">
	<TR class=header>
		<TH width=20%><input type="checkbox" id="checklayouttype_all" name="checklayouttype_all"/></TH>
		<TH width=80%><%=SystemEnv.getHtmlLabelName(23721,user.getLanguage())%></TH>
	</tr>
	<%
	int rowNum=0;
	for(int to_layouttype=0;to_layouttype<=4;to_layouttype++){
		if(layouttype==to_layouttype)continue;
		//显示布局不能同步到新建、编辑布局
		if(layouttype == 0 && (to_layouttype == 1 || to_layouttype ==2)){
			continue;
		}
		//编辑布局不能同步到新建布局
		if(layouttype == 2 && to_layouttype == 1){
			continue;
		}
		//监控布局、打印布局不需要同步
		if(layouttype == 3 || layouttype == 4){
			continue;
		}
		
		String layouttypeDesc = htmlLayoutOperate.reflectLayoutType(to_layouttype+"", user.getLanguage()+"");
		if(rowNum%2==0){
		%>
		<TR class=DataLight>
		<%	}else{%>
		<TR class=DataDark>
		<%	}%>
		<TD>
		<input type="checkbox" name="checklayouttype" value="<%=to_layouttype %>" >
		</TD>	
	    <TD><%=layouttypeDesc%></TD>
		</TR>
		<%
		rowNum++;
	}
%>
</TABLE>
<FORM name="syncForm" action="excel_operation.jsp" method=post>
	<input type="hidden" name="operation" value="syncLayouttypes"/>
	<input type="hidden" name="modeid" value="<%=modeid %>"/>
	<input type="hidden" name="layouttype" value="<%=layouttype %>"/>
	<input type="hidden" name="isdefault" value="<%=isdefault %>"/>
	<input type="hidden" name="from_layoutid" value="<%=from_layoutid %>"/>
	<input type="hidden" name="to_layouttypes" />
</FORM>
<div id="submitloaddingdiv_out" style="display:none;background:#000;width:100%;height:100%;top:0px;left:0px; bottom:0px;right:0px;position:absolute;top:0px;left:0px;z-index:9999;filter:alpha(opacity=20);-moz-opacity:0.2;opacity:0.2;">
</div>
<span id="submitloaddingdiv" style="display:none;height:48px;border:1px solid #9cc5db;background:#ebf8ff;color:#4c7c9f;line-height:48px;width:217px;position:absolute;z-index:9999;font-size:12px;">
	<img src="/images/ecology8/workflow/multres/cg_lodding_wev8.gif" height="27px" width="57px" style="vertical-align:middle;"/><span style="margin-left:22px;">正在处理，请稍候...</span>
	<div style="display:none;"><img src="/wui/theme/ecology8/skins/default/rightbox/icon_query_wev8.png" /></div>
</span>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
    <wea:layout needImportDefaultJsAndCss="false">
		<wea:group context="" attributes="{'groupDisplay':'none'}">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%>" id="submitBtn" class="zd_btn_submit" onclick="onSure();">
		    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" id="cancelBtn" class="zd_btn_cancle" onclick="onClose();">
			</wea:item>
		</wea:group>
	</wea:layout>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
</div>
</div>
</BODY>
</HTML>
<script language="javascript">
jQuery(document).ready(function(){
	jQuery("#checklayouttype_all").click(function(){
		var state = jQuery("#checklayouttype_all").attr("checked");
		jQuery("input[name='checklayouttype']").each(function(){
			if(state){
				$(this).attr("checked",true).next().addClass("jNiceChecked");
			}else{
				$(this).attr("checked",false).next().removeClass("jNiceChecked");
			}
		});
	});
});
	
function onSure(){
	var obj=$("[name='checklayouttype']:checked");
	if(obj.size()==0){
		window.top.Dialog.alert("请选择需要同步节点");
	}else{
		__setloaddingeffect();
		
		var to_layouttypes="";
		obj.each(function(index){
			if(index!=0)	to_layouttypes +=",";
			to_layouttypes +=$(this).val();
		});
		$("[name='to_layouttypes']").val(to_layouttypes);
    	window.document.syncForm.submit();
    }
}

function onClose(){
	if(dialog){
	    dialog.close();
	}
}

function onSyncAllNodes(){
	window.top.Dialog.confirm("是否同步到所有节点？",function(){
		$("[name='checklayouttype']").attr("checked",true).next().addClass("jNiceChecked");
		onSure();
	});
}

function __setloaddingeffect() {
	try {
		var pTop= document.body.offsetHeight/2 - (50/2);
		var pLeft= document.body.offsetWidth/2 - (217/2);
		jQuery("#submitloaddingdiv").css({"top":pTop, "left":pLeft, "display":"inline-block;"});
		jQuery("#submitloaddingdiv").show();
		jQuery("#submitloaddingdiv_out").show();
	} catch (e) {}
}
</script>