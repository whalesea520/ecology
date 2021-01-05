<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.hrm.attendance.domain.HrmLeaveTypeColor" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<!-- Modified by wcd 2015-04-28-->
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="strUtil" class="weaver.common.StringUtil" scope="page" />
<jsp:useBean id="colorManager" class="weaver.hrm.attendance.manager.HrmLeaveTypeColorManager" scope="page" />
<%
	if(!HrmUserVarify.checkUserRight("LeaveTypeColor:All", user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	String operation = Util.null2String(request.getParameter("operation"));
	String subcompanyid = Util.null2String(request.getParameter("subcompanyid"));
	String sql = "";
	String allsubcompanyid = SubCompanyComInfo.getSubCompanyTreeStr(subcompanyid+"")+subcompanyid;

	String temp1=",";
	int a[] = CheckSubCompanyRight.getSubComByUserRightId(user.getUID(),"AnnualPeriod:All");
	for(int j=0;j<a.length;j++) {
	   temp1+=a[j]+",";
	}
	ArrayList rightsub = SubCompanyComInfo.getRightSubCompany(user.getUID(),"LeaveTypeColor:All");
	String temp = "";
	if(rightsub!=null){
	   for(int i=0;i<rightsub.size();i++){
		  if((","+allsubcompanyid).indexOf(","+rightsub.get(i).toString()+",")>-1 && temp1.indexOf(","+rightsub.get(i).toString()+",")>-1 ) temp += rightsub.get(i).toString()+",";
	   }
	}
	allsubcompanyid = temp + subcompanyid;
	if(operation.equals("edit")){
		String[] itemids = request.getParameterValues("itemid");
		String[] selectname = request.getParameterValues("selectname");
		String[] color = request.getParameterValues("color");
		String[] field002 = strUtil.vString(request.getParameter("field002")).split(",");
		String[] field003 = strUtil.vString(request.getParameter("field003")).split(",");
		String[] field004 = request.getParameterValues("field004");
		String[] field005 = request.getParameterValues("field005");
		String[] field006 = request.getParameterValues("field006");
		String[] isCalWorkDayCol = strUtil.vString(request.getParameter("isCalWorkDayField")).split(",");
		String[] relateweekdayField = strUtil.vString(request.getParameter("relateweekdayField")).split(",");
		String[] ispaidleaveCol = strUtil.vString(request.getParameter("ispaidleaveField")).split(",");
		if(itemids != null){
			HrmLeaveTypeColor colorBean = null;
			for(int i=0;i<itemids.length;i++){
				colorBean = colorManager.get(colorManager.getMapParam("subcompanyid:"+subcompanyid+";field004:"+strUtil.parseToInt(field004[i])));
				colorBean = colorBean == null ? new HrmLeaveTypeColor() : colorBean;
				colorBean.setItemid(strUtil.parseToInt(itemids[i]));
				colorBean.setColor(strUtil.vString(color[i], "#FF0000"));
				colorBean.setSubcompanyid(strUtil.parseToInt(subcompanyid));
				colorBean.setField001(strUtil.vString(selectname[i]));
				colorBean.setField002(strUtil.parseToInt(field002[i], 0));
				colorBean.setField003(strUtil.parseToInt(field003[i], 0));
				colorBean.setField004(strUtil.parseToInt(field004[i]));
				colorBean.setField005(strUtil.vString(field005[i], "otherLeaveType"));
				colorBean.setField006(strUtil.parseToInt(field006[i]));
				colorBean.setIsCalWorkDay(strUtil.parseToInt(isCalWorkDayCol[i], 1));
				colorBean.setRelateweekday(strUtil.parseToInt(relateweekdayField[i], 2));//默认周一
				colorBean.setIspaidleave(strUtil.parseToInt(ispaidleaveCol[i]));
				colorManager.save(colorBean);
			}
		}
		response.sendRedirect("LeaveTypeColorEdit.jsp?subcompanyid="+subcompanyid);
	} else if(operation.equals("delete")){
		String ids = Util.null2String(request.getParameter("ids"));
		if(ids.equals("")||ids.equals("-1")){   
			sql = "delete from HrmLeaveTypeColor where subcompanyid = " + subcompanyid;
		}else{
			sql = "delete from HrmLeaveTypeColor where id in (" + ids + ")";
		}
		rs.executeSql(sql);

		response.sendRedirect("LeaveTypeColorEdit.jsp?subcompanyid="+subcompanyid);      
	} else if(operation.equals("syn")){
		String ids = Util.null2String(request.getParameter("ids")) + "-1";
		String _tempsubcompanyid[] = Util.TokenizerString2(allsubcompanyid,",");   
		sql = "delete from HrmLeaveTypeColor where subcompanyid <> " + subcompanyid + " and subcompanyid in ("+allsubcompanyid+") and itemid in (" + ids + ")";
		rs.executeSql(sql);
		sql = "select * from HrmLeaveTypeColor where subcompanyid = " + subcompanyid + " and itemid in (" + ids + ")";
		rs.executeSql(sql);
		HrmLeaveTypeColor colorBean = null;
		while(rs.next()){
			colorBean = new HrmLeaveTypeColor();
			colorBean.setItemid(strUtil.parseToInt(rs.getString("itemid")));
			colorBean.setColor(strUtil.vString(rs.getString("color")));
			colorBean.setField001(strUtil.vString(rs.getString("field001")));
			colorBean.setField002(strUtil.parseToInt(rs.getString("field002")));
			colorBean.setField003(strUtil.parseToInt(rs.getString("field003")));
			colorBean.setIsCalWorkDay(strUtil.parseToInt(rs.getString("isCalWorkDay")));
			colorBean.setIspaidleave(strUtil.parseToInt(rs.getString("ispaidleave")));
			for(int i=0;i<_tempsubcompanyid.length;i++){
				if(_tempsubcompanyid[i].equals(subcompanyid)) continue;
				colorBean.setSubcompanyid(strUtil.parseToInt(_tempsubcompanyid[i]));
				colorManager.insert(colorBean);   
			}
		}
	   
		response.sendRedirect("LeaveTypeColorEdit.jsp?subcompanyid="+subcompanyid);      
	} else if(operation.equals("syndelete")){
		String ids = Util.null2String(request.getParameter("ids")) + "-1";
		sql = "delete from HrmLeaveTypeColor where subcompanyid in ("+allsubcompanyid+") and itemid in (" + ids + ")";
		rs.executeSql(sql);
		response.sendRedirect("LeaveTypeColorEdit.jsp?subcompanyid="+subcompanyid);      
	}
%>