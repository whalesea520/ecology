
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<%@ page import="weaver.workflow.workflow.GroupDetailMatrix,weaver.workflow.workflow.GroupDetailMatrixDetail" %>
<jsp:useBean id="matrixUtil" class="weaver.matrix.MatrixUtil" scope="page" />
<jsp:useBean id="recordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="recordSet2" class="weaver.conn.RecordSet" scope="page" />
<%
	String imagefilename = "/images/hdSystem_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelNames("34066", user.getLanguage());
	String needfav = "1";
	String needhelp = "";
	 int i = 0;
	String wfid = Util.null2String(request.getParameter("wfid"));
	String formid = Util.null2String(request.getParameter("formid"));
	String isbill = Util.null2String(request.getParameter("isbill"));

	String isDialog = Util.null2String(request.getParameter("isdialog"));
	String matrixValue = Util.null2String(request.getParameter("matrixvalue"));
	String matrix = "" ;
	
	GroupDetailMatrix gdMatrix = new GroupDetailMatrix();
	List<GroupDetailMatrixDetail> gdmds = new ArrayList<GroupDetailMatrixDetail>();
	String[] valueAry = matrixValue.split(",");
	if (valueAry.length >= 2) {
		 matrix = valueAry[0];
		String value_field = valueAry[1];
		gdMatrix.setMatrix(matrix);
		gdMatrix.setValue_field(value_field);
		for (int z = 2; z < valueAry.length; z++) {
			String rowValue = valueAry[z];
			String[] rowValueAry = rowValue.split(":");
			String condition_field = rowValueAry[0];
			String workflow_field = rowValueAry[1];
			GroupDetailMatrixDetail gdMatrixDetail = new GroupDetailMatrixDetail();
			gdMatrixDetail.setCondition_field(condition_field);
			gdMatrixDetail.setWorkflow_field(workflow_field);
			gdmds.add(gdMatrixDetail);
		}
	}

	titlename = gdMatrix.getMatrixName(matrixUtil);
	String valueFieldCompleteUrl = "/data.jsp?type=fieldBrowser&wfid=" + wfid;
%>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<SCRIPT language="javascript" src="/js/hrm/HrmTools_wev8.js"></script>
		<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
		<script type="text/javascript">
			var parentWin = parent.parent.getParentWindow(parent);
			var parentDialog = parent.parent.getDialog(parent);

			function onBtnSearchClick(){
				jQuery("#searchfrm").submit();
			}

			function doCloseDialog() {
				parentDialog.close();
			}
		</script>
	</head>
	<BODY>
		<!-- start -->
		<jsp:include page="/systeminfo/commonTabHead.jsp">
			<jsp:param name="mouldID" value="workflow" />
			<jsp:param name="navName" value="<%=titlename%>" />
		</jsp:include>
			<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
			<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
			<%
				RCMenu += "{" + SystemEnv.getHtmlLabelName(86, user.getLanguage())
						+ ",javascript:save(),_self} ";
				RCMenuHeight += RCMenuHeightStep;
				RCMenu += "{"
						+ SystemEnv.getHtmlLabelName(31129, user.getLanguage())
						+ ",javascript:cancel(),_self} ";
				RCMenuHeight += RCMenuHeightStep;
			%>
			<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
			
			<input type="hidden" id="matrix" name="matrix" value="<%=gdMatrix.getMatrix()%>" />
			<form action="" name="searchfrm" id="searchfrm">
				<table id="topTitle" cellpadding="0" cellspacing="0">
					<tr>
						<td></td>
						<td class="rightSearchSpan" style="text-align: right;">
							<input type=button class="e8_btn_top" onclick="save();" value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage())%>"></input>
							<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>" class="cornerMenu"></span>
						</td>
					</tr>
				</table>
					<div style="display:none;">
												 <select class=inputstyle id="__max1">
												 </select>
												 <select class=inputstyle id="__max2">
												 </select>
								 </div>
				<wea:layout type="2col">
					<wea:group context='<%=SystemEnv.getHtmlLabelName(1361, user.getLanguage())%>'>
						<wea:item><%=SystemEnv.getHtmlLabelName(21847, user.getLanguage())%></wea:item>
						<wea:item>
							<!--<brow:browser viewType="0" name="vf"
								browserValue='<%=gdMatrix.getValue_field()%>'
								getBrowserUrlFn="getMatrixBrowserUrl"
								getBrowserUrlFnParams="1"
								hasInput="true" isSingle="true" hasBrowser="true"
								isMustInput="1" completeUrl="javascript:getMatrixDataUrl(1);"
								browserSpanValue='<%=gdMatrix.getValueFieldName(matrixUtil)%>'></brow:browser> -->
								 <input type="hidden" issingle="true" ismustinput="1" viewtype="0" onpropertychange="" temptitle="" name="vf" id="vf">
								<select class=inputstyle id="matrixTmpfield" name="matrixTmpfield"  onchange="selectShow()" style="float:left;">
									<%
		  						String matrixid = "";
						  	  	String name = "";
						  	  	String desc = "";
							
									 String sql = "select id,fieldname,displayname from MatrixFieldInfo where fieldtype='1' and  matrixid = "+ matrix ;
								  	recordSet.executeSql(sql);
								  	while(recordSet.next()){
								  	     matrixid = recordSet.getString("id");
								  	  	 name = recordSet.getString("fieldname");
								  	  	 desc = recordSet.getString("displayname");

							  	%>	 		
							  	<%
								if(gdMatrix.getValue_field().equals(matrixid)){	%>
								<option  value="<%=gdMatrix.getValue_field()%>" selected><%=gdMatrix.getValueFieldName(matrixUtil)%>
						  			</option>
								
								<%}else{%>
									<option value=<%=matrixid%>>
							  			<%=desc%>
						  			</option>
								<%}
								}%>
								</select>
							  	<!--	<option  value="<%=gdMatrix.getValue_field()%>"><%=gdMatrix.getValueFieldName(matrixUtil)%>
						  			</option>
								</select> -->
						</wea:item>
						<wea:item attributes="{'colspan':'full','isTableList':'true'}">
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
								<%
								
								for (GroupDetailMatrixDetail gdmd : gdmds) {
									%>
									<tr class="data">
										<td style="padding-left: 30px !important;"><input type="checkbox" /></td>
										<td class="cf">
										 <div class = "cf">
											<!--<brow:browser viewType="0" name="cf"
												browserValue='<%=gdmd.getCondition_field()%>'
												getBrowserUrlFn="getMatrixBrowserUrl"
												getBrowserUrlFnParams="0"
												hasInput="true" isSingle="true" hasBrowser="true"
												isMustInput="1" completeUrl="javascript:getMatrixDataUrl(1);"
												browserSpanValue='<%=gdmd.getConditionFieldName(matrixUtil, gdMatrix.getMatrix())%>'></brow:browser>  -->
												  <input type="hidden" issingle="true" ismustinput="1" viewtype="0" onpropertychange="" temptitle="" name="cf_<%=i%>" id="cf_<%=i%>">
										<select style="width:140px" class=inputstyle id="matrixCfield_<%=i%>" name="matrixCfield_<%=i%>"  onChange="selectShow(<%=i%>);changetype(<%=i%>);changetype2(<%=i%>)" style="float:left;">
														<%
		  						String matrixfid = "";
						  	  	String fname = "";
						  	  	String fdesc = "";
							
									 String sql = "select id,fieldname,displayname from MatrixFieldInfo where fieldtype='0' and  matrixid = "+ matrix ;
								  	recordSet.executeSql(sql);
								  	while(recordSet.next()){
								  	     matrixfid = recordSet.getString("id");
								  	  	 fname = recordSet.getString("fieldname");
								  	  	 fdesc = recordSet.getString("displayname");
										 
										// issystem =   RecordSet.getString("issystem");
							  	%>	 		
							  	<%
								if(gdmd.getCondition_field().equals(matrixfid)){	%>
								<option  value="<%=gdmd.getCondition_field()%>" selected><%=gdmd.getConditionFieldName(matrixUtil, gdMatrix.getMatrix())%> 
						  			</option>
								
								<%}else{%>
									<option value=<%=matrixfid%>>
							  			<%=fdesc%>
						  			</option>
								<%}
								}%>
								</select>
							  	<!--	<option  value="<%=gdmd.getCondition_field()%>"><%=gdmd.getConditionFieldName(matrixUtil, gdMatrix.getMatrix())%>
						  			</option>-->
									</div>
										</td>
							
										<td class = "wf">
											   <div class = "wf">
											<!--<brow:browser viewType="0" name="wf"
												browserValue='<%=gdmd.getWorkflow_field()%>'
												getBrowserUrlFn="getFieldUrl"
												hasInput="true" isSingle="true" hasBrowser="true"
												isMustInput="1" completeUrl='<%=valueFieldCompleteUrl%>'
												browserSpanValue='<%=gdmd.getWorkflowFieldName(recordSet, isbill, formid, user.getLanguage())%>'></brow:browser> -->
												  <input type="hidden" issingle="true" ismustinput="1" viewtype="0" onpropertychange="" temptitle="" name="wf_<%=i%>" id="wf_<%=i%>">
										<select style="width:140px" class=inputstyle id="matrixRulefield_<%=i%>" name="matrixRulefield_<%=i%>"  onChange="selectShow(<%=i%>)" style="float:left;">
									 						<%
		  						String matrixruleid = "";
						  	  	String rulename = "";
						  	  	String ruledescr = "";
								String sqlstr = "";
								String browsertypeid= "";
								sqlstr = "select * from MatrixFieldInfo where fieldtype='0'  and id=" + gdmd.getCondition_field() ;
								recordSet.executeSql(sqlstr);
								if(recordSet.next()){
								browsertypeid = recordSet.getString("browsertypeid");
								 }
						 

							
								
if("1".equals(browsertypeid) || "17".equals(browsertypeid)){		 
   if(isbill.equals("0")){
	sqlstr = "  select distinct(workflow_formfield.fieldid) as id,fieldname as name,workflow_fieldlable.fieldlable as label,workflow_formdict.fieldhtmltype as htmltype,workflow_formdict.type as type,workflow_formdict.fielddbtype as dbtype,workflow_formfield.isdetail as isdetail,workflow_formfield.groupid,workflow_formfield.fieldorder from workflow_formfield,workflow_formdict,workflow_fieldlable where workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.isdefault = '1' and workflow_formdict.fieldhtmltype!=6 and not(workflow_formdict.fieldhtmltype=2 and workflow_formdict.type=2) and workflow_formdict.fieldhtmltype=3 and workflow_fieldlable.fieldid =workflow_formfield.fieldid and workflow_formdict.id = workflow_formfield.fieldid and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formdict.type in (1,17,165,166) and workflow_formfield.formid=" + formid;
   }
	if(isbill.equals("1")){	
	  sqlstr = "select distinct(t1.id) as id,t1.fieldname as name,t1.fieldlabel as label,t1.fieldhtmltype as htmltype,t1.type as type, t1.fielddbtype as dbtype,t1.viewtype as isdetail,t1.detailtable,t1.dsporder from workflow_billfield t1 where (t1.viewtype is null or t1.viewtype!=1) and t1.billid = "+ formid +" and t1.fieldhtmltype!=6 and not(t1.fieldhtmltype=2 and t1.type=2) and t1.type in (1,17,165,166) and t1.fieldhtmltype = 3";
	}
	  }
	    if("4".equals(browsertypeid) || "57".equals(browsertypeid)){		
   if(isbill.equals("0")){
	sqlstr = "  select distinct(workflow_formfield.fieldid) as id,fieldname as name,workflow_fieldlable.fieldlable as label,workflow_formdict.fieldhtmltype as htmltype,workflow_formdict.type as type,workflow_formdict.fielddbtype as dbtype,workflow_formfield.isdetail as isdetail,workflow_formfield.groupid,workflow_formfield.fieldorder from workflow_formfield,workflow_formdict,workflow_fieldlable where workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.isdefault = '1' and workflow_formdict.fieldhtmltype!=6 and not(workflow_formdict.fieldhtmltype=2 and workflow_formdict.type=2) and workflow_formdict.fieldhtmltype=3 and workflow_fieldlable.fieldid =workflow_formfield.fieldid and workflow_formdict.id = workflow_formfield.fieldid and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formdict.type in (4,57,167,168) and workflow_formfield.formid=" + formid;
   }
	if(isbill.equals("1")){	
	  sqlstr = "select distinct(t1.id) as id,t1.fieldname as name,t1.fieldlabel as label,t1.fieldhtmltype as htmltype,t1.type as type, t1.fielddbtype as dbtype,t1.viewtype as isdetail,t1.detailtable,t1.dsporder from workflow_billfield t1 where (t1.viewtype is null or t1.viewtype!=1) and t1.billid = "+ formid +" and t1.fieldhtmltype!=6 and not(t1.fieldhtmltype=2 and t1.type=2) and t1.type in (4,57,167,168) and t1.fieldhtmltype=3 ";
	 // System.out.println("---72-sqlstr-"+sqlstr);
	}
	  }
	      if("8".equals(browsertypeid) || "135".equals(browsertypeid)){		 
   if(isbill.equals("0")){
	sqlstr = "  select distinct(workflow_formfield.fieldid) as id,fieldname as name,workflow_fieldlable.fieldlable as label,workflow_formdict.fieldhtmltype as htmltype,workflow_formdict.type as type,workflow_formdict.fielddbtype as dbtype,workflow_formfield.isdetail as isdetail,workflow_formfield.groupid,workflow_formfield.fieldorder from workflow_formfield,workflow_formdict,workflow_fieldlable where workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.isdefault = '1' and workflow_formdict.fieldhtmltype!=6 and not(workflow_formdict.fieldhtmltype=2 and workflow_formdict.type=2) and workflow_formdict.fieldhtmltype=3 and workflow_fieldlable.fieldid =workflow_formfield.fieldid and workflow_formdict.id = workflow_formfield.fieldid and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formdict.type in (8,135) and workflow_formfield.formid=" + formid;
   }
	if(isbill.equals("1")){	
	  sqlstr = "select distinct(t1.id) as id,t1.fieldname as name,t1.fieldlabel as label,t1.fieldhtmltype as htmltype,t1.type as type, t1.fielddbtype as dbtype,t1.viewtype as isdetail,t1.detailtable,t1.dsporder from workflow_billfield t1 where (t1.viewtype is null or t1.viewtype!=1) and t1.billid = "+ formid +" and t1.fieldhtmltype!=6 and not(t1.fieldhtmltype=2 and t1.type=2) and t1.type in (8,135) and t1.fieldhtmltype=3 ";
	}
	  }
	      if("7".equals(browsertypeid) || "18".equals(browsertypeid)){
   if(isbill.equals("0")){
	sqlstr = "  select distinct(workflow_formfield.fieldid) as id,fieldname as name,workflow_fieldlable.fieldlable as label,workflow_formdict.fieldhtmltype as htmltype,workflow_formdict.type as type,workflow_formdict.fielddbtype as dbtype,workflow_formfield.isdetail as isdetail,workflow_formfield.groupid,workflow_formfield.fieldorder from workflow_formfield,workflow_formdict,workflow_fieldlable where workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.isdefault = '1' and workflow_formdict.fieldhtmltype!=6 and not(workflow_formdict.fieldhtmltype=2 and workflow_formdict.type=2) and workflow_formdict.fieldhtmltype=3 and workflow_fieldlable.fieldid =workflow_formfield.fieldid and workflow_formdict.id = workflow_formfield.fieldid and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formdict.type in (7,18) and workflow_formfield.formid=" + formid;
   }
	if(isbill.equals("1")){	
	  sqlstr = "select distinct(t1.id) as id,t1.fieldname as name,t1.fieldlabel as label,t1.fieldhtmltype as htmltype,t1.type as type, t1.fielddbtype as dbtype,t1.viewtype as isdetail,t1.detailtable,t1.dsporder from workflow_billfield t1 where (t1.viewtype is null or t1.viewtype!=1) and t1.billid = "+ formid +" and t1.fieldhtmltype!=6 and not(t1.fieldhtmltype=2 and t1.type=2) and t1.type in (7,18) and t1.fieldhtmltype=3 ";
	}
	  }

	      if("164".equals(browsertypeid) || "194".equals(browsertypeid)){		 
   if(isbill.equals("0")){
	sqlstr = "  select distinct(workflow_formfield.fieldid) as id,fieldname as name,workflow_fieldlable.fieldlable as label,workflow_formdict.fieldhtmltype as htmltype,workflow_formdict.type as type,workflow_formdict.fielddbtype as dbtype,workflow_formfield.isdetail as isdetail,workflow_formfield.groupid,workflow_formfield.fieldorder from workflow_formfield,workflow_formdict,workflow_fieldlable where workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.isdefault = '1' and workflow_formdict.fieldhtmltype!=6 and not(workflow_formdict.fieldhtmltype=2 and workflow_formdict.type=2) and workflow_formdict.fieldhtmltype=3 and workflow_fieldlable.fieldid =workflow_formfield.fieldid and workflow_formdict.id = workflow_formfield.fieldid and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formdict.type in (164,194,169,170) and workflow_formfield.formid=" + formid;
   }
	if(isbill.equals("1")){	
	  sqlstr = "select distinct(t1.id) as id,t1.fieldname as name,t1.fieldlabel as label,t1.fieldhtmltype as htmltype,t1.type as type, t1.fielddbtype as dbtype,t1.viewtype as isdetail,t1.detailtable,t1.dsporder from workflow_billfield t1 where (t1.viewtype is null or t1.viewtype!=1) and t1.billid = "+ formid +" and t1.fieldhtmltype!=6 and not(t1.fieldhtmltype=2 and t1.type=2) and t1.type in (164,194,169,170) and t1.fieldhtmltype=3 ";
	}
	  }
	     if("24".equals(browsertypeid)||"278".equals(browsertypeid)){	
   if(isbill.equals("0")){
	sqlstr = "  select distinct(workflow_formfield.fieldid) as id,fieldname as name,workflow_fieldlable.fieldlable as label,workflow_formdict.fieldhtmltype as htmltype,workflow_formdict.type as type,workflow_formdict.fielddbtype as dbtype,workflow_formfield.isdetail as isdetail,workflow_formfield.groupid,workflow_formfield.fieldorder from workflow_formfield,workflow_formdict,workflow_fieldlable where workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.isdefault = '1' and workflow_formdict.fieldhtmltype!=6 and not(workflow_formdict.fieldhtmltype=2 and workflow_formdict.type=2) and workflow_formdict.fieldhtmltype=3 and workflow_fieldlable.fieldid =workflow_formfield.fieldid and workflow_formdict.id = workflow_formfield.fieldid and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formdict.type in (24,278) and workflow_formfield.formid=" + formid;
   }
	if(isbill.equals("1")){	
	  sqlstr = "select distinct(t1.id) as id,t1.fieldname as name,t1.fieldlabel as label,t1.fieldhtmltype as htmltype,t1.type as type, t1.fielddbtype as dbtype,t1.viewtype as isdetail,t1.detailtable,t1.dsporder from workflow_billfield t1 where (t1.viewtype is null or t1.viewtype!=1) and t1.billid = "+ formid +" and t1.fieldhtmltype!=6 and not(t1.fieldhtmltype=2 and t1.type=2) and t1.type in (24,278) and t1.fieldhtmltype=3 ";
	}
	  }

		   if("161".equals(browsertypeid)){		
   if(isbill.equals("0")){
	sqlstr = "  select distinct(workflow_formfield.fieldid) as id,fieldname as name,workflow_fieldlable.fieldlable as label,workflow_formdict.fieldhtmltype as htmltype,workflow_formdict.type as type,workflow_formdict.fielddbtype as dbtype,workflow_formfield.isdetail as isdetail,workflow_formfield.groupid,workflow_formfield.fieldorder from workflow_formfield,workflow_formdict,workflow_fieldlable where workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.isdefault = '1' and workflow_formdict.fieldhtmltype!=6 and not(workflow_formdict.fieldhtmltype=2 and workflow_formdict.type=2) and workflow_formdict.fieldhtmltype=3 and workflow_fieldlable.fieldid =workflow_formfield.fieldid and workflow_formdict.id = workflow_formfield.fieldid and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formdict.type in (161,162) and workflow_formfield.formid=" + formid;
   }
	if(isbill.equals("1")){	
	  sqlstr = "select distinct(t1.id) as id,t1.fieldname as name,t1.fieldlabel as label,t1.fieldhtmltype as htmltype,t1.type as type, t1.fielddbtype as dbtype,t1.viewtype as isdetail,t1.detailtable,t1.dsporder from workflow_billfield t1 where (t1.viewtype is null or t1.viewtype!=1) and t1.billid = "+ formid +" and t1.fieldhtmltype!=6 and not(t1.fieldhtmltype=2 and t1.type=2) and t1.type in (161,162) and t1.fieldhtmltype=3 ";
	}
	  }

	     if("162".equals(browsertypeid)){		
   if(isbill.equals("0")){
	sqlstr = "  select distinct(workflow_formfield.fieldid) as id,fieldname as name,workflow_fieldlable.fieldlable as label,workflow_formdict.fieldhtmltype as htmltype,workflow_formdict.type as type,workflow_formdict.fielddbtype as dbtype,workflow_formfield.isdetail as isdetail,workflow_formfield.groupid,workflow_formfield.fieldorder from workflow_formfield,workflow_formdict,workflow_fieldlable where workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.isdefault = '1' and workflow_formdict.fieldhtmltype!=6 and not(workflow_formdict.fieldhtmltype=2 and workflow_formdict.type=2) and workflow_formdict.fieldhtmltype=3 and workflow_fieldlable.fieldid =workflow_formfield.fieldid and workflow_formdict.id = workflow_formfield.fieldid and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formdict.type in (161) and workflow_formfield.formid=" + formid;
   }
	if(isbill.equals("1")){	
	  sqlstr = "select distinct(t1.id) as id,t1.fieldname as name,t1.fieldlabel as label,t1.fieldhtmltype as htmltype,t1.type as type, t1.fielddbtype as dbtype,t1.viewtype as isdetail,t1.detailtable,t1.dsporder from workflow_billfield t1 where (t1.viewtype is null or t1.viewtype!=1) and t1.billid = "+ formid +" and t1.fieldhtmltype!=6 and not(t1.fieldhtmltype=2 and t1.type=2) and t1.type in (161) and t1.fieldhtmltype=3 ";
	}
	  }


								  	recordSet2.executeSql(sqlstr);
								  	while(recordSet2.next()){
								  	     matrixruleid = recordSet2.getString("id");
								  	  	 rulename = recordSet2.getString("name");
										 
										 if ("0".equals(isbill)) {
										     ruledescr = Util.null2String(recordSet2.getString("label"));    
										 } else {
										     ruledescr = Util.null2String(SystemEnv.getHtmlLabelName(Util.getIntValue(recordSet2.getString("label")),user.getLanguage()));
										 }
										 
										// issystem =   RecordSet.getString("issystem");
							  	%>	 		
							  	<%
									//System.out.println("-gdmd.getWorkflow_field()---"+gdmd.getWorkflow_field());
								//System.out.println("-matrixruleid--"+matrixruleid);
								//System.out.println("-getWorkflowFieldName--"+gdmd.getWorkflowFieldName(recordSet, isbill, formid, user.getLanguage()));
								if(gdmd.getWorkflow_field().equals(matrixruleid)){	
									//System.out.println("-getWorkflowFieldName-2222-"+gdmd.getWorkflowFieldName(recordSet, isbill, formid, user.getLanguage()));
									%>
								<option  value="<%=gdmd.getWorkflow_field()%>" selected><%=gdmd.getWorkflowFieldName(recordSet, isbill, formid, user.getLanguage())%> 
						  			</option>
								
								<%}else{%>
									<option value=<%=matrixruleid%>>
							  			<%=ruledescr%>
						  			</option>
								<%}
								}
								  //分部
							        if ("164".equals(browsertypeid) || "194".equals(browsertypeid)) {
							            matrixruleid = "-13";
							            //创建人分部（系统字段）
							            ruledescr = SystemEnv.getHtmlLabelName(22788, user.getLanguage()) + SystemEnv.getHtmlLabelName(81913, user.getLanguage()) +  SystemEnv.getHtmlLabelName(28415, user.getLanguage()) + SystemEnv.getHtmlLabelName(82174, user.getLanguage());
							            %>
	                                    <option value=<%=matrixruleid%> <%=gdmd.getWorkflow_field().equals(matrixruleid)?"selected":"" %>>
	                                        <%=ruledescr%>
	                                    </option>
	                                <%
							        }
							      
							        //部门
							        if ("4".equals(browsertypeid) || "57".equals(browsertypeid)) {
							            matrixruleid = "-12";
							            //创建人部门（系统字段）
							            ruledescr = SystemEnv.getHtmlLabelName(19225, user.getLanguage()) + SystemEnv.getHtmlLabelName(81913, user.getLanguage()) +  SystemEnv.getHtmlLabelName(28415, user.getLanguage()) + SystemEnv.getHtmlLabelName(82174, user.getLanguage());
							            %>
                                        <option value=<%=matrixruleid%> <%=gdmd.getWorkflow_field().equals(matrixruleid)?"selected":"" %>>
                                            <%=ruledescr%>
                                        </option>
                                    <%
							        }
								
								%>
								
								
								</select>
							  		<!--<option  value="<%=gdmd.getWorkflow_field()%>"><%=gdmd.getWorkflowFieldName(recordSet, isbill, formid, user.getLanguage())%>
						  			</option>  -->
									</div>
										</td>
										<td></td>
									</tr>
									<tr class="Spacing" style="height:1px!important;display:;"><td class="paddingLeft0" colspan="4"><div class="intervalDivClass"></div></td></tr>
								<%
									i = i+1;	
									}%>
							</table>
						</wea:item>
					</wea:group>
				</wea:layout>
			</form>
			<%if ("1".equals(isDialog)) {%>
				<div id="zDialog_div_bottom" class="zDialog_div_bottom">
					<wea:layout type="2col">
						<wea:group context="">
							<wea:item type="toolbar">
								<input type="button" value="<%=SystemEnv.getHtmlLabelName(309, user.getLanguage())%>" class="e8_btn_cancel" onclick="parentDialog.close();">
							</wea:item>
						</wea:group>
					</wea:layout>
				</div>
				<script type="text/javascript">
					jQuery(document).ready(function(){
						resizeDialog(document);
						
					});
				</script>
			<%}%>
		<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>
		<script type="text/javascript">
			function save() {
				if (checkMatrix()) {
					var id = getMatrixValue();
					//var name = '<%=titlename%>('+jQuery('#vfspan span a').text()+')';
					var name = '<%=titlename%>('+jQuery("#matrixTmpfield").find("option:selected").text()+')';
					var returnjson = {id: id, name: name};
					if(parentDialog) {
						try {
							parentDialog.callback(returnjson);
						} catch(e) {}
		
						try {
							parentDialog.close(returnjson);
						} catch(e) {}
					} else {
						window.parent.parent.returnValue = returnjson;
						window.parent.parent.close();
					}
				} else {
					Dialog.alert('<%=SystemEnv.getHtmlLabelName(15859, user.getLanguage())%>');
				}
			}

			function cancel() {
				if(parentDialog) {
					try {
						parentDialog.close();
					} catch(e) {}
				} else {
					window.parent.parent.close();
				}
			}

	
   var insertindex = <%=i%>;






 function initMatrixRowNew(){
	 var  j= 0;
	 for(j=0;j<insertindex;j++){
		// alert("-412---"+jQuery("#matrixCfield_"+j).parent().parent().find('td.cf span').html())
	 var matrixCfield=jQuery("#matrixCfield_"+j).val();
	   var formid = <%=formid%>;
		var isbill = <%=isbill%> ;
		var typeid;
		var temp;
			if(matrixCfield>-1){
		jQuery.ajax({
		url:"/matrixmanage/pages/matrixbrowserOp.jsp",
		type:"post",
		data:{"j":j,"matrixCfield":matrixCfield,"formid":formid,"isbill":isbill,"operator":"6"},
		dataType: "text",
		complete: function(){
		},
		success:function (returnValues, textStatus) {
	    	if (returnValues == undefined || returnValues == null) {
	    		alert("<%=SystemEnv.getHtmlLabelName(129417, user.getLanguage())%>");
	    		return;
	    	} else {
					
				   temp = returnValues.trim();
				   j = temp.substring(0,temp.indexOf(","))	;
					typeid = temp.substring(temp.indexOf(",")+1,temp.length)
				   if(162 == typeid){
						 jQuery("#matrixCfield_"+j).parent().parent().find('div.cf span').after('<span id = "rule_'+j+'">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(346, user.getLanguage())%></span>');
					//   jQuery("#matrixRulefield_"+insertindex).parent().before('<div id = Brule_"'+insertindex+'">包含</span>');
				  // lastRow.find('div.wf span').before('包含');
				   } else{
				   		jQuery("#matrixCfield_"+j).parent().parent().find('div.cf span').after('<span id = "rule_'+j+'">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(353, user.getLanguage())%></span>');
				   }
				
	    	}
	      }
	   });

			}


	 
	 }


}



				function addMatrixRowNew(){
	Matrix(insertindex);
	var lastRow = jQuery('<tr class="data"><td style="padding-left: 30px !important;"><input type="checkbox" value="'+ insertindex+ '" /></td><td><div class="cf"><span></span></div></td><td><div class="wf"><span></span></div></td><td></td></tr>');
	var lineRow = jQuery('<tr class="Spacing" style="height:1px!important;display:;"><td class="paddingLeft0" colspan="4"><div class="intervalDivClass"></div></td></tr>');
	var matrixTable = jQuery('#matrixTable');
	var formid = <%=formid%>;
	var isbill = <%=isbill%> ;
	var issystem;
	matrixTable.append(lastRow);
	matrixTable.append(lineRow);
	lastRow.jNice();
	
	 lastRow.find('div.cf span').append('<input type="hidden" issingle="true" ismustinput="1" viewtype="0" onpropertychange="" temptitle="" name="cf_'+ insertindex+ '" id="cf_'+ insertindex+ '" ><select style="width:140px" class=inputstyle id="matrixCfield_'+ insertindex+ '"  name="matrixCfield_'+ insertindex+ '" onchange = "selectShow('+ insertindex+ ');changetype('+ insertindex+ ');changetype2('+ insertindex+ ')" style="float:left;">'+jQuery("#__max1").html()+'</select>');

	 lastRow.find('div.cf span').append('<span id = "rule_'+insertindex+'">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(353, user.getLanguage())%></span>');

	lastRow.find('div.wf span').append('<input type="hidden" issingle="true" ismustinput="1" viewtype="0" onpropertychange="" temptitle="" name="wf_'+ insertindex+ '" id="wf_'+ insertindex+ '"> <select style="width:140px" class=inputstyle id="matrixRulefield_'+ insertindex+ '" name="matrixRulefield_'+ insertindex+ '"  onchange = "selectShow('+ insertindex+ ')"  style="float:left;">'+jQuery("#__max2").html()+'</select>');

	//matrixTable.append('<tr class="Spacing" style="height:1px!important;"><td colspan="8" class="paddingLeft0Table"><div class="intervalDivClass"></div></td></tr>');
	setTimeout(function () {
		changetype(insertindex);
		changetype2(insertindex);
		selectShow(insertindex);
		insertindex = insertindex+1;
	}, 500);

}

function changetype2(insertindex){
		 //jQuery("#matrixRulefield_"+insertindex).find('div.cf span').after('2221212');
		// alert("-2312-insertindex---"+insertindex);
		 var matrixCfield=jQuery("#matrixCfield_"+insertindex).val();
	   var formid = <%=formid%>;
		var isbill = <%=isbill%> ;
		var typeid;
		//alert("-2317-matrixCfield---"+matrixCfield);
			if(matrixCfield>-1){
		jQuery.ajax({
		url:"/matrixmanage/pages/matrixbrowserOp.jsp",
		type:"post",
		data:{"matrixCfield":matrixCfield,"formid":formid,"isbill":isbill,"operator":"5"},
		dataType: "text",
		complete: function(){
		},
		success:function (returnValues, textStatus) {
	    	if (returnValues == undefined || returnValues == null) {
	    		alert("<%=SystemEnv.getHtmlLabelName(129417, user.getLanguage())%>");
	    		return;
	    	} else {
					
				   typeid = returnValues.trim();
				
				   if(162 == typeid){
					
					 //alert("----162----"+jQuery("#rule_"+insertindex).html());
						jQuery("#rule_"+insertindex).html('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(346, user.getLanguage())%>');
					//   jQuery("#matrixRulefield_"+insertindex).parent().before('<div id = Brule_"'+insertindex+'">包含</span>');
				  // lastRow.find('div.wf span').before('包含');
				   }else{
						jQuery("#rule_"+insertindex).html('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(353, user.getLanguage())%>');
				   }
				
	    	}
	      }
	   });

			}
	
	}



	function Matrix(insertindex){
		   
		var formid = <%=formid%>;
		var isbill = <%=isbill%> ;
	  	var matrixTmp=<%=matrix%>;
	    var issystem;
			   jQuery.ajax({
		url:"/matrixmanage/pages/matrixbrowserOp.jsp",
		type:"post",
		data:{"matrixTmp":matrixTmp,"operator":"0"},
		dataType: "text",
		complete: function(){
		},
		success:function (returnValues, textStatus) {
	    	if (returnValues == undefined || returnValues == null) {
	    		alert("<%=SystemEnv.getHtmlLabelName(129417, user.getLanguage())%>");
	    		return;
	    	} else {
				if(insertindex){
				jQuery("#matrixCfield_"+insertindex).html(returnValues.trim());	
				jQuery("#matrixCfield_"+insertindex).selectbox("detach")
				__jNiceNamespace__.beautySelect("#matrixCfield_"+insertindex)
					jQuery("#__max1").html(returnValues.trim());
				jQuery("#__max1").selectbox("detach")
				__jNiceNamespace__.beautySelect("#__max1")
				}else{
				 // alert("----0-returnValues.trim()---"+returnValues.trim());
				jQuery("[id^=matrixCfield]").html(returnValues.trim());
				
				jQuery("[id^=matrixCfield]").selectbox("detach")
				__jNiceNamespace__.beautySelect("[id^=matrixCfield]")
					jQuery("#__max1").html(returnValues.trim());
				jQuery("#__max1").selectbox("detach")
				__jNiceNamespace__.beautySelect("#__max1")
				}
				//alert(jQuery("matrixCfield").html());
	    	}
	      }
	   });

	      jQuery.ajax({
		url:"/matrixmanage/pages/matrixbrowserOp.jsp",
		type:"post",
		data:{"matrixTmp":matrixTmp,"operator":"2"},
		dataType: "text",
		complete: function(){
		},
		success:function (returnValues, textStatus) {
	    	if (returnValues == undefined || returnValues == null) {
	    		alert("<%=SystemEnv.getHtmlLabelName(129417, user.getLanguage())%>");
	    		return;
	    	} else {
				// alert("----0-returnValues.trim()---"+returnValues.trim());
					issystem = returnValues.trim();
					//jQuery("#issystem").val(returnValues.trim());
					if(issystem ==1 || issystem==2)   {
						//alert("----0-issystem.trim()---"+issystem);
						//jQuery("#matrixCfield").attr("disabled","disabled");
						jQuery("[id^=matrixCfield]").attr("disabled","disabled");	
						jQuery("[id^=matrixCfield]").selectbox("detach")
				__jNiceNamespace__.beautySelect("[id^=matrixCfield]")
					}else{
						   jQuery("[id^=matrixCfield]").removeAttr("disabled");	
						jQuery("[id^=matrixCfield]").selectbox("detach")
				__jNiceNamespace__.beautySelect("[id^=matrixCfield]")
						}
	    	}
	      }
	   });
	  
	    jQuery.ajax({
		url:"/matrixmanage/pages/matrixbrowserOp.jsp",
		type:"post",
		data:{"formid":formid,"isbill":isbill,"operator":"3"},
		dataType: "text",
		complete: function(){
		},
		success:function (returnValues, textStatus) {
	    	if (returnValues == undefined || returnValues == null) {
	    		alert("<%=SystemEnv.getHtmlLabelName(129417, user.getLanguage())%>");
	    		return;
	    	} else {
				if(insertindex){
				  // alert("----0-returnValues.trim()---"+returnValues.trim());
				jQuery("#matrixRulefield"+insertindex).html(returnValues.trim());
				 jQuery("#__max2").html(returnValues.trim());
				jQuery("#matrixRulefield_"+insertindex).selectbox("detach")
				__jNiceNamespace__.beautySelect("#matrixRulefield_"+insertindex)
				
				}else{
				 //alert("----3-returnValues.trim()---"+returnValues.trim());
				 if(window.console)console.log("----3-returnValues.trim()---"+returnValues.trim());
				jQuery("[id^=matrixRulefield]").html(returnValues.trim());
				jQuery("#__max2").html(returnValues.trim());
				jQuery("[id^=matrixRulefield]").selectbox("detach")
				__jNiceNamespace__.beautySelect("[id^=matrixRulefield]")
				//alert(jQuery("#matrixRulefield").html());
				}
					changetype(insertindex);
	    	}
	      }
	   });	

	   if(insertindex)	{
	   	changetype(insertindex);
	   }else{
	   var matrixTableRows = jQuery('#matrixTable tr.data');
	    //alert("--insertindex-matrixTableRows.length-"+matrixTableRows.length);
		if(matrixTableRows){
		indexinsert =0;
		for(indexinsert=0;indexinsert<matrixTableRows.length;indexinsert++){
			 changetype(insertindex);
		}
		}
	   }   
	
	}

function changetype(insertindex){

	var matrixTableRows = jQuery('#matrixTable tr.data');
if(typeof(insertindex) ==  "undefined"){
	insertindex = 0;
   for(insertindex=0;insertindex<matrixTableRows.length;insertindex++){
	   var matrixCfield=jQuery("#matrixCfield_"+insertindex).val();
	   var formid = <%=formid%>;
		var isbill = <%=isbill%> ;
		//alert("--insertindex-2312--"+insertindex);
		//alert("--matrixCfield--2312-"+matrixCfield);
			if(matrixCfield>-1){
		jQuery.ajax({
		url:"/matrixmanage/pages/matrixbrowserOp.jsp",
		type:"post",
		data:{"matrixCfield":matrixCfield,"formid":formid,"isbill":isbill,"operator":"4"},
		dataType: "text",
		complete: function(){
		},
		success:function (returnValues, textStatus) {
	    	if (returnValues == undefined || returnValues == null) {
	    		alert("<%=SystemEnv.getHtmlLabelName(129417, user.getLanguage())%>");
	    		return;
	    	} else {
				insertindex = insertindex-1;
				//jQuery("#matrixRulefield_"+insertindex).html(returnValues.trim());
				//jQuery("#matrixRulefield_"+insertindex).selectbox("detach")
				//__jNiceNamespace__.beautySelect("#matrixRulefield_"+insertindex)
				jQuery("[id^=matrixRulefield_]").html(returnValues.trim());
				jQuery("[id^=matrixRulefield_]").selectbox("detach")
				__jNiceNamespace__.beautySelect("[id^=matrixRulefield_]")
				//alert(jQuery("#matrixRulefield_"+(insertindex-1)).html());
	    	}
	      }
	   });

			}
}
}else{
	var matrixCfield=jQuery("#matrixCfield_"+insertindex).val();
	   var formid = <%=formid%>;
		var isbill = <%=isbill%> ;
		//alert("--matrixCfield---"+matrixCfield);
			if(matrixCfield>-1){
		jQuery.ajax({
		url:"/matrixmanage/pages/matrixbrowserOp.jsp",
		type:"post",
		data:{"matrixCfield":matrixCfield,"formid":formid,"isbill":isbill,"operator":"4"},
		dataType: "text",
		complete: function(){
		},
		success:function (returnValues, textStatus) {
	    	if (returnValues == undefined || returnValues == null) {
	    		alert("<%=SystemEnv.getHtmlLabelName(129417, user.getLanguage())%>");
	    		return;
	    	} else {
				
	
				jQuery("#matrixRulefield_"+insertindex).html(returnValues.trim());
				jQuery("#matrixRulefield_"+insertindex).selectbox("detach")
				__jNiceNamespace__.beautySelect("#matrixRulefield_"+insertindex)
				//alert(jQuery("#matrixTmpfield"));
				//alert(jQuery("#matrixTmpfield").html());
	    	}
	      }
	   });

			}

}
}

function selectShow(insertindex){

	if(document.getElementById("matrixTmp")){
		 // document.getElementById("matrix").setAttribute("value",document.getElementById("matrixTmp").getAttribute("value")); 
		  document.getElementById("matrix").value=document.getElementById("matrixTmp").value;
	}	 
	if(document.getElementById("matrixTmpfield")){
	     document.getElementById("vf").value=document.getElementById("matrixTmpfield").value;
		// document.getElementById("vf").setAttribute("value",document.getElementById("matrixTmpfield").getAttribute("value")); 
	 }
	 if(document.getElementById("matrixCfield_"+insertindex)){
		// document.getElementById("cf_"+insertindex).setAttribute("value",document.getElementById("matrixCfield_"+insertindex).getAttribute("value")); 
		 document.getElementById("cf_"+insertindex).value=document.getElementById("matrixCfield_"+insertindex).value;
	 }
	 if(document.getElementById("matrixRulefield_"+insertindex)){
		 //document.getElementById("wf_"+insertindex).setAttribute("value",document.getElementById("matrixRulefield_"+insertindex).getAttribute("value"));
		 document.getElementById("wf_"+insertindex).value=document.getElementById("matrixRulefield_"+insertindex).value;
	 }
	 
	}

		jQuery(document).ready(function(){
						//resizeDialog(document);
						initMatrixRowNew();
					});
		</script>
		<jsp:include page="/workflow/workflow/editOperatorGroupMatrixScript.jsp"></jsp:include>
	</body>
</html>
