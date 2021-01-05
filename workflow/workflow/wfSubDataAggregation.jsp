<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/tld/browser.tld" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rsfield" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="FormFieldlabelMainManager" class="weaver.workflow.form.FormFieldlabelMainManager" scope="page" />
<%FormFieldlabelMainManager.resetParameter();%>
<jsp:useBean id="DetailFieldComInfo" class="weaver.workflow.field.DetailFieldComInfo" scope="page" />
<%
int wfid = Util.getIntValue(request.getParameter("wfid"),0);
int subworkflowid = Util.getIntValue(request.getParameter("subworkflowid"),0);
String nodeid = Util.null2String(request.getParameter("nodeid"));
String titlename = Util.null2String(request.getParameter("workflowname"));
String isclose = Util.null2String(request.getParameter("isclose"));
boolean promptdiv = true;
//获取主流程所有字段信息
String formid = "0";
String isBill = "0";
rs.executeSql("SELECT formid,isBill FROM workflow_base WHERE id="+wfid);
if (rs.next()) {
	formid = rs.getString(1);
	isBill = rs.getString(2);
}
//获取子流程流程信息
String subformid = "0";
String subisBill = "0";
rs.executeSql("SELECT formid,isBill FROM workflow_base WHERE id="+subworkflowid);
if (rs.next()) {
	subformid = rs.getString(1);
	subisBill = rs.getString(2);
}

Map<String,String> subfieldmap = new HashMap<String,String>();
Map<String,String> subfieldnamemap = new HashMap<String,String>();
Map<String,String> subtypemap = new HashMap<String,String>();
Map<String,String> fieldhtmltypemap = new HashMap<String,String>();
Map<String,String> typemap = new HashMap<String,String>();
Map<String,String> iscreatedocmap = new HashMap<String,String>();
String rsmainfieldid = "";
String rssubfieldid = "";
String rssubfieldname = "";
String rssubtype = "";
String rsfieldhtmltype = "";
String rstype = "";
String rsiscreatedoc = "";
rs.executeSql("SELECT mainfieldid,subfieldid,subfieldname,subtype,fieldhtmltype,type,iscreatedoc FROM Workflow_DistributionSummary WHERE mainwfid="+wfid+" and mainformid="+formid+" and subwfid="+subworkflowid+" and subformid="+subformid+" and nodeid="+nodeid);
while(rs.next()) {
	rsmainfieldid = Util.null2String(Util.getIntValue(rs.getString(1),-1));
	rssubfieldid = Util.null2String(Util.getIntValue(rs.getString(2),-1));
	rssubfieldname = Util.null2String(rs.getString(3));
	rssubtype = Util.null2String(Util.getIntValue(rs.getString(4),-1));
	rsfieldhtmltype = Util.null2String(Util.getIntValue(rs.getString(5),-1));
	rstype = Util.null2String(Util.getIntValue(rs.getString(6),-1));
	rsiscreatedoc = Util.null2String(Util.getIntValue(rs.getString(7),-1));
	subfieldmap.put(rsmainfieldid, rssubfieldid);
	if(!"".equals(rssubfieldname)){
		subfieldnamemap.put(rsmainfieldid, rssubfieldname);
	}
	subtypemap.put(rsmainfieldid, rssubtype);
	fieldhtmltypemap.put(rsmainfieldid, rsfieldhtmltype);
	typemap.put(rsmainfieldid, rstype);
	iscreatedocmap.put(rsmainfieldid, rsiscreatedoc);
}
%>
<html>
<head>	
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.bgiframe.min_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/jquery.autocomplete_wev8.css" />
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/browser_wev8.css" />
<script type="text/javascript">

	
var parentWin = null;
var dialog = null;
try{
	parentWin = parent.getParentWindow(window);
	dialog =parent.getDialog(window);
}catch(e){}

function onClose(){
	dialog.close();
}

function changeFlowType(e,datas,name,params){
	if (datas != undefined && datas != null) {
		if(datas.fieldId != ''){
			var fieldId = datas.fieldId;
			var fieldName = datas.fieldName;
			var detailGroupid = datas.detailGroupid;
			var detailGroup = datas.detailGroup;
			var fieldHtmlType = datas.fieldHtmlType;
			var fieldType = datas.fieldType;
			var fieldNames = datas.fieldNames;
			
		    var sHtml = "";
			var curid = detailGroupid+"."+fieldId;
			var curname = detailGroup+"."+fieldName;
			sHtml += wrapshowhtml($G(name).getAttribute("viewtype"), curname, curid);
			
			jQuery($GetEle(name+"span")).html(sHtml);
			$GetEle(name).value = curid;
			jQuery("#"+name).parent().parent().parent().parent().parent().find("input[name=fieldHtmlType]").val(fieldHtmlType);
			jQuery("#"+name).parent().parent().parent().parent().parent().find("input[name=fieldType]").val(fieldType);
			jQuery("#"+name).parent().parent().parent().parent().parent().find("input[name=subfieldname]").val(fieldNames);
			//if(fieldHtmlType == "3" && (fieldType == "9" || fieldType == "37")){
			//	jQuery("#"+name).parent().parent().parent().parent().parent().parent().find("div[name=showcreatedoc]").css("display","");
			//	jQuery("#"+name).parent().parent().parent().parent().parent().parent().find("div[name=showcreatedoc]").find("div[name=showcreatename]").html("<%=SystemEnv.getHtmlLabelName(21718,user.getLanguage())%>");
			//}else if(fieldHtmlType == "6"){
			//	jQuery("#"+name).parent().parent().parent().parent().parent().parent().find("div[name=showcreatedoc]").css("display","");
			//	jQuery("#"+name).parent().parent().parent().parent().parent().parent().find("div[name=showcreatedoc]").find("div[name=showcreatename]").html("<%=SystemEnv.getHtmlLabelName(21719,user.getLanguage())%> ");
			//}else{
				//jQuery("#"+name).parent().parent().parent().parent().parent().parent().find("div[name=showcreatedoc]").css("display","none");
			//}
			//alert(fieldHtmlType);
			//alert(fieldType);
			if(fieldHtmlType == "1" && (fieldType == "2" || fieldType == "3" || fieldType == "4" || fieldType == "5")){
				jQuery("#"+name).parent().parent().parent().parent().parent().parent().find("div[name=showcreatedoc]").css("display","");
				jQuery("#"+name).parent().parent().parent().parent().parent().parent().find("div[name=showcreatedoc]").find("div[name=showcreatename]").html("<%=SystemEnv.getHtmlLabelName(130236,user.getLanguage())%>");
			}else{
				jQuery("#"+name).parent().parent().parent().parent().parent().parent().find("div[name=showcreatedoc]").css("display","none");
			}
		    
		    hoverShowNameSpan(".e8_showNameClass");
			try {
				var onppchgfnstr = jQuery("#"+ name).attr('onpropertychange');
				eval(onppchgfnstr);
				if (onppchgfnstr.indexOf("function onpropertychange") != -1) {
					onpropertychange();
				}
			} catch (e) {
			}
			try {
				var onppchgfnstr = jQuery("#"+ name + "__").attr('onpropertychange').toString();
				eval(onppchgfnstr);
				if (onppchgfnstr.indexOf("function onpropertychange") != -1) {
					onpropertychange();
				}
			} catch (e) {
			}
		}else{
			jQuery("#"+name).parent().parent().parent().parent().parent().parent().find("div[name=showcreatedoc]").css("display","none");
		}
	}
}

function wrapshowhtml(viewtype, ahtml, id) {
	var ismust = 1;
	if (viewtype == '1') {
		ismust = 2;
	}
	var str = "<span class=\"e8_showNameClass\">";
	str += ahtml;
	str += "<span class=\"e8_delClass\" id=\"" + id + "\" onclick=\"del(event,this," + ismust + ",false,{});\" style=\"opacity: 0; visibility: hidden;\">&nbsp;x&nbsp;</span></span>";
	return str;
}

function onSave(){
	var postValueStr="";
	jQuery("input[name=mainfieldid]").each(function(index,obj){
		var mainfieldid = $(obj).val();
		var fieldmate_ = $(obj).parent().parent().find("input[name=fieldmate_"+mainfieldid+"]").val();
		var fieldHtmlType = $(obj).parent().parent().find("input[name=fieldHtmlType]").val();
		var fieldType = $(obj).parent().parent().find("input[name=fieldType]").val();
		var iscreatedoc = $(obj).parent().parent().find("input[name=iscreatedoc]").val();
		var maindetailnum = $(obj).parent().find("input[name=maindetailnum]").val();
		var mainfieldname = $(obj).parent().find("input[name=mainfieldname]").val();
		var subfieldname = $(obj).parent().parent().find("input[name=subfieldname]").val();
		var subfieldid = null;
		var subtype = null;
		if(fieldmate_ != "" && fieldmate_ != null){
			subfieldid = fieldmate_.split(".")[1];
			subtype = fieldmate_.split(".")[0];
		}
		if(!!!subfieldid){
			subfieldid = "[(*_*)]";
        }
		if(!!!subtype){
			subtype = "[(*_*)]";
        }
		if(!!!fieldHtmlType){
			fieldHtmlType = "[(*_*)]";
		}
		if(!!!fieldType){
			fieldType = "[(*_*)]";
		}
		if(!!!maindetailnum){
			maindetailnum = "[(*_*)]";
		}
		if(!!!mainfieldname){
			mainfieldname = "[(*_*)]";
		}
		if(!!!subfieldname){
			subfieldname = "[(*_*)]";
		}
		
		postValueStr += mainfieldid+"\u001b"+subfieldid+"\u001b"+subtype+"\u001b"+fieldHtmlType+"\u001b"+fieldType+"\u001b"+iscreatedoc+"\u001b"+maindetailnum+"\u001b"+mainfieldname+"\u001b"+subfieldname+"\u0007";
	});
	postValueStr = postValueStr.substring(0,postValueStr.length-1);
	jQuery("input[name=postValue]").val(postValueStr);
	SearchForm.submit();
}

function changecheck(obj){
	var checkvalue = jQuery(obj).val();
	if(checkvalue == "0"){
		jQuery(obj).val("1");
	}else{
		jQuery(obj).val("0");
	}
}

if("<%=isclose%>"==1){
	onClose();
}

</script>
</head>
<body>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(309,user.getLanguage())+",javascript:onClose(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<div class="zDialog_div_content" style="height: 100%!important;">
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="workflow"/>
   <jsp:param name="navName" value="<%=titlename %>"/>
</jsp:include>
<FORM id="SearchForm" name="SearchForm" action="wfSubDataAggOperation.jsp" method="post">
<input type="hidden" name="mainwfid" value="<%=wfid%>">
<input type="hidden" name="mainformid" value="<%=formid%>">
<input type="hidden" name="nodeid" value="<%=nodeid%>">
<input type="hidden" name="subwfid" value="<%=subworkflowid%>">
<input type="hidden" name="subformid" value="<%=subformid%>">
<input type="hidden" name="postValue" value="">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage()) %>" class="e8_btn_top"  onclick="onSave();"/>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>

<wea:layout>
<%
//System.out.println("isBill = "+isBill);
if("0".equals(isBill)){
	rs.executeSql("select distinct groupId from workflow_formfield where formid=" + formid + "  and isdetail='1' order by groupId ");
	while(rs.next()){
		promptdiv = false;
		int tempgid=rs.getInt("groupId");//得到顺序id
%>
	<wea:group context='<%=SystemEnv.getHtmlLabelNames("21254,19325",user.getLanguage())+(tempgid+1)%>'>
		<wea:item attributes="{'isTableList':'true'}">
			<wea:layout needImportDefaultJsAndCss="false" type="table" attributes="{'cols':'3','cws':'35%,35%,30%'}">
			<wea:group context="" attributes="{'groupDisplay':'none'}">
				<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(19358,user.getLanguage())%></wea:item>
				<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(19357,user.getLanguage())%></wea:item>
				<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(21845,user.getLanguage())%></wea:item>
				<% 
					String formsql = " select * from workflow_formfield,(select distinct id,fielddbtype,description,fieldname " +
							" from workflow_formdictdetail) a  where workflow_formfield.formid= " + formid +
							" and groupId = " + tempgid + " and workflow_formfield.isdetail='1' " +
							" and workflow_formfield.fieldid=a.id  order by workflow_formfield.fieldorder ";
					RecordSet.executeSql(formsql);
					//System.out.println("formsql = "+formsql);
					while(RecordSet.next()){
						int mainfieldid = RecordSet.getInt("id");
						FormFieldlabelMainManager.resetParameter();
						FormFieldlabelMainManager.setFormid(Util.getIntValue(formid,0));
						FormFieldlabelMainManager.setFieldid(mainfieldid);
						FormFieldlabelMainManager.setLanguageid(user.getLanguage());
						FormFieldlabelMainManager.selectSingleFormField();
						String mainfieldname = FormFieldlabelMainManager.getFieldlabel();
						String mainfieldnames = Util.null2String(RecordSet.getString("fieldname"));
						String browurl = "/workflow/workflow/wfSubProcessFieldList.jsp?subworkflowid="+subworkflowid;
		 				String browname = "fieldmate_"+mainfieldid;
		 				String browserValue = "";
		 				String browserSpanValue = "";
		 				String subfieldid = Util.null2String(Util.getIntValue(subfieldmap.get(mainfieldid+""),-1));
		 				String subfieldnames = Util.null2String(subfieldnamemap.get(mainfieldid+""));
		 				String subtype = Util.null2String(Util.getIntValue(subtypemap.get(mainfieldid+""),-1));
		 				String fieldHtmlType = Util.null2String(Util.getIntValue(fieldhtmltypemap.get(mainfieldid+""),-1));
		 				String fieldType = Util.null2String(Util.getIntValue(typemap.get(mainfieldid+""),-1));
		 				String iscreatedoc = Util.null2String(Util.getIntValue(iscreatedocmap.get(mainfieldid+""),0));
		 				String showcheckbox = "display:none;";
		 				String ischeck = "";
		 				//System.out.println("subfieldid = "+subfieldid);
		 				if(!("-1".equals(subfieldid) || "-1".equals(subtype))){
		 					browserValue = subtype+"."+subfieldid;
		 					String subfieldname = "";
		 					if("0".equals(subisBill)){
			 					FormFieldlabelMainManager.resetParameter();
								FormFieldlabelMainManager.setFormid(Util.getIntValue(subformid,0));
								FormFieldlabelMainManager.setFieldid(Util.getIntValue(subfieldid,0));
								FormFieldlabelMainManager.setLanguageid(user.getLanguage());
								FormFieldlabelMainManager.selectSingleFormField();
								subfieldname = FormFieldlabelMainManager.getFieldlabel();
		 					}else{
		 						rsfield.executeSql("SELECT fieldlabel FROM workflow_billfield WHERE id = "+subfieldid);
		 						while(rsfield.next()){
		 							subfieldname = SystemEnv.getHtmlLabelName(rsfield.getInt("fieldlabel"),user.getLanguage());
		 						}
		 					}
		 					if("0".equals(subtype)){
		 						browserSpanValue = SystemEnv.getHtmlLabelName(21778,user.getLanguage())+"."+subfieldname;
		 					}else{
		 						browserSpanValue = SystemEnv.getHtmlLabelName(19325,user.getLanguage())+subtype+"."+subfieldname;
		 					}
		 					if(("3".equals(fieldHtmlType) && ("9".equals(fieldType) || "37".equals(fieldType))) || "6".equals(fieldHtmlType)){
		 						//showcheckbox = "";
		 						if("1".equals(iscreatedoc)){
		 							//ischeck = "checked";
		 						}
		 					}
		 					if(("1".equals(fieldHtmlType) && ("2".equals(fieldType) || "3".equals(fieldType))) || "4".equals(fieldType) || "5".equals(fieldType)){
		 						showcheckbox = "";
		 						if("1".equals(iscreatedoc)){
		 							ischeck = "checked";
		 						}
		 					}
		 				}
		 		%>
			 			<wea:item>
			 				<%=mainfieldname%>
			 				<input type="hidden" name="mainfieldid" value="<%=mainfieldid%>">
			 				<input type="hidden" name="mainfieldname" value="<%=mainfieldnames%>">
			 				<input type="hidden" name="maindetailnum" value="<%=tempgid%>">
			 			</wea:item>
			 			<wea:item>
			 				<brow:browser viewType="0" name="<%=browname%>"
								browserValue="<%=browserValue %>"
								browserUrl="<%=browurl%>"
								_callback="changeFlowType"
								hasInput="false" isSingle="true" hasBrowser="true"
								isMustInput="1" completeUrl="/data.jsp"
								browserDialogWidth="700px"
								browserSpanValue="<%=browserSpanValue %>">
							</brow:browser>
			 				<input type="hidden" name="fieldHtmlType" value="<%=fieldHtmlType%>">
			 				<input type="hidden" name="fieldType" value="<%=fieldType%>">
			 				<input type="hidden" name="subfieldname" value="<%=subfieldnames%>">
			 			</wea:item>
			 			<wea:item>
			 				<div name="showcreatedoc" style="<%=showcheckbox%>" >
								<input type="checkbox" name="iscreatedoc" value="<%=iscreatedoc%>" <%=ischeck%> onclick="changecheck(this)"/>
			 				<%--
								<div name="showcreatename" style="display:inline-block;">
									<%if("3".equals(fieldHtmlType)){%>
									<%=SystemEnv.getHtmlLabelName(21718,user.getLanguage())%> 
									<%}else{%>
									<%=SystemEnv.getHtmlLabelName(21719,user.getLanguage())%> 
									<%}%>
								</div>
							</div>
							--%>
							<div name="showcreatename" style="display:inline-block;">
								<%if(("1".equals(fieldHtmlType) && ("2".equals(fieldType) || "3".equals(fieldType))) || "4".equals(fieldType) || "5".equals(fieldType)){%>
								<%=SystemEnv.getHtmlLabelName(130236,user.getLanguage())%>
								<span class='e8tips' title='<%=SystemEnv.getHtmlLabelName(130270,user.getLanguage())%>'><img src='/images/tooltip_wev8.png' align='absMiddle'/></span>
								<%}%> 
							</div>
			 			</wea:item>
		 		<%} %>
			</wea:group>
			</wea:layout>
		</wea:item>
	</wea:group>
<%
	}
}else{
	rs.executeSql(" SELECT id,tablename,orderid FROM Workflow_billdetailtable where billid = " + formid + " order by orderid");
	while(rs.next()){
		promptdiv = false;
		String detailtablename = rs.getString("tablename");
		String tableNumber = rs.getString("orderid");
%>
	<wea:group context='<%=SystemEnv.getHtmlLabelNames("21254,19325",user.getLanguage())+tableNumber%>'>
		<wea:item attributes="{'isTableList':'true'}">
			<wea:layout needImportDefaultJsAndCss="false" type="table" attributes="{'cols':'3','cws':'35%,35%,30%'}">
			<wea:group context="" attributes="{'groupDisplay':'none'}">
				<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(19358,user.getLanguage())%></wea:item>
				<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(19357,user.getLanguage())%></wea:item>
				<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(21845,user.getLanguage())%></wea:item>
				<%
					RecordSet.executeSql("select id,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,dsporder from workflow_billfield where billid="+formid+" and viewtype=1 and detailtable='"+detailtablename+"' order by dsporder,id");
					//System.out.println("select id,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,dsporder from workflow_billfield where billid="+formid+" and viewtype=1 and detailtable='"+detailtablename+"' order by dsporder,id");	
					while(RecordSet.next()){
		 				int mainfieldid = RecordSet.getInt("id");
		 				String browurl = "/workflow/workflow/wfSubProcessFieldList.jsp?subworkflowid="+subworkflowid;
		 				String browname = "fieldmate_"+mainfieldid;
		 				String browserValue = "";
		 				String browserSpanValue = "";
		 				String mainfieldname = Util.null2String(RecordSet.getString("fieldname"));
		 				String subfieldid = Util.null2String(Util.getIntValue(subfieldmap.get(mainfieldid+""),-1));
		 				String subfieldnames = Util.null2String(subfieldnamemap.get(mainfieldid+""));
		 				String subtype = Util.null2String(Util.getIntValue(subtypemap.get(mainfieldid+""),-1));
		 				String fieldHtmlType = Util.null2String(Util.getIntValue(fieldhtmltypemap.get(mainfieldid+""),-1));
		 				String fieldType = Util.null2String(Util.getIntValue(typemap.get(mainfieldid+""),-1));
		 				String iscreatedoc = Util.null2String(Util.getIntValue(iscreatedocmap.get(mainfieldid+""),0));
		 				String showcheckbox = "display:none;";
		 				String ischeck = "";
		 				if(!("-1".equals(subfieldid) || "-1".equals(subtype))){
		 					browserValue = subtype+"."+subfieldid;
		 					String subfieldname = "";
		 					if("0".equals(subisBill)){
			 					FormFieldlabelMainManager.resetParameter();
								FormFieldlabelMainManager.setFormid(Util.getIntValue(subformid,0));
								FormFieldlabelMainManager.setFieldid(Util.getIntValue(subfieldid,0));
								FormFieldlabelMainManager.setLanguageid(user.getLanguage());
								FormFieldlabelMainManager.selectSingleFormField();
								subfieldname = FormFieldlabelMainManager.getFieldlabel();
		 					}else{
		 						rsfield.executeSql("SELECT fieldlabel FROM workflow_billfield WHERE id = "+subfieldid);
		 						while(rsfield.next()){
		 							subfieldname = SystemEnv.getHtmlLabelName(rsfield.getInt("fieldlabel"),user.getLanguage());
		 						}
		 					}
		 					if("0".equals(subtype)){
		 						browserSpanValue = SystemEnv.getHtmlLabelName(21778,user.getLanguage())+"."+subfieldname;
		 					}else{
		 						browserSpanValue = SystemEnv.getHtmlLabelName(19325,user.getLanguage())+subtype+"."+subfieldname;
		 					}
		 					if(("3".equals(fieldHtmlType) && ("9".equals(fieldType) || "37".equals(fieldType))) || "6".equals(fieldHtmlType)){
		 						//showcheckbox = "";
		 						if("1".equals(iscreatedoc)){
		 							//ischeck = "checked";
		 						}
		 					}
		 					if(("1".equals(fieldHtmlType) && ("2".equals(fieldType) || "3".equals(fieldType))) || "4".equals(fieldType) || "5".equals(fieldType)){
		 						showcheckbox = "";
		 						if("1".equals(iscreatedoc)){
		 							ischeck = "checked";
		 						}
		 					}
		 				}
		 				
	 			%>
		 			<wea:item>
		 				<%=SystemEnv.getHtmlLabelName(RecordSet.getInt("fieldlabel"),user.getLanguage())%>
		 				<input type="hidden" name="mainfieldid" value="<%=mainfieldid%>">
		 				<input type="hidden" name="mainfieldname" value="<%=mainfieldname%>">
		 				<input type="hidden" name="maindetailnum" value="<%=tableNumber%>">
		 			</wea:item>
		 			<wea:item>
		 				<brow:browser viewType="0" name="<%=browname%>"
								browserValue="<%=browserValue %>"
								browserUrl="<%=browurl%>"
								_callback="changeFlowType"
								hasInput="false" isSingle="true" hasBrowser="true"
								isMustInput="1" completeUrl="/data.jsp"
								browserDialogWidth="700px"
								browserSpanValue="<%=browserSpanValue %>">
						</brow:browser>
						<input type="hidden" name="fieldHtmlType" value="<%=fieldHtmlType%>">
			 			<input type="hidden" name="fieldType" value="<%=fieldType%>">
			 			<input type="hidden" name="subfieldname" value="<%=subfieldnames%>">
		 			</wea:item>
		 			<wea:item>
		 				<div name="showcreatedoc" style="<%=showcheckbox%>" >
							<input type="checkbox" name="iscreatedoc" value="<%=iscreatedoc%>" <%=ischeck%> onclick="changecheck(this)" />
							<%--
							<div name="showcreatename" style="display:inline-block;">
								<%if("3".equals(fieldHtmlType)){%>
								<%=SystemEnv.getHtmlLabelName(21718,user.getLanguage())%> 
								<%}else{%>
								<%=SystemEnv.getHtmlLabelName(21719,user.getLanguage())%> 
								<%}%> 
							</div>
							--%>
							<div name="showcreatename" style="display:inline-block;">
								<%if(("1".equals(fieldHtmlType) && ("2".equals(fieldType) || "3".equals(fieldType))) || "4".equals(fieldType) || "5".equals(fieldType)){%>
								<%=SystemEnv.getHtmlLabelName(130236,user.getLanguage())%>
								<span class='e8tips' title='<%=SystemEnv.getHtmlLabelName(130270,user.getLanguage())%>'><img src='/images/tooltip_wev8.png' align='absMiddle'/></span>
								<%}%> 
							</div>
						</div>
		 			</wea:item>
	 			<%} %>
			</wea:group>
			</wea:layout>
		</wea:item>
	</wea:group>
<%
	}
}
%>
</wea:layout>
</FORM>
<%if(promptdiv){%>
<div style="width:100%;font-family:'Microsoft YaHei'!important;text-align: center;font-size:12px;"><%=SystemEnv.getHtmlLabelName(125882,user.getLanguage()) %></div>
<%}%>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
    <wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
			<wea:item type="toolbar">
		    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="onClose();">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
</div>
</body>
</html>