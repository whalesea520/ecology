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
			<div id=odiv_urger_3 style="display:none">
				<wea:layout type="4col" attributes="{'cw1':'20%','cw2':'30%','cw3':'20%','cw4':'30%'}">
					<wea:group context='<%=SystemEnv.getHtmlLabelName(106,user.getLanguage())%>'>
						<wea:item>
							<input type=radio onClick="setSelIndexByUrger('10','8')" name=tmptype id='tmptype_10' value=8 />
							<%=SystemEnv.getHtmlLabelName(15564,user.getLanguage())%>
						</wea:item>
						<wea:item>
							<select class=inputstyle  name=wfid_10 style="width:150px" onClick="changelevelByUrger(tmptype_10)">
						  		<%
								  if(isbill.equals("0"))
									  sql = "select workflow_formdict.id as id,workflow_fieldlable.fieldlable as name from workflow_formdict,workflow_formfield,workflow_fieldlable where  workflow_fieldlable.isdefault='1' and workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.fieldid = workflow_formfield.fieldid and workflow_formfield.fieldid = workflow_formdict.id and workflow_formdict.fieldhtmltype='3' and workflow_formdict.type = 9 and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formfield.formid="+formid;
								  else
									  sql = "select id as id , fieldlabel as name from workflow_billfield where billid="+ formid+ " and fieldhtmltype = '3' and type=9 and viewtype = 0" ;

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
							<input type=text class=Inputstyle   name=wflevel_10 style="display:none">
						</wea:item>
						<!-- end row -->

						<wea:item>
							<input type=radio onClick="setSelIndexByUrger('11','33')" name=tmptype id='tmptype_11' value=33 />
							<%=SystemEnv.getHtmlLabelName(15565,user.getLanguage())%>
						</wea:item>
						<wea:item>
							<select class=inputstyle  name=wfid_11 onClick="changelevelByUrger(tmptype_11)" style="width:150px">
						  		<%
								  RecordSet.beforFirst();
								  while(RecordSet.next()){
								  %>
								  <option value=<%=RecordSet.getString("id")%>><% if(isbill.equals("0")) {%> <%=RecordSet.getString("name")%>
									  <%} else {%> <%=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage())%> <%}%></option>
								  <%}%>
							</select>
						</wea:item>
						<wea:item>
							<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>
						</wea:item>
						<wea:item>
							<input type=text class=Inputstyle   name=wflevel_11  onClick="changelevelByUrger(tmptype_11)" style="width:60px;" value=0 />-
	    					<input type=text class=Inputstyle   name=wflevel2_11  onClick="changelevelByUrger(tmptype_11)" style="width:60px;" value=100 />
						</wea:item>
						<!-- end row -->

						<wea:item>
							<input type=radio onClick="setSelIndexByUrger('12','9')" name=tmptype id='tmptype_12' value=9 />
							<%=SystemEnv.getHtmlLabelName(15566,user.getLanguage())%>
						</wea:item>
						<wea:item>
							<select class=inputstyle  name=wfid_12 onClick="changelevelByUrger(tmptype_12)" style="width:150px">
						  		<%
								  RecordSet.beforFirst();
								  while(RecordSet.next()){
								  %>
								  <option value=<%=RecordSet.getString("id")%>><% if(isbill.equals("0")) {%> <%=RecordSet.getString("name")%>
									  <%} else {%> <%=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage())%> <%}%></option>
								  <%}%>
							</select>
						</wea:item>
						<wea:item>
							<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>
						</wea:item>
						<wea:item>
							<input type=text class=Inputstyle   name=wflevel_12  onClick="changelevelByUrger(tmptype_12)" style="width:60px;" value=0 />-
	    					<input type=text class=Inputstyle   name=wflevel2_12  onClick="changelevelByUrger(tmptype_12)" style="width:60px;" value=100 />
						</wea:item>
						<!-- end row -->

					</wea:group>
				</wea:layout>
			</div>

			<div id=odiv_urger_4 style="display:none">
				<wea:layout type="4col" attributes="{'cw1':'20%','cw2':'30%','cw3':'20%','cw4':'30%'}">
					<wea:group context='<%=SystemEnv.getHtmlLabelName(106,user.getLanguage())%>'>
						<wea:item>
							<input type=radio onClick="setSelIndexByUrger('13','10')" name=tmptype id='tmptype_13' value=10 />
							<%=SystemEnv.getHtmlLabelName(15567,user.getLanguage())%>
						</wea:item>
						<wea:item>
							<select class=inputstyle  name=wfid_13 style="width:150px" onClick="changelevelByUrger(tmptype_13)">
						  		<%
								  if(isbill.equals("0"))
									  sql = "select workflow_formdict.id as id,workflow_fieldlable.fieldlable as name from workflow_formdict,workflow_formfield,workflow_fieldlable where  workflow_fieldlable.isdefault='1' and workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.fieldid = workflow_formfield.fieldid and workflow_formfield.fieldid = workflow_formdict.id and workflow_formdict.fieldhtmltype='3' and workflow_formdict.type = 8 and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formfield.formid="+formid;
								  else
									  sql = "select id as id , fieldlabel as name from workflow_billfield where billid="+ formid+ " and fieldhtmltype = '3' and type=8 and viewtype = 0" ;

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
							<input type=text class=Inputstyle   name=wflevel_13 style="display:none" />
						</wea:item>
						<!-- end row -->

						<wea:item>
							<input type=radio onClick="setSelIndexByUrger('47','47')" name=tmptype id='tmptype_47' value=47 />
							<%=SystemEnv.getHtmlLabelName(18680,user.getLanguage())%>
						</wea:item>
							<select class=inputstyle  name=wfid_47 onClick="changelevelByUrger(tmptype_47)" style="width:150px">
						  		<%

								  RecordSet.beforFirst();
								  while(RecordSet.next()){
								  %>
								  <option value=<%=RecordSet.getString("id")%>><% if(isbill.equals("0")) {%> <%=RecordSet.getString("name")%>
									  <%} else {%> <%=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage())%> <%}%></option>
								  <%}%>
							</select>
						<wea:item>
						</wea:item>
						<wea:item>
						</wea:item>
						<wea:item>
							<input type=text class=Inputstyle name=wflevel_47 style="display:none" />
						</wea:item>
						<!-- end row -->

						<wea:item>
							<input type=radio onClick="setSelIndexByUrger('14','34')" name=tmptype id='tmptype_14' value=34 />
							<%=SystemEnv.getHtmlLabelName(15568,user.getLanguage())%>
						</wea:item>
						<wea:item>
							<select class=inputstyle  name=wfid_14 onClick="changelevelByUrger(tmptype_14)" style="width:150px">
						  		<%
								  RecordSet.beforFirst();
								  while(RecordSet.next()){
								  %>
								  <option value=<%=RecordSet.getString("id")%>><% if(isbill.equals("0")) {%> <%=RecordSet.getString("name")%>
									  <%} else {%> <%=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage())%> <%}%></option>
								  <%}%>
						  </select>
						</wea:item>
						<wea:item>
							<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>
						</wea:item>
						<wea:item>
							<input type=text class=Inputstyle   name=wflevel_14  onClick="changelevelByUrger(tmptype_14)" style="width:60px;" value=0 />-
    						<input type=text class=Inputstyle   name=wflevel2_14  onClick="changelevelByUrger(tmptype_14)" style="width:60px;" value=100 />
						</wea:item>
						<!-- end row -->

						<wea:item>
							<input type=radio onClick="setSelIndexByUrger('15','11')" name=tmptype id='tmptype_15' value=11 />
							<%=SystemEnv.getHtmlLabelName(15569,user.getLanguage())%>
						</wea:item>
						<wea:item>
							<select class=inputstyle  name=wfid_15 onClick="changelevelByUrger(tmptype_15)" style="width:150px">
						  		<%
								  RecordSet.beforFirst();
								  while(RecordSet.next()){
								  %>
								  <option value=<%=RecordSet.getString("id")%>><% if(isbill.equals("0")) {%> <%=RecordSet.getString("name")%>
									  <%} else {%> <%=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage())%> <%}%></option>
								  <%}%>
							 </select>
						</wea:item>
						<wea:item>
							<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>
						</wea:item>
						<wea:item>
							<input type=text class=Inputstyle   name=wflevel_15  onClick="changelevelByUrger(tmptype_15)" style="width:60px;" value=0 />-
    						<input type=text class=Inputstyle   name=wflevel2_15  onClick="changelevelByUrger(tmptype_15)" style="width:60px;" value=100 />
						</wea:item>
						<!-- end row -->

						<wea:item>
							<input type=radio onClick="setSelIndexByUrger('16','12')" name=tmptype id='tmptype_16' value=12 />
							<%=SystemEnv.getHtmlLabelName(15570,user.getLanguage())%>
						</wea:item>
						<wea:item>
							<select class=inputstyle  name=wfid_16 onClick="changelevelByUrger(tmptype_16)" style="width:150px">
						  		<%
								  RecordSet.beforFirst();
								  while(RecordSet.next()){
								  %>
								  <option value=<%=RecordSet.getString("id")%>><% if(isbill.equals("0")) {%> <%=RecordSet.getString("name")%>
									  <%} else {%> <%=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage())%> <%}%></option>
								  <%}%>
		  					</select>
						</wea:item>
						<wea:item>
							<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>
						</wea:item>
						<wea:item>
							<input type=text class=Inputstyle   name=wflevel_16  onClick="changelevelByUrger(tmptype_16)" style="width:60px;" value=0 />-
    						<input type=text class=Inputstyle   name=wflevel2_16  onClick="changelevelByUrger(tmptype_16)" style="width:60px;" value=100 />
						</wea:item>
						<!-- end row -->

						<wea:item>
							<input type=radio onClick="setSelIndexByUrger('48','48')" name=tmptype id='tmptype_48' value=48 />
							<%=SystemEnv.getHtmlLabelName(18681,user.getLanguage())%>
						</wea:item>
						<wea:item>
							<select class=inputstyle  name=wfid_48 onClick="changelevelByUrger(tmptype_48)" style="width:150px">
					  		<%
							  if(isbill.equals("0"))
								  sql = "select workflow_formdict.id as id,workflow_fieldlable.fieldlable as name from workflow_formdict,workflow_formfield,workflow_fieldlable where  workflow_fieldlable.isdefault='1' and workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.fieldid = workflow_formfield.fieldid and workflow_formfield.fieldid = workflow_formdict.id and workflow_formdict.fieldhtmltype='3' and workflow_formdict.type = 87 and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formfield.formid="+formid;
							  else
								  sql = "select id as id , fieldlabel as name from workflow_billfield where billid="+ formid+ " and fieldhtmltype = '3' and type=87 and viewtype = 0" ;

							  RecordSet.executeSql(sql);
							  while(RecordSet.next()){
							  %>
							  <option value=<%=RecordSet.getString("id")%>><%=(isbill.equals("0"))?RecordSet.getString("name"):SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name"),0),user.getLanguage())%></option>
							  <%}%>
							 </select>
						</wea:item>
						<wea:item>
						</wea:item>
						<wea:item>
							<input type=text class=Inputstyle name=wflevel_48 style="display:none" />
						</wea:item>
						<!-- end row -->

					</wea:group>
				</wea:layout>
			</div>

			<div id=odiv_urger_5 style="display:none">
				<wea:layout type="4col" attributes="{'cw1':'20%','cw2':'30%','cw3':'20%','cw4':'30%'}">
					<wea:group context='<%=SystemEnv.getHtmlLabelName(106,user.getLanguage())%>'>
						<wea:item>
							<input type=radio onClick="setSelIndexByUrger('17','13')" name=tmptype id='tmptype_17' value=13 />
							<%=SystemEnv.getHtmlLabelName(15571,user.getLanguage())%>
						</wea:item>
						<wea:item>
							<select class=inputstyle  name=wfid_17 style="width:150px" onClick="changelevelByUrger(tmptype_17)">
						  		<%
								  if(isbill.equals("0"))
									  sql = "select workflow_formdict.id as id,workflow_fieldlable.fieldlable as name from workflow_formdict,workflow_formfield,workflow_fieldlable where  workflow_fieldlable.isdefault='1' and workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.fieldid = workflow_formfield.fieldid and workflow_formfield.fieldid = workflow_formdict.id and workflow_formdict.fieldhtmltype='3' and workflow_formdict.type = 23 and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formfield.formid="+formid;
								  else
									  sql = "select id as id , fieldlabel as name from workflow_billfield where billid="+ formid+ " and fieldhtmltype = '3' and type=23 and viewtype = 0" ;

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
							<input type=text class=Inputstyle   name=wflevel_17 style="display:none" />
						</wea:item>
						<!-- end row -->

						<wea:item>
							<input type=radio onClick="setSelIndexByUrger('18','35')" name=tmptype id='tmptype_18' value=35 />
							<%=SystemEnv.getHtmlLabelName(15572,user.getLanguage())%>
						</wea:item>
						<wea:item>
							<select class=inputstyle  name=wfid_18 onClick="changelevelByUrger(tmptype_18)" style="width:150px">
						  		<%
								  RecordSet.beforFirst();
								  while(RecordSet.next()){
								  %>
								  <option value=<%=RecordSet.getString("id")%>><% if(isbill.equals("0")) {%> <%=RecordSet.getString("name")%>
									  <%} else {%> <%=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage())%> <%}%></option>
								  <%}%>
						  	</select>
						</wea:item>
						<wea:item>
							<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>
						</wea:item>
						<wea:item>
							<input type=text class=Inputstyle   name=wflevel_18  onClick="changelevelByUrger(tmptype_18)" style="width:60px;" value=0 />-
    						<input type=text class=Inputstyle   name=wflevel2_18  onClick="changelevelByUrger(tmptype_18)" style="width:60px;" value=100 />
						</wea:item>
						<!-- end row -->

						<wea:item>
							<input type=radio onClick="setSelIndexByUrger('19','14')" name=tmptype id='tmptype_19' value=14 />
							<%=SystemEnv.getHtmlLabelName(15573,user.getLanguage())%>
						</wea:item>
						<wea:item>
							<select class=inputstyle  name=wfid_19 onClick="changelevelByUrger(tmptype_19)" style="width:150px">
						  		<%
								  RecordSet.beforFirst();
								  while(RecordSet.next()){
								  %>
								  <option value=<%=RecordSet.getString("id")%>><% if(isbill.equals("0")) {%> <%=RecordSet.getString("name")%>
									  <%} else {%> <%=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage())%> <%}%></option>
								  <%}%>
							</select>
						</wea:item>
						<wea:item>
							<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>
						</wea:item>
						<wea:item>
							<input type=text class=Inputstyle   name=wflevel_19  onClick="changelevelByUrger(tmptype_19)" style="width:60px;" value=0 />-
    						<input type=text class=Inputstyle   name=wflevel2_19  onClick="changelevelByUrger(tmptype_19)" style="width:60px;" value=100 />
						</wea:item>
						<!-- end row -->

					</wea:group>
				</wea:layout>
			</div>

			<div id=odiv_urger_6 style="display:none">
				<wea:layout type="4col" attributes="{'cw1':'20%','cw2':'30%','cw3':'20%','cw4':'30%'}">
					<wea:group context='<%=SystemEnv.getHtmlLabelName(106,user.getLanguage())%>'>
						<wea:item>
							<input type=radio onClick="setSelIndexByUrger('20','15')" name=tmptype id='tmptype_20' value=15 />
							<%=SystemEnv.getHtmlLabelName(15574,user.getLanguage())%>
						</wea:item>
						<wea:item>
							<select class=inputstyle  name=wfid_20 style="width:150px" onClick="changelevelByUrger(tmptype_20)">
					  		<%
							  if(isbill.equals("0"))
								  sql = "select workflow_formdict.id as id,workflow_fieldlable.fieldlable as name from workflow_formdict,workflow_formfield,workflow_fieldlable where  workflow_fieldlable.isdefault='1' and workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.fieldid = workflow_formfield.fieldid and workflow_formfield.fieldid = workflow_formdict.id and workflow_formdict.fieldhtmltype='3' and workflow_formdict.type = 7 and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formfield.formid="+formid;
							  else
								  sql = "select id as id , fieldlabel as name from workflow_billfield where billid="+ formid+ " and fieldhtmltype = '3' and type=7 and viewtype = 0" ;

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
							<input type=text class=Inputstyle   name=wflevel_20 style="display:none" />
						</wea:item>
						<!-- end row -->

						<wea:item>
							<input type=radio onClick="setSelIndexByUrger('44','44')" name=tmptype id='tmptype_44' value=44 />
							<%=SystemEnv.getHtmlLabelName(17204,user.getLanguage())%>
						</wea:item>
						<wea:item>
							<select class=inputstyle  name=wfid_44 style="width:150px" onClick="changelevelByUrger(tmptype_44)">
					  		<%
							  RecordSet.beforFirst();
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
							<input type=text class=Inputstyle name=wflevel_44 style="display:none" />
						</wea:item>
						<!-- end row -->

						<wea:item>
							<input type="radio" onClick="setSelIndexByUrger('45','45')" name=tmptype id='tmptype_45' value=45 />
							<%=SystemEnv.getHtmlLabelName(18678,user.getLanguage())%>
						</wea:item>
						<wea:item>
							<select class=inputstyle  name=wfid_45 style="width:150px" onClick="changelevelByUrger(tmptype_45)">
					  		<%
							  RecordSet.beforFirst();
							  while(RecordSet.next()){
							  %>
							  <option value=<%=RecordSet.getString("id")%>><% if(isbill.equals("0")) {%> <%=RecordSet.getString("name")%>
								  <%} else {%> <%=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage())%> <%}%></option>
							  <%}%>
							</select>
						</wea:item>
						<wea:item>
							<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>
						</wea:item>
						<wea:item>
							<input type=text class=Inputstyle name=wflevel_45  onClick="changelevelByUrger(tmptype_45)" style="width:60px;" value=0 />-
    						<input type=text class=Inputstyle name=wflevel2_45  onClick="changelevelByUrger(tmptype_45)" style="width:60px;" value=100 />
						</wea:item>
						<!-- end row -->

						<wea:item>
							<input type=radio onClick="setSelIndexByUrger('46','46')" name=tmptype id='tmptype_46' value=46 />
							<%=SystemEnv.getHtmlLabelName(18679,user.getLanguage())%>
						</wea:item>
						<wea:item>
							<select class=inputstyle  name=wfid_46 style="width:150px" onClick="changelevelByUrger(tmptype_46)">
					  		<%
							  RecordSet.beforFirst();
							  while(RecordSet.next()){
							  %>
							  <option value=<%=RecordSet.getString("id")%>><% if(isbill.equals("0")) {%> <%=RecordSet.getString("name")%>
								  <%} else {%> <%=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage())%> <%}%></option>
							  <%}%>
							</select>
						</wea:item>
						<wea:item>
							<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>
						</wea:item>
						<wea:item>
							<input type=text class=Inputstyle name=wflevel_46  onClick="changelevelByUrger(tmptype_46)" style="width:60px;" value=0 />-
    						<input type=text class=Inputstyle name=wflevel2_46  onClick="changelevelByUrger(tmptype_46)" style="width:60px;" value=100 />
						</wea:item>
						<!-- end row -->

					</wea:group>
				</wea:layout>
			</div>

			<div id=odiv_urger_7 style="display:none">
				<wea:layout type="4col" attributes="{'cw1':'20%','cw2':'30%','cw3':'20%','cw4':'30%'}">
					<wea:group context='<%=SystemEnv.getHtmlLabelName(106,user.getLanguage())%>'>
						<wea:item>
							<input type=radio onClick="setSelIndexByUrger('22','17')" name=tmptype id='tmptype_22' value=17 />
							<%=SystemEnv.getHtmlLabelName(15079,user.getLanguage())%>
						</wea:item>
						<wea:item>
							<input type=text class=Inputstyle   name=wfid_22 style="display:none" />
						</wea:item>
						<wea:item>
						</wea:item>
						<wea:item>
							<input type=text class=Inputstyle   name=wflevel_22 style="display:none" />
						</wea:item>
						<!-- end row -->

						<wea:item>
							<input type=radio onClick="setSelIndexByUrger('23','18')" name=tmptype id='tmptype_23' value=18 />
							<%=SystemEnv.getHtmlLabelName(15080,user.getLanguage())%>
						</wea:item>
						<wea:item>
							<input type=text class=Inputstyle   name=wfid_23 style="display:none" />
						</wea:item>
						<wea:item>
						</wea:item>
						<wea:item>
							<input type=text class=Inputstyle   name=wflevel_23 style="display:none" />
						</wea:item>
						<!-- end row -->

						<wea:item>
							<input type=radio onClick="setSelIndexByUrger('24','36')" name=tmptype id='tmptype_24' value=36 />
							<%=SystemEnv.getHtmlLabelName(15576,user.getLanguage())%>
						</wea:item>
						<wea:item>
							<input type=text class=Inputstyle   name=wfid_24 style="display:none" />
						</wea:item>
						<wea:item>
							<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>
						</wea:item>
						<wea:item>
							<input type=text class=Inputstyle   name=wflevel_24  onClick="changelevelByUrger(tmptype_24)" style="width:60px;" value=0 />-
    						<input type=text class=Inputstyle   name=wflevel2_24  onClick="changelevelByUrger(tmptype_24)" style="width:60px;" value=100 />
						</wea:item>
						<!-- end row -->

						<wea:item>
							<input type=radio onClick="setSelIndexByUrger('25','37')" name=tmptype id='tmptype_25' value=37 />
							<%=SystemEnv.getHtmlLabelName(15577,user.getLanguage())%>
						</wea:item>
						<wea:item>
							<input type=text class=Inputstyle   name=wfid_25 style="display:none" />
						</wea:item>
						<wea:item>
							<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>
						</wea:item>
						<wea:item>
							<input type=text class=Inputstyle   name=wflevel_25  onClick="changelevelByUrger(tmptype_25)" style="width:60px;" value=0 />-
    						<input type=text class=Inputstyle   name=wflevel2_25  onClick="changelevelByUrger(tmptype_25)" style="width:60px;" value=100 />
						</wea:item>
						<!-- end row -->

						<wea:item>
							<input type=radio onClick="setSelIndexByUrger('26','19')" name=tmptype id='tmptype_26' value=19 />
							<%=SystemEnv.getHtmlLabelName(15081,user.getLanguage())%>
						</wea:item>
						<wea:item>
							<input type=text class=Inputstyle   name=wfid_26 style="display:none" />
						</wea:item>
						<wea:item>
							<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>
						</wea:item>
						<wea:item>
							<input type=text class=Inputstyle   name=wflevel_26  onClick="changelevelByUrger(tmptype_26)" style="width:60px;" value=0 />-
    						<input type=text class=Inputstyle   name=wflevel2_26  onClick="changelevelByUrger(tmptype_26)" style="width:60px;" value=100 />
						</wea:item>
						<!-- end row -->

						<!-- 创建人上级部门 -->
						<wea:item>
							<input type=radio onClick="setSelIndexByUrger('39','39')" name=tmptype id='tmptype_39' value=39 />
							<%=SystemEnv.getHtmlLabelName(15578,user.getLanguage())%>
						</wea:item>
						<wea:item>
							<input type=text class=Inputstyle   name=wfid_39 style="display:none" />
						</wea:item>
						<wea:item>
							<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>
						</wea:item>
						<wea:item>
							<input type=text class=Inputstyle   name=wflevel_39  onClick="changelevelByUrger(tmptype_39)" style="width:60px;" value=0 />-
    						<input type=text class=Inputstyle   name=wflevel2_39  onClick="changelevelByUrger(tmptype_39)" style="width:60px;" value=100 />
						</wea:item>
						<!-- end row -->

						<!-- 创建人本岗位 -->
						<wea:item>
							<input type=radio onClick="setSelIndexByUrger('61','61')" name=tmptype id='tmptype_61' value=61>
							<%=SystemEnv.getHtmlLabelName(126610,user.getLanguage())%>
						</wea:item>
						<wea:item>
							<input type=text class=Inputstyle name=wfid_61 style="display:none">
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(34216,user.getLanguage())%></wea:item>
						<wea:item>
							<select class=inputstyle  name=wflevel_61  onclick="changelevelByUrger(tmptype_61)" style="float:left;width:110px;">
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

<div id=odiv_urger_8 style="display:none">
<table class=ListStyle cellspacing=1  >
      	<COLGROUP>
      	<COL width="20%">
  	<COL width="35%">
  	<COL width="10%">
  	<COL width="35%">

  	<tr class=DataLight >
  	<td><input type=radio onClick="setSelIndexByUrger('27','20')" name=tmptype id='tmptype_27' value=20><%=SystemEnv.getHtmlLabelName(1282,user.getLanguage())%></td>
  	<td>
  	<select class=inputstyle  name=wfid_27 onClick="changelevelByUrger(tmptype_27)" style="width:150px">
  	<%

		  RecordSet.executeProc("CRM_CustomerType_SelectAll","");
		  while(RecordSet.next()){
		  %>
		  <option value=<%=RecordSet.getString("id")%>><%=Util.toScreen(RecordSet.getString("fullname"),user.getLanguage())%></option>
		  <%}%>
		  </select>
    	</td>
    	<td><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td><td>
    	<input type=text class=Inputstyle   name=wflevel_27  onClick="changelevelByUrger(tmptype_27)" style="width:60px;" value=0>-
    	<input type=text class=Inputstyle   name=wflevel2_27  onClick="changelevelByUrger(tmptype_27)" style="width:60px;" value=100>
    	</td>
    	</tr>
    	<tr class=DataLight >
    	<td><input type=radio onClick="setSelIndexByUrger('28','21')" name=tmptype id='tmptype_28' value=21><%=SystemEnv.getHtmlLabelName(15078,user.getLanguage())%></td>
      	<td>
      		<brow:browser name="wfid_28" viewType="0" hasBrowser="true" hasAdd="false"
      			 browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/Maint/CustomerStatusBrowser.jsp?resourceids="  
                 _callback ="callbackMeth" isMustInput="1" isSingle="true" hasInput="false"
                 completeUrl=""  width="200px" browserValue="" browserSpanValue="" /> 
    	</td>
    	<td><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td><td>
    	<input type=text class=Inputstyle   name=wflevel_28  onClick="changelevelByUrger(tmptype_28)" style="width:60px;" value=0>-
    	<input type=text class=Inputstyle   name=wflevel2_28  onClick="changelevelByUrger(tmptype_28)" style="width:60px;" value=100>
    	</td>
    	</tr>

    	<tr class=DataLight >
    	<td><input type=radio onClick="setSelIndexByUrger('29','22')" name=tmptype id='tmptype_29' value=22><%=SystemEnv.getHtmlLabelName(15579,user.getLanguage())%></td>
  		<td>
      		<brow:browser name="wfid_29" viewType="0" hasBrowser="true" hasAdd="false" 
                 browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?resourceids="  
                 _callback ="callbackMeth" isMustInput="1" isSingle="true" hasInput="true"
                 completeUrl="/data.jsp?type=4"  width="150px" browserValue="" browserSpanValue="" />
    	</td>
    	<td><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td><td>
    	<input type=text class=Inputstyle   name=wflevel_29  onClick="changelevelByUrger(tmptype_29)" style="width:60px;" value=0>-
    	<input type=text class=Inputstyle   name=wflevel2_29  onClick="changelevelByUrger(tmptype_29)" style="width:60px;" value=100>
    	</td>
    	</tr>
    	<tr class=DataLight >
    	<td><input type=radio onClick="setSelIndexByUrger('30','23')" name=tmptype id='tmptype_30' value=23><%=SystemEnv.getHtmlLabelName(1278,user.getLanguage())%></td>
    	<td><select class=inputstyle  name=wfid_30 style="width:150px" onClick="changelevelByUrger(tmptype_30)">
  	<%
  	 if(isbill.equals("0"))
			  sql = "select workflow_formdict.id as id,workflow_fieldlable.fieldlable as name from workflow_formdict,workflow_formfield,workflow_fieldlable where  workflow_fieldlable.isdefault='1' and workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.fieldid = workflow_formfield.fieldid and  workflow_formfield.fieldid= workflow_formdict.id and workflow_formdict.fieldhtmltype='3' and (workflow_formdict.type = 1 or workflow_formdict.type=17 or workflow_formdict.type=165 or workflow_formdict.type=166) and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formfield.formid="+formid;
		  else
			  sql = "select id as id , fieldlabel as name from workflow_billfield where billid="+ formid+ " and fieldhtmltype = '3' and (type=1 or type=17 or type=165 or type=166) and viewtype = 0" ;

		  RecordSet.executeSql(sql);
		   while(RecordSet.next()){
		 %>
  	<option value=<%=RecordSet.getString("id")%>><% if(isbill.equals("0")) {%> <%=RecordSet.getString("name")%>
			  <%} else {%> <%=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage())%> <%}%></option>
		  <%}%>
		  </select>
    	</td>
    	<td><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td><td>
    	<input type=text class=Inputstyle   name=wflevel_30  onClick="changelevelByUrger(tmptype_30)" style="width:60px;" value=0>-
    	<input type=text class=Inputstyle   name=wflevel2_30  onClick="changelevelByUrger(tmptype_30)" style="width:60px;" value=100>
    	</td>
    	</tr>
    	<tr class=DataLight >
    	<td><input type=radio onClick="setSelIndexByUrger('31','24')" name=tmptype id='tmptype_31' value=24><%=SystemEnv.getHtmlLabelName(15580,user.getLanguage())%></td>
  	<td><select class=inputstyle  name=wfid_31 style="width:150px" onClick="changelevelByUrger(tmptype_31)">
  	<%
		  if(isbill.equals("0"))
			  sql = "select workflow_formdict.id as id,workflow_fieldlable.fieldlable as name from workflow_formdict,workflow_formfield,workflow_fieldlable where  workflow_fieldlable.isdefault='1' and workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.fieldid = workflow_formfield.fieldid and workflow_formfield.fieldid = workflow_formdict.id and workflow_formdict.fieldhtmltype='3' and (workflow_formdict.type = 7 or workflow_formdict.type = 18 ) and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formfield.formid="+formid;
		  else
			  sql = "select id as id , fieldlabel as name from workflow_billfield where billid="+ formid+ " and fieldhtmltype = '3' and type=7 and viewtype = 0" ;

		  RecordSet.executeSql(sql);
		  while(RecordSet.next()){
		  %>
		  <option value=<%=RecordSet.getString("id")%>><% if(isbill.equals("0")) {%> <%=RecordSet.getString("name")%>
			  <%} else {%> <%=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage())%> <%}%></option>
		  <%}%>
		  </select>
    	</td>
    	<td></td><td>
    	<input type=hidden name=wflevel_31 style="width:80%" value=0>
    	</td>
    	</tr>

    	 <tr class=DataLight>
    	<td><input type=radio onClick="setSelIndexByUrger('32','25')" name=tmptype id='tmptype_32' value=25><%=SystemEnv.getHtmlLabelName(15581,user.getLanguage())%></td>
  	<td><input type=text class=Inputstyle   name=wfid_32 style="display:none">
    	</td>
    	<td><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td><td>
    	<input type=text class=Inputstyle   name=wflevel_32  onClick="changelevelByUrger(tmptype_32)" style="width:60px;" value=0>-
    	<input type=text class=Inputstyle   name=wflevel2_32  onClick="changelevelByUrger(tmptype_32)" style="width:60px;" value=100>
    	</td>
    	</tr>
 </table>
</div>				