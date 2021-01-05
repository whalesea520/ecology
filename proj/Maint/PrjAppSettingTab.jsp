<%@page import="weaver.general.Util"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="ProjectTransUtil" class="weaver.proj.util.ProjectTransUtil" scope="page" />
<%
int userid=user.getUID();
if(!HrmUserVarify.checkUserRight("Prj:AppSettings", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
  
%>
<%
    String nameQuery = Util.null2String(request.getParameter("nameQuery"));
    String typedesc = Util.null2String(request.getParameter("typedesc"));
    
    RecordSet.executeSql("select * from Prj_Settings where id=-1");
    RecordSet.next();
    
    String prj_dsc_doc=Util.null2String(RecordSet.getString("prj_dsc_doc"));
    String prj_dsc_wf=Util.null2String(RecordSet.getString("prj_dsc_wf"));
    String prj_dsc_crm=Util.null2String(RecordSet.getString("prj_dsc_crm"));
    String prj_dsc_prj=Util.null2String(RecordSet.getString("prj_dsc_prj"));
    String prj_dsc_tsk=Util.null2String(RecordSet.getString("prj_dsc_tsk"));
    String prj_dsc_acc=Util.null2String(RecordSet.getString("prj_dsc_acc"));
    int prj_dsc_accsec=Util.getIntValue(RecordSet.getString("prj_dsc_accsec"),0);
    
    String tsk_dsc_doc=Util.null2String(RecordSet.getString("tsk_dsc_doc"));
    String tsk_dsc_wf=Util.null2String(RecordSet.getString("tsk_dsc_wf"));
    String tsk_dsc_crm=Util.null2String(RecordSet.getString("tsk_dsc_crm"));
    String tsk_dsc_prj=Util.null2String(RecordSet.getString("tsk_dsc_prj"));
    String tsk_dsc_tsk=Util.null2String(RecordSet.getString("tsk_dsc_tsk"));
    String tsk_dsc_acc=Util.null2String(RecordSet.getString("tsk_dsc_acc"));
    int tsk_dsc_accsec=Util.getIntValue(RecordSet.getString("tsk_dsc_accsec"),0);
    
    String prj_acc=Util.null2String(RecordSet.getString("prj_acc"));
    int prj_accsec=Util.getIntValue(RecordSet.getString("prj_accsec"),0);
    
    String tsk_acc=Util.null2String(RecordSet.getString("tsk_acc"));
    int tsk_accsec=Util.getIntValue(RecordSet.getString("tsk_accsec"),0);
    
    String prj_gnt_showplan_=Util.null2String(RecordSet.getString("prj_gnt_showplan_"));
    int prj_gnt_warningday=Util.getIntValue(RecordSet.getString("prj_gnt_warningday"),0);
    
    String tsk_approval=Util.null2String(RecordSet.getString("tsk_approval"));
    String tsk_approval_type=Util.null2String(RecordSet.getString("tsk_approval_type"));
    
    
	String title="";
    title+= "<ul style='padding-left:15px;'>";
    if(user.getLanguage()==8){
		title+=  	"<li>"+"1,when the mission is changed, by the second task responsible for examination and approval; when a change occurs in the second task, a task level by responsible person for approval; when a change occurs in the first task, the project manager for approval."+"</li>";
		title+=  	"<li>"+"2,Superior task is responsible for their own, do not need approval."+"</li>";
    }else if(user.getLanguage()==9){
		title+=  	"<li>"+"1、當第三級任務發生改變時，將由第二級任務負責人審批；當二級任務發生改變時，將由一級任務負責人進行審批；當第一級任務發生改變時，由項目經理進行審批。"+"</li>";
		title+=  	"<li>"+"2、上級任務負責人爲自己時，不需要審批。"+"</li>";
    }else{
		title+=  	"<li>"+"1、当第三级任务发生改变时，将由第二级任务负责人审批；当二级任务发生改变时，将由一级任务负责人进行审批；当第一级任务发生改变时，由项目经理进行审批。"+"</li>";
		title+=  	"<li>"+"2、上级任务负责人为自己时，不需要审批。"+"</li>";
    }
    title+= "</ul>";
    
%>
<HTML>
<HEAD>
<link href="/js/checkbox/jquery.tzCheckbox_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/checkbox/jquery.tzCheckbox_wev8.js"></script>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<SCRIPT language="javascript" src="/proj/js/common_wev8.js"></script>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs6_wev8.css" rel="stylesheet" />
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<FORM id=weaver name=weaver action="PrjAppSettingOperation.jsp" method=post>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelNames("86",user.getLanguage())%>" class="e8_btn_top"  onclick="submitData()"/>
			<span id="advancedSearch" class="advancedSearch" style="display:none;"><%=SystemEnv.getHtmlLabelNames("347",user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelNames("23036",user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
		
<div class="advancedSearchDiv" id="advancedSearchDiv" >
</div>
<a name="lv1"></a>
<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(33157,user.getLanguage()) %>' attributes="{'itemAreaDisplay':'true'}">
		<wea:item><%=SystemEnv.getHtmlLabelName(58,user.getLanguage()) %></wea:item>
		<wea:item><input type="checkbox" tzCheckbox="true" name='prj_dsc_doc' value='1' <%="1".equals(prj_dsc_doc)?"checked":"" %> /></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(18015,user.getLanguage()) %></wea:item>
		<wea:item><input type="checkbox" tzCheckbox="true" name='prj_dsc_wf' value='1' <%="1".equals(prj_dsc_wf)?"checked":"" %> /></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(136,user.getLanguage()) %></wea:item>
		<wea:item><input type="checkbox" tzCheckbox="true" name='prj_dsc_crm' value='1' <%="1".equals(prj_dsc_crm)?"checked":"" %> /></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(101,user.getLanguage()) %></wea:item>
		<wea:item><input type="checkbox" tzCheckbox="true" name='prj_dsc_prj' value='1' <%="1".equals(prj_dsc_prj)?"checked":"" %> /></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(1332,user.getLanguage()) %></wea:item>
		<wea:item><input type="checkbox" tzCheckbox="true" name='prj_dsc_tsk' value='1' <%="1".equals(prj_dsc_tsk)?"checked":"" %> /></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(156,user.getLanguage()) %></wea:item>
		<wea:item><input type="checkbox" tzCheckbox="true" name='prj_dsc_acc' value='1' <%="1".equals(prj_dsc_acc)?"checked":"" %> onclick='onchangeacc(this)' /></wea:item>
		<wea:item attributes="{'samePair':'prj_dsc_acc_td','display':'none'}"><%=SystemEnv.getHtmlLabelName(22210,user.getLanguage()) %></wea:item>
		<wea:item attributes="{'samePair':'prj_dsc_acc_td','display':'none'}">
			<brow:browser viewType="0" name="prj_dsc_accsec" idKey="id" nameKey="path"
				browserValue='<%=prj_dsc_accsec>0?""+prj_dsc_accsec:"" %>' 
				browserSpanValue='<%=ProjectTransUtil.getDocCategoryFullname(""+prj_dsc_accsec) %>'
				browserUrl="/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategorySingleBrowser.jsp"
				hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
				completeUrl="/data.jsp?type=categoryBrowser&onlySec=true"  />
		</wea:item>
	</wea:group>
	
	<wea:group context='<%=SystemEnv.getHtmlLabelName(33158,user.getLanguage()) %>' attributes="{'itemAreaDisplay':'true'}">
		<wea:item><a name="lv2"></a><%=SystemEnv.getHtmlLabelName(58,user.getLanguage()) %></wea:item>
		<wea:item><input type="checkbox" tzCheckbox="true" name='tsk_dsc_doc' value='1' <%="1".equals(tsk_dsc_doc)?"checked":"" %> /></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(18015,user.getLanguage()) %></wea:item>
		<wea:item><input type="checkbox" tzCheckbox="true" name='tsk_dsc_wf' value='1' <%="1".equals(tsk_dsc_wf)?"checked":"" %> /></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(136,user.getLanguage()) %></wea:item>
		<wea:item><input type="checkbox" tzCheckbox="true" name='tsk_dsc_crm' value='1' <%="1".equals(tsk_dsc_crm)?"checked":"" %> /></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(101,user.getLanguage()) %></wea:item>
		<wea:item><input type="checkbox" tzCheckbox="true" name='tsk_dsc_prj' value='1' <%="1".equals(tsk_dsc_prj)?"checked":"" %> /></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(1332,user.getLanguage()) %></wea:item>
		<wea:item><input type="checkbox" tzCheckbox="true" name='tsk_dsc_tsk' value='1' <%="1".equals(tsk_dsc_tsk)?"checked":"" %> /></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(156,user.getLanguage()) %></wea:item>
		<wea:item><input type="checkbox" tzCheckbox="true" name='tsk_dsc_acc' value='1' <%="1".equals(tsk_dsc_acc)?"checked":"" %> onclick='onchangeacc(this)' /></wea:item>
		<wea:item attributes="{'samePair':'tsk_dsc_acc_td','display':'none'}"><%=SystemEnv.getHtmlLabelName(22210,user.getLanguage()) %></wea:item>
		<wea:item attributes="{'samePair':'tsk_dsc_acc_td','display':'none'}">
			<brow:browser viewType="0" name="tsk_dsc_accsec" idKey="id" nameKey="path"
				browserValue='<%=tsk_dsc_accsec>0?""+tsk_dsc_accsec:"" %>' 
				browserSpanValue='<%=ProjectTransUtil.getDocCategoryFullname(""+tsk_dsc_accsec) %>'
				browserUrl="/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategorySingleBrowser.jsp"
				hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
				completeUrl="/data.jsp?type=categoryBrowser"  />
		</wea:item>
	</wea:group>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(33159,user.getLanguage()) %>' attributes="{'itemAreaDisplay':'true'}">
		<wea:item><a name="lv3"></a><%=SystemEnv.getHtmlLabelNames("18095,156",user.getLanguage()) %></wea:item>
		<wea:item><input type="checkbox" tzCheckbox="true" name='prj_acc' value='1' <%="1".equals(prj_acc)?"checked":"" %> onclick='onchangeacc(this)' /></wea:item>
		<wea:item attributes="{'samePair':'prj_acc_td','display':'none'}"><%=SystemEnv.getHtmlLabelName(22210,user.getLanguage()) %></wea:item>
		<wea:item attributes="{'samePair':'prj_acc_td','display':'none'}">
			<brow:browser viewType="0" name="prj_accsec" idKey="id" nameKey="path"
				browserValue='<%=prj_accsec>0?""+prj_accsec:"" %>' 
				browserSpanValue='<%=ProjectTransUtil.getDocCategoryFullname(""+prj_accsec) %>'
				browserUrl="/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategorySingleBrowser.jsp"
				hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
				completeUrl="/data.jsp?type=categoryBrowser"  />
		</wea:item>
	</wea:group>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(33160,user.getLanguage()) %>' attributes="{'itemAreaDisplay':'true'}">
		<wea:item><a name="lv4"></a><%=SystemEnv.getHtmlLabelNames("18095,156",user.getLanguage()) %></wea:item>
		<wea:item><input type="checkbox" tzCheckbox="true" name='tsk_acc' value='1' <%="1".equals(tsk_acc)?"checked":"" %> onclick='onchangeacc(this)' /></wea:item>
		<wea:item attributes="{'samePair':'tsk_acc_td','display':'none'}"><%=SystemEnv.getHtmlLabelName(22210,user.getLanguage()) %></wea:item>
		<wea:item attributes="{'samePair':'tsk_acc_td','display':'none'}">
			<brow:browser viewType="0" name="tsk_accsec" idKey="id" nameKey="path"
				browserValue='<%=tsk_accsec>0?""+tsk_accsec:"" %>' 
				browserSpanValue='<%=ProjectTransUtil.getDocCategoryFullname(""+tsk_accsec) %>'
				browserUrl="/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategorySingleBrowser.jsp"
				hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
				completeUrl="/data.jsp?type=?"  />
		</wea:item>
	</wea:group>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(33161,user.getLanguage()) %>' attributes="{'itemAreaDisplay':'true'}">
		<wea:item><a name="lv5"></a><%=SystemEnv.getHtmlLabelName(33166,user.getLanguage()) %></wea:item>
		<wea:item><input type="checkbox" tzCheckbox="true" name='prj_gnt_showplan_' value='1' <%="1".equals(prj_gnt_showplan_)?"checked":"" %>  /></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(33167,user.getLanguage()) %></wea:item>
		<wea:item><INPUT class=InputStyle onkeypress="ItemPlusCount_KeyPress()" style="" maxLength=8 size=10 name="prj_gnt_warningday" value='<%=prj_gnt_warningday %>'   ></wea:item>
	</wea:group>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(84823,user.getLanguage()) %>' attributes="{'itemAreaDisplay':'true'}">
		<wea:item><a name="lv6"></a><%=SystemEnv.getHtmlLabelNames("84824",user.getLanguage()) %></wea:item>
		<wea:item><input type="checkbox" tzCheckbox="true" name='tsk_approval' value='1' <%="1".equals(tsk_approval)?"checked":"" %> onclick='onchangeacc(this)' /></wea:item>
		<wea:item attributes="{'samePair':'tsk_approval_td','display':'none'}"><%=SystemEnv.getHtmlLabelName(84825,user.getLanguage()) %></wea:item>
		<wea:item attributes="{'samePair':'tsk_approval_td','display':'none'}">
			<input type="radio" name="tsk_approval_type"  value="1" <%="1".equals(tsk_approval_type)?"checked":"" %> /><%=SystemEnv.getHtmlLabelName(84826,user.getLanguage()) %>
			&nbsp;&nbsp;&nbsp;&nbsp;<input type="radio" name="tsk_approval_type" value="2" <%="2".equals(tsk_approval_type)?"checked":"" %>/><%=SystemEnv.getHtmlLabelName(84827,user.getLanguage()) %>
			<span id="help" title="<%=title %>"><img src="/images/tooltip_wev8.png" align="absMiddle"/></span>
		</wea:item>
	</wea:group>
</wea:layout>




</FORM>
<div style="height:30px;"></div>
<script language=javascript>  
function onchangeacc(obj){
	if(obj.checked==true){
		showEle(obj.name+'_td');		
	}else{
		hideEle(obj.name+'_td');	
	}
}


jQuery(document).ready(function(){
	jQuery('.e8_box').Tabs({
	    	getLine:1,
	    	image:false,
	    	needLine:false,
	    	needTopTitle:false,
	    	needInitBoxHeight:false,
	    	needFix:true,
	    	containerHide:true
	});
	jQuery("input[type=checkbox][name$=_acc],input[type=checkbox][name=tsk_approval]").each(function(){
		if(jQuery(this).attr("checked")==true){
			showEle(jQuery(this).attr("name")+'_td');
		}
	});
});

function checkmust(){
	var bool=true;
	jQuery("input[type=checkbox][name$=_acc]").each(function(){
		if(jQuery(this).attr("checked")==true){
			var checkname=jQuery(this).attr("name")+"sec";
			try{
				if(jQuery("#"+checkname).val()==""){
					bool=false;
					return false;
				}	
			}catch(e){}
			
		}
	});
	return bool;
}

function submitData(){
	//weaver.submit();
	if(!checkmust()){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage()) %>");
		return;
	}
	var form=jQuery("#weaver");
	var form_data=form.serialize();
	var form_url=form.attr("action");
	jQuery.ajax({
		url : form_url,
		type : "post",
		async : true,
		data : form_data,
		dataType : "html",
		contentType: "application/x-www-form-urlencoded; charset=utf-8", 
		success: function do4Success(msg){
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("83551",user.getLanguage())%>");
			
		}
	});
}
function onShowCatalog(spanName) {
    var result = showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategorySingleBrowser.jsp");
    if (result != null) {
        if (result.tag>0){
          spanName.innerHTML=result.path;
          $("#mypath").val(result.path);
          $("#pathcategory").val(result.path);
          $("#maincategory").val(result.mainid);
          $("#subcategory").val(result.subid);
          $("#seccategory").val(result.id);
        }else{
          spanName.innerHTML="";
          $("#mypath").val("");
          $("#pathcategory").val("");
          $("#maincategory").val("");
          $("#subcategory").val("");
          $("#seccategory").val("");
        }
    }
}

function onBtnSearchClick(){
	weaver.submit();
}
$(function(){
	$("#topTitle").topMenuTitle({searchFn:onBtnSearchClick});
	jQuery("#help").wTooltip({html:true});
});
</script>
</BODY>
</HTML>
