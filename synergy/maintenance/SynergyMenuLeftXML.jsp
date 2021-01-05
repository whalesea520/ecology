
<%@ page language="java" contentType="text/xml; charset=UTF-8" %><?xml version="1.0" encoding="UTF-8"?>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.*,weaver.general.*,weaver.systeminfo.*,weaver.systeminfo.menuconfig.*" %>
<%@ page import="weaver.docs.category.security.*" %>
<%@ page import="weaver.docs.category.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rswf" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rsnode" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkTypeComInfo"
	class="weaver.workflow.workflow.WorkTypeComInfo" scope="page" />
<jsp:useBean id="shareManager" class="weaver.share.ShareManager"
	scope="page" />
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="baseBean" class="weaver.general.BaseBean" scope="page" />
<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");

User user = HrmUserVarify.getUser(request,response);
if(user == null)  return ;

String parentid = Util.null2String(request.getParameter("parentid"));
String stype = Util.null2String(request.getParameter("stype"));
String pagetype = Util.null2String(request.getParameter("pagetype"));

String searchwf = "";
String wftypeid = "";

if(parentid.length()==0) 
{
	//由于数据是初始化的，并不是程序插入，因此，ID固定，直接拼接parentid
	String slqnode = "select id,wfid from synergy_base where frommodule='"+stype+"|"+pagetype+"'";
	baseBean.writeLog(slqnode);
	rsnode.executeSql(slqnode);
	if(rsnode.next())
	{
		String __id = Util.null2String(rsnode.getString("id"));
		String __wfid = Util.null2String(rsnode.getString("wfid"));
		String isno = "NO";
		if(pagetype.equals("operat"))
			isno = "ON";
		parentid=__id +"|"+isno+"|"+__wfid+"|"+stype+"|"+pagetype;
	}
}
//baseBean.writeLog("SynergyMenuLeftXML.jsp parentid:===>"+parentid);
if(!parentid.equals(""))
{
String[] tempitem = Util.TokenizerString2(parentid, "|");
searchwf = tempitem[1];
parentid = tempitem[0];
wftypeid = tempitem[2];
stype = tempitem[3];
pagetype = tempitem[4];
%>
<tree>
<%
	StringBuffer treeStr = new StringBuffer();
	String mainname = "";
	String mainid = "";
	if(searchwf.equals("ON"))
	{
		if(stype.equals("doc"))
		{
			AclManager am = new AclManager();
			CategoryTree tree = am.getPermittedTree(user, AclManager.OPERATION_CREATEDOC);
		    Vector alldirs = tree.allCategories;

		    for (int i=0; i < alldirs.size(); i++)
		    {
		        CommonCategory temp = (CommonCategory)alldirs.get(i);
		        if(wftypeid.equals("0"))
		        {
			        if (temp.type == AclManager.CATEGORYTYPE_MAIN) 
			        {
			        	treeStr = new StringBuffer();
			        	mainname = MainCategoryComInfo.getMainCategoryname(temp.id+"");
			        	mainid = temp.id+"";
			        	treeStr.append("<tree ");
					    //text
					    treeStr.append("text=\"");
					    treeStr.append(
					    Util.replace(
					    Util.replace(
							Util.replace(
							Util.replace(
							Util.replace(
							Util.toScreen(mainname,user.getLanguage())
					    		,"<","&lt;",0)
					    		,">","&gt;",0)
					    		,"&","&amp;",0)
					    		,"'","&apos;",0)
					    		,"\"","&quot;",0)
					    		
					    );
					    treeStr.append("\" ");
					    //action
					    treeStr.append("action=\"");
					    treeStr.append("javascript:onClickCustomField('0',"+mainid+",'"+stype+"','"+pagetype+"','0');");
					    treeStr.append("\" ");
					    //icon
					    //treeStr.append("icon=\"/images/treeimages/book1_close_wev8.gif\" ");
					    //openIcon
					    //treeStr.append("openIcon=\"/images/treeimages/book1_open_wev8.gif\" ");
					    //target
					    treeStr.append("target=\"_self\" ");
					  	//_id
					    treeStr.append("_id=\""+mainid+"\" ");
					    //src
				    	treeStr.append("src=\"SynergyMenuLeftXML.jsp?parentid="+mainid+"|ON|1|"+stype+"|"+pagetype+"\" ");
					    
					    treeStr.append(" />");
					    out.println(treeStr.toString());
			        } 
		        }else if(wftypeid.equals("1"))
		        {
		        	
		        	if (temp.type == AclManager.CATEGORYTYPE_SUB) 
			        {
		        		String curmainid = SubCategoryComInfo.getMainCategoryid(temp.id+"");
		        		if(!curmainid.equals(parentid))
		        			continue;
			        	treeStr = new StringBuffer();
			        	mainname = SubCategoryComInfo.getSubCategoryname(temp.id+"");
			        	mainid = temp.id+"";
			        	treeStr.append("<tree ");
					    //text
					    treeStr.append("text=\"");
					    treeStr.append(
					    Util.replace(
					    Util.replace(
							Util.replace(
							Util.replace(
							Util.replace(
							Util.toScreen(mainname,user.getLanguage())
					    		,"<","&lt;",0)
					    		,">","&gt;",0)
					    		,"&","&amp;",0)
					    		,"'","&apos;",0)
					    		,"\"","&quot;",0)
					    		
					    );
					    treeStr.append("\" ");
					    //action
					    treeStr.append("action=\"");
					    treeStr.append("javascript:onClickCustomField('0',"+mainid+",'"+stype+"','"+pagetype+"','1');");
					    treeStr.append("\" ");
					    //icon
					    //treeStr.append("icon=\"/images/treeimages/book1_close_wev8.gif\" ");
					    //openIcon
					    //treeStr.append("openIcon=\"/images/treeimages/book1_open_wev8.gif\" ");
					    //target
					    treeStr.append("target=\"_self\" ");
					  	//_id
					    treeStr.append("_id=\""+mainid+"\" ");
					    //src
				    	treeStr.append("src=\"SynergyMenuLeftXML.jsp?parentid="+mainid+"|ON|2|"+stype+"|"+pagetype+"\" ");
					    
					    treeStr.append(" />");
					    out.println(treeStr.toString());
			        } 
		        }else if(wftypeid.equals("2"))
		        {
		        	if (temp.type == AclManager.CATEGORYTYPE_SEC) 
			        {
		        		String cursecid = SecCategoryComInfo.getSubCategoryid(temp.id+"");
		        		if(!cursecid.equals(parentid))
		        			continue;
			        	treeStr = new StringBuffer();
			        	mainname = SecCategoryComInfo.getSecCategoryname(temp.id+"");
			        	mainid = temp.id+"";
			        	treeStr.append("<tree ");
					    //text
					    treeStr.append("text=\"");
					    treeStr.append(
					    Util.replace(
					    Util.replace(
							Util.replace(
							Util.replace(
							Util.replace(
							Util.toScreen(mainname,user.getLanguage())
					    		,"<","&lt;",0)
					    		,">","&gt;",0)
					    		,"&","&amp;",0)
					    		,"'","&apos;",0)
					    		,"\"","&quot;",0)
					    		
					    );
					    treeStr.append("\" ");
					    //action
					    treeStr.append("action=\"");
					    treeStr.append("javascript:onClickCustomField('0',"+mainid+",'"+stype+"','"+pagetype+"','2');");
					    treeStr.append("\" ");
					    //icon
					    //treeStr.append("icon=\"/images/treeimages/book1_close_wev8.gif\" ");
					    //openIcon
					    //treeStr.append("openIcon=\"/images/treeimages/book1_open_wev8.gif\" ");
					    //target
					    treeStr.append("target=\"_self\" ");
					  	//_id
					    treeStr.append("_id=\""+mainid+"\" ");
					    //src
				    	treeStr.append("src=\"SynergyMenuLeftXML.jsp?parentid="+mainid+"|ON|3|"+stype+"|"+pagetype+"\" ");
					    
					    treeStr.append(" />");
					    out.println(treeStr.toString());
			        } 
		        }
		    }
		}else if(stype.equals("wf"))
		{
			String sql = " select distinct(t1.workflowtype) as id,t2.typename as workflowname from workflow_base t1,workflow_type t2 where t1.workflowtype = t2.id and t1.isvalid=1 ";
			if(!wftypeid.equals("0"))
				sql = " select t1.id,t1.workflowname from workflow_base t1,workflow_type t2 where t1.workflowtype=t2.id and t1.isvalid=1 and t1.workflowtype="+parentid;
			if(wftypeid.equals("0") || wftypeid.equals("1"))
				rswf.executeSql(sql);
			while(rswf.next())
			{
				treeStr = new StringBuffer();
				mainname = rswf.getString("workflowname");
				mainid = rswf.getString("id");
				
				treeStr.append("<tree ");
			    //text
			    treeStr.append("text=\"");
			    treeStr.append(
			    Util.replace(
			    Util.replace(
					Util.replace(
					Util.replace(
					Util.replace(
					Util.toScreen(mainname,user.getLanguage())
			    		,"<","&lt;",0)
			    		,">","&gt;",0)
			    		,"&","&amp;",0)
			    		,"'","&apos;",0)
			    		,"\"","&quot;",0)
			    		
			    );
			    treeStr.append("\" ");
			    //action
			    treeStr.append("action=\"");
			    treeStr.append("javascript:onClickCustomField('0',"+mainid+",'"+stype+"','"+pagetype+"','"+(Util.getIntValue(wftypeid)+1)+"');");
			    treeStr.append("\" ");
			    //icon
			    //treeStr.append("icon=\"/images/treeimages/book1_close_wev8.gif\" ");
			    //openIcon
			    //treeStr.append("openIcon=\"/images/treeimages/book1_open_wev8.gif\" ");
			    //target
			    treeStr.append("target=\"_self\" ");
			  	//_id
			    treeStr.append("_id=\""+mainid+"\" ");
			    //src
			    if(wftypeid.equals("0"))
			    	treeStr.append("src=\"SynergyMenuLeftXML.jsp?parentid="+mainid+"|ON|1|"+stype+"|"+pagetype+"\" ");
			    else if(wftypeid.equals("1"))
			    	treeStr.append("src=\"SynergyMenuLeftXML.jsp?parentid="+mainid+"|ON|2|"+stype+"|"+pagetype+"\" ");
			    
			    treeStr.append(" />");
			    out.println(treeStr.toString());
			}
		}
	}else
	{
		String sql = " select * from synergy_base where supid=0 ";
		if(parentid.length()>0)
		{
			
			sql = " select * from synergy_base where showtree = '1' and supid="+parentid;
		}
		sql+=" order by orderkey asc ";
		RecordSet.executeSql(sql);
	 	while(RecordSet.next()){
			treeStr = new StringBuffer();
			mainname = SystemEnv.getHtmlLabelName(RecordSet.getInt("modulename"),user.getLanguage());
			mainid = RecordSet.getString("id");
		
			String frommodule = RecordSet.getString("frommodule");
		    //第一层
		    treeStr.append("<tree ");
		    //text
		    treeStr.append("text=\"");
		    treeStr.append(
		    Util.replace(
		    Util.replace(
				Util.replace(
				Util.replace(
				Util.replace(
				Util.toScreen(mainname,user.getLanguage())
		    		,"<","&lt;",0)
		    		,">","&gt;",0)
		    		,"&","&amp;",0)
		    		,"'","&apos;",0)
		    		,"\"","&quot;",0)
		    		
		    );
		    treeStr.append("\" ");
		    //action
		    treeStr.append("action=\"");
		    treeStr.append("javascript:onClickCustomField("+mainid+",'','"+stype+"','"+pagetype+"','2');");
		    treeStr.append("\" ");
		    //icon
		    //treeStr.append("icon=\"/images/treeimages/book1_close_wev8.gif\" ");
		    //openIcon
		    //treeStr.append("openIcon=\"/images/treeimages/book1_open_wev8.gif\" ");
		    //target
		    treeStr.append("target=\"_self\" ");
		  	//_id
		    treeStr.append("_id=\""+mainid+"\" ");
		    //treeStr.append("_last="+true+" ");
		    //src
		    if(frommodule.equals("workflow") && mainid.equals("4"))
		    	treeStr.append("src=\"SynergyMenuLeftXML.jsp?parentid="+mainid+"|ON|0|"+stype+"|"+pagetype+"\" ");
		    else
		    	treeStr.append("src=\"SynergyMenuLeftXML.jsp?parentid="+mainid+"|NO|0|"+stype+"|"+pagetype+"\" ");
		    treeStr.append(" />");
		    //baseBean.writeLog("treeStr:+++>" + treeStr);
	    	out.println(treeStr.toString());
	 	}
	}
}
%>
</tree>