<%@ page language="java" contentType="text/html; charset=UTF-8"%>

<%@ page import="weaver.general.Util"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.general.Encoder"%>
<%@page import="weaver.file.FileUpload"%>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
request.setCharacterEncoding("UTF-8");
response.setContentType("text/html;charset=UTF-8");
User user = HrmUserVarify.getUser(request , response);
if(user == null){
	out.println("无用户，请登录");
	return;
}
FileUpload fu = new FileUpload(request);
String clienttype = Util.null2String((String)fu.getParameter("clienttype"));
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width,height=device-height, initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no" />
<HEAD>
<script	type="text/javascript" src="/wechat/js/jquery-1.7.1.min_wev8.js"></script>
<link rel="stylesheet" href="/wechat/css/jquery.mobile-1.1.1.min_wev8.css" />
<script	type="text/javascript" src="/wechat/js/custom-jqm-mobileinit_wev8.js"></script>
<script	type="text/javascript" src="/wechat/js/jquery.mobile-1.1.1.min_wev8.js"></script>
<script type="text/javascript" src="/wechat/js/my_wev8.js"></script>

<style>
	body{
		background-color: #FFFFF;
		max-width:640px;
   	    min-width:320px;
   	    font-size: 15px;
	}
	
	  #mianDiv{
	      background:white;
	      overflow:hidden;
	  }
	  
	  #faqDiv{
	      padding:10px;
	      border-bottom: 1px solid #C4C4C4;
	      font-weight: bold;
	      font-size: 16px;
	      line-height: 25px;
	      padding-top: 5px;
   		  padding-bottom: 5px;
	  }
	  
	  #contentDiv{
	      padding:10px;
	      overflow-y:auto;
	      background-color: #F0F2F5;
	      line-height: 22px;
	  }
	
	</style>
</head>
	<%
	    
	// 获得问题库中问题ID编号
    String faqId = Util.null2String(request.getParameter("faqId"));
	String changeQ = "问题不存在";
    String changeA = "";

	if(Util.getIntValue(faqId)<0){
		faqId=new String(Encoder.getFromBASE64(faqId));
		if(faqId!=null&&faqId.indexOf("*")>-1){
			String[] params=faqId.split("\\*");
			if(params.length==5){
				rs.execute("select "+params[1]+","+params[2]+" from "+params[0]+" where "+params[3]+"='"+params[4]+"'");
				if(rs.next()){
					changeQ=rs.getString(1);
					changeA=rs.getString(2);
				}
			}
		}
	}else{
		rs.execute("SELECT FAQDESC,FAQANSWER FROM FULLSEARCH_FAQDETAIL WHERE ID = "+ faqId);
	    if(rs.next()){
	    	changeQ = rs.getString("FAQDESC");
	        changeA = rs.getString("FAQANSWER");
	    }
	}
	
   
    //屏蔽A标签
    changeQ=changeQ.replaceAll("</?a[^>]+>", "");
    changeA=changeA.replaceAll("</?a[^>]+>", "");
	%>
	<BODY style="background:#F0F0F0;overflow:hidden">
		<div data-role="page" >
			<div id="mianDiv">
			  <div id="faqDiv">
	             <span style="vertical-align:top"><%=changeQ %></span>
	          </div>
	          <div id="contentDiv">
	            <div>
		            <%=changeA %>
	           </div>
	         </div>
	        </div>
    	</div>
	</BODY>
</html>


<script language="javascript">  
jQuery(document).ready(function() {
	try{
	  getRequestTitle("查看问答");
	}catch(e){}
	
	var bodyheight = jQuery("body").height();
	var bodywidth = jQuery("body").width();
	
	var contentDivHeight = bodyheight - $('#faqDiv').height()-35;
	$("#contentDiv").css("height",contentDivHeight+"px");
	  
	var contentImgWidth = bodywidth - 20;
	$("#contentDiv").find("img").css("max-width",contentImgWidth+"px");
	
	$("#contentDiv").find("img").off("tap");
	$("#contentDiv").find("img").on("tap",function(){
		var imgSrc=$(this)[0].src;
		if(imgSrc!=""){
			if("<%=clienttype%>"=="Webclient"){
				location = imgSrc;
			}else{
				location = 'emobile:imgCarousel:["'+imgSrc+'"]:0';
			}				
		}
	});
});

</script>
