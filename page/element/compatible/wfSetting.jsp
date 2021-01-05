
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<%@ page import="java.util.*" %>
<%@ page import="weaver.conn.RecordSet"  %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.GCONST"  %>
<%@ page import="weaver.file.Prop"  %>
<%@page import="java.net.*"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<jsp:include page="/systeminfo/init_wev8.jsp"></jsp:include>

<link href='/css/Weaver_wev8.css' type=text/css rel=stylesheet>
<script type='text/javascript' src='/js/weaver_wev8.js'></script>
<%
 String userLanguageId = Util.null2String(request.getParameter("userLanguageId"));
 String eid = Util.null2String(request.getParameter("eid"));
 String tabId = Util.null2String(request.getParameter("tabId"));
 String tabTitle = null;
 String showCopy = "0";
 String countFlag = "0";
 String ebaseid =Util.null2String(request.getParameter("ebaseid"));
 String method =Util.null2String(request.getParameter("method"));
 int completeflag = 0;
 if(!"1".equals(showCopy)){
	 showCopy = "0";
 }
try {

int viewType=1;	
//int isExclude=0;
//如果session里面有 则直接从session里面取出来
RecordSet rs=new RecordSet();
if (session.getAttribute(eid + "_Add") != null) {
		Hashtable tabAddList = (Hashtable) session.getAttribute(eid+ "_Add");
		if (tabAddList.containsKey(tabId)) {
			Hashtable tabInfo = (Hashtable) tabAddList.get(tabId);
			viewType = Util.getIntValue((String) tabInfo.get("viewType"));
			completeflag = Util.getIntValue((String) tabInfo.get("completeflag"));
			tabTitle =(String)tabInfo.get("tabTitle"); 
			showCopy = Util.null2String((String) tabInfo.get("showCopy"));
			countFlag = Util.null2String((String) tabInfo.get("countFlag"));
		}
		
}
if(tabTitle==null){
	rs.executeSql("select * from hpsetting_wfcenter where eid="+eid+" and tabid="+tabId);
    if(rs.next()){ 
		viewType=rs.getInt("viewType");
		completeflag=rs.getInt("completeflag");
		tabTitle = rs.getString("tabtitle");
		countFlag = Util.null2o(rs.getString("countflag"));
		showCopy = Util.null2String(rs.getString("showCopy"));
		countFlag = Util.null2String(rs.getString("countFlag"));
    }else{
    	tabTitle = "";
    }
}
String radViewType_1="  ";
String radViewType_2="  ";
String radViewType_3="  ";
String radViewType_4="  "; 
String radViewType_5="  "; 
String radViewType_6="  "; 
String radViewType_7="  "; 
String radViewType_8="  ";
String radViewType_10="  "; 
String showCopyDivDispaly = "none";
String showCopyChecked = "";
String showMyrequestDivDispaly = "none";
String countFlagDivDispaly = "";
if(viewType==1){ 
	radViewType_1=" selected ";
	showCopyDivDispaly = "";
	if("0".equals(showCopy)){
		showCopyChecked = "";
	}else{
		showCopyChecked = "checked";
	}
}
else if(viewType==2) radViewType_2=" selected ";
else if(viewType==3) radViewType_3=" selected ";
else if(viewType==4) radViewType_4=" selected ";
else if(viewType==5) radViewType_5=" selected ";
else if(viewType==6){
	radViewType_6=" selected ";
	countFlagDivDispaly = "none";
}else if(viewType==7) radViewType_7=" selected ";
else if(viewType==8){
	radViewType_8=" selected ";
	countFlagDivDispaly = "none";
}else if(viewType==10) radViewType_10=" selected ";	

String countFlagChecked = "";
if("0".equals(countFlag)){
	countFlagChecked = "";
}else{
	countFlagChecked = "checked";
}

String isselected_0 = " selected ";
String isselected_1 = "";
String isselected_2 = "";
String myrequestselect = "";
if(viewType==4){
    showMyrequestDivDispaly = "";
    if(completeflag==1){
        isselected_0 = "";
        isselected_1 = " selected ";	
        isselected_2 = "";
    }else if(completeflag==2){
        isselected_0 = "";
        isselected_1 = "";
        isselected_2 = " selected ";
    }
}

//String strExclude1="";
//String strExclude2="";
//if(isExclude==0){
//	strExclude1=" selected ";
//} else {
//	strExclude2=" selected ";
//}

Prop prop = Prop.getInstance();
String hasOvertime = Util.null2String(prop.getPropValue(GCONST.getConfigFile(), "ecology.overtime"));
String hasChangStatus = Util.null2String(prop.getPropValue(GCONST.getConfigFile(), "ecology.changestatus"));
String returnStr = "";
String spanDisplay ="";
if(!tabTitle.equals("")){
	spanDisplay ="none";
}
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
				<input class=inputStyle id='tabTitle_<%=eid%>' name=tabTitle_<%=eid%> type='text' value="<%=Util.toHtml2(tabTitle.replaceAll("&","&amp;")) %>" onchange='checkinput("tabTitle_<%=eid %>","tabTitleSpan_<%=eid %>")' />
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
				<%=SystemEnv.getHtmlLabelName(17483,Util.getIntValue(userLanguageId)) %><!--查看类型--></TD>
			</wea:item>
			<wea:item>
				<input type='hidden' name=_whereKey_<%=eid %> value=''>
			<select name='radViewType_<%=eid %>' id='radViewType_<%=eid %>' onchange='onViewTypeChange(this,<%=eid %>)'>
				<option value='1' <%=radViewType_1 %>><%=SystemEnv.getHtmlLabelName(1207,Util.getIntValue(userLanguageId)) %></option> <!--  //待办事宜 -->
				<option value='2' <%=radViewType_2 %>><%=SystemEnv.getHtmlLabelName(17991,Util.getIntValue(userLanguageId)) %></option><!--  //已办事宜 -->
				<option value='3' <%=radViewType_3 %>><%=SystemEnv.getHtmlLabelName(17992,Util.getIntValue(userLanguageId)) %></option><!--  //办结事宜 -->
				<option value='4' <%=radViewType_4 %>><%=SystemEnv.getHtmlLabelName(1210,Util.getIntValue(userLanguageId)) %></option><!--  //我的请求 -->
				<option value='5' <%=radViewType_5 %>><%=SystemEnv.getHtmlLabelName(21639,Util.getIntValue(userLanguageId)) %></option><!--  //抄送事宜 -->
				<option value='6' <%=radViewType_6 %>><%=SystemEnv.getHtmlLabelName(21640,Util.getIntValue(userLanguageId)) %></option><!--//督办事宜 -->
		 <%
		 if(!"".equals(hasOvertime)){
			 %>
			 	<option value='7' <%=radViewType_7 %>><%=SystemEnv.getHtmlLabelName(21641,Util.getIntValue(userLanguageId)) %></option><!--  //超时事宜-->
		<%
		 }
		 
		 if(!"".equals(hasChangStatus)){
			 %>
				<option value='8' <%=radViewType_8 %>><%=SystemEnv.getHtmlLabelName(21643,Util.getIntValue(userLanguageId)) %></option><!--  //反馈事宜-->
		 <%
		 }	
		 %>
				<option value='10' <%=radViewType_10 %>><%=SystemEnv.getHtmlLabelName(25398,Util.getIntValue(userLanguageId)) %><%=SystemEnv.getHtmlLabelName(21561,Util.getIntValue(userLanguageId)) %></option><!--//所有事宜 -->
				
			</select>	
 			<span id='showCopySpan_<%=eid %>' style='display:<%=showCopyDivDispaly %>'>&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(89,Util.getIntValue(userLanguageId))+SystemEnv.getHtmlLabelName(21639,Util.getIntValue(userLanguageId)) %><input type=checkbox  <%=showCopyChecked %> name=showCopy_<%=eid %> id=showCopy_<%=eid %> onclick='onShowCopyClick(this)'></span>
 			<span id='myrequestSpan_<%=eid %>' style='display:<%=showMyrequestDivDispaly %>'><select id='completeflag_<%=eid %>' onchange='setCompleteFlag(this.value)'><option value=0 <%=isselected_0 %>></option><option value=1 <%=isselected_1 %>><%=SystemEnv.getHtmlLabelName(732,Util.getIntValue(userLanguageId)) %></option><option value=2 <%=isselected_2 %>><%=SystemEnv.getHtmlLabelName(1961,Util.getIntValue(userLanguageId)) %></option></select></span>
			<span id='countFlagSpan_<%=eid %>' style='display:<%=countFlagDivDispaly%>'>&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(82641,Util.getIntValue(userLanguageId))%><input type='checkbox'  <%=countFlagChecked %> name='countFlag_<%=eid %>' id='countFlag_<%=eid %>' onclick='onCountFlagClick(this)'></span>
			</wea:item>
			<wea:item>
				<%=SystemEnv.getHtmlLabelName(21672,Util.getIntValue(userLanguageId)) %>
			</wea:item>
			<wea:item>
				<iframe  style='overflow-x:yes;'BORDER=0 FRAMEBORDER='no' NORESIZE=NORESIZE id='ifrmViewType_<%=eid %>' name='ifrmViewType_<%=eid %>"' width='100%' height='300px'  scrolling='auto'
		 			src='/homepage/element/setting/WorkflowCenterBrowser.jsp?tabId=<%=tabId %>&viewType=<%=viewType %>&eid=<%=eid %>&ebaseid=<%=ebaseid %>&random=<%=Math.random() %>'></iframe>
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
		<%






} catch (Exception e) {			
e.printStackTrace();
}

%>

<SCRIPT LANGUAGE="JavaScript">

    

	$(document).ready(function(){
	   
		<%if("1".equals(showCopy)){%>
		    var showcopy ;
		    //抄送人
		    function  setShowCopy(){
		      showcopy = jQuery(window.frames["ifrmViewType_<%=eid%>"]).contents().find("#showCopy");
		      if( showcopy.length > 0 ){
		           showcopy.val( "1" ); 
		      }else{
		         setTimeout(function(){setShowCopy()},500);
		      }
		    }
		    setShowCopy();
		    
		<%}%>
		<%if("1".equals(countFlag)){%>
			window.frames["ifrmViewType_<%=eid%>"].document.getElementById("countFlag").value = "1"; 
		<%}%>
		
		
	})
	

	function onViewTypeChange(obj,eid){	
		if(obj.value=='1'){
			document.getElementById("showCopySpan_<%=eid%>").style.display=''
			document.getElementById("myrequestSpan_<%=eid%>").style.display='none'
			document.getElementById("countFlagSpan_<%=eid%>").style.display='';
		}else if(obj.value=='4'){
			document.getElementById("showCopySpan_<%=eid%>").style.display='none'
			document.getElementById("myrequestSpan_<%=eid%>").style.display=''
			document.getElementById("countFlagSpan_<%=eid%>").style.display='';
		}else if(obj.value=='6'|| obj.value=='8'){
			document.getElementById("countFlagSpan_<%=eid%>").style.display='none';
			document.getElementById("showCopySpan_<%=eid%>").style.display='none';
			document.getElementById("myrequestSpan_<%=eid%>").style.display='none';
			$("#countFlag_<%=eid%>").removeAttr("checked");
			$("#ifrmViewType_<%=eid%>").contents().find("#countFlag").val("0");
		}else{
			document.getElementById("countFlagSpan_<%=eid%>").style.display='';
			document.getElementById("showCopySpan_<%=eid%>").style.display='none'
			document.getElementById("myrequestSpan_<%=eid%>").style.display='none'
		}
		$(document).find("#ifrmViewType_"+eid).contents().find("#frmFlwCenter").find("input[name='viewType']").val(obj.value);
        document.getElementById("ifrmViewType_"+eid).src="/homepage/element/setting/WorkflowCenterBrowser.jsp?viewType="+obj.value+"&eid="+eid+"&ebaseid=<%=ebaseid %>&tabId=<%=tabId%>&showCopy=<%=showCopy%>&completeflag=<%=completeflag%>&countFlag=<%=countFlag%>";
		//alert(obj.value)
	}
	
	function onShowCopyClick(obj){
		if(obj.checked){
			$("#ifrmViewType_<%=eid%>").contents().find("#showCopy").val("1"); 
			
		}else{
			$("#ifrmViewType_<%=eid%>").contents().find("#showCopy").val("0"); 
			//window.frames["ifrmViewType_<%=eid%>"].document.getElementById("showCopy").value = "0";
		}
	}
	
	function onCountFlagClick(obj){
		if(obj.checked){
			$("#ifrmViewType_<%=eid%>").contents().find("#countFlag").val("1"); 
			
		}else{
			$("#ifrmViewType_<%=eid%>").contents().find("#countFlag").val("0"); 
		}
	}

	function setCompleteFlag(flagValue){
		$("#ifrmViewType_<%=eid%>").contents().find("#completeflag").val(flagValue); 
	    //window.frames["ifrmViewType_<%=eid%>"].document.getElementById("completeflag").value = flagValue; 
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
  
  </SCRIPT>

