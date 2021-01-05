<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.Writer"%>
<%@ page import="weaver.general.StaticObj" %>
<%@ page import="weaver.parseBrowser.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SapBrowserComInfo" class="weaver.parseBrowser.SapBrowserComInfo" scope="page" />
<%
response.setContentType("text/xml;charset=UTF-8");
String formid=Util.getIntValue(request.getParameter("formid"),0)+"";
String isbill=Util.getIntValue(request.getParameter("isbill"),-1)+"";
String workflowid = Util.getIntValue(request.getParameter("workflowid"),-1)+"";
String browserType = Util.null2String(request.getParameter("browserType"));
String currenttime = Util.null2String(request.getParameter("currenttime"));
String isfirefox = Util.null2String(request.getParameter("isfirefox"));
String sapbrowserid = "";//浏览框id
String frombrowserid = "";//触发字段id
String strs[] = browserType.split("\\|");
if(strs.length==2){
	sapbrowserid = Util.null2String(strs[0]);
	frombrowserid = Util.null2String(strs[1]);
}

boolean ismainfiled = true;//是主字段
String detailrow = "";//如果是明字段，代表行号
String fromdetailtable = "";//如果是明字段，代表明细表
String fromfieldid = "";//字段id
strs = frombrowserid.split("_");
if(strs.length==2){
	fromfieldid = strs[0];
	detailrow = strs[1];
	ismainfiled = false;
}else{
	fromfieldid = strs[0];
}

//System.out.println(sapbrowserid+"	@	"+frombrowserid);
String sql = "";
ArrayList AllFieldList = new ArrayList();//主字段
HashMap AllField = new HashMap();//主字段
ArrayList needChangeField = new ArrayList();//需要转换的字段
String needChangeFieldString = "";
if(isbill.equals("1")){//单据
	sql = "select id,fieldname,detailtable from workflow_billfield where billid = "+formid;
	rs.executeSql(sql);
	while(rs.next()){
		String id = "field"+Util.null2String(rs.getString("id"));
		String detailtable = Util.null2String(rs.getString("detailtable")).toUpperCase();
		if(id.equals("field"+fromfieldid)){
			fromdetailtable = detailtable;
		}
		if(!detailtable.equals("")){
			detailtable = detailtable + "_";
		}
		String fieldname = detailtable+Util.null2String(rs.getString("fieldname")).toUpperCase();
		AllField.put(fieldname.toUpperCase(),id);
		//System.out.println("all field: "+fieldname+"	####	"+id);
		AllFieldList.add(fieldname);
	}
}else{//表单暂时不处理
	//主表数据
	//workflow_formdictdetail
	//sql = "select b.id,b.fieldname from workflow_formfield a,workflow_formdict b where a.fieldid = b.id and formid = " + formid;
	//rs.executeSql(sql);
	//while(rs.next()){
		//String id = "field"+Util.null2String(rs.getString("id"));
		//String fieldname = Util.null2String(rs.getString("fieldname"));
		//System.out.println(id+"	"+fieldname);
		//AllField.put(fieldname.toLowerCase(),id);
		//AllFieldList.add(fieldname);
	//}	
}
if("0".equals(isfirefox)){
	sapbrowserid=new String(sapbrowserid.getBytes( "iso-8859-1" ), "utf-8" );     
} 
SapBaseBrowser SapBaseBrowser = (SapBaseBrowser)SapBrowserComInfo.getSapBaseBrowser(sapbrowserid);
ArrayList import_input = SapBaseBrowser.getImport_input();
for(int i=0;i<import_input.size();i++){
	Field Field = (Field)import_input.get(i);
	String fieldname = Field.getFromOaField().toUpperCase();
	String fieldid = Util.null2String((String)AllField.get(fieldname));
	int isdetailfield = fieldname.indexOf(fromdetailtable);
	if(isdetailfield>=0&&!fromdetailtable.equals("")){
		fieldid = fieldid+"_"+detailrow;
	}
	needChangeFieldString += fieldid + ",";
	//System.out.println(fieldname.indexOf(fromdetailtable)+" @ "+fieldname+" @ "+fieldid+" @ needChangeFieldString:"+needChangeFieldString);
}

session.setAttribute("needChangeFieldString_"+workflowid+"_"+currenttime,needChangeFieldString);
session.setAttribute("AllField_"+workflowid+"_"+currenttime,AllField);
session.setAttribute("AllFieldList_"+workflowid+"_"+currenttime,AllFieldList);
%>
<value>
<%=needChangeFieldString%>
</value>