<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="java.util.*" %>
<%@ page import="org.apache.axis.encoding.Base64" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="net.sf.json.JSONArray" %>
<%@ page import="weaver.rdeploy.doc.PrivateSeccategoryManager"%>
<%@ page import="weaver.rdeploy.doc.SeccategoryShowModel"%>
<%
	response.setHeader("cache-control", "no-cache");
	response.setHeader("pragma", "no-cache");
	response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
	User user  = HrmUserVarify.getUser (request , response) ;
	RecordSet rs = new RecordSet();
	
	byte[] filePathArray = Base64.decode(request.getParameter("filePathArray"));
	String filePathStrs = new String(filePathArray, "utf8");
	
	byte[] rootPath = Base64.decode(request.getParameter("rootPath"));
	String rootPathStr = new String(rootPath, "utf8");
	
	
	PrivateSeccategoryManager privateSeccategoryManager = new PrivateSeccategoryManager();
	
	Map<String,Map<String,String>> result = new HashMap<String,Map<String,String>>();
	Map<String,String> filepathMap = new HashMap<String,String>();
	Map<String,String> folderMap = new HashMap<String,String>();
	 
	if(!filePathStrs.isEmpty())
	{
	    String[] filePathStr = filePathStrs.split("&&&&&&&");
	    
	    for(String filePath : filePathStr)
	    {
	        String filePathTemp = filePath;
			filePathTemp = filePath.substring(rootPathStr.length()+1);
			String categoryid = request.getParameter("categoryid");
			if(filePathTemp.indexOf("\\") > 0)
			{
				filePathTemp = filePathTemp.substring(0,filePathTemp.lastIndexOf("\\"));
				boolean flag = true;
				for(String category : filePathTemp.split("\\\\")){
						if(category.isEmpty()) continue;
						if(flag){
							String sql = "select id,parentid,categoryname from DocPrivateSecCategory where categoryname = '" + category + "' and parentid=" + categoryid;
							System.out.println(sql);
							rs.execute(sql);
							if(rs.next()){
								categoryid = rs.getString("id");
								folderMap.put(categoryid,rs.getString("parentid")+"_"+rs.getString("categoryname"));
							}else{
								flag = false;
							}
						}
						
						if(!flag){
							SeccategoryShowModel showModel = privateSeccategoryManager.createSeccategory(user, category, Util.getIntValue(categoryid));
							categoryid = showModel.getSid();
							folderMap.put(categoryid,showModel.getPid()+"_"+showModel.getSname());
						}
						
						
					}
			}
			filepathMap.put(filePath,categoryid);
	    }
	}
	result.put("filepathMap",filepathMap);
	result.put("folderMap",folderMap);
	JSONArray jo = JSONArray.fromObject(result);
	out.println(jo.toString());
%>