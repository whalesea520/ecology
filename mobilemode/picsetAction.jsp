<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="java.io.FileFilter"%>
<%@ page import="net.sf.json.JSONObject"%>
<%@ page import="net.sf.json.JSONArray"%>
<%@ page import="weaver.general.GCONST"%>
<%@ page import="java.io.File"%>
<%@ page import="java.net.URLDecoder"%>
<%@ include file="/mobilemode/init.jsp"%>
<%
response.reset();
out.clear();
String action = Util.null2String(request.getParameter("action"));
if(action.equalsIgnoreCase("getServerPicDatas")){
	JSONObject resultObj = new JSONObject();
	
	try{
		
		String path = Util.null2String(request.getParameter("path"));
		path = URLDecoder.decode(path, "UTF-8");
		if(path.equals("")){
			path = "/mobilemode/piclibrary";
		}		
		if(!path.startsWith("/mobilemode/piclibrary") || path.indexOf("../") != -1){
			throw new IllegalArgumentException("路径拒绝访问");
		}
		resultObj.put("path", path);
		
		JSONArray jsonArray = new JSONArray();
		
		final List<String> acceptList = Arrays.asList(".jpg", ".jpeg", ".png", ".bmp", ".gif", ".ico");
		
		String realPath = session.getServletContext().getRealPath(path);
		File file = new File(realPath);
		File[] childFileArr = file.listFiles(new FileFilter() {
			public boolean accept(File file) {
				boolean result = false;
				if(!file.isHidden()){
					if(file.isDirectory()){
						result = true;
					}else{
						String name = file.getName();
						if(name.indexOf(".") != -1){
							String s = name.substring(name.lastIndexOf(".")).toLowerCase();
							if(acceptList.contains(s)){
								result = true;
							}
						}
					}
				}
				return result;
			}
		});
		for(int i = 0; childFileArr != null && i < childFileArr.length; i++){
			File childFile = childFileArr[i];
			String fileServerPath = path + "/" + childFile.getName();
			boolean isFolder = childFile.isDirectory();
			String filename = childFile.getName();
			
			JSONObject jsonObject = new JSONObject();
			jsonObject.put("fileServerPath", fileServerPath);
			jsonObject.put("isFolder", isFolder);
			jsonObject.put("filename", filename);
			
			jsonArray.add(jsonObject);
		}
		
		Collections.sort(jsonArray, new Comparator<JSONObject>() {
			public int compare(JSONObject o1, JSONObject o2) {
				boolean isFolder = (Boolean)o1.get("isFolder");
				boolean isFolder2 = (Boolean)o2.get("isFolder");
				return (isFolder && isFolder2) ? 0 : (isFolder ? -1 : 1);
			}
		});
		
		resultObj.put("files", jsonArray);
		
		resultObj.put("status", "1");
		
	}catch(Exception ex){
		ex.printStackTrace();
		resultObj.put("status", "0");
	}finally{
		out.print(resultObj);
	}
}	
out.flush();
out.close();
%>