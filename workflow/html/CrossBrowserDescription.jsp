
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.*" %>

<html>
<head>
	<title>跨浏览器模式选项说明</title>
</head>
<body>
<br>
<div id="helpdiv" name="helpdiv" style="width:100%;height:100%">
<%
//这个页面用来写操作说明，分3种语言
//不用标签是因为操作说明都是大段文字
int languageid = Util.getIntValue(request.getParameter("languageid"), 7);
if(languageid == 7){
%>
&nbsp;&nbsp;&nbsp;&nbsp;
<p class="MsoNormal" style="margin: 0cm 0cm 0pt">
	<span style="font-size: 12px"><b style="mso-bidi-font-weight: normal"><span style="font-family: '微软雅黑','sans-serif'"><font color="#000000">如果您的<span lang="EN-US">Html</span>模板在非<span lang="EN-US">IE</span>下（<span lang="EN-US">Chrome</span>、<span lang="EN-US">FF</span>）明细行无法对齐，您可以选择启用跨浏览器模式来解决此问题，启用此模式可能需要您调整模板内容，请您按照以下步骤进行启用</font></span></b></span><b style="mso-bidi-font-weight: normal"><span style="font-family: '微软雅黑','sans-serif'; font-size: 8pt"><font color="#000000"><span lang="EN-US"><o:p></o:p></span></font></span></b></p>
<p class="MsoNormal" style="margin: 0cm 0cm 0pt">
	<span style="font-size: 12px"><b style="mso-bidi-font-weight: normal"><span lang="EN-US" style="font-family: '微软雅黑','sans-serif'"><o:p><font color="#000000">&nbsp;</font></o:p></span></b></span><span style="font-size: 11px"><b style="mso-bidi-font-weight: normal"><span lang="EN-US" style="font-family: '微软雅黑','sans-serif'"><o:p></o:p></span></b></span></p>
<p class="MsoNormal" style="margin: 0cm 0cm 0pt">
	<span style="font-size: 12px"><b style="mso-bidi-font-weight: normal"><span lang="EN-US" style="font-family: '微软雅黑','sans-serif'"><o:p></o:p></span></b></span></p>
<p class="MsoNormal" style="margin: 0cm 0cm 0pt">
	<span style="font-size: 12px"><font color="#000000"><b style="mso-bidi-font-weight: normal"><span lang="EN-US" style="font-family: '微软雅黑','sans-serif'">1.</span></b><b style="mso-bidi-font-weight: normal"><span style="font-family: '微软雅黑','sans-serif'">判断是否需要修改模板（需要您具备<span lang="EN-US">Html</span>的知识）：</span></b></font></span></p>
<p class="MsoNormal" style="margin: 0cm 0cm 0pt">
	<font color="#000000"><b style="mso-bidi-font-weight: normal"><span style="font-family: '微软雅黑','sans-serif'; font-size: 8pt"><span lang="EN-US"><o:p></o:p></span></span></b></font></p>
<p class="MsoNormal" style="margin: 0cm 0cm 0pt">
	<span style="font-size: 12px"><span style="font-family: '微软雅黑','sans-serif'"><font color="#000000">①<span lang="EN-US">.</span>明细部分代码是否在同一个<span lang="EN-US">Table</span>当中</font></span></span><span style="font-family: '微软雅黑','sans-serif'; font-size: 8pt"><font color="#000000"><span lang="EN-US"><o:p></o:p></span></font></span></p>
<p class="MsoNormal" style="margin: 0cm 0cm 0pt">
	<span style="font-size: 12px"><span style="font-family: '微软雅黑','sans-serif'"><font color="#000000">点击顶部，【源码】按钮，在源码中找到明细块所在元素：</font></span></span></p>
<p class="MsoNormal" style="margin: 0cm 0cm 0pt">
	<span style="font-size: 12px"><span style="font-family: '微软雅黑','sans-serif'"><font color="#000000"><img width="80%" alt="docimages_0" src="../../images/1_wev8.png" />&nbsp;&nbsp;&nbsp;</font></span></span></p>
<p class="MsoNormal" style="margin: 0cm 0cm 0pt">
	&nbsp;</p>
<p class="MsoNormal" style="margin: 0cm 0cm 0pt">
	<span style="font-size: 12px"><span style="font-family: '微软雅黑','sans-serif'"><font color="#000000">如果此元素为一个独立的<span lang="EN-US">Table</span>，且格式为以下格式时，则不需要调整模板，反之，则需要调整成以下格式</font></span></span><span style="font-family: '微软雅黑','sans-serif'; font-size: 8pt"><font color="#000000"><span lang="EN-US"><o:p></o:p></span></font></span></p>
<p class="MsoNormal" style="margin: 0cm 0cm 0pt">
	<span style="font-size: 12px"><font color="#000000"><span lang="EN-US" style="font-family: '微软雅黑','sans-serif'">&lt;table id=&quot;oTable0&quot; name=&quot;oTable0&quot; &hellip;&gt;<span style="mso-spacerun: yes">&nbsp;&nbsp;&nbsp; </span>//</span><span style="font-family: '微软雅黑','sans-serif'">必须含有<span lang="EN-US">id</span>和<span lang="EN-US">name</span>属性，且内容必须为&ldquo;<span lang="EN-US">oTable</span>&rdquo;加上当前明细是第几组明细<span lang="EN-US">-1</span>，如：两组明细，那么第一组明细的名字：<span lang="EN-US">oTable0 </span>第二组明细的名字为：<span lang="EN-US">oTable1</span>以此类推</span></font></span><font color="#000000"><span style="font-family: '微软雅黑','sans-serif'; font-size: 8pt"><span lang="EN-US"><o:p></o:p></span></span></font></p>
<p class="MsoNormal" style="text-indent: 15.75pt; margin: 0cm 0cm 0pt">
	<span style="font-size: 12px"><span lang="EN-US" style="font-family: '微软雅黑','sans-serif'"><font color="#000000">&lt;tbody&gt;</font></span></span><span lang="EN-US" style="font-family: '微软雅黑','sans-serif'; font-size: 8pt"><font color="#000000"><o:p></o:p></font></span></p>
<p class="MsoNormal" style="text-indent: 15.75pt; margin: 0cm 0cm 0pt">
	<span style="font-size: 12px"><span lang="EN-US" style="font-family: '微软雅黑','sans-serif'"><font color="#000000"><span style="mso-spacerun: yes">&nbsp;&nbsp;&nbsp; </span>&lt;tr&gt;</font></span></span><span lang="EN-US" style="font-family: '微软雅黑','sans-serif'; font-size: 8pt"><font color="#000000"><o:p></o:p></font></span></p>
<p class="MsoNormal" style="text-indent: 15.75pt; margin: 0cm 0cm 0pt">
	<span style="font-size: 12px"><font color="#000000"><span lang="EN-US" style="font-family: '微软雅黑','sans-serif'"><span style="mso-spacerun: yes">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>&lt;td&gt;</span><span style="font-family: '微软雅黑','sans-serif'">明细表头项<span lang="EN-US">&lt;/td&gt;</span></span></font></span><font color="#000000"><span style="font-family: '微软雅黑','sans-serif'; font-size: 8pt"><span lang="EN-US"><o:p></o:p></span></span></font></p>
<p class="MsoNormal" style="text-indent: 15.75pt; margin: 0cm 0cm 0pt">
	<span style="font-size: 12px"><font color="#000000"><span lang="EN-US" style="font-family: '微软雅黑','sans-serif'"><span style="mso-spacerun: yes">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>&lt;td&gt;</span><span style="font-family: '微软雅黑','sans-serif'">明细表头项<span lang="EN-US">&lt;/td&gt;</span></span></font></span><font color="#000000"><span style="font-family: '微软雅黑','sans-serif'; font-size: 8pt"><span lang="EN-US"><o:p></o:p></span></span></font></p>
<p class="MsoNormal" style="text-indent: 15.75pt; margin: 0cm 0cm 0pt">
	<span style="font-size: 12px"><span lang="EN-US" style="font-family: '微软雅黑','sans-serif'"><font color="#000000"><span style="mso-spacerun: yes">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>&hellip;</font></span></span><span lang="EN-US" style="font-family: '微软雅黑','sans-serif'; font-size: 8pt"><font color="#000000"><o:p></o:p></font></span></p>
<p class="MsoNormal" style="text-indent: 15.75pt; margin: 0cm 0cm 0pt">
	<span style="font-size: 12px"><span lang="EN-US" style="font-family: '微软雅黑','sans-serif'"><font color="#000000"><span style="mso-spacerun: yes">&nbsp;&nbsp;&nbsp; </span>&lt;/tr&gt;</font></span></span><span lang="EN-US" style="font-family: '微软雅黑','sans-serif'; font-size: 8pt"><font color="#000000"><o:p></o:p></font></span></p>
<p class="MsoNormal" style="text-indent: 15.75pt; margin: 0cm 0cm 0pt">
	<span style="font-size: 12px"><span lang="EN-US" style="font-family: '微软雅黑','sans-serif'"><font color="#000000"><span style="mso-spacerun: yes">&nbsp;&nbsp;&nbsp; </span>&lt;tr&gt;</font></span></span><span lang="EN-US" style="font-family: '微软雅黑','sans-serif'; font-size: 8pt"><font color="#000000"><o:p></o:p></font></span></p>
<p class="MsoNormal" style="text-indent: 15.75pt; margin: 0cm 0cm 0pt">
	<span style="font-size: 12px"><font color="#000000"><span lang="EN-US" style="font-family: '微软雅黑','sans-serif'"><span style="mso-spacerun: yes">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>&lt;td&gt;</span><span style="font-family: '微软雅黑','sans-serif'">明细项<span lang="EN-US">&lt;/td&gt;</span></span></font></span><font color="#000000"><span style="font-family: '微软雅黑','sans-serif'; font-size: 8pt"><span lang="EN-US"><o:p></o:p></span></span></font></p>
<p class="MsoNormal" style="text-indent: 15.75pt; margin: 0cm 0cm 0pt">
	<span style="font-size: 12px"><font color="#000000"><span lang="EN-US" style="font-family: '微软雅黑','sans-serif'"><span style="mso-spacerun: yes">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>&lt;td&gt;</span><span style="font-family: '微软雅黑','sans-serif'">明细项<span lang="EN-US">&lt;/td&gt;</span></span></font></span><font color="#000000"><span style="font-family: '微软雅黑','sans-serif'; font-size: 8pt"><span lang="EN-US"><o:p></o:p></span></span></font></p>
<p class="MsoNormal" style="text-indent: 15.75pt; margin: 0cm 0cm 0pt">
	<span style="font-size: 12px"><span lang="EN-US" style="font-family: '微软雅黑','sans-serif'"><font color="#000000"><span style="mso-spacerun: yes">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>&hellip;</font></span></span><span lang="EN-US" style="font-family: '微软雅黑','sans-serif'; font-size: 8pt"><font color="#000000"><o:p></o:p></font></span></p>
<p class="MsoNormal" style="text-indent: 15.75pt; margin: 0cm 0cm 0pt">
	<span style="font-size: 12px"><span lang="EN-US" style="font-family: '微软雅黑','sans-serif'"><o:p><font color="#000000">&nbsp;</font></o:p></span></span><span style="font-size: 11px"><span lang="EN-US" style="font-family: '微软雅黑','sans-serif'"><o:p></o:p></span></span></p>
<p class="MsoNormal" style="text-indent: 15.75pt; margin: 0cm 0cm 0pt">
	<span style="font-size: 12px"><span lang="EN-US" style="font-family: '微软雅黑','sans-serif'"><o:p></o:p></span></span></p>
<p class="MsoNormal" style="text-indent: 15.75pt; margin: 0cm 0cm 0pt">
	<span style="font-size: 12px"><span lang="EN-US" style="font-family: '微软雅黑','sans-serif'"><font color="#000000"><span style="mso-spacerun: yes">&nbsp;&nbsp;&nbsp; </span>&lt;/tr&gt;</font></span></span></p>
<p class="MsoNormal" style="text-indent: 15.75pt; margin: 0cm 0cm 0pt">
	<span lang="EN-US" style="font-family: '微软雅黑','sans-serif'; font-size: 8pt"><font color="#000000"><o:p></o:p></font></span></p>
<p class="MsoNormal" style="text-indent: 15.75pt; margin: 0cm 0cm 0pt">
	<span style="font-size: 12px"><span lang="EN-US" style="font-family: '微软雅黑','sans-serif'"><o:p><font color="#000000">&nbsp;</font></o:p></span></span><span style="font-size: 11px"><span lang="EN-US" style="font-family: '微软雅黑','sans-serif'"><o:p></o:p></span></span></p>
<p class="MsoNormal" style="text-indent: 15.75pt; margin: 0cm 0cm 0pt">
	<span style="font-size: 12px"><span lang="EN-US" style="font-family: '微软雅黑','sans-serif'"><o:p></o:p></span></span></p>
<p class="MsoNormal" style="margin: 0cm 0cm 0pt">
	<span style="font-size: 12px"><span lang="EN-US" style="font-family: '微软雅黑','sans-serif'"><o:p><font color="#000000">&nbsp;</font></o:p></span></span></p>
<p class="MsoNormal" style="margin: 0cm 0cm 0pt">
	<span style="font-size: 11px"><span lang="EN-US" style="font-family: '微软雅黑','sans-serif'"><o:p></o:p></span></span></p>
<p class="MsoNormal" style="margin: 0cm 0cm 0pt">
	<span style="font-size: 12px"><span lang="EN-US" style="font-family: '微软雅黑','sans-serif'"><o:p></o:p></span></span></p>
<p class="MsoNormal" style="margin: 0cm 0cm 0pt">
	<span style="font-size: 12px"><span lang="EN-US" style="font-family: '微软雅黑','sans-serif'"><o:p><font color="#000000">&nbsp;</font></o:p></span></span></p>
<p class="MsoNormal" style="margin: 0cm 0cm 0pt">
	<span style="font-size: 11px"><span lang="EN-US" style="font-family: '微软雅黑','sans-serif'"><o:p></o:p></span></span></p>
<p class="MsoNormal" style="margin: 0cm 0cm 0pt">
	<span style="font-size: 12px"><span lang="EN-US" style="font-family: '微软雅黑','sans-serif'"><o:p></o:p></span></span></p>
<p class="MsoNormal" style="margin: 0cm 0cm 0pt">
	<span style="font-size: 12px"><font color="#000000"><b style="mso-bidi-font-weight: normal"><span lang="EN-US" style="font-family: '微软雅黑','sans-serif'">2.Html</span></b><b style="mso-bidi-font-weight: normal"><span style="font-family: '微软雅黑','sans-serif'">模板调整：</span></b></font></span></p>
<p class="MsoNormal" style="margin: 0cm 0cm 0pt">
	<font color="#000000"><b style="mso-bidi-font-weight: normal"><span style="font-family: '微软雅黑','sans-serif'; font-size: 8pt"><span lang="EN-US"><o:p></o:p></span></span></b></font></p>
<p class="MsoNormal" style="margin: 0cm 0cm 0pt">
	<span style="font-size: 12px"><span style="font-family: '微软雅黑','sans-serif'"><font color="#000000">方法<span lang="EN-US">1</span>：手动调整模板，调整为以上的格式即可。</font></span></span><span style="font-family: '微软雅黑','sans-serif'; font-size: 8pt"><font color="#000000"><span lang="EN-US"><o:p></o:p></span></font></span></p>
<p class="MsoNormal" style="margin: 0cm 0cm 0pt">
	<span style="font-size: 12px"><span style="font-family: '微软雅黑','sans-serif'"><font color="#000000">方法<span lang="EN-US">2</span>：</font></span></span><span style="font-family: '微软雅黑','sans-serif'; font-size: 8pt"><font color="#000000"><span lang="EN-US"><o:p></o:p></span></font></span></p>
<p class="MsoNormal" style="text-indent: -18pt; margin: 0cm 0cm 0pt 33.75pt; mso-list: l0 level1 lfo1">
	<span style="font-size: 12px"><font color="#000000"><span lang="EN-US" style="font-family: '微软雅黑','sans-serif'; mso-bidi-font-family: 微软雅黑"><span style="mso-list: Ignore">①<span style="line-height: normal; font-variant: normal; font-style: normal; font-family: 'Times New Roman'; font-weight: normal">&nbsp;&nbsp;&nbsp;&nbsp; </span></span></span><span style="font-family: '微软雅黑','sans-serif'">首先备份此<span lang="EN-US">html</span>模板内容（请一定要备份，不能跳过此步骤）</span></font></span><font color="#000000"><span style="font-family: '微软雅黑','sans-serif'; font-size: 8pt"><span lang="EN-US"><o:p></o:p></span></span></font></p>
<p class="MsoNormal" style="text-indent: -18pt; margin: 0cm 0cm 0pt 33.75pt; mso-list: l0 level1 lfo1">
	<span style="font-size: 12px"><font color="#000000"><span lang="EN-US" style="font-family: '微软雅黑','sans-serif'; mso-bidi-font-family: 微软雅黑"><span style="mso-list: Ignore">②<span style="line-height: normal; font-variant: normal; font-style: normal; font-family: 'Times New Roman'; font-weight: normal">&nbsp;&nbsp;&nbsp;&nbsp; </span></span></span><span style="font-family: '微软雅黑','sans-serif'">点击【节点字段属性批量设置】，生成系统默认模板（覆盖了老的模板，在①中已经备份）</span></font></span><font color="#000000"><span style="font-family: '微软雅黑','sans-serif'; font-size: 8pt"><span lang="EN-US"><o:p></o:p></span></span></font></p>
<p class="MsoNormal" style="text-indent: 15.75pt; margin: 0cm 0cm 0pt">
	&nbsp;</p>
<p class="MsoNormal" style="text-indent: 15.75pt; margin: 0cm 0cm 0pt">
	<span style="font-size: 12px"><span lang="EN-US" style="font-family: '微软雅黑','sans-serif'; mso-no-proof: yes"><font color="#000000"><v:shape id="_x0000_i1026" style="width: 6in; height: 204.75pt; visibility: visible" type="#_x0000_t75"><v:imagedata o:title="" src="file:///C:\Users\CC\AppData\Local\Temp\msohtmlclip1\01\clip_image003_wev8.png"></v:imagedata></v:shape><o:p></o:p></font></span></span></p>
<p class="MsoNormal" style="text-indent: 15.75pt; margin: 0cm 0cm 0pt">
	<span style="font-size: 12px"><span lang="EN-US" style="font-family: '微软雅黑','sans-serif'; mso-no-proof: yes"><o:p><font color="#000000">&nbsp;<img width="80%" alt="docimages_0" src="../../images/2_wev8.png" />&nbsp;&nbsp;&nbsp;</font></o:p></span></span></p>
<p class="MsoNormal" style="text-indent: 15.75pt; margin: 0cm 0cm 0pt">
	<span style="font-size: 11px"><span lang="EN-US" style="font-family: '微软雅黑','sans-serif'; mso-no-proof: yes"><o:p></o:p></span></span></p>
<p class="MsoNormal" style="text-indent: 15.75pt; margin: 0cm 0cm 0pt">
	&nbsp;</p>
<p class="MsoNormal" style="text-indent: 15.75pt; margin: 0cm 0cm 0pt">
	<span style="font-size: 12px"><span lang="EN-US" style="font-family: '微软雅黑','sans-serif'; mso-no-proof: yes"><o:p></o:p></span></span></p>
<p class="MsoNormal" style="text-indent: 15.75pt; margin: 0cm 0cm 0pt">
	<span style="font-size: 12px"><span style="font-family: '微软雅黑','sans-serif'; mso-no-proof: yes"><font color="#000000">③<span lang="EN-US">. </span>在系统生成的默认模板中，找到生成的明细块，拷贝出来，替换老模板原来的明细块即可，如果对生成的样式不满意，可以在此基础上进行微调即可。</font></span></span></p>
<p>
	<img width="80%" alt="docimages_0" src="../../images/3_wev8.png" />&nbsp;&nbsp;&nbsp;</p>
<p class="MsoNormal" style="text-indent: 15.75pt; margin: 0cm 0cm 0pt">
	<span style="font-family: '微软雅黑','sans-serif'; font-size: 8pt; mso-no-proof: yes"><font color="#000000"><span lang="EN-US"><o:p></o:p></span></font></span></p>
<p class="MsoNormal" style="text-indent: 15.75pt; margin: 0cm 0cm 0pt">
	<span lang="EN-US" style="font-family: '微软雅黑','sans-serif'; mso-no-proof: yes"><v:shape id="_x0000_i1027" style="width: 6in; height: 212.25pt; visibility: visible" type="#_x0000_t75"><v:imagedata o:title="" src="file:///C:\Users\CC\AppData\Local\Temp\msohtmlclip1\01\clip_image005_wev8.png"></v:imagedata></v:shape></span><span lang="EN-US" style="font-family: '微软雅黑','sans-serif'; font-size: 8pt"><o:p></o:p></span></p>

<p class="MsoNormal" style="margin: 0cm 0cm 0pt">
	<span style="font-size: 12px"><font color="#000000"><b style="mso-bidi-font-weight: normal"><span lang="EN-US" style="font-family: '微软雅黑','sans-serif'">3.</span></b><b style="mso-bidi-font-weight: normal"><span style="font-family: '微软雅黑','sans-serif'">启用跨浏览器模式，并保存。</span></b></font></span></p>
<%
}else if(languageid == 8){
%>
&nbsp;&nbsp;&nbsp;&nbsp;<b>Description of operation</b>
<%
}else if(languageid == 9){
%>

<%}%>
</div>

</body>
</html>
