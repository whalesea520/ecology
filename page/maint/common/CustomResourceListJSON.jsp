
<%@ page language="java"  import="java.util.*" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.io.*"%>
<%@ page import="weaver.hrm.*,weaver.general.*" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@ page import="weaver.page.PageManager"%>
<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");

User user = HrmUserVarify.getUser(request,response);
if(user == null)  return ;
String dir = Util.null2String(request.getParameter("dir"));
out.print(getFileNode(dir));
%>
<%!
private String getFileNode(String dir){
	StringBuffer returnStr = new StringBuffer();
	PageManager pm = new PageManager();
	String dirAbs = pm.getRealPath("/page/resource/userfile/");
	if(!"".equals(dir)) dirAbs+=dir;
	if (dirAbs.charAt(dirAbs.length()-1) == '\\') {
		dirAbs = dirAbs.substring(0, dirAbs.length()-1) + "/";
	} else if (dirAbs.charAt(dirAbs.length()-1) != '/') {
		dirAbs += "/";
	}
	dirAbs  = Util.StringReplace(dirAbs,"\\","/");
	returnStr.append("[");
    if (new File(dirAbs).exists()) {
		String[] files = new File(dirAbs).list(new FilenameFilter() {
		    public boolean accept(File dirAbs, String name) {
				return name.charAt(0) != '.';
		    }
		});
		Arrays.sort(files, String.CASE_INSENSITIVE_ORDER);
		if(files.length>0){
			for (int i=0; i<files.length;i++) {
				JSONObject json = new JSONObject ();
				String file = files[i];
				File _file =  new File(dirAbs, file);
			    if (_file.isDirectory()) {
			    	json.put("id",new Date().getTime());
					json.put("isParent",true);
					json.put("parentId",_file.getParentFile().getName());
					
					json.put("name",file);		
					json.put("dirtype","cus");
					json.put("dirrealpath",dir + file + "/");
					if("flash".equals(file)||"image".equals(file)||"other".equals(file)||"video".equals(file)){
						json.put("dirtype","sys");
					}
					
					File[] hasFiles = new File(dirAbs + file).listFiles();
					if(hasFiles.length>0){
						for (int k=0; k<hasFiles.length;k++) {
							if(hasFiles[k].isDirectory()){
								json.put("isParent",true);
								break;
							}else{
								json.put("isParent",false);
							}
						}
					}else{
						json.put("isParent",false);
					}
			    	returnStr.append(json.toString());
			    	returnStr.append(",");
			    }
			}
		}
    }
    return returnStr.toString().substring(0,returnStr.toString().length()-1)+"]";
}
%>
