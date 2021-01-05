<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.general.StaticObj" %>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%!
    public String getDefaultSySConfig(int osType) {
        // 1:windows  2: osx  3:linux
        String defaulConfig = "";
        switch(osType) {
            case 1 : 
                defaulConfig = "{\"login\":{\"autoLogin\":false,\"language\":\"zh\"},\"mainPanel\":{\"alwaysQuit\":true,\"noLongerRemind\":false},\"shortcut\":{\"openAndHideWin\":\"ALT+W\",\"screenshot\":\"ALT+Q\"},\"download\":{\"isAuto\":\"false\",\"defaultPath\":\"\"}}";
                break;
            case 2 : 
                defaulConfig = "";
                break;
            case 3 : 
                defaulConfig = "";
                break;
        }
        return defaulConfig;
    }

    // 获得不同系统对应的数据库字段列名
    public String getColumnName(int osType) {
        String column = "";
        switch(osType) {
            case 1 :
                column = "winConfig";
                break;
            case 2 : 
                column = "osxConfig";
                break;
			case 4 :
				column = "webandpcconfig";
				break;
        }
        return column;
    }
%>


<%
    User user = HrmUserVarify.checkUser(request, response);
    String method = request.getParameter("method");

    // 获得文件大小
    if("getFileSize".equals(method)) {
        String fileSize = "0";
        RecordSet rs = new RecordSet();
        rs.executeQuery("select fileSize from social_IMFile where fileid = ?", request.getParameter("fileid"));
        if(rs.next()) {
            fileSize = rs.getString("fileSize");
        }
        out.print(fileSize);
    }
    
    // 获取服务端用户配置信息
    else if("getUserSysConfig".equals(method)) {
        JSONObject jObject = new JSONObject();
        int osType = Util.getIntValue(request.getParameter("osType"), 1);
        String column = getColumnName(osType);
        if(!column.isEmpty()) {
            String sql = "select " + column + " from Social_IMUserSysConfig where userId = " + user.getUID();
            if(RecordSet.executeSql(sql) && RecordSet.next()) {
                String dbConfig = RecordSet.getString(column);
                if(!dbConfig.isEmpty()) {
                    jObject.put("isSuccess", true);
                    jObject.put("config",dbConfig);
                }
            }
        }
        if(!jObject.has("isSuccess")) {
            jObject.put("isSuccess", false);
        }
        out.print(jObject);
    }
    
    // 保存用户配置信息到服务端
    else if("saveUserSysConfig".equals(method)) {
        int osType = Util.getIntValue(request.getParameter("osType"));
        String userConfing = Util.null2String(request.getParameter("config"));
        String column = getColumnName(osType);
        String sql = "select " + column + " from Social_IMUserSysConfig where userId = " + user.getUID();
        if(RecordSet.executeSql(sql) && RecordSet.next()){
        	sql = "update Social_IMUserSysConfig set "+column+" = ? where userid = ? ";
            RecordSet.executeUpdate(sql, userConfing,user.getUID());
        }else{
			sql = "insert into Social_IMUserSysConfig(userId, " + column + ") values (?, ?)";
            RecordSet.executeUpdate(sql, user.getUID(), userConfing);
		}
    }
    // 保存客户端文件最近下载路径
    else if("recordLastsavepath".equals(method)){
    	int fileId = Util.getIntValue(request.getParameter("fileid"));
    	String userId = user.getUID() + "";
        String filePath = Util.null2String(request.getParameter("filepath"));
        String whereSql = "where userid = " + userId + " and fileid="+fileId;
        String sql = "select downloadcount from Social_FileDownloadLog "+whereSql;
        RecordSet.executeSql(sql);
        if(RecordSet.next()){
        	sql = "update Social_FileDownloadLog set lastsavepath=?, downloadcount=downloadcount+1 "+whereSql;
        	RecordSet.executeUpdate(sql, filePath);
        }else {
        	sql = "insert into Social_FileDownloadLog(userid, fileid, lastsavepath, downloadcount) values (?,?,?,?)";
            RecordSet.executeUpdate(sql, user.getUID(), fileId, filePath, 1);
        }
        StaticObj staticobj = StaticObj.getInstance();
        Object socialSavePathObj = staticobj.getObject("socialSavePathKey");
        if(socialSavePathObj != null) {
        	JSONObject resultPerson = null;
        	Map<String, JSONObject> result = (Map<String, JSONObject>)socialSavePathObj;
			if(result.containsKey(userId)){
				resultPerson = result.get(userId);
				resultPerson.put(fileId+"", filePath);
				result.put(userId, resultPerson);
				staticobj.putObject("socialSavePathKey", result);
			}
        }
        out.print("ok");
    }
    // 获取客户端文件最近下载路径
    else if("getLastsavepath".equals(method)){
    	StaticObj staticobj = StaticObj.getInstance();
		String socialSavePathKey = "socialSavePathKey";
		String userId = user.getUID() + "";
		Map<String, JSONObject> result = null;
		JSONObject resultPerson = new JSONObject();
		Object socialSavePathObj = staticobj.getObject(socialSavePathKey);
		if(socialSavePathObj != null){
			result = (Map<String, JSONObject>)socialSavePathObj;
			if(result.containsKey(userId)){
				resultPerson = result.get(userId);
				out.print(resultPerson);
				return;
			}
		}else{
			result = new HashMap<String, JSONObject>();
		}
		RecordSet recordSet=new RecordSet();
		String sql = "select userid, fileid, lastsavepath, downloadcount from Social_FileDownloadLog " + 
					 "where userid = "+ userId;
		recordSet.execute(sql);
		while(recordSet.next()) {
			resultPerson.put(recordSet.getString("fileid"), recordSet.getString("lastsavepath"));
		}
		result.put(userId, resultPerson);
		staticobj.putObject(socialSavePathKey, result);
		out.print(resultPerson);
    }
    // 找不到执行方法
    else {
        throw new Exception("no method matching");
    }
%>