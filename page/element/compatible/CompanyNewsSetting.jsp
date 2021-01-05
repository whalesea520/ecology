
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<jsp:useBean id="dnc" class="weaver.docs.news.DocNewsComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.net.*"%>
<%@ page import="weaver.file.Prop"  %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>

<jsp:include page="/systeminfo/init_wev8.jsp"></jsp:include>
<link href='/css/Weaver_wev8.css' type=text/css rel=stylesheet>
<script type='text/javascript' src='/js/weaver_wev8.js'></script>
<script language=javascript src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language=javascript src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type="text/css" />
<%
	
	String userLanguageId = Util.null2String(request.getParameter("userLanguageId"));
	String eid = Util.null2String(request.getParameter("eid"));
	String tabId = Util.null2String(request.getParameter("tabId"));
	String tabTitle = "";
	String whereKey = "";
	 String ebaseid = Util.null2String(request.getParameter("ebaseid"));
	 String method = Util.null2String(request.getParameter("method"));
	
	 if (session.getAttribute(eid + "_Add") != null) {
		Hashtable tabAddList = (Hashtable) session.getAttribute(eid+ "_Add");
		if (tabAddList.containsKey(tabId)) {
			Hashtable tabInfo = (Hashtable) tabAddList.get(tabId);
			whereKey = (String) tabInfo.get("tabWhere");
			tabTitle = (String) tabInfo.get("tabTitle");
		}
		
	}
	if("".equals(whereKey) && "".equals(tabTitle)){
		 rs.execute("select sqlwhere,tabtitle from hpnewstabinfo where eid="+eid+" and tabid="+tabId);
	    if(rs.next()){ 
	    	whereKey=rs.getString("sqlWhere");
	    	tabTitle=rs.getString("tabtitle");
	    }
	}
		
	
	String whereSrcName = "";
	if(!"".equals(whereKey))
	{
		whereSrcName = dnc.getDocNewsname(whereKey);
	}
%>

<jsp:include page="/systeminfo/commonTabHead.jsp">
		   <jsp:param name="mouldID" value="portal"/>
		   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(16390,user.getLanguage()) %>"/>  
</jsp:include>
<table id="topTitle" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td width="160px">
					</td>
					<td class="rightSearchSpan"
						style="text-align: right; width: 500px !important">
						<input type="button" value="<%=SystemEnv.getHtmlLabelName(30986,user.getLanguage()) %>" class="e8_btn_top"
							onclick="checkSubmit();" />
						&nbsp;&nbsp;&nbsp;
						<span title="<%=SystemEnv.getHtmlLabelName(83721,user.getLanguage()) %>" class="cornerMenu"></span>
					</td>
				</tr>
</table>

<wea:layout type="2Col">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(33396,user.getLanguage())%>' attributes="{'class':\"e8_title e8_title_1\"}">
		 <wea:item><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></wea:item>
	      
		  <wea:item>
		  	 <input  class=inputStyle id='tabTitle_<%=eid%>' name=tabTitle_<%=eid%> type='text' value="<%=Util.toHtml2(tabTitle.replaceAll("&","&amp;"))%>"   onchange='checkinput("tabTitle_<%=eid%>","tabTitleSpan_<%=eid%>")' />
		  	    <SPAN id='tabTitleSpan_<%=eid%>'>
				<% if(tabTitle.equals("")){%>
					<IMG src="/images/BacoError_wev8.gif" align=absMiddle>
				<%}%>
				</SPAN>
		  </wea:item>
		  
		  <wea:item><%=SystemEnv.getHtmlLabelName(22919,user.getLanguage())%></wea:item>
	      
		  <wea:item>
		  	 <INPUT id="_whereKey_<%=eid%>" type=hidden value="<%=whereKey %>" name="_whereKey_<%=eid%>">
				<BUTTON type="button" class=Browser onclick=onShowNewNews(_whereKey_<%=eid%>,spannews_<%=eid%>,<%=eid%>,0)></BUTTON>
				<SPAN id=spannews_<%=eid%>>
					<%
					if(!"".equals(whereKey))
					{
					%>
					<a href="/docs/news/NewsDsp.jsp?id=<%=whereKey %>" target='_blank'><%=whereSrcName %></a>
					<%
					}
					%>
				</SPAN>
		  </wea:item>
	    </wea:group>
    </wea:layout>


<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
	<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
		<wea:item type="toolbar">
	     <input type="button" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="onCancel();"/>
	    </wea:item>
	</wea:group>
	</wea:layout>
</div>	

<script type="text/javascript">

function onCancel(){
	var dialog = parent.getDialog(window);	
	dialog.close();
}

function getNewsSettingString(eid){
	var whereKeyStr="";
	var _whereKeyObjs=document.getElementsByName("_whereKey_"+eid);
	//得到上传的SQLWhere语句
	for(var k=0;k<_whereKeyObjs.length;k++){
		var _whereKeyObj=_whereKeyObjs[k];	
		if(_whereKeyObj.tagName=="INPUT" && _whereKeyObj.type=="checkbox" &&! _whereKeyObj.checked) continue;			
		whereKeyStr+=_whereKeyObj.value+"^,^";			
	}
	if(whereKeyStr!="") whereKeyStr=whereKeyStr.substring(0,whereKeyStr.length-3);	
	return whereKeyStr;
}

function checkSubmit(){
	var dialog = parent.getDialog(window);
	parentWin = dialog.currentWindow;
	parentWin.doTabSave('<%=eid %>','<%=ebaseid %>','<%=tabId %>','<%=method %>');
}

function onShowNewNews(input,span,eid,publishtype){
   splitflag = ",,,"
   var dlg=new window.top.Dialog();//定义Dialog对象
   dlg.Model=true;
   dlg.Width=550;//定义长度
   dlg.Height=550;
   dlg.URL="/systeminfo/BrowserMain.jsp?url=/docs/news/NewsBrowser.jsp?publishtype="+publishtype+"&splitflag="+splitflag;
   dlg.Title="<%=SystemEnv.getHtmlLabelName(16356,user.getLanguage())%>";
   dlg.callbackfun=function(params,datas){
	   if(datas){
			if(datas.id!=""){
				$(span).html("<a href='/docs/news/NewsDsp.jsp?id="+datas.id+"' target='_blank'>" +datas.name+"</a>");
				$(input).val(datas.id);
			}
			else {
				$(span).html("");
				$(input).val("");
			}
		}
   }
   dlg.show();
}

</script>
				
