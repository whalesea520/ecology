
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.conn.*"%>
<%@ page import="weaver.hrm.*,weaver.general.*,weaver.systeminfo.*,weaver.systeminfo.menuconfig.*" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@page import="weaver.hrm.company.DepartmentComInfo"%>
<jsp:useBean id="ManageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
<jsp:useBean id="dci" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="rci" class="weaver.hrm.resource.ResourceComInfo" scope="page" />

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

boolean isDetachable=ManageDetachComInfo.isUsePortalManageDetach();
RecordSet rs1=new RecordSet();
RecordSet rs2=new RecordSet();

RecordSet rs=new RecordSet();
	MenuUtil mu=new MenuUtil(type,resourceType,resourceId,languageId);
	mu.setUser(user);
	if(parentid==0) rs = mu.getAllMenuRs(1,mode);
	else rs = mu.getMenuRs(parentid,mode);
	List spareList=new ArrayList();
	StringBuffer treeStr = new StringBuffer();
	treeStr.append("[");
	while (rs.next()) {
		JSONObject json = new JSONObject ();
		//treeStr = new StringBuffer();
		
		int visible = Util.getIntValue(rs.getString("visible"), 0);
		if(visible==0){
			continue;
		}
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
			//System.out.println(module+":"+status);
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
		if(!mu.hasShareRight(infoId, needResourceid,needResourcetype)){	//判断权限
			continue;
		}
		
		
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
		else if(infoId==119)  {
			continue;
			//mainMenuId="voting"; //网上调查
		}
		else if(infoId==115)  { 
			continue;
			//mainMenuId="remind"; //提醒信息
		
		}
		
		linkAddress=Util.StringReplace(linkAddress, "\\", "/");

		json.put("id",infoId);
		json.put("isParent",true);
		json.put("parentId",parentId);
		json.put("name",text);
		
		json.put("openIcon",iconUrl);
		json.put("icon",iconUrl);
		json.put("linkAddress",linkAddress);
		
		json.put("isCustom",isCustom);
		json.put("visible",visible);
		json.put("baseTarget",baseTarget);
		
		json.put("refersubid",refersubid);
		json.put("action",linkAddress);
		json.put("mainMenuId",mainMenuId);
		
	    if(needResourcetype==1){/*总部 z* 分部 s*  个人 r*  */
	    	json.put("ownerid","z"+needResourceid);
	    } else if(needResourcetype==2){
	    	json.put("ownerid","s"+needResourceid);
	    }else if(needResourcetype==3){
	    	json.put("ownerid","r"+needResourceid);
	    }
	    json.put("chkDisabled",false);
	    json.put("canEdit",false);
	    
	    //当前菜单是否在常用菜单 rs1
	    // 查询当前菜单的下级菜单
	    int subcompanyId=Util.getIntValue(dci.getSubcompanyid1(rci.getDepartmentID(""+resourceId)),0);
	    String sql = "select count(*) c from " + tblInfo + " t1, "+tblConfig+" t2  where t1.id=t2.infoid and  t2.visible=1 and  t1.parentId = " + infoId;
	    if(resourceId==1){
	    	sql+=" and ((t2.resourcetype=1 and t2.resourceid =1) or (t2.resourcetype=3 and t2.resourceid=1))"; 
		} else if(isDetachable&&subcompanyId==0) {//分权时分部管理员
			sql+=" and ((t2.resourcetype=1 and t2.resourceid =1) or (t2.resourcetype=3 and t2.resourceid="+resourceId+"))"; 
		}else {
			sql+=" and ((t2.resourcetype=2 and t2.resourceid="+subcompanyId+") or (t2.resourcetype=3 and t2.resourceid="+resourceId+"))";
		}
	    
	    //rs2.executeSql("select count(*) c from " + tblInfo + " t1, "+tblConfig+" t2  where t1.id=t2.infoid and ((t2.resourcetype="+resourceType+" and t2.resourceid="+resourceId+") or (t2.resourcetype=2 and t2.resourceid="+user.getUserSubCompany1()+")) and t2.visible=1 and  t1.parentId = " + infoId);
	    rs2.executeSql(sql);
	    //System.out.println("select count(*) c from " + tblInfo + " t1, "+tblConfig+" t2  where t1.id=t2.infoid and ((t2.resourcetype="+resourceType+" and t2.resourceid="+resourceId+") or (t2.resourcetype=2 and t2.resourceid="+user.getUserSubCompany1()+")) and t2.visible=1 and  t1.parentId = " + infoId);
	    
	    if( rs2.next()&&rs2.getInt("c")>0	){
	    	//有下级菜单
	    	 rs1.executeSql("select count(*) c from UserCommonMenu  where menuid = '"+infoId+"' and userid=" +user.getUID());
	  
	    	 rs2.executeSql("select count(*) c from " + tblInfo + " where parentId = " + infoId +" and id in (select menuid from UserCommonMenu  where userid=" +user.getUID()+" )");
	    	 if(rs1.next()&&rs1.getInt("c")>0&&rs2.next()&&rs2.getInt("c")>0){
		    	 json.put("checked",true);
		    }else{
		    	json.put("checked",false);
		    }
	    	json.put("isParent",true);
	    }else{
	    	 rs1.executeSql("select count(*) c from UserCommonMenu  where menuid = '"+infoId+"' and userid=" +user.getUID());
	    	  
	    	if(rs1.next()&&rs1.getInt("c")>0){
		    	 json.put("checked",true);
		    }else{
		    	json.put("checked",false);
		    }
	    	json.put("isParent",false);
	    }
	    //rs2.executeSql("select count(*) c from " + tblInfo + " where parentId = " + infoId +" and id in (select menuid from UserCommonMenu  where userid=" +user.getUID()+" )");
	    
	    json.put("viewIndex",viewIndex);
	   
	    treeStr.append(json.toString());
	    treeStr.append(",");
	}
	if(treeStr.length()==1){
		out.print("[]");
	}else{
		out.print(treeStr.toString().substring(0,treeStr.toString().length()-1)+"]");
	}
%>