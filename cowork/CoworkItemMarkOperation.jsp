
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.cowork.CoworkDAO"%>
<%@page import="weaver.file.FileUpload"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<jsp:useBean id="CoworkItemMarkOperation" class="weaver.cowork.CoworkItemMarkOperation" scope="page" />
<%
    FileUpload fu = new FileUpload(request);

	String type = Util.null2String(fu.getParameter("type"));
	String coworkids = Util.null2String(fu.getParameter("coworkid"));
	ArrayList coworkidList = Util.TokenizerString(coworkids,",");
	String flag="";
	if("createLabel".equals(type)){
		flag = CoworkItemMarkOperation.createLabel(user.getUID()+"",fu)+"";
		out.print("<script>parent.getParentWindow(window).labelCallback();</script>");
	}else if("isExist".equals(type)){
		String name = Util.null2String(fu.getParameter("name"));
		flag = CoworkItemMarkOperation.isExistLabel(user.getUID()+"",name)+"";
		out.println(flag);
	}else if("getLabel".equals(type)){
		flag = CoworkItemMarkOperation.getUserLabels(user.getUID()+"",user.getLanguage());
		out.println(flag);
	}else if("addLabel".equals(type)){
		String labelids = Util.null2String(fu.getParameter("labelids"));
		for(int i=0;i < coworkidList.size(); i++){
			String coworkid = (String)coworkidList.get(i);
			flag+=CoworkItemMarkOperation.addItemLabels(coworkid,user.getUID()+"",labelids)+",";
		}
		out.print("<script>parent.getParentWindow(window).labelCallback();</script>");
	}else if("getLabelForManage".equals(type)){
		flag = CoworkItemMarkOperation.getUserLabelsForManage(user.getUID()+"", user.getLanguage());
	}else if("deleteLabel".equals(type)){
		String id = Util.null2String(fu.getParameter("id"));
		flag = CoworkItemMarkOperation.deleteLabel(id)+""; 
	}else if("editLabel".equals(type)){
		flag = CoworkItemMarkOperation.updateLabel(fu,user.getUID())+"";
		out.print("<script>parent.getParentWindow(window).labelCallback();</script>");
	}else if("setLabel".equals(type)){
		flag = CoworkItemMarkOperation.updateLabel(fu,user.getUID())+"";
		//response.sendRedirect("/cowork/coworkview.jsp");
		out.print("<script>parent.getParentWindow(window).labelManageCallback();</script>");
		//response.sendRedirect("/cowork/CoworkTabFrame.jsp");
	}else if("getLabelsForTab".equals(type)){
		flag = CoworkItemMarkOperation.getUserLabelsForTab(user.getUID()+"");
	}else if("delItemLable".equals(type)){ //删除用户协作标签
		String labelitemid = Util.null2String(fu.getParameter("labelitemid"));
		CoworkItemMarkOperation.deleteItemLabel(labelitemid);
	}else{
		CoworkDAO dao=new CoworkDAO();
		for(int i=0;i < coworkidList.size(); i++){
			String coworkid = (String)coworkidList.get(i);
			flag+= CoworkItemMarkOperation.markItemAsType(user.getUID()+"",coworkid,type)+",";
			//添加已读记录
			if(type.equals("read"))
				dao.addCoworkLog(Integer.parseInt(coworkid),2,user.getUID(),fu);
		}	 
	}
%>