<%@page import="weaver.formmode.virtualform.VirtualFormHandler"%>
<%@page import="weaver.general.InitServiceXMLtoDB"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.servicefiles.ResetXMLFileCache"%>
<%@ page import="weaver.formmode.excel.ModeCacheManager"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="BrowserXML" class="weaver.servicefiles.BrowserXML" scope="page" />
<%
if (!HrmUserVarify.checkUserRight("FORMMODEAPP:ALL", user)) {
	response.sendRedirect("/notice/noright.jsp");
	return;
}

String browserid = Util.null2String(request.getParameter("browserid"));
String customid = Util.null2String(request.getParameter("customid"));
String dataid = Util.null2String(request.getParameter("dataid"));
String type = Util.null2String(request.getParameter("type"));
if(!browserid.equals("")&&!customid.equals("")&&!type.equals("")){
	String modeid = "";
	String formid = "";
	String titlename = "";
	String tablename = "";
	String pkfield = "";
	
	String sql = "select a.modeid,a.customname,a.customdesc,a.formid,a.modeid from mode_custombrowser a where a.id="+customid;
	rs.executeSql(sql);
	if(rs.next()){
		formid = Util.null2String(rs.getString("formid"));	
		modeid = Util.null2String(rs.getString("modeid"));
	}
	
	sql = "select tablename from workflow_bill where id = " + formid;
	rs.executeSql(sql);
	while(rs.next()){
		tablename = Util.null2String(rs.getString("tablename"));
	}
	
	
	sql = "select b.fieldname,a.istitle from mode_CustomBrowserDspField a,workflow_billfield b where a.fieldid = b.id and a.customid = "+customid+" and (a.istitle = '1' or a.istitle='2')";
	rs.executeSql(sql);
	int istitle=0;
	while(rs.next()){
		titlename = Util.null2String(rs.getString("fieldname"));
		istitle = Util.getIntValue(Util.null2String(rs.getString("istitle")),0);
	}
	sql = "select b.fieldname,a.ispk from mode_CustomBrowserDspField a,workflow_billfield b where a.fieldid = b.id and a.customid = "+customid+" and a.ispk = '1'";
	rs.executeSql(sql);
	while(rs.next()){
		pkfield = Util.null2String(rs.getString("fieldname"));
	}
	if("".equals(pkfield)){
		pkfield = "id";
	}
    boolean isVirtualForm = VirtualFormHandler.isVirtualForm(formid);
    if(isVirtualForm){
    	tablename = VirtualFormHandler.getRealFromName(tablename);
    }
    String searchById = "";
    String search = "";
    String searchByName = "";
    if(isVirtualForm){
    	rs.executeSql("select vprimarykey from ModeFormExtend where formid="+formid);
    	String vprimarykey = "";
    	if(rs.next()){
    		vprimarykey = Util.null2String(rs.getString("vprimarykey"));
    	}
    	searchById = "select "+titlename+","+titlename+" from "+tablename+" where "+vprimarykey+"=?";
    	search = "select "+vprimarykey+","+titlename+","+titlename+" from "+tablename;
    	searchByName = "select "+vprimarykey+","+titlename+","+titlename+" from "+tablename + " where " + titlename + " like ?";
    }else{
    	searchById = "select "+titlename+","+titlename+" from "+tablename+" where "+pkfield+"=?";
    	search = "select "+pkfield+","+titlename+","+titlename+" from "+tablename;
    	searchByName = "select "+pkfield+","+titlename+","+titlename+" from "+tablename + " where " + titlename + " like ?";
    }
    
    String outPageURL = "/formmode/browser/CommonSingleBrowser.jsp?customid="+customid;
    String from = "1";
    String href = "";
    if("id".equals(pkfield)||"".equals(pkfield)){
    	href = "/formmode/view/AddFormMode.jsp?type=0&modeId="+modeid+"&formId="+formid+"&billid=";
    }else{
    	href = "/formmode/view/AddFormMode.jsp?type=0&modeId="+modeid+"&pkfield="+pkfield+"&formId="+formid+"&billid=";
    }
    if(istitle==2)
    	href="";
    if(type.equals("2")){
    	outPageURL = "/formmode/browser/CommonMultiBrowser.jsp?customid="+customid;
    }
    String ds = "";
    String nameHeader = "";
    String descriptionHeader = "";

    Hashtable dataHST = new Hashtable();
    dataHST.put("customid",customid);
    dataHST.put("ds",ds);
    dataHST.put("search",search);
    dataHST.put("searchById",searchById);
    dataHST.put("searchByName",searchByName);
    dataHST.put("nameHeader",nameHeader);
    dataHST.put("descriptionHeader",descriptionHeader);
    dataHST.put("outPageURL",outPageURL);
    dataHST.put("from",from);
    dataHST.put("href",href);
	if(isVirtualForm){
		Map<String,Object> vFormInfo =  VirtualFormHandler.getVFormInfo(formid);
		dataHST.put("ds","datasource."+vFormInfo.get("vdatasource"));
	}
    ArrayList pointArrayList = BrowserXML.getPointArrayList();
    String method = Util.null2String(request.getParameter("method"));
    if(method.equals("initData")){//初始化已经存在的配置信息--更新操作
    	if(pointArrayList.contains(browserid)){
    		dataHST.put("name",browserid);
    		BrowserXML.writeToBrowserXMLAdd(browserid,dataHST);
    		BrowserXML.init();
    		InitServiceXMLtoDB initServiceXMLtoDB = new InitServiceXMLtoDB();
    		initServiceXMLtoDB.initCacheBrowserByName(browserid);
			ModeCacheManager.getInstance().reloadBrowser(browserid);
        	%>
        	<script type="text/javascript">
				location.href = "/formmode/setup/browsersetinfo.jsp?customid=<%=customid%>&id=<%=browserid%>&browserid=<%=browserid%>&dataid=<%=dataid%>";
			</script>
        	<%
    	}
    }else{
    	
    if(pointArrayList.indexOf(browserid)>-1){
%>
		<script type="text/javascript">
			parent.location.href = "/formmode/browser/CreateBrowser.jsp?customid=<%=customid%>&browserid=<%=browserid%>&type=<%=type%>&flag=1";
		</script>
<%
    }else{
    	BrowserXML.writeToBrowserXMLAdd(browserid,dataHST);
    	BrowserXML.init();
    	InitServiceXMLtoDB initServiceXMLtoDB = new InitServiceXMLtoDB();
    	initServiceXMLtoDB.initCacheBrowserByName(browserid);
		ModeCacheManager.getInstance().reloadBrowser(browserid);
%>
		<script type="text/javascript">
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(18758,user.getLanguage())%>");//保存成功
			var parentWin = parent.parent.parent.getParentWindow(parent.parent);
			var dialog = parent.parent.parent.getDialog(parent.parent);
			dialog.close();
			parentWin.location.href = parentWin.location.href;
		</script>
<%
    }
	}
}else{
%>
	<script type="text/javascript">
		parent.location.href = "/formmode/browser/CreateBrowser.jsp?customid=<%=customid%>&browserid=<%=browserid%>&type=<%=type%>&flag=2";
	</script>
<%
}
%>

