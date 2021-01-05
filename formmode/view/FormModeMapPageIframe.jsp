<%@page import="weaver.formmode.customjavacode.CustomJavaCodeRun"%>
<%@page import="weaver.formmode.service.CommonConstant"%>
<%@page import="weaver.servicefiles.DataSourceXML"%>
<%@page import="weaver.formmode.virtualform.VirtualFormHandler"%>
<%@page import="weaver.workflow.workflow.WorkflowBillComInfo"%>
<%@page import="weaver.workflow.form.FormManager"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.file.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
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
<html>
<head>
<title></title>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/weaver_wev8.js"></script>
<script type="text/javascript" src="/wui/common/jquery/jquery.min_wev8.js"></script>
<script type="text/javascript" src='/formmode/js/ping_wev8.js'></script>
<script type="text/javascript" src="http://api.map.baidu.com/api?v=<%=Prop.getPropValue("map", "baidumapversion") %>&ak=<%=Prop.getPropValue("map", "baidumapak")%>"></script>
<style type="text/css">
.searchText_tip{
	position: absolute;
	top: 7px;
	left: 15px;
	color: #BBB;
	font-style: italic;
}
.searchBtn{
	background: url("/formmode/images/btnSearch.png") no-repeat;
	width:16px;
	height: 16px;
	position: absolute;
	top: 11px;
	left: 178px;
	cursor:pointer;
}
.searchText{
	height: 30px;
	width: 300px;
	padding-right: 40px;
	border: 1px solid #BBB;
	background-position: 162px center;
}
</style>
</head>
<body>
<%
String titlename ="";
String customid=Util.null2String(request.getParameter("customid"));
int viewtype=Util.getIntValue(request.getParameter("viewtype"),0);
String treesqlwhere = Util.null2String(request.getParameter("treesqlwhere"));
String treesqlwhere1 = Util.null2String(request.getParameter("treesqlwhere1"));
int templateid = Util.getIntValue(request.getParameter("templateid"),0);
String searchMethod=Util.null2String(request.getParameter("searchMethod"),"0");//查询方式，0-搜索查询，1-模板查询
int mainid = Util.getIntValue(request.getParameter("mainid"),0);
String datasqlwhere = Util.null2String(request.getParameter("datasqlwhere"));
datasqlwhere = xssUtil.get(datasqlwhere);
//============================================查询列表基础数据====================================
boolean issimple= true;
int isresearch=1;
String isbill="1";
String formID="0";
String customname="";
String tablename="";
String modeid = "0";
String disQuickSearch = "";
String defaultsql = "";
String norightlist = "";
int iscustom = 0;
int opentype = 0;

String searchconditiontype = "1";
String javafilename = "";
int perpage=10;
String detailtable="";
String detailkeyfield="";
String maintableAlias="t1";
String detailtableAlias="d1";
String detailfieldAlias="d_";

rs.execute("select a.*,b.tablename,b.detailkeyfield from mode_customsearch a left join workflow_bill b on a.formid=b.id where a.id="+customid);
if(rs.next()){
    formID=Util.null2String(rs.getString("formid"));
    customname=Util.null2String(rs.getString("customname"));
    titlename = SystemEnv.getHtmlLabelName(197,user.getLanguage())+":"+customname;
    modeid=""+Util.getIntValue(rs.getString("modeid"),0);
    
    disQuickSearch = "" + Util.toScreenToEdit(rs.getString("disQuickSearch"),user.getLanguage());
    defaultsql = "" + Util.toScreenToEdit(rs.getString("defaultsql"),user.getLanguage()).trim();
    defaultsql = FormModeTransMethod.getDefaultSql(user,"","",defaultsql);
    norightlist = Util.null2String(rs.getString("norightlist"));
	iscustom = Util.getIntValue(rs.getString("iscustom"),1);
    opentype = Util.getIntValue(rs.getString("opentype"),0);//0 弹出，1当前窗口
    
    searchconditiontype = Util.null2String(rs.getString("searchconditiontype"));
	searchconditiontype = searchconditiontype.equals("") ? "1" : searchconditiontype;
	javafilename = Util.null2String(rs.getString("javafilename"));
	perpage = Util.getIntValue(Util.null2String(rs.getString("pagenumber")),10);
	detailtable=Util.null2String(rs.getString("detailtable"));
	tablename = rs.getString("tablename");
	detailkeyfield=Util.null2String(rs.getString("detailkeyfield"));
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
	//自定义页面查看权限
	rs.executeSql("select * from mode_searchPageshareinfo where righttype=1 and pageid = " + customid);
	if(rs.next()){  
		FormModeRightInfo.setUser(user);
		isRight = FormModeRightInfo.checkUserRight(Util.getIntValue(customid),1);
	}else{  //没有设置任何查看权限数据，则认为有权限查看
		isRight = true;
	}
}

if(!isRight){
	//response.sendRedirect("/notice/noright.jsp");
	out.println("<script>window.location.href='/notice/noright.jsp';</script>");
	return;
}
String formmodeid=modeid;
List<User> lsUser = ModeRightInfo.getAllUserCountList(user);
//未配置模块时重新解析权限
String rightsql = "";
if(!isVirtualForm){
	if(formmodeid.equals("")||formmodeid.equals("0")){//查询中没有设置模块
		String sqlStr1 = "select id,modename from modeinfo where formid="+formmodeid+" order by id";
		rs.executeSql(sqlStr1);
		while(rs.next()){
			String mid = rs.getString("id");
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
String sqlwhere="";
if(viewtype!=3&&!norightlist.equals("1")&&!isVirtualForm){//不是监控、无权限列表、不是虚拟表单
	fromSql  = fromSql+","+rightsql+" t2 " ;
    sqlwhere += " and t1.id = t2.sourceid ";
}


String sqlCondition = "";
if(searchconditiontype.equals("2")){	//java file
	if(!javafilename.equals("")){
		Map<String, String> sourceCodePackageNameMap = CommonConstant.SOURCECODE_PACKAGENAME_MAP;
		String sourceCodePackageName = sourceCodePackageNameMap.get("2");
		String classFullName = sourceCodePackageName + "." + javafilename;
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("user", user);
		
		Object result = CustomJavaCodeRun.run(classFullName, param);
		sqlCondition = Util.null2String(result);
	}
}else{
	sqlCondition = defaultsql;
}
if(!sqlCondition.equals("")){//默认搜索
	if(sqlwhere.equals("")){
		sqlwhere = sqlCondition;
	}else{
		sqlwhere += " and "+sqlCondition;
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


if(splitIndex==-1){//未把treesqlwhere转换
	if(!treesqlwhere.equals("")){//来自树形关联字段
		int index1 = treesqlwhere.indexOf("=");
		if(index1!=-1){
			String val = treesqlwhere.substring(index1+1);
			val = "'"+val+"'";
			treesqlwhere = treesqlwhere.substring(0,index1);
			treesqlwhere = " t1."+treesqlwhere+" = "+val;
		}
		if(sqlwhere.equals("")){
			sqlwhere = "" + treesqlwhere;
		}else{
			sqlwhere += " and "+treesqlwhere+" ";
		}
	}
}

if(!treesqlwhere1.equals("")){
	if(sqlwhere.equals("")){
		sqlwhere = " t1." + treesqlwhere1;
	}else{
		sqlwhere += " and t1."+treesqlwhere1+" ";
	}
}

String fieldsql="select b.id,b.fieldname,b.detailtable from mode_CustomDspField f,workflow_billfield b where f.fieldid=b.id and f.customid="
			+customid+" and f.isshow=1 and f.ismaplocation=1";
rs.executeSql(fieldsql);
String fieldback="";
int mapfieldcount=0;
while(rs.next()){
	mapfieldcount++;
	String fieldname= Util.null2String(rs.getString("fieldname"));
	String id= Util.null2String(rs.getString("id"));
	String tdetailtable= Util.null2String(rs.getString("detailtable"));
	if(tdetailtable.equals("")){
		fieldback+=",t1."+fieldname;
	}else{
		fieldback+=","+detailtableAlias+"."+fieldname+" as "+detailfieldAlias+fieldname;
	}
}
if(fieldback.length()>0){
	fieldback = fieldback.substring(1);
}
String sql="";
if(sqlwhere.trim().startsWith("and")){
	sql="select "+fieldback+" "+fromSql+" where 1=1 "+sqlwhere;
}else{
	sql="select "+fieldback+" "+fromSql+" where "+sqlwhere;
}

if(!vdatasource.equals("")){
	rs.execute(sql, vdatasource);
}else{
	rs.execute(sql);
}


 %>
<div style="width:100%;height:100%;border:1px solid gray" id="container"></div>
</body>
</html>
<script type="text/javascript">
var addressinfo="";
var map = new BMap.Map("container",{enableMapClick:false});//初始化地图                    
map.addControl(new BMap.NavigationControl());  //初始化地图控件              
map.addControl(new BMap.ScaleControl());                   
map.addControl(new BMap.OverviewMapControl());              
var point=new BMap.Point(116.404, 39.915);
map.centerAndZoom(point, 6);
var size = new BMap.Size(60, 20);
map.addControl(new BMap.CityListControl({
    anchor: BMAP_ANCHOR_TOP_LEFT,
    offset: size,
}));
map.enableScrollWheelZoom();//启动鼠标滚轮缩放地图
var index=0;
var myGeo = new BMap.Geocoder();
<%
String adds="";
while(rs.next()){
	for(int i=1;i<=mapfieldcount;i++){ 
		String addr = Util.null2String(rs.getString(i)).trim();
		
		if(!addr.equals("")){
			adds+=",\""+addr+"\"";
		}
	}
}
if(adds.length()>0){
	adds = adds.substring(1);
}
%>
var adds = [<%out.print(adds);%>];
bdGEO();
function bdGEO(){
	var add = adds[index];
	geocodeSearch(add);
	index++;
}
function geocodeSearch(add){
var index1 = index;
	if(index < adds.length){
		setTimeout(window.bdGEO,50);
	} 
	myGeo.getPoint(add, function(point){
		if (point) {
			var address = new BMap.Point(point.lng, point.lat);
			addMarker(address,index1);
		}
	}, "");
}
// 编写自定义函数,创建标注
function addMarker(point,index1){
	var marker = new BMap.Marker(point);
	marker.setZIndex(index1);
	map.addOverlay(marker);
	marker.addEventListener("click", function(){  
		var sContent =adds[marker.zIndex];
		var infoWindow = new BMap.InfoWindow(sContent);  // 创建信息窗口对象
	   	this.openInfoWindow(infoWindow);
	})
}
pingmap();
var ispingmap = 1;//0没有ping -1 ping不通   1 ping通
function pingmap(){
  	var p = new Ping();
  	var pingnum = 0;
	p.ping("http://map.baidu.com", function(data) {
        pingnum = data;
        if(pingnum>0){
	     	if(pingnum>1000){
	     		Dialog.alert("无法链接到互联网!<br/>1.请检查网线是否接好<br/>2.请检查网络是否可以链接互联网");
	     	}else{
	     		
	     	}
	    }
     },1500);
}
</script>