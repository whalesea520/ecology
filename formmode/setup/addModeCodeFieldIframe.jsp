<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="com.weaver.formmodel.util.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.interfaces.workflow.browser.Browser"%>
<%@ page import="weaver.formmode.virtualform.VirtualFormHandler"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rst" class="weaver.conn.RecordSet" scope="page"/>

<%@ include file="/systeminfo/init_wev8.jsp" %>

<HTML><HEAD>
<link href="/js/checkbox/jquery.tzCheckbox_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/checkbox/jquery.tzCheckbox_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<LINK href="/cpt/css/common_wev8.css" type=text/css rel=STYLESHEET>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";
String modeId = Util.null2String(request.getParameter("modeId"));
String formId = Util.null2String(request.getParameter("formId"));
String codemainid = Util.null2String(request.getParameter("codemainid"));
String isclose = Util.null2String(request.getParameter("isclose"));
%>
<script type="text/javascript">
if("<%=isclose%>"=="1"){
	parent.closeWinAFrsh();	
}
</script>
</head>
<BODY style="overflow:hidden;">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),mainFrame} " ;//保存
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(309,user.getLanguage())+",javascript:closePrtDlgARfsh(),mainFrame} " ;//关闭
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<span title="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" style="font-size: 12px;cursor: pointer;"><!-- 保存 -->
				<input class="e8_btn_top middle" onclick="javascript:submitData()" type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>"/>
			</span>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span><!-- 菜单 -->
		</wea:item>
	</wea:group>
</wea:layout>
<FORM id=frmain name=frmain action="/formmode/data/addModeCodeFieldOperation.jsp" method=post >
<input type="hidden" name="codemainid" id="codemainid" value="<%=codemainid%>"/>
<input type="hidden" name="fieldhtmltype" id="fieldhtmltype" value=""/>
<input type="hidden" name="fielddbtype" id="fielddbtype" value=""/>
<input type="hidden" name="type" id="type" value=""/>
<input type="hidden" name="fieldname" id="fieldname" value=""/>
<input type="hidden" name="fieldId" id="fieldId" value=""/>
<input type="hidden" name="contentstr" id="contentstr" value=""/>
<input type="hidden" name="labelstr" id="labelstr" value=""/>
<div style="margin-top:30px!important;">
<wea:layout type="4col">
	<wea:group context="<%=SystemEnv.getHtmlLabelName(17998,user.getLanguage()) %>" attributes="{'groupDisplay':'none'}"><!--添加字段  -->
		<wea:item attributes="{'customAttrs':'nowrap=true'}"><%=SystemEnv.getHtmlLabelName(21740,user.getLanguage()) %><!--表单字段--></wea:item>
		<wea:item>
			<wea:required id="formfield_span" required="true">
				<select name="formfield" id="formfield" onChange="changeContentspan(this);checkinput('formfield','formfield_span')" style="width: 135px;">
					<option value="" type="0" fielddbtype="0" fieldhtmltype="0" fieldname="0"></option>
				<% if(!isclose.equals("1")){
					  String sql="select id,fieldlabel,type,fielddbtype,fieldhtmltype,fieldname from workflow_billfield where viewtype=0 "
					   + " and (fieldhtmltype not in (2,3, 4,6,7) or (fieldhtmltype = 3 and type in (1, 2,17, 4,19,16,152,171,8,135,9,37,7,18 ,57, 164, 194, 161, 162, 256, 257))) and billid="+formId;
					  rs.executeSql(sql);
					  while(rs.next()){
						  int fieldId = rs.getInt(1);
						  int fieldlabel = rs.getInt(2);
						  String type = rs.getString(3);
						  String fielddbtype = rs.getString(4);
						  String fieldhtmltype = rs.getString(5);
						  String fieldname_ = rs.getString(6);
						  String chkstr = "";
						  boolean showlayout = ",161,162,".indexOf(","+type+",")>-1;
						  if(showlayout){
							   try{
								    Browser browser=(Browser)StaticObj.getServiceByFullname(fielddbtype, Browser.class);
								    String customid = browser.getCustomid();
								    if(StringHelper.isEmpty(customid))
								  	    continue;
								    rst.executeSql("select * from mode_custombrowser where id="+customid);
								    if(rst.next()){
									    int tmpformid = rst.getInt("formid");
									    if(VirtualFormHandler.isVirtualForm(tmpformid)){//如果是虚拟表单就做授权
										    continue;
									    }
								    }
								  
							   }catch(org.apache.hivemind.ApplicationRuntimeException e){
							      continue;
							   }catch(Exception e){
							      e.printStackTrace();
							   }
						  }
					%>
		    			<option value="<%=fieldId%>" type="<%=type %>" fielddbtype="<%=fielddbtype%>" fieldhtmltype="<%=fieldhtmltype %>" fieldname="<%=fieldname_%>"><%=SystemEnv.getHtmlLabelName(fieldlabel, user.getLanguage()) %></option>
		    		<%}} %>
		    		<option value="0" type="0" fielddbtype="0" fieldhtmltype="0" fieldname=""><%=SystemEnv.getHtmlLabelName(27903,user.getLanguage()) %></option>
		    	</select>
	    	</wea:required>
		</wea:item>
		<wea:item attributes="{'customAttrs':'nowrap=true'}"><%=SystemEnv.getHtmlLabelName(15935,user.getLanguage()) %><!--显示内容--></wea:item>
		<wea:item>
			<select name="content" id="content" style="width: 135px;">
	    	</select>
		</wea:item>
	</wea:group>
</wea:layout>
</div>
</FORM>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout type="2col">
		<wea:group context="">
			<wea:item type="toolbar"><!-- 关闭 -->
				<input type="button"
					value="<%=SystemEnv.getHtmlLabelName(309, user.getLanguage())%>"
					id="zd_btn_cancle" class="zd_btn_cancle" onclick="closePrtDlgARfsh()">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<script type="text/javascript">
jQuery(document).ready(function(){
	resizeDialog(document);
});
</script>

<script language="javascript">

function submitData()
{
	if (check_form(frmain,'formfield')){
		document.frmain.fieldhtmltype.value=jQuery("#formfield").find("option:selected").attr("fieldhtmltype");
		document.frmain.type.value=jQuery("#formfield").find("option:selected").attr("type");
		document.frmain.fielddbtype.value=jQuery("#formfield").find("option:selected").attr("fielddbtype");
		document.frmain.fieldname.value=jQuery("#formfield").find("option:selected").attr("fieldname");
		document.frmain.fieldId.value=jQuery("#formfield").find("option:selected").val();
		document.frmain.contentstr.value=jQuery("#content").find("option:selected").val();
		document.frmain.labelstr.value=jQuery("#content").find("option:selected").attr("label");
		document.frmain.submit();
	}
}
function closePrtDlgARfsh(){
	window.parent.closeWinAFrsh();
}
function changeContentspan(obj) {
	var fieldid = jQuery(obj).find("option:selected").val();
	var type = jQuery(obj).find("option:selected").attr("type");
	var dbtype = jQuery(obj).find("option:selected").attr("fielddbtype");
	var fieldhtmltype = jQuery(obj).find("option:selected").attr("fieldhtmltype");
	var fieldname = jQuery(obj).find("option:selected").attr("fieldname");

	jQuery("#content").find("option").remove();
	
	jQuery.ajax({
		   type: "POST",
		   dataType:"string",
		   async:false,
		   url: "/weaver/weaver.formmode.servelt.CodeBuildAction?action=getContentStr",
		   data: "type="+type+"&dbtype="+dbtype+"&codeField="+fieldid+"&fieldname="+fieldname+"&fieldhtmltype="+fieldhtmltype+"&language=<%=user.getLanguage()%>",
		   success: function(data){
			   jQuery("#content").append(data);
			   jQuery("#content").selectbox("detach");
		       beautySelect(jQuery("#content"));
		       jQuery("#content").selectbox("change","");
		   }
	});
}
</script>
</BODY></HTML>
