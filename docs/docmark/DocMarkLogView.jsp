
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.PageIdConst" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%	
    String secId = (String)session.getValue("secId");
    String docId = Util.null2String(request.getParameter("docId"));  
    if ("".equals(docId)){
        out.println(SystemEnv.getHtmlLabelName(19001,user.getLanguage()));
        return ;
    }
%>

<HTML>
  <HEAD>
    <LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
    <script type="text/javascript">
	    try{
			parent.setTabObjName("<%=SystemEnv.getHtmlLabelNames("6072,361",user.getLanguage())%>");
		}catch(e){
			if(window.console)console.log(e);
		}
		var parentWin = null;
		var dialog = null;
		try{
			parentWin = parent.parent.getParentWindow(parent);
			dialog = parent.parent.getDialog(parent);
		}catch(e){}
	</script>
  </HEAD>
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
	<%
        RCMenu += "{"+SystemEnv.getHtmlLabelName(309,user.getLanguage())+",javascript:onClose()',_top} " ;
        RCMenuHeight += RCMenuHeightStep ;
	%>
	<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

             <!--列表部分-->
              <%
                    String tableString=""+
					   "<table instanceid=\"docMouldTable\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.DOC_MARKLOGLIST,user.getUID(),"doc")+"\" tabletype=\"none\">"+
					   "<sql backfields=\"*\" sqlwhere=\""+Util.toHtmlForSplitPage(" docId="+docId)+"\"  sqlform=\"DocMark\" sqlorderby=\"markDate,id\"  sqlprimarykey=\"id\" sqlsortway=\"asc\"  sqldistinct=\"true\" />"+
					   "<head>"+							 
							 "<col width=\"20%\" transmethod=\"weaver.general.KnowledgeTransMethod.getMarkUser\" otherpara=\""+secId+"+column:markHrmType+"+user.getLanguage()+"\" text=\""+SystemEnv.getHtmlLabelName(19002,user.getLanguage())+"\" column=\"markHrmId\"/>"+
							 "<col width=\"10%\"  transmethod=\"weaver.general.KnowledgeTransMethod.getMark\" column=\"mark\" otherpara=\""+user.getLanguage()+"\"  text=\""+SystemEnv.getHtmlLabelName(18093,user.getLanguage())+"\"/>"+
							 "<col width=\"40%\"  transmethod=\"weaver.general.KnowledgeTransMethod.forHtml\" text=\""+SystemEnv.getHtmlLabelName(1514,user.getLanguage())+"\" column=\"remark\"/>"+
							 "<col width=\"20%\"  transmethod=\"weaver.general.KnowledgeTransMethod.forHtml\" text=\""+SystemEnv.getHtmlLabelName(19003,user.getLanguage())+"\" column=\"markDate\"/>"+
					   "</head>"+
					   "</table>";
                  %>
      <input type="hidden" name="pageId" id="pageId" _showCol="false" value="<%= PageIdConst.DOC_MARKLOGLIST %>"/>
      <wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run"  />
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout needImportDefaultJsAndCss="false">
	<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
		<wea:item type="toolbar">
	        <input type="button" onclick="onClose()" class=zd_btn_cancle accessKey=T  id=btncancel value="T-<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>"></input>
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

 <SCRIPT LANGUAGE="JavaScript">
    <!--  
     function onClose(){
     	if(dialog){
     		dialog.close();
     	}else{
       		window.parent.close();
       	}        
     }  
     //-->
 </SCRIPT>
