
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
<%@ page import="java.util.ArrayList" %>

<%@ page import="weaver.general.*" %>
<%@ page import="weaver.systeminfo.menuconfig.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="java.lang.reflect.Method" %>

<%
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;

String result = "";

String mid = Util.null2String(request.getParameter("mid"));

weaver.conn.RecordSet sltRs = new weaver.conn.RecordSet();
weaver.conn.RecordSet rs = new weaver.conn.RecordSet();

//菜单id
String[] needInitMenus = new String[]{"1", "2", "80"};
//菜单对应初始化点击的次数
int[] needInitCnts = new int[]{8, 9, 10};

long clickCnt = 0;
if (!"".equals(mid)) {
	sltRs.executeSql("SELECT id, clickCnt FROM HrmUserMenuStatictics WHERE userid=" + user.getUID() + " and menuId=" + mid);
	if (sltRs.next()) {
		clickCnt = Long.parseLong(sltRs.getString("clickCnt"));
		clickCnt++;
		rs.executeSql("UPDATE HrmUserMenuStatictics SET clickCnt=" + clickCnt + " WHERE userid=" + user.getUID() + " and menuId=" + mid);
	} else {
		//initClickCnt(user, needInitMenus, needInitCnts);
		int istflg = -1;
		for (int i=0; i<needInitMenus.length; i++) {
			if (mid.equals(needInitMenus[i])) {
				istflg = i;
				break;
			}
		}
		if (istflg == -1) {
			rs.executeSql("INSERT INTO HrmUserMenuStatictics(userid, menuId, clickCnt) VALUES(" + user.getUID() + " , " + mid + ", 1)");
		} else {
			rs.executeSql("INSERT INTO HrmUserMenuStatictics(userid, menuId, clickCnt) VALUES(" + user.getUID() + " , " + mid + ", " + needInitCnts[istflg] +")");
		}
	}
	out.print("0");
} else {
	out.print("-1");
}
%>

