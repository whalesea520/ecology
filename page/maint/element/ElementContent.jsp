
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="pc" class="weaver.page.PageCominfo" scope="page" />
<jsp:useBean id="pu" class="weaver.page.PageUtil" scope="page" />
<jsp:useBean id="ecc" class="weaver.admincenter.homepage.ElementCustomCominfo"scope="page" />
<jsp:useBean id="we" class="weaver.admincenter.homepage.WeaverElement"scope="page" />
<jsp:useBean id="ec" class="weaver.page.element.ElementUtil" scope="page" />
<%
boolean isSystemer=false;
if(HrmUserVarify.checkUserRight("homepage:Maint", user)) isSystemer=true;

String hpid = Util.null2String(request.getParameter("hpid"));	
int subCompanyId = Util.getIntValue(request.getParameter("subCompanyId"),-1);
String eid=Util.null2String(request.getParameter("eid"));		
String ebaseid=Util.null2String(request.getParameter("ebaseid"));	
String styleid=Util.null2String(request.getParameter("styleid"));

boolean hasRight =true;
	User loginuser = (User)request.getSession(true).getAttribute("weaver_user@bean") ;
	// 先取消权限判断
	if(loginuser != null)  {
		hasRight =  ec.isHasRight(eid,loginuser.getUID()+"");
	}
	if(!hasRight){
		response.sendRedirect("/page/element/noright.jsp");
	}

	int userid=pu.getHpUserId(hpid,""+subCompanyId,user);
	int usertype=pu.getHpUserType(hpid,""+subCompanyId,user);
	if(pc.getIsLocked(hpid).equals("1")) {
	   userid=Util.getIntValue(pc.getCreatorid(hpid));
	   usertype=Util.getIntValue(pc.getCreatortype(hpid));
	}else if("0".equals(hpid)&&subCompanyId==0){
		userid =1;
		usertype=0;
	}

	
	String filedname = "";
	String filedvalue = "";
	String strSql = "select name,value from hpElementSetting where eid='"+eid+"'";
	rs.executeSql(strSql);
	if(rs.next()){
		filedname=Util.null2String(rs.getString("name"));
		filedvalue=Util.null2String(rs.getString("value"));		
	}
	String[] setData = Util.TokenizerStringNew(filedvalue,"^,^");
	String dataDBPoint = "";
	String data = "";
	if(setData.length==2){
		dataDBPoint = setData[0];
		data = setData[1];
	}else if(setData.length==1) data = setData[0];
	
	ArrayList setList = (ArrayList) ecc.getSettingList(ebaseid);
	Map map = new HashMap();
	for(int i = 0;i<setList.size();i++){
		Map setMap = (Map)setList.get(i);
		String datatype = (String)setMap.get("settingdatatype");
		String type = (String)setMap.get("settingtype");
		if("DataSource".equals(type)&&"SQL".equals(datatype)){
			if("".equals(dataDBPoint.trim()))
				out.print(we.getOutDataSource(eid,userid,usertype,loginuser,data));
			else
				out.print(we.getOutDataSource(eid,userid,usertype,loginuser,dataDBPoint.trim(),data));
		}else if("DataPage".equals(type)){
			if("JSON".equals(datatype))
				out.print(we.getOutPageSourceToJSON(eid,userid,usertype,loginuser,data));
			else if("XML".equals(datatype))
				out.print(we.getOutPageSourceToXML(eid,userid,usertype,loginuser,data));
			else if("WebService".equals(datatype))
				out.print(we.getOutPageSourceToWebService(eid,userid,usertype,loginuser,data));
		}
	}
%>