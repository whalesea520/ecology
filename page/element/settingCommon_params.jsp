<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="rs_common" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rsIn_common" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="hpec" class="weaver.homepage.cominfo.HomepageElementCominfo" scope="page"/>
<jsp:useBean id="ebc" class="weaver.page.element.ElementBaseCominfo" scope="page"/>
<jsp:useBean id="ecc" class="weaver.admincenter.homepage.ElementCustomCominfo" scope="page"/>
<jsp:useBean id="pu" class="weaver.page.PageUtil" scope="page" />
<jsp:useBean id="pc" class="weaver.page.PageCominfo" scope="page"/>

<%
	/*
	基本信息
	eib
	ebaseid	
	esharelevel
	strsqlwhere
	*/
%>
<%
	boolean isSystemer=false;
	if(HrmUserVarify.checkUserRight("homepage:Maint", user)) isSystemer=true;
	
	String eid=Util.null2String(request.getParameter("eid"));		
	String ebaseid=Util.null2String(request.getParameter("ebaseid"));		
	String hpid=Util.null2String(request.getParameter("hpid"));
	int subCompanyId = Util.getIntValue(request.getParameter("subCompanyId"),-1);

	int userid = 1;
	int usertype=0;
	userid=pu.getHpUserId(hpid,""+subCompanyId,user);
	usertype=pu.getHpUserType(hpid,""+subCompanyId,user);
	//协同区记录
	//if(Util.getIntValue(hpid) < 0)
	//{
	//	userid = user.getUID();
	//	usertype = Util.getIntValue(user.getLogintype());
	//}
	String etitle=hpec.getTitle(eid);
	String eperpage="";
	String elinkmode="";
	String eshowfield="";
	String strsqlwhere=hpec.getStrsqlwhere(eid);
	String esharelevel="";
	

	String  strSql="select perpage,linkmode,showfield,sharelevel from hpElementSettingDetail where eid="+eid+" and userid="+userid+" and usertype="+usertype;	

	rs_common.executeSql(strSql);
	if(!rs_common.next()){
		int _sharelevel = 1;
		if(isSystemer){
				_sharelevel = 2;
		}
		String insertSql = "insert into hpElementSettingDetail (userid,usertype,eid,linkmode,perpage,showfield,sharelevel,hpid) select "+userid+", "+usertype+", "+eid+", linkmode,perpage,showfield,"+_sharelevel+","+hpid+" from hpElementSettingDetail where eid="+eid+" and userid=1";
		//System.out.println("sttingCommon.jsp:===> insertSql "+ insertSql);
		rs_common.executeSql(insertSql);
	
		rs_common.executeSql(strSql);
	}else{

		rs_common.beforFirst();
	}
	
	if(rs_common.next()){
		eperpage=Util.null2String(rs_common.getString("perpage"));
		elinkmode=Util.null2String(rs_common.getString("linkmode"));
		eshowfield=Util.null2String(rs_common.getString("showfield"));
		esharelevel=Util.null2String(rs_common.getString("sharelevel"));  //1:为查看 2:为编辑
	}
	if("FormModeCustomSearch".equals(ebaseid)&&!"2".equals(esharelevel)){
		List<String> list = pu.getUserMaintHpidListPublic(user.getUID());
		if(!list.contains(hpid)){
			out.println("<p>&nbsp;</p><p>&nbsp;</p>");
			return;	
		}
	}
	
	
	String isFixationRowHeight="";
	String background="";
	String isremind = "";
	strSql="select isFixationRowHeight,background,isremind  from hpelement where id="+eid;	
	rs_common.executeSql(strSql);
	if(rs_common.next()){
		isFixationRowHeight=Util.null2String(rs_common.getString("isFixationRowHeight"));
		background=Util.null2String(rs_common.getString("background"));
		isremind=Util.null2String(rs_common.getString("isremind"));
	}	
	
	//获取元素显示URL，用于元素独立显示
	String indieUrlStr = "";
	String isBaseElementSql = "select isbase from hpBaseElement where id = '"+ebaseid+"'";
	rs_common.executeSql(isBaseElementSql);
	if(rs_common.next()){
		if ("1".equals(rs_common.getString("isbase"))) {
			String contentUrl = ebc.getView(ebaseid);
			if("".equals(contentUrl)) {
				contentUrl = ecc.getView(ebaseid);
			}
			indieUrlStr = contentUrl+"?ebaseid="+ebaseid+"&eid="+eid+"&hpid="+hpid+"&subCompanyId="+subCompanyId+"&indie=true&needHead=true";
		}
	}
	if("-1".equals(eperpage)&&"favourite".equals(ebaseid)){
		eperpage="5";
	}
%>
<input type="hidden" name="_esharelevel_<%=eid%>" value="<%=esharelevel%>">	