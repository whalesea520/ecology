
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


 initCommonMenu(user);

 result = getCommonMenu(user, parentid); 

 

out.print(result);
%>


<%!

private void initCommonMenu(User user){

	RecordSet rs = new RecordSet();
	RecordSet rs1 = new RecordSet();
	int userid = user.getUID();
	rs.execute("select count(*) as num from UserCommonMenu where userid ="+userid);
	rs.next();
	if(rs.getInt("num")==0){
		rs.execute("select count(*) as num from UserCommonMenuInit where userid ="+user.getUID());
		rs.next();
		if(rs.getInt("num")==0){
			rs1.execute("insert into UserCommonMenu(userid,menuid) values ("+userid+",0)");
			rs1.execute("insert into UserCommonMenu(userid,menuid) values ("+userid+",2)");
			rs1.execute("insert into UserCommonMenu(userid,menuid) values ("+userid+",16)");
			rs1.execute("insert into UserCommonMenu(userid,menuid) values ("+userid+",1)");
			rs1.execute("insert into UserCommonMenu(userid,menuid) values ("+userid+",12)");
			rs1.execute("insert into UserCommonMenu(userid,menuid) values ("+userid+",6)");
			rs1.execute("insert into UserCommonMenu(userid,menuid) values ("+userid+",573)");
			rs1.execute("insert into UserCommonMenu(userid,menuid) values ("+userid+",140)");
			rs1.execute("insert into UserCommonMenu(userid,menuid) values ("+userid+",60)");
			
			rs1.execute("insert into UserCommonMenuInit(userid) values ("+userid+")");
		}
	}
	
}
private String getCommonMenu(User user, String parentid) {
    if(user == null) {
        return null;
    }
    String s = "";
  //---------------------------
    // 菜单项背景图片随机显示
    // bgcnt   : 左侧菜单背景图片个数
    // bgindex : 左侧菜单背景图片随机用下标
    // abgs    : 左侧菜单背景图片数组

    

    //parentid=Util.null2String(request.getParameter("parentid"));
    
    MenuUtil mu=new MenuUtil("left", 3,user.getUID(),user.getLanguage()) ;
    //===============================================
  	mu.setUser(user);
    RecordSet rs=mu.getCommonMenuRs(user.getUID());
    while(rs.next()){
        int infoid=rs.getInt("infoid");
        
     
        int labelId = rs.getInt("labelId");
        
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
      
        
        String linkAddress = "";
        String iconUrl = "";
        try {
            linkAddress = Util.replace(rs.getString("linkAddress"), "&", "&#38;", 0);
        } catch (Exception e) {
            
        }
        if(linkAddress.trim().equals("")){
        	continue;
        }
        iconUrl = rs.getString("iconUrl");
        s+="<li url='"+linkAddress+"' target='"+baseTarget+"'><em class='icon'>&nbsp;</em><span title='"+text+"' class='menuname'>"+text+"</span> <em class='closemenu' menuid='"+infoid+"'>&nbsp;</em></li>";
        
    }
   // s+="<li class='addMenu'>+"+SystemEnv.getHtmlLabelName(611,user.getLanguage())+"</li>";
    
  
    return s;
	
}
%>

