
<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML>
<HEAD>
	<link REL=stylesheet type=text/css HREF="/css/Weaver_wev8.css">
	<script type="text/javascript" src="/js/weaver_wev8.js"></script>
	<script type="text/javascript">
		// 获取父窗口对象和弹窗对象
		var parentWin = parent.parent.getParentWindow(parent);
		var dialog = parent.parent.getDialog(parent);
		console.log("parentWin="+parentWin.location.href+",dialog="+dialog);
	</script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(16384,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
	<%
	// 文档id
	String docId = Util.null2String(request.getParameter("docId"));
	// 当前版本id
	String currentVersionId = Util.null2String(request.getParameter("currentVersionId"));

	String tilteName = Util.null2String(request.getParameter("tilteName"));
	tilteName = "".equals(tilteName) ? "16384" : tilteName;
	%>
	<div class="zDialog_div_content">
		<form style="margin-bottom:0" action="" method="post">
			<input type="hidden" id="docId" name="docId" value="<%=docId %>">
			<input type="hidden" id="currentVersionId" name="currentVersionId" value="<%=currentVersionId %>">
			<table id="versionsList" class="ListStyle" cellspacing="0">
				<tr class="header">
					<th width="20%"><%=SystemEnv.getHtmlLabelName(22186,user.getLanguage())%></th>
					<th width="80%"><%=SystemEnv.getHtmlLabelName(16446,user.getLanguage())%></th>
				</tr>
				<%
				String sql = "SELECT versionId,imagefileid,versionDetail FROM DocImageFile WHERE docid = '" + docId + "' ORDER BY versionId DESC";
				RecordSet.execute(sql);
				String versionId = null;
				String versionDetail = null;
				String imagefileid = null;
				while(RecordSet.next()){
					versionId = Util.null2String(RecordSet.getString("versionId"));
					versionDetail = Util.null2String(RecordSet.getString("versionDetail"));
					imagefileid = Util.null2String(RecordSet.getString("imagefileid"));
				%>
				<tr class="DataDark" imagefileid="<%=imagefileid %>">
					<td class="versionId"><%=versionId %></td>
					<td class="versionDetail"><%=versionDetail %></td>
				</tr>
				<%
				}
				%>
			</table>
		</form>
	</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout needImportDefaultJsAndCss="false" attributes="{'expandAllGroup':'true'}">
			<wea:group context="<%=SystemEnv.getHtmlLabelName(15070,user.getLanguage())%>">
				<wea:item type="toolbar">
					<input type="button" accessKey="T"  id="btncancel" value="<%="T-"+SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="onClose();">
				</wea:item>
			</wea:group>
		</wea:layout>
		<script type="text/javascript">
			jQuery(document).ready(function(){
				resizeDialog(document);
			});
		</script>
	</div>
</BODY>
</HTML>

<script language="javascript">

jQuery(function(){
	jQuery("#versionsList").find("tr.DataDark").click(function(){
		var tr = jQuery(this);
		var json = {
				id:jQuery.trim(tr.children("td.versionId").html()),
				name:jQuery.trim(tr.children("td.versionDetail").html())
		};
		var ifid = jQuery.trim(tr.attr("imagefileid"));
		if(json.id === jQuery.trim(jQuery("#currentVersionId").val())) {
			onClose();
		} else {
			parentWin.location.href = changeURLArg(parentWin.location.href,"imagefileId",ifid) +"&pointUrl=true";
			if(dialog){
				try{
					dialog.callback(json);
					dialog.close(json);
				}catch(e){}
			}else{
				 window.parent.returnValue = json;
				 window.parent.close();
			}
		}
		
	});
});

function changeURLArg(url,arg,arg_val){ 
    var pattern=arg+'=([^&]*)'; 
    var replaceText=arg+'='+arg_val; 
    if(url.match(pattern)){ 
        var tmp='/('+ arg+'=)([^&]*)/gi'; 
        tmp=url.replace(eval(tmp),replaceText); 
        return tmp; 
    }else{ 
        if(url.match('[\?]')){ 
            return url+'&'+replaceText; 
        }else{ 
            return url+'?'+replaceText; 
        } 
    } 
    return url+'\n'+arg+'\n'+arg_val; 
} 

function onClose() {
	if(dialog){
	    dialog.close();
	}else{  
		window.parent.close() ;
	}	
}
</script>