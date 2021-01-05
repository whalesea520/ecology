
<%@ page language="java" contentType="application/x-json;charset=UTF-8" %>
<%@ page import="org.json.*" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.general.StaticObj" %>
<%@ page import="weaver.interfaces.workflow.browser.*" %>
<%@ page import="weaver.interfaces.workflow.browser.BrowserBean" %>
<%@ page import="weaver.workflow.workflow.WorkTypeComInfo" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>

<%
String isreport = Util.getIntValue(request.getParameter("isreport"),0)+"";

User user = HrmUserVarify.getUser (request , response) ;

if(user == null)  return ;
String id=Util.null2String(request.getParameter("node"));
String type=Util.null2String(request.getParameter("type"));
String checked=Util.null2String(request.getParameter("checked"));
String workflowid = Util.getIntValue(request.getParameter("workflowid"),-1)+"";
String currenttime = Util.null2String(request.getParameter("currenttime"));
//System.out.println("123123 id : "+id);
String selectid="";
if(!"".equals(id)&&!"root".equals(id))
	selectid = id;
Browser browser=(Browser)StaticObj.getServiceByFullname(type, Browser.class);
String href = Util.null2String(browser.getHref());
String outpage = Util.null2String(browser.getOutPageURL());
String search = Util.null2String(browser.getSearch())+" ";

/*Enumeration em = request.getParameterNames();
while(em.hasMoreElements())
{
	String pname = (String)em.nextElement();
	String pvalue = Util.null2String(request.getParameter(pname));
	System.out.println("pname : "+pname+" pvalue : "+pvalue);
}*/
String tablename = "";
int fromidx = search.indexOf("from");
if(fromidx>0)
{
	tablename = search.substring(fromidx+4,search.length());
}
String showtree = Util.null2String(browser.getShowtree());
String nodename = Util.null2String(browser.getNodename());
String parentid = Util.null2String(browser.getParentid());
String ismutil = Util.null2String(browser.getIsmutil());
String from = Util.null2String(browser.getFrom());
//if(from.equals("2")){
	browser.initBaseBrowser("",type,from);
//}
//System.out.println("id : "+id+"   tablename : "+tablename+" nodename : "+nodename+" parentid : "+parentid);
JSONArray jsonArrayReturn= new JSONArray();
//System.out.println("type : "+type);
List l = null;
Map searchvaluemap = new HashMap();
String parentfield = browser.getParentfield();
//System.out.println("123123 parentfield : "+parentfield+"  selectid : "+selectid);
int datafrom = browser.getDatafrom();
if(1==datafrom)
{
	if("".equals(selectid))
	{
		selectid = "0";
	}
}
searchvaluemap.put(parentfield,selectid);
browser.setSearchValueMap(searchvaluemap);

session = request.getSession(true);
String needChangeFieldString = Util.null2String((String)session.getAttribute("needChangeFieldString_"+workflowid+"_"+currenttime));
HashMap allField = (HashMap)session.getAttribute("allField_"+workflowid+"_"+currenttime);
ArrayList allFieldList = (ArrayList)session.getAttribute("allFieldList_"+workflowid+"_"+currenttime);
if(allField==null){
	allField = new HashMap();
}//System.out.println(allField);
if(allFieldList==null){
	allFieldList = new ArrayList();
}
String fieldids[] = needChangeFieldString.split(",");
HashMap valueMap = (HashMap)session.getAttribute("valueMap_"+workflowid+"_"+currenttime);
if(isreport.equals("0")){
for(int i=0;i<allFieldList.size();i++){
	String fieldname = Util.null2String((String)allFieldList.get(i));
	if(!fieldname.equals("")){
		String fieldid = Util.null2String((String)allField.get(fieldname));
		String fieldvalue = Util.null2String((String)valueMap.get(fieldid));
		
		if("".equals(fieldvalue)){
		  fieldvalue = "''";
		}
		//System.out.println("fieldname="+fieldname+", fieldvalue="+fieldvalue);
		search = search.replace(fieldname,fieldvalue);
	}
}
}else{//报表需要将变量去掉
	search = removeDefaultValue(search);
}

l=browser.search(""+user.getUID(),search,searchvaluemap);
Iterator iter=l.iterator();
while(iter.hasNext()){
    BrowserBean bean=(BrowserBean)iter.next();
	String nodeId = bean.getId();
	String nodeName=bean.getName();
	String nodePaId=bean.getParentId();
	//System.out.println("123123 nodeId : "+nodeId+"  nodeName : "+nodeName);
	JSONObject jsonTypeObj=new JSONObject();	
	
	//if("1".equals(wfTypeId)) continue; 
	jsonTypeObj.put("id",nodeId);
	jsonTypeObj.put("pId",nodePaId);
	jsonTypeObj.put("name",nodeName);
	jsonTypeObj.put("open","false");
	jsonArrayReturn.put(jsonTypeObj);
}

out.println(jsonArrayReturn.toString());
%>
<%!
public String removeDefaultValue(String sql)
{
	sql = sql.replaceAll("''''","''").replaceAll("%''%","%%");//对空字符串的特殊处理
	sql = sql.replaceAll("from[ ]+table[ ]+\\(", "from table(");//对oracle表函数的特殊处理
	sql = sql.replaceAll("\\([ ]+\\{\\?", "({?");//对自定义变量的特殊处理
	
	//in和not in特殊情况处理
	sql = sql.replaceAll("[\\s]+[_a-zA-Z0-9.]+[\\s]+((not|NOT)[\\s]+)?(in|IN)[\\s]+[\\(][\\s]*''''[\\s]*[\\)][\\s]+", " 1=1 ");
	sql = sql.replaceAll("[\\s]+[_a-zA-Z0-9.]+[\\s]+((not|NOT)[\\s]+)?(in|IN)[\\s]+[\\(][\\s]*[']?(\\$|\\{\\?)[_a-zA-Z0-9]+(\\$|\\})[']?[\\s]*[\\)][\\s]+", " 1=1 ");
	sql = sql.replaceAll("[\\s]+[_a-zA-Z0-9.]+[\\s]+((not|NOT)[\\s]+)?(in|IN)[\\s]+[\\(][\\s]*'*[\\s]*'*[\\s]*[\\)][\\s]+", " 1=1 ");
	//like和not like特殊情况处理
	sql = sql.replaceAll("[\\s]+[_a-zA-Z0-9.]+[\\s]+((not|NOT)[\\s]+)?(like|LIKE)[\\s]+[\\(]?[\\s]*[']?%?(\\$|\\{\\?)[_a-zA-Z0-9]+(\\$|\\})%?[']?[\\s]*[\\)]?[\\s]+", " 1=1 ");
	sql = sql.replaceAll("'%''%'", "'%%'");
	//去除between and
	sql = sql.replaceAll("[\\s]+[_a-zA-Z0-9.]+[\\s]+((not|NOT)[\\s]+)?(between|BETWEEN)[\\s]+[']?(\\$|\\{\\?)[_a-zA-Z0-9]+(\\$|\\})[']?[\\s]+(and|AND)[\\s]+[']?(\\$|\\{\\?)[_a-zA-Z0-9]+(\\$|\\})[']?[\\s]+", " 1=1 ");
	
	//id=$fieldname$ id=$userid$
	sql = sql.replaceAll("[\\s]+[_a-zA-Z0-9.]+[\\s]+[=<>!]{1,2}[\\s]+[']?(\\$|\\{\\?)[_a-zA-Z0-9]+(\\$|\\})[']?[\\s]+", " 1=1 ");
	//$fieldname$=id  $userid$=id
	sql = sql.replaceAll("[\\s]+[']?(\\$|\\{\\?)[_a-zA-Z0-9]+(\\$|\\})[']?[\\s]+[=<>!]{1,2}[\\s]+[_a-zA-Z0-9.]+[\\s]+", " 1=1 ");
	
	sql = sql.replaceAll("([ \\s\\(]+)[_a-zA-Z0-9.]*[\\(]?[_a-zA-Z0-9,.]*[']?[%]?\\$[_a-zA-Z0-9]+\\$[%]?[']?[_a-zA-Z0-9,.]*[\\)]?[ \\s]*([=<>!]{1,2}|not[\\s]+like|like|not[\\s]+in|in|NOT[\\s]+LIKE|LIKE|NOT[\\s]+IN|IN)[\\s]+[_a-zA-Z0-9.,\\(\\)]+([\\) \\s]+)", " $1 1=1 $3 ");
	sql = sql.replaceAll("([ \\s\\(]+)[_a-zA-Z0-9.,\\(\\)]+[ \\s]*([=<>!]{1,2}|not[\\s]+like|like|not[\\s]+in|in|NOT[\\s]+LIKE|LIKE|NOT[\\s]+IN|IN)[ \\s]*[_a-zA-Z0-9.]*[\\(]?[_a-zA-Z0-9,.]*[']?[%]?\\$[_a-zA-Z0-9]+\\$[%]?[']?[_a-zA-Z0-9,.]*[\\s]+[\\)]?([\\) \\s]+)", " $1 1=1 $3 ");
	sql = sql.replaceAll("([ \\s\\(]+)[_a-zA-Z0-9.]*[\\(]?[_a-zA-Z0-9,.]*[']?[%]?\\{\\?[a-z]+\\}[%]?[']?[_a-zA-Z0-9,.]*[\\)]?[ \\s]*([=<>!]{1,2}|not[\\s]+like|like|not[\\s]+in|in|NOT[\\s]+LIKE|LIKE|NOT[\\s]+IN|IN)[ \\s]*[_a-zA-Z0-9.,\\(\\)]+([\\) \\s]+)", " $1 1=1 $3 ");
	sql = sql.replaceAll("([ \\s\\(]+)[_a-zA-Z0-9.,\\(\\)]+[ \\s]*([=<>!]{1,2}|not[\\s]+like|like|not[\\s]+in|in|NOT[\\s]+LIKE|LIKE|NOT[\\s]+IN|IN)[ \\s]*[_a-zA-Z0-9.]*[\\(]?[_a-zA-Z0-9,.]*[']?[%]?\\{\\?[a-z]+\\}[%]?[']?[_a-zA-Z0-9,.]*[\\)]?([\\) \\s]+)", " $1 1=1 $3 ");

	return sql;
}
%>
