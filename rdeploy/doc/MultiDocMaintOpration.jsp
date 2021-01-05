<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util,weaver.general.TimeUtil" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@ page import="weaver.rdeploy.doc.DocShowModel" %>
<%@ page import="weaver.hrm.*" %>
<% 
	response.setHeader("cache-control", "no-cache");
	response.setHeader("pragma", "no-cache");
	response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
	//request.setCharacterEncoding("utf-8");
	User user = HrmUserVarify.getUser (request , response) ;
	if(user == null)  return ;

	String imgFileId= ""+Util.getIntValue(request.getParameter("imgFileId"),0);
	String seccategory = Util.null2String(request.getParameter("seccategory"));

	JSONObject jsonObject = new JSONObject();
	RecordSet rs = new RecordSet();
	
	if("0".equals(seccategory)){
        rs.execute("select id from DocPrivateSecCategory where categoryname = '" + user.getUID() + "_" + user.getLastname() + "' and parentid=0");
        if(rs.next()){
            seccategory = rs.getString("id");
        }
	}
	
	String sql = "select imagefilename from imagefile where imagefileid=" + imgFileId;
	
	String date = TimeUtil.getCurrentDateString();
	String time = TimeUtil.getOnlyCurrentTimeString();
	
	
	rs.executeSql(sql);
	DocShowModel docShowModel = new DocShowModel();
	if(rs.next()){
	    String imagefilename = rs.getString("imagefilename");
	    sql = "insert into ImageFileRef(imagefileid,fileName,createDate,createtime,createrid,modifydate,modifytime,modifierid,comefrom,categoryid) values("
	            + imgFileId + 
	            ",'" + imagefilename + "'" +
	            ",'" + date + "'" +
	            ",'" + time + "'" + 
	            "," + user.getUID() + 
	            ",'" + date + "'" +
                ",'" + time + "'" + 
                "," + user.getUID() +
                ",6" +
                "," + seccategory + ")";
	    rs.executeSql(sql);
	    jsonObject.put("imagefileId",imgFileId);
	    jsonObject.put("fullName",imagefilename);
	    jsonObject.put("doctitle",imagefilename.indexOf(".") > -1 ? 
	            imagefilename.substring(0,imagefilename.lastIndexOf(".")) : "");
	    docShowModel.setDocExtendName(imagefilename);
	    jsonObject.put("docExtendName",docShowModel.getDocExtendName());
	    jsonObject.put("docid",imgFileId);
	}
	 
	 
	 out.println(jsonObject.toString());    
%>