<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.*,weaver.systeminfo.*" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CompanyVirtualComInfo" class="weaver.hrm.companyvirtual.CompanyVirtualComInfo" scope="page" />
<%
	String nodetype = Util.null2String(request.getParameter("nodetype"));
	String ajax = Util.null2String(request.getParameter("ajax"));
	String isbill = Util.null2String(request.getParameter("isbill"));
	int formid = Util.getIntValue(request.getParameter("formid"), 0);
	String sql = "";
	String VirtualOrganization = Util.null2String(request.getParameter("VirtualOrganization"));
	int design = Util.getIntValue(request.getParameter("design"), 0);
%>

<div id=odiv_1 style="display:''">
						<wea:layout type="4col" attributes="{'cw1':'15%','cw2':'40%','cw3':'15%','cw4':'30%'}">
						<wea:group context='<%=SystemEnv.getHtmlLabelName(106,user.getLanguage())%>'>
							<!-- 一般 新增加分部 @author Dracula 2014-7-17-->
							<wea:item>
								<input type=radio onClick="setSelIndex('0','30')" name=tmptype id='tmptype_0' value=30><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>
							</wea:item>
							<wea:item>
								<%if(nodetype.equals("0")){%>
								<select id="signorder_0" name="signorder_0" onfocus="changelevel(tmptype_0)" style="float:left;">
									<option value="1"><%=SystemEnv.getHtmlLabelName(353,user.getLanguage())%></option>
									<option value="2"><%=SystemEnv.getHtmlLabelName(21473,user.getLanguage())%></option>
								</select>
								<%}else{%>
								<input type="hidden" id="signorder_0" name="signorder_0" value="0">
								<%}%>
								<%if(!ajax.equals("1")){%>
								<brow:browser name="id_0" viewType="0" hasBrowser="true" hasAdd="false" 
												browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?selectedids="
								                _callback ="callbackMeth"
								                isMustInput="1" isSingle="true" hasInput="true"
								                completeUrl="/data.jsp?type=164"  width="150px" browserValue="" browserSpanValue="" /> 
								<%}else if(!nodetype.equals("0")){%>
								<brow:browser name="id_0" viewType="0" hasBrowser="true" hasAdd="false" 
								               browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?selectedids="
								                _callback ="callbackMeth"
								                isMustInput="1" isSingle="true" hasInput="true"
								                completeUrl="/data.jsp?type=164"  width="150px" browserValue="" browserSpanValue="" />  
								<span id="name_0" name="name_0" style="display:none"/>
								<%}else{%>
								<brow:browser name="id_0" viewType="0" hasBrowser="true" hasAdd="false" 
								            browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiSubcompanyBrowser.jsp?selectedids="
								            _callback ="callbackMeth"
								            isMustInput="1" isSingle="false" hasInput="true"
								            completeUrl="/data.jsp?type=164"  width="150px" browserValue="" browserSpanValue="" />  
								 	<%}%>
								<%if("0".equals(nodetype)){%>
						          &nbsp;&nbsp;&nbsp;
						          <input type="checkbox" value="1" name="bhxj_0"><%=SystemEnv.getHtmlLabelName(84674,user.getLanguage())%>           
								<%}%>
							</wea:item>
							<wea:item><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></wea:item>
							<wea:item>
								<input type=text class=Inputstyle name=level_0 onfocus="changelevel(tmptype_0)" style="width:60px;" value=0>-
								<input type=text class=Inputstyle name=level2_0 onfocus="changelevel(tmptype_0)" style="width:60px;" value=100>
							</wea:item>
							
							<!-- 一般 部门 @author Dracula 2014-7-17-->
							<wea:item><input type=radio onClick="setSelIndex('1','1')" name=tmptype id='tmptype_1' value=1><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></wea:item>
							<wea:item>
								<%if(nodetype.equals("0")){%>
								<select id="signorder_1" name="signorder_1" onfocus="changelevel(tmptype_1)" style="float:left;">
									<option value="1"><%=SystemEnv.getHtmlLabelName(353,user.getLanguage())%></option>
									<option value="2"><%=SystemEnv.getHtmlLabelName(21473,user.getLanguage())%></option>
								</select>
								<%}else{%>
								<input type="hidden" id="signorder_1" name="signorder_1" value="0">
								<%}%>
								<%if(!ajax.equals("1")){%>
								<brow:browser name="id_1" viewType="0" hasBrowser="true" hasAdd="false" 
											browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="
								          	_callback ="callbackMeth"
								          	isMustInput="1" isSingle="true" hasInput="true"
								          	completeUrl="/data.jsp?type=4"  width="150px" browserValue="" browserSpanValue="" />     
								<%}else if(!nodetype.equals("0")){%>
								<brow:browser name="id_1" viewType="0" hasBrowser="true" hasAdd="false" 
								      		browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="
								      		_callback ="callbackMeth"
								      		isMustInput="1" isSingle="true" hasInput="true"
								      		completeUrl="/data.jsp?type=4"  width="150px" browserValue="" browserSpanValue="" /> 
								<%}else{%>
								<brow:browser name="id_1" viewType="0" hasBrowser="true" hasAdd="false" 
								     		browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids="
								     		_callback ="callbackMeth"
								     		isMustInput="1" isSingle="false" hasInput="true"
								     		completeUrl="/data.jsp?type=4"  width="150px" browserValue="" browserSpanValue="" />
								<%}%>
								<%if("0".equals(nodetype)){%>
									&nbsp;&nbsp;&nbsp;
						          <input type="checkbox" value="1" name="bhxj_1"><%=SystemEnv.getHtmlLabelName(125943,user.getLanguage())%>
						       <%} %>
							</wea:item>
							<wea:item><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></wea:item>
							<wea:item>
								<input type=text  class=Inputstyle name=level_1 onfocus="changelevel(tmptype_1)" style="width:60px;" value=0>-
								<input type=text  class=Inputstyle name=level2_1 onfocus="changelevel(tmptype_1)" style="width:60px;" value=100>
							</wea:item>
							
							<!-- 一般 角色 @author Dracula 2014-7-17-->
							<wea:item><input type=radio onClick="setSelIndex('2','2')" name=tmptype id='tmptype_2' value=2><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></wea:item>
							<wea:item>
								<%if(nodetype.equals("0")){%>
								<select id="signorder_2" name="" onfocus="changelevel(tmptype_2)"  style="float:left;">
									<option value="1"><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
									<option value="2"><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
								</select>
								<%}else{%>
								<%}%>
								<%if(!ajax.equals("1")){%>
								<brow:browser name="id_2" viewType="0" hasBrowser="true" hasAdd="false" 
											browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp"
								     		_callback ="callbackMeth"
								     		isMustInput="1" isSingle="true" hasInput="true"
								     		completeUrl="/data.jsp?type=65"  width="150px" browserValue="" browserSpanValue="" /> 
								<%}else{%>
								<brow:browser name="id_2" viewType="0" hasBrowser="true" hasAdd="false" 
								           	browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp" 
								           	_callback ="callbackMeth"
								           	isMustInput="1" isSingle="true" hasInput="true"
								          	completeUrl="/data.jsp?type=65"  width="150px" browserValue="" browserSpanValue="" /> 
								<%}%>
							</wea:item>
							<wea:item><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%></wea:item>
							<wea:item>
								<select class=inputstyle  name=level_2  onfocus="changelevel(tmptype_2)" >
									<option value=0 ><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
									<option value=1 ><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>
									<%if(!nodetype.equals("0")){%><option value=3 ><%=SystemEnv.getHtmlLabelName(22753,user.getLanguage())%></option><%}%>
									<option value=2 ><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%></option>
								</select>
							</wea:item>
							
							<!-- 一般 岗位 -->
							<wea:item><input type=radio onClick="setSelIndex('58','58')" name=tmptype id='tmptype_58' value=58><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></wea:item>
							<wea:item>
								<%if(nodetype.equals("0")){%>
								<select id="signorder_58" name="" onfocus="changelevel(tmptype_58)"  style="float:left;">
									<option value="1"><%=SystemEnv.getHtmlLabelName(353,user.getLanguage())%></option>
									<option value="2"><%=SystemEnv.getHtmlLabelName(21473,user.getLanguage())%></option>
								</select>
								<%}else{%>
								
								<%}%>
								<%if(!ajax.equals("1")){
								String opchange = "browpropertychange(this,'id_58')";%>
								<brow:browser onPropertyChange='<%= opchange%>' name="id_58" viewType="0" hasBrowser="true" hasAdd="false" 
											browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/jobtitles/MutiJobTitlesBrowser.jsp?selectedids="
								     		_callback ="callbackMeth"
								     		isMustInput="1" isSingle="false" hasInput="true"
								     		completeUrl="/data.jsp?type=24"  width="150px" browserValue="" browserSpanValue="" /> 
								<%}else{
								String opchange = "browpropertychange(this,'id_58')";%>
								<brow:browser onPropertyChange='<%=opchange %>' name="id_58" viewType="0" hasBrowser="true" hasAdd="false" 
								           	browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/jobtitles/MutiJobTitlesBrowser.jsp?selectedids=" 
								           	_callback ="callbackMeth"
								           	isMustInput="1" isSingle="false" hasInput="true"
								          	completeUrl="/data.jsp?type=24"  width="150px" browserValue="" browserSpanValue="" /> 
								<%}%>
								<span id="name_58" name="name_58" style="display:none"/>
							</wea:item>
							<wea:item><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())+SystemEnv.getHtmlLabelName(139,user.getLanguage())%></wea:item>
							<wea:item>
								<select class=inputstyle  name=level_58  onfocus="changelevel(tmptype_58)" onchange="onChangeSharetype(58)" style="float:left;">
									<option value=0 ><%=SystemEnv.getHtmlLabelName(17908,user.getLanguage())+SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
									<option value=1 ><%=SystemEnv.getHtmlLabelName(17908,user.getLanguage())+SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>
									<option value=2 selected><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%></option>
								</select>
								<span id="relatedshareSpan_58" style="float:left;display:none;">
									<brow:browser name="relatedshareid_58" viewType="0" hasBrowser="true" hasAdd="false" 
								 	   		   getBrowserUrlFn="onChangeResource" getBrowserUrlFnParams="58" 
						    				   isMustInput="2" isSingle="false" hasInput="true"
						     				   completeUrl="javascript:getajaxurl(58)"  width="150px" browserValue="" browserSpanValue=""/>
						     	</span>
							</wea:item>
							
							<!-- 一般 人力资源 @author Dracula 2014-7-17-->
							<wea:item><input type=radio onClick="setSelIndex('3','3')" name=tmptype id='tmptype_3' value=3><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></wea:item>
							<wea:item>
								<%if(!ajax.equals("1")){%>
								<brow:browser name="id_3" viewType="0" hasBrowser="true" hasAdd="false" 
											browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?selectedids="
									  		_callback ="callbackMeth"  isMustInput="1" isSingle="false" hasInput="true"
									  		completeUrl="/data.jsp"  width="150px" browserValue="" browserSpanValue="" />      
								<%}else{%>
								<brow:browser name="id_3" viewType="0" hasBrowser="true" hasAdd="false" 
								      		browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?selectedids=" 
								      		_callback ="callbackMeth" isMustInput="1" isSingle="false" hasInput="true" completeUrl="/data.jsp"  width="150px" browserValue="" browserSpanValue="" /> 
								<%}%>
							</wea:item>
							<wea:item></wea:item>
							<wea:item><input type=text class=Inputstyle name=level_3 style="display:none"></wea:item>
							
							<!-- 一般 所有人 @author Dracula 2014-7-17-->
							<wea:item><input type=radio onClick="setSelIndex('4','4')" name=tmptype id='tmptype_4' value=4 ><%=SystemEnv.getHtmlLabelName(1340,user.getLanguage())%></wea:item>
							<wea:item><input type=text class=Inputstyle name=id_4 style="display:none"></wea:item>
							<wea:item><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></wea:item>
							<wea:item>
								<input type=text class=Inputstyle name=level_4  onfocus="changelevel(tmptype_4)" style="width:60px;" value=0>-
								<input type=text class=Inputstyle name=level2_4  onfocus="changelevel(tmptype_4)" style="width:60px;" value=100>
							</wea:item>
							
						</wea:group>
					</wea:layout>
				</div>
		<%-- 人力资源字段start --%>
				<div id=odiv_2 style="display:none">
					<wea:layout type="4col" attributes="{'cw1':'20%','cw2':'40%','cw3':'15%','cw4':'25%'}">
						<wea:group context='<%=SystemEnv.getHtmlLabelName(106,user.getLanguage())%>'>
							<!-- 人力资源字段本人 @author Dracula 2014-7-18 -->
							<wea:item><input type=radio onClick="setSelIndex('5','5')" name=tmptype id='tmptype_5' value=5><%=SystemEnv.getHtmlLabelName(15555,user.getLanguage())%></wea:item>
							<wea:item>
								<select class=inputstyle  name=id_5 onfocus="changelevel(tmptype_5)" style="width:150px">
			  					<%
				  					if(isbill.equals("0")){
								  		sql = "select * from (";
									  	sql += " select workflow_formdict.id as id,workflow_fieldlable.fieldlable as name,0 viewtype,0 groupid from workflow_formdict,workflow_formfield,workflow_fieldlable where  workflow_fieldlable.isdefault=1 and workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.fieldid = workflow_formfield.fieldid and  workflow_formfield.fieldid= workflow_formdict.id and workflow_formdict.fieldhtmltype=3 and (workflow_formdict.type = 1 or workflow_formdict.type=17 or workflow_formdict.type=165 or workflow_formdict.type=166) and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formfield.formid="+formid;      // 包括多人力资源字段
										sql += " union all ";
										sql += " SELECT workflow_formdictdetail.id AS id,workflow_fieldlable.fieldlable AS name,1 viewtype,workflow_formfield.groupId + 1 FROM workflow_formdictdetail,workflow_formfield,workflow_fieldlable WHERE workflow_fieldlable.isdefault = 1 AND workflow_fieldlable.formid = workflow_formfield.formid AND workflow_fieldlable.fieldid = workflow_formfield.fieldid AND workflow_formfield.fieldid = workflow_formdictdetail.id AND workflow_formdictdetail.fieldhtmltype = 3 AND (workflow_formdictdetail.type = 1 OR workflow_formdictdetail.type = 17 OR workflow_formdictdetail.type = 165 OR workflow_formdictdetail.type = 166) AND workflow_formfield.isdetail = '1' AND workflow_formfield.formid = " + formid;
										sql += " )t order by viewtype asc,groupid asc,id asc";
								  	}else{
									  	sql = "select * from (";
									  	sql += " select id as id , fieldlabel as name,0 viewtype,0 groupid from workflow_billfield where billid="+ formid+ " and fieldhtmltype = '3' and (type=1 or type=17 or type=165 or type=166) and viewtype = 0";
									  	sql += " union all";
									  	sql += " select a.id, fieldlabel as name,1 viewtype,b.orderid groupid from workflow_billfield a,Workflow_billdetailtable b where a.billid = b.billid and a.detailtable = b.tablename and a.billid="+ formid+ " and fieldhtmltype = '3' and (type=1 or type=17 or type=165 or type=166) and viewtype = 1";
									  	sql += " )t order by viewtype asc,groupid asc,id asc";
								  	}
			  						RecordSet.executeSql(sql);
								  	while(RecordSet.next()){
				  						String viewtype = RecordSet.getString("viewtype");
								  		String groupid = RecordSet.getString("groupid");
								  		String name = "";
								  		if(isbill.equals("0")) 
								  			name = RecordSet.getString("name");
								  		else
								  			name = SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage());
								  		if("1".equals(viewtype))
								  			name += "（" + SystemEnv.getHtmlLabelName(17463,user.getLanguage()) + groupid + "）";
				  					%>
					  					<option value=<%=RecordSet.getString("id")%>>
					  						<%=name %>
						  				</option>
						  			<%}%>
				  				</select>
							</wea:item>
							<wea:item></wea:item>
							<wea:item></wea:item>
							
							<!-- 人力资源字段经理 @author Dracula 2014-7-18 -->
							<wea:item><input type=radio onClick="setSelIndex('6','6')" name=tmptype id='tmptype_6' value=6 ><%=SystemEnv.getHtmlLabelName(15559,user.getLanguage())%></wea:item>
							<wea:item>
								<select class=inputstyle  name=id_6 onfocus="changelevel(tmptype_6)" style="float:left;width:150px">
		  						<%
			  						if(isbill.equals("0")){
								  		sql = "select * from (";
									  	sql += " select workflow_formdict.id as id,workflow_fieldlable.fieldlable as name,0 viewtype,0 groupid from workflow_formdict,workflow_formfield,workflow_fieldlable where  workflow_fieldlable.isdefault=1 and workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.fieldid = workflow_formfield.fieldid and  workflow_formfield.fieldid= workflow_formdict.id and workflow_formdict.fieldhtmltype=3 and (workflow_formdict.type = 1 or workflow_formdict.type=165 ) and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formfield.formid="+formid;      // 包括多人力资源字段
										sql += " union all ";
										sql += " SELECT workflow_formdictdetail.id AS id,workflow_fieldlable.fieldlable AS name,1 viewtype,workflow_formfield.groupId + 1 FROM workflow_formdictdetail,workflow_formfield,workflow_fieldlable WHERE workflow_fieldlable.isdefault = 1 AND workflow_fieldlable.formid = workflow_formfield.formid AND workflow_fieldlable.fieldid = workflow_formfield.fieldid AND workflow_formfield.fieldid = workflow_formdictdetail.id AND workflow_formdictdetail.fieldhtmltype = 3 AND (workflow_formdictdetail.type = 1 OR workflow_formdictdetail.type = 165) AND workflow_formfield.isdetail = '1' AND workflow_formfield.formid = " + formid;
										sql += " )t order by viewtype asc,groupid asc,id asc";
								  	}else{
									  	sql = "select * from (";
									  	sql += " select id as id , fieldlabel as name,0 viewtype,0 groupid from workflow_billfield where billid="+ formid+ " and fieldhtmltype = '3' and (type=1 or type=165) and viewtype = 0";
									  	sql += " union all";
									  	sql += " select a.id, fieldlabel as name,1 viewtype,b.orderid groupid from workflow_billfield a,Workflow_billdetailtable b where a.billid = b.billid and a.detailtable = b.tablename and a.billid="+ formid+ " and fieldhtmltype = '3' and (type=1 or type=165) and viewtype = 1";
									  	sql += " )t order by viewtype asc,groupid asc,id asc";
								  	}
			  						RecordSet.executeSql(sql);
			  						while(RecordSet.next()){
				  						String viewtype = RecordSet.getString("viewtype");
								  		String groupid = RecordSet.getString("groupid");
								  		String name = "";
								  		if(isbill.equals("0")) 
								  			name = RecordSet.getString("name");
								  		else
								  			name = SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage());
								  		if("1".equals(viewtype))
								  			name += "（" + SystemEnv.getHtmlLabelName(17463,user.getLanguage()) + groupid + "）";
				  					%>
					  					<option value=<%=RecordSet.getString("id")%>>
					  						<%=name %>
						  				</option>
				  				<%}%>
				  				</select>
				  				
				  				<%if(CompanyVirtualComInfo.getCompanyNum()>0){ %>
					  				<select class=inputstyle id='id_6_1' style="float:left;width:150px">
										<%=VirtualOrganization%>
					  				</select>
								<%}%>
							</wea:item>
							<wea:item></wea:item>
							<wea:item><input type=text class=Inputstyle name=level_6 style="display:none"></wea:item>
							
							<!-- 人力资源字段 岗位 -->
							<wea:item><input type=radio onClick="setSelIndex('59','59')" name=tmptype id='tmptype_59' value=59><%=SystemEnv.getHtmlLabelName(15549,user.getLanguage())+SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></wea:item>
							<wea:item>
								<select class=inputstyle  name=id_59 onfocus="onclick(tmptype_59)" style="float:left;width:150px">
								<%
				  					if(isbill.equals("0")){
								  		sql = "select * from (";
									  	sql += " select workflow_formdict.id as id,workflow_fieldlable.fieldlable as name,0 viewtype,0 groupid from workflow_formdict,workflow_formfield,workflow_fieldlable where  workflow_fieldlable.isdefault=1 and workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.fieldid = workflow_formfield.fieldid and  workflow_formfield.fieldid= workflow_formdict.id and workflow_formdict.fieldhtmltype=3 and (workflow_formdict.type = 1 or workflow_formdict.type=17 or workflow_formdict.type=165 or workflow_formdict.type=166) and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formfield.formid="+formid;      // 包括多人力资源字段
										sql += " union all ";
										sql += " SELECT workflow_formdictdetail.id AS id,workflow_fieldlable.fieldlable AS name,1 viewtype,workflow_formfield.groupId + 1 FROM workflow_formdictdetail,workflow_formfield,workflow_fieldlable WHERE workflow_fieldlable.isdefault = 1 AND workflow_fieldlable.formid = workflow_formfield.formid AND workflow_fieldlable.fieldid = workflow_formfield.fieldid AND workflow_formfield.fieldid = workflow_formdictdetail.id AND workflow_formdictdetail.fieldhtmltype = 3 AND (workflow_formdictdetail.type = 1 OR workflow_formdictdetail.type = 17 OR workflow_formdictdetail.type = 165 OR workflow_formdictdetail.type = 166) AND workflow_formfield.isdetail = '1' AND workflow_formfield.formid = " + formid;
										sql += " )t order by viewtype asc,groupid asc,id asc";
								  	}else{
									  	sql = "select * from (";
									  	sql += " select id as id , fieldlabel as name,0 viewtype,0 groupid from workflow_billfield where billid="+ formid+ " and fieldhtmltype = '3' and (type=1 or type=17 or type=165 or type=166) and viewtype = 0";
									  	sql += " union all";
									  	sql += " select a.id, fieldlabel as name,1 viewtype,b.orderid groupid from workflow_billfield a,Workflow_billdetailtable b where a.billid = b.billid and a.detailtable = b.tablename and a.billid="+ formid+ " and fieldhtmltype = '3' and (type=1 or type=17 or type=165 or type=166) and viewtype = 1";
									  	sql += " )t order by viewtype asc,groupid asc,id asc";
								  	}
			  						RecordSet.executeSql(sql);
								  	while(RecordSet.next()){
				  						String viewtype = RecordSet.getString("viewtype");
								  		String groupid = RecordSet.getString("groupid");
								  		String name = "";
								  		if(isbill.equals("0")) 
								  			name = RecordSet.getString("name");
								  		else
								  			name = SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage());
								  		if("1".equals(viewtype))
								  			name += "（" + SystemEnv.getHtmlLabelName(17463,user.getLanguage()) + groupid + "）";
				  					%>
					  					<option value=<%=RecordSet.getString("id")%>>
					  						<%=name %>
						  				</option>
						  			<%}%>
								</select>
							</wea:item>
							<wea:item><%=SystemEnv.getHtmlLabelName(34216,user.getLanguage())%></wea:item>
							<wea:item>
								<select class=inputstyle  name=level_59  onclick="changelevel(tmptype_59)" onchange="onChangeSharetype(59)" style="float:left;width:110px">
									<option value=0 selected><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%></option>
									<option value=1 ><%=SystemEnv.getHtmlLabelName(21837,user.getLanguage())%></option>
									<option value=2 ><%=SystemEnv.getHtmlLabelName(126607,user.getLanguage())%></option>
									<option value=3 ><%=SystemEnv.getHtmlLabelName(126608,user.getLanguage())%></option>
									<option value=4 ><%=SystemEnv.getHtmlLabelName(30792,user.getLanguage())%></option>
									<option value=5 ><%=SystemEnv.getHtmlLabelName(19436,user.getLanguage())%></option>
									<option value=6 ><%=SystemEnv.getHtmlLabelName(27189,user.getLanguage())%></option>
								</select>&nbsp;&nbsp;
								<SPAN class="e8tips" title="<%=SystemEnv.getHtmlLabelName(126892,user.getLanguage())%>">
									<img src='/images/tooltip_wev8.png' align='absMiddle'/>
								</SPAN>
							</wea:item>
							
							<!-- 人力资源字段下属 @author Dracula 2014-7-18 -->
							<wea:item><input type=radio onClick="setSelIndex('7','31')" name=tmptype id='tmptype_7' value=31><%=SystemEnv.getHtmlLabelName(15560,user.getLanguage())%></wea:item>
							<wea:item>
								<select class=inputstyle  name=id_7 onfocus="changelevel(tmptype_7)" style="float:left;width:150px">
		  						<%
			  						RecordSet.beforFirst();
			  						while(RecordSet.next()){
				  						String viewtype = RecordSet.getString("viewtype");
								  		String groupid = RecordSet.getString("groupid");
								  		String name = "";
								  		if(isbill.equals("0")) 
								  			name = RecordSet.getString("name");
								  		else
								  			name = SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage());
								  		if("1".equals(viewtype))
								  			name += "（" + SystemEnv.getHtmlLabelName(17463,user.getLanguage()) + groupid + "）";
				  					%>
				  					<option value=<%=RecordSet.getString("id")%>>
				  						<%=name %>
					  				</option>
				  				<%}%>
				  				</select>
				  				<%if(CompanyVirtualComInfo.getCompanyNum()>0){ %>
					  				<select class=inputstyle id='id_7_1' style="float:left;width:150px">
										<%=VirtualOrganization%>
					  				</select>
								<%}%>
							</wea:item>
							<wea:item><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></wea:item>
							<wea:item>
								<input type=text class=Inputstyle name=level_7  onfocus="changelevel(tmptype_7)" style="width:60px;" value=0> -
		    					<input type=text class=Inputstyle name=level2_7  onfocus="changelevel(tmptype_7)" style="width:60px;" value=100>
							</wea:item>
							
							<!-- 人力资源字段本分部 @author Dracula 2014-7-18 -->
							<wea:item><input type=radio onClick="setSelIndex('8','32')" name=tmptype id='tmptype_8' value=32><%=SystemEnv.getHtmlLabelName(15561,user.getLanguage())%></wea:item>
							<wea:item>
								<select class=inputstyle  name=id_8 onfocus="changelevel(tmptype_8)" style="float:left;width:150px">
		  						<%
			  						RecordSet.beforFirst();
			  						while(RecordSet.next()){
				  						String viewtype = RecordSet.getString("viewtype");
								  		String groupid = RecordSet.getString("groupid");
								  		String name = "";
								  		if(isbill.equals("0")) 
								  			name = RecordSet.getString("name");
								  		else
								  			name = SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage());
								  		if("1".equals(viewtype))
								  			name += "（" + SystemEnv.getHtmlLabelName(17463,user.getLanguage()) + groupid + "）";
				  					%>
				  					<option value=<%=RecordSet.getString("id")%>>
				  						<%=name %>
					  				</option>
				  				<%}%>
				  				</select>
				  				<%if(CompanyVirtualComInfo.getCompanyNum()>0){ %>
					  				<select class=inputstyle id='id_8_1' style="float:left;width:150px">
										<%=VirtualOrganization%>
					  				</select>
								<%}%>
							</wea:item>
							<wea:item><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></wea:item>
							<wea:item>
								<input type=text class=Inputstyle name=level_8  onfocus="changelevel(tmptype_8)" style="width:60px;" value=0> -
		    					<input type=text class=Inputstyle name=level2_8  onfocus="changelevel(tmptype_8)" style="width:60px;" value=100>
							</wea:item>
							
							<!-- 人力资源字段本部门 @author Dracula 2014-7-18 -->
							<wea:item><input type=radio onClick="setSelIndex('9','7')" name=tmptype id='tmptype_9' value=7><%=SystemEnv.getHtmlLabelName(15562,user.getLanguage())%></wea:item>
							<wea:item>
								<select class=inputstyle  name=id_9 onfocus="changelevel(tmptype_9)" style="float:left;width:150px">
		       					<%
			       					RecordSet.beforFirst();
			  						while(RecordSet.next()){
				  						String viewtype = RecordSet.getString("viewtype");
								  		String groupid = RecordSet.getString("groupid");
								  		String name = "";
								  		if(isbill.equals("0")) 
								  			name = RecordSet.getString("name");
								  		else
								  			name = SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage());
								  		if("1".equals(viewtype))
								  			name += "（" + SystemEnv.getHtmlLabelName(17463,user.getLanguage()) + groupid + "）";
				  					%>
				  					<option value=<%=RecordSet.getString("id")%>>
				  						<%=name %>
					  				</option>
							  	<%}%>
							  	</select>
							  	<%if(CompanyVirtualComInfo.getCompanyNum()>0){ %>
					  				<select class=inputstyle id='id_9_1' style="float:left;width:150px">
										<%=VirtualOrganization%>
					  				</select>
								<%}%>
							</wea:item>
							<wea:item><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></wea:item>
							<wea:item>
								<input type=text class=Inputstyle name=level_9  onfocus="changelevel(tmptype_9)" style="width:60px;" value=0> -
		    					<input type=text class=Inputstyle name=level2_9  onfocus="changelevel(tmptype_9)" style="width:60px;" value=100>
		    				</wea:item>
							
							<!-- 人力资源字段上级部门 @author Dracula 2014-7-18 -->
							<wea:item><input type=radio onClick="setSelIndex('38','38')" name=tmptype id='tmptype_38' value=38><%=SystemEnv.getHtmlLabelName(15563,user.getLanguage())%></wea:item>
							<wea:item>
								<select class=inputstyle  name=id_38 onfocus="changelevel(tmptype_38)" style="float:left;width:150px">
		  						<%
			  						RecordSet.beforFirst();
			  						while(RecordSet.next()){
				  						String viewtype = RecordSet.getString("viewtype");
								  		String groupid = RecordSet.getString("groupid");
								  		String name = "";
								  		if(isbill.equals("0")) 
								  			name = RecordSet.getString("name");
								  		else
								  			name = SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage());
								  		if("1".equals(viewtype))
								  			name += "（" + SystemEnv.getHtmlLabelName(17463,user.getLanguage()) + groupid + "）";
				  					%>
				  					<option value=<%=RecordSet.getString("id")%>>
				  						<%=name %>
					  				</option>
				  				<%}%>
				  				</select>
				  				<%if(CompanyVirtualComInfo.getCompanyNum()>0){ %>
					  				<select class=inputstyle id='id_38_1' style="float:left;width:150px">
										<%=VirtualOrganization%>
					  				</select>
								<%}%>
							</wea:item>
							<wea:item><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></wea:item>
							<wea:item>
								<input type=text class=Inputstyle name=level_38  onfocus="changelevel(tmptype_38)" style="width:60px;" value=0> -
		    					<input type=text class=Inputstyle name=level2_38  onfocus="changelevel(tmptype_38)" style="width:60px;" value=100>
							</wea:item>
							
							<!-- 部门 @author Dracula 2014-7-18 -->
							<wea:item><input type=radio onClick="setSelIndex('42','42')" name=tmptype id='tmptype_42' value=42><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></wea:item>
							<%int deptrscount=0; %>
							<wea:item>
								<select class=inputstyle  name=id_42 onfocus="changelevel(tmptype_42)" style="width:150px">
		  						<%
			  						if(isbill.equals("0")){
								  		sql = "select * from (";
									  	sql += " select workflow_formdict.id as id,workflow_fieldlable.fieldlable as name,0 viewtype,0 groupid from workflow_formdict,workflow_formfield,workflow_fieldlable where  workflow_fieldlable.isdefault=1 and workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.fieldid = workflow_formfield.fieldid and  workflow_formfield.fieldid= workflow_formdict.id and workflow_formdict.fieldhtmltype=3 and (workflow_formdict.type = 4 or workflow_formdict.type=57 or workflow_formdict.type=167 or workflow_formdict.type=168) and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formfield.formid="+formid;      // 包括多人力资源字段
										sql += " union all ";
										sql += " SELECT workflow_formdictdetail.id AS id,workflow_fieldlable.fieldlable AS name,1 viewtype,workflow_formfield.groupId + 1 FROM workflow_formdictdetail,workflow_formfield,workflow_fieldlable WHERE workflow_fieldlable.isdefault = 1 AND workflow_fieldlable.formid = workflow_formfield.formid AND workflow_fieldlable.fieldid = workflow_formfield.fieldid AND workflow_formfield.fieldid = workflow_formdictdetail.id AND workflow_formdictdetail.fieldhtmltype = 3 AND (workflow_formdictdetail.type = 4 OR workflow_formdictdetail.type = 57 OR workflow_formdictdetail.type = 167 OR workflow_formdictdetail.type = 168) AND workflow_formfield.isdetail = '1' AND workflow_formfield.formid = " + formid;
										sql += " )t order by viewtype asc,groupid asc,id asc";
								  	}else{
									  	sql = "select * from (";
									  	sql += " select id as id , fieldlabel as name,0 viewtype,0 groupid from workflow_billfield where billid="+ formid+ " and fieldhtmltype = '3' and (type=4 or type=57 or type=167 or type=168) and viewtype = 0";
									  	sql += " union all";
									  	sql += " select a.id, fieldlabel as name,1 viewtype,b.orderid groupid from workflow_billfield a,Workflow_billdetailtable b where a.billid = b.billid and a.detailtable = b.tablename and a.billid="+ formid+ " and fieldhtmltype = '3' and (type=4 or type=57 or type=167 or type=168) and viewtype = 1";
									  	sql += " )t order by viewtype asc,groupid asc,id asc";
								  	}
			  						RecordSet.executeSql(sql);
								  	while(RecordSet.next()){
				  						String viewtype = RecordSet.getString("viewtype");
								  		String groupid = RecordSet.getString("groupid");
								  		String name = "";
								  		if(isbill.equals("0")) 
								  			name = RecordSet.getString("name");
								  		else
								  			name = SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage());
								  		if("1".equals(viewtype))
								  			name += "（" + SystemEnv.getHtmlLabelName(17463,user.getLanguage()) + groupid + "）";
				  					%>
				  					<option value=<%=RecordSet.getString("id")%>>
				  						<%=name %>
					  				</option>
				  				<%}%>
				  				</select>	
							</wea:item>
							<wea:item>
								<input type="hidden" name="id_42_dept" id="id_42_dept" value="0">
								<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>
		    				</wea:item>
							<wea:item>
								<div id=odiv_level_42 style="display:''">
		    						<input type=text class=Inputstyle id="level_42" name="level_42"  onfocus="changelevel(tmptype_42)" style="width:60px;" value=0>
		    						<span id="level_42span" name="level_42span">-</span> 
		    						<input type=text class=Inputstyle id="level2_42" name="level2_42"  onfocus="changelevel(tmptype_42)" style="width:60px;" value=100><br>
		    					</div>
							</wea:item>
							
							<!--人力资源字段下 岗位属性 -->
							<wea:item><input type=radio onClick="setSelIndex('60','60')" name=tmptype id='tmptype_60' value=60><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></wea:item>
							<wea:item>
								<select class=inputstyle  name=id_60 onclick="changelevel(tmptype_60)" onchange="onChangeJobField(60)" style="width:150px">
		  						<%
			  						if(isbill.equals("0")){
								  		sql = "select * from (";
									  	sql += " select workflow_formdict.id as id,workflow_fieldlable.fieldlable as name,0 viewtype,0 groupid from workflow_formdict,workflow_formfield,workflow_fieldlable where  workflow_fieldlable.isdefault=1 and workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.fieldid = workflow_formfield.fieldid and  workflow_formfield.fieldid= workflow_formdict.id and workflow_formdict.fieldhtmltype=3 and (workflow_formdict.type = 24 or workflow_formdict.type=278) and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formfield.formid="+formid;      // 包括岗位、多岗位字段
										sql += " union all ";
										sql += " SELECT workflow_formdictdetail.id AS id,workflow_fieldlable.fieldlable AS name,1 viewtype,workflow_formfield.groupId + 1 FROM workflow_formdictdetail,workflow_formfield,workflow_fieldlable WHERE workflow_fieldlable.isdefault = 1 AND workflow_fieldlable.formid = workflow_formfield.formid AND workflow_fieldlable.fieldid = workflow_formfield.fieldid AND workflow_formfield.fieldid = workflow_formdictdetail.id AND workflow_formdictdetail.fieldhtmltype = 3 AND (workflow_formdictdetail.type = 24 OR workflow_formdictdetail.type = 278) AND workflow_formfield.isdetail = '1' AND workflow_formfield.formid = " + formid;
										sql += " )t order by viewtype asc,groupid asc,id asc";
								  	}else{
									  	sql = "select * from (";
									  	sql += " select id as id , fieldlabel as name,0 viewtype,0 groupid from workflow_billfield where billid="+ formid+ " and fieldhtmltype = '3' and (type=24 or type=278) and viewtype = 0";
									  	sql += " union all";
									  	sql += " select a.id, fieldlabel as name,1 viewtype,b.orderid groupid from workflow_billfield a,Workflow_billdetailtable b where a.billid = b.billid and a.detailtable = b.tablename and a.billid="+ formid+ " and fieldhtmltype = '3' and (type=24 or type=278) and viewtype = 1";
									  	sql += " )t order by viewtype asc,groupid asc,id asc";
								  	}
			  						RecordSet.executeSql(sql);
								  	while(RecordSet.next()){
				  						String viewtype = RecordSet.getString("viewtype");
								  		String groupid = RecordSet.getString("groupid");
								  		String name = "";
								  		if(isbill.equals("0")){
								  			name = RecordSet.getString("name");
								  		}else{
									  		name = SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage());
								  		}
								  		if("1".equals(viewtype)){
								  			name += "（" + SystemEnv.getHtmlLabelName(17463,user.getLanguage()) + groupid + "）";
								  		}else{
								  			groupid = "0";
								  		}
				  					%>
				  					<option value=<%=RecordSet.getString("id")+"_@@_"+groupid+"_@@_"+isbill+"_@@_"+formid%>>
				  						<%=name %>
					  				</option>
				  				<%}%>
				  				</select>	
							</wea:item>
							<wea:item>
								<%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())+SystemEnv.getHtmlLabelName(139,user.getLanguage())%>
		    				</wea:item>
							<wea:item>
								<select class=inputstyle  name=level_60  onclick="changelevel(tmptype_60)" onchange="onChangeSharetype(60)" style="float:left;width:70px;">
									<option value=0 ><%=SystemEnv.getHtmlLabelName(17908,user.getLanguage())+SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
									<option value=1 ><%=SystemEnv.getHtmlLabelName(17908,user.getLanguage())+SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>
									<option value=2 selected><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%></option>
									<option value=3 ><%=SystemEnv.getHtmlLabelName(21740,user.getLanguage())%></option>
								</select>
								<span id="relatedshareSpan_60" style="float:left;display:none;">
									<brow:browser name="relatedshareid_60" viewType="0" hasBrowser="true" hasAdd="false" 
								 	   		   getBrowserUrlFn="onChangeResource" getBrowserUrlFnParams="60" 
						    				   isMustInput="2" isSingle="false" hasInput="true" 
						     				   completeUrl="javascript:getajaxurl(60)"  width="120px" browserValue="" browserSpanValue=""/>
						     	</span>
						     	<span id="relatedshareformSpan_60" style="float:left;display:none;">
									<brow:browser name="relatedshareform_60" viewType="0" hasBrowser="true" hasAdd="false" 
								 	   		   getBrowserUrlFn="onChangeResource" getBrowserUrlFnParams="60" 
						    				   isMustInput="1" isSingle="true" hasInput="false"
						     				   width="120px" browserValue="" browserSpanValue=""/>
						     	</span>&nbsp;&nbsp;
								<SPAN class="e8tips" title="<%=SystemEnv.getHtmlLabelName(126905,user.getLanguage())%>">
									<img src='/images/tooltip_wev8.png' align='absMiddle'/>
								</SPAN>
							</wea:item>
							
							<!-- 分部 @author Dracula 2014-7-18 -->
							<wea:item><input type=radio onClick="setSelIndex('51','51')" name=tmptype id='tmptype_51' value=51><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></wea:item>
							<%int subcompanyrscount=0; %>
							<wea:item>
								<select class=inputstyle  name=id_51 onfocus="changelevel(tmptype_51)" style="width:150px">
					  			<%
						  			if(isbill.equals("0")){
								  		sql = "select * from (";
									  	sql += " select workflow_formdict.id as id,workflow_fieldlable.fieldlable as name,0 viewtype,0 groupid from workflow_formdict,workflow_formfield,workflow_fieldlable where  workflow_fieldlable.isdefault=1 and workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.fieldid = workflow_formfield.fieldid and  workflow_formfield.fieldid= workflow_formdict.id and workflow_formdict.fieldhtmltype=3 and (workflow_formdict.type = 164 or workflow_formdict.type=194 or workflow_formdict.type=169 or workflow_formdict.type=170) and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formfield.formid="+formid;      // 包括多人力资源字段
										sql += " union all ";
										sql += " SELECT workflow_formdictdetail.id AS id,workflow_fieldlable.fieldlable AS name,1 viewtype,workflow_formfield.groupId + 1 FROM workflow_formdictdetail,workflow_formfield,workflow_fieldlable WHERE workflow_fieldlable.isdefault = 1 AND workflow_fieldlable.formid = workflow_formfield.formid AND workflow_fieldlable.fieldid = workflow_formfield.fieldid AND workflow_formfield.fieldid = workflow_formdictdetail.id AND workflow_formdictdetail.fieldhtmltype = 3 AND (workflow_formdictdetail.type = 164 OR workflow_formdictdetail.type = 194 OR workflow_formdictdetail.type = 169 OR workflow_formdictdetail.type = 170) AND workflow_formfield.isdetail = '1' AND workflow_formfield.formid = " + formid;
										sql += " )t order by viewtype asc,groupid asc,id asc";
								  	}else{
									  	sql = "select * from (";
									  	sql += " select id as id , fieldlabel as name,0 viewtype,0 groupid from workflow_billfield where billid="+ formid+ " and fieldhtmltype = '3' and (type=164 or type=194 or type=169 or type=170) and viewtype = 0";
									  	sql += " union all";
									  	sql += " select a.id, fieldlabel as name,1 viewtype,b.orderid groupid from workflow_billfield a,Workflow_billdetailtable b where a.billid = b.billid and a.detailtable = b.tablename and a.billid="+ formid+ " and fieldhtmltype = '3' and (type=164 or type=194 or type=169 or type=170) and viewtype = 1";
									  	sql += " )t order by viewtype asc,groupid asc,id asc";
								  	}
			  						RecordSet.executeSql(sql);
								  	while(RecordSet.next()){
				  						String viewtype = RecordSet.getString("viewtype");
								  		String groupid = RecordSet.getString("groupid");
								  		String name = "";
								  		if(isbill.equals("0")) 
								  			name = RecordSet.getString("name");
								  		else
								  			name = SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage());
								  		if("1".equals(viewtype))
								  			name += "（" + SystemEnv.getHtmlLabelName(17463,user.getLanguage()) + groupid + "）";
				  					%>
				  					<option value=<%=RecordSet.getString("id")%>>
				  						<%=name %>
					  				</option>
							  	<%}%>
							  	</select>
							</wea:item>
							<wea:item>
								<input type="hidden" name="id_51_sub" id="id_51_sub" value="0">
								<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>
							</wea:item>
							<wea:item>
								<div id=odiv_level_51 style="display:''">
						    		<input type=text class=Inputstyle id="level_51" name="level_51"  onfocus="changelevel(tmptype_51)" style="width:60px;" value=0>
						    		<span id="level_51span" name="level_51span">-</span> 
						    		<input type=text class=Inputstyle id="level2_51" name="level2_51"  onfocus="changelevel(tmptype_51)" style="width:60px;" value=100><br>
						    	</div>
							</wea:item>
							
							<!-- 角色 @author Dracula 2014-7-18 -->
							<wea:item><input type=radio onClick="setSelIndex('43','43')" name=tmptype id='tmptype_43' value=43><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></wea:item>
							<wea:item>
								<select class=inputstyle  name=id_43 onfocus="changelevel(tmptype_43)" style="width:150px">
					  			<%
					  	       		sql ="" ;
									if(isbill.equals("0"))
								  		sql = "select workflow_formdict.id as id,workflow_fieldlable.fieldlable as name from workflow_formdict,workflow_formfield,workflow_fieldlable where  workflow_fieldlable.isdefault=1 and workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.fieldid = workflow_formfield.fieldid and  workflow_formfield.fieldid= workflow_formdict.id and workflow_formdict.fieldhtmltype=3 and workflow_formdict.type = 65 and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formfield.formid="+formid;      // 多角色


							  		else
								  		sql = "select id as id , fieldlabel as name from workflow_billfield where billid="+ formid+ " and fieldhtmltype = '3' and type=65 and viewtype = 0 " ;
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
							<wea:item></wea:item>
							
							<!-- 收发文单位 @author Dracula 2014-7-18 -->
							<wea:item><input type=radio onClick="setSelIndex('49','49')" name=tmptype id='tmptype_49' value=49><%=SystemEnv.getHtmlLabelName(19309,user.getLanguage())%></wea:item>
							<wea:item>
								<select class=inputstyle  name=id_49 onfocus="changelevel(tmptype_49)" style="width:150px">
		 						<%
								  	if(isbill.equals("0"))
									  	sql = "select workflow_formdict.id as id,workflow_fieldlable.fieldlable as name from workflow_formdict,workflow_formfield,workflow_fieldlable where  workflow_fieldlable.isdefault='1' and workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.fieldid = workflow_formfield.fieldid and  workflow_formfield.fieldid= workflow_formdict.id and workflow_formdict.fieldhtmltype='3' and workflow_formdict.type = 142  and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formfield.formid="+formid;      // 收发文单位字段


								  	else
									  	sql = "select id as id , fieldlabel as name from workflow_billfield where billid="+ formid+ " and fieldhtmltype = '3' and type=142 and viewtype = 0 " ;
						
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
							<wea:item></wea:item>
							
							<!-- 角色人员 @author Dracula 2014-7-18 -->
							<wea:item><input type=radio onClick="setSelIndex('50','50')" name=tmptype id='tmptype_50' value=50><%=SystemEnv.getHtmlLabelName(20570,user.getLanguage())%></wea:item>
							<wea:item>
								<select class=inputstyle  name=id_50 onfocus="changelevel(tmptype_50)" style="float: left;width:150px">
		  						<%
		  	       					sql ="" ;
				  					if(isbill.equals("0"))
				  						sql = "select workflow_formdict.id as id,workflow_fieldlable.fieldlable as name from workflow_formdict,workflow_formfield,workflow_fieldlable where  workflow_fieldlable.isdefault=1 and workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.fieldid = workflow_formfield.fieldid and  workflow_formfield.fieldid= workflow_formdict.id and workflow_formdict.fieldhtmltype=3 and ( workflow_formdict.type=160) and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formfield.formid="+formid;      // 角色人员
									else
										sql = "select id as id , fieldlabel as name from workflow_billfield where billid="+ formid+ " and fieldhtmltype = '3' and (type=160) and viewtype = 0 " ;
		
				  					RecordSet.executeSql(sql);
				  					while(RecordSet.next()){
				  					%>
				  						<option value=<%=RecordSet.getString("id")%>>
				  							<% if(isbill.equals("0")) {%> <%=RecordSet.getString("name")%>
					  						<%} else {%> <%=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage())%> <%}%>
				  						</option>
				  					<%}%>
				  				</select>
		          				<%if(!ajax.equals("1")){%>
			      					<brow:browser name="level_50" viewType="0" hasBrowser="true" hasAdd="false" 
			            				browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp"
			            				_callback ="callbackMeth"
			            				isMustInput="1" isSingle="true" hasInput="true"
			            				completeUrl="/data.jsp?type=65"  width="150px" browserValue="" browserSpanValue="" />  
		          				<%}else{%>
		     						<brow:browser name="level_50" viewType="0" hasBrowser="true" hasAdd="false" 
		            					browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp"
		            					_callback ="callbackMeth"
		            					isMustInput="1" isSingle="true" hasInput="true"
		            					completeUrl="/data.jsp?type=65"  width="150px" browserValue="" browserSpanValue="" />     
		         	 			<%}%>
							</wea:item>
							<wea:item><%=SystemEnv.getHtmlLabelName(22691,user.getLanguage())%></wea:item>
							<wea:item>
								<select id="level2_50" name="level2_50" class="inputstyle" onfocus="changelevel(tmptype_50)" >
									<option value="0"><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%></option>
									<option value="1"><%=SystemEnv.getHtmlLabelName(22689,user.getLanguage())%></option>
									<option value="2"><%=SystemEnv.getHtmlLabelName(22690,user.getLanguage())%></option>
									<option value="3"><%=SystemEnv.getHtmlLabelName(22667,user.getLanguage())%></option>
								</select>
							</wea:item>
							
							<!-- 会议室管理员 @author Dracula 2014-7-18 -->
							<wea:item><input type=radio onClick="setSelIndex('48','48')" name=tmptype id='tmptype_48' value=48><%=SystemEnv.getHtmlLabelName(18681,user.getLanguage())%></wea:item>
							<wea:item>
								<select class=inputstyle  name=id_48 onfocus="changelevel(tmptype_48)" style="width:150px">
		  						<%
						          	sql="";
								  	if(isbill.equals("0"))
									  	sql = "select workflow_formdict.id as id,workflow_fieldlable.fieldlable as name from workflow_formdict,workflow_formfield,workflow_fieldlable where  workflow_fieldlable.isdefault=1 and workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.fieldid = workflow_formfield.fieldid and workflow_formfield.fieldid = workflow_formdict.id and workflow_formdict.fieldhtmltype=3 and (workflow_formdict.type = 184 or workflow_formdict.type = 87) and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formfield.formid="+formid;
								  	else
									  	sql = "select id as id , fieldlabel as name from workflow_billfield where billid="+ formid+ " and fieldhtmltype = '3' and (type=87 or type=184) and viewtype = 0 " ;
						
								  	RecordSet.executeSql(sql);
								  	while(RecordSet.next()){
							  	%>
							  		<option value=<%=RecordSet.getString("id")%>>
							  			<%=(isbill.equals("0"))?RecordSet.getString("name"):SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name"),0),user.getLanguage())%>
						  			</option>
							  	<%}%>
								</select>
							</wea:item>
							<wea:item></wea:item>
							<wea:item><input type=text class=Inputstyle name=level_48 style="display:none"></wea:item>
						</wea:group>
					</wea:layout>
		
				</div>
<%-- 人力资源字段end --%>

