
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.docs.category.security.*" %>
<%@ page import="weaver.docs.category.*,org.springframework.web.util.JavaScriptUtils,org.json.* " %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rswf" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SynergyComInfo" class="weaver.synergy.SynergyComInfo" scope="page"/>
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<%
User user = HrmUserVarify.getUser (request , response) ;
String stype = Util.null2String(request.getParameter("stype"));
String pagetype = Util.null2String(request.getParameter("pagetype"));
String wftypeid = Util.null2String(request.getParameter("wftypeid"));

//System.out.println("stype:"+stype+"    pagetype:"+pagetype+"    wftypeid:"+wftypeid);
String demoLeftMenus = "";

List<Map<String,Object>>  menuItems = new ArrayList<Map<String,Object>>();

Map<String,Object>  menuItem ;

Map<String,Object>  attrItem ;

demoLeftMenus = "[";
String slqnode = "";
if(pagetype.equals("menu"))
{
	if(!wftypeid.equals("0")) return;
	slqnode = "select id,wfid from synergy_base where frommodule='"+stype+"|menu' ";
	rs.execute(slqnode);
	String parentid ="";
	if(rs.first())
		parentid = Util.null2String(rs.getString("id"));

	rs.executeSql("select id from synergy_base where supid='"+parentid+"' and showtree=1 order by id");
	while(rs.next())
	{
	    menuItem = new HashMap<String,Object>();
	    menuItem.put("name",SystemEnv.getHtmlLabelName(Util.getIntValue(SynergyComInfo.getModulename(rs.getString("id"))), user.getLanguage()));
	    menuItem.put("hasChildren",false);
	    menuItem.put("isOpen",false);
	    
	    attrItem = new HashMap<String,Object>();
	    attrItem.put("_id",rs.getString("id"));
	    attrItem.put("pagetype",pagetype);
	    attrItem.put("stype",stype);
	    attrItem.put("hasChildren",false);
        
        menuItem.put("attr",attrItem);
        
        menuItems.add(menuItem);
	}
	
}else if(pagetype.equals("operat"))
{
	slqnode = "select id,wfid from synergy_base where frommodule='"+stype+"|operat'";
	String level = Util.null2String(request.getParameter("doclevel"));
	if(stype.equals("wf"))
	{
		if(level.equals("2")) return;
		String sql = " select id,typename as workflowname from workflow_type order by dsporder asc,id asc ";
		
		if(!wftypeid.equals("0"))
			sql = " select t1.id,t1.workflowname from workflow_base t1,workflow_type t2 where t1.workflowtype=t2.id and t1.isvalid=1 and t1.workflowtype="+wftypeid+"     order by t1.dsporder asc,t1.workflowname asc";
		rs.executeSql(sql);
		while(rs.next())
		{
		    menuItem = new HashMap<String,Object>();
		    menuItem.put("name",rs.getString("workflowname"));
		    menuItem.put("hasChildren",(wftypeid.equals("0")?true:false));
		    menuItem.put("isOpen",false);
			
			attrItem = new HashMap<String,Object>();
		    attrItem.put("_id",rs.getString("id"));
		    attrItem.put("pagetype",pagetype);
		    attrItem.put("stype",stype);
		    attrItem.put("hasChildren",(wftypeid.equals("0")?true:false));
	        
	        menuItem.put("attr",attrItem);
			
			menuItems.add(menuItem);
		}
	}else if(stype.equals("doc"))
	{
		MultiAclManager am = new MultiAclManager();
		Map<String,Object> params = new HashMap<String,Object>();
		Map<String,Object> attr = new HashMap<String,Object>();
		attr.put("pagetype",pagetype);
		attr.put("stype",stype);
		params.put("attr",attr);
		//MultiCategoryTree tree = am.getPermittedTree(user, MultiAclManager.OPERATION_CREATEDOC);
		//MultiCategoryTree tree = am.getPermittedTree(user, MultiAclManager.OPERATION_CREATEDOC,"",-1,params);
		

		String subcompanyId = Util.null2String(request.getParameter("subCompanyId"));
		String categoryname = Util.null2String(request.getParameter("categoryname"));
		//MultiAclManager am = new MultiAclManager();
		MultiCategoryTree tree = am.getPermittedTree(user.getUID(), user.getType(), Util.getIntValue(user.getSeclevel(),0), -1,categoryname,Util.getIntValue(subcompanyId,0));
		
		out.println(tree.getTreeCategories().toString());
		return;
	}
}
JSONArray  menusJson = new JSONArray(menuItems);

demoLeftMenus = menusJson.toString();

//System.out.println("demoLeftMenus::::==="+demoLeftMenus);
out.clear();
out.print(demoLeftMenus);
%>           
