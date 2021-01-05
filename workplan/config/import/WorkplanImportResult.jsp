<%@ page import="weaver.general.Util,java.util.*,java.math.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<SCRIPT language="javascript" src="/js/checkinput_wev8.js"></script>
<%	

    String message = Util.null2String(request.getParameter("message"));
	String reson = Util.null2String(request.getParameter("reson"));
	String coutt=request.getParameter("coutt");
	String total=request.getParameter("total");
	String ResultMsg="";
	String s1="";
	String s2="";
	String s3="";
    if("1".equals(message)){
    	ResultMsg = SystemEnv.getHtmlLabelName(33966, user.getLanguage());//"日程插入成功";
    } else if("2".equals(message)){
    	int count=Integer.parseInt(coutt);
    	int totals=Integer.parseInt(total);
    	String temp_reson=SystemEnv.getHtmlLabelName(33967, user.getLanguage());//"数据库保存异常";
    	if("1".equals(reson)){//标题空
    		temp_reson=SystemEnv.getHtmlLabelName(33968, user.getLanguage());//"日程标题为空";
    	}else if("2".equals(reson)){
    		temp_reson=SystemEnv.getHtmlLabelName(82911, user.getLanguage());//"日程开始日期与结束日期数据非法";
    	}else if("3".equals(reson)){
    		temp_reson=SystemEnv.getHtmlLabelName(82912, user.getLanguage());//"日程开始时间与结束时间数据非法";
    	}else if("-1".equals(reson)){
    		temp_reson=SystemEnv.getHtmlLabelName(126224, user.getLanguage());//"存在非法数据";
    	}
    	if(count>1){
    		s1=SystemEnv.getHtmlLabelName(82906, user.getLanguage()).replace("{1}","1")+":"+SystemEnv.getHtmlLabelName(33970, user.getLanguage());//数据导入成功!";
    		if(count>2){
    			s1=SystemEnv.getHtmlLabelName(82906, user.getLanguage()).replace("{1}","1")+SystemEnv.getHtmlLabelName(15322, user.getLanguage())+SystemEnv.getHtmlLabelName(82906, user.getLanguage()).replace("{1}",""+(count-1))+":"+SystemEnv.getHtmlLabelName(33970, user.getLanguage());//数据导入成功!";
    		}
    	}
    	
    	s2=SystemEnv.getHtmlLabelName(82906, user.getLanguage()).replace("{1}",""+count)+":"+SystemEnv.getHtmlLabelName(33971, user.getLanguage())+SystemEnv.getHtmlLabelName(861, user.getLanguage())+":"+temp_reson;
    	
    	if(count<totals){//数据未全部保存
    		s3=SystemEnv.getHtmlLabelName(82910, user.getLanguage())+"!";//其他数据未处理,请根据提示删除成功数据,修改错误行,再导入剩余的数据
    	}
    } else if("3".equals(message)){//原因：excel文件未找到
    	ResultMsg = SystemEnv.getHtmlLabelName(33969, user.getLanguage())+"，"+SystemEnv.getHtmlLabelName(82907, user.getLanguage())+"！";
    } else if("4".equals(message)){//原因：excel文件读取失败，请检查格式
    	ResultMsg = SystemEnv.getHtmlLabelName(33969, user.getLanguage())+"，"+SystemEnv.getHtmlLabelName(82908, user.getLanguage())+"！";
    }else if("5".equals(message)){//原因：数据异常或服务器异常
    	ResultMsg = SystemEnv.getHtmlLabelName(33969, user.getLanguage())+"，"+SystemEnv.getHtmlLabelName(82909, user.getLanguage())+"！";
    }else if("6".equals(message)){//原因：数据异常或服务器异常
    	ResultMsg = SystemEnv.getHtmlLabelName(33969, user.getLanguage())+"，"+SystemEnv.getHtmlLabelName(82909, user.getLanguage())+"！";
    }
%>
<HTML>
<HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>

<STYLE type=text/css>
.success{ 
    background:#EBF1DE;
    padding:8px;
	color:#21B964;
	margin-top:10px;
	margin-right: 25px;
	font-weight: bold;
}
.err{
    background:#F2DEDE;
    padding:8px;
 	color:#C82424;
 	margin-top:10px;
 	margin-right: 25px;
 	font-weight: bold;
}
.other{
	background:#B1B9FE;
    padding:8px;
 	margin-top:10px;
 	margin-right: 25px;
 	font-weight: bold;
}

.end{
 	margin-top:10px;
 	margin-right: 25px;
}
</STYLE>

</head>
<%
	String imagefilename = "/images/hdHRMCard_wev8.gif";
	String titlename =SystemEnv.getHtmlLabelName(18596,user.getLanguage())+SystemEnv.getHtmlLabelName(356,user.getLanguage());
	String needfav = "1";
	String needhelp = "";
%>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(1290, user.getLanguage())+",javaScript:goBack(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;

%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="schedule"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(18596,user.getLanguage())+SystemEnv.getHtmlLabelName(356,user.getLanguage())%>"/>
</jsp:include>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
	<td></td>
	<td class="rightSearchSpan" style="text-align:right;">
		<input type=button class="e8_btn_top" onClick="goBack()" value="<%=SystemEnv.getHtmlLabelName(1290, user.getLanguage())%>">
		<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
	</td>
	</tr>
</table>
	<wea:layout type="2col">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(18596,user.getLanguage())+SystemEnv.getHtmlLabelName(356,user.getLanguage())%>'>
			<wea:item>
				<%if("1".equals(message)){ 
					out.print("<div class=\"success\">"+ResultMsg+"</div>");
				}else if("2".equals(message)){
					if(!"".equals(s1)){
						out.print("<div class=\"success\">"+s1+"</div>");
					}
					if(!"".equals(s2)){
						out.print("<div class=\"err\">"+s2+"</div>");
					}
					if(!"".equals(s3)){
						out.print("<div class=\"other\">"+s3+"</div>");
					}
				}else{
					out.print("<div class=\"err\">"+ResultMsg+"</div>");
				}%>
				<div class="end"></div>
			</wea:item>
		</wea:group>
	</wea:layout>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout type="2col">
		<wea:group context="">
			<wea:item type="toolbar">
				<input type="button"
					value="<%=SystemEnv.getHtmlLabelName(309, user.getLanguage())%>"
					id="zd_btn_cancle" class="e8_btn_cancel" onclick="btn_cancle()">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>   
<script language=javascript>
function btn_cancle(){
	parent.closeDlgAndRfsh();
}
     
/*返回导入页面*/
function goBack() {
	window.location.href="/workplan/config/import/WorkplanImport.jsp";
}

</script>

</BODY>
</HTML>
