
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="CoMainTypeComInfo" class="weaver.cowork.CoMainTypeComInfo" scope="page"/>

<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<%@ taglib uri="/browserTag" prefix="brow"%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
if(! HrmUserVarify.checkUserRight("collaborationtype:edit", user)) { 
    response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

%>
<%
int id = Util.getIntValue(request.getParameter("id"),0);

String sql="select * from cowork_maintypes where id="+id;
RecordSet.executeSql(sql);
RecordSet.next();
String typename = RecordSet.getString("typename");
String category = Util.null2String(RecordSet.getString("category"));
String sequence = RecordSet.getString("sequence");
String categorypath = "";
if(!category.equals("")){
    String[] categoryArr = Util.TokenizerString2(category,",");
    try{
	    /*categorypath += "/"+MainCategoryComInfo.getMainCategoryname(categoryArr[0]);
	    categorypath += "/"+SubCategoryComInfo.getSubCategoryname(categoryArr[1]);
	    categorypath += "/"+SecCategoryComInfo.getSecCategoryname(categoryArr[2]);*/
	    categorypath = SecCategoryComInfo.getAllParentName(categoryArr[2],true);
    }catch(Exception e){
    	categorypath = SecCategoryComInfo.getAllParentName(category,true);
    	
    }
}
boolean canDel = true;
if(id!=0){
	sql="select * from cowork_types where departmentid="+id;
	RecordSet.executeSql(sql);
	if(RecordSet.next()){
		canDel = false;
	}
}
String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(93,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(178,user.getLanguage());
String needfav ="1";
String needhelp ="";

%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:checkSubmit(),''} " ;
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
<input type=hidden name=operation value="edit">
<input type=hidden name=id value="<%=id%>">
<wea:layout attributes="{'cw1':'30%','cw2':'70%'}">
	<wea:group context='<%= SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>' >
		<wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
		<wea:item>
			<wea:required id="nameimage" required="true">
				<INPUT class=inputstyle type=text maxLength=60 size=25 name=name id=coworkname value="<%=typename%>" onchange='checkinput("name","nameimage")'>
            </wea:required>
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(17616,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(92,user.getLanguage())%></wea:item>
		<wea:item>
            
             <brow:browser viewType="0" name="mypath" 
	         browserUrl="/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategorySingleBrowser.jsp"
	         browserValue='<%=category %>' idKey="id" nameKey="path"
	         browserSpanValue = '<%=categorypath%>'
	         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1' 
	         completeUrl="/data.jsp?type=categoryBrowser" width="90%" ></brow:browser>
	         
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(15513,user.getLanguage())%></wea:item>
		<wea:item>
			<wea:required id="sequenceimage" required="true">
				<input type="text" id='sequence' name='sequence' value="<%=sequence %>" 
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
		var typename = '<%=typename%>';
		$.post("/cowork/type/CoworkMainTypeCheck.jsp",{coworkname:encodeURIComponent($("#coworkname").val()),id:'<%=id%>'},function(datas){  
				 if(datas.indexOf("unfind") > 0 && check_form(document.frmMain,'name')){
						document.frmMain.operation.value="edit";
						document.frmMain.submit();
				 } else if (datas.indexOf("exist") > 0){				 	  
				 	  window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%> [ "+coworkname+" ] <%=SystemEnv.getHtmlLabelName(24943,user.getLanguage())%>");
				 }
		});
}

function onShowCatalog(spanName) {
    var result = showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/CategoryBrowser.jsp");
    if (result != null) {
        if (wuiUtil.getJsonValueByIndex(result,0)> 0){
          jQuery("#"+spanName).html(wuiUtil.getJsonValueByIndex(result,2));
          jQuery("#mypath").val(wuiUtil.getJsonValueByIndex(result,3)+","+wuiUtil.getJsonValueByIndex(result,4)+","+wuiUtil.getJsonValueByIndex(result,1));
        }else{
          jQuery("#"+spanName).html("");
          jQuery("#mypath").val("");
        }
    }
}

jQuery(function(){
	checkinput("name","nameimage");
	checkinput("sequence","sequenceimage");
});

function callBackSelectUpdate(event,data,name,_callbackParams){
	jQuery("#mypathspan").find("a").attr("title",data.path);
	jQuery("#mypathspan").find("a").html(data.path);
	jQuery("#mypath").val(data.mainid+","+data.subid+","+data.id);
}

</script>
</BODY></HTML>
