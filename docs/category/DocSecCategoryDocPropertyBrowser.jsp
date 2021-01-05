
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page import="weaver.conn.RecordSet"%>
<%@ page import="weaver.docs.category.security.*" %>
<jsp:useBean id="SecCategoryDocPropertiesComInfo" class="weaver.docs.category.SecCategoryDocPropertiesComInfo" scope="page"/>

<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<script type="text/javascript">
	try{
		parent.setTabObjName("<%=SystemEnv.getHtmlLabelNames("33197,33331",user.getLanguage())%>");
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

<BODY scroll='auto'>
<div class="zDialog_div_content">
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td>
			</td>
			<td class="rightSearchSpan" style="text-align:right;">
				<span title="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage()) %>" class="cornerMenu"></span>
			</td>
		</tr>
	</table>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(309,user.getLanguage())+",javascript:onClose(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:submitClear(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;

%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<script>
rightMenu.style.visibility='hidden'
</script>

<%
int secCategoryId = Util.getIntValue(request.getParameter("seccategory"));
String needDocumentCreator = Util.null2String(request.getParameter("needDocumentCreator"));//是否需要文档创建人  1：需要   其它：不需要
String needCurrentOperator = Util.null2String(request.getParameter("needCurrentOperator"));//是否需要当前操作者  1：需要   其它：不需要
String needDocShare = Util.null2String(request.getParameter("needDocShare"));//是否需要当前操作者  1：需要   其它：不需要
%>

<FORM NAME=SearchForm STYLE="margin-bottom:0;margin-right:0">
<wea:layout type="table" attributes="{'formTableId':'BrowseTable','cols':'2','cws':'30%,70%'}">
	<wea:group context="" attributes="{'groupDisplay':'none'}">
		<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></wea:item>
		<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
		<%
		if("1".equals(needDocShare)){%>
			<wea:item><A HREF=#>-4</A></wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(19910, user.getLanguage())%></wea:item>
		<%}
		if(needDocumentCreator.equals("1")){ %>
			<wea:item><A HREF=#>-3</A></wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(20558, user.getLanguage())%></wea:item>
		<%}
		if(needCurrentOperator.equals("1")){ %>
			<wea:item><A HREF=#>-2</A></wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(18582, user.getLanguage())%></wea:item>
		<%} %>
		<%
SecCategoryDocPropertiesComInfo.addDefaultDocProperties(secCategoryId);
RecordSet rs = new RecordSet();
rs.executeSql("select * from DocSecCategoryDocProperty where (labelid is null or labelid not in ("+MultiAclManager.MAINCATEGORYLABEL+","+MultiAclManager.SUBCATEGORYLABEL+")) and secCategoryId =" + secCategoryId + "order by viewindex");

while(rs.next()){
	
	int id = rs.getInt("id");
	int labelId = rs.getInt("labelid");
	String customName = Util.null2String(SecCategoryDocPropertiesComInfo.getCustomName(""+id,user.getLanguage()));
	int isCustom = rs.getInt("isCustom");

	String name = "";
	if(isCustom==1)
		name = customName;
	else
		if(customName!=null&&!"".equals(customName))
			name = customName;
		else
			name = SystemEnv.getHtmlLabelName(labelId, user.getLanguage());

%>
	<wea:item><A HREF=#><%=id%></A></wea:item>
	<wea:item><%=name%></wea:item>
<%}%>
	</wea:group>
</wea:layout>
</FORM>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<input type="button" style="display:none;" class=zd_btn_submit accessKey=S  id=btnsearch value="S-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"></input>
<wea:layout needImportDefaultJsAndCss="false">
	<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
		<wea:item type="toolbar">
			<input type="button" onclick="submitClear()" class=zd_btn_submit accessKey=2  id=btnclear value="<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%>"></input>
	        <input type="button" onclick="onClose()" class=zd_btn_cancle accessKey=T  id=btncancel value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>"></input>
		</wea:item>
	</wea:group>
</wea:layout>
<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
</div>
<script type="text/javascript">

jQuery(document).ready(function(){
	//alert(jQuery("#BrowseTable").find("tr").length)
	jQuery("#BrowseTable").find("tbody tr[class!='Spacing']").bind("click",function(){
			if(dialog){
				try{
				dialog.callback({id:$(this).find("td:first").text(),name:$(this).find("td:first").next().text()});
				}catch(e){}
				try{
				dialog.close({id:$(this).find("td:first").text(),name:$(this).find("td:first").next().text()});
				}catch(e){}

			}else{
				window.parent.returnValue = {id:$(this).find("td:first").text(),name:$(this).find("td:first").next().text()};
				window.parent.close()
			}
		})
});

function onClose(){
	if(dialog){
		dialog.close();
	}else{
		window.parent.close()
	}
}
function submitClear()
{
	if(dialog){
		try{
		dialog.callback({id:"",name:""});
		}catch(e){}
		try{
		dialog.close({id:"",name:""});
		}catch(e){}
	}else{
		window.parent.returnValue = {id:"",name:""};
		window.parent.close()
	}
}
</script>
</BODY></HTML>

