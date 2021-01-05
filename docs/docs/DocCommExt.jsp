
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
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
<div id="loading">	
		<span><img src="/images/loading2_wev8.gif" align="absmiddle"></span>
		<span  id="loading-msg"><%=SystemEnv.getHtmlLabelName(19945, user.getLanguage())%></span>
</div>

<jsp:include page="/systeminfo/WeaverLangJS.jsp">
    <jsp:param name="languageId" value="<%=user.getLanguage()%>" />
</jsp:include>


<link rel="stylesheet" type="text/css" href="/js/homepage/extjs/resources/css/ext-all_wev8.css" />
<link rel="stylesheet" type="text/css" href="/js/homepage/extjs/resources/css/xtheme-gray_wev8.css" />
<link rel="stylesheet" type="text/css" href="/css/weaver-ext_wev8.css" />	
<script type="text/javascript">document.getElementById('loading-msg').innerHTML = "<%=SystemEnv.getHtmlLabelName(19945, user.getLanguage())%>"</script>

<script type="text/javascript" src="/js/Cookies_wev8.js"></script>





<SCRIPT LANGUAGE="vbscript">
	dim id
</SCRIPT>



<script type="text/javascript" src="/js/homepage/extjs/adapter/ext/ext-base_wev8.js"></script>
<script type="text/javascript" src="/js/homepage/extjs/ext-all_wev8.js"></script>  
<script type="text/javascript" src="/js/TabCloseMenu_wev8.js"></script> 
<%if(user.getLanguage()==7) {%>
	<script type='text/javascript' src='/js/extjs/build/locale/ext-lang-zh_CN_gbk_wev8.js'></script>
<%} else if(user.getLanguage()==8) {%>
	<script type='text/javascript' src='/js/extjs/build/locale/ext-lang-en_wev8.js'></script>
<%} else if(user.getLanguage()==9) {%>
	<script type='text/javascript' src='/js/extjs/build/locale/ext-lang-zh_TW_wev8.js'></script>
<%}%>

<script type="text/javascript" src="/js/ColumnNodeUI_wev8.js"></script>
<script type="text/javascript" src="/js/extjs/build/ux/miframe_wev8.js"></script>


<link rel="stylesheet" type="text/css" href="/css/column-tree_wev8.css" />


<SCRIPT LANGUAGE="javascript">	
Ext.onReady(function(){
	Ext.Ajax.timeout=300000;
	Ext.QuickTips.init();
    Ext.BLANK_IMAGE_URL = '/js/extjs/resources/images/default/s_wev8.gif';
	Ext.useShims = true;
	//Ext.state.Manager.setProvider(new Ext.state.CookieProvider());

	Ext.override(Ext.grid.GridView, {
		templates: {
			cell: new Ext.Template(
						'<td class="x-grid3-col x-grid3-cell x-grid3-td-{id} {css}" style="{style}" tabIndex="0" {cellAttr}>',
						'<div class="x-grid3-cell-inner x-grid3-col-{id}" {attr}>{value}</div>',
						"</td>"
				)
		}
	});
});
</SCRIPT>

