
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.conn.*"%>
<%@ page import="weaver.hrm.*,weaver.general.*,weaver.systeminfo.*,weaver.systeminfo.menuconfig.*" %>
<%@ page import="net.sf.json.JSONObject" %>
<jsp:useBean id="ManageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />

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
RecordSet rs=new RecordSet();

	MenuUtil mu=new MenuUtil(type,resourceType,resourceId,languageId);
	mu.setUser(user);
	if(parentid==0){
	new BaseBean().writeLog("in SystemMenuMaint getAllMenuRs");
	 rs = mu.getAllMenuRs(1,mode);
	}
	else {
	new BaseBean().writeLog("in SystemMenuMaint getMenuRs");
	rs = mu.getMenuRs(parentid,mode);
	}
	
	List spareList=new ArrayList();
	StringBuffer treeStr = new StringBuffer();
	treeStr.append("[");
	while (rs.next()) {
		JSONObject json = new JSONObject ();
		//treeStr = new StringBuffer();
		
		int visible = Util.getIntValue(rs.getString("visible"), 0);
		
		int infoId = rs.getInt("infoId");
		
		 int needResourcetype=rs.getInt("resourcetype");
			int needResourceid=rs.getInt("resourceid");
			if(resourceType==3){
				if(!mu.hasShareRight(infoId,needResourceid,needResourcetype)){
					continue;
				}
			}
	        
		//System.out.println(infoId);
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
		json.put("isParent",rs.getInt("curParent") > 0); 
	    json.put("isReferedParent",rs.getInt("allParent") > 0); 
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

		if(resourceType==3){
			json.put("chkDisabled",true);
		}else{
			json.put("chkDisabled",false);
		}
		
		
	    if(needResourcetype==1){/*总部 z* 分部 s*  个人 r*  */
	    	json.put("ownerid","z"+needResourceid);
	    } else if(needResourcetype==2){
	    	json.put("ownerid","s"+needResourceid);
	    }else if(needResourcetype==3){
	    	json.put("ownerid","r"+needResourceid);
	    	json.put("chkDisabled",false);
	    }
	    //System.out.println(resourceType+"%%%"+needResourcetype+"%%%"+resourceId+"%%%"+needResourceid);
	    //if(resourceType==needResourcetype&&resourceId==needResourceid)
	    json.put("hasReferedToSub",refersubid!=-1);//是否同步到下级
		if(refersubid==-1 || refersubid==0 && resourceType==1 ||refersubid==resourceId){
	    	// json.put("chkDisabled",false);
	    	 json.put("canEdit",true);

	    }else{
	    	 
	    	 json.put("canEdit",false);
	    }
	    json.put("remark","");
	    
	//  	rs1.executeSql("select count(0) c from " + tblInfo + " t1, "+tblConfig+" t2 where t2.infoId = t1.id and t2.resourcetype = "+resourceType+"  and t2.resourceid = "+resourceId+" and t1.parentId = " + infoId);
	 //  	rs1.executeSql("select count(0) c from " + tblInfo + " where parentId = " + infoId);//总部建的菜单，分部在该菜单下建了下级菜单，总部删除时需提示有下级菜单？
	 // 	if(rs1.next()&&rs1.getInt("c")==0) json.put("isParent",false); 
	    json.put("viewIndex",viewIndex);
	    json.put("checked",visible==1?true:false);
	   
	    treeStr.append(json.toString());
	    treeStr.append(",");
	}
	if(treeStr.length()==1){
		out.print("[]");
	}else{
		out.print(treeStr.toString().substring(0,treeStr.toString().length()-1)+"]");
	}
%>