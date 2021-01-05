<%@page import="java.util.Map.Entry"%>
<%@page import="weaver.proj.util.PrjWfUtil"%>
<%@page import="org.json.JSONObject"%>
<%@page import="weaver.proj.util.PrjWfConfComInfo"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="ProjectTransUtil" class="weaver.proj.util.ProjectTransUtil" scope="page" />
<jsp:useBean id="PrjWfConfComInfo" class="weaver.proj.util.PrjWfConfComInfo" scope="page" />
<jsp:useBean id="ProjectTypeComInfo" class="weaver.proj.Maint.ProjectTypeComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<jsp:useBean id="CptFieldComInfo" class="weaver.proj.util.PrjFieldComInfo" scope="page" />
<jsp:useBean id="CptCardGroupComInfo" class="weaver.proj.util.PrjCardGroupComInfo" scope="page" />
<jsp:useBean id="PrjFieldManager" class="weaver.proj.util.PrjFieldManager" scope="page" />

<jsp:useBean id="CptFieldComInfo1" class="weaver.proj.util.PrjTskFieldComInfo" scope="page"/>
<jsp:useBean id="CptFieldManager1" class="weaver.proj.util.PrjTskFieldManager" scope="page"/>
<jsp:useBean id="CptCardGroupComInfo1" class="weaver.proj.util.PrjTskCardGroupComInfo" scope="page" />


<%
String wftype = Util.null2String(request.getParameter("wftype"));
String rightStr="3".equals(wftype)?"projTemplateSetting:Maint":"Prj:WorkflowSetting";
if(!HrmUserVarify.checkUserRight(rightStr,user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
String id = Util.null2String(request.getParameter("id"));
String wfid = "";
String formid="";
String formname="";
String prjtype="";
String isopen="1";
boolean isEdit=false;
if(Util.getIntValue(id)>0){
	wfid= PrjWfConfComInfo.getWfid(id);
	formid=WorkflowComInfo.getFormId(wfid);
	formname=ProjectTransUtil.getWorkflowformname(wfid, ""+user.getLanguage()) ;
	prjtype=PrjWfConfComInfo.getPrjtype(id);
	isopen=PrjWfConfComInfo.getIsopen(id);
	isEdit=true;
}else{
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

if(request.getParameter("wfid")!=null&&Util.getIntValue(request.getParameter("wfid"))>0){
	wfid=Util.null2String(request.getParameter("wfid"));
	formid=WorkflowComInfo.getFormId(wfid);
	formname=ProjectTransUtil.getWorkflowformname(wfid, ""+user.getLanguage()) ;
} 
if(request.getParameter("formid")!=null&&Util.getIntValue(request.getParameter("formid"))<0){
	formid=request.getParameter("formid");
	RecordSet.executeSql("select namelabel from workflow_bill where id="+formid);
	if(RecordSet.next()){
		formname=SystemEnv.getHtmlLabelNames(""+RecordSet.getString("namelabel"), user.getLanguage()) ;
	}
}


String titlelabel="1".equals(wftype)?"81937":"2".equals(wftype)?"81938":"3".equals(wftype)?"18374":"";
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));



%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<SCRIPT language="javascript" src="/proj/js/common_wev8.js"></script>
<script  src="/wui/theme/ecology8/weaveredittable/js/WeaverEditTable_wev8.js"></script>
<link rel="stylesheet" href="/wui/theme/ecology8/weaveredittable/css/WeaverEditTable_wev8.css">
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<style type="text/css">
	select{
		/*width:300px!important;*/
	}
</style>
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
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData("+wftype+"),_top} " ;
RCMenuHeight += RCMenuHeightStep;

%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<FORM id=weaver action="/proj/conf/prjwfop.jsp" method=post>
<input type="hidden" name="method" value="fieldmap" />
<input type="hidden" name="wftype" value="<%=wftype %>" />
<input type="hidden" name="id" value="<%=id %>" />

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="submitData(<%=wftype %>);">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<table class="ListStyle" cols=2  border=0 cellspacing=1 style="">
    <COLGROUP>
		<COL width="30%">
		<COL width="70%">
          <tr class=header>
            <td nowrap><%=SystemEnv.getHtmlLabelNames("15551",user.getLanguage())%></td>
            <td nowrap><%=SystemEnv.getHtmlLabelNames("19372",user.getLanguage())%></td>
          </tr>
<%
String checkStr1="";
if("2".equals(wftype)){
	JSONObject jsonObject1=new JSONObject();
	jsonObject1.put("fieldname", "manager");
	jsonObject1.put("fieldhtmltype", "3");
	jsonObject1.put("type", "1");
	jsonObject1.put("ismand", 1);
	JSONObject jsonObject2=new JSONObject();
	jsonObject2.put("fieldname", "relatedprjid");
	jsonObject2.put("fieldhtmltype", "3");
	jsonObject2.put("type", "8");
	jsonObject2.put("ismand", 1);
	
	String sql="select t1.xmjl,t1.xgxm from prj_prjwfconf t1 where t1.id="+id;
	RecordSet.executeSql(sql);
	if(!RecordSet.next()){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	%>
<tr class="DataLight">
	<td><%=SystemEnv.getHtmlLabelNames("16573",user.getLanguage())%></td>
	<td>
		<%=PrjWfUtil.getSelect(jsonObject1, user, formid, "prjapprove", "0", Util.null2String(RecordSet.getString("xmjl")) ) %>
		<img src="/wechat/images/remind_wev8.png" align="absMiddle" title="<%=SystemEnv.getHtmlLabelNames("179,695",user.getLanguage())%>" />
	</td>
</tr>	
<tr class="DataDark">
	<td><%=SystemEnv.getHtmlLabelNames("782",user.getLanguage())%></td>
	<td>
		<%=PrjWfUtil.getSelect(jsonObject2, user, formid, "prjapprove", "0", Util.null2String(RecordSet.getString("xgxm"))) %>
		<img src="/wechat/images/remind_wev8.png" align="absMiddle" title="<%=SystemEnv.getHtmlLabelNames("101,695",user.getLanguage())%>" />
	</td>
</tr>	
	<%
	
}else if("3".equals(wftype)){//项目模板审批
	JSONObject jsonObject1=new JSONObject();
	jsonObject1.put("fieldname", "prjtemplate");
	jsonObject1.put("fieldhtmltype", "3");
	jsonObject1.put("type", "129");
	jsonObject1.put("ismand", 1);
	
	String sql="select t1.xmmb from prj_prjwfconf t1 where t1.id="+id;
	RecordSet.executeSql(sql);
	if(!RecordSet.next()){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	%>
<tr class="DataLight">
	<td><%=SystemEnv.getHtmlLabelNames("18375",user.getLanguage())%></td>
	<td>
		<%=PrjWfUtil.getSelect(jsonObject1, user, formid, "prjtemplate", "0", Util.null2String(RecordSet.getString("xmmb")) ) %>
		<img src="/wechat/images/remind_wev8.png" align="absMiddle" title="<%=SystemEnv.getHtmlLabelNames("18375,695",user.getLanguage())%>" />
	</td>
</tr>	
	<%
	
}else if("1".equals(wftype)){
	HashMap<String,String> tipMap=new HashMap<String,String>();
	tipMap.put("1", SystemEnv.getHtmlLabelName(688, user.getLanguage()));
	tipMap.put("2", SystemEnv.getHtmlLabelName(689, user.getLanguage()));
	tipMap.put("3", SystemEnv.getHtmlLabelName(695, user.getLanguage()));
	tipMap.put("4", SystemEnv.getHtmlLabelName(691, user.getLanguage()));
	tipMap.put("5", SystemEnv.getHtmlLabelName(690, user.getLanguage()));
	tipMap.put("6", SystemEnv.getHtmlLabelName(21691, user.getLanguage()));
	tipMap.put("7", SystemEnv.getHtmlLabelName(156, user.getLanguage()));
	
	HashMap<String,String> fieldMap=new HashMap<String,String>();
	String sql="select t1.wfid,t1.wftype,t1.formid,t1.prjtype,t1.isopen,t1.isasync,t1.actname,t2.* from prj_prjwfconf t1 left outer join prj_prjwffieldmap t2 on t2.mainid=t1.id  where t1.id="+id;
	RecordSet.executeSql(sql);
	while(RecordSet.next()){
		fieldMap.put(Util.null2String(RecordSet.getString("fieldname"))+"_"+Util.getIntValue(RecordSet.getString("fieldtype"),0) , Util.null2String(RecordSet.getString("fieldid")));
	}
	
	
%>	
<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelNames("16290",user.getLanguage())%>'>

<%

//1,项目信息
if(Util.getIntValue(prjtype)<=0){
	prjtype="-1";
}
TreeMap<String,TreeMap<String,JSONObject>> groupFieldMap=CptFieldComInfo.getGroupFieldMap(""+prjtype);
CptCardGroupComInfo.setTofirstRow();
try{
	while(CptCardGroupComInfo.next()){
		String groupid=CptCardGroupComInfo.getGroupid();
		TreeMap<String,JSONObject> openfieldMap= groupFieldMap.get(groupid);
		if(openfieldMap==null||openfieldMap.size()==0){
			continue;
		}
		int grouplabel=Util.getIntValue( CptCardGroupComInfo.getLabel(),-1);
		if(!openfieldMap.isEmpty()){
			Iterator it=openfieldMap.entrySet().iterator();
			while(it.hasNext()){
				Entry<String,JSONObject> entry=(Entry<String,JSONObject>)it.next();
				String k= entry.getKey();
				JSONObject v=new JSONObject(((JSONObject)entry.getValue()).toString());
				int fieldlabel=v.getInt("fieldlabel");
				int fieldhtmltype=v.getInt("fieldhtmltype");
				String fieldid=v.getString("id");
				String fieldname=v.getString("fieldname");
				if("protemplateid".equalsIgnoreCase(fieldname)
					||"status".equalsIgnoreCase(fieldname)
						){
					continue;
				}
				int ismand=v.getInt("ismand");
				if(ismand==1){
					checkStr1+="prj_"+fieldname+",";
				}
%>
				<wea:item><%=SystemEnv.getHtmlLabelName(fieldlabel, user.getLanguage()) %></wea:item>
				<wea:item>
				<%=PrjWfUtil.getSelect(v, user, formid, "prj", "0", Util.null2String(fieldMap.get(fieldname+"_0") )) %>
				<img src="/wechat/images/remind_wev8.png" align="absMiddle" title="<%=Util.null2String( tipMap.get(""+fieldhtmltype)) %>" />
				</wea:item>
<%
				
			}
		}
	}
}catch(Exception e){
	
}
	
	
%>
	</wea:group>
</wea:layout>
<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelNames("83789",user.getLanguage())%>'>
<%

//2,任务信息
TreeMap<String,TreeMap<String,JSONObject>> groupFieldMap1=CptFieldComInfo1.getGroupFieldMap();
CptCardGroupComInfo1.setTofirstRow();
while(CptCardGroupComInfo1.next()){
	String groupid=CptCardGroupComInfo1.getGroupid();
	TreeMap<String,JSONObject> openfieldMap= groupFieldMap1.get(groupid);
	if(openfieldMap==null||openfieldMap.size()==0){
		continue;
	}
	int grouplabel=Util.getIntValue( CptCardGroupComInfo1.getLabel(),-1);
	if(!openfieldMap.isEmpty()){
		Iterator it=openfieldMap.entrySet().iterator();
		while(it.hasNext()){
			Entry<String,JSONObject> entry=(Entry<String,JSONObject>)it.next();
			String k= entry.getKey();
			JSONObject v=new JSONObject(((JSONObject)entry.getValue()).toString());
			int fieldlabel=v.getInt("fieldlabel");
			int fieldhtmltype=v.getInt("fieldhtmltype");
			String fieldid=v.getString("id");
			String fieldname=v.getString("fieldname");
			if("parentid".equalsIgnoreCase(fieldname)
					||"prjid".equalsIgnoreCase(fieldname)
					||"actualbegindate".equalsIgnoreCase(fieldname)
					||"actualenddate".equalsIgnoreCase(fieldname)
					||"realmandays".equalsIgnoreCase(fieldname)
					||"finish".equalsIgnoreCase(fieldname)
					||"prefinish".equalsIgnoreCase(fieldname)
					||"accessory".equalsIgnoreCase(fieldname)
						){
					continue;
			}
			int ismand=v.getInt("ismand");
			if(ismand==1){
				checkStr1+="tsk_"+fieldname+",";
			}
%>
			<wea:item><%=SystemEnv.getHtmlLabelName(fieldlabel, user.getLanguage()) %></wea:item>
			<wea:item>
			<%=PrjWfUtil.getSelect(v, user, formid, "tsk", "1", Util.null2String(fieldMap.get(fieldname+"_1") )) %>
			<img src="/wechat/images/remind_wev8.png" align="absMiddle" title="<%=Util.null2String( tipMap.get(""+fieldhtmltype)) %>" />
			</wea:item>
<%			
			
		}
	}
}
%>
	</wea:group>
</wea:layout>
<%

}
%>


</table>
	
<input type="hidden" name="prjtype" value="<%=prjtype %>" />
</FORM>
<script language="javascript">
function mycheck(obj){
	if(jQuery(obj).val()!=""){
		jQuery(obj).parents("td").first().find("img[type=mycheck]").hide();
	}else{
		if(jQuery(obj).attr("ismand")==1){
			jQuery(obj).parents("td").first().find("img[type=mycheck]").show();
		}
	}
}

function submitData(type)
{
	var wftype='<%=wftype %>';
	var checkstr="";
	if(wftype=="2"){
		checkstr="prjapprove_manager,prjapprove_relatedprjid";
	}else if(wftype=="1"){
		checkstr="<%=checkStr1 %>";
	}else if(wftype=="3"){
		checkstr="prjtemplate_prjtemplate";
	}
	if (check_form(weaver,checkstr)){
		//weaver.submit();
		var form=jQuery("#weaver");
		var form_data=form.serialize();
		var form_url=form.attr("action");
		jQuery.ajax({
			url : form_url,
			type : "post",
			async : true,
			data : form_data,
			dataType : "json",
			contentType: "application/x-www-form-urlencoded; charset=utf-8", 
			success: function do4Success(data){
				if(!data.errmsg){
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("83551",user.getLanguage())%>");
				}
				
			}
		});
	}
}

$(function(){
	$("select").blur();
});
</script>
</BODY>
</HTML>
