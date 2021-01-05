
<%@ page language="java" %>
<%@ page import="java.io.*" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="weaver.general.*" %>
<%
        Integer imageid=Util.getIntValue(request.getParameter("imageid"),0);
		RecordSet rs = new RecordSet();
		String sql = "select filerealpath from imagefile where imagefileid  = "+imageid;
		rs.execute(sql);
		if(rs.next()) {
		    String filerealpath = rs.getString("filerealpath");
		    //System.out.println(filerealpath);
		    FileInputStream fis = new FileInputStream(new File(filerealpath));
		    byte bs[] = new byte[fis.available()];
		    fis.read(bs);
		    response.reset();
		    response.setContentType("image/jpeg"); 
		    OutputStream ros = response.getOutputStream();
		    ros.write(bs);
		    fis.close();
		    ros.flush();
		    ros.close();
		}
%>