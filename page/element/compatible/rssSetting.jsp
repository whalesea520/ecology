
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<%@ page import="weaver.conn.RecordSet"  %>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="java.net.*"%>

<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:include page="/systeminfo/init_wev8.jsp"></jsp:include>

<jsp:useBean id="sci" class="weaver.system.SystemComInfo" scope="page" />
<link href='/css/Weaver_wev8.css' type=text/css rel=stylesheet>
<script type='text/javascript' src='/js/weaver_wev8.js'></script>
<%
String userLanguageId = Util.null2String(request.getParameter("userLanguageId"));
String eid = Util.null2String(request.getParameter("eid"));
String tabId = Util.null2String(request.getParameter("tabId"));
String tabTitle = "";	
String value = "";
String ebaseid = Util.null2String(request.getParameter("ebaseid"));
String method = Util.null2String(request.getParameter("method"));

RecordSet rssRs = new RecordSet();
if (session.getAttribute(eid + "_Add") != null) {
	Hashtable tabAddList = (Hashtable) session.getAttribute(eid+ "_Add");
	
	if (tabAddList.containsKey(tabId)) {
		Hashtable tabInfo = (Hashtable) tabAddList.get(tabId);
		tabTitle = Util.null2String((String) tabInfo.get("tabTitle"));
		value = Util.null2String((String) tabInfo.get("tabWhere"));
	}
}
if("".equals(value)){
	rssRs.execute("select * from hpNewsTabInfo where eid="+eid +" and tabid="+tabId);
	if(rssRs.next()){
		tabTitle = rssRs.getString("tabTitle");
		value = rssRs.getString("sqlWhere");
	}
}

String setValue1="";
String setValue2=""; 
String setValue3="";
String setValue4="";

if(!"".equals(value))
{
    ArrayList rssSetList=Util.TokenizerString(value,"^,^");
  
    if(rssSetList.size()>=3)
    {
    	
    	if(rssSetList.size()>=4){
    		
    		setValue1=Util.null2String((String)rssSetList.get(0));
        	setValue2=Util.null2String((String)rssSetList.get(1));
        	setValue3=Util.null2String((String)rssSetList.get(2));
        	setValue4 = Util.null2String((String)rssSetList.get(3));
    	}else{
    		setValue2=Util.null2String((String)rssSetList.get(0));
        	setValue3=Util.null2String((String)rssSetList.get(1));
        	setValue4=Util.null2String((String)rssSetList.get(2));
    	}
    }
    else if(rssSetList.size()==2)
    {
    	String tsetValue1=Util.null2String((String)rssSetList.get(0));
    	String tsetValue2=Util.null2String((String)rssSetList.get(1));
    	if((tsetValue1.equals("1")&&value.indexOf("^,^1")==0)||(tsetValue1.equals("2")&&value.indexOf("^,^2")==0))
    	{
    		setValue1 = "";
    		setValue2 = tsetValue1;
    		setValue3 = tsetValue2;
    	}
    	else
    	{
    		setValue1 = tsetValue1;
    		setValue2 = tsetValue2;
    		setValue3 = "3";
    	}
    }
}
else
{
	setValue1 = "";
	setValue2 = "1";
	setValue3 = "3";
}
if(setValue4.equals("")){
	setValue4 = sci.getRsstype();
}

setValue2 = setValue2.equals("")?"1":setValue2;
setValue3 = setValue3.equals("")?"3":setValue3;

tabTitle = Util.toHtml2(tabTitle.replaceAll("&","&amp;"));



String showMode1="";
String showMode2=""; 
String showMode3="";
String showMode4="";
String showMode5="";
String showMode6="";



if("1".equals(setValue2)) showMode1=" selected ";
if("2".equals(setValue2)) showMode2=" selected ";
if("3".equals(setValue3)) showMode3=" selected ";
if("4".equals(setValue3)) showMode4=" selected ";
if("1".equals(setValue4)) showMode5=" selected ";
if("2".equals(setValue4)) showMode6=" selected ";

%>
		<jsp:include page="/systeminfo/commonTabHead.jsp">
		   <jsp:param name="mouldID" value="portal"/>
		   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(19480,user.getLanguage()) %>"/>  
		</jsp:include>
		
		  <%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
  
	  <%
	  RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:checkSubmit(),_self} " ;
	  RCMenuHeight += RCMenuHeightStep ;
	
	  %>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
	
	<table id="topTitle" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td width="160px">
					</td>
					<td class="rightSearchSpan"
						style="text-align: right; width: 500px !important">
						<input type="button" value="<%=SystemEnv.getHtmlLabelName(30986,user.getLanguage())%>" class="e8_btn_top"
							onclick="checkSubmit();" />
						&nbsp;&nbsp;&nbsp;
						<span title="<%=SystemEnv.getHtmlLabelName(83721,user.getLanguage())%>" class="cornerMenu"></span>
					</td>
				</tr>
			</table>
		
	<wea:layout type="2Col">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(33396,user.getLanguage())%>' attributes="{'class':\"e8_title e8_title_1\"}">
			<wea:item>
				<%=SystemEnv.getHtmlLabelName(229,Util.getIntValue(userLanguageId)) %>
			</wea:item>
			<wea:item>
				<input class=inputStyle id='tabTitle_<%=eid%>' name='tabTitle_<%=eid%>' type='text' value="<%=Util.toHtml2(tabTitle.replaceAll("&","&amp;")) %>" onchange='checkinput("tabTitle_<%=eid %>","tabTitleSpan_<%=eid %>")' />
				<SPAN id='tabTitleSpan_<%=eid %>'>
				<%
				if(tabTitle.equals("")){
					%>
					<IMG src="/images/BacoError_wev8.gif" align=absMiddle>
					<% 
				}
				%>
				</SPAN>
			</wea:item>
			<wea:item>
				<%=SystemEnv.getHtmlLabelName(15935,Util.getIntValue(userLanguageId)) %>
			</wea:item>
			<wea:item>
				<INPUT TYPE='text' name="_whereKey_<%=eid %>" value='<%=setValue1 %>' class='inputStyle'>
			</wea:item>
			<wea:item>
				<%=SystemEnv.getHtmlLabelName(19669,Util.getIntValue(userLanguageId)) %>
			</wea:item>
			<wea:item>
				<select  name="_whereKey_<%=eid %>" >
			   			<option <%=showMode1 %> value=1><%=SystemEnv.getHtmlLabelName(19670,Util.getIntValue(userLanguageId)) %></option>
			   			<option <%=showMode2 %> value=2><%=SystemEnv.getHtmlLabelName(19671,Util.getIntValue(userLanguageId)) %></option>
			   	</select>&nbsp;( <%=SystemEnv.getHtmlLabelName(19672,Util.getIntValue(userLanguageId)) %>)
			</wea:item>
			<wea:item>
				<%=SystemEnv.getHtmlLabelName(24020,Util.getIntValue(userLanguageId)) %>
			</wea:item>
			<wea:item>
				<select  name="_whereKey_<%=eid %>" >
			    		<option <%=showMode3 %> value=3>and</option>
			    		<option <%=showMode4 %> value=4>or</option>
			    </select>&nbsp;<img title='<%=SystemEnv.getHtmlLabelName(24022,Util.getIntValue(userLanguageId)) %>' align='absMiddle' src='/images/remind_wev8.png' complete='complete'/>
			</wea:item>
			<wea:item>
				<%=SystemEnv.getHtmlLabelName(24661,Util.getIntValue(userLanguageId)) %>
			</wea:item>
			<wea:item>
				<select  name="_whereKey_<%=eid %>" onchange="doChange(this)">
					<option <%=showMode5 %> value=1><%=SystemEnv.getHtmlLabelName(108,Util.getIntValue(userLanguageId)) %></option>
					<option <%=showMode6 %> value=2><%=SystemEnv.getHtmlLabelName(15038,Util.getIntValue(userLanguageId)) %></option>
				</select>
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
		
	<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>  
<script type="text/javascript">
//获取所有设置条件的值
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
	//var topDocIds = document.getElementById("topdocids_"+eid).value;
	return whereKeyStr;
}

function doChange(obj){
	if("<%=isIE%>"=="false"){
		if(obj.options[obj.options.selectedIndex].value==1){
			alert("<%=SystemEnv.getHtmlLabelName(30353,Util.getIntValue(userLanguageId))%>")
			obj.options[1].selected = true;
		}
	}
	
}

function onCancel(){
		var dialog = parent.getDialog(window);	
		dialog.close();
	}
	
	function checkSubmit(){
		var dialog = parent.getDialog(window);
		parentWin = dialog.currentWindow;
		parentWin.doTabSave('<%=eid %>','<%=ebaseid %>','<%=tabId %>','<%=method %>');
	}

</script>

