
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="init.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page isELIgnored="false"%>
<jsp:useBean id="indexMng" class="weaver.fullsearch.IndexManagerBean"/>
<jsp:setProperty name="indexMng" property="pageContext" value="<%=pageContext%>"/>
<jsp:setProperty name="indexMng" property="action" param="action"/>
<jsp:setProperty name="indexMng" property="indexDbName" param="indexDbName"/>
<jsp:setProperty name="indexMng" property="date" param="date"/>
<jsp:setProperty name="indexMng" property="contentType" param="contentType"/>
<jsp:setProperty name="indexMng" property="user" value="<%=user%>"/>
<jsp:setProperty name="indexMng" property="startYear" value="2002"/>
<jsp:setProperty name="indexMng" property="init" value="true"/>
<% 
   if(!HrmUserVarify.checkUserRight("searchIndex:manager",user)) {
        response.sendRedirect("/notice/noright.jsp") ;
        return ;
    }
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta http-equiv="X-UA-Compatible" content="IE=10" /> 
<title><%=SystemEnv.getHtmlLabelName(31953,user.getLanguage()) %></title>
<style type="text/css">
<!--
*{
	font-family:微软雅黑;
}
.searchtype{width: 50px;height: 22px;line-height: 24px;float: left;margin-left: 5px;text-align: center;cursor: pointer;color: #191919;font-size: 17px;border-top:1px solid #3eaf0e;border-bottom:1px solid #3eaf0e;border-right:1px solid #3eaf0e;vertical-align:middle;font-size: 15px;overflow: hidden}
.moreType{width: 50px;height: 32px;line-height: 24px;float: left;margin-left: 2px;text-align: center;cursor: pointer;color: #fff;font-size: 17px;border-top:1px solid #3eaf0e;border-bottom:1px solid #3eaf0e;border-right:1px solid #3eaf0e;vertical-align:middle;font-size: 15px;}
.searchtype_click{text-decoration: none;font-size: 15px; background-color:#ffffff;}
.searchtype:hover{color: #FFF;text-decoration: none;}
.searchtype_click:hover{color: #666;text-decoration: none;}
.searchtypeline{width: 0px;height: 30px;line-height: 24px;float: left;margin: 0px;border-right:1px solid #3eaf0e;border-bottom:1px solid #3eaf0e}

.btndiv{text-align: center;width:100%;padding-left: 40px;
}
.btns{width: 22px;height: 22px;line-height: 24px;float: left;margin:10px;text-align: center;cursor: pointer;color: #191919;font-size: 14px;}
.btns:hover{width: 20px;height: 20px; border:1px solid #fff}
.redo{ background: url(../images/bg/syy/52_wev8.png) no-repeat;
}
.delete{ background: url(../images/bg/syy/62_wev8.png) no-repeat;
}
.line1{width: 10px;height: 24px;line-height: 24px;float: left;margin:0px auto;;text-align: center;cursor: pointer;color: #191919;font-size: 14px;}


.listview td{ 
	height:74px;width:191px;border-bottom:1px solid #3eaf0e;border-right:1px solid #3eaf0e;text-align: center;vertical-align:middle;font-size: 25px;padding-top:10px;
}

.year { line-height: 25px;width: 90px;height: 25px;float: right;margin:0px auto;text-align: center;cursor: pointer;font-size: 15px;}
.year_click{color: #008000;text-decoration: none;BACKGROUND: #3fcf0e;color: #ffffff;}
.year:hover{color: #008000;text-decoration: none;BACKGROUND: #8fef0e;color: #ffffff;}
.maintd{
	border:1px solid #FFF;vertical-align:top;
}
.title{
	PADDING-RIGHT: 25px; ZOOM: 1; DISPLAY: inline-block; font-weight: bold;font-size: 30px;
}
BODY {
	POSITION: relative; COLOR: #666
}
.btnV{ height:36px;BACKGROUND: #F00;cursor: pointer;
}

.topbtn{ top:0;background: url(../images/bg/syy/3-2_wev8.png) 20px no-repeat;
}
.topbtn:hover{background: url(../images/bg/syy/3-2_wev8.png) 22px no-repeat;}
.bottombtn{ bottom:0;top:auto;background: url(../images/bg/syy/4-2_wev8.png) 20px no-repeat;
}
.bottombtn:hover{background: url(../images/bg/syy/4-2_wev8.png) 22px no-repeat;}
.s-allyears
{list-style: none;padding-left:0px;padding-right:0px;padding-top:0px;margin-top:0px}
.s-allyears li{position:relative}

a{text-decoration:none;cursor:pointer;color: #666;font-size: 15px;}
#so-nav-more{min-width:50px;position:absolute;z-index:0;margin-left:610px;top:228px;padding:0;line-height:30px;text-align:left;border:1px #dedede solid;background:#FFF;list-style:none;display:none}
#so-nav-more a{width:100%;display:block;margin:0;text-indent:10px}
#so-nav-more a:hover{background-color:#f1f1f1}

-->
</style>
<script type="text/javascript" src="../js/jquery/jquery_wev8.js"></script> 
<script type="text/javascript">
var data='<c:out value="${allindexdb}" escapeXml="false"/>';
var pageDate=new Date();
var currentYear = pageDate.getFullYear();
    
var types=[<c:out value="${allcontenttypes}" escapeXml="false"/>];

var dataObj=null;
if(data != ''){
	dataObj=eval("("+data+")");
}

function Map(){

	/** 存放键的数组(遍历用到) */    
	this.keys = new Array();
	/** 存放数据 */    
	this.data = new Object();

	//向MAP中增加元素（key, value) 
	this.put = function(key, value) {     
		if(this.data[key] == null){     
			this.keys.push(key);     
		}     
		this.data[key] = value;     
	};
	this.get = function(key) {     
		return this.data[key];     
	};
	this.remove = function(key) {     
		this.keys.remove(key);     
		this.data[key] = null;     
	}; 
	this.size = function(){     
		return this.keys.length;     
	};
}

var mapAll = new Map();

function initAll(){
	if(dataObj != null){
		jQuery.each(dataObj.root,function(idx,item){
			var intmouth=parseInt(item.time,10);
			if(mapAll.get(intmouth) != null){
				mapAll.get(intmouth).put(item.type, "");
			} else {
				var mapv = new Map();
				mapv.put(item.type, "");
				mapAll.put(intmouth, mapv);
			}	
		});
	}
}

function initAllBg(){
	if(jQuery("#contentType").val() != "" && jQuery("#date").val()!=""){
		var contentType = jQuery("#contentType").val();
		var date=jQuery("#date").val();
		if(date.length > 4){
			var year = date.substr(0,4);
			jQuery(".searchtype").each(function(){
				jQuery(this).removeClass("searchtype_click");
			});
			if(jQuery("DIV[contentType="+contentType+"]").length > 0){
				jQuery("DIV[contentType="+contentType+"]").addClass("searchtype_click");
			}
			
			//如果是在更多中
			if(jQuery(".moreType").length > 0){
				var obj =jQuery(".moreType").prev(".searchtype");
				var obja = jQuery("A[contentType="+contentType+"]");
				if(obja.length>0){
					var obj_val = obj.html();
					var obj_con = obj.attr("contentType");
					obj.attr("contentType", obja.attr("contentType"));
					obj.html(obja.html());
					obja.attr("contentType", obj_con);
					obja.html(obj_val);
					
					obj.parent().find(".searchtype").each(function(){
						jQuery(this).removeClass("searchtype_click");
					});
					obj.addClass("searchtype_click");
				}
				
			}
			
			
			jQuery(".s-allyears").find("DIV").each(function(){
				jQuery(this).removeClass("year_click");
			});
		     jQuery("DIV[year="+year+"]").addClass("year_click");
		     
		     //滚动到当前年
		     var difYear=parseInt(currentYear)-parseInt(year);
		     if(difYear>8){
		     	jQuery(".s-allyears").css("margin-top",((difYear-8)*-25)+"px");
		     };
		     
		}
		jQuery("#info").html(jQuery(".searchtype_click").html()+"["+date+"]:"+jQuery("#info").html());
	}
    changeMouthBg(jQuery(".searchtype_click").attr("contentType"),jQuery(".year_click").attr("year"))
}


     function init(){
		
		
    }
	
	function initMouthBg(){
	}
	
	function changeMouthBg(type, year){
		var startmouth=201301;
		var endmouth=201306;
		startmouth=parseInt(year+"01",10);
		endmouth=parseInt(year+"12",10);
		if(type == 'ALL'){
			for(var i = startmouth; i<=endmouth;i++){
				var mum = '1'+(""+i).substr(4);
			    if(mapAll.get(i) != null){
				    var mapt = mapAll.get(i);
					if(mapt.size() >= types.length){
						setBdForAllDone(jQuery("TD[month="+mum+"]"));
					} else {
						setBdForHalfDone(jQuery("TD[month="+mum+"]"));
					}
				} else {
					setBdForNotDo(jQuery("TD[month="+mum+"]"));
				}
			}
			
		}else{
		     
			for(var i = 101; i<=112;i++){
				setBdForNotDo(jQuery("TD[month="+i+"]"));
			}
			if(dataObj != null){
				jQuery.each(dataObj.root,function(idx,item){
					var intmouth=parseInt(item.time,10);
					if(item.type==type && intmouth>=startmouth && intmouth<=endmouth){
						var mum = '1'+item.time.substr(4);
						setBdForAllDone(jQuery("TD[month="+mum+"]"));
					}
						
				});
			}
		}
	}
	
	function setBdForAllDone(obj){
		//obj.css("background-color", "#aaa");
		obj.css("background", "url(../images/bg/syy/0-2_wev8.png) top right no-repeat");
	}
	
	function setBdForNotDo(obj){
		//obj.css("background-color", "#fff");
		obj.css("background", "");
	}
	
	function setBdForHalfDone(obj){
		//obj.css("background-color", "#faa");
		obj.css("background", "url(../images/bg/syy/1-2_wev8.png) top right no-repeat");
	}
	
	function dosubmit(){
	        
	}
	function setline(){
	    jQuery("LI").css("list-style-type","");
		jQuery("LI").css("list-style-type","none");
	}
	
    jQuery(document).ready(function(){
	    
		initAll();
		
		jQuery(".moreType").mouseover(function(){
		     //jQuery("#so-nav-more").css("display","block");
			 setTimeout(function(){jQuery("#so-nav-more").css("display","block");},200)
		});
		jQuery(".moreType").mouseout(function(){
			//jQuery("#so-nav-more").css("display","none");
			setTimeout(function(){jQuery("#so-nav-more").css("display","none");},200)
		});
		jQuery("#so-nav-more").mouseover(function(){
		     //jQuery("#so-nav-more").css("display","block");
			 setTimeout(function(){jQuery("#so-nav-more").css("display","block");},200)
		});
		jQuery("#so-nav-more").mouseout(function(){
			//jQuery("#so-nav-more").css("display","none");
			setTimeout(function(){jQuery("#so-nav-more").css("display","none");},200)
		});
				
		jQuery(".searchtype").click(function(){
			jQuery(this).parent().find(".searchtype").each(function(){
				jQuery(this).removeClass("searchtype_click");
			});
		     jQuery(this).addClass("searchtype_click");
			 
			changeMouthBg(jQuery(this).attr("contentType"), jQuery(".year_click").attr("year"));

		});
		
		jQuery(".year").click(function(){
			jQuery(".s-allyears").find("DIV").each(function(){
				jQuery(this).removeClass("year_click");
			});
		     jQuery(this).addClass("year_click");
			 
			changeMouthBg(jQuery(".searchtype_click").attr("contentType"), jQuery(this).attr("year"));

		});
		
		jQuery(".redo").click(function(){
			var month = jQuery(this).parent().parent().attr("month");
			var year=jQuery(".year_click").attr("year");
			var mon=month.substr(1,2);
			var contentType = jQuery(".searchtype_click").attr("contentType");
			jQuery("#contentType").val(contentType);
			jQuery("#action").val("createIndex");
			jQuery("#indexDbName").val(""+year+mon);
			jQuery("#date").val(year+"-"+mon);
			jQuery('#frm').submit();
			//alert(contentType+" "+ year + " "+  month + "redo");
			//setBdForAllDone(jQuery("TD[month="+month+"]"));
			
		});
		
		jQuery(".delete").click(function(){
			var month = jQuery(this).parent().parent().attr("month");
			var year=jQuery(".year_click").attr("year");
			var mon=month.substr(1,2);
			var contentType = jQuery(".searchtype_click").attr("contentType");
			jQuery("#contentType").val(contentType);
			jQuery("#action").val("deleteIndex");
			jQuery("#indexDbName").val(""+year+mon);
			jQuery("#date").val(year+"-"+mon);
			jQuery('#frm').submit();
			//alert(contentType+" "+ year + " "+ half + " "+ month + "delete");
			//setBdForNotDo(jQuery(this).parent().parent());
		});
		jQuery("#bottombtn").click(function(){
			var mgn= jQuery("#s_allyears").css("margin-top");
			var mgnnum= parseInt(mgn.substr(0, mgn.length-2));
			mgnnum = mgnnum - 25;
			var tolwidth = (jQuery(".year").length-7)*25;
			jQuery(".btnV").css("cursor", "pointer");
			if((0-mgnnum) < tolwidth){
				jQuery("#s_allyears").css("margin-top", mgnnum+"px");
				
			} 
			else {
				jQuery(this).css("cursor", "");
				//jQuery("#s_allyears").css("margin-top", "0px");
			}
		});
		jQuery("#topbtn").click(function(){
			var mgn= jQuery("#s_allyears").css("margin-top");
			var mgnnum= parseInt(mgn.substr(0, mgn.length-2));
			mgnnum = mgnnum + 25;
			var tolwidth = jQuery("#s_allyears").css("margin-top");
			jQuery(".btnV").css("cursor", "pointer");
			//var tolwidthnum = parseInt(tolwidthnum.substr(0, tolwidthnum.length-2));
			if(mgnnum <= 0){
				jQuery("#s_allyears").css("margin-top", mgnnum+"px");
				
			} else {
				jQuery(this).css("cursor", "");
				//jQuery("#s_allyears").css("margin-top", "0px");
			}
		});
		
		
		jQuery("#so-nav-more").find("A").click(function(){
			var obj =jQuery(".moreType").prev(".searchtype");
			var obj_val = obj.html();
			var obj_con = obj.attr("contentType");
			obj.attr("contentType", jQuery(this).attr("contentType"));
			obj.html(jQuery(this).html());
			jQuery(this).attr("contentType", obj_con);
			jQuery(this).html(obj_val);
			
			obj.parent().find(".searchtype").each(function(){
				jQuery(this).removeClass("searchtype_click");
			});
		     obj.addClass("searchtype_click");
			 
			changeMouthBg(obj.attr("contentType"), jQuery(".year_click").attr("year"));
		});
		
		initAllBg();
	});
	
</script>

</head>

<body style="height:100%">
<div align="center" style="width:980px;margin:0px auto;">
<div style="height: 60px;border-bottom:1px solid #3eaf0e;vertical-align:middle;PADDING-top: 20px;width:980px;margin:0px auto;">
		<img id="logoimg" style="cursor: pointer;float:left;margin-left: 20px; width: 40px;height: 40px;" src="../images/bg/wslogn_old_wev8.png" align="middle" /><SPAN class="title" style="float:left;"><%=SystemEnv.getHtmlLabelName(31953,user.getLanguage()) %></SPAN>
</div>
<div style="height: 40px;width: 780px;">
</div>
<div align="left" style="height: 55px;width:780px;PADDING-top: 5px;margin-right:0px auto;margin-left:0px auto;">
	<SPAN style="margin-left:100px;margin-right:auto;height: 55px;color:#3eaf0e;font-size: 30px;"><%=SystemEnv.getHtmlLabelName(83360,user.getLanguage()) %></SPAN>
    <table cellpadding="1" cellspacing="0" style="width:220px;font-size: 11px;float:right;">
	 <tr>
	 <td>&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(83402,user.getLanguage()) %><div style="background: url(../images/bg/syy/0-2_wev8.png) no-repeat;width:15px;height:15px;font-size: 10px;margin-top:2px;margin-left:0px;margin-right:auto;float:left;"></div>
	 </td>
	 </tr>
	 <tr>
	 <td>&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(83403,user.getLanguage()) %><div style="background: url(../images/bg/syy/1-2_wev8.png) no-repeat;border:0px solid;width:15px;height:15px;font-size: 10px;margin-top:2px;margin-left:0px;margin-right:auto;float:left;"></div>
	 </td>
	 </tr>
	 <tr>
	 <td>&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(83404,user.getLanguage()) %><div style="border:1px solid;width:10px;height:10px;margin-left:0px;margin-top:2px;margin-right:auto;float:left;"></div>
	 </td>
	 </tr>
	</table>
    
</div>
<div align="center" class="history" style="width:980px;margin:0px auto;">
<div id="info" name="info" style="height: 30px;width: 780px;"><c:out value="${info}"  escapeXml="false"/></div>
<div style="width: 780px;">
<table border="0" cellpadding="0" cellspacing="0">
<colgroup>
<col width="80px">
<col width="672px">
</colgroup>
<tbody>
	<tr>
		<td class="maintd">
		</td>
		<td class="maintd">
		<div style="height: 24px;overflow: hidden;BACKGROUND: #3eaf0e;padding:4px" >
                <div class="searchtypeline "></div>
				<div class="searchtype searchtype_click" _type="1" contentType="ALL" _type="3"><%=SystemEnv.getHtmlLabelName(332,user.getLanguage()) %></div>
				<div class="searchtype" _type="2" contentType="DOC" title="<%=SystemEnv.getHtmlLabelName(58,user.getLanguage()) %>"><%=SystemEnv.getHtmlLabelName(58,user.getLanguage()) %></div>
				<%
				List list1=pageContext.getAttribute("allSchemas")==null?null:(List)pageContext.getAttribute("allSchemas");
				if(list1 != null){
					int cnt = 3;
					for(Object obj:list1){
						if(obj != null && ((String)obj).indexOf(":") > 0){
						    String str = (String)obj;
							String key = str.substring(0, str.indexOf(":"));
							String content = str.substring(str.indexOf(":")+1);
							if(cnt <= 10) {
				%>
				<div class="searchtype" _type="<%=cnt %>" contentType="<%=key %>" title="<%=content %>"><%=content %></div>
				<%			} else if(cnt == 11){%>
				<div class="moreType" _type="13" contentType="" ><%=SystemEnv.getHtmlLabelName(17499,user.getLanguage()) %></div>
				<ul id="so-nav-more" style="display:none">
					<li><a href="javascript:" contentType="<%=key %>" title="<%=content %>"><%=content %></a></li>
				<%			} else {%>
					<li><a href="javascript:" contentType="<%=key %>" title="<%=content %>"><%=content %></a></li>
				<%			}
				             cnt++;
						}
					}
					if(cnt > 11){ %>
				</ul>
				<%		} 
				}%>
				<!--<div class="searchtype" _type="3" contentType="WF" >流程</div>
				<div class="searchtype" _type="4" contentType="RSC" >人员</div>
				<div class="searchtype" _type="5" contentType="EMAIL" >邮件</div>
				<div class="searchtype" _type="6" contentType="COW" >协作</div>
				<div class="searchtype" _type="7" contentType="CRM" >客户</div>
				<div class="searchtype" _type="8" contentType="WKP" >日程</div>
				<div class="searchtype" _type="9" contentType="WKP" >日程</div>
				<div class="searchtype" _type="10" contentType="WKP" >日程</div>
				<div class="searchtype" _type="11" contentType="WKP" >日程</div>
				<div class="searchtype" _type="12" contentType="WKP" >日程</div>
				<div class="moreType" _type="13" contentType="" >更多</div>
				<ul id="so-nav-more" style="display:none">
					<li><a href="javascript:" contentType="BK">百科</a></li>
					<li><a href="javascript:" contentType="SF">软件</a></li>
					<li><a href="javascript:" contentType="BUY">购物</a></li>
					<li><a href="javascript:" contentType="DOC">文档</a></li>
				</ul>-->
		</div>
		</td>
	</tr>
	<tr>
		<td class="maintd" >
		<div style="border:1px solid #3eaf0e;position:relative">
		<div id="topbtn" name="topbtn" class="btnV topbtn" >
		</div>
		<div style="height:226px;" >
		    <div id="years" name="years" style="height:226px;overflow-y:hidden;">
			<UL id=s_allyears class=s-allyears style="margin-top: 0px;">
				<c:forEach var="ys" items="${years}" varStatus="status">
				<LI data-index="3" coltype="1">
					<c:choose>
					  <c:when test="${status.first}">
						 <div class="year year_click" year="<c:out value="${ys}"/>"><c:out value="${ys}"/><%=(user.getLanguage()==7 ||user.getLanguage()==9)?"年":"" %></div>
					  </c:when>
					  <c:otherwise>
						 <div class="year" year="<c:out value="${ys}"/>"><c:out value="${ys}"/><%=(user.getLanguage()==7 ||user.getLanguage()==9)?"年":"" %></div>
					  </c:otherwise>
					</c:choose>
				</LI>
				</c:forEach>
				<!--<LI data-index="3" coltype="1">
					<div class="year" year="2012">2012年</div>
				</LI>
				<LI data-index="3" coltype="1">
					<div class="year" year="2011">2011年</div>
				</LI>
				<LI data-index="3" coltype="1">
					<div class="year" year="2010">2010年</div>
				</LI>
				<LI data-index="3" coltype="1">
					<div class="year" year="2009">2009年</div>
				</LI>
				<LI data-index="3" coltype="1">
					<div class="year" year="2008">2008年</div>
				</LI>
				<LI data-index="3" coltype="1">
					<div class="year" year="2007">2007年</div>
				</LI>
				<LI data-index="3" coltype="1">
					<div class="year" year="2006">2006年</div>
				</LI>
				<LI data-index="3" coltype="1">
					<div class="year" year="2005">2005年</div>
				</LI>
				<LI data-index="3" coltype="1">
					<div class="year" year="2004">2004年</div>
				</LI>
				<LI data-index="3" coltype="1">
					<div class="year" year="2003">2003年</div>
				</LI>
				<LI data-index="3" coltype="1">
					<div class="year" year="2002">2002年</div>
				</LI>-->
				
			</div>
			
		</div>
		<div id="bottombtn" name="bottombtn" class="btnV bottombtn" >
		</div>
		</div>
		</td>
		<td class="maintd">
		<table class="listview" cellpadding="0" cellspacing="0" style="width:672px;" width="672">
			<tbody>
				<tr height="100">
					<td height="100"   month="101" style="border-left:1px solid #3eaf0e;border-top:1px solid #3eaf0e;">
						01<%=(user.getLanguage()==7 ||user.getLanguage()==9)?"月":"" %><br />
						<div class="btndiv" ><div class="btns redo" title="<%=SystemEnv.getHtmlLabelName(83355,user.getLanguage()) %>"></div><div class="btns delete" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage()) %>"></div></div>
					</td>
					<td   month="102" style="border-top:1px solid #3eaf0e;">
						02<%=(user.getLanguage()==7 ||user.getLanguage()==9)?"月":"" %><br />
						<div class="btndiv"><div class="btns redo" title="<%=SystemEnv.getHtmlLabelName(83355,user.getLanguage()) %>"></div><div class="btns delete" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage()) %>"></div></div>
					</td>
					<td  month="103" style="border-top:1px solid #3eaf0e;">
						03<%=(user.getLanguage()==7 ||user.getLanguage()==9)?"月":"" %><br />
						<div class="btndiv"><div class="btns redo" title="<%=SystemEnv.getHtmlLabelName(83355,user.getLanguage()) %>"></div><div class="btns delete" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage()) %>"></div></div>
					</td>
					<td   month="104" style="border-top:1px solid #3eaf0e;">
						04<%=(user.getLanguage()==7 ||user.getLanguage()==9)?"月":"" %><br />
						<div class="btndiv"><div class="btns redo" title="<%=SystemEnv.getHtmlLabelName(83355,user.getLanguage()) %>"></div><div class="btns delete" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage()) %>"></div></div>
					</td>
				</tr>
				<tr height="100">
					
					<td  month="105" style="border-left:1px solid #3eaf0e;">
						05<%=(user.getLanguage()==7 ||user.getLanguage()==9)?"月":"" %><br />
						<div class="btndiv"><div class="btns redo" title="<%=SystemEnv.getHtmlLabelName(83355,user.getLanguage()) %>"></div><div class="btns delete" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage()) %>"></div></div>
					</td>
					<td  month="106">
						06<%=(user.getLanguage()==7 ||user.getLanguage()==9)?"月":"" %><br />
						<div class="btndiv"><div class="btns redo" title="<%=SystemEnv.getHtmlLabelName(83355,user.getLanguage()) %>"></div><div class="btns delete" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage()) %>"></div></div>
					</td>
					<td   month="107">
						07<%=(user.getLanguage()==7 ||user.getLanguage()==9)?"月":"" %><br />
						<div class="btndiv"><div class="btns redo" title="<%=SystemEnv.getHtmlLabelName(83355,user.getLanguage()) %>"></div><div class="btns delete" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage()) %>"></div></div>
					</td>
					<td  month="108">
						08<%=(user.getLanguage()==7 ||user.getLanguage()==9)?"月":"" %><br />
						<div class="btndiv"><div class="btns redo" title="<%=SystemEnv.getHtmlLabelName(83355,user.getLanguage()) %>"></div><div class="btns delete" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage()) %>"></div></div>
					</td>
				</tr>
				<tr height="100">
					
					<td  month="109" style="border-left:1px solid #3eaf0e;">
						09<%=(user.getLanguage()==7 ||user.getLanguage()==9)?"月":"" %><br />
						<div class="btndiv"><div class="btns redo" title="<%=SystemEnv.getHtmlLabelName(83355,user.getLanguage()) %>"></div><div class="btns delete" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage()) %>"></div></div>
					</td>
					<td   month="110">
						10<%=(user.getLanguage()==7 ||user.getLanguage()==9)?"月":"" %><br />
						<div class="btndiv"><div class="btns redo" title="<%=SystemEnv.getHtmlLabelName(83355,user.getLanguage()) %>"></div><div class="btns delete" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage()) %>"></div></div>
					</td>
					<td  month="111">
						11<%=(user.getLanguage()==7 ||user.getLanguage()==9)?"月":"" %><br />
						<div class="btndiv"><div class="btns redo" title="<%=SystemEnv.getHtmlLabelName(83355,user.getLanguage()) %>"></div><div class="btns delete" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage()) %>"></div></div>
					</td>
					<td  month="112">
						12<%=(user.getLanguage()==7 ||user.getLanguage()==9)?"月":"" %><br />
						<div class="btndiv"><div class="btns redo" title="<%=SystemEnv.getHtmlLabelName(83355,user.getLanguage()) %>"></div><div class="btns delete" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage()) %>"></div></div>
					</td>
				</tr>
			</tbody>
		</table>
		</td>
	</tr>
</tbody>
</table>

</div>
</div>

<form name="frm" id="frm" action="#" method="post">
<input type="hidden" name="action" id="action" value="createIndex"/>
<input type="hidden" name="indexDbName" id="indexDbName" value=""/>
<input type="hidden" name="date" id="date" value="<c:out value="${date}"/>"/>
<input type="hidden" name="contentType" id="contentType" value="<c:out value="${contentType}"/>"/>
</form>
</body>
</html>
