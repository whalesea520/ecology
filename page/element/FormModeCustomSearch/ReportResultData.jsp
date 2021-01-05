<%@page import="weaver.formmode.service.CustomSearchService"%>
<%@page import="weaver.formmode.tree.CustomTreeUtil"%>
<%@page import="com.weaver.formmodel.util.StringHelper"%>
<%@page import="weaver.formmode.customjavacode.CustomJavaCodeRun"%>
<%@page import="weaver.formmode.service.CommonConstant"%>
<%@page import="weaver.servicefiles.DataSourceXML"%>
<%@page import="weaver.formmode.virtualform.VirtualFormHandler"%>
<%@page import="java.util.regex.Matcher"%>
<%@page import="java.util.regex.Pattern"%>
<%@page import="weaver.docs.docs.DocComInfo"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="weaver.interfaces.workflow.browser.Browser" %>
<%@page import="weaver.interfaces.workflow.browser.BrowserBean" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="weaver.formmode.tree.CustomTreeData"%>
<%
	request.setCharacterEncoding("UTF-8");
%>
<%@ include file="/page/maint/common/init.jsp"%>
<%@ page import="weaver.file.*,java.math.BigDecimal"%>
<%@ page import="weaver.workflow.report.ReportCompositorOrderBean"%>
<%@ page import="weaver.workflow.report.ReportCompositorListBean"%>
<%@ page import="weaver.workflow.report.ReportUtilComparator"%>
<jsp:useBean id="ModeShareManager" class="weaver.formmode.view.ModeShareManager" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs3" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs4" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs_Setting" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="FormModeRightInfo" class="weaver.formmode.search.FormModeRightInfo" scope="page" />
<jsp:useBean id="BrowserComInfo"
	class="weaver.workflow.field.BrowserComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo"
	class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo"
	class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="CostcenterComInfo"
	class="weaver.hrm.company.CostCenterComInfo" scope="page" />
<jsp:useBean id="JobTitlesComInfo"
	class="weaver.hrm.job.JobTitlesComInfo" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo"
	scope="page" />
<jsp:useBean id="CapitalAssortmentComInfo"
	class="weaver.cpt.maintenance.CapitalAssortmentComInfo" scope="page" />
<jsp:useBean id="CapitalComInfo"
	class="weaver.cpt.capital.CapitalComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo"
	class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="ProjectInfoComInfo"
	class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="RequestComInfo"
	class="weaver.workflow.request.RequestComInfo" scope="page" />
<jsp:useBean id="ReportComInfo"
	class="weaver.workflow.report.ReportComInfo" scope="page" />
<jsp:useBean id="CurrencyComInfo"
	class="weaver.fna.maintenance.CurrencyComInfo" scope="page" />
<jsp:useBean id="LedgerComInfo"
	class="weaver.fna.maintenance.LedgerComInfo" scope="page" />
<jsp:useBean id="ExpensefeeTypeComInfo"
	class="weaver.fna.maintenance.ExpensefeeTypeComInfo" scope="page" />
<jsp:useBean id="MDCompanyNameInfo"
	class="weaver.workflow.report.ReportShare" scope="page" />
<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile"
	scope="session" />
<jsp:useBean id="resourceConditionManager"
	class="weaver.workflow.request.ResourceConditionManager" scope="page" />
<jsp:useBean id="DocReceiveUnitComInfo"
	class="weaver.docs.senddoc.DocReceiveUnitComInfo" scope="page" />
<jsp:useBean id="DocTreeDocFieldComInfo"
	class="weaver.docs.category.DocTreeDocFieldComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo"
	class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="WorkflowJspBean"
	class="weaver.workflow.request.WorkflowJspBean" scope="page" />
<jsp:useBean id="FieldInfo" class="weaver.workflow.mode.FieldInfo"
	scope="page" />
<jsp:useBean id="FormModeTransMethod" class="weaver.formmode.search.FormModeTransMethod" scope="page" />
<jsp:useBean id="FormModeConfig" class="weaver.formmode.FormModeConfig" scope="page" />
<jsp:useBean id="ModeRightInfo" class="weaver.formmode.setup.ModeRightInfo" scope="page" />
<jsp:useBean id="rsm" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="baseBean" class="weaver.general.BaseBean" scope="page" />
<jsp:useBean id="esc" class="weaver.page.style.ElementStyleCominfo" scope="page" />
<jsp:useBean id="hpec" class="weaver.homepage.cominfo.HomepageElementCominfo" scope="page"/>
<%
    //报表id
	String customid = "";
	String fieldsWidth = "";
	String sqlBizListView = "";
	String formid = "";
	String strfields = "";
	String maintableAlias="t1";
	String detailtableAlias="d1";
	String detailfieldAlias="d_";
	HashMap hmEleSetting = new HashMap();
	String eid = Util.null2String(request.getParameter("eid"));
	String searchid = Util.null2String(request.getParameter("searchid"));
	String linkmode = Util.null2String(request.getParameter("linkmode"));
	String searchinfosql="select * from formmodeelement where id='"+searchid+"'";
	RecordSet.executeSql(searchinfosql);
	int countsearchinfosql = RecordSet.getCounts();
	String fe_fields="";
	String fe_fieldsWidth="";
	String fe_reportId="";
	int fe_isshowunread=0;
	String fe_isautoomit = "";
	while(RecordSet.next()){
		fe_reportId = Util.null2String(RecordSet.getString("reportId"));
		fe_fields = Util.null2String(RecordSet.getString("fields"));
		fe_fieldsWidth = Util.null2String(RecordSet.getString("fieldsWidth"));
		fe_isshowunread = Util.getIntValue(Util.null2String(RecordSet.getString("fieldsWidth")),0);
		fe_isautoomit = Util.null2String(RecordSet.getString("isautoomit"));
	}
	
	//modify by huguomin QC:263819   start
	String sqlhgm = "select a.fieldid, b.fieldname from mode_CustomDspField a left join workflow_billfield b on a.fieldid=b.id  where a.customid='"+fe_reportId+"' and isshow=1";
	RecordSet.executeSql(sqlhgm);
	Map idnameMap = new HashMap();		
	while (RecordSet.next()) {
		idnameMap.put(RecordSet.getString("fieldid"),RecordSet.getString("fieldname"));
	}
	String fe_fields_new = "";
	String fe_fieldsWidth_new = "";
	String [] fe_fieldslist = fe_fields.split(",");
	String [] fe_fieldsWidthlist = fe_fieldsWidth.split(",");
	for(int i = 0; i< fe_fieldslist.length; i++){
		if(!"".equals(idnameMap.get(fe_fieldslist[i])) || fe_fieldslist[i].indexOf("-") != -1){
			fe_fields_new += ","+fe_fieldslist[i];
			fe_fieldsWidth_new += ","+fe_fieldsWidthlist[i];
		}
	}
	if(fe_fields_new.indexOf(",") != -1){
		fe_fields = fe_fields_new.substring(1);
		fe_fieldsWidth = fe_fieldsWidth_new.substring(1);
	}else{
		fe_fields = fe_fields_new;
		fe_fieldsWidth = fe_fieldsWidth_new;
	}
	//modify by huguomin QC:263819   end
	sqlBizListView = "select * from hpElementSetting where eid='" + eid+ "'";
	
	RecordSet.executeSql(sqlBizListView);
	while (RecordSet.next()) {
		hmEleSetting.put(RecordSet.getString("name"),RecordSet.getString("value"));
	}
	
	int perpage = 0;
	perpage = Util.getIntValue(request.getParameter("perpage"),5);
	if(perpage<=0){
		perpage = 5;
	}
// 	customid = Util.null2String("" + hmEleSetting.get("reportId"));
	customid = fe_reportId;
	if(StringHelper.isEmpty(customid)){
		return;
	}
	session.setAttribute("page_formmode"+eid, customid);
	session.setAttribute("page_formmodeelementid"+eid, searchid);
	//查看权限判断==============================start
	boolean isRight = false;
	//自定义页面查看权限
	rs.executeSql("select * from mode_searchPageshareinfo where righttype=1 and pageid = " + customid);
	if(rs.next()){
		FormModeRightInfo.setUser(user);
		isRight = FormModeRightInfo.checkUserRight(Util.getIntValue(customid),1);
	}else{  //没有设置任何查看权限数据，则认为有权限查看
		isRight = true;
	}
	if(!isRight){
		%>
		<table>
			<tbody>
				<tr class="Section"><th style="font-size:8pt"> <%=SystemEnv.getHtmlLabelName(2012,user.getLanguage())%></th></tr>
			</tbody>
		</table>
		<%
		return;
	}
	//查看权限判断================================end
	
// 	strfields = Util.null2String("" + hmEleSetting.get("fields"));
	strfields = fe_fields;
	fieldsWidth = fe_fieldsWidth;
	int isshowtitle = Util.getIntValue(Util.null2String(hmEleSetting.get("isshowtitle")),1);
	String rolltype = Util.null2String(hmEleSetting.get("rolltype"));
	ArrayList<String> fields = new ArrayList<String>();
	String[] fieldsArray = strfields.split(",");
	String isbill = "1";
	String customname = "";
	String modeid = "0";
	String defaultsql = "";
	String detailtablename = "";
	String sql = "select a.modeid,a.defaultsql,a.formid,a.customname,a.norightlist,javafilename,searchConditionType,detailtable from mode_customsearch a where a.id = "+ customid;
	RecordSet.executeSql(sql);
	int countsql = RecordSet.getCounts();
	//modify by huguomin 20170828 QC:263819   start


	//modify by huguomin 20170828 QC:263819   end
	String norightlist="";
	while (RecordSet.next()) {
		detailtablename = Util.null2String(RecordSet.getString("detailtable"));
		formid = Util.null2String(RecordSet.getString("formid"));
		customname = Util
				.null2String(RecordSet.getString("customname"));
		modeid = Util.null2String(RecordSet.getString("modeid"));
		defaultsql = Util.null2String(RecordSet.getString("defaultsql"));
		if(!defaultsql.equals("")){
			defaultsql = FormModeTransMethod.getDefaultSql(user,"","",defaultsql);
		}
		String javafilename = Util.null2String(RecordSet.getString("javafilename"));
		String searchConditionType = Util.null2String(RecordSet.getString("searchConditionType"));
		if(searchConditionType.equals("2")&&!StringHelper.isEmpty(javafilename)){
			Map<String, String> sourceCodePackageNameMap = CommonConstant.SOURCECODE_PACKAGENAME_MAP;
			String sourceCodePackageName = sourceCodePackageNameMap.get("2");
			String classFullName = sourceCodePackageName + "." + javafilename;
			
			Map<String, Object> param = new HashMap<String, Object>();
			param.put("user", user);
			Object result = CustomJavaCodeRun.run(classFullName, param);
			defaultsql = Util.null2String(result);
		}
		
		norightlist = Util.null2String(RecordSet.getString("norightlist"));
	}
	//是否开启列表未读，反馈标识功能,1未读、2反馈和3已读
	boolean isenabled = FormModeConfig.isEnabled();
	boolean isVirtualForm = VirtualFormHandler.isVirtualForm(formid);
	String vdatasource = "";
	String vdatasourceDBtype = RecordSet.getDBType();
	String tablename = "";
	String vprimarykey = "";
	String vpkgentype = "";
	if (isVirtualForm) {
		Map<String, Object> vFormInfo = VirtualFormHandler
				.getVFormInfo(formid);
		vdatasource = Util.null2String(vFormInfo.get("vdatasource"));
		vprimarykey = Util.null2String(vFormInfo.get("vprimarykey"));
		vpkgentype = Util.null2String(vFormInfo.get("vpkgentype"));
		DataSourceXML dataSourceXML = new DataSourceXML();
		vdatasourceDBtype = dataSourceXML
				.getDataSourceDBType(vdatasource);
		
	}else{
		vprimarykey = "id";
		if(!StringHelper.isEmpty(modeid)&&!"0".equals(modeid)){
			if(StringHelper.isEmpty(defaultsql)){
				defaultsql +=  maintableAlias+".formmodeid="+modeid;
			}else{
				defaultsql += " and "+maintableAlias+".formmodeid="+modeid;
			}
		}
	}
	RecordSet.executeSql("select tablename from workflow_bill where id = "+formid);
	if(RecordSet.next())
		tablename = RecordSet.getString(1);
	if(isVirtualForm)
		tablename = VirtualFormHandler.getRealFromName(tablename);
	List fieldids = new ArrayList();
	List fieldnames = new ArrayList();
	List fieldLabels = new ArrayList();
	List fielddbtypes = new ArrayList();
	List htmltypes = new ArrayList();
	List types = new ArrayList();
	List viewtypes = new ArrayList();
	List isstats = new ArrayList();
	List statvalues = new ArrayList();
	List tempstatvalues = new ArrayList();
	List isdetails = new ArrayList();
	String requestid = "";
	boolean isnew = true;
	List isdborders = new ArrayList();

	ArrayList compositorOrderList = new ArrayList();
	ArrayList compositorColList = new ArrayList();
	ArrayList compositorColList2 = new ArrayList();

	List ids = new ArrayList();
	List isMains = new ArrayList();
	List isShows = new ArrayList();
	List isCheckConds = new ArrayList();
	List colnames = new ArrayList();
	List htmlTypes = new ArrayList();
	List typeTemps = new ArrayList();
	List opts = new ArrayList();
	List values = new ArrayList();
	List names = new ArrayList();
	List opt1s = new ArrayList();
	List value1s = new ArrayList();
	List hreflinks = new ArrayList();
	List istitles = new ArrayList();
	List detailtablefieldnames = new ArrayList();
	
	int ordercount=0;
	String detailkeyfield = "";
	String fieldname = "";
	String orderbystr ="";

	ReportCompositorOrderBean reportCompositorOrderBean = new ReportCompositorOrderBean();
	ReportCompositorListBean rcListBean = new ReportCompositorListBean();
	ReportCompositorListBean rcColListBean = new ReportCompositorListBean();
	Map<String, Integer> fieldShowingTransferedStatusMap = new HashMap<String, Integer>();

	sql = " select a.fieldname , c.labelname, a.fieldhtmltype, a.type,a.fielddbtype, "
			+ " b.isstat , a.viewtype , a.id ,a.detailtable,"
			+ " b.queryorder,b.isorder,b.priorder,a.fielddbtype,b.ordertype, b.showmethod "
			+ " from  workflow_billfield a, mode_CustomDspField b , HtmlLabelInfo c "
			+ " where a.id = b.fieldid and a.fieldlabel = c.indexid "
			+ " and b.customid = "
			+ customid
			+ " and  c.languageid = "
			+ user.getLanguage() +" order by priorder ";
	RecordSet.executeSql(sql);
	while (RecordSet.next()) {
		if (strfields.indexOf(Util.null2String(RecordSet
				.getString("id"))) == -1) {
			continue;
		}
		fieldShowingTransferedStatusMap.put(RecordSet.getString("id"), RecordSet.getInt("showmethod"));
		
		String viewtype = Util.null2String(RecordSet
				.getString("viewtype"));
		if (viewtype.equals("1")) {
			viewtype = detailtableAlias;
			//detailtablename = Util.null2String(RecordSet.getString("detailtable"));
			detailtablefieldnames.add(Util.null2String(RecordSet.getString("fieldname")));
		} else {
			viewtype = maintableAlias;
		}
		rcListBean = new ReportCompositorListBean();
		rcListBean.setCompositorList(strfields.indexOf(RecordSet
				.getString("id")));
		rcListBean.setSqlFlag(viewtype);
		rcListBean.setFieldName(Util.null2String(RecordSet
				.getString("fieldname")));
		rcListBean.setFieldId(Util.null2String(RecordSet
				.getString("id")));
		rcListBean.setColName(Util.toScreen(
				RecordSet.getString("labelname"), user.getLanguage()));
		compositorColList.add(rcListBean);
		fields.add(Util.null2String(RecordSet.getString("fieldname")));
		if (RecordSet.getInt("isorder") != 0&&!StringHelper.isEmpty(RecordSet.getString("isorder"))) {
			reportCompositorOrderBean = new ReportCompositorOrderBean();
			reportCompositorOrderBean.setCompositorOrder(RecordSet
					.getInt("priorder"));
			reportCompositorOrderBean.setOrderType(Util
					.null2String(RecordSet
							.getString("ordertype")));
			String ordertmpfieldname = Util.null2String(RecordSet.getString("fieldname"));
			reportCompositorOrderBean.setFieldName(ordertmpfieldname);
			reportCompositorOrderBean.setSqlFlag(viewtype);
			compositorOrderList.add(reportCompositorOrderBean);
		}

	}
	
	//只有显示请求说明时才执行下面的操作
	if (strfields.indexOf("-1") != -1) {
		RecordSet
				.executeSql("select * from mode_CustomDspField where customid = "
						+ customid + " and fieldid = -1");
		if (RecordSet.next()) {
			rcListBean = new ReportCompositorListBean();
			rcListBean.setCompositorList(strfields.indexOf("-1"));
			
			rcListBean.setSqlFlag(maintableAlias);
			rcListBean.setFieldName("modedatacreatedate");
			rcListBean.setFieldId("-1");
			rcListBean.setColName(SystemEnv.getHtmlLabelName(722,
					user.getLanguage()));
			compositorColList.add(rcListBean);
			fields.add("modedatacreatedate");
			//fielddbtypes.add("char(10)");
			if (RecordSet.getInt("isorderfield") > 0) {
				reportCompositorOrderBean = new ReportCompositorOrderBean();
				reportCompositorOrderBean.setCompositorOrder(RecordSet
						.getInt("priorder"));
				reportCompositorOrderBean.setOrderType(Util
						.null2String(getOrderSql(RecordSet
								.getInt("isorderfield"))));
				reportCompositorOrderBean
						.setFieldName("modedatacreatedate");
				reportCompositorOrderBean.setSqlFlag(maintableAlias);
				compositorOrderList.add(reportCompositorOrderBean);
			}
		}
	}

	if (strfields.indexOf("-2") != -1) {
		RecordSet
				.executeSql("select * from mode_CustomDspField where customid = "
						+ customid + " and fieldid = -2");
		if (RecordSet.next()) {
			rcListBean = new ReportCompositorListBean();
			rcListBean.setCompositorList(strfields.indexOf("-2"));
			rcListBean.setSqlFlag(maintableAlias);
			rcListBean.setFieldName("modedatacreater");
			rcListBean.setFieldId("-2");
			rcListBean.setColName(SystemEnv.getHtmlLabelName(882,
					user.getLanguage()));
			compositorColList.add(rcListBean);
			fields.add("modedatacreater");
			//fielddbtypes.add("char(10)");
			if (RecordSet.getInt("isorderfield") > 0) {
				reportCompositorOrderBean = new ReportCompositorOrderBean();
				reportCompositorOrderBean.setCompositorOrder(RecordSet
						.getInt("priorder"));
				reportCompositorOrderBean.setOrderType(Util
						.null2String(getOrderSql(RecordSet
								.getInt("isorderfield"))));
				reportCompositorOrderBean
						.setFieldName("modedatacreater");
				reportCompositorOrderBean.setSqlFlag(maintableAlias);
				compositorOrderList.add(reportCompositorOrderBean);
			}
		}
	}
	
	
	compositorColList2 = ReportComInfo
			.getCompositorList(compositorColList);
	List<String> titlefields = new ArrayList<String>();
	for (int a = 0; a < fieldsArray.length; a++) {
		String tempfieldid = fieldsArray[a];
		RecordSet
				.executeSql("select * from mode_CustomDspField where customid = "
						+ customid
						+ " and fieldid = "
						+ tempfieldid);
		if (RecordSet.next()) {
			String istitle = RecordSet.getString("istitle");
			String hreflink = RecordSet.getString("hreflink");
			if(!"0".equals(istitle)){
				titlefields.add(tempfieldid);
			}
			
			if ("-1".equals(tempfieldid) || "-2".equals(tempfieldid)) {
				fieldShowingTransferedStatusMap.put(tempfieldid, RecordSet.getInt("showmethod"));
				htmltypes.add(tempfieldid);
				hreflinks.add("");
				istitles.add("0");
				types.add(tempfieldid);
				viewtypes.add("0");
				isdetails.add("");
				if("-1".equals(tempfieldid)){
					fieldnames.add(maintableAlias+".modedatacreatedate");
					fieldLabels.add(SystemEnv.getHtmlLabelName(722,user.getLanguage()));
					fieldids.add(tempfieldid);
					fielddbtypes.add("varchar");
				}else{
					fieldnames.add(maintableAlias+".modedatacreater");
					fieldLabels.add(SystemEnv.getHtmlLabelName(882,user.getLanguage()));
					fieldids.add(tempfieldid);
					fielddbtypes.add("varchar");
				}
			} else {
				if (!formid.equals("")) {
					rs2.executeSql("select * from workflow_billfield where id = "
							+ tempfieldid
							+ " and billid="
							+ formid);
					if (rs2.next()) {
						htmltypes.add(Util.null2String(rs2
								.getString("fieldhtmltype")));
						types.add(Util.null2String(rs2
								.getString("type")));
						viewtypes.add(Util.null2String(rs2.getString("viewtype")));
						
						String detailtabletmp = Util.null2String(rs2
								.getString("detailtable"));
						hreflinks.add(hreflink);
						istitles.add(istitle);
						if (!"".equals(detailtabletmp)) {
							isdetails.add("1");
							fieldnames.add(detailtableAlias+"."+Util.null2String(rs2.getString("fieldname"))+" as "+detailfieldAlias+Util.null2String(rs2.getString("fieldname")));
						} else {
							isdetails.add("");
							fieldnames.add(maintableAlias+"."+Util.null2String(rs2.getString("fieldname")));
						}
						fieldids.add(tempfieldid);
						fielddbtypes.add(Util.null2String(rs2.getString("fielddbtype")));
						fieldLabels.add(SystemEnv.getHtmlLabelName(Util.getIntValue(rs2.getString("fieldlabel")),user.getLanguage()));
					}
				}
			}
		}
	}
	
	//String ordersql = ReportComInfo.getCompositorOrderByStrs(compositorOrderList);
	String ordersql =  "";
	CustomSearchService CustomSearchService = new CustomSearchService();
	if(isVirtualForm){	//虚拟表单
		ordersql += CustomSearchService.getOrderSQL(customid);
		if(!ordersql.equals("")){
			ordersql += ",";
		}
		ordersql += "t1." + vprimarykey+" desc";
	} else { //实际表单
		ordersql += CustomSearchService.getOrderSQL(customid);
		if(!ordersql.equals("")){
			ordersql += ",";
		}
		ordersql += "t1.id desc";
	}
	
	if(!"".equals(detailtablename)){
		ordersql+=","+detailtableAlias+".id desc";
	}
	ordersql = " order by "+ordersql;
	String rightsql = "";
	List<User> lsUser = ModeRightInfo.getAllUserCountList(user);
	if(!isVirtualForm){
		if(modeid.equals("")||modeid.equals("0")){//查询中没有设置模块
			String sqlStr1 = "select id,modename from modeinfo where formid='"+formid+"' order by id";
			rsm.executeSql(sqlStr1);
			while(rsm.next()){
				String mid = rsm.getString("id");
				ModeShareManager.setModeId(Util.getIntValue(mid,0));
				for(int i=0;i<lsUser.size();i++){
					User tempUser = lsUser.get(i);
					String tempRightStr = ModeShareManager.getShareDetailTableByUser("formmode",tempUser);
					if(rightsql.isEmpty()){
						rightsql += tempRightStr;
					}else {
						rightsql += " union  all "+ tempRightStr;
					}
				}
			}
			if(!rightsql.isEmpty()){
				rightsql = " (SELECT  sourceid,MAX(sharelevel) AS sharelevel from ( "+rightsql+" ) temptable group by temptable.sourceid) ";
			}
		}else{
			ModeShareManager.setModeId(Util.getIntValue(modeid,0));
			for(int i=0;i<lsUser.size();i++){
				User tempUser = (User)lsUser.get(i);
				String tempRightStr = ModeShareManager.getShareDetailTableByUser("formmode",tempUser);
				if(rightsql.isEmpty()){
					rightsql += tempRightStr;
				}else {
					rightsql += " union  all "+ tempRightStr;
				}
			}
			if(!rightsql.isEmpty()){
				rightsql = " (SELECT  sourceid,MAX(sharelevel) AS sharelevel from ( "+rightsql+" ) temptable group by temptable.sourceid) ";
			}
		}
}
	//=================
	if(defaultsql.indexOf("PARM(")>-1){
			int beginIndex = defaultsql.indexOf("PARM(");
			while(beginIndex>-1){
				int endIndex = defaultsql.indexOf(")",beginIndex+5);
				int nextIndex = 0;
				if(endIndex>-1){
					String substring = defaultsql.substring(beginIndex+5, endIndex);
					if(request.getParameter(substring)==null){
						beginIndex = defaultsql.indexOf("PARM(",endIndex-nextIndex+1);
					}else{
						String paramvalue = Util.null2String(request.getParameter(substring));
						defaultsql = defaultsql.replace("PARM("+substring+")", paramvalue);
						if(paramvalue.length()<substring.length()){
							nextIndex = substring.length()-paramvalue.length();
						}
						beginIndex = defaultsql.indexOf("PARM(",endIndex-nextIndex+1);
					}
				}else{
					break;
				}
			}
	}
	//=================	
	String querysql = getQuerySql(tablename, detailtablename,fieldnames,fielddbtypes,defaultsql,perpage,vdatasourceDBtype,ordersql,rightsql,norightlist,vprimarykey);
	String[] fieldsWidthArray =  null;
	String tdExtendStyle = "";
	if(!tablename.isEmpty()){
		if(isVirtualForm){
			RecordSet.executeSql(querysql, vdatasource);
		}else{
			RecordSet.executeSql(querysql);
		}
		fieldsWidthArray =  fieldsWidth.split(","); 
		if("1".equals(fe_isautoomit)){
			tdExtendStyle = "overflow:hidden;white-space:nowrap;word-break:keep-all;text-overflow:ellipsis;";
		}
	}
%>
<TABLE style="width: 100%;display: <%=isshowtitle==1?"":"none"%>;table-layout:fixed;">
	<TR style="width:100%;">
		<TH style="width: 1%">&nbsp;</TH>
		<%
			if(countsearchinfosql<2 && countsql == 0){
			%>	
			    	<TH title="<%=SystemEnv.getHtmlLabelName(382469,user.getLanguage()) %>" style="text-align:left;width:100%;color:red"><%=SystemEnv.getHtmlLabelName(382469,user.getLanguage()) %></TH>
		    <%}else if(customid==null || "".equals(customid) || strfields==null || "".equals(strfields)){%>
					<TH title="<%=SystemEnv.getHtmlLabelName(382469,user.getLanguage()) %>" style="text-align:left;width:100%;color:red"><%=SystemEnv.getHtmlLabelName(382469,user.getLanguage()) %></TH>
			<%}else{
		
				for (int i = 0; i < fieldsArray.length; i++) {
					String fWidth =  fieldsWidthArray[i];
			%>
				<TH title="<%=Util.null2String(fieldLabels.get(i))%>" style="text-align:left;width:<%=fWidth%>;<%=tdExtendStyle%>"><font class='font'><font class='font'><%=Util.null2String(fieldLabels.get(i))%></font></font></TH>
		<%
				}
			}
		%>
	</TR>
</TABLE>
<%
double height=18*RecordSet.getCounts();
if("Up".equals(rolltype)||"Down".equals(rolltype)) {
	out.println("<MARQUEE DIRECTION="+rolltype.toLowerCase()+"  id=\"MARQUEE_"+eid+"\" onmouseover=\"MARQUEE_"+eid+".stop()\" onmouseout=\"MARQUEE_"+eid+".start()\"  SCROLLDELAY=200 width=\"100%\" height=\""+height+"\">");
}else if("Left".equals(rolltype)||"Right".equals(rolltype)) {
	out.println("<MARQUEE DIRECTION="+rolltype.toLowerCase()+"  id=\"MARQUEE_"+eid+"\" onmouseover=\"MARQUEE_"+eid+".stop()\" onmouseout=\"MARQUEE_"+eid+".start()\"  SCROLLDELAY=200>");
}
%>
<TABLE class="elementdatatable"  style="width:100%;table-layout:fixed;">
		<%
		String imgSymbol="";
		if (!"".equals(esc.getIconEsymbol(hpec.getStyleid(eid)))){
 			imgSymbol="<img name='esymbol' src='"+esc.getIconEsymbol(hpec.getStyleid(eid))+"'>";
 		}else{
 			imgSymbol = "<IMG name=esymbol src='/images/homepage/style/style1/esymbol_wev8.gif'>";
 		}
		 while(RecordSet.next()){
		 %>
		 <tr style="height: 18;width:100%" >
		 	<TD style="width: 1%"><%=imgSymbol %></TD>
		  <%
							for (int i = 0; i < fieldsArray.length; i++) {
								String fWidth =  fieldsWidthArray[i];
								String result = Util.null2String(RecordSet
										.getString(i + 1));
										
								String tempFieldId = fieldsArray[i];
								String tempFieldValue = result;
								String tempdbtype = (String)fielddbtypes.get(i);
								String tempviewtype = (String)viewtypes.get(i);
								//customid 已经有值
								String htmltype = (String) htmltypes.get(i);
								int type = Util.getIntValue((String) types
										.get(i));
								String hreflink =(String)hreflinks.get(i);
								int istitle = Util.getIntValue((String) istitles
										.get(i),0);
								String results[] = null;
								String billid_id = RecordSet.getString("id");
								if(htmltype.equals("1")){
									result = "<font class=font>"+result+"</font>";
									if(hreflink.indexOf("$")>-1){
										hreflink = changehreflink(hreflink,tablename,vdatasource,billid_id,formid);
									}
									/*if(istitle==1){
										//result = "<a href='javascript:void(0)' onclick=openFullWindowForXtable('"+hreflink+"') >"+result+"</a>";
									}else if(istitle==2){
										if(linkmode.equals("2")){
											result = "<a href=\"javascript:modeopenFullWindowHaveBar('"+hreflink+"','"+eid+"_"+billid_id+"')\" >"+result+"</a>";
										}else{
											result = "<a href='"+hreflink+"' target='_self' >"+result+"</a>";
										}
									}else if(istitle==3){
										if(linkmode.equals("2")){
											result = "<a href=\"javascript:modeopenFullWindowHaveBar('"+hreflink+"','"+eid+"_"+billid_id+"')\" >"+result+"</a>";
										}else{
											result = "<a  href='"+hreflink+"' target='_self'>"+result+"</a>";
										}
									}*/
								}
								if (htmltype.equals("-2")) {
									result = Util.toScreen(ResourceComInfo
											.getResourcename(result), user
											.getLanguage());
									result = "<font class=font>"+result+"</font>";
								}else if (htmltype.equals("3")) {
									switch (type) {
									case 1://人力资源
										if(istitle != 0){
											result = ResourceComInfo.getResourcename(result);
										}else{
											result = Util.toScreen(ResourceComInfo
													.getMulResourcename1(result), user
													.getLanguage());
										}
										break;
									case 23:
										result = Util.toScreen(CapitalComInfo
												.getCapitalname(result), user
												.getLanguage());
										break;
									case 4://部门
										if(istitle != 0){
											result = DepartmentComInfo.getDepartmentname(result);
										}else{
											result = Util
													.toScreen(
															DepartmentComInfo
																	.getDepartmentnameToLink(result),
															user.getLanguage());
										}
										break;
									case 6:
										result = Util
												.toScreen(
														CostcenterComInfo
																.getCostCentername(result),
														user.getLanguage());
										break;
									case 7:
										result = Util
												.toScreen(
														CustomerInfoComInfo
																.getCustomerInfoname(result),
														user.getLanguage());
										break;
									case 8:
										result = Util
												.toScreen(
														ProjectInfoComInfo
																.getProjectInfoname(result),
														user.getLanguage());
										break;
									case 9://文档
										if(istitle != 0){
											result = DocComInfo.getDocname(result);
										}else{
											result = Util.toScreen(
													DocComInfo.getMuliDocName2(result),
													user.getLanguage());
										}
										break;
									case 12:
										result = Util.toScreen(CurrencyComInfo
												.getCurrencyname(result), user
												.getLanguage());
										break;
									case 25:
										result = Util
												.toScreen(
														CapitalAssortmentComInfo
																.getAssortmentName(result),
														user.getLanguage());
										break;
									case 14:
									case 15:
										result = Util.toScreen(LedgerComInfo
												.getLedgername(result), user
												.getLanguage());
										break;
									case 16://单流程
										if(istitle == 0){
											result = "<a href=\"/workflow/request/ViewRequest.jsp?requestid="+result+"\" target=\"_new\">"+Util.toScreen(RequestComInfo
												.getRequestname(result), user
												.getLanguage())+"</a>";
										}else{
											result = Util.toScreen(RequestComInfo
												.getRequestname(result), user
												.getLanguage());
										}
										break;
									case 17:
										results = Util.TokenizerString2(result,
												",");
										if (results != null) {
											for (int j = 0; j < results.length; j++) {
												if (j == 0)
													result = Util
															.toScreen(
																	ResourceComInfo
																			.getMulResourcename1(results[j]),
																	user.getLanguage());
												else
													result += ","
															+ Util.toScreen(
																	ResourceComInfo
																			.getMulResourcename1(results[j]),
																	user.getLanguage());
											}
										}
										break;
									case 18:
										results = Util.TokenizerString2(result,
												",");
										if (results != null) {
											for (int j = 0; j < results.length; j++) {
												if (j == 0)
													result = Util
															.toScreen(
																	CustomerInfoComInfo
																			.getCustomerInfoname(results[j]),
																	user.getLanguage());
												else
													result += ","
															+ Util.toScreen(
																	CustomerInfoComInfo
																			.getCustomerInfoname(results[j]),
																	user.getLanguage());
											}
										}
										break;
									case 24:
										result = Util.toScreen(JobTitlesComInfo
												.getJobTitlesname(result), user
												.getLanguage());
										break;
									case 37: // 增加多文档处理
										results = Util.TokenizerString2(result,
												",");
										if (results != null) {
											for (int j = 0; j < results.length; j++) {
												if (j == 0)
													result = Util
															.toScreen(
																	DocComInfo
																			.getMuliDocName2(results[j]),
																	user.getLanguage());
												else
													result += ","
															+ Util.toScreen(
																	DocComInfo
																			.getMuliDocName2(results[j]),
																	user.getLanguage());
											}
										}
										break;
									case 57: // 增加多部门处理
										results = Util.TokenizerString2(result,
												",");
										if (results != null) {
											for (int j = 0; j < results.length; j++) {
												if (j == 0)
													result = Util
															.toScreen(
																	DepartmentComInfo
																			.getDepartmentnameToLink(results[j]),
																	user.getLanguage());
												else
													result += ","
															+ Util.toScreen(
																	DepartmentComInfo
																			.getDepartmentnameToLink(results[j]),
																	user.getLanguage());
											}
										}
										break;
									case 2:
										break;
									case 19:
										break;
									case 42: //分部
										result = Util
												.toScreen(
														SubCompanyComInfo
																.getSubCompanynameToLink(result),
														user.getLanguage());
										break;
										
									case 164: //增加分部
										if(istitle != 0){
											result = SubCompanyComInfo.getSubCompanyname(result);
										}else{
											result = Util
													.toScreen(
															SubCompanyComInfo
																	.getSubCompanynameToLink(result),
															user.getLanguage());
										}
										break;
									case 194: //增加多分部
										results = Util.TokenizerString2(result,
										",");
											if (results != null) {
												for (int j = 0; j < results.length; j++) {
													if (j == 0)
														result = Util
																.toScreen(
																		SubCompanyComInfo
																			.getSubCompanynameToLink(results[j]),
																		user.getLanguage());
													else
														result += ","
																+ Util.toScreen(
																		SubCompanyComInfo
																			.getSubCompanynameToLink(results[j]),
																		user.getLanguage());
												}
											}
										break;
									case 65: //多角色处理 added xwj for td2127 on 2005-06-20
										Map roleMap = new HashMap();
										String sql_ = "select ID,RolesName from HrmRoles";
										rs.executeSql(sql_);
										while (rs.next()) {
											roleMap.put(rs.getString("ID"),
													rs.getString("RolesName"));
										}
										results = Util.TokenizerString2(result,
												",");
										if (results != null) {
											for (int j = 0; j < results.length; j++) {
												if (j == 0)
													result = Util
															.toScreen(
																	(String) roleMap
																			.get(results[j]),
																	user.getLanguage());
												else
													result += ","
															+ Util.toScreen(
																	(String) roleMap
																			.get(results[j]),
																	user.getLanguage());
											}
										}
										break;
									case 141:
										//人力资源条件
										result = resourceConditionManager
												.getFormShowName(result,
														user.getLanguage());
										break;
									case 142:
										//收发文单位
										results = Util.TokenizerString2(result,
												",");
										if (results != null) {
											for (int j = 0; j < results.length; j++) {
												if (j == 0)
													result = Util
															.toScreen(
																	DocReceiveUnitComInfo
																			.getReceiveUnitName(results[j]),
																	user.getLanguage());
												else
													result += ","
															+ Util.toScreen(
																	DocReceiveUnitComInfo
																			.getReceiveUnitName(results[j]),
																	user.getLanguage());
											}
										}
										break;
									case 143:
										//树状文档
										results = Util.TokenizerString2(result,
												",");
										if (results != null) {
											for (int j = 0; j < results.length; j++) {
												if (j == 0)
													result = Util
															.toScreen(
																	DocTreeDocFieldComInfo
																			.getTreeDocFieldName(results[j]),
																	user.getLanguage());
												else
													result += ","
															+ Util.toScreen(
																	DocTreeDocFieldComInfo
																			.getTreeDocFieldName(results[j]),
																	user.getLanguage());
											}
										}
										break;
									case 152:
										//多请求
										results = Util.TokenizerString2(result,
												",");
										if (results != null) {
											result = "";
											for (int j = 0; j < results.length; j++) {
												String sql2 = "select "
														+ BrowserComInfo
																.getBrowsercolumname(""
																		+ type)
														+ " from "
														+ BrowserComInfo
																.getBrowsertablename(""
																		+ type)
														+ " where "
														+ BrowserComInfo
																.getBrowserkeycolumname(""
																		+ type)
														+ "=" + results[j];
												rs.executeSql(sql2);
												while (rs.next()) {
													result += "<a href=\"/workflow/request/ViewRequest.jsp?requestid="+results[j]+"\" target=\"_new\">"+Util.toScreen(
															rs.getString(1),
															user.getLanguage())+"</a>"
															+ ",";
												}
											}
											if (!result.equals(""))
												result = result.substring(0,
														result.length() - 1);
										}
										break;
									case 135:
										//多项目
										results = Util.TokenizerString2(result,
												",");
										if (results != null) {
											result = "";
											for (int j = 0; j < results.length; j++) {
												String sql2 = "select "
														+ BrowserComInfo
																.getBrowsercolumname(""
																		+ type)
														+ " from "
														+ BrowserComInfo
																.getBrowsertablename(""
																		+ type)
														+ " where "
														+ BrowserComInfo
																.getBrowserkeycolumname(""
																		+ type)
														+ "=" + results[j];
												rs.executeSql(sql2);
												while (rs.next()) {
													result += Util.toScreen(
															rs.getString(1),
															user.getLanguage())
															+ ",";
												}
											}
											if (!result.equals(""))
												result = result.substring(0,
														result.length() - 1);
										}
										break;
									case 161://自定义单选
									case 162:
										//自定义单选,多选
										if (!result.equals("")) {
											//获取字段的数据库类型
											String tempfid = (String) fieldids
													.get(i);
											String tempfdbtype = "";
											rs1.execute("select fielddbtype from workflow_billfield where id="
													+ tempfid);
											if (rs1.next())
												tempfdbtype = rs1
														.getString("fielddbtype");
											//modify by huguomin QC:292207 查询列表中的链接字段支持浏览框类型，除多选以外  ---此功能在门户建模中心使用不生效 start
											if(istitle!=0){
												 Browser browser=(Browser) StaticObj.getServiceByFullname(tempfdbtype, Browser.class);
										         BrowserBean bb=browser.searchById(result);
											     String name=Util.null2String(bb.getName());
												 result = name;
												break;
											}
											//modify by huguomin QC:292207 查询列表中的链接字段支持浏览框类型，除多选以外  ---此功能在门户建模中心使用不生效 start
											result = WorkflowJspBean
													.getWorkflowBrowserShowName(
															result, "" + type,
															"", "", tempfdbtype);
										}
										if (type == 162) {
											if (!result.equals(""))
												result = result.substring(0,
														result.length() - 1);
										}
										break;
									case 256://树形单选
										if(istitle!=0){
											String [] browserValArray = result.split("_");
											String sqlStr = "select b.tablename,b.tablekey,b.showfield,b.datacondition from mode_customtree a,mode_customtreedetail b"+
												" where a.id=b.mainid and a.id="+tempdbtype+"  and b.id="+browserValArray[0];
											rs1.executeSql(sqlStr);
											if(rs1.next()){
												String tablenameStr = rs1.getString("tablename");//表名
												String tablekey = rs1.getString("tablekey");//主字段
												String showfield = rs1.getString("showfield");//显示名称
												String shownamesql = "select "+showfield.toLowerCase()+" from "+tablenameStr+" where "+tablekey+" in ('"+browserValArray[1]+"')";
												CustomTreeData customTreeData = new CustomTreeData();
												String treedatasource =  customTreeData.getVdatasourceByNodeId(browserValArray[0]);
												if(vdatasource.equals("")){
													rs1.executeSql(shownamesql);
												}else{
													rs1.executeSql(shownamesql,vdatasource);
												}
												if(rs1.next()){
													result = rs1.getString(showfield.toLowerCase());
													break;
												}
											}
											
										}
									
									
									case 257:
						                	CustomTreeUtil customTreeUtil = new CustomTreeUtil();
						                	//获取字段的数据库类型
											String tempfid = (String) fieldids.get(i);
											String tempfdbtype = "";
											rs1.execute("select fielddbtype from workflow_billfield where id="+ tempfid);
											if (rs1.next())
												tempfdbtype = rs1.getString("fielddbtype");
											result = customTreeUtil.getTreeFieldShowName(result,tempfdbtype);
											//String result2 = "";
											//String[] tmpresult = result.split("</a>");
											//result = "";
											//for(int h=0;h<tmpresult.length;h++){
											//	String tmpresult2 = tmpresult[h].replaceAll("<a.*>", "");
											//	tmpresult2 = tmpresult2.replaceAll("&nbsp", "");
											//	if(StringHelper.isEmpty(tmpresult2)){
											//		continue;
											//	}
											//	result+=","+tmpresult2;
											//}
											//if(!StringHelper.isEmpty(result)){
											//	result = result.substring(1);
											//}
											break;
									case 171:
										results = Util.TokenizerString2(result,
										",");
										if (results != null) {
											result = "";
											for (int j = 0; j < results.length; j++) {
												String sql2 = "select "
														+ BrowserComInfo
																.getBrowsercolumname(""
																		+ type)
														+ " from "
														+ BrowserComInfo
																.getBrowsertablename(""
																		+ type)
														+ " where "
														+ BrowserComInfo
																.getBrowserkeycolumname(""
																		+ type)
														+ "=" + results[j];
												rs.executeSql(sql2);
												while (rs.next()) {
													result += "<a href=\"/workflow/request/ViewRequest.jsp?requestid="+results[j]+"\" target=\"_new\">"+Util.toScreen(
															rs.getString(1),
															user.getLanguage())+"</a>"
															+ ",";
												}
											}
											if (!result.equals(""))
												result = result.substring(0,
														result.length() - 1);
										}
										break;
									default:
										results = Util.TokenizerString2(result,
												",");
										if (results != null) {
											result = "";
											for (int j = 0; j < results.length; j++) {
												String sql2 = "select "
														+ BrowserComInfo
																.getBrowsercolumname(""
																		+ type)
														+ " from "
														+ BrowserComInfo
																.getBrowsertablename(""
																		+ type)
														+ " where "
														+ BrowserComInfo
																.getBrowserkeycolumname(""
																		+ type)
														+ "=" + results[j];
												rs.executeSql(sql2);
												while (rs.next()) {
													result += Util.toScreen(
															rs.getString(1),
															user.getLanguage())
															+ ",";
												}
											}
											if (!result.equals(""))
												result = result.substring(0,
														result.length() - 1);
										}
									}
									result = addFontAttributeForHrefText(result);
									
									result = "<font class=font>"+result+"</font>";
									
								}else if (htmltype.equals("5"))
								// 选择框字段
								{
									char flag = Util.getSeparator();
									if (!result.equals("")) {
										rs.executeProc(
												"workflow_SelectItemSByvalue",
												(String) fieldids.get(i) + flag
														+ isbill + flag
														+ result);
										if (rs.next()) {
											result = Util.toScreen(
													rs.getString("selectname"),
													user.getLanguage());
											/*if(istitle==1){
												
											}else if(istitle==2){
												if(linkmode.equals("2")){
													result = "<a href=\"javascript:modeopenFullWindowHaveBar('"+hreflink+"','"+eid+"_"+billid_id+"')\" >"+result+"</a>";
												}else{
													result = "<a href='"+hreflink+"' target='_self' >"+result+"</a>";
												}
											}else if(istitle==3){
												if(linkmode.equals("2")){
													result = "<a href=\"javascript:modeopenFullWindowHaveBar('"+hreflink+"','"+eid+"_"+billid_id+"')\" >"+result+"</a>";
												}else{
													result = "<a  href='"+hreflink+"' target='_self'>"+result+"</a>";
												}
											}*/
										} else {
											result = "";
										}
									} else {
										result = "";
									}
									result = "<font class=font>"+result+"</font>";
								}else if (htmltype.equals("6")) {
									switch (type) {
									case 1:
										result = Util.toScreen(getDoc(result,DocComInfo), user.getLanguage());										
										break;
									case 2:
										result = Util.toScreen(getDoc(result,DocComInfo), user.getLanguage());
										break;
									default:
									}
																		
								}

			String tempTdTextValue = "";
			tempTdTextValue =result;
			String realModeid = modeid;
			if(titlefields.contains(fieldsArray[i])){
				String billid = RecordSet.getString(vprimarykey);
				JSONObject otherParam = new JSONObject();
				otherParam.put("billid", billid);
				otherParam.put("customid", customid);
				otherParam.put("modeid", modeid);
				otherParam.put("formid", formid);
				otherParam.put("fieldid", tempFieldId);
				otherParam.put("fieldhtmltype", htmltype);
				otherParam.put("istitle", istitle);
				otherParam.put("viewtype", "0");
				otherParam.put("opentype", "0");
				otherParam.put("viewfrom", "fromsearchlist");
				otherParam.put("userid", user.getUID());
				otherParam.put("enabled", 0);
				otherParam.put("isenabled", isenabled);
				//标题字段链接地址解析
				otherParam.put("isportal","1");
				otherParam.put("linkmode",linkmode);
				otherParam.put("detailtablename",detailtablename);
                otherParam.put("detaildateId",RecordSet.getString(detailfieldAlias+"id"));
				tempTdTextValue = FormModeTransMethod.analyzeTitleFieldUrl(tempTdTextValue, otherParam);
				if(isenabled&&!isVirtualForm){
					//查询数据状态未选时，则需要判断数据状态
					int isnewimage = FormModeTransMethod.isNewimage(realModeid,billid,user.getUID());
					if(isnewimage==1){
						tempTdTextValue +="&nbsp;<span id=\"span"+eid+"_"+billid+"\"><img title='"+SystemEnv.getHtmlLabelName(83818,user.getLanguage())+"' src=\"/images/ecology8/statusicon/BDNew_wev8.png\" complete=\"complete\"/></span>";
					}else if(isnewimage==2){
						tempTdTextValue +="&nbsp;<span id=\"span"+eid+"_"+billid+"\"><img title='"+SystemEnv.getHtmlLabelName(83821,user.getLanguage())+"' src=\"/images/ecology8/statusicon/BDNew2_wev8.png\" complete=\"complete\"/></span>";
					}
				}
			}
			//处理显示转换字段
			boolean isShowTransferField = (fieldShowingTransferedStatusMap.get(fieldsArray[i]) != null && fieldShowingTransferedStatusMap.get(fieldsArray[i]).intValue() == 1) ;
			String opentype = "";
			String enabled = "0";
			String showmethod = isShowTransferField ? "1": "0";
			String para3="column:"+(isVirtualForm?vprimarykey:"id")+"+"+tempFieldId+"+"+htmltype+"+"+type+"+"+user.getLanguage()+"+"+isbill+"+"+tempdbtype+"+"+istitle+"+"+modeid+"+"+formid+"+"+tempviewtype+"+"+opentype+"+"+customid+"+fromsearchlist"+"+"+showmethod+"+"+user.getUID()+"+"+enabled;
			if ((htmltype.equals("-1")||htmltype.equals("-2")||htmltype.equals("1") || htmltype.equals("4")|| htmltype.equals("5")|| htmltype.equals("8")||(htmltype.equals("3")&&(type+"").equals("2"))) && 
				istitle!=1&& istitle!=2&& istitle!=3) {
				if(isShowTransferField) {
					if(htmltype.equals("5") || htmltype.equals("8")){
						tempTdTextValue = FormModeTransMethod.changeShowmethod(Integer.valueOf(customid).intValue() , tempFieldId, tempFieldValue, tempTdTextValue, para3);
					}else {
						tempTdTextValue = FormModeTransMethod.changeShowmethod(Integer.valueOf(customid).intValue(), tempFieldId, tempFieldValue, tempFieldValue, para3);
					}
				}
			}
			
			String tempTdTextValue4Show = tempTdTextValue;
			
			// 如果是多行文本且勾选了多行文本单行显示则显示内容为多行文本的第一行
			if(htmltype.equals("2")&&"1".equals(fe_isautoomit)) { // 多行显示为单行
				if(type == 1) {
					int nextLineIndex = tempTdTextValue4Show.indexOf("\n");
					nextLineIndex = nextLineIndex == -1 ? tempTdTextValue4Show.indexOf("<br"):nextLineIndex;
					nextLineIndex = nextLineIndex == -1 ? tempTdTextValue4Show.length()-1:nextLineIndex;
					nextLineIndex = nextLineIndex == -1 ? 0:nextLineIndex;
					tempTdTextValue4Show = tempTdTextValue4Show.substring(0,nextLineIndex);
				} else if(type==2) {
					tempTdTextValue4Show = Util.delHtml(tempTdTextValue);
				} else {
					tempTdTextValue4Show = tempTdTextValue;
				}
			}
		%>
		<TD style="width: <%=fWidth%>;<%=tdExtendStyle%>" <%if("1".equals(fe_isautoomit)){out.print("title='"+Util.delHtml(tempTdTextValue)+"'");} %>><font class='font'><font class='font'><%=tempTdTextValue4Show%></font></font></TD>
		<%
			}
		%>
	</TR>
	<TR class=sparator style="height:1px" height=1 >
			<TD colSpan=<%=fieldsArray.length+1 %> style='padding:0px'></TD>
		</TR>
	<%} %>
</TABLE>
<%if("Left".equals(rolltype)||"Right".equals(rolltype)||"Up".equals(rolltype)||"Down".equals(rolltype)) 
	out.println("</MARQUEE>");
%>
<script type="text/javascript">
function modeopenFullWindowHaveBar(url,obj){
	$("[id=span"+obj+"]").remove();
	openFullWindowHaveBar(url);
}
</script>
<%!
	String maintableAlias="t1";
	String detailtableAlias="d1";
	String detailfieldAlias="d_";
	private String getSplitPageString(int pageSize, int currentPage,
			int rowcount, int pageCount, String position,User user) {
		String sbf = "";
		int z_index = currentPage - 2;
		int y_num = currentPage + 2;
		String tempCent = "";
		String tempLeft = "";
		String tempRight = "";
		if (z_index > 1) {
			tempLeft += "<a style=\"position:relative;cursor:hand;TEXT-DECORATION:none;height:21px;border:1px solid #6ec8ff;margin-right:5px;padding:0 5px 0 5px;\" _jumpTo=\"1\" onClick=\"jumpTo(1)\">"
					+ 1 + "</a>";
		}
		if (z_index > 2) {
			tempLeft += "<span style=\"height:21px;padding-top:1px;text-align:center;\">&nbsp;...&nbsp;</span>";
		}

		if (y_num < (pageCount - 1)) {
			tempRight += "<span style=\"height:21px;padding-top:1px;text-align:center;\">&nbsp;...&nbsp;</span>";
		}

		if (y_num < pageCount) {
			tempRight += "<a style=\"position:relative;cursor:hand;TEXT-DECORATION:none;height:21px;border:1px solid #6ec8ff;margin-right:5px;padding:0 5px 0 5px;\" _jumpTo=\"1\" onClick=\"jumpTo("
					+ pageCount + ")\">" + pageCount + "</a>";
		}

		for (; z_index <= y_num; z_index++) {
			if (z_index > 0 && z_index <= pageCount) {
				if (z_index == currentPage) {
					tempCent += "<a style=\"position:relative;TEXT-DECORATION:none;height:21px;border:1px solid #6ec8ff;margin-right:5px;padding:0 5px 0 5px;\" _jumpTo=\""
							+ z_index
							+ "\" class=\"weaverTableCurrentPageBg\" >"
							+ z_index + "</a>";
				} else {
					tempCent += "<a style=\"position:relative;cursor:hand;TEXT-DECORATION:none;height:21px;border:1px solid #6ec8ff;margin-right:5px;padding:0 5px 0 5px;\" _jumpTo=\""
							+ z_index
							+ "\" onClick=\"jumpTo("
							+ z_index
							+ ")\">" + z_index + "</a>";
				}
			}
		}

		sbf = tempLeft + tempCent + tempRight;

		String str = "";
		if (currentPage > 1) {
			str += "<a class=\"weaverTablePrevPage\" style=\"position:relative;top:0px;bottom:0;cursor:hand;TEXT-DECORATION:none;height:21px;width:21px;margin-right:5px;font-size:11px;\" id=\""
					+ position
					+ "-pre\" onClick=\"jumpTo("
					+ (currentPage - 1)
					+ ")\" onmouseover=\"pmouseover(this, true)\" onmouseout=\"pmouseover(this, false)\">&nbsp;</a>";
		} else {
			str += "<span class=\"weaverTablePrevPageOfDisabled\" style=\"position:relative;top:0px;TEXT-DECORATION:none;height:21px;width:21px;margin-right:5px;color:#c6c6c6;font-size:11px;display:inline-block;\">&nbsp;</span>";
		}
		str += sbf;
		if (currentPage < pageCount) {
			str += "<a class=\"weaverTableNextPage\" style=\"position:relative;top:0px;cursor:hand;TEXT-DECORATION:none;height:21px;width:21px;margin-right:10px;font-size:11px;\" id=\""
					+ position
					+ "-next\" onClick=\"jumpTo("
					+ (currentPage + 1)
					+ ")\" onmouseover=\"pmouseover(this, true)\" onmouseout=\"pmouseover(this, false)\">&nbsp;</a>";
		} else {
			str += "<span class=\"weaverTableNextPageOfDisabled\" style=\"position:relative;top:0px;TEXT-DECORATION:none;height:21px;width:21px;margin-right:10px;font-size:11px;display:inline-block;\">&nbsp;</span>";
		}

		String result = "";
		result += "<span style=\"TEXT-DECORATION:none;height:21px;padding-top:1px;\">"+SystemEnv.getHtmlLabelName(15323,user.getLanguage())+"&nbsp;</span>";

		result += "<input id=\"jumpTo"
				+ position
				+ "\" type=\"text\" value=\""
				+ currentPage
				+ "\" size=\"3\" class=\"text\" onMouseOver=\"this.select()\" style=\"text-align:right;height:20px;widht:30px;border:1px solid #6ec8ff;background:none;position:relative;margin-right:5px;padding-right:2px;\"/>";
		result += "<span style=\"TEXT-DECORATION:none;height:21px;padding-top:1px;\">"+SystemEnv.getHtmlLabelName(30642,user.getLanguage())+"</span>";
		result += "&nbsp;<button id=\"jumpTo-goPage\" onClick=\"jumpTo(document.getElementById('jumpTo"
				+ position
				+ "').value, document.getElementById('jumpTo"
				+ position
				+ "'))\" style=\"cursor:hand;background:url(/wui/theme/ecology7/skins/default/table/jump_wev8.png) no-repeat;height:21px;width:38px;margin-right:5px;text-align:center;border:none;\">"+SystemEnv.getHtmlLabelName(81304,user.getLanguage())+"</button>";

		str += result;
		return str;
	}

	private String delHtml(final String inputString) {

		String htmlStr = new weaver.workflow.mode.FieldInfo()
				.toExcel(inputString); // 含html标签的字符串
		htmlStr = Util.StringReplace(htmlStr, "&dt;&at;", "<br>");

		String textStr = "";
		java.util.regex.Pattern p_script;
		java.util.regex.Matcher m_script;
		java.util.regex.Pattern p_html;
		java.util.regex.Matcher m_html;

		try {
			String regEx_html = "<[^>]+>"; // 定义HTML标签的正则表达式

			String regEx_script = "<[/s]*?script[^>]*?>[/s/S]*?<[/s]*?//[/s]*?script[/s]*?>"; // 定义script的正则表达式{或<script[^>]*?>[/s/S]*?<//script>

			p_script = java.util.regex.Pattern.compile(regEx_script,
					java.util.regex.Pattern.CASE_INSENSITIVE);
			m_script = p_script.matcher(htmlStr);
			htmlStr = m_script.replaceAll(""); // 过滤script标签

			p_html = java.util.regex.Pattern.compile(regEx_html,
					java.util.regex.Pattern.CASE_INSENSITIVE);
			m_html = p_html.matcher(htmlStr);
			htmlStr = m_html.replaceAll(""); // 过滤html标签

			textStr = htmlStr;

		} catch (Exception e) {
		}

		String returnstr = Util.HTMLtoTxt(textStr).replaceAll("%nbsp;", "").trim();
		returnstr = returnstr.replaceAll("%nbsp", "").trim();
		returnstr = returnstr.replaceAll("&amp;nbs","").trim();
		returnstr = returnstr.replaceAll("&amp;nbsp","").trim();
		return returnstr.equals("")?"&nbsp":returnstr;
	}

	private String formatData(String inData) {
		if (inData == null || inData.equals("")) {
			return "";
		}
		try {
			return new BigDecimal(Util.null2String(inData).equals("") ? "0"
					: Util.null2String(inData)).setScale(2,
					BigDecimal.ROUND_HALF_UP).toString();
		} catch (Exception e) {
			return inData;
		}
	}
    //是 -3  升序 -1 降序-2
	private String getOrderSql(int o){
		if(o==1){
			return "asc";
	    }else{
	    	return "d";
	    }
    }
    //获取sql
    private String getQuerySql(String tablename,String detailtablename,List fieldnames,List fielddbtypes,String sqlwhere,int perpage,String dbtype,String ordersql,String rightsql,String norightlist,String pkfieldname){
    	String sql = "select ";
    	String perpagesql  = "";
    	//分页
    	if(dbtype.indexOf("sqlserver")>-1){
    		sql = " select top "+perpage+"  ";
    	}else{
    	    perpagesql = " rownum<"+(perpage+1);
    	}
    	if(!fieldnames.contains(maintableAlias+"."+pkfieldname)){
    	   fieldnames.add(maintableAlias+"."+pkfieldname);
    	   fielddbtypes.add("varchar");
    	}
    	
    	String strfieldname="";
        for(int i=0;i<fieldnames.size();i++){
            String tmpfieldname = Util.null2String(fieldnames.get(i));
        	if(!tmpfieldname.equals("")){
        	   if("text,clob,".indexOf(Util.null2String(fielddbtypes.get(i)))>-1){
        		 int index = tmpfieldname.indexOf(" ");
        		 if(dbtype.equals("oracle")){
        	    	 if(index>-1){
        	        	strfieldname+=",to_char("+tmpfieldname.substring(0,index)+") "+tmpfieldname.substring(index);
        	         }else{
        	        	strfieldname+=",to_char("+tmpfieldname+") as "+tmpfieldname.replace(maintableAlias+".", "");
        	         }
        	     }else{
        	    	 if(index>-1){
        	        	strfieldname+=",convert(varchar(4000),"+tmpfieldname.substring(0,index)+") "+tmpfieldname.substring(index);
        	         }else{
        	        	strfieldname+=",convert(varchar(4000),"+tmpfieldname+") as "+tmpfieldname.replace(maintableAlias+".", "");
        	         }
        	     }
        	   }else{
        	   	  strfieldname+=","+tmpfieldname;
        	   }
        	   
        	}
        }
        if(!strfieldname.equals("")){
           strfieldname = strfieldname.substring(1);
        }
        //sql = sql+strfieldname+" from "+tablename+" where "+(sqlwhere.equals("")?" 1=1 ":sqlwhere) +ordersql;
        if(!StringHelper.isEmpty(detailtablename)){
            strfieldname+=","+detailtableAlias+".id as "+detailfieldAlias+"id";  
	        if("1".equals(norightlist)){
	        	sql = sql+strfieldname+" from "+tablename+" "+maintableAlias+" left join "+detailtablename+" "+detailtableAlias
	        			+" on "+maintableAlias+".id="+detailtableAlias+".mainid "+" where 1=1 ";
	        	if(!StringHelper.isEmpty(sqlwhere)){
	        		sql+=(sqlwhere.trim().toLowerCase().startsWith("and")?sqlwhere:" and "+sqlwhere) ;
	        	}
	        	sql+=ordersql;
	        }else{
	        	sql = sql+strfieldname+" from "+tablename+" "+maintableAlias
	        			+" left join "+detailtablename+" "+detailtableAlias+" "
	        			+" on "+maintableAlias+".id="+detailtableAlias+".mainid ";
	    		if(!StringHelper.isEmpty(rightsql)){
	        		sql+=","+rightsql +" t2 ";
	      		}
	        	sql+=" where 1=1 ";
	        	if(!StringHelper.isEmpty(sqlwhere)){
	        		sql+=(sqlwhere.trim().toLowerCase().startsWith("and")?sqlwhere:" and "+sqlwhere) ;
	        	}
	        	if(!StringHelper.isEmpty(rightsql)){
	        		sql+=" and "+maintableAlias+".id = t2.sourceid ";
	        	}
	        	sql+=ordersql;	
	        }
        }else{
        	if("1".equals(norightlist)){
	        	sql = sql+strfieldname+" from "+tablename+" "+maintableAlias+" where 1=1 ";
	        	if(!StringHelper.isEmpty(sqlwhere)){
	        		sql+=(sqlwhere.trim().toLowerCase().startsWith("and")?sqlwhere:" and "+sqlwhere);
	        	}
	        	sql+=ordersql;
	        }else{
	        	sql = sql+strfieldname+" from "+tablename+" "+maintableAlias;
	    		if(!StringHelper.isEmpty(rightsql)){
	        		sql+=","+rightsql +" t2 ";
	      		}
	        	sql+=" where 1=1 ";
	        	if(!StringHelper.isEmpty(sqlwhere)){
	        		sql+=(sqlwhere.trim().toLowerCase().startsWith("and")?sqlwhere:" and "+sqlwhere);
	        	}
	        	if(!StringHelper.isEmpty(rightsql)){
	        		sql+=" and "+maintableAlias+".id = t2.sourceid ";
	        	}
	        	sql+=ordersql;	
	        }
        }
        if(dbtype.equals("oracle")){
            if(!ordersql.equals(""))
        	  sql = "select * from ("+sql+") where "+perpagesql;
        	else{
        	  sql=sql+" and "+perpagesql;
        	}           
        }
        return sql;
    }
    
   	private String changehreflink(String hreflink,String tablename,String datasource,String billid,String formID){
   		weaver.conn.RecordSet RecordSet = new weaver.conn.RecordSet();
   		String requestid = "0";
		String datesql ="select * from "+tablename +" where id='"+billid+"'";
		if(!"".equals(datasource)){
			RecordSet.executeSql(datesql,datasource);
		}else{
			RecordSet.executeSql(datesql);
		}
		if(RecordSet.next()){
			requestid = RecordSet.getString("requestId");
			hreflink = Util.replaceString(hreflink, "$requestId$", requestid);
			weaver.conn.RecordSet RecordSetfield = new weaver.conn.RecordSet();
			String fieldsql = "select * from workflow_billfield where billid="+formID+" and (detailtable ='' or detailtable is null)";
			RecordSetfield.executeSql(fieldsql);
			while(RecordSetfield.next()){
				String fieldhtype = RecordSetfield.getString("fieldhtmltype");
				String type = RecordSetfield.getString("type");
				String fieldname = RecordSetfield.getString("fieldname");
				if("2".equals(fieldhtype)&&"2".equals(type)){
					continue;
				}
				hreflink = Util.replaceString(hreflink, "$"+fieldname+"$", RecordSet.getString(fieldname));
				hreflink = Util.replaceString(hreflink, "$billid$", RecordSet.getString("id"));
			}
		}
		return hreflink;
   	}
   	private String addFontAttributeForHrefText(String src) {
   		String regex1 = "<a.*?/a>";
		String regex2 = ">.*?</a>";
		Pattern pt1 = Pattern.compile(regex1);
		Pattern pt2 = Pattern.compile(regex2);
		Matcher match1 = pt1.matcher(src);
		String result = "";
		while(match1.find()) {
			StringBuilder sb = new StringBuilder();
			String href = match1.group();
			sb.append(href.substring(0, href.indexOf(">") + 1));
			
			Matcher match2 = pt2.matcher(href);
			while(match2.find()) {
				String content = match2.group();
				String temp = content.substring(content.indexOf(">") + 1, content.indexOf("<"));
				sb.append("<font class=font>" + temp + "</font></a>");
			}
			result += sb.toString();
		}
   		return result.isEmpty() ? src : result;
   	}
   	
   	public String getDoc(String muliDocId,DocComInfo docComInfo){
   		muliDocId = Util.null2String(muliDocId);
		String returnStr = "";
		if (muliDocId.equals(""))
			return "";
		String[] tempArray = Util.TokenizerString2(muliDocId, ",");
		for (int i = 0; i < tempArray.length; i++) {
			String docname =  "<font class=font>" + docComInfo.getDocname(tempArray[i]) + "</font>";		
			returnStr += "<a href='/docs/docs/DocDsp.jsp?id="+tempArray[i]+"' target='_blank'>"+docname + "</a><br>";
		}
		return returnStr;
	}	
 %>