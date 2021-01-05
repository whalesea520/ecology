<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=utf-8" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WFNodeMainManager" class="weaver.workflow.workflow.WFNodeMainManager" scope="page" />
<%@ page import="weaver.workflow.workflow.WfLinkageInfo" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="java.util.*" %>
<%@ page import="org.json.JSONArray" %>
<%@ page import="org.json.JSONObject" %>
<%

User user = HrmUserVarify.getUser (request , response) ;
int wfid = Util.getIntValue(request.getParameter("wfid"));
int formid = Util.getIntValue(request.getParameter("formid"));
int isbill = Util.getIntValue(request.getParameter("isbill"));

String firstnodeid="0";
String firstselectfieldid="0";
WFNodeMainManager.setWfid(wfid);
WFNodeMainManager.selectWfNode();
ArrayList nodeidlist=new ArrayList();
while(WFNodeMainManager.next()){
    String tnodeid=""+WFNodeMainManager.getNodeid();
    String tnodename=WFNodeMainManager.getNodename();
    String tnodetype=WFNodeMainManager.getNodetype();
    if(tnodetype.equals("3")) continue;
    nodeidlist.add(tnodeid);
}

String sql="select * from workflow_viewattrlinkage where workflowid="+wfid+" order by nodeid,selectfieldid,selectfieldvalue";
rs.executeSql(sql);
int i=0;
String checkfield="";
WfLinkageInfo wfli=new WfLinkageInfo();
wfli.setFormid(formid);
wfli.setIsbill(isbill);
wfli.setWorkflowid(wfid);

JSONArray jsonArray=new JSONArray();
JSONArray ajaxData=new JSONArray();
JSONObject jsonObject=new JSONObject();

while(rs.next()){
    String nodeid=Util.null2String(rs.getString("nodeid"));
    String selectfieldid=Util.null2String(rs.getString("selectfieldid"));
    String selectfieldvalue=Util.null2String(rs.getString("selectfieldvalue"));
    String changefieldids=Util.null2String(rs.getString("changefieldids"));
    String viewattr=Util.null2String(rs.getString("viewattr"));
    checkfield+="nodeid_"+i+",selectfieldid_"+i+",selectfieldvalue_"+i+",changefieldids_"+i+",";
    ArrayList changefieldidlist=Util.TokenizerString(changefieldids,",");
    ArrayList[] tempselectfield=wfli.getSelectFieldByEdit(Util.getIntValue(nodeid));
    ArrayList tselectfieldidlist=tempselectfield[0];
    ArrayList tselectfieldnamelist=tempselectfield[1];
    ArrayList tselectfieldisdetaillist=tempselectfield[2];
    ArrayList[] tempselectfieldvalue=wfli.getSelectFieldItem(Util.getIntValue(selectfieldid.substring(0,selectfieldid.indexOf("_"))));
    ArrayList tselectfieldvaluelist=tempselectfieldvalue[0];
    ArrayList tselectfieldvaluenamelist=tempselectfieldvalue[1];
    int index=selectfieldid.indexOf("_");
    String viewtype="";
    int tselectfieldid=0;
    if(index!=-1){
        tselectfieldid=Util.getIntValue(selectfieldid.substring(0,index));
        viewtype=selectfieldid.substring(index+1);
    }
    wfli.setViewtype(viewtype);
    wfli.setFieldid(tselectfieldid);
    ArrayList[] tempfield=wfli.getFieldsByEdit(Util.getIntValue(nodeid));
    ArrayList tfieldidlist=tempfield[0];
    ArrayList tfieldnamelist=tempfield[1];
    int notnodeid=nodeidlist.indexOf(nodeid);
    int notselectfield=tselectfieldidlist.indexOf(selectfieldid.substring(0,selectfieldid.indexOf("_")));
    int notselectfieldvalue=tselectfieldvaluelist.indexOf(selectfieldvalue);
    String fieldnames="";
    for(int j=0;j<changefieldidlist.size();j++){
        String tfieldid=(String)changefieldidlist.get(j);
        tfieldid=tfieldid.substring(0,tfieldid.indexOf("_"));
        int _index=tfieldidlist.indexOf(tfieldid);
        if(_index<0||selectfieldid.equals(changefieldidlist.get(j))){
            fieldnames+="<a href='#"+(String)changefieldidlist.get(j)+"'><font style='background-color:red'>"+wfli.getFieldnames(Util.getIntValue(tfieldid))+"</font></a>,";
        }else{
            fieldnames+="<a href='#"+(String)changefieldidlist.get(j)+"'>"+tfieldnamelist.get(_index)+"</a>,";
        }
    }
    if(fieldnames.endsWith(",")){
    	fieldnames = fieldnames.substring(0,fieldnames.length()-1);
    }
    
    jsonArray=new JSONArray();
    jsonObject=new JSONObject();
	jsonObject.put("name", "viewid");
	jsonObject.put("iseditable", "true");
	jsonObject.put("value", Util.null2String(rs.getString("ndeid")));
	jsonObject.put("type", "checkbox");
	jsonArray.put(jsonObject);
	
	jsonObject=new JSONObject();
	jsonObject.put("name", "nodeid");
	jsonObject.put("iseditable", "true");
	jsonObject.put("value", Util.null2String(rs.getString("nodeid")));
	jsonObject.put("type", "select");
	jsonArray.put(jsonObject);
	
	jsonObject=new JSONObject();
	jsonObject.put("name", "selectfieldid");
	jsonObject.put("iseditable", "true");
	jsonObject.put("value", Util.null2String(rs.getString("selectfieldid")));
	jsonObject.put("type", "select");
	jsonArray.put(jsonObject);
	
	jsonObject=new JSONObject();
	jsonObject.put("name", "selectfieldvalue");
	jsonObject.put("iseditable", "false");
	jsonObject.put("value", Util.null2String(rs.getString("selectfieldvalue")));
	jsonObject.put("type", "select");
	jsonArray.put(jsonObject);
	
	jsonObject=new JSONObject();
	jsonObject.put("name", "changefieldids");
	jsonObject.put("iseditable", "false");
	jsonObject.put("value", changefieldids);
	
	jsonObject.put("label", fieldnames);
	jsonObject.put("type", "browser");
	jsonArray.put(jsonObject);
	
	jsonObject=new JSONObject();
	jsonObject.put("name", "viewattr");
	jsonObject.put("iseditable", "true");
	jsonObject.put("value", Util.null2String(rs.getString("viewattr")));
	jsonObject.put("type", "select");
	jsonArray.put(jsonObject);
	
	ajaxData.put(jsonArray);
   }
out.println(ajaxData.toString());
%>
