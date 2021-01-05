
<%@page import="weaver.general.BaseBean"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.homepage.style.HomepageStyleBean" %>

<%@page import="weaver.page.style.ElementStyleCominfo"%>
<jsp:useBean id="hpc" class="weaver.page.PageCominfo" scope="page" />
<jsp:useBean id="hpu" class="weaver.page.PageUtil" scope="page" />
<jsp:useBean id="hpec" class="weaver.homepage.cominfo.HomepageElementCominfo" scope="page"/>
<jsp:useBean id="hpefc" class="weaver.homepage.cominfo.HomepageElementFieldCominfo" scope="page"/>
<jsp:useBean id="hpes" class="weaver.homepage.HomepageExtShow" scope="page"/>
<jsp:useBean id="hpsu" class="weaver.homepage.style.HomepageStyleUtil" scope="page" />
<jsp:useBean id="rsCommon" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ebc" class="weaver.page.element.ElementBaseCominfo" scope="page" />
<jsp:useBean id="esc" class="weaver.page.style.ElementStyleCominfo"scope="page" />
<jsp:useBean id="ec" class="weaver.page.element.ElementUtil" scope="page" />

<%@ include file="/page/maint/common/initNoCache.jsp"%>
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
	int subCompanyId = Util.getIntValue(request
			.getParameter("subCompanyId"), -1);
	String eid = Util.null2String(request.getParameter("eid"));
	String ebaseid = Util.null2String(request.getParameter("ebaseid"));
	String styleid = Util.null2String(request.getParameter("styleid"));
	String ePath = ebc.getPath(ebaseid);
	//HomepageStyleBean hpsb = hpsu.getHpsb(styleid);
	
	int perpage = 0;
	int userid = hpu.getHpUserId(hpid, "" + subCompanyId, user);
	int usertype = hpu.getHpUserType(hpid, "" + subCompanyId, user);
	
	if (hpc.getIsLocked(hpid).equals("1")) {
		userid = Util.getIntValue(hpc.getCreatorid(hpid));
		usertype = Util.getIntValue(hpc.getCreatortype(hpid));
	}

	//判断当前用户是否有权限查看该元素
		boolean hasRight =false;
		User loginuser = (User)request.getSession(true).getAttribute("weaver_user@bean") ;
		ec.setUser(loginuser);		
		hasRight=ec.isHasRight(eid,loginuser.getUID()+"",0,1);
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



	String fields = "";
	String linkmode = "";

	String strsqlwhere = hpec.getStrsqlwhere(eid);

	String strSql = "select perpage,linkmode,showfield from hpElementSettingDetail where eid="
			+ eid
			+ " and userid="
			+ userid
			+ " and usertype="
			+ usertype;
	
	rsCommon.executeSql(strSql);
	if (rsCommon.next()) {
		fields = Util.null2String(rsCommon.getString("showfield"));
		perpage = Util.getIntValue(rsCommon.getString("perpage"));
		linkmode = Util.null2String(rsCommon.getString("linkmode"));
	} else {
		//用于元素独立显示判断，若个人配置不存在，读取管理员数据。
		if ("true".equals(Util.null2String(request.getParameter("indie"), "false"))) {
			strSql = "select perpage,linkmode,showfield from hpElementSettingDetail where eid="+eid+" and usertype=3";
		}
		rsCommon.executeSql(strSql);
		if (rsCommon.next()) {
			fields = Util.null2String(rsCommon.getString("showfield"));
			perpage = Util.getIntValue(rsCommon.getString("perpage"));
			linkmode = Util.null2String(rsCommon.getString("linkmode"));
		}
	}

	if (!"".equals(fields)) {
		ArrayList tempFieldList = Util.TokenizerString(fields, ",");
		for (int i = 0; i < tempFieldList.size(); i++) {
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
	String isFixationRowHeight="0";
	String background="";
	strSql = "select isFixationRowHeight,background from hpelement where id="+ eid;
	rsCommon.executeSql(strSql);
	if (rsCommon.next()) {
		isFixationRowHeight = Util.null2String(rsCommon.getString("isFixationRowHeight"));
		background = Util.null2String(rsCommon.getString("background"));
	}
%>