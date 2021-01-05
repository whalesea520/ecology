<%@ page language="java" contentType="text/xml; charset=UTF-8" %>
<%@ page import="java.util.*,weaver.hrm.*,weaver.general.Util,weaver.common.util.xtree.TreeNode" %>
<jsp:useBean id="rsc" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="signIn" class="weaver.hrm.mobile.signin.SignInManager" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
	response.setHeader("cache-control", "no-cache");
	response.setHeader("pragma", "no-cache");
	response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
	User user = HrmUserVarify.getUser(request , response);
	if(user == null)  return;
	String id = Util.null2String(request.getParameter("id"));
	boolean appendthis = Boolean.valueOf(Util.null2String(request.getParameter("appendthis"), "true"));
	String slg = Util.null2String(request.getParameter("slg"), "i");
	int isFirst = Util.getIntValue(request.getParameter("isfirst"), 1);
	if(HrmUserVarify.checkUserRight("MobileSignInfo:Manage", user)){
		if(slg.equals("c")){
			TreeNode envelope=new TreeNode();
			envelope.setTitle("envelope");
			
			if(appendthis){
				TreeNode root = new TreeNode();
				String sql = "";
				if(rs.getDBType().equals("oracle")){
					sql = "select id from HrmResource where status in (0,1,2,3) and (managerid is null or managerid<=0 or managerid=id) order by dsporder,id";
				}else{
					sql = "select id from HrmResource where status in (0,1,2,3) and (managerid is null or managerid='' or managerid<=0 or managerid=id) order by dsporder,id";
				}
				rs.executeSql(sql);
				while(rs.next()){
					String resourceId = Util.null2String(rs.getString("id"));
					root = new TreeNode();
					root.setTitle(rsc.getResourcename(resourceId));
					root.setNodeId("res_"+resourceId);
					root.setTarget("_self");
					root.setCheckbox("Y");
					root.setValue(resourceId);
					root.setOncheck("check(" + root.getNodeId() + ")");
					envelope.addTreeNode(root);
					signIn.getSubordinateTreeListByCheck(root, resourceId);
				}
			}else{
				signIn.getSubordinateTreeListByCheck(envelope, id);
			}
			weaver.common.util.string.StringUtil.parseXml(out, envelope);
		} else {
			out.print(isFirst!=1 && id.length()==0 ? "" : signIn.getSubordinateTreeList(id, slg, isFirst, true));
		}
	}else{
		if(slg.equals("c")){
			TreeNode envelope=new TreeNode();
			envelope.setTitle("envelope");
			
			TreeNode root = new TreeNode();
			root.setTitle(rsc.getResourcename(id));
			root.setNodeId("res_"+id);
			root.setTarget("_self");
			root.setCheckbox("Y");
			root.setValue(id);
			root.setOncheck("check(" + root.getNodeId() + ")");
			if(appendthis) envelope.addTreeNode(root);
			signIn.getSubordinateTreeListByCheck(appendthis ? root : envelope, id);
			weaver.common.util.string.StringUtil.parseXml(out, envelope);
		} else {
			out.print(id.length()==0 ? "" : signIn.getSubordinateTreeList(id, slg, isFirst));
		}
	}
%>