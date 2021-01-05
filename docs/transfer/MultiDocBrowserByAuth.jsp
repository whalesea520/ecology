
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/hrm/header.jsp" %>
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page" />
<jsp:useBean id="DocSearchForMonitorComInfo" class="weaver.docs.search.DocSearchForMonitorComInfo" scope="session" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="UserDefaultManager" class="weaver.docs.tools.UserDefaultManager" scope="session" />
<jsp:useBean id="ShareManager" class="weaver.share.ShareManager" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="scc" class="weaver.docs.category.SecCategoryComInfo" scope="page" />	
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />	
<%@ page import="weaver.common.StringUtil" %>	
<%
	String imagefilename = "/images/hdSystem_wev8.gif";
	String titlename =SystemEnv.getHtmlLabelName(1207, user.getLanguage());
	String needfav ="1";
	String needhelp ="";
	
	int searchflag =Util.getIntValue(request.getParameter("searchflag"));
	String doctitle =Util.toScreenToEdit(request.getParameter("doctitle"),user.getLanguage());
	String docsubject =Util.toScreenToEdit(request.getParameter("docsubject"),user.getLanguage());
	if(searchflag==1) docsubject=doctitle;
	
	String isDialog ="1";//Util.null2String(request.getParameter("isDialog"));
	String fromid =Util.null2String(request.getParameter("fromid"));
	String toid =Util.null2String(request.getParameter("toid"));
	String _type =Util.null2String(request.getParameter("type"));
	String selectedstrs =Util.null2String(request.getParameter("idStr"));
	String jsonSql =Tools.getURLDecode(request.getParameter("jsonSql"));
	String oldJson =jsonSql;
	jsonSql =Tools.replace(jsonSql,"\"","\\\\\"");
	boolean isHidden =Boolean.valueOf(Util.null2String(request.getParameter("isHidden")));
	
	String codeName = Util.null2String(request.getParameter("codeName"));
  if(codeName.startsWith("auth")) codeName=codeName.substring(4);

	String qname =Util.null2String(request.getParameter("qname"));

	String eventName =Util.null2String(request.getParameter("eventName"));
	String eventCode =Util.null2String(request.getParameter("eventCode"));
	String eventType =Util.null2String(request.getParameter("eventType"));
	String eventWorkFlowName =Util.null2String(request.getParameter("eventWorkFlowName"));
	
	int isgoveproj =Util.getIntValue(IsGovProj.getPath(),0);//0:非政务系统，1：政务系统
	String needSubmit =Util.null2String(request.getParameter("needSubmit"));
	String ishow =Util.null2String(request.getParameter("ishow"));
	
	String loginType = user.getLogintype() ;
	String fromSearch = Util.null2String(request.getParameter("fromSearch"));
	
	String path= Util.null2String(request.getParameter("path"));
	String mainCategory = Util.null2String(request.getParameter("mainCategory"));
	String subCategory= Util.null2String(request.getParameter("subCategory"));
	String secCategory= Util.null2String(request.getParameter("secCategory"));
	String departmentId= Util.null2String(request.getParameter("departmentId"));
	String docCreaterId = Util.null2String(request.getParameter("docCreaterIdSelected"));
	if(docCreaterId.equals("")){
		docCreaterId = Util.null2String(request.getParameter("docCreaterIdSelected1"));
	}
	String userType = Util.null2String(request.getParameter("userType"));
	String docCreateDateFrom = Util.null2String(request.getParameter("docCreateDateFrom"));
	String docCreateDateTo = Util.null2String(request.getParameter("docCreateDateTo"));
	if (!secCategory.equals("")) path = scc.getAllParentName(secCategory,true);
	
	String docStatusSearch = Util.null2String(request.getParameter("docStatusSearch"));
	DocSearchForMonitorComInfo.resetSearchInfo() ;
	DocSearchForMonitorComInfo.setDocsubject(docsubject);
	DocSearchForMonitorComInfo.setMaincategory(mainCategory);
	DocSearchForMonitorComInfo.setSubcategory(subCategory);
	DocSearchForMonitorComInfo.setSeccategory(secCategory);
	DocSearchForMonitorComInfo.setDoccreaterid(docCreaterId);
	DocSearchForMonitorComInfo.setDocdepartmentid(departmentId);
	DocSearchForMonitorComInfo.setUsertype(userType);
	DocSearchForMonitorComInfo.setDoccreatedateFrom(docCreateDateFrom);
	DocSearchForMonitorComInfo.setDoccreatedateTo(docCreateDateTo);
	DocSearchForMonitorComInfo.setDocStatusSearch(docStatusSearch);
	
	String _completeUrl = userType.equals("1")?"/data.jsp":"/data.jsp?type=7";
	
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
			parentDialog.checkDataChange = false;

			function onBtnSearchClick() {
				jQuery("#searchfrm").submit();
			}

			function doAdvancedSearch() {
				jQuery('#topTitle input[name="qname"]').val('');
				jQuery("#searchfrm").submit();
			}

			function doCloseDialog() {
				parentDialog.close();
			}

			function setSelectBoxValue(selector, value) {
				if (value == null) {
					value = jQuery(selector).find('option').first().val();
				}
				jQuery(selector).selectbox('change',value,jQuery(selector).find('option[value="'+value+'"]').text());
			}

			function doReset() {
				//input
				jQuery('#advancedSearchDiv input:text').val('');
				//select
				jQuery('#advancedSearchDiv select').each(function() {
					setSelectBoxValue(this);
				});
			}
		</script>
	</head>
	<BODY>
		<%if("1".equals(isDialog)){ %>
			<div class="zDialog_div_content">
		<%} %>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
			if (!isHidden) {
				RCMenu += "{"+SystemEnv.getHtmlLabelName(555,user.getLanguage())+",javascript:selectDone(),_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
				RCMenu += "{"+SystemEnv.getHtmlLabelNames("172,332",user.getLanguage())+",javascript:selectAll(),_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
			}
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<form action="" name="searchfrm" id="searchfrm">
			<input type=hidden name="isHidden" value="<%=isHidden%>">
			<input type=hidden name="isDialog" value="<%=isDialog%>">
			<input type=hidden name="cmd" value="closeDialog">
			<input type=hidden name="fromid" value="<%=fromid%>">
			<input type=hidden name="toid" value="<%=toid%>">
			<input type=hidden name="type" value="<%=_type%>">
			<input type=hidden name="idStr" value="<%=selectedstrs%>">
			<input type=hidden name="jsonSql" value="<%=xssUtil.put(Tools.getURLEncode(oldJson))%>">
			<input type=hidden name="isDelType" value="0">
			<input type=hidden name="selectAllSql" value="">
			<input type=hidden name="needExecuteSql" value="0">
			<input type=hidden name="codeName" value="<%=codeName%>">
			<input type=hidden id="searchflag" name="searchflag" value="">
			
			<table id="topTitle" cellpadding="0" cellspacing="0">
				<tr>
					<td></td>
					<td class="rightSearchSpan" style="text-align:right;">
						<%if (!isHidden) {%>
						<input type=button class="e8_btn_top" onclick="selectDone();" value="<%=SystemEnv.getHtmlLabelName(555,user.getLanguage())%>"></input>
						<input type=button class="e8_btn_top" onclick="selectAll();" value="<%=SystemEnv.getHtmlLabelNames("172,332",user.getLanguage())%>"></input>
						<%}%>
						<input type="text" class="searchInput" name="docsubject" value="<%=docsubject %>"/>
						<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span><span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
					</td>
				</tr>
			</table>
			<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >
				<input type="hidden" name="_completeUrl" id="_completeUrl" value="<%=_completeUrl %>"/>
				<wea:layout type="4col" attributes="{'expandAllGroup':'true'}">
					<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
						<wea:item><%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%></wea:item>
						<wea:item><input type="text"  class=InputStyle id="doctitle"  name="doctitle" value='<%=doctitle%>'></wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(16398,user.getLanguage())%></wea:item>
						<wea:item>
			
					 <span >
						<brow:browser viewType="0" name="secCategory" browserValue='<%=secCategory%>' idKey="id" nameKey="path"
						 browserUrl="/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategorySingleBrowser.jsp"
						 hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
						 completeUrl="/data.jsp?type=categoryBrowser&onlySec=true" linkUrl="#" width="80%"
						browserSpanValue='<%=path%>'></brow:browser>
					</span>

			<input type=hidden name=mainCategory value="<%=mainCategory%>">
			<INPUT type=hidden name=subCategory value="<%=subCategory%>">
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%></wea:item>
		<wea:item>
			<span style="float:left;">
			  <select class=inputstyle  name=userType id="userType" onChange="onChangeUserType(this.value)" style="width:110px;">
				  <%if(isgoveproj==0){%>
				  <option value="1" <%if(userType.equals("1")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(362,user.getLanguage())%></option>
				  <option value="2" <%if(userType.equals("2")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%></option>
			  <%}else{%>
			  <option value="1" <%if(userType.equals("1")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(20098,user.getLanguage())%></option>
			  <%}%>
			  </select>
			  </span>
			  <span id="crmAndHrm" style="">
			   <span id="hrm" >
					<brow:browser viewType="0" name="docCreaterIdSelected" browserValue='<%=userType.equals("1")?(""+docCreaterId):"" %>' 
					 browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
					 hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
					 completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" width="49%"
					browserSpanValue='<%=(!docCreaterId.equals("")&&userType.equals("1"))?Util.toScreen(ResourceComInfo.getResourcename(docCreaterId+""),user.getLanguage()):""%>'></brow:browser>
				</span>
			   <span id="crm" >
					<brow:browser viewType="0" name="docCreaterIdSelected1" browserValue='<%=userType.equals("2")?(""+docCreaterId):"" %>' 
					 browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp"
					 hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
					 completeUrl="/data.jsp?type=7" linkUrl="#" width="49%"
					browserSpanValue='<%=(!docCreaterId.equals("")&&userType.equals("2"))?Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(docCreaterId+""),user.getLanguage()):""%>'></brow:browser>
				</span>
			  </span>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(722,user.getLanguage())%></wea:item>
		<wea:item>
			<span class="wuiDateSpan" selectId="doccreatedateselect">
			    <input class=wuiDateSel type="hidden" name="docCreateDateFrom" value="<%=docCreateDateFrom%>">
			    <input class=wuiDateSel  type="hidden" name="docCreateDateTo" value="<%=docCreateDateTo%>">
			</span>
		</wea:item>
		
		</wea:group>
		<wea:group context="" attributes="{'groupDisplay':'none'}">
			<wea:item type="toolbar">
				<input type="submit" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" class="e8_btn_submit" onclick="changeSearchFlag();"/>
				<span class="e8_sep_line">|</span>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>" class="e8_btn_cancel" onclick="resetCondtion();"/>
				<span class="e8_sep_line">|</span>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
			</wea:item>
		</wea:group>
		</wea:layout>
			</div>
		</form>
		<%
			String tmptsql="";
			if("T149".equals(codeName)||"C148".equals(codeName)||"D128".equals(codeName)){
				tmptsql="select docid from DocShare where sharetype=1 and userid="+fromid;
			} else if("C247".equals(codeName)||"D227".equals(codeName)){
				tmptsql="select docid from DocShare where sharetype=3 and departmentid="+fromid;	
			} else if("C347".equals(codeName)||"D327".equals(codeName)){
				tmptsql="select docid from DocShare where sharetype=2 and subcompanyid="+fromid;		
			} else if("C437".equals(codeName)||"D417".equals(codeName)){
				tmptsql="select docid from DocShare where sharetype=4 and roleid="+fromid;			
			}
			
			String sqlWhere = " where " + DocSearchForMonitorComInfo.FormatSQLSearch(user.getLanguage());
			
			
			if("T148".equals(codeName)){
				sqlWhere +=" and (ishistory=0 or ishistory is null) and ownerid="+fromid;
			} else {
				sqlWhere +=" and docstatus in(1,2,5) and (ishistory=0 or ishistory is null) and id in("+tmptsql+")";	
			}
			
			
			//System.out.println("########:"+sqlWhere);
			
			String backfields = "id,ownerid,docsubject,seccategory,docextendname"; 
			String fromSql  = " from docdetail t1";
			String sqlOrderBy = "id" ;

			String tableString =" <table pageId=\""+PageIdConst.DOC_DOCTransferLIST+"\" instanceid=\"DocTransferTable\" tabletype=\"checkbox\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.DOC_DOCTransferLIST,user.getUID(),PageIdConst.DOC)+"\" >"+
												"	   <sql backfields=\""+backfields+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+sqlOrderBy+"\"  sqlprimarykey=\"id\" sqlsortway=\"Desc\" sqlisdistinct=\"true\"/>"+
                        "			<head>"+
                        "        <col width=\"10%\"  text=\" \" column=\"docextendname\" orderkey=\"docextendname\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocIconByExtendName\"/>"+
                        "				<col width=\"45%\"  text=\""+SystemEnv.getHtmlLabelName(58,user.getLanguage())+"\" labelid=\"58\" column=\"id\" otherpara=\"column:docsubject\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocNameForDocMonitor\"  orderkey=\"docsubject\"/>"+
												"				<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(79,user.getLanguage())+"\" labelid=\"79\" column=\"ownerid\" orderkey=\"ownerid\" otherpara=\"column:ownerType\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getName\"/>"+									 
												"				<col width=\"30%\" pkey=\"id+weaver.splitepage.transform.SptmForDoc.getAllDirName\" text=\""+SystemEnv.getHtmlLabelName(92,user.getLanguage())+"\" labelid=\"92\" column=\"secCategory\" orderkey=\"secCategory\"  transmethod=\"weaver.splitepage.transform.SptmForDoc.getAllDirName\"/>"+
												"			</head>"+   			
                        "</table>";

			StringBuilder _sql = new StringBuilder();
			_sql.append("select ").append("distinct id").append(fromSql).append(sqlWhere);

			rs.executeSql("select count(1) as count from (" + _sql.toString() + ") temp");
			long count = 0;
			if (rs.next()) {
				count = Long.parseLong(Util.null2String(rs.getString("count"), "0"));
			}
			//System.out.println("count:"+count);

			_sql = new StringBuilder(StringUtil.encode(_sql.toString()));
			
			MJson mjson = new MJson(oldJson, true);
			if (mjson.exsit(_type)) {
				mjson.updateArrayValue(_type, _sql.toString());
			} else {
				mjson.putArrayValue(_type, _sql.toString());
			}
			String oJson = Tools.getURLEncode(mjson.toString());
			mjson.removeArrayValue(_type);
			String nJson = Tools.getURLEncode(mjson.toString());
		%>
		<script>
			
			$GetEle("selectAllSql").value = encodeURI("<%=xssUtil.put(_sql.toString())%>");
		</script>
		<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' selectedstrs="<%=selectedstrs%>" mode="run" /> 
			
		<%if("1".equals(isDialog)){%>
		</div>
		<div id="zDialog_div_bottom" class="zDialog_div_bottom">
			<wea:layout type="2col">
	    	<wea:group context="">
		    	<wea:item type="toolbar">
		    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" class="e8_btn_cancel" onclick="parentDialog.close();">
		    	</wea:item>
		   	</wea:group>
	  	</wea:layout>
		</div>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
		
		jQuery(document).ready(function(){
			onChangeUserType(<%=Util.getIntValue(userType,1)%>);
		});
		
	</script>
	<%}%>
	<script type="text/javascript">
		function selectDone(id){
			if(!id){
				id = _xtable_CheckedCheckboxId();
			}
			if(!id){
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(20149,user.getLanguage())%>");
				return;
			}
			if(id.match(/,$/)){
				id = id.substring(0,id.length-1);
			}
			if (parentDialog) {
				var data = {
					type: '<%=_type%>',
					isAll: false,
					id: id,
					json: '<%=nJson%>'
				};
				parentDialog.callback(data);
				doCloseDialog();
			}
		}

		function selectAll(){
			if (parentDialog) {
				var data = {
					type: '<%=_type%>',
					isAll: true,
					count: <%=count%>,
					json: '<%=oJson%>'
				};
				parentDialog.callback(data);
				doCloseDialog();
			}
		}
		
		function onChangeUserType(userType) {
			jQuery("#docCreaterIdSelected").val("");
			jQuery("#docCreaterIdSelected1").val("");
			jQuery("#docCreaterIdSelectedspan").html("");
			jQuery("#docCreaterIdSelected1span").html("");
			if(userType==1){
				jQuery("#crm").hide();
				jQuery("#hrm").show();
			}else if(userType==2){
				jQuery("#hrm").hide();
				jQuery("#crm").show();
			}
		}
		
		function changeSearchFlag(){
			jQuery("#searchflag").val(1);	
		}
		
	</script>
	</body>
</html>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
