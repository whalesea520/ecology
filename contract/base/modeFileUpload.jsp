<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="com.alibaba.fastjson.*"%>

<jsp:useBean id="fileHandle" class="weaver.contractn.util.FileHandle" scope="page" />
<jsp:useBean id="modefile" class="weaver.contractn.serviceImpl.ModeFileServiceImpl" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="modeRight" class="weaver.formmode.setup.ModeRightInfo" scope="page" />
<jsp:useBean id="fileService" class="weaver.contractn.serviceImpl.FileServiceImpl" scope="page" />
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<%
        JSONArray arr = fileHandle.uploadFile(request).getJSONArray("fileItem");
    	JSONObject obj = (JSONObject)arr.get(0);
   		String name = obj.getString("name");
   		String path = obj.getString("path");
   		String real_name = obj.getString("real_name");
		int docid = modefile.saveFile(user, name, path+"/"+real_name);
		int download_id = docid;
		rs.executeSql("select f.imagefileid from DocDetail d LEFT JOIN docimagefile f ON d.id = f.docid LEFT JOIN imagefile m ON f.id = m.imagefileid where d.id = "+docid);
		while(rs.next()){
			download_id = rs.getInt("imagefileid");
			rs1.executeSql("update docImageFile set docid = null where imagefileid = "+download_id);
			rs1.executeSql("update imagefile set comefrom = 'resourceimageid' where imagefileid = "+download_id);
		}
		String fileId = fileService.save(arr,"comment",null,download_id);
        out.print(fileId);

%>

