<%@page import="weaver.file.AESCoder"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.file.FileUpload,weaver.file.Prop"%>
<%@ page import="weaver.general.*"%>
<%@ page import="weaver.hrm.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.sun.image.codec.jpeg.*"%>
<%@ page import="java.awt.*"%>
<%@ page import="java.awt.geom.Rectangle2D"%>
<%@ page import="java.awt.image.*"%>
<%@ page import="java.io.*"%>
<%@ page import="javax.imageio.ImageIO"%>
<%@ page import="org.apache.commons.fileupload.*"%>
<%@ page import="java.util.zip.ZipInputStream"%>
<%@page import="weaver.hrm.resource.ResourceComInfo"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="cs" class="weaver.conn.ConnStatement" scope="page"/>
<%
	String modelid = Util.null2String(request.getParameter("modelid"));
    int isUsedSearch = Util.getIntValue(request.getParameter("isUsedSearch"),0);
    String searchName = Util.null2String(request.getParameter("searchName"),"");
    String searchField = Util.null2String(request.getParameter("searchField"),"");
    String imageUrl = Util.null2String(request.getParameter("imageRelUrl"),"");
    String imageSource = Util.null2String(request.getParameter("imageSource"),"");
    int imageid = 0;
    if(request.getParameter("imageid").equals("")){
    	imageid = 0;
    }else{
    	imageid = Util.getIntValue(request.getParameter("imageid"));   	
    }
   
    int searchtype = Util.getIntValue(request.getParameter("searchType"));
    int order = Util.getIntValue(request.getParameter("order"));
    
    //如果是树形，则需要拿到查询列表的id
    if(searchtype == 2){
    	rs.executeSql("select * from mode_customtree where id="+modelid);
    	if(rs.next()){          
    		String defaultaddress = rs.getString("defaultaddress");
    		if(defaultaddress != null && !defaultaddress.equals("")){
    			String[] tempAddress = defaultaddress.split("[?]");
    			if(tempAddress.length > 1){
    				String[] tempFieldValue = tempAddress[1].split("&");
    				for(int i=0;i<tempFieldValue.length;i++){
    					if(tempFieldValue[i].indexOf("customid") != -1){
    						searchField = tempFieldValue[i].split("=")[1];
    					}
    				}
    			}
    		} 
    	}
    }
    
    rs.executeSql("select * from mode_toolbar_search where mainid="+modelid);
    	
    if(rs.next()){
    	cs.setStatementSql("update mode_toolbar_search set isusedsearch=?,searchname=?,searchfield=?,imagesource=?,imageid=?,imageurl=?,showorder=?,mainid=?,serachtype=? where mainid="+modelid); 	 
    }else{
	    cs.setStatementSql("insert into mode_toolbar_search(isusedsearch,searchname,searchfield,imagesource,imageid,imageurl,showorder,mainid,serachtype) values(?,?,?,?,?,?,?,?,?)");	   
    }
    cs.setInt(1,isUsedSearch);
    cs.setString(2,searchName);
    cs.setString(3,searchField);
    cs.setString(4,imageSource);
    cs.setInt(5,imageid);
    cs.setString(6,imageUrl);
    cs.setInt(7,order);
    cs.setString(8,modelid);
    cs.setInt(9,searchtype);
    cs.executeUpdate();
    cs.close();
    //response.sendRedirect("/formmode/setup/customSearchInfo.jsp");
%>

<script type="text/javascript">
   window.location.href = "/formmode/search/CustomSearchToolbar.jsp?id=<%=modelid%>&imageUrl=<%=imageUrl %>&imageid=<%=imageid %>&imageSource=<%=imageSource %>&type=<%=searchtype%>";
</script>
