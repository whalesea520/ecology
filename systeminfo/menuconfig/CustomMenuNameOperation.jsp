
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="weaver.systeminfo.menuconfig.*" %>
<%@ page import="java.util.Enumeration" %>
<%@ page import="java.util.ArrayList" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="log" class="weaver.admincenter.homepage.PortalMaintenanceLog" scope="page" />
<jsp:useBean id="baseBean" class="weaver.general.BaseBean" scope="page" />
<%
int id = Util.getIntValue(request.getParameter("id"));
int resourceId = Util.getIntValue(request.getParameter("resourceId"));
String resourceType = Util.null2String(request.getParameter("resourceType"));
String type = Util.null2String(request.getParameter("type"));

String subCompanyId = Util.null2String(request.getParameter("subCompanyId"));

MenuMaint  mm=new MenuMaint(type,Util.getIntValue(resourceType),resourceId,user.getLanguage());


String customName = Util.null2String(request.getParameter("customName"));
String customName_e = Util.null2String(request.getParameter("customName_e"));
String customName_t = Util.null2String(request.getParameter("customName_t"));
String topmenuname = Util.null2String(request.getParameter("topMenuName"));
String topname_e = Util.null2String(request.getParameter("topName_e"));
String topname_t = Util.null2String(request.getParameter("topName_t"));
String basetarget = Util.null2String(request.getParameter("basetarget"));
int use = Util.getIntValue(request.getParameter("useCustom"));

if(!HrmUserVarify.checkUserRight("HeadMenu:Maint", user)){
	if("1".equals(resourceType)){
		response.sendRedirect("/notice/noright.jsp");
        return;
	}
}
if(!HrmUserVarify.checkUserRight("SubMenu:Maint", user)){
	if("2".equals(resourceType)){
		response.sendRedirect("/notice/noright.jsp");
        return;
	}
}

if(use!=1)
	use = 0;
mm.setTopmenuname(topmenuname);
mm.setTopname_e(topname_e);
mm.setTopname_t(topname_t);
mm.updateMenu(id,use,customName,customName_e,customName_t);
//baseBean.writeLog("customName:"+customName);

if ("left".equalsIgnoreCase(type)) {
	log.setItem("PortalMenu");
	log.setType("update");
	log.setSql("update leftmenuinfo set basetarget='"+basetarget+"'  where id="+id);
	log.setDesc("编辑菜单");
	log.setUserid(user.getUID()+"");
	log.setIp(request.getRemoteAddr());
	log.setOpdate(TimeUtil.getCurrentDateString());
	log.setOptime(TimeUtil.getOnlyCurrentTimeString());
	log.savePortalOperationLog();
	rs.executeSql("update leftmenuinfo set basetarget='"+basetarget+"'  where id="+id);
} else if ("top".equalsIgnoreCase(type)) {
	log.setItem("PortalMenu");
	log.setType("update");
	log.setSql("update mainmenuinfo set basetarget='"+basetarget+"'  where id="+id);
	log.setDesc("编辑菜单");
	log.setUserid(user.getUID()+"");
	log.setIp(request.getRemoteAddr());
	log.setOpdate(TimeUtil.getCurrentDateString());
	log.setOptime(TimeUtil.getOnlyCurrentTimeString());
	log.savePortalOperationLog();
	rs.executeSql("update mainmenuinfo set basetarget='"+basetarget+"'  where id="+id);
}

if(use!=1){ //非自定义
	MenuConfigBean mcb = mm.getMenuConfigBeanByInfoId(id);
	//out.println("<input type='hidden' value=\""+ SystemEnv.getHtmlLabelName(mcb.getMenuInfoBean().getLabelId(),7)+"\" id='sText'/>");
	customName = SystemEnv.getHtmlLabelName(mcb.getMenuInfoBean().getLabelId(),7);
}
clearSelectids();
List ids = getSuperMenuid(""+id,type);
String selectids = "";
for(int i=ids.size()-1;i>=0;i--)selectids+=","+ids.get(i);
response.sendRedirect("/systeminfo/menuconfig/MenuMaintenanceEdit.jsp?closeDialog=close&id="+id+"&resourceType="+resourceType+"&resourceId="+resourceId+"&type="+type+"&subCompanyId="+subCompanyId+"&selectids="+selectids);
%>
<%!
List selectids = new ArrayList();
List getSuperMenuid(String infoid,String type){
	BaseBean bb = new BaseBean();
	weaver.conn.RecordSet rs = new weaver.conn.RecordSet();
	String sql = "";
	if("left".equals(type)){
		sql = "select parentid from leftmenuinfo where id="+infoid;
	}else if("top".equals(type)){
		sql = "select parentid from mainmenuinfo where id="+infoid;
	}
	bb.writeLog(sql);
	rs.executeSql(sql);
	rs.next();
	String parentid = rs.getString("parentid");
	bb.writeLog(parentid+"=====parentid");
	if(!"".equals(parentid)&&!"0".equals(parentid)){
		selectids.add(parentid);
		getSuperMenuid(parentid,type);
	}
	return selectids;
}

void clearSelectids(){
	if(selectids!=null)
		selectids = new ArrayList();
}
%>