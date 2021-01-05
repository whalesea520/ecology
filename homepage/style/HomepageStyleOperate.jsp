
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.file.FileUpload" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="hpsu" class="weaver.homepage.style.HomepageStyleUtil" scope="page"/>
<jsp:useBean id="hpsc" class="weaver.homepage.cominfo.HomepageStyleCominfo" scope="page"/>
<jsp:useBean id="hpc" class="weaver.homepage.cominfo.HomepageCominfo" scope="page"/>
<%
	FileUpload fu = new FileUpload(request,false,"images/homepage/others");
	String styleid = Util.null2String(fu.getParameter("styleid"));	
	String stylename = Util.null2String(fu.getParameter("stylename"));	
	String styledesc = Util.null2String(fu.getParameter("styledesc"));		
	String hpbgcolor = Util.null2String(fu.getParameter("hpbgcolor"));		
	String etitlebgcolor = Util.null2String(fu.getParameter("etitlebgcolor"));	
	String ebgcolor = Util.null2String(fu.getParameter("ebgcolor"));	
	String etitlecolor = Util.null2String(fu.getParameter("etitlecolor"));
	String ecolor = Util.null2String(fu.getParameter("ecolor"));	
	String ebordercolor = Util.null2String(fu.getParameter("ebordercolor"));	
	String edatemode = Util.null2String(fu.getParameter("edatemode"));	
	String etimemode = Util.null2String(fu.getParameter("etimemode"));	

	String navbgcolor= Util.null2String(fu.getParameter("navbgcolor"));
	String navcolor= Util.null2String(fu.getParameter("navcolor"));
	String navselectedbgcolor= Util.null2String(fu.getParameter("navselectedbgcolor"));
	String navselectedcolor= Util.null2String(fu.getParameter("navselectedcolor"));
	String navbordercolor= Util.null2String(fu.getParameter("navbordercolor"));
	String mimgshowmode= Util.null2String(fu.getParameter("mimgshowmode"));

	
	String hpbgimg = Util.null2String(fu.uploadFiles("hpbgimg"));
	String etitlebgimg = Util.null2String(fu.uploadFiles("etitlebgimg"));
	String ebgimg = Util.null2String(fu.uploadFiles("ebgimg"));
	String elockimg1 = Util.null2String(fu.uploadFiles("elockimg1"));
	String elockimg2 = Util.null2String(fu.uploadFiles("elockimg2"));
	String eunlockimg1 = Util.null2String(fu.uploadFiles("eunlockimg1"));
	String eunlockimg2 = Util.null2String(fu.uploadFiles("eunlockimg2"));
	String erefreshimg1 = Util.null2String(fu.uploadFiles("erefreshimg1"));
	String erefreshimg2 = Util.null2String(fu.uploadFiles("erefreshimg2"));
	String esettingimg1 = Util.null2String(fu.uploadFiles("esettingimg1"));
	String esettingimg2 = Util.null2String(fu.uploadFiles("esettingimg2"));
	
	String ecoloseimg1 = Util.null2String(fu.uploadFiles("ecoloseimg1"));
	String ecoloseimg2 = Util.null2String(fu.uploadFiles("ecoloseimg2"));
	String emoreimg1 = Util.null2String(fu.uploadFiles("emoreimg1"));
	String emoreimg2 = Util.null2String(fu.uploadFiles("emoreimg2"));
	String esparatorimg = Util.null2String(fu.uploadFiles("esparatorimg"));
	String esymbol = Util.null2String(fu.uploadFiles("esymbol"));
	

	String navbackgroudimg= Util.null2String(fu.uploadFiles("navbackgroudimg"));
	String navselectedbackgroudimg = Util.null2String(fu.uploadFiles("navselectedbackgroudimg"));

	int issystemdefualt=0;

	String method = Util.null2String(fu.getParameter("method"));
	String from = Util.null2String(fu.getParameter("from"));
	String hpinfoid = Util.null2String(fu.getParameter("hpinfoid"));
	if("edit".equals(method)){
		String strSql="update hpstyle set stylename='"+stylename+"',styledesc='"+styledesc+"',hpbgcolor='"+hpbgcolor+"',etitlebgcolor='"+etitlebgcolor+"',ebgcolor='"+ebgcolor+"',etitlecolor='"+etitlecolor+"',ecolor='"+ecolor+"',ebordercolor='"+ebordercolor+"',edatemode='"+edatemode+"',etimemode='"+etimemode+"',navbgcolor='"+navbgcolor+"',navcolor='"+navcolor+"',navselectedbgcolor='"+navselectedbgcolor+"',navselectedcolor='"+navselectedcolor+"',navbordercolor='"+navbordercolor+"',mimgshowmode='"+mimgshowmode+"'";
		
		if (!"".equals(hpbgimg)) strSql+=",hpbgimg='"+hpsu.getRealAddr(hpbgimg)+"'";
		if (!"".equals(etitlebgimg)) strSql+=",etitlebgimg='"+hpsu.getRealAddr(etitlebgimg)+"'";
		if (!"".equals(ebgimg)) strSql+=",ebgimg='"+hpsu.getRealAddr(ebgimg)+"'";
		if (!"".equals(elockimg1)) strSql+=",elockimg1='"+hpsu.getRealAddr(elockimg1)+"'";
		if (!"".equals(elockimg2)) strSql+=",elockimg2='"+hpsu.getRealAddr(elockimg2)+"'";		
		if (!"".equals(eunlockimg1)) strSql+=",eunlockimg1='"+hpsu.getRealAddr(eunlockimg1)+"'";
		if (!"".equals(eunlockimg2)) strSql+=",eunlockimg2='"+hpsu.getRealAddr(eunlockimg2)+"'";
		if (!"".equals(erefreshimg1)) strSql+=",erefreshimg1='"+hpsu.getRealAddr(erefreshimg1)+"'";
		if (!"".equals(erefreshimg2)) strSql+=",erefreshimg2='"+hpsu.getRealAddr(erefreshimg2)+"'";
		if (!"".equals(esettingimg1)) strSql+=",esettingimg1='"+hpsu.getRealAddr(esettingimg1)+"'";
		if (!"".equals(esettingimg2)) strSql+=",esettingimg2='"+hpsu.getRealAddr(esettingimg2)+"'";
		if (!"".equals(ecoloseimg1)) strSql+=",ecoloseimg1='"+hpsu.getRealAddr(ecoloseimg1)+"'";
		if (!"".equals(ecoloseimg2)) strSql+=",ecoloseimg2='"+hpsu.getRealAddr(ecoloseimg2)+"'";
		if (!"".equals(emoreimg1)) strSql+=",emoreimg1='"+hpsu.getRealAddr(emoreimg1)+"'";
		if (!"".equals(emoreimg2)) strSql+=",emoreimg2='"+hpsu.getRealAddr(emoreimg2)+"'";
		if (!"".equals(esparatorimg)) strSql+=",esparatorimg='"+hpsu.getRealAddr(esparatorimg)+"'";
		if (!"".equals(esymbol)) strSql+=",esymbol='"+hpsu.getRealAddr(esymbol)+"'";
		if (!"".equals(navbackgroudimg)) strSql+=",navbackgroudimg='"+hpsu.getRealAddr(navbackgroudimg)+"'";
		if (!"".equals(navselectedbackgroudimg)) strSql+=",navselectedbackgroudimg='"+hpsu.getRealAddr(navselectedbackgroudimg)+"'";

		strSql+=" where id="+styleid;
			
	    //System.out.println(strSql);
		rs.executeSql(strSql);
        if (hpsc.isHaveThisHpStyle(styleid))  hpsc.updateHpStyleCache(styleid);
        else hpsc.addHpStyleCache(styleid);
        
		response.sendRedirect("HomepageStyleList.jsp?hpinfoid="+hpinfoid+"&from="+from+"&seleStyleid="+styleid);
		
	} else if("ref".equals(method)){
		String srcstyleid = Util.null2String(fu.getParameter("seleSrcStyle"));
        String strSql="insert into hpstyle(stylename,styledesc,hpbgimg,hpbgcolor,etitlebgimg,etitlebgcolor,ebgimg,ebgcolor,etitlecolor,ecolor, ebordercolor,edatemode,etimemode,elockimg1,elockimg2,eunlockimg1,eunlockimg2,erefreshimg1,erefreshimg2,esettingimg1,esettingimg2,ecoloseimg1,ecoloseimg2,emoreimg1,emoreimg2,esparatorimg,esymbol,issystemdefualt,navbgcolor,navcolor,navselectedbgcolor,navselectedcolor,navbordercolor,navbackgroudimg,navselectedbackgroudimg,mimgshowmode) select '','',hpbgimg,hpbgcolor,etitlebgimg,etitlebgcolor,ebgimg,ebgcolor,etitlecolor,ecolor, ebordercolor,edatemode,etimemode,elockimg1,elockimg2,eunlockimg1,eunlockimg2,erefreshimg1,erefreshimg2,esettingimg1,esettingimg2,ecoloseimg1,ecoloseimg2,emoreimg1,emoreimg2,esparatorimg,esymbol,'0',navbgcolor,navcolor,navselectedbgcolor,navselectedcolor,navbordercolor,navbackgroudimg,navselectedbackgroudimg,mimgshowmode from hpstyle where id="+srcstyleid;
        //System.out.println("strSql: "+strSql);
		rs.executeSql(strSql);
        int maxStyleid=hpsu.getMaxHpstyleid();
		//hpsc.addHpStyleCache(""+maxStyleid);
		response.sendRedirect("HomepageStyleAdd.jsp?styleid="+maxStyleid+"&hpinfoid="+hpinfoid+"&from="+from);
	} else if("delpic".equals(method)){
		String delfield = Util.null2String(fu.getParameter("delfield"));
		rs.executeSql("update hpstyle set "+delfield+"='' where id="+styleid);
		hpsc.updateHpStyleCache(styleid);
        //System.out.println("HomepageStyleAdd.jsp?styleid="+styleid+"&hpinfoid="+hpinfoid+"&from="+from);
		response.sendRedirect("HomepageStyleAdd.jsp?styleid="+styleid+"&hpinfoid="+hpinfoid+"&from="+from);
	} else if("del".equals(method)){
        //如果是已被引用,此样式将不能被删除
        rs.executeSql("select id from hpinfo where styleid="+styleid);
        if(rs.next()){
            response.sendRedirect("HomepageStyleAdd.jsp?styleid="+styleid+"&hpinfoid="+hpinfoid+"&message=nodel&from="+from);
            return;
        }
		rs.executeSql("delete hpstyle  where id="+styleid);
		hpsc.deleteHpStyleCache(styleid);
		response.sendRedirect("HomepageStyleList.jsp"+"?hpinfoid="+hpinfoid+"&from="+from);
	}

%>