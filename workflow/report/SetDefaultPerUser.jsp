
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
   if(!defaultval.equals("")){
	   String[] arr=defaultval.split("~");
	   //System.out.println(arr.length);
	   val1=arr[0];
	   if(arr.length>1)
	        val2=arr[1];
   }
%>


<BODY scroll="auto">
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="workflow"/>
   <jsp:param name="navName" value="<%=title%>"/>
</jsp:include>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
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
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(16261,user.getLanguage())%>'>
	<wea:item><%=SystemEnv.getHtmlLabelName(23243,user.getLanguage())%></wea:item>
	<wea:item>
	   <select id=defaulttype name=defaulttype>
			<OPTION value="0"  <%if(val1.equals("0")){%>selected="selected"<%}%>><%=SystemEnv.getHtmlLabelName(353, user.getLanguage())%></OPTION>
			<OPTION value="1"  <%if(val1.equals("1")){%>selected="selected"<%}%>><%=SystemEnv.getHtmlLabelName(21473, user.getLanguage())%></OPTION>
	   </select>
	</wea:item>
	<wea:item><%=SystemEnv.getHtmlLabelName(19206,user.getLanguage())%></wea:item>
	<wea:item>   
	    <select id=defaultval name=defaultval>
			<OPTION value="0"  <%if(val2.equals("0")){%>selected="selected"<%}%>><%=SystemEnv.getHtmlLabelName(332, user.getLanguage())%></OPTION>
			<OPTION value="1"  <%if(val2.equals("1")){%>selected="selected"<%}%>><%=SystemEnv.getHtmlLabelName(20558, user.getLanguage())%></OPTION>
			<OPTION value="3"  <%if(val2.equals("2")){%>selected="selected"<%}%>><%=SystemEnv.getHtmlLabelName(81811, user.getLanguage())%></OPTION>
	   </select>
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
	    var val1 = document.all("defaulttype").value;
	    var val2 = document.all("defaultval").value;
	    var val = val1+"~"+val2
        var returnjson = {id:val,name:""};
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
