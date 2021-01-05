<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/browser" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
 String isbill = Util.null2String(request.getParameter("isbill"));
 String formid = Util.null2String(request.getParameter("formid"));
 String sql = "";
%>
<wea:layout>
<wea:group context='<%=SystemEnv.getHtmlLabelName(21219,user.getLanguage())%>'>

<wea:item attributes="{'isTableList':'true'}">
			
			<!-- 隆掳脪禄掳茫隆卤脟酶脫貌 -->
			<div id=odiv_urger_1 style="display:''">
				<wea:layout type="4col" attributes="{'cw1':'20%','cw2':'30%','cw3':'20%','cw4':'30%'}">
					<wea:group context='<%=SystemEnv.getHtmlLabelName(106,user.getLanguage())%>'>
						<wea:item>
							<input type=radio onClick="setSelIndexByUrger('0','30')" name=tmptype id='tmptype_0' value=30 />
							<%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>
						</wea:item>
						<wea:item>
					   		<brow:browser name="wfid_0" viewType="0" hasBrowser="true" hasAdd="false" 
					   			browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?show_virtual_org=-1&selectedids="
				                _callback ="callbackMeth" isMustInput="1" isSingle="true" hasInput="true"
				                completeUrl="/data.jsp?type=164&show_virtual_org=-1"  width="200px" browserValue="" browserSpanValue="" />
						</wea:item>
						<wea:item>
							<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>
						</wea:item>
						<wea:item>
							<input type=text class=Inputstyle   name=wflevel_0 onClick="changelevelByUrger(tmptype_0)" style="width:60px;" value=0 />-
					    	<input type=text class=Inputstyle   name=wflevel2_0 onClick="changelevelByUrger(tmptype_0)" style="width:60px;" value=100 />
						</wea:item>
						<!-- row end -->
						
						<wea:item>
							<input type=radio onClick="setSelIndexByUrger('1','1')" name=tmptype id='tmptype_1' value=1 />
							<%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
						</wea:item>
						<wea:item>
					         <brow:browser name="wfid_1" viewType="0" hasBrowser="true" hasAdd="false" 
					         	 browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?show_virtual_org=-1&selectedids="
					             _callback ="callbackMeth" isMustInput="1" isSingle="true" hasInput="true"
					             completeUrl="/data.jsp?type=4&show_virtual_org=-1"  width="200px" browserValue="" browserSpanValue="" />      
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></wea:item>
						<wea:item>
							<input type=text class=Inputstyle   name=wflevel_1 onClick="changelevelByUrger(tmptype_1)" style="width:60px;" value=0 />-
					    	<input type=text class=Inputstyle   name=wflevel2_1 onClick="changelevelByUrger(tmptype_1)" style="width:60px;" value=100 />
						</wea:item>
						<!-- row end -->
						
						<!-- 一般 角色 -->
						<wea:item>
							<input type=radio onClick="setSelIndexByUrger('2','2')" name=tmptype id='tmptype_2' value=2 />
							<%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%>
						</wea:item>
						<wea:item>
					         <brow:browser name="wfid_2" viewType="0" hasBrowser="true" hasAdd="false"
					         	 browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp?selectedids="
				                 _callback ="callbackMeth" isMustInput="1" isSingle="true" hasInput="true"
				                 completeUrl="/data.jsp?type=65"  width="200px" browserValue="" browserSpanValue="" />
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%></wea:item>
						<wea:item>
							<select class=inputstyle  name=wflevel_2  onClick="changelevelByUrger(tmptype_2)" style="float:left;">
						    	<option value=0 ><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
						      	<option value=1 ><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>
						      	<option value=2 ><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%></option>
					      	</select>
						</wea:item>
						<!-- row end -->
						
						<!-- 一般 岗位 -->
						<wea:item>
							<input type=radio onClick="setSelIndexByUrger('58','58')" name=tmptype id='tmptype_58' value=58>
							<%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%>
						</wea:item>
						<wea:item>
							<brow:browser name="wfid_58" viewType="0" hasBrowser="true" hasAdd="false" 
					           	browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/jobtitles/MutiJobTitlesBrowser.jsp?selectedids=" 
					           	_callback ="callbackMeth"
					           	isMustInput="1" isSingle="false" hasInput="true"
					          	completeUrl="/data.jsp?type=24"  width="200px" browserValue="" browserSpanValue="" /> 
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())+SystemEnv.getHtmlLabelName(139,user.getLanguage())%></wea:item>
						<wea:item>
							<select class=inputstyle  name=wflevel_58  onClick="changelevelByUrger(tmptype_58)" onchange="onChangeSharetype(58)" style="float:left;width:60px;">
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
						
						<wea:item>
							<input type=radio onClick="setSelIndexByUrger('3','3')" name=tmptype id='tmptype_3' value=3 />
							<%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%>
						</wea:item>
						<wea:item>
						    <brow:browser name="wfid_3" viewType="0" hasBrowser="true" hasAdd="false" 
						    	browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids=" 
					        	_callback ="callbackMeth" isMustInput="1" isSingle="false" hasInput="true"
					            completeUrl="/data.jsp?type=1"  width="200px" browserValue="" browserSpanValue="" />
						</wea:item>
						<wea:item></wea:item>
						<wea:item><input type=text class=Inputstyle name=wflevel_3 style="display:none"/></wea:item>
						<!-- row end -->
						
						<wea:item>
							<input type=radio onClick="setSelIndexByUrger('4','4')" name=tmptype id='tmptype_4' value=4 />
							<%=SystemEnv.getHtmlLabelName(1340,user.getLanguage())%>
						</wea:item>
						<wea:item><input type=text class=Inputstyle   name=wfid_4 style="display:none"/></wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></wea:item>
						<wea:item>
							<input type=text class=Inputstyle name=wflevel_4  onClick="changelevelByUrger(tmptype_4)" style="width:60px;" value=0 />-
					    	<input type=text class=Inputstyle name=wflevel2_4  onClick="changelevelByUrger(tmptype_4)" style="width:60px;" value=100 />
						</wea:item>
					</wea:group>
				</wea:layout>
			</div>

			<!-- 脠脣脕娄脳脢脭麓脳脰露脦 脟酶脫貌 -->
			<div id=odiv_urger_2 style="display:none">
				<wea:layout type="4col" attributes="{'cw1':'20%','cw2':'30%','cw3':'20%','cw4':'30%'}">
					<wea:group context='<%=SystemEnv.getHtmlLabelName(106,user.getLanguage())%>'>
						<wea:item>
							<input type=radio onClick="setSelIndexByUrger('5','5')" name=tmptype id='tmptype_5' value=5 />
							<%=SystemEnv.getHtmlLabelName(15555,user.getLanguage())%>
						</wea:item>
						<wea:item>
							<select class=inputstyle  name=wfid_5 onClick="changelevelByUrger(tmptype_5)" style="width:150px">
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
						
						
						<wea:item>
							<input type=radio onClick="setSelIndexByUrger('6','6')" name=tmptype id='tmptype_6' value=6 />
							<%=SystemEnv.getHtmlLabelName(15559,user.getLanguage())%>
						</wea:item>
						<wea:item>
							<input type=text class=Inputstyle   name=wflevel_6 style="display:none">
							<select class=inputstyle  name=wfid_6 onClick="changelevelByUrger(tmptype_6)" style="width:150px">
						  		<%
						  		//人力资源字段经理，只选择单人力
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
						</wea:item>
						<wea:item></wea:item>
						<wea:item></wea:item>
						
						<!-- 人力资源字段 岗位 -->
						<wea:item>
							<input type=radio onClick="setSelIndexByUrger('59','59')" name=tmptype id='tmptype_59' value=59>
							<%=SystemEnv.getHtmlLabelName(15549,user.getLanguage())+SystemEnv.getHtmlLabelName(6086,user.getLanguage())%>
						</wea:item>
						<wea:item>
							<select class=inputstyle  name=wfid_59 onClick="changelevelByUrger(tmptype_59)" style="width:150px">
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
							<select class=inputstyle  name=wflevel_59  onclick="changelevelByUrger(tmptype_59)" style="float:left;width:110px;">
								<option value=0 selected><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%></option>
								<option value=1 ><%=SystemEnv.getHtmlLabelName(21837,user.getLanguage())%></option>
								<option value=2 ><%=SystemEnv.getHtmlLabelName(126607,user.getLanguage())%></option>
								<option value=3 ><%=SystemEnv.getHtmlLabelName(126608,user.getLanguage())%></option>
								<option value=4 ><%=SystemEnv.getHtmlLabelName(30792,user.getLanguage())%></option>
								<option value=5 ><%=SystemEnv.getHtmlLabelName(19436,user.getLanguage())%></option>
								<option value=6 ><%=SystemEnv.getHtmlLabelName(27189,user.getLanguage())%></option>
							</select>
						</wea:item>
						
						<wea:item>
							<input type=radio onClick="setSelIndexByUrger('7','31')" name=tmptype id='tmptype_7' value=31 />
							<%=SystemEnv.getHtmlLabelName(15560,user.getLanguage())%>
						</wea:item>
						<wea:item>
							<select class="inputstyle"  name="wfid_7" onClick="changelevelByUrger(tmptype_7)" style="width:150px">
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
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></wea:item>
						<wea:item>
							<input type=text class="Inputstyle" name="wflevel_7" onClick="changelevelByUrger(tmptype_7)" style="width:60px;" value=0 />-
					    	<input type=text class="Inputstyle" name="wflevel2_7" onClick="changelevelByUrger(tmptype_7)" style="width:60px;" value=100 />
						</wea:item>
						
						
						<wea:item>
							<input type="radio" onClick="setSelIndexByUrger('8','32')" name="tmptype" id='tmptype_8' value=32 />
							<%=SystemEnv.getHtmlLabelName(15561,user.getLanguage())%>
						</wea:item>
						<wea:item>
							<select class=inputstyle  name=wfid_8 onClick="changelevelByUrger(tmptype_8)" style="width:150px">
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
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></wea:item>
						<wea:item>
							<input type=text class=Inputstyle   name=wflevel_8  onClick="changelevelByUrger(tmptype_8)" style="width:60px;" value=0 />-
    						<input type=text class=Inputstyle   name=wflevel2_8  onClick="changelevelByUrger(tmptype_8)" style="width:60px;" value=100 />
						</wea:item>
						<!-- end row -->

						<wea:item>
							<input type=radio onClick="setSelIndexByUrger('9','7')" name=tmptype id='tmptype_9' value=7 />
							<%=SystemEnv.getHtmlLabelName(15562,user.getLanguage())%>
						</wea:item>
						<wea:item>
							<select class=inputstyle  name=wfid_9 onClick="changelevelByUrger(tmptype_9)" style="width:150px">
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
						</wea:item>
						<wea:item>
							<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>
						</wea:item>
						<wea:item>
							<input type=text class=Inputstyle   name=wflevel_9  onClick="changelevelByUrger(tmptype_9)" style="width:60px;" value=0 />-
	    					<input type=text class=Inputstyle   name=wflevel2_9  onClick="changelevelByUrger(tmptype_9)" style="width:60px;" value=100 />
						</wea:item>
						<!-- end row -->

						<wea:item>
							<input type=radio onClick="setSelIndexByUrger('38','38')" name=tmptype id='tmptype_38' value=38 />
							<%=SystemEnv.getHtmlLabelName(15563,user.getLanguage())%>
						</wea:item>
						<wea:item>
							<select class=inputstyle  name=wfid_38 onClick="changelevelByUrger(tmptype_38)" style="width:150px">
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
						</wea:item>
						<wea:item>
							<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>
						</wea:item>
						<wea:item>
							<input type="text" class="Inputstyle"   name=wflevel_38  onClick="changelevelByUrger(tmptype_38)" style="width:60px;" value=0 />-
	    					<input type="text" class="Inputstyle"   name=wflevel2_38  onClick="changelevelByUrger(tmptype_38)" style="width:60px;" value=100 />
						</wea:item>


						<wea:item>
							<input type=radio onClick="setSelIndexByUrger('42','42')" name=tmptype id='tmptype_42' value=42 />
							<%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
						</wea:item>
						<wea:item>
							<select class="inputstyle"  name=wfid_42 onClick="changelevelByUrger(tmptype_42)" style="width:150px">
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
							<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>
						<wea:item>
						</wea:item>
						<wea:item>
							<input type=text class=Inputstyle name=wflevel_42  onClick="changelevelByUrger(tmptype_42)" style="width:60px;" value=0 />-
	    					<input type=text class=Inputstyle name=wflevel2_42  onClick="changelevelByUrger(tmptype_42)" style="width:60px;" value=100 />
						</wea:item>

						<!--人力资源字段下 岗位属性 -->
						<wea:item>
							<input type=radio onClick="setSelIndexByUrger('60','60')" onchange="onChangeJobField(60)" name=tmptype id='tmptype_60' value=60>
							<%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%>
						</wea:item>
						<wea:item>
							<select class=inputstyle  name=wfid_60 onclick="changelevelByUrger(tmptype_60)" onchange="onChangeJobField(60)" style="width:150px">
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
							<select class=inputstyle  name=wflevel_60  onchange="onChangeSharetype(60)" onclick="changelevelByUrger(tmptype_60)" style="float:left;width:60px;">
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
					     	</span>
						</wea:item>

						<!-- 角色 -->
						<wea:item>
							<input type=radio onClick="setSelIndexByUrger('43','43')" name=tmptype id='tmptype_43' value=43 />
							<%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%>
						</wea:item>
						<wea:item>
							<select class=inputstyle  name=wfid_43 onClick="changelevelByUrger(tmptype_43)" style="width:150px">
						  	<%
								  if(isbill.equals("0"))
									  sql = "select workflow_formdict.id as id,workflow_fieldlable.fieldlable as name from workflow_formdict,workflow_formfield,workflow_fieldlable where  workflow_fieldlable.isdefault='1' and workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.fieldid = workflow_formfield.fieldid and  workflow_formfield.fieldid= workflow_formdict.id and workflow_formdict.fieldhtmltype='3' and workflow_formdict.type = 65 and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formfield.formid="+formid;      // 露脿陆脟脡芦
								  else
									  sql = "select id as id , fieldlabel as name from workflow_billfield where billid="+ formid+ " and fieldhtmltype = '3' and type=65 and viewtype = 0" ;

								  RecordSet.executeSql(sql);
								  while(RecordSet.next()){
								  %>
								  <option value=<%=RecordSet.getString("id")%>><% if(isbill.equals("0")) {%> <%=RecordSet.getString("name")%>
									  <%} else {%> <%=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage())%> <%}%></option>
								  <%}%>
							</select>
						</wea:item>
						<wea:item>
						</wea:item>
						<wea:item>
						</wea:item>

						<wea:item>
							<input type=radio onClick="setSelIndexByUrger('49','49')" name=tmptype id='tmptype_49' value=49 />
							<%=SystemEnv.getHtmlLabelName(19309,user.getLanguage())%>
						</wea:item>
						<wea:item>
							<select class=inputstyle  name=wfid_49 onClick="changelevelByUrger(tmptype_49)" style="width:150px">
						  	<%
								  if(isbill.equals("0"))
									  sql = "select workflow_formdict.id as id,workflow_fieldlable.fieldlable as name from workflow_formdict,workflow_formfield,workflow_fieldlable where  workflow_fieldlable.isdefault='1' and workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.fieldid = workflow_formfield.fieldid and  workflow_formfield.fieldid= workflow_formdict.id and workflow_formdict.fieldhtmltype='3' and workflow_formdict.type = 142  and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formfield.formid="+formid;      // 脢脮路垄脦脛碌楼脦禄脳脰露脦
								  else
									  sql = "select id as id , fieldlabel as name from workflow_billfield where billid="+ formid+ " and fieldhtmltype = '3' and type=142 and viewtype = 0" ;

								  RecordSet.executeSql(sql);
								  while(RecordSet.next()){
								  %>
								  <option value=<%=RecordSet.getString("id")%>><% if(isbill.equals("0")) {%> <%=RecordSet.getString("name")%>
									  <%} else {%> <%=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage())%> <%}%></option>
								  <%}%>
								  </select>
						</wea:item>
						<wea:item>
						</wea:item>
						<wea:item>
						</wea:item>
					
					</wea:group>
				</wea:layout>
			</div>
			<jsp:include page="WFUrger_inner1.jsp" flush="true">
					<jsp:param value="<%=isbill %>" name="isbill"/>
					<jsp:param value="<%=formid %>" name="formid"/>
			</jsp:include>	
		</wea:item>
</wea:group>
</wea:layout>