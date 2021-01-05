
<%@ page language="java" contentType="text/xml; charset=UTF-8" %><?xml version="1.0" encoding="UTF-8"?>
<%@ page import="java.util.*" %>
<%@ page import="weaver.conn.*"%>
<%@ page import="weaver.docs.category.security.*"%>
<%@ page import="weaver.docs.category.*" %>
<%@ page import="weaver.hrm.*,weaver.general.*,weaver.systeminfo.*,weaver.systeminfo.menuconfig.*" %>
<%@ page import="weaver.systeminfo.menuconfig.*" %>
<%@ page import="org.json.XML" %>

<jsp:useBean id="rci" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="dci" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");

User user = HrmUserVarify.getUser(request,response);
if(user == null)  return ;

int parentid=Util.getIntValue(Util.null2String(request.getParameter("parentid")),0);
String type = Util.null2String(request.getParameter("type"));
String mode = Util.null2String(request.getParameter("mode"));
int resourceId = Util.getIntValue(request.getParameter("resourceId"),0);
int resourceType = Util.getIntValue(Util.null2String((String)request.getParameter("resourceType")),0);
int languageId = user.getLanguage();

String tblInfo = "";
String tblConfig = "";
if ("left".equalsIgnoreCase(type)) {
	tblInfo = "leftmenuinfo";
	tblConfig = "leftmenuconfig";
} else if ("top".equalsIgnoreCase(type)) {
	tblInfo = "mainmenuinfo";
	tblConfig = "mainmenuconfig";
}

boolean isDetachable=false;
RecordSet rs1=new RecordSet();
RecordSet rs=new RecordSet();
rs.executeSql("select detachable from systemset");
if(rs.next()) isDetachable=rs.getInt(1)==1?true:false;
%>
<tree>
<%
	MenuUtil mu=new MenuUtil(type,resourceType,resourceId,languageId);
	
	if(parentid==0) rs = mu.getAllMenuRs(1,mode);
	else rs = mu.getMenuRs(parentid,mode);

	ArrayList spareList=new ArrayList();
	StringBuffer treeStr = new StringBuffer();
	while (rs.next()) {
		treeStr = new StringBuffer();
		
		int visible = Util.getIntValue(rs.getString("visible"), 0);

		int infoId = rs.getInt("infoId");
		String iconUrl = rs.getString("iconUrl");
		String linkAddress = rs.getString("linkAddress");
		linkAddress=Util.replace(linkAddress, "&", "&#38;", 0);
		String isCustom = rs.getString("isCustom");
		int labelId = rs.getInt("labelId");
		boolean useCustomName = rs.getInt("useCustomName") == 1 ? true: false;
		String customName = rs.getString("customName");
		String customName_e = rs.getString("customName_e");
		String customName_t = rs.getString("customName_t");
		String module = Util.null2String(rs.getString("module"));
		if(!"".equals(module)){
			MouldStatusCominfo msc=new MouldStatusCominfo();
			String status=Util.null2String(msc.getStatus(module));

			if("0".equals(status)) 		continue;
		}
		
		boolean infoUseCustomName = rs.getInt("infoUseCustomName") == 1 ? true
				: false;
		String infoCustomName = rs.getString("infoCustomName");
		String infoCustomName_e = rs.getString("infoCustomName_e");
		String infoCustomName_t = rs.getString("infoCustomName_t");
		String viewIndex=rs.getString("viewIndex");
		
		int needResourcetype=rs.getInt("resourcetype");
		int needResourceid=rs.getInt("resourceid");
		
		int refersubid=Util.getIntValue(rs.getString("refersubid"),-1);		
		
		String baseTarget= Util.null2String(rs.getString("baseTarget"));			

		String text = mu.getMenuText(labelId, useCustomName, customName, customName_e,customName_t, infoUseCustomName, infoCustomName, infoCustomName_e, infoCustomName_t, languageId);			
		int parentId = Util.getIntValue(rs.getString("parentId"), 0);
		
		if(spareList.contains(""+infoId)) continue;
		spareList.add(""+infoId);
		if("top".equals(type))			
			if(infoId==1 || infoId==10  || infoId==26 ||  infoId==27 ||  infoId==19) continue;
		
		
		if("".equals(baseTarget)) baseTarget="mainFrame";
		
		if("".equals(iconUrl)) iconUrl="/images/homepage/baseelement_wev8.gif";
		
		String mainMenuId=""; 
		if(infoId==110) mainMenuId="10"; //report
		else if(infoId==114)  mainMenuId="0"; //setting
		else if(infoId==118)  mainMenuId="news"; //新闻公告
		else if(infoId==119)  mainMenuId="voting"; //网上调查
		else if(infoId==115)  mainMenuId="remind"; //提醒信息
		
		linkAddress=Util.StringReplace(linkAddress, "\\", "/");
		
		treeStr.append("<tree ");
		
		treeStr.append("id=\"");
		treeStr.append(infoId);
		treeStr.append("\" ");
		
		treeStr.append("parentId=\"");
		treeStr.append(parentId);
		treeStr.append("\" ");

		treeStr.append("text=\"");
		//{modified by chengfeng.han 2011-7-4 23777 
		treeStr.append(XML.escape(text));
		//treeStr.append(text);
		//end}
		treeStr.append("\" ");
		
		treeStr.append("openIcon=\"");
		treeStr.append(iconUrl);
		treeStr.append("\" ");
		
		treeStr.append("icon=\"");
		treeStr.append(iconUrl);
		treeStr.append("\" ");
		
		treeStr.append("linkAddress=\"");
		treeStr.append(linkAddress);
		treeStr.append("\" ");
		
		treeStr.append("isCustom=\"");
		treeStr.append(isCustom);
		treeStr.append("\" ");
		
		treeStr.append("visible=\"");
		treeStr.append(visible);
		treeStr.append("\" ");
		
		treeStr.append("viewIndex=\"");
		treeStr.append(viewIndex);
		treeStr.append("\" ");
		
		treeStr.append("baseTarget=\"");
		treeStr.append(baseTarget);
		treeStr.append("\" ");
		
		treeStr.append("refersubid=\"");
		treeStr.append(refersubid);
		treeStr.append("\" ");
		
		treeStr.append("action=\"");
		treeStr.append(linkAddress);
		treeStr.append("\" ");

		treeStr.append("mainMenuId=\"");
		treeStr.append(mainMenuId);
		treeStr.append("\" ");
		
	    if(needResourcetype==1){/*总部 z* 分部 s*  个人 r*  */
			treeStr.append("ownerid=\"");
			treeStr.append("z" + needResourceid);
			treeStr.append("\" ");
	    } else if(needResourcetype==2){
			treeStr.append("ownerid=\"");
			treeStr.append("s" + needResourceid);
			treeStr.append("\" ");
	    }else if(needResourcetype==3){
			treeStr.append("ownerid=\"");
			treeStr.append("r" + needResourceid);
			treeStr.append("\" ");
	    }
	    
	    rs1.executeSql("select count(0) c from " + tblInfo + " where parentId = " + infoId);
	    if(rs1.next()&&rs1.getInt("c")>0) treeStr.append("src=\"MenuMaintenanceListXML.jsp?type="+type+"&amp;mode="+mode+"&amp;resourceId="+resourceId+"&amp;resourceType="+resourceType+"&amp;parentid="+infoId+"\" ");
	    
	    treeStr.append(" />");
	     
	    out.println(treeStr.toString());
	}
%>
</tree>