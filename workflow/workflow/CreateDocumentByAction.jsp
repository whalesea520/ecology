<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/tld/browser.tld" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="checkSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="SecCategoryDocPropertiesComInfo" class="weaver.docs.category.SecCategoryDocPropertiesComInfo" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>

<%@ include file="/systeminfo/init_wev8.jsp" %>

<HTML>
<%
int workflowId=Util.getIntValue(request.getParameter("wfid"),-1);
if(!HrmUserVarify.checkUserRight("workflowtodocument:all", user)){
	response.sendRedirect("/notice/noright.jsp");
    return;
}
    String imagefilename = "/images/hdMaintenance_wev8.gif";
    String titlename = SystemEnv.getHtmlLabelName(19332,user.getLanguage()) + "：" + SystemEnv.getHtmlLabelName(21569,user.getLanguage()) ;
    String needfav = "";
    String needhelp = "";
%>
<%@ include file="/workflow/workflow/addwf_checktetachable.jsp" %>
    <HEAD>
        <LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
        <SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
        <SCRIPT language="javascript" src="/js/ecology8/request/e8_tabHoverColor_wev8.js"></script>
        <script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.bgiframe.min_wev8.js'></script>
		<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.ajaxQueue_wev8.js'></script>
		<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
		<script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>
		<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/jquery.autocomplete_wev8.css" />
		<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/browser_wev8.css" />
    </HEAD>
<BODY style="overflow:hidden;">

<%
    String ajax=Util.null2String(request.getParameter("ajax"));
    int docPropId=Util.getIntValue(request.getParameter("docPropId"),-1);
    
    String pathCategory = "";
    int secCategoryId=0;
	String wfdocpath = "";
	String wfdocpathspan="";
	String wfdocownertype = "";
	String wfdocownerfieldid = "";
	String wfdocowner="";
	String wfdocownerspan="";
	int keepsign = 0;

	rs.executeSql("select * from workflow_base where id = " + workflowId);
	rs.next();
	wfdocowner = rs.getString("wfdocowner");
	wfdocownerspan = ResourceComInfo.getLastname(wfdocowner);
	wfdocownertype = rs.getString("wfdocownertype");
	wfdocownerfieldid = rs.getString("wfdocownerfieldid");
	keepsign = rs.getInt("keepsign");
	wfdocpath = rs.getString("wfdocpath");
	String wfdocpaths[] = Util.TokenizerString2(wfdocpath,",");
	try{
		secCategoryId = Util.getIntValue(wfdocpaths[2],-1);
	}catch(Exception e){
		secCategoryId = Util.getIntValue(wfdocpath);
	}
    String formID = WorkflowComInfo.getFormId(""+workflowId);
    String isbill = WorkflowComInfo.getIsBill(""+workflowId);
    if("".equals(formID)){
    	formID = rs.getString("formid");	
    }
    
    if("".equals(isbill)){
    	isbill = rs.getString("isbill");	
    }
	if(!"1".equals(isbill)){
		isbill="0";
	}
	if(pathCategory.equals("")&&secCategoryId>0){
		String innerSecCategory = String.valueOf(secCategoryId);
		String innerSubCategory = SecCategoryComInfo.getSubCategoryid(innerSecCategory);
		String innerMainCategory = SubCategoryComInfo.getMainCategoryid(innerSubCategory);
	    pathCategory = SecCategoryComInfo.getAllParentName(innerSecCategory,true);     
	    pathCategory = pathCategory.replaceAll("<", "＜").replaceAll(">", "＞").replaceAll("&lt;", "＜").replaceAll("&gt;", "＞");
	    wfdocpathspan = pathCategory;
	}

    if(docPropId<=0){
	    RecordSet.executeSql("select id from  WorkflowToDocProp where workflowId="+workflowId+" and secCategoryid="+secCategoryId);
	    if(RecordSet.next()){
		    docPropId=Util.getIntValue(RecordSet.getString("id"),0);
	    }
	}
%>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
    RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:saveCreateDocumentByAction(this),_self}";
    RCMenuHeight += RCMenuHeightStep;      
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<FORM name="CreateDocumentByAction" method="post" action="CreateDocumentByActionOperation.jsp" >
<wea:layout type="twoCol" attributes="{'expandAllGroup':'true'}">
    <wea:group context='<%=SystemEnv.getHtmlLabelName(16484,user.getLanguage())%>'>
    	<wea:item><%=SystemEnv.getHtmlLabelName(22220,user.getLanguage())%></wea:item>
	    <wea:item>
	    	<brow:browser name="wfdocpath" idKey="id" nameKey="path" viewType="0" hasBrowser="true" hasAdd="false" 
	         			browserUrl="/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategorySingleBrowser.jsp" isMustInput="1" isSingle="true" hasInput="true" language='<%=""+user.getLanguage() %>'
	         			temptitle='<%= SystemEnv.getHtmlLabelName(22220,user.getLanguage())%>'
	         			completeUrl="/data.jsp?type=categoryBrowser" _callback="onShowCatalogData"  width="300px" browserValue='<%=wfdocpath%>' browserSpanValue='<%=wfdocpathspan%>' />	    
	    </wea:item>
    	<wea:item><%=SystemEnv.getHtmlLabelName(22221,user.getLanguage())%></wea:item>
    	<wea:item>
			<select id="wfdocownertype" name="wfdocownertype" onchange="onchangewfdocownertype(this.value)" style="float: left;">
				<option value="0"></option>
				<option value="1" <%if("1".equals(wfdocownertype)){out.println("selected");}%> ><%=SystemEnv.getHtmlLabelName(23122,user.getLanguage())%></option>
				<option value="2" <%if("2".equals(wfdocownertype)){out.println("selected");}%> ><%=SystemEnv.getHtmlLabelName(15549,user.getLanguage())%></option>
			</select>
			<span id="selectwfdocowner" name="selectwfdocowner" style="display:<%if(!"1".equals(wfdocownertype)){out.println("none");}%>">
				<brow:browser name="wfdocowner" viewType="0" hasBrowser="true" hasAdd="false" 
				temptitle='<%= SystemEnv.getHtmlLabelName(179,user.getLanguage())%>' language='<%=""+user.getLanguage() %>'
	           	browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp" isMustInput="1" isSingle="true" hasInput="true"
	           	completeUrl="/data.jsp"  width="300px" browserValue='<%=wfdocowner%>' browserSpanValue='<%=wfdocownerspan%>' />
			</span>
			<select id="wfdocownerfieldid" name="wfdocownerfieldid" style="display:<%if(!"2".equals(wfdocownertype)){out.println("none");}%>">
				<%
				String sql_tmp = "";
				if("1".equals(isbill)){
					sql_tmp = "select formField.id,fieldLable.labelName as fieldLable "
		                    + "from HtmlLabelInfo  fieldLable ,workflow_billfield  formField "
		                    + "where fieldLable.indexId=formField.fieldLabel "
		                    + "  and formField.billId= " + formID
		                    + "  and formField.viewType=0 "
		                    + "  and fieldLable.languageid =" + user.getLanguage()
		                    + " and formField.fieldHtmlType='3' and formField.type=1 order by formField.id";
				}else{
					sql_tmp = "select formDict.id, fieldLable.fieldLable "
		                    + "from workflow_fieldLable fieldLable, workflow_formField formField, workflow_formdict formDict "
		                    + "where fieldLable.formid = formField.formid and fieldLable.fieldid = formField.fieldid and formField.fieldid = formDict.ID and (formField.isdetail<>'1' or formField.isdetail is null) "
		                    + "and formField.formid = " + formID
		                    + " and fieldLable.langurageid = " + user.getLanguage()
		                    + " and formDict.fieldHtmlType='3' and formDict.type=1 order by formDict.id";
				}
				RecordSet.executeSql(sql_tmp);
				while(RecordSet.next()){
					String fieldid_tmp = Util.null2String(RecordSet.getString("id"));
					String fieldlabel_tmp = Util.null2String(RecordSet.getString("fieldLable"));
					String selectedStr = "";
					if(!"".equals(wfdocownerfieldid) && fieldid_tmp.equals(wfdocownerfieldid)){
						selectedStr = " selected ";
					}
					out.println("<option value=\""+fieldid_tmp+"\" "+selectedStr+">"+fieldlabel_tmp+"</option>\n");
				}%>
			</select>    	
    	</wea:item>
    	<wea:item><%=SystemEnv.getHtmlLabelName(24568,user.getLanguage())%></wea:item>
    	<wea:item>
			<select id=keepsign name=keepsign >
				<option value="1" <%if(keepsign==1) out.println("selected");%>><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option>
				<option value="2" <%if(keepsign==2) out.println("selected");%>><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option>
			</select>    	
    	</wea:item>
    </wea:group>
    <wea:group context='<%=SystemEnv.getHtmlLabelName(21569,user.getLanguage())%>'>
    	<wea:item attributes="{'isTableList':'true'}">
			<div id="docPropList"></div>
    	</wea:item>
    </wea:group>    
</wea:layout>

    <INPUT TYPE="hidden" NAME="docPropId" VALUE="<%= docPropId %>">
    <INPUT TYPE="hidden" NAME="workflowId" VALUE="<%= workflowId %>">
    <INPUT TYPE="hidden" NAME="secCategoryId" VALUE="<%= secCategoryId %>">
    <INPUT TYPE="hidden" NAME="ajax" VALUE="<%= ajax %>">
</FORM>
<script type="text/javascript">
var iTop = (window.screen.availHeight-30-550)/2+"px"; //获得窗口的垂直位置;
var iLeft = (window.screen.availWidth-10-550)/2+"px"; //获得窗口的水平位置;
function onchangewfdocownertype(objvalue){
	var wfdocownertype = objvalue;
	document.getElementById("selectwfdocowner").style.display = "none";
	document.getElementById("wfdocownerspan").style.display = "none";
	jQuery("#wfdocownerfieldid").selectbox("hide");
	try{
		if(wfdocownertype=="1"){
			document.getElementById("selectwfdocowner").style.display = "";
			document.getElementById("wfdocownerspan").style.display = "";
		}else if(wfdocownertype=="2"){
			jQuery("#wfdocownerfieldid").selectbox("show");
		}
	}catch(e){}
}

function onShowWfCatalog(spanName) {
    var datas = showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategorySingleBrowser.jsp","","dialogTop="+iTop+";dialogLeft="+iLeft+";dialogHeight=550px;dialogWidth=550px;");
    if (datas) {
        if (datas.tag>0)  {
            $("#"+spanName).html("<a href='#"+datas.id+"'>"+datas.path+"</a>");
            $("input[name=wfdocpath]").val(datas.mainid+","+datas.subid+","+datas.id);
        }
        else{
            spanName.innerHTML="";
            $GetEle("wfdocpath").value="";
            }
    }
}

function onShowCatalogData(event,datas,name,paras) {
	var allId = '';
	var secId = '';
	if (!!datas.mainid && !!datas.subid && !!datas.id) {
		allId = datas.mainid+","+datas.subid+","+datas.id;
		secId = datas.id;
	} else {
		allId = datas.id;
		secId = allId.split(',')[2];
	}
	jQuery("#wfdocpath").val(allId);
	jQuery("input:hidden[name='secCategoryId']").val(secId);
	getDocProperties(secId);
}

function getDocProperties(id,isInit){
	jQuery.ajax({
		url:"CreateDocumentByActionAjax.jsp",
		type:"post",
		dataType:"html",
		data:{
			wfid:<%=workflowId%>,
			secCategoryId:""+id,
			docPropId:<%=docPropId%>
		},
		beforeSend:function(xhr){
			try{
				e8showAjaxTips("<%=SystemEnv.getHtmlLabelName(81558, user.getLanguage())%>",true);
			}catch(e){}
		},
		complete:function(xhr){
			e8showAjaxTips("",false);
		},
		success:function(data){
			jQuery("#docPropList").html(data);
			initLayoutForCss();
			beautySelect();
		}
	});
}

jQuery(document).ready(function(){
	getDocProperties(<%=secCategoryId%>,true);
});

function _userDelCallback(text,name){
	if(name==="wfdocpath"){
		$("input[name=wfdocpath]").val("");
	}else if(name==="wfdocowner"){
		$("input[name=wfdocowner]").val("");
	}	
}

function onShowWfDocOwner(spanname,inputename,needinput){
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp","","dialogTop="+iTop+";dialogLeft="+iLeft+";dialogHeight=550px;dialogWidth=550px;")
	if (datas) {
		if(datas.id!=""){
			$("#"+spanname).html("<a href='javaScript:openhrm("+datas.id+");' onclick='pointerXY(event);'>"+datas.name+"</a>");
			$("input[name="+inputename+"]").val(datas.id);
		}else{
			if(needinput == "1") {
				$("#"+spanname).html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
			}else{
				$("#"+spanname).empty();
			}
			$("input[name="+inputename+"]").val("");
		}
	}
}

function saveCreateDocumentByAction(obj)
{
    CreateDocumentByAction.submit();
}
</script>
</BODY>
</HTML>
