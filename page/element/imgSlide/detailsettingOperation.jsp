<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.conn.RecordSet"%>
<%@ page import="weaver.file.right.FileRightManager"%>
<%@ page import="weaver.file.constant.FileConstant"%>	
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";

int eid = Util.getIntValue(Util.null2String(request.getParameter("eid")));



String[] imgsrcArray = request.getParameterValues("imgsrc");
String[] imgdescArray = request.getParameterValues("imgdesc");
if (imgdescArray == null) {
    imgdescArray = new String[imgsrcArray.length];
}
String displaydesc = Util.null2String(request.getParameter("displaydesc"));
if (eid > 0 && !"".equals(imgsrcArray) && imgsrcArray.length > 0) {
    String[] imgsrcarray = imgsrcArray;
    String[] imgdescarray = imgdescArray;
    
    RecordSet rs = new RecordSet();
    
    rs.executeSql("delete from hpElement_slidesetting where eleid=" + eid);
    int fileId = 0;
    String temp  = "";
    for (int i=0; i<imgsrcarray.length; i++) {
		String sql = "insert into hpElement_slidesetting(eleid, displaydesc, imgsrc, imgdesc) values (" + eid + ", '" + Util.null2String(displaydesc) + "', '" + imgsrcarray[i] + "', '" + Util.null2String(imgdescarray[i]) + "')";
		rs.executeSql(sql);
    }
	
}
%>


<script>
parent.parentWin.onRefresh('<%=eid %>','imgSlide')
parent.cancle();
</script>