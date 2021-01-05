<%@page import="com.weaver.formmodel.util.StringHelper"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.Writer"%>
<%@ page import="weaver.general.StaticObj" %>
<%@ page import="weaver.interfaces.workflow.browser.Browser" %>
<%@ page import="weaver.interfaces.workflow.browser.BrowserBean" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
response.setContentType("text/xml;charset=UTF-8");
request.setCharacterEncoding("utf-8");
String formid=Util.getIntValue(request.getParameter("formid"),0)+"";
String isbill=Util.getIntValue(request.getParameter("isbill"),-1)+"";
String workflowid = Util.getIntValue(request.getParameter("workflowid"),-1)+"";
String browserType = Util.null2String(request.getParameter("browserType"));
String frombrowserid = Util.null2String(request.getParameter("frombrowserid"));//触发字段id
String iscustom = Util.null2String(request.getParameter("iscustom"));

//browserType = java.net.URLDecoder.decode(browserType);
String sql = "";
if("-1".equals(workflowid)) { // 从表单建模进来isbill设为1
	isbill = "1";
}

boolean ismainfiled = true;//是主字段
String detailrow = "";//如果是明字段，代表行号
String fromdetailtable = "";//如果是明字段，代表明细表
String fromfieldid = "";//触发字段id
String strs[] = frombrowserid.split("_");
if(strs.length==2){
	fromfieldid = strs[0];
	detailrow = strs[1];
	ismainfiled = false;
}else{
	fromfieldid = strs[0];
}
fromfieldid = fromfieldid.toLowerCase();
if(fromfieldid.indexOf("field")>=0){
	fromfieldid = fromfieldid.replace("field","");
}
if(browserType.indexOf("browser.")==-1)
{
	browserType = "browser."+browserType;
}

ArrayList allFieldList = new ArrayList();//主字段
HashMap allField = new HashMap();//主字段
ArrayList needChangeField = new ArrayList();//需要转换的字段
String needChangeFieldString = "";
if(isbill.equals("1")){//单据
	sql = "select id,fieldname,detailtable from workflow_billfield where billid = "+formid;
	rs.executeSql(sql);
	while(rs.next()){
		String id = "field"+Util.null2String(rs.getString("id"));
		String fieldname = Util.null2String(rs.getString("fieldname")).toLowerCase();
		String detailtable = Util.null2String(rs.getString("detailtable")).toLowerCase();
		if(!detailtable.equals("")){
			detailtable = detailtable + "_";
		}
		if(id.equals("field"+fromfieldid)){
			fromdetailtable = detailtable;
		}
		fieldname = "$"+detailtable+fieldname+"$";
		allField.put(fieldname.toLowerCase(),id);
		allFieldList.add(fieldname);
	}
}else{//表单
	//主字段
	sql = "select b.id,b.fieldname from workflow_formfield a,workflow_formdict b where a.fieldid = b.id and formid = " + formid;
	rs.executeSql(sql);
	while(rs.next()){
		String id = "field"+Util.null2String(rs.getString("id"));
		String fieldname = "$"+Util.null2String(rs.getString("fieldname"))+"$";
		
		allField.put(fieldname.toLowerCase(),id);
		allFieldList.add(fieldname);
	}
	//明细字段
	sql = "select b.id,b.fieldname from workflow_formfield a,workflow_formdictdetail b where a.fieldid = b.id and formid = " + formid;
	rs.executeSql(sql);
	while(rs.next()){
		String id = "field"+Util.null2String(rs.getString("id"));
		String fieldname = "$detail_"+Util.null2String(rs.getString("fieldname"))+"$";
		if(id.equals("field"+fromfieldid)){
			fromdetailtable = "detail_";
		}
		
		allField.put(fieldname.toLowerCase(),id);
		allFieldList.add(fieldname);
	}
}
Browser browser=null;
String Search = "";//
String SearchByName = "";//
String from = "";
Map paramvalues = null;
try
{
	browser=(Browser)StaticObj.getServiceByFullname(browserType, Browser.class);
	Search = browser.getSearch().toLowerCase();//
	SearchByName = browser.getSearchByName().toLowerCase();//
	from = Util.null2String(browser.getFrom());
	paramvalues = browser.getParamvalues();
}
catch(Exception e)
{
	e.printStackTrace();
}
if(from.equals("2")&&null!=browser){
	browser.initBaseBrowser("",browserType,from);
}
for(int i=0;i<allFieldList.size();i++){
	String fieldname = Util.null2String((String)allFieldList.get(i));
	if(from.equals("2")&&null!=browser){
		Map map = (Map)browser.getWokflowfieldnameMap();
		
		if(null!=map&&map.size()>0)
		{
			Set keyset = map.keySet(); 
			for(Iterator it = keyset.iterator();it.hasNext();)
			{
				String searchfieldname = Util.null2String((String)it.next());
				String workflowname = Util.null2String((String)map.get(searchfieldname));
				String fieldid = Util.null2String((String)allField.get(workflowname));
				
				if(!"".equals(fieldid)&&fieldname.equalsIgnoreCase(workflowname))
				{
					int isdetailfield = fieldname.indexOf(fromdetailtable);
					if(isdetailfield>=0&&!fromdetailtable.equals("")){
						fieldid = fieldid+"_"+detailrow;
					}
					needChangeFieldString += searchfieldname+"="+fieldid + ",";
				}
			}
		}
		if(null!=paramvalues&&paramvalues.size()>0)
		{
			Set keyset = paramvalues.keySet(); 
			for(Iterator it = keyset.iterator();it.hasNext();)
			{
				String searchfieldname = Util.null2String((String)it.next());
				String workflowname = Util.null2String((String)paramvalues.get(searchfieldname));
				String fieldid = Util.null2String((String)allField.get(workflowname));
				if(!"".equals(fieldid)&&fieldname.equalsIgnoreCase(workflowname))
				{
					int isdetailfield = fieldname.indexOf(fromdetailtable);
					if(isdetailfield>=0&&!fromdetailtable.equals("")){
						fieldid = fieldid+"_"+detailrow;
					}
					needChangeFieldString += searchfieldname+"="+fieldid + ",";
				}
			}
		}
	}
	if(from.equals("1")||Search.indexOf("$")>-1)
	{
		String _fieldname = fieldname.substring(1,fieldname.length()-1);
		if(from.equals("1")||Search.indexOf("$")>-1)
		{
			int searchIndex = Search.indexOf(fieldname);
			int searchByNameIndex = SearchByName.indexOf(fieldname);
			
			if(searchIndex>=0||searchByNameIndex>=0){
				String fieldid = Util.null2String((String)allField.get(fieldname));
				int isdetailfield = fieldname.indexOf(fromdetailtable);
				if(isdetailfield>=0&&!fromdetailtable.equals("")){
					if(!"1".equals(iscustom)){
						fieldid = fieldid+"_"+detailrow;
					}
				}
				needChangeFieldString += _fieldname+"="+fieldid+",";
				
			}
		}
	}
}
%>
<value>
<%=needChangeFieldString%>
</value>