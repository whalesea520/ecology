
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util"%>
<%@ page import="net.sf.json.JSONArray" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.general.*,weaver.file.Prop" %>
<%@page import="java.util.ArrayList"%>
<jsp:useBean id="MutilResourceBrowser" class="weaver.hrm.resource.MutilResourceBrowser" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="SubCompanyVirtualComInfo" class="weaver.hrm.companyvirtual.SubCompanyVirtualComInfo" scope="page"/>
<jsp:useBean id="DepartmentVirtualComInfo" class="weaver.hrm.companyvirtual.DepartmentVirtualComInfo" scope="page"/>
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<%
User user = HrmUserVarify.getUser (request , response) ;
String cmd = Util.null2String(request.getParameter("cmd"));
String alllevel = Util.null2String(request.getParameter("alllevel"));
String isNoAccount = Util.null2String(request.getParameter("isNoAccount"));
String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));

if(cmd.equals("workflow")){
	//格式化数据
	String types = Util.null2String(request.getParameter("type"));
	String ids = Util.null2String(request.getParameter("id"));

	if(ids.length()==0)out.print("[]");
	JSONArray jsonArr = new JSONArray();
	JSONObject json = new JSONObject();
	String[] arrtypes = types.split(",");
	String[] arrids = ids.split(",");
	
	for(int i=0;i<arrtypes.length;i++){
		String type = arrtypes[i];
		String id = arrids[i];
		ArrayList jsonid = new ArrayList();
		ArrayList jsonname = new ArrayList();
		ArrayList jsonjobtitle = new ArrayList();
		String resourceids = "";
		String name = "";
		if(type.equals("resource")){
			//人员直接取缓存
			resourceids =  id;
			name = ResourceComInfo.getLastname(id);
		}else if(type.equals("subcom")||type.equals("dept")||type.equals("com")){//分部 部门
			String nodeid = type+"_"+id;
			if(Integer.parseInt(id)<0){
				//虚拟
				resourceids = MutilResourceBrowser.getComDeptResourceVirtualIds(nodeid,alllevel,isNoAccount,user, sqlwhere);
				if(type.equals("subcom")){
					name = SubCompanyVirtualComInfo.getSubCompanyname(id);
				}else{
					name = DepartmentVirtualComInfo.getDepartmentname(id);
				}
			}else{
				resourceids = MutilResourceBrowser.getComDeptResourceIds(nodeid,alllevel,isNoAccount,user, sqlwhere);
				if(type.equals("subcom")){
					name = SubCompanyComInfo.getSubCompanyname(id);
				}else{
					name = DepartmentComInfo.getDepartmentname(id);
				}
			}
		}else if(type.equals("group")){//自定义组
			resourceids = MutilResourceBrowser.getGroupResourceIds(id,isNoAccount,user, sqlwhere);
			rs.executeSql("select name from hrmgroup where id = "+id);
			if(rs.next()){
				name = rs.getString("name");
			}
		}
		
		String[] resourceid = Util.TokenizerString2(resourceids,",");
		for(int idx=0;resourceid!=null&&idx<resourceid.length;idx++){
			jsonid.add(resourceid[idx]);
			jsonname.add(ResourceComInfo.getLastname(resourceid[idx]));
			jsonjobtitle.add(MutilResourceBrowser.getJobTitlesname(resourceid[idx]));
		}
		
		//type：1:人力资源 2：分部 3：部门 4：公共组 5:虚拟分部 7：虚拟部门
		if(type.equals("subcom")){
			if(Integer.parseInt(id)<0){
				type="5";
			}else{
				type="2";
			}
		}else if(type.equals("dept")){
			if(Integer.parseInt(id)<0){
				type="7";
			}else{
				type="3";
			}
		}else if(type.equals("resource")){
			type="1";
		}else if(type.equals("group")){
			type="4";
		}
		
		json.put("type",type);
		json.put("typeid",id);
		json.put("title",name);
		json.put("ids",jsonid);
		json.put("names",jsonname);
		json.put("jobtitle",jsonjobtitle);
		jsonArr.add(json);
	}
	out.println(jsonArr.toString());
	//System.out.println(jsonArr.toString());
}
%>
