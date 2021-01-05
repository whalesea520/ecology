
<%@ page language="java" contentType="application/x-json;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="org.json.*" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.*" %>
<jsp:useBean id="DocDsp" class="weaver.docs.docs.DocDsp" scope="page"/>
<jsp:useBean id="DocSearchMouldManager" class="weaver.docs.search.DocSearchMouldManager" scope="page" />
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<%
	User user = HrmUserVarify.getUser(request,response);
	if(user == null)  return ;
	int maincategory= 0 ;
	int subcategory= 0 ;
	int seccategory= 0 ;
	String type = Util.null2String(request.getParameter("type"));
	
	JSONObject oJson= new JSONObject();	
	JSONArray table=new JSONArray();
	

	JSONObject rowFirst=new JSONObject();
	rowFirst.put("name","---");
	rowFirst.put("value","0");
	table.put(rowFirst);
	if("main".equals(type)){
		while(MainCategoryComInfo.next()){
			JSONObject row=new JSONObject();
			//String isselect = "";
			String curid = MainCategoryComInfo.getMainCategoryid();
			String curname = MainCategoryComInfo.getMainCategoryname();
			//if(maincategory==(Util.getIntValue(curid,-1))) isselect=" selected";
			row.put("name",curname);
			row.put("value",curid);
			table.put(row);	
		}
	}else if("sub".equals(type)){
		while(SubCategoryComInfo.next()){
			JSONObject row=new JSONObject();
			//String isselect = "";
			String curid = SubCategoryComInfo.getSubCategoryid();
			String curname = SubCategoryComInfo.getSubCategoryname();
			curname=Util.replace(curname,"&amp;quot;","\"",0);
		    curname=Util.replace(curname,"&quot;","\"",0);
            curname=Util.replace(curname,"&lt;","<",0);
            curname=Util.replace(curname,"&gt;",">",0);
		    curname=Util.replace(curname,"&apos;","'",0);
			curname=Util.replace(curname,"&amp;","&",0);
			String main= SubCategoryComInfo.getMainCategoryid();
			row.put("name",curname);
			row.put("value",curid);
			row.put("main",main);
			table.put(row);	
		}
	}else if("sec".equals(type)){
		while(SecCategoryComInfo.next()){
			JSONObject row=new JSONObject();
			//String isselect = "";
			String curid = SecCategoryComInfo.getSecCategoryid();
			boolean isUsedCustomSearch = SecCategoryComInfo.isUsedCustomSearch(Util.getIntValue(curid));
			String curname = SecCategoryComInfo.getSecCategoryname();		
			curname=Util.replace(curname,"&amp;quot;","\"",0);
		    curname=Util.replace(curname,"&quot;","\"",0);
            curname=Util.replace(curname,"&lt;","<",0);
            curname=Util.replace(curname,"&gt;",">",0);
		    curname=Util.replace(curname,"&apos;","'",0);
			curname=Util.replace(curname,"&amp;","&",0);					
			String sub= SecCategoryComInfo.getSubCategoryid();
			String main= SubCategoryComInfo.getMainCategoryid(sub);
			
			row.put("name",curname);
			row.put("value",curid);
			row.put("main",main);
			row.put("sub",sub);
			row.put("isUsedCustomSearch",isUsedCustomSearch+"");
			
			table.put(row);	
		}
	}
	
	//oJson.put("totalCount",200);
	oJson.put("row",table);
    out.print(oJson.toString());
%>
