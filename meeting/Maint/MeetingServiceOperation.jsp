<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.general.SplitPageParaBean"%>
<%@page import="weaver.general.SplitPageUtil"%>
<%@page import="weaver.conn.RecordSet"%>
<%@ page import="net.sf.json.JSONArray" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@page import="java.util.Enumeration"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
User user=HrmUserVarify.getUser(request, response);
if(user==null){
	return;
}
String method = Util.null2String(request.getParameter("method"));

if(!HrmUserVarify.checkUserRight("Meeting:Service", user)&&!"dest".equals(method)&&!"src".equals(method))
{
	response.sendRedirect("/notice/noright.jsp");
	return;
}

if("addType".equalsIgnoreCase(method)){//添加会议服务类型
	String id = Util.null2String(request.getParameter("id"));
	String name = Util.null2String(request.getParameter("name"));
	String desc = Util.null2String(request.getParameter("desc"));
	if("".equals(id)){
		RecordSet.execute("insert into Meeting_Service_type(name,desc_n) values('"+name+"','"+desc+"')");
	}else{
		RecordSet.execute("update Meeting_Service_type set name='"+name+"',desc_n='"+desc+"' where id="+id);
	}
%>	
	<script type="text/javascript">
	var parentWin;
	try{
		parentWin = parent.getParentWindow(window);
		parentWin.closeDlgARfsh();
	}catch(e){
		window.close();
	}
	</script>
<%
}else if("delType".equals(method)){//删除会议服务类型
	String ids = Util.null2String(request.getParameter("ids"));
	if(ids.endsWith(",")){
		ids=ids.substring(0,ids.length()-1);
	}
	if(ids.length()>0){
		String[] arr=ids.split(",");
		for(int i=0;i<arr.length;i++){
			RecordSet.executeSql("select * from Meeting_Service_item where type="+arr[i]);
			if(!RecordSet.next()){
				RecordSet.executeSql("delete from Meeting_Service_type where id in("+ids+")");
			}
		}
	}
	out.print("true");
}else if("addItem".equalsIgnoreCase(method)){//添加会议服务项目
	String id = Util.null2String(request.getParameter("id"));
	String itemname = Util.null2String(request.getParameter("itemname"));
	String type = Util.null2String(request.getParameter("type"));
	if("".equals(id)){
		RecordSet.execute("insert into Meeting_Service_item(itemname,type) values('"+itemname+"','"+type+"')");
	}else{
		RecordSet.execute("update Meeting_Service_item set itemname='"+itemname+"',type='"+type+"' where id="+id);
	}
%>	
	<script type="text/javascript">
	var parentWin;
	try{
		parentWin = parent.getParentWindow(window);
		parentWin.closeDlgARfsh();
	}catch(e){
		window.close();
	}
	</script>
<%
}else if("delItem".equals(method)){//删除会议服务项目
	String ids = Util.null2String(request.getParameter("ids"));
	if(ids.endsWith(",")){
		ids=ids.substring(0,ids.length()-1);
	}
	if(ids.length()>0){
		RecordSet.executeSql("delete from Meeting_Service_Item where id in("+ids+")");
	}
	out.print("true");
}else if("src".equals(method)){
	JSONObject json = new JSONObject();
	String check_per = Util.null2String(request.getParameter("systemIds"));
	Enumeration e= request.getParameterNames();
	while(e.hasMoreElements()){
		String key=(String)e.nextElement();
		//System.out.println(key+":"+request.getParameter(key));
	}
	int perpage = Util.getIntValue(request.getParameter("pageSize"),10) ;
	int pagenum = Util.getIntValue(request.getParameter("currentPage") , 1) ;
	
	String type = Util.null2String(request.getParameter("type"));
	String itemname = Util.null2String(request.getParameter("itemname"));
	 
 	String sqlwhere=" where 1=1 ";
	if(!"".equals(check_per)){
		sqlwhere+=" and s.id not in("+check_per+")";
	}
	String table="";
	 
	//查询条件
	if(!type.equals("")){
		sqlwhere += " and type = '" + type +"' ";
	}
	if(!itemname.equals("")){
			sqlwhere += " and itemname like '%" + itemname +"%' ";
	}
	
	SplitPageParaBean spp = new SplitPageParaBean();
	spp.setBackFields("  s.*,t.name  ");
	spp.setSqlFrom("  Meeting_Service_Item s join Meeting_Service_Type t on s.type=t.id ");
	spp.setSqlWhere(sqlwhere);
	spp.setSqlOrderBy(" s.id ");
	spp.setPrimaryKey("s.id");
	spp.setDistinct(true);
	spp.setSortWay(spp.ASC);
	SplitPageUtil spu = new SplitPageUtil();
	spu.setSpp(spp);
 
	int RecordSetCounts = spu.getRecordCount();
	int totalPage = RecordSetCounts/perpage;
	if(totalPage%perpage>0||totalPage==0){
		totalPage++;
	}

	RecordSet rs = spu.getCurrentPageRs(pagenum, perpage);
	JSONArray jsonArr = new JSONArray();
	while(rs.next()) {
		JSONObject tmp = new JSONObject();
		tmp.put("id",rs.getString("id"));
		tmp.put("itemname",rs.getString("itemname"));
		tmp.put("name",rs.getString("name"));
		jsonArr.add(tmp);
	}
	json.put("currentPage", pagenum);
	json.put("mapList",jsonArr.toString());
	out.println(json.toString());
	return;
}else if("dest".equals(method)){
	JSONObject json = new JSONObject();
	String systemIds = Util.null2String(request.getParameter("systemIds"));
	String sqlWhere=" where 1=1 ";
	if (!systemIds.equals("")) {
		sqlWhere += " and s.id in ("+systemIds+")";
		SplitPageParaBean spp = new SplitPageParaBean();
		spp.setBackFields("  s.*,t.name  ");
		spp.setSqlFrom("  Meeting_Service_Item s join Meeting_Service_Type t on s.type=t.id ");
		spp.setSqlWhere(sqlWhere);
		spp.setSqlOrderBy(" s.id ");
		spp.setPrimaryKey("s.id");
		spp.setDistinct(true);
		spp.setSortWay(spp.ASC);
		SplitPageUtil spu = new SplitPageUtil();
		spu.setSpp(spp);
	
		RecordSet rs = spu.getAllRs();
		JSONArray jsonArr = new JSONArray();
		while(rs.next()) {
			JSONObject tmp = new JSONObject();
			tmp.put("id",rs.getString("id"));
			tmp.put("itemname",rs.getString("itemname"));
			tmp.put("name",rs.getString("name"));
			jsonArr.add(tmp);
		}
		json.put("currentPage", 1);
		json.put("totalPage", 1);
		json.put("mapList",jsonArr.toString());
		out.println(json.toString());
		return;
		
	} else {
		json.put("currentPage", 1);
		json.put("totalPage", 0);
		json.put("mapList","");
		out.println(json.toString());
		return;
	}
}
%>
