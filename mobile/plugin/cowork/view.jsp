
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.systeminfo.*"%>
<%@ page import="weaver.cowork.*"%>
<%@ page import="weaver.file.FileUpload" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="CoTypeComInfo" class="weaver.cowork.CoTypeComInfo" scope="page" />
<jsp:useBean id="CoworkShareManager" class="weaver.cowork.CoworkShareManager" scope="page" />
<%
    request.setCharacterEncoding("UTF-8");
    response.setContentType("text/html;charset=UTF-8");
    
    User user = HrmUserVarify.getUser (request , response) ;
    if(user == null)  return ;
    int userid=user.getUID();
    
    FileUpload fu = new FileUpload(request);
    String module = Util.null2String((String)fu.getParameter("module"));
    String scope = Util.null2String((String)fu.getParameter("scope"));
    
    String title = Util.null2String((String)fu.getParameter("title"));
    
    String clienttype = Util.null2String((String)fu.getParameter("clienttype"));
    String clientlevel = Util.null2String((String)fu.getParameter("clientlevel"));
    
    int coworkid = Util.getIntValue(fu.getParameter("detailid"));
    //如果协作id不存在，则返回错误信息
    RecordSet.executeSql("select id from cowork_items where id="+coworkid);
    if(!RecordSet.next()){
    	out.println(SystemEnv.getHtmlLabelName(383035,user.getLanguage()));
    	return;
    }
    String name = "";
    String creater = "";
    String principal = "";
    String typeid = "";
    String begindate = "";
    String beingtime = "";
    String enddate = "";
    String endtime = "";
    String remark = "";
    String approvalAtatus="";
    String isAnonymous="";
    String isApproval="";
    
    boolean canView=CoworkShareManager.isCanView(""+coworkid,""+userid,"all");
	//如果不具有查看权限则跳转到无权限页面
    if (coworkid>0&&!canView) {
    	out.println(SystemEnv.getHtmlLabelName(2012,user.getLanguage()));
        return;
    }
    
    CoworkDAO dao = new CoworkDAO(coworkid);
    CoworkItemsVO vo = dao.getCoworkItemsVO();
    	
    if (coworkid > 0 && canView) {
    	name = Util.null2String(vo.getName());                 //协作名称
    	creater = Util.null2String(vo.getCreater());           //协作创建人
    	principal=Util.null2String(vo.getPrincipal());         //协作负责人
    	typeid=Util.null2String(vo.getTypeid());               //所属协作区
    	begindate = Util.null2String(vo.getBegindate());       //开始日期
    	beingtime = Util.null2String(vo.getBeingtime());       //开始时间      
    	enddate = Util.null2String(vo.getEnddate());           //结束日期
    	endtime = Util.null2String(vo.getEndtime());           //结束时间
    	remark = Util.null2String(vo.getRemark()).trim();	   //详细描述
    	approvalAtatus=vo.getApprovalAtatus();                 //审批状态，待审批
    	isAnonymous=vo.getIsAnonymous();
    	isApproval=vo.getIsApproval();
    	//添加查看者记录
    	String sql="select id from cowork_read where coworkid="+coworkid+" and userid="+userid;
    	RecordSet.execute(sql);  
    	if(!RecordSet.next()){
    		sql="insert into cowork_read(coworkid,userid) values("+coworkid+","+userid+")";
    		RecordSet.execute(sql);
    	}
    
    	//添加查看日志
    	dao.addCoworkLog(coworkid,2,userid,fu);
    }
    
    String isCoworkTypeAnonymous = "0";  //后台设置，板块是否允许匿名
	RecordSet.execute("select isAnonymous from cowork_types where id = "+ typeid);
    if(RecordSet.next()) {
        isCoworkTypeAnonymous = Util.null2s(RecordSet.getString("isAnonymous"), "0");
    }
%>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<meta name="author" content="Weaver E-Mobile Dev Group" />
	<meta name="description" content="Weaver E-mobile" />
	<meta name="keywords" content="weaver,e-mobile" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<title>协作</title>
	<script type="text/javascript" src="/js/jquery/jquery_wev8.js"></script>
	<script type="text/javascript" src="/mobile/plugin/widget/asyncbox/AsyncBox.v1.4_wev8.js"></script>
	<link rel="stylesheet" href="/mobile/plugin/widget/asyncbox/skins/ZCMS/asyncbox_wev8.css">
	<script type="text/javascript" src="/mobile/plugin/cowork/js/script_wev8.js"></script>
	<script type="text/javascript" src="/weaverEditor/kindeditor_wev8.js"></script>
	<style type="text/css">
		body{
			margin:0px;
		}
	
		#listArea table{
			width:100%;
			border-collapse:collapse;
			border-spacing:0;
		}
		
		#listArea table th,td{
			padding:0;
		}
		
		#view_header {
			width: 100%;
			filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#FFFFFF',endColorstr='#ececec' );
			background: -webkit-gradient(linear, left top, left bottom, from(#FFFFFF),to(#ECECEC) );
			background: -moz-linear-gradient(top, white, #ECECEC);
			border-bottom: #CCC solid 1px;
			font-size:9pt;
		}
		#view_title {
			color: #336699;
			font-size: 20px;
			font-weight: bold;
			text-align: center;
		}
	
		.hr1{
			border-top:1px dashed #C9C9C9;
			border-bottom:1px dashed #FFFFFF;
			border-left:0;
		}
	
		.hr2{
			border-bottom:1px solid #C9C9C9;
		}
	
		.replay {
			border:1px solid #C9C9C9;
			background-color: #F1F1F1;
			-webkit-border-radius:4px;
			padding:5px 10px;
			color:#666666
		}
	
		.listitem {
			padding:8px;
			font-size:13px;
		}
	
		.replayBtn {
			width:90px;
			height:20px;
			line-height:20px;
			color:#666666;
			border:1px solid #C9C9C9;
			-webkit-border-radius:10px;
			float:left;
		}
		
		.replayBtnDown {
			background-image:-webkit-gradient(linear, left top, left bottom, color-stop(0, #C9C9C9), color-stop(1, #EAEAEA));
		}
	
		.itemContent {
			padding-left:10px;
			margin-top:10px;
		}
	
		.personHeader {
			border:1px solid #C9C9C9;
			-webkit-border-radius:4px;
			width:50px;
			height:50px;
		}
		
		/* 更多 */
		.listitemmore {
			height:46px;
			text-align:center;
			line-height:80px;
			font-weight:bold;
			color:#777878;
			font-size: 13px;
		}
		
		/* 列表更新时间 */
		.lastupdatedate {
			width:100%;
			height:20px;
			text-align:right;
			font-size:12px;
			line-height:120px;
			background:#E1E8EC;
			background: -moz-linear-gradient(0, white, #E1E8EC);
			background:-webkit-gradient(linear, 0 0, 0 100%, from(white), to(#E1E8EC));
		}
		
		.opSubmit {
			margin-top:3px;
			margin-bottom:10px;
			width:59px;
			height:21px;
			line-height:21px;
			border:1px solid #B2B2B2;
			text-align:center;
			-webkit-border-radius:4px;
			background-image:-webkit-gradient(linear, left top, left bottom, color-stop(0, #F0EFEF), color-stop(1, #C9C9C9));
			float:left;
		}
		
		.itemcontentReplybox {
			margin-top:5px;
		}
		
		.inputArea {
			display:block;
			width:93%;
			border-color:#95CBEE;
			-webkit-border-radius:4px;
			color:#ACACAC;
			height:60px;
		}
		
		.headBtn {
			width:72px;
			height:33px;
			line-height:33px;
			padding-left:11px;
			margin:5px 0;
			border:1px solid #79AAD2;
			color:#296591;
			text-shadow:0 1px #FFFFFF;
			font-size: 14px;
			-webkit-border-radius:4px;
			background-image:-webkit-gradient(linear, left top, left bottom, color-stop(0, #D9E6EE), color-stop(1, #C1DBEC));
		}

		.accitem{
			padding-left:20px;
			height:28px;
		}
		.accname{float:left}
		.accsize{
			float:left;
			margin-left: 5px;
		}
		.clear{clear:both}

	  </style>
	<script type="text/javascript">
    	var today=new Date();
    	
    	var clientVersion=0;
    	var isShowEditor = true;
    	var clienttype="<%=clienttype%>";
    	var approvalAtatus="<%=approvalAtatus%>";
        var isAnonymous="<%=isAnonymous%>"; //协作是否允许匿名
        var isApproval="<%=isApproval%>";
        var isCoworkTypeAnonymous = "<%=isCoworkTypeAnonymous%>";  // 后台设置，协作板块是否允许匿名
    	
    	function highEditor(remarkid,height){
    	    height=!height||height<150?150:height;
    	    
    	    if(jQuery("#"+remarkid).is(":visible")){
    			
    			var  items=[
    							'justifyleft', 'justifycenter', 'justifyright','forecolor','bold','italic','fullscreen'
    					   ];
    				 
    			 K.createEditor({
    					id : remarkid,
    					height :height+'px',
    					themeType:'mobile',
    					resizeType:1,
    					width:'100%',
    					uploadJson:'/weaverEditor/jsp/upload_json.jsp',
    				    allowFileManager : false,
    	                newlineTag:'br',
    	                filterMode:false,
    					imageTabIndex:1,
    					langType : 'en',
    	                items : items,
    				    afterCreate : function(id) {
    						this.focus();
    						if(approvalAtatus==1){ //待审批状态禁止发言
    							KE.html(remarkid,"<div style='text-align:center;color:red'><%=SystemEnv.getHtmlLabelName(383037,user.getLanguage())%></div>");
    							this.readonly();
    						}
    				    }
    	   		});
    		}
    	}
    	
    	function showReply(obj, coworkdtlid,topdiscussid,replyType){
    		if($(obj).hasClass("replayBtnDown")) return;
    		$(".itemcontentReplybox").remove();
    		$(".replayBtn").removeClass("replayBtnDown");
    		var item=$(obj).parents(".listitem");
    		var replybox = "<div class='itemcontentReplybox'>"
    					 + "  <textarea class='inputArea' name='content' id='replayArea'></textarea>"
    					 + "  <div style='height:30px;padding-top:10px;'>"
    					 + "    <div class='opSubmit' onclick='doSave(this)' topdiscussid='"+topdiscussid+"' replyType='"+replyType+"' replayid='"+coworkdtlid+"'><%=SystemEnv.getHtmlLabelName(615,user.getLanguage())%></div>"
    					 + "    <div class='opSubmit' style='margin-left:35px;' onclick='doCancelReply()'><%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></div>";
    		if(isCoworkTypeAnonymous == "1" && isAnonymous == "1") {
                replybox +="    <input type='checkbox' name='isAnonymous' id='isAnonymous' value='1'><%=SystemEnv.getHtmlLabelName(18611,user.getLanguage())%>"
            }
    			replybox +="  </div>"
    					 + "</div>";
    		$(obj).parents(".listitem").append(replybox);
    		if(isShowEditor) {
    			highEditor("replayArea",150);
    		}
    		$(obj).addClass("replayBtnDown");
    	}
    	
    	function doSave(obj){
    	  if(approvalAtatus=="1"){
    	  	 alert("<%=SystemEnv.getHtmlLabelName(383037,user.getLanguage())%>");
    	  	 return;
    	  }
          var item=$(obj).parents(".listitem");
          
          if(isShowEditor) {
          	  var editorid=item.find("textarea[name='content']").attr("id");
          	  //K.sync("#"+editorid); //同步内容
    		  var editbody=$(KE.g[editorid].edit.doc.body);
    		  var keContentdiv=editbody.find("#ke-content-div-mobil");
    		  if(keContentdiv.length==1){
    			$("#"+editorid).val(keContentdiv.html());
    		  }else{
    			$("#"+editorid).val(editbody.html());
    		  }
          }
          
          var content=item.find("textarea[name='content']").val();
    	  
          
          var replayid=0;
          if($(obj).attr("replayid")){
              replayid=$(obj).attr("replayid");
          }
          var replyType=$(obj).attr("replyType");
          var topdiscussid=$(obj).attr("topdiscussid");
          
          if(!isShowEditor){
    	      content = content.replace(/&/g,"&amp;"); 
    	      content = content.replace(/</g,"&lt;");
    	      content = content.replace(/>/g,"&gt;");
    	      content = content.replace(/\n/g,"<br/>");
    	      content = content.replace(/ /g,'&nbsp;');   //避免空字符产生???问题
    	  }
          if(content==""){
             asyncbox.open({
    	             html:"<div style='color:#2475C8;margin:8px;'><%=SystemEnv.getHtmlLabelName(383036,user.getLanguage())%></div>",
    			　　　width : 250,
    			　　　height : 150,
    			     title : <%=SystemEnv.getHtmlLabelName(558,user.getLanguage())%>,
    			　　　btnsbar : [{
    					text : <%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%>,
    					action  : 'ok'
    				 }], 
    			　　　callback : function(action){}
    		  });
          }else{
	          content = '<p>' + content + '</p>';  // 手机端加上这个，换行后手机端才正常显示
          	  $(obj).removeAttr("onclick").css("color", "#ACACAC").text("<%=SystemEnv.getHtmlLabelName(19611,user.getLanguage())%>...").siblings(".opSubmit").remove();
    	      content = encodeURIComponent(content);
    	      //匿名
    	      var isAnonymous = '0';
    		  item.find("input:checked[name=isAnonymous]").each(function(){
    			 isAnonymous='1';
    		  });
    	      util.getData({
    		    	loadingTarget : document.body,
    	    		paras : getUrlParam("saveCowork"),//得数据的URL,
    	    		datas : {remark:content,replayid:replayid,"topdiscussid":topdiscussid,"replyType":replyType,"isAnonymous":isAnonymous,"isApproval":isApproval},
    	    		callback : function (data){
    	    			location.reload();
    	    		}
    	       });	
          } 	
    	}
    	
    	function doCancelReply(){
    		$(".itemcontentReplybox").remove();
    		$(".replayBtn").removeClass("replayBtnDown");
    	}
    
    	$(document).ready(function () {
    		if(clienttype=="android"||clienttype=="androidpad"){
    			try{
    				clientVersion=mobileInterface.getClientVersion();
    			}catch(err){}
    			
    			isShowEditor = clientVersion >= 16;
    		}
    		
    		if(isShowEditor) {
    			highEditor("contentInput",150);
    		}
    		
    		//加载数据
    		getDataList(getUrlParam(), true);
    	});
    	
    	/**
    	 * 获取url参数
    	 */
    	function getUrlParam(type) {
    		var sessionkey = $("input[name='sessionkey']").val();
    		var coworkid = $("input[name='coworkid']").val();
    		var pageindex = $("input[name='pageindex']").val();
    		var pagesize = 0;
    		var paras = "coworkid="+coworkid+"&";
    		if (type=="more") {
    			pageindex=pageindex*1+1;
    			paras=paras+"operation=getCoworkDetail&pageindex="+pageindex; //加载非第一页
    		} else if(type=="saveCowork") {
    		    paras=paras+"operation=saveCowork";            //提交协作
    		} else {
    			paras=paras+"operation=getCoworkDetail";
    		}
    		    
    		paras =paras+"&pagesize=" + pagesize + 
    			"&tk" + new Date().getTime() +"=1";
    		return paras;
    	}
    	
    	function getDataList(paras, isFirst){
    		$("#listItemMore").html("<img id='loadingImg' src='/mobile/plugin/cowork/img/ajax-loader_wev8.gif' style='vertical-align:middle;'>&nbsp;<%=SystemEnv.getHtmlLabelName(124820,user.getLanguage())%>").unbind("click");
    		
            // 10秒钟出不来，提示加载失败
            setTimeout(function(){
                if($('#loadingImg').length > 0) {
                    $("#listItemMore").html("<%=SystemEnv.getHtmlLabelName(383038,user.getLanguage())%>").bind('click', function(){
                        getDataList(getUrlParam(), $('.itemcontent').length == 0);
                    });
                }
            }, 10000);
            
    	    util.getData({
    	    	loadingTarget : document.body,
        		paras : paras,//得数据的URL,
        		callback : function (data){
        			if(isFirst) {
        				$("#listArea").html("");
        			}
        			
        			if(data.error){
    		    		$("#listItemMore").text("<%=SystemEnv.getHtmlLabelName(83781,user.getLanguage())%>");
    				} else {
    				    //验证权限 status<=0没有查看权限
    				    if(data.status<=0){
    				       $("#listItemMore").text("<%=SystemEnv.getHtmlLabelName(30816,user.getLanguage())%>");
    				       return ;
    				    }
    				    
    					var sessionkey = $("input[name='sessionkey']").val();
    					var pageindex = data.pageindex;
    					var pagesize = data.pagesize;
    					var count = data.count;
    					var ishavepre = data.ishavepre;
    					var ishavenext = data.ishavenext
    					var pagecount = data.pagecount;
    					$("input[name='pageindex']").val(pageindex);
    					$("input[name='pagesize']").val(pagesize);
    					$("input[name='count']").val(count);
    					$("input[name='ishavepre']").val(ishavepre);
    					$("input[name='ishavenext']").val(ishavenext);
    					$("input[name='pagecount']").val(pagecount);
    					
    					if(data.coworkList.length==0&&ishavenext!="1") {
    						$("#listItemMore").text("<%=SystemEnv.getHtmlLabelName(22521,user.getLanguage())%>");
    						return;
    					}
    					
    					$("#pagecontent_" + pageindex).remove();
    					
    					var listItemString = "<div id='pagecontent_" + pageindex + "'>";
    					$.each(data.coworkList, function (i, item){
    						var isAnonymous=item.isAnonymous;
    						var newapprovalAtatus = data.coworkList[i].approvalAtatus;
    						var itemstr="<div class='listitem'>";
                            itemstr 	+= "<table>"
    									+"		<TR>"
    									+"			<TD style='vertical-align:top;width:50px;'>"
    									+"				<img src='/downloadpic.do?url="+(isAnonymous=="1"?"/messager/images/icon_m_wev8.jpg":item.image)+"' class='personHeader'/>"
    									+"			</TD>"
    									+"			<TD style='color:#666666;padding-left:5px;padding-top:5px;float:left'>"
    									+"				<div>"+item.floorNum+"<%=SystemEnv.getHtmlLabelName(25403,user.getLanguage())%>&nbsp;<span style='color:#28648E;'>"+(isAnonymous=="1"?"<%=SystemEnv.getHtmlLabelName(18611,user.getLanguage())%>":item.name)+"&nbsp;</span>";
    									
    							itemstr +="<img src='/mobile/plugin/cowork/img/submit_wev8.png'></div>";
    							
    							itemstr +="				<div style='margin-top:5px;'><%=SystemEnv.getHtmlLabelName(23066,user.getLanguage())%>："+item.posttime+"</div>"
    									+"			</TD>"
    									+"			<TD style='vertical-align:top;float:right'>"
    									+"				<div class='replayBtn' onclick='showReply(this, "+item.id+","+item.id+",\"reply\")'><img src='/mobile/plugin/cowork/img/repop_wev8.png' style='vertical-align:middle;margin-left: 4px;'>&nbsp;<span><%=SystemEnv.getHtmlLabelName(19422,user.getLanguage())%></span></div>"
    									+"				<div class='replayBtn' onclick='showReply(this, "+item.id+","+item.id+",\"comment\")'><img src='/mobile/plugin/cowork/img/repop_wev8.png' style='vertical-align:middle;margin-left: 4px;'>&nbsp;<span><%=SystemEnv.getHtmlLabelName(675,user.getLanguage())%></span></div>"
    				
    									+"			</TD>"
    									+"		</TR>"
    									+"</table>"
    									+"<div class='itemcontent' style='margin-top:5px;'>";
    						if(item.replay) {
    							var replayitem = item.replay;
    							isAnonymous=replayitem.isAnonymous;
    							itemstr +="     <div class='replay'>"
    									+"			<img src='/mobile/plugin/cowork/img/return_wev8.png'>&nbsp;"+replayitem.floorNum+"<%=SystemEnv.getHtmlLabelName(25403,user.getLanguage())%>&nbsp;<span style='color:#28648E;'>"+(isAnonymous=="1"?"<%=SystemEnv.getHtmlLabelName(18611,user.getLanguage())%>":replayitem.name)+"&nbsp;</span><img src='/mobile/plugin/cowork/img/submit_wev8.png'>&nbsp;<%=SystemEnv.getHtmlLabelName(23066,user.getLanguage())%>："+replayitem.posttime
    									+"			<hr class='hr1'></hr>"
    									+"			<div style='margin-top:5px;'>"+replayitem.remark2html+"</div>"
    									+"		    <div style='"+(replayitem.relatedacc==""?"display:none":"")+"'>"
    									+"				<div style='margin-top:5px;float:left'><%=SystemEnv.getHtmlLabelName(22194,user.getLanguage())%>：</div>"
    									+"				<div style='margin-top:5px;float:left'>"+replayitem.relatedacc+"</div>"
    									+"				<div style='clear:left'></div>"
    									+"		    </div>"	
    									+"		</div>"
    						}if("1"==newapprovalAtatus){
									itemstr +="		<div style='margin-top:5px;'><span style='color: red;'><p>[<%=SystemEnv.getHtmlLabelName(83261,user.getLanguage())%>]</p></span></div>"
									+"<div class='hr2'></div>"
	    						}else{
    							itemstr +="		<div style='margin-top:5px;'>"+item.remark2html+"</div>"
    									+"		<div style='"+(item.relatedacc==""?"display:none":"")+"'>"
    									+"			<div style='margin-top:5px;float:left'><%=SystemEnv.getHtmlLabelName(22194,user.getLanguage())%>：</div>"
    									+"			<div style='margin-top:5px;float:left'>"+item.relatedacc+"</div>"
    									+"			<div style='clear:left'></div>"
    									+"		</div>"
    									+	getCommentList(item.commentList)	
    									+"</div>"
    									+"</div>"
    									+"<div class='hr2'></div>"
                        }
                            listItemString += itemstr;
    					});
    					
    					listItemString += "</div>";
    					
    					$("#listArea").append(listItemString);
    					if (ishavenext == "1") {
    						$("#listItemMore").html("<%=SystemEnv.getHtmlLabelName(17499,user.getLanguage())%>...").bind("click", function () {
    							getDataList(getUrlParam("more"), false);
    						});
    					} else {
    						$("#listItemMore").html("<%=SystemEnv.getHtmlLabelName(18861,user.getLanguage())%>"+count+" <%=SystemEnv.getHtmlLabelName(18256,user.getLanguage())%>");
    					}
    				}
    			}
    	    });
    	    //最后更新时间
    	    $("#lastupdatedate").html("<%=SystemEnv.getHtmlLabelName(25295,user.getLanguage())%>&nbsp;<%=SystemEnv.getHtmlLabelName(15537,user.getLanguage())%>：" + util.getCurrentDate4Format("hh:mm:ss") + "&nbsp;&nbsp;");
        }
    	
    	function getCommentList(commentList){
    		var itemstr="";
    		if(commentList.length>0){
    			itemstr +="<div class='replay'>"
                for(var i = 0, n = commentList.length; i < n; i++) {
                    var item = commentList[i];
                    var id = item.id;
    				var isAnonymous=item.isAnonymous;
    				var commentuserid=item.commentuserid;
    				var commentuserName=item.commentuserName;
                    var commentid = item.commentid;
                    var topdiscussid = item.topdiscussid;
    				if(i>0){
    					itemstr+="<hr class='hr1'></hr>";
    				}
    				itemstr +="<div>"
    						+"			<span style='color:#28648E;'>"+(isAnonymous==1?"<%=SystemEnv.getHtmlLabelName(18611,user.getLanguage())%>":item.discussName)+"&nbsp;</span>"
    						+			((commentid == topdiscussid || id == commentid)?"":"&nbsp;<%=SystemEnv.getHtmlLabelName(117,user.getLanguage())%><span style='color:#28648E;'>"+getReCommentUserName(commentList, commentid, commentuserName)+"&nbsp;</span>")
    						+"          <img src='/mobile/plugin/cowork/img/replay_wev8.png'>&nbsp;<%=SystemEnv.getHtmlLabelName(33287,user.getLanguage())%>："+item.createdate+"&nbsp;"+item.createtime
    						+"			<div style='margin-top:5px;'>"+item.remark+"</div>"
    						+"	</div>";
    			}
    			itemstr +="</div>"
    		}
    		return itemstr;
    	}
        
        function getReCommentUserName(commentList, commentid, defaltName) {
            var result = defaltName;
            for(var i = 0, n = commentList.length; i < n; i++) {
                var item = commentList[i];
                if(item.id == commentid && item.isAnonymous == 1) {
                    result = '<%=SystemEnv.getHtmlLabelName(18611,user.getLanguage())%>';
                    break;
                }
            }
            return result;
        }
    	
    	function showDetail(type){
    		if(type=="all"){
    			$("#showAll").show();
    			$("#showPart").hide();
    		}else{
    			$("#showAll").hide();
    			$("#showPart").show();
    		}
    		$("div[detail]").toggle();
    	}
    	
    	function doLeftButton() {
    		location = "/view.do?module=<%=module%>&scope=<%=scope%>";
    		return "0";
    	}
    	
    	function doBack() {
    		var result = doLeftButton();
    		if(result==null||result=="BACK"){
    			location = "/home.do";
    		}
    	}
    
    	//打开文档 
    	function opendoc1(docid){
    	   	location = "/mobile/plugin/2/view.jsp?detailid="+docid+"&module=<%=module%>&scope=<%=scope%>&fromcowork=true&coworkid=<%=coworkid%>";
    	}
    	
    	function opendoc(docid){
    	   	location = "/mobile/plugin/2/view.jsp?detailid="+docid+"&module=<%=module%>&scope=<%=scope%>&fromcowork=true&coworkid=<%=coworkid%>";
    	}
    	   
    	//下载文件
    	function downloads(fileid,obj,filename){
    	   	filename=filename?filename:"";
    	   	location = "/download.do?fileid="+fileid+"&filename="+filename+"&module=<%=module%>&scope=<%=scope%>";
    	}

    </script>
</head>
<body onload="setTimeout(function() { window.scrollTo(0, 1) }, 100);" />
<div id="view_page">
	<div id="view_header" style="<%if (clienttype.equals("Webclient")) {%>display:block;<%} else {%>display:none;<%}%>">
		<table style="width: 100%; height: 40px;">
			<tr>
				<td width="10%" align="left" valign="middle" style="padding-left:5px;">
					<a href="javascript:doBack();"  style="text-decoration: none;">
						<div style="width:56px;height:26px;background:url('/images/bg-top-btn_wev8.png') no-repeat;text-align:center;line-height:26px;color:#000;">
						<%=SystemEnv.getHtmlLabelName(1290,user.getLanguage())%>
						</div>
					</a>
				</td>
				<td align="center" valign="middle">
					<div id="view_title"><%=name%></div>
				</td>
				<td width="10%" align="right" valign="middle" style="padding-right:5px;">
				</td>
			</tr>
		</table>
	</div>
	<div  class="content" style="background:#fff;">
		<!-- 存放必须数据区域 START -->
		<input type="hidden" name="sessionkey" value="<%=fu.getParameter("mobileSession") %>">
		<input type="hidden" name="module" value="<%=fu.getParameter("module") %>">
		<input type="hidden" name="scope" value="<%=fu.getParameter("scope") %>">
		<!-- 当前页索引 -->
		<input type="hidden" name="pageindex" value="">
		<!-- 每页记录条数 -->
		<input type="hidden" name="pagesize" value="5">
		<!-- 总记录条数 -->
		<input type="hidden" name="count" value="">
		<!-- 是否有上一页 -->
		<input type="hidden" name="ishavepre" value="">
		<!-- 是否有下一页 -->
		<input type="hidden" name="ishavenext" value="">
		<!-- 总页数 -->
		<input type="hidden" name="pagecount" value="">
		
		<!-- 当前查看的协作id -->
		<input type="hidden" name="coworkid" value="<%=coworkid%>">
		
		<!-- 存放必须数据区域 END -->
		<div style="padding-bottom:10px;padding-top:8px;padding-left:5px;border:1px solid #e5e5e5;background-color:#EFF2F6;margin:5px">
			<%
			 if(remark.indexOf("<form")!=-1)
				 remark=remark.replace("<form", "<span").replace("</form>", "</span>").replace("id=\"frmmain\"", "id=\"\"").replace("name=\"frmmain\"", "name=\"\"");
             if(remark.replaceAll("<[^>].*?>","").replaceAll("&nbsp;","").length()>150){
            	 String remarkhtml=remark.replaceAll("<[^>].*?>","").replaceAll("&nbsp;","");
           %>
              <div id="showPart"><%=remarkhtml.substring(0,150)%>...
              	<div class="headBtn" onclick="showDetail('all');return false"><%=SystemEnv.getHtmlLabelName(15315,user.getLanguage())%><img style="margin-left:15px;" src="/mobile/plugin/cowork/img/open_wev8.png"></div>
              </div><!-- 展开 -->
              <div id="showAll" style="display: none"><%=remark%>
              	<br>
           		<%=dao.showRelatedaccList(vo.getRelatedaccList(),user,coworkid)%>
              	<div class="headBtn" onclick="showDetail('part');return false"><%=SystemEnv.getHtmlLabelName(20721,user.getLanguage())%><img style="margin-left:15px;" src="/mobile/plugin/cowork/img/back_wev8.png"></div>
              </div><!-- 收缩 -->
           <%}else{
        	   String remarkhtml = remark;
		   %>
		      <div id="showPart">
		      	<%=remarkhtml%>
		      	<div class="headBtn" onclick="showDetail('all');return false"><%=SystemEnv.getHtmlLabelName(15315,user.getLanguage())%><img style="margin-left:15px;" src="/mobile/plugin/cowork/img/open_wev8.png"></div>
		      </div><!-- 展开 -->
		      <div id="showAll" style="display: none">
			    <%=remark%>
			    <br>
           		<%=dao.showRelatedaccList(vo.getRelatedaccList(),user,coworkid)%>
			    <div class="headBtn" onclick="showDetail('part');return false"><%=SystemEnv.getHtmlLabelName(20721,user.getLanguage())%><img style="margin-left:15px;" src="/mobile/plugin/cowork/img/back_wev8.png"></div>
			  </div><!-- 收缩 -->
           <%} %>
		</div>
		
		<div style="margin-top:2px;margin-bottom:2px;height:5px;width:100%;background-image: url(/mobile/plugin/cowork/img/hr2_wev8.png)"></div>
		
		<!-- 协作信息 -->
		<div style="font-size:13px;padding:8px;">
			<span style="font-weight:bold;"><%=name%></span>
			&nbsp;|&nbsp;
			<%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%>：<span style="color:#28648E;"><%=Util.toScreen(ResourceComInfo.getResourcename(creater),user.getLanguage())%></span>
			&nbsp;
			<%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%>：<span style="color:#28648E;"><%=Util.toScreen(ResourceComInfo.getResourcename(principal),user.getLanguage())%></span>
		</div>
		
		<div class="pdecblock" style="font-size:13px;display:none" detail="true">
			<span style="margin-left:5px"><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>：<%=CoTypeComInfo.getCoTypename(typeid)%></span>
			<span style="margin-left:50px;"><%=SystemEnv.getHtmlLabelName(17697,user.getLanguage())%>：<%=begindate%> <%=beingtime%><%=SystemEnv.getHtmlLabelName(15322,user.getLanguage())%>&nbsp;<%=enddate%> <%=endtime%></span>
		</div>
		
		<div class="listitem" style="margin-top:5px;">
			<textarea class="inputArea" name="content" id="contentInput"></textarea>
			<div style="clear:both;"></div> 
			<div style='height:30px;padding-top:10px;'>
				<div class="opSubmit" onclick='doSave(this)'><%=approvalAtatus.equals("1")?SystemEnv.getHtmlLabelName(383043,user.getLanguage()):SystemEnv.getHtmlLabelName(615,user.getLanguage())%></div>
				<div style="<%=("1".equals(isCoworkTypeAnonymous) && "1".equals(isAnonymous))?"":"display:none;"%>">
					<input type="checkbox" name="isAnonymous" id="isAnonymous" value="1"><%=SystemEnv.getHtmlLabelName(18611,user.getLanguage())%>
				</div>
			</div>
		</div>
		
		<div class="hr2"></div>
		
		<div class="listArea" id="listArea"></div>
		<div class='listitemmore' id='listItemMore'></div>
		<div class='hr2'></div>
		
		<div class="lastupdatedate" id="lastupdatedate">
			<%=SystemEnv.getHtmlLabelName(25295,user.getLanguage())%>&nbsp;<%=SystemEnv.getHtmlLabelName(15537,user.getLanguage())%>&nbsp;&nbsp;
		</div>
	</div>
	</div>
</body>
</html>
