<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*,weaver.general.*,weaver.systeminfo.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="CompanyVirtualComInfo" class="weaver.hrm.companyvirtual.CompanyVirtualComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WFNodeMainManager" class="weaver.workflow.workflow.WFNodeMainManager" scope="page" />
<jsp:useBean id="FormFieldTransMethod" class="weaver.general.FormFieldTransMethod" scope="page" />
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<%
	String nodetype = Util.null2String(request.getParameter("nodetype"));
	String ajax = Util.null2String(request.getParameter("ajax"));
	String isbill = Util.null2String(request.getParameter("isbill"));
	int formid = Util.getIntValue(request.getParameter("formid"), 0);
	String sql = "";
	String VirtualOrganization = Util.null2String(request.getParameter("VirtualOrganization"));
	int wfid = Util.getIntValue(request.getParameter("wfid"), 0);
	int nodeid = Util.getIntValue(request.getParameter("nodeid"), 0);
	User user = HrmUserVarify.getUser (request , response) ;
%>

<%-- 文档字段 start --%>
<div id=odiv_3 style="display:none">
<wea:layout type="4col" attributes="{'cw1':'20%','cw2':'30%','cw3':'20%','cw4':'30%'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(106,user.getLanguage())%>'>
		<!-- 文档字段所有者 @author Dracula 2014-7-18 -->
		<wea:item><input type=radio onClick="setSelIndex('10','8')" name=tmptype id='tmptype_10' value=8><%=SystemEnv.getHtmlLabelName(15564,user.getLanguage())%></wea:item>
		<wea:item>
			<select class=inputstyle  name=id_10 onfocus="changelevel(tmptype_10)">
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
			<select class=inputstyle  name=id_11 onfocus="changelevel(tmptype_11)" >
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
			<input type=text class=Inputstyle name=level_11  onfocus="changelevel(tmptype_11)" style="width:40%" value=0> -
    		<input type=text class=Inputstyle name=level2_11  onfocus="changelevel(tmptype_11)" style="width:40%" value=100>
   		</wea:item>
		
		<!-- 文档字段部门 @author Dracula 2014-7-18 -->
		<wea:item><input type=radio onClick="setSelIndex('12','9')" name=tmptype id='tmptype_12' value=9><%=SystemEnv.getHtmlLabelName(15566,user.getLanguage())%></wea:item>
		<wea:item>
			<select class=inputstyle  name=id_12 onfocus="changelevel(tmptype_12)">
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
			<input type=text class=Inputstyle name=level_12  onfocus="changelevel(tmptype_12)" style="width:40%" value=0> -
    		<input type=text class=Inputstyle name=level2_12  onfocus="changelevel(tmptype_12)" style="width:40%" value=100>
		</wea:item>
	</wea:group>
</wea:layout>
</div>
<%-- 文档字段 end --%>

<%-- 项目字段 start --%>
<div id=odiv_4 style="display:none">
<wea:layout type="4col" attributes="{'cw1':'20%','cw2':'30%','cw3':'20%','cw4':'30%'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(106,user.getLanguage())%>'>
		<!-- 项目字段经理 @author Dracula 2014-7-18 -->
		<wea:item><input type=radio onClick="setSelIndex('13','10')" name=tmptype id='tmptype_13' value=10><%=SystemEnv.getHtmlLabelName(15567,user.getLanguage())%></wea:item>
		<wea:item>
			<select class=inputstyle  name=id_13 onfocus="changelevel(tmptype_13)">
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
			<select class=inputstyle  name=id_47 onfocus="changelevel(tmptype_47)">
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
			<select class=inputstyle  name=id_14 onfocus="changelevel(tmptype_14)">
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
			<input type=text class=Inputstyle name=level_14  onfocus="changelevel(tmptype_14)" style="width:40%" value=0> -
    	<input type=text class=Inputstyle name=level2_14  onfocus="changelevel(tmptype_14)" style="width:40%" value=100>
		</wea:item>
		
		<!-- 项目字段部门 @author Dracula 2014-7-18 -->
		<wea:item><input type=radio onClick="setSelIndex('15','11')" name=tmptype id='tmptype_15' value=11><%=SystemEnv.getHtmlLabelName(15569,user.getLanguage())%></wea:item>
		<wea:item>
			<select class=inputstyle  name=id_15 onfocus="changelevel(tmptype_15)">
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
			<input type=text class=Inputstyle name=level_15  onfocus="changelevel(tmptype_15)" style="width:40%" value=0> -
    		<input type=text class=Inputstyle name=level2_15  onfocus="changelevel(tmptype_15)" style="width:40%" value=100>
		</wea:item>
		
		<!-- 项目字段成员 @author Dracula 2014-7-18 -->
		<wea:item><input type=radio onClick="setSelIndex('16','12')" name=tmptype id='tmptype_16' value=12><%=SystemEnv.getHtmlLabelName(15570,user.getLanguage())%></wea:item>
		<wea:item>
			<select class=inputstyle  name=id_16 onfocus="changelevel(tmptype_16)">
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
			<input type=text class=Inputstyle name=level_16  onfocus="changelevel(tmptype_16)" style="width:40%" value=0> -
    		<input type=text class=Inputstyle name=level2_16  onfocus="changelevel(tmptype_16)" style="width:40%" value=100>
		</wea:item>
	</wea:group>
</wea:layout>
</div>
<%-- 项目字段 end --%>

<%-- 资产字段 start --%>
<div id=odiv_5 style="display:none">
<wea:layout type="4col" attributes="{'cw1':'20%','cw2':'30%','cw3':'20%','cw4':'30%'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(106,user.getLanguage())%>'>
		<!-- 资产字段管理员 @author Dracula 2014-7-18 -->
		<wea:item><input type=radio onClick="setSelIndex('17','13')" name=tmptype id='tmptype_17' value=13><%=SystemEnv.getHtmlLabelName(15571,user.getLanguage())%></wea:item>
		<wea:item>
			<select class=inputstyle  name=id_17 onfocus="changelevel(tmptype_17)">
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
			<select class=inputstyle  name=id_18 onfocus="changelevel(tmptype_18)">
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
			<input type=text class=Inputstyle name=level_18  onfocus="changelevel(tmptype_18)" style="width:40%" value=0> -
    		<input type=text class=Inputstyle name=level2_18  onfocus="changelevel(tmptype_18)" style="width:40%" value=100>
		</wea:item>
		
		<!-- 资产字段部门 @author Dracula 2014-7-18 -->
		<wea:item><input type=radio onClick="setSelIndex('19','14')" name=tmptype id='tmptype_19' value=14><%=SystemEnv.getHtmlLabelName(15573,user.getLanguage())%></wea:item>
		<wea:item>
			<select class=inputstyle  name=id_19 onfocus="changelevel(tmptype_19)">
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
			<input type=text class=Inputstyle name=level_19  onfocus="changelevel(tmptype_19)" style="width:40%" value=0> -
    		<input type=text class=Inputstyle name=level2_19  onfocus="changelevel(tmptype_19)" style="width:40%" value=100>
		</wea:item>
	</wea:group>
</wea:layout>
</div>
<%-- 资产字段 end --%>

<%-- 客户字段 start --%>
<div id=odiv_6 style="display:none">
<wea:layout type="4col" attributes="{'cw1':'20%','cw2':'30%','cw3':'20%','cw4':'30%'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(106,user.getLanguage())%>'>
		<!-- 客户字段经理 @author Dracula 2014-7-18 -->
		<wea:item><input type=radio onClick="setSelIndex('20','15')" name=tmptype id='tmptype_20' value=15><%=SystemEnv.getHtmlLabelName(15574,user.getLanguage())%></wea:item>
		<wea:item>
			<select class=inputstyle  name=id_20 onfocus="changelevel(tmptype_20)">
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
			<select class=inputstyle  name=id_44 onfocus="changelevel(tmptype_44)">
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
		<wea:item><input type=radio onClick="setSelIndex('45','45')" name=tmptype id='tmptype_45' value=45>客户字段分部</wea:item>
		<wea:item>
			<select class=inputstyle  name=id_45 onfocus="changelevel(tmptype_45)">
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
			<input type=text class=Inputstyle name=level_45  onfocus="changelevel(tmptype_45)" style="width:40%" value=0> -
    		<input type=text class=Inputstyle name=level2_45  onfocus="changelevel(tmptype_45)" style="width:40%" value=100>
		</wea:item>
		
		<!-- 客户字段部门 @author Dracula 2014-7-18 -->
		<wea:item><input type=radio onClick="setSelIndex('46','46')" name=tmptype id='tmptype_46' value=46>客户字段部门</wea:item>
		<wea:item>
			<select class=inputstyle  name=id_46 onfocus="changelevel(tmptype_46)">
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
			<input type=text class=Inputstyle name=level_46  onfocus="changelevel(tmptype_46)" style="width:40%" value=0> -
	    	<input type=text class=Inputstyle name=level2_46  onfocus="changelevel(tmptype_46)" style="width:40%" value=100>
		</wea:item>
		
		<!-- 客户字段联系人经理 @author Dracula 2014-7-18 -->
		<wea:item><input type=radio onClick="setSelIndex('21','16')" name=tmptype id='tmptype_21' value=16><%=SystemEnv.getHtmlLabelName(15575,user.getLanguage())%></wea:item>
		<wea:item>
			<select class=inputstyle  name=id_21 onfocus="changelevel(tmptype_21)">
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
<wea:layout type="4col" attributes="{'cw1':'20%','cw2':'30%','cw3':'20%','cw4':'30%'}">
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
			<%if(CompanyVirtualComInfo.getCompanyNum()>0){ %>
  				<select class=inputstyle id='id_24_1' style="float:left;">
					<%=VirtualOrganization%>
  				</select>
			<%}%>
			<input type=text class=Inputstyle name=id_24 style="display:none">
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></wea:item>
		<wea:item>
			<input type=text class=Inputstyle name=level_24  onfocus="changelevel(tmptype_24)" style="width:40%" value=0> -
    		<input type=text class=Inputstyle name=level2_24  onfocus="changelevel(tmptype_24)" style="width:40%" value=100>
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
			<input type=text class=Inputstyle name=level_25  onfocus="changelevel(tmptype_25)" style="width:40%" value=0> -
    		<input type=text class=Inputstyle name=level2_25  onfocus="changelevel(tmptype_25)" style="width:40%" value=100>
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
			<input type=text class=Inputstyle name=level_26  onfocus="changelevel(tmptype_26)" style="width:40%" value=0> -
    		<input type=text class=Inputstyle name=level2_26  onfocus="changelevel(tmptype_26)" style="width:40%" value=100>
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
			<input type=text class=Inputstyle name=level_39  onfocus="changelevel(tmptype_39)" style="width:40%" value=0> -
    		<input type=text class=Inputstyle name=level2_39  onfocus="changelevel(tmptype_39)" style="width:40%" value=100>
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
<wea:layout type="4col" attributes="{'cw1':'20%','cw2':'30%','cw3':'20%','cw4':'30%'}">
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
			<input type=text class=Inputstyle name=level_27  onfocus="changelevel(tmptype_27)" style="width:40%" value=0> -
    		<input type=text class=Inputstyle name=level2_27  onfocus="changelevel(tmptype_27)" style="width:40%" value=100>
		</wea:item>
		
		<!-- 客户状态 @author Dracula 2014-7-18 -->
		<wea:item><input type=radio onClick="setSelIndex('28','21')" name=tmptype id='tmptype_28' value=21><%=SystemEnv.getHtmlLabelName(15078,user.getLanguage())%></wea:item>
		<wea:item>
			<%if(!ajax.equals("1")){
			String opchange = "browpropertychange(this,'id_28')";%>
				<brow:browser onPropertyChange='<%=opchange %>' name="id_28" viewType="0" hasBrowser="true" hasAdd="false" 
					browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/Maint/CustomerStatusBrowser.jsp"
                 	_callback ="callbackMeth"
                 	isMustInput="1" isSingle="true" hasInput="true"
                 	completeUrl="/data.jsp?type=customerStatus"  width="150px" browserValue="" browserSpanValue="" />   
            <%}else{
			String opchange = "browpropertychange(this,'id_28')";%>
      			<brow:browser onPropertyChange='<%=opchange %>' name="id_28" viewType="0" hasBrowser="true" hasAdd="false" 
                 	browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/Maint/CustomerStatusBrowser.jsp"
                 	_callback ="callbackMeth"
                 	isMustInput="1" isSingle="true" hasInput="true"
                 	completeUrl="/data.jsp?type=customerStatus"  width="150px" browserValue="" browserSpanValue="" /> 
            <%}%>  
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></wea:item>
		<wea:item>
			<input type=text class=Inputstyle name=level_28  onfocus="changelevel(tmptype_28)" style="width:40%" value=0> -
    		<input type=text class=Inputstyle name=level2_28  onfocus="changelevel(tmptype_28)" style="width:40%" value=100>
		</wea:item>
		
		<!-- 客户部门 @author Dracula 2014-7-18 -->
		<wea:item><input type=radio onClick="setSelIndex('29','22')" name=tmptype id='tmptype_29' value=22><%=SystemEnv.getHtmlLabelName(15579,user.getLanguage())%></wea:item>
		<wea:item>
			<%if(!ajax.equals("1")){
			String opchange = "browpropertychange(this,'id_29')";%>
      			<brow:browser onPropertyChange='<%=opchange %>' name="id_29" viewType="0" hasBrowser="true" hasAdd="false" 
      				browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp"
                 	browserOnClick="onShowBrowser4op('','29',tmptype_29)" 
                 	_callback ="callbackMeth"
                 	isMustInput="1" isSingle="true" hasInput="true"
                 	completeUrl="/data.jsp?type=4"  width="150px" browserValue="" browserSpanValue="" />   
          	<%}else{
			String opchange = "browpropertychange(this,'id_29')";%>
           		<brow:browser onPropertyChange='<%=opchange %>' name="id_29" viewType="0" hasBrowser="true" hasAdd="false" 
                 	browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp"
                 	_callback ="callbackMeth"
                 	isMustInput="1" isSingle="true" hasInput="true"
                 	completeUrl="/data.jsp?type=4"  width="150px" browserValue="" browserSpanValue="" />         
          	<%}%>     
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></wea:item>
		<wea:item>
			<input type=text class=Inputstyle name=level_29  onfocus="changelevel(tmptype_29)" style="width:40%" value=0> -
    		<input type=text class=Inputstyle name=level2_29  onfocus="changelevel(tmptype_29)" style="width:40%" value=100>
		</wea:item>

		<%if (!"0".equals(nodetype)) {%>
		<!-- 客户经理 @author Dracula 2014-7-18 -->
		<wea:item><input type=radio onClick="setSelIndex('30','23')" name=tmptype id='tmptype_30' value=23><%=SystemEnv.getHtmlLabelName(1278,user.getLanguage())%></wea:item>
		<wea:item>
			<select class=inputstyle  name=id_30 onfocus="changelevel(tmptype_30)">
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
			<input type=text class=Inputstyle name=level_30  onfocus="changelevel(tmptype_30)" style="width:40%" value=0> -
    		<input type=text class=Inputstyle name=level2_30  onfocus="changelevel(tmptype_30)" style="width:40%" value=100>
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
			<input type=text class=Inputstyle name=level_32  onfocus="changelevel(tmptype_32)" style="width:40%" value=0> -
    		<input type=text class=Inputstyle name=level2_32  onfocus="changelevel(tmptype_32)" style="width:40%" value=100>
		</wea:item>
	</wea:group>
</wea:layout>
	<%--
    <td>
    	<input type=radio name=signorder_31 value="0" onfocus="changelevel(tmptype_31)"><%=SystemEnv.getHtmlLabelName(15556,user.getLanguage())%>&nbsp;&nbsp;
    	<input type=radio name=signorder_31 value="1" checked  onfocus="changelevel(tmptype_31)"><%=SystemEnv.getHtmlLabelName(15557,user.getLanguage())%>&nbsp;&nbsp;
	</td>
 	--%>
</div>
<%-- 客户门户相关 end --%>

<%-- 节点操作者 start --%>
<div id=odiv_9 style="display:none">

<%
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
%>

<wea:layout type="4col" attributes="{'cw1':'20%','cw2':'30%','cw3':'20%','cw4':'30%'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(106,user.getLanguage())%>'>
		<!-- 节点操作者本人 @author Dracula 2014-7-18 -->
		<wea:item><input type=radio onClick="setSelIndex('40','40')" name=tmptype id='tmptype_40' value=40><%=SystemEnv.getHtmlLabelName(18676,user.getLanguage())%></wea:item>
		<wea:item>
			<select name=id_40 onfocus="changelevel(tmptype_40)">
        	<%
        		for(int i=0 ; i< nodeids.size() ; i++ ) {
            		String tmpid = (String) nodeids.get(i);
            		String tmpname = (String) nodenames.get(i);
            		if(tmpid.equals(""+nodeid))
            		{
            			continue;
            		}
        	%>
            	<option value='<%=tmpid%>'><strong><%=tmpname%></strong>
        	<%}%>
    		</select>
		</wea:item>
		<wea:item><input type=text name=level_40 style="display:none"></wea:item>
		<wea:item></wea:item>
		
		<!-- 节点操作者本人 @author Dracula 2014-7-18 -->
		<wea:item><input type=radio onClick="setSelIndex('41','41')" name=tmptype id='tmptype_41' value=41 ><%=SystemEnv.getHtmlLabelName(18677,user.getLanguage())%></wea:item>
		<wea:item>
			<select name=id_41 onfocus="changelevel(tmptype_41)" style="float:left;">
       		<%
        		for(int i=0 ; i< nodeids.size() ; i++ ) {
            		String tmpid = (String) nodeids.get(i);
            		String tmpname = (String) nodenames.get(i);
            		if(tmpid.equals(""+nodeid))
            		{
            			continue;
            		}
        	%>
            	<option value='<%=tmpid%>'><strong><%=tmpname%></strong>
        	<%}%>
    		</select>
    		<%if(CompanyVirtualComInfo.getCompanyNum()>0){ %>
  				<select class=inputstyle id='id_41_1' style="float:left;">
					<%=VirtualOrganization%>
  				</select>
			<%}%>
		</wea:item>
		<wea:item><input type=text name=level_41 style="display:none"></wea:item>
		<wea:item></wea:item>
	</wea:group>
</wea:layout>
</div>
<%-- 节点操作者 end --%>

<%-- 相关负责人 start --%>
<div id=odiv_10 style="display:none;">
	<table id="" class="LayoutTable" style="display:">
		<colgroup>
			<col width="5%">
			<col width="95%">
		</colgroup>
		<tbody>
			<tr class="intervalTR" style="display:" _samepair="">
				<td colspan="2">
					<table class="LayoutTable" style="width:100%;">
						<colgroup>
							<col width="50%">
							<col width="50%">
						</colgroup>
						<tbody>
							<tr height="30px;" class="groupHeadHide">
								<td >
									<span class="groupbg" style="display:block;margin-left:10px;"></span>
									<span class="e8_grouptitle" style="display:block;color:#5b5b5b!important;"><%=SystemEnv.getHtmlLabelName(106,user.getLanguage())%></span>
								</td>
								<td class="interval" style="text-align:right;" colspan="2">
									<span class="toolbar"> </span>
									<span class="hideBlockDiv" style="color: rgb(204, 204, 204);" _status="0">
										<img src="/wui/theme/ecology8/templates/default/images/2_wev8.png">
									</span>
								</td>
							</tr>
							<tr class="Spacing" style="height:1px;display:">
								<td class="Line" colspan="2"> </td>
							</tr>
						</tbody>
					</table>
				</td>
			</tr>
			<tr class="Spacing" style="height:1px;display:">
				<td class="Line" colspan="2"> </td>
			</tr>
			<tr class="items intervalTR" style="display: table-row;">
				<td colspan="2">
					<table id="" class="LayoutTable" style="display:">
						<colgroup>
							<col width="6%"/>
							<col width="15%"/>
							<col width="32%"/>
							<col width="15%"/>
							<col width="32%"/>
						</colgroup>
						<tbody>
							<tr>
							<div style="display:none;">
												 <select class=inputstyle id="__max1">
												 </select>
												 <select class=inputstyle id="__max2">
												 </select>
								 </div>

								<td class="fieldName">
									<input id="matrixTmpType" type="radio" name="tmptype" value="99" onclick="setSelIndex('99','99');" />
								</td>
								<td class="fieldName"><%=SystemEnv.getHtmlLabelName(125352,user.getLanguage())%></td>
								<td class="field">
																	 <input type="hidden" id="matrix" name="matrix" />
								<select class=inputstyle style="width:160px" id="matrixTmp" name="matrixTmp" onChange="Matrix();selectShow()" style="float:left;">
		  						<%
			  						String matrixid = "";
			  						String name = "";
			  						String desc = "";
			  						String issystem = "";
									sql = "select id,name,descr,issystem from MatrixInfo " ;
								  	RecordSet.executeSql(sql);
								  	while(RecordSet.next()){
								  	     matrixid = RecordSet.getString("id");
								  	  	 name = RecordSet.getString("name");
								  	  	 desc = RecordSet.getString("desc");
										 issystem = RecordSet.getString("issystem");
							  if("2".equals(issystem)) {
							  	%>	 
							  		<option value=<%=matrixid%> selected>
							  			<%=name%>
						  			</option>
								
							  	<% }else{  %>
									 <option value=<%=matrixid%> >
							  			<%=name%>
						  			</option>	
									<%}%>
								<%}%>
								</select>
								<input type=hidden name=issystem id=issystem value='<%=issystem%>'>
								
									<!--<brow:browser viewType="0" name="matrix"
											browserUrl="/systeminfo/BrowserMain.jsp?url=/matrixmanage/pages/matrixbrowser.jsp"
											_callback="matrixChanged"
											hasInput="true" isSingle="true" hasBrowser="true"
											isMustInput="1" completeUrl="/data.jsp?type=matrix"></brow:browser>-->

								</td>
															<td class="fieldName"><%=SystemEnv.getHtmlLabelName(21847,user.getLanguage())%></td>
								<td class="field">
								  <input type="hidden" issingle="true" ismustinput="1" viewtype="0" onpropertychange="" temptitle="" name="vf" id="vf">
								<select style="width:160px" class=inputstyle id="matrixTmpfield" name="matrixTmpfield"  onChange="selectShow()" style="float:left;">

							  		<option  value="0">
						  			</option>
								</select>
									<!--<brow:browser viewType="0" name="vf"
											getBrowserUrlFn="getMatrixBrowserUrl"
											getBrowserUrlFnParams="1"
											hasInput="true" isSingle="true" hasBrowser="true"
											isMustInput="1" completeUrl="javascript:getMatrixDataUrl(1);"></brow:browser>-->
								
								</td>

							</tr>
							<tr>
								<td colspan="5">
									<table id="matrixTable" class=ListStyle border=0 cellspacing=1>
										<colgroup>
											<col width="5%"/>
											<col width="40%"/>
											<col width="40%"/>
											<col width="15%"/>
										</colgroup>
										<tr class=header>
											<td style="padding-left: 30px !important;" NOWRAP><input type=checkbox onclick="selectAllMatrixRow(this.checked);"></td>
											<td NOWRAP><%=SystemEnv.getHtmlLabelName(15364,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(33331,user.getLanguage())%></td>
											<td NOWRAP><%=SystemEnv.getHtmlLabelName(19372,user.getLanguage())%></td>
											<td style="text-align:right;" NOWRAP>
												<button type=button  Class=addbtn type=button onclick="addMatrixRowNew();" title="<%=SystemEnv.getHtmlLabelName(15582,user.getLanguage())%>"></button>
												<button type=button  Class=delbtn type=button onclick="removeMatrixRow();" title="<%=SystemEnv.getHtmlLabelName(15583,user.getLanguage())%>"></button>
											</td>
										</tr>
									</table>
								</td>
							</tr>
						</tbody>
					</table>
				</td>
			</tr>
		</tbody>
	</table>
</div>
<%-- 相关负责人 end --%>
