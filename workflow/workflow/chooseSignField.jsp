
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<%
  String selectedids=Util.null2String(request.getParameter("selectedids"));
  String ids[] = {"0","1","2","3","4","5","6"};
  String names[] = {SystemEnv.getHtmlLabelName(129433, user.getLanguage()),
		          SystemEnv.getHtmlLabelName(17482, user.getLanguage()),
		          SystemEnv.getHtmlLabelName(15070, user.getLanguage()),
		          SystemEnv.getHtmlLabelName(15390, user.getLanguage()),
		          SystemEnv.getHtmlLabelName(21663, user.getLanguage()),
		          SystemEnv.getHtmlLabelName(15502, user.getLanguage()),
		          SystemEnv.getHtmlLabelName(81454, user.getLanguage())};
%>
<script type="text/javascript">
	var parentWin = null;
	var dialog = null;
	try{
		parentWin = parent.parent.getParentWindow(parent);
		dialog = parent.parent.getDialog(parent);
	}catch(e){}
	
	$("#selall").click(function(){
	    alert("<%=SystemEnv.getHtmlLabelName(556, user.getLanguage())%>");
	    if($(this).is(":checked")){
	       $("input[name='fieldid']").each(function(){
				$(this).attr("checked","checked");
		   });
	    }else{
	       $("input[name='fieldid']").each(function(){
				$(this).removeAttr("checked");
		   });
	    }
	});
	function changstatus(obj){
       if($(obj).is(":checked")){
	       jQuery("input[name='fieldid']").each(function(){
	        	changeCheckboxStatus($(this),true);
		   });
       }else{
	       jQuery("input[name='fieldid']").each(function(){
	        	changeCheckboxStatus($(this),false);
		   });
       }
	}
</script>
</HEAD>
<BODY style="overflow:hidden">
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="workflow"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(33958, user.getLanguage())%>"/>
</jsp:include>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:btnok_onclick(),_top} " ;
RCMenuHeight += RCMenuHeightStep;

RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:btnclear_onclick(),_top} " ;
RCMenuHeight += RCMenuHeightStep;
%>

<div class="zDialog_div_content">
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="" method=post>
<DIV align=right style="display:none">
</DIV>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<wea:layout type="2col">
	<wea:group context="<%=SystemEnv.getHtmlLabelName(15935, user.getLanguage())%>">
		<wea:item attributes="{'isTableList':'true'}">
			<table class="ListStyle" id="oTable" cellspacing=0> 
				<colgroup>
					<col width="25%">
					<col width="75%">
				</colgroup>
				<tr class=header>
					<th>
						<input onclick="javascript:changstatus(this);" type="checkbox">
						<span><%=SystemEnv.getHtmlLabelName(556, user.getLanguage())%></span>
					</th>
					<th><%=SystemEnv.getHtmlLabelName(33958, user.getLanguage())%></th>
				</tr>
				<%
				for(int i=0;i<ids.length;i++){
				%>
					<tr>
						<td  height="23"><input type='checkbox' name='fieldid' id="field<%=i%>" value="<%=i%>" <%if(selectedids.contains(""+i+"")){%> checked <%}%> ></td>
						<td  height="23">
						  <a onclick='checkLine(<%=i%>)' id="field<%=i%>name"><%=names[i]%></a>
						</td>
					</tr>
					<tr class='Spacing' style="height:1px!important;"><td colspan=2 class='paddingLeft18'><div class='intervalDivClass'></div></td></tr> 
				<%}%>
			</table>	
		</wea:item>
	</wea:group>
</wea:layout>
</FORM>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
    <wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes='{\"groupDisplay\":\"none\"}'>
			<wea:item type="toolbar">
		    	<input type="button" value="<%="O-"
					+ SystemEnv.getHtmlLabelName(826, user.getLanguage())%>"
								id="zd_btn_submit_0" class="zd_btn_submit" onclick="btnok_onclick();">
							<input type="button" 
								value="<%="2-"
					+ SystemEnv.getHtmlLabelName(311, user.getLanguage())%>"
								id="zd_btn_submit" class="zd_btn_submit" onclick="btnclear_onclick();">
							<input type="button" accessKey=T id=btncancel
								value="<%="T-"
					+ SystemEnv.getHtmlLabelName(201, user.getLanguage())%>"
								id="zd_btn_cancle" class="zd_btn_cancle" onclick="btnclose_onclick();">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</BODY></HTML>

<script language="javascript" >
// 清除
function btnclear_onclick(){
	var returnjson = {id:"",name:""};
	if(dialog){
		try{
			dialog.callback(returnjson);
		}catch(e){
		}
		dialog.close(returnjson);
   	}else{ 
   	    window.parent.returnValue  = returnjson;
   	 	window.parent.close();
   	}
}
// 关闭
function btnclose_onclick(){
    if(dialog){
        try{
		dialog.close();
		}catch(e){
		}
	}else{
	    window.parent.close();
	}
}
// 保存
function btnok_onclick(){
    var printNodes="";
	var printNodesName="";
	var i=0;
	var temp=0;
	$("input[name='fieldid']").each(function(){
		if($(this).is(":checked")){
		    temp++;
			printNodes=printNodes+","+i;
			printNodesName=printNodesName+","+$("#field"+i+"name").html();
		}
		i++;
	});
	if(printNodes!=""){
		printNodes=printNodes.substr(1);
		printNodesName=printNodesName.substr(1);
	}
	//if(i == temp){
	//	printNodesName="全部";
	//}
	var returnjson  = {id:printNodes,name:printNodesName} ;
	if(dialog){
		dialog.callback(returnjson);
		dialog.close(returnjson);
	}else{  
		window.parent.returnValue  = returnjson;
		window.parent.close();
	}     
}
</script>