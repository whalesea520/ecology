
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.conn.RecordSet"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.general.TimeUtil"%>
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rslayout" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="hpu" class="weaver.page.PageUtil" scope="page"/>
<jsp:useBean id="pc" class="weaver.page.PageCominfo" scope="page"/>
<jsp:useBean id="hpec" class="weaver.homepage.cominfo.HomepageElementCominfo" scope="page"/>
<jsp:useBean id="SpopForHomepage" class="weaver.splitepage.operate.SpopForHomepage" scope="page"/>
<jsp:useBean id="log" class="weaver.admincenter.homepage.PortalMaintenanceLog" scope="page" />
<%
	

/*用户验证*/
User user = HrmUserVarify.getUser (request , response) ;
if(user==null) {
    response.sendRedirect("/login/Login.jsp");
    return;
}
//门户编辑权限验证
if(!HrmUserVarify.checkUserRight("homepage:Maint", user)){
    response.sendRedirect("/notice/noright.jsp");
    return;
}

		String subCompanyId = "1";
		//String srchpid = Util.null2String(request.getParameter("srchpid"));
		String infoname = Util.null2String(request.getParameter("infoname"));
		String infodesc = infoname;//Util.null2String(request.getParameter("infodesc"));
		String isuse = "0";
		String islocked = "0";
		String styleid = "1413740040168";
		String layoutid = "2";
		String txtLayoutFlag = "A,B";
		String menuStyleid = "1";
		Map<String, String> txtAreas = new HashMap<String, String>();
		txtAreas.put("A", "50");
		txtAreas.put("B", "50");
		//txtAreas.put("C", "50");
		//txtAreas.put("D", "50");
		
		//System.out.println("infoname=" + infoname);
		int userid = user.getUID();
		String date = new SimpleDateFormat("yyyy-MM-dd").format(new Date()).toString();
		String time = new SimpleDateFormat("HH:mm:ss").format(new Date()).toString();
		String creatortype = (Util.getIntValue(user.getLogintype()) - 1) + "";
		String creatorid = userid + "";
		//int creatorid=hpu.getHpUserId(hpid,""+subCompanyId,user);
		
        //int creatorid=subCompanyId;
        //int creatortype=3;
        isuse = "".equals(isuse)?"0":isuse;
		islocked = "".equals(islocked)?"0":islocked;
	
        //插入主页信息
        rs.executeSql("insert into hpinfo (infoname,infodesc,styleid,layoutid,subcompanyid,isuse,islocked,creatortype,creatorid,hpcreatorid,menuStyleid) values( '"+infoname+"','"+infodesc+"','"+styleid+"',"+layoutid+","+subCompanyId+",'"+isuse+"','"+islocked+"','"+creatortype+"',"+creatorid+","+userid+",'"+menuStyleid+"')");
        log.setItem("PortalPage");
    	log.setType("insert");
    	log.setSql("insert into hpinfo (infoname,infodesc,styleid,layoutid,subcompanyid,isuse,islocked,creatortype,creatorid,hpcreatorid) values( '"+infoname+"','"+infodesc+"','"+styleid+"',"+layoutid+","+subCompanyId+",'"+isuse+"','"+islocked+"','"+creatortype+"',"+creatorid+","+userid+")");
    	log.setDesc("新建门户页面");
    	log.setUserid(user.getUID()+"");
    	log.setIp(request.getRemoteAddr());
    	log.setOpdate(TimeUtil.getCurrentDateString());
    	log.setOptime(TimeUtil.getOnlyCurrentTimeString());
    	log.savePortalOperationLog();
		int maxHpid=hpu.getMaxHpinfoid();
		rs.executeSql("update hpinfo set ordernum='"+maxHpid+"',hplastdate='"+date+"',hplasttime='"+time+"',pid=0,ordernum1='"+maxHpid+"' where id="+maxHpid);
        log.setItem("PortalPage");
    	log.setType("update");
    	log.setSql("update hpinfo set ordernum='"+maxHpid+"',hplastdate='"+date+"',hplasttime='"+time+"',pid=0,ordernum1='"+maxHpid+"' where id="+maxHpid);
    	log.setDesc("修改门户页面信息");
    	log.setUserid(user.getUID()+"");
    	log.setIp(request.getRemoteAddr());
    	log.setOpdate(TimeUtil.getCurrentDateString());
    	log.setOptime(TimeUtil.getOnlyCurrentTimeString());
    	log.savePortalOperationLog();
     
        if(pc.isHaveThisHp(""+maxHpid))  
			pc.updateHpCache(""+maxHpid);
        else 
        	pc.addHpCache(""+maxHpid);

		//插入布局信息
		ArrayList pageFlagList=Util.TokenizerString(txtLayoutFlag,",");
		
		//先改值
		for(int i=0;i<pageFlagList.size();i++)
		{
			String pageFlag=(String)pageFlagList.get(i);
			String pageFlagSize=txtAreas.get(pageFlag);//Util.null2String(request.getParameter("txtArea_"+pageFlag));

			String strSql="insert into hplayout(hpid,layoutbaseid,areaflag,areasize,areaElements,userid,usertype) values ("+maxHpid+","+layoutid+",'"+pageFlag+"','"+pageFlagSize+"','',"+creatorid+","+creatortype+")";
			//System.out.println("=========="+strSql);
			rslayout.executeSql(strSql);
	        log.setItem("PortalPage");
	    	log.setType("insert");
	    	log.setSql(strSql);
	    	log.setDesc("插入布局信息");
	    	log.setUserid(user.getUID()+"");
	    	log.setIp(request.getRemoteAddr());
	    	log.setOpdate(TimeUtil.getCurrentDateString());
	    	log.setOptime(TimeUtil.getOnlyCurrentTimeString());
	    	log.savePortalOperationLog();
		}
		//String strSql="insert into hplayout (hpid,layoutbaseid,areaflag,areasize,userid,usertype) " +
        //        "select  "+maxHpid+",layoutbaseid,areaflag,areasize,"+creatorid+"," +
        //        ""+creatortype+" from hplayout where hpid="+srchpid+" " +
        //        "and userid="+srchpCreatorId+" and usertype="+srchpCreatorType;

		//System.out.println(strSql);

        //rs.executeSql(strSql);

        /*插入共享信息*/
		String strShareSql="insert into shareinnerhp(hpid,type,content,seclevel,sharelevel,seclevelmax) values ("+maxHpid+",6,"+subCompanyId+",0,0,100)";
		rs.executeSql(strShareSql);
        log.setItem("PortalPage");
    	log.setType("insert");
    	log.setSql(strShareSql);
    	log.setDesc("插入共享信息");
    	log.setUserid(user.getUID()+"");
    	log.setIp(request.getRemoteAddr());
    	log.setOpdate(TimeUtil.getCurrentDateString());
    	log.setOptime(TimeUtil.getOnlyCurrentTimeString());
    	log.savePortalOperationLog();

		//out.println(maxHpid);
        //response.sendRedirect("HomepageConfig.jsp?hpid="+maxHpid);
		//response.sendRedirect("/homepage/maint/HomepagePageEdit.jsp?method=savebase&hpid="+maxHpid+"&subCompanyId="+subCompanyId);
		
		response.getWriter().write("1");
%>  
