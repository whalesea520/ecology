<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="com.weaver.formmodel.util.StringHelper"%> 
<%@ page import="weaver.formmode.service.ModelInfoService"%>
<%@ page import="weaver.formmode.service.FormInfoService"%>
<%@ page import="weaver.formmode.util.ModeLayoutCommonUtil"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="modeRightInfo" class="weaver.formmode.setup.ModeRightInfo" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/formmode/pub_detach.jsp"%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<LINK href="/js/jquery/plugins/multiselect/jquery.multiselect_wev8.css" type=text/css rel=STYLESHEET>
<link href="/js/jquery/plugins/multiselect/style_wev8.css" type=text/css rel=STYLESHEET>
<link href="/formmode/css/formmode_wev8.css" type="text/css" rel="stylesheet" />
<script language=javascript src="/js/weaver_wev8.js"></script>
<script type="text/javascript" src="/formmode/js/jquery/jquery-ui-1.10.3/ui/minified/jquery-ui.min_wev8.js"></script>
<script language="javascript" src="/js/jquery/plugins/multiselect/jquery.multiselect.min_wev8.js"></script>
<script language="javascript" src="/js/jquery-autocomplete/jquery.autocomplete_wev8.js"></script>
<script language="javascript" src="/mobilemode/js/UUID_wev8.js"></script>
<style type="text/css">
.conditionInput{
	border: 1px solid #e6e6e6;
	padding-left: 5px;
	padding-right: 5px;
}

.ui-multiselect-menu{
	z-index:9999999;
}
.ui-multiselect-displayvalue{
	background-image:none;
	width: 89%;
}

.ui-state-default, .ui-widget-content .ui-state-default, .ui-widget-header .ui-state-default{
	background-image:none;
	background-color: rgb(255,255,255);
}

.ui-state-hover, .ui-widget-content .ui-state-hover, .ui-widget-header .ui-state-hover, .ui-state-focus, .ui-widget-content .ui-state-focus, .ui-widget-header .ui-state-focus{
	background-image:none;
	background-color: rgb(255,255,255);
}

.ui-widget-header {
	background-image:none;
}
</style>
</head>
<%
	if (!HrmUserVarify.checkUserRight("ModeSetting:All", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>
<%
ModeLayoutCommonUtil modeLayoutCommonUtil = new ModeLayoutCommonUtil();
int modeId = Util.getIntValue(request.getParameter("id"),0);
if(modeId<=0){
	modeId = Util.getIntValue(request.getParameter("modeId"),0);
}
int formId = Util.getIntValue(Util.null2String(request.getParameter("formId")));

String subCompanyIdsql = "select subCompanyId from modeinfo where id="+modeId;
RecordSet recordSet = new RecordSet();
recordSet.executeSql(subCompanyIdsql);
int subCompanyId = -1;
if(recordSet.next()){
	subCompanyId = recordSet.getInt("subCompanyId");
}
String userRightStr = "ModeSetting:All";
Map rightMap = getCheckRightSubCompanyParam(userRightStr,user,fmdetachable, subCompanyId,"",request,response,session);
int operatelevel = Util.getIntValue(Util.null2String(rightMap.get("operatelevel")),-1);
subCompanyId = Util.getIntValue(Util.null2String(rightMap.get("subCompanyId")),-1);

boolean isVirtualForm = Boolean.valueOf(Util.null2String(request.getParameter("isVirtualForm")));
if(isVirtualForm){
	FormInfoService formInfoService = new FormInfoService();
	Map<String, Object> formInfo = formInfoService.getFormInfoById(formId);
	String virtualformtype = Util.null2String(formInfo.get("virtualformtype"));
	if("1".equals(virtualformtype)){
		StringBuffer message=new StringBuffer();
		message.append("<div id='message' style='padding-top:10px;font-size:14px;color:red;'>"+SystemEnv.getHtmlLabelName(82371,user.getLanguage())+"</div>");//此模块关联的是虚拟表单视图，不支持数据操作和权限配置。
		message.append("<script>$(document).ready(function(){$('.loading', window.parent.document).hide();$(document.body).height($('#message').outerHeight());});</script>");
		out.print(message.toString());
		return;
	}
}
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(16526,user.getLanguage());
String needfav ="";
String needhelp ="";
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<BODY> 
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(modeId >0 && !isVirtualForm){
	if(operatelevel>0){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(this),_top} " ;//保存
		RCMenuHeight += RCMenuHeightStep ;
		
		RCMenu += "{"+SystemEnv.getHtmlLabelName(30254,user.getLanguage())+",javascript:createmenu1(),_self} " ;//创建批量导入菜单
		RCMenuHeight += RCMenuHeightStep;
	}
	
	RCMenu += "{"+SystemEnv.getHtmlLabelName(30255,user.getLanguage())+",javascript:viewmenu1(),_self} " ;//查看批量导入菜单地址
	RCMenuHeight += RCMenuHeightStep;
	
	if(operatelevel>0){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(31464,user.getLanguage())+",javascript:resetModeShare(),_self} " ;//权限重构
		RCMenuHeight += RCMenuHeightStep;
	}
	
	String mainSql = "select seccategory,selectcategory from modeinfo where id="+modeId;
	RecordSet.executeSql(mainSql);
	if(RecordSet.next()){
		int seccategory = RecordSet.getInt("seccategory");
		int selectcategory = RecordSet.getInt("selectcategory");
		if(seccategory>0||selectcategory>0){
			RCMenu += "{"+SystemEnv.getHtmlLabelName(82202,user.getLanguage())+",javascript:reseDocShare(),_self} " ;//文档权限重构
			RCMenuHeight += RCMenuHeightStep;
		}
	}
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%
modeRightInfo.setUser(user);
modeRightInfo.setModeId(modeId);
Map allRightMap = modeRightInfo.getAllRightList();			//所有权限Map

List viewRightList = modeRightInfo.getViewRightList();		//查看权限
List addRightList = modeRightInfo.getAddRightList();		//新建权限
List editRightList = modeRightInfo.getEditRightList();		//编辑权限
List controlRightList = modeRightInfo.getControlRightList();//完全控制权限
List monitorRightList = modeRightInfo.getMonitorRightList();//监控权限
List batchRightList = modeRightInfo.getBatchRightList();//批量导入权限

int creatorpostRightId = Util.getIntValue(""+allRightMap.get("creatorpostRightId"),-1);
int creatorpost = Util.getIntValue((String)allRightMap.get("creatorpost"),99);				//创建人本人
int creatorpostlayoutid = Util.getIntValue((String)allRightMap.get("creatorpostlayoutid"),-1);	
String creatorpostlayoutname = modeRightInfo.getLayoutnameByID(creatorpostlayoutid);
int creatorpostlayoutid1 = Util.getIntValue((String)allRightMap.get("creatorpostlayoutid1"),-1);
String creatorpostlayoutname1 = modeRightInfo.getLayoutnameByID(creatorpostlayoutid1);
int creatorpostlayoutorder = Util.getIntValue((String)allRightMap.get("creatorpostlayoutorder"));
int creatorpostlayoutversion = modeLayoutCommonUtil.getLayoutVersionById(creatorpostlayoutid);
int creatorpostlayout1version = modeLayoutCommonUtil.getLayoutVersionById(creatorpostlayoutid1);

int creatorRightId = Util.getIntValue(""+allRightMap.get("creatorRightId"),-1);
String creatorConditiondesc = Util.null2String(""+allRightMap.get("creatorConditiondesc"));
int creator = Util.getIntValue((String)allRightMap.get("creator"),3);				//创建人本人
int creatorlayoutid = Util.getIntValue((String)allRightMap.get("creatorlayoutid"),-1);	
String creatorlayoutname = modeRightInfo.getLayoutnameByID(creatorlayoutid);
int creatorlayoutid1 = Util.getIntValue((String)allRightMap.get("creatorlayoutid1"),-1);
String creatorlayoutname1 = modeRightInfo.getLayoutnameByID(creatorlayoutid1);
int creatorlayoutorder = Util.getIntValue((String)allRightMap.get("creatorlayoutorder"));
String creatorvirtualtype = Util.null2String((String)allRightMap.get("creatorvirtualtype"));
int creatorlayoutversion = modeLayoutCommonUtil.getLayoutVersionById(creatorlayoutid);
int creatorlayout1version = modeLayoutCommonUtil.getLayoutVersionById(creatorlayoutid1);

int creatorleaderRightId = Util.getIntValue(""+allRightMap.get("creatorleaderRightId"),-1);
String creatorleaderConditiondesc = Util.null2String(""+allRightMap.get("creatorleaderConditiondesc"));
int creatorleader = Util.getIntValue((String)allRightMap.get("creatorleader"),99);	//创建人直接上级
int creatorleaderlayoutid = Util.getIntValue((String)allRightMap.get("creatorleaderlayoutid"),-1);	
String creatorleaderlayoutname = modeRightInfo.getLayoutnameByID(creatorleaderlayoutid);
int creatorleaderlayoutid1 = Util.getIntValue((String)allRightMap.get("creatorleaderlayoutid1"),-1);	
String creatorleaderlayoutname1 = modeRightInfo.getLayoutnameByID(creatorleaderlayoutid1);
int creatorleaderlayoutorder = Util.getIntValue((String)allRightMap.get("creatorleaderlayoutorder"));
String creatorleadervirtualtype = Util.null2String((String)allRightMap.get("creatorleadervirtualtype"));
int creatorleaderlayoutversion = modeLayoutCommonUtil.getLayoutVersionById(creatorleaderlayoutid);
int creatorleaderlayout1version = modeLayoutCommonUtil.getLayoutVersionById(creatorleaderlayoutid1);

int allcreatorleaderRightId = Util.getIntValue(""+allRightMap.get("allcreatorleaderRightId"),-1);
String allcreatorleaderConditiondesc = Util.null2String(""+allRightMap.get("allcreatorleaderConditiondesc"));
int creatorAllLeadersl = Util.getIntValue((String)allRightMap.get("creatorAllLeadersl"),10);
String creatorAllLeadersl2 = Util.null2String(allRightMap.get("creatorAllLeadersl2"));
if(creatorAllLeadersl2.equals("-1")){
	creatorAllLeadersl2 = "";
}
int allcreatorleader = Util.getIntValue((String)allRightMap.get("allcreatorleader"),99);	//创建人所有上级
int allcreatorleaderlayoutid = Util.getIntValue((String)allRightMap.get("allcreatorleaderlayoutid"),-1);	
String allcreatorleaderlayoutname = modeRightInfo.getLayoutnameByID(allcreatorleaderlayoutid);
int allcreatorleaderlayoutid1 = Util.getIntValue((String)allRightMap.get("allcreatorleaderlayoutid1"),-1);	
String allcreatorleaderlayoutname1 = modeRightInfo.getLayoutnameByID(allcreatorleaderlayoutid1);
int allcreatorleaderlayoutorder = Util.getIntValue((String)allRightMap.get("allcreatorleaderlayoutorder"));
String allcreatorleadervirtualtype = Util.null2String((String)allRightMap.get("allcreatorleadervirtualtype"));
int allcreatorleaderlayoutversion = modeLayoutCommonUtil.getLayoutVersionById(allcreatorleaderlayoutid);
int allcreatorleaderlayout1version = modeLayoutCommonUtil.getLayoutVersionById(allcreatorleaderlayoutid1);

int creatorSub = Util.getIntValue((String)allRightMap.get("creatorSub"),99);		//创建人本分部
int creatorSubRightId = Util.getIntValue(""+allRightMap.get("creatorSubRightId"),-1);
String creatorSubConditiondesc = Util.null2String(""+allRightMap.get("creatorSubConditiondesc"));
int creatorSubsl = Util.getIntValue((String)allRightMap.get("creatorSubsl"),10);
String creatorSubsl2 = Util.null2String(allRightMap.get("creatorSubsl2"));
if(creatorSubsl2.equals("-1")){
	creatorSubsl2 = "";
}
int creatorSublayoutid = Util.getIntValue((String)allRightMap.get("creatorSublayoutid"),-1);	
String creatorSublayoutname = modeRightInfo.getLayoutnameByID(creatorSublayoutid);
int creatorSublayoutid1 = Util.getIntValue((String)allRightMap.get("creatorSublayoutid1"),-1);	
String creatorSublayoutname1 = modeRightInfo.getLayoutnameByID(creatorSublayoutid1);
int creatorSublayoutorder = Util.getIntValue((String)allRightMap.get("creatorSublayoutorder"));
String creatorSubvirtualtype = Util.null2String((String)allRightMap.get("creatorSubvirtualtype"));
int creatorSublayoutversion = modeLayoutCommonUtil.getLayoutVersionById(creatorSublayoutid);
int creatorSublayout1version = modeLayoutCommonUtil.getLayoutVersionById(creatorSublayoutid1);

int creatorDept = Util.getIntValue((String)allRightMap.get("creatorDept"),99);		//创建人本部门
int creatorDeptRightId = Util.getIntValue(""+allRightMap.get("creatorDeptRightId"),-1);
String creatorDeptConditiondesc = Util.null2String(""+allRightMap.get("creatorDeptConditiondesc"));
int creatorDeptsl = Util.getIntValue((String)allRightMap.get("creatorDeptsl"),10);
String creatorDeptsl2 = Util.null2String(allRightMap.get("creatorDeptsl2"));
if(creatorDeptsl2.equals("-1")){
	creatorDeptsl2 = "";
}
int creatorDeptlayoutid = Util.getIntValue((String)allRightMap.get("creatorDeptlayoutid"),-1);
String creatorDeptlayoutname = modeRightInfo.getLayoutnameByID(creatorDeptlayoutid);		
int creatorDeptlayoutid1 = Util.getIntValue((String)allRightMap.get("creatorDeptlayoutid1"),-1);
String creatorDeptlayoutname1 = modeRightInfo.getLayoutnameByID(creatorDeptlayoutid1);	
int creatorDeptlayoutorder = Util.getIntValue((String)allRightMap.get("creatorDeptlayoutorder"),0);
String creatorDeptvirtualtype = Util.null2String((String)allRightMap.get("creatorDeptvirtualtype"));
int creatorDeptlayoutversion = modeLayoutCommonUtil.getLayoutVersionById(creatorDeptlayoutid);
int creatorDeptlayout1version = modeLayoutCommonUtil.getLayoutVersionById(creatorDeptlayoutid1);
String isdisplay = isVirtualForm?"none":"";
%>

<FORM id=weaver name=weaver action="ModeRightOperation.jsp" method=post>
<input type=hidden name="method" value="saveForCreator">
<input type=hidden name=modeId id=modeId value=<%=modeId %>>
<input type=hidden name=formId id=formId value=<%=formId %>>
<input type=hidden name=mainids id=mainids>
<input type=hidden name="resetRightId" id="resetRightId">
<input type=hidden name=isVirtualForm value="<%=isVirtualForm%>">
<input type=hidden name="rebulidFlag" id="rebulidFlag">
<div id="rebulidProcessDiv" style="margin-top:4px;display:none;">
	<iframe name="rebulidProcessFrame" id="rebulidProcessFrame" frameborder="0" scrolling="no" width="100%" height="20"></iframe>
</div>
<table class="e8_tblForm">
<tr><td colspan="2" style="height:8px;"></td></tr>
<tr>
	<td style="font-weight: bold;"><%=SystemEnv.getHtmlLabelName(21945,user.getLanguage())%></td><!-- 创建权限 -->
	<td align=right>
		<%if(operatelevel>1){%>
			<input type="checkbox" name="chkPermissionAll0" onclick="chkAllClick(this,0)">(<%=SystemEnv.getHtmlLabelName(2241,user.getLanguage())%>)<!-- 全部选中 -->
		<%}%>
		<%if(operatelevel>0){%>
			<a class=href href="ModeShareAdd.jsp?trighttype=1&modeId=<%=modeId%>&formId=<%=formId%>&isVirtualForm=<%=isVirtualForm%>"><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></a><!-- 添加 -->
		<%}%>
		<%if(operatelevel>1){%>
			<a class=href href="#" onclick="javaScript:doDelShare(0);"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a><!-- 删除 -->
		<%}%>
	</td>
</TR>
<tr><td colspan="2" style="border-bottom:1px solid #e6e6e6;"></td></tr>

<%
Map datamap = null;
for(int i=0 ;i < addRightList.size();i++){
 datamap = (Map)addRightList.get(i);
 String rightid = (String)datamap.get("rightId");
 String sharetypetext = (String)datamap.get("sharetypetext");
 String detailText = (String)datamap.get("detailText");
%>
<tr>
  <td class="e8_tblForm_label" width="20%"><input type="checkbox" name="rightid0" id="rightid0" value="<%=rightid %>"></td>
  <td class="e8_tblForm_field"><%=sharetypetext %> <%=detailText%></td>
</tr>
<%}%>

<tr><td colspan="2" style="height:8px;"></td></tr>
<tr style="display:<%=isdisplay%>">
	<td colspan="2" style="font-weight: bold;">
	<%=SystemEnv.getHtmlLabelName(15059,user.getLanguage())%><!-- 默认共享 -->
	(<%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(522,user.getLanguage())%>)<!-- 创建人相关 -->
	</td>
</TR>
<tr style="display:<%=isdisplay%>"><td colspan="2" style="border-bottom:1px solid #e6e6e6;height:1px;"></td></tr>
<tr style="display:<%=isdisplay%>">
	<td class="e8_tblForm_label" width="20%"><%=SystemEnv.getHtmlLabelName(15079,user.getLanguage())%></td><!-- 创建人本人 -->
    <td class="e8_tblForm_field"> 
		<div style="float:left;width:95px;">
		<select name="creator" onchange="onSelectChange1(this,creatorlayoutidDiv,creatorlayoutid1Div,creatorlayoutorderdiv);">
           <option value="99" <%if(creator==99){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2011,user.getLanguage())%></option><!-- 没有权限 -->
           <option value="1" <%if(creator==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%></option><!-- 查看 -->
           <option value="2" <%if(creator==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%></option> <!-- 编辑 -->
           <option value="3" <%if(creator==3){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(17874,user.getLanguage())%></option> <!-- 完全控制 -->
        </select>
         </div>
        <div id="creatorlayoutidDiv"  <%if(creator==99) {out.println(" style=\"display:none;float:left;margin-left:10px;\"" );}else{out.println(" style=\"float:left;margin-left:10px;\"" );}%> >    
       		 <%=SystemEnv.getHtmlLabelName(82203,user.getLanguage())%><!-- 查看布局 -->
       		 <button type="button" class="copybtn2" onclick="onShowModeBrowser('creatorlayoutid','creatorlayoutidspan','0','1')" title="<%=SystemEnv.getHtmlLabelName(23039,user.getLanguage())%>"></button><!-- 选择模板 -->
			<span id="creatorlayoutidspan">
			<%if(creatorlayoutid!=-1){%>
				<a href="#" 
				<%if(creatorlayoutversion==2){ %>
					onclick="onshowExcelDesign('0','<%=creatorlayoutid %>')"
				<%}else{ %>
					onclick="openFullWindowHaveBar('/formmode/setup/LayoutEdit.jsp?type=0&modeId=<%=modeId%>&formId=<%=formId%>&Id=<%=creatorlayoutid%>')"
				<%} %>
				><%=creatorlayoutname%></a>
			<%}%>
			</span>
			<input type="hidden" id="creatorlayoutid" name="creatorlayoutid" value="<%=creatorlayoutid%>">
		</div>
		<div id="creatorlayoutid1Div"  <%if(creator==99||creator==1) {out.println(" style=\"display:none;float:left;margin-left:10px;\"" );}else{out.println(" style=\"float:left;margin-left:10px;\"" );}%> >    
			<%=SystemEnv.getHtmlLabelName(82136,user.getLanguage())%><!-- 编辑布局 -->
       		 <button type="button" class="copybtn2" onclick="onShowModeBrowser('creatorlayoutid1','creatorlayoutid1span','1','1')" title="<%=SystemEnv.getHtmlLabelName(23039,user.getLanguage())%>"></button><!-- 选择模板 -->
			<span id="creatorlayoutid1span">
			<%if(creatorlayoutid1!=-1){%>
				<a href="#" 
				<%if(creatorlayout1version==2){ %>
					onclick="onshowExcelDesign('2','<%=creatorlayoutid1 %>')"
				<%}else{ %>
					onclick="openFullWindowHaveBar('/formmode/setup/LayoutEdit.jsp?type=2&modeId=<%=modeId%>&formId=<%=formId%>&Id=<%=creatorlayoutid1%>')"
				<%} %>
				><%=creatorlayoutname1%></a>
			<%}%>
			</span>
			<input type="hidden" id="creatorlayoutid1" name="creatorlayoutid1" value="<%=creatorlayoutid1%>">
		</div>
		<div id="creatorlayoutorderdiv"  <%if(creator==99) {out.println(" style=\"display:none;float:left;margin-left:15px;\"" );}else{out.println(" style=\"float:left;margin-left:15px;\"" );}%> >  
			<%=SystemEnv.getHtmlLabelName(82204,user.getLanguage())%><!-- 布局级别 -->
			<input value="<%=creatorlayoutorder%>"  class="inputStyle" type="text" size="4" name="creatorlayoutorder" onchange="checkphone('creatorlayoutorder')">
		</div> 
		<div style="float:left;margin-left:10px;">
		<INPUT class="inputstyle" type="checkbox" id="resetModeShareBycreteor" name="resetModeShareBycreteor" value="1" /><%=SystemEnv.getHtmlLabelName(31570,user.getLanguage())%>
		</div>
    </td>
</tr>
<!-- 创建人直接上级 -->
<tr style="display:<%=isdisplay%>">
	<td class="e8_tblForm_label" width="20%"><%=SystemEnv.getHtmlLabelName(18583,user.getLanguage())%></td>
	<td class="e8_tblForm_field"> 
		<div style="float:left;width:95px;">
		<select name="creatorleader" onchange="onSelectChange1(this,creatorleaderlayoutidDiv,creatorleaderlayoutid1Div,creatorleaderlayoutorderdiv,creatorleaderConditionDiv,creatorleadervirtualtypeDiv,<%=creatorleader %>);">
			<option value="99" <%if(creatorleader==99){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2011,user.getLanguage())%></option>
			<option value="1" <%if(creatorleader==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%></option>
			<option value="2" <%if(creatorleader==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%></option> 
			<option value="3" <%if(creatorleader==3){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(17874,user.getLanguage())%></option> 
		</select>
		</div>
		<table>
		<tr><td>
		<div id="creatorleadervirtualtypeDiv"
		<%if(creatorleader==99) {out.println(" style=\"display:none;float:left;margin-left:10px;\"" );}else{out.println(" style=\"float:left;margin-left:10px;\"" );}%>
		>
		<input name="creatorleadervirtualtype_value" type="hidden" id="creatorleadervirtualtype_value" value="<%=creatorleadervirtualtype%>">
		<select name="creatorleadervirtualtype" notBeauty=true multiple="multiple" id="creatorleadervirtualtype">
			<option value="0"><%=SystemEnv.getHtmlLabelName(83179, user.getLanguage()) %></option>
			<%
   				RecordSet.executeSql("select * from HrmCompanyVirtual  where (canceled is null or canceled<>1) order by showorder");
   				while(RecordSet.next()){
   					String id = Util.null2String(RecordSet.getString("id"));
   					String companyname = Util.null2String(RecordSet.getString("companyname"));
   			 %>
   			 <option value="<%=id%>"><%=companyname %></option>
   			 <%} %>
		</select>
		</div>
		</td></tr>
		<tr>
		<td style="text-align: left;">
		<div id="creatorleaderlayoutidDiv" <%if(creatorleader==99) {out.println(" style=\"display:none;float:left;margin-left:10px;\"" );}else{out.println(" style=\"float:left;margin-left:10px;\"" );}%> >    
       		<%=SystemEnv.getHtmlLabelName(82203,user.getLanguage())%><!-- 查看布局 -->
       		 <button type="button" class="copybtn2" onclick="onShowModeBrowser('creatorleaderlayoutid','creatorleaderlayoutidspan','0','2')" title="<%=SystemEnv.getHtmlLabelName(23039,user.getLanguage())%>"></button><!-- 选择模板 -->
			<span id="creatorleaderlayoutidspan">
			<%if(creatorleaderlayoutid!=-1){%>
				<a href="#" 
				<%if(creatorleaderlayoutversion==2){ %>
					onclick="onshowExcelDesign('0','<%=creatorleaderlayoutid %>')"
				<%}else{ %>
					onclick="openFullWindowHaveBar('/formmode/setup/LayoutEdit.jsp?type=0&modeId=<%=modeId%>&formId=<%=formId%>&Id=<%=creatorleaderlayoutid%>')"
				<%} %>
				><%=creatorleaderlayoutname%></a>
			<%}%>
			</span>
			<input type="hidden" id="creatorleaderlayoutid" name="creatorleaderlayoutid" value="<%=creatorleaderlayoutid%>">
		</div>
		<div id="creatorleaderlayoutid1Div" <%if(creatorleader==99||creatorleader==1) {out.println(" style=\"display:none;float:left;margin-left:10px;\"" );}else{out.println(" style=\"float:left;margin-left:10px;\"" );}%> >    
			<%=SystemEnv.getHtmlLabelName(82136,user.getLanguage())%><!-- 编辑布局 -->
       		 <button type="button" class="copybtn2" onclick="onShowModeBrowser('creatorleaderlayoutid1','creatorleaderlayoutid1span','1','2')" title="<%=SystemEnv.getHtmlLabelName(23039,user.getLanguage())%>"></button><!-- 选择模板 -->
			<span id="creatorleaderlayoutid1span">
			<%if(creatorleaderlayoutid1!=-1){%>
				<a href="#" 
				<%if(creatorleaderlayout1version==2){ %>
					onclick="onshowExcelDesign('2','<%=creatorleaderlayoutid1 %>')"
				<%}else{ %>
					onclick="openFullWindowHaveBar('/formmode/setup/LayoutEdit.jsp?type=2&modeId=<%=modeId%>&formId=<%=formId%>&Id=<%=creatorleaderlayoutid1%>')"
				<%} %>
				><%=creatorleaderlayoutname1%></a>
			<%}%>
			</span>
			<input type="hidden" id="creatorleaderlayoutid1" name="creatorleaderlayoutid1" value="<%=creatorleaderlayoutid1%>">
		</div>
		<div id="creatorleaderlayoutorderdiv"  <%if(creatorleader==99) {out.println(" style=\"display:none;float:left;margin-left:15px;\"" );}else{out.println(" style=\"float:left;margin-left:15px;\"" );}%> >  
			<%=SystemEnv.getHtmlLabelName(82204,user.getLanguage())%><!-- 布局级别 -->
			<input value="<%=creatorleaderlayoutorder%>"  class="inputStyle" type="text" size="4" name="creatorleaderlayoutorder" onchange="checkphone('creatorleaderlayoutorder')">
		</div> 
		<div id="creatorleaderConditionDiv"  <%if(creatorleader==99) {out.println(" style=\"display:none;float:left;margin-left:15px;\"" );}else{out.println(" style=\"float:left;margin-left:15px;\"" );}%> >
				<span class="conditionContentSpan">
				<%=SystemEnv.getHtmlLabelName(15364,user.getLanguage())%><!-- 条件 -->
				<input style="display:none;" class="conditionInput" name="creatorleaderConditionText" id="creatorleaderConditionText" value="<%=creatorleaderConditiondesc %>" readonly="readonly">
				<button class="addbtn2" title="<%=SystemEnv.getHtmlLabelName(15364,user.getLanguage())%>"  style="color:#018efb;"  onclick="addCondition('<%=creatorleaderRightId %>','creatorleaderCondition','creatorleaderConditionText')" type="button"></button>
				<input type="hidden" name="creatorleaderCondition" id="creatorleaderCondition">
				<%if(!StringHelper.isEmpty(creatorleaderConditiondesc)){%>
					<a href='javascript:void(0);'  style="color:#018efb;"  onclick="addCondition('<%=creatorleaderRightId %>','creatorleaderCondition','creatorleaderConditionText')">
					<%=SystemEnv.getHtmlLabelName(15809,user.getLanguage())%><!-- 已设置条件 -->
					</a>
				<%} %>
				</span>
				</span>
		</div>
		<div style="float:left;margin-left:10px;">
		<INPUT class="inputstyle" type="checkbox" id="resetModeShareByManager" name="resetModeShareByManager" value="1" /><%=SystemEnv.getHtmlLabelName(31570,user.getLanguage())%>
		</div>
		</td></tr>
		</table>
	</td>
</tr>
<!-- 创建人所有上级 -->
<tr style="display:<%=isdisplay%>">
	<td class="e8_tblForm_label" width="20%"><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())+SystemEnv.getHtmlLabelName(15762,user.getLanguage())%></td>
	<td class="e8_tblForm_field"> 
		<div style="float:left;width:95px;">
		<select name="allcreatorleader" onchange="onSelectChange(this,allcreatorleaderLDiv,allcreatorleaderlayoutidDiv,allcreatorleaderlayoutid1Div,allcreatorleaderlayoutorderdiv,allcreatorleaderConditionDiv,allcreatorleadervirtualtypeDiv,<%=allcreatorleader %>);">
			<option value="99" <%if(allcreatorleader==99){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2011,user.getLanguage())%></option>
			<option value="1" <%if(allcreatorleader==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%></option>
			<option value="2" <%if(allcreatorleader==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%></option> 
			<option value="3" <%if(allcreatorleader==3){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(17874,user.getLanguage())%></option> 
		</select>
		</div>
		<table>
			<tr>
				<td>
		<div id="allcreatorleadervirtualtypeDiv"
		<%if(allcreatorleader==99) {out.println(" style=\"display:none;float:left;margin-left:10px;\"" );}else{out.println(" style=\"float:left;margin-left:10px;\"" );}%>
		>
		<input name="allcreatorleadervirtualtype_value" type="hidden" id="allcreatorleadervirtualtype_value" value="<%=allcreatorleadervirtualtype%>">
		<select name="allcreatorleadervirtualtype" notBeauty=true multiple="multiple" id="allcreatorleadervirtualtype">
			<option value="0"><%=SystemEnv.getHtmlLabelName(83179, user.getLanguage()) %></option>
			<%
   				RecordSet.executeSql("select * from HrmCompanyVirtual  where (canceled is null or canceled<>1) order by showorder");
   				while(RecordSet.next()){
   					String id = Util.null2String(RecordSet.getString("id"));
   					String companyname = Util.null2String(RecordSet.getString("companyname"));
   			 %>
   			 <option value="<%=id%>"><%=companyname %></option>
   			 <%} %>
		</select>
		</div>
		</td>
		</tr>
		<tr><td style="text-align: left;">
		<div style="float:left;">
    		<span id="allcreatorleaderLDiv" <%if(allcreatorleader==99) {out.println(" style=\"display:none\"" );}%> align="left">&nbsp;
	         	<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%> 
	         	<input value="<%=creatorAllLeadersl %>" onblur="checkLevel('creatorAllLeadersl','creatorAllLeadersl2',this)"  class="inputStyle" type="text" size="4" name="creatorAllLeadersl">
	         	-
	         	<input value="<%=creatorAllLeadersl2 %>" onblur="checkLevel('creatorAllLeadersl','creatorAllLeadersl2',this)" class="inputStyle" type="text" size="4" name="creatorAllLeadersl2">
     		</span>
     	</div>
		<div id="allcreatorleaderlayoutidDiv" <%if(allcreatorleader==99) {out.println(" style=\"display:none;float:left;margin-left:10px;\"" );}else{out.println(" style=\"float:left;margin-left:10px;\"" );}%> >    
       		<%=SystemEnv.getHtmlLabelName(82203,user.getLanguage())%><!-- 查看布局 -->
       		 <button type="button" class="copybtn2" onclick="onShowModeBrowser('allcreatorleaderlayoutid','allcreatorleaderlayoutidspan','0','4')" title="<%=SystemEnv.getHtmlLabelName(23039,user.getLanguage())%>"></button><!-- 选择模板 -->
			<span id="allcreatorleaderlayoutidspan">
			<%if(allcreatorleaderlayoutid!=-1){%>
				<a href="#" 
				<%if(allcreatorleaderlayoutversion==2){ %>
					onclick="onshowExcelDesign('0','<%=allcreatorleaderlayoutid %>')"
				<%}else{ %>
					onclick="openFullWindowHaveBar('/formmode/setup/LayoutEdit.jsp?type=0&modeId=<%=modeId%>&formId=<%=formId%>&Id=<%=allcreatorleaderlayoutid%>')"
				<%} %>
				><%=allcreatorleaderlayoutname%></a>
			<%}%>
			</span>
			<input type="hidden" id="allcreatorleaderlayoutid" name="allcreatorleaderlayoutid" value="<%=allcreatorleaderlayoutid%>">
		</div>
		<div id="allcreatorleaderlayoutid1Div" <%if(allcreatorleader==99||allcreatorleader==1) {out.println(" style=\"display:none;float:left;margin-left:10px;\"" );}else{out.println(" style=\"float:left;margin-left:10px;\"" );}%> >    
			<%=SystemEnv.getHtmlLabelName(82136,user.getLanguage())%><!-- 编辑布局 -->
       		 <button type="button" class="copybtn2" onclick="onShowModeBrowser('allcreatorleaderlayoutid1','allcreatorleaderlayoutid1span','1','4')" title="<%=SystemEnv.getHtmlLabelName(23039,user.getLanguage())%>"></button><!-- 选择模板 -->
			<span id="allcreatorleaderlayoutid1span">
			<%if(allcreatorleaderlayoutid1!=-1){%>
				<a href="#" 
				<%if(allcreatorleaderlayout1version==2){ %>
					onclick="onshowExcelDesign('2','<%=allcreatorleaderlayoutid1 %>')"
				<%}else{ %>
					onclick="openFullWindowHaveBar('/formmode/setup/LayoutEdit.jsp?type=2&modeId=<%=modeId%>&formId=<%=formId%>&Id=<%=allcreatorleaderlayoutid1%>')"
				<%} %>
				><%=allcreatorleaderlayoutname1%></a>
			<%}%>
			</span>
			<input type="hidden" id="allcreatorleaderlayoutid1" name="allcreatorleaderlayoutid1" value="<%=allcreatorleaderlayoutid1%>">
		</div>
		<div id="allcreatorleaderlayoutorderdiv"  <%if(allcreatorleader==99) {out.println(" style=\"display:none;float:left;margin-left:15px;\"" );}else{out.println(" style=\"float:left;margin-left:15px;\"" );}%> >  
			<%=SystemEnv.getHtmlLabelName(82204,user.getLanguage())%><!-- 布局级别 -->
			<input value="<%=allcreatorleaderlayoutorder%>"  class="inputStyle" type="text" size="4" name="allcreatorleaderlayoutorder" onchange="checkphone('allcreatorleaderlayoutorder')">
		</div> 
		<div id="allcreatorleaderConditionDiv"  <%if(allcreatorleader==99) {out.println(" style=\"display:none;float:left;margin-left:15px;\"" );}else{out.println(" style=\"float:left;margin-left:15px;\"" );}%> >
				<span class="conditionContentSpan">
				<%=SystemEnv.getHtmlLabelName(15364,user.getLanguage())%><!-- 条件 -->
				<input style="display:none;" class="conditionInput" name="allcreatorleaderConditionText" id="allcreatorleaderConditionText" value="<%=allcreatorleaderConditiondesc %>" readonly="readonly">
				<button class="addbtn2" title="<%=SystemEnv.getHtmlLabelName(15364,user.getLanguage())%>"  style="color:#018efb;"  onclick="addCondition('<%=allcreatorleaderRightId %>','allcreatorleaderCondition','allcreatorleaderConditionText')" type="button"></button>
				<input type="hidden" name="allcreatorleaderCondition" id="allcreatorleaderCondition">
				<%if(!StringHelper.isEmpty(allcreatorleaderConditiondesc)){%>
					<a href='javascript:void(0);'  style="color:#018efb;"  onclick="addCondition('<%=allcreatorleaderRightId %>','allcreatorleaderCondition','allcreatorleaderConditionText')" >
					<%=SystemEnv.getHtmlLabelName(15809,user.getLanguage())%><!-- 已设置条件 -->
					</a>
				<%} %>
				</span>
		</div>
		 <div style="float:left;margin-left:10px;">
		<INPUT class="inputstyle" type="checkbox" id="resetModeShareByAllManager" name="resetModeShareByAllManager" value="1" /><%=SystemEnv.getHtmlLabelName(31570,user.getLanguage())%>
		</div>
			</td>
		</tr>
		</table>
	</td>
</tr>
<!-- 创建人本分部 -->
<tr style="display:<%=isdisplay%>">
    <td class="e8_tblForm_label" width="20%"><%=SystemEnv.getHtmlLabelName(15577,user.getLanguage())%></td>
    <td class="e8_tblForm_field">
    	<div style="float:left;width:95px;">
    	<select name="creatorSub"  onchange="onSelectChange(this,createrSubLDiv,creatorSublayoutidDiv,creatorSublayoutid1Div,creatorSublayoutorderdiv,creatorSubConditionDiv,creatorSubvirtualtypeDiv,<%=creatorSub %>);">
           <option value="99" <%if(creatorSub==99){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2011,user.getLanguage())%></option><!-- 没有权限 -->
           <option value="1" <%if(creatorSub==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%></option><!-- 查看 -->
           <option value="2" <%if(creatorSub==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%></option> <!-- 编辑 -->
           <option value="3" <%if(creatorSub==3){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(17874,user.getLanguage())%></option><!-- 完全控制 -->
        </select>
         </div>
         <table><tr><td>
         <div id="creatorSubvirtualtypeDiv"
		<%if(creatorSub==99) {out.println(" style=\"display:none;float:left;margin-left:10px;\"" );}else{out.println(" style=\"float:left;margin-left:10px;\"" );}%>
		>
		<input name="creatorSubvirtualtype_value" id="creatorSubvirtualtype_value" type="hidden" value="<%=creatorSubvirtualtype%>">
		<select name="creatorSubvirtualtype" notBeauty=true multiple="multiple" id="creatorSubvirtualtype">
			<option value="0"><%=SystemEnv.getHtmlLabelName(83179, user.getLanguage()) %></option>
			<%
   				RecordSet.executeSql("select * from HrmCompanyVirtual  where (canceled is null or canceled<>1) order by showorder");
   				while(RecordSet.next()){
   					String id = Util.null2String(RecordSet.getString("id"));
   					String companyname = Util.null2String(RecordSet.getString("companyname"));
   			 %>
   			 <option value="<%=id%>"><%=companyname %></option>
   			 <%} %>
		</select>
		</div>
		</td></tr><tr><td style="text-align: left;"  >
         <div style="float:left;">
    	<span id="createrSubLDiv" <%if(creatorSub==99) {out.println(" style=\"display:none\"" );}%> align="left">&nbsp;                            
			<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%> 
			<input value="<%=creatorSubsl%>" onblur="checkLevel('creatorSubsl','creatorSubsl2',this)" class="inputStyle" type="text" size="4" name="creatorSubsl">
			-
			<input value="<%=creatorSubsl2 %>" onblur="checkLevel('creatorSubsl','creatorSubsl2',this)"  class="inputStyle" type="text" size="4" name="creatorSubsl2">
		</span>
		</div>
        <div id="creatorSublayoutidDiv" <%if(creatorSub==99) {out.println(" style=\"display:none;float:left;margin-left:10px;\"" );}else{out.println(" style=\"float:left;margin-left:10px;\"" );}%> >    
       		 <%=SystemEnv.getHtmlLabelName(82203,user.getLanguage())%><!-- 查看布局 -->
       		 <button type="button" class="copybtn2" onclick="onShowModeBrowser('creatorSublayoutid','creatorSublayoutidspan','0','3')" title="<%=SystemEnv.getHtmlLabelName(23039,user.getLanguage())%>"></button><!-- 选择模板 -->
			<span id="creatorSublayoutidspan">
			<%if(creatorSublayoutid!=-1){%>
			<a href="#" 
				<%if(creatorSublayoutversion==2){ %>
					onclick="onshowExcelDesign('0','<%=creatorSublayoutid %>')"
				<%}else{ %>
					onclick="openFullWindowHaveBar('/formmode/setup/LayoutEdit.jsp?type=0&modeId=<%=modeId%>&formId=<%=formId%>&Id=<%=creatorSublayoutid%>')"
				<%} %>
				><%=creatorSublayoutname %></a>
			<%}%>
			</span>
			<input type="hidden" id="creatorSublayoutid" name="creatorSublayoutid" value="<%=creatorSublayoutid%>">
		</div>
		<div id="creatorSublayoutid1Div" <%if(creatorSub==99||creatorSub==1) {out.println(" style=\"display:none;float:left;margin-left:10px;\"" );}else{out.println(" style=\"float:left;margin-left:10px;\"" );}%> >    
			 <%=SystemEnv.getHtmlLabelName(82136,user.getLanguage())%><!-- 编辑布局 -->
       		 <button type="button" class="copybtn2" onclick="onShowModeBrowser('creatorSublayoutid1','creatorSublayoutid1span','1','3')" title="<%=SystemEnv.getHtmlLabelName(23039,user.getLanguage())%>"></button><!-- 选择模板 -->
			<span id="creatorSublayoutid1span">
			<%if(creatorSublayoutid1!=-1){%>
			<a href="#" 
				<%if(creatorSublayout1version==2){ %>
					onclick="onshowExcelDesign('2','<%=creatorSublayoutid1 %>')"
				<%}else{ %>
					onclick="openFullWindowHaveBar('/formmode/setup/LayoutEdit.jsp?type=2&modeId=<%=modeId%>&formId=<%=formId%>&Id=<%=creatorSublayoutid1%>')"
				<%} %>
				><%=creatorSublayoutname1 %></a>
			<%}%>
			</span>
			<input type="hidden" id="creatorSublayoutid1" name="creatorSublayoutid1" value="<%=creatorSublayoutid1%>">
		</div>
		<div id="creatorSublayoutorderdiv"  <%if(creatorSub==99) {out.println(" style=\"display:none;float:left;margin-left:15px;\"" );}else{out.println(" style=\"float:left;margin-left:15px;\"" );}%> >  
			<%=SystemEnv.getHtmlLabelName(82204,user.getLanguage())%><!-- 布局级别 -->
			<input value="<%=creatorSublayoutorder%>"  class="inputStyle" type="text" size="4" name="creatorSublayoutorder" onchange="checkphone('creatorSublayoutorder')">
		</div> 
		
		<div id="creatorSubConditionDiv"  <%if(creatorSub==99) {out.println(" style=\"display:none;float:left;margin-left:15px;\"" );}else{out.println(" style=\"float:left;margin-left:15px;\"" );}%> >
				<span class="conditionContentSpan">
				<%=SystemEnv.getHtmlLabelName(15364,user.getLanguage())%><!-- 条件 -->
				<input style="display:none;" class="conditionInput" name="creatorSubConditionText" id="creatorSubConditionText" value="<%=creatorSubConditiondesc %>" readonly="readonly">
				<button class="addbtn2" title="<%=SystemEnv.getHtmlLabelName(15364,user.getLanguage())%>"  style="color:#018efb;"  onclick="addCondition('<%=creatorSubRightId %>','creatorSubCondition','creatorSubConditionText')" type="button"></button>
				<input type="hidden" name="creatorSubCondition" id="creatorSubCondition">
				<%if(!StringHelper.isEmpty(creatorSubConditiondesc)){%>
					<a href='javascript:void(0);'  style="color:#018efb;"  onclick="addCondition('<%=creatorSubRightId %>','creatorSubCondition','creatorSubConditionText')">
					<%=SystemEnv.getHtmlLabelName(15809,user.getLanguage())%><!-- 已设置条件 -->
					</a>
				<%} %>
				</span>
		</div>
		<div style="float:left;margin-left:10px;">
		<INPUT class="inputstyle" type="checkbox" id="resetModeShareBySubDept" name="resetModeShareBySubDept" value="1" /><%=SystemEnv.getHtmlLabelName(31570,user.getLanguage())%>
		</div>
		</td></tr></table>
    </td>
</tr>
<!-- 创建人本部门 -->
<tr style="display:<%=isdisplay%>">
    <td class="e8_tblForm_label" width="20%"><%=SystemEnv.getHtmlLabelName(15081,user.getLanguage())%></td>
    <td class="e8_tblForm_field">
    	<div style="float:left;width:95px;">
    	<select name="creatorDept" onchange="onSelectChange(this,createrDepartLDiv,creatorDeptlayoutidDiv,creatorDeptlayoutid1Div,creatorDeptlayoutorderdiv,creatorDeptConditionDiv,creatorDeptvirtualtypeDiv,<%=creatorDept %>);">
           <option value="99" <%if(creatorDept==99){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2011,user.getLanguage())%></option><!-- 没有权限 -->
           <option value="1" <%if(creatorDept==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%></option><!-- 查看 -->
           <option value="2" <%if(creatorDept==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%></option> <!-- 编辑 -->
           <option value="3" <%if(creatorDept==3){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(17874,user.getLanguage())%></option><!-- 完全控制 -->
        </select>
        </div>
        <table><tr><td>
        <div id="creatorDeptvirtualtypeDiv"
		<%if(creatorDept==99) {out.println(" style=\"display:none;float:left;margin-left:10px;\"" );}else{out.println(" style=\"float:left;margin-left:10px;\"" );}%>
		>
		<input name="creatorDeptvirtualtype_value" id="creatorDeptvirtualtype_value" type="hidden" value="<%=creatorDeptvirtualtype%>">
		<select name="creatorDeptvirtualtype" notBeauty=true multiple="multiple" id="creatorDeptvirtualtype">
			<option value="0"><%=SystemEnv.getHtmlLabelName(83179, user.getLanguage()) %></option>
			<%
   				RecordSet.executeSql("select * from HrmCompanyVirtual  where (canceled is null or canceled<>1) order by showorder");
   				while(RecordSet.next()){
   					String id = Util.null2String(RecordSet.getString("id"));
   					String companyname = Util.null2String(RecordSet.getString("companyname"));
   			 %>
   			 <option value="<%=id%>"><%=companyname %></option>
   			 <%} %>
		</select>
		</div>
		</td></tr><tr><td style="text-align: left;" >
        <div style="float:left;">
    		<span id="createrDepartLDiv" <%if(creatorDept==99) {out.println(" style=\"display:none\"" );}%> align="left">&nbsp;
         	<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%> 
         	<input value="<%=creatorDeptsl%>" onblur="checkLevel('creatorDeptsl','creatorDeptsl2',this)" class="inputStyle" type="text" size="4" name="creatorDeptsl">
         	-
         	<input value="<%=creatorDeptsl2 %>" onblur="checkLevel('creatorDeptsl','creatorDeptsl2',this)" class="inputStyle" type="text" size="4" name="creatorDeptsl2">
     	</span>
    	</div>
        <div id="creatorDeptlayoutidDiv" <%if(creatorDept==99) {out.println(" style=\"display:none;float:left;margin-left:10px;\"" );}else{out.println(" style=\"float:left;margin-left:10px;\"" );}%> >    
       		 <%=SystemEnv.getHtmlLabelName(82203,user.getLanguage())%><!-- 查看布局 -->
       		 <button type="button" class="copybtn2" onclick="onShowModeBrowser('creatorDeptlayoutid','creatorDeptlayoutidspan','0','4')" title="<%=SystemEnv.getHtmlLabelName(23039,user.getLanguage())%>"></button><!-- 选择模板 -->
			<span id="creatorDeptlayoutidspan">
			<%if(creatorDeptlayoutid!=-1){%>
			<a href="#" 
				<%if(creatorDeptlayoutversion==2){ %>
					onclick="onshowExcelDesign('0','<%=creatorDeptlayoutid %>')"
				<%}else{ %>
					onclick="openFullWindowHaveBar('/formmode/setup/LayoutEdit.jsp?type=0&modeId=<%=modeId%>&formId=<%=formId%>&Id=<%=creatorDeptlayoutid%>')"
				<%} %>
				><%=creatorDeptlayoutname %></a>
			<%}%>
			</span>
			<input type="hidden" id="creatorDeptlayoutid" name="creatorDeptlayoutid" value="<%=creatorDeptlayoutid%>">
		</div>
		<div id="creatorDeptlayoutid1Div" <%if(creatorDept==99||creatorDept==1) {out.println(" style=\"display:none;float:left;margin-left:10px;\"" );}else{out.println(" style=\"float:left;margin-left:10px;\"" );}%> >    
			 <%=SystemEnv.getHtmlLabelName(82136,user.getLanguage())%><!-- 编辑布局 -->
       		 <button type="button" class="copybtn2" onclick="onShowModeBrowser('creatorDeptlayoutid1','creatorDeptlayoutid1span','1','4')" title="<%=SystemEnv.getHtmlLabelName(23039,user.getLanguage())%>"></button><!-- 选择模板 -->
			<span id="creatorDeptlayoutid1span">
			<%if(creatorDeptlayoutid1!=-1){%>
			<a href="#" 
				<%if(creatorDeptlayout1version==2){ %>
					onclick="onshowExcelDesign('2','<%=creatorDeptlayoutid1 %>')"
				<%}else{ %>
					onclick="openFullWindowHaveBar('/formmode/setup/LayoutEdit.jsp?type=2&modeId=<%=modeId%>&formId=<%=formId%>&Id=<%=creatorDeptlayoutid1%>')"
				<%} %>
				><%=creatorDeptlayoutname1 %></a>
			<%}%>
			</span>
			<input type="hidden" id="creatorDeptlayoutid1" name="creatorDeptlayoutid1" value="<%=creatorDeptlayoutid1%>">
		</div>
		<div id="creatorDeptlayoutorderdiv"  <%if(creatorDept==99) {out.println(" style=\"display:none;float:left;margin-left:15px;\"" );}else{out.println(" style=\"float:left;margin-left:15px;\"" );}%> >  
			<%=SystemEnv.getHtmlLabelName(82204,user.getLanguage())%><!-- 布局级别 -->
			<input value="<%=creatorDeptlayoutorder%>"  class="inputStyle" type="text" size="4" name="creatorDeptlayoutorder" onchange="checkphone('creatorDeptlayoutorder')">
		</div> 
		
		<div id="creatorDeptConditionDiv"  <%if(creatorDept==99) {out.println(" style=\"display:none;float:left;margin-left:15px;\"" );}else{out.println(" style=\"float:left;margin-left:15px;\"" );}%> >
				<span class="conditionContentSpan">
				<%=SystemEnv.getHtmlLabelName(15364,user.getLanguage())%><!-- 条件 -->
				<input style="display:none;" class="conditionInput" name="creatorDeptConditionText" id="creatorDeptConditionText" value="<%=creatorDeptConditiondesc %>" readonly="readonly">
				<button class="addbtn2" title="<%=SystemEnv.getHtmlLabelName(15364,user.getLanguage())%>"  style="color:#018efb;"  onclick="addCondition('<%=creatorDeptRightId %>','creatorDeptCondition','creatorDeptConditionText')" type="button"></button>
				<input type="hidden" name="creatorDeptCondition" id="creatorDeptCondition">
				<%if(!StringHelper.isEmpty(creatorDeptConditiondesc)){%>
					<a href='javascript:void(0);'  style="color:#018efb;"  onclick="addCondition('<%=creatorDeptRightId %>','creatorDeptCondition','creatorDeptConditionText')">
					<%=SystemEnv.getHtmlLabelName(15809,user.getLanguage())%><!-- 已设置条件 -->
					</a>
				<%} %>
				</span>
		</div>
		<div style="float:left;margin-left:10px;">
		<INPUT class="inputstyle" type="checkbox" id="resetModeShareByDept" name="resetModeShareByDept" value="1" /><%=SystemEnv.getHtmlLabelName(31570,user.getLanguage())%>
		</div>
		</td></tr></table>
    </td>
</tr>
<!-- 创建人本岗位 -->
<tr style="display:<%=isdisplay%>">
	<td class="e8_tblForm_label" width="20%"><%=SystemEnv.getHtmlLabelName(126610,user.getLanguage())%></td><!-- 创建人本岗位 -->
    <td class="e8_tblForm_field"> 
		<div style="float:left;width:95px;">
		<select name="creatorpost" onchange="onSelectChange1(this,creatorpostlayoutidDiv,creatorpostlayoutid1Div,creatorpostlayoutorderdiv);">
           <option value="99" <%if(creatorpost==99){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2011,user.getLanguage())%></option><!-- 没有权限 -->
           <option value="1" <%if(creatorpost==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%></option><!-- 查看 -->
           <option value="2" <%if(creatorpost==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%></option> <!-- 编辑 -->
           <option value="3" <%if(creatorpost==3){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(17874,user.getLanguage())%></option> <!-- 完全控制 -->
        </select>
         </div>
        <div id="creatorpostlayoutidDiv"  <%if(creatorpost==99) {out.println(" style=\"display:none;float:left;margin-left:10px;\"" );}else{out.println(" style=\"float:left;margin-left:10px;\"" );}%> >    
       		 <%=SystemEnv.getHtmlLabelName(82203,user.getLanguage())%><!-- 查看布局 -->
       		 <button type="button" class="copybtn2" onclick="onShowModeBrowser('creatorpostlayoutid','creatorpostlayoutidspan','0','1')" title="<%=SystemEnv.getHtmlLabelName(23039,user.getLanguage())%>"></button><!-- 选择模板 -->
			<span id="creatorpostlayoutidspan">
			<%if(creatorpostlayoutid!=-1){%>
				<a href="#"
				<%if(creatorpostlayoutversion==2){ %>
					onclick="onshowExcelDesign('0','<%=creatorpostlayoutid %>')"
				<%}else{ %>
					onclick="openFullWindowHaveBar('/formmode/setup/LayoutEdit.jsp?type=0&modeId=<%=modeId%>&formId=<%=formId%>&Id=<%=creatorpostlayoutid%>')"
				<%} %>
				><%=creatorpostlayoutname%></a>
			<%}%>
			</span>
			<input type="hidden" id="creatorpostlayoutid" name="creatorpostlayoutid" value="<%=creatorpostlayoutid%>">
		</div>
		<div id="creatorpostlayoutid1Div"  <%if(creatorpost==99||creatorpost==1) {out.println(" style=\"display:none;float:left;margin-left:10px;\"" );}else{out.println(" style=\"float:left;margin-left:10px;\"" );}%> >    
			<%=SystemEnv.getHtmlLabelName(82136,user.getLanguage())%><!-- 编辑布局 -->
       		 <button type="button" class="copybtn2" onclick="onShowModeBrowser('creatorpostlayoutid1','creatorpostlayoutid1span','1','1')" title="<%=SystemEnv.getHtmlLabelName(23039,user.getLanguage())%>"></button><!-- 选择模板 -->
			<span id="creatorpostlayoutid1span">
			<%if(creatorpostlayoutid1!=-1){%>
				<a href="#"
				<%if(creatorpostlayout1version==2){ %>
					onclick="onshowExcelDesign('2','<%=creatorpostlayoutid1 %>')"
				<%}else{ %>
					onclick="openFullWindowHaveBar('/formmode/setup/LayoutEdit.jsp?type=2&modeId=<%=modeId%>&formId=<%=formId%>&Id=<%=creatorpostlayoutid1%>')"
				<%} %>
				><%=creatorpostlayoutname1%></a>
			<%}%>
			</span>
			<input type="hidden" id="creatorpostlayoutid1" name="creatorpostlayoutid1" value="<%=creatorpostlayoutid1%>">
		</div>
		<div id="creatorpostlayoutorderdiv"  <%if(creatorpost==99) {out.println(" style=\"display:none;float:left;margin-left:15px;\"" );}else{out.println(" style=\"float:left;margin-left:15px;\"" );}%> >  
			<%=SystemEnv.getHtmlLabelName(82204,user.getLanguage())%><!-- 布局级别 -->
			<input value="<%=creatorpostlayoutorder%>"  class="inputStyle" type="text" size="4" name="creatorpostlayoutorder" onchange="checkphone('creatorpostlayoutorder')">
		</div> 
		<div style="float:left;margin-left:10px;">
		<INPUT class="inputstyle" type="checkbox" id="resetModeShareBycreteorpost" name="resetModeShareBycreteorpost" value="1" /><%=SystemEnv.getHtmlLabelName(31570,user.getLanguage())%>
		</div>
    </td>
</tr>
<!-- 默认共享 -->
<tr><td colspan="2" style="height:8px;"></td></tr>
<tr>
	<td style="font-weight: bold;"><%=SystemEnv.getHtmlLabelName(15059,user.getLanguage())%></td>
	<td align=right>
		<%if(operatelevel>1){%>
			<input type="checkbox" name="chkPermissionAll2" onclick="chkAllClick(this,2)">(<%=SystemEnv.getHtmlLabelName(2241,user.getLanguage())%>)<!-- 全部选中 -->
		<%} %>
		<%if(operatelevel>0){%>
			<a class=href href="ModeShareAdd.jsp?modeId=<%=modeId%>&formId=<%=formId%>&isVirtualForm=<%=isVirtualForm%>"><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></a><!-- 添加 -->
		<%} %>
		<%if(operatelevel>1){%>
			<a class=href href="#" onclick="javaScript:doDelShare(2);"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a><!-- 删除 -->
		<%} %>
	</td>
</TR>
<tr><td colspan="2" style="border-bottom:1px solid #e6e6e6;height:1px;"></td></tr>
<%//查看
for(int i=0 ;i < viewRightList.size();i++){
	datamap = (Map)viewRightList.get(i);
	String rightid = (String)datamap.get("rightId");
	String sharetypetext = (String)datamap.get("sharetypetext");
	String detailText = (String)datamap.get("detailText");
	String conditiondesc = (String)datamap.get("conditiondesc");
	int higherlevel = (Integer)datamap.get("higherlevel");
	String higherlevelSpan = "";
	if(higherlevel==1){
		higherlevelSpan = "("+SystemEnv.getHtmlLabelName(524,user.getLanguage())+SystemEnv.getHtmlLabelName(1867,user.getLanguage())+")";
	}else if(higherlevel==2){
		higherlevelSpan = "("+SystemEnv.getHtmlLabelName(1867,user.getLanguage())+SystemEnv.getHtmlLabelName(15709,user.getLanguage())+")";
	}else if(higherlevel==3){
		higherlevelSpan = "("+SystemEnv.getHtmlLabelName(1867,user.getLanguage())+SystemEnv.getHtmlLabelName(15762,user.getLanguage())+")";
	}
	String singleRightResetStr = "";
	String singleRightRemoveStr = "";
	if(operatelevel>0&&!isVirtualForm){
		String sql = "select modifytime from moderightinfo where id="+rightid;
		recordSet.executeSql(sql);
		if(recordSet.next()){
			String modifytimeStr = StringHelper.null2String(recordSet.getString("modifytime"));
			if(!modifytimeStr.equals("")){
				singleRightResetStr = "<div style='padding-top: 6px;float: left;'>&nbsp;&nbsp;&nbsp;&nbsp;<a href='javascript:void(0);'  style='color:#018efb;'  onclick='resetRightSingle("+rightid+")'>"+SystemEnv.getHtmlLabelName(31464,user.getLanguage())+"</a></div>";//单条权限重构
				singleRightRemoveStr = "<div style='padding-top: 6px;float: left;'>&nbsp;&nbsp;&nbsp;&nbsp;<a href='javascript:void(0);'  style='color:#018efb;'  onclick='removeRightSingle("+rightid+")'>"+SystemEnv.getHtmlLabelName(34239,user.getLanguage())+"</a></div>";//单条权限删除
			}
		}
	}
	
%>
<tr style="display:<%=isdisplay%>">
	<td class="e8_tblForm_label" width="20%"><input type="checkbox" name="rightid2" id="rightid2" value="<%=rightid %>"></td>
  	<td class="e8_tblForm_field">
  		<div style="float:left;padding-top: 4px;">
	  		<%=sharetypetext %>
	  		<%=higherlevelSpan%> 
	  		<%=detailText%>
  		</div>
	  		<div id="defConditionDiv_<%=rightid %>"  style="float:left;margin-left:15px;"  >  
				<%=SystemEnv.getHtmlLabelName(15364,user.getLanguage())%><!-- 条件 -->
				<button class="addbtn2" title="<%=SystemEnv.getHtmlLabelName(15364,user.getLanguage())%>"  style="color:#018efb;"  onclick="addCondition('<%=rightid %>','defCondition_<%=rightid %>','defConditionText_<%=rightid %>')" type="button"></button>
				<input type="hidden" name="defCondition_<%=rightid %>" id="defCondition_<%=rightid %>">
				<%if(!StringHelper.isEmpty(conditiondesc)){%>
					<a href='javascript:void(0);'  style="color:#018efb;"  onclick="addCondition('<%=rightid %>','defCondition_<%=rightid %>','defConditionText_<%=rightid %>')">
					<%=SystemEnv.getHtmlLabelName(15809,user.getLanguage())%><!-- 已设置条件 -->
					</a>
				<%} %>
			</div>
			<%=singleRightResetStr%>
			<%=singleRightRemoveStr%>
  	</td>
</tr>
<%}%>
<%//编辑
for(int i=0 ;i < editRightList.size();i++){
	datamap = (Map)editRightList.get(i);
	String rightid = (String)datamap.get("rightId");
	String sharetypetext = (String)datamap.get("sharetypetext");
	String detailText = (String)datamap.get("detailText");
	String conditiondesc = (String)datamap.get("conditiondesc");
	String javaFileName=(String)datamap.get("javafilename");
	int higherlevel = (Integer)datamap.get("higherlevel");
	String higherlevelSpan = "";
	if(higherlevel==1){
		higherlevelSpan = "("+SystemEnv.getHtmlLabelName(524,user.getLanguage())+SystemEnv.getHtmlLabelName(1867,user.getLanguage())+")";
	}else if(higherlevel==2){
		higherlevelSpan = "("+SystemEnv.getHtmlLabelName(1867,user.getLanguage())+SystemEnv.getHtmlLabelName(15709,user.getLanguage())+")";
	}else if(higherlevel==3){
		higherlevelSpan = "("+SystemEnv.getHtmlLabelName(1867,user.getLanguage())+SystemEnv.getHtmlLabelName(15762,user.getLanguage())+")";
	}
	String singleRightResetStr = "";
	String singleRightRemoveStr = "";
	if(operatelevel>0&&!isVirtualForm){
		String sql = "select modifytime from moderightinfo where id="+rightid;
		recordSet.executeSql(sql);
		if(recordSet.next()){
			String modifytimeStr = StringHelper.null2String(recordSet.getString("modifytime"));
			if(!modifytimeStr.equals("")){
				singleRightResetStr = "<div style='padding-top: 6px;float: left;'>&nbsp;&nbsp;&nbsp;&nbsp;<a href='javascript:void(0);'  style='color:#018efb;'  onclick='resetRightSingle("+rightid+")'>"+SystemEnv.getHtmlLabelName(31464,user.getLanguage())+"</a></div>";//单条权限重构
				singleRightRemoveStr = "<div style='padding-top: 6px;float: left;'>&nbsp;&nbsp;&nbsp;&nbsp;<a href='javascript:void(0);'  style='color:#018efb;'  onclick='removeRightSingle("+rightid+")'>"+SystemEnv.getHtmlLabelName(34239,user.getLanguage())+"</a></div>";//单条权限删除
			}
		}
	}
%>
<tr>
	<td class="e8_tblForm_label" width="20%"><input type="checkbox" name="rightid2" id="rightid2" value="<%=rightid %>"></td>
  	<td class="e8_tblForm_field">
		<div style="float:left;padding-top: 4px;">
	  		<%=sharetypetext %> 
	  		<%=higherlevelSpan%>
	  		<%=detailText%>
  		</div>
	  		<div id="defConditionDiv_<%=rightid %>"  style="float:left;margin-left:15px;<%if(!javaFileName.equals("")){%>display:none;<%} %>"   >  
				<%=SystemEnv.getHtmlLabelName(15364,user.getLanguage())%><!-- 条件 -->
				<button class="addbtn2" title="<%=SystemEnv.getHtmlLabelName(15364,user.getLanguage())%>"  style="color:#018efb;"  onclick="addCondition('<%=rightid %>','defCondition_<%=rightid %>','defConditionText_<%=rightid %>')" type="button"></button>
				<input type="hidden" name="defCondition_<%=rightid %>" id="defCondition_<%=rightid %>">
				<%if(!StringHelper.isEmpty(conditiondesc)){%>
					<a href='javascript:void(0);'  style="color:#018efb;"  onclick="addCondition('<%=rightid %>','defCondition_<%=rightid %>','defConditionText_<%=rightid %>')">
					<%=SystemEnv.getHtmlLabelName(15809,user.getLanguage())%><!-- 已设置条件 -->
					</a>
				<%} %>
			</div>
			<%=singleRightResetStr%>
			<%=singleRightRemoveStr%>
	</td>
</tr>
<%}%>
<%//完全控制
for(int i=0 ;i < controlRightList.size();i++){
	datamap = (Map)controlRightList.get(i);
	String rightid = (String)datamap.get("rightId");
	String sharetypetext = (String)datamap.get("sharetypetext");
	String detailText = (String)datamap.get("detailText");
	String conditiondesc = (String)datamap.get("conditiondesc");
	String javaFileName=(String)datamap.get("javafilename");
	int higherlevel = (Integer)datamap.get("higherlevel");
	String higherlevelSpan = "";
	if(higherlevel==1){
		higherlevelSpan = "("+SystemEnv.getHtmlLabelName(524,user.getLanguage())+SystemEnv.getHtmlLabelName(1867,user.getLanguage())+")";
	}else if(higherlevel==2){
		higherlevelSpan = "("+SystemEnv.getHtmlLabelName(1867,user.getLanguage())+SystemEnv.getHtmlLabelName(15709,user.getLanguage())+")";
	}else if(higherlevel==3){
		higherlevelSpan = "("+SystemEnv.getHtmlLabelName(1867,user.getLanguage())+SystemEnv.getHtmlLabelName(15762,user.getLanguage())+")";
	}
	String singleRightResetStr = "";
	String singleRightRemoveStr = "";
	if(operatelevel>0&&!isVirtualForm){
		String sql = "select modifytime from moderightinfo where id="+rightid;
		recordSet.executeSql(sql);
		if(recordSet.next()){
			String modifytimeStr = StringHelper.null2String(recordSet.getString("modifytime"));
			if(!modifytimeStr.equals("")){
				singleRightResetStr = "<div style='padding-top: 6px;float: left;'>&nbsp;&nbsp;&nbsp;&nbsp;<a href='javascript:void(0);'  style='color:#018efb;'  onclick='resetRightSingle("+rightid+")'>"+SystemEnv.getHtmlLabelName(31464,user.getLanguage())+"</a></div>";//单条权限重构
				singleRightRemoveStr = "<div style='padding-top: 6px;float: left;'>&nbsp;&nbsp;&nbsp;&nbsp;<a href='javascript:void(0);'  style='color:#018efb;'  onclick='removeRightSingle("+rightid+")'>"+SystemEnv.getHtmlLabelName(34239,user.getLanguage())+"</a></div>";//单条权限删除
			}
		}
	}
%>
<tr>
	<td class="e8_tblForm_label" width="20%"><input type="checkbox" name="rightid2" id="rightid2" value="<%=rightid %>"></td>
  	<td class="e8_tblForm_field">
		<div style="float:left;padding-top: 4px;">
	  		<%=sharetypetext %> 
	  		<%=higherlevelSpan%>
	  		<%=detailText%>
  		</div>
	  		<div id="defConditionDiv_<%=rightid %>"  style="float:left;margin-left:15px;<%if(!javaFileName.equals("")){%>display:none;<%} %>"  >  
				<%=SystemEnv.getHtmlLabelName(15364,user.getLanguage())%><!-- 条件 -->
				<button class="addbtn2" title="<%=SystemEnv.getHtmlLabelName(15364,user.getLanguage())%>"  style="color:#018efb;"  onclick="addCondition('<%=rightid %>','defCondition_<%=rightid %>','defConditionText_<%=rightid %>')" type="button"></button>
				<input type="hidden" name="defCondition_<%=rightid %>" id="defCondition_<%=rightid %>">
				<%if(!StringHelper.isEmpty(conditiondesc)){%>
					<a href='javascript:void(0);'  style="color:#018efb;"  onclick="addCondition('<%=rightid %>','defCondition_<%=rightid %>','defConditionText_<%=rightid %>')">
					<%=SystemEnv.getHtmlLabelName(15809,user.getLanguage())%><!-- 已设置条件 -->
					</a>
				<%} %>
			</div>
			<%=singleRightResetStr%>
			<%=singleRightRemoveStr%>
	</td>
</tr>
<%}%>

<!-- 监控权限 -->
<tr style="display:<%=isdisplay%>"><td colspan="2" style="height:8px;"></td></tr>
<tr style="display:<%=isdisplay%>">
	<td style="font-weight: bold;"><%=SystemEnv.getHtmlLabelName(20305,user.getLanguage())%></td>
	<td align=right>
		<%if(operatelevel>1){%>
			<input type="checkbox" name="chkPermissionAll3" onclick="chkAllClick(this,3)">(<%=SystemEnv.getHtmlLabelName(2241,user.getLanguage())%>)
		<%} %>
		<%if(operatelevel>0){%>
			<a class=href href="ModeShareAdd.jsp?trighttype=2&modeId=<%=modeId%>&formId=<%=formId%>"><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></a>
		<%} %>
		<%if(operatelevel>1){%>
			<a class=href href="#" onclick="javaScript:doDelShare(3);"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a>
		<%} %>
	</td>
</TR>
<tr style="display:<%=isdisplay%>"><td colspan="2" style="border-bottom:1px solid #e6e6e6;height:1px;"></td></tr>
<%//监控
for(int i=0 ;i < monitorRightList.size();i++){
	datamap = (Map)monitorRightList.get(i);
	String rightid = (String)datamap.get("rightId");
	String sharetypetext = (String)datamap.get("sharetypetext");
	String detailText = (String)datamap.get("detailText");
%>
<tr style="display:<%=isdisplay%>">
	<td class="e8_tblForm_label" width="20%"><input type="checkbox" name="rightid3" id="rightid3" value="<%=rightid %>"></td>
	<td class="e8_tblForm_field"><%=sharetypetext %> <%=detailText%></td>
</tr>
<TR style="height: 1px"> <TD class=Line colSpan=3></TD></TR>
<%}%>

<!-- 批量导入权限 -->
<tr style="display:<%=isdisplay%>"><td colspan="2" style="height:8px;"></td></tr>
<tr style="display:<%=isdisplay%>">
	<td style="font-weight: bold;"><%=SystemEnv.getHtmlLabelName(30253,user.getLanguage())%></td>
	<td align=right>
		<%if(operatelevel>1){%>
			<input type="checkbox" name="chkPermissionAll4" onclick="chkAllClick(this,4)">(<%=SystemEnv.getHtmlLabelName(2241,user.getLanguage())%>)
		<%} %>
		<%if(operatelevel>0){%>
			<a class=href href="ModeShareAdd.jsp?trighttype=4&modeId=<%=modeId%>&formId=<%=formId%>"><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></a>
		<%} %>
		<%if(operatelevel>1){%>
			<a class=href href="#" onclick="javaScript:doDelShare(4);"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a>
		<%} %>
	</td>
</TR>
<tr style="display:<%=isdisplay%>"><td colspan="2" style="border-bottom:1px solid #e6e6e6;height:1px;"></td></tr>
<%//批量导入权限
for(int i=0 ;i < batchRightList.size();i++){
	datamap = (Map)batchRightList.get(i);
	String rightid = (String)datamap.get("rightId");
	String sharetypetext = (String)datamap.get("sharetypetext");
	String detailText = (String)datamap.get("detailText");
%>
<tr style="display:<%=isdisplay%>">
	<td class="e8_tblForm_label" width="20%"><input type="checkbox" name="rightid4" id="rightid4" value="<%=rightid %>"></td>
	<td class="e8_tblForm_field"><%=sharetypetext %> <%=detailText%></td>
</tr>
<%}%>
</table>

</form>

<script language="javascript">
$(document).ready(function(){//onload事件
	$(".loading", window.parent.document).hide(); //隐藏加载图片
	if($("#modeId").val()=='0'){
		window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(30776,user.getLanguage())%>",function(){
			window.parent.document.getElementById('modeBasicTab').click();
		},function(){
			$('.href').hide();
		});
	}
	//创建人直接上级
	jQuery("#creatorleadervirtualtype").multiselect({
			multiple: true,
			noneSelectedText: '',
			checkAllText: "<%=SystemEnv.getHtmlLabelName(556,user.getLanguage())%>",
	        uncheckAllText: "<%=SystemEnv.getHtmlLabelName(84355,user.getLanguage())%>",
	        selectedList:100,
	        close: function(){
				var tmpmsv = jQuery("#creatorleadervirtualtype").multiselect("getChecked").map(function(){return this.value;}).get();
				jQuery("#creatorleadervirtualtype_value").val(tmpmsv.join(","));
			}
	  	});
	jQuery("#creatorleadervirtualtype").val("<%=creatorleadervirtualtype.equals("")?"0":creatorleadervirtualtype%>".split(","));
  	jQuery("#creatorleadervirtualtype").multiselect("refresh");
  	
  	//创建人所有上级
	jQuery("#allcreatorleadervirtualtype").multiselect({
			multiple: true,
			noneSelectedText: '',
			checkAllText: "<%=SystemEnv.getHtmlLabelName(556,user.getLanguage())%>",
	        uncheckAllText: "<%=SystemEnv.getHtmlLabelName(84355,user.getLanguage())%>",
	        selectedList:100,
	        close: function(){
				var tmpmsv = jQuery("#allcreatorleadervirtualtype").multiselect("getChecked").map(function(){return this.value;}).get();
				jQuery("#allcreatorleadervirtualtype_value").val(tmpmsv.join(","));
			}
	  	});
	jQuery("#allcreatorleadervirtualtype").val("<%=allcreatorleadervirtualtype.equals("")?"0":allcreatorleadervirtualtype%>".split(","));
  	jQuery("#allcreatorleadervirtualtype").multiselect("refresh");
  	
  	//创建人本分部
	jQuery("#creatorSubvirtualtype").multiselect({
			multiple: true,
			noneSelectedText: '',
			checkAllText: "<%=SystemEnv.getHtmlLabelName(556,user.getLanguage())%>",
	        uncheckAllText: "<%=SystemEnv.getHtmlLabelName(84355,user.getLanguage())%>",
	        selectedList:100,
	        close: function(){
				var tmpmsv = jQuery("#creatorSubvirtualtype").multiselect("getChecked").map(function(){return this.value;}).get();
				jQuery("#creatorSubvirtualtype_value").val(tmpmsv.join(","));
			}
	  	});
	jQuery("#creatorSubvirtualtype").val("<%=creatorSubvirtualtype.equals("")?"0":creatorSubvirtualtype%>".split(","));
  	jQuery("#creatorSubvirtualtype").multiselect("refresh");
  	
  	//创建人本部门
	jQuery("#creatorDeptvirtualtype").multiselect({
			multiple: true,
			noneSelectedText: '',
			checkAllText: "<%=SystemEnv.getHtmlLabelName(556,user.getLanguage())%>",
	        uncheckAllText: "<%=SystemEnv.getHtmlLabelName(84355,user.getLanguage())%>",
	        selectedList:100,
	        close: function(){
				var tmpmsv = jQuery("#creatorDeptvirtualtype").multiselect("getChecked").map(function(){return this.value;}).get();
				jQuery("#creatorDeptvirtualtype_value").val(tmpmsv.join(","));
			}
	  	});
	jQuery("#creatorDeptvirtualtype").val("<%=creatorDeptvirtualtype.equals("")?"0":creatorDeptvirtualtype%>".split(","));
  	jQuery("#creatorDeptvirtualtype").multiselect("refresh");
  	
})

function checkLevel(befEleName,aftEleName,obj){
	var bef = jQuery("[name="+befEleName+"]");
	var aft = jQuery("[name="+aftEleName+"]");
	if(isNaN(bef.val())){
		bef.val("");
	}
	if(isNaN(aft.val())){
		aft.val("");
	}
	if(bef.val()==""&&aft.val()!=""){
		if(aft.val()<10){
			bef.val(aft.val());
			return;
		}else{
			bef.val("10");
		}
		
	}
	if(bef.val()==""||aft.val()==""){
		return;
	}
	if(parseInt(bef.val())>parseInt(aft.val())){
		obj.value = "";
		if(obj.name==befEleName){
			bef.val(aft.val());
		}else{
			Dialog.alert("<%=SystemEnv.getHtmlLabelName(82808,user.getLanguage())%>");
		}
	}
}

function onSave(){
	enableAllmenu();
	weaver.method.value="saveForCreator";
	$(".loading", window.parent.document).show();
	weaver.submit();
}

function resetModeShare(){
	try{
		for (a=0;a<window.frames["rightMenuIframe"].document.all.length;a++){
			if(window.frames["rightMenuIframe"].document.all.item(a).tagName == "BUTTON"){
				window.frames["rightMenuIframe"].document.all.item(a).disabled=true;
			}
		}
	}catch(e){}
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(82205,user.getLanguage())%>",function(){//请确认权限重构是否继续?
		$(".loading", window.parent.document).show();
		weaver.method.value="resetModeShare";
		var uuid = new UUID();
		document.weaver.target="rebulidProcessFrame";
		$("#rebulidFlag").val("rebulidFlag_"+uuid);
		$("#rightMenu").css("visibility","hidden");
		weaver.submit();
	},function(){
		enableRightMenu();
	});
}

function showRebulidProcessDiv(){
	$(".loading", window.parent.document).hide();
	$("#rebulidProcessDiv").show();
}

function hideRebulidProcessDiv(){
	$("#weaver").attr("target","");
	$(".loading", window.parent.document).hide();
	enableRightMenu();
}

function enableRightMenu(){
	try{
		for (a=0;a<window.frames["rightMenuIframe"].document.all.length;a++){
			if(window.frames["rightMenuIframe"].document.all.item(a).tagName == "BUTTON"){
				window.frames["rightMenuIframe"].document.all.item(a).disabled=false;
			}
		}
	}catch(e){}
}

function resetRightSingle(rightid){
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(82784,user.getLanguage())%>",function(){//是否需要对此规则历史数据进行重构?
		$(".loading", window.parent.document).show();
		weaver.method.value="resetRightSingle";
		weaver.resetRightId.value=rightid;
		$("#rightMenu").css("visibility","hidden");
		weaver.submit();
	});
}

function removeRightSingle(rightid){
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(23069,user.getLanguage())%>",function(){//确认删除吗
		window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(82820,user.getLanguage())%>",function(){//是否删除此权限对应的数据权限？
			weaver.method.value="deleteDataRight";
    		weaver.mainids.value=rightid;
    		$(".loading", window.parent.document).show();
    		weaver.submit();
		},function(){
			weaver.method.value="delete";
    		weaver.mainids.value=rightid;
    		$(".loading", window.parent.document).show();
    		weaver.submit();
		});
	});
}

function reseDocShare(){
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(82206,user.getLanguage())%>",function(){//确认对模块中的文档进行权限重构?
		$(".loading", window.parent.document).show();
		weaver.method.value="reseDocShare";
		weaver.submit();
	});
}

function createmenu(){
	var url = "/formmode/search/CustomSearch.jsp?modeid=<%=modeId%>&monitor=1";
	//location.href = url;
	window.open(url);
}

function createmenu1(){
	var url = "/formmode/interfaces/ModeDataBatchImport.jsp?modeid=<%=modeId%>";
	var parmes = escape(url);
	diag_vote = new window.top.Dialog();
	diag_vote.currentWindow = window;	
	diag_vote.Width = 350;
	diag_vote.Height = 180;
	diag_vote.Modal = true;
	diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(23033,user.getLanguage())%>";
	diag_vote.URL = "/formmode/setup/modelMenuAdd.jsp?dialog=1&isFromMode=1&parmes="+parmes;
	diag_vote.isIframe=false;
	diag_vote.show();
	//window.open("/formmode/menu/CreateMenu.jsp?menuaddress="+escape(url));
}
function viewmenu1(){
	var url = "/formmode/interfaces/ModeDataBatchImport.jsp?modeid=<%=modeId%>";
	prompt("<%=SystemEnv.getHtmlLabelName(28624,user.getLanguage())%>",url);//查看菜单地址
}

function chkAllClick(obj,types){
    var chks = document.getElementsByName("rightid"+types); 
    for (var i=0;i<chks.length;i++){
        var chk = chks[i];
        changeCheckboxStatus(chk, obj.checked);
    }    
}

function doDelShare(type){
	var mainids = "";
    var chks = document.getElementsByName("rightid"+type);   
    for (var i=0;i<chks.length;i++){
        var chk = chks[i];
        if(chk.checked)
        	mainids += "," + chk.value;
    }    
    if(mainids == ''){
    	window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32568,user.getLanguage())%>");
		return;
    }else{
    	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(33435,user.getLanguage())%>",function(){
			weaver.method.value="delete";
    		weaver.mainids.value=mainids;
    		$(".loading", window.parent.document).show();
    		weaver.submit();
		});
    }
}
function onSelectChange(obj1,obj2,obj3,obj4,obj5,obj6,obj7,initval){
     var selectValue = obj1.value;
     if (selectValue!=99) {
    	 obj2.style.display="";
    	 obj5.style.display="";
    	 obj6.style.display="";
    	 if(selectValue==1){
    	 	obj3.style.display="";
    	 	obj4.style.display="none";
    	 }else{
    	 	obj3.style.display="";
    	 	obj4.style.display="";
    	 }
    	 obj7.style.display="";
     }else{
     	 obj2.style.display="none"; 
     	 obj3.style.display="none"; 
     	 obj4.style.display="none";   
     	 obj5.style.display="none";   
     	 obj6.style.display="none";   
     	 obj7.style.display="none";
     }
     if(initval&&initval==99){
    	jQuery(obj6).find(".conditionContentSpan").hide();
     }
}
function onSelectChange1(obj1,obj3,obj4,obj5,obj6,obj7,initval){
     var selectValue = obj1.value;
     if (selectValue!=99) {
     	obj5.style.display="";
     	if(obj6){
	     	obj6.style.display="";
     	}
    	 if(selectValue==1){
    	 	obj3.style.display="";
    	 	obj4.style.display="none";
    	 }else{
    	 	obj3.style.display="";
    	 	obj4.style.display="";
    	 }
    	obj7.style.display="";
     }else{
     	 obj3.style.display="none"; 
     	 obj4.style.display="none";   
     	 obj5.style.display="none";  
     	 if(obj6){
	     	 obj6.style.display="none";   
     	}
     	obj7.style.display="none";
     }
     if(initval&&initval==99){
    	jQuery(obj6).find(".conditionContentSpan").hide();
     }
}

function addCondition(rightid,objid,objspan){
	var url = "/formmode/interfaces/shareConditionContent.jsp?modeid=<%=modeId%>&rightid="+rightid;
	var dlg = top.createTopDialog();
    dlg.currentWindow = window;
	dlg.Model = true;
	dlg.Width = 800;//定义长度
	dlg.Height = 500;
	dlg.URL = url;
	dlg.Title = "<%=SystemEnv.getHtmlLabelName(82394,user.getLanguage())%>";//条件编辑
	dlg.callback = function(datas){
	};
	dlg.show();
}

function onShowModeBrowser(ids,spans,righttype,creatortype){
	var type =-1
	var layouttype = -1;
	if(creatortype=='1'){
		layouttype=$GetEle("creator").value;
	}else if(creatortype=='2'){
		layouttype=$GetEle("creatorleader").value;
	}else if(creatortype=='3'){
		layouttype=$GetEle("creatorSub").value;
	}else if(creatortype=='4'){//所有上级
		layouttype=$GetEle("allcreatorleader").value;
	}else{
		layouttype=$GetEle("creatorDept").value;
	}
	if(layouttype=='1'){
		type = 0
	}else if(layouttype=='2'||layouttype=='3'){
		//编辑、完全控制权限 type为0，表示显示布局； type为1，表示编辑布局
		if(righttype==0){
			type = 0
		}else{
			type = 2
		}
	}
	if(creatortype=='4'){
		type = righttype;
		if(righttype==0){
			type = 0
		}else{
			type = 2
		}
	}
	
	urls = "/formmode/setup/FormModeHtmlBrowser.jsp?modeId=<%=modeId%>&formId=<%=formId%>&type="+type+"&comfrom=right";
	urls = "/systeminfo/BrowserMain.jsp?url="+escape(urls);
	var dlg = top.createTopDialog();
	dlg.currentWindow = window;
	dlg.Model = true;
	dlg.Width = 500;
	dlg.Height = 400;
	dlg.URL = urls;
	dlg.Title = "<%=SystemEnv.getHtmlLabelName(81986,user.getLanguage())%>";//请选择模板
	dlg.callback = function(datas){
		if (datas != undefined && datas != null) {
			if(datas.id!=""){
			    var layoutid = datas.id+"";
				jQuery("#"+ids).val(layoutid);
				var version = datas.version;
				if(version==2){
					jQuery("#"+spans).html("<a href=\"#\" onclick=\"onshowExcelDesign("+type+","+layoutid+")\">"+datas.name+"</a>");
				}else{
					jQuery("#"+spans).html("<a href=\"#\" onclick=\"openFullWindowHaveBar('/formmode/setup/LayoutEdit.jsp?type="+type+"&modeId=<%=modeId%>&formId=<%=formId%>&Id="+layoutid+"')\">"+datas.name+"</a>");
				}
			}else{
				jQuery("#"+ids).val("");
				jQuery("#"+spans).html("");
			}
		}
		dlg.close();
	};
	dlg.show();
}

function openCodeEdit(filename){
	top.openCodeEdit({
		"type" : "6",
		"filename" : filename,
		"formid" : "<%=formId%>"
	}, function(result){
		
	});
}

//打开新表单设计器
function onshowExcelDesign(layouttype, layoutid){
	var dlg=new window.top.Dialog();//定义Dialog对象
	dlg.currentWindow=window;
	dlg.Model=true;
    if ($.browser.msie && parseInt($.browser.version, 10) < 9) {		//run for ie7/8
    	dlg.maxiumnable=false;
    	dlg.Width = 1000;
		dlg.Height = 600;
    	dlg.URL="/wui/common/page/sysRemind.jsp?labelid=124796";
    	dlg.hideDraghandle = false;
    }else{
    	dlg.maxiumnable=true;
    	dlg.Width = $(window.top).width()-60;
		dlg.Height = $(window.top).height()-80;
    	dlg.URL="/formmode/exceldesign/excelMain.jsp?modeid=<%=modeId%>&formid=<%=formId%>&layoutid="+layoutid+"&layouttype="+layouttype;
    	dlg.hideDraghandle = true;
    } 
	dlg.Title="新版流程模式设计器";
	dlg.closeHandle = function (paramobj, datas){
		//window.location.reload();
	}
　　 dlg.show();
}

</script>
</BODY></HTML>