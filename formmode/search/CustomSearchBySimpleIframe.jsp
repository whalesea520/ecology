<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.servicefiles.DataSourceXML"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.formmode.interfaces.ModeManageMenu" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Map.Entry" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="weaver.formmode.virtualform.VirtualFormHandler"%>
<%@ page import="weaver.formmode.service.CommonConstant"%>
<%@ page import="weaver.formmode.customjavacode.CustomJavaCodeRun"%>
<%@ page import="com.weaver.formmodel.util.StringHelper"%>
<%@ page import="weaver.interfaces.workflow.browser.Browser"%>
<%@ page import="weaver.interfaces.workflow.browser.BrowserBean"%>
<%@ page import="weaver.formmode.data.FieldInfo"%>
<%@ page import="weaver.formmode.setup.ExpandBaseRightInfo"%>
<%@ page import="weaver.formmode.tree.CustomTreeUtil"%>
<%@ page import="weaver.formmode.util.CustomSearchAnalyzeUtil"%>
<%@ page import="weaver.common.util.taglib.ShowColUtil"%>
<%@ page import="java.util.Map.Entry"%>
<%@ page import="weaver.formmode.search.editplugin.AbstractPluginElement"%>
<%@ page import="weaver.formmode.search.editplugin.PluginElementClassName"%>
<%@ page import="net.sf.json.JSONObject"%>
<%@ page import="weaver.formmode.excel.ModeCacheManager"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="selectRs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rsm" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="ModeShareManager" class="weaver.formmode.view.ModeShareManager" scope="page" />
<jsp:useBean id="ModeRightInfo" class="weaver.formmode.setup.ModeRightInfo" scope="page" />
<jsp:useBean id="FormModeTransMethod" class="weaver.formmode.search.FormModeTransMethod" scope="page" />
<jsp:useBean id="DeleteData" class="weaver.formmode.search.batchoperate.DeleteData" scope="page" />
<jsp:useBean id="FormModeRightInfo" class="weaver.formmode.search.FormModeRightInfo" scope="page" />
<jsp:useBean id="CustomSearchService" class="weaver.formmode.service.CustomSearchService" scope="page" />
<jsp:useBean id="FormModeConfig" class="weaver.formmode.FormModeConfig" scope="page" />
<jsp:useBean   id="xssUtil" class="weaver.filter.XssUtil" />
<jsp:useBean id="ExpandBaseRightInfo" class="weaver.formmode.setup.ExpandBaseRightInfo" scope="page" />
<jsp:useBean id="CustomSearchUtil" class="weaver.formmode.search.CustomSearchUtil" scope="page" />

<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>

<!DOCTYPE html><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<LINK href="/js/jquery/plugins/multiselect/jquery.multiselect_wev8.css" type=text/css rel=STYLESHEET>
<link href="/js/jquery/plugins/multiselect/style_wev8.css" type=text/css rel=STYLESHEET>
<link href="/formmode/js/jquery/jquery-ui-1.10.3/themes/base/jquery-ui_wev8.css" type=text/css rel=STYLESHEET>
<script type="text/javascript" src="/formmode/js/jquery/jquery-ui-1.10.3/ui/minified/jquery-ui.min_wev8.js"></script>
<script language="javascript" src="/js/jquery/plugins/multiselect/jquery.multiselect.min_wev8.js"></script>
<script language="javascript" src="/js/jquery-autocomplete/jquery.autocomplete_wev8.js"></script>
<script language="javascript" src="/formmode/js/customSearchOperate_wev8.js?v=7"></script>

 <LINK href="/formmode/css/search_wev8.css" type=text/css rel=STYLESHEET>
 
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<script language=javascript src="/js/ecology8/docs/docExt_wev8.js"></script>
<script language=javascript src="/js/ecology8/docs/docSearchInit_wev8.js"></script>
<script language=javascript src="/formmode/js/modebrow_wev8.js"></script>
</head>
<%
String customid=Util.null2String(request.getParameter("customid").split("\\?")[0]);

//先加载下缓存
ModeCacheManager.getInstance().loadCacheNow("", customid, "");

int viewtype=Util.getIntValue(request.getParameter("viewtype"),0);
String treesqlwhere = Util.null2String(request.getParameter("treesqlwhere"));
String treesqlwhere1 = Util.null2String(request.getParameter("treesqlwhere1"));
int templateid = Util.getIntValue(request.getParameter("templateid"),0);
String searchMethod=Util.null2String(request.getParameter("searchMethod"),"0");//查询方式，0-搜索查询，1-模板查询
int mainid = Util.getIntValue(request.getParameter("mainid"),0);
String datasqlwhere = Util.null2String(request.getParameter("datasqlwhere"));
datasqlwhere = xssUtil.get(datasqlwhere);
String fromadvanced = Util.null2String(request.getParameter("fromadvanced"),"0");
String fromgroup = Util.null2String(request.getParameter("fromgroup"),"0");
String customTreeDataId = Util.null2String(request.getParameter("customTreeDataId"),"");
//============================================快捷搜索====================================

//快捷搜索 1本周,2本月,3本季,4本年
String thisdate=Util.null2String(request.getParameter("thisdate"));
//快捷搜索 1本部门,2本部门(包含下级部门),3本分部,4本分部(包含下级分部)
String thisorg=Util.null2String(request.getParameter("thisorg"));
//获得快捷搜索的sql
String quickSql = FormModeTransMethod.getQuickSearch(user,thisdate,thisorg);
//分组条件
String groupby=Util.null2String(xssUtil.get(request.getParameter("groupby")));

//是否开启列表未读，反馈标识功能,1未读、2反馈和3已读
boolean isEnabled = FormModeConfig.isEnabled();
String enabled = Util.null2String(request.getParameter("enabled"),"0");

//============================================查询列表基础数据====================================
boolean issimple= true;
int isresearch=1;
String isbill="1";
String formID="0";
String customname="";
String titlename ="";
String tablename="";
String modeid = "0";
String disQuickSearch = "";
String defaultsql = "";
String norightlist = "";
int iscustom = 0;
int opentype = 0;

String searchconditiontype = "1";
String javafilename = "";
String javafileAddress = "";
int perpage=10;
String detailtable="";
String detailkeyfield="";
String maintableAlias="t1";
String detailtableAlias="d1";
String detailfieldAlias="d_";
int isShowQueryCondition=0;
rs.execute("select a.*,b.tablename,b.detailkeyfield from mode_customsearch a left join workflow_bill b on a.formid=b.id where a.id="+customid);
if(rs.next()){
    formID=Util.null2String(rs.getString("formid"));
    customname=Util.null2String(rs.getString("customname"));
    titlename = SystemEnv.getHtmlLabelName(197,user.getLanguage())+":"+customname;
    modeid=""+Util.getIntValue(rs.getString("modeid"),0);
    
    disQuickSearch = "" + Util.toScreenToEdit(rs.getString("disQuickSearch"),user.getLanguage());
    defaultsql = "" + Util.toScreenToEdit(rs.getString("defaultsql"),user.getLanguage()).trim();
    defaultsql = FormModeTransMethod.getDefaultSql(user,thisdate,thisorg,defaultsql);
    norightlist = Util.null2String(rs.getString("norightlist"));
	iscustom = Util.getIntValue(rs.getString("iscustom"),1);
	isShowQueryCondition = Util.getIntValue(rs.getString("isShowQueryCondition"),0);
    opentype = Util.getIntValue(rs.getString("opentype"),0);//0 弹出，1当前窗口
    
    searchconditiontype = Util.null2String(rs.getString("searchconditiontype"));
	searchconditiontype = searchconditiontype.equals("") ? "1" : searchconditiontype;
	javafilename = Util.null2String(rs.getString("javafilename"));
	perpage = Util.getIntValue(Util.null2String(rs.getString("pagenumber")),10);
	detailtable=Util.null2String(rs.getString("detailtable"));
	tablename = rs.getString("tablename");
	detailkeyfield=Util.null2String(rs.getString("detailkeyfield"));
	javafileAddress= Util.null2String(rs.getString("javafileAddress"));
}

//============================================虚拟表基础数据====================================
String vdatasource = "";	//虚拟表单数据源
String vprimarykey = "";	//虚拟表单主键列名称
String vdatasourceDBtype = "";	//数据库类型
boolean isVirtualForm = VirtualFormHandler.isVirtualForm(formID);	//是否是虚拟表单
Map<String, Object> vFormInfo = new HashMap<String, Object>();
if(isVirtualForm){
	vFormInfo = VirtualFormHandler.getVFormInfo(formID);
	vdatasource = Util.null2String(vFormInfo.get("vdatasource"));	//虚拟表单数据源
	vprimarykey = Util.null2String(vFormInfo.get("vprimarykey"));	//虚拟表单主键列名称
	DataSourceXML dataSourceXML = new DataSourceXML();
	vdatasourceDBtype = dataSourceXML.getDataSourceDBType(vdatasource);
}else{
	vdatasourceDBtype = RecordSet.getDBType();
}

//============================================权限判断====================================
boolean isRight = false;
boolean isDel = false;
boolean isBatchEdit = false;
if(viewtype == 3){//监控权限判断
	boolean isHavepageRight = FormModeRightInfo.isHavePageRigth(Util.getIntValue(customid),4);
	if(isHavepageRight){
		FormModeRightInfo.setUser(user);
		isRight = FormModeRightInfo.checkUserRight(Util.getIntValue(customid),4);
	}
	else{  //如果自定义查询页面无监控权限，则检查全局监控权限
		ModeRightInfo.setModeId(Util.getIntValue(modeid));
		ModeRightInfo.setType(viewtype);
		ModeRightInfo.setUser(user);
		
		isRight = ModeRightInfo.checkUserRight(viewtype);
	}
	ModeRightInfo.setModeId(Util.getIntValue(modeid));
	ModeRightInfo.setType(viewtype);
	ModeRightInfo.setUser(user);
	if(ModeRightInfo.checkUserRight(viewtype)){
		isDel = true;
	}
}else{
	isDel = true;
	//批量修改权限
	rs.executeSql("select * from mode_searchPageshareinfo where righttype=2 and pageid = " + customid);
	if(rs.next()){  
		FormModeRightInfo.setUser(user);
		isBatchEdit = FormModeRightInfo.checkUserRight(Util.getIntValue(customid),2);
	}
	if(isBatchEdit){
		isRight = true;
	}else{
		//自定义页面查看权限
		rs.executeSql("select * from mode_searchPageshareinfo where righttype=1 and pageid = " + customid);
		if(rs.next()){  
			FormModeRightInfo.setUser(user);
			isRight = FormModeRightInfo.checkUserRight(Util.getIntValue(customid),1);
		}else{  //没有设置任何查看权限数据，则认为有权限查看
			isRight = true;
		}
	}
}

if(!isRight || (viewtype==2 && !isBatchEdit)){
	//response.sendRedirect("/notice/noright.jsp");
	out.println("<script>window.location.href='/notice/noright.jsp';</script>");
	return;
}

boolean isBatchEditPage = (viewtype==2 && !isVirtualForm && !"1".equals(norightlist));
boolean showBatchEditButton = (isBatchEdit && viewtype==0 && !isVirtualForm && !"1".equals(fromadvanced) && !"1".equals(norightlist));
boolean CreateRight = false;//新建权限
boolean BatchImportRight = false;//批量导入权限
boolean DelRight = false;//删除权限

ModeRightInfo.setModeId(Util.getIntValue(modeid));
ModeRightInfo.setType(1);//新建
ModeRightInfo.setUser(user);
CreateRight = ModeRightInfo.checkUserRight(1);

ModeRightInfo.setType(4);//批量导入
if(isVirtualForm){//虚拟表单不能批量导入
    BatchImportRight = false;
}else{
	BatchImportRight = ModeRightInfo.checkUserRight(4);
	if(!BatchImportRight){
		BatchImportRight = HrmUserVarify.checkUserRight("ModeSetting:All", user);
	}
}
String treenodeid = Util.null2String(request.getParameter("treenodeid"));
String treeconid = Util.null2String(request.getParameter("treeconid"));
String treeconvalue = "";
if(!treeconid.equals("")){
	treeconvalue = Util.null2String(request.getParameter("treecon"+treeconid+"_value"));
}
//============================================链接地址参数应用====================================
String createurl = "";
String tempquerystring = Util.null2String(request.getQueryString()); 
if (tempquerystring.indexOf("&flag") > -1) {
	tempquerystring = tempquerystring.substring(0,tempquerystring.indexOf("&flag"));
}
int splitIndex = tempquerystring.indexOf("&splitFlag=-999");
if(splitIndex!=-1){
	tempquerystring = tempquerystring.substring(0,splitIndex);
	//把treesqlwhere转换为了实际参数
	String removeStr = "&treesqlwhere=";//要移除的参数
	int index = tempquerystring.indexOf(removeStr);
	if(index!=-1){
		String tempStr = tempquerystring.substring(0,index);
		String aftStr = tempquerystring.substring(index+removeStr.length());
		if(aftStr.indexOf("&")!=-1){
			tempStr = tempStr + aftStr.substring(aftStr.indexOf("&"));
		}
		tempquerystring = tempStr;
	}
	
	removeStr = "&treenodeid=";//要移除的参数
	index = tempquerystring.indexOf(removeStr);
	if(index!=-1){
		String tempStr = tempquerystring.substring(0,index);
		String aftStr = tempquerystring.substring(index+removeStr.length());
		if(aftStr.indexOf("&")!=-1){
			tempStr = tempStr + aftStr.substring(aftStr.indexOf("&"));
		}
		tempquerystring = tempStr;
	}
}

String tempquerystrings[] = tempquerystring.split("&");
for(int i=0;i<tempquerystrings.length;i++){
	String tempquery = tempquerystrings[i];
	if(tempquery.toLowerCase().startsWith("field")){
		createurl += "&"+tempquery;
	}
}


//替换查询url，request传参字段
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

//============================================删除数据====================================
String method=Util.null2String(request.getParameter("method"));
int pageexpandid = Util.getIntValue(request.getParameter("pageexpandid"),0);
String deletebillid=Util.null2String(request.getParameter("deletebillid"));
if(method.equals("del")){//删除数据
	DeleteData.setClientaddress(request.getRemoteAddr());
	DeleteData.setDeletebillid(deletebillid);
	DeleteData.setFormid(Util.getIntValue(formID));
	DeleteData.setModeid(Util.getIntValue(modeid));
	DeleteData.setTablename(tablename);
	DeleteData.setUser(user);
	DeleteData.setViewtype(viewtype);
	DeleteData.setPageexpandid(pageexpandid);
	String delMsg = DeleteData.DelData();
	if(delMsg != null && !delMsg.equals("")) {
		out.print("<script>top.Dialog.alert('"+delMsg+"');</script>");
	}
	%>
    <script>
        if(parent.parent.frames['leftframe']){
            if(typeof(parent.parent.frames['leftframe'].delRefresh) == "function"){
                parent.parent.frames['leftframe'].delRefresh();
            }
        }
        parent.loadGroup();
    </script>
    <%
}

//============================================关键字搜索====================================

String searchkeyname = Util.null2String(request.getParameter("searchkeyname"));
String isusersearchkey=Util.null2String(request.getParameter("isusersearchkey"));
String quicksqlwhere = "";
String quickTitle = "";
int searchKeyNum = 0;
String parfield = "";
Map ActionMap=new HashMap();
//查询sql
ActionMap.put("action","keyfieldSql");
ActionMap.put("customid",customid);
CustomSearchUtil.setMap(ActionMap);
String keyfieldSql = CustomSearchUtil.getSearchSql();
RecordSet.execute(keyfieldSql);
while(RecordSet.next()){
	searchKeyNum++;
	parfield = RecordSet.getString("id");
	String fieldname = RecordSet.getString("fieldname");
	String indexdesc = RecordSet.getString("indexdesc");
	int field_viewtype=RecordSet.getInt("viewtype");
	String tableAlias=maintableAlias;
	if(field_viewtype==1){
		tableAlias=detailtableAlias;
	}
	quicksqlwhere += " LOWER("+tableAlias+"."+fieldname+") like LOWER('%"+searchkeyname.replace("'", "''")+"%') or";
	quickTitle += " "+indexdesc+" or";
}
if(quicksqlwhere.length()>2){
	quicksqlwhere ="("+quicksqlwhere.substring(0,quicksqlwhere.length()-2)+")";
}
if(quickTitle.length()>2){
	quickTitle = quickTitle.substring(0,quickTitle.length()-2);
}
if ("".equals(searchkeyname)||"0".equals(isusersearchkey)) {
	quicksqlwhere="";
}

//============================================自定义查询条件====================================
boolean isoracle = vdatasourceDBtype.equals("oracle") ;
boolean isdb2 = vdatasourceDBtype.equals("db2") ;

//下面开始自定义查询条件
String[] checkcons = request.getParameterValues("check_con");
String sqlwhere_con="";
ArrayList ids = new ArrayList();
ArrayList colnames = new ArrayList();
ArrayList opts = new ArrayList();
ArrayList values = new ArrayList();
ArrayList names = new ArrayList();
ArrayList opt1s = new ArrayList();
ArrayList value1s = new ArrayList();
ids.clear();
colnames.clear();
opt1s.clear();
names.clear();
value1s.clear();
opts.clear();
values.clear();
Hashtable conht=new Hashtable();

String consql = "select b.id,b.fieldname,b.fielddbtype,b.fieldhtmltype,b.type,b.viewtype,c.searchparaname,c.searchparaname1,c.conditionTransition from mode_customsearch a,workflow_billfield b,mode_CustomDspField c where b.id=c.fieldid and a.id=c.customid and c.isquery=1 and a.id="+customid
	+" union select fieldid as id,'' as fieldname,'' as fielddbtype,'' as fieldhtmltype,0 as type,0 as viewtype ,searchparaname,searchparaname1,conditionTransition from mode_CustomDspField where isquery='1' and fieldid in(-1,-2,-3,-4,-5,-6,-7,-8,-9) and customid="+customid;
rs.executeSql(consql);

//获取conht，sqlwhere_con逻辑放在FormModeTransMethod中，是因为该jsp在weblogic环境中编译超过最大字节数63535
FormModeTransMethod.setIsTemplate("true");
Map map = FormModeTransMethod.customsearch(request,rs,customid,maintableAlias,detailtableAlias,isoracle,isdb2,vdatasourceDBtype,user,isbill,modeid,formID,viewtype,conht,sqlwhere_con);
conht = (Hashtable)map.get("conht");
sqlwhere_con = (String)map.get("sqlwhere_con");

String _sql = "";
//如果没有查询条件传递过来，且当前模板没有，则查询模板用默认模板
if (templateid == 0 && checkcons == null) { 
	rs.execute("select id from mode_TemplateInfo where customid="+customid+" and isdefault=1 and sourcetype=2 and createrid='"+user.getUID()+"'");
	if (rs.next()) {
		templateid = rs.getInt("id");
	}
}
if (templateid > 0) { //如果有模板，则获取模板信息，传过来的值直接覆盖默认模板
    ActionMap.put("action","templateSql");
    ActionMap.put("templateid",templateid);
    CustomSearchUtil.setMap(ActionMap);
    _sql=CustomSearchUtil.getSearchSql();
	RecordSet.executeSql(_sql);
	if (checkcons==null) { //有默认模板，且没有页面传输值的，则searchMethod为模板查询
		searchMethod = "1";
	}
}
if (RecordSet.getColCounts() > 0 && "1".equals(searchMethod)) {//有模板信息，且是模板查询
	//获取conht，sqlwhere_con逻辑放在FormModeTransMethod中，是因为该jsp在weblogic环境中编译超过最大字节数63535
	Map map1 = FormModeTransMethod.customsearch1(RecordSet,customid,maintableAlias,detailtableAlias,isoracle,isdb2,vdatasourceDBtype,conht,sqlwhere_con);
	conht = (Hashtable)map1.get("conht");
	sqlwhere_con = (String)map1.get("sqlwhere_con");
} else {
	if (!"1".equals(searchMethod)) { // 不是空模板，且不是模板查询
		//获取conht，sqlwhere_con逻辑放在FormModeTransMethod中，是因为该jsp在weblogic环境中编译超过最大字节数63535
		Map map2 = FormModeTransMethod.customsearch2(request,checkcons,maintableAlias,detailtableAlias,isoracle,isdb2,vdatasourceDBtype,conht,sqlwhere_con);
		conht = (Hashtable)map2.get("conht");
		sqlwhere_con = (String)map2.get("sqlwhere_con");
	}
} 
//查询条件有默认值，则去掉URL中默认值 ---- begin
String deltempquerystrings[] = tempquerystring.split("&");
String filedsql="";
ActionMap.put("action","defaultQuerySql");
ActionMap.put("formID",formID);
CustomSearchUtil.setMap(ActionMap);
filedsql=CustomSearchUtil.getSearchSql();
if (templateid == 0) { //如果没有模板，则获取默认模板信息
	rs.execute("select id from mode_TemplateInfo where customid="+customid+" and isdefault=1 and sourcetype=2 and createrid='"+user.getUID()+"'");
	if (rs.next()) {
		templateid = rs.getInt("id");
	}
}
if (templateid > 0) { //如果有模板，则获取模板信息
    ActionMap.put("action","haveTemplateSql");
    ActionMap.put("templateid",templateid);
    CustomSearchUtil.setMap(ActionMap);
    filedsql=CustomSearchUtil.getSearchSql();
}
RecordSet.execute(filedsql);
while (RecordSet.next()){
	String tmpid = RecordSet.getString("id");
	for(int j=0;j<deltempquerystrings.length;j++){
		String tempquery = deltempquerystrings[j].toLowerCase();
		if(("check_con="+tmpid).equals(tempquery)||tempquery.startsWith("con"+tmpid+"_colname")||tempquery.startsWith("con"+tmpid+"_htmltype")
			||tempquery.startsWith("con"+tmpid+"_type")||tempquery.startsWith("con"+tmpid+"_opt")||tempquery.startsWith("con"+tmpid+"_value")
			||tempquery.startsWith("con"+tmpid+"_name")||tempquery.startsWith("con"+tmpid+"_opt1")||tempquery.startsWith("con"+tmpid+"_value1")){
				deltempquerystrings[j] = "";
		}
	}
}

String newtempquerystring = "";
for(int i=0;i<deltempquerystrings.length;i++){
	String tempquery = deltempquerystrings[i];
	if(!"".equals(tempquery)){
		newtempquerystring +=tempquery+"&";
	}
}
if(newtempquerystring.length() > 2) {
	newtempquerystring = newtempquerystring.substring(0, newtempquerystring.length()-1);
}
tempquerystring = newtempquerystring;
//去掉查询条件默认值-----end

//去掉条件参数---- begin
String searchparmstrings[] = tempquerystring.split("&");
filedsql = "select b.id,b.fieldname,b.fielddbtype,b.fieldhtmltype,b.type,c.searchparaname,c.searchparaname1 from mode_customsearch a,workflow_billfield b,mode_CustomDspField c where b.id=c.fieldid and a.id=c.customid and c.isquery=1 and a.id="+customid
	+" union select fieldid as id,'' as fieldname,'' as fielddbtype,'' as fieldhtmltype,0 as type,searchparaname,searchparaname1 from mode_CustomDspField where isquery='1' and fieldid in(-1,-2,-3,-4,-5,-6,-7,-8,-9) and customid="+customid;
RecordSet.execute(filedsql);
while (RecordSet.next()){
	String searchparaname = RecordSet.getString("searchparaname");
	String searchparaname1 = RecordSet.getString("searchparaname1");
	for(int j=0;j<searchparmstrings.length;j++){
		String tempquery = searchparmstrings[j];
		if((tempquery).startsWith(searchparaname+"=")||(tempquery).startsWith(searchparaname1+"=")){
				searchparmstrings[j] = "";
		}
	}
}

String newsearchparmstring = "";
for(int i=0;i<searchparmstrings.length;i++){
	String tempquery = searchparmstrings[i];
	if(!"".equals(tempquery)){
		newsearchparmstring +=tempquery+"&";
	}
}
if (newsearchparmstring.length() > 2) {
	newsearchparmstring = newsearchparmstring.substring(0, newsearchparmstring.length()-1);
}
tempquerystring = newsearchparmstring;
//去掉条件参数-----end
//去掉searchkeyname条件参数
if (tempquerystring.indexOf("searchkeyname") > -1) {
	String tempquerystringpre = tempquerystring.split("searchkeyname")[0];
	String tempquerystringaft = tempquerystring.split("searchkeyname")[1];
	if (tempquerystringaft.indexOf("&") > -1) {
		tempquerystringaft = tempquerystringaft.substring(1);
	}
	tempquerystring = tempquerystringpre + tempquerystringaft;
}

//如果点击的是关键字搜索，则自定义查询条件失效
if("1".equals(isusersearchkey)){
	//sqlwhere_con="";
}

//============================================数据属于哪个模块条件====================================
String whereclause=CustomSearchUtil.getModeSearchSql(isVirtualForm, formID, modeid,norightlist);
String sqlwhere = whereclause + sqlwhere_con + datasqlwhere;
String formmodeid=modeid;
String orderby = "";
String sql="";
String initselectfield = "";
List iframeList = new ArrayList();
String multiselectid="";
ArrayList<String> ldselectfieldid=new ArrayList<String>();
boolean isCleanColWidth =false;
rs.executeSql("select 1 from user_default_col where pageid = 'mode_customsearch:"+customid+"' and userid = "+user.getUID());
if(rs.next()){
	isCleanColWidth = true;
}
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
//鼠标右键
ModeManageMenu ModeManageMenu = new ModeManageMenu();
ModeManageMenu.setCustomid(Util.getIntValue(customid,0));
ModeManageMenu.setModeId(Util.getIntValue(modeid,0));
ModeManageMenu.setRCMenuHeightStep(RCMenuHeightStep);
ModeManageMenu.setUser(user);
ModeManageMenu.setCreateRight(CreateRight);
ModeManageMenu.setBatchImportRight(BatchImportRight);
ModeManageMenu.setVirtualForm(isVirtualForm);
ModeManageMenu.getSearchMenu();
HashMap urlMap = ModeManageMenu.getUrlMap();
RCMenu += ModeManageMenu.getRCMenu() ;
RCMenuHeight += ModeManageMenu.getRCMenuHeight() ;
if(isCleanColWidth){
	RCMenu += "{"+SystemEnv.getHtmlLabelNames("20873,19509",user.getLanguage())+",javascript:customSearchOperate.cleanColWidth(),_self} " ;//清除列宽
	RCMenuHeight += RCMenuHeightStep;
}
if(showBatchEditButton){
	RCMenu += "{"+SystemEnv.getHtmlLabelNames("25465",user.getLanguage())+",javascript:customSearchOperate.doBatchEdit(),_self} " ;//批量修改
	RCMenuHeight += RCMenuHeightStep;
}
if(isBatchEditPage){
	RCMenu = "{"+SystemEnv.getHtmlLabelNames("20839,86",user.getLanguage())+",javascript:customSearchOperate.batchEditSave(),_self} " ;//批量保存
	RCMenuHeight += RCMenuHeightStep;
	RCMenu += "{"+SystemEnv.getHtmlLabelNames("197",user.getLanguage())+",javascript:submitData(),_self} " ;//搜索
	RCMenuHeight = RCMenuHeightStep;
	RCMenu += "{"+SystemEnv.getHtmlLabelNames("1290",user.getLanguage())+",javascript:customSearchOperate.batchEditGoBack(),_self} " ;//返回
	RCMenuHeight += RCMenuHeightStep;
}

//页面扩展或批量操作设置是否显示或是否启用新建按钮
ModeManageMenu.isShowCreateInBox();
boolean isCreateBox = ModeManageMenu.isCreateRight();

//新建按钮通过拓展页面获取
String isShowCreateBtn = "1";
String isVirtualFormFilterSql = "";
if(isVirtualForm){
	isVirtualFormFilterSql = " and (a.issystemflag not in(103,104) or a.issystemflag  is null) ";
}
if(rs.getDBType().equals("oracle")){
    sql = "select a.id,b.listbatchname expendname,a.expenddesc,b.isuse,a.issystem,a.issystemflag,a.defaultenable,a.hreftarget,a.hreftype,a.hrefid,a.opentype,b.listbatchname from mode_pageexpand a left join mode_batchset b on a.id = b.expandid and b.customsearchid = "+customid+" where a.isbatch in(1,2) "+isVirtualFormFilterSql+" and a.modeid = " + modeid + " and nvl(b.isshortcutbutton,0)=1 and a.isshow=1 order by b.showorder asc,a.issystem desc,a.id asc";
}else{
    sql = "select a.id,b.listbatchname expendname,a.expenddesc,b.isuse,a.issystem,a.issystemflag,a.defaultenable,a.hreftarget,a.hreftype,a.hrefid,a.opentype,b.listbatchname from mode_pageexpand a left join mode_batchset b on a.id = b.expandid and b.customsearchid = "+customid+" where a.isbatch in(1,2) "+isVirtualFormFilterSql+" and a.modeid = " + modeid + " and isnull(b.isshortcutbutton,0)=1 and a.isshow=1 order by b.showorder asc,a.issystem desc,a.id asc";   
}
RecordSet.executeSql(sql);
// 增加判断页面扩展权
ExpandBaseRightInfo.setUser(user);
ArrayList<Map<String,String>> expandbuttonList = new ArrayList<Map<String,String>>();
while (RecordSet.next()) {
	if(!ExpandBaseRightInfo.checkExpandRight(Util.null2String(RecordSet.getString("id")), modeid)){
		continue;
	}
	Map<String,String> expandbuttonMap = new HashMap<String,String>();
	String detailid = Util.null2String(RecordSet.getString("id"));
	String issystem = Util.null2String(RecordSet.getString("issystem"));
	String issystemflag = Util.null2String(RecordSet.getString("issystemflag"));
	String isuse = Util.null2String(RecordSet.getString("isuse"));
	String defaultenable = Util.null2String(RecordSet.getString("defaultenable"));
	String hreftarget = Util.null2String(RecordSet.getString("hreftarget"));
	String _opentype = Util.null2String(RecordSet.getString("opentype"));
	String expendname = Util.null2String(RecordSet.getString("expendname"));
	String hreftype = Util.null2String(RecordSet.getString("hreftype"));
	String hrefid = Util.null2String(RecordSet.getString("hrefid"));
	String createname = Util.null2String(RecordSet.getString("listbatchname"));
	String methodStr = "";

	if(isBatchEditPage && !"1".equals(issystemflag) && !"100".equals(issystemflag))continue;
	if(issystemflag.equals("")){
		issystemflag = "0";
	}
	if(issystem.equals("1")){
		if(isuse.equals("")){
			isuse = defaultenable;
		}
		if(isuse.equals("0")){
			//continue;
		}
		else{
			if(issystemflag.equals("100")){
				if(createname.equals("")){
					createname = SystemEnv.getHtmlLabelName(197,user.getLanguage());
				}
				methodStr = "submitData()";
			}
			if(CreateRight&&issystemflag.equals("101")){
				if(createname.equals("")){
					createname = SystemEnv.getHtmlLabelName(82,user.getLanguage());
				}
				methodStr = "Add()";
				isShowCreateBtn = RecordSet.getString("isshow");
			}
			if(BatchImportRight&&issystemflag.equals("103")){
				if(createname.equals("")){
					createname = SystemEnv.getHtmlLabelName(26601,user.getLanguage());
				}
				methodStr = "BatchImport("+detailid+")";
			}
			if(issystemflag.equals("102")){
				if(createname.equals("")){
					createname = SystemEnv.getHtmlLabelName(91,user.getLanguage());
				}
				methodStr = "Del("+detailid+")";
			}
			if(issystemflag.equals("8")){
				if(createname.equals("")){
					createname = SystemEnv.getHtmlLabelName(33418,user.getLanguage());
				}
				methodStr = "resetSearch()";
			}
			if(issystemflag.equals("12")){ //批量生成二维码
				if(createname.equals("")){
					createname = SystemEnv.getHtmlLabelName(125512,user.getLanguage());
				}
				methodStr = "batchCreateQRCode()";
			}
			if(issystemflag.equals("171")){ //批量生成条形码
				if(createname.equals("")){
					createname = SystemEnv.getHtmlLabelName(126684,user.getLanguage());
				}
				methodStr = "batchCreateBARCode()";
			}
			if(!isVirtualForm&&issystemflag.equals("104")){//虚拟表单能用批量共享
				if(createname.equals("")){
					createname = SystemEnv.getHtmlLabelName(18037,user.getLanguage());
				}
				methodStr = "batchShare()";
			}
			if(issystemflag.equals("105")){
				if(createname.equals("")){
					createname = SystemEnv.getHtmlLabelName(17416,user.getLanguage());
				}
				methodStr = "getAllExcelOut()";
			}
			if(issystemflag.equals("106")){//显示定制列
				if(createname.equals("")){
					createname = SystemEnv.getHtmlLabelName(32535,user.getLanguage());
				}
				methodStr = "columnMake()";
			}
			if(issystemflag.equals("110")){
				if(createname.equals("")){
					createname = SystemEnv.getHtmlLabelName(82639,user.getLanguage())+SystemEnv.getHtmlLabelName(22967,user.getLanguage());
				}
				methodStr = "showMapPage()";
			}
		}
	}else{
		if(isuse.equals("0")||isuse.equals("")){
			//continue;
		}else{
			createname = expendname;
			if(_opentype.equals("1")){//默认窗口，当前窗口
				methodStr = "windowOpenOnSelf("+detailid+")";
		   	}else if(_opentype.equals("2")){//弹出窗口
		   		methodStr = "windowOpenOnNew("+detailid+")";
		   	}else if(_opentype.equals("3")){//其它
		   		methodStr = "doCustomFunction("+detailid+")";
		   	}
		   	if("4".equals(hreftype)){
		   		methodStr = "batchmodifyfeildvalue("+detailid+","+hrefid+")";
		   	}
		}
	}
	expandbuttonMap.put("createname",createname);
	expandbuttonMap.put("methodStr",methodStr);
	expandbuttonList.add(expandbuttonMap);
	
}

boolean isbatchsetnew = true;
RecordSet.executeSql("select 1 from mode_batchset where customsearchid="+customid);
if(RecordSet.next()){
	isbatchsetnew = false;
}
%>

	<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td>
			</td>
			<td class="rightSearchSpan" style="text-align:right;">
				<%if (isbatchsetnew) {
					if (CreateRight && isCreateBox && "1".equals(isShowCreateBtn) && !isBatchEditPage) {%><!-- 新建 -->
						<input name="add_zh" type="button" class="e8_btn_top" value="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage()) %>" onclick="javascript:Add()"/>				
				<%  }
				  } else {%><!-- 有查询批量操作的，都按照 查询批量操作获取-->
                <%      
                		for (int i = 0 ; i < expandbuttonList.size() ; i++) {
                			Map<String,String> expandbuttonMap = expandbuttonList.get(i);
                			String createname = (String)expandbuttonMap.get("createname");
                			String methodStr = (String)expandbuttonMap.get("methodStr");
                			if (!methodStr.isEmpty()) {%>
								<input name="expand_zh" type="button" class="e8_btn_top" value="<%=createname %>" onclick="javascript:<%=methodStr %>"/>
				<%      	} 
                		}
				  }
				%>
				<%if(searchKeyNum==0){%>
				<input type="hidden" id="searchName" name="searchName"/>
				<%}else{%>
				<input type="text" class="searchInput" id="searchName" name="searchName" value="<%=searchkeyname%>" title="<%=quickTitle %>"/>
				<%}%><!-- 高级搜索 -->
				<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span>
				<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage())%>" class="cornerMenu"></span><!-- 菜单 -->
			</td>
		</tr>
	</table>
	
<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:hide;overflow: auto" >
<form id="frmmain" name="frmmain" method="post" action="/formmode/search/CustomSearchBySimpleIframe.jsp?<%=tempquerystring%>">
<iframe id="selectChange" frameborder=0 scrolling=no src=""  style="display:none"></iframe>
<input id="customid" name=customid type=hidden value="<%=customid%>"/>
<input id="isDel" name="isDel" type=hidden value="<%=isDel%>"/>
<input name=viewtype type=hidden value="<%=viewtype%>"/>
<input name=issimple type=hidden value="<%=issimple%>"/>
<input name=templateid id="templateid" type=hidden value="<%=templateid%>"/>
<input name="deletebillid" id="deletebillid" type=hidden value=""/>
<input name="method" id="method" type=hidden value=""/>
<input name="searchMethod" id="searchMethod" type=hidden value=""/>
<input type=hidden name="pageexpandid" id="pageexpandid" value="">
<input name="treesqlwhere" id="treesqlwhere" type=hidden value=""/>
<input name="treesqlwhere1" id="treesqlwhere1" type=hidden value="<%=treesqlwhere1 %>"/>
<input name="formmodeid" id="formmodeid" type="hidden" value="<%=modeid %>"/>
<input type=hidden name=formid id="formid" value="<%=formID %>"/>
<input type=hidden name=groupby id="groupby" value="<%=groupby %>"/>
<input type=hidden name=searchkeyname id="searchkeyname" value="<%=searchkeyname%>"/>
<input type=hidden name="isusersearchkey" id="isusersearchkey" value="0"/>
<input type=hidden name="treenodeid" id="treenodeid" value="<%=treenodeid %>"/>
<input type=hidden name="treeconid" id="treeconid" value="<%=treeconid %>"/>
<input type=hidden name="<%="treecon"+treeconid+"_value" %>" id="<%="treecon"+treeconid+"_value" %>" value="<%=treeconvalue %>"/>
<wea:layout type="4col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage()) %>' attributes=""><!-- 自定义查询条件 -->
		<wea:item type="groupHead">
		 	<div style="margin-top:-2px;width:219px;" class="templatecls">
		    	<select name="template" id="template" onChange="onChangeTemplate(this);" style="width: 135px;">
		    		<option value="-1"></option>
		    		<%
		    		rs.executeSql("select id,templatename from mode_templateinfo where customid="+customid+" and (sourcetype=1 or sourcetype=2) and createrid='"+user.getUID()+"' order by displayorder");
		    		while (rs.next()) {
		    			int t_id = rs.getInt("id");
		    			String t_name = rs.getString("templatename");
		    			String selectedstr = "";
		    			if (t_id == templateid) {
		    				selectedstr = " selected ";
		    			}
		    		%>
		    		<option value="<%=t_id %>"<%=selectedstr %>><%=t_name %></option>
		    		<%
		    		}
		    		%>
		    	</select>
		    	<a href="javascript:void(0)"  onclick="templateManage(2)"><%=SystemEnv.getHtmlLabelName(17857,user.getLanguage()) %><!-- 模板管理 --></a>
	    	</div>
	    </wea:item>
		<% if(!disQuickSearch.equals("1") && !isVirtualForm) {%>
			<wea:item>
				<%=SystemEnv.getHtmlLabelName(81449,user.getLanguage())%><!-- 创建日期属于 -->
			</wea:item>
			<wea:item>
				<input type="checkbox" id="thisdate" name="thisdate" value="1" onclick="clickThisDate(this)" <%if(thisdate.equals("1")){out.println("checked");}%>>
				<span style="font-size:12px;TEXT-DECORATION:none;color:<%if("1".equals(thisdate)){%>#0000FF<%}else{%>#6A9EE6<%}%>;cursor:hand" onclick="quickSearchDate('1')">[<%=SystemEnv.getHtmlLabelName(15539,user.getLanguage())%>]</span><!-- 本周 -->
				<input type="checkbox" id="thisdate" name="thisdate" value="2" onclick="clickThisDate(this)" <%if(thisdate.equals("2")){out.println("checked");}%>>
				<span style="font-size:12px;TEXT-DECORATION:none;color:<%if("2".equals(thisdate)){%>#0000FF<%}else{%>#6A9EE6<%}%>;cursor:hand" onclick="quickSearchDate('2')">[<%=SystemEnv.getHtmlLabelName(15541,user.getLanguage())%>]</span><!-- 本月 -->
				<br/>
				<input type="checkbox" id="thisdate" name="thisdate" value="3" onclick="clickThisDate(this)" <%if(thisdate.equals("3")){out.println("checked");}%>>
				<span style="font-size:12px;TEXT-DECORATION:none;color:<%if("3".equals(thisdate)){%>#0000FF<%}else{%>#6A9EE6<%}%>;cursor:hand" onclick="quickSearchDate('3')">[<%=SystemEnv.getHtmlLabelName(21904,user.getLanguage())%>]</span><!-- 本季 -->
				<input type="checkbox" id="thisdate" name="thisdate" value="4" onclick="clickThisDate(this)" <%if(thisdate.equals("4")){out.println("checked");}%>>
				<span style="font-size:12px;TEXT-DECORATION:none;color:<%if("4".equals(thisdate)){%>#0000FF<%}else{%>#6A9EE6<%}%>;cursor:hand" onclick="quickSearchDate('4')">[<%=SystemEnv.getHtmlLabelName(15384,user.getLanguage())%>]</span><!-- 本年 -->
			</wea:item>

			<wea:item><%=SystemEnv.getHtmlLabelName(81448,user.getLanguage())%></wea:item><!-- 创建人属于 -->
			<wea:item>
				<input type="checkbox" id="thisorg" name="thisorg" value="1" onclick="clickThisOrg(this)" <%if(thisorg.equals("1")){out.println("checked");}%>>
				<span style="font-size:12px;TEXT-DECORATION:none;color:<%if("1".equals(thisorg)){%>#0000FF<%}else{%>#6A9EE6<%}%>;cursor:hand" onclick="quickSearchOrg('1')">[<%=SystemEnv.getHtmlLabelName(21837,user.getLanguage())%>]</span><!-- 本部门 -->
				<input type="checkbox" id="thisorg" name="thisorg" value="2" onclick="clickThisOrg(this)" <%if(thisorg.equals("2")){out.println("checked");}%>>
				<span style="font-size:12px;TEXT-DECORATION:none;color:<%if("2".equals(thisorg)){%>#0000FF<%}else{%>#6A9EE6<%}%>;cursor:hand" onclick="quickSearchOrg('2')">[<%=SystemEnv.getHtmlLabelName(81362,user.getLanguage())%>]</span><!-- 本部门(包含下级部门) -->
				<br/>
				<input type="checkbox" id="thisorg" name="thisorg" value="3" onclick="clickThisOrg(this)" <%if(thisorg.equals("3")){out.println("checked");}%>>
				<span style="font-size:12px;TEXT-DECORATION:none;color:<%if("3".equals(thisorg)){%>#0000FF<%}else{%>#6A9EE6<%}%>;cursor:hand" onclick="quickSearchOrg('3')">[<%=SystemEnv.getHtmlLabelName(30792,user.getLanguage())%>]</span><!-- 本分部 -->
				<input type="checkbox" id="thisorg" name="thisorg" value="4" onclick="clickThisOrg(this)" <%if(thisorg.equals("4")){out.println("checked");}%>>
				<span style="font-size:12px;TEXT-DECORATION:none;color:<%if("4".equals(thisorg)){%>#0000FF<%}else{%>#6A9EE6<%}%>;cursor:hand" onclick="quickSearchOrg('4')">[<%=SystemEnv.getHtmlLabelName(81363,user.getLanguage())%>]</span><!-- 本分部(包含下级分部) -->
			</wea:item>
		<%}%>
		<%if(isEnabled&&viewtype!=3&&!isVirtualForm){%>
			<wea:item><%=SystemEnv.getHtmlLabelName(82439,user.getLanguage())%></wea:item><!-- 数据状态 -->
			<wea:item>
				<input type="checkbox" id="enabled" name="enabled" value="1" onclick="clickEnabled(this)" <%if(enabled.equals("1")){out.println("checked");}%>>
				<span style="font-size:12px;TEXT-DECORATION:none;color:<%if("1".equals(enabled)){%>#0000FF<%}else{%>#6A9EE6<%}%>" ><%=SystemEnv.getHtmlLabelName(25426,user.getLanguage())%></span><!-- 未读 -->
				<input type="checkbox" id="enabled" name="enabled" value="2" onclick="clickEnabled(this)" <%if(enabled.equals("2")){out.println("checked");}%>>
				<span style="font-size:12px;TEXT-DECORATION:none;color:<%if("2".equals(enabled)){%>#0000FF<%}else{%>#6A9EE6<%}%>" ><%=SystemEnv.getHtmlLabelName(21950,user.getLanguage())%></span><!-- 反馈 -->
				<input type="checkbox" id="enabled" name="enabled" value="3" onclick="clickEnabled(this)" <%if(enabled.equals("3")){out.println("checked");}%>>
				<span style="font-size:12px;TEXT-DECORATION:none;color:<%if("3".equals(enabled)){%>#0000FF<%}else{%>#6A9EE6<%}%>" ><%=SystemEnv.getHtmlLabelName(25425,user.getLanguage())%></span><!-- 已读-->
			</wea:item>
		<%}%>

<%//以下开始列出自定义查询条件
sql="";
//获取sql
ActionMap.put("action","customQuerySql");
CustomSearchUtil.setMap(ActionMap);
sql=CustomSearchUtil.getSearchSql();
if (templateid == 0) { //如果没有模板，则获取默认模板信息
	rs.execute("select id from mode_TemplateInfo where customid="+customid+" and isdefault=1 and sourcetype=2 and createrid='"+user.getUID()+"'");
	if (rs.next()) {
		templateid = rs.getInt("id");
	}
}
if (templateid > 0) { //如果有模板，则获取模板信息
  //获取sql
    ActionMap.put("action","customHaveTempSql");
    CustomSearchUtil.setMap(ActionMap);
    sql=CustomSearchUtil.getSearchSql();
}
int i=0;
RecordSet.execute(sql);
while (RecordSet.next())
{
i++;
String name = RecordSet.getString("name");
String label = RecordSet.getString("label");
String htmltype = RecordSet.getString("httype");
String type = RecordSet.getString("type");
String id = RecordSet.getString("id");
String dbtype = Util.null2String(RecordSet.getString("dbtype"));
int selectitem =Util.getIntValue(Util.null2String(RecordSet.getString("selectitem")),0);
int linkfield = 0;
rs.execute("select id from workflow_billfield where linkfield="+id);
if(rs.next()){
	linkfield = Util.getIntValue(rs.getString("id"), 0);
}
label = SystemEnv.getHtmlLabelName(Util.getIntValue(label),user.getLanguage());
String childfieldid = Util.null2String(RecordSet.getString("childfieldid"));
int field_viewtype=RecordSet.getInt("viewtype");

String browsertype = type;
if (type.equals("0")) browsertype = "";
String completeUrl = "javascript:getajaxurl('"+browsertype+"','"+dbtype+"','"+id+"','1')";
int conditionTransition = Util.getIntValue(Util.null2String(RecordSet.getString("conditionTransition")),0);

if(id.equals("-1")){
    id="_3";
    name="modedatacreatedate";
    label=SystemEnv.getHtmlLabelName(722,user.getLanguage());//创建日期
    htmltype="3";
    type="2";
}else if(id.equals("-2")){
    id="_4";
    name="modedatacreater";
    label=SystemEnv.getHtmlLabelName(882,user.getLanguage());// 创建人
    htmltype="3";
    type="1";
}
String namestr = "con"+id+"_value";
String display="display:'';";
if(issimple) display="display:none;";
String checkstr="checked";
String tmpvalue="";
String tmpvalue1="";
String tmpname="";
if(isresearch==1){
    tmpvalue=Util.null2String((String)conht.get("con_"+id+"_value"));
    tmpvalue1=Util.null2String((String)conht.get("con_"+id+"_value1"));
    tmpname=Util.null2String((String)conht.get("con_"+id+"_name"));
}
%>
		<wea:item><!-- 是否作为查询条件 -->
			<input type='checkbox' name='check_con' title="<%=SystemEnv.getHtmlLabelName(20778,user.getLanguage())%>" value="<%=id%>" style="display:none" <%=checkstr%>> <%=label%>
			<input type=hidden name="con<%=id%>_htmltype" value="<%=htmltype%>">
			<input type=hidden name="con<%=id%>_type" value="<%=type%>">
			<input type=hidden name="con<%=id%>_colname" value="<%=name%>">
			<input type=hidden name="con<%=id%>_viewtype" value="<%=field_viewtype%>">
		</wea:item>
		<wea:item>
<%
if("3".equals(htmltype) && !"".equals(tmpvalue)){
	FieldInfo fieldInfo = new FieldInfo();
	tmpname = fieldInfo.getFieldName(tmpvalue, Util.getIntValue(type), dbtype);
}
//=========================================================================================文本框
if((htmltype.equals("1")&& type.equals("1"))||htmltype.equals("2")){
    int tmpopt=3;
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),3);
%>
		<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
		<%if(!htmltype.equals("2")){//TD9319 屏蔽掉多行文本框的“等于”和“不等于”操作，text数据库类型不支持该判断%>
		<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>     <!--等于-->
		<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>   <!--不等于-->
		<%}%>
		<option value="3" <%if(tmpopt==3){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>   <!--包含-->
		<option value="4" <%if(tmpopt==4){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>   <!--不包含-->

		</select>
		<input type=text class=InputStyle style="width:50%" name="con<%=id%>_value" value="<%=tmpvalue%>">
	
		<SPAN id=remind style='cursor:hand' title='<%=SystemEnv.getHtmlLabelName(82346,user.getLanguage())%>&#10;<%=SystemEnv.getHtmlLabelName(82347,user.getLanguage())%>&#10;<%=SystemEnv.getHtmlLabelName(82348,user.getLanguage())%>&#10;<%=SystemEnv.getHtmlLabelName(82349,user.getLanguage())%>'>
		<IMG src='/images/remind_wev8.png' align=absMiddle>
		</SPAN>
<%
//=========================================================================================数字   <!--大于,大于或等于,小于,小于或等于,等于,不等于-->
}else if(htmltype.equals("1")&& !type.equals("1")){  
    int tmpopt=2;
    int tmpopt1=4;
    if(isresearch==1) {
        tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),2);
        tmpopt1=Util.getIntValue((String)conht.get("con_"+id+"_opt1"),4);
    }
%>
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option><!-- 大于 -->
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option><!-- 大于或等于 -->
<option value="3" <%if(tmpopt==3){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option><!-- 小于 -->
<option value="4" <%if(tmpopt==4){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option><!-- 小于或等于 -->
<option value="5" <%if(tmpopt==5){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option><!-- 等于 -->
<option value="6" <%if(tmpopt==6){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option><!-- 不等于 -->
</select>
<%if(issimple){%><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%><%}%>
<input type=text class=InputStyle size=10 name="con<%=id%>_value" onblur="checknumber('con<%=id%>_value');" value="<%=tmpvalue%>" style="width:75px;">
<select class=inputstyle  name="con<%=id%>_opt1" style="<%=display%>width:90"  >
<option value="1" <%if(tmpopt1==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option><!-- 大于 -->
<option value="2" <%if(tmpopt1==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option><!-- 大于或等于 -->
<option value="3" <%if(tmpopt1==3){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option><!-- 小于 -->
<option value="4" <%if(tmpopt1==4){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option><!-- 小于或等于 -->
<option value="5" <%if(tmpopt1==5){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option><!-- 等于 -->
<option value="6" <%if(tmpopt1==6){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option><!-- 不等于 -->
</select>
<%if(issimple){%><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%><%}%>
<input type=text class=InputStyle size=10 name="con<%=id%>_value1"  onblur="checknumber('con<%=id%>_value1');" value="<%=tmpvalue1%>" style="width:75px;">
<%
//=========================================================================================check类型
}
else if(htmltype.equals("4")){   
%>
<input type=checkbox value=1 name="con<%=id%>_value" <%if(tmpvalue.equals("1")){%>checked<%}%>>
<%
//=========================================================================================选择框	
}
else if(htmltype.equals("5")){  //
    int tmpopt=1;
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option><!-- 等于 -->
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option><!-- 不等于 -->
</select>
<%
String selectchange = "";
if(!childfieldid.equals("")&&!childfieldid.equals("0")){//子字段联动
	selectchange = "changeChildField(this,'"+id+"','"+childfieldid+"');";
	initselectfield += "changeChildField(jQuery('#con"+id+"_value')[0],'"+id+"','"+childfieldid+"');";
	ldselectfieldid.add(id+"");
}
//下拉框查询条件多选
String multiselect="";
String multiselectvalue="";
if (templateid > 0) { //如果有模板，则获取模板信息
	RecordSet  multiselectRs = new RecordSet();
    multiselectRs.executeSql("select conditionTransition from mode_CustomDspField where fieldid="+id+" and customid="+customid);
	if(multiselectRs.next()){
		conditionTransition = multiselectRs.getInt("conditionTransition");
	}
}
if(conditionTransition==1){
	multiselect="multiple=\"multiple\"";
	multiselectid+="con"+id+"_value,";
	multiselectvalue = Util.null2String(conht.get("multiselectValue_con_"+id+"_value"));
}else{
	multiselectvalue = tmpvalue;
}
%>
<input type="hidden" name="multiselectValue_con<%=id%>_value" id="multiselectValue_con<%=id%>_value" value="<%=multiselectvalue %>" />
<select notBeauty=true class=inputstyle <%=multiselect %> value="<%=multiselectvalue %>"  name="con<%=id%>_value" id="con<%=id%>_value"  onchange="<%=selectchange%>;change_multiselectValue_con_value('<%=id%>',this.value)" >
<%
if(conditionTransition!=1){
 %>
<option value="" ></option>
<%
}
char flag=2;
rs.executeProc("workflow_SelectItemSelectByid",""+id+flag+isbill);
while(rs.next()){
	int tmpselectvalue = rs.getInt("selectvalue");
	String tmpselectname = rs.getString("selectname");
	String tempcancel = rs.getString("cancel");
	if("1".equals(tempcancel)){
		continue;
	}
%>
<option value="<%=tmpselectvalue%>" <%if (tmpvalue.equals(""+tmpselectvalue)) {%>selected<%}%>><%=Util.toScreen(tmpselectname,user.getLanguage())%></option>
<%} %>
</select>

<%
//=========================================================================================浏览框单人力资源  条件为多人力 (like not lik)
} else if(htmltype.equals("3") && type.equals("1")){////浏览框单人力资源 
    int tmpopt=1;
    //String browserOnClick = "onShowBrowser('"+id+"','/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp')";
    String browserUrl = "/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp";
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90">
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18987,user.getLanguage())%></option><!-- 被包含于 -->
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18988,user.getLanguage())%></option><!-- 不被包含于 -->
</select>

<brow:browser viewType="0" name='<%=namestr%>' browserValue='<%=tmpvalue %>'
	_callback="change_con_name"
	_callbackParams="<%=id%>" 
	browserUrl='<%= browserUrl %>'
	hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
	completeUrl='<%=completeUrl%>' width="135px" 
	browserSpanValue='<%=tmpname%>'>
</brow:browser>
<input type=hidden name="con<%=id%>_name" value='<%=tmpname%>'>
<%
//=========================================================================================浏览框单文挡  条件为多文挡 (like not lik)
} else if(htmltype.equals("3") && type.equals("9")){//浏览框单文挡  
    int tmpopt=1;
    //String browserOnClick = "onShowBrowser('"+id+"','/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp')";
    String browserUrl = "/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp";
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18987,user.getLanguage())%></option><!-- 被包含于 -->
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18988,user.getLanguage())%></option><!-- 不被包含于 -->
</select>

<brow:browser viewType="0" name='<%=namestr%>' browserValue='<%=tmpvalue %>' 
	_callback="change_con_name"
	_callbackParams="<%=id%>"
	browserUrl='<%= browserUrl %>'
	hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
	completeUrl='<%=completeUrl%>' width="135px" 
	browserSpanValue='<%=tmpname%>'>
</brow:browser>
<input type=hidden name="con<%=id%>_name" value='<%=tmpname%>'>
<%
//=========================================================================================
} else if(htmltype.equals("3") && type.equals("4")){//浏览框单部门 
    int tmpopt=1;
    //String browserOnClick = "onShowBrowser('"+id+"','/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp')";
    String browserUrl = "/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp";
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18987,user.getLanguage())%></option><!-- 被包含于 -->
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18988,user.getLanguage())%></option><!-- 不被包含于 -->
</select>

<brow:browser viewType="0" name='<%=namestr%>' browserValue='<%=tmpvalue %>' 
	_callback="change_con_name"
	_callbackParams="<%=id%>"
	browserUrl='<%= browserUrl %>'
	hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
	completeUrl='<%=completeUrl%>' width="135px" 
	browserSpanValue='<%=tmpname%>'>
</brow:browser>
<input type=hidden name="con<%=id%>_name" value='<%=tmpname%>'>
	<%
	
//=========================================================================================
} else if(htmltype.equals("3") && type.equals("7")){//浏览框单客户 
        int tmpopt=1;
        //String browserOnClick = "onShowBrowser('"+id+"','/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp')";
        String browserUrl = "/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp";
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90"  >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18987,user.getLanguage())%></option><!-- 被包含于 -->
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18988,user.getLanguage())%></option><!-- 不被包含于 -->
</select>

<brow:browser viewType="0" name='<%=namestr%>' browserValue='<%=tmpvalue %>' 
	_callback="change_con_name"
	_callbackParams="<%=id%>"
	browserUrl='<%= browserUrl %>'
	hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
	completeUrl='<%=completeUrl%>' width="135px" 
	browserSpanValue='<%=tmpname%>'>
</brow:browser>
<input type=hidden name="con<%=id%>_name" value='<%=tmpname%>'>
<%
//=========================================================================================	
} else if(htmltype.equals("3") && type.equals("8")){//浏览框单项目
    int tmpopt=1;
    //String browserOnClick="onShowBrowser('"+id+"','/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp')";
    String browserUrl = "/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp";
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18987,user.getLanguage())%></option><!-- 被包含于 -->
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18988,user.getLanguage())%></option><!-- 不被包含于 -->
</select>

<brow:browser viewType="0" name='<%=namestr%>' browserValue='<%=tmpvalue %>' 
	_callback="change_con_name"
	_callbackParams="<%=id%>"
	browserUrl='<%= browserUrl %>'
	hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
	completeUrl='<%=completeUrl%>' width="135px" 
	browserSpanValue='<%=tmpname%>'>
</brow:browser>
<input type=hidden name="con<%=id%>_name" value='<%=tmpname%>'>
<%
	
//=========================================================================================
} else if(htmltype.equals("3") && type.equals("16")){//浏览框单请求
    int tmpopt=1;
    //String browserOnClick="onShowBrowser('"+id+"','/systeminfo/BrowserMain.jsp?url=/workflow/request/RequestBrowser.jsp')";
    String browserUrl = "/systeminfo/BrowserMain.jsp?url=/workflow/request/RequestBrowser.jsp";
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18987,user.getLanguage())%></option><!-- 被包含于 -->
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18988,user.getLanguage())%></option><!-- 不被包含于 -->
</select>

<brow:browser viewType="0" name='<%=namestr%>' browserValue='<%=tmpvalue %>' 
	_callback="change_con_name"
	_callbackParams="<%=id%>"
	browserUrl='<%= browserUrl %>'
	hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
	completeUrl='<%=completeUrl%>' width="135px" 
	browserSpanValue='<%=tmpname%>'>
</brow:browser>
<input type=hidden name="con<%=id%>_name" value='<%=tmpname%>'>
<%
	
//=========================================================================================
}else if(htmltype.equals("3") && type.equals("24")){//职位
    int tmpopt=5;
%>
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<option value="5" <%if(tmpopt==5){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18987,user.getLanguage())%></option><!-- 被包含于 -->
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18988,user.getLanguage())%></option><!-- 不被包含于 -->
</select>
<brow:browser viewType="0" name='<%=namestr%>' browserValue='<%=tmpvalue %>' 
	_callback="change_con_name"
	_callbackParams="<%=id%>"
	browserUrl='/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/JobTitlesBrowser.jsp'
	hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
	completeUrl='<%=completeUrl%>' width="135px" 
	browserSpanValue='<%=tmpname%>'>
</brow:browser>
<input type=hidden name="con<%=id%>_name" value='<%=tmpname%>'>
<%
//=========================================================================================	
}//职位end

else if(htmltype.equals("3") &&( type.equals("2") || type.equals("19"))){    //日期
	
	int tmpopt=2;
    int tmpopt1=4;
    String classStr = "";
	if(type.equals("2")){ //日期
		display = "display:none;";
		String datetype_opt_span_display = "display:none;";
		classStr = "calendar";
		int datetype_opt = Util.getIntValue(Util.null2String(request.getParameter("datetype_"+id+"_opt")),0);
		if(datetype_opt==0){
			datetype_opt = Util.getIntValue(Util.null2String((String)conht.get("datetype_"+id+"_opt")),6);
		}
		if(datetype_opt == 6){
			datetype_opt_span_display = "display:inline;";
		}
		%>
		<select name="datetype_<%=id%>_opt" id="datetype_<%=id%>_opt" style="display: block;" onchange="changeDateType(this,'datetype_<%=id%>_opt_span','con<%=id%>_value','con<%=id%>_valuespan','con<%=id%>_value1','con<%=id%>_value1span')">
		<option value="1" <%if(datetype_opt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15537,user.getLanguage())%></option><!-- 今天 -->
		<option value="2" <%if(datetype_opt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15539,user.getLanguage())%></option><!-- 本周 -->
		<option value="3" <%if(datetype_opt==3){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15541,user.getLanguage())%></option><!-- 本月 -->
		<option value="7" <%if(datetype_opt==7){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(27347,user.getLanguage())%></option><!-- 上个月 -->
		<option value="4" <%if(datetype_opt==4){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(21904,user.getLanguage())%></option><!-- 本季 -->
		<option value="5" <%if(datetype_opt==5){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15384,user.getLanguage())%></option><!-- 本年 -->
		<option value="8" <%if(datetype_opt==8){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(31276,user.getLanguage())+SystemEnv.getHtmlLabelName(25201,user.getLanguage())%></option><!-- 上一年 -->
		<option value="6" <%if(datetype_opt==6){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(32530,user.getLanguage())%></option><!-- 指定日期范围 -->
		</select>
		<span name="datetype_<%=id%>_opt_span" id="datetype_<%=id%>_opt_span" style="<%=datetype_opt_span_display%>">
			<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90">
			<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option><!-- 大于 -->
			<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option><!-- 大于或等于 -->
			<option value="3" <%if(tmpopt==3){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option><!-- 小于 -->
			<option value="4" <%if(tmpopt==4){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option><!-- 小于或等于 -->
			<option value="5" <%if(tmpopt==5){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option><!-- 等于 -->
			<option value="6" <%if(tmpopt==6){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option><!-- 不等于 -->
			</select>
			<%if(issimple){%><%=SystemEnv.getHtmlLabelName(348,user.getLanguage())%><%}%><!-- 从 -->
			<button type=button  class="<%=classStr %>" onclick="onSearchWFQTDate(con<%=id%>_valuespan,con<%=id%>_value,con<%=id%>_value1)" ></button>
			<input type=hidden name="con<%=id%>_value" id="con<%=id%>_value" value="<%=tmpvalue%>">
			<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=tmpvalue%></span>
			<select class=inputstyle  name="con<%=id%>_opt1" style="<%=display%>width:90"  >
			<option value="1" <%if(tmpopt1==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option><!-- 大于 -->
			<option value="2" <%if(tmpopt1==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option><!-- 大于或等于 -->
			<option value="3" <%if(tmpopt1==3){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option><!-- 小于 -->
			<option value="4" <%if(tmpopt1==4){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option><!-- 小于或等于 -->
			<option value="5" <%if(tmpopt1==5){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option><!-- 等于 -->
			<option value="6" <%if(tmpopt1==6){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option><!-- 不等于 -->
			</select>
			<%if(issimple){%><%=SystemEnv.getHtmlLabelName(349,user.getLanguage())%><%}%><!-- 到 -->
			<button type=button  class="<%=classStr %>" onclick="onSearchWFQTDate(con<%=id%>_value1span,con<%=id%>_value1,con<%=id%>_value)" ></button>
			<input type=hidden name="con<%=id%>_value1" id="con<%=id%>_value1" value="<%=tmpvalue1%>">
			<span name="con<%=id%>_value1span" id="con<%=id%>_value1span"><%=tmpvalue1%></span>
		</span>
		<%
	}else{ //时间
		if(isresearch==1) {
	        tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),2);
	        tmpopt1=Util.getIntValue((String)conht.get("con_"+id+"_opt1"),4);
	    }
		classStr = "Clock";
		%>
		<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90">
		<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option><!-- 大于 -->
		<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option><!-- 大于或等于 -->
		<option value="3" <%if(tmpopt==3){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option><!-- 小于 -->
		<option value="4" <%if(tmpopt==4){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option><!-- 小于或等于 -->
		<option value="5" <%if(tmpopt==5){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option><!-- 等于 -->
		<option value="6" <%if(tmpopt==6){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option><!-- 不等于 -->
		</select>
		<%if(issimple){%><%=SystemEnv.getHtmlLabelName(348,user.getLanguage())%><%}%><!-- 从 -->
		<button type=button  class="<%=classStr %>" onclick ="onSearchWFQTTime(con<%=id%>_valuespan,con<%=id%>_value,con<%=id%>_value1)" ></button>
		<input type=hidden name="con<%=id%>_value" id="con<%=id%>_value" value="<%=tmpvalue%>">
		<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=tmpvalue%></span>
		<select class=inputstyle  name="con<%=id%>_opt1" style="<%=display%>width:90"  >
		<option value="1" <%if(tmpopt1==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option><!-- 大于 -->
		<option value="2" <%if(tmpopt1==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option><!-- 大于或等于 -->
		<option value="3" <%if(tmpopt1==3){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option><!-- 小于 -->
		<option value="4" <%if(tmpopt1==4){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option><!-- 小于或等于 -->
		<option value="5" <%if(tmpopt1==5){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option><!-- 等于 -->
		<option value="6" <%if(tmpopt1==6){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option><!-- 不等于 -->
		</select>
		<%if(issimple){%><%=SystemEnv.getHtmlLabelName(349,user.getLanguage())%><%}%><!-- 到 -->
		<button type=button  class="<%=classStr %>" onclick ="onSearchWFQTTime(con<%=id%>_value1span,con<%=id%>_value1,con<%=id%>_value)" ></button>
		<input type=hidden name="con<%=id%>_value1" id="con<%=id%>_value1" value="<%=tmpvalue1%>">
		<span name="con<%=id%>_value1span" id="con<%=id%>_value1span"><%=tmpvalue1%></span>
		<%
	}

//=========================================================================================	
} else if(htmltype.equals("3") && type.equals("17")){ //人力资源 多选框
    int tmpopt=1;
    String browserOnClick="onShowBrowser('"+id+"','/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp')";
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option><!-- 包含 -->
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option><!-- 不包含 -->
</select>

<brow:browser viewType="0" name='<%=namestr%>' browserValue='<%=tmpvalue %>' 
	_callback="change_con_name"
	_callbackParams="<%=id%>"
	browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp"
	hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1'
	completeUrl='<%=completeUrl%>' width="135px" 
	browserSpanValue='<%=tmpname%>'>
</brow:browser>
<input type=hidden name="con<%=id%>_name" value='<%=tmpname%>'>
<%
//=========================================================================================	
} else if(htmltype.equals("3") && type.equals("37")){//浏览框 (多文挡)
    int tmpopt=1;
    //String browserOnClick="onShowBrowser('"+id+"','/systeminfo/BrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp?isworkflow=1')";
    String browserUrl = "/systeminfo/BrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp?isworkflow=1";
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option><!-- 包含 -->
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option><!-- 不包含 -->
</select>

<brow:browser viewType="0" name='<%=namestr%>' browserValue='<%=tmpvalue %>' 
	_callback="change_con_name"
	_callbackParams="<%=id%>"
	browserUrl='<%= browserUrl %>'
	hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1'
	completeUrl='<%=completeUrl%>' width="135px" 
	browserSpanValue='<%=tmpname%>'>
</brow:browser>
<input type=hidden name="con<%=id%>_name" value='<%=tmpname%>'>
<%
//=========================================================================================	
} else if(htmltype.equals("3") && type.equals("57")){//浏览框（多部门）
    int tmpopt=1;
    //String browserOnClick="onShowBrowser('"+id+"','/systeminfo/BrowserMain.jsp?url=/hrm/company/MultiDepartmentBrowserByOrder.jsp')";
    String browserUrl = "/systeminfo/BrowserMain.jsp?url=/hrm/company/MultiDepartmentBrowserByOrder.jsp";
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>
<select class=inputstyle  name="con<%=id%>_opt" style="width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option><!-- 包含 -->
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option><!-- 不包含 -->
</select>

<brow:browser viewType="0" name='<%=namestr%>' browserValue='<%=tmpvalue %>' 
	_callback="change_con_name"
	_callbackParams="<%=id%>"
	browserUrl='<%= browserUrl %>'
	hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1'
	completeUrl='<%=completeUrl%>' width="135px" 
	browserSpanValue='<%=tmpname%>'>
</brow:browser>
<input type=hidden name="con<%=id%>_name" value='<%=tmpname%>'>
<%
//=========================================================================================	
} else if(htmltype.equals("3") && type.equals("135")){//浏览框（多项目 ）
    int tmpopt=1;
    //String browserOnClick="onShowBrowser('"+id+"','/systeminfo/BrowserMain.jsp?url=/proj/data/MultiProjectBrowser.jsp')";
    String browserUrl = "/systeminfo/BrowserMain.jsp?url=/proj/data/MultiProjectBrowser.jsp";
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option><!-- 包含 -->
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option><!-- 不包含 -->
</select>

<brow:browser viewType="0" name='<%=namestr%>' browserValue='<%=tmpvalue %>' 
	_callback="change_con_name"
	_callbackParams="<%=id%>"
	browserUrl='<%= browserUrl %>'
	hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1'
	completeUrl='<%=completeUrl%>' width="135px" 
	browserSpanValue='<%=tmpname%>'>
</brow:browser>
<input type=hidden name="con<%=id%>_name" value='<%=tmpname%>'>
<%
//=========================================================================================	
} else if(htmltype.equals("3") && type.equals("152")){//浏览框（多请求 ）
    int tmpopt=1;
    //String browserOnClick="onShowBrowser('"+id+"','/systeminfo/BrowserMain.jsp?url=/workflow/request/MultiRequestBrowser.jsp')";
    String browserUrl = "/systeminfo/BrowserMain.jsp?url=/workflow/request/MultiRequestBrowser.jsp";
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option><!-- 包含 -->
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option><!-- 不包含 -->
</select>

<brow:browser viewType="0" name='<%=namestr%>' browserValue='<%=tmpvalue %>' 
	_callback="change_con_name"
	_callbackParams="<%=id%>"
	browserUrl='<%= browserUrl %>'
	hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1'
	completeUrl='<%=completeUrl%>' width="135px" 
	browserSpanValue='<%=tmpname%>'>
</brow:browser>
<input type=hidden name="con<%=id%>_name" value='<%=tmpname%>'>
<%
//=========================================================================================	
} else if(htmltype.equals("3") && type.equals("18")){//浏览框  多选筐条件为单选筐
    int tmpopt=1;
    //String browserOnClick="onShowBrowser('"+id+"','/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp')";
    String browserUrl = "/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp";
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option><!-- 包含 -->
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option><!-- 不包含 -->
</select>

<brow:browser viewType="0" name='<%=namestr%>' browserValue='<%=tmpvalue %>' 
	_callback="change_con_name"
	_callbackParams="<%=id%>"
	browserUrl='<%= browserUrl %>'
	hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
	completeUrl='<%=completeUrl%>' width="135px" 
	browserSpanValue='<%=tmpname%>'>
</brow:browser>
<input type=hidden name="con<%=id%>_name" value='<%=tmpname%>'>
<%
//=========================================================================================	
}
else if(htmltype.equals("3") && type.equals("160")){//浏览框  多选筐条件为单选筐
    int tmpopt=1;
    //String browserOnClick="onShowBrowser('"+id+"','/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp')";
    String browserUrl = "/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp";
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90"  >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option><!-- 包含 -->
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option><!-- 不包含 -->
</select>

<brow:browser viewType="0" name='<%=namestr%>' browserValue='<%=tmpvalue %>' 
	_callback="change_con_name"
	_callbackParams="<%=id%>"
	browserUrl='<%= browserUrl %>'
	hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
	completeUrl='<%=completeUrl%>' width="135px" 
	browserSpanValue='<%=tmpname%>'>
</brow:browser>
<input type=hidden name="con<%=id%>_name" value='<%=tmpname%>'>
<%
//=========================================================================================	
} else if(htmltype.equals("3") && type.equals("142")){//浏览框多收发文单位
String urls = "/systeminfo/BrowserMain.jsp?url=/docs/sendDoc/DocReceiveUnitBrowserMulti.jsp?selectids=";
    int tmpopt=1;
    //String browserOnClick="onShowBrowser('"+id+"','"+urls+"')";
    String browserUrl = urls;
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option><!-- 等于 -->
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option><!-- 不等于 -->
</select>

<brow:browser viewType="0" name='<%=namestr%>' browserValue='<%=tmpvalue %>' 
	_callback="change_con_name"
	_callbackParams="<%=id%>"
	browserUrl='<%= browserUrl %>'
	hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1'
	completeUrl='<%=completeUrl%>' width="135px" 
	browserSpanValue='<%=tmpname%>'>
</brow:browser>
<input type=hidden name="con<%=id%>_name" value='<%=tmpname%>'>
<%
//=========================================================================================	
}
else if(htmltype.equals("3") && (type.equals("56")||type.equals("27")||type.equals("118")||type.equals("65")||type.equals("64")||type.equals("137"))){//浏览框
String urls=BrowserComInfo.getBrowserurl(type);     // 浏览按钮弹出页面的url
    int tmpopt=1;
    //String browserOnClick="onShowBrowser('"+id+"','"+urls+"')";
    String browserUrl = urls;
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90"  >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option><!-- 包含 -->
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option><!-- 不包含 -->
</select>

<brow:browser viewType="0" name='<%=namestr%>' browserValue='<%=tmpvalue %>' 
	_callback="change_con_name"
	_callbackParams="<%=id%>"
	browserUrl='<%= browserUrl %>'
	hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
	completeUrl='<%=completeUrl%>' width="135px" 
	browserSpanValue='<%=tmpname%>'>
</brow:browser>
<input type=hidden name="con<%=id%>_name" value='<%=tmpname%>'>
<%
//=========================================================================================	
}else if("3".equals(htmltype) && "141".equals(type)){
	String url = "/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceConditionBrowser.jsp";
	String browserOnClick = "onShowResourceConditionBrowserForCondition('"+namestr+"','"+url+"','','141',0)";
    int tmpopt=1;
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
	%>
	<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90"  >
	<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option><!-- 包含 -->
	<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option><!-- 不包含 -->
	</select>
	<brow:browser viewType="0" name='<%=namestr%>' browserValue='<%=tmpvalue %>' 
		_callback="change_con_name"
		_callbackParams="<%=id%>"
		browserOnClick='<%=browserOnClick%>'
		hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
		completeUrl='<%=completeUrl%>' width="135px" 
		browserSpanValue='<%=tmpname%>'>
	</brow:browser>
	<input type=hidden name="con<%=id%>_name" value='<%=tmpname%>'>
	<%
}
else if(htmltype.equals("3") && id.equals("_5")){//工作流浏览框
    tmpname="";
    ArrayList tempvalues=Util.TokenizerString(tmpvalue,",");
    for(int k=0;k<tempvalues.size();k++){
        if(tmpname.equals("")){
            tmpname=WorkflowComInfo.getWorkflowname((String)tempvalues.get(k));
        }else{
            tmpname+=","+WorkflowComInfo.getWorkflowname((String)tempvalues.get(k));
        }
    }
%>
<input type=hidden  name="con<%=id%>_opt" value="1">
<%if(customid.equals("")){
String browserOnClick="onShowWorkFlowSerach('workflowid','workflowspan')";
%>
<brow:browser viewType="0" name='<%=namestr%>' browserValue='<%=tmpvalue %>' 
	browserOnClick='<%=browserOnClick%>'
	hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
	completeUrl='<%=completeUrl%>' width="135px" 
	browserSpanValue='<%=tmpname%>'>
</brow:browser>
<span id=workflowspan></span>
<%}else{
String browserOnClick="onShowCQWorkFlow('con"+id+"_value','con"+id+"_valuespan')";
%>

<brow:browser viewType="0" name='<%=namestr%>' browserValue='<%=tmpvalue %>' 
	_callback="change_con_name"
	_callbackParams="<%=id%>"
	browserOnClick='<%=browserOnClick%>'
	hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
	completeUrl='<%=completeUrl%>' width="135px" 
	browserSpanValue='<%=tmpname%>'>
</brow:browser>
<input type=hidden name="con<%=id%>_name" value='<%=tmpname%>'>
<%}%>
<%
//=========================================================================================	
} else if (htmltype.equals("3") && (type.equals("161") || type.equals("162"))){
	String urls=BrowserComInfo.getBrowserurl(type)+"?type="+dbtype;     // 浏览按钮弹出页面的url
	String browserOnClick = "onShowBrowserCustomNew('"+id+"','"+urls+"','"+type+"')";
	String method2 = "setName('"+id+"')";
    int tmpopt=1;
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
    String isSignle = "true";
    String width = "135px";
    if (type.equals("162")) {
    	isSignle = "false";
    	width = "270px";
    }
    tmpname=CustomSearchUtil.getModeBrowser(tmpvalue,dbtype);
%>
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option><!-- 等于 -->
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option><!-- 不等于 -->
</select>
<brow:browser viewType="0" name='<%=namestr%>' browserValue='<%=tmpvalue %>' 
	_callback="change_con_name"
	_callbackParams="<%=id%>"
	browserOnClick='<%=browserOnClick %>' browserUrl='<%=urls%>' onPropertyChange='<%=method2%>' 
	hasInput="true" isSingle='<%=isSignle%>' hasBrowser="true" isMustInput='1'
	completeUrl='<%=completeUrl%>' width='<%=width%>' 
	browserSpanValue='<%=tmpname%>'>
</brow:browser>
<input type=hidden name="con<%=id%>_name" value=''>
<%
//=========================================================================================	
}  else if (htmltype.equals("3") && (type.equals("256") || type.equals("257"))){
	String urls=BrowserComInfo.getBrowserurl(type)+"?type="+dbtype+"_"+type;     // 浏览按钮弹出页面的url
    int tmpopt=1;
	String isSingle = "";
    String browserOnClick="onShowBrowserCustomNew('"+id+"','"+urls+"','"+type+"')";
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
    if(type.equals("256")){
    	isSingle = "true";
    }else{
    	isSingle = "false";
    }
    CustomTreeUtil customTreeUtil = new CustomTreeUtil();
    tmpname = customTreeUtil.getTreeFieldShowName(tmpvalue,dbtype);
%>
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option><!-- 等于 -->
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option><!-- 不等于 -->
</select>
<brow:browser viewType="0" name="<%=namestr%>" browserValue="<%=tmpvalue %>" 
	_callback="change_con_name"
	_callbackParams="<%=id%>"
	browserOnClick='<%=browserOnClick %>' browserUrl='<%=urls%>' nameSplitFlag="&nbsp"
	hasInput="true" isSingle="<%=isSingle%>" hasBrowser = "true" isMustInput='1'
	completeUrl="<%=completeUrl%>" width="135px" 
	browserSpanValue="<%=tmpname%>">
</brow:browser>
<input type=hidden name="con<%=id%>_name" value=''>
<%} else if (htmltype.equals("3")){
	String urls=BrowserComInfo.getBrowserurl(type);     // 浏览按钮弹出页面的url
	String sapbrowser_name = "";
	if(type.equals("224") || type.equals("225")||type.equals("226") || type.equals("227")){
		urls += "?type="+dbtype+"|"+id;
		sapbrowser_name = "sapbrowser_name";
	}
    int tmpopt=1;
    String browserOnClick="onShowBrowser('"+id+"','"+urls+"')";
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option><!-- 等于 -->
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option><!-- 不等于 -->
</select>

<brow:browser viewType="0" name='<%=namestr%>' browserValue='<%=tmpvalue %>' 
	_callback="change_con_name"
	_callbackParams="<%=id%>"
	browserUrl='<%= urls %>'
	hasInput="true" isSingle='<%=type.equals("194")?"false":"true" %>' hasBrowser = "true" isMustInput='1'
	completeUrl='<%=completeUrl%>' width="135px" 
	browserSpanValue='<%=tmpname%>'>
</brow:browser>
<input type=hidden name="con<%=id%>_name" class="<%=sapbrowser_name %>" cid='<%=id %>' value='<%=tmpname%>'>
<%
//=========================================================================================	
} else if (htmltype.equals("6")){   //附件上传同多文挡
	String urls=BrowserComInfo.getBrowserurl(type);     // 浏览按钮弹出页面的url
    int tmpopt=1;
    String browserOnClick="onShowBrowser('"+id+"','/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp?isworkflow=1')";
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90"   >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option><!-- 包含 -->
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option><!-- 不包含 -->
</select>

<brow:browser viewType="0" name='<%=namestr%>' browserValue='<%=tmpvalue %>' 
	_callback="change_con_name"
	_callbackParams="<%=id%>"
	browserOnClick='<%=browserOnClick%>'
	hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
	completeUrl='<%=completeUrl%>' width="135px" 
	browserSpanValue='<%=tmpname%>'>
</brow:browser>
<input type=hidden name="con<%=id%>_name" value='<%=tmpname%>'>
<%}else if (htmltype.equals("8")){
	int tmpopt=1;
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
    %>
    <select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90"  >
    <option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option><!-- 等于 -->
    <option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option><!-- 不等于 -->
    </select>
    <%
    String selectchange = "";
    if(linkfield!=0){//公共子字段联动
    	if(!iframeList.contains(id)){
    		iframeList.add(id);
    	}
    	selectchange = "changeChildSelectItemField(this,'"+id+"','"+linkfield+"');";
   	  	int selflinkfieldid = 1;
   		String selfSql = "select linkfield from workflow_billfield where id="+id;
   		selectRs.executeSql(selfSql);
   		if(selectRs.next()){
   			selflinkfieldid = selectRs.getInt("linkfield");
   			if(selflinkfieldid<1){
		    	initselectfield += "changeChildSelectItemField(0,'"+id+"','"+linkfield+"',1); \n ";
   			} 
   		}
    }
  
	
    %>
    <select initvalue="<%=tmpvalue %>" childsel="<%=linkfield %>" notBeauty=true class=inputstyle style="width:175px;"  name="con<%=id%>_value" id="con<%=id%>_value"  onchange="<%=selectchange%>" >
    <option value="" ></option>
   <%
	char flag=2;
	rs.executeSql("select id,name,defaultvalue from mode_selectitempagedetail where mainid = "+selectitem+" and statelev = 1  and (cancel=0 or cancel is null)  order by disorder asc,id asc");
	while(rs.next()){
		int tmpselectvalue = rs.getInt("id");
		String tmpselectname = rs.getString("name");
		String isdefault = rs.getString("defaultvalue");
		%>
		<option value="<%=tmpselectvalue%>" <%if (tmpvalue.equals(""+tmpselectvalue)) {%>selected<%}%>><%=Util.toScreen(tmpselectname,user.getLanguage())%></option>
		<%
	}%>
	</select>
	<%
}%>
</wea:item>
<%}%>
	</wea:group>
	<wea:group context="">
		<wea:item type="toolbar"><!-- 搜索 -->
			<input type="submit" class="e8_btn_submit" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" id="searchBtn" onclick="setSearchName(parent)"/>
			<!-- 重置 -->
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>" class="e8_btn_cancel" onclick="clearSearchName();resetSearch();resetMultiselect();resetDate();"/>
			<% if (templateid > 0) { %>
				<!-- 保存 -->
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>"" class="e8_btn_cancel" onclick="onSaveTempalte2();"/>
			<% } else { %>
				<!-- 存为模板 -->
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(18418,user.getLanguage())%>"" class="e8_btn_cancel" onclick="onSaveTempalte();"/>
			<% } %>
			<!-- 取消 -->
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
		</wea:item>
	</wea:group>
</wea:layout>
<%for(int i=0;i<iframeList.size();i++){%>
<iframe id="selectChange_<%=iframeList.get(i) %>" frameborder=0 scrolling=no src=""  style="display:none"></iframe>
<%} %>
<%for(int i=0;i<ldselectfieldid.size();i++){%>
<iframe id="selectChange_<%=ldselectfieldid.get(i) %>" frameborder=0 scrolling=no src=""  style="display:none"></iframe>
<%} %>
</form>
</div>
<div>
  <input id="formmodeFlag" name="formmodeFlag" type="hidden" value="1">
</div>
<!-- 显示查询结果 -->    
<div id="splitPageContiner">  
<input type="hidden" name="pageWidthUnit" id="pageWidthUnit" value="px"/>
<input type="hidden" name="pageWidth" id="pageWidth" value=""/> 
<input type="hidden" name="iscustom" id="iscustom" value="<%=iscustom %>"/> 
<input type="hidden" name="pageId" id="pageId" value="mode_customsearch:<%=customid %>" _showCol="false"/> 
<%
String tableString = "";
if(perpage <1) perpage=10;
String backfields = " t1.id,t1.formmodeid,t1.modedatacreater,t1.modedatacreatertype,t1.modedatacreatedate,t1.modedatacreatetime ";
//判断表单中是否有创建人、创建日期字段。（流程表）
if(isVirtualForm){
	RecordSet.executeSql("select * from "+VirtualFormHandler.getRealFromName(tablename)+" where 1=2",vdatasource);
}else{
	RecordSet.executeSql("select * from "+tablename+" where 1=2");	
}
String colfieldname[] =RecordSet.getColumnName();
if(!StringHelper.containsIgnoreCase(colfieldname, "modedatacreater")&&!StringHelper.containsIgnoreCase(colfieldname, "modedatacreatedate")){
	backfields = " t1.id ";
}
if(!"".equals(detailtable)){
	backfields+=","+detailtableAlias+".id as "+detailfieldAlias+"id";
}
if(isVirtualForm){	//虚拟表单
	backfields = " t1." + vprimarykey + " ";
}
//加上自定以字段
String showfield="";
//加入设置了列自定义过滤
String columnMakeSql = ""; String columnMakeSql1 = ""; String columnMakeSql2 = "";
List<Map<String,String>> user_col_list = ShowColUtil.getUserDefaultColList("mode_customsearch:"+customid, user);
RecordSet colrs = new RecordSet();
colrs.executeSql("select id,fieldname,detailtable from workflow_billfield where billid="+formID+" and (detailtable is null or detailtable ='' or detailtable ='"+detailtable+"')");
Map<String,Integer> _col_map = new HashMap<String,Integer>();
Map<Integer,String> col_map = new HashMap<Integer,String>();
while(colrs.next()){
	if(!"".equals(colrs.getString(3))){
		_col_map.put("d_"+colrs.getString(2),colrs.getInt(1));
		col_map.put(colrs.getInt(1),"d_"+colrs.getString(2));
	}else{
		_col_map.put(colrs.getString(2),colrs.getInt(1));
		col_map.put(colrs.getInt(1),colrs.getString(2));
	}
}
boolean is_user_column = false;
if(user_col_list!=null&&user_col_list.size()>0){
	is_user_column = true;
	col_map.clear();
	for(Map<String,String> user_col : user_col_list){
		String user_column_name = user_col.get("column");
		if(_col_map.containsKey(user_column_name)){
			col_map.put(_col_map.get(user_column_name), user_column_name);
		}else{
			if(user_column_name.equals("modedatacreater")){
				col_map.put(-2, user_column_name);
			}else if(user_column_name.equals("modedatacreatedate")){
				col_map.put(-1, user_column_name);
			}else if(user_column_name.equals("id")){
				col_map.put(-3, user_column_name);
			}
		}
	}
}
ActionMap.put("action","defaultStyleSql");
CustomSearchUtil.setMap(ActionMap);
sql=CustomSearchUtil.getSearchSql();
RecordSet.execute(sql);
int real_col_count = 0;
while (RecordSet.next()){
	int col_id = RecordSet.getInt("id");
	if(col_map.containsKey(col_id)||!is_user_column){
		real_col_count ++;
	}
	if (RecordSet.getInt("id")>0){
		String tempname=Util.null2String(RecordSet.getString("name"));
		String dbtype=Util.null2String(RecordSet.getString("dbtype"));
		String fieldAlias=tempname;
		String tableAlias=maintableAlias;
		int field_viewtype=RecordSet.getInt("viewtype");
		if(field_viewtype==1){
			tableAlias=detailtableAlias;
			fieldAlias=detailfieldAlias+tempname;
		}
		String showfield_tmp=","+showfield.toLowerCase()+",";
		String currfield_tmp=","+tableAlias+"."+tempname.toLowerCase()+",";
		String backfield_tmp=","+backfields.trim().toLowerCase()+",";
		if(showfield_tmp.indexOf(currfield_tmp)>-1||backfield_tmp.indexOf(currfield_tmp)>-1)continue;
		
		if(dbtype.toLowerCase().equals("text")){
			if(vdatasourceDBtype.equals("oracle")){
				showfield=showfield+","+"to_char("+tableAlias+"."+tempname+") as "+fieldAlias;
			}else{
				showfield=showfield+","+"convert(varchar(4000),"+tableAlias+"."+tempname+") as "+fieldAlias;
			}
		}else{
			if(field_viewtype==1){
				showfield=showfield+","+tableAlias+"."+tempname+" as "+fieldAlias;
			}else{
				showfield=showfield+","+tableAlias+"."+tempname;
			}
		}
	}
}
RecordSet.beforFirst();
backfields=backfields+showfield;


List<User> lsUser = ModeRightInfo.getAllUserCountList(user);
//未配置模块时重新解析权限
String rightsql = "";
if(!isVirtualForm){
	if(formmodeid.equals("")||formmodeid.equals("0")){//查询中没有设置模块
		String sqlStr1 = "select id,modename from modeinfo where formid="+formID+" order by id";
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
		ModeShareManager.setModeId(Util.getIntValue(formmodeid,0));
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
String fromSql = "";
if(isVirtualForm){
	fromSql = " from "+VirtualFormHandler.getRealFromName(tablename)+" t1 " ;
}else{
	fromSql = " from "+tablename+" t1 " ;
}

if(!"".equals(detailtable)){
	fromSql+=" left join "+detailtable+" "+detailtableAlias+" on t1.id="+detailtableAlias+"."+detailkeyfield+" ";
}

if(viewtype!=3&&!norightlist.equals("1")&&!isVirtualForm){//不是监控、无权限列表、不是虚拟表单
	fromSql  = fromSql+","+rightsql+" t2 " ;
    sqlwhere += " and t1.id = t2.sourceid ";
    
    if(isBatchEditPage){
		sqlwhere += " and t2.sharelevel>1 ";
	}
}

sqlwhere=CustomSearchUtil.getSqlWhere( sqlwhere, quickSql, searchconditiontype,javafileAddress,javafilename, user, defaultsql,
        quicksqlwhere, splitIndex, treesqlwhere, treesqlwhere1, groupby, enabled, modeid);
                                    
//检查是否设置列宽
double sumColWidth = 0;
int zerocount = 0;
String allstatfield = "";
String decimalFormat = "";
Map<String, Integer> countColumnsDbType = new HashMap<String, Integer>();
Map<String,Object> fieldColWidthMap = new LinkedHashMap<String,Object>();
RecordSet.beforFirst();
while(RecordSet.next()){
	int col_id = RecordSet.getInt("id");
	if(!col_map.containsKey(col_id)&&is_user_column){
		continue;
	}
	int fieldColWidth = (int)Util.getDoubleValue(RecordSet.getString("ColWidth"),0);
	fieldColWidthMap.put(col_id+"", fieldColWidth);
	sumColWidth += fieldColWidth;
	if(Util.getDoubleValue(RecordSet.getString("ColWidth"),0)==0){
		zerocount++;
	}
	
	if(Util.getIntValue(RecordSet.getString("isstat"),0)==1&&Util.getIntValue(RecordSet.getString("httype"))==1){
		String qfws=Util.null2String(RecordSet.getString("qfws"));
		String name=Util.null2String(RecordSet.getString("name"));
		int field_viewtype=RecordSet.getInt("viewtype");
		if(field_viewtype==1){
			name=detailfieldAlias+name;
		}
		allstatfield+=name+",";
		String dbtype = Util.null2String(RecordSet.getString("dbtype"));
		int temptype = Util.getIntValue(RecordSet.getString("type"));
		if(temptype==5){
			countColumnsDbType.put(name,1);
		}else{
			countColumnsDbType.put(name,0);
		}
		int digitsIndex = dbtype.indexOf(",");
		int decimaldigits=2;
	 	if(digitsIndex > -1){
	 		decimaldigits = Util.getIntValue(dbtype.substring(digitsIndex+1, dbtype.length()-1), 2);
	 		decimalFormat +="%."+decimaldigits+"f|";
	 	}else{
	 		if(!qfws.equals("0")){
	 			decimalFormat +="%."+qfws+"f|";
	 		}else{
		 		decimalFormat +="%.0f|";	 			
	 		}
	 	}
	}
}
if(isBatchEditPage){
	allstatfield = "";
	decimalFormat = "";
}

int allSumWidthFix = CustomSearchAnalyzeUtil.calculateColWidth(fieldColWidthMap);
String sqlprimarykey = "t1.id";
if(isVirtualForm){	//虚拟表单
	sqlprimarykey = "t1." + vprimarykey;
	orderby = CustomSearchService.getOrderSQL(customid);
	if("".equals(orderby)){
		orderby += "t1." + vprimarykey+" desc ";
	}else{
		orderby += ",t1." + vprimarykey+" desc ";
	}
} else {
	orderby = CustomSearchService.getOrderSQL(customid);
	if("".equals(orderby)){
		orderby += "t1.id"+" desc ";
	}else{
		orderby += ",t1.id"+" desc ";
	}
}
if(!"".equals(detailtable)){
	orderby+=","+detailfieldAlias+"id";
}
if (iscustom == 1) {
	perpage = Util.getIntValue(PageIdConst.getPageSize("mode_customsearch:"+customid ,user.getUID(), "formmode:pagenumber"),perpage);
}
tableString =" <table instanceid=\"workflowRequestListTable\" tabletype=\"checkbox\" pagesize=\""+perpage+"\" isFromFromMode=\"true\"  modeCustomid=\""+customid+"\">"+
              "	   <sql backfields=\""+backfields+"\" sumColumns=\""+allstatfield+"\" decimalFormat=\""+decimalFormat;
if(!countColumnsDbType.isEmpty()){
	tableString+="\" countColumnsDbType=\""+countColumnsDbType;
}
tableString+="\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\""+sqlprimarykey+"\" sqlsortway=\"Desc\" poolname=\""+vdatasource+"\" />";

rsm.executeSql("select * from mode_customSearchButton where objid="+customid+" and isshow=1 order by showorder asc");
//添加自定义按钮
String btonBodyStr = "";
boolean haveOperates = false;
if(rsm.getCounts()>0 && !isBatchEditPage){
	haveOperates = true;
	String operateString= "";
	operateString = "<operates>";
	String para_=customid+"+"+user.getUID()+"+"+modeid;
	operateString +=" <popedom  transmethod=\"weaver.formmode.search.FormModeTransMethod.getSearchResultOperation\" otherpara=\""+para_+"\" ></popedom> ";
	int index = 0;
	while(rsm.next()){
		index++;
		String buttonName = Util.null2String(rsm.getString("buttonname"));
		String hreftype = Util.null2String(rsm.getString("hreftype"));
		String hreftargetParid = Util.null2String(rsm.getString("hreftargetParid"));
		String hreftargetParval = Util.null2String(rsm.getString("hreftargetParval"));
		String hreftarget = Util.null2String(rsm.getString("hreftarget"));
		String jsmethodname = Util.null2String(rsm.getString("jsmethodname"));
		String jsParameter = Util.null2String(rsm.getString("jsParameter"));
		String jsmethodbody = Util.null2String(rsm.getString("jsmethodbody"));
		if("1".equals(hreftype)){
			btonBodyStr += jsmethodbody;
			String operate = "     <operate href=\""+jsmethodname+"\" text=\""+buttonName+"\" ";
			if(!StringHelper.isEmpty(jsParameter)){
				StringBuffer fieldBuf = new StringBuffer();
				ArrayList<String> fieldList = Util.TokenizerString(jsParameter, ",");
				for(int fieldIdx=0; fieldIdx<fieldList.size(); fieldIdx++){
					if(!StringHelper.isEmpty(fieldList.get(fieldIdx))){
						fieldBuf.append("column:"+fieldList.get(fieldIdx)+"+");
					}
				}
				if(!StringHelper.isEmpty(fieldBuf.toString())){
					jsParameter = fieldBuf.substring(0,fieldBuf.length()-1);
				}
				operate += "otherpara=\""+jsParameter+"\" ";
			}
			operate +=" index=\""+index+"\"/>";
			operateString +=operate;
		}else if("2".equals(hreftype)){
			String _blank = "_blank";
			if("2".equals(Util.null2String(rsm.getString("hreftargetOpenWay"))))
				_blank = "_fullwindow";
			hreftarget=hreftarget.replaceAll("&","&amp;");  //避免&符号在xml解析是报错
			operateString +="     <operate href=\""+hreftarget+"\" isalwaysshow=\"true\" text=\""+Util.toHtmlForSplitPage(buttonName)+"\" linkkey=\""+hreftargetParid+"\" linkvaluecolumn=\""+hreftargetParval+"\" target=\""+_blank+"\" index=\""+index+"\"/>";
		}
	}
	operateString +="</operates>";
	tableString+=operateString;
}
	
tableString+="			<head>";

RecordSet.beforFirst();

AbstractPluginElement pluginElement = null;
StringBuffer pluginJS = new StringBuffer();
StringBuffer pluginLoadedJS = new StringBuffer();
boolean hasSetMaintableEditable = false;
boolean hasSetDetailtableEditable = false;
while (RecordSet.next()) {
	String fieldid = Util.null2String(RecordSet.getString("id"));
	int temocolwidth = Util.getIntValue(Util.null2String(fieldColWidthMap.get(fieldid)), 0);
	String hideAttribute = "";
	int col_id = Util.getIntValue(fieldid, 0);
	if(!col_map.containsKey(col_id)&&is_user_column){
		temocolwidth = 1;
		hideAttribute = "display=\"false\"";
	}
	if(RecordSet.getString("id").equals("-1")){
		String orderkey = "orderkey=\"t1.modedatacreatedate,t1.modedatacreatetime\"";
		String isorder = RecordSet.getString("isorder");
		String showmethod = Util.null2o(RecordSet.getString("showmethod"));
		String para3="column:modedatacreatetime+"+customid+"+"+showmethod+"+column:"+(isVirtualForm?vprimarykey:"id")+"+"+formID;
		if(!"1".equals(isorder)){
			orderkey = "";
		}
		tableString+="				<col width=\""+temocolwidth+"%\" "+hideAttribute+" text=\""+Util.toHtmlForSplitPage(SystemEnv.getHtmlLabelName(722,user.getLanguage()))+"\" column=\"modedatacreatedate\" "+orderkey+"  otherpara=\""+para3+"\" transmethod=\"weaver.formmode.search.FormModeTransMethod.getSearchResultCreateTime\" />";
	}else if(RecordSet.getString("id").equals("-2")){
		String orderkey = "orderkey=\"t1.modedatacreater\"";
		String isorder = RecordSet.getString("isorder");
		if(!"1".equals(isorder)){
			orderkey = "";
		}
		tableString+="				<col width=\""+temocolwidth+"%\" "+hideAttribute+" text=\""+Util.toHtmlForSplitPage(SystemEnv.getHtmlLabelName(882,user.getLanguage()))+"\" column=\"modedatacreater\" "+orderkey+"  otherpara=\"column:modedatacreatertype\" transmethod=\"weaver.formmode.search.FormModeTransMethod.getSearchResultName\" />";
	}else if(RecordSet.getString("id").equals("-3")){
		String orderkey = "orderkey=\"t1.id\"";
		String isorder = RecordSet.getString("isorder");
		if(!"1".equals(isorder)){
			orderkey = "";
		}
		tableString+="				<col width=\""+temocolwidth+"%\" "+hideAttribute+" text=\""+Util.toHtmlForSplitPage(SystemEnv.getHtmlLabelName(81287,user.getLanguage()))+"\" column=\"id\" "+orderkey+" otherpara=\"column:dataid\" transmethod=\"weaver.formmode.search.FormModeTransMethod.getDataId\" />";
	}else{
		String name = RecordSet.getString("name");
		String label = RecordSet.getString("label");
		String htmltype = RecordSet.getString("httype");
		String type = RecordSet.getString("type");
		String id = RecordSet.getString("id");
		String dbtype=RecordSet.getString("dbtype");
		String istitle = RecordSet.getString("istitle");
		String showmethod = Util.null2o(RecordSet.getString("showmethod"));
		String isorder = RecordSet.getString("isorder");
		String ismaplocation = Util.getIntValue(RecordSet.getString("ismaplocation"),0)+"";
		int field_viewtype=RecordSet.getInt("viewtype");
		String editable = Util.null2String(RecordSet.getString("editable"),"0");
		if("1".equals(editable)){
			hasSetMaintableEditable = true;
			if(field_viewtype==1){
				hasSetDetailtableEditable = true;
			}
		}
		String fieldAlias=name;
		String tableAlias=maintableAlias;
		String orderkey="orderkey=\""+tableAlias+"."+name+"\"";
		if(field_viewtype==1){
			tableAlias=detailtableAlias;
			fieldAlias=detailfieldAlias+name;
			orderkey="orderkey=\""+fieldAlias+"\"";
		}
		if(!"1".equals(isorder)){
			orderkey = "";
		}
		
		if(isVirtualForm){
		    if(formmodeid.equals("0")){
		    	formmodeid = "virtual";
		    }
		}
		String para3="";
		if(viewtype==3){
	        para3="column:"+(isVirtualForm?vprimarykey:"id")+"+"+id+"+"+htmltype+"+"+type+"+"+user.getLanguage()+"+"+isbill+"+"+dbtype+"+"+istitle+"+"+formmodeid+"+"+formID+"+"+viewtype+"+"+ismaplocation+"+"+opentype+"+"+customid+"+fromsearchlist"+"+"+showmethod+(detailtable.equals("")?"":("'+column:d_id+"+detailtable+"'"));
		}else{
	        para3="column:"+(isVirtualForm?vprimarykey:"id")+"+"+id+"+"+htmltype+"+"+type+"+"+user.getLanguage()+"+"+isbill+"+"+dbtype+"+"+istitle+"+"+formmodeid+"+"+formID+"+"+viewtype+"+"+ismaplocation+"+"+opentype+"+"+customid+"+fromsearchlist"+"+"+showmethod+"+"+user.getUID()+"+"+enabled+(detailtable.equals("")?"":("'+column:d_id+"+detailtable+"'"));
		}
		label = SystemEnv.getHtmlLabelName(Util.getIntValue(label),user.getLanguage());
		label = Util.null2String(label);
		String editPlugin = "";
		String transmethod = "transmethod=\"weaver.formmode.search.FormModeTransMethod.getOthers\"";
		if("1".equals(editable) && isBatchEditPage){
			String elementClassName = PluginElementClassName.getElementClassName(htmltype,type);
			pluginElement = (AbstractPluginElement)Class.forName(elementClassName).newInstance();
			String pluginName = pluginElement.getEditPluginName(Util.getIntValue(id));
			editPlugin = "editPlugin=\""+pluginName+"\"";
			
			JSONObject pluginJSObject = pluginElement.getEditPluginJS(Util.getIntValue(id), name, Util.getIntValue(htmltype), Util.getIntValue(type), dbtype, user);
			pluginJS.append(pluginJSObject.get("pluginJS"));
			pluginLoadedJS.append(pluginJSObject.get("pluginLoadedJS"));
			String pluginTransmethod = Util.null2String(pluginElement.getTransmethod());
			if(!"".equals(pluginTransmethod)){
				transmethod = "transmethod=\""+pluginTransmethod+"\"";
			}else{
				transmethod = "";
			}
			JSONObject paraObject = new JSONObject();
			paraObject.put("fieldid",id);
			paraObject.put("fieldhtmltype",htmltype);
			paraObject.put("type",type);
			if(rs.getDBType().equalsIgnoreCase("oracle") && dbtype !=null && dbtype.startsWith("number(")){//浮点类型针对oracle特殊处理
				transmethod = "transmethod=\"weaver.formmode.search.FormModeTransMethod.getOthers\"";
			} else {
				para3 = "{mainid:+column:id+,fieldid:"+id+",fieldhtmltype:"+htmltype+",fieldtype:"+type+",fielddbtype:'"+dbtype+"',languageid:"+user.getLanguage()+"}";	
			}
		}
		tableString+="			    <col "+editPlugin+" width=\""+temocolwidth+"%\" "+hideAttribute+" text=\""+Util.toHtmlForSplitPage(label)+"\"  column=\""+fieldAlias+"\"  otherpara=\""+para3+"\" "+orderkey+" "+transmethod+" />";
	}
}
if(hasSetMaintableEditable && isBatchEditPage){
	String elementClassName = PluginElementClassName.getPrimaryKeyElementClassName();
	pluginElement = (AbstractPluginElement)Class.forName(elementClassName).newInstance();
	String primaryKeyName = isVirtualForm?vprimarykey:"id";
	String primaryKeyPluginName = pluginElement.getEditPluginName(primaryKeyName);
	JSONObject pluginJSObject = pluginElement.getEditPluginJS(0, primaryKeyName, 0, 0, "", user);
	pluginJS.append(pluginJSObject.getString("pluginJS"));
	tableString+="<col hide=\"true\" editPlugin=\""+primaryKeyPluginName+"\" text=\"\" column=\""+primaryKeyName+"\"  />";
	if(hasSetDetailtableEditable){
		primaryKeyName = detailfieldAlias+"id";
		primaryKeyPluginName = pluginElement.getEditPluginName(primaryKeyName);
		pluginJSObject = pluginElement.getEditPluginJS(0, primaryKeyName, 0, 0, "", user);
		pluginJS.append(pluginJSObject.getString("pluginJS"));
		tableString+="<col hide=\"true\" editPlugin=\""+primaryKeyPluginName+"\" text=\"\" column=\""+primaryKeyName+"\"  />";
	}
}
tableString+="			</head>"+ "</table>";
%>
<form id="batcheditForm" name="batcheditForm" method="post" action="/formmode/setup/customSearchActionForFront.jsp" target="batcheditIframe">
<input type="hidden" id="action" name="action" value="batchEdit" />
<input type="hidden" id="batcheditCustomid" name="batcheditCustomid" value="<%=customid%>" />
<input type="hidden" id="tableMax" name="tableMax" value="0" />
<textarea id="modifiedRows" name="modifiedRows" style="display:none;"></textarea>
<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />
</form>
<iframe id="batcheditIframe" name="batcheditIframe" style="display:none;"></iframe>
</div> 
<!-- 显示查询结果 -->

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>


<script language="javascript" src="/js/browser/WorkFlowBrowser_wev8.js"></script>
<script language=javascript src="/wui/common/jquery/plugin/Listener_wev8.js"></script>
<script language=javascript src="/formmode/js/jquery/aop/jquery.aop.min_wev8.js"></script>
<script>
chromeOnPropListener = null;
//加载监听器
function loadListener(){
	if(chromeOnPropListener==null){
		chromeOnPropListener = new Listener();
	}else{
		chromeOnPropListener.stop();
	}
	chromeOnPropListener.load("[_listener][_listener!='']");
	chromeOnPropListener.start(500,"_listener");
}
</script>
<script>
var fromgroup = <%="1".equals(fromgroup)%>;
var hasSetMaintableEditable = <%=hasSetMaintableEditable%>;
var hasSetDetailtableEditable = <%=hasSetDetailtableEditable%>;
<%=pluginJS%>
function afterDoWhenLoaded(){
	<%=pluginLoadedJS%>
	<%if(isBatchEditPage){%>
		loadListener();
		customSearchOperate.changeEmptyTRMessage();
	<%}%>
}
</script>
<script language=javascript src="/formmode/js/search_wev8.js?v=1"></script>
<script language="javaScript">

jQuery(document).ready(function(){
	resetSplitPageWidth();
	<%=initselectfield%>;
	<%
	String[] multiselectidArray = multiselectid.split(",");
	for(int m=0;m<multiselectidArray.length;m++){
		if(Util.null2String(multiselectidArray[m]).trim().equals(""))
			continue;
	%>
		jQuery("#<%=multiselectidArray[m]%>").multiselect({
			multiple: true,
			noneSelectedText: '',
			checkAllText: "<%=SystemEnv.getHtmlLabelName(556,user.getLanguage())%>",
	        uncheckAllText: "<%=SystemEnv.getHtmlLabelName(84355,user.getLanguage())%>",
	        selectedList:100,
	        close: function(){
				var tmpmsv = jQuery("#<%=multiselectidArray[m]%>").multiselect("getChecked").map(function(){return this.value;}).get();
	  			jQuery("#multiselectValue_<%=multiselectidArray[m]%>").val(tmpmsv.join(","));
	  			var selectObj = jQuery("#<%=multiselectidArray[m]%>");
				var onchangeStr = selectObj.attr('onchange');
				if(onchangeStr&&onchangeStr!=""){
					var selObj = selectObj.get(0);
					if (selObj.fireEvent){
						selObj.fireEvent('onchange');
					}else{
						selObj.onchange();
					}
				}
			}
			
	  	});
	  	jQuery("#<%=multiselectidArray[m]%>").val(jQuery("#multiselectValue_<%=multiselectidArray[m]%>").val().split(","));
	  	jQuery("#<%=multiselectidArray[m]%>").multiselect("refresh");
	<%}%>
	jQuery("#rightMenu").css("position","fixed");
	<%if(isBatchEditPage){%>
		jQuery.aop.around( {target: XTableHandler, method: "jumpTo"},customSearchOperate.jumpToAroundFun);
		jQuery.aop.around( {target: XTableHandler, method: "nextPage"},customSearchOperate.jumpToAroundFun);
		jQuery.aop.around( {target: XTableHandler, method: "prePage"},customSearchOperate.jumpToAroundFun);
		jQuery.aop.around( {target: XTableHandler, method: "goPage"},customSearchOperate.jumpToAroundFun);
	<%}%>
});



function resetMultiselect(){
    <%
	for(int m=0;m<multiselectidArray.length;m++){
		if(Util.null2String(multiselectidArray[m]).trim().equals(""))
			continue;
	%>
	  jQuery("#<%=multiselectidArray[m]%>").multiselect("refresh");
	<%}%>
}



//多选下拉框赋值
function multselectSetValue(){
	var tmpmsv="";
    <%
	for(int m=0;m<multiselectidArray.length;m++){
		if(Util.null2String(multiselectidArray[m]).trim().equals(""))
			continue;
	%>
	  tmpmsv = jQuery("#<%=multiselectidArray[m]%>").multiselect("getChecked").map(function(){return this.value;}).get();
	  
	  jQuery("#multiselectValue_<%=multiselectidArray[m]%>").val(tmpmsv.join(","));
	<%}%>

}

<%
Iterator it = urlMap.entrySet().iterator();
while (it.hasNext()) {
	Entry entry = (Entry) it.next();
	String detailid = Util.null2String((String)entry.getKey());
	String hreftarget = Util.null2String((String)entry.getValue());
	hreftarget = hreftarget.replace("\"","\\\"");
	hreftarget = hreftarget.replaceAll("\r\n","");
	out.println("var url_id_"+detailid + " = \"" +hreftarget+"\";");
}
%>

//初始化数据，用在search_wev8.js中

var dataArray = new Array();
dataArray["20149"] = "<%=SystemEnv.getHtmlLabelName(20149,user.getLanguage())%>";
dataArray["32535"] = "<%=SystemEnv.getHtmlLabelName(32535,user.getLanguage())%>";
dataArray["32530"] = "<%=SystemEnv.getHtmlLabelName(32530,user.getLanguage())%>";
dataArray["7"] = "<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>";
dataArray["sumColWidth"] = <%=sumColWidth%>;
dataArray["allSumWidthFix"] = <%=allSumWidthFix%>;
dataArray["mainid"] = <%=mainid%>;
dataArray["customTreeDataId"] = "<%=customTreeDataId%>";
dataArray["18214"] = "<%=SystemEnv.getHtmlLabelName(18214,user.getLanguage())%>";
dataArray["tempquerystring"] = "<%=tempquerystring%>";
dataArray["16388"] = "<%=SystemEnv.getHtmlLabelName(16388 ,user.getLanguage()) %>";
dataArray["127295"] = "<%=SystemEnv.getHtmlLabelName(127295 ,user.getLanguage()) %>";
dataArray["searchKeyNum"] = <%=searchKeyNum %>;
dataArray["isShowQueryCondition"] = <%=isShowQueryCondition %>;
dataArray["parfield"] = "<%=parfield %>";
dataArray["multiselectid"] = "<%=multiselectid %>";


<%
int isUseMap = 1;
String sqlquery = "select * from mode_CustomDspField where ismaplocation=1 and isshow=1 and customid="+customid;
rs.executeSql(sqlquery);
if(!rs.next()){
	isUseMap = 0;
}
%>
dataArray["isUseMap"] = <%=isUseMap %>;


//批量生成二维码
function batchCreateQRCode() {
	<%
	int qrIsuse = 0;//二维码是否启用
	RecordSet.executeSql("select isuse from ModeQRCode where modeid="+modeid);
	if (RecordSet.next()) {
		qrIsuse = RecordSet.getInt("isuse");
	}
	%>
	if(<%=qrIsuse==0%>) {
		alert("<%=SystemEnv.getHtmlLabelName(125710 ,user.getLanguage()) %>"); //二维码功能尚未开启，请在后台开启二维码功能
   	 	return;
	}
    var billids = _xtable_CheckedCheckboxId();
    if(billids==""){
    	alert('<%=SystemEnv.getHtmlLabelName(20149,user.getLanguage())%>');///请至少选择一条记录。
        return;
    }
	window.open("/formmode/view/QRCodeViewIframe.jsp?modeId=<%=modeid%>&customid=<%=customid%>&formId=<%=formID%>&billid="+billids);
}

//批量生成条形码
function batchCreateBARCode() {
	<%
	int barIsused = 0;//条形码是否启用
	RecordSet.executeSql("select isused from mode_barcode where modeid="+modeid);
	if (RecordSet.next()) {
		barIsused = Util.getIntValue(RecordSet.getInt("isused")+"",-1);
	}
	%>
	if(<%=barIsused==-1%> || <%=barIsused==0%>) {
		alert("<%=SystemEnv.getHtmlLabelName(127216 ,user.getLanguage()) %>"); //条形码功能尚未开启，请在后台开启条形码功能
   	 	return;
	}
    var billids = _xtable_CheckedCheckboxId();
    if(billids==""){
    	alert('<%=SystemEnv.getHtmlLabelName(20149,user.getLanguage())%>');///请至少选择一条记录。
        return;
    }
	window.open("/formmode/view/BARCodeViewIframe.jsp?modeId=<%=modeid%>&customId=<%=customid%>&formId=<%=formID%>&billId="+billids);
}



function Add(){
	<%
	String treeFieldStr = "";
	if(!treenodeid.equals("")){
		String treeFieldSql = "select d.id,d.fieldname from mode_customtreedetail a ,mode_customsearch b,modeinfo c,workflow_billfield d where a.id='"+treenodeid+"' and a.hreftype=3 and a.hrefid=b.id and b.modeid=c.id and c.formid=d.billid and UPPER(a.hrefrelatefield)=UPPER(d.fieldname) and (d.detailtable is null or d.detailtable='')";
		RecordSet.executeSql(treeFieldSql);
		if(RecordSet.next()){
			String fieldid = RecordSet.getString("id");
			if(!StringHelper.isEmpty(treeconvalue)){
				treeFieldStr = "&field"+fieldid+"="+treeconvalue;
			}
		}
	}%>
	var url = "/formmode/view/AddFormMode.jsp?customTreeDataId=<%=customTreeDataId%>&mainid=<%=mainid%>&modeId=<%=modeid%>&formId=<%=formID%>&type=1<%=createurl+treeFieldStr%>";
	window.open(url);
}

<%=btonBodyStr%>


<%--
weaverTable.prototype.loadOver = function(){
	var message_table_Div  = document.getElementById("message_table_Div");	 	
	//message_table_Div.style.display="none";	
	jQuery(message_table_Div).css("display", "none");	
	if(jQuery(".mapimage").length>0){
		pingmap();
	}
}
--%>

</script>
<%if(isUseMap==1){%>
	<script type="text/javascript" src="http://api.map.baidu.com/api?v=<%=Prop.getPropValue("map", "baidumapversion") %>&ak=<%=Prop.getPropValue("map", "baidumapak")%>"></script>
<%}%>

</body>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>

<!-- browser 相关 -->
<script type="text/javascript" src="/formmode/js/modebrow_wev8.js?v=1"></script>
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
</html>
