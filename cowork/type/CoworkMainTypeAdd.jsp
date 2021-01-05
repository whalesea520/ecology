
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="CoMainTypeComInfo" class="weaver.cowork.CoMainTypeComInfo" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%

if(! HrmUserVarify.checkUserRight("collaborationtype:edit", user)) { 
    response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

rs.execute("select max(sequence) FROM cowork_maintypes ");
rs.next();
int sequence = Util.getIntValue(rs.getString(1),0);
sequence++;

%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>

</head>
<%

String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(178,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSubmit(),''} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="collaboration"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(178,user.getLanguage()) %>"/>
</jsp:include>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<span title="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" style="font-size: 12px;cursor: pointer;">
				<input class="e8_btn_top middle" onclick="doSubmit()" type="button" jQuery1392950000546="32" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>"/>
			</span>
			<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage())%>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<FORM id=weaver name=frmMain action="MainTypeOperation.jsp" method=post>
<input type=hidden name=operation value="add">
<wea:layout attributes="{'cw1':'30%','cw2':'70%'}">
	<wea:group context='<%= SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>' >
		<wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
		<wea:item>
			<wea:required id="nameimage" required="true">
				<INPUT class=inputstyle type=text maxLength=60 size=25 name=name id=coworkname onchange='checkinput("name","nameimage")'>
			</wea:required>
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(17616,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(92,user.getLanguage())%></wea:item>
		<wea:item>
			
			 <brow:browser viewType="0" name="mypath" 
	         browserUrl="/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategorySingleBrowser.jsp" idKey="id" nameKey="path"
	         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
	         completeUrl="/data.jsp?type=categoryBrowser" width="90%" ></brow:browser>
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(15513,user.getLanguage())%></wea:item>
		<wea:item>
			<wea:required id="sequenceimage" required="true">
				<input id='sequence' name='sequence' value="<%=sequence %>" type="text"
					onkeypress="ItemCount_KeyPress()" onchange='checkinput("sequence","sequenceimage")'>
			</wea:required>
		</wea:item>
	</wea:group>
</wea:layout>
</FORM>

<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout>
		<wea:group context="" attributes="{groupDisplay:none}">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="parentWin.closeDialog();">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>  
<script language=javascript>
var dialog = parent.getDialog(window); 
var parentWin = parent.getParentWindow(window);
function doSubmit() {
		var coworkname = $("#coworkname").val();				
		$.post("/cowork/type/CoworkMainTypeCheck.jsp",{coworkname:encodeURIComponent($("#coworkname").val())},function(datas){  
				 if(datas.indexOf("unfind") > 0 && check_form(frmMain,"name,sequence")){
					 frmMain.submit();
				 } else if (datas.indexOf("exist") > 0){				 	  
				 	 window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%> [ "+coworkname+" ] <%=SystemEnv.getHtmlLabelName(24943,user.getLanguage())%>");
				 }
		});
}

function onShowCatalog(spanName) {
    var result = showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/CategoryBrowser.jsp");
    if (result != null) {
        if (wuiUtil.getJsonValueByIndex(result,0)> 0){
          spanName.innerHTML=wuiUtil.getJsonValueByIndex(result,2);
          document.all("mypath").value=wuiUtil.getJsonValueByIndex(result,3)+","+wuiUtil.getJsonValueByIndex(result,4)+","+wuiUtil.getJsonValueByIndex(result,1);
        }else{
          spanName.innerHTML="";
          document.all("mypath").value="";
        }
    }
}

jQuery(function(){
	checkinput("sequence","sequenceimage");
});


function callBackSelectUpdate(event,data,name,_callbackParams){
	jQuery("#mypathspan").find("a").attr("title",data.path);
	jQuery("#mypathspan").find("a").html(data.path);
	jQuery("#mypath").val(data.mainid+","+data.subid+","+data.id);
}
</script>


</BODY></HTML>

