
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.docs.category.CategoryUtil" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>

<link type="text/css" href="/js/dragBox/e8browser_wev8.css" rel=stylesheet>
<script type="text/javascript">
	var parentWin = null;
	var dialog = null;
	try{
		parentWin = parent.parent.getParentWindow(parent);
		dialog = parent.parent.getDialog(parent);
	}catch(e){}
	function onClose(){
		 if(dialog){
	    	dialog.close()
	    }else{
		    window.parent.close();
		}
	}
</script>
</HEAD>


<%
   String title = Util.null2String(request.getParameter("title")); 
   String type = Util.null2String(request.getParameter("type"));
   String defaultval = Util.null2String(request.getParameter("defaultval"));
   String createdatestart="";
   String createdateend="";
   String val="";
   if(!defaultval.equals("")){
	   String[] arr=defaultval.split("~");
	   if(arr.length>0)
	   		val=arr[0];
	   if(arr.length>1)
	        createdatestart=arr[1];
	   if(arr.length>2)
	        createdateend=arr[2];
   }
%>


<BODY scroll="auto">
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="workflow"/>
   <jsp:param name="navName" value="<%=title%>"/>
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
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top"  onclick="btnok_onclick()"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" class="e8_btn_top"  onclick="btnclear_onclick()"/>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
	<wea:item><%=SystemEnv.getHtmlLabelName(19206,user.getLanguage())%></wea:item>
	<wea:item>
	   <select id=defaultval name=defaultval onchange="check_val()"> 
	   		<option></option>
			<OPTION value="0" <%if(val.equals("0")){%>selected="selected"<%}%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></OPTION>
			<OPTION value="1" <%if(val.equals("1")){%>selected="selected"<%}%>><%=SystemEnv.getHtmlLabelName(15537,user.getLanguage())%></OPTION>
			<OPTION value="2" <%if(val.equals("2")){%>selected="selected"<%}%>><%=SystemEnv.getHtmlLabelName(15539,user.getLanguage())%></OPTION>
			<OPTION value="3" <%if(val.equals("3")){%>selected="selected"<%}%>><%=SystemEnv.getHtmlLabelName(15541,user.getLanguage())%></OPTION>
			<OPTION value="4" <%if(val.equals("4")){%>selected="selected"<%}%>><%=SystemEnv.getHtmlLabelName(21904,user.getLanguage())%></OPTION>
			<OPTION value="5" <%if(val.equals("5")){%>selected="selected"<%}%>><%=SystemEnv.getHtmlLabelName(15384,user.getLanguage())%></OPTION>
			<OPTION value="6" <%if(val.equals("6")){%>selected="selected"<%}%>><%=SystemEnv.getHtmlLabelName(32530,user.getLanguage())%></OPTION>
		</select>
	</wea:item>
	<wea:item>
	          <%=SystemEnv.getHtmlLabelName(32530,user.getLanguage())%>
	</wea:item>
	<wea:item>
	      <span id="datepicker" style="display:none">
	                  <button type="button" class=Calendar id=selectbirthday
							onclick="getTheDate(createdatestart,createdatestartspan)"></BUTTON>
						<SPAN id=createdatestartspan><%=createdatestart%></SPAN>
			  - &nbsp;<button type="button" class=Calendar id=selectbirthday1
							onclick="getTheDate(createdateend,createdateendspan)"></BUTTON>
						<SPAN id=createdateendspan><%=createdateend%></SPAN>
						<input type="hidden" id=createdatestart name="createdatestart"
							value="<%=createdatestart%>">
						<input type="hidden" id=createdateend name="createdateend"
							value="<%=createdateend%>">
		 </span>
	</wea:item>
	</wea:group>
</wea:layout>
</FORM>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
    <wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes='{\"groupDisplay\":\"none\"}'>
			<wea:item type="toolbar">
		    	<input type="button" accessKey=S  id=btncancel value="<%="S-"+SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="btnclose_onclick()">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:btnok_onclick(),_top} " ;
RCMenuHeight += RCMenuHeightStep;

RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:btnclear_onclick(),_top} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<SCRIPT language="javascript" defer="defer"
	src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
</BODY></HTML>

<script language="javascript" >
function check_val(){
   if($("#defaultval").val()=='6'){
      $("#datepicker").css("display","");
   }else{
   	  $("#datepicker").css("display","none");
   }
}
//清除
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
//关闭
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
//保存
function btnok_onclick(){
        var id = document.all("defaultval").value;
        var datestart = document.all("createdatestart").value; 
        var dateend = document.all("createdateend").value; 
        var param="";
        if(id != "" || datestart != "" || dateend != "")
            param=id+"~"+datestart+"~"+dateend;
        var returnjson = {id:param,name:""};
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
</script>
