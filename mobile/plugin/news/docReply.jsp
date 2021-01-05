<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.general.*"%>
<%@ page import="weaver.file.Prop"%>
<%@ page import="weaver.docs.docs.DocComInfo"%>
<%@ page import="weaver.hrm.resource.ResourceComInfo"%>
<%@ page import="weaver.conn.RecordSet"%>
<%@ page import="weaver.wxinterface.WxInterfaceInit"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<jsp:useBean id="dc" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="sfd" class="weaver.splitepage.operate.SpopForDoc" scope="page" />
<jsp:useBean id="rc" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="DocManager" class="weaver.docs.docs.DocManager" scope="page" />
<%
	int docid = Util.getIntValue(request.getParameter("docid"),0);
	if(docid==0){
		response.sendRedirect("/notice/noright.jsp");
		return ;
	}
	String userInfo=user.getLogintype()+"_"+user.getUID()+"_"+user.getSeclevel()+"_"+user.getLogintype()+"_"+user.getUserDepartment()+"_"+user.getUserSubCompany1();
	ArrayList PdocList = sfd.getDocOpratePopedom(docid+"",userInfo);
	boolean canReader = ((String)PdocList.get(0)).equals("true");
	String parentids=Util.null2String(request.getParameter("parentids"));
    String docName="";
    String newParentIds=","+parentids;
    int lastFlagIndex=newParentIds.lastIndexOf(",");
    String replyedDoc=newParentIds.substring(lastFlagIndex+1);
    String replyedName=dc.getDocname(replyedDoc);
    if (replyedName.indexOf("Re:")!=-1)  docName=replyedName;
    else  docName="Re: "+replyedName;
       

    DocManager.resetParameter();
    DocManager.setId(docid);
    DocManager.getDocInfoById();

    int maincategory=DocManager.getMaincategory();
    int subcategory=DocManager.getSubcategory();
    int seccategory=DocManager.getSeccategory();
    int replydocid=DocManager.getReplydocid();
    String docsubject=DocManager.getDocsubject();
    DocManager.closeStatement();
    
    String operationurl = "/mobile/plugin/news/operation.jsp";
    if(WxInterfaceInit.isIsutf8()) operationurl = "/mobile/plugin/news/operation_wev8.jsp";
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>文档回复</title>
	<meta name="viewport" content="width=device-width,initial-scale=1.0,minimum-scale=1.0, maximum-scale=1.0" />
	<script type='text/javascript' src="/mobile/plugin/news/js/jquery-1.8.3.min.js"></script>
	<script type='text/javascript' src="/mobile/plugin/news/js/jquery.form.js"></script>
</head>	
<style>
body{
	font-family:"微软雅黑";
	margin: 0 auto;
	width:100%;
	font-size:14px;
	color:#333;
}
input,button,select,textarea,div{outline:none}
.listitem {
	border-bottom: 1px solid #D8DDE4;
	cursor: pointer;
	position: relative;
	z-index:1;
	overflow: hidden;
	padding-top:5px;
}
.listTable{
	width:100%;
	border:0;
	cellspacing:0;
	cellpadding:0;
	table-layout:fixed;
}
.listTable tr{
	height:30px;
}
.listTable td{
	line-height:30px;
	color:#000;
}
.listTable th{
	word-break: keep-all;
	white-space: nowrap;
	overflow: hidden;
	text-overflow:ellipsis;
	color:#000;
	text-align:left;
}
.listTable td span{
	color: #6a9df2;
	font-size:12px;
}
.comment{
	border:1px solid #e7e7e7;
	margin:0px 10px;
	padding:5px;
	background: #f6f6f6;
	margin-top: 10px;
}
.topdiv{
	padding:10px;
}
.tdiv{
	border-bottom: 1px solid #D8DDE4;
}
.topdiv textarea{
	font-family:"微软雅黑";
	margin:0;
	padding:0;
	background:#fff;
	border-radius:0;
	border:1px solid #d5d5d5;
	line-height:24px;
	height:80px;
	width:100%;
	min-width:260px;
	text-indent:5px;
	-webkit-appearance:none;
}
.btn{
	margin:10px 0px;;
	background:#87b87f;
	color: #fff;
	height:34px;
	font-size:18px;
	line-height:34px;
	text-align:center;
	cursor: pointer;
	width:100%;
	border:1px solid #87b87f;
}
.name{
	font-size:18px;
	color:#1aa5d3 !important;
	text-align: left;
	padding-left:5px;
	word-break: keep-all;
	white-space: nowrap;
	overflow: hidden;
	text-overflow:ellipsis;
}
.date{
	font-size:14px;
	color:#666;
	text-align: right;
	word-break: keep-all;
	white-space: nowrap;
	overflow: hidden;
	text-overflow:ellipsis;
}
.content{
	font-size:16px;
	color:#333;
	padding-left:5px;
}
.tips{
	line-height:30px;
	text-align: center;
	font-style: italic;
}
.btn2{
	border:1px solid #f1f1f1;
	background:#f1f1f1;
}
</style>
<script>
var canClick = true;
$(document).ready(function(){
	$("#submit").click(function(){
		if(!canClick){
			return;
		}
		var content = $.trim($("#doccontent").val());
		if(content==""){
			$("#doccontent").focus();
			return;
		}
		canClick = false;
		$(this).addClass("btn2");
		$("#form").submit();
	});
	$("#frame").load(function(){
		var temp = "<div class='listitem'><table class='listTable'>";
		temp+="<tr><td width='30'><img src='<%=rc.getMessagerUrls(user.getUID()+"") %>' width='30' height='30'/></td>";
		temp+="<td class='name' width='30%'><%=rc.getLastname(user.getUID()+"")%></td><td class='date'>刚刚</td></tr>";
		temp+="<tr><td>&nbsp;</td><td class='content' colspan='2'>"+$("#doccontent").val()+"</td></tr>";
		temp+="</table></div>";
		$("#doccontent").val("");
		$(".tips").hide();
		$(".comment").prepend(temp);
		canClick = true;
		$("#submit").removeClass("btn2");
	});
});
</script>
<body>
<%if(canReader){ %>
<form target="frame" action="<%=operationurl %>" id="form" method="post" enctype="multipart/form-data">
	<input type="hidden" name="docsubject" value="<%=docName%>">
	<input type="hidden" name="docapprovable" value="0">
	<input type="hidden" name="docreplyable" value="1">
	<input type="hidden" name="isreply" value="1">
	<input type="hidden" name="docpublishtype" value="1">
	<input type="hidden" name="replydocid" value="<%=docid%>">
	<input type="hidden" name="usertype" value="<%=user.getLogintype()%>">
	<input type="hidden" name="maincategory" value="<%=maincategory%>">
	<input type="hidden" name="docdepartmentid" value="<%=user.getUserDepartment()%>">
	<input type="hidden" name="subcategory" value="<%=subcategory%>">
	<input type="hidden" name="doclangurage" value="<%=user.getLanguage()%>">
	<input type="hidden" name="seccategory" value="<%=seccategory%>">
	<input type="hidden" name="operation" value="addsave">
	<input type="hidden" name="parentids" value="<%=parentids%>">
	<input type="hidden" name="docstatus" value="0">
	<input type="hidden" name="ownerid" value="<%=user.getUID()%>">
	<input type="hidden" name="namerepeated" value="0">
	<input type="hidden" name="accessorynum" value="1">
	<div style="display: none;">
		<input type=file name="accessory1">
	</div>
	<div class="topdiv">
		<div class="tdiv">
			<textarea id="doccontent" name="doccontent"></textarea>
			<div class="btn" id="submit">发表评论</div>
		</div>
	</div>
</form>
<iframe id="frame" name="frame" style="display:none;" src=""></iframe>
<%} %>
<div class="comment">
<%
	String content = getDocReply(docid+"",0,rc); 
	if(!content.equals("")){
		out.println(content);
	}else{
%>
	<div class="tips">暂时还没有任何评论，快来抢沙发吧!</div>
<%} %>
</div>
<%! 
	public String getDocReply(String docid,int padding,ResourceComInfo rc){
		RecordSet rs = new RecordSet();
		StringBuffer sb = new StringBuffer();
		if(rs.getDBType().equals("oracle")){//oracle数据库 图文内容存放在DocDetailContent
			sb.append("select a.id,b.doccontent,a.doccreaterid,a.doccreatedate,a.doccreatetime from DOCDETAIL a,");
			sb.append("DocDetailContent b where a.id = b.docid and a.isreply = 1 and replydocid="+docid);
			sb.append(" and (a.docstatus = 1 or a.docstatus = 2) order by a.id desc");
			rs.executeSql(sb.toString());
		}else{
			sb.append("select id,doccontent,doccreaterid,doccreatedate,doccreatetime "+
					" from DocDetail where (docstatus = 1 or docstatus = 2) and isreply = 1 and replydocid="+docid+" order by id desc");
		}
		rs.executeSql(sb.toString());
		StringBuffer temp = new StringBuffer();
		while(rs.next()){
			String id = rs.getString("id");
			String userid = rs.getString("doccreaterid");
			String doccontent = Util.null2String(rs.getString("doccontent"));
			String date = rs.getString("doccreatedate")+" "+rs.getString("doccreatetime");
			temp.append("<div class='listitem' style='padding-left:"+padding+"px'>");
			temp.append("<table class='listTable'>");
			temp.append("<tr><td width='30'><img src='"+rc.getMessagerUrls(userid)+"' width='30' height='30'/></td>");
			temp.append("<td class='name' width='30%'>"+rc.getLastname(userid)+"</td><td class='date'>"+date+"</td></tr>");
			temp.append("<tr><td>&nbsp;</td><td class='content' colspan='2'>"+doccontent+"</td></tr>");
			temp.append("</table></div>");
			temp.append(getDocReply(id,padding+30,rc));
		}
		return temp.toString();
	}
%>
</body>
</html>