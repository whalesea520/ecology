<!DOCTYPE HTML>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="weaver.wechat.util.DateUtil"%>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<html>
<head>
<title><%=SystemEnv.getHtmlLabelName(221,user.getLanguage())+SystemEnv.getHtmlLabelName(81634,user.getLanguage())%></title>
<meta http-equiv="Content-Type" content="text/html; charset=GBK">

<link rel=stylesheet href="/css/Weaver_wev8.css" type="text/css" />
<LINK href="/wechat/css/material_wev8.css" type="text/css" rel="STYLESHEET">

<script type="text/javascript">var languageid=<%=user.getLanguage()%>;</script>
<script type="text/javascript" src="/wechat/kindeditor/kindeditor.js"></script>
<%
    if(user.getLanguage()==8){
%>
    <script type="text/javascript" src="/wechat/kindeditor/lang/en.js"></script>
<%
	}else if(user.getLanguage()==9){
%>
   <script type="text/javascript" src="/wechat/kindeditor/lang/zh_TW.js"></script>
<%
    }else{
%>
    <script type="text/javascript" src="/wechat/kindeditor/lang/zh_CN.js"></script>
<%
    }
%>	

<style>
.upload_area a{
	color: #000 !important;
}

.upload_area a:hover{
	color: #000 !important;
}
</style>


</head>
<body>
<%
String userid = "" + user.getUID();
String newsId=Util.null2String(request.getParameter("newsid"));
String remark="";
String newsType="";



int limitSize=8;//新建图文的最大条数

int addSize=1;//目前最大编号 dsporder
int itemSize=1;//总数

String msg_title="";
String msg_picUrl="";
String msg_summary="";
String msg_url="";


if(!"".equals(newsId)){
	rs.execute("select * from wechat_news where createrid="+userid+" and id="+newsId);
	if(!rs.next()){
%>		
		<script>
			alert("<%=SystemEnv.getHtmlLabelName(561,user.getLanguage())+SystemEnv.getHtmlLabelName(2245,user.getLanguage())%>");
			window.close();
		</script>

<%		return;
	}else{
		remark=rs.getString("name");
		newsType=rs.getString("newstype");
		//哪些记录条数
		rs.execute("select dspOrder,title,picUrl,summary,url from wechat_news_material where newsid="+newsId+" order by dsporder asc");
		itemSize=rs.getCounts();
		if(rs.next()){
			addSize=rs.getInt("dspOrder");//应该来说第一条 是1
			msg_title=Util.null2String(rs.getString("title"));
			msg_picUrl=Util.null2String(rs.getString("picUrl"));
			msg_summary=Util.null2String(rs.getString("summary"));
			msg_url=Util.null2String(rs.getString("url"));
		}
		if("".equals(msg_url)){
			msg_url="/wechat/view.jsp?nid="+newsId+"&uid="+userid+"&dsp="+addSize;
		}
	}
}

if("".equals(newsId)){
%>
		<script>
			alert("<%=SystemEnv.getHtmlLabelName(561,user.getLanguage())+SystemEnv.getHtmlLabelName(2245,user.getLanguage())%>");
			window.close();
		</script>

<%
}

String imagefilename = "/images/hdReport.gif";
String titlename = SystemEnv.getHtmlLabelName(221,user.getLanguage())+SystemEnv.getHtmlLabelName(81634,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<div class="main_bd" style="margin:10px;">    
	<div class="media_preview_area">
		<%if("1".equals(newsType)){%>
			<div class="appmsg">            
				<div id="js_appmsg_preview" class="appmsg_content">                                            
					<div id="appmsgItem1" data-fileid="<%=newsId%>" data-id="1" class="js_appmsg_item  <%=(!"".equals(msg_picUrl))?"has_thumb":""%>">
							<h4 class="appmsg_title">
								<a onclick="return false;" href="javascript:void(0);" target="_blank"><%="".equals(msg_title)?"标题":msg_title%></a>
							</h4>
							<div class="appmsg_info">
								<em class="appmsg_date"></em>
							</div>
							<div class="appmsg_thumb_wrp ">
								<img class="js_appmsg_thumb appmsg_thumb" src="<%=msg_picUrl%>">
								<i class="appmsg_thumb default">封面图片</i>
							</div>
							<p class="appmsg_desc"><%=msg_summary%></p>
					</div>
				</div>                    
			</div> 

		<%}else{%>
			<div class="appmsg multi">
				<div id="js_appmsg_preview" class="appmsg_content">
					<div id="appmsgItem1" data-fileid="<%=newsId%>" data-id="1" class="js_appmsg_item <%=(!"".equals(msg_picUrl))?"has_thumb":""%>">
						<div class="appmsg_info">
							<em class="appmsg_date"></em>
						</div>
						<div class="cover_appmsg_item">
							<h4 class="appmsg_title">
								<a href="javascript:void(0);" onclick="return false;" target="_blank"><%="".equals(msg_title)?"标题":msg_title%></a>
							</h4>
							<div class="appmsg_thumb_wrp">
								<img class="js_appmsg_thumb appmsg_thumb" src="<%=msg_picUrl%>">
								<i class="appmsg_thumb default">封面图片</i>
							</div>
							<div class="appmsg_edit_mask">
								<a onclick="editGray(this)" class="icon18_common edit_gray js_edit" data-id="1" href="javascript:void(0);" >编辑</a>
							</div>
						</div>
    
					</div>
					<%
					while(rs.next()){
						addSize=rs.getInt("dspOrder");
						String temp_title=Util.null2String(rs.getString("title"));
						String temp_pic=Util.null2String(rs.getString("picUrl"));
					%>
						<div id="appmsgItem2" data-fileid="<%=newsId%>" data-id="<%=addSize%>" class="appmsg_item js_appmsg_item <%=(!"".equals(temp_pic))?"has_thumb":""%>">
							<%if(!"".equals(temp_pic)){%>
								<img class="js_appmsg_thumb appmsg_thumb" src="<%=temp_pic%>">
							<%}else{%>
								<i class="appmsg_thumb default">缩略图</i>
							<%}%>
							<h4 class="appmsg_title">
								<a onclick="return false;" href="javascript:void(0);" target="_blank"><%="".equals(temp_title)?"标题":temp_title%></a>
							</h4>
							<div class="appmsg_edit_mask">
								<a class="icon18_common edit_gray js_edit" data-id="2" onclick="editGray(this)" href="javascript:void(0);">编辑</a>
								<a class="icon18_common del_gray js_del" data-id="2" onclick="delGray(this)" href="javascript:void(0);">删除</a>
							</div>
						</div>
					
					<%}	
					%>
				</div>
            </div>		
		<%}%>
	</div>    
	<div class="media_edit_area">        
		<div id="js_appmsg_editor">
			<div class="appmsg_editor" style="margin-top: 0px;">
				<div class="inner">
					 <iframe src="<%=msg_url %>" id="vewNewsframe" name="vewNewsframe" class="flowFrame" frameborder="0" 
					 height="450px" width="100%;"></iframe>
	        
				</div>
			</div>
			
		</div>
	</div>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout type="2col">
		<wea:group context="">
			<wea:item type="toolbar">

				<input type="button"
					value="<%=SystemEnv.getHtmlLabelName(309, user.getLanguage())%>"
					id="zd_btn_cancle" class="zd_btn_cancle" onclick="btn_cancle()">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
</body>
</html>
<script>
var current_id=1;
//初始化
jQuery(function(){
		
	 $('.js_appmsg_item').click(function(){
		var id=$(this).data("id");
		if(current_id==id){
			return;
		}else{
			$.post("materialOperate.jsp", 
				{"operate":"queryUrl","newsId":"<%=newsId%>","userId":"<%=userid%>","dsporder":id},
				function(data){
					var data=data.replace(/[\r\n]/g,"").replace(/[ ]/g,"");
					var jsonData=eval('('+data+')');
					$('#vewNewsframe').attr("src",jsonData.url); 
					current_id=id;
				});
		}		
	 });
	 
});

function btn_cancle(){
	var dialog;
    try{
    	dialog = parent.getDialog(window);
    }catch(e){}
    if(!dialog){
    	try{
	    	dialog = parent.parent.getDialog(parent);
	    }catch(e){}
    }
    if(!!dialog){
    	dialog.closeByHand();
    } else {
    	window.close();
    }
}

</script>