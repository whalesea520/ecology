
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<HTML>
<HEAD>
	<TITLE></TITLE>
</HEAD>
<style>
.sbSelector{
font-size: 12px;
}
</style>
<BODY>
 <%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	<FORM NAME=SearchForm id="SearchForm" STYLE="margin-bottom:0" action="/formmode/tree/CustomTreeRight.jsp" method="get" target="contentframe">
		<div style="height: 20px;"></div>
		<table align="center" >
			<tr>
				<td style="font-size: 12px;"><%=SystemEnv.getHtmlLabelName(82080,user.getLanguage())%></td><!-- 请选择预览样式: -->
				<td style="width:95px;">
					<select id="previewType" name="previewType">
						<option value="1"><%=SystemEnv.getHtmlLabelName(28626,user.getLanguage())%></option><!-- 单选 -->
						<option value="2"><%=SystemEnv.getHtmlLabelName(28627,user.getLanguage())%></option><!-- 多选 -->
					</select>
				</td>
			</tr>
		</table>
		
	</FORM>
	
		<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout type="2col" needImportDefaultJsAndCss="false">
		<wea:group context="">
			<wea:item type="toolbar">
			<input type="button" class=zd_btn_submit  id=btnok onclick="onSave();" value="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%>"><!-- 确定 -->
    		<input type="button" class=zd_btn_submit  id=btncancel onclick="btncancel_onclick();" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>"><!-- 取消 -->
</wea:item>
</wea:group>
</wea:layout>
</div>
</BODY>
	<SCRIPT type="text/javascript">
	var parentWin = window.parent.parent.getParentWindow(parent);
	var dialog = window.parent.parent.getDialog(parent);
	if(!dialog){
		parentWin = window.parent.parent;
		dialog = window.parent.parent.getDialog(window);
	}
	
	function onSave() {
		var previewType = $("#previewType").val();
		var returnjson = {id:previewType, name:previewType};
        if(dialog){
			 try{
			     dialog.callback(returnjson);
			 }catch(e){}
			 
			 try{
			     dialog.close(returnjson);
			 }catch(e){}
		    
		}
    }
    
    function btncancel_onclick(){
     	if(dialog){
		    dialog.close();
		}else{  
		    window.parent.parent.close();
		}
    }
    
	
	</SCRIPT>
</HTML>