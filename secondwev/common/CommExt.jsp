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
		<span><img src="/images/loading2.gif" align="absmiddle"></span>
		<span  id="loading-msg"><%=SystemEnv.getHtmlLabelName(19945, user.getLanguage())%></span>
</div>

<%if(user.getLanguage()==7) {%>
	<script type='text/javascript' src='/js/weaver-lang-cn-gbk.js'></script>
<%} else if(user.getLanguage()==8) {%>
	<script type='text/javascript' src='/js/weaver-lang-en-gbk.js'></script>
<%} else if(user.getLanguage()==9) {%>
	<script type='text/javascript' src='/js/weaver-lang-tw-gbk.js'></script>
<%}%>


<link rel="stylesheet" type="text/css" href="/js/homepage/extjs/resources/css/ext-all.css" />
<link rel="stylesheet" type="text/css" href="/js/homepage/extjs/resources/css/xtheme-gray.css" />
<link rel="stylesheet" type="text/css" href="/css/weaver-ext.css" />	
<script type="text/javascript">document.getElementById('loading-msg').innerHTML = "<%=SystemEnv.getHtmlLabelName(19945, user.getLanguage())%>"</script>

<script type="text/javascript" src="/js/Cookies.js"></script>





<SCRIPT LANGUAGE="vbscript">
	dim id
</SCRIPT>



<script type="text/javascript" src="/js/homepage/extjs/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="/js/homepage/extjs/ext-all.js"></script>  
<script type="text/javascript" src="/js/TabCloseMenu.js"></script> 
<%if(user.getLanguage()==7) {%>
	<script type='text/javascript' src='/js/extjs/build/locale/ext-lang-zh_CN_gbk.js'></script>
<%} else if(user.getLanguage()==8) {%>
	<script type='text/javascript' src='/js/extjs/build/locale/ext-lang-en.js'></script>
<%} else if(user.getLanguage()==9) {%>
	<script type='text/javascript' src='/js/extjs/build/locale/ext-lang-zh_TW.js'></script>
<%}%>

<script type="text/javascript" src="/js/ColumnNodeUI.js"></script>
<script type="text/javascript" src="/js/extjs/build/ux/miframe.js"></script>


<link rel="stylesheet" type="text/css" href="/css/column-tree.css" />


<SCRIPT LANGUAGE="javascript">	
Ext.onReady(function(){
	Ext.Ajax.timeout=300000;
	Ext.QuickTips.init();
    Ext.BLANK_IMAGE_URL = '/js/extjs/resources/images/default/s.gif';
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

