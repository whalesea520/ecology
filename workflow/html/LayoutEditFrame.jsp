<%@page import="weaver.workflow.workflow.WfRightManager"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%
int wfid = Util.getIntValue(request.getParameter("wfid"), 0);//
WfRightManager wfrm = new WfRightManager();
boolean haspermission = wfrm.hasPermission3(wfid, 0, user, WfRightManager.OPERATION_CREATEDIR);
if (!HrmUserVarify.checkUserRight("WorkflowManage:All", user) && !haspermission) {
	response.sendRedirect("/notice/noright.jsp");
	return;
}
%>
<jsp:useBean id="wfLayoutToHtml" class="weaver.workflow.html.WFLayoutToHtml" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="wFNodeFieldManager" class="weaver.workflow.workflow.WFNodeFieldManager" scope="page"/>
<HTML>
<HEAD>
<link href="/css/Weaver_wev8.css" type="text/css" rel=STYLESHEET>
<script type="text/javascript" language="javascript" src="/js/weaver_wev8.js"></script>
<script language=javascript src="/js/jquery/jquery_wev8.js"></script>
<!--
<script type="text/javascript" language="javascript" src="/FCKEditor/fckeditor_wev8.js"></script>
<script type="text/javascript" language="javascript" src="/FCKEditor/FCKEditorExt_wev8.js"></script>
-->
<script type="text/javascript" src="/wui/common/js/ckeditor/ckeditor_wev8.js"></script>
<script type="text/javascript" src="/wui/common/js/ckeditor/ckeditorext_wev8.js"></script>
<link rel="stylesheet" type="text/css" href="/css/ecology8/workflowsign_wev8.css" />
<script type="text/javascript">

$(function () {
	var modetype=$("[name='modetype']",window.opener.document).val();
	var obj=$("[name='curmodetype']");		//普通模式链接的HTML打印模板，保存不改变模板类型
	if(modetype=='0'||'<%=Util.null2String(request.getParameter("curmodetype")) %>'=='0'){
		obj.val('0');
	}else{
		obj.val('2');
	}
	initFckEdit();
})

window.onbeforeunload=function(){
	if(window.opener.location.href.indexOf("addwfnodefield")>0){
    	window.opener.location.reload();
    }
}

</script>
<style type="text/css">
.cke_editor{
heigth:1000px!important;
}

.delTempcss{
	border-radius:4px;
	border: solid 1px #cfe2f3;
	display:inline-block;
	height:14px;
	line-height:14px;
	padding:0px 4px;
	background:#e06666;
	cursor:pointer;
}
</style>

<%
int formid = Util.getIntValue(request.getParameter("formid"), 0);//
int nodeid = Util.getIntValue(request.getParameter("nodeid"), 0);//
int modeid = Util.getIntValue(request.getParameter("modeid"), 0);//
int isbill = Util.getIntValue(request.getParameter("isbill"), -1);//
int layouttype = Util.getIntValue(request.getParameter("layouttype"), -1);
int isform = Util.getIntValue(request.getParameter("isform"), 0);//
int flag = Util.getIntValue(request.getParameter("flag"), 0);
int nodetype = -1;
rs.execute("select nodetype from workflow_flownode where nodeid="+nodeid);
if(rs.next()){
	nodetype = Util.getIntValue(rs.getString("nodetype"), -1);
}
int canFieldEdit = 1;//设置这个属性，在wfEditorConf.js获得hidden的input的value，以判断是否出现“只读”、“可编辑”、“必填”3个右键菜单

if(nodetype==3 || layouttype==1){
	canFieldEdit = 0;
}
String layoutname = "";
String htmlLayout = "";
int cssfile = 0;
int htmlParseScheme = 0;
wFNodeFieldManager.setRequest(request);
wFNodeFieldManager.setUser(user);
Hashtable ret_hs = wFNodeFieldManager.doGetHtmlLayout();
layoutname = Util.null2String((String)ret_hs.get("layoutname"));
htmlLayout = Util.null2String((String)ret_hs.get("htmlLayout"));
modeid = Util.getIntValue((String)ret_hs.get("modeid"), 0);
cssfile = Util.getIntValue((String)ret_hs.get("cssfile"), 0);
htmlParseScheme = Util.getIntValue((String)ret_hs.get("htmlParseScheme"), 0);
String cssname = "";
String realfilename = "";
rs.execute("select * from workflow_crmcssfile where id="+cssfile);
if(rs.next()){
	cssname = Util.null2String(rs.getString("cssname"));
	realfilename = Util.null2String(rs.getString("realfilename"));
}
String layout = Util.null2String((String)session.getAttribute("layout_t"));
if(!"".equals(layout)){
	htmlLayout = layout;
	session.removeAttribute("layout_t");
}
htmlLayout = wfLayoutToHtml.deleteTempCss(htmlLayout);
//htmlLayout = wfLayoutToHtml.addTempCss(htmlLayout, realfilename);
Hashtable rhs = wFNodeFieldManager.getFieldAttr4LEF();
ArrayList fieldidList = (ArrayList)rhs.get("fieldidList");
Hashtable fieldLabel_hs = (Hashtable)rhs.get("fieldLabel_hs");
Hashtable fieldAttr_hs = (Hashtable)rhs.get("fieldAttr_hs");
Hashtable detailFieldid_hs = (Hashtable)rhs.get("detailFieldid_hs");
ArrayList detailGroupList = (ArrayList)rhs.get("detailGroupList");
Hashtable detailGroupTitle_hs = (Hashtable)rhs.get("detailGroupTitle_hs");
Hashtable fieldSQL_hs = (Hashtable)rhs.get("fieldSQL_hs");

ArrayList nodeidList = (ArrayList)rhs.get("nodeidList");
ArrayList nodenameList = (ArrayList)rhs.get("nodenameList");
ArrayList detailGroupAttrList = (ArrayList)rhs.get("detailGroupAttrList");
String fileFieldids = Util.null2String((String)rhs.get("fileFieldids"));
String inputFieldids = Util.null2String((String)rhs.get("inputFieldids"));
String especialFieldids = Util.null2String((String)rhs.get("especialFieldids"));
String dateFields = Util.null2String((String)rhs.get("dateFields"));
String zhengshuFields = Util.null2String((String)rhs.get("zhengshuFields"));
String shuziFieldids = Util.null2String((String)rhs.get("shuziFieldids"));
String gpsFieldid = Util.null2String((String)rhs.get("gpsFieldid"));
String layoutTypeName = "";
if(layouttype == 0){
	layoutTypeName = SystemEnv.getHtmlLabelName(16450,user.getLanguage());
}else if(layouttype == 1){
	layoutTypeName = SystemEnv.getHtmlLabelName(257,user.getLanguage())+SystemEnv.getHtmlLabelName(64,user.getLanguage());
}else if(layouttype == 2) {
	layoutTypeName = "Mobile"+SystemEnv.getHtmlLabelName(64,user.getLanguage());	
}	
StringBuffer fieldAttr_sb = new StringBuffer();//字段属性，拼html代码。主表和明细表字段放一起拼
StringBuffer detailGroupAttr_sb = new StringBuffer();//明细表属性

StringBuffer fieldSQL_sb = new StringBuffer();//字段SQL属性

StringBuffer fieldid_sb = new StringBuffer();//记录所有字段id
%>
<TITLE></TITLE>
</HEAD>

<%
if(flag==1){
%>
<SCRIPT LANGUAGE="javascript">
	alert("<%=SystemEnv.getHtmlLabelName(18758, user.getLanguage())%>");
</SCRIPT>
<%}
if(formid==0 || isbill==-1 || layouttype==-1){
	out.println(SystemEnv.getHtmlLabelName(20239, user.getLanguage()));
%>
<BODY style="overflow:hidden;">
<%
}else{
%>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
if(layouttype == 1){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(20873,user.getLanguage())+SystemEnv.getHtmlLabelName(257,user.getLanguage())+SystemEnv.getHtmlLabelName(64,user.getLanguage())+",javascript:onPrepPrintMode(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(64,user.getLanguage())+SystemEnv.getHtmlLabelName(18596,user.getLanguage())+",javascript:onImportLayout(),_self} " ;
RCMenuHeight += RCMenuHeightStep;//导入
if(modeid > 0){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(64,user.getLanguage())+SystemEnv.getHtmlLabelName(17416,user.getLanguage())+",javascript:onExportLayout(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;//导出
	RCMenu += "{"+SystemEnv.getHtmlLabelName(64,user.getLanguage())+SystemEnv.getHtmlLabelName(23690,user.getLanguage())+",javascript:onPreviewLayout(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;//预览
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<BODY style="MARGIN: 0px;padding: 0px">
<form id="LayoutForm" name="LayoutForm" style="height:100%;" action="LayoutOperation.jsp" target="_self" method="post" enctype="multipart/form-data">
<div style="width: 0px;height: 0px!important;">
<iframe id="htmloutiframe" name="htmloutiframe" border="0" frameborder="no" noresize="NORESIZE" height="0%" width="0%"></iframe>
</div>


<div id="container" style="height:100%;overflow:hidden;">
 	<!-- 右侧 -->
	<div style="width:240px;height:100%;float:right;overflow-y:auto;">
		<wea:layout type="2Col">
					<wea:group context='<%=layoutTypeName%>'>
						<wea:item attributes="{'isTableList':'true','width':'49%'}">
						<table  width="120px" border="0" cellspacing="1" cellpadding="3" align="center">
					<tr class="Title">
						<td class="field" align="center"><B><%=SystemEnv.getHtmlLabelName(15456,user.getLanguage())%></B></td>
					</tr>
					
					<tr class="Title">
						<td class="field" id="tdtablelist" name="tdtablelist" align="center">
							<select notBeauty=true id="tablelist0" name="tablelist0" class="tablelist" size="1" onchange="onchangeformlabel(this)" style="width:100%">
								<option value="-1" selected><%=SystemEnv.getHtmlLabelName(21778,user.getLanguage())%></option>
						<%
							if(detailGroupList!=null && detailGroupList.size()>0){
								for(int i=0; i<detailGroupList.size(); i++){
									String groupid_tmp = (String)detailGroupList.get(i);
									ArrayList detailFieldidList = (ArrayList)detailFieldid_hs.get("group"+groupid_tmp);
									if(detailFieldidList!=null && detailFieldidList.size()>0){
										String title_tmp = (String)detailGroupTitle_hs.get("grouptitle"+groupid_tmp);
						%>
								<option value="<%=i%>"><%=title_tmp%></option>
						<%
									}
								}
							}
						//节点名称没有中英文语言区分，所以这里不处理
						%>
							</select>
						</td>
					</tr>
					
					<tr class="Title">
						<td class="field" id="tdfieldlist" name="tdfieldlist" align="center" >
							<select notBeauty=true id="labellist-1" notBeauty="true" name="labellist-1" class="labellist" size="15" ondblclick="javascript:cool_webcontrollabel(this);" style="width:100%;height:150px;display:">
					<%
						for(int i=0; i<fieldidList.size(); i++){
							String fieldid_tmp = (String)fieldidList.get(i);
							String fieldlabel_tmp = (String)fieldLabel_hs.get("fieldlabel"+fieldid_tmp);
							//如果是手机版Html模板，则不显示“签字意见”选项
							if(layouttype == 2 && "签字意见".equals(fieldlabel_tmp)){
								continue;
							}
					%>
								<option value="<%=fieldid_tmp%>" nodeType="<%=fieldlabel_tmp%>"><%=fieldlabel_tmp%></option>
					<%
						}
					%>
							</select>
					<%
					if(detailGroupList!=null && detailGroupList.size()>0){
					%>
					<%
						for(int i=0; i<detailGroupList.size(); i++){
							String groupid_tmp = (String)detailGroupList.get(i);
							ArrayList detailFieldidList = (ArrayList)detailFieldid_hs.get("group"+groupid_tmp);
							if(detailFieldidList!=null && detailFieldidList.size()>0){
					%>
							<select notBeauty=true id="labellist<%=i%>" notBeauty="true" name="labellist<%=i%>" class="labellist" size="15" ondblclick="javascript:cool_webcontrollabel(this);" style="width:100%;display:none;height:150px;">
					<%
								for(int j=0; j<detailFieldidList.size(); j++){
									String detailFieldid_tmp = (String)detailFieldidList.get(j);
									String detailFieldlabel_tmp = (String)fieldLabel_hs.get("fieldlabel"+detailFieldid_tmp);
					%>
									<option value="<%=detailFieldid_tmp%>" nodeType="<%=detailFieldlabel_tmp%>"><%=detailFieldlabel_tmp%></option>
					<%
								}
							}
					%>
							</select>
					<%
						}
					}
					%>
						<select notBeauty=true id="labellist-all" notBeauty="true" name="labellist-all" class="labellist" size="15" ondblclick="javascript:cool_webcontrollabel(this);" style="width:100%;display:none;height:150px;">
							<optgroup label="<%=SystemEnv.getHtmlLabelName(18020, user.getLanguage())%>">
							<%
								for(int i=0; i<fieldidList.size(); i++){
									String fieldid_tmp = (String)fieldidList.get(i);
									String fieldlabel_tmp = (String)fieldLabel_hs.get("fieldlabel"+fieldid_tmp);
							%>
										<option value="<%=fieldid_tmp%>" nodeType="<%=fieldlabel_tmp%>"><%=fieldlabel_tmp%></option>
							<%
								}
							%>
							</optgroup>
						    <%
							if(detailGroupList!=null && detailGroupList.size()>0){
							%>
							<%
								for(int i=0; i<detailGroupList.size(); i++){
									String groupid_tmp = (String)detailGroupList.get(i);
									ArrayList detailFieldidList = (ArrayList)detailFieldid_hs.get("group"+groupid_tmp);
									if(detailFieldidList!=null && detailFieldidList.size()>0){
							%>
									<optgroup label="<%=SystemEnv.getHtmlLabelName(19325, user.getLanguage())%><%=i+1 %><%=SystemEnv.getHtmlLabelName(261, user.getLanguage())%>">
							<%
										for(int j=0; j<detailFieldidList.size(); j++){
											String detailFieldid_tmp = (String)detailFieldidList.get(j);
											String detailFieldlabel_tmp = (String)fieldLabel_hs.get("fieldlabel"+detailFieldid_tmp);
							%>
											<option value="<%=detailFieldid_tmp%>" nodeType="<%=detailFieldlabel_tmp%>"><%=detailFieldlabel_tmp%></option>
							<%
										}
									}
							%>
									</optgroup>
							<%
								}
							}
							%>
							
						</select>
					
					
						</td>
					</tr>
					
				</table>
						</wea:item>
						<wea:item attributes="{'isTableList':'true','width':'49%'}">
							<table  width="120px" border="0" cellspacing="1" cellpadding="3" align="center">
					<tr class="Title">
						<td class="field" align="center"><B><%=SystemEnv.getHtmlLabelName(21740,user.getLanguage())%></B></td>
					</tr>
					
					<tr class="Title">
						<td class="field" align="center">
							<select notBeauty=true id="tablelist1" notBeauty=true name="tablelist1" class="tablelist" size="1" onchange="onchangeformfield(this)" style="width:100%">
								<option value="-1" selected><%=SystemEnv.getHtmlLabelName(21778,user.getLanguage())%></option>
						<%
							if(detailGroupList!=null && detailGroupList.size()>0){
								for(int i=0; i<detailGroupList.size(); i++){
									String groupid_tmp = (String)detailGroupList.get(i);
									ArrayList detailFieldidList = (ArrayList)detailFieldid_hs.get("group"+groupid_tmp);
									if(detailFieldidList!=null && detailFieldidList.size()>0){
										String title_tmp = (String)detailGroupTitle_hs.get("grouptitle"+groupid_tmp);
						%>
								<option value="<%=i%>"><%=title_tmp%></option>
						<%
									}
								}
							}
							if(nodeidList!=null && nodeidList.size()>0){//防止没有节点
						%>
								<option value="-2"><%=SystemEnv.getHtmlLabelName(18015,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15586,user.getLanguage())%></option>
						<%
							}
						%>
							</select>
						</td>
					</tr>
					
					<tr class="Title">
						<td class="field" align="center" height="100px;">
							<select  notBeauty=true id="fieldlist-1" notBeauty="true" name="fieldlist-1" class="fieldlist" size="15" onchange="loadfieldstyle(this)" ondblclick="javascript:cool_webcontrolfield(this);" style="width:100%;height:150px;">
						<%
						for(int i=0; i<fieldidList.size(); i++){
							String fieldid_tmp = (String)fieldidList.get(i);
							String fieldlabel_tmp = (String)fieldLabel_hs.get("fieldlabel"+fieldid_tmp);
							String fieldAttr_tmp = Util.null2String((String)fieldAttr_hs.get("fieldAttr"+fieldid_tmp));
							fieldAttr_sb.append("<input type=\"hidden\" id=\"fieldattr"+fieldid_tmp+"\" nodetype=\"-1\" name=\"fieldattr"+fieldid_tmp+"\" value=\""+fieldAttr_tmp+"\">").append("\n");
							String fieldSQL_tmp = Util.null2String((String)fieldSQL_hs.get("fieldsql"+fieldid_tmp));
							int caltype_tmp = Util.getIntValue((String)fieldSQL_hs.get("caltype"+fieldid_tmp), 0);
							int othertype_tmp = Util.getIntValue((String)fieldSQL_hs.get("othertype"+fieldid_tmp), 0);
							int transtype_tmp = Util.getIntValue((String)fieldSQL_hs.get("transtype"+fieldid_tmp), 0);
							fieldSQL_sb.append("<input type=\"hidden\" id=\"fieldsql"+fieldid_tmp+"\" name=\"fieldsql"+fieldid_tmp+"\" value=\""+fieldSQL_tmp+"\">").append("\n");
							fieldSQL_sb.append("<input type=\"hidden\" id=\"caltype"+fieldid_tmp+"\" name=\"caltype"+fieldid_tmp+"\" value=\""+caltype_tmp+"\" >").append("\n");
							fieldSQL_sb.append("<input type=\"hidden\" id=\"othertype"+fieldid_tmp+"\" name=\"othertype"+fieldid_tmp+"\" value=\""+othertype_tmp+"\">").append("\n");
							fieldSQL_sb.append("<input type=\"hidden\" id=\"transtype"+fieldid_tmp+"\" name=\"transtype"+fieldid_tmp+"\" value=\""+transtype_tmp+"\">").append("\n");
							fieldid_sb.append(fieldid_tmp+",");
							
							//如果是手机版Html模板，则不显示“签字意见”选项
							if(layouttype == 2 && "签字意见".equals(fieldlabel_tmp)){
								continue;
							}
						%>
								<option value="<%=fieldid_tmp%>" nodeType="<%=fieldAttr_tmp%>"><%=fieldlabel_tmp%></option>
						<%
						}
						%>
							</select>
					<%
					if(detailGroupList!=null && detailGroupList.size()>0){
					%>
					<%
						for(int i=0; i<detailGroupList.size(); i++){
							String groupid_tmp = (String)detailGroupList.get(i);
							String detailGroupAttr = (String)detailGroupAttrList.get(i);
							ArrayList detailFieldidList = (ArrayList)detailFieldid_hs.get("group"+groupid_tmp);
							if(detailFieldidList!=null && detailFieldidList.size()>0){
								String title_tmp = (String)detailGroupTitle_hs.get("grouptitle"+groupid_tmp);
								detailGroupAttr_sb.append("<input type=\"hidden\" id=\"detailgroupattr"+i+"\" name=\"detailgroupattr"+i+"\" value=\""+detailGroupAttr+"\">").append("\n");
					%>
							<select notBeauty=true id="fieldlist<%=i%>" notBeauty="true" name="fieldlist<%=i%>" class="fieldlist" size="15" onchange="loadfieldstyle(this)" ondblclick="javascript:cool_webcontrolfield(this);" style="width:100%;display:none;height:150px;">
					<%
								for(int j=0; j<detailFieldidList.size(); j++){
									String detailFieldid_tmp = (String)detailFieldidList.get(j);
									String detailFieldlabel_tmp = (String)fieldLabel_hs.get("fieldlabel"+detailFieldid_tmp);
									String detailFieldAttr_tmp = (String)fieldAttr_hs.get("fieldAttr"+detailFieldid_tmp);
									fieldAttr_sb.append("<input type=\"hidden\" id=\"fieldattr"+detailFieldid_tmp+"\" nodetype=\""+i+"\" name=\"fieldattr"+detailFieldid_tmp+"\" value=\""+detailFieldAttr_tmp+"\">").append("\n");
									String fieldSQL_tmp = Util.null2String((String)fieldSQL_hs.get("fieldsql"+detailFieldid_tmp));
									int caltype_tmp = Util.getIntValue((String)fieldSQL_hs.get("caltype"+detailFieldid_tmp), 0);
									int othertype_tmp = Util.getIntValue((String)fieldSQL_hs.get("othertype"+detailFieldid_tmp), 0);
									int transtype_tmp = Util.getIntValue((String)fieldSQL_hs.get("transtype"+detailFieldid_tmp), 0);
									fieldSQL_sb.append("<input type=\"hidden\" id=\"fieldsql"+detailFieldid_tmp+"\" name=\"fieldsql"+detailFieldid_tmp+"\" value=\""+fieldSQL_tmp+"\">").append("\n");
									fieldSQL_sb.append("<input type=\"hidden\" id=\"caltype"+detailFieldid_tmp+"\" name=\"caltype"+detailFieldid_tmp+"\" value=\""+caltype_tmp+"\" >").append("\n");
									fieldSQL_sb.append("<input type=\"hidden\" id=\"othertype"+detailFieldid_tmp+"\" name=\"othertype"+detailFieldid_tmp+"\" value=\""+othertype_tmp+"\">").append("\n");
									fieldSQL_sb.append("<input type=\"hidden\" id=\"transtype"+detailFieldid_tmp+"\" name=\"transtype"+detailFieldid_tmp+"\" value=\""+transtype_tmp+"\">").append("\n");
									fieldid_sb.append(detailFieldid_tmp+",");
					%>
									<option value="<%=detailFieldid_tmp%>" nodeType="<%=detailFieldAttr_tmp%>"><%=detailFieldlabel_tmp%></option>
					<%
								}
							}
					%>
							</select>
					<%
						}
					}
						if(nodeidList!=null && nodeidList.size()>0){//防止没有节点
					%>
							<select notBeauty=true id="fieldlist-2" notBeauty="true" name="fieldlist-2" class="fieldlist" size="15" onchange="loadfieldstyle(this)" ondblclick="javascript:cool_webcontrolnode(this);" style="width:100%;display:none;height:150px;">
					<%
							for(int i=0; i<nodeidList.size(); i++){
								String nodeid_tmp = (String)nodeidList.get(i);
								String nodename_tmp = (String)nodenameList.get(i);
					%>
								<option value="<%=nodeid_tmp%>" nodeType="<%=nodeid_tmp%>"><%=nodename_tmp%></option>
					<%
							}
					%>
                            <option value="999999999" nodeType="999999999"><%=SystemEnv.getHtmlLabelName(84441, user.getLanguage())%></option>
							</select>
					<%
						}
					%>
						</td>
					</tr>
				</table>
						</wea:item>
					</wea:group>
					<wea:group context='<%=SystemEnv.getHtmlLabelName(23724,user.getLanguage())%>' attributes="{'itemAreaDisplay':''}">
						<wea:item attributes="{'colspan':'2'}">
							<input type="hidden" id="nowgroupid" name="nowgroupid" value=""><input type="hidden" id="nowfieldid" name="nowfieldid" value="">
					<div id="groupAttrDiv" name="groupAttrDiv" class="groupAttrDiv" style="display:none">
					<%if(nodetype==0 || nodetype==1 || nodetype==2){%>
						<%=SystemEnv.getHtmlLabelName(19394,user.getLanguage())%><input type="checkbox" id="dtladd" name="dtladd" class="groupattrcheckbox" value="1" notBeauty="true" onclick="onclickgroupattr(this)"><%=SystemEnv.getHtmlLabelName(19395,user.getLanguage())%><input type="checkbox" id="dtledit" name="dtledit" class="groupattrcheckbox" value="1" notBeauty="true" onclick="onclickgroupattr(this)">
						</br>
						<%=SystemEnv.getHtmlLabelName(24801,user.getLanguage())%>
						<input type="checkbox" id="dtlned" name="dtlned" class="groupattrcheckbox" value="1" notBeauty="true" onclick="onclickgroupattr(this)"><%=SystemEnv.getHtmlLabelName(24796,user.getLanguage())%><input type="checkbox" id="dtldef" name="dtldef" class="groupattrcheckbox" value="1" notBeauty="true" onclick="onclickgroupattr(this)">
						</br>
						<%=SystemEnv.getHtmlLabelName(19396,user.getLanguage())%><input type="checkbox" id="dtldel" name="dtldel" class="groupattrcheckbox" value="1" notBeauty="true" onclick="onclickgroupattr(this)"><%=SystemEnv.getHtmlLabelName(22363,user.getLanguage())%><input type="checkbox" id="dtlhide" name="dtlhide" class="groupattrcheckbox" value="1" notBeauty="true" onclick="onclickgroupattr(this)">
						<br>
						<!-- zzl -->
						<%=SystemEnv.getHtmlLabelName(31592 ,user.getLanguage())%>
						<input type="checkbox" id="dtlmul" name="dtlmul" class="groupattrcheckbox" value="1" notBeauty="true" onclick="onclickgroupattr(this)">
					<%}else{%>
						<%=SystemEnv.getHtmlLabelName(22363,user.getLanguage())%><input type="checkbox" id="dtlhide" name="dtlhide" class="groupattrcheckbox" value="1" notBeauty="true" onclick="onclickgroupattr(this)">
						<input type="checkbox" id="dtladd" name="dtladd" class="groupattrcheckbox0" value="1" style="visibility:hidden">
						<input type="checkbox" id="dtledit" name="dtledit" class="groupattrcheckbox0" value="1" style="visibility:hidden">
						<input type="checkbox" id="dtldel" name="dtldel" class="groupattrcheckbox0" value="1" style="visibility:hidden">
						<input type="checkbox" id="dtlned" name="dtlned" class="groupattrcheckbox0" value="1" style="visibility:hidden">
						<input type="checkbox" id="dtldef" name="dtldef" class="groupattrcheckbox0" value="1" style="visibility:hidden">
						<!-- zzl -->
						<input type="checkbox" id="dtlmul" name="dtlmul" class="groupattrcheckbox0" value="1" style="visibility:hidden">
					<%}%>
					</div>
					<select notBeauty=true id="fieldattrlist" name="fieldattrlist" class="fieldattrlist" onchange="onchangefieldattr(this)" style="display:none">
						<!-- option value="0"><%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%></option> --><!-- 把"隐藏"属性去掉 -->
						<option value="1"><%=SystemEnv.getHtmlLabelName(17873,user.getLanguage())%></option>
						<option value="2"><%=SystemEnv.getHtmlLabelName(18018,user.getLanguage())%></option>
						<option value="3"><%=SystemEnv.getHtmlLabelName(18019,user.getLanguage())%></option>
					</select>
						</wea:item>
						<wea:item attributes="{'colspan':'2'}">
							<%=SystemEnv.getHtmlLabelName(23731,user.getLanguage())%>
							<input id="layoutname" name="layoutname" class="InputStyle" value="<%=layoutname%>" temptitle="<%=SystemEnv.getHtmlLabelName(23731,user.getLanguage())%>" maxlength="20" onchange="checkinput('layoutname','layoutnamespan')"><span id="layoutnamespan"><%if("".equals(layoutname)){out.print("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");}%></span>
						</wea:item>
						<%if(layouttype == 0){%>
						<wea:item attributes="{'colspan':'2'}">
							<a href="javascript:openFullWindowHaveBar('/workflow/workflow/edithtmlnodefield.jsp?layouttype=<%=layouttype %>&wfid=<%=wfid%>&nodeid=<%=nodeid%>&ajax=0')"><%=SystemEnv.getHtmlLabelName(23689,user.getLanguage())%></a>
						</wea:item>
						<%}else if(layouttype == 1){%>
						<wea:item >
							<%=SystemEnv.getHtmlLabelName(23692,user.getLanguage())%>
						</wea:item>
						<wea:item >
							<select notBeauty=true id="colsperrow" name="colsperrow" style="width:50px">
								<option value="1">1</option>
								<option value="2">2</option>
								<option value="3">3</option>
								<option value="4">4</option>
							</select>
						</wea:item>
						<%}%>
						<%if(layouttype == 0 || layouttype == 1){ %>
						<wea:item attributes="{'colspan':'2'}">
							CSS<%=SystemEnv.getHtmlLabelName(1014,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(68,user.getLanguage())%>
							<a href="#" onclick="uploadCss()"><%=SystemEnv.getHtmlLabelName(75,user.getLanguage())%></a>
							<a href="#" onclick="changeCss()"><%=SystemEnv.getHtmlLabelName(27825,user.getLanguage())%></a>
						</wea:item>
						<wea:item attributes="{'colspan':'2'}">
							CSS<%=SystemEnv.getHtmlLabelName(17517,user.getLanguage())%>：

							<span id="cssfilespan"><%=cssname%></span>
							<input type="hidden" id="cssfile" name="cssfile" value="<%=cssfile%>">
							&nbsp;<span class="delTempcss" style="display:<%="".equals(cssname)?"none":"" %>;" title="<%=SystemEnv.getHtmlLabelName(129247, user.getLanguage())%>" onclick="javascript:clearTempcss();">x</span>
						</wea:item>
						<wea:item attributes="{'colspan':'2'}">
							<a href="/workflow/html/WorkFlowCssList.jsp" target="_blank">CSS<%=SystemEnv.getHtmlLabelName(18493,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(60,user.getLanguage())%></a>
						</wea:item>
						<wea:item attributes="{'colspan':'2'}">
							<input type="checkbox" name="htmlParseScheme" <%=htmlParseScheme == 1 ? "checked" : "" %> id="htmlParseScheme" value="1"><%=SystemEnv.getHtmlLabelName(82172, user.getLanguage())%><a href="/workflow/html/CrossBrowserDescription.jsp?languageid=<%=user.getLanguage()%>" target="_blank"><%=SystemEnv.getHtmlLabelName(82173, user.getLanguage())%></a>）

						</wea:item>
						<%}%>
						<wea:item attributes="{'colspan':'2'}">
							<a href="/workflow/html/OperationDescription.jsp?languageid=<%=user.getLanguage()%>" target="_blank"><%=SystemEnv.getHtmlLabelName(19010,user.getLanguage())%></a>
						</wea:item>
					</wea:group>
		</wea:layout>
	
	
	
	</div>
	<!-- 左侧 -->
	<div style="height:100%;margin-right:250px;">
		<textarea name="layouttext" id="layouttext" style="width:100%;height:100%"><%=htmlLayout%></textarea>
	</div>
</div>



<%=fieldAttr_sb.toString()%>
<%=detailGroupAttr_sb.toString()%>
<%=fieldSQL_sb%>
<input type="hidden" name="curmodetype" />
<input type="hidden" id="operation" name="operation" value="save">
<input type="hidden" id="wfid" name="wfid" value="<%=wfid%>">
<input type="hidden" id="formid" name="formid" value="<%=formid%>">
<input type="hidden" id="nodeid" name="nodeid" value="<%=nodeid%>">
<input type="hidden" id="modeid" name="modeid" value="<%=modeid%>">
<input type="hidden" id="isbill" name="isbill" value="<%=isbill%>">
<input type="hidden" id="layouttype" name="layouttype" value="<%=layouttype%>">
<input type="hidden" id="isform" name="isform" value="<%=isform%>">
<input type="hidden" id="fieldids" name="fieldids" value="<%if(fieldid_sb.length()>0){out.print(fieldid_sb.deleteCharAt(fieldid_sb.length()-1));}%>">
<input type="hidden" id="fileFieldids" name="fileFieldids" value="<%=fileFieldids%>">
<input type="hidden" id="inputFieldids" name="inputFieldids" value="<%=inputFieldids%>">
<input type="hidden" id="especialFieldids" name="especialFieldids" value="<%=especialFieldids%>">
<input type="hidden" id="shuziFieldids" name="shuziFieldids" value="<%=shuziFieldids%>">
<input type="hidden" id="gpsFieldid" name="gpsFieldid" value="<%=gpsFieldid%>">
<input type="hidden" id="canFieldEdit" name="canFieldEdit" value="<%=canFieldEdit%>">
<input type="hidden" id="htmlfile" name="htmlfile" value="">
<input type="hidden" id="dateFields" name="dateFields" value="<%=dateFields%>">
<input type="hidden" id="zhengshuFields" name="zhengshuFields" value="<%=zhengshuFields%>">
<div id="htmllayoutdiv" name="htmllayoutdiv" style="height:0px;width:0px;visibility:hidden"></div>
</form>
<%} %>
</BODY>
<script language="javascript">
//标识是否为手机版HTML模板
var isMobileLayout = <%=(layouttype==2)%>;

//如果是手机版HTML模板，则不能设置字段属性(只读、可编辑、必填)
if(isMobileLayout){
	$GetEle("fieldattrlist").disabled = true;
}

function openFieldAttributeDialog(){
	alert(1);
	var url = escape("/FCKEditor/editor/dialog/fck_fieldattr.jsp?wfid=1&nodeid=2");
	var id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url, window);

}

function funcremark(){
	if(isMobileLayout){
		FCKEditorExt.initEditor("LayoutForm","layouttext",7,FCKEditorExt.MobileLayout_IMAGE, '100%');
	}else{
		FCKEditorExt.initEditor("LayoutForm","layouttext",7,FCKEditorExt.HtmlLayout_IMAGE, '100%');
	}
}
function initFckEdit(){
	funcremark();
}
//往左边Fck编辑框里加一个字段显示名
function cool_webcontrollabel(obj){
	//var nodetype = obj.options.item(obj.selectedIndex).nodeType;
    //var fieldlabel = obj.options.item(obj.selectedIndex).text;
	//var labelid = obj.value;
	//var labelhtml = "<input class=\"Label\" id=\"$label"+labelid+"$\" name=\"label"+labelid+"\" value=\""+nodetype+"\">";
	//FCKEditorExt.insertHtml(labelhtml, "layouttext");
	var fckHtml = FCKEditorExt.getHtml("layouttext");
	var nodetype = obj.options.item(obj.selectedIndex).nodeType;
	var label = obj.options.item(obj.selectedIndex).text;
	var labelid = obj.value;
	//if(fckHtml.indexOf("$node"+fieldid+"$") != -1){
	//	alert("<%=SystemEnv.getHtmlLabelName(23723, user.getLanguage())%>");
	//	return;
	//}
	var labelhtml = "<input class=\"Label\" id=\"$label"+labelid+"$\" name=\"label"+labelid+"\" value=\""+label+"\">";
	FCKEditorExt.insertHtml(labelhtml, "layouttext");
}
function cool_webcontrolnode(obj){
	var fckHtml = FCKEditorExt.getHtml("layouttext");
	var nodetype = obj.options.item(obj.selectedIndex).nodeType;
	var fieldlabel = obj.options.item(obj.selectedIndex).text;
	var fieldid = obj.value;
	if(fckHtml.indexOf("$node"+fieldid+"$") != -1){
		alert("<%=SystemEnv.getHtmlLabelName(23723, user.getLanguage())%>");
		return;
	}
	var fieldhtml = "<input class=\"InputStyle\" id=\"$node"+fieldid+"$\" name=\"node"+fieldid+"\" value=\""+fieldlabel+"\" disabled=true>";
	FCKEditorExt.insertHtml(fieldhtml, "layouttext");
}

//往左边Fck编辑框里加一个字段

function cool_webcontrolfield(obj){
	var fckHtml = FCKEditorExt.getHtml("layouttext");
	var nodetype = obj.options.item(obj.selectedIndex).nodeType;
	var fieldlabel = obj.options.item(obj.selectedIndex).text;
	var fieldid = obj.value;
	if(fckHtml.indexOf("$field"+fieldid+"$") != -1){
		alert("<%=SystemEnv.getHtmlLabelName(23723, user.getLanguage())%>");
		return;
	}
<%if(nodetype==0 || nodetype==1 || nodetype==2){%>
	$("#fieldattr"+fieldid).val("2");//刚添加的都认为是编辑属性

<%}else{%>
	$("#fieldattr"+fieldid).val("1");//
<%}%>
	if(fieldid == "-4"){
		$("#fieldattr"+fieldid).val("1");
	}
	var fieldattrStr = "<%=SystemEnv.getHtmlLabelName(18018,user.getLanguage())%>";
//手机Html模板不能设置字段属性，故去掉该条件layouttype为2的条件

<%if((layouttype==0) && (nodetype==0 || nodetype==1 || nodetype==2)){%>
	var fieldhtml = "<input class=\"InputStyle\" id=\"$field"+fieldid+"$\" name=\"field"+fieldid+"\" value=\"["+fieldattrStr+"]"+fieldlabel+"\">";
<%}else{%>
	var fieldhtml = "<input class=\"InputStyle\" id=\"$field"+fieldid+"$\" name=\"field"+fieldid+"\" value=\""+fieldlabel+"\">";
<%}%>
	if(fieldid == "-4"){
		fieldhtml = "<input class=\"InputStyle\" id=\"$field"+fieldid+"$\" name=\"field"+fieldid+"\" value=\""+fieldlabel+"\">";
	}
	FCKEditorExt.insertHtml(fieldhtml, "layouttext");
	//添加了字段，同时把下面的字段属性下拉框显示出来
	var nodetype = obj.options.item(obj.selectedIndex).nodeType;
	//$("#nowgroupid").val("");
	$("#nowfieldid").val("");
	$("#groupAttrDiv").hide();
	$("#fieldattrlist").hide();
	$(".groupattrcheckbox").attr("checked", "");
<%if(layouttype==0 || layouttype == 2){//编辑模板%>
	//如果Fck编辑框里面没有这个字段，那么也不显示出来
	if(obj.id != "fieldlist-2" && fieldid!="-4"){//不是节点
		if(obj.id == "fieldlist-1"){//主表
			var nowfieldid = obj.value;
			$("#nowfieldid").val(nowfieldid);
		<%if(nodetype==0 || nodetype==1 || nodetype==2){%>
			var fieldattr = $("#fieldattr"+nowfieldid).val();
			$("#fieldattrlist").val(fieldattr);
			$("#fieldattrlist").show();
		<%}%>
		}else{
			var nowgroupid = $("#nowgroupid").val();
			var nowgroupattr = $("#detailgroupattr"+nowgroupid).val();
		<%if(nodetype==0 || nodetype==1 || nodetype==2){%>
			$("#fieldattrlist option").each(function(){
				if($(this).val()=="2" || $(this).val()=="3"){
					$(this).remove();
				}
			});
			if(nowgroupattr.indexOf("00") != 0){
				$("#fieldattrlist").append("<option value=\"2\"><%=SystemEnv.getHtmlLabelName(18018,user.getLanguage())%></option>");
				$("#fieldattrlist").append("<option value=\"3\"><%=SystemEnv.getHtmlLabelName(18019,user.getLanguage())%></option>");
			}
		<%}%>
			var nowfieldid = obj.value;
			$("#nowfieldid").val(nowfieldid);
		<%if(nodetype==0 || nodetype==1 || nodetype==2){%>
			var fieldattr = $("#fieldattr"+nowfieldid).val();
			$("#fieldattrlist").val(fieldattr);
			$("#fieldattrlist").show();
		<%}%>
		}
	}
<%}%>
}

function fomateHtml(textStr){
	var tmpStr = "";
	var hasTd = textStr.indexOf("<td");
	var tdIndex = textStr.indexOf("<td");
	var headIndex = textStr.indexOf("<", tdIndex+1);
	var tailIndex = textStr.indexOf(">", tdIndex);
	var tailTdIndex = textStr.indexOf(">&nbsp;</td>", tdIndex);
	while(hasTd >= 0){
		if(tdIndex>=0 && headIndex==(tailIndex+7) && tailTdIndex==tailIndex){
			tmpStr += textStr.substring(0, tailIndex+1);
			textStr = textStr.substring(tailTdIndex+7, textStr.length);
		}else{
			tmpStr += textStr.substring(0, tdIndex+3);
			textStr = textStr.substring(tdIndex+3, textStr.length);
		}
		hasTd = textStr.indexOf("<td");
		tdIndex = textStr.indexOf("<td");
		headIndex = textStr.indexOf("<", tdIndex+1);
		tailIndex = textStr.indexOf(">", tdIndex);
		tailTdIndex = textStr.indexOf(">&nbsp;</td>", tdIndex);
	}
	tmpStr += textStr;
	return tmpStr;
}
function onSave(){
	FCKEditorExt.updateContent("layouttext");
	var textStr = document.getElementById("layouttext").value;
	
	var tmpStr = fomateHtml(textStr);
	document.getElementById("layouttext").value = tmpStr;
	if(check_form(LayoutForm,"layoutname")){
		LayoutForm.submit();
		enableAllmenu();
	}
}
function onPrepPrintMode(){
	if(confirm("<%=SystemEnv.getHtmlLabelName(25780, user.getLanguage())%>")){
		LayoutForm.operation.value = "preppm";
		LayoutForm.submit();
	}
}

function onchangeformlabel(obj){
	$(".labellist").hide();
	$("#labellist"+obj.value).show();
}
function onchangeformfield(obj){
	$(".fieldlist").hide();
	$("#fieldlist"+obj.value).show();
	$("#nowgroupid").val(obj.value);
	$("#nowfieldid").val("");
	$("#groupAttrDiv").hide();
	$("#fieldattrlist").hide();
	$(".groupattrcheckbox").attr("checked", "");
	//只有在非手机版Html模板，才能操作明细。

	if(!isMobileLayout){
		if($("#nowgroupid").val()!="-2" && $("#nowgroupid").val()!="-1"){
			var thisGroupAttr = $("#detailgroupattr"+obj.value).val();
			if(thisGroupAttr.indexOf("1") == 0){
				$("#dtladd").attr("checked", "checked");
			}
			if(thisGroupAttr.indexOf("1",1) == 1){
				$("#dtledit").attr("checked", "checked");
			}
			if(thisGroupAttr.indexOf("1",2) == 2){
				$("#dtldel").attr("checked", "checked");
			}
			if(thisGroupAttr.indexOf("1",3) == 3){
				$("#dtlhide").attr("checked", "checked");
			}
			if(thisGroupAttr.indexOf("1",4) == 4){
				$("#dtldef").attr("checked", "checked");
			}
			if(thisGroupAttr.indexOf("1",5) == 5){
				$("#dtlned").attr("checked", "checked");
			}
			if(thisGroupAttr.indexOf("1",6) == 6){
				$("#dtlmul").attr("checked", "checked");
			}
			$("#groupAttrDiv").show();
		}
	}
}
function onclickgroupattr(obj){
	var nowgroupid = $("#nowgroupid").val();
	var groupattr = "";
	var text2 = "";
	if($("#dtladd").attr("checked")==true){
		groupattr += "1";
		text2 = "<button class=\"addbtn\" type=\"button\" id=\"$addbutton"+nowgroupid+"$\" name=\"addbutton"+nowgroupid+"\" onclick=\"addRow"+nowgroupid+"("+nowgroupid+");return false;\" title=\"<%=SystemEnv.getHtmlLabelName(611, user.getLanguage())%>\"></button>";
	}else{
		groupattr += "0";
	}
	text2 += "<button class=\"delbtn\" type=\"button\" id=\"$delbutton"+nowgroupid+"$\" name=\"delbutton"+nowgroupid+"\" onclick=\"if(isdel()){deleteRow"+nowgroupid+"("+nowgroupid+");}return false;\" title=\"<%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%>\"></button>";
	var fckHtml = FCKEditorExt.getHtml("layouttext");
	var pos1 = fckHtml.indexOf("<div id=\"div"+nowgroupid+"button\"");
	if(pos1 != -1){
		var pos2 = fckHtml.indexOf(">", pos1);
		var pos3 = fckHtml.indexOf("</div>", pos2);
		var text1 = fckHtml.substring(0, pos2+1);
		var text3 = fckHtml.substring(pos3);
		var text = text1 + text2 + text3;
		FCKEditorExt.setHtml(text, "layouttext");
	}
	if($("#dtledit").attr("checked")==true){
		groupattr += "1";
	}else{
		groupattr += "0";
	}
	if($("#dtldel").attr("checked")==true){
		groupattr += "1";
	}else{
		groupattr += "0";
	}
	if($("#dtlhide").attr("checked")==true){
		groupattr += "1";
	}else{
		groupattr += "0";
	}
	if($("#dtldef").attr("checked")==true){
		groupattr += "1";
	}else{
		groupattr += "0";
	}
	if($("#dtlned").attr("checked")==true){
		groupattr += "1";
	}else{
		groupattr += "0";
	}
	if($("#dtlmul").attr("checked")==true){
		groupattr += "1";
	}else{
		groupattr += "0";
	}
	$("#detailgroupattr"+nowgroupid).val(groupattr);
}
function loadfieldstyle(obj){
	var nodetype = obj.options.item(obj.selectedIndex).nodeType;
	//$("#nowgroupid").val("");
	$("#nowfieldid").val("");
	$("#groupAttrDiv").hide();
	$("#fieldattrlist").hide();
	$(".groupattrcheckbox").attr("checked", "");
<%if(layouttype==0 || layouttype==2){//只有显示模板才能调整字段显示属性%>
	var especialFieldids = $("#especialFieldids").val();
	var index_eFieldids = (","+especialFieldids+",").indexOf(","+obj.value+",");
	var gpsFieldid = $("#gpsFieldid").val();
	var index_gpsFieldids = (","+gpsFieldid+",").indexOf(","+obj.value+",");
	if(obj.id!="fieldlist-2" && index_eFieldids==-1 && obj.value!="-4"&&index_gpsFieldids==-1){//不是节点
		var fckHtml = FCKEditorExt.getHtml("layouttext");
		if(fckHtml.indexOf("$field"+obj.value+"$") != -1){//如果Fck编辑框里面没有这个字段，那么也不显示出来
			if(obj.id == "fieldlist-1"){//主表
				var nowfieldid = obj.value;
				$("#nowfieldid").val(nowfieldid);
			<%if(nodetype==0 || nodetype==1 || nodetype==2){%>
				var fieldattr = $("#fieldattr"+nowfieldid).val();
				$("#fieldattrlist").val(fieldattr);
				$("#fieldattrlist").show();
			<%}%>
			}else{
				var nowgroupid = $("#nowgroupid").val();
				var nowgroupattr = $("#detailgroupattr"+nowgroupid).val();
			<%if(nodetype==0 || nodetype==1 || nodetype==2){%>
				$("#fieldattrlist option").each(function(){
					if($(this).val()=="2" || $(this).val()=="3"){
						$(this).remove();
					}
				});
				if(nowgroupattr.indexOf("00") != 0){
					$("#fieldattrlist").append("<option value=\"2\"><%=SystemEnv.getHtmlLabelName(18018,user.getLanguage())%></option>");
					$("#fieldattrlist").append("<option value=\"3\"><%=SystemEnv.getHtmlLabelName(18019,user.getLanguage())%></option>");
				}
			<%}%>
				var nowfieldid = obj.value;
				$("#nowfieldid").val(nowfieldid);
			<%if(nodetype==0 || nodetype==1 || nodetype==2){%>
				var fieldattr = $("#fieldattr"+nowfieldid).val();
				$("#fieldattrlist").val(fieldattr);
				$("#fieldattrlist").show();
			<%}%>
			}
		}
	}
	fckHtml = FCKEditorExt.getHtml("layouttext");
	//FCKEditorExt.setHtml(fckHtml,"layouttext");
<%}%>
}
function onchangefieldattr(obj){
	var nowfieldid = $("#nowfieldid").val();
	$("#fieldattr"+nowfieldid).val(obj.value);
	var fckHtml = FCKEditorExt.getHtml("layouttext");
	var pos1 = fckHtml.indexOf("$field"+nowfieldid+"$");
	if(pos1 != -1){
		var pos2 = fckHtml.indexOf("[", pos1);
		if(pos2 != -1){
			var pos3 = fckHtml.indexOf("]", pos2);
			var text1 = fckHtml.substring(0, pos2+1);
			if(obj.value == "0"){
				var text1 = text1.substring(0, text1.lastIndexOf("<"));
				pos3 = fckHtml.indexOf(">", pos2)+1;
				//text1 += "隐藏";如果切换成隐藏，直接删除
			}else if(obj.value == "1"){
				text1 += "<%=SystemEnv.getHtmlLabelName(17873,user.getLanguage())%>";	
			}else if(obj.value == "2"){
				text1 += "<%=SystemEnv.getHtmlLabelName(18018,user.getLanguage())%>";
			}else if(obj.value == "3"){
				text1 += "<%=SystemEnv.getHtmlLabelName(18019,user.getLanguage())%>";
			}
			text1 += fckHtml.substring(pos3);
			FCKEditorExt.setHtml(text1,"layouttext");
		}
	}else if(obj.value != "0"){
		//如果本来没有，则添加进去
		var nowgroupid = "-1";
		if(nowfieldid.indexOf("-") == 0){//明细字段
			nowgroupid = $("#nowgroupid").val();
		}
		var obj2 = document.getElementById("fieldlist"+nowgroupid);
		var nodetype = obj2.options.item(obj2.selectedIndex).nodeType;
		var fieldlabel = obj2.options.item(obj2.selectedIndex).text;
		var fieldid = nowfieldid;
		var fieldattrStr = "<%=SystemEnv.getHtmlLabelName(18018,user.getLanguage())%>";
		if(obj.value == "1"){
			fieldattrStr = "<%=SystemEnv.getHtmlLabelName(17873,user.getLanguage())%>";
		}else if(obj.value == "3"){
			fieldattrStr = "<%=SystemEnv.getHtmlLabelName(18019,user.getLanguage())%>";
		}
	<%if(layouttype==0 || layouttype == 2){%>
		var fieldhtml = "<input class=\"InputStyle\" id=\"$field"+fieldid+"$\" name=\"field"+fieldid+"\" value=\"["+fieldattrStr+"]"+fieldlabel+"\">";
	<%}else{%>
		var fieldhtml = "<input class=\"InputStyle\" id=\"$field"+fieldid+"$\" name=\"field"+fieldid+"\" value=\""+fieldlabel+"\">";
	<%}%>
		FCKEditorExt.insertHtml(fieldhtml, "layouttext");

	}
}
function onchangefieldattrFromFck(fieldid,fieldShowAttr){
	var nowfieldid = $("#nowfieldid").val();
	if(nowfieldid == fieldid){
		$("#fieldattrlist").val(fieldShowAttr);
	}
	var fckHtml = FCKEditorExt.getHtml("layouttext");
	var pos1 = fckHtml.indexOf("$field"+fieldid+"$");
	if(pos1 != -1){
		var pos2 = fckHtml.indexOf("[", pos1);
		if(pos2 != -1){
			var pos3 = fckHtml.indexOf("]", pos2);
			var text1 = fckHtml.substring(0, pos2+1);
			if(fieldShowAttr == "0"){
				var text1 = text1.substring(0, text1.lastIndexOf("<"));
				pos3 = fckHtml.indexOf(">", pos2)+1;
				//text1 += "隐藏";如果切换成隐藏，直接删除
			}else if(fieldShowAttr == "1"){
				text1 += "<%=SystemEnv.getHtmlLabelName(17873,user.getLanguage())%>";	
			}else if(fieldShowAttr == "2"){
				text1 += "<%=SystemEnv.getHtmlLabelName(18018,user.getLanguage())%>";
			}else if(fieldShowAttr == "3"){
				text1 += "<%=SystemEnv.getHtmlLabelName(18019,user.getLanguage())%>";
			}
			text1 += fckHtml.substring(pos3);
			FCKEditorExt.setHtml(text1,"layouttext");
		}
	}
}
function uploadCss(){
	var urls = "/workflow/html/WorkFlowCssUP.jsp";
	var id_t = showModalDialog("/systeminfo/BrowserMain.jsp?url="+urls);
	if(id_t){
		if(id_t[0]!="" && id_t[0]!="0" && id_t[0]!="-1"){
			document.getElementById("cssfile").value = id_t[0];
			document.getElementById("cssfilespan").innerHTML = id_t[1];
		}else{
			document.getElementById("cssfile").value = "";
			document.getElementById("cssfilespan").innerHTML = "";
		}
	}
}
function changeCss(){
	var urls = "/workflow/html/WorkFlowCssBrowser.jsp";
	var id_t = showModalDialog("/systeminfo/BrowserMain.jsp?url="+urls);
	//alert(id_t);
	//alert(id_t[0]);
	//alert(id_t[1]);
	if(id_t){
		if(id_t[0]!="" && id_t[0]!="0" && id_t[0]!="-1"){
			document.getElementById("cssfile").value = id_t[0];
			document.getElementById("cssfilespan").innerHTML = id_t[1];
			jQuery(".delTempcss").show();
		}else{
			document.getElementById("cssfile").value = "";
			document.getElementById("cssfilespan").innerHTML = "";
			jQuery(".delTempcss").hide();
		}
	}
}

function clearTempcss(){
	jQuery("#cssfile").val("");
	jQuery("#cssfilespan").text("");
	jQuery(".delTempcss").hide();
}

function onPreviewLayout(){
	openFullWindow("/workflow/html/LayoutPreview.jsp?modeid=<%=modeid%>&workflowid=<%=wfid%>&nodeid=<%=nodeid%>&isbill=<%=isbill%>&nodetype=<%=nodetype%>&formid=<%=formid%>&isremark=0");
}
function onImportLayout(){
	var urls = "/workflow/html/WorkFlowHtmlBrowser.jsp";
	var id_t = showModalDialog("/systeminfo/BrowserMain.jsp?url="+urls);
	if(id_t){
		if(id_t[0]=="1"){
			self.location.reload();
		}
	}
}
function onExportLayout(){
	document.getElementById("htmloutiframe").src = "/weaver/weaver.file.HtmlFileDownload?modeid=<%=modeid%>";
}
</script>
</HTML>
