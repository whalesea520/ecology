<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.workflow.form.FormManager"%>
<%@ page import="weaver.formmode.virtualform.VirtualFormHandler"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Enumeration" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Map.Entry" %>
<%@ page import="weaver.formmode.interfaces.ModeManageMenu" %>
<%@ page import="weaver.formmode.view.ResolveFormMode"%>
<%@ page import="java.util.regex.Pattern"%>
<%@page import="weaver.file.Prop"%>
<%@ page import="java.util.regex.Matcher"%>
<%@page import="weaver.common.util.string.StringUtil"%>
<%@ page import="weaver.formmode.setup.ExpandBaseRightInfo" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResolveFormMode" class="weaver.formmode.view.ResolveFormMode" scope="page" />
<jsp:useBean id="ModeRightInfo" class="weaver.formmode.setup.ModeRightInfo" scope="page" />
<jsp:useBean id="ModeShareManager" class="weaver.formmode.view.ModeShareManager" scope="page" />
<jsp:useBean id="ModeViewLog" class="weaver.formmode.view.ModeViewLog" scope="page"/>
<jsp:useBean id="FormModeRightInfo" class="weaver.formmode.search.FormModeRightInfo" scope="page" />
<jsp:useBean id="ExpandInfoService" class="weaver.formmode.service.ExpandInfoService" scope="page" />
<jsp:useBean id="FieldInfo" class="weaver.formmode.data.FieldInfo" scope="page" />
<jsp:useBean id="modeShareManager" class="weaver.formmode.view.ModeShareManager" scope="page" />
<jsp:useBean id="expandBaseRightInfo" class="weaver.formmode.setup.ExpandBaseRightInfo" scope="page" />
<jsp:useBean   id="xssUtil" class="weaver.filter.XssUtil" />
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
String logintype = user.getLogintype();
int modeId = Util.getIntValue(request.getParameter("modeId"),0);
int mainid = Util.getIntValue(request.getParameter("mainid"),0);
int formId = Util.getIntValue(request.getParameter("formId"),0);
//qc360788 
if(modeId!=0){
    rs.executeSql(" SELECT * FROM modeinfo WHERE id="+modeId);
    if(rs.next()){
        formId = rs.getInt("formid");
    }
}
int type = Util.getIntValue(request.getParameter("type").split("\\?")[0],0);
boolean checkisRight = false;
if(logintype.equals("2") && type == 0){
	checkisRight = true;
}
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
int templateid = Util.getIntValue(request.getParameter("templateid"),0);
//int billid = Util.getIntValue(request.getParameter("billid"),0);
String billid="";
if(request.getParameter("billid_add")!=null){
	billid = xssUtil.get(request.getParameter("billid_add"));
}else{
    billid = Util.null2String(request.getParameter("billid"));
}
billid = billid.replaceAll("%2B","\\+");
String pkfield = Util.null2String(request.getParameter("pkfield"));//主键字段，用于浏览按钮设置主键字段时解析billid
String customTreeDataId = Util.null2String(request.getParameter("customTreeDataId"),"");
if(!"id".equals(pkfield)&&!"".equals(pkfield)){//当设置了主键时，重新解析billid
	FormManager fManager = new FormManager();
	String table = fManager.getTablename(formId);
	try {
		rs.executeSql("select id from "+table+" where "+pkfield+"='"+billid+"' and formmodeid="+modeId);
		if(rs.next()){
			billid = Util.null2String(rs.getInt("id"));
		}
	} catch(Exception e) {}	
}
String isopenbyself = Util.null2String(request.getParameter("isopenbyself"));
String editData = Util.null2String(request.getParameter("editData"));//不为空表示来自新建或编辑，允许出现编辑按钮
int isfromTab = Util.getIntValue(request.getParameter("isfromTab"),0);
int fromSave = Util.getIntValue(request.getParameter("fromSave"),0);
String iscreate = Util.null2String(request.getParameter("iscreate"));

String viewfrom = Util.null2String(request.getParameter("viewfrom"));
int opentype = Util.getIntValue(request.getParameter("opentype"),0);
int customid = Util.getIntValue(request.getParameter("customid"),0);

//============================================虚拟表基础数据====================================
String vdatasource = null;	//虚拟表单数据源
String vprimarykey = "id";	//虚拟表单主键列名称
boolean isVirtualForm = VirtualFormHandler.isVirtualForm(formId);	//是否是虚拟表单
Map<String, Object> vFormInfo = new HashMap<String, Object>();
if(isVirtualForm){
	vFormInfo = VirtualFormHandler.getVFormInfo(formId);
	vdatasource = Util.null2String(vFormInfo.get("vdatasource"));	//虚拟表单数据源
	vprimarykey = Util.null2String(vFormInfo.get("vprimarykey"));	//虚拟表单主键列名称
}
expandBaseRightInfo.setUser(user);
ModeRightInfo.setModeId(modeId);
ModeRightInfo.setType(type);
ModeRightInfo.setUser(user);
boolean isRight = false;
boolean isEdit = false;		//是否有编辑权限，主要针对右键按钮是否显示
boolean isDel = false;		//是否有删除权限，主要针对右键按钮是否显示
List<User> lsUser = new ArrayList<User>();
if(type==1){//新建时只取当前账户
	lsUser.add(user);
}else{
	lsUser = ModeRightInfo.getAllUserCountList(user);
}
int operateuserid = user.getUID();

for(int i=0;i<lsUser.size();i++){
	User tempUser = lsUser.get(i);
	if(type == 1 || type == 3){//新建、监控权限判断
		//isRight = ModeRightInfo.checkUserRight(type);
		FormModeRightInfo.setUser(tempUser);
		isRight = FormModeRightInfo.checkUserRight(customid,4);
		if(!isRight){  //如果自定义查询页面无监控权限，则检查全局监控权限
			ModeRightInfo.setModeId(modeId);
			ModeRightInfo.setType(type);
			ModeRightInfo.setUser(tempUser);
			
			isRight = ModeRightInfo.checkUserRight(type);
		}
	}
	if(isRight){
		operateuserid = tempUser.getUID();
		break;
	}
}

for(int i=0;i<lsUser.size();i++){
	User tempUser = lsUser.get(i);
	ModeShareManager.setModeId(modeId);
	int MaxShare = 0;
	if((type == 0 || type == 2) && !isVirtualForm){//查看、编辑权限
		String rightStr = ModeShareManager.getShareDetailTableByUser("formmode",tempUser);
		rs.executeSql("select sourceid,max(sharelevel) as sharelevel from "+rightStr+" t where sourceid="+billid+" group by sourceid");
		if(rs.next()){
			MaxShare = rs.getInt("sharelevel");
			isRight = true;
			if(MaxShare > 1) {
				isEdit = true;		//有编辑或完全控制权限的出现编辑按钮
				if(MaxShare == 3) isDel = true;		//有编辑或者完全控制权限的出现删除按钮
			}
		}
	}
	
	if(isRight){
		operateuserid = tempUser.getUID();
		break;
	}
}
if(checkisRight){
		isRight = true;
}
String formmodeflag = Util.null2String(request.getParameter("formmode_authorize"));
if(formmodeflag.equals("formmode_authorize")){
	isRight = true;
}
if(!isRight && !isVirtualForm){
	response.sendRedirect("/notice/noright.jsp");
	return;
}

if(isVirtualForm){	//虚拟表单，暂时不考虑权限。
	isEdit = true;	
}
if(type==2&&!isEdit){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
boolean haveTab = false;//需要多tab页
String sql = "";
if(modeId>0&&isfromTab!=1){
	FormManager fManager = new FormManager();
	sql = "select id,expendname,createpage,showtype,opentype,hreftype,hrefid,hreftarget,showorder,issystem from mode_pageexpand where modeid = "+modeId+" and isshow = 1 and showtype = 1 and (tabshowtype is null or tabshowtype=0)  and isbatch in(0,2) order by showorder asc";
	rs.executeSql(sql);
	while(rs.next()){
		String detailid = Util.null2String(rs.getString("id"));
    	String expendname = Util.null2String(rs.getString("expendname"));
    	String hreftitle = Util.null2String(rs.getString("expendname"));
    	String hreftarget = Util.null2String(rs.getString("hreftarget"));
		String createpage  = Util.null2String(rs.getString("createpage"));
		
		// 检查是否有该页面扩展权限
		if(!expandBaseRightInfo.checkExpandRight(detailid, String.valueOf(modeId), billid)){
		  	// 没有权限，不显示
		  	continue;
		}
		haveTab = true;
	}
}

FieldInfo.setUser(user);
HashMap hm = FieldInfo.getMainTableData(modeId+"",formId+"",billid);
//获得模块的主字段
HashMap modeMainFieldMap = FieldInfo.getModeFieldList(modeId+"");

String addpagesql = "";
if(type== 0){//显示
	addpagesql = "and viewpage=1";
}else if(type == 2){//编辑
	addpagesql = "and managepage=1";
}else if(type == 1){//新建
	addpagesql = "and createpage=1";
}
//只查询内嵌tab页
sql = "select id from mode_pageexpand where modeid = "+modeId+" and isshow = 1 "+addpagesql+" and showtype = 1 and tabshowtype=1 and isbatch in(0,2) order by showorder asc";
rs.executeSql(sql);


boolean isgoiframe = false;
String istabinline = Util.null2String(request.getParameter("istabinline"));
if(istabinline.equals("1")){//内嵌的tab页面
	if(rs.getCounts()==0){
		isgoiframe = true;
	}
}

if(!isgoiframe&&haveTab){
	String url = "/formmode/view/ViewMode.jsp?"+Util.null2String(request.getQueryString());
	response.sendRedirect(url);
	return;
}
HashMap parentTabValueMap = new HashMap();
if(formId!=0){
	sql = "select id,fieldname from workflow_billfield where viewtype=0 and billid = " + formId;
	rs.executeSql(sql);
	while(rs.next()){
		String id = Util.null2String(rs.getString("id"));
		if(expandBaseRightInfo.checkExpandRight(id, Util.null2String(modeId), billid)) {
			continue;
		}
		String fieldid = "field"+id;
		String fieldname = Util.null2String(rs.getString("fieldname"));
		String fieldvalue = Util.null2String(request.getParameter("field"+id));
		if(!fieldvalue.equals("")){
			parentTabValueMap.put(id,fieldvalue);
		}
	}
}

//保存操作日志
//只记录查看日志，修改日志在保存的时候记录
if(type ==0&&modeId!=0){
	String operatetype = "4";//操作的类型： 1：新建 2：修改 3：删除 4：查看
	String clientaddress = request.getRemoteAddr();
	String operatedesc = SystemEnv.getHtmlLabelName(367,user.getLanguage());//查看
	int relatedid = Util.getIntValue(billid);
	String relatedname = "";
	
	ModeViewLog.resetParameter();
	ModeViewLog.setClientaddress(clientaddress);
	ModeViewLog.setModeid(modeId);
	ModeViewLog.setOperatedesc(operatedesc);
	ModeViewLog.setOperatetype(operatetype);
	ModeViewLog.setOperateuserid(operateuserid);
	ModeViewLog.setRelatedid(relatedid);
	ModeViewLog.setRelatedname(relatedname);
	ModeViewLog.setSysLogInfo();
}


String custompage = "";
String modename = "";
String modedesc = "";
String isImportDetail = "";
if(modeId > 0 ){
	rs.executeSql("select * from modeinfo where id="+modeId);
	if(rs.next()){
		if(type==1){
			isImportDetail = Util.null2String(rs.getString("isImportDetail"));
		}
		modename = Util.null2String(rs.getString("modename"));
		modedesc = Util.null2String(rs.getString("modedesc"));
		custompage = Util.null2String(rs.getString("custompage"));
	}
}
String titles = "";
String status = "";
switch(type){
	case 1:
		status = SystemEnv.getHtmlLabelName(82,user.getLanguage());//新建
		break;
	case 2:
		status = SystemEnv.getHtmlLabelName(93,user.getLanguage());//编辑
		break;
	case 3:
		status = SystemEnv.getHtmlLabelName(665,user.getLanguage());//监控
		break;
}
if (!status.equals("")) {
	titles = modename +": "+status;
} else {
	titles = modename;
	status = SystemEnv.getHtmlLabelName(89,user.getLanguage());//显示
}
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = titles;
String needfav ="";
String needhelp ="";

//处理特殊值
String iframeurl = "/formmode/view/AddFormModeIframe.jsp?modeId="+modeId+"&formId="+formId+"&type="+type+"&billid="+billid+"&customid="+customid+"&isdialog="+isDialog+"&templateid="+templateid+"&isclose="+isclose+"&mainid="+mainid+"&customTreeDataId="+customTreeDataId;
Enumeration<String> pNames = request.getParameterNames();
while(pNames.hasMoreElements()){
	String pName = pNames.nextElement();
	String pValue = Util.null2String(request.getParameter(pName));
	if(!("modeId".equals(pName)||"formId".equals(pName)||"type".equals(pName)||"billid".equals(pName)||"customid".equals(pName)||"customTreeDataId".equals(pName))){
		if(!"".equals(pValue)){
			Pattern p = Pattern.compile("[\u4e00-\u9fa5]");
    		Matcher m = p.matcher(pValue);
    		if (m.find()) {
				pValue = FieldInfo.escape(pValue);
    		}
		}
		iframeurl +="&"+pName+"="+pValue;
	}
}


//只查询内嵌tab页
sql = "select id,expendname,showtype,opentype,hreftype,hrefid,hreftarget,showorder,issystem from mode_pageexpand where modeid = "+modeId+" and isshow = 1 "+addpagesql+" and showtype = 1 and tabshowtype=1 and isbatch in(0,2) order by showorder asc";
rs.executeSql(sql);
int tempcount = 0;
while(rs.next()) {
	if(expandBaseRightInfo.checkExpandRight(Util.null2String(rs.getString("id")), Util.null2String(modeId), billid)) {
		tempcount++;
	}
}
if(isgoiframe){//内嵌的tab页面
	iframeurl += "&tabcount="+tempcount;
	response.sendRedirect(iframeurl);
	return;
}
%>
<!DOCTYPE html>
<HEAD>
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

<%if(VirtualFormHandler.isVirtualForm(formId)&&modeId==0){%>
<script type="text/javascript">
	alert("<%=SystemEnv.getHtmlLabelName(82273,user.getLanguage())%>");//虚拟表单查询列表未设置模块，不能查看数据！
	window.close();
</script>
<%}else{%>
<script type="text/javascript">
$(function(){
    $('.e8_box').Tabs({
        getLine:1,
        iframe:"tabcontentframe",
        staticOnLoad:true,
        mouldID:"<%= MouldIDConst.getID("formmode")%>",
        objName:"<%=modename%>"
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

function doBackCustomSearch(){
	window.location.href = "/formmode/search/CustomSearchBySimple.jsp?customid=<%=customid%>";
}

</script>
</head>
<BODY scroll="no">
	<input type="hidden" id="isopenbyself" name="isopenbyself" value="<%=isopenbyself %>">
	<input type="hidden" id="customid" name="customid" value="<%=customid %>">
	<div class="e8_box demo2">
		<div class="e8_boxhead">
			<div class="div_e8_xtree" id="div_e8_xtree"></div>
	        <div class="e8_tablogo" id="e8_tablogo"></div>
			<div class="e8_ultab">
				<div class="e8_navtab" id="e8_navtab">
					<span id="objName"></span>
				</div>
				<div>	
			    <ul class="tab_menu">
				    <li class="current">
				    	<%
				    	String descStr = modename;
				    	int innerTabCount = rs.getCounts();
				    	if(innerTabCount>0){
				    		descStr = SystemEnv.getHtmlLabelName(1361,user.getLanguage());
				    	}
				    	%>
				    	<a href="javascript:void(0)"  url="<%=iframeurl%>" onclick="showTabIframe(this,0,<%=innerTabCount %>)" class="a_tabcontentframe" >
							<%=descStr %>
						</a>
					</li>
					
					<%
					
		   			FormManager fManager = new FormManager();
		   			List iframeList = new ArrayList();
		   			List iframeUrlList = new ArrayList();
		   			String tableName = isVirtualForm ? VirtualFormHandler.getRealFromName(fManager.getTablename(formId)) : fManager.getTablename(formId);
		   			rs.beforFirst();
		   			while(rs.next()){
		   				String detailid = Util.null2String(rs.getString("id"));
		   		    	String expendname = Util.null2String(rs.getString("expendname"));
		   		    	String hreftitle = Util.null2String(rs.getString("expendname"));
		   		    	String hreftarget = Util.null2String(rs.getString("hreftarget"));
		   		    	int hreftype = rs.getInt("hreftype");
		   		    	int hrefid = rs.getInt("hrefid");
		   		    	
		   		    	// 检查是否有该页面扩展权限
						if(!expandBaseRightInfo.checkExpandRight(detailid, String.valueOf(modeId), billid)){
		  					// 没有权限，不显示
		  					continue;
						}
		   		    	
		   		    	if(hreftype==1&&hrefid>0){//模块
		   		    		sql = "select * from modeinfo where id = " + hrefid;
		   		    		RecordSet.executeSql(sql);
		   		    		//out.println(sql);
							if(RecordSet.next()){
								int modeformid = RecordSet.getInt("formid");
								String vdatasource_ = null;	//虚拟表单数据源
								String vprimarykey_ = "id";	//虚拟表单主键列名称
								boolean isVirtualForm_ = VirtualFormHandler.isVirtualForm(modeformid);	//是否是虚拟表单
								Map<String, Object> vFormInfo_ = new HashMap<String, Object>();
								tableName = fManager.getTablename(modeformid);
								if(isVirtualForm_){
									vFormInfo_ = VirtualFormHandler.getVFormInfo(modeformid);
									vdatasource_ = Util.null2String(vFormInfo_.get("vdatasource"));	//虚拟表单数据源
									vprimarykey_ = Util.null2String(vFormInfo_.get("vprimarykey"));	//虚拟表单主键列名称
									tableName = VirtualFormHandler.getRealFromName(tableName);
								}
								String sqlwhere = FieldInfo.getRelateSqlWhere(modeId+"",hrefid,hreftype,Util.getIntValue(detailid,0),hreftarget,hm);
								sql = "select "+vprimarykey_+" from " + tableName + " " + sqlwhere;
								
								String fromSql;
								//查询有权限查询的数据是否存在，如果存在的话，就进入查看页面，如果不存在，则新建
								if(isVirtualForm_){	//是虚拟表单
									fromSql  = sql;
								}else{
									modeShareManager.setModeId(hrefid);
									String rightStr = modeShareManager.getShareDetailTableByUser("formmode",user);
									fromSql = "select * from "+rightStr+" t ";
									fromSql = fromSql + ",("+sql+") t2 where t.sourceid=t2.id " ;
								}
								fromSql += " order by " + vprimarykey_;
								RecordSet.executeSql(fromSql,vdatasource_);
								
								if(RecordSet.next()){//存在直接打开数据
									type = 0;
									String subid = RecordSet.getString(vprimarykey_);
									//http://127.0.0.1:86/formmode/view/addformmode.jsp?isfromTab=1&type=0&modeId=10&formId=-257&billid=5
									hreftarget = "/formmode/view/AddFormMode.jsp?type="+type+"&modeId="+hrefid+"&formId="+modeformid+"&billid="+subid;
								}else{//如果不存在，新建数据
									hreftarget = FieldInfo.getRelateHrefAddress(modeId+"",hrefid,hreftype,Util.getIntValue(detailid,0),hreftarget,hm,modeMainFieldMap);
								}
							}
		   		    	}else if(hreftype==3&&hrefid>0){//模块查询列表
		   		    		try{
		   		    			hreftarget = FieldInfo.getRelateHrefAddress(modeId+"",hrefid,hreftype,Util.getIntValue(detailid,0),hreftarget,hm,modeMainFieldMap);
		   		    		}catch(Exception e){
		   		    			out.println(e);
		   		    		}
		   		    	}else{
		   		    		hreftarget = FieldInfo.getRelateHrefAddress(modeId+"",hrefid,hreftype,Util.getIntValue(detailid,0),hreftarget,hm,modeMainFieldMap);
		   		    	}
		   		    	
		   		    	if(hreftarget.indexOf("?")>-1){
		   		    		hreftarget = hreftarget + "&isfromTab=1";
		   		    	}else{
		   		    		hreftarget = hreftarget + "?isfromTab=1";
		   		    	}
		   		    	hreftarget += "&tabid="+detailid;
		   		    	if(hreftarget.indexOf("/formmode/view/AddFormMode.jsp")!=-1){
		   		    		hreftarget += "&istabinline=1";
		   		    	}
		   		    	if(hreftarget.indexOf("/formmode/search/CustomSearchBySimple.jsp")!=-1){
		   		    		hreftarget += "&istabinline=1";
		   		    	}
		   		    	iframeList.add(detailid);
		   		    	iframeUrlList.add(hreftarget);
				%>
					<li class="">
						<a href="javascript:void(0)" url="<%=hreftarget%>" onclick="showTabIframe(this,<%=detailid %>)" class="a_tabcontentframe" >
						<%=expendname%>
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
	        <div id="iframeDiv">
	            <iframe src="<%=iframeurl%>" id="tabcontentframe" name="tabcontentframe" onload="update()" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
	        </div>
	    </div>
	</div>     
</body>
<%}%>
</html>
<script language="javascript">
	$(function(){
		$('.a_tabcontentframe').hover(function(){
			$('.a_tabcontentframe').attr('title', "<%=StringUtil.Html2Text(modedesc).replaceAll("\"", "&quot;").replaceAll("\r\n|\r|\n|\n\r", "")%>");
		});
	});
	
	function showTabIframe(obj,index,innerTabCount){
		var url = $(obj).attr("url");
		var name = $(obj).text();
		if(index==0&&innerTabCount>0){
			name = "<%=modename%>";
		}
		var tabcontentframe;
		tabcontentframe = $("#tabcontentframe");
		tabcontentframe.attr("src",url);
		if(url.indexOf("http:")==0||url.indexOf("https:")==0){
			$("#rightBox").hide();
		}else{
			$("#rightBox").show();
		}
		$('.e8_box').Tabs({
	        getLine:1,
	        iframe:"tabcontentframe",
	        staticOnLoad:true,
	        mouldID:"<%= MouldIDConst.getID("formmode")%>",
	        objName:name
	    });
	}
</script>
<script type="text/javascript">
function closeWinAFrsh(templateid){
	if (parent&&typeof(parent.closeWinAFrsh)=="function") {
		parent.closeWinAFrsh(templateid);
	} else {
		var parentWin = parent.getParentWindow(window);
		parentWin.closeDlgARfsh(templateid);
	}
}
</script>

