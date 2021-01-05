<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=utf-8" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkFlowFieldTransMethod" class="weaver.workflow.workflow.WorkFlowFieldTransMethod" scope="page" />
<%@ page import="weaver.workflow.workflow.WfLinkageInfo" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="net.sf.json.JSONArray" %>
<%@ page import="net.sf.json.JSONObject" %>
<%

User user = HrmUserVarify.getUser (request , response) ;
String src = Util.null2String(request.getParameter("src"));
int wfid = Util.getIntValue(request.getParameter("wfid"));
String fieldname = Util.null2String(request.getParameter("fieldname"));
String tabletype = Util.null2String(request.getParameter("tabletype"));
String selfieldid = Util.null2String(request.getParameter("systemIds"));
String resourceids = Util.null2String(request.getParameter("resourceids"));
if(selfieldid.trim().startsWith(",")){
	selfieldid = selfieldid.substring(1);
}
int perpage = Util.getIntValue(request.getParameter("pageSize"),10) ;
int pagenum = Util.getIntValue(request.getParameter("currentPage") , 1) ;

String sqlWhere = " ";
String SqlWhere = "";

String isbill = "";
String formid = "";
RecordSet.executeSql("select formid, isbill from workflow_base where id=" + wfid);
if(RecordSet.next()) {
	formid = RecordSet.getString("formid");
	isbill = RecordSet.getString("isbill");
}

if(isbill.equals("0")) { // 表单
	SqlWhere = " where a.formid=b.formid and a.fieldid=b.fieldid and a.formid=" + formid + " and b.langurageid = " + user.getLanguage();
}else if(isbill.equals("1")) { // 单据
	SqlWhere = " where a.fieldlabel = b.id and a.billid=" + formid;
}
RecordSet rs = new RecordSet();
JSONObject json = new JSONObject();
if(src.equalsIgnoreCase("dest")){//右侧已选择列表的sql条件
	if (!selfieldid.equals("")) {
		if(selfieldid.indexOf(",")==0){
			selfieldid=selfieldid.substring(1);
		}
		if(isbill.equals("0")) { // 表单
			sqlWhere += " and a.fieldid in(" + selfieldid + ") ";
		}else if(isbill.equals("1")) { // 单据
			sqlWhere += " and a.id in(" + selfieldid + ") ";
		}
		String strtmp = "";
		if(isbill.equals("0")) { // 表单
			strtmp = "select a.fieldid as id, b.fieldlable, a.isdetail, a.fieldorder "
				+ " from workflow_formfield a, workflow_fieldlable b "
				+ " where a.formid=b.formid and a.fieldid=b.fieldid and a.formid=" + formid + " and b.langurageid = " + user.getLanguage()
				+ " and a.fieldid in (" + selfieldid + ") "
				+ " order by a.isdetail, a.fieldorder ";
		}else if(isbill.equals("1")) { // 单据
			strtmp = "select a.id, b.indexdesc as fieldlable, a.viewtype as isdetail, a.dsporder as fieldorder "
					+ " from workflow_billfield a, HtmlLabelIndex b "
					+ " where a.fieldlabel = b.id and a.billid=" + formid
					+ " and a.id in (" + selfieldid + ") "
					+ " order by a.viewtype, a.dsporder ";
		}
		rs.executeSql(strtmp);
	} else {
		json.put("currentPage", 1);
		json.put("totalPage", 1);
		json.put("mapList","");
		out.println(json.toString());
		return;
	}
	//SqlWhere+=sqlWhere;
}else{//左侧待选择列表的sql条件
		
	String name = Util.null2String(request.getParameter("name"));
	String description = Util.null2String(request.getParameter("description"));
	String prjtype = Util.null2String(request.getParameter("prjtype"));
	String worktype = Util.null2String(request.getParameter("worktype"));
	String manager = Util.null2String(request.getParameter("manager"));
	String status = Util.null2String(request.getParameter("status"));
	String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));

	String resourcenames = "";
	if (!selfieldid.equals("")) {
		String strtmp = "";
		if(isbill.equals("0")) { // 表单
			strtmp = "select a.fieldid as id, b.fieldlable, a.isdetail, a.fieldorder "
				+ " from workflow_formfield a, workflow_fieldlable b "
				+ " where a.formid=b.formid and a.fieldid=b.fieldid and a.formid=" + formid + " and b.langurageid = " + user.getLanguage()
				+ " and a.fieldid in (" + selfieldid + ") "
				+ " order by a.isdetail, a.fieldorder ";
		}else if(isbill.equals("1")) { // 单据
			strtmp = "select a.id, b.indexdesc as fieldlable, a.viewtype as isdetail, a.dsporder as fieldorder "
					+ " from workflow_billfield a, HtmlLabelIndex b "
					+ " where a.fieldlabel = b.id and a.billid=" + formid
					+ " and a.id in (" + selfieldid + ") "
					+ " order by a.viewtype, a.dsporder ";
		}
		RecordSet.executeSql(strtmp);
		Hashtable ht = new Hashtable();
		while (RecordSet.next()) {
			ht.put( Util.null2String(RecordSet.getString("id")), Util.null2String(RecordSet.getString("fieldlable")));
		}
		try{
			StringTokenizer st = new StringTokenizer(selfieldid,",");

			while(st.hasMoreTokens()){
				String s = st.nextToken();
				resourceids +=","+s;
				resourcenames += ","+ht.get(s).toString();
			}
		}catch(Exception e){
			resourceids ="";
			resourcenames ="";
		}
	}

	if(!"".equals(fieldname)) {
	if(isbill.equals("0")) { // 表单
		sqlWhere += " and b.fieldlable like '%" + fieldname + "%' ";
	}else if(isbill.equals("1")) { // 单据
		sqlWhere += " and b.indexdesc like '%" + fieldname + "%' ";
	}
	}
	if(!"".equals(tabletype)) {
		if(isbill.equals("0")) { // 表单
			if("0".equals(tabletype)) { // 主表
				sqlWhere += " and (a.isdetail != 1 or a.isdetail is null) ";
			}else if("1".equals(tabletype)) { // 明细
				sqlWhere += " and a.isdetail = 1 ";
			}
		}else if(isbill.equals("1")) { // 单据
			sqlWhere += " and a.viewtype = " + tabletype + " ";
		}
	}
	
	// TODO
	SqlWhere += sqlWhere +sqlwhere;

	if (selfieldid.equals("")) {
		//selfieldid = Util.null2String(request.getParameter("excludeId"));
	}
	if (!selfieldid.equals("")) {
		if(selfieldid.indexOf(',')==0){
			selfieldid=selfieldid.substring(1);
		}
		//SqlWhere += " and t1.id not in ("+selfieldid+")";
	}
	
	SplitPageParaBean spp = new SplitPageParaBean();
	if(isbill.equals("0")) { // 表单
		
		
		spp.setBackFields(" a.fieldid as id, b.fieldlable, a.isdetail, a.fieldorder ");
		spp.setSqlFrom(" workflow_formfield a, workflow_fieldlable b ");
		spp.setSqlOrderBy(" a.isdetail, a.fieldorder ");
		spp.setPrimaryKey("a.fieldid");
		
	}else if(isbill.equals("1")) { // 单据
		
		
		spp.setBackFields(" a.id, b.indexdesc as fieldlable, a.viewtype as isdetail, a.dsporder as fieldorder ");
		spp.setSqlFrom(" workflow_billfield a, HtmlLabelIndex b ");
		spp.setSqlOrderBy(" a.viewtype, a.dsporder ");
		spp.setPrimaryKey("a.id");
		
	}
	spp.setSqlWhere(SqlWhere);
	spp.setSortWay(spp.ASC);
	SplitPageUtil spu = new SplitPageUtil();
	spu.setSpp(spp);
	
	rs = spu.getCurrentPageRs(pagenum, perpage);
}




int totalPage =1;
/**
int RecordSetCounts = spu.getRecordCount();
totalPage = RecordSetCounts/perpage;
if(totalPage%perpage>0||totalPage==0){
	totalPage++;
}
**/

String id=null;
String fieldlable=null;
String isdetail=null;

int i=0;


JSONArray jsonArr = new JSONArray();
while(rs.next()) {
	id = rs.getString("id");
	fieldlable = Util.null2String(rs.getString("fieldlable"));
	isdetail=WorkFlowFieldTransMethod.getFieldTableType2( Util.null2String(rs.getString("isdetail")));
	JSONObject tmp = new JSONObject();
	tmp.put("id",id);
	tmp.put("name",fieldlable);	
	tmp.put("status",isdetail);	
	jsonArr.add(tmp);
}
json.put("currentPage", pagenum);
json.put("totalPage", totalPage);
json.put("mapList",jsonArr.toString());
out.println(json.toString());
%>
