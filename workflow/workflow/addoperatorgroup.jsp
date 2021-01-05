<!DOCTYPE html>
 	

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
 <%@ include file="/systeminfo/init_wev8.jsp" %>
 <%@ taglib uri="/browser" prefix="brow"%>
 <%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
 <jsp:useBean id="CompanyVirtualComInfo" class="weaver.hrm.companyvirtual.CompanyVirtualComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WFNodeMainManager" class="weaver.workflow.workflow.WFNodeMainManager" scope="page" />
<jsp:useBean id="FormFieldTransMethod" class="weaver.general.FormFieldTransMethod" scope="page" />
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<%
	String isclose = Util.null2String(request.getParameter("isclose"));	
 	String ajax=Util.null2String(request.getParameter("ajax"));
	int design = 0;//Util.getIntValue(request.getParameter("design"),0);
	
%>
<script type="text/javascript">
<!--
	if("<%=isclose%>" === "1")
	{
		var parentWin = parent.parent.getParentWindow(parent);
		try{
			parentWin._table.reLoad();
		}catch(e){}
		try{
			parentWin.location.reload();
		}catch(e){}
		var dialog = parent.parent.getDialog(parent);
		dialog.close();
		
	}
//-->
</script>
<script language=javascript>
	var dialog = parent.parent.getDialog(parent);
	$(document).ready(function(){
  		resizeDialog(document);
  		//初始增加一行


  		//阻止事件冒泡
  		jQuery('#addBtn,#deleteBtn').click(function(event) {
  			if (event) {
				event.stopPropagation();
			}
  		});
	});

	function closeCancle(){
		var dialog = parent.parent.getDialog(parent);
		dialog.close();
	}
</script>
<html>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<LINK href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script language="JavaScript" src="/js/addRowBg_wev8.js" ></script>
<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.bgiframe.min_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.ajaxQueue_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/jquery.autocomplete_wev8.css" />
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/browser_wev8.css" />
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(259,user.getLanguage());
String needfav ="";
String needhelp ="";
int nodeid=Util.getIntValue(Util.null2String(request.getParameter("nodeid")),0);
int wfid=Util.getIntValue(Util.null2String(request.getParameter("wfid")),0);
int formid=Util.getIntValue(Util.null2String(request.getParameter("formid")),0);
String isbill=Util.null2String(request.getParameter("isbill"));
String iscust=Util.null2String(request.getParameter("iscust"));
request.getSession(true).setAttribute("por0_con","");
request.getSession(true).setAttribute("por0_con_cn","");
String nodetype="";
char flag=2;
RecordSet.executeProc("workflow_NodeType_Select",""+wfid+flag+nodeid);

if(RecordSet.next())
	nodetype = RecordSet.getString("nodetype");

int iscreate = 0;
if(nodetype.equals("0"))
	iscreate = 1;

String sql ="";
//System.out.println(nodetype);

////////多维组织option
String VirtualOrganization = "";
if(CompanyComInfo.getCompanyNum()>0){
	CompanyComInfo.setTofirstRow();
	while(CompanyComInfo.next()){
		VirtualOrganization +="<option value="+CompanyComInfo.getCompanyid() +">"+SystemEnv.getHtmlLabelName(83179,user.getLanguage())+"</option>";
	}
}
if(CompanyVirtualComInfo.getCompanyNum()>0){
	CompanyVirtualComInfo.setTofirstRow();
	while(CompanyVirtualComInfo.next()){
		VirtualOrganization +=" <option value="+CompanyVirtualComInfo.getCompanyid()+"> " +
					(CompanyVirtualComInfo.getVirtualType().length()>4?CompanyVirtualComInfo.getVirtualType():CompanyVirtualComInfo.getVirtualType()) +
					" </option> ";
	}
}
////////
%>



</head>
<body>
<%
if(design==0) {
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%
}
%>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
if(!ajax.equals("1"))
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:selectall(),_self} " ;
else
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:nodeopaddsave(this),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
if(design==1) {
	RCMenu += "{"+SystemEnv.getHtmlLabelName(309,user.getLanguage())+",javascript:designOnClose(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
}
else {
if(!ajax.equals("1"))
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:history.back(-1),_self} " ;
else
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:cancelEditNode(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
}
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<div class="zDialog_div_content">
<form id="addopform" name="addopform" method=post action="wf_operation.jsp" >
<%
if(ajax.equals("1")){
%>
<input type="hidden" name="ajax" value="1">
<%}%>
<input type="hidden" name="selectindex">
<input type="hidden" name="selectvalue">
<input type="hidden" name="nodetype_operatorgroup" value="<%=nodetype%>" >
<input type="hidden" value="<%=nodeid%>" name="nodeid">
<input type="hidden" value="<%=wfid%>" name="wfid">
<input type="hidden" value="<%=formid%>" name="formid">
<input type=hidden name=isbill value="<%=isbill%>">
<input type=hidden name=iscust value="<%=iscust%>">
<input type="hidden" value="<%=design%>" name="design">
<input type="hidden" name="singerorder_flag" id="singerorder_flag" value="0">
<input type="hidden" name="singerorder_type" id="singerorder_type" value="">
<input type="hidden" name="singerorder_level" id="singerorder_level" value="-1">
<input type="hidden" value="addoperatorgroup" name="src">
<input type="hidden" value="0" name="groupnum">
<table id="topTitle" cellpadding="0" cellspacing="0" >
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage()) %>" class="e8_btn_top"  onclick="nodeopaddsave(this);"/>&nbsp;&nbsp;
			<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table> 

	<wea:layout attributes="{'expandAllGroup':'true'}">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
			<wea:item><%=SystemEnv.getHtmlLabelName(15545,user.getLanguage())%></wea:item>
			<wea:item>
		    	<input class=Inputstyle type=text name="groupname" size=40 maxlength="60"  onchange='checkinput("groupname","groupnameimage")'>
		    	<SPAN id=groupnameimage>
		    	<IMG src="/images/BacoError_wev8.gif" align=absMiddle>
		    	</SPAN>
		    	<input type=hidden name="canview" value="1">
		    	<input type=hidden name="iscreate" value="<%=iscreate%>">		
			</wea:item>

			<%
				if(iscreate == 1){
			%>	
			<wea:item>
				<%=SystemEnv.getHtmlLabelName(125061,user.getLanguage()) %> 


			</wea:item>
			<wea:item>
				<%String opchange = "browpropertychange(this,'workflowids')";%>
				<brow:browser onPropertyChange='<%=opchange %>' viewType="0" name="workflowids" browserValue="" 
	                browserUrl='<%="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowMutiBrowser.jsp?wfids=#id#" %>'
	                hasInput="true" isSingle="false" hasBrowser = "true" isMustInput="1"
	                completeUrl="/data.jsp?type=workflowBrowser"  temptitle='<%= SystemEnv.getHtmlLabelNames("33806",user.getLanguage())%>'
	                browserSpanValue="" browserDialogWidth="600px;" width="auto">
		        </brow:browser>		        
		        &nbsp;<input type="checkbox" name="deleteBeforeAdd" value="true" checked style="padding-left:5px;"/>
		        <span style="padding-left:5px;"><%=SystemEnv.getHtmlLabelName(125062,user.getLanguage()) %></span>
			</wea:item>
			<%
				}
			%>
			
		</wea:group>
		</wea:layout>
		
		<%--
		<wea:group context='<%=SystemEnv.getHtmlLabelName(21956,user.getLanguage())%>'>
			<wea:item attributes="{'colspan':'full','isTableList':'true'}">
				<table width=100% class=ListStyle cellspacing=1>
					<tr class=DataLight>
						<td width=11%>
							<nobr><input type=radio  name=operategroup checked value=1 onclick="onChangetype(this.value)"><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%>
						</td>
						<%if(!nodetype.equals("0")){%>
						<td width=11%>
							<nobr><input type=radio  name=operategroup value=2 onclick="onChangetype(this.value)"><%=SystemEnv.getHtmlLabelName(15549,user.getLanguage())%></nobr>
						</td>
						<td width=11%>
							<nobr><input type=radio  name=operategroup value=3 onclick="onChangetype(this.value)"><%=SystemEnv.getHtmlLabelName(15550,user.getLanguage())%></nobr>
						</td>
						<td width=11%>
							<nobr><input type=radio  name=operategroup value=4 onclick="onChangetype(this.value)"><%=SystemEnv.getHtmlLabelName(15551,user.getLanguage())%></nobr>
						</td>
						<td width=11%>
							<nobr><input type=radio  name=operategroup value=5 onclick="onChangetype(this.value)"><%=SystemEnv.getHtmlLabelName(15552,user.getLanguage())%></nobr>
						</td>
						<td width=11%>
							<nobr><input type=radio  name=operategroup value=6 onclick="onChangetype(this.value)"><%=SystemEnv.getHtmlLabelName(15553,user.getLanguage())%></nobr>
						</td>
						<td width=11%>
							<nobr><input type=radio  name=operategroup value=7 onclick="onChangetype(this.value)"><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%></nobr>
						</td>
						<td width=11%>
							<nobr><input type=radio  name=operategroup value=9 onclick="onChangetype(this.value)"><%=SystemEnv.getHtmlLabelName(15586,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(99,user.getLanguage())%></nobr>
						</td>
						<%}%>
						<td width=11%>
							<nobr>
							<%if(iscust.equals("1")){%>
							<input type=radio  name=operategroup value=8 onclick="onChangetype(this.value)"><%=SystemEnv.getHtmlLabelName(15554,user.getLanguage())%>
							<%}%>
							</nobr>
						</td>
					</tr>
				</table>	
			</wea:item>
		</wea:group>
		 --%>
<div>
<table class="LayoutTable" style="width:100%;">
			<colgroup>
				<col width="10%">
				<col width="90%">
			</colgroup>
			<tbody><tr height="30px;">
				<td >
					<span class="groupbg" style="display:block;margin-left:10px;"> </span>
					<span class="e8_grouptitle" style="display:block;color:#5b5b5b!important;"><%=SystemEnv.getHtmlLabelName(21956,user.getLanguage())%></span>
				</td>
				<td  colspan="2" style="text-align: center;">

				<table width=100% class=ListStyle cellspacing=1>
					<tr>
						<td width=11%>
							<nobr><input type=radio  name=operategroup checked value=1 onclick="onChangetype(this.value)"><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%></nobr>
						</td>
						<%if(!nodetype.equals("0")){%>
						<td width=11%>
							<nobr><input type=radio  name=operategroup value=2 onclick="onChangetype(this.value)"><%=SystemEnv.getHtmlLabelName(15549,user.getLanguage())%></nobr>
						</td>
						<td width=11%>
							<nobr><input type=radio  name=operategroup value=3 onclick="onChangetype(this.value)"><%=SystemEnv.getHtmlLabelName(15550,user.getLanguage())%></nobr>
						</td>
						<td width=11%>
							<nobr><input type=radio  name=operategroup value=4 onclick="onChangetype(this.value)"><%=SystemEnv.getHtmlLabelName(15551,user.getLanguage())%></nobr>
						</td>
						<td width=11%>
							<nobr><input type=radio  name=operategroup value=5 onclick="onChangetype(this.value)"><%=SystemEnv.getHtmlLabelName(15552,user.getLanguage())%></nobr>
						</td>
						<td width=11%>
							<nobr><input type=radio  name=operategroup value=6 onclick="onChangetype(this.value)"><%=SystemEnv.getHtmlLabelName(15553,user.getLanguage())%></nobr>
						</td>
						<td width=11%>
							<nobr><input type=radio  name=operategroup value=7 onclick="onChangetype(this.value)"><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%></nobr>
						</td>
						<td width=11%>
							<nobr><input type=radio  name=operategroup value=9 onclick="onChangetype(this.value)"><%=SystemEnv.getHtmlLabelName(15586,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(99,user.getLanguage())%></nobr>
						</td>
						<td width=11%>
							<nobr><input type=radio  name=operategroup value=10 onclick="onChangetype(this.value)"><%=SystemEnv.getHtmlLabelNames("34066,522",user.getLanguage())%></nobr>
						</td>
						<%}%>
						<td width=11%>
							<nobr>
							<%if(iscust.equals("1")){%>
							<input type=radio  name=operategroup value=8 onclick="onChangetype(this.value)"><%=SystemEnv.getHtmlLabelName(15554,user.getLanguage())%>
							<%}%>
							</nobr>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr class="Spacing" style="height:1px;display:">
							<td class="Line" colspan="2">
		</td>
		</tr>
	</tbody>
</table>
</div>
<!--  -->
		
		<wea:layout  attributes="{'expandAllGroup':'true'}">
		<wea:group context="" attributes="{'groupDisplay':'none'}">
		 	<wea:item attributes="{'isTableList':'true','colspan':'full'}">
		<jsp:include page="/workflow/workflow/addoperatorgroup_inner.jsp">
			<jsp:param name="nodetype" value="<%=nodetype %>" />
			<jsp:param name="ajax" value="<%=ajax %>" />
			<jsp:param name="isbill" value="<%=isbill %>" />
			<jsp:param name="formid" value="<%=formid %>" />
			<jsp:param name="VirtualOrganization" value="<%=VirtualOrganization %>" />
			<jsp:param name="wfid" value="<%=wfid %>" />
			<jsp:param name="nodeid" value="<%=nodeid %>" />
		</jsp:include>

<%-- 会签属性 start --%>
<%if (!nodetype.equals("0")) {%>
<%--
<div id="signordertr" style="display:none;">
	<wea:layout type="table" attributes="{'cols':'5','cws':'20%'}">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(15557,user.getLanguage())+SystemEnv.getHtmlLabelName(713,user.getLanguage()) %>'>
			<wea:item type="thead"><input type=radio name=signorder value="0" onclick="hideOrganizer(this)"><%=SystemEnv.getHtmlLabelName(15556,user.getLanguage())%></wea:item>
			<wea:item type="thead"><input type=radio name=signorder value="1" onclick="hideOrganizer(this)" checked><%=SystemEnv.getHtmlLabelName(15557,user.getLanguage())%></wea:item>
			<wea:item type="thead"><input type=radio name=signorder value="2" onclick="hideOrganizer(this)"><%=SystemEnv.getHtmlLabelName(15558,user.getLanguage())%></wea:item>
			<wea:item type="thead"><input type=radio name=signorder value="3" onclick="hideOrganizer(this)"><%=SystemEnv.getHtmlLabelName(21227,user.getLanguage())%></wea:item>
			<wea:item type="thead"><input type=radio name=signorder value="4" onclick="hideOrganizer(this)"><%=SystemEnv.getHtmlLabelName(21228,user.getLanguage())%></wea:item>
		</wea:group>
	</wea:layout>
</div>

 --%>
<!--  -->
<div id="signordertr"  >
	<!--?xml version="1.0" encoding="UTF-8"?-->
<!-- 所有没有内容的标签请增加一个空格 -->

		<table class="LayoutTable" style="width:100%;">
			<colgroup>
				<col width="10%">
				<col width="90%">
			</colgroup>
			<tbody><tr height="30px;">
				<td >
					<span class="groupbg" style="display:block;margin-left:10px;"> </span>
					<span class="e8_grouptitle" style="display:block;color:#5b5b5b!important;"><%=SystemEnv.getHtmlLabelName(125351,user.getLanguage()) %></span>
				</td>
				<td  colspan="2" style="text-align: center;">

				<table width="80%" class="ListStyle">
					<tr >
						<td ><input type=radio name=signorder value="0" onclick="hideOrganizer(this)"><%=SystemEnv.getHtmlLabelName(15556,user.getLanguage())%>
							</td>
						<td>
							<input type=radio name=signorder value="1" onclick="hideOrganizer(this)" checked><%=SystemEnv.getHtmlLabelName(15557,user.getLanguage())%>
						</td>
						<td>
							<input type=radio name=signorder value="2" onclick="hideOrganizer(this)"><%=SystemEnv.getHtmlLabelName(15558,user.getLanguage())%>
						</td>
						<td>
							<input type=radio name=signorder value="3" onclick="hideOrganizer(this)"><%=SystemEnv.getHtmlLabelName(21227,user.getLanguage())%>
						</td>
						<td>
							<input type=radio name=signorder value="4" onclick="hideOrganizer(this)"><%=SystemEnv.getHtmlLabelName(21228,user.getLanguage())%>
						</td>
				</tr>
				</table>
		</td>
	</tr>
	<tr class="Spacing" style="height:1px;display:">
						<td class="Line" colspan="2">
	</td>
	</tr>
</tbody>
</table>

</div>

<script language=javascript>
	var dialog = parent.parent.getDialog(parent);
var insertindex = 0;
	$(document).ready(function(){
  		//resizeDialog(document);
  		//初始增加一行


  		addMatrixRowNew();

  	
	});



	  function Matrix2(insertindex){
	
	//	alert("---add---insertindex--"+insertindex);
		jQuery("#matrixTmpfield").empty()
		jQuery("#matrixCfield").empty();
		var formid = <%=formid%>;
		var isbill = <%=isbill%> ;
	   var matrixTmp=jQuery("#matrixTmp").val();
	   var issystem;
	//	alert("--matrixTmpT---"+matrixTmp);
		jQuery.ajax({
		url:"/matrixmanage/pages/matrixbrowserOp.jsp",
		type:"post",
		data:{"matrixTmp":matrixTmp,"operator":"1"},
		dataType: "text",
		complete: function(){
		},
		success:function (returnValues, textStatus) {
	    	if (returnValues == undefined || returnValues == null) {
	    		alert("<%=SystemEnv.getHtmlLabelName(129417, user.getLanguage())%>");
	    		return;
	    	} else {
				
	
				jQuery("#matrixTmpfield").html(returnValues.trim());
				jQuery("#matrixTmpfield").selectbox("detach")
				__jNiceNamespace__.beautySelect("#matrixTmpfield")
	    	}
	      }
	   });

	   jQuery.ajax({
		url:"/matrixmanage/pages/matrixbrowserOp.jsp",
		type:"post",
		data:{"matrixTmp":matrixTmp,"operator":"0"},
		dataType: "text",
		complete: function(){
		},
		success:function (returnValues, textStatus) {
	    	if (returnValues == undefined || returnValues == null) {
	    		alert("<%=SystemEnv.getHtmlLabelName(129417, user.getLanguage())%>");
	    		return;
	    	} else {
				//alert("--insertindex--1111-"+insertindex);
				if(insertindex){
				  // alert("----0-returnValues.trim()---"+returnValues.trim());
				jQuery("#matrixCfield_"+insertindex).html(returnValues.trim());
				
				jQuery("#matrixCfield_"+insertindex).selectbox("detach")
				__jNiceNamespace__.beautySelect("#matrixCfield_"+insertindex)
					jQuery("#__max1").html(returnValues.trim());
				jQuery("#__max1").selectbox("detach")
				__jNiceNamespace__.beautySelect("#__max1")
				}else{
				 // alert("----0-returnValues.trim()---"+returnValues.trim());
				 //alert("--insertindex--2222-"+insertindex);
				jQuery("[id^=matrixCfield]").html(returnValues.trim());
				
				jQuery("[id^=matrixCfield]").selectbox("detach")
				__jNiceNamespace__.beautySelect("[id^=matrixCfield]")
					jQuery("#__max1").html(returnValues.trim());
				jQuery("#__max1").selectbox("detach")
				__jNiceNamespace__.beautySelect("#__max1")
				}
				//alert(jQuery("matrixCfield").html());
				//changetypeall();
				changetype(insertindex);
				
				   
	    	}
	      }
	   });

	      jQuery.ajax({
		url:"/matrixmanage/pages/matrixbrowserOp.jsp",
		type:"post",
		data:{"matrixTmp":matrixTmp,"operator":"2"},
		dataType: "text",
		complete: function(){
		},
		success:function (returnValues, textStatus) {
	    	if (returnValues == undefined || returnValues == null) {
	    		alert("<%=SystemEnv.getHtmlLabelName(129417, user.getLanguage())%>");
	    		return;
	    	} else {
				// alert("----0-returnValues.trim()---"+returnValues.trim());
					issystem = returnValues.trim();
					//jQuery("#issystem").val(returnValues.trim());
					if(issystem ==1 || issystem==2)   {	
						jQuery("[id^=matrixCfield]").attr("disabled","disabled");	
						jQuery("[id^=matrixCfield]").selectbox("detach")
				__jNiceNamespace__.beautySelect("[id^=matrixCfield]")
					}else{
						   jQuery("[id^=matrixCfield]").removeAttr("disabled");	
						jQuery("[id^=matrixCfield]").selectbox("detach")
				__jNiceNamespace__.beautySelect("[id^=matrixCfield]")
						}
	    	}
	      }
	   });


	    jQuery.ajax({
		url:"/matrixmanage/pages/matrixbrowserOp.jsp",
		type:"post",
		data:{"formid":formid,"isbill":isbill,"operator":"3"},
		dataType: "text",
		complete: function(){
		},
		success:function (returnValues, textStatus) {
	    	if (returnValues == undefined || returnValues == null) {
	    		alert("<%=SystemEnv.getHtmlLabelName(129417, user.getLanguage())%>");
	    		return;
	    	} else {
				//alert("--insertindex-2260--"+insertindex);
				if(typeof(insertindex) ==  "undefined"){
			//	  	alert("--insertindex-2269--"+insertindex);
				 //alert("----3-returnValues.trim()---"+returnValues.trim());
				 if(window.console)console.log("----3-returnValues.trim()---"+returnValues.trim());
				jQuery("[id^=matrixRulefield]").html(returnValues.trim());
				jQuery("#__max2").html(returnValues.trim());
				jQuery("[id^=matrixRulefield]").selectbox("detach")
				__jNiceNamespace__.beautySelect("[id^=matrixRulefield]")
				//alert(jQuery("#matrixRulefield").html());
				}else{
						  // alert("----0-returnValues.trim()---"+returnValues.trim());
				jQuery("#matrixRulefield"+insertindex).html(returnValues.trim());
				 jQuery("#__max2").html(returnValues.trim());
				jQuery("#matrixRulefield_"+insertindex).selectbox("detach")
				__jNiceNamespace__.beautySelect("#matrixRulefield_"+insertindex)
				
				}
	    	}
	      }
	   });	
	  
	/*   if(insertindex)	{
	   	changetype(insertindex);
	   }else{
	   var matrixTableRows = jQuery('#matrixTable tr.data');
		if(matrixTableRows){
		indexinsert =0;
		for(indexinsert=0;indexinsert<matrixTableRows.length;indexinsert++){
			 changetype(insertindex);
		}
		}
	   }   */
	   
	}


	function Matrix(insertindex){
	//	alert("---add---Matrix--"+insertindex);
		jQuery("#matrixTmpfield").empty();
		jQuery("#matrixCfield").empty();
		var formid = <%=formid%>;
		var isbill = <%=isbill%> ;
	   var matrixTmp=jQuery("#matrixTmp").val();
	   var issystem;
	//	alert("--matrixTmpT---"+matrixTmp);
		jQuery.ajax({
		url:"/matrixmanage/pages/matrixbrowserOp.jsp",
		type:"post",
		data:{"matrixTmp":matrixTmp,"operator":"1"},
		dataType: "text",
		complete: function(){
		},
		success:function (returnValues, textStatus) {
	    	if (returnValues == undefined || returnValues == null) {
	    		alert("<%=SystemEnv.getHtmlLabelName(129417, user.getLanguage())%>");
	    		return;
	    	} else {
				
	
				jQuery("#matrixTmpfield").html(returnValues.trim());
				jQuery("#matrixTmpfield").selectbox("detach")
				__jNiceNamespace__.beautySelect("#matrixTmpfield")
				
	    	}
	      }
	   });

	   jQuery.ajax({
		url:"/matrixmanage/pages/matrixbrowserOp.jsp",
		type:"post",
		data:{"matrixTmp":matrixTmp,"operator":"0"},
		dataType: "text",
		complete: function(){
		},
		success:function (returnValues, textStatus) {
	    	if (returnValues == undefined || returnValues == null) {
	    		alert("<%=SystemEnv.getHtmlLabelName(129417, user.getLanguage())%>");
	    		return;
	    	} else {
				 if(insertindex){
				  // alert("----0-returnValues.trim()---"+returnValues.trim());
				jQuery("#matrixCfield_"+insertindex).html(returnValues.trim());
				
				jQuery("#matrixCfield_"+insertindex).selectbox("detach")
				__jNiceNamespace__.beautySelect("#matrixCfield_"+insertindex)
					jQuery("#__max1").html(returnValues.trim());
				jQuery("#__max1").selectbox("detach")
				__jNiceNamespace__.beautySelect("#__max1")
				}else{
				 // alert("----0-returnValues.trim()---"+returnValues.trim());
				jQuery("[id^=matrixCfield]").html(returnValues.trim());
				
				jQuery("[id^=matrixCfield]").selectbox("detach")
				__jNiceNamespace__.beautySelect("[id^=matrixCfield]")
					jQuery("#__max1").html(returnValues.trim());
				jQuery("#__max1").selectbox("detach")
				__jNiceNamespace__.beautySelect("#__max1")
				}
				//changetype(insertindex);
				 changetypeall();
				
	    	}
	      }
	   });

	      jQuery.ajax({
		url:"/matrixmanage/pages/matrixbrowserOp.jsp",
		type:"post",
		data:{"matrixTmp":matrixTmp,"operator":"2"},
		dataType: "text",
		complete: function(){
		},
		success:function (returnValues, textStatus) {
	    	if (returnValues == undefined || returnValues == null) {
	    		alert("<%=SystemEnv.getHtmlLabelName(129417, user.getLanguage())%>");
	    		return;
	    	} else {
				// alert("----0-returnValues.trim()---"+returnValues.trim());
					issystem = returnValues.trim();
					//jQuery("#issystem").val(returnValues.trim());
					if(issystem ==1 || issystem==2)   {
						//alert("----0-issystem.trim()---"+issystem);
						//jQuery("#matrixCfield").attr("disabled","disabled");
						jQuery("[id^=matrixCfield]").attr("disabled","disabled");	
						jQuery("[id^=matrixCfield]").selectbox("detach")
				__jNiceNamespace__.beautySelect("[id^=matrixCfield]")
					}else{
						   jQuery("[id^=matrixCfield]").removeAttr("disabled");	
						jQuery("[id^=matrixCfield]").selectbox("detach")
				__jNiceNamespace__.beautySelect("[id^=matrixCfield]")
						}
			
	    	}
	      }
	   });


	/*   jQuery.ajax({
		url:"/matrixmanage/pages/matrixbrowserOp.jsp",
		type:"post",
		data:{"formid":formid,"isbill":isbill,"operator":"3"},
		dataType: "text",
		complete: function(){
		},
		success:function (returnValues, textStatus) {
	    	if (returnValues == undefined || returnValues == null) {
	    		alert("服务器运行出错!\n请联系系统管理员!");
	    		return;
	    	} else {
				if(insertindex){
				  // alert("----0-returnValues.trim()---"+returnValues.trim());
				jQuery("#matrixRulefield"+insertindex).html(returnValues.trim());
				  jQuery("#__max2").html(returnValues.trim());
				jQuery("#matrixRulefield_"+insertindex).selectbox("detach")
				__jNiceNamespace__.beautySelect("#matrixRulefield_"+insertindex)
				}else{
				 //alert("----3-returnValues.trim()---"+returnValues.trim());
				 if(window.console)console.log("----3-returnValues.trim()---"+returnValues.trim());
				jQuery("[id^=matrixRulefield]").html(returnValues.trim());
				jQuery("#__max2").html(returnValues.trim());
				jQuery("[id^=matrixRulefield]").selectbox("detach")
				__jNiceNamespace__.beautySelect("[id^=matrixRulefield]")
				//alert(jQuery("#matrixRulefield").html());
				}
				
	    	}
	      }
	   });	 */
	  
	}

  function selectAllMatrixRow(checked) {
	changeCheckboxStatus('#matrixTable tr.data td input:checkbox', checked);
}

function changeSelectAllMatrixRowStatus(checked) {
	changeCheckboxStatus('#matrixTable tr.header td input:checkbox', checked);
}

	Matrix2(insertindex);//这里放在addMatrixRowNew方法外面选择矩阵取值字段内容后就不会默认显示第一条了
	function addMatrixRowNew(){
	var lastRow = jQuery('<tr class="data"><td style="padding-left: 30px !important;"><input type="checkbox" value="'+ insertindex+ '" /></td><td><div class="cf"><span></span></div></td><td><div class="wf"><span></span></div></td><td></td></tr>');
	var lineRow = jQuery('<tr class="Spacing" style="height:1px!important;display:;"><td class="paddingLeft0" colspan="4"><div class="intervalDivClass"></div></td></tr>');
	var matrixTable = jQuery('#matrixTable');
	var formid = <%=formid%>;
	var isbill = <%=isbill%> ;
	var issystem;
	matrixTable.append(lastRow);
	matrixTable.append(lineRow);
	lastRow.jNice();
		

	 lastRow.find('div.cf span').append('<input type="hidden" issingle="true" ismustinput="1" viewtype="0" onpropertychange="" temptitle="" name="cf_'+ insertindex+ '" id="cf_'+ insertindex+ '" ><select style="width:140px" class=inputstyle id="matrixCfield_'+ insertindex+ '"  name="matrixCfield_'+ insertindex+ '" onchange = "selectShow('+ insertindex+ ');changetype('+ insertindex+ ');changetype2('+ insertindex+ ')" style="float:left;">'+jQuery("#__max1").html()+'</select>');


	 lastRow.find('div.cf span').append('<span id = "rule_'+insertindex+'">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(353, user.getLanguage())%></span>');

	lastRow.find('div.wf span').append('<input type="hidden" issingle="true" ismustinput="1" viewtype="0" onpropertychange="" temptitle="" name="wf_'+ insertindex+ '" id="wf_'+ insertindex+ '"> <select style="width:140px" class=inputstyle id="matrixRulefield_'+ insertindex+ '" name="matrixRulefield_'+ insertindex+ '"  onchange = "selectShow('+ insertindex+ ')"  style="float:left;">'+jQuery("#__max2").html()+'</select>');
	


	//matrixTable.append('<tr class="Spacing" style="height:1px!important;"><td colspan="8" class="paddingLeft0Table"><div class="intervalDivClass"></div></td></tr>');
	changeSelectAllMatrixRowStatus(false);
	changetype(insertindex);
	changetype2(insertindex);
	selectShow(insertindex);
	//当下拉框的内容只有一条时，样式为只读，多条时编辑
    if(jQuery("#matrixCfield_"+insertindex).find("option").length <= 1){
        jQuery("#matrixCfield_"+insertindex).attr("disabled","disabled");
    }
    __jNiceNamespace__.beautySelect("#matrixCfield_"+insertindex);
	insertindex = insertindex+1;
}


function selectShow(insertindex){

	if(document.getElementById("matrixTmp")){
		 // document.getElementById("matrix").setAttribute("value",document.getElementById("matrixTmp").getAttribute("value")); 
		  document.getElementById("matrix").value=document.getElementById("matrixTmp").value;
	}	 
	if(document.getElementById("matrixTmpfield")){
	     document.getElementById("vf").value=document.getElementById("matrixTmpfield").value;
		// document.getElementById("vf").setAttribute("value",document.getElementById("matrixTmpfield").getAttribute("value")); 
	 }
	 if(document.getElementById("matrixCfield_"+insertindex)){
		// document.getElementById("cf_"+insertindex).setAttribute("value",document.getElementById("matrixCfield_"+insertindex).getAttribute("value")); 
		 document.getElementById("cf_"+insertindex).value=document.getElementById("matrixCfield_"+insertindex).value;
	 }
	 if(document.getElementById("matrixRulefield_"+insertindex)){
		 //document.getElementById("wf_"+insertindex).setAttribute("value",document.getElementById("matrixRulefield_"+insertindex).getAttribute("value"));
		 document.getElementById("wf_"+insertindex).value=document.getElementById("matrixRulefield_"+insertindex).value;
	 }
	 
	}

function changetype(insertindex){
	var matrixTableRows = jQuery('#matrixTable tr.data');
if(typeof(insertindex) ==  "undefined"){
	insertindex = 0;
   for(insertindex=0;insertindex<matrixTableRows.length;insertindex++){
	   var matrixCfield=jQuery("#matrixCfield_"+insertindex).val();
	   var formid = <%=formid%>;
		var isbill = <%=isbill%> ;
		//alert("--matrixCfield---"+matrixCfield);
			if(matrixCfield>-1){
		jQuery.ajax({
		url:"/matrixmanage/pages/matrixbrowserOp.jsp",
		type:"post",
		data:{"matrixCfield":matrixCfield,"formid":formid,"isbill":isbill,"operator":"4"},
		dataType: "text",
		complete: function(){
		},
		success:function (returnValues, textStatus) {
	    	if (returnValues == undefined || returnValues == null) {
	    		alert("<%=SystemEnv.getHtmlLabelName(129417, user.getLanguage())%>");
	    		return;
	    	} else {
				insertindex = insertindex-1;
				jQuery("#matrixRulefield_"+insertindex).html(returnValues.trim());
				jQuery("#matrixRulefield_"+insertindex).selectbox("detach")
				__jNiceNamespace__.beautySelect("#matrixRulefield_"+insertindex)
				//jQuery("[id^=matrixRulefield_]").html(returnValues.trim());
				//jQuery("[id^=matrixRulefield_]").selectbox("detach")
				//__jNiceNamespace__.beautySelect("[id^=matrixRulefield_]")
				//alert(jQuery("#matrixRulefield_"+(insertindex-1)).html());
	    	}
	      }
	   });

			}
}
}else{
	var matrixCfield=jQuery("#matrixCfield_"+insertindex).val();
	   var formid = <%=formid%>;
		var isbill = <%=isbill%> ;
		//alert("--matrixCfield---"+matrixCfield);
			if(matrixCfield>-1){
		jQuery.ajax({
		url:"/matrixmanage/pages/matrixbrowserOp.jsp",
		type:"post",
		data:{"matrixCfield":matrixCfield,"formid":formid,"isbill":isbill,"operator":"4"},
		dataType: "text",
		complete: function(){
		},
		success:function (returnValues, textStatus) {
	    	if (returnValues == undefined || returnValues == null) {
	    		alert("<%=SystemEnv.getHtmlLabelName(129417, user.getLanguage())%>");
	    		return;
	    	} else {
				
	
				jQuery("#matrixRulefield_"+insertindex).html(returnValues.trim());
				jQuery("#matrixRulefield_"+insertindex).selectbox("detach")
				__jNiceNamespace__.beautySelect("#matrixRulefield_"+insertindex)
				//alert(jQuery("#matrixTmpfield"));
				//alert(jQuery("#matrixTmpfield").html());
	    	}
	      }
	   });

			}

}
}

function changetypeall(){
	var matrixTableRows = jQuery('#matrixTable tr.data');
	//alert("--insertindex--2367-"+insertindex);
	//alert("--222--all-");
	var insertindex;
   for(insertindex=0;insertindex<matrixTableRows.length+5;insertindex++){
	   var matrixCfield=jQuery("#matrixCfield_"+insertindex).val();
	   var formid = <%=formid%>;
		var isbill = <%=isbill%> ;
		//alert("-matrixCfield-3333-"+matrixCfield);
		if(matrixCfield>-1){
		jQuery.ajax({
		url:"/matrixmanage/pages/matrixbrowserOp.jsp",
		type:"post",
		data:{"matrixCfield":matrixCfield,"formid":formid,"isbill":isbill,"operator":"4"},
		dataType: "text",
		complete: function(){
		},
		success:function (returnValues, textStatus) {
			//alert("succ");
	    	if (returnValues == undefined || returnValues == null) {
	    		alert("<%=SystemEnv.getHtmlLabelName(129417, user.getLanguage())%>");
	    		return;
	    	} else {
				//insertindex = insertindex-1;
			//	alert("-insertindex-3333-");
				//	alert("--(returnValues.trim()--3333-"+returnValues.trim());
						//alert("--matrixCfield---"+matrixCfield);
				//jQuery("#matrixRulefield_"+insertindex).html(returnValues.trim());
				//jQuery("#matrixRulefield_"+insertindex).selectbox("detach")
				//__jNiceNamespace__.beautySelect("#matrixRulefield_"+insertindex)
				jQuery("[id^=matrixRulefield_]").html(returnValues.trim());
				jQuery("[id^=matrixRulefield_]").selectbox("detach")
				__jNiceNamespace__.beautySelect("[id^=matrixRulefield_]")
				//alert(jQuery("#matrixRulefield_"+(insertindex-1)).html());
	    	}
	      }
	   });
		}

}

}

	function changetype2(insertindex){
		 //jQuery("#matrixRulefield_"+insertindex).find('div.cf span').after('2221212');
		// alert("-2312-insertindex---"+insertindex);
		 var matrixCfield=jQuery("#matrixCfield_"+insertindex).val();
	   var formid = <%=formid%>;
		var isbill = <%=isbill%> ;
		var typeid;
		//alert("-2317-matrixCfield---"+matrixCfield);
			if(matrixCfield>-1){
		jQuery.ajax({
		url:"/matrixmanage/pages/matrixbrowserOp.jsp",
		type:"post",
		data:{"matrixCfield":matrixCfield,"formid":formid,"isbill":isbill,"operator":"5"},
		dataType: "text",
		complete: function(){
		},
		success:function (returnValues, textStatus) {
	    	if (returnValues == undefined || returnValues == null) {
	    		alert("<%=SystemEnv.getHtmlLabelName(129417, user.getLanguage())%>");
	    		return;
	    	} else {
					
				   typeid = returnValues.trim();
				
				   if(162 == typeid){
					
					 //alert("----162----"+jQuery("#rule_"+insertindex).html());
						jQuery("#rule_"+insertindex).html('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(346, user.getLanguage())%>');
					//   jQuery("#matrixRulefield_"+insertindex).parent().before('<div id = Brule_"'+insertindex+'">包含</span>');
				  // lastRow.find('div.wf span').before('包含');
				   }  else{
				   	 jQuery("#rule_"+insertindex).html('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(353, user.getLanguage())%>');
				   }
				
	    	}
	      }
	   });

			}
	
	}

</script>
<!--  -->

<%-- 会签属性 end --%>

<%-- 批次、条件 start --%>
<div>
	<wea:layout type="4col">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(17892,user.getLanguage()) + "/" +SystemEnv.getHtmlLabelName(15364,user.getLanguage())%>'>
			<wea:item><%=SystemEnv.getHtmlLabelName(15364,user.getLanguage())%></wea:item>
			<wea:item>
				<%if(!ajax.equals("1")){%>
	    	  		<button type=button  class=Browser1 onclick="onShowBrowser4s('<%=wfid%>','<%=formid%>','<%=isbill%>')"></button>
	    	  	<%}else {%>
	    	  		<button type=button  class=Browser1 onclick="onShowBrowsers(this,'0','<%=nodeid %>','<%=formid%>','<%=isbill%>','<%=wfid%>')"></button>
	    	  	<%}%>
	    	  	<input type=hidden name=fromsrc id=fromsrc value="2">
	    	  	<input type=hidden name=conditionss id=conditionss>
	    	  	<input type=hidden name=ruleRelationship id=ruleRelationship>
	    	  	<input type=hidden name=conditioncn id=conditioncn>
	    	  	<input type=hidden name=rulemaplistids id=rulemaplistids>
			  	<span id="conditions">
			  
			   	</span>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(17892,user.getLanguage())%></wea:item>
			<wea:item><input type=text class=Inputstyle name=orders  onchange="check_number('orders');checkDigit(this,5,2)"  maxlength="5"></wea:item>
			
			<wea:item attributes="{\"samePair\":\"Tab_Coadjutant\",\"display\":\"none\"}"><%=SystemEnv.getHtmlLabelName(22675,user.getLanguage())%></wea:item>
			<wea:item attributes="{\"cols\":\"3\",\"samePair\":\"Tab_Coadjutant\",\"display\":\"none\"}">
				<div style="float:left;display:block;">
              		<button type=button  class=Browser1 onclick="onShowCoadjutantBrowser()"></button>
              	</div>
              	<div style="float:left;display:block;">
              		<span id="Coadjutantconditionspan"></span>
              	</div>
				<input type=hidden name=IsCoadjutant id=IsCoadjutant>
				<input type=hidden name=signtype id=signtype>
				<input type=hidden name=issyscoadjutant id=issyscoadjutant>
				<input type=hidden name=coadjutants id=coadjutants>
				<input type=hidden name=coadjutantnames id=coadjutantnames>
				<input type=hidden name=issubmitdesc id=issubmitdesc>
				<input type=hidden name=ispending id=ispending>
				<input type=hidden name=isforward id=isforward>
				<input type=hidden name=ismodify id=ismodify>
				<input type=hidden name=Coadjutantconditions id=Coadjutantconditions>
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<%-- 批次、条件 end --%>
<%--
	<table class="viewform" id="Tab_Coadjutant" name="Tab_Coadjutant" style="display:none">
		<input type=hidden name=IsCoadjutant id=IsCoadjutant>
		<input type=hidden name=signtype id=signtype>
		<input type=hidden name=issyscoadjutant id=issyscoadjutant>
		<input type=hidden name=coadjutants id=coadjutants>
		<input type=hidden name=coadjutantnames id=coadjutantnames>
		<input type=hidden name=issubmitdesc id=issubmitdesc>
		<input type=hidden name=ispending id=ispending>
		<input type=hidden name=isforward id=isforward>
		<input type=hidden name=ismodify id=ismodify>
		<input type=hidden name=Coadjutantconditions id=Coadjutantconditions>
      	<COLGROUP>	
  			<COL width="20%">
  			<COL width="40%">
  			<COL width="40%">
  		</COLGROUP>
   	  	<tr>
    	  	<td colSpan=3 style="padding-left:30px;"><%=SystemEnv.getHtmlLabelName(22675,user.getLanguage())%>
              	<button type=button  class=Browser onclick="onShowCoadjutantBrowser()"></button>
              	<span id="Coadjutantconditionspan"></span>
    	  	</td>
		</tr>
	</table>
--%>
<%}
else {%>
<input type=hidden name=fromsrc id=fromsrc value="2">
<input type=hidden name=conditionss id=conditionss>
<input type=hidden name=conditioncn id=conditioncn>
<span id="conditions">
</span>
<input type=hidden name=orders  value=0>
<table class="viewform" id="Tab_Coadjutant" name="Tab_Coadjutant" style="display:none">
     <input type=hidden name=IsCoadjutant id=IsCoadjutant>
     <input type=hidden name=signtype id=signtype>
     <input type=hidden name=issyscoadjutant id=issyscoadjutant>
     <input type=hidden name=coadjutants id=coadjutants>
     <input type=hidden name=coadjutantnames id=coadjutantnames>
     <input type=hidden name=issubmitdesc id=issubmitdesc>
     <input type=hidden name=ispending id=ispending>
     <input type=hidden name=isforward id=isforward>
     <input type=hidden name=ismodify id=ismodify>
     <input type=hidden name=Coadjutantconditions id=Coadjutantconditions>
     <COLGROUP>
         <COL width="20%">
         <COL width="40%">
         <COL width="40%">
         <tr>
             <td colSpan=3 style="padding-left:30px;"><%=SystemEnv.getHtmlLabelName(22675, user.getLanguage())%>
                 <button type=button  class=Browser onclick="onShowCoadjutantBrowser()"></button>
                 <span id="Coadjutantconditionspan"></span>
             </td>

         </tr>
 </table> 
<%}%>					 
		</wea:item>
		
		<wea:item attributes="{'isTableList':'true'}">
			<%if(!ajax.equals("1")){%>
			<wea:layout type="table" attributes="{'cols':'7','cws':'5%,20%,10%,15%,10%,30%,10%','formTableId':'oTable'}">
				<wea:group context="<%=SystemEnv.getHtmlLabelName(99,user.getLanguage())%>">
					<wea:item type="thead"><input type=checkbox name="checkall" onclick="checkAllChkBox()"></wea:item>
					<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></wea:item>
					<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
					<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%></wea:item>
					<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(15557,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(713,user.getLanguage())%></wea:item>
					<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(17892,user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(22671,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15364,user.getLanguage())%></wea:item>
					<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(17892,user.getLanguage())%></wea:item>
					<wea:item type="groupHead">
						<button type=button id="addBtn" Class=addbtn type=button accessKey=A onclick="addRow();" title="A-<%=SystemEnv.getHtmlLabelName(15582,user.getLanguage())%>"></BUTTON>
						<button type=button id="deleteBtn" Class=delbtn type=button accessKey=D onclick="deleteRow()" title="D-<%=SystemEnv.getHtmlLabelName(15583,user.getLanguage())%>"></BUTTON></div>
					</wea:item>	
				</wea:group>
			</wea:layout>
			<%}else{%>
			<wea:layout type="table" attributes="{'cols':'7','cws':'5%,15%,15%,15%,10%,30%,10%','formTableId':'oTable4op'}">
				<wea:group context="<%=SystemEnv.getHtmlLabelName(99,user.getLanguage())%>">
					<wea:item type="thead"><input type=checkbox name="checkall" onclick="checkAllChkBox()"></wea:item>
					<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></wea:item>
					<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
					<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%></wea:item>
					<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(15557,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(713,user.getLanguage())%></wea:item>
					<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(17892,user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(22671,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15364,user.getLanguage())%></wea:item>
					<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(17892,user.getLanguage())%></wea:item>
					<wea:item type="groupHead">
						<button type=button id="addBtn" Class=addbtn type=button accessKey=A onclick="addRow4op();" title="A-<%=SystemEnv.getHtmlLabelName(15582,user.getLanguage())%>"></BUTTON>
						<button type=button id="deleteBtn" Class=delbtn type=button accessKey=D onclick="deleteRow4op();" title="D-<%=SystemEnv.getHtmlLabelName(15583,user.getLanguage())%>"></BUTTON></div>
					</wea:item>
				</wea:group>
			</wea:layout>
			<%}%>
			
		</wea:item>	 
	</wea:group>
</wea:layout>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
		<wea:group context="" attributes="{groupDisplay:none}">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="closeCancle()">
	    </wea:item>
		</wea:group>
	</wea:layout>
</div>	
<%--
<%if(design==1){
%>
	<jsp:include page="/workflow/workflow/addoperatorgroupScript.jsp" flush="true">
		<jsp:param name="nodetype" value="<%=nodetype%>" />
		<jsp:param name="nodetype" value="<%=design%>" />
		<jsp:param name="formid" value="<%=formid%>" />
		<jsp:param name="isbill" value="<%=isbill%>" />
	</jsp:include>
	
<%}else{%>
 --%>
	<jsp:include page="/workflow/workflow/addoperatorgroupScriptND.jsp" flush="true">
		<jsp:param name="wfid" value="<%=wfid%>" />
		<jsp:param name="nodetype" value="<%=nodetype%>"/>
	</jsp:include>
<%--
<%} %>
 --%>
</form>

<script language="javascript" src="/wui/theme/ecology8/jquery/js/e8_btn_addOrdel_wev8.js"></script>
 
</body>
</html>
