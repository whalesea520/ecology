
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="java.text.SimpleDateFormat"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="weaver.cowork.*" %> 
<%@ page import="java.io.*" %>
<%@ page import="weaver.file.FileUpload" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="settingComInfo" class="weaver.systeminfo.setting.HrmUserSettingComInfo" scope="page" />
<%
	int userid=user.getUID();//用户id
	FileUpload fu = new FileUpload(request);
	String from = Util.null2String(fu.getParameter("from"));
	String isCoworkHead=settingComInfo.getIsCoworkHead(settingComInfo.getId(""+userid));
	int currentpage =1;
	String datetype=Util.null2String(request.getParameter("datetype"),"week");
%>
<html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link rel="stylesheet" href="/cowork/css/cowork_wev8.css" type="text/css" />
<link rel=stylesheet href="/css/Weaver_wev8.css" type="text/css" />
<script type="text/javascript">var languageid=<%=user.getLanguage()%>;</script>
<SCRIPT language="VBS" src="/cowork/js/Cowork.vbs"></SCRIPT>
<script language=javascript src="/js/weaver_wev8.js"></script>

<SCRIPT language="javascript" defer="defer" src="/cowork/js/coworkUtil_wev8.js"></script>
<link rel=stylesheet type="text/css" href="/cowork/css/coworkNew_wev8.css"/>

<!-- 图片缩略 -->
<link href="/blog/js/weaverImgZoom/weaverImgZoom_wev8.css" rel="stylesheet" type="text/css">
<script src="/blog/js/weaverImgZoom/weaverImgZoom_wev8.js"></script>

<!--引入ueditor相关文件-->
<script type="text/javascript" charset="UTF-8" src="/ueditor/ueditor.config_wev8.js"></script>
<script type="text/javascript" charset="UTF-8" src="/ueditor/ueditor.all_wev8.js"> </script>
<script type="text/javascript" charset="UTF-8" src="/ueditor/lang/zh-cn/zh-cn_wev8.js"></script>

<script type="text/javascript" src="/cowork/js/kkpager/kkpager_wev8.js"></script>
<link rel="stylesheet" href="/cowork/js/kkpager/kkpager_wev8.css" type="text/css"/>

<jsp:include page="CoworkUtil.jsp"></jsp:include>
</head>
<script  type="text/javascript">

var isAnonymous="0";
var isCoworkTypeAnonymous="0";
var approvalAtatus="0";
jQuery(document).ready(function(){
  
  toPage(1);
   //绑定收缩下拉框事件
   if(jQuery(window.parent.document).find("#ifmCoworkItemContent")[0]!=undefined){
	    jQuery(document.body).bind("mouseup",function(){
		   parent.jQuery("html").trigger("mouseup.jsp");	
	    });
	    jQuery(document.body).bind("click",function(){
			jQuery(parent.document.body).trigger("click");		
	    });
    }
});

function toPage(pageNum){
	
	displayLoading(1,"page");
	jQuery.post("/cowork/DiscussRecord.jsp?recordType=replay&type=1&currentpage="+pageNum+"&datetype=<%=datetype%>",{},function(data){
          
          var tempdiv=jQuery("<div>"+data+"</div>");
          tempdiv=coomixImg(tempdiv);
          
          jQuery("#discusses").html("").append(tempdiv);
          
          //为留言添加背景颜色
		  displayLoading(0);
		  resizeImg(); 
  }); 
  
 } 
    /*
    点赞功能
    **/
    function agree(status,itemId,discussid){
         $.ajax({
            url: '/cowork/CoworkCountVotes.jsp?status='+status+'&itemId='+itemId+'&discussid='+discussid,
            async : false,
            success: function(result){
               result = eval('('+result+')');
               var votetype=result.votetype; 
               var agreevote=result.agreevote;
            //   $("#agreevote_"+discussid).html("("+agreevote+")");
               var initcount=$("#agreevote_"+discussid).html().replace("(","").replace(")","");//取实时页面赞数
               //赞
               if(0==votetype){
            //     $("#agreevoteclick_"+discussid).find("img").attr("src","/cowork/images/zaned_wev8.png");
                   $("#agreevoteclick_"+discussid).attr("class","zaned item replayLink");
                   $("#agreevoteclick_"+discussid).attr("title","<%=SystemEnv.getHtmlLabelNames("201,32942", user.getLanguage())%>");
                   $("#agreevote_"+discussid).html("("+(initcount*1+1)+")");
               }
               //取消状态
               else{
            //     $("#agreevoteclick_"+discussid).find("img").attr("src","/cowork/images/zan_wev8.png");
                   $("#agreevoteclick_"+discussid).attr("class","zan item replayLink");
                   $("#agreevoteclick_"+discussid).attr("title","<%=SystemEnv.getHtmlLabelName(32942, user.getLanguage())%>");
                   $("#agreevote_"+discussid).html("("+(initcount*1-1)+")");
               }
            }
        })
    }
    
      /*
    收藏功能
   **/
   function collect (itemId,discussid){
       $.ajax({
            url: '/cowork/CoworkCollect.jsp?itemId='+itemId+'&discussid='+discussid,
            async : false,
            success: function(result){
                result = eval('('+result+')');
                var iscollect=result.iscollect;
                if(iscollect==1){
                //收藏了
                 $("#collect_"+discussid).find("img").attr("src","/cowork/images/collect_wev8.png");
                }else{
                //取消了
                 $("#collect_"+discussid).find("img").attr("src","/cowork/images/nocollect_wev8.png");
                }
            }
       }) 
   }


</script>
<body id="ViewCoWorkBody" style="overflow: auto;">
<div id="divTopMenu"></div>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<!-- 提交回复等待 -->
<div id="coworkLoading" class="loading" align='center'>
	<div id="loadingdiv" style="right:260px;">
		<div id="loadingMsg">
			<div><%=SystemEnv.getHtmlLabelName(81558,user.getLanguage())%></div>
		</div>
	</div>
</div>

<a id="top" href="#"></a>
<div style="height: 100%;padding-left:5px;padding-right:5px;">
<form name="frmmain" id="frmmain" method="post" action="CoworkOperation.jsp">
  <input type=hidden name="method" id="method" value="doremark">
  <input type=hidden name="id" id="coworkid" value="0">
  <input type=hidden name="replayid" id="replayid" value="0">
  <input type=hidden name="floorNum" id="floorNum" value="0">
  <input type=hidden name="remark" id="remark" value="0">
  <input type=hidden name="from" id="remark" value="<%=from%>">

<div id="editorTmp" style="display:none">
	<!--请填写回复内容-->
    <div id="tipcontent" class="tipcontent"><%=SystemEnv.getHtmlLabelName(23073,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(18546,user.getLanguage())%></div>
    <div style="margin-bottom: 3px;margin-top:3px;">  
       <textarea name="remark_content" _editorName="remark_content" id="replay_content_###" style="width:100%;height:80px;border:1px solid #C7C7C7;" class="replayContent" ></textarea>
    </div>
	   
	<div class="discussOperation">
	   	   <div class=left>
		       <button type=button class="submitBtn" onclick="doSave(this,'doremark')"><%=SystemEnv.getHtmlLabelName(117,user.getLanguage())%></button> <!-- 回复 -->
		       <button type=button class="cancelBtn" onclick="cancelReply(this,'comment')"><%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></button> <!-- 取消 -->
	   	   	   <span id="isAnonymous_span"></span>
	   	   </div>
   	</div>
</div>
  
<!-- 最近一周被回复的留言 -->
<div style="margin-top: 8px;padding-bottom:10px;padding-top:8px;border:1px solid #c2e2e7;background-color:#ebfcff;text-align: center;display:none;">
     <%=SystemEnv.getHtmlLabelName(26261,user.getLanguage())%>
</div>
<!-- 协作交流 -->
<div style="width: 99%;padding-top: 8px" id="cowork_comm_tab">
  <div id="discusses"></div>
</div>
</form>
</div>
</body>
</html>
