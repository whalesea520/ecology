
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
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<script type="text/javascript" src="/js/selectDateTime_wev8.js"></script>
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
	String val1="";
	String val2="";
	String val3="";
	String val4="";
	if(!defaultval.equals("")&&type.equals("num")){
		   String[] arr=defaultval.split("~");
		   //System.out.println(arr.length);
		   val1=arr[0];
		   if(arr.length>1)
		        val2=arr[1];
		   if(arr.length>2)
			    val3=arr[2];
		   if(arr.length>3)
			    val4=arr[3];
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
	<wea:item><%=SystemEnv.getHtmlLabelName(129369, user.getLanguage())%></wea:item>
	<wea:item>
	   <select id=bottomtype name=bottomtype>
			<option value="1" <%if(val1.equals("1")){%>selected="selected"<%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
        	<option value="2" <%if(val1.equals("2")){%>selected="selected"<%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
        	<option value="3" <%if(val1.equals("3")){%>selected="selected"<%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
        	<option value="4" <%if(val1.equals("4")){%>selected="selected"<%}%> ><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
        	<option value="5" <%if(val1.equals("5")){%>selected="selected"<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
        	<option value="6" <%if(val1.equals("6")){%>selected="selected"<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
		</select>
	</wea:item>
	<wea:item><%=SystemEnv.getHtmlLabelName(129370, user.getLanguage())%></wea:item>
	<wea:item>
	   <span style="float: left;"><img class="timer"  src="../../images/time3_wev8.png" onclick="javascript:onWorkFlowShowTime(picktimestart, picktimestart, 0);"></span>
	   <input name="picktimestart" readonly="readonly" type="text" style="border: 0px;background-color: rgb(248,248,248);" size="6">
	</wea:item>
	<wea:item><%=SystemEnv.getHtmlLabelName(129371, user.getLanguage())%></wea:item>
	<wea:item>
	   <select id=toptype name=toptype>
			<option value="1" <%if(val3.equals("1")){%>selected="selected"<%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
        	<option value="2" <%if(val3.equals("2")){%>selected="selected"<%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
        	<option value="3" <%if(val3.equals("3")){%>selected="selected"<%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
        	<option value="4" <%if(val3.equals("4")){%>selected="selected"<%}%> ><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
        	<option value="5" <%if(val3.equals("5")){%>selected="selected"<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
        	<option value="6" <%if(val3.equals("6")){%>selected="selected"<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
		</select>
	</wea:item>
	<wea:item>
	   <%=SystemEnv.getHtmlLabelName(129372, user.getLanguage())%>
	</wea:item>
	<wea:item>
	   <span style="float: left;"><img class="timer" src="../../images/time3_wev8.png" onclick="javascript:onWorkFlowShowTime(picktimeend, picktimeend, 0);"></span>
	   <input name="picktimeend" readonly="readonly" type="text" style="border: 0px;background-color: rgb(248,248,248);" size="6">
	</wea:item>
	</wea:group>
</wea:layout>
</FORM>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
    <wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes='{\"groupDisplay\":\"none\"}'>
			<wea:item type="toolbar">
		    	<input type="button" accessKey=T  id=btncancel value="<%="T-"+SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="btnclose_onclick()">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</BODY></HTML>
<script language="javascript" >
//为了防止弹出时间

function doClick(){
  onWorkFlowShowTime(toptime, toptime, 0)
}

$(".timer").mouseover(function(){
    $(this).attr("src","../../images/time2_wev8.png");
});
$(".timer").mouseout(function(){
    $(this).attr("src","../../images/time3_wev8.png");
});

//清除
function btnclear_onclick(){
	var returnjson = {id:"",name:""};
<!--	if(dialog){-->
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
        var returnjson = {id:id,name:""};
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
