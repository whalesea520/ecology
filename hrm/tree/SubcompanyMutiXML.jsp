<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.common.util.xtree.TreeNode" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%response.setHeader("cache-control", "no-cache");
			response.setHeader("pragma", "no-cache");
			response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
			User user = HrmUserVarify.getUser(request, response);
			if (user == null)
				return;
%>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<%			String rightStr = Util.null2String(request.getParameter("rightStr"));
			String type = Util.null2String(request.getParameter("type"));
			String id = Util.null2String(request.getParameter("id"));
			String nodeids=Util.null2String(request.getParameter("nodeids"));
			rightStr = "Structure:Mag";
			TreeNode envelope = new TreeNode();
			envelope.setTitle("envelope");
			String excludeid = Util.null2String(request.getParameter("excludeid"));
			TreeNode root = new TreeNode();
			String companyname = CompanyComInfo.getCompanyname("1");
			root.setTitle(companyname);
			root.setNodeId("root_0");
			root.setCheckbox("Y");
			root.setOncheck("check(root_0)");
			root.setTarget("_self");
			root.setIcon("/images/treeimages/global_wev8.gif");
			//root.setHref("javascript:setCompany('com_1')");
			//SubCompanyComInfo.getSubCompanyTreeListByRight(user.getUID(),rightStr);
			if (!"".equals(id)) {
				if (type.equals("com")) {
					SubCompanyComInfo.getAppDetachSubCompanyTreeList(envelope,id, 0, 2, false, "subcompanyMutiXml", null, null,user);
				}
			} 
			if(id.equals("")&&nodeids.equals("")) {
				envelope.addTreeNode(root);
				if (excludeid.equals("")) {
					SubCompanyComInfo.getAppDetachSubCompanyTreeList(root, "0",0, 2, false, "subcompanyMutiXml", null, null,user);
				} else {
					SubCompanyComInfo.getAppDetachSubCompanyTreeList(root, "0",0, 2, false, "subcompanyMutiXml", null, null,excludeid, user);
				}
			}
			//SubCompanyComInfo.getSubCompanyTreeList(root,"0",0,10,false,"subcompanyMutiByRight",null,null,excludeid, user);

			//envelope.marshal(out);
			weaver.common.util.string.StringUtil.parseXml(out, envelope,true);
%>
