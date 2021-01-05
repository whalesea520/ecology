<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@page import="weaver.email.MailPreviewHtml"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<%
	String userid=""+user.getUID();
	String fileid=Util.null2String(request.getParameter("fileid"),"0");
	String filename="";
	
	boolean isHasRight=true;
	
	String sql="select * from social_IMFileShare where fileid="+fileid+" and userid="+userid;
	RecordSet.execute(sql);
	if(!RecordSet.next()){
		isHasRight=false;
		response.sendRedirect("/notice/noright.jsp") ;
		return;	
	}else{
		sql="select * from social_IMFile where fileid="+fileid;
		RecordSet.execute(sql);
		RecordSet.next();
		filename=RecordSet.getString("fileName");
	}
	
	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(24266, user.getLanguage())+":" + SystemEnv.getHtmlLabelName(611, user.getLanguage());
	String needfav = "1";
	String needhelp = "";
%>
	

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en"> 

<body>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{" + SystemEnv.getHtmlLabelName(86, user.getLanguage()) + ",javascript:downLoad(),_self} ";
	RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="social"/>
   <jsp:param name="navName" value="<%=filename%>"/>
</jsp:include>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<%if(isHasRight){%>
			<span title="<%=SystemEnv.getHtmlLabelName(258,user.getLanguage()) %>" id="configSpan" style="font-size: 12px;cursor: pointer;">
				<input class="e8_btn_top middle" onclick="downLoad()" type="button" value="<%=SystemEnv.getHtmlLabelName(258,user.getLanguage()) %>"/>
			</span>
			<%}%>
			<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage()) %>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout> 
<DIV id="bgAlpha"></DIV>
<div id="loading">	
		<span><img src="/images/loading2_wev8.gif" align="absmiddle"></span>
		<span  id="loading-msg" style="font-size:12px;"><%=SystemEnv.getHtmlLabelName(31230,user.getLanguage()) %>...</span>
</div>
<div class="zDialog_div_content" id='contentDiv' style="height:500px;">
	<iframe id="htmlShowContent" frameborder="0" style="width:100%;height:495px;" onload="hideLoading()" src="/social/im/SocialIMFilePreContent.jsp?fileid=<%=fileid%>&filename=<%=filename%>" ></iframe>
</div>

<iframe id="downLoadFrame" style="display:none;"></iframe>

<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout>
		<wea:group context="" attributes="{groupDisplay:none}">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="parent.getDialog(window).close()"/>
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>
<style>
#loading{
    position:absolute;
    left:45%;
    background:#ffffff;
    top:40%;
    padding:8px;
    z-index:20001;
    height:auto;
    border:1px solid #ccc;
    width: 120px;
    text-align: center;
}
</style>
<script>
jQuery(document).ready(function(){
});

function hideLoading(){
	$("#bgAlpha").hide();
	$("#loading").hide();	
}
function downLoad(){
	$("#downLoadFrame").attr("src","/weaver/weaver.file.FileDownload?download=1&fileid="+<%=fileid%>); 
}

function iFrameHeight() {
    var ifm= document.getElementById("htmlShowContent");
    var subWeb = document.frames ? document.frames["htmlShowContent"].document :ifm.contentDocument;
    if(ifm != null && subWeb != null) {
    	ifm.height = subWeb.body.scrollHeight;
    }
}

window.onresize=function(){
	//iFrameHeight();
}

</script>


</body>
</html>