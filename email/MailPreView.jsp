<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@page import="weaver.email.MailPreviewHtml"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="mms" class="weaver.email.service.MailManagerService" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>

<%
	User currentuser = HrmUserVarify.getUser (request , response) ;
	String mailid=Util.null2String(request.getParameter("mailid"),"0");
	String fileid=Util.null2String(request.getParameter("fileid"),"0");
	String filename="";
	int fileSize=0;
    
	String sql="";
	if(mailid.equals("0")) {
		sql = "select isaesencrypt,aescode, filename,filerealpath,iszip,isencrypt,filetype,attachfile,isEncoded,fileSize from MailResourceFile where (mailid=0 or mailid is null) and id="+fileid;
	}else{
    	String resourceids=mms.getAllResourceids(""+currentuser.getUID()); //获取所有账号包括子账号
		sql = "select isaesencrypt,aescode, filename,filerealpath,iszip,isencrypt,filetype,attachfile,isEncoded,fileSize from MailResourceFile t1,MailResource t2 " 
            + " where t1.id = " + fileid + " and t1.mailid=t2.id and t2.resourceid in("+resourceids+")";
        
		RecordSet.executeQuery("select folderId from MailResource where id = " + mailid);
        if(RecordSet.next()) {
            String folderId = RecordSet.getString("folderId");
            if("-2".equals(folderId)) {
                sql += " union all ";
                sql += "select isaesencrypt,aescode, filename,filerealpath,iszip,isencrypt,filetype,attachfile,isEncoded,fileSize from MailResourceFile where (mailid=0 or mailid is null) and id="+fileid;
            }
        }
	}
	RecordSet.execute(sql);
	if(!RecordSet.next()){
		response.sendRedirect("/notice/noright.jsp") ;
		return;	
	}else{
		filename=RecordSet.getString("filename");
		fileSize=RecordSet.getInt("fileSize");
	}
	
	String iframesrc="/weaver/weaver.email.FileDownloadLocation?mailid="+mailid+"&fileid="+fileid;
	if(fileSize/(1024.0*1024.0)>5){
		iframesrc="/wui/common/page/sysRemind.jsp?labelid=-99999";
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
   <jsp:param name="mouldID" value="mail"/>
   <jsp:param name="navName" value="<%=filename%>"/>
</jsp:include>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<span title="<%=SystemEnv.getHtmlLabelName(258,user.getLanguage()) %>" id="configSpan" style="font-size: 12px;cursor: pointer;">
				<input class="e8_btn_top middle" onclick="downLoad()" type="button" value="<%=SystemEnv.getHtmlLabelName(258,user.getLanguage()) %>"/>
			</span>
			<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage()) %>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout> 
<DIV id="bgAlpha"></DIV>
<div id="loading">	
		<span><img src="/images/loading2_wev8.gif" align="absmiddle"></span>
		<span  id="loading-msg" style="font-size:12"><%=SystemEnv.getHtmlLabelName(31230,user.getLanguage()) %>...</span>
</div>
<div class="zDialog_div_content" id='contentDiv' style="height:485px;">
	<iframe id="htmlShowContent" frameborder="0" style="width:100%;height:99%;" onload="hideLoading()" src="<%=iframesrc%>" ></iframe>
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
}
</style>
<script>
jQuery(document).ready(function(){
	Ext.get('loading').fadeIn();
});

function hideLoading(){
	$("#bgAlpha").hide();
	 $("#loading").hide();	
	
}
function downLoad(){
	$("#downLoadFrame").attr("src","/weaver/weaver.email.FileDownloadLocation?download=1&fileid="+<%=fileid%>+"&mailid=<%=mailid%>"); 
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