
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

<%


String result = "";

String parentid = Util.null2String(request.getParameter("parentid"));
String typeid = Util.null2String(request.getParameter("typeid"));

User user = HrmUserVarify.getUser (request , response) ;

if(user == null) {
    return;
}

if ("111".equals(typeid)) {
    result = getInfoCenterMenu(user);
} else {
    result = getSettingMenu(user, parentid); 
}
 

out.print(result);
%>


<%!
private String getSettingMenu(User user, String parentid) {
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
    
    String sql="";
    String visibility="";
    //parentid=Util.null2String(request.getParameter("parentid"));
    
    MenuUtil mu=new MenuUtil("top", 3,user.getUID(),user.getLanguage()) ;
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
    mu.setUser(user);
    RecordSet rs=mu.getMenuRsWithShareRight(Util.getIntValue(parentid,0));
    while(rs.next()){
        boolean hasSubMenu = false;
        
        int infoid=rs.getInt("infoid");
        int needResourcetype=rs.getInt("resourcetype");
		int needResourceid=rs.getInt("resourceid");
		//if(!mu.hasShareRight(infoid,needResourceid,needResourcetype)){
			//continue;
		//}
        
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
        
        boolean _needRightToVisible = rs.getString("needRightToVisible").equals("1") ? true : false;
        boolean _needSwitchToVisible = rs.getString("needSwitchToVisible").equals("1") ? true : false;
        String _rightDetailToVisible = rs.getString("rightDetailToVisible");
        String _switchMethodNameToVisible = rs.getString("switchMethodNameToVisible");
        int _relatedModuleId = rs.getInt("relatedModuleId");
        String linkAddress = "";
        String iconUrl = "";
        try {
            linkAddress = Util.replace(rs.getString("linkAddress"), "&", "&#38;", 0);
        } catch (Exception e) {
            
        }
        
        iconUrl = rs.getString("iconUrl");
        
    
        visibility = isDisplay(_needRightToVisible,_needSwitchToVisible,_rightDetailToVisible,_switchMethodNameToVisible,_relatedModuleId,user);
        
        if("hidden".equals(visibility)){
            continue;
        }else if("noright".equals(visibility)){
            bgindex++;
            if(hasSubMenu){
                StringBuffer sfcm = new StringBuffer();
                
                //sfcm.append("<li><div   style='width:100%;'>");
                sfcm.append("<li><div>");
                 sfcm.append("<a class='lfMenuItem' href='");
                sfcm.append("javascript:void(0);");
                //sfcm.append("' style=\"background:url('").append(abgs[bgindex%4]).append("') no-repeat;\" ");
                sfcm.append("' _bgPosition='" + sbgPostions[bgindex%4] + "'");
                sfcm.append(" action='javascript:void(0);'");
                sfcm.append(" target=\"" + baseTarget + "\" >");
                sfcm.append("<div class=\"leftMenuItemLeft\" style=\"background-position: " + sbgPostions[bgindex%4] + ";\"></div>");
                sfcm.append("<div class=\"leftMenuItemCenter\"; style=\"\">");
				sfcm.append(text);
				 sfcm.append("<span style='display:none;' class='iconImage'>")
				 	.append(iconUrl).append("</span>");
				sfcm.append("<span class='e8_number' id='num_"+infoid+"'></span>");
                sfcm.append("</div>");
               // sfcm.append("<div class=\"leftMenuItemRight\" style=\"\"></div>");
               sfcm.append("<div style='width:4px;'></div></a></div>");
                String tempStr = getSettingMenu(user, String.valueOf(infoid));
                sfcm.append("<ul></ul>".equals(tempStr) ? "" : tempStr);
                sfcm.append("</li>");
                s += sfcm.toString();
            }else{
                StringBuffer sfcm = new StringBuffer();
                //sfcm.append("<li><div   style='width:100%;'>");
                sfcm.append("<li><div>");
                sfcm.append("<a class='lfMenuItem' href='");
                //sfcm.append("' style=\"background:url('").append(abgs[bgindex%4]).append("') no-repeat;\" ");
                sfcm.append("' _bgPosition='" + sbgPostions[bgindex%4] + "'");
                //sfcm.append(" action='noright'");
                sfcm.append(" target=\"" + baseTarget + "\" >");
                sfcm.append("<div class=\"leftMenuItemLeft\" style=\"background-position: " + sbgPostions[bgindex%4] + ";\"></div>");
                sfcm.append("<div class=\"leftMenuItemCenter\"; style=\"\">");
				    sfcm.append(text);
					sfcm.append("<span class='e8_number' id='num_"+infoid+"'></span>");
                sfcm.append("</div>");
                //sfcm.append("<div class=\"leftMenuItemRight\" style=\"\"></div>");
            
                sfcm.append("<div style='width:4px;'></div></a></div>");
                sfcm.append("</li>");
                s += sfcm.toString();
            }
        }else{
            bgindex++;
            if(hasSubMenu){
                StringBuffer sfcm = new StringBuffer();
                //sfcm.append("<li><div  style='width:100%;'>");
                sfcm.append("<li><div>");
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
				  sfcm.append("<span style='display:none;' class='iconImage'>")
				 	.append(iconUrl).append("</span>");
				 sfcm.append("<span class='e8_number' id='num_"+infoid+"'></span>");
                sfcm.append("</div>");
               // sfcm.append("<div class=\"leftMenuItemRight\" style=\"\"></div>");
            
                sfcm.append("<div style='width:4px;display:none;'></div></a></div>");
                String tempStr = getSettingMenu(user, String.valueOf(infoid));
                sfcm.append("<ul></ul>".equals(tempStr) ? "" : tempStr);
                sfcm.append("</li>");
                s += sfcm.toString();
            }else{
                StringBuffer sfcm = new StringBuffer();
                
                //sfcm.append("<li><div  style='width:100%;'>");
                sfcm.append("<li><div>");
                sfcm.append("<a class='lfMenuItem' href='");
                sfcm.append(linkAddress);
                //sfcm.append("' style=\"background:url('").append(abgs[bgindex%4]).append("') no-repeat;\" ");
                sfcm.append("' _bgPosition='" + sbgPostions[bgindex%4] + "'");
                //sfcm.append(" action='"+linkAddress+"'");
                sfcm.append(" target=\"" + baseTarget + "\" >");
                sfcm.append("<div class=\"leftMenuItemLeft\" style=\"background-position: " + sbgPostions[bgindex%4] + ";\"></div>");
                sfcm.append("<div class=\"leftMenuItemCenter\"; style=\"\">");
				 sfcm.append(text);
				 sfcm.append("<span style='display:none;' class='iconImage'>")
				 	.append(iconUrl).append("</span>");
				 sfcm.append("<span class='e8_number' id='num_"+infoid+"'></span>");
                sfcm.append("</div>");
                //sfcm.append("<div class=\"leftMenuItemRight\" style=\"\"></div>");
                
                sfcm.append("<div style='width:4px;display:none;'></div></a>");
                sfcm.append("</div></li>");
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
              //System.err.println(e);
			  e.printStackTrace();
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
                
                //sfcm.append("<li><div   style='width:100%;'>");
                sfcm.append("<li><div>");
                sfcm.append("<a class='lfMenuItem' href='");
                sfcm.append(linkAddress);
                //sfcm.append("' style=\"background:url('").append(abgs[bgindex%4]).append("') no-repeat;\" ");
                sfcm.append("' _bgPosition='" + sbgPostions[bgindex%4] + "'");
                //sfcm.append(" action='javascript:void(0);'");
                sfcm.append(" target=\"" + "mainFrame" + "\" >");
                sfcm.append("<div class=\"leftMenuItemLeft\" style=\"background-position: " + sbgPostions[bgindex%4] + ";\"></div>");
                sfcm.append("<div class=\"leftMenuItemCenter\"; style=\"\">");
				 sfcm.append(subName);
				 sfcm.append("<span style='display:none;' class='iconImage'>")
				 	.append(iconUrl).append("</span>");
				 sfcm.append("<span  class='e8_number' id='num_"+subLevelId+"'></span>");
                sfcm.append("</div>");
                sfcm.append("<div class=\"leftMenuItemRight\" style=\"\"></div>");
                sfcm.append("<div style='width:4px; display:none;'></div></a></div>");
                String result = getTypesMenu(user);
                sfcm.append("<ul></ul>".equals(result) ? "" : result);
                sfcm.append("</li>");
                s += sfcm.toString();
                
                //s += "<tree text=\""+subName+"\" action=\""+linkAddress+"\" icon=\""+iconUrl+"\" src=\"/LeftMenu/InfoCenterTreeTypes.jsp\" />";
            }else if(subLevelId==119){}else if(subLevelId==115){}else{}
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
        sql = "select a.type, sum(a.counts) as count, (select statistic from SysPoppupinfo where type=a.type) as statistic, (select typedescription from SysPoppupinfo where type=a.type) as typedescription, (select link from SysPoppupinfo where type=a.type) as link from SysPoppupRemindInfoNew a where  a.userid=? and a.usertype=?  and ( (a.type=0 and a.requestid in (select requestid from workflow_currentoperator where userid=? and usertype=? and islasttimes=1 and isremark in ('0','1','8','9','7') ) )   or (a.type=1 and a.requestid in (select requestid from workflow_currentoperator where userid=? and usertype=? and islasttimes=1 and exists (select 1 from workflow_requestbase where workflow_requestbase.requestid=workflow_currentoperator.requestid and currentnodetype=3) ) ) or (a.type=14 and a.requestid in (select requestid from workflow_currentoperator where userid=? and usertype=? and islasttimes=1 and exists (select 1 from workflow_requestbase where workflow_requestbase.requestid=workflow_currentoperator.requestid) ) ) or (type=10 and requestid in (select requestid from workflow_currentoperator where ((isremark='0' and (isprocessed='2' or isprocessed='3' or isprocessed is null))  or isremark='5') and userid=? AND usertype=? and islasttimes=1)) or (a.type=9 and a.requestid in (select id from cowork_items t1 where t1.status=1  and (dbms_lob.instr(t1.coworkers,',?,',1,1)>0 or t1.creater=?) and dbms_lob.instr(t1.isnew,',?,',1,1)<=0))   or type in (2,3,4,6,7,8,11,12,13)) group by a.type";
        rs.executeQuery(sql,userid,usertype,userid,usertype,userid,usertype,userid,usertype,userid,usertype,userid,userid,userid);
    } else {
        sql = "select a.type, sum(a.counts) as count, (select statistic from SysPoppupinfo where type=a.type) as statistic, (select typedescription from SysPoppupinfo where type=a.type) as typedescription, (select link from SysPoppupinfo where type=a.type) as link from SysPoppupRemindInfoNew a where  a.userid=? and a.usertype=?  and ( (a.type=0 and a.requestid in (select requestid from workflow_currentoperator where userid=? and usertype=? and islasttimes=1 and isremark in ('0','1','8','9','7') ) )   or (a.type=1 and a.requestid in (select requestid from workflow_currentoperator where userid=? and usertype=? and islasttimes=1 and exists (select 1 from workflow_requestbase where workflow_requestbase.requestid=workflow_currentoperator.requestid and currentnodetype=3) ) ) or (a.type=14 and a.requestid in (select requestid from workflow_currentoperator where userid=? and usertype=? and islasttimes=1 and exists (select 1 from workflow_requestbase where workflow_requestbase.requestid=workflow_currentoperator.requestid) ) ) or (type=10 and requestid in (select requestid from workflow_currentoperator where ((isremark='0' and (isprocessed='2' or isprocessed='3' or isprocessed is null))  or isremark='5') and userid=? AND usertype=? and islasttimes=1)) or (a.type=9 and a.requestid in (select id from cowork_items t1 where  t1.status=1 and (t1.coworkers like '%,?,%' or t1.creater=?) and t1.isnew not like '%,?,%'))   or type in (2,3,4,6,7,8,11,12,13)) group by a.type";
        rs.executeQuery(sql,userid,usertype,userid,usertype,userid,usertype,userid,usertype,userid,usertype,userid,userid,userid);
    }
   
    
    while(rs.next()){
    	bgindex++;
        if(rs.getString("statistic").equals("y")) {   
           int count=rs.getInt("count");
           StringBuffer sfcm = new StringBuffer();
           //sfcm.append("<li><div   style='width:100%;'>");
           sfcm.append("<li><div>");
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
           sfcm.append("<div style='width:4px;display:none;'></div></a></div>");
           sfcm.append("</li>");
           s += sfcm.toString();
        } else {
            StringBuffer sfcm = new StringBuffer();
             //sfcm.append("<li><div   style='width:100%;'>");
             sfcm.append("<li><div>");
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
            sfcm.append("<div style='width:4px;display:none;'></div></a></div>");
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
    sql = "SELECT DISTINCT t1.id,t1.subject FROM voting t1,VotingShareDetail t2 WHERE t1.id=t2.votingid AND t2.resourceid="+user.getUID()+" AND t1.status=1 AND t1.id NOT IN (SELECT DISTINCT votingid FROM votingresource WHERE resourceid="+user.getUID()+")"+" and t1.beginDate<='"+CurrentDate+"' and (t1.beginTime is null or t1.beginTime='' or t1.beginTime<='"+CurrentTime+"') ";
    rs.executeSql(sql);
    
    while(rs.next()){
    	bgindex++;
        StringBuffer sfcm = new StringBuffer();
        String menuname=rs.getString("subject");
        if(menuname.length()>9){
        	menuname =menuname.substring(0,9)+"...";
        }
       //sfcm.append("<li><div   style='width:100%;'>");
       sfcm.append("<li><div>");
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
        sfcm.append("<div style='width:4px;display:none;'></div></a></div>");
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
       //sfcm.append("<li><div   style='width:100%;'>");
       sfcm.append("<li><div>");
        sfcm.append("<a class='lfMenuItem' href='");
        sfcm.append("javascript:void(0);");
        //sfcm.append("' style=\"background:url('").append(abgs[bgindex%4]).append("') no-repeat;\" ");
        sfcm.append("' _bgPosition='" + sbgPostions[bgindex%4] + "'");
        //sfcm.append(" action='javascript:void(0);'");
        sfcm.append(" target=\"" + "mainFrame" + "\" >");
        //sfcm.append("<div class=\"leftMenuItemLeft\" style=\"background-position: " + sbgPostions[bgindex%4] + ";\"></div>");
        sfcm.append("<div class=\"leftMenuItemCenter\" style=\"\">");
        sfcm.append(rs.getString("typename"));
		 sfcm.append("</div>");
        sfcm.append("<div class=\"leftMenuItemRight\" style=\"\"></div>");
       sfcm.append("<div style='width:4px;display:none;'></div></a></div>");
        sfcm.append(getNews1Menu(user, Integer.parseInt(rs.getString("id"))));
        sfcm.append("</li>");
        s += sfcm.toString();
        
    }
    bgindex++;
    //sf.append("<tree text=\""+SystemEnv.getHtmlLabelName(811,7)+"\" action=\"javascript:void(0)\" src=\"/LeftMenu/InfoCenterTreeNews1.jsp?typeid=0\"></tree>");
    sfcm = new StringBuffer();
    //sfcm.append("<li><div   style='width:100%;'>");
    sfcm.append("<li><div>");
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
 
   sfcm.append("<div style='width:4px;display:none;'></div></a></div>");
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
        //sfcm.append("<li><div   style='width:100%;'>");
        sfcm.append("<li><div>");
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
   
        sfcm.append("<div style='width:4px;display:none;'></div></a></div>");
        sfcm.append("</li>");
        s += sfcm.toString();
    }
    s += "</ul>";
    return s;
}
%>
