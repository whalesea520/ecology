<!DOCTYPE html>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/browser" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CompanyVirtualComInfo" class="weaver.hrm.companyvirtual.CompanyVirtualComInfo" scope="page" />
<jsp:useBean id="WFNodeOperatorManager" class="weaver.workflow.workflow.WFNodeOperatorManager" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />
<jsp:useBean id="CustomerStatusComInfo" class="weaver.crm.Maint.CustomerStatusComInfo" scope="page" />
<jsp:useBean id="WFNodeMainManager" class="weaver.workflow.workflow.WFNodeMainManager" scope="page" />
<jsp:useBean id="FormFieldTransMethod" class="weaver.general.FormFieldTransMethod" scope="page" />
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<%
 String ajax=Util.null2String(request.getParameter("ajax"));
%>

<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.bgiframe.min_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.ajaxQueue_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>
<%
int design = Util.getIntValue(request.getParameter("design"),0);
int isview = Util.getIntValue(Util.null2String(request.getParameter("isview")),0);
int nodeid=Util.getIntValue(Util.null2String(request.getParameter("nodeid")),0);
int wfid=Util.getIntValue(Util.null2String(request.getParameter("wfid")),0);
int formid=Util.getIntValue(Util.null2String(request.getParameter("formid")),0);
String isbill=Util.null2String(request.getParameter("isbill"));
String iscust=Util.null2String(request.getParameter("iscust"));
int id=Util.getIntValue(Util.null2String(request.getParameter("id")),0);
String nodetype=Util.null2String(request.getParameter("nodetype"));
char flag=2;
int iscreate = 0;
String groupname = Util.null2String(WFNodeOperatorManager.getName());
String sql = "";
ArrayList nodeids = new ArrayList() ;
ArrayList nodenames = new ArrayList() ;
WFNodeMainManager.setWfid(wfid);
WFNodeMainManager.selectWfNode();
while(WFNodeMainManager.next()){
	int tmpid = WFNodeMainManager.getNodeid();
	String tmpname = WFNodeMainManager.getNodename();
	nodeids.add(""+tmpid) ;
	nodenames.add(tmpname) ;
}
WFNodeMainManager.closeStatement();

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


<%-- 文档字段 start --%>
<div id=odiv_3 style="display:none">
<wea:layout needImportDefaultJsAndCss="false" type="4col" attributes="{'cw1':'20%','cw2':'30%','cw3':'20%','cw4':'30%'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(106,user.getLanguage())%>'>
		<!-- 文档字段所有者 @author Dracula 2014-7-18 -->
		<wea:item><input type=radio onClick="setSelIndex('10','8')" name=tmptype id='tmptype_10' value=8><%=SystemEnv.getHtmlLabelName(15564,user.getLanguage())%></wea:item>
		<wea:item>
			<select class=inputstyle  name=id_10 onfocus="changelevel(tmptype_10)" style="float:left;">
			<%
  	  			sql ="" ;

		  		if(isbill.equals("0"))
			  		sql = "select workflow_formdict.id as id,workflow_fieldlable.fieldlable as name from workflow_formdict,workflow_formfield,workflow_fieldlable where  workflow_fieldlable.isdefault=1 and workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.fieldid = workflow_formfield.fieldid and workflow_formfield.fieldid = workflow_formdict.id and workflow_formdict.fieldhtmltype=3 and workflow_formdict.type = 9 and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formfield.formid="+formid;
	  			else
			  		sql = "select id as id , fieldlabel as name from workflow_billfield where billid="+ formid+ " and fieldhtmltype = '3' and type=9 and viewtype = 0 " ;

		  		RecordSet.executeSql(sql);
		  		while(RecordSet.next()){
		  		%>
		  			<option value=<%=RecordSet.getString("id")%>>
		  				<% if(isbill.equals("0")) {%> <%=RecordSet.getString("name")%>
			  			<%} else {%> <%=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage())%> <%}%>
		  			</option>
			<%}%>
			</select>
		</wea:item>
		<wea:item></wea:item>
		<wea:item><input type=text class=Inputstyle name=level_10 style="display:none"></wea:item>
		
		<!-- 文档字段分部 @author Dracula 2014-7-18 -->
		<wea:item><input type=radio onClick="setSelIndex('11','33')" name=tmptype id='tmptype_11' value=33><%=SystemEnv.getHtmlLabelName(15565,user.getLanguage())%></wea:item>
		<wea:item>
			<select class=inputstyle  name=id_11 onfocus="changelevel(tmptype_11)" style="float:left;">
  			<%
  				RecordSet.beforFirst();
		  		while(RecordSet.next()){
		  	%>
		  		<option value=<%=RecordSet.getString("id")%>>
		  			<% if(isbill.equals("0")) {%> <%=RecordSet.getString("name")%>
					<%} else {%> <%=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage())%> <%}%>
				</option>
		  	<%}%>
		  	</select>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></wea:item>
		<wea:item>
			<input type=text class=Inputstyle name=level_11  onfocus="changelevel(tmptype_11)" style="width:60px;" value=0> -
    		<input type=text class=Inputstyle name=level2_11  onfocus="changelevel(tmptype_11)" style="width:60px;" value=100>
   		</wea:item>
		
		<!-- 文档字段部门 @author Dracula 2014-7-18 -->
		<wea:item><input type=radio onClick="setSelIndex('12','9')" name=tmptype id='tmptype_12' value=9><%=SystemEnv.getHtmlLabelName(15566,user.getLanguage())%></wea:item>
		<wea:item>
			<select class=inputstyle  name=id_12 onfocus="changelevel(tmptype_12)" style="float:left;">
  			<%
		  		RecordSet.beforFirst();
		  		while(RecordSet.next()){
		  	%>
		  			<option value=<%=RecordSet.getString("id")%>>
		  				<% if(isbill.equals("0")) {%> <%=RecordSet.getString("name")%>
			 	 		<%} else {%> <%=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage())%> <%}%>
		 	 		</option>
	  		<%}%>
		  	</select>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></wea:item>
		<wea:item>
			<input type=text class=Inputstyle name=level_12  onfocus="changelevel(tmptype_12)" style="width:60px;" value=0> -
    		<input type=text class=Inputstyle name=level2_12  onfocus="changelevel(tmptype_12)" style="width:60px;" value=100>
		</wea:item>
	</wea:group>
</wea:layout>
</div>
<%-- 文档字段 end --%>

<%-- 项目字段 start --%>
<div id=odiv_4 style="display:none">
<wea:layout needImportDefaultJsAndCss="false" type="4col" attributes="{'cw1':'20%','cw2':'30%','cw3':'20%','cw4':'30%'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(106,user.getLanguage())%>'>
		<!-- 项目字段经理 @author Dracula 2014-7-18 -->
		<wea:item><input type=radio onClick="setSelIndex('13','10')" name=tmptype id='tmptype_13' value=10><%=SystemEnv.getHtmlLabelName(15567,user.getLanguage())%></wea:item>
		<wea:item>
			<select class=inputstyle  name=id_13 onfocus="changelevel(tmptype_13)" style="float:left;">
  			<%
  	  			sql ="" ;
		  		if(isbill.equals("0"))
			  		sql = "select workflow_formdict.id as id,workflow_fieldlable.fieldlable as name from workflow_formdict,workflow_formfield,workflow_fieldlable where  workflow_fieldlable.isdefault=1 and workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.fieldid = workflow_formfield.fieldid and workflow_formfield.fieldid = workflow_formdict.id and workflow_formdict.fieldhtmltype=3 and workflow_formdict.type = 8 and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formfield.formid="+formid;
		  		else
			  		sql = "select id as id , fieldlabel as name from workflow_billfield where billid="+ formid+ " and fieldhtmltype = '3' and type=8 and viewtype = 0 " ;

		  		RecordSet.executeSql(sql);
		  		while(RecordSet.next()){
		  	%>
		  		<option value=<%=RecordSet.getString("id")%>>
		  			<% if(isbill.equals("0")) {%> <%=RecordSet.getString("name")%>
			  		<%} else {%> <%=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage())%> <%}%>
		  		</option>
		  	<%}%>
		  	</select>
		</wea:item>
		<wea:item></wea:item>
		<wea:item><input type=text class=Inputstyle name=level_13 style="display:none"></wea:item>
		
		<!-- 项目字段经理的经理 @author Dracula 2014-7-18 -->
		<wea:item><input type=radio onClick="setSelIndex('47','47')" name=tmptype id='tmptype_47' value=47><%=SystemEnv.getHtmlLabelName(18680, user.getLanguage())%></wea:item>
		<wea:item>
			<select class=inputstyle  name=id_47 onfocus="changelevel(tmptype_47)" style="float:left;"> 
  			<%
		  		RecordSet.beforFirst();
		  		while(RecordSet.next()){
		  	%>
		  		<option value=<%=RecordSet.getString("id")%>>
		  			<% if(isbill.equals("0")) {%> <%=RecordSet.getString("name")%>
			  		<%} else {%> <%=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage())%> <%}%>
		  		</option>
		  	<%}%>
		  	</select>
		</wea:item>
		<wea:item></wea:item>
		<wea:item><input type=text class=Inputstyle name=level_47 style="display:none"></wea:item>
		
		<!-- 项目字段分部 @author Dracula 2014-7-18 -->
		<wea:item><input type=radio onClick="setSelIndex('14','34')" name=tmptype id='tmptype_14' value=34><%=SystemEnv.getHtmlLabelName(15568,user.getLanguage())%></wea:item>
		<wea:item>
			<select class=inputstyle  name=id_14 onfocus="changelevel(tmptype_14)" style="float:left;">
  			<%
		  		RecordSet.beforFirst();
		  		while(RecordSet.next()){
		  	%>
		  		<option value=<%=RecordSet.getString("id")%>>
		  			<% if(isbill.equals("0")) {%> <%=RecordSet.getString("name")%>
			  	<%} else {%> <%=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage())%> <%}%>
			  	</option>
		  	<%}%>
		  	</select>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></wea:item>
		<wea:item>
			<input type=text class=Inputstyle name=level_14  onfocus="changelevel(tmptype_14)" style="width:60px;" value=0> -
    	<input type=text class=Inputstyle name=level2_14  onfocus="changelevel(tmptype_14)" style="width:60px;" value=100>
		</wea:item>
		
		<!-- 项目字段部门 @author Dracula 2014-7-18 -->
		<wea:item><input type=radio onClick="setSelIndex('15','11')" name=tmptype id='tmptype_15' value=11><%=SystemEnv.getHtmlLabelName(15569,user.getLanguage())%></wea:item>
		<wea:item>
			<select class=inputstyle  name=id_15 onfocus="changelevel(tmptype_15)" style="float:left;">
  			<%
  				RecordSet.beforFirst();
		  		while(RecordSet.next()){
		  	%>
		  		<option value=<%=RecordSet.getString("id")%>>
		  			<% if(isbill.equals("0")) {%> <%=RecordSet.getString("name")%>
			  		<%} else {%> <%=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage())%> <%}%>
		  		</option>
		  	<%}%>
		  	</select>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></wea:item>
		<wea:item>
			<input type=text class=Inputstyle name=level_15  onfocus="changelevel(tmptype_15)" style="width:60px;" value=0> -
    		<input type=text class=Inputstyle name=level2_15  onfocus="changelevel(tmptype_15)" style="width:60px;" value=100>
		</wea:item>
		
		<!-- 项目字段成员 @author Dracula 2014-7-18 -->
		<wea:item><input type=radio onClick="setSelIndex('16','12')" name=tmptype id='tmptype_16' value=12><%=SystemEnv.getHtmlLabelName(15570,user.getLanguage())%></wea:item>
		<wea:item>
			<select class=inputstyle  name=id_16 onfocus="changelevel(tmptype_16)" style="float:left;">
  			<%
		  		RecordSet.beforFirst();
		  		while(RecordSet.next()){
	  		%>
		  		<option value=<%=RecordSet.getString("id")%>>
		  			<% if(isbill.equals("0")) {%> <%=RecordSet.getString("name")%>
			  		<%} else {%> <%=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage())%> <%}%>
	  			</option>
		  	<%}%>
		  	</select>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></wea:item>
		<wea:item>
			<input type=text class=Inputstyle name=level_16  onfocus="changelevel(tmptype_16)" style="width:60px;" value=0> -
    		<input type=text class=Inputstyle name=level2_16  onfocus="changelevel(tmptype_16)" style="width:60px;" value=100>
		</wea:item>
	</wea:group>
</wea:layout>
</div>
<%-- 项目字段 end --%>

<%-- 资产字段 start --%>
<div id=odiv_5 style="display:none">
<wea:layout needImportDefaultJsAndCss="false" type="4col" attributes="{'cw1':'20%','cw2':'30%','cw3':'20%','cw4':'30%'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(106,user.getLanguage())%>'>
		<!-- 资产字段管理员 @author Dracula 2014-7-18 -->
		<wea:item><input type=radio onClick="setSelIndex('17','13')" name=tmptype id='tmptype_17' value=13><%=SystemEnv.getHtmlLabelName(15571,user.getLanguage())%></wea:item>
		<wea:item>
			<select class=inputstyle  name=id_17 onfocus="changelevel(tmptype_17)" style="float:left;">
			<%
  	  			sql ="" ;
			  	if(isbill.equals("0"))
				  	sql = "select workflow_formdict.id as id,workflow_fieldlable.fieldlable as name from workflow_formdict,workflow_formfield,workflow_fieldlable where  workflow_fieldlable.isdefault=1 and workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.fieldid = workflow_formfield.fieldid and workflow_formfield.fieldid = workflow_formdict.id and workflow_formdict.fieldhtmltype=3 and workflow_formdict.type = 23 and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formfield.formid="+formid;
			  	else
				  	sql = "select id as id , fieldlabel as name from workflow_billfield where billid="+ formid+ " and fieldhtmltype = '3' and type=23 and viewtype = 0 " ;
	
			  	RecordSet.executeSql(sql);
			  	while(RecordSet.next()){
		  	%>
			  	<option value=<%=RecordSet.getString("id")%>>
			  		<% if(isbill.equals("0")) {%> <%=RecordSet.getString("name")%>
				  	<%} else {%> <%=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage())%> <%}%>
			  	</option>
			<%}%>
			</select>
		</wea:item>
		<wea:item></wea:item>
		<wea:item><input type=text class=Inputstyle name=level_17 style="display:none"></wea:item>
		
		<!-- 资产字段分部 @author Dracula 2014-7-18 -->
		<wea:item><input type=radio onClick="setSelIndex('18','35')" name=tmptype id='tmptype_18' value=35><%=SystemEnv.getHtmlLabelName(15572,user.getLanguage())%></wea:item>
		<wea:item>
			<select class=inputstyle  name=id_18 onfocus="changelevel(tmptype_18)" style="float:left;">
  			<%
			 	RecordSet.beforFirst();
		  		while(RecordSet.next()){
		  	%>
		  		<option value=<%=RecordSet.getString("id")%>>
		  			<% if(isbill.equals("0")) {%> <%=RecordSet.getString("name")%>
			  		<%} else {%> <%=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage())%> <%}%>
			  	</option>
		  	<%}%>
		  	</select>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></wea:item>
		<wea:item>
			<input type=text class=Inputstyle name=level_18  onfocus="changelevel(tmptype_18)" style="width:60px;" value=0> -
    		<input type=text class=Inputstyle name=level2_18  onfocus="changelevel(tmptype_18)" style="width:60px;" value=100>
		</wea:item>
		
		<!-- 资产字段部门 @author Dracula 2014-7-18 -->
		<wea:item><input type=radio onClick="setSelIndex('19','14')" name=tmptype id='tmptype_19' value=14><%=SystemEnv.getHtmlLabelName(15573,user.getLanguage())%></wea:item>
		<wea:item>
			<select class=inputstyle  name=id_19 onfocus="changelevel(tmptype_19)" style="float:left;">
  			<%
  				RecordSet.beforFirst();
		  		while(RecordSet.next()){
		  	%>
		  		<option value=<%=RecordSet.getString("id")%>>
		  			<% if(isbill.equals("0")) {%> <%=RecordSet.getString("name")%>
					<%} else {%> <%=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage())%> <%}%>
				</option>
		  	<%}%>
		  	</select>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></wea:item>
		<wea:item>
			<input type=text class=Inputstyle name=level_19  onfocus="changelevel(tmptype_19)" style="width:60px;" value=0> -
    		<input type=text class=Inputstyle name=level2_19  onfocus="changelevel(tmptype_19)" style="width:60px;" value=100>
		</wea:item>
	</wea:group>
</wea:layout>
</div>
<%-- 资产字段 end --%>

<%-- 客户字段 start --%>
<div id=odiv_6 style="display:none">
<wea:layout needImportDefaultJsAndCss="false" type="4col" attributes="{'cw1':'20%','cw2':'30%','cw3':'20%','cw4':'30%'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(106,user.getLanguage())%>'>
		<!-- 客户字段经理 @author Dracula 2014-7-18 -->
		<wea:item><input type=radio onClick="setSelIndex('20','15')" name=tmptype id='tmptype_20' value=15><%=SystemEnv.getHtmlLabelName(15574,user.getLanguage())%></wea:item>
		<wea:item>
			<select class=inputstyle  name=id_20 onfocus="changelevel(tmptype_20)" style="float:left;">
  			<%
  	  			sql ="" ;
  				if(isbill.equals("0"))
			  		sql = "select workflow_formdict.id as id,workflow_fieldlable.fieldlable as name from workflow_formdict,workflow_formfield,workflow_fieldlable where  workflow_fieldlable.isdefault=1 and workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.fieldid = workflow_formfield.fieldid and workflow_formfield.fieldid = workflow_formdict.id and workflow_formdict.fieldhtmltype=3 and workflow_formdict.type = 7 and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formfield.formid="+formid;
		  		else
			  		sql = "select id as id , fieldlabel as name from workflow_billfield where billid="+ formid+ " and fieldhtmltype = '3' and type=7 and viewtype = 0 " ;
				RecordSet.executeSql(sql);
		  		while(RecordSet.next()){
		  	%>
		  		<option value=<%=RecordSet.getString("id")%>>
		  			<% if(isbill.equals("0")) {%> <%=RecordSet.getString("name")%>
			  		<%} else {%> <%=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage())%> <%}%>
		  		</option>
		  	<%}%>
		  	</select>
		</wea:item>
		<wea:item></wea:item>
		<wea:item><input type=text class=Inputstyle name=level_20 style="display:none"></wea:item>
		
		<!-- 客户字段经理的经理 @author Dracula 2014-7-18 -->
		<wea:item><input type=radio onClick="setSelIndex('44','44')" name=tmptype id='tmptype_44' value=44><%=SystemEnv.getHtmlLabelName(17204,user.getLanguage())%></wea:item>
		<wea:item>
			<select class=inputstyle  name=id_44 onfocus="changelevel(tmptype_44)" style="float:left;">
  			<%
		  		RecordSet.beforFirst();
		  		while(RecordSet.next()){
		  	%>
		  		<option value=<%=RecordSet.getString("id")%>>
		  			<% if(isbill.equals("0")) {%> <%=RecordSet.getString("name")%>
			  		<%} else {%> <%=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage())%> <%}%>
		  		</option>
		  	<%}%>
		  	</select>
		</wea:item>
		<wea:item></wea:item>
		<wea:item><input type=text class=Inputstyle name=level_44 style="display:none"></wea:item>
		
		<!-- 客户字段分部 @author Dracula 2014-7-18 -->
		<wea:item><input type=radio onClick="setSelIndex('45','45')" name=tmptype id='tmptype_45' value=45><%=SystemEnv.getHtmlLabelName(18678, user.getLanguage())%></wea:item>
		<wea:item>
			<select class=inputstyle  name=id_45 onfocus="changelevel(tmptype_45)" style="float:left;">
  			<%
		  		RecordSet.beforFirst();
		  		while(RecordSet.next()){
		  	%>
		  		<option value=<%=RecordSet.getString("id")%>>
		  			<% if(isbill.equals("0")) {%> <%=RecordSet.getString("name")%>
			  		<%} else {%> <%=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage())%> <%}%>
		  		</option>
		  	<%}%>
		  	</select>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></wea:item>
		<wea:item>
			<input type=text class=Inputstyle name=level_45  onfocus="changelevel(tmptype_45)" style="width:60px;" value=0> -
    		<input type=text class=Inputstyle name=level2_45  onfocus="changelevel(tmptype_45)" style="width:60px;" value=100>
		</wea:item>
		
		<!-- 客户字段部门 @author Dracula 2014-7-18 -->
		<wea:item><input type=radio onClick="setSelIndex('46','46')" name=tmptype id='tmptype_46' value=46><%=SystemEnv.getHtmlLabelName(18679, user.getLanguage())%></wea:item>
		<wea:item>
			<select class=inputstyle  name=id_46 onfocus="changelevel(tmptype_46)" style="float:left;">
			<%
		  		RecordSet.beforFirst();
		  		while(RecordSet.next()){
		  	%>
		  		<option value=<%=RecordSet.getString("id")%>>
		  			<% if(isbill.equals("0")) {%> <%=RecordSet.getString("name")%>
			  		<%} else {%> <%=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage())%> <%}%>
		  		</option>
		  	<%}%>
		  	</select>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></wea:item>
		<wea:item>
			<input type=text class=Inputstyle name=level_46  onfocus="changelevel(tmptype_46)" style="width:60px;" value=0> -
	    	<input type=text class=Inputstyle name=level2_46  onfocus="changelevel(tmptype_46)" style="width:60px;" value=100>
		</wea:item>
		
		<!-- 客户字段联系人经理 @author Dracula 2014-7-18 -->
		<wea:item><input type=radio onClick="setSelIndex('21','16')" name=tmptype id='tmptype_21' value=16><%=SystemEnv.getHtmlLabelName(15575,user.getLanguage())%></wea:item>
		<wea:item>
			<select class=inputstyle  name=id_21 onfocus="changelevel(tmptype_21)" style="float:left;">
  			<%
  				RecordSet.beforFirst();
		  		while(RecordSet.next()){
		  	%>
		  		<option value=<%=RecordSet.getString("id")%>>
		  			<% if(isbill.equals("0")) {%> <%=RecordSet.getString("name")%>
			  		<%} else {%> <%=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage())%> <%}%>
	  			</option>
		  	<%}%>
		  	</select>
		</wea:item>
		<wea:item></wea:item>
		<wea:item><input type=text class=Inputstyle name=level_21 style="display:none"></wea:item>
	</wea:group>
</wea:layout>
</div>
<%-- 客户字段 end --%>

<%-- 创建人 start --%>
<div id=odiv_7 style="display:none">
<wea:layout needImportDefaultJsAndCss="false" type="4col" attributes="{'cw1':'20%','cw2':'30%','cw3':'20%','cw4':'30%'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(106,user.getLanguage())%>'>
		<!-- 创建人本人 @author Dracula 2014-7-18 -->
		<wea:item><input type=radio onClick="setSelIndex('22','17')" name=tmptype id='tmptype_22' value=17><%=SystemEnv.getHtmlLabelName(15079,user.getLanguage())%></wea:item>
		<wea:item><input type=text class=Inputstyle name=id_22 style="display:none"></wea:item>
		<wea:item></wea:item>
		<wea:item><input type=text class=Inputstyle name=level_22 style="display:none"></wea:item>
		
		<!-- 创建人经理 @author Dracula 2014-7-18 -->
		<wea:item><input type=radio onClick="setSelIndex('23','18')" name=tmptype id='tmptype_23' value=18><%=SystemEnv.getHtmlLabelName(15080,user.getLanguage())%></wea:item>
		<wea:item>
			<input type=text class=Inputstyle name=id_23 style="display:none">
			<%if(CompanyVirtualComInfo.getCompanyNum()>0){ %>
  				<select class=inputstyle id='id_23_1' style="float:left;">
					<%=VirtualOrganization%>
  				</select>
			<%}%>
		</wea:item>
		<wea:item></wea:item>
		<wea:item><input type=text class=Inputstyle name=level_23 style="display:none"></wea:item>
		
		<!-- 创建人下属 @author Dracula 2014-7-18 -->
		<wea:item><input type=radio onClick="setSelIndex('24','36')" name=tmptype id='tmptype_24' value=36><%=SystemEnv.getHtmlLabelName(15576,user.getLanguage())%></wea:item>
		<wea:item>
			<input type=text class=Inputstyle name=id_24 style="display:none">
			<%if(CompanyVirtualComInfo.getCompanyNum()>0){ %>
  				<select class=inputstyle id='id_24_1' style="float:left;">
					<%=VirtualOrganization%>
  				</select>
			<%}%>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></wea:item>
		<wea:item>
			<input type=text class=Inputstyle name=level_24  onfocus="changelevel(tmptype_24)" style="width:60px;" value=0> -
    		<input type=text class=Inputstyle name=level2_24  onfocus="changelevel(tmptype_24)" style="width:60px;" value=100>
		</wea:item>
		
		<!-- 创建人本分部 @author Dracula 2014-7-18 -->
		<wea:item><input type=radio onClick="setSelIndex('25','37')" name=tmptype id='tmptype_25' value=37><%=SystemEnv.getHtmlLabelName(15577,user.getLanguage())%></wea:item>
		<wea:item>
			<input type=text class=Inputstyle name=id_25 style="display:none">
			<%if(CompanyVirtualComInfo.getCompanyNum()>0){ %>
  				<select class=inputstyle id='id_25_1' style="float:left;">
					<%=VirtualOrganization%>
  				</select>
			<%}%>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></wea:item>
		<wea:item>
			<input type=text class=Inputstyle name=level_25  onfocus="changelevel(tmptype_25)" style="width:60px;" value=0> -
    		<input type=text class=Inputstyle name=level2_25  onfocus="changelevel(tmptype_25)" style="width:60px;" value=100>
		</wea:item>
		
		<!-- 创建人本部门 @author Dracula 2014-7-18 -->
		<wea:item><input type=radio onClick="setSelIndex('26','19')" name=tmptype id='tmptype_26' value=19><%=SystemEnv.getHtmlLabelName(15081,user.getLanguage())%></wea:item>
		<wea:item>
			<input type=text class=Inputstyle name=id_26 style="display:none">
			<%if(CompanyVirtualComInfo.getCompanyNum()>0){ %>
  				<select class=inputstyle id='id_26_1' style="float:left;">
					<%=VirtualOrganization%>
  				</select>
			<%}%>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></wea:item>
		<wea:item>
			<input type=text class=Inputstyle name=level_26  onfocus="changelevel(tmptype_26)" style="width:60px;" value=0> -
    		<input type=text class=Inputstyle name=level2_26  onfocus="changelevel(tmptype_26)" style="width:60px;" value=100>
		</wea:item>
		
		<!-- 创建人上级部门 @author Dracula 2014-7-18 -->
		<wea:item><input type=radio onClick="setSelIndex('39','39')" name=tmptype id='tmptype_39' value=39><%=SystemEnv.getHtmlLabelName(15578,user.getLanguage())%></wea:item>
		<wea:item>
			<input type=text class=Inputstyle name=id_39 style="display:none">
			<%if(CompanyVirtualComInfo.getCompanyNum()>0){ %>
  				<select class=inputstyle id='id_39_1' style="float:left;">
					<%=VirtualOrganization%>
  				</select>
			<%}%>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></wea:item>
		<wea:item>
			<input type=text class=Inputstyle name=level_39  onfocus="changelevel(tmptype_39)" style="width:60px;" value=0> -
    		<input type=text class=Inputstyle name=level2_39  onfocus="changelevel(tmptype_39)" style="width:60px;" value=100>
		</wea:item>
		
		<!-- 创建人本岗位 -->
		<wea:item><input type=radio onClick="setSelIndex('61','61')" name=tmptype id='tmptype_61' value=61><%=SystemEnv.getHtmlLabelName(126610,user.getLanguage())%></wea:item>
		<wea:item>
			<input type=text class=Inputstyle name=id_61 style="display:none">
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(34216,user.getLanguage())%></wea:item>
		<wea:item>
			<select class=inputstyle  name=level_61  onclick="changelevel(tmptype_61)" style="float:left;width:110px">
				<option value=0 selected><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%></option>
				<option value=1 ><%=SystemEnv.getHtmlLabelName(21837,user.getLanguage())%></option>
				<option value=2 ><%=SystemEnv.getHtmlLabelName(126607,user.getLanguage())%></option>
				<option value=3 ><%=SystemEnv.getHtmlLabelName(126608,user.getLanguage())%></option>
				<option value=4 ><%=SystemEnv.getHtmlLabelName(30792,user.getLanguage())%></option>
				<option value=5 ><%=SystemEnv.getHtmlLabelName(19436,user.getLanguage())%></option>
				<option value=6 ><%=SystemEnv.getHtmlLabelName(27189,user.getLanguage())%></option>
			</select>
		</wea:item>
	</wea:group>
</wea:layout>
</div>
<%-- 创建人 end --%>

<%-- 客户门户相关 start --%>
<div id=odiv_8 style="display:none;">
<wea:layout needImportDefaultJsAndCss="false" type="4col" attributes="{'cw1':'20%','cw2':'30%','cw3':'20%','cw4':'30%'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(106,user.getLanguage())%>'>
		<!-- 客户类型 @author Dracula 2014-7-18 -->
		<wea:item><input type=radio onClick="setSelIndex('27','20')" name=tmptype id='tmptype_27' value=20><%=SystemEnv.getHtmlLabelName(1282,user.getLanguage())%></wea:item>
		<wea:item>
			<select class=inputstyle  name=id_27 onfocus="changelevel(tmptype_27)">
  			<%
  				RecordSet.executeProc("CRM_CustomerType_SelectAll","");
		  		while(RecordSet.next()){
		  	%>
		  		<option value=<%=RecordSet.getString("id")%>><%=Util.toScreen(RecordSet.getString("fullname"),user.getLanguage())%>
		  		</option>
		  	<%}%>
		  	</select>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></wea:item>
		<wea:item>
			<input type=text class=Inputstyle name=level_27  onfocus="changelevel(tmptype_27)" style="width:60px;" value=0> -
    		<input type=text class=Inputstyle name=level2_27  onfocus="changelevel(tmptype_27)" style="width:60px;" value=100>
		</wea:item>
		
		<!-- 客户状态 @author Dracula 2014-7-18 -->
		<wea:item><input type=radio onClick="setSelIndex('28','21')" name=tmptype id='tmptype_28' value=21><%=SystemEnv.getHtmlLabelName(15078,user.getLanguage())%></wea:item>
		<wea:item>
			<%if(!ajax.equals("1")){%>
				<brow:browser name="id_28" viewType="0" hasBrowser="true" hasAdd="false" 
                 	browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/Maint/CustomerStatusBrowser.jsp" 
                 	_callback ="callbackMeth"
                 	isMustInput="1" isSingle="true" hasInput="true"
                 	completeUrl="/data.jsp?type=customerStatus"  width="150px" browserValue="" browserSpanValue="" />   
            <%}else{%>
      			<brow:browser name="id_28" viewType="0" hasBrowser="true" hasAdd="false" 
                 	browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/Maint/CustomerStatusBrowser.jsp" 
                 	_callback ="callbackMeth"
                 	isMustInput="1" isSingle="true" hasInput="true"
                 	completeUrl="/data.jsp?type=customerStatus"  width="150px" browserValue="" browserSpanValue="" /> 
            <%}%>  
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></wea:item>
		<wea:item>
			<input type=text class=Inputstyle name=level_28  onfocus="changelevel(tmptype_28)" style="width:60px;" value=0> -
    		<input type=text class=Inputstyle name=level2_28  onfocus="changelevel(tmptype_28)" style="width:60px;" value=100>
		</wea:item>
		
		<!-- 客户部门 @author Dracula 2014-7-18 -->
		<wea:item><input type=radio onClick="setSelIndex('29','22')" name=tmptype id='tmptype_29' value=22><%=SystemEnv.getHtmlLabelName(15579,user.getLanguage())%></wea:item>
		<wea:item>
			<%if(!ajax.equals("1")){%>
      			<brow:browser name="id_29" viewType="0" hasBrowser="true" hasAdd="false" 
                 	browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp" 
                 	_callback ="callbackMeth"
                 	isMustInput="1" isSingle="true" hasInput="true"
                 	completeUrl="/data.jsp?type=4"  width="150px" browserValue="" browserSpanValue="" />   
          	<%}else{%>
           		<brow:browser name="id_29" viewType="0" hasBrowser="true" hasAdd="false" 
                 	browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp" 
                 	_callback ="callbackMeth"
                 	isMustInput="1" isSingle="true" hasInput="true"
                 	completeUrl="/data.jsp?type=4"  width="150px" browserValue="" browserSpanValue="" />         
          	<%}%>     
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></wea:item>
		<wea:item>
			<input type=text class=Inputstyle name=level_29  onfocus="changelevel(tmptype_29)" style="width:60px;" value=0> -
    		<input type=text class=Inputstyle name=level2_29  onfocus="changelevel(tmptype_29)" style="width:60px;" value=100>
		</wea:item>

		<%if (!"0".equals(nodetype)) {%>
		<!-- 客户经理 @author Dracula 2014-7-18 -->
		<wea:item><input type=radio onClick="setSelIndex('30','23')" name=tmptype id='tmptype_30' value=23><%=SystemEnv.getHtmlLabelName(1278,user.getLanguage())%></wea:item>
		<wea:item>
			<select class=inputstyle  name=id_30 onfocus="changelevel(tmptype_30)" style="float:left;">
  			<%
  	 			sql ="" ;
  	 			if(isbill.equals("0"))
			  		sql = "select workflow_formdict.id as id,workflow_fieldlable.fieldlable as name from workflow_formdict,workflow_formfield,workflow_fieldlable where  workflow_fieldlable.isdefault=1 and workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.fieldid = workflow_formfield.fieldid and  workflow_formfield.fieldid= workflow_formdict.id and workflow_formdict.fieldhtmltype=3 and (workflow_formdict.type = 1 or workflow_formdict.type=17 or workflow_formdict.type=165 or workflow_formdict.type=166) and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formfield.formid="+formid;
		  		else
			  		sql = "select id as id , fieldlabel as name from workflow_billfield where billid="+ formid+ " and fieldhtmltype = '3' and (type=1 or type=17 or type=165 or type=166) and viewtype = 0 " ;

		  		RecordSet.executeSql(sql);
		   		while(RecordSet.next()){
		 	%>
  				<option value=<%=RecordSet.getString("id")%>>
  					<% if(isbill.equals("0")) {%> <%=RecordSet.getString("name")%>
			  		<%} else {%> <%=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage())%> <%}%>
		  		</option>
		  	<%}%>
		  	</select>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></wea:item>
		<wea:item>
			<input type=text class=Inputstyle name=level_30  onfocus="changelevel(tmptype_30)" style="width:60px;" value=0> -
    		<input type=text class=Inputstyle name=level2_30  onfocus="changelevel(tmptype_30)" style="width:60px;" value=100>
		</wea:item>
		
		<!-- 客户字段本人 @author Dracula 2014-7-18 -->
		<wea:item><input type=radio onClick="setSelIndex('31','24')" name=tmptype id='tmptype_31' value=24><%=SystemEnv.getHtmlLabelName(15580,user.getLanguage())%></wea:item>
		<wea:item>
			<select class=inputstyle  name=id_31 onfocus="changelevel(tmptype_31)">
  			<%
  	  			sql ="" ;
  				if(isbill.equals("0"))
			  		sql = "select workflow_formdict.id as id,workflow_fieldlable.fieldlable as name from workflow_formdict,workflow_formfield,workflow_fieldlable where  workflow_fieldlable.isdefault=1 and workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.fieldid = workflow_formfield.fieldid and workflow_formfield.fieldid = workflow_formdict.id and workflow_formdict.fieldhtmltype=3 and (workflow_formdict.type = 7 or workflow_formdict.type = 18 ) and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formfield.formid="+formid;
		  		else
			  		sql = "select id as id , fieldlabel as name from workflow_billfield where billid="+ formid+ " and fieldhtmltype = '3' and (type=7 or type=18) and viewtype = 0  " ;

		  		RecordSet.executeSql(sql);
		  		while(RecordSet.next()){
		  	%>
		  		<option value=<%=RecordSet.getString("id")%>>
		  			<% if(isbill.equals("0")) {%> <%=RecordSet.getString("name")%>
			  		<%} else {%> <%=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage())%> <%}%>
		  		</option>
		  	<%}%>
		  	</select>
		</wea:item>
		<wea:item></wea:item>
		<wea:item>
			<input type=text name=level_31 style="display:none">
			<input type=radio name=signorder_31 value="0" onfocus="changelevel(tmptype_31)"><%=SystemEnv.getHtmlLabelName(15556,user.getLanguage())%>&nbsp;&nbsp;
    		<input type=radio name=signorder_31 value="1" checked  onfocus="changelevel(tmptype_31)"><%=SystemEnv.getHtmlLabelName(15557,user.getLanguage())%>&nbsp;&nbsp;
		</wea:item>
		<%}%>

		<!-- 所有客户 @author Dracula 2014-7-18 -->
		<wea:item><input type=radio onClick="setSelIndex('32','25')" name=tmptype id='tmptype_32' value=25><%=SystemEnv.getHtmlLabelName(15581,user.getLanguage())%></wea:item>
		<wea:item><input type=text class=Inputstyle name=id_32 style="display:none"></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></wea:item>
		<wea:item>
			<input type=text class=Inputstyle name=level_32  onfocus="changelevel(tmptype_32)" style="width:60px;" value=0> -
    		<input type=text class=Inputstyle name=level2_32  onfocus="changelevel(tmptype_32)" style="width:60px;" value=100>
		</wea:item>
	</wea:group>
</wea:layout>
</div>
<%-- 客户门户相关 end --%>

		
