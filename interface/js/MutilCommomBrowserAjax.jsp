
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.general.*,weaver.interfaces.workflow.browser.*"%>
<%@ page import="weaver.docs.category.CategoryUtil"%>
<%@ page import="weaver.hrm.*"%>
<%@ page import="java.util.*"%>
<%@page import="java.net.URLDecoder"%>
<%@ page import="net.sf.json.JSONArray"%>
<%@ page import="net.sf.json.JSONObject"%>

<jsp:useBean id="dm" class="weaver.docs.docs.DocManager" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<%
String isreport = Util.getIntValue(request.getParameter("isreport"),0)+"";

	User user = HrmUserVarify.getUser(request, response);
	String src = Util.null2String(request.getParameter("src"));
	String beanids = Util.null2String(request.getParameter("systemIds"));
	//System.out.println("beanids : "+beanids+" src : "+src);
	//if (beanids.trim().indexOf(",")==0) {
	//	beanids = beanids.substring(1);
	//}
	String requestjson = Util.null2String(request.getParameter("requestjson"));
	//requestjson = URLDecoder.decode(requestjson,"UTF-8");//qc:311744[80][缺陷]数据展现集成-多选选择了主键带双引号的数据，再打开，显示 服务器正在处理，请稍候，加载不出数据
	requestjson = URLDecoder.decode(requestjson);//[80][缺陷]数据展现集成-解决311744产生的问题
	weaver.interfaces.workflow.browser.BaseBrowserDataSource bbds = new weaver.interfaces.workflow.browser.BaseBrowserDataSource();
	
	Map<String, String> otherparams = bbds.SpitParamToMap(requestjson);
	Map<String, String> searchValueMap= new HashMap<String,String>();

	String type = Util.null2String(otherparams.get("type"));
	String bts[] = type.split("\\|");
	type = bts[0];
	type = java.net.URLDecoder.decode(type,"UTF-8");
	//out.println("type : "+type);
	if(type.indexOf("browser.")==-1)
	{
		type = "browser."+type;
	}
	Browser browser=(Browser)StaticObj.getServiceByFullname(type, Browser.class);
	String from = Util.null2String(browser.getFrom());
	browser.initBaseBrowser("",type,from);
	String searchsql = browser.getSearchById()+" ";
	if(searchsql.trim().equals(""))
	    searchsql = browser.getSearch()+" ";
	if(isreport.equals("1")){
		searchsql = removeParam(searchsql);
	}
	String href = Util.null2String(browser.getHref());
	href = Util.null2String(browser.getHref(""+user.getUID(),href));
	
	Map searchfieldMap = browser.getSearchfieldMap();
	if(null!=searchfieldMap)
	{
		Set keyset = searchfieldMap.keySet();
	    for(Iterator it = keyset.iterator();it.hasNext();)
	    {
	    	String keyname = (String)it.next();
	    	String keyvalue = Util.null2String(request.getParameter(keyname));
	    	//System.out.println("keyname : "+keyname+" keyvalue : "+keyvalue);
	    	if(!"".equals(keyvalue))
	    	{
	    		searchValueMap.put(keyname,keyvalue);
	    		//requestjson += "".equals(requestjson)?(keyname+":"+keyvalue):("+"+keyname+":"+keyvalue);
	    	}
	    }
	}
	if(!from.equals("2")){//对老格式的特殊处理
		String keyname = "name";
		String keyvalue  = Util.null2String(request.getParameter(keyname));
		if(!"".equals(keyvalue))
		{
			requestjson += "".equals(requestjson)?(keyname+":"+keyvalue):("+"+keyname+":"+keyvalue);
		}
	}
	//System.out.println("requestjson : "+requestjson);
	otherparams = bbds.SpitParamToMap(requestjson);
	otherparams.putAll(searchValueMap);
	if (src.equalsIgnoreCase("dest")) {
		//表单值传到浏览框重新构造sql。start
		String workflowid = Util.getIntValue(request.getParameter("workflowid"),-1)+"";
		String currenttime = Util.null2String(request.getParameter("currenttime"));
		session = request.getSession(true);
		String needChangeFieldString = Util.null2String((String)session.getAttribute("needChangeFieldString_"+workflowid+"_"+currenttime));
		HashMap allField = (HashMap)session.getAttribute("allField_"+workflowid+"_"+currenttime);
		ArrayList allFieldList = (ArrayList)session.getAttribute("allFieldList_"+workflowid+"_"+currenttime);
		if(allField==null){
			allField = new HashMap();
		}
		//System.out.println(allField);
		if(allFieldList==null){
			allFieldList = new ArrayList();
		}
		String fieldids[] = needChangeFieldString.split(",");
		HashMap valueMap1 = (HashMap)session.getAttribute("valueMap_"+workflowid+"_"+currenttime);
		for(int i=0;i<allFieldList.size();i++){
			String fieldname = Util.null2String((String)allFieldList.get(i));
			if(!fieldname.equals("")){
				String fieldid = Util.null2String((String)allField.get(fieldname));
				String fieldvalue = Util.null2String((String)valueMap1.get(fieldid));
				
				if("".equals(fieldvalue)){
				  fieldvalue = "''";
				}
				fieldvalue = bbds.rebuildMultiFieldValue(fieldvalue);//处理多值
				//System.out.println("fieldname="+fieldname+", fieldvalue="+fieldvalue);
				searchsql = searchsql.replace(fieldname,fieldvalue);
			}
		}
		//表单值传到浏览框重新构造sql。end
		
		JSONArray jsonArr = new JSONArray();
		JSONArray jsonArr_tmp = new JSONArray();
		JSONObject json = new JSONObject();
		if (!beanids.equals("")) {
			List beanidlist = Util.TokenizerString(beanids,",");
			for(int i = 0;i<beanidlist.size();i++)
			{
				String tempid = Util.null2String(beanidlist.get(i));
				if("".equals(tempid))
				{
					continue;
				}
				// 2005-04-08 Modify by guosheng for TD1769
				//System.out.println("tempid : "+tempid+" search : "+searchsql);
				BrowserBean tempbean = browser.searchSqlById(tempid,searchsql);
				JSONObject tmp = new JSONObject();
				//System.out.println("tempid : "+tempid+" tempbean : "+tempbean);
				if(null!=tempbean)
				{
					tmp.put("id", tempid);
					Map valueMap = tempbean.getValueMap();
					if("2".equals(from))
					{
						Map showfieldMap = browser.getShowfieldMap();
						Set keyset = showfieldMap.keySet();
			            for(Iterator it = keyset.iterator();it.hasNext();)
			            {
			            	String keyname = (String)it.next();
			            	String tempvalue = Util.null2String((String)valueMap.get(keyname));
			            	tmp.put(keyname, tempvalue);
			            }
					}
					else
					{
						tmp.put("name", tempbean.getName());
						tmp.put("desc", tempbean.getDescription());
					}
					
					jsonArr_tmp.add(tmp);
				}
			}
			for(int i = 0;i<beanidlist.size();i++)
			{
				String tempid = Util.null2String(beanidlist.get(i));
				if("".equals(tempid))
				{
					continue;
				}
				for (int j = 0; j < jsonArr_tmp.size(); j++) {
					JSONObject tmp = (JSONObject) jsonArr_tmp.get(j);
					if (tmp.get("id").equals(tempid)) {
						jsonArr.add(tmp);
					}
				}
			}

		}
		json.put("currentPage", 1);
		json.put("totalPage", 1);
		json.put("mapList", jsonArr.toString());
		out.println(json.toString());
		return;
	}
	else
	{
		JSONArray jsonArr_tmp = new JSONArray();
		JSONObject json = new JSONObject();
		
		int perpage = Util.getIntValue(request.getParameter("pageSize"), 10);
		int pagenum = Util.getIntValue(request.getParameter("currentPage"),1);
		
		otherparams.put("systemIds",beanids);
		List<Map<String, String>> dataList = bbds.getDataResourceList4(user,otherparams,request,response);
		
		List templist = new ArrayList();
		int sumcount = dataList.size();
		
		int start = (pagenum-1) * perpage;
		int end = pagenum * perpage;
		if(end>sumcount) end = sumcount;
		
		int totalPage = (sumcount%perpage==0)?(sumcount/perpage):((sumcount/perpage)+1);
			
		for(int t=start;t<end;t++){
			templist.add(dataList.get(t));
		}
		for(int i = 0;i<templist.size();i++)
		{
			Map tempMap = (Map)templist.get(i);
			if(null==tempMap)
			{
				continue;
			}
			String tempid = Util.null2String(tempMap.get("ids"));
			JSONObject tmp = new JSONObject();
			if(!"".equals(tempid))
			{
				tmp.put("id", tempid);
				if("2".equals(from))
				{
					Map showfieldMap = browser.getShowfieldMap();
					Set keyset = showfieldMap.keySet();
		            for(Iterator it = keyset.iterator();it.hasNext();)
		            {
		            	String keyname = (String)it.next();
		            	String tempvalue = Util.null2String((String)tempMap.get(keyname+"s"));
		            	tmp.put(keyname, tempvalue);
		            }
				}
				else
				{
					tmp.put("name", Util.null2String((String)tempMap.get("names")));
					tmp.put("desc", Util.null2String((String)tempMap.get("descs")));
				}
				
				jsonArr_tmp.add(tmp);
			}
		}
		json.put("currentPage", pagenum);
		json.put("totalPage", totalPage);
		json.put("mapList", jsonArr_tmp.toString());
		out.println(json.toString());
	}
%>
<%!
public String removeParam(String sql){
	sql = sql.replaceAll("[ \\\\s]+[_a-zA-Z0-9.,\\(\\)]+[ \\\\s]*=[ \\\\s]*[']?\\$[_a-zA-Z0-9]+\\$[']?[ \\\\s]+", " 1=1 ");
	sql = sql.replaceAll("[ \\\\s]+[_a-zA-Z0-9.,\\(\\)]+[ \\\\s]*=[ \\\\s]*[']?\\{\\?[_a-zA-Z0-9]+\\}[']?[ \\\\s]+", " 1=1 ");
	
	return sql;
}
%>