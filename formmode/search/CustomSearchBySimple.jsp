<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.servicefiles.DataSourceXML"%>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.Util" %>
<%@page import="weaver.formmode.data.FieldInfo"%>
<%@ page import="weaver.formmode.virtualform.VirtualFormHandler"%>
<%@page import="weaver.formmode.service.CommonConstant"%>
<%@page import="weaver.formmode.customjavacode.CustomJavaCodeRun"%>
<%@page import="com.weaver.formmodel.util.StringHelper"%>f
<%@page import="weaver.interfaces.workflow.browser.Browser"%>
<%@page import="weaver.interfaces.workflow.browser.BrowserBean"%>
<%@page import="weaver.conn.RecordSetDataSource"%>
<%@page import="weaver.formmode.service.SelectItemPageService"%>
<%@page import="weaver.common.util.string.StringUtil"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rsm" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="customSearchService" class="weaver.formmode.service.CustomSearchService" scope="page" />
<jsp:useBean id="ModeShareManager" class="weaver.formmode.view.ModeShareManager" scope="page" />
<jsp:useBean id="ModeRightInfo" class="weaver.formmode.setup.ModeRightInfo" scope="page" />
<jsp:useBean id="FormModeTransMethod" class="weaver.formmode.search.FormModeTransMethod" scope="page" />
<jsp:useBean id="FormModeRightInfo" class="weaver.formmode.search.FormModeRightInfo" scope="page" />
<jsp:useBean id="CustomSearchService" class="weaver.formmode.service.CustomSearchService" scope="page" />
<%@ page import="weaver.formmode.tree.CustomTreeData" %>
<jsp:useBean id="CustomTreeUtil" class="weaver.formmode.tree.CustomTreeUtil" scope="page" />

<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
int customid = Util.getIntValue(request.getParameter("customid"));
Map m = customSearchService.getCustomSearchById(customid);
String customName = Util.null2String(m.get("customname"));
String customDesc = Util.null2String(m.get("customdesc"));
String customTreeDataId = request.getParameter("customTreeDataId");
if(!StringHelper.isEmpty(customTreeDataId)){
	String[] arr = customTreeDataId.split("_");
	if(arr.length==2){
		String sql = "select mainid from mode_customtreedetail where id="+arr[0];
		rs.executeSql(sql);
		if(rs.next()){
			String mainid = rs.getString("mainid");
			String nodename = CustomTreeUtil.getTreeFieldShowName(customTreeDataId,mainid,"onlyname");
			if(!nodename.equals("")){
				customName = nodename;
			}
		}
	}
}
String tempquerystring = Util.null2String(request.getQueryString());
 tempquerystring  = new String(tempquerystring.getBytes("ISO8859-1"), "UTF-8");
String tempquerystringGBK =  new String(Util.null2String(request.getQueryString()).getBytes("ISO8859-1"), "GBK");
String customidStr = "";
if(tempquerystring.indexOf("customid=")==-1){
	customidStr ="customid="+customid+"&";
}
String treesqlwhere = Util.null2String(request.getParameter("treesqlwhere"));
String treenodeid = Util.null2String(request.getParameter("treenodeid"));
String isfromsearchtree = Util.null2String(request.getParameter("isfromsearchtree"));
int mainid = Util.getIntValue(Util.null2String(request.getParameter("mainid")),0);
if(isfromsearchtree.equals("1")){
	String pid = Util.null2String(request.getParameter("pid"));
	String pids[] = pid.split(CustomTreeData.Separator);
	String customdetailid = pids[0];
	String supid = pids[1];
	String href = CustomTreeUtil.getRelateHrefAddress(mainid,customdetailid,supid);
	if(!href.equals("")){
		int indexTemp = href.indexOf("treesqlwhere=");
		int indexTemp2 = -1;
		
		if(indexTemp!=-1){
			treesqlwhere = href.substring(indexTemp+"treesqlwhere=".length());
			if(!treesqlwhere.equals("")){
				indexTemp2 = treesqlwhere.indexOf("&");
				if(indexTemp2!=-1){
					treesqlwhere = treesqlwhere.substring(0,indexTemp2);
				}
			}
			if(!treesqlwhere.equals("")){
				indexTemp = tempquerystring.indexOf("&isfromsearchtree");
				tempquerystring = tempquerystring.substring(0,indexTemp);
				indexTemp = tempquerystring.indexOf("treesqlwhere=");
				if(indexTemp!=-1){
					String aftStr = "";
					String tempStr = tempquerystring.substring(indexTemp+"treesqlwhere=".length());
					if(!tempStr.equals("")){
						indexTemp2 = tempStr.indexOf("&");
						if(indexTemp2!=-1){
							aftStr = tempStr.substring(indexTemp2);
						}
					}
					tempquerystring = tempquerystring.substring(0,indexTemp)+"treesqlwhere="+treesqlwhere+aftStr;
				}
			}
		}
	}
}else if(treesqlwhere.equals("")){
	if(!tempquerystringGBK.equals("")){
		int indexTemp = tempquerystringGBK.indexOf("treesqlwhere=");
		int indexTemp2 = -1;
		String aftStr = "";
		if(indexTemp!=-1){
			treesqlwhere = tempquerystringGBK.substring(indexTemp+"treesqlwhere=".length());
			if(!treesqlwhere.equals("")){
				indexTemp2 = treesqlwhere.indexOf("&");
				if(indexTemp2!=-1){
					aftStr = treesqlwhere.substring(indexTemp2);
					treesqlwhere = treesqlwhere.substring(0,indexTemp2);
				}
			}
			if(!treesqlwhere.equals("")){
				tempquerystring = tempquerystring.substring(0,indexTemp)+"treesqlwhere="+treesqlwhere+aftStr;
			}
		}
	}
}
if(treenodeid.equals("")){
	if(!tempquerystringGBK.equals("")){
		int indexTemp = tempquerystringGBK.indexOf("&treenodeid=");
		int indexTemp2 = -1;
		String aftStr = "";
		if(indexTemp!=-1){
			treenodeid = tempquerystringGBK.substring(indexTemp+"&treenodeid=".length());
			if(!treenodeid.equals("")){
				indexTemp2 = treenodeid.indexOf("&");
				if(indexTemp2!=-1){
					aftStr = treenodeid.substring(indexTemp2);
					treenodeid = treenodeid.substring(0,indexTemp2);
				}
			}
		}
	}
}

String paramStr = "";
String treesqlwhere1 =treesqlwhere;
if(!treenodeid.equals("")&&!treesqlwhere.equals("")){
	FieldInfo fieldInfo = new FieldInfo();
	fieldInfo.setUser(user);
	int isContainsSub = 0;
	paramStr = fieldInfo.getCustomSearchParam(treesqlwhere,treenodeid,customid+"");
	if(paramStr.indexOf(" and isContainsSub=1")!=-1){
		isContainsSub = 1;
		paramStr = paramStr.replace(" and isContainsSub=1","");
		treesqlwhere1 =paramStr ;
		paramStr = "&treesqlwhere1="+paramStr;
	}
	if(!paramStr.equals("")){
		if(paramStr.equals(treesqlwhere)){
			paramStr = "";
		}else{
			if(!paramStr.startsWith("&treecon")){
				paramStr = "&splitFlag=-999"+paramStr;
			}
		}
	}
}
String url = "/formmode/search/CustomSearchBySimpleIframe.jsp?"+customidStr+tempquerystring+paramStr+"&mainid="+mainid+"&customTreeDataId="+customTreeDataId;
if(url.indexOf("+")!=-1){
	url = url.replace("+", "%2B");
}
int viewtype=Util.getIntValue(request.getParameter("viewtype"),0);
//快捷搜索 1本周,2本月,3本季,4本年
String thisdate=Util.null2String(request.getParameter("thisdate"));
//快捷搜索 1本部门,2本部门(包含下级部门),3本分部,4本分部(包含下级分部)
String thisorg=Util.null2String(request.getParameter("thisorg"));
//获得快捷搜索的sql
String quickSql = FormModeTransMethod.getQuickSearch(user,thisdate,thisorg);

//============================================查询列表基础数据====================================
String formID="0";
String tablename="";
String modeid = "0";
String disQuickSearch = "";
String defaultsql = "";
String norightlist = "";

String searchconditiontype = "1";
String javafilename = "";
String detailtable = "";
int isShowQueryCondition=0;
rs.execute("select a.*,b.tablename,b.detailkeyfield, detailtable from mode_customsearch a left join workflow_bill b on a.formid=b.id where a.id="+customid);
if(rs.next()){
    formID=Util.null2String(rs.getString("formid"));
    modeid=""+Util.getIntValue(rs.getString("modeid"),0);
    detailtable = Util.null2String(rs.getString("detailtable"));
    disQuickSearch = "" + Util.toScreenToEdit(rs.getString("disQuickSearch"),user.getLanguage());
    defaultsql = "" + Util.toScreenToEdit(rs.getString("defaultsql"),user.getLanguage()).trim();
    defaultsql = FormModeTransMethod.getDefaultSql(user,thisdate,thisorg,defaultsql);
    norightlist = Util.null2String(rs.getString("norightlist"));
    isShowQueryCondition = Util.getIntValue(rs.getString("isShowQueryCondition"),0);
    searchconditiontype = Util.null2String(rs.getString("searchconditiontype"));
	searchconditiontype = searchconditiontype.equals("") ? "1" : searchconditiontype;
	javafilename = Util.null2String(rs.getString("javafilename"));
	tablename = rs.getString("tablename");
}

boolean isVirtualForm = VirtualFormHandler.isVirtualForm(formID);	//是否是虚拟表单
String vdatasource = "";	//虚拟表单数据源
String vdatasourceDBtype = "";	//数据库类型
Map<String, Object> vFormInfo = new HashMap<String, Object>();
if(isVirtualForm){
	vFormInfo = VirtualFormHandler.getVFormInfo(formID);
	vdatasource = Util.null2String(vFormInfo.get("vdatasource"));	//虚拟表单数据源
	tablename =VirtualFormHandler.getRealFromName(tablename);
	DataSourceXML dataSourceXML = new DataSourceXML();
	vdatasourceDBtype = dataSourceXML.getDataSourceDBType(vdatasource);
}else {
	vdatasourceDBtype = rs.getDBType();
}

//============================================权限判断====================================
boolean isRight = false;
boolean isBatchEdit = false;
if(viewtype == 3){//监控权限判断
	boolean isHavepageRight = FormModeRightInfo.isHavePageRigth(customid,4);
	if(isHavepageRight){
		FormModeRightInfo.setUser(user);
		isRight = FormModeRightInfo.checkUserRight(customid,4);
	}
	else{  //如果自定义查询页面无监控权限，则检查全局监控权限
		ModeRightInfo.setModeId(Util.getIntValue(modeid));
		ModeRightInfo.setType(viewtype);
		ModeRightInfo.setUser(user);
		
		isRight = ModeRightInfo.checkUserRight(viewtype);
	}
}else{
	//批量修改权限
	rs.executeSql("select * from mode_searchPageshareinfo where righttype=2 and pageid = " + customid);
	if(rs.next()){  
		FormModeRightInfo.setUser(user);
		isBatchEdit = FormModeRightInfo.checkUserRight(customid,2);
	}
	if(isBatchEdit){
		isRight = true;
	}else{
		//自定义页面查看权限
		rs.executeSql("select * from mode_searchPageshareinfo where righttype=1 and pageid = " + customid);
		if(rs.next()){  
			FormModeRightInfo.setUser(user);
			isRight = FormModeRightInfo.checkUserRight(customid,1);
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

boolean isBatchEditPage = (viewtype==2 && !isVirtualForm);
//获取查询分组字段
String groupid = "0";
String groupname = "";
String groupsql = "";
String fieldhtmltype = "";
int selectitem = 0;
int linkfield = 0;

Map groupmap = new HashMap();
rs.execute("select fieldid from mode_CustomDspField where isgroup=1 and  customid="+customid);
if(rs.next()){
	groupid = Util.null2String(rs.getString("fieldid"));
}
if(!"0".equals(groupid)){
		url += "&fromgroup=1";
		rs.execute("select * from workflow_billfield where id="+groupid);
		if(rs.next()){
			groupname = Util.null2String(rs.getString("fieldname"));
			fieldhtmltype = Util.null2String(rs.getString("fieldhtmltype"));
			selectitem = Util.getIntValue(rs.getString("selectitem"),0);
			linkfield = Util.getIntValue(rs.getString("linkfield"),0);
		}
		int splitIndex = tempquerystring.indexOf("&splitFlag=-999");
		
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
		
		//============================================数据属于哪个模块条件====================================
		String whereclause=" where t1.formmodeid = " + modeid + " ";
		if(isVirtualForm){
			whereclause = " where 1=1 ";
		}else if(modeid.equals("")||modeid.equals("0")){//没有设置模块
			if("1".equals(norightlist)) {
				whereclause = " where 1=1 ";
			} else {
				String sqlStr1 = "select id,modename from modeinfo where formid="+formID+" order by id";
				rsm.executeSql(sqlStr1);
				whereclause = "";
				String modeStr = "";
				while(rsm.next()){
					String mid = rsm.getString("id");
					if(modeStr.equals("")){
						modeStr += mid;
					}else{
						modeStr += ","+mid;
					}
				}
				if(!modeStr.isEmpty()){
					whereclause = " where t1.formmodeid  in ("+modeStr+") ";
				}else{
					whereclause = " where 1=1 ";
				}
			}
		}
		/**QC 195209 begin*/
		String[] checkcons = request.getParameterValues("check_con");
		Map map2 = FormModeTransMethod.customsearch2(request,checkcons,"t1","d1",vdatasourceDBtype.equals("oracle"),vdatasourceDBtype.equals("db2"),vdatasourceDBtype,new Hashtable(),"");
		String sqlwhere_con = (String)map2.get("sqlwhere_con");
		/**QC 195209 end*/
		String sqlwhere = whereclause + sqlwhere_con;
		String formmodeid=modeid;
		
		//未配置模块时重新解析权限
		String rightsql = "";
		if(!isVirtualForm){
			if(formmodeid.equals("")||formmodeid.equals("0")){//查询中没有设置模块
				String sqlStr1 = "select id,modename from modeinfo where formid="+formID+" order by id";
				rsm.executeSql(sqlStr1);
				while(rsm.next()){
					String mid = rsm.getString("id");
					ModeShareManager.setModeId(Util.getIntValue(mid,0));
					String tempRightStr = ModeShareManager.getShareDetailTableByUser("formmode",user);
					if(rightsql.isEmpty()){
						rightsql += tempRightStr;
					}else {
						rightsql += " union  all "+ tempRightStr;
					}
				}
				if(!rightsql.isEmpty()){
					rightsql = "( "+rightsql+" )";
				}
			}else{
				ModeShareManager.setModeId(Util.getIntValue(formmodeid,0));
				rightsql = ModeShareManager.getShareDetailTableByUser("formmode",user);
			}
		}
		
		String fromSql  = " from "+tablename+" t1 " ;
		if(!StringHelper.isEmpty(detailtable)) {
			fromSql += " left join "+detailtable+" d1 on t1.id = d1.mainid ";
		}
		
		if(viewtype!=3&&!norightlist.equals("1")&&!isVirtualForm){//不是监控、无权限列表、不是虚拟表单
			fromSql  = fromSql+","+rightsql+" t2 " ;
		    sqlwhere += " and t1.id = t2.sourceid ";
		    
		    if(isBatchEditPage){
				sqlwhere += " and t2.sharelevel>1 ";
			}
		}
		
		if(!quickSql.equals("")){//快捷搜索，如果快捷搜索不为空
			if(sqlwhere.equals("")){
				sqlwhere = " 1=1 " + quickSql;
			}else{
				sqlwhere += quickSql;
			}
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
		
		/* if(splitIndex==-1){//未把treesqlwhere转换
			if(!treesqlwhere.equals("")){//来自树形关联字段
				if(sqlwhere.equals("")){
					sqlwhere = " t1." + treesqlwhere;
				}else{
					sqlwhere += " and t1."+treesqlwhere+" ";
				}
			}
		} */
		if(!treesqlwhere1.equals("")){//来自树形关联字段
			int index = treesqlwhere1.indexOf("&");
			if(index!=-1){
				treesqlwhere1 = treesqlwhere1.substring(0,index);
			}
			treesqlwhere1=treesqlwhere1.replaceAll("=(.+)", "='$1'");
			if(sqlwhere.equals("")){
				sqlwhere = " t1." + treesqlwhere1;
			}else{
				sqlwhere += " and t1."+treesqlwhere1+" ";
			}
		}
		groupsql = "select tt."+groupname +", sum(1) count from (select t1."+groupname+fromSql+sqlwhere+")tt group by tt."+groupname;
		session.setAttribute("groupsql_"+customid,groupsql);
		/*int sumvalue = 0;
		if(isVirtualForm){
			RecordSetDataSource rsd = new RecordSetDataSource(vdatasource);
			rsd.executeSql(groupsql);
			while(rsd.next()){
				String key = Util.null2String(rsd.getString(groupname));
				int value = Util.getIntValue(rsd.getString("count"),0);
				groupmap.put(key, value);
				sumvalue +=value;
			}
			groupmap.put("sum", sumvalue);
		}else{
			rs.executeSql(groupsql);
			while(rs.next()){
				String key = Util.null2String(rs.getString(groupname));
				int value = Util.getIntValue(rs.getString("count"),0);
				groupmap.put(key, value);
				sumvalue +=value;
			}
			groupmap.put("sum", sumvalue);
		}*/
	}
		
int selectitemid = 0;
int level = 1;
if(selectitem>0){
	selectitemid = selectitem;
}else{
	if(fieldhtmltype.equals("8")){
		SelectItemPageService selectItemPageService = new SelectItemPageService();
		Map<String,Integer> map = selectItemPageService.getTopSelectItemIdByField(Util.getIntValue(groupid),level);
		if(map.size()>0){
			selectitemid = map.get("selectitemid");
			level = map.get("level");
		}
	}
}

String istabinline = Util.null2String(request.getParameter("istabinline"));
if(istabinline.equals("1")){//内嵌的tab页面
	response.sendRedirect(url);
	return;
}
%>
<!DOCTYPE html><HEAD>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>

<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>

<script type="text/javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script type="text/javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<LINK href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type=text/css rel=STYLESHEET>

<script type="text/javascript">
$(function(){
    $('.e8_box').Tabs({
        getLine:1,
        iframe:"tabcontentframe",
        mouldID:"<%= MouldIDConst.getID("formmode")%>",
        staticOnLoad:true,
        objName:"<%=customName%>"
    });
    
    //树形打开此页面，给图标加上展开功/关闭左侧树的功能
    if(parent.location.href.indexOf("/formmode/tree/ViewCustomTree.jsp")!=-1){
    	var logo = jQuery("#e8_tablogo");
   		if(typeof(parent.expandOrCollapse)=="function"){
	    	logo.bind("click",function(){
	    			parent.expandOrCollapse();
	    	});
	    	logo.css("cursor","pointer");
   		}
    }
}); 
</script>
</head>
<BODY scroll="no">
	<div class="e8_box demo2">
		<div class="e8_boxhead">
			<div class="div_e8_xtree" id="div_e8_xtree"></div>
	        <div class="e8_tablogo" id="e8_tablogo"></div>
			<div class="e8_ultab">
				<div class="e8_navtab" id="e8_navtab">
					<%if("0".equals(groupid)){%>
						<span id="objName" ></span>
					<%}else{%>
						<span id="objName" title="<%=StringUtil.Html2Text(customDesc) %>"></span>
					<%}%>
				</div>
				<div>	
			    <ul class="tab_menu">
					<%if("0".equals(groupid)) {%>
				    <li class="current">
						<a href="<%=url %>" target="tabcontentframe" class="a_tabcontentframe">
						<%if(!"".equals(customDesc)){%>
							<%=StringUtil.Html2Text(customDesc).length()>60?StringUtil.Html2Text(customDesc).substring(0, 60) + "...":StringUtil.Html2Text(customDesc)%>
						<%}%>
						</a>
					</li>
					<%}%>
			    </ul>
	      <div id="rightBox" class="e8_rightBox">
	    </div>
	   </div>
	  </div>
	</div>	 
	    <div class="tab_box">
	        <div>
	            <iframe src="<%=url %>" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;" onload="update();showQueryCondition()"></iframe>
	        </div>
	    </div>
	</div>     
</body>
</html>
<script language="javascript">
	$(function(){
		<%if("0".equals(groupid)) {%>
			$('.a_tabcontentframe').hover(function(){
				$('.a_tabcontentframe').attr('title', "<%=StringUtil.Html2Text(customDesc).replaceAll("\r\n|\r|\n|\n\r", "")%>");
			});
		<%}else{%>
			loadGroup();
		<%}%>
	});
	function loadGroup(){
		<%if("0".equals(groupid)){%>
			return;
		<%}%>
		jQuery.ajax({
			url:"LoadGroup.jsp",
			type:"post",
			dataType:"html",
			async:true,
			data:{
				groupid:"<%=groupid%>",
				customid:"<%=customid%>",
				url:"<%=url%>",
				customDesc:"<%=StringUtil.Html2Text(customDesc).replaceAll("\r\n|\r|\n|\n\r", "")%>",
				groupname:"<%=groupname%>",
				fieldhtmltype:"<%=fieldhtmltype%>",
				isVirtualForm:"<%=isVirtualForm%>",
				vdatasource:"<%=vdatasource%>",
				selectitemid:"<%=selectitemid%>",
				level:"<%=level%>"
			},
			success:function(data){
				$('.tab_menu').html(data);
			}
		});
	}
	
	function showQueryCondition(){
		<%if(1==isShowQueryCondition){%>
			setTimeout(function(){
			    var shadowDiv=$("div.e8_shadowDiv");
			    var advancedSearchDiv=$('#advancedSearchDiv',tabcontentframe.document);
			    $('#advancedSearch').addClass("click");
			    shadowDiv.show();
				$('#advancedSearch').unbind('click').bind('click',function(){
				    var advancedSearchDiv=$('#advancedSearchDiv',tabcontentframe.document);
				    var e8_shadowDiv=$("div.e8_shadowDiv");
					if(advancedSearchDiv.css('display')=='block'){
						advancedSearchDiv.css('display','none');
						shadowDiv.hide();
						$('#advancedSearch').removeClass("click");
					}else if(advancedSearchDiv.css('display')=='none'){
						advancedSearchDiv.css('display','block');
						shadowDiv.show();
						$('#advancedSearch').addClass("click");
					}
				});
			},200);
		<%}%>
	}
</script>
