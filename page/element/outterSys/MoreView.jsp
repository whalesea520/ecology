
<%@ page language="java" contentType="text/html; charset=UTF-8"%>

<%@page import="weaver.outter.OutterDisplayHelper"%>
<%@ include file="/page/element/viewCommon.jsp"%>
<%@ include file="common.jsp" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@page import="java.util.ArrayList"%>
<%@ page import="weaver.conn.*" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<HTML>
<HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/dragBox/parentShowcol_wev8.js"></script>
<link rel="stylesheet" href="/css/ecology8/request/requestView_wev8.css" type="text/css" />
</head>
<%
String disouttyName = "";
String disouttyimag = "";
String displaytype ="";
String displayLayout = "";
/*QC297379 [80][90]集成登录设置-解决集成登录元素中改变名称字数，但列表中集成登录名称字数没有变化的问题 start*/
//int dislength =0;
/*QC297379 [80][90]集成登录设置-解决集成登录元素中改变名称字数，但列表中集成登录名称字数没有变化的问题 end*/
int pageNum=0;
disouttyName=Util.null2String(valueList.get(nameList.indexOf("displayName")));
disouttyimag=Util.null2String(valueList.get(nameList.indexOf("displayimag")));
displaytype=Util.null2String(valueList.get(nameList.indexOf("displaytype")));
displayLayout=Util.null2String(valueList.get(nameList.indexOf("displaylayout")));
/*QC297379 [80][90]集成登录设置-解决集成登录元素中改变名称字数，但列表中集成登录名称字数没有变化的问题 start*/
//dislength=Util.getIntValue(Util.null2String(valueList.get(nameList.indexOf("displayNamelen"))),0);
/*QC297379 [80][90]集成登录设置-解决集成登录元素中改变名称字数，但列表中集成登录名称字数没有变化的问题 end*/

String sql="";
RecordSet rs=new RecordSet();
RecordSet rs1=new RecordSet();
pageNum=10;
//得到有权限查看的集成登录
OutterDisplayHelper ohp=new OutterDisplayHelper();
String sqlright=ohp.getShareOutterSql(user);
String testhtml="";
String defaultimag="/page/element/outterSys/resource/image/outterdefaultimag.png";
//displaytype="1";
sql="select * from outter_sys a where EXISTS (select 1 from ("+sqlright+") b where a.sysid=b.sysid )";
rs.executeSql(sql);
rs1.executeSql("delete outter_Moreview1");
//rs1.executeSql("delete outter_Moreview2");
if(displaytype.equals("1")){ //左图式
	while(rs.next()){
		String urllinkimagid=Util.null2String(rs.getString("urllinkimagid"));
		String sysid=Util.null2String(rs.getString("sysid"));
		String name=Util.null2String(rs.getString("name"));
		String imagewidth=Util.null2String(rs.getString("imagewidth"));
		String imageheight=Util.null2String(rs.getString("imageheight"));
		if(imagewidth.equals("")||imagewidth.equals("0")){
			imagewidth="32";
		}
		if(imageheight.equals("")||imageheight.equals("0")){
			imageheight="32";
		}
		String disname=name;

		String link="/interface/Entrance.jsp?id="+sysid;
		String imagelink="";
		if(urllinkimagid.equals("")||urllinkimagid.equals("0")){
		imagelink=defaultimag;
		}else{
		imagelink="/weaver/weaver.file.FileDownload?fileid="+urllinkimagid;
		}
		if(disouttyName.equals("1")){
		/*QC297379 [80][90]集成登录设置-解决集成登录元素中改变名称字数，但列表中集成登录名称字数没有变化的问题 start*/
		/*if(dislength>0&&name.length()>dislength){
		name=name.substring(0,dislength);
		}else{
		int temp=dislength-name.length();

		name=ohp.stringFill(name,name.length()+temp/2,' ',true);
		name=ohp.stringFill(name,name.length()+temp/2,' ',false);
		}*/
		/*QC297379 [80][90]集成登录设置-解决集成登录元素中改变名称字数，但列表中集成登录名称字数没有变化的问题 end*/
		if(disouttyimag.equals("1")){
		String discontent="";
		if(displaytype.equals("1")){  //
		discontent=ohp.getleftToRightimageHtml2(name,link,imagelink,disname,imagewidth,imageheight);
		}else{
		discontent=ohp.getUpToDownimageHtml(name,link,imagelink,disname,imagewidth,imageheight);
		}
		testhtml=discontent;
		}
		else{
			testhtml=ohp.getNameHtml(name,link,disname);
		}

		}else{  //no name

		if(disouttyimag.equals("1")){
			testhtml=ohp.getimageHtml(name,link,imagelink,imagewidth,imageheight);
		}

		} 
		
		ConnStatement statement = null;
		try{
		    statement=new ConnStatement();
		    sql="insert into outter_Moreview1(c1) values(?)";
			statement.setStatementSql(sql);
			statement.setString(1, testhtml);
			statement.executeUpdate();

	}catch(Exception e){
		new BaseBean().writeLog(e);
	}finally{
		try{
			statement.close();
		}catch(Exception e){
			
		}
	}
	
	
	}
	
}
else{  //上图式
	int i=0;
    String c1="";
    String c2="";
    String c3="";
    String c4="";
    String c5="";
	while(rs.next()){
		i++;
		String urllinkimagid=Util.null2String(rs.getString("urllinkimagid"));
		String sysid=Util.null2String(rs.getString("sysid"));
		String name=Util.null2String(rs.getString("name"));
		String imagewidth=Util.null2String(rs.getString("imagewidth"));
		String imageheight=Util.null2String(rs.getString("imageheight"));
		if(imagewidth.equals("")||imagewidth.equals("0")){
			imagewidth="32";
		}
		if(imageheight.equals("")||imageheight.equals("0")){
			imageheight="32";
		}
		String disname=name;

		String link="/interface/Entrance.jsp?id="+sysid;
		String imagelink="";
		if(urllinkimagid.equals("")||urllinkimagid.equals("0")){
		imagelink=defaultimag;
		}else{
		imagelink="/weaver/weaver.file.FileDownload?fileid="+urllinkimagid;
		}
		if(disouttyName.equals("1")){
	    /*QC297379 [80][90]集成登录设置-解决集成登录元素中改变名称字数，但列表中集成登录名称字数没有变化的问题 start*/
		/*if(dislength>0&&name.length()>dislength){
		name=name.substring(0,dislength);
		}else{
		int temp=dislength-name.length();

		name=ohp.stringFill(name,name.length()+temp/2,' ',true);
		name=ohp.stringFill(name,name.length()+temp/2,' ',false);
		}*/
		/*QC297379 [80][90]集成登录设置-解决集成登录元素中改变名称字数，但列表中集成登录名称字数没有变化的问题 end*/
		if(disouttyimag.equals("1")){
		String discontent="";
		if(displaytype.equals("1")){  //
		discontent=ohp.getleftToRightimageHtml2(name,link,imagelink,disname,imagewidth,imageheight);
		}else{
		discontent=ohp.getUpToDownimageHtml(name,link,imagelink,disname,imagewidth,imageheight);
		}
		testhtml=discontent;
		}
		else{
			testhtml=ohp.getNameHtml(name,link,disname);
		}

		}else{  //no name
		if(disouttyimag.equals("1")){
			testhtml=ohp.getimageHtml(name,link,imagelink,imagewidth,imageheight);
		  }
		} 
		if(i==1){
			c1=testhtml;
		}else if(i==2){
			c2=testhtml;
		}else if(i==3){
			c3=testhtml;
		}else if(i==4){
			c4=testhtml;
		}else if(i==5){
			i=0;
			c5=testhtml;
			ConnStatement statement = null;
			try{
			    statement=new ConnStatement();
			    sql="insert into outter_Moreview1(c1,c2,c3,c4,c5) values(?,?,?,?,?)";
				statement.setStatementSql(sql);
				statement.setString(1, c1);
				statement.setString(2, c2);
				statement.setString(3, c3);
				statement.setString(4, c4);
				statement.setString(5, c5);
				statement.executeUpdate();
				  c1="";
				  c2="";
				  c3="";
				  c4="";
				  c5="";

		}catch(Exception e){
			new BaseBean().writeLog(e);
		}finally{
			try{
				statement.close();
			}catch(Exception e){
				
			}
		 }
	 }
	
   }
if(i!=0){

	
	ConnStatement statement = null;
	try{
	    statement=new ConnStatement();
	    sql="insert into outter_Moreview1(c1,c2,c3,c4,c5) values(?,?,?,?,?)";
		statement.setStatementSql(sql);
		statement.setString(1, c1);
		statement.setString(2, c2);
		statement.setString(3, c3);
		statement.setString(4, c4);
		statement.setString(5, c5);
		statement.executeUpdate();

}catch(Exception e){
	new BaseBean().writeLog(e);
}finally{
	try{
		statement.close();
	}catch(Exception e){
		
	}
 }
		
}
	
	
}
response.sendRedirect("MoreView2.jsp?displaytype="+displaytype) ;

%>

</html>

