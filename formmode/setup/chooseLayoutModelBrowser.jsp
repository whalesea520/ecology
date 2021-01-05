<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<HTML>
<HEAD>
	<TITLE></TITLE>
	<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</HEAD>

<BODY>
 <%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<div style="background-color:#FFF;padding-left:17%">
			<div style="height:30px"></div>
			<div>
				<input type=radio name=layoutmodel value="0" checked onclick="layoutmodelClickFun()" /><%=SystemEnv.getHtmlLabelName(84089,user.getLanguage())%>
			</div>
			<div style="height:20px"></div>
			<div>
				<input type=radio name=layoutmodel value="2" onclick="layoutmodelClickFun()" /><%="excel"+SystemEnv.getHtmlLabelNames("19071,64",user.getLanguage())%>
			</div>
			<div style="height:10px"></div>
			<div id="initexcellayoutdiv" style="display:none;">
				<input type="checkbox" name="intiexcellayout" id="initexcellayout" value="1" /><%=SystemEnv.getHtmlLabelName(125556,user.getLanguage())%>
			</div>
		</div>
	
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
		var layoutmodel = $("input[name='layoutmodel']:checked").val();
		var initexcellayout = $("#initexcellayout").attr("checked");
		if(layoutmodel==0){
			initexcellayout = false;
		}
		var returnjson = {layoutmodel:layoutmodel,initexcellayout:initexcellayout};
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
    
    function layoutmodelClickFun(){
    	var layoutmodel = $("input[name='layoutmodel']:checked").val();
    	if(layoutmodel==0){
    		$("#initexcellayoutdiv").hide();
    		$("#initexcellayout").trigger("checked",false);
    	}else{
    		$("#initexcellayoutdiv").show();
    	}
    }
	</SCRIPT>
</HTML>