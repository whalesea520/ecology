<%@page import="weaver.formmode.service.ModelInfoService"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/formmode/pub_detach.jsp"%>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.docs.category.CategoryUtil" %>
<%@ page import="weaver.docs.category.security.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />
<%
	if (!HrmUserVarify.checkUserRight("ModeSetting:All", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>
<%
ModelInfoService modelInfoService=new ModelInfoService();
int modeId = Util.getIntValue(request.getParameter("modeId"),0);
int formId = modelInfoService.getFormInfoIdByModelId(modeId); 
int layoutformId = Util.getIntValue(Util.null2String(request.getParameter("formId")));
int trighttype = Util.getIntValue(request.getParameter("trighttype"),0);
boolean isVirtualForm=Boolean.valueOf(Util.null2String(request.getParameter("isVirtualForm")));
boolean showJavaTr=(trighttype==0&&isVirtualForm);

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

%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link href="/formmode/css/formmode_wev8.css" type="text/css" rel="stylesheet" />
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<style>
.codeEditFlag{
    padding-left:20px;
    padding-right: 3px;
    height: 20px;
    background:transparent url('/formmode/images/code_wev8.png') no-repeat !important;
    cursor: pointer;
    margin-left: 2px;
    margin-top: 2px;
    position: relative;
    display: block;
    float: left;
}

.codeDownFlag{
    padding-left:20px;
    padding-right: 10px;
    height: 22px;
    background:transparent url('/formmode/images/codeDown_wev8.png') no-repeat !important;
    cursor: pointer;
    margin-left: 2px;
    position: relative;
    display: block;
    float: left;
}
</style>
</HEAD>
<BODY>
<%
String imagefilename = "/images/hdCRMAccount_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(16526,user.getLanguage());
String needfav ="1";
String needhelp ="";
if(trighttype==1){//创建权限:添加
	titlename = SystemEnv.getHtmlLabelName(21945,user.getLanguage()) + ":" + SystemEnv.getHtmlLabelName(611,user.getLanguage());
}else if(trighttype==0){//默认共享:添加
	titlename = SystemEnv.getHtmlLabelName(15059,user.getLanguage()) + ":" + SystemEnv.getHtmlLabelName(611,user.getLanguage());
}else if(trighttype==2){//监控权限:添加
	titlename = SystemEnv.getHtmlLabelName(20305,user.getLanguage()) + ":" + SystemEnv.getHtmlLabelName(611,user.getLanguage());
}else if(trighttype==4){//批量导入权限:添加
	titlename = SystemEnv.getHtmlLabelName(30253,user.getLanguage()) + ":" + SystemEnv.getHtmlLabelName(611,user.getLanguage());
}
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(operatelevel>0){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(this),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:location.href='ModeRightEdit.jsp?modeId="+modeId+"&formId="+layoutformId+"&isVirtualForm="+isVirtualForm+"',_top} " ;
RCMenuHeight += RCMenuHeightStep ;

boolean isDefaultShare = false;//是否默认共享
if(trighttype==0&&!isVirtualForm){
	isDefaultShare = true;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>


<FORM id=weaver name=weaver action=ModeRightOperation.jsp method=post onsubmit='return check_by_permissiontype()'>
  <input type="hidden" name="method" value="addNew">
  <input type="hidden" name="modeId" value="<%=modeId%>">
  <input type="hidden" name="formId" value="<%=layoutformId%>">
  <input type="hidden" name="relatedid" id="relatedid" value="">
  <input type="hidden" name="isVirtualForm" value="<%=isVirtualForm%>">
<table class="e8_tblForm">
    <TBODY>
     <TR><!-- 共享类型 -->
       <td class="e8_tblForm_label" width="20%"><%=SystemEnv.getHtmlLabelName(18495,user.getLanguage())%></TD>
       <TD class="e8_tblForm_field" nowrap>
         <SELECT class=InputStyle  name=sharetype onChange="onChangeSharetype()"  style="width:100px;">  
			<option value="1" selected><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%></option> <!-- 人员 -->
			<option value="3"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option><!-- 部门 -->
			<option value="2"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option><!-- 分部 -->
			<option value="4"><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></option><!-- 角色 -->
			<option value="5"><%=SystemEnv.getHtmlLabelName(1340,user.getLanguage())%></option><!-- 所有人 -->
			<%if(trighttype==0&&!isVirtualForm){%>
			<option value="1000"><%=SystemEnv.getHtmlLabelName(28605,user.getLanguage())%></option><!-- 流程主字段 -->
			<%}
			if(showJavaTr){
			%>
			<option value="1001">java<%=SystemEnv.getHtmlLabelName(32363,user.getLanguage())%></option><!-- java接口 -->
			<%}%>
			<option value="6"><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></option><!-- 岗位 -->
         </SELECT>
         <span id="modefieldtypespan" style="display:none;width: 220px;" >
         <span><%=SystemEnv.getHtmlLabelName(686,user.getLanguage())%></span>
         <select class=InputStyle id="modefieldtype" name="modefieldtype" onchange="changeFieldType(this)">
         	<option value="1"><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%></option><!-- 人员 -->
         	<option value="2"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option><!-- 部门 -->
         	<option value="3"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option><!-- 分部 -->
         	<option value="4"><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></option><!-- 岗位 -->
         </select>
         </span>
         <span id="orgrelationspan" style="display:none;width: 220px;" >
         <select class=InputStyle id="orgrelation" name="orgrelation" onchange="">
         	<option value=""></option>
         	<option value="1"><%=SystemEnv.getHtmlLabelName(15762,user.getLanguage())%></option><!-- 所有上级 -->
         	<option value="2"><%=SystemEnv.getHtmlLabelName(15765,user.getLanguage())%></option><!-- 所有下级 -->
         </select>
         </span>
       </TD>
     </TR>
     <TR id="browserTr">
     	<TD class="e8_tblForm_label" width="20%"><%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%><!-- 选择 --></TD>
     	<TD class="e8_tblForm_field">
     	 <span id="showspan1">
         	<brow:browser viewType="0" name="relatedid1" browserValue="" browserOnClick="" 
         		browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids=" 
         		hasInput="true"  width="50%" isSingle="false" hasBrowser="true" completeUrl="/data.jsp?type=1" browserSpanValue="" isMustInput="2">
         	</brow:browser>
         </span>
         <span id="showspan2" style="display:none;">
         	<brow:browser viewType="0" name="relatedid2" browserValue="" browserOnClick="" 
         		browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp?selectedids=&selectedDepartmentIds=" 
         		hasInput="true"  width="50%" isSingle="false" hasBrowser="true" completeUrl="/data.jsp?type=164" browserSpanValue="" isMustInput="2">
         	</brow:browser>
         </span>
         <span id="showspan3" style="display:none;">
         	<brow:browser viewType="0" name="relatedid3" browserValue="" browserOnClick="" 
         		browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids=" 
         		hasInput="true"  width="50%" isSingle="false" hasBrowser="true" completeUrl="/data.jsp?type=167" browserSpanValue="" isMustInput="2">
         	</brow:browser>
         </span>
         <span id="showspan4" style="display:none;">
         	<brow:browser viewType="0" name="relatedid4" browserValue="" browserOnClick="" 
         		browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp" 
         		hasInput="true"  width="50%" isSingle="true" hasBrowser="true" completeUrl="/data.jsp?type=65" browserSpanValue="" isMustInput="2">
         	</brow:browser>
         </span>
         <span id="showspan6" style="display:none;">
         	<brow:browser viewType="0" name="relatedid6" browserValue="" browserOnClick="" 
         		browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/MutiJobTitlesBrowser.jsp" 
         		hasInput="true"  width="50%" isSingle="false" hasBrowser="true" completeUrl="/data.jsp?type=24" browserSpanValue="" isMustInput="2">
         	</brow:browser>
         </span>
         <span id="showspan1000" style="display:none;">
         	<brow:browser viewType="0" name="relatedid1000" browserValue="" browserOnClick="" getBrowserUrlFn="modefiledChange" tempTitle="<%=SystemEnv.getHtmlLabelName(82098,user.getLanguage())%>"
         		hasInput="false"  width="50%" isSingle="false" hasBrowser="true" completeUrl="/data.jsp" browserSpanValue="" isMustInput="2">
         	</brow:browser>
         </span>
     	</TD>
     </TR>
     <%if(isDefaultShare){%>
     <TR id="isRoleLimitedTr" style="display: none;" >
     	<TD class="e8_tblForm_label" width="20%"><%=SystemEnv.getHtmlLabelName(82385,user.getLanguage())%></TD><!-- 角色是否受范围限制 -->
     	<TD class="e8_tblForm_field">
     		<table style="width: 100%;">
     			<colgroup>
		   			<col style="width: 20%"  />
		   			<col style="width: 35%"  />
		   			<col style="width: 15%"  />
		   			<col style="width: 30%"  />
		   		</colgroup>
     			<tr>
     				<td>
	     				<SELECT id="isRoleLimited"  name="isRoleLimited" style="width:60px;" onchange="changeRoleLimited()">
				           <option value="0"><%=SystemEnv.getHtmlLabelName(30587,user.getLanguage())%></option><!-- 否 -->
				           <option value="1"><%=SystemEnv.getHtmlLabelName(30586,user.getLanguage())%></option><!-- 是 -->
				       </SELECT>
			       </td>
     				<td id="isRoleLimitedTd2" style="display: none;">
					         <span><%=SystemEnv.getHtmlLabelName(686,user.getLanguage())%></span><!-- 字段类型 -->
					         <select class=InputStyle id="rolefieldtype" name="rolefieldtype" onchange="roleFieldTypeChange()" >
					         	<option value="1"><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%></option>
					         	<option value="2"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
					         	<option value="3"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>
					         </select>
     				</td>
     				<td id="isRoleLimitedTd3" style="display: none;"><%=SystemEnv.getHtmlLabelName(82386,user.getLanguage())%></td><!-- 限制字段 -->
     				<td id="isRoleLimitedTd4" style="display: none;">
	     				<brow:browser viewType="0" name="rolefield" browserValue="" browserOnClick="" getBrowserUrlFn="rolefiledChange" tempTitle="<%=SystemEnv.getHtmlLabelName(82098,user.getLanguage())%>"
			         		hasInput="false"  width="260px;" isSingle="false" hasBrowser="true" completeUrl="/data.jsp" browserSpanValue="" isMustInput="2">
			         	</brow:browser>
     				</td>
     			</tr>
     		</table>
     	</TD>
     </TR>
     
     <%} %>
     
     <TR id="javaTr" style="display:none;">
     	<TD class="e8_tblForm_label" width="20%">java<%=SystemEnv.getHtmlLabelName(32363,user.getLanguage())%></TD>
     	<TD class="e8_tblForm_field">
         	<!-- <span class="codeEditFlag" onclick="openCodeEdit();">
				<span id="javafilename_span"><img align="absmiddle" src="/images/BacoError_wev8.gif"></span>
				<div class="codeDelFlag" style="display: none;"></div>
			</span>
			<input type="hidden" id="javafilename" name="javafilename" value=""/>
			 -->
            <input type="text" id="javafileAddress" name="javafileAddress"   onchange='checkinput("javafileAddress","addressspan")' style="min-width:40%;float: left;" value=""/>
            <SPAN id=addressspan style="float: left;padding-right: 3px;padding-top: 3px;" >
                            <img src="/images/BacoError_wev8.gif"/>
            </SPAN>
            <span class="codeDownFlag" onclick="downloadMode()" title="<%=SystemEnv.getHtmlLabelName(382920, user
                                .getLanguage())%>">
            </span>
            <br>
            <br><span style="Letter-spacing:1px;"><%=SystemEnv.getHtmlLabelName(384524, user
                                .getLanguage())%>weaver.formmode.customjavacode.moderightinfo.XXX。</span>                   
     	</TD>
     </TR>

     <!-- 角色级别 -->
     <TR id=rolelevel_tr name=id=rolelevel_tr style="display:none">
       <td class="e8_tblForm_label" width="20%"><%=SystemEnv.getHtmlLabelName(3005,user.getLanguage())%></td>
       <TD class="e8_tblForm_field">
           <SELECT  name=rolelevel style="width:100px;">
	           <option value="0" selected><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%><!-- 部门 -->
	           <option value="1"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%><!-- 分门 -->
	           <option value="2"><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%><!-- 总部 -->
	       </SELECT>
       </td>
     </TR>
     <!-- 岗位级别 -->
     <TR id=joblevel_tr name=id=joblevel_tr style="display:none">
       <td class="e8_tblForm_label" width="20%"><%=SystemEnv.getHtmlLabelName(28169,user.getLanguage())%></td>
       <TD class="e8_tblForm_field">
           <SELECT  name=joblevel style="width:100px;float: left;" onchange="onJoblevelChange();">
	           <option value="0"><%=SystemEnv.getHtmlLabelName(19438,user.getLanguage())%><!-- 部门 -->
	           <option value="1"><%=SystemEnv.getHtmlLabelName(19437,user.getLanguage())%><!-- 分门 -->
	           <option value="2" selected><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%><!-- 总部 -->
	       </SELECT>
	       <span id="joblevel_1" style="display:none;">
         	<brow:browser viewType="0" name="jobleveltext1" browserValue="" browserOnClick="" 
         		browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp?selectedids=&selectedDepartmentIds=" 
         		hasInput="true"  width="39%" isSingle="false" hasBrowser="true" completeUrl="/data.jsp?type=164" browserSpanValue="" isMustInput="2">
         	</brow:browser>
         	</span>
       	 	<span id="joblevel_0" style="display:none;">
         	<brow:browser viewType="0" name="jobleveltext0" browserValue="" browserOnClick="" 
         		browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids=" 
         		hasInput="true"  width="39%" isSingle="false" hasBrowser="true" completeUrl="/data.jsp?type=167" browserSpanValue="" isMustInput="2">
         	</brow:browser>
         	</span>
         	<input type="hidden" id="jobleveltext" name="jobleveltext" value=""/>
       </td>
     </TR>
     
     <!-- 上级关系 -->
     <TR  id=higherlevel_tr name=higherlevel_tr style="display:none;height: 1px">
       <td class="e8_tblForm_label" width="20%"><%=SystemEnv.getHtmlLabelName(596,user.getLanguage())+SystemEnv.getHtmlLabelName(729,user.getLanguage())%></TD>
       <TD class="e8_tblForm_field">
       	 <select class=InputStyle id="higherlevel" name="higherlevel" onchange="javascript:changeHigherlevel();" >
         	<option value="1"><%=SystemEnv.getHtmlLabelName(524,user.getLanguage())+SystemEnv.getHtmlLabelName(1867,user.getLanguage())%></option>
         	<option value="2"><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())+SystemEnv.getHtmlLabelName(15709,user.getLanguage())%></option>
         	<option value="3"><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())+SystemEnv.getHtmlLabelName(15762,user.getLanguage())%></option>
         </select>
       </TD>
     </TR>
     <tr id="tr_virtualtype" style="display:none">
     	<td class="e8_tblForm_label" width="20%"><%=SystemEnv.getHtmlLabelName(34069, user.getLanguage()) %></td>
     	<td class="e8_tblForm_field">
     		<select id="HrmCompanyVirtual" name="HrmCompanyVirtual">
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
     	</td>
     </tr>
     <!-- 安全级别 -->
     <TR  id=showlevel_tr name=showlevel_tr style="display:none;height: 1px">
       <td class="e8_tblForm_label" width="20%"><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></TD>
       <TD class="e8_tblForm_field">
       	 <INPUT type=text name="showlevel" id="showlevel" name="showlevel" onblur="checkLevel('showlevel','showlevel2',this)" class=InputStyle size=6 value="10" onchange='checkinput("showlevel","showlevelimage")' onKeyPress="ItemCount_KeyPress()">
         <span id=showlevelimage></span> - 
         <INPUT type=text name="showlevel2" id="showlevel2" name="showlevel2" onblur="checkLevel('showlevel','showlevel2',this)" class=InputStyle size=6 value=""  onKeyPress="ItemCount_KeyPress()">
       </TD>
     </TR>
     
     <!-- 权限项 -->
     <TR>
       <td class="e8_tblForm_label" width="20%"><%=SystemEnv.getHtmlLabelName(440,user.getLanguage())%></td>
       <TD class="e8_tblForm_field">
       	<div <%if(trighttype == 1||trighttype == 2||trighttype == 4){%>style="display: none;"<%} %>>
         <SELECT class=InputStyle  name=righttype <%if(trighttype == 1 || trighttype == 2 || trighttype == 4){%>disabled<%}%>  onChange="onChangeSharetype1()" style="width:100px;">
         	 <%if(trighttype == 1){%>
         	 <option value="0" selected><%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%></option>
         	 <%}else if(trighttype == 2){%>
         	 <option value="4" selected><%=SystemEnv.getHtmlLabelName(665,user.getLanguage())%></option>
         	 <%}else if(trighttype == 4){%>
         	 <option value="5" selected><%=SystemEnv.getHtmlLabelName(26601,user.getLanguage())%></option>
         	 <%}else{
	       	 		if(!isVirtualForm){%>
	       	 		<option value="1"><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%></option><%
	       	 		}%>
					<option value="2"><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%></option>
					<option value="3"><%=SystemEnv.getHtmlLabelName(17874,user.getLanguage())%></option>
	         <%}%>
		 </SELECT>
		 </div>
		 	 <%if(trighttype == 1){%>
		 		<span><%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%></span>
		 	 <%}else if(trighttype == 2){%>
		 		<span><%=SystemEnv.getHtmlLabelName(665,user.getLanguage())%></span>
        	 <%}else if(trighttype == 4){%>
		 		<span><%=SystemEnv.getHtmlLabelName(26601,user.getLanguage())%></span>
        	 <%} %>
       </TD>
     </TR>
     <%if(trighttype != 4){%>
		<tr>
			<td class="e8_tblForm_label"><span id="layoutidtdname">
			<%if(trighttype == 1){%>
	         	<%=SystemEnv.getHtmlLabelName(82135,user.getLanguage())%><!-- 新建布局 -->
	         	 <%}else if(trighttype == 2){%>
	         	<%=SystemEnv.getHtmlLabelName(82137,user.getLanguage())%><!-- 监控布局 -->
	         	 <%}else{ %>
	         	<%=SystemEnv.getHtmlLabelName(82203,user.getLanguage())%><!-- 查看布局 -->
	         	 <%} %>
			</span></td>
			<td class="e8_tblForm_field">
				<button type="button" class="copybtn2" onclick="onShowModeBrowser('layoutid','layoutidspan','0')" title="<%=SystemEnv.getHtmlLabelName(23039,user.getLanguage())%>"></button><!-- 选择模板 -->
				<span id="layoutidspan"></span>
				<input type="hidden" id="layoutid" name="layoutid" value="">
			</td>
		</tr>
		<tr id=layoutid1_tr name=layoutid1_tr style="display:none;height: 1px">
			<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(82136,user.getLanguage())%><!-- 编辑布局 --></td>
			<td class="e8_tblForm_field">
				<button type="button" class="copybtn2" onclick="onShowModeBrowser('layoutid1','layoutidspan1','2')" title="<%=SystemEnv.getHtmlLabelName(23039,user.getLanguage())%>"></button><!-- 选择模板 -->
				<span id="layoutidspan1"></span>
				<input type="hidden" id="layoutid1" name="layoutid1" value="">
			</td>
		</tr>
		<!-- 布局级别 -->
	     <TR>
	       <td class="e8_tblForm_label" width="20%"><%=SystemEnv.getHtmlLabelName(82204,user.getLanguage())%><!-- 布局级别 --></TD>
	       <TD class="e8_tblForm_field">
	       	 <INPUT type=text name=layoutorder class=InputStyle size=6 value="-1" onchange="checkphone('layoutorder')" >
	       </TD>
	     </TR>
		<%}else{%>
		<TR><!-- 导入类型 -->
        <td class="e8_tblForm_label" width="20%"><%=SystemEnv.getHtmlLabelName(24863,user.getLanguage())%></td>
        <TD class="e8_tblForm_field">
            <select id="importtype" name="importtype" >
                <option value="0"><%=SystemEnv.getHtmlLabelName(21979,user.getLanguage())%></option><!-- 全部类型-->
				<option value="1"><%=SystemEnv.getHtmlLabelName(31259,user.getLanguage())%></option><!-- 追加 -->
				<option value="2"><%=SystemEnv.getHtmlLabelName(31260,user.getLanguage())%></option><!-- 覆盖 -->
				<option value="3"><%=SystemEnv.getHtmlLabelName(17744, user.getLanguage())%></option><!-- 更新 -->
			</select>
			<span id="RemindMessage" style="color:red;font-weight:bold;Letter-spacing:1px;"></span>
        </TD>
        </TR>
		<%} %>
     <%if(trighttype==0&&!isVirtualForm){ %>
     <TR>
       <td class="e8_tblForm_label" width="20%"><%=SystemEnv.getHtmlLabelName(31570,user.getLanguage())%></td><!-- 更新表单数据 -->
       <TD class="e8_tblForm_field">
         <input name="isEditAllData" type="checkbox" value="1">
       </TD>
     </TR>
     <%} %>
 	<tr><td colspan="2" style="height:10px;"></td></tr>
 	<TR>
       <TD  colspan=2 style="text-align:right;">
       <button
	      	type="button"
	      	title="<%=SystemEnv.getHtmlLabelName(18645,user.getLanguage())%>" 
	      	class="addbtn2" 
	      	onClick="addValue()"></button><!-- 添加共享 -->
	      <button 
	      	type="button"
	      	title="<%=SystemEnv.getHtmlLabelName(18646,user.getLanguage())%>"
	      	class="deletebtn2" 
	      	onclick="removeValue()"></button><!-- 删除共享 -->
       </TD>
     </TR>
</table>

<table id="oTable" name="oTable">
             <colgroup>
             <col width="3%">
             <col width="15%">
             <col width="25%">
             <col width="15%">
             <col width="15%">
             <col width="15%">
             <tr class="header">
                 <th><input type="checkbox" name="chkAll" onClick="chkAllClick(this)"></th>
                  <th><%=SystemEnv.getHtmlLabelName(18495,user.getLanguage())%></th><!-- 共享类型 -->
                 <th><%=SystemEnv.getHtmlLabelName(119,user.getLanguage())%></th><!-- 共享 -->
                 <th><%=SystemEnv.getHtmlLabelName(3005,user.getLanguage())%></th><!-- 共享级别 -->
                 <th><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></th><!-- 安全级别 -->
                 <th><%=SystemEnv.getHtmlLabelName(385,user.getLanguage())%></th><!-- 权限 -->
             </tr>
         </table>

</FORM>


<script language=javascript>
$(document).ready(function() {
	onChangeSharetype();
	onChangeSharetype1();
});

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
			checkinput("showlevel","showlevelimage");
			return;
		}else{
			bef.val("10");
			checkinput("showlevel","showlevelimage");
		}
		
	}
	if(bef.val()==""||aft.val()==""){
		return;
	}
	if(parseInt(bef.val())>parseInt(aft.val())){
		obj.value = "";
		if(obj.name==befEleName){
			bef.val(aft.val());
			checkinput("showlevel","showlevelimage");
		}else{
			Dialog.alert("<%=SystemEnv.getHtmlLabelName(82808,user.getLanguage())%>");
		}
	}
}

function modefiledChange(){
    var tmpval = $GetEle("modefieldtype").value;
    var selectedids = $GetEle("relatedid1000").value;
	var tempurl1 = "/systeminfo/BrowserMain.jsp?url=/formmode/setup/MultiFormmodeShareFieldBrowser.jsp?type="+tmpval+"&selectedids="+selectedids+"&modeId=<%=modeId%>";
	return tempurl1;
}
function rolefiledChange(){
    var tmpval = $GetEle("rolefieldtype").value;
    var selectedids = $GetEle("rolefield").value;
	var tempurl1 = "/systeminfo/BrowserMain.jsp?url=/formmode/setup/MultiFormmodeShareFieldBrowser.jsp?type="+tmpval+"&selectedids="+selectedids+"&modeId=<%=modeId%>&isRoleLimited=1";
	return tempurl1;
}
function onChangeSharetype(){
	var thisvalue=$GetEle("sharetype").value;
    var strAlert= ""
    $("span[id^='showspan']").css('display','none');
	if(thisvalue==1 || thisvalue==2 || thisvalue==3 || thisvalue==4 || thisvalue==6 || thisvalue==1000){//需要浏览框
		$GetEle("browserTr").style.display = '';
		$GetEle("showspan"+thisvalue).style.display='';	//浏览框
	}else{
		$GetEle("browserTr").style.display = 'none';
		//$GetEle("showspan").style.display='none';	//不需要浏览框
	}
	if(thisvalue==6){
		jQuery("#joblevel_tr").show();
	}else{
		jQuery("#joblevel_tr").hide();
	}
	if(thisvalue==1001){
		jQuery("#javaTr").show();
	}else{
		jQuery("#javaTr").hide();
	}
	if(thisvalue==1000){
		jQuery("#higherlevel_tr").show();
	}else{
	    jQuery("#higherlevel_tr").hide();
	}
	
	<%if(isDefaultShare){%>
		var isRoleLimitedTr = jQuery("#isRoleLimitedTr");
	<%}%>
	
	if(thisvalue != 4){
		$GetEle("rolelevel_tr").style.display='none';	//角色级别
		<%if(isDefaultShare){%>
			isRoleLimitedTr.hide();
		<%}%>
	}else{
		$GetEle("rolelevel_tr").style.display='';	//需要角色级别
		<%if(isDefaultShare){%>
			changeRoleLimited();
		<%}%>
	}
	if(thisvalue == 1 || thisvalue==1001){//人员、Java不需要安全级别
		$GetEle("showlevel_tr").style.display='none';	//安全级别
	}else{
		if(thisvalue==1000){
			changeHigherlevel();
		}else{
			$GetEle("showlevel_tr").style.display='';	//安全级别
		}
	}
	if(thisvalue==1000){
		jQuery("#modefieldtypespan").show();
	}else{
		//jQuery("#modefieldtype").hide();
		jQuery("#modefieldtypespan").hide();
	}
	
	if(thisvalue==1000&&jQuery("#modefieldtype").val()==1&&(jQuery("#higherlevel").val()==2||jQuery("#higherlevel").val()==3)){//人员 
		jQuery("#tr_virtualtype").show();
	}else {
		jQuery("#tr_virtualtype").hide();
	}
	changeOrgRelationShow();
	
}

function onJoblevelChange(){
	var joblevel = $GetEle("joblevel").value;
	jQuery("#jobleveltext").val('');
	if(joblevel=='0'){//指定部门
		jQuery("#joblevel_0").show();
		jQuery("#joblevel_1").hide();
	}else if(joblevel=='1'){//指定分部
		jQuery("#joblevel_1").show();
		jQuery("#joblevel_0").hide();
	}else{//总部
		jQuery("#joblevel_0").hide();
		jQuery("#joblevel_1").hide();
	}
}

var isNeedOrgRelation = false;//是否需要组织关系
function changeOrgRelationShow(){
	<%if(isDefaultShare||(trighttype==1&&!isVirtualForm)){%>
		var sharetype = $("select[name=sharetype]").val();
		if(sharetype==3||sharetype==2){//部门     分部
			isNeedOrgRelation = true;
		}else if(sharetype==1000){
			sharetype
			var modefieldtype = $("#modefieldtype").val();
			if(modefieldtype==2||modefieldtype==3){
				isNeedOrgRelation = true;
			}else{
				isNeedOrgRelation = false;
			}
		}else{
			isNeedOrgRelation = false;
		}
		$("#orgrelation").selectbox("detach");
		$("#orgrelation").val("");
		$("#orgrelation").selectbox("attach");
		if(isNeedOrgRelation){
			$("#orgrelationspan").show();
		}else{
			$("#orgrelationspan").hide();
		}
	<%}%>
}

function changeHigherlevel(){
	var thisvalue=$GetEle("sharetype").value;
		var modefieldtype = jQuery("#modefieldtype").val();
		var higherlevel = jQuery("#higherlevel").val();
		if(modefieldtype==1){
			if(higherlevel==3){
				$GetEle("showlevel_tr").style.display='';	//安全级别
			}else{
				$GetEle("showlevel_tr").style.display='none';
			}
		}else{
			$GetEle("showlevel_tr").style.display='';	//安全级别
		}
		if(modefieldtype==1&&(higherlevel==2||higherlevel==3)){
			jQuery("#tr_virtualtype").show();
		}else{
			jQuery("#tr_virtualtype").hide();
		}
	
}

function changeRoleLimited(){
	<%if(isDefaultShare){%>
		var isRoleLimitedTr = jQuery("#isRoleLimitedTr");
		
		var isRoleLimitedTd2 = jQuery("#isRoleLimitedTd2");
		var isRoleLimitedTd3 = jQuery("#isRoleLimitedTd3");
		var isRoleLimitedTd4 = jQuery("#isRoleLimitedTd4");
		
		var isRoleLimited = jQuery("#isRoleLimited");
		isRoleLimitedTr.show();
		if(isRoleLimited.val()==1){
			isRoleLimitedTd2.show();
			isRoleLimitedTd3.show();
			isRoleLimitedTd4.show();
		}else{
			isRoleLimitedTd2.hide();
			isRoleLimitedTd3.hide();
			isRoleLimitedTd4.hide();
		}
		changeRolelevelShow();
	<%}%>
}

function roleFieldTypeChange(){
	var relatedid1001 = jQuery("#rolefield");
	var relatedid1001span = jQuery("#rolefieldspan");
	var relatedid1001spanimg = jQuery("#rolefieldspanimg");
	
	relatedid1001.val("");
	relatedid1001span.html("");
	relatedid1001spanimg.html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
	changeRolelevelShow();
}

function changeRolelevelShow(){
	var isRoleLimited = jQuery("#isRoleLimited").val();
	var rolelevel_tr = jQuery("#rolelevel_tr");
	var rolefieldtype = jQuery("#rolefieldtype").val();
	var sharetype = jQuery("[name=sharetype]").val();
	if(sharetype!=4){
		rolelevel_tr.hide();
		return;
	}
	if(sharetype==4&&isRoleLimited==0){
		rolelevel_tr.show();
		return;
	}
	
	if(sharetype==4&&isRoleLimited==1&&rolefieldtype==1){
		rolelevel_tr.show();
		return;
	}else{
		rolelevel_tr.hide();
		return;
	}
	
}

function openCodeEdit(){
	top.openCodeEdit({
		"type" : "6",
		"filename" : $("#javafilename").val(),
		"formid" : "<%=formId%>"
	}, function(result){
		if(result){
			var fName = result["fileName"];
			$("#javafilename_span").html(fName);
			$("#javafilename").val(fName);
			$(".codeDelFlag").show();
		}
	});
}
function onChangeSharetype1(){
	var righttype=$GetEle("righttype").value;
	if(righttype==1){
		jQuery("#layoutidtdname").html("<%=SystemEnv.getHtmlLabelName(82203,user.getLanguage())%>");//查看布局
	}else if(righttype==3||righttype==2){
		jQuery("#layoutidtdname").html("<%=SystemEnv.getHtmlLabelName(82203,user.getLanguage())%>");//查看布局
	}
	if(righttype == 3||righttype==2){
		$GetEle("layoutid1_tr").style.display='';	
	}else{
		$GetEle("layoutid1_tr").style.display='none';	
	}
}
var prevVal = document.getElementById("modefieldtype").value;

function changeFieldType(obj){
	if(obj.value=='1'){
		jQuery("#higherlevel_tr").show();
	}else{
		jQuery("#higherlevel_tr").hide();
	}
	if(jQuery("#modefieldtype").val()==1&&(jQuery("#higherlevel").val()==2||jQuery("#higherlevel").val()==3)){//人员 
		jQuery("#tr_virtualtype").show();
	}else {
		jQuery("#tr_virtualtype").hide();
	}
	if(prevVal!=null){
		var newVal = document.getElementById("modefieldtype").value;
		if(prevVal!=newVal){
			document.getElementById("relatedid1000").value="";
			document.getElementById("relatedid1000span").innerHTML="";
			document.getElementById("relatedid1000spanimg").innerHTML="<IMG align=absMiddle src='/images/BacoError_wev8.gif'></IMG>";
		}
	}
	prevVal = document.getElementById("modefieldtype").value;
	changeHigherlevel();
	changeOrgRelationShow();
	//$GetEle("showspan").style.display='';	//浏览框
	$GetEle("relatedid").value="";
	$GetEle("showrelatedname").innerHTML="<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
}


function onShowRelated(inputname,spanname){
	var sharetype = $G("sharetype").value;
	var datas = "";
	if(sharetype == '1'){
		datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="+inputname.value);
	}else if(sharetype == '2'){
		datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp?selectedids="+inputname.value+"&selectedDepartmentIds="+inputname.value);
	}else if(sharetype == '3'){
		datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids="+inputname.value);
	}else if(sharetype == '4'){
		datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp");
	}else if(sharetype == '1000'){
		var modefieldtype = jQuery("#modefieldtype").val();
		datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+escape("/formmode/setup/MultiFormmodeShareFieldBrowser.jsp?type="+modefieldtype+"&selectedids="+inputname.value+"&modeId=<%=modeId%>"));
	}
	if (datas != undefined && datas != null) {
		var ids = "";
		var names = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
		if(datas.id != ''){
			if(sharetype != '4' && sharetype != '1000'){
				//ids = datas.id.substring(1);
				//names = datas.name.substring(1);
				ids = datas.id;
				names = datas.name;
			}else{
				ids = datas.id;
				names = datas.name;
			}
			inputname.value = ids;
			spanname.innerHTML = names;
		}else{
			inputname.value = ids;
			spanname.innerHTML = names;
		}
	}
}


function addValue(){
	thisvalue=$GetEle("sharetype").value;
	var shareTypeValue = thisvalue;
	var shareTypeText = $GetEle("sharetype").options.item($GetEle("sharetype").selectedIndex).text;
	var orgrelation = $("#orgrelation").val();
	if(isNeedOrgRelation){
		if(orgrelation==""){
			orgrelation = "0";
		}else{
			var text = $GetEle("orgrelation").options.item($GetEle("orgrelation").selectedIndex).text;
			shareTypeText += " - "+text;
		}
	}else{
		orgrelation = "0";
	}
	//人力资源(1),分部(2),部门(3),角色后的那个选项值不能为空(4)
	var relatedids="0";
	var relatedShareNames="";
	var joblevel = "0";
	var jobleveltext = "0";
	if (thisvalue==1||thisvalue==2||thisvalue==3||thisvalue==4||thisvalue==6||thisvalue==1000) {
		$GetEle("relatedid").value = $GetEle("relatedid"+thisvalue).value;
	    if(!check_form(document.weaver,'relatedid')) {
	        return ;
	    }
	    if (thisvalue == 4){
	        if (!check_form(document.weaver,'rolelevel')){
	            return;
	        }
	        <%if(isDefaultShare){%>
	        	var isRoleLimited = jQuery("#isRoleLimited").val();
	        	if(isRoleLimited==1){
	        		 if (!check_form(document.weaver,'rolefield')){
			            return;
			        }
	        	}
	        <%}%>
	    }
	    if(thisvalue == 6){
	    	joblevel = $GetEle("joblevel").value;
	    	if(joblevel=='0'||joblevel=='1'){
	    		jobleveltext = $GetEle("jobleveltext"+joblevel).value;
	    		$GetEle("jobleveltext").value = jobleveltext;
		    	if (!check_form(document.weaver,'jobleveltext')){
		            return;
		        }
	    	}else{
	    		$GetEle("jobleveltext").value = '';
	    	}
	    }else if(thisvalue == 1000){
	    	var _relatev = jQuery("#modefieldtype").val();
	    	if(_relatev=='4'){//模块主字段-岗位
	    		joblevel = '2';
	    	}
	    }
	    relatedids = $GetEle("relatedid").value;
	    relatedShareNames = $GetEle("relatedid"+thisvalue+"span").innerHTML;
	    if(thisvalue==1000&&jQuery("#modefieldtype").val()==1&&jQuery("#higherlevel").val()!=1){
	    	relatedShareNames="("+jQuery("#HrmCompanyVirtual :selected").text()+")"+relatedShareNames
	    }
	}else if(thisvalue==1001){
		if(!check_form(document.weaver,'javafileAddress')) {
	        return ;
	    }
	    var javafileAddress =$("#javafileAddress").val();
	    var checkAddress=true;
	    if(javafileAddress!=""){
	       var url = "/formmode/setup/codeEditAction.jsp?action=checkFileAddress&javafileAddress="+javafileAddress;
	       $.ajax({
	        url: url,
	        data: "", 
	        dataType: 'json',
	        type: 'POST',
	        async : false,
	        success: function (result) {
	           var status = result.status;
	           if("0"==status){
	             alert("<%=SystemEnv.getHtmlLabelName(382919, user.getLanguage())%>");
	             checkAddress=false;
	            }
	        }
	       });
	    }
	    if(!checkAddress) {
            return ;
        }
	}
	if(thisvalue != 1){
    	if (!check_form(document.weaver,'showlevel'))
            return;
    }
	var showlevelValue="0";
	var showlevelValue2="";
	var showlevelText="";
	var flag = false;
	if (thisvalue!=1&&thisvalue!=1001) {
		if((thisvalue==1000&&jQuery("#modefieldtype").val()=="1")){
			var higherlevel = jQuery("#higherlevel").val();
			if(higherlevel==3){
				flag = true;
			}
		}else{
			flag = true;
		}
		if(flag){
			showlevelValue = $GetEle("showlevel").value;
		    showlevelText = showlevelValue;
		    showlevelValue2 = $GetEle("showlevel2").value;
		    if(showlevelValue2!=""&&!isNaN(showlevelValue2)){
		    	showlevelText += " - "+showlevelValue2;
		    }else{
		    	showlevelValue2 = "";
		    }
		}
	}
	var rolelevelValue=0;
	var rolelevelText="";
	if (thisvalue==4){  //角色  0:部门   1:分部  2:总部
	   	rolelevelValue = $GetEle("rolelevel").value;
	    	rolelevelText = $GetEle("rolelevel").options.item($GetEle("rolelevel").selectedIndex).text;
	}else if(thisvalue==6){
		var joblevelspan = '';
		if(joblevel=='0'||joblevel=='1'){
			joblevelspan = '('+$GetEle("jobleveltext"+joblevel+"span").innerHTML+')';
		}
		rolelevelText = $GetEle("joblevel").options.item($GetEle("joblevel").selectedIndex).text+joblevelspan;
	}
	//上级关系
	var higherlevelValue = 0;
	var higherlevelText = "";
	if (thisvalue==1000 && jQuery("#modefieldtype").val()==1){
	     higherlevelValue = $GetEle("higherlevel").value;
	     higherlevelText = "("+$GetEle("higherlevel").options.item($GetEle("higherlevel").selectedIndex).text+")";
	}
	
	//导入类型
	var  importtypeValue =0;
	var  importtypeText ="";
	<%if(trighttype == 4){%>
	   importtypeValue =  $GetEle("importtype").value;
	   importtypeText = "/"+$GetEle("importtype").options.item($GetEle("importtype").selectedIndex).text;
	<%}%>
	
	var righttypeValue =  $GetEle("righttype").value;
	var righttypelText = $GetEle("righttype").options.item($GetEle("righttype").selectedIndex).text;
	//var javaFileName=jQuery("#javafilename").val();
	var javaFileName=" "; 
	var javafileAddress=jQuery("#javafileAddress").val();
	
	var layoutid,layoutid1,layoutorder;
	if($GetEle("layoutid")!=null){
		layoutid = $GetEle("layoutid").value
	}
	if($GetEle("layoutid1")!=null){
		layoutid1 = $GetEle("layoutid1").value
	}
	if($GetEle("layoutorder")!=null){
		layoutorder = $GetEle("layoutorder").value
	}
	if(layoutid==null||layoutid==''){
		layoutid = 0;
	}
	if(layoutid1==null||layoutid1==''){
		layoutid1 = 0;
	}
	if(layoutorder==null||layoutorder==''){
		layoutorder = 0;
	}
	
	//共享类型 + 共享者ID +共享角色级别 +共享级别+共享权限+下载权限(TD12005)+javaFileNameChanged+布局ID+布局ID2+布局级别
	//当为默认共享时：   +角色是否受范围限制+范围字段类型+角色限制字段
	var javaFileNameChanged=javaFileName.replace(/\_/g,"#");
	if(javaFileNameChanged==""){
		javaFileNameChanged = "0";
	}
	if(javafileAddress==""){
	    javafileAddress="0";
	}
	var totalValue=shareTypeValue+"_"+relatedids+"_"+rolelevelValue+"_"+showlevelValue;
	if(showlevelValue2!=""){
		totalValue +="$"+showlevelValue2;
	}
	var hrmCompanyVirtualValue = jQuery("#HrmCompanyVirtual").val();
	totalValue += "_"+righttypeValue+"_"+righttypelText+"_"+layoutid+"_"+layoutid1+"_"+layoutorder+"_"+javaFileNameChanged+"_"+higherlevelValue+"_"+importtypeValue+"_"+hrmCompanyVirtualValue+"_"+orgrelation;
	totalValue += "_"+joblevel+"_"+jobleveltext;
	<%if(isDefaultShare){%>
		var isRoleLimited = jQuery("#isRoleLimited").val();
		if(isRoleLimited==1){
			var tempRoleValue = "1";
			var rolefieldtype = jQuery("#rolefieldtype").val();
			var rolefield = jQuery("#rolefield").val();
			tempRoleValue += "_"+rolefieldtype+"_"+rolefield;
			totalValue += "_"+tempRoleValue;
		}else{
			var tempRoleValue = "0";
			totalValue += "_"+tempRoleValue;
		}
	<%}%>
	totalValue += "_"+javafileAddress;
	
	var oRow = oTable.insertRow(-1);
	var oRowIndex = oRow.rowIndex;
	
	if (oRowIndex%2==0) oRow.className="dataLight";
	else oRow.className="dataDark";
	for (var i =1; i <7; i++) {   //生成一行中的每一列
		oCell = oRow.insertCell(-1);
		var oDiv = document.createElement("div");
		if (i==1) oDiv.innerHTML="<input class='inputStyle' type='checkbox' name='chkShareDetail' value='"+totalValue+"'><input type='hidden' name='txtShareDetail' value='"+totalValue+"'>";
		else if (i==2) oDiv.innerHTML=shareTypeText;
		else  if (i==3) oDiv.innerHTML=relatedShareNames+higherlevelText+importtypeText;
		else  if (i==4) oDiv.innerHTML=rolelevelText;
		else  if (i==5) {
			if (showlevelText=="0") {
				showlevelText="";
			}
			
			oDiv.innerHTML=showlevelText;
		}
		else  if (i==6) oDiv.innerHTML=righttypelText;
		oCell.appendChild(oDiv);
	}
	
	jQuery("#oTable").jNice();
}

function removeValue(){
    var chks = document.getElementsByName("chkShareDetail");
    for (var i=chks.length-1;i>=0;i--){
        var chk = chks[i];
        if (chk.checked)
            oTable.deleteRow(chk.parentElement.parentElement.parentElement.parentElement.rowIndex);
    }
}

function chkAllClick(obj){
    var chks = document.getElementsByName("chkShareDetail");
    for (var i=0;i<chks.length;i++){
        var chk = chks[i];
        changeCheckboxStatus(chk, obj.checked);
    }
}

function doSave(obj){
   var javafileAddress =$("#javafileAddress").val();
   var checkAddress=true;
   if(javafileAddress!=""){
       var url = "/formmode/setup/codeEditAction.jsp?action=checkFileAddress&javafileAddress="+javafileAddress;
       $.ajax({
        url: url,
        data: "", 
        dataType: 'json',
        type: 'POST',
        async : false,
        success: function (result) {
           var status = result.status;
           if("0"==status){
             alert("<%=SystemEnv.getHtmlLabelName(382919, user.getLanguage())%>");
             checkAddress=false;
            }
        }
       });
    } 
    if (checkAddress){
        obj.disabled=true;
        weaver.submit();
    }
}
function onShowModeBrowser(ids,spans,type){
	var righttype=$GetEle("righttype").value;
	var layouttype = -1;
	//新建权限
	if(righttype==0){
		layouttype = 1;
	}else if(righttype==1){
		//查看权限
		layouttype = 0;
	}else if(righttype==3||righttype==2){
		//完全控制
		if(type==0){
			layouttype=0;
		}else{
			layouttype=2;
		}
	}else if(righttype==4){
		//监控
		layouttype = 3;
	}
	
	urls = "/formmode/setup/FormModeHtmlBrowser.jsp?modeId=<%=modeId%>&formId=<%=layoutformId%>&type="+layouttype+"&comfrom=right";
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
					jQuery("#"+spans).html("<a href=\"#\" onclick=\"onshowExcelDesign("+layouttype+","+layoutid+")\">"+datas.name+"</a>");
				}else{
					jQuery("#"+spans).html("<a href=\"#\" onclick=\"openFullWindowHaveBar('/formmode/setup/LayoutEdit.jsp?type="+layouttype+"&modeId=<%=modeId%>&formId=<%=layoutformId%>&Id="+layoutid+"')\">"+datas.name+"</a>");
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

function downloadMode(){
      top.location='/weaver/weaver.formmode.data.FileDownload?type=6';
}
</script>

</BODY>
</HTML>
