
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/page/element/operationCommon.jsp"%>
<%@ include file="common.jsp"%>


<%
	String operationSql = "";

	for(int i=0;i<nameList.size();i++){
		if(!nameList.get(i).equals("videoSrcType")){
			operationSql = "update hpElementSetting set value = '"+Util.null2String(request.getParameter(nameList.get(i)+"_"+eid))+"' where eid="+eid+" and name = '"+nameList.get(i)+"'";
			//System.out.println("==============1==================="+operationSql);
			rs_Setting.execute(operationSql);
		}else{
			operationSql = "update hpElementSetting set value = '"+Util.null2String(request.getParameter(nameList.get(i)+"_"+eid))+"' where eid="+eid+" and name = '"+nameList.get(i)+"'";
			//System.out.println("==============2==================="+operationSql);
			rs_Setting.execute(operationSql);
			if("1".equals(Util.null2String(request.getParameter("videoSrcType_"+eid)))){
				operationSql = "update hpElementSetting set value = '"+Util.null2String(request.getParameter("videoSrc_"+eid))+"' where eid="+eid+" and name = 'videoSrc'";
				rs_Setting.execute(operationSql);
			}else if("2".equals(Util.null2String(request.getParameter("videoSrcType_"+eid)))){
				operationSql = "update hpElementSetting set value = '"+Util.null2String(request.getParameter("videoUrl_"+eid))+"' where eid="+eid+" and name = 'videoSrc'";
				rs_Setting.execute(operationSql);
			}
			break;
		}
	}
%>