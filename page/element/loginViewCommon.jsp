
<%@page import="weaver.general.BaseBean"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.homepage.style.HomepageStyleBean"%>

<jsp:useBean id="hpc" class="weaver.homepage.cominfo.HomepageCominfo"
	scope="page" />
<jsp:useBean id="hpec"
	class="weaver.homepage.cominfo.HomepageElementCominfo" scope="page" />
<jsp:useBean id="hpefc"
	class="weaver.homepage.cominfo.HomepageElementFieldCominfo"
	scope="page" />
<jsp:useBean id="hpsu" class="weaver.homepage.style.HomepageStyleUtil"
	scope="page" />
<jsp:useBean id="rsCommon" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ebc" class="weaver.page.element.ElementBaseCominfo"
	scope="page" />
<jsp:useBean id="esc" class="weaver.page.style.ElementStyleCominfo"
	scope="page" />
<jsp:useBean id="hpes" class="weaver.homepage.HomepageExtShow"
	scope="page" />	
<jsp:useBean id="ec" class="weaver.page.element.ElementUtil" scope="page" />
<jsp:useBean id="pc" class="weaver.page.PageCominfo" scope="page" />
<jsp:useBean id="pu" class="weaver.page.PageUtil" scope="page"/>
<%@ include file="/page/maint/common/initLoginNoCache.jsp"%>
<%
	/*
	基本信息
	--------------------------------------
	hpid:表首页ID
	subCompanyId:首页所属分部的分部ID
	eid:元素ID
	ebaseid:基本元素ID
	styleid:样式ID
	
	条件信息
	--------------------------------------
	String strsqlwhere 格式为 条件1^,^条件2...
	int perpage  显示页数
	String linkmode 查看方式  1:当前页 2:弹出页

	
	字段信息
	--------------------------------------
	fieldIdList
	fieldColumnList
	fieldIsDate
	fieldTransMethodList
	fieldWidthList
	linkurlList
	valuecolumnList
	isLimitLengthList

	样式信息
	----------------------------------------
	String hpsb.getEsymbol() 列首图标
	String hpsb.getEsparatorimg()   行分隔线 
	 */
%>
<%
	String hpid = Util.null2String(request.getParameter("hpid"));
	int subCompanyId = Util.getIntValue(request.getParameter("subCompanyId"), -1);
	int eidInt=Util.getIntValue(request.getParameter("eid"),-1);
	String eid = eidInt+"";
//	int ebaseidInt=Util.getIntValue(request.getParameter("ebaseid"),-1);
	String ebaseid =  Util.null2String(request.getParameter("ebaseid"));
	String styleid = Util.null2String(request.getParameter("styleid"));
	String ePath = ebc.getPath(ebaseid);
	//HomepageStyleBean hpsb = hpsu.getHpsb(styleid);

	//判断当前用户是否有权限查看该元素
	boolean hasRight =true;
	User loginuser = (User)request.getSession(true).getAttribute("weaver_user@bean") ;

		List<User> viceUsers=null;
		
		// 先取消权限判断
		if(loginuser != null)  {
			ec.setUser(loginuser);
			hasRight =  ec.isHasRight(eid,loginuser.getUID()+"",0,1);
		}
		
		if(!hasRight)
		{
		response.sendRedirect("/page/element/noright.jsp");
		}
	
		
	//得到需要显示的字段
	ArrayList fieldIdList = new ArrayList();
	ArrayList fieldColumnList = new ArrayList();
	ArrayList fieldIsDate = new ArrayList();
	ArrayList fieldTransMethodList = new ArrayList();
	ArrayList fieldWidthList = new ArrayList();
	ArrayList linkurlList = new ArrayList();
	ArrayList valuecolumnList = new ArrayList();
	ArrayList isLimitLengthList = new ArrayList();

	int perpage = 0;
	int userid = 1;
	int usertype = 0;
	int language = 7;
	if(loginuser==null||(pc.getSubcompanyid(hpid).equals("-1")&&pc.getCreatortype(hpid).equals("0"))){
		userid =1;
		usertype=0;
	}else{
		userid=pu.getHpUserId(hpid,""+subCompanyId,loginuser);
		usertype=pu.getHpUserType(hpid,""+subCompanyId,loginuser);
		language = loginuser.getLanguage();
		
		if (pc.getIsLocked(hpid).equals("1")) {
			userid = Util.getIntValue(pc.getCreatorid(hpid));
			usertype = Util.getIntValue(pc.getCreatortype(hpid));
		}
	}
	
	String fields = "";
	String linkmode = "";
	String strSql = "";
	String strsqlwhere = hpec.getStrsqlwhere(eid);
    strSql="select strsqlwhere  from hpElement where id='"+eid+"'";
    rsCommon.execute(strSql);
    if(rsCommon.next()){
    	strsqlwhere=rsCommon.getString("strsqlwhere");
    }
    
	strSql = "select perpage,linkmode,showfield from hpElementSettingDetail where eid=" + eid + " and userid=" + userid
			+ " and usertype=" + usertype;
	rsCommon.executeSql(strSql);
	if (rsCommon.next())
	{
		fields = Util.null2String(rsCommon.getString("showfield"));
		perpage = Util.getIntValue(rsCommon.getString("perpage"));
		linkmode = Util.null2String(rsCommon.getString("linkmode"));
	} else {
		//用于元素独立显示判断，若个人配置不存在，读取管理员数据。
		if ("true".equals(Util.null2String(request.getParameter("indie"), "false"))) {
			strSql = "select perpage,linkmode,showfield from hpElementSettingDetail where eid="
				+ eid
				+ " and usertype=3";
		}
		rsCommon.executeSql(strSql);
		if (rsCommon.next()) {
			fields = Util.null2String(rsCommon.getString("showfield"));
			perpage = Util.getIntValue(rsCommon.getString("perpage"));
			linkmode = Util.null2String(rsCommon.getString("linkmode"));
		}
	}
	String currenttab="";
	
	if(loginuser != null){
		boolean needRecordTab = true;
		strSql="select isremembertab  from PageUserDefault where userid="+loginuser.getUID();
		rsCommon.executeSql(strSql);
		if(rsCommon.next()){
			needRecordTab = !"0".equals(rsCommon.getString("isremembertab"));
		}
		if(needRecordTab){//只有开启了记录最后选中叶签，才需要查该数据
			strSql = "select currenttab from hpcurrenttab where eid="+eid
			+ " and usertype="
			+ loginuser.getType()+ " and userid="+ loginuser.getUID();
			rsCommon.execute(strSql);
			
			if(rsCommon.next()){
				currenttab = Util.null2String(rsCommon.getString("currenttab"));
			}else{
				rsCommon.execute("insert into hpcurrenttab (currenttab,eid,userid,usertype) values ( null,"+eid+","+loginuser.getUID()+","+loginuser.getType()+")");
			}
		}
	}
	
	
	if (!"".equals(fields))
	{
		ArrayList tempFieldList = Util.TokenizerString(fields, ",");
		for (int i = 0; i < tempFieldList.size(); i++)
		{
			String tempId = (String) tempFieldList.get(i);
			fieldIdList.add(tempId);
			fieldColumnList.add(hpefc.getFieldcolumn(tempId));
			fieldIsDate.add(hpefc.getIsdate(tempId));
			fieldTransMethodList.add(hpefc.getTransmethod(tempId));
			fieldWidthList.add(hpefc.getFieldWidth(tempId));
			linkurlList.add(hpefc.getLinkurl(tempId));
			valuecolumnList.add(hpefc.getValuecolumn(tempId));
			isLimitLengthList.add(hpefc.getIsLimitLength(tempId));
		}
	}
	String isFixationRowHeight = "0";
	String background = "";
	strSql = "select isFixationRowHeight,background from hpelement where id=" + eid;
	rsCommon.executeSql(strSql);
	if (rsCommon.next())
	{
		isFixationRowHeight = Util.null2String(rsCommon.getString("isFixationRowHeight"));
		background = Util.null2String(rsCommon.getString("background"));
	}
%>