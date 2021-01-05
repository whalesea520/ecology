
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.cowork.CoworkDAO"%>
<%@page import="weaver.file.FileUpload"%>
<%@page import="weaver.crm.customer.CustomerLabelService"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%@ page import="weaver.general.*" %>
<%@ page import="java.util.*" %>
<%@page import="java.net.URLDecoder"%>
<jsp:useBean id="CustomerLabelService" class="weaver.crm.customer.CustomerLabelService" scope="page" />
<%
    FileUpload fu = new FileUpload(request);

	String type = Util.null2String(fu.getParameter("type"));
	String coworkids = Util.null2String(fu.getParameter("coworkid"));
	ArrayList coworkidList = Util.TokenizerString(coworkids,",");
	String flag="";
	if("createLabel".equals(type)){
		flag = CustomerLabelService.createLabel(user.getUID()+"",fu)+"";
		out.print("<script>parent.getParentWindow(window).labelCallback();</script>");
	}else if("isExist".equals(type)){
		String name = Util.null2String(fu.getParameter("name"));
		flag = CustomerLabelService.isExistLabel(user.getUID()+"",name)+"";
		out.println(flag);
	}else if("getLabel".equals(type)){
		flag = CustomerLabelService.getUserLabels(user.getUID()+"",user.getLanguage());
		out.println(flag);
	}else if("addLabel".equals(type)){
		String labelids = Util.null2String(fu.getParameter("labelids"));
		String customerids = Util.null2String(fu.getParameter("customerid"));
		ArrayList customeridList = Util.TokenizerString(customerids,",");
		for(int i=0;i < customeridList.size(); i++){
			String customerid = (String)customeridList.get(i);
			flag+=CustomerLabelService.addItemLabels(customerid,user.getUID()+"",labelids)+",";
		}
		out.print("<script>parent.getParentWindow(window).labelCallback();</script>");
	}else if("cancelLabel".equals(type)){
		String labelids = Util.null2String(fu.getParameter("labelids"));
		String customerids = Util.null2String(fu.getParameter("customerid"));
		ArrayList customeridList = Util.TokenizerString(customerids,",");
		for(int i=0;i < customeridList.size(); i++){
			String customerid = (String)customeridList.get(i);
			flag+=CustomerLabelService.cancelItemLabels(customerid,user.getUID()+"",labelids)+",";
		}
		out.print("<script>parent.getParentWindow(window).labelCallback();</script>");
	}else if("getLabelForManage".equals(type)){
		flag = CustomerLabelService.getUserLabelsForManage(user.getUID()+"", user.getLanguage());
	}else if("deleteLabel".equals(type)){
		String id = Util.null2String(fu.getParameter("id"));
		flag = CustomerLabelService.deleteLabel(id)+""; 
	}else if("editLabel".equals(type)){
		flag = CustomerLabelService.updateLabel(fu)+"";
		out.print("<script>parent.getParentWindow(window).labelCallback();</script>");
	}else if("setLabel".equals(type)){
		flag = CustomerLabelService.updateLabel(fu)+"";
		//response.sendRedirect("/cowork/coworkview.jsp");
		out.print("<script>parent.getParentWindow(window).labelManageCallback();</script>");
		//response.sendRedirect("/cowork/CoworkTabFrame.jsp");
	}else if("getLabelsForTab".equals(type)){
		flag = CustomerLabelService.getUserLabelsForTab(user.getUID()+"");
	}else if("delItemLable".equals(type)){ //删除用户协作标签
		String labelitemid = Util.null2String(fu.getParameter("labelitemid"));
		CustomerLabelService.deleteItemLabel(labelitemid);
	}else{
		CoworkDAO dao=new CoworkDAO();
		for(int i=0;i < coworkidList.size(); i++){
			String coworkid = (String)coworkidList.get(i);
			//flag+= CustomerLabelService.markItemAsType(user.getUID()+"",coworkid,type)+",";
			//添加已读记录
			if(type.equals("read"))
				dao.addCoworkLog(Integer.parseInt(coworkid),2,user.getUID(),fu);
		}	 
	}
%>