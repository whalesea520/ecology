<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ include file="/systeminfo/init_wev8.jsp"%>
<%@ page import="weaver.general.Util"%>

<HTML>
	<HEAD>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<style>
	      #mianDiv{
			background:#ffffff;
		  }
		  #headDiv{
		      text-align:center;
		  }
		  #faqDiv{
		      padding:5px;
		  }
		  #contentDiv{
		      padding:10px 50px 10px 50px;
		      line-height:28px;
		      overflow-y:auto;
		      color:#45586a;
		      font-size:14px;
		  }
		  
		  .headTitle{
		      font-family:Microsoft YaHei;
		      font-size:12px;
		      color:white;
		      line-height:30px
		  }
		  .faqDesc{
		      float:left;
              color:black;
              font-family:Microsoft YaHei;
              font-size:15px;
              line-height:20px;
              width:80%;
		  }
		  #faqTitle{
		      vertical-align:top;
		      text-align:left;
              font-style:normal;
              COLOR: #25aae2;
              font-weight:400;
              font-size:16px;
              padding: 18px 30px 10px 30px;
              background:white;
              line-height:28px;
              padding-top:25px
		  }
		  .box-shadow{  
              -moz-box-shadow:0px 2px 1px #e7e7e7; 
              -webkit-box-shadow:0px 2px 1px #e7e7e7; 
              box-shadow:0px 2px 1px #e7e7e7;
              background:#fff;
              filter: progid:DXImageTransform.Microsoft.Shadow(Strength=2, Direction=135, Color='#e7e7e7');
          }  
		  #middleLine{
		    height: 1px;
		    width: 97%;
		    border-bottom: 1px solid #f2f2f2;
		    margin-top: -1px;
		    margin-left:25px;
		  }
		
		a:hover {
		    color: red !important;
		    cursor: pointer;
		  }
		</style>
	</head>
	<%
	   
		// 获得问题库中问题ID编号
		String faqId = Util.null2String(request.getParameter("faqId"));
	    String changeQ = "";
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
	    
	    if("".equals(changeQ)) {
			out.print("<script>window.alert('此问题不存在');</script>");
		}
	%>
	<BODY
		style="overflow-x: hidden;overflow-y: auto; background: #f4f4f4; padding: 0 50px 0 45px; width: 95%">
		<div id="mianDiv" style="">
			<div id="headDiv">
				<span><img src="/fullsearch/img/faq_wev8.png" style="" /> </span>
			</div>
			<div id="middleLine">
			</div>
			<div id="faqTitle">
				<span style="vertical-align:-webkit-baseline-middle;vertical-align:middle;"><img src="/fullsearch/img/q_wev8.png" style="margin-bottom:-5px" /></span>&nbsp;<span style=""><%=changeQ%></span>
			</div>
			<div id="faqDiv">
				<div id="contentDiv" style="overflow: atuo;">
					<%=changeA%>
				</div>
			</div>
		</div>
	</BODY>
</html>


<script language="javascript">
// 定义菜单栏离页面顶部的距离，默认为200  
var divOffsetTop = 248;  
//滚动事件  
window.onscroll=function(){  
    var div = document.getElementById("faqTitle");  
    // 计算页面滚动了多少（需要区分不同浏览器）  
    var topVal = 0;  
    if(window.pageYOffset){//这一条滤去了大部分， 只留了IE678  
        topVal = window.pageYOffset;  
    }  
    else if(document.documentElement.scrollTop ){//IE678 的非quirk模式  
        topVal = document.documentElement.scrollTop;  
    }  
    else if(document.body.scrolltop){//IE678 的quirk模式  
        topVal = document.body.scrolltop;  
    }  
    if(topVal <= divOffsetTop){  
        div.style.position = "";  
        $("#faqTitle").removeClass("box-shadow");
        $("#faqTitle").css("margin-right","0px");
    } else {  
        var bodywidth = jQuery("body").width();
        faqTitleWidth = bodywidth - 60;
        div.style.top=0;
        $("#faqTitle").addClass("box-shadow");
        $("#faqTitle").css("width",faqTitleWidth+"px");
        div.style.position = "fixed";  
    }  
};  

jQuery(document).ready(function() {
  var div = document.getElementById("faqTitle");  
  divOffsetTop = div.offsetTop;  
  var bodywidth = jQuery("body").width();
  var contentImgWidth = bodywidth - 100;
  $("#contentDiv").find("img").css("max-width",contentImgWidth+"px");
  $("#contentDiv").find("a").css("color","#123885");
});
</script>
