<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.fullsearch.util.RmiConfig"%>
<%@page import="weaver.fullsearch.util.CommentedProperties"%>
<%@page import="java.io.OutputStream"%>
<%@page import="java.io.FileOutputStream"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>

<%
//读取微搜配置文件信息
String analyzerProp=RmiConfig.getFilePath();
File ff=new File(analyzerProp);
CommentedProperties cprop=null;
if(ff.exists()){
	cprop=new CommentedProperties();
	cprop.load(ff,"GBK");
}else{
	rs.writeLog("配置文件不存");
}

String method=Util.null2String(request.getParameter("method"));

if("saveProp".equals(method)){
	Enumeration names=request.getParameterNames();
	while(names.hasMoreElements()){
		String name=(String)names.nextElement();
		if("method".equals(name)) continue;
		if(cprop!=null){
			cprop.setProperty(name,Util.null2String(request.getParameter(name)));
		}
	}
	OutputStream os=new FileOutputStream(new File(analyzerProp));
	cprop.store(os,"GBK");
	RmiConfig.reloadProp();
}



 

 
%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
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
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(32642,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>

<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSubmit(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value=""/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(19665,user.getLanguage()) %>"/>
</jsp:include>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; ">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" class="e8_btn_top" onclick="doSubmit()"/>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu middle"></span>
		</td>
	</tr>
</table>
<div id="tabDiv" >
	<span id="hoverBtnSpan" class="hoverBtnSpan">
			
	</span>
</div>

<FORM id=weaver name=weaver action="SearchInfoSet.jsp" method=post >
 <input type="hidden" name="method" value="saveProp"/>
	<wea:layout type="2Col">
		     <wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
			        <%if(cprop!=null){
						Set<String> names=cprop.getPropertyCommentSet();
						for(String s:names){
							if("weather".equals(s)) continue;
					%>
						<wea:item><%=Util.null2String(Util.null2String(cprop.getPropertyComment(s)))%></wea:item>
						 <wea:item>
			          		<input class="InputStyle" type="text" id="classname" name="<%=s %>" value="<%=Util.null2String(cprop.getProperty(s)) %>" >
			      		</wea:item>
					<%	}%>
					<%} %>
			   </wea:group>
	</wea:layout>
 
</FORM>

<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>   
<script language="javascript">
var isSubmit=false;

$(document).ready(function() {
	 
});

function changeType(obj){
	if($(obj).val()==1){
		hideEle('msgstr');
		showEle('newstr');
	}else{
		hideEle('newstr');
		showEle('msgstr');
	}
}

	
function doSubmit(){

	$("#weaver").submit();
	 
}
 
 

</script>
 
</HTML>
