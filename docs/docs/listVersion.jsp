<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<script type="text/javascript">
			try{
				parent.setTabObjName("<%=SystemEnv.getHtmlLabelNames("19587",user.getLanguage())%>");
			}catch(e){
				if(window.console)console.log(e+"-->HrmRolesBrowser.jsp");
			}
		  var parentWin = null;
		  var dialog = null;
		  try{
			parentWin = parent.parent.getParentWindow(parent);
			dialog = parent.parent.getDialog(parent);
		  }catch(e){}
		</script> 






<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css></HEAD>

<BODY>
<div class="zDialog_div_content">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<span title="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>


<FORM NAME=SearchForm STYLE="margin-bottom:0" action="ResourceBrowser.jsp" method=post>
<input type=hidden name=seclevelto value="">
<input type=hidden name=needsystem value="">
<DIV align=right style="display:none">


</DIV>

<%
int ImageFileid = Util.getIntValue(request.getParameter("imgId"),0);
int versionId=Util.getIntValue(request.getParameter("versionId"),0);
boolean canDel = Util.null2String(request.getParameter("canDel")).equals("true");
boolean canDownload = Util.null2String(request.getParameter("canDownload")).equals("true");
if(canDel) canDownload=true;
RecordSet.executeSql("select versionId from DocImageFile where ImageFileid="+ImageFileid);
if(RecordSet.next()){
versionId=Util.getIntValue(RecordSet.getString("versionId"),0);
}
int docid = Util.getIntValue(request.getParameter("docid"),0);

DocImageManager.setVersionId(versionId);
DocImageManager.setDocid(docid);
DocImageManager.selectCurNewestVersion();
ArrayList versionIdTmp = new ArrayList();
ArrayList versionDetailTmp = new ArrayList();
ArrayList fileImageId = new ArrayList();
while(DocImageManager.next()){
    versionIdTmp.add(DocImageManager.getVersionId()+"");
    versionDetailTmp.add(DocImageManager.getVersionDetail()+"");
    fileImageId.add(DocImageManager.getImagefileid()+"");
}
int id=0;
RecordSet.executeSql("select id from DocImageFile where versionId=" + versionId + (docid>0?" and docid = " + docid:""));
if(RecordSet.next()){
id=Util.getIntValue(RecordSet.getString("id"),0);
}
String sourceParams = "docid:"+docid+"+id:"+id+"+canDownload:"+canDownload;
//设置好搜索条件				
String tableString=""+
	   "<table  needPage=\"false\" datasource=\"weaver.docs.docs.DocDataSource.getDocImgVersionList\" sourceparams=\""+sourceParams+"\" pagesize=\"10\" tabletype=\"none\">"+
	    "<sql backfields=\"*\"  sqlorderby=\"versionid\"  sqlprimarykey=\"imagefileId\" sqlsortway=\"desc\"  />";
	   tableString += "<operates width=\"20%\">";
			if(canDownload){
			tableString += "     <operate href=\"javascript:downloadDocImgs()\"  text=\""+SystemEnv.getHtmlLabelName(31156,user.getLanguage())+"\" index=\"1\"/>";
			}
			if(canDel){
				tableString += "     <operate href=\"javascript:delImage()\"  text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" index=\"2\"/>";
			}
		    tableString += "</operates>"+
	   "<head>";
			tableString += "<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(16445,user.getLanguage())+"\" column=\"currentrow\" />";
			tableString +=	 "<col width=\"40%\"  text=\""+SystemEnv.getHtmlLabelName(17517,user.getLanguage())+"\" column=\"imagefilename\" />";		
			tableString +=	 "<col width=\"40%\"  text=\""+SystemEnv.getHtmlLabelName(16446,user.getLanguage())+"\" column=\"versiondetail\" />"+			
	   "</head>"+
	   "</table>"; 
%>
<div id="BrowserTable">
<wea:SplitPageTag  tableString='<%=tableString%>' isShowTopInfo="false"  mode="run"/>
</div>
</FORM>


<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
    <wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
			<wea:item type="toolbar">
		    	<input type="button" accessKey=T  id=btncancel value="<%="T-"+SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="onClose();">
			</wea:item>
		</wea:group>
	</wea:layout>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
</div>
</BODY></HTML>

<script type="text/javascript">

function onClose(){
	if(dialog){
		dialog.close();
	}else{
		//window.parent.returnValue = returnjson;
		window.parent.close();
	}
}
	function openTip(flag){
		var dialog = new window.top.Dialog();
		var url="/wui/common/page/sysRemindfordoc.jsp";
		if(flag==1){
			url="/wui/common/page/sysRemindfordoc.jsp?labelid=129755";
		}else if(flag==2){
			url="/wui/common/page/sysRemindfordoc.jsp?labelid=129757";
		}
		dialog.currentWindow = window; 
		dialog.URL = url;
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(24960,user.getLanguage())%>";
		dialog.Width = 850;
		dialog.Height = 450;
		dialog.Drag = true;
		dialog.show();
	}
function downloadDocImgs(id){
	top.location="/weaver/weaver.file.FileDownload?download=1&fileid="+id;
}
	function delImage(id){
		jQuery.ajax({
					url:"/docs/docs/DocImgsUtil.jsp?method=delImgsOnly&docid=<%=docid%>&delcurrentversion=1&delImgIds="+id,
					type:"get",
					beforeSend:function(){
						e8showAjaxTips(SystemEnv.getHtmlNoteName(3513,readCookie("languageidweaver")),true);
					},
					complete:function(){
						e8showAjaxTips("",false);
						_table.reLoad();
					}
				});		
	}
jQuery(document).ready(function(){
	jQuery("#BrowserTable").find("tr[class!='Spacing']").bind("click",function(){
		<%
			
		    if(Util.getIntValue(request.getParameter("versionId"),0)>0){
		%>
			var returnjson = {id:jQuery(this).find("#versionId").val(),name:jQuery(this).find("#fileImageId").val()};
         <%
		    }else{	 
		 %> 
			var versionid=jQuery(this).find("#versionId").val();
			var fileImageId=jQuery(this).find("#fileImageId").val();
			var returnjson = {id:jQuery(this).find("#fileImageId").val(),name:jQuery(this).find("#versionId").val()};
		 <%
		     }	 
		 %>
			if(dialog){
				openFullWindowForXtable('/docs/docs/DocDspExt.jsp?id=<%=Util.getIntValue(request.getParameter("docid"),0)%>&imagefileId='+fileImageId+'&isFromAccessory=true&versionId='+versionid);
				try{
				//	dialog.callback(returnjson);
				}catch(e){}
				try{
				//	dialog.close(returnjson);
				}catch(e){}
			}else{
			window.parent.returnValue = returnjson;
		  	window.parent.close();
			}
		});
});

</script>
