
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.general.Util,java.sql.Timestamp"%>
<%@ page import="java.util.*"%>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuConfigHandler"%>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfo"%>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuConfig"%>
<%@ page import="weaver.systeminfo.menuconfig.MenuMaint"%>
<%@ page import="weaver.hrm.HrmUserVarify"%>
<%@ page import="weaver.hrm.User"%>
<%@ page import="weaver.conn.RecordSet"%>
<%@ page import="java.util.ArrayList,java.lang.reflect.Method" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.systeminfo.menuconfig.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="java.lang.reflect.Method" %>
<%@page import="weaver.cpcompanyinfo.ProManageUtil"%>
<%@page import="com.weaver.integration.util.IntegratedSapUtil"%>
<%@page import="com.weaver.formmodel.util.StringHelper"%>
<jsp:useBean id="baseBean" class="weaver.general.BaseBean" scope="page" />
<%


String result = "";

String parentid = Util.null2String(request.getParameter("parentid"));
String typeid = Util.null2String(request.getParameter("typeid"));

User user = HrmUserVarify.getUser (request , response) ;

String curTheme = getCurrWuiConfig(session, user, "theme");

if ("111".equals(typeid)) {
    result = getInfoCenterMenu(user);
} else {
    result = getSettingMenu(user, parentid,curTheme);
}
 

out.print(result);
%>


<%!
private String getSettingMenu(User user, String parentid,String curTheme) {
    if(user == null) {
        return null;
    }
    String s = "<ul>";
  //---------------------------
    // 菜单项背景图片随机显示
    // bgcnt   : 左侧菜单背景图片个数
    // bgindex : 左侧菜单背景图片随机用下标
    // abgs    : 左侧菜单背景图片数组
    //---------------------------
    int bgcnt = 4;
    int bgindex = 4;
  
    String[] sbgPostions = new String[]{"0px -28px", "0px -84px", "0px 0px", "0px -56px"};
    
    String sql="";
    String visibility="";
    //parentid=Util.null2String(request.getParameter("parentid"));
    
    MenuUtil mu=new MenuUtil("top", 3,user.getUID(),user.getLanguage()) ;
    mu.setUser(user);
    //===============================================
    //TD4425 避免重复执行脚本造成菜单重复
    //added by hubo,2006-07-03
    ArrayList menuIds = new ArrayList();
    //===============================================
    
    //
    //if(parentid.equals("")){
        //sql = "SELECT a.* FROM MainMenuInfo a,SystemModule c WHERE c.moduleReleased='1' AND c.id=a.relatedModuleId  AND  defaultParentId IS NULL ORDER BY defaultIndex";
    //}else{
        //sql = "SELECT a.* FROM MainMenuInfo a,SystemModule c WHERE c.moduleReleased='1' AND c.id=a.relatedModuleId  AND   defaultParentId="+Integer.parseInt(request.getParameter("parentid"))+" ORDER BY defaultIndex";
    //}
    //rs.executeSql(sql);
    RecordSet rs=mu.getMenuRs(Util.getIntValue(parentid,0));

    while(rs.next()){
        boolean hasSubMenu = false;
        int infoid=rs.getInt("infoid");
        int needResourcetype=rs.getInt("resourcetype");
		int needResourceid=rs.getInt("resourceid");
        if(!mu.hasShareRight(infoid,needResourceid,needResourcetype)){
			continue;
		}
        if(infoid==1 || infoid==10  || infoid==26 ||  infoid==27 ||  infoid==19) continue;
     
        //TD4425=========================================
        if(menuIds.contains(String.valueOf(infoid))) continue;
        menuIds.add(String.valueOf(infoid));
        //===============================================
        
        int labelId = rs.getInt("labelId");
        
        //我的报表、系统设置、设置中心 模块屏蔽
        if("".equals(parentid)||"10".equals(parentid)||"11".equals(parentid)){
           String module = Util.null2String(rs.getString("module"));
           if(!"".equals(module)){
                MouldStatusCominfo msc=new MouldStatusCominfo();
                String status=Util.null2String(msc.getStatus(module));
                if("0".equals(status))      continue;
            }
        }
        
        //1163text=SAP数据授权设置
		//1164text=配置SAP浏览按钮
		//1189text=配置SAP连接
		String IsOpetype=IntegratedSapUtil.getIsHideOldSapMenu();
		if("1".equals(IsOpetype)){
		   	if(infoid==1163||infoid==1164||infoid==1189){
		   		continue;
		   	}
		}
		//1227=集成管理
		/*  if("0".equals(IsOpetype)&&infoid==1227){
				continue;
		 } */
		//1242text证照管理
		int isOpenCpcompanyinfo=ProManageUtil.getIsOpenCpcompanyinfo();
		if(isOpenCpcompanyinfo==0&&(infoid==1255||infoid==1257)){
				continue;
		}
		
		if(infoid==10008){
    		String emServer = Util.null2String( new BaseBean().getPropValue("emserver","server"));
    		if(emServer.equals("")){
    			continue;
    		}
    	}
	
        boolean useCustomName = rs.getInt("useCustomName") == 1 ? true: false;
        String customName = rs.getString("customName");
        String customName_e = rs.getString("customName_e");
        String customName_t = rs.getString("customName_t");
        
        boolean infoUseCustomName = rs.getInt("infoUseCustomName") == 1 ? true  : false;
        String infoCustomName = rs.getString("infoCustomName");
        String infoCustomName_e = rs.getString("infoCustomName_e");
        String infoCustomName_t = rs.getString("infoCustomName_t");
        String baseTarget = rs.getString("baseTarget");
        if("".equals(baseTarget)) baseTarget="mainFrame";
        
        String text = mu.getMenuText(labelId, useCustomName, customName, customName_e, customName_t, infoUseCustomName, infoCustomName, infoCustomName_e,infoCustomName_t,user.getLanguage());           
        RecordSet rs2 = new RecordSet();
        sql = "SELECT id FROM MainMenuInfo WHERE parentid=?";
        rs2.executeQuery(sql,infoid);
        if(rs2.next()) hasSubMenu=true;
        if(infoid==10005 || infoid==10006){// infoid(10005-建模引擎 10006-移动引擎)
	        if(!StringHelper.isEmpty(curTheme)&&!curTheme.equals("ecology8")){
	        	hasSubMenu=false;
	    	}
        }
        
        boolean _needRightToVisible = rs.getString("needRightToVisible").equals("1") ? true : false;
        boolean _needSwitchToVisible = rs.getString("needSwitchToVisible").equals("1") ? true : false;
        String _rightDetailToVisible = rs.getString("rightDetailToVisible");
        String _switchMethodNameToVisible = rs.getString("switchMethodNameToVisible");
        int _relatedModuleId = rs.getInt("relatedModuleId");
        String linkAddress = "";
        try {
            linkAddress = Util.replace(rs.getString("linkAddress"), "&", "&#38;", 0);
        } catch (Exception e) {
            
        }
        
    
        visibility = isDisplay(_needRightToVisible,_needSwitchToVisible,_rightDetailToVisible,_switchMethodNameToVisible,_relatedModuleId,user);
        if("hidden".equals(visibility)){
            continue;
        }else if("noright".equals(visibility)){
            bgindex++;
            if(hasSubMenu){
                StringBuffer sfcm = new StringBuffer();
                
                sfcm.append("<li>");
                 sfcm.append("<a class='lfMenuItem' href='");
                sfcm.append("javascript:void(0);");
                //sfcm.append("' style=\"background:url('").append(abgs[bgindex%4]).append("') no-repeat;\" ");
                sfcm.append("' _bgPosition='" + sbgPostions[bgindex%4] + "'");
                sfcm.append(" action='javascript:void(0);'");
                sfcm.append(" target=\"" + baseTarget + "\" >");
                sfcm.append("<div class=\"leftMenuItemLeft\" style=\"background-position: " + sbgPostions[bgindex%4] + ";\"></div>");
                sfcm.append("<div class=\"leftMenuItemCenter\"; style=\"\">");
				sfcm.append(text);
                sfcm.append("</div>");
                sfcm.append("<div class=\"leftMenuItemRight\" style=\"\"></div>");
               sfcm.append("<div style='width:4px;'></div></a>");
                String tempStr = getSettingMenu(user, String.valueOf(infoid),curTheme);
                sfcm.append("<ul></ul>".equals(tempStr) ? "" : tempStr);
                sfcm.append("</li>");
                s += sfcm.toString();
            }else{
                StringBuffer sfcm = new StringBuffer();
                sfcm.append("<li>");
                sfcm.append("<a class='lfMenuItem' href='");
                //sfcm.append("' style=\"background:url('").append(abgs[bgindex%4]).append("') no-repeat;\" ");
                sfcm.append("' _bgPosition='" + sbgPostions[bgindex%4] + "'");
                //sfcm.append(" action='noright'");
                sfcm.append(" target=\"" + baseTarget + "\" >");
                sfcm.append("<div class=\"leftMenuItemLeft\" style=\"background-position: " + sbgPostions[bgindex%4] + ";\"></div>");
                sfcm.append("<div class=\"leftMenuItemCenter\"; style=\"\">");
				    sfcm.append(text);
                sfcm.append("</div>");
                sfcm.append("<div class=\"leftMenuItemRight\" style=\"\"></div>");
            
                sfcm.append("<div style='width:4px;'></div></a>");
                sfcm.append("</li>");
                s += sfcm.toString();
            }
        }else{
            bgindex++;
            if(hasSubMenu){
                StringBuffer sfcm = new StringBuffer();
                sfcm.append("<li>");
                sfcm.append("<a class='lfMenuItem' href='");
                sfcm.append((linkAddress == null || "".equals(linkAddress)) ? "javascript:void(0);" : linkAddress);
                //sfcm.append("javascript:void(0);");
                //sfcm.append("' style=\"background:url('").append(abgs[bgindex%4]).append("') no-repeat;\" ");
                sfcm.append("' _bgPosition='" + sbgPostions[bgindex%4] + "'");
                //sfcm.append(" action='"+linkAddress+"'");
                sfcm.append(" target=\"" + baseTarget + "\" >");
                sfcm.append("<div class=\"leftMenuItemLeft\" style=\"background-position: " + sbgPostions[bgindex%4] + ";\"></div>");
                sfcm.append("<div class=\"leftMenuItemCenter\"; style=\"\">");
				 sfcm.append(text);
                sfcm.append("</div>");
                sfcm.append("<div class=\"leftMenuItemRight\" style=\"\"></div>");
            
                sfcm.append("<div style='width:4px;'></div></a>");
                String tempStr = getSettingMenu(user, String.valueOf(infoid),curTheme);
                sfcm.append("<ul></ul>".equals(tempStr) ? "" : tempStr);
                sfcm.append("</li>");
                s += sfcm.toString();
            }else{
                StringBuffer sfcm = new StringBuffer();
 				if(infoid==10005 || infoid==10006){//建模引擎、移动引擎
 					linkAddress = "/formmode/setup/ModeSettingMain.jsp?infoid="+infoid;
 					baseTarget = "_blank";
                }
 				
                sfcm.append("<li>");
                sfcm.append("<a class='lfMenuItem' href='");
                sfcm.append(linkAddress);
                //sfcm.append("' style=\"background:url('").append(abgs[bgindex%4]).append("') no-repeat;\" ");
                sfcm.append("' _bgPosition='" + sbgPostions[bgindex%4] + "'");
                //sfcm.append(" action='"+linkAddress+"'");
                sfcm.append(" target=\"" + baseTarget + "\" >");
                sfcm.append("<div class=\"leftMenuItemLeft\" style=\"background-position: " + sbgPostions[bgindex%4] + ";\"></div>");
                sfcm.append("<div class=\"leftMenuItemCenter\"; style=\"\">");
				sfcm.append(text);
                sfcm.append("</div>");
                sfcm.append("<div class=\"leftMenuItemRight\" style=\"\"></div>");
                
                sfcm.append("<div style='width:4px;'></div></a>");
                sfcm.append("</li>");
                s += sfcm.toString();
            }
        }
    }
    s += "</ul>";
    return s;
}
%>

<%!
//visibility: visible,noright,hidden
String visibility = "";

private String isDisplay(boolean needRightToVisible,boolean needSwitchToVisible,String rightDetailToVisible,String switchMethodNameToVisible,int relatedModuleId,User user){
    visibility = "visible";
    //通过开关控制可见
    if(needSwitchToVisible){
         try {
              Class cls = Class.forName("weaver.systeminfo.menuconfig.MenuSwitch");
              //some error here, modify by xiaofeng
              Method meth = cls.getMethod(switchMethodNameToVisible,new Class[]{User.class });

              MenuSwitch methobj = new MenuSwitch();
              Object retobj = meth.invoke(methobj,new Object[]{user});
              Boolean retval = (Boolean) retobj;
              boolean switchToVisible = retval.booleanValue();
              //visible = visible&&switchToVisible;
              if(!switchToVisible)
                visibility = "hidden";
         } catch (Throwable e) {
              System.err.println(e);
         }
    }
    //通过权限控制菜单可见
    if(needRightToVisible){
         ArrayList rightDetails = Util.TokenizerString(rightDetailToVisible,"&&");
         for(int a=0;a<rightDetails.size();a++){
              String rightDetail = (String)rightDetails.get(a);
              //visible = visible&&HrmUserVarify.checkUserRight(rightDetail,user);
              if(!HrmUserVarify.checkUserRight(rightDetail,user)){
                  break;
              }
         }
         visibility = "noright";
    }
    return visibility;
}
%>

<%!
private String getInfoCenterMenu(User user) {
    if(user == null) {
        return null;
    }
    String s = "<ul>";
  //---------------------------
    // 菜单项背景图片随机显示
    // bgcnt   : 左侧菜单背景图片个数
    // bgindex : 左侧菜单背景图片随机用下标
    // abgs    : 左侧菜单背景图片数组
    //---------------------------
    int bgcnt = 4;
    int bgindex = 4;
  
    String[] sbgPostions = new String[]{"0 -28", "0 -84", "0 0", "0 -56"};
    
    LeftMenuConfigHandler leftMenuConfigHandler = new LeftMenuConfigHandler();
    HashMap leftMenuConfigMapping = leftMenuConfigHandler.getLeftMenuConfig(user.getUID());
    ArrayList visibleSubLevelLeftMenus = (ArrayList)leftMenuConfigMapping.get(new Integer(111));

    if(visibleSubLevelLeftMenus!=null){
        for(int j=0; j<visibleSubLevelLeftMenus.size(); j++){
            LeftMenuConfig subConfig = (LeftMenuConfig)visibleSubLevelLeftMenus.get(j);
            LeftMenuInfo subInfo = subConfig.getLeftMenuInfo();
            int subLevelId = subInfo.getId();
            int subLabelId = subInfo.getLabelId();
            String subName = subInfo.getName(user.getLanguage());
            String iconUrl = subInfo.getIconUrl();
            String linkAddress = subInfo.getLinkAddress();
            if(linkAddress.indexOf("<")!=-1){
                linkAddress = Util.replaceRange(linkAddress,"<",">",String.valueOf(user.getUID()),false);
            }
            bgindex++;
            if(subLevelId==118){    //新闻公告
                StringBuffer sfcm = new StringBuffer();
                
                sfcm.append("<li>");
                sfcm.append("<a class='lfMenuItem' href='");
                sfcm.append(linkAddress);
                //sfcm.append("' style=\"background:url('").append(abgs[bgindex%4]).append("') no-repeat;\" ");
                sfcm.append("' _bgPosition='" + sbgPostions[bgindex%4] + "'");
                //sfcm.append(" action='javascript:void(0);'");
                sfcm.append(" target=\"" + "mainFrame" + "\" >");
                sfcm.append("<div class=\"leftMenuItemLeft\" style=\"background-position: " + sbgPostions[bgindex%4] + ";\"></div>");
                sfcm.append("<div class=\"leftMenuItemCenter\"; style=\"\">");
				 sfcm.append(subName);
                sfcm.append("</div>");
                sfcm.append("<div class=\"leftMenuItemRight\" style=\"\"></div>");
                sfcm.append("<div style='width:4px;'></div></a>");
                String result = getTypesMenu(user);
                sfcm.append("<ul></ul>".equals(result) ? "" : result);
                sfcm.append("</li>");
                s += sfcm.toString();
                
                //s += "<tree text=\""+subName+"\" action=\""+linkAddress+"\" icon=\""+iconUrl+"\" src=\"/LeftMenu/InfoCenterTreeTypes.jsp\" />";
            }else if(subLevelId==119){  //网上调查
                StringBuffer sfcm = new StringBuffer();
                
                sfcm.append("<li>");
                sfcm.append("<a class='lfMenuItem' href='");
                sfcm.append(linkAddress);
                //sfcm.append("' style=\"background:url('").append(abgs[bgindex%4]).append("') no-repeat;\" ");
                sfcm.append("' _bgPosition='" + sbgPostions[bgindex%4] + "'");
                //sfcm.append(" action='javascript:void(0);'");
                sfcm.append(" target=\"" + "mainFrame" + "\" >");
                sfcm.append("<div class=\"leftMenuItemLeft\" style=\"background-position: " + sbgPostions[bgindex%4] + ";\"></div>");
                sfcm.append("<div class=\"leftMenuItemCenter\"; style=\"\">");
				sfcm.append(subName);
				sfcm.append("</div>");
                sfcm.append("<div class=\"leftMenuItemRight\" style=\"\"></div>");
            
                sfcm.append("<div style='width:4px;'></div></a>");
                String result = getVotingMenu(user);
                sfcm.append("<ul></ul>".equals(result) ? "" : result);
                sfcm.append("</li>");
                s += sfcm.toString();
                //s += "<tree text=\""+subName+"\" action=\""+linkAddress+"\" icon=\""+iconUrl+"\" src=\"/LeftMenu/InfoCenterTreeVoting.jsp\" />";
            }else if(subLevelId==115){ //提醒信息(for xwj)
                StringBuffer sfcm = new StringBuffer();
                
                sfcm.append("<li>");
                sfcm.append("<a class='lfMenuItem' href='");
                sfcm.append(linkAddress);
                //sfcm.append("' style=\"background:url('").append(abgs[bgindex%4]).append("') no-repeat;\" ");
                sfcm.append("' _bgPosition='" + sbgPostions[bgindex%4] + "'");
                sfcm.append(" target=\"" + "mainFrame" + "\" >");
                sfcm.append("<div class=\"leftMenuItemLeft\" style=\"background-position: " + sbgPostions[bgindex%4] + ";\"></div>");
                sfcm.append("<div class=\"leftMenuItemCenter\"; style=\"\">");
				sfcm.append(subName);
                sfcm.append("</div>");
                sfcm.append("<div class=\"leftMenuItemRight\" style=\"\"></div>");
            
                sfcm.append("<div style='width:4px;'></div></a>");
                String result = getRemindMenu(user);
                sfcm.append("<ul></ul>".equals(result) ? "" : result);
                sfcm.append("</li>");
                s += sfcm.toString();
                //s += "<tree text=\""+subName+"\" action=\""+linkAddress+"\" icon=\""+iconUrl+"\" src=\"/LeftMenu/InfoCenterTreeRemind.jsp\" />";
            }else{
                s += "<tree text=\""+subName+"\" action=\""+linkAddress+"\" icon=\""+iconUrl+"\" />";
                StringBuffer sfcm = new StringBuffer();
                
                sfcm.append("<li>");
                sfcm.append("<a class='lfMenuItem' href='");
                sfcm.append(linkAddress);
                //sfcm.append("' style=\"background:url('").append(abgs[bgindex%4]).append("') no-repeat;\" ");
                sfcm.append("' _bgPosition='" + sbgPostions[bgindex%4] + "'");
                sfcm.append(" target=\"" + "mainFrame" + "\" >");
                sfcm.append("<div class=\"leftMenuItemLeft\" style=\"background-position: " + sbgPostions[bgindex%4] + ";\"></div>");
                sfcm.append("<div class=\"leftMenuItemCenter\"; style=\"\">");
				sfcm.append(subName);
				sfcm.append("</div>");
                sfcm.append("<div class=\"leftMenuItemRight\" style=\"\"></div>");
                sfcm.append("<div style='width:4px;'></div></a>");
                sfcm.append("</li>");
                s += sfcm.toString();
            }
        }
    }
    
    s += "</ul>";
    return s;
}
%>

<%!
private String getRemindMenu(User user) {
    if(user == null) {
        return null;
    }
    String s = "<ul>";

    int bgcnt = 4;
    int bgindex = 4;

    String[] sbgPostions = new String[]{"0 -28", "0 -84", "0 0", "0 -56"};
    
    RecordSet rs = new RecordSet();
    
    String sql="";
    int userid=user.getUID();
    int usertype= Util.getIntValue(user.getLogintype(),1)-1;   
    //Remind
    //sql = "select a.type, sum(a.counts) as count, (select statistic from SysPoppupinfo where type=a.type) as statistic, (select typedescription from SysPoppupinfo where type=a.type) as typedescription, (select link from SysPoppupinfo where type=a.type) as link from SysPoppupRemindInfoNew a where  a.userid="+userid+" group by a.type";
    if(rs.getDBType().equals("oracle")){
        sql = "select a.type, sum(a.counts) as count, (select statistic from SysPoppupinfo where type=a.type) as statistic, (select typedescription from SysPoppupinfo where type=a.type) as typedescription, (select link from SysPoppupinfo where type=a.type) as link from SysPoppupRemindInfoNew a where  a.userid=? and a.usertype=?  and ( (a.type=0 and a.requestid in (select requestid from workflow_currentoperator where userid=? and usertype=? and islasttimes=1 and isremark in ('0','1','8','9','7') ) )   or " +
                "(a.type=1 and a.requestid in (select requestid from workflow_currentoperator where userid=? and usertype=? and islasttimes=1 and exists (select 1 from workflow_requestbase where workflow_requestbase.requestid=workflow_currentoperator.requestid and currentnodetype=3) ) ) or " +
                "(a.type=14 and a.requestid in (select requestid from workflow_currentoperator where userid=? and usertype=? and islasttimes=1 and exists (select 1 from workflow_requestbase where workflow_requestbase.requestid=workflow_currentoperator.requestid) ) ) or " +
                "(type=10 and requestid in (select requestid from workflow_currentoperator where ((isremark='0' and (isprocessed='2' or isprocessed='3' or isprocessed is null))  or isremark='5') and islasttimes=1)) or " +
                "(a.type=9 and a.requestid in (select id from cowork_items t1 where t1.status=1  and (dbms_lob.instr(t1.coworkers,',?,',1,1)>0 or t1.creater=?) and dbms_lob.instr(t1.isnew,',?,',1,1)<=0)" +
                " or (a.type=12 and a.requestid in(select id from WorkPlan wp where ','||wp.resourceid||',' like '%,?,%'  )) " +
                ")   or type in (2,3,4,6,7,8,11,13)) group by a.type";
         rs.executeQuery(sql,userid,usertype,userid,usertype,userid,usertype,userid,usertype,userid,userid,userid,userid);
    } else {
        sql = "select a.type, sum(a.counts) as count, (select statistic from SysPoppupinfo where type=a.type) as statistic, (select typedescription from SysPoppupinfo where type=a.type) as typedescription, (select link from SysPoppupinfo where type=a.type) as link from SysPoppupRemindInfoNew a where  a.userid=? and a.usertype=?  and ( (a.type=0 and a.requestid in (select requestid from workflow_currentoperator where userid=? and usertype=? and islasttimes=1 and isremark in ('0','1','8','9','7') ) )   or " +
                "(a.type=1 and a.requestid in (select requestid from workflow_currentoperator where userid=? and usertype=? and islasttimes=1 and exists (select 1 from workflow_requestbase where workflow_requestbase.requestid=workflow_currentoperator.requestid and currentnodetype=3) ) ) or " +
                "(a.type=14 and a.requestid in (select requestid from workflow_currentoperator where userid=? and usertype=? and islasttimes=1 and exists (select 1 from workflow_requestbase where workflow_requestbase.requestid=workflow_currentoperator.requestid) ) ) or " +
                "(type=10 and requestid in (select requestid from workflow_currentoperator where ((isremark='0' and (isprocessed='2' or isprocessed='3' or isprocessed is null))  or isremark='5') and islasttimes=1)) or " +
                "(a.type=9 and a.requestid in (select id from cowork_items t1 where  t1.status=1 and (t1.coworkers like '%,?,%' or t1.creater=?) and t1.isnew not like '%,?,%')" +
                " or (a.type=12 and a.requestid in(select id from WorkPlan wp where ','+wp.resourceid+',' like '%,?,%'  )) " +
                ")   or type in (2,3,4,6,7,8,11,13)) group by a.type";
             rs.executeQuery(sql,userid,usertype,userid,usertype,userid,usertype,userid,usertype,userid,userid,userid,userid);
    }
   
    
    while(rs.next()){
    	bgindex++;
        if(rs.getString("statistic").equals("y")) {   
           int count=rs.getInt("count");
           StringBuffer sfcm = new StringBuffer();
           sfcm.append("<li>");
           sfcm.append("<a class='lfMenuItem' href='");
           sfcm.append(rs.getString("link"));
           //sfcm.append("' style=\"background:url('").append(abgs[bgindex%4]).append("') no-repeat;\"");
           sfcm.append("' _bgPosition='" + sbgPostions[bgindex%4] + "'");
           sfcm.append(" target=\"" + "mainFrame" + "\" >");
           sfcm.append("<div class=\"leftMenuItemLeft\" style=\"background-position: " + sbgPostions[bgindex%4] + ";\"></div>");
           sfcm.append("<div class=\"leftMenuItemCenter\"; style=\"\">");
		   sfcm.append(SystemEnv.getHtmlLabelName(rs.getInt("typedescription"),user.getLanguage())+"("+count+")");
		   sfcm.append("</div>");
           sfcm.append("<div class=\"leftMenuItemRight\" style=\"\"></div>");
           sfcm.append("<div style='width:4px;'></div></a>");
           sfcm.append("</li>");
           s += sfcm.toString();
        } else {
            StringBuffer sfcm = new StringBuffer();
            sfcm.append("<li>");
            sfcm.append("<a class='lfMenuItem' href='");
            sfcm.append(rs.getString("link"));
            //sfcm.append("' style=\"background:url('").append(abgs[bgindex%4]).append("') no-repeat;\"");
            sfcm.append("' _bgPosition='" + sbgPostions[bgindex%4] + "'");
            sfcm.append(" target=\"" + "mainFrame" + "\" >");
            sfcm.append("<div class=\"leftMenuItemLeft\" style=\"background-position: " + sbgPostions[bgindex%4] + ";\"></div>");
            sfcm.append("<div class=\"leftMenuItemCenter\"; style=\"\">");
			sfcm.append(SystemEnv.getHtmlLabelName(rs.getInt("typedescription"),user.getLanguage()));
			 sfcm.append("</div>");
            sfcm.append("<div class=\"leftMenuItemRight\" style=\"\"></div>");
            sfcm.append("<div style='width:4px;'></div></a>");
            sfcm.append("</li>");
            s += sfcm.toString();
            //s += "<tree text=\""+SystemEnv.getHtmlLabelName(rs.getInt("typedescription"),user.getLanguage())+"\" icon=\"/images_face/ecologyFace_2/LeftMenuIcon/level3_wev8.gif\" action=\""+rs.getString("link")+"\" />";
        }
    }
    s +="</ul>";
    return s;
}
%>

<%!
private String getVotingMenu(User user) {
    if(user == null) {
        return null;
    }
    String s = "<ul>";

    int bgcnt = 4;
    int bgindex = 4;

    String[] sbgPostions = new String[]{"0 -28", "0 -84", "0 0", "0 -56"};
    
    RecordSet rs = new RecordSet();
    Date newdate = new Date() ;
    long datetime = newdate.getTime() ;
    Timestamp timestamp = new Timestamp(datetime) ;
    String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
    String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16);
    
    String sql="";
    //Voting
    //sql = "SELECT DISTINCT t1.id,t1.subject FROM voting t1,VotingShareDetail t2 WHERE t1.id=t2.votingid AND t2.resourceid="+user.getUID()+" AND t1.status=1 AND t1.id NOT IN (SELECT DISTINCT votingid FROM votingresource WHERE resourceid="+user.getUID()+")"+" and t1.beginDate<='"+CurrentDate+"' and (t1.beginTime is null or t1.beginTime='' or t1.beginTime<='"+CurrentTime+"') ";

	sql="SELECT DISTINCT t1.id,t1.subject  from voting t1,VotingShareDetail t2 where t1.id=t2.votingid and t2.resourceid=? and t1.status=1 "+ " and t1.id not in (select distinct votingid from votingresource where resourceid =?)" 
+" and (t1.beginDate<'"+CurrentDate+"' or (t1.beginDate='"+CurrentDate+"' and (t1.beginTime is null or t1.beginTime='' or t1.beginTime<='"+CurrentTime+"'))) "; 
    rs.executeQuery(sql,user.getUID(),user.getUID());
    
    while(rs.next()){
    	bgindex++;
        StringBuffer sfcm = new StringBuffer();
        String menuname=rs.getString("subject");
        if(menuname.length()>9){
        	menuname =menuname.substring(0,9)+"...";
        }
        sfcm.append("<li>");
        sfcm.append("<a class='lfMenuItem' href=\"");
        sfcm.append("javascript:window.open('/voting/VotingPoll.jsp?votingid="+rs.getInt("id")+"', '','toolbar,resizable,scrollbars,dependent,height=600,width=800,top=0,left=100');void(0);");
        //sfcm.append("' style=\"background:url('").append(abgs[bgindex%4]).append("') no-repeat;\"");
        sfcm.append("\" _bgPosition='" + sbgPostions[bgindex%4] + "'");
        sfcm.append(">");
        sfcm.append("<div class=\"leftMenuItemLeft\" style=\"background-position: " + sbgPostions[bgindex%4] + ";\"></div>");
        sfcm.append("<div class=\"leftMenuItemCenter\"; style=\"\">");
		 sfcm.append(menuname);
		 sfcm.append("</div>");
        sfcm.append("<div class=\"leftMenuItemRight\" style=\"\"></div>");
        sfcm.append("<div style='width:4px;'></div></a>");
        sfcm.append("</li>");
        s += sfcm.toString();
    }
    s += "</ul>";
    return s;
}
%>


<%!
private String getTypesMenu(User user) {
    if(user == null) {
        return null;
    }
    String s = "<ul>";

    int bgcnt = 4;
    int bgindex = 4;
    String[] sbgPostions = new String[]{"0 -28", "0 -84", "0 0", "0 -56"};
    
    StringBuffer sfcm = null;
    RecordSet rs = new RecordSet();
    rs.executeSql("select * from newstype order by dspnum,id");
    while (rs.next()){
    	bgindex++;
        //sf.append("<tree text=\""+rs.getString("typename")+"\" action=\"javascript:void(0)\" src=\"/LeftMenu/InfoCenterTreeNews1.jsp?typeid="+rs.getString("id")+"\"></tree>");
        sfcm = new StringBuffer();
        sfcm.append("<li>");
        sfcm.append("<a class='lfMenuItem' href='");
        sfcm.append("javascript:void(0);");
        //sfcm.append("' style=\"background:url('").append(abgs[bgindex%4]).append("') no-repeat;\" ");
        sfcm.append("' _bgPosition='" + sbgPostions[bgindex%4] + "'");
        //sfcm.append(" action='javascript:void(0);'");
        sfcm.append(" target=\"" + "mainFrame" + "\" >");
        sfcm.append("<div class=\"leftMenuItemLeft\" style=\"background-position: " + sbgPostions[bgindex%4] + ";\"></div>");
        sfcm.append("<div class=\"leftMenuItemCenter\"; style=\"\">");
        sfcm.append(rs.getString("typename"));
		 sfcm.append("</div>");
        sfcm.append("<div class=\"leftMenuItemRight\" style=\"\"></div>");
        sfcm.append("<div style='width:4px;'></div></a>");
        sfcm.append(getNews1Menu(user, Integer.parseInt(rs.getString("id"))));
        sfcm.append("</li>");
        s += sfcm.toString();
        
    }
    bgindex++;
    //sf.append("<tree text=\""+SystemEnv.getHtmlLabelName(811,7)+"\" action=\"javascript:void(0)\" src=\"/LeftMenu/InfoCenterTreeNews1.jsp?typeid=0\"></tree>");
    sfcm = new StringBuffer();
    sfcm.append("<li>");
    sfcm.append("<a class='lfMenuItem' href='");
    sfcm.append("javascript:void(0);");
    //sfcm.append("' style=\"background:url('").append(abgs[bgindex%4]).append("') no-repeat;\" ");
    sfcm.append("' _bgPosition='" + sbgPostions[bgindex%4] + "'");
    //sfcm.append(" action='javascript:void(0);'");
    sfcm.append(" target=\"" + "mainFrame" + "\" >");
    sfcm.append("<div class=\"leftMenuItemLeft\" style=\"background-position: " + sbgPostions[bgindex%4] + ";\"></div>");
    sfcm.append("<div class=\"leftMenuItemCenter\"; style=\"\">");
	sfcm.append(SystemEnv.getHtmlLabelName(811,7));
	sfcm.append("</div>");
    sfcm.append("<div class=\"leftMenuItemRight\" style=\"\"></div>");
 
    sfcm.append("<div style='width:4px;'></div></a>");
    sfcm.append(getNews1Menu(user, 0));
    sfcm.append("</li>");
    s += sfcm.toString();

    s += "</ul>";
    
    return s;
}

private String getNews1Menu(User user, int typeid) {
    if(user == null) {
        return null;
    }
    String s = "<ul>";
  //---------------------------
    // 菜单项背景图片随机显示
    // bgcnt   : 左侧菜单背景图片个数
    // bgindex : 左侧菜单背景图片随机用下标
    // abgs    : 左侧菜单背景图片数组
    //---------------------------
    int bgcnt = 4;
    int bgindex = 4;
    
    String[] sbgPostions = new String[]{"0 -28", "0 -84", "0 0", "0 -56"};
    
    RecordSet rs = new RecordSet();
    String strSql="";
    if(typeid==0) {
        strSql="select id,frontpagename from DocFrontpage where isactive='1' and publishtype=1 and (newstypeid=0 or newstypeid is null) order by typeordernum,id";
        rs.executeQuery(strSql);
    } else {
        strSql="select  id,frontpagename from DocFrontpage where isactive='1' and publishtype=1 and newstypeid=? order by typeordernum,id";
        rs.executeQuery(strSql,typeid);
    }
    
    
    while (rs.next()){
    	bgindex++;
        StringBuffer sfcm = new StringBuffer();
        sfcm.append("<li>");
        sfcm.append("<a class='lfMenuItem' href='");
        sfcm.append("/docs/news/NewsDsp.jsp?id="+rs.getString("id"));
        //sfcm.append("' style=\"background:url('").append(abgs[bgindex%4]).append("') no-repeat;\" ");
        sfcm.append("' _bgPosition='" + sbgPostions[bgindex%4] + "'");
        sfcm.append(" target=\"" + "mainFrame" + "\" >");
        sfcm.append("<div class=\"leftMenuItemLeft\" style=\"background-position: " + sbgPostions[bgindex%4] + ";\"></div>");
        sfcm.append("<div class=\"leftMenuItemCenter\"; style=\"\">");
		sfcm.append(rs.getString("frontpagename"));
		sfcm.append("</div>");
        sfcm.append("<div class=\"leftMenuItemRight\" style=\"\"></div>");
   
        sfcm.append("<div style='width:4px;'></div></a>");
        sfcm.append("</li>");
        s += sfcm.toString();
    }
    s += "</ul>";
    return s;
}

private String getCurrWuiConfig(HttpSession session, User user, String keyword) throws Exception {
	
	if (keyword == null || "".equals(keyword)) {
		return "";
	}
	
	String curTheme = "";
	String curskin = "";

	
		String[] rtnValue = getHrmUserSetting(user);
		
		curTheme = rtnValue[0];
		curskin = rtnValue[1];
		if(curTheme.equals("")||curskin.equals("")){
			String templatetype = getCurrE8TemplateType(user);
			if("".equals(templatetype)){
				curTheme = "ecologyBasic";
				curskin = "default";
			}else if("ecology7".equals(templatetype)){
				curTheme ="ecology7";
				curskin = getCurrE8SkinInfo(user);
			}else{
				curTheme ="ecology8";
				curskin = "default";
			}
			
			
		}else{
			curTheme = rtnValue[0];
			curskin = rtnValue[1];
		}
		
		session.setAttribute("SESSION_CURRENT_THEME", curTheme);
		session.setAttribute("SESSION_CURRENT_SKIN", curskin);
	
	if ("THEME".equals(keyword.toUpperCase())) {
		return curTheme;
	}
	
	if ("SKIN".equals(keyword.toUpperCase())) {
		return curskin;
	}
	return "";
}

private String getCurrE8TemplateType(User user){
	weaver.conn.RecordSet rs = new weaver.conn.RecordSet();
	weaver.systeminfo.template.UserTemplate  userTemplate = new weaver.systeminfo.template.UserTemplate();
	userTemplate.getTemplateByUID(user.getUID(),user.getUserSubCompany1());
	
	
	String skin =  userTemplate.getTemplatetype();
	
	
	return skin;
	
}

private String getCurrE8SkinInfo(User user){
	weaver.conn.RecordSet rs = new weaver.conn.RecordSet();
	weaver.systeminfo.template.UserTemplate  userTemplate = new weaver.systeminfo.template.UserTemplate();
	userTemplate.getTemplateByUID(user.getUID(),user.getUserSubCompany1());
	
	
	String skin =  userTemplate.getSkin();
	
	
	return skin;
	
}

private String[] getHrmUserSetting(User user) throws Exception {
	weaver.conn.RecordSet rs = new weaver.conn.RecordSet();

	String[] result = new String[2];
	String theme = "";
	String skin = "";
	
	String sql="select templateid from SystemTemplateSubComp where subcompanyid=?";
	rs.executeQuery(sql,user.getUserSubCompany1());
	if(rs.next()){	
		String curUserCanUse = rs.getString("templateid");
		sql = "SELECT b.* FROM SystemTemplateUser a, SystemTemplate  b WHERE a.userid=? AND a.templateId=b.id  and  b.id=?";
		rs.executeQuery(sql,user.getUID(),curUserCanUse);
		if(rs.next()){
			theme = rs.getString("templatetype");
			skin = rs.getString("skin");
			result[0] = theme;
			result[1] = skin;
			return result;
		}
	}
	
	

	
	int userid = user.getUID();
	rs.executeQuery("select theme, skin from HrmUserSetting where resourceId=?",userid);
	
	if (rs.next()) {
		theme = rs.getString("theme");
		skin = rs.getString("skin");
	}
	
	//rs.executeSql("select * from extandHpThemeItem where extandHpThemeId=" + sqltemplateid1 + " and isopen=1 and theme='" + theme + "' and skin='" + skin + "'");
	result[0] = theme;
	result[1] = skin;
	
	
	
	//System.out.println("result"+result[0]+result[1]);
	return result;
}
%>
