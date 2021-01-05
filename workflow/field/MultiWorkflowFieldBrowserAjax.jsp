<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=utf-8" %>
<jsp:useBean id="recordSet" class="weaver.conn.RecordSet" scope="page" />
<%@ page import="weaver.workflow.workflow.WfLinkageInfo" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="java.util.*" %>
<%@ page import="net.sf.json.JSONArray" %>
<%@ page import="net.sf.json.JSONObject" %>
<%

User user = HrmUserVarify.getUser (request , response) ;
String src = Util.null2String(request.getParameter("src"));
String documentids = Util.null2String(request.getParameter("systemIds"));
int wfid = Util.getIntValue(request.getParameter("wfid"));
int nodeid = Util.getIntValue(request.getParameter("nodeid"));
String fieldname = Util.null2String(request.getParameter("fieldname"));
String selfieldid = Util.null2String(request.getParameter("selfieldid"));
String viewtype="-1";
int selectfieldid=0;
int indx=selfieldid.indexOf("_");
if(indx!=-1){
    selectfieldid=Util.getIntValue(selfieldid.substring(0,indx));
    viewtype=selfieldid.substring(indx+1);
}
WfLinkageInfo wfli=new WfLinkageInfo();
wfli.init(wfid,user.getLanguage());
if(documentids.trim().startsWith(",")){
	documentids = documentids.substring(1);
}
if(src.equalsIgnoreCase("dest")){
	JSONArray jsonArr = new JSONArray();
	JSONArray jsonArr_tmp = new JSONArray();
	JSONObject json = new JSONObject();
	if (!documentids.equals("")) {
		 wfli.setViewtype(viewtype.trim());
         wfli.setFieldid(selectfieldid);
         ArrayList[] fieldlist=wfli.getFieldsByEdit(nodeid);
         ArrayList fieldidlist=fieldlist[0];
         ArrayList fieldnamelist=fieldlist[1];
         ArrayList fieldisdetaillist=fieldlist[2];
		for(int j=0;j<fieldidlist.size();j++){
				JSONObject tmp = new JSONObject();
				String id = fieldidlist.get(j)+"_"+fieldisdetaillist.get(j) ;
				if(!id.equals(selfieldid)){
				tmp.put("id",id);
				tmp.put("name",fieldnamelist.get(j));
				jsonArr_tmp.add(tmp);
				}
		}
		for(int j=0;j<jsonArr_tmp.size();j++){
			JSONObject tmp = (JSONObject)jsonArr_tmp.get(j);
			if(documentids.indexOf((String)tmp.get("id"))!=-1){
				jsonArr.add(tmp);
			}
		}
	}
	json.put("currentPage", 1);
	json.put("totalPage", 1);
	json.put("mapList",jsonArr.toString());
	out.println(json.toString());
	return;
}



int i=0;

int perpage = Util.getIntValue(request.getParameter("pageSize"),10) ;
//System.out.println("perpage = "+perpage);
int pagenum = Util.getIntValue(request.getParameter("currentPage") , 1) ;
if(documentids.equals("")){
	documentids = Util.null2String(request.getParameter("excludeId"));
}

wfli.setSearchfieldname(fieldname.trim());
wfli.setViewtype(viewtype.trim());
wfli.setFieldid(selectfieldid);
ArrayList[] fieldlist=wfli.getFieldsByEdit(nodeid);
ArrayList fieldidlist=fieldlist[0];
ArrayList fieldnamelist=fieldlist[1];
ArrayList fieldisdetaillist=fieldlist[2];

int RecordSetCounts = fieldidlist.size();
int totalPage = 1;

JSONArray jsonArr = new JSONArray();
JSONObject json = new JSONObject();
for(int j=0;j<fieldidlist.size();j++){
	JSONObject tmp = new JSONObject();
	String id=fieldidlist.get(j)+"_"+fieldisdetaillist.get(j);
	if(!id.equals(selfieldid)){
		tmp.put("id",id);
		tmp.put("name",fieldnamelist.get(j));
		jsonArr.add(tmp);
	}
}
json.put("currentPage", pagenum);
json.put("totalPage", totalPage);
json.put("mapList",jsonArr.toString());
out.println(json.toString());
%>
