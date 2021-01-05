<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="com.weaver.formmodel.util.StringHelper"%>
<%@ page import="weaver.servicefiles.DataSourceXML"%>
<%@ page import="net.sf.json.JSONArray"%>
<%@ page import="weaver.general.SplitPageUtil"%>
<%@ page import="java.net.URLDecoder"%>
<%@ page import="weaver.conn.RecordSet"%>
<%@ page import="weaver.systeminfo.SystemEnv"%>
<%@ page import="weaver.hrm.User"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.formmode.virtualform.VirtualFormHandler"%>
<%@ page import="weaver.formmode.service.CommonConstant"%>
<%@ page import="weaver.formmode.customjavacode.CustomJavaCodeRun"%>
<%@ page import="weaver.formmode.service.BrowserInfoService"%>
<%@ page import="weaver.hrm.HrmUserVarify"%>
<%@ page import="weaver.general.SplitPageParaBean"%>
<%@ page import="net.sf.json.JSONObject"%>
<%@ page import="weaver.general.StaticObj" %>
<%@ page import="weaver.interfaces.workflow.browser.Browser" %>
<%@ page import="weaver.interfaces.workflow.browser.BrowserBean" %>
<%@page import="weaver.formmode.tree.CustomTreeData"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rsm" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="FormModeTransMethod" class="weaver.formmode.search.FormModeTransMethod" scope="page"/>
<jsp:useBean id="ModeShareManager" class="weaver.formmode.view.ModeShareManager" scope="page" />
<jsp:useBean id="ModeRightInfo" class="weaver.formmode.setup.ModeRightInfo" scope="page" />

<%
request.setCharacterEncoding("UTF-8");
User user = HrmUserVarify.getUser(request,response);

String treeid = Util.null2String(request.getParameter("treeid"));
String src = Util.null2String(request.getParameter("src"));
String browsertype = Util.null2String(request.getParameter("browsertype"));
String customid=Util.null2String(request.getParameter("customid"));
//链接地址中sqlwhere
String sqlwhereparam=Util.null2String(request.getParameter("sqlwhere"));
String check_per = Util.null2String(request.getParameter("systemIds"));
int perpage = Util.getIntValue(request.getParameter("pageSize") , 10) ;
int pagenum = Util.getIntValue(request.getParameter("currentPage") , 1) ;
if(perpage<=1){
	perpage = 10;
}


//============================================browser框基础数据====================================
String backfields = "  a.id,a.showname,a.nodename,a.nodeid ";


//============================================虚拟表基础数据====================================
String vdatasource = "";	//虚拟表单数据源
String vprimarykey = "";	//虚拟表单主键列名称
String vdatasourceDBtype = "";	//数据库类型
Map<String, Object> vFormInfo = new HashMap<String, Object>();




//============================================需要显示的字段====================================
Map<String,Object> showfieldMap=new LinkedHashMap<String,Object>();
String showname = Util.null2String(request.getParameter("showname"));
String sql = "select * from mode_customtreedetail where mainid="+treeid+" order by showorder";
rs.executeSql(sql);
List<Map<String,String>> treeNodeList = new ArrayList<Map<String,String>>();
CustomTreeData customTreeData = new CustomTreeData();

String dbtypeStr = "";
RecordSet rs1 = new RecordSet();

//先计算数据源
while(rs.next()){
	  String id = rs.getString("id");
	  String tablename = rs.getString("tablename");
	  String vdatasourceTemp = customTreeData.getVdatasourceByNodeId(id);
	  if(vdatasourceTemp.equals("")){
	  	  dbtypeStr = rs1.getDBType();
	  }else{
		  vdatasource = vdatasourceTemp;
		  dbtypeStr = rs1.getDBTypeByPoolName(vdatasource);
		  break;
	  }
}

String connStr = "";
if(dbtypeStr.equalsIgnoreCase("sqlserver")){
	  connStr = "+";
}else{
	  connStr = "||";
}

String sqls = "";
rs.beforFirst();
while(rs.next()){
	  String tablekey = rs.getString("tablekey");
	  String showfield = rs.getString("showfield");
	  String tablename = rs.getString("tablename");
	  String id = rs.getString("id");
	  String nodename = rs.getString("nodename");
	  String datacondition = rs.getString("datacondition");
	  String tempkey = tablekey;
	  if(dbtypeStr.equalsIgnoreCase("sqlserver")){
		  tempkey = "convert(varchar(4000),"+tablekey+")";
	  }
	  String nodeSql = "select '"+id+"_'"+connStr+tempkey+" as id,"+tablekey+" as objid,"+showfield+" as showname,'"+nodename+"' as nodename, '"+id+"' as nodeid from "+tablename;
	  if(!StringHelper.isEmpty(datacondition)){
		  datacondition = customTreeData.replaceParam(datacondition);
		  nodeSql += " where 1=1 and ("+datacondition+")";
	  }
	  if(sqls.equals("")){
		  sqls =  nodeSql;
	  }else{
		  sqls = sqls+" union all "+nodeSql;
	  }
}

String backFields = " a.id,a.showname,a.nodename,a.nodeid ";
String fromSql = " from ("+sqls+") a " ;
String SqlWhere = " where 1=1 ";
if(!showname.equals("")){
	  SqlWhere += " and a.showname like '%"+showname+"%'";
}

String sqlprimarykey = "id";
String otherSqlwhere = "";
if(src.equalsIgnoreCase("dest")){//右侧数据 
	if("".equals(check_per)){
		check_per="0";
	}
	String[] arr = check_per.split(",");
	String ids = "";
	for(int i=0;i<arr.length;i++){
		ids+= "'"+arr[i]+"'";
		if(i<arr.length-1){
			ids+= ",";
		}
	}
	otherSqlwhere += " and a.id in ("+ids+")";
}else if(src.equalsIgnoreCase("src")){//左侧数据
	String excludeId=Util.null2String(request.getParameter("excludeId"));
	if(excludeId.length()==0)excludeId=check_per;
	if(excludeId.length()>0){
		String[] arr = excludeId.split(",");
		String ids = "";
		for(int i=0;i<arr.length;i++){
			ids+= "'"+arr[i]+"'";
			if(i<arr.length-1){
				ids+= ",";
			}
		}
		otherSqlwhere += " and a.id not in ("+ids+")";
	}
}
SqlWhere+=otherSqlwhere;
String orderby = "nodeid asc,objid asc";
SplitPageParaBean spp = new SplitPageParaBean();
spp.setBackFields(backfields);
spp.setSqlFrom(fromSql);
spp.setSqlWhere(SqlWhere);
spp.setSqlOrderBy(orderby);
spp.setPrimaryKey(sqlprimarykey);
spp.setPoolname(vdatasource);
spp.setDistinct(false);
spp.setSortWay(spp.DESC);
SplitPageUtil spu = new SplitPageUtil();
spu.setSpp(spp);


int totalPage=0;
if("dest".equalsIgnoreCase(src)){
	pagenum=1;
	totalPage=1;
	rs=spu.getAllRs();
}else if("src".equalsIgnoreCase(src)){
	int RecordSetCounts=0;
	RecordSetCounts = spu.getRecordCount();
	totalPage = RecordSetCounts/perpage;
	if(totalPage%perpage>0||totalPage==0){
		totalPage++;
	}
	rs = spu.getCurrentPageRs(pagenum, perpage);
}


JSONArray jsonArr = new JSONArray();
while(rs.next()) {
	JSONObject tmp = new JSONObject();
	String id = "";
	id=rs.getString("id");
	tmp.put("id",id);
	tmp.put("showname",rs.getString("showname"));
	jsonArr.add(tmp);
}
JSONObject json = new JSONObject();
json.put("currentPage", pagenum);
json.put("totalPage", totalPage);
json.put("mapList",jsonArr.toString());
out.println(json.toString());
%>