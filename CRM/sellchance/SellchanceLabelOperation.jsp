
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.cowork.CoworkDAO"%>
<%@page import="weaver.file.FileUpload"%>
<%@page import="weaver.crm.customer.CustomerLabelService"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%@ page import="weaver.general.*" %>
<%@page import="java.net.URLDecoder"%>
<jsp:useBean id="SellChanceLabelService" class="weaver.crm.sellchance.SellChanceLabelService" scope="page" />
<%
    FileUpload fu = new FileUpload(request);

	String type = Util.null2String(fu.getParameter("type"));
	String coworkids = Util.null2String(fu.getParameter("coworkid"));
	ArrayList coworkidList = Util.TokenizerString(coworkids,",");
	String flag="";
	if("createLabel".equals(type)){
		flag = SellChanceLabelService.createLabel(user.getUID()+"",fu)+"";
		out.print("<script>parent.getParentWindow(window).labelCallback();</script>");
	}else if("isExist".equals(type)){
		String name = Util.null2String(fu.getParameter("name"));
		flag = SellChanceLabelService.isExistLabel(user.getUID()+"",name)+"";
		out.println(flag);
	}else if("getLabel".equals(type)){
		flag = SellChanceLabelService.getUserLabels(user.getUID()+"",user.getLanguage());
		out.println(flag);
	}else if("addLabel".equals(type)){
		String labelids = Util.null2String(fu.getParameter("labelids"));
		String sellchanceids = Util.null2String(fu.getParameter("sellchanceids"));
		ArrayList sellchanceidList = Util.TokenizerString(sellchanceids,",");
		for(int i=0;i < sellchanceidList.size(); i++){
			String sellchanceid = (String)sellchanceidList.get(i);
			flag+=SellChanceLabelService.addItemLabels(sellchanceid,user.getUID()+"",labelids)+",";
		}
		out.print("<script>parent.getParentWindow(window).labelCallback();</script>");
	}else if("cancelLabel".equals(type)){
		String labelids = Util.null2String(fu.getParameter("labelids"));
		String sellchanceids = Util.null2String(fu.getParameter("sellchanceids"));
		ArrayList sellchanceidList = Util.TokenizerString(sellchanceids,",");
		for(int i=0;i < sellchanceidList.size(); i++){
			String sellchanceid = (String)sellchanceidList.get(i);
			flag+=SellChanceLabelService.cancelItemLabels(sellchanceid,user.getUID()+"",labelids)+",";
		}
		out.print("<script>parent.getParentWindow(window).labelCallback();</script>");
	}else if("getLabelForManage".equals(type)){
		flag = SellChanceLabelService.getUserLabelsForManage(user.getUID()+"", user.getLanguage());
	}else if("deleteLabel".equals(type)){
		String id = Util.null2String(fu.getParameter("id"));
		flag = SellChanceLabelService.deleteLabel(id)+""; 
	}else if("editLabel".equals(type)){
		flag = SellChanceLabelService.updateLabel(fu)+"";
		out.print("<script>parent.getParentWindow(window).labelCallback();</script>");
	}else if("setLabel".equals(type)){
		flag = SellChanceLabelService.updateLabel(fu)+"";
		//response.sendRedirect("/cowork/coworkview.jsp");
		out.print("<script>parent.getParentWindow(window).labelManageCallback();</script>");
		//response.sendRedirect("/cowork/CoworkTabFrame.jsp");
	}else if("getLabelsForTab".equals(type)){
		flag = SellChanceLabelService.getUserLabelsForTab(user.getUID()+"");
	}else if("delItemLable".equals(type)){ //删除用户协作标签
		String labelitemid = Util.null2String(fu.getParameter("labelitemid"));
		SellChanceLabelService.deleteItemLabel(labelitemid);
	}else{
		CoworkDAO dao=new CoworkDAO();
		for(int i=0;i < coworkidList.size(); i++){
			String coworkid = (String)coworkidList.get(i);
			// flag+= CustomerLabelService.markItemAsType(user.getUID()+"",coworkid,type)+",";
			//添加已读记录
			if(type.equals("read"))
				dao.addCoworkLog(Integer.parseInt(coworkid),2,user.getUID(),fu);
		}	 
	}
%>