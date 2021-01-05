<%@page import="com.weaver.formmodel.apps.ktree.KtreePermissionService"%>
<%@page import="weaver.hrm.company.DepartmentComInfo"%>
<%@page import="weaver.hrm.resource.ResourceComInfo"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="weaver.general.Util"%>

<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="weaver.systeminfo.*" %>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="com.weaver.formmodel.util.StringHelper"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.general.Util"%>
<%@page import="com.weaver.formmodel.util.NumberHelper"%>
<%@page import="com.weaver.formmodel.util.DateHelper"%>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%!
	public void updateKtreeVisitlog(int versionid,int functionid,int tabid,int documentid,User user){
		RecordSet rs = new RecordSet();
		long nowDate = new Date().getTime();
		String sql = "select * from uf_ktree_visitlog where versionid="+versionid
		+" and functionid="+functionid+" and tabid="+tabid+" and userid="+user.getUID();
		rs.executeSql(sql);
		if(rs.next()){
			int id = rs.getInt("id");
			sql="update uf_ktree_visitlog set visitdatetime= "+nowDate
			+" where id="+id;
			
			rs.execute(sql);
		}else{
			sql="insert into uf_ktree_visitlog(userid,versionid,functionid,tabid,documentid,visitdatetime)values("
			+user.getUID()+","+versionid+","+functionid+","+tabid+","+documentid+","+nowDate+")";
			rs.execute(sql);
		}
		
		sql="select pid from uf_ktree_tabinfo where id="+tabid;
		rs.executeSql(sql);
		//int tabPid = 0;上级
		if(rs.next()){
			tabid = Util.getIntValue(rs.getInt(1)+"",0);
		}
		
		sql = "select * from uf_ktree_visitlog where versionid="+versionid
		+" and functionid="+functionid+" and tabid="+tabid+" and userid="+user.getUID();
		rs.executeSql(sql);
		if(rs.next()){
			int id = rs.getInt("id");
			sql="update uf_ktree_visitlog set visitdatetime= "+nowDate
			+" where versionid="+versionid
			+" and functionid="+functionid+" and tabid="+tabid+" and userid="+user.getUID();
			rs.execute(sql);
		}else{
			sql="insert into uf_ktree_visitlog(userid,versionid,functionid,tabid,documentid,visitdatetime)values("
			+user.getUID()+","+versionid+","+functionid+","+tabid+","+documentid+","+nowDate+")";
			rs.execute(sql);
		}
	}
 %>
<%
User user = (User)request.getSession(true).getAttribute("weaver_user@bean") ;
KtreePermissionService ktreePermissionService = new KtreePermissionService();
int userType = ktreePermissionService.getUserType(user);
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
int historyDocumentid = Util.getIntValue(request.getParameter("historyDocumentid"),-1);
int versionid = Util.getIntValue(request.getParameter("versionid"));
int functionid = Util.getIntValue(request.getParameter("functionid"));
int tabid = Util.getIntValue(request.getParameter("tabid"));
RecordSet.executeSql("select * from uf_ktree_documentInformality where id="+historyDocumentid);
if(RecordSet.next()){
	versionid = RecordSet.getInt("versionid");
	functionid = RecordSet.getInt("functionid");
	tabid = RecordSet.getInt("tabid");
}
String message = Util.null2String(request.getParameter("message"));
message = URLDecoder.decode(message,"UTF-8");
ResourceComInfo rc = new ResourceComInfo();
DepartmentComInfo dc = new DepartmentComInfo();
%>

<!DOCTYPE HTML>
<html>
  <head>
    <base href="<%=basePath%>">
    <title>查看文档</title>
	<link rel="stylesheet" href="/formmode/apps/ktree/css/index_wev8.css" type="text/css" />
	<style type="text/css">
          #content {padding-left:10px;padding-right:10px;z-index:998;}
          #content {z-index:998;}
		  #remarkdiv{vertical-align: middle;overflow: hidden;height: 0px;margin-top: 5px;}
		  .ke-container{width: 98%;}
		  .replaydiv{display: none;}
     </style>
	 <script type="text/javascript" src="/js/jquery/jquery-1.4.2.min_wev8.js"></script>
	 <script type="text/javascript">var languageid=<%=user.getLanguage()%>;</script>
	 <script language=javascript src="/js/weaver_wev8.js"></script>
	 <script type="text/javascript" src="/kindeditor/kindeditor_wev8.js"></script>
	 <script type="text/javascript" src="/kindeditor/kindeditor-Lang_wev8.js"></script>
	 <SCRIPT language="javascript" defer="defer" src="/formmode/apps/ktree/js/discuss_wev8.js"></script>
	 <script type="text/javascript" src="/formmode/js/jquery/resize/jquery.ba-resize.min_wev8.js"></script>
	 <script type="text/javascript" src="/formmode/js/WdatePicker/WdatePicker_wev8.js"></script>
	<script type="text/javascript">
		function createDoc(){
			location.href="/formmode/apps/ktree/createdocument.jsp?versionid=<%=versionid%>&functionid=<%=functionid%>&tabid=<%=tabid%>";
		}
		function modifyDoc(docid){
			location.href="/formmode/apps/ktree/modifydocument.jsp?documentid="+docid;
		}
		function checkNoOK(docid){
			$.ajax({ 
				url: "/formmode/apps/ktree/operationKtreeDcoument.jsp?action=admin_checkNoOk&documentid="+docid, 
				context: document.body, 
				async:false,
				cache:false,
				success: function(data){
					var message = $.trim(data);
					if(message!=''){
						$("#A_Rollback_"+docid).hide();
						$("#A_CheckOk_"+docid).hide();
						$("#A_CheckNoOk_"+docid).hide();
						alert(message);
					}
      			}
			});
		}
		
		//历史版本选择查询状态
		function selectDocStatus(obj){
			var str="";
			$("[name=c_doc_status]").each(function(i,val){
				if(val.checked){
					str+=","+$(val).val();
				}
			})
			$("#searchDocStatus").val(str);
		}
		
		function goHistory(objid){
			
			if(document.getElementById(objid))
				document.getElementById(objid).scrollIntoView()
		}
		
		function searchHistoryDoc(){
			var v_searchStartDate = $("#searchStartDate").val();
			var v_searchEndDate =  $("#searchEndDate").val();
			var v_searchDocStatus = $("#searchDocStatus").val();
			var parameter = "&searchStartDate="+v_searchStartDate+"&searchEndDate="+v_searchEndDate+"&searchDocStatus="+v_searchDocStatus;
			$("#historyDocSearchParameter").val(parameter);
			var url = "/formmode/apps/ktree/documentInformality.jsp";
	    		url+="?newDate="+(new Date()).getTime();
	    		url+="&versionid=<%=versionid%>&functionid=<%=functionid%>&tabid=<%=tabid%>";
	    		url+=parameter;
			$('#content2').load(url);
		}
		
		function loadfunction(){
			if("<%=message%>"!=''){
				alert("<%=message%>");
			}
		}
		jQuery(document).ready(function(){
  	      displayLoading(1,"page");
		  jQuery.post("/formmode/apps/ktree/KtreeDiscussRecord.jsp?versionid=<%=versionid%>&functionid=<%=functionid%>&tabid=<%=tabid%>",{},function(data){
		      var tempdiv=jQuery("<div>"+data+"</div>");
		      jQuery("#discusslist").append(tempdiv);
			  addBackGround();//为留言添加背景颜色
			  displayLoading(0);
		  }); 
		  $("#docAttr").resize(function(){
		  	parent.resetFrameWithChildPageChange();
		  });
		});
     	function tabClick(){
          if($(this).hasClass('activeTab')) 
                  return;
          $('.nomal').removeClass('activeTab');
          $(this).addClass('activeTab');
          var tabId = $(this).attr('tabId');
          if(tabId=='content2'){
          	content2DateLoad(tabId);
          }
          $('#content > div').hide();
          $('#' + tabId).show();
     	}
	    $(document).ready(function(){
	        $('.nomal').click(tabClick);
	    });
	    
	    function content2DateLoad(tabId){
	    	if($.trim($('#' + tabId).text())==''){
	    		$('#' + tabId).load('/formmode/apps/ktree/documentInformality.jsp?newDate='
	    		+(new Date()).getTime()
	    		+'&versionid=<%=versionid%>&functionid=<%=functionid%>&tabid=<%=tabid%>');
	    	}
	    }
	    //为留言添加背景颜色
		function addBackGround(){
		   jQuery(".discuss_div").each(function(){
			   jQuery(this).bind("mouseover",function(){
			        jQuery(this).css("background-color","#f5fafa");
			   }).bind("mouseout",function(){ //如果回复框显示则不还原颜色
			        if(jQuery(this).find(".replaydiv").is(":hidden"))
			           jQuery(this).css("background-color","#FFFFFF");
			   });
		  });
		}
	    //提交回复时，提交等待
		function displayLoading(state,flag){
		  	if(state==1){
		        var bgHeight=document.body.scrollHeight; 
		        var bgWidth=window.parent.document.body.offsetWidth;
		        jQuery("#bg").css("height",bgHeight,"width",bgWidth);
		        jQuery("#bg").show();
		        
		        if(flag=="save")
		           jQuery("#loadingMsg").html("<%=SystemEnv.getHtmlLabelName(23278,user.getLanguage())%>");
		        else if(flag=="page"||flag=="edit")
		           jQuery("#loadingMsg").html("<%=SystemEnv.getHtmlLabelName(20010,user.getLanguage())%>");
		              
			    var loadingHeight=jQuery("#loading").height();
			    var loadingWidth=jQuery("#loading").width();
			    jQuery("#loading").css({"top":document.body.scrollTop + document.body.clientHeight/2 - loadingHeight/2,"left":document.body.scrollLeft + document.body.clientWidth/2 - loadingWidth/2});
			    jQuery("#loading").show();
		    }else{
		        jQuery("#loading").hide();
		        jQuery("#bg").hide(); 
		    }
		}
	   /*显示回复框*/
	   var preReplayid="";
	   function showReplay(discussid,floorNum){
		   if(preReplayid=="")
		      preReplayid=discussid;
		   if(preReplayid!=discussid){
		      if(KE.text("replay_content_"+preReplayid)!=""){
			      if(confirm("<%=SystemEnv.getHtmlLabelName(25406,user.getLanguage())%>")){
				        cancelReplay(preReplayid);
				        jQuery("#discuss_table_"+preReplayid).css("background-color","#FFFFFF");
				        preReplayid=discussid;
			      }else
			            return ;
		      }else{
			        cancelReplay(preReplayid);
			        jQuery("#discuss_table_"+preReplayid).css("background-color","#FFFFFF");
			        preReplayid=discussid;
			  }    
		   }      
		   jQuery("#replay_"+discussid).show();
		   highEditor("replay_content_"+discussid);
		   KE.focus("replay_content_"+discussid);
		   jQuery("#replayid").val(discussid);  //被回复的留言
		   jQuery("#floorNum").val(floorNum);   //被回复留言的楼层 
		   /*if(jQuery("#uploadDiv_"+discussid).length>0){
		      bindUploaderDiv(jQuery("#uploadDiv_"+discussid),"relatedacc_"+discussid);
		   }*/
	  }
	  /*隐藏回复框*/
	  function cancelReplay(discussid){
	    KE.text("replay_content_"+discussid,"");
	    KE.remove("replay_content_"+discussid);
	    jQuery("#replay_"+discussid).hide();
	    jQuery("#replayid").val(0);
	    jQuery("#floorNum").val(0);
	    jQuery("#external_"+discussid).hide();
	    preReplayid="";
	  }  
	  /*文本输入自动调整高度*/
	  function autoHeight(obj,height){
	  	if(obj.scrollHeight>height)
	    obj.style.posHeight=obj.scrollHeight
	  }
	 /*附加功能*/
	 function external(externalid,obj){
	   if(jQuery("#"+externalid).is(":visible")){
	      jQuery("#"+externalid).hide();
	      jQuery(obj).css("background-image","url('/cowork/images/blue/down_wev8.png')");
	   }else{
	      jQuery("#"+externalid).show();
	      jQuery(obj).css("background-image","url('/cowork/images/blue/up_wev8.png')");
	   }
	 }
	function clearRemark(){
		jQuery("#replayid").val(0);
 		KE.text("remarkContent","");//还原编辑框
 		KE.create("remarkContent");
	}
	</script>
  </head>
  <body onload="loadfunction();">
    <%
    	String sql = "select * from uf_ktree_document where versionid="+versionid+" and functionid="+functionid+" and tabid="+tabid;
    	if(historyDocumentid!=-1){
    		sql = "select * from uf_ktree_documentInformality where id="+historyDocumentid;
    	}else{
    		//修改访问记录
			updateKtreeVisitlog(versionid, functionid, tabid,0, user);
    	}
    	RecordSet.executeSql(sql);
    	if(RecordSet.next()){
    		int id = RecordSet.getInt("id");//id
    		int versionId = RecordSet.getInt("versionId");//系统版本id
			int functionId = RecordSet.getInt("functionId");//功能id
			int tabId = RecordSet.getInt("tabId");//标签id
			String subject = RecordSet.getString("subject");//标题
			String content = RecordSet.getString("content");//内容
			String doc_version = RecordSet.getString("doc_version");//文档版本号
			String doc_status = RecordSet.getString("doc_status");//状态默认为1正式
			String creator = RecordSet.getString("creator");//创建人
			String createdate = RecordSet.getString("createdate");//创建日期
			String createtime = RecordSet.getString("createtime");//创建日期
			String updater = RecordSet.getString("updater");//最后修改人
			String updatedate = RecordSet.getString("updatedate");//最后修改日期
			String updatetime = RecordSet.getString("updatetime");//最后修改时间
			String approver = RecordSet.getString("approver");//审批人
			String approvedate = RecordSet.getString("approvedate");//审批日期
			String approvetime = RecordSet.getString("approvetime");//审批时间
			String digest = RecordSet.getString("digest");//摘要
			%>
			<div class="divDocTitleIcon"><img src="/formmode/apps/ktree/images/docIcon_wev8.png"/></div>
			<div class="divDocTitle"><%=subject %></div>
			<div class="divDocDesc">
				最后由<a><%
					String updateDeptName = dc.getDepartmentname(rc.getDepartmentID(updater));
					if(!"".equals(updateDeptName)){
						updateDeptName = "("+updateDeptName+")";
					}
					String updaterName = rc.getResourcename(updater);
				 %><%=(updaterName+updateDeptName) %></a>编辑于<%=updatedate+updatetime %>
			</div>
			<div class="divDocToolbar">	
				<%if(historyDocumentid==-1){ %>
					<%if(userType>1){ %>
					<a href="javascript:modifyDoc('<%=id%>')">编辑</a>
					<%} %>
				<a>讨论</a>(<%="6" %>)
				<a>附件</a>(<%="2" %>)
				<a href="javascript:goHistory('h')">版本历史</a>
				<% }%>
			</div>
			<div class="divDocContent"><%=content %></div>
			<div class="divDocBottom">
				<%
					String creatorDeptName = dc.getDepartmentname(rc.getDepartmentID(creator));
					if(!"".equals(creatorDeptName)){
						creatorDeptName = "("+creatorDeptName+")";
					}
					String creatorName = rc.getResourcename(creator);
				%>
				由<a><%=creatorName+creatorDeptName %></a>创建于<%=createdate+createtime %>
			</div>

			<%
    	}else{%>
    		<h1>还没有人新建文档！</h1>
    		<%if(userType>1){ %>
    			<button onclick="createDoc();">新建文档</button>
    		<% }%>
    	<%}%>
     <div id="loading" class="loading" align='center'>
		<div id="loadingdiv" style="right:260px;">
			<div id="loadingMsg">
				<div>正在努力加载...</div>
			</div>
		</div>
	 </div>
	<div id="docAttr" >
  	  <form name="frmmain" id="frmmain" method="post" action="" enctype="multipart/form-data">
  	   <input type=hidden name="discussid" id="discussid">
 	   <input type=hidden name="replayid" id="replayid" value="0">
 	   <input type=hidden name="method" id="method" value="insertTreeDiscuss">
 	   <input type=hidden name="floorNum" id="floorNum" value="0">
 	   <%
        	sql="select COUNT(*) from uf_ktree_discussion where versionid="+versionid+" and functionid="+functionid+" and tabid="+tabid;
         	RecordSet.executeSql(sql);
        	int discussionCount = 0;
        	if(RecordSet.next()){
        		discussionCount =  RecordSet.getInt(1);
        	}
		%>
	   <input type=hidden name="discussionCount" id="discussionCount" value="<%=discussionCount%>">
	
     <div class="tab" style="display: <%=historyDocumentid!=-1?"none":"" %>" >
          <div class="hd">
	           <table width="100%" cellpadding="0" cellspacing="0">
		           	<tr>
			           	<td width="1px" class="first"></td>
			           	<td class="nomal activeTab" id="discount" tabId="content1">讨论<%if(discussionCount>0){%>(<%=discussionCount%>)<%}%></td>
			           	<%
			           		sql="select COUNT(*) from uf_ktree_documentInformality where versionid="+versionid+" and functionid="+functionid+" and tabid="+tabid;
			           		RecordSet.executeSql(sql);
			           		int historyVersionCount = 0;
			           		if(RecordSet.next()){
			           			historyVersionCount =  RecordSet.getInt(1);
			           		}
			           	 %>
			           	<td tabId="content2" class="nomal"><span id="h">历史版本(<%=historyVersionCount %>)<span></td>
			           	<td tabId="content3" class="nomal">相关信息</td>
			           	<td width="100%" class="last"></td>
		           	</tr>
	           </table>
          </div>
          <div id="content" class="divDiscussContent" style="display: <%=historyDocumentid!=-1?"none":"" %>;">
               <div id="content1" style="display:block;">
               		<div id="remarkdiv">
	                    <div id="remarkHtml" style="">
								<div style="margin-top:5px;" align="left">
									<span style="color: #929393;">创建人：<%=Util.toScreen(ResourceComInfo.getResourcename(String.valueOf(user.getUID())),user.getLanguage())%></span>
									<span style="color: #929393;margin-left:5px;">时间：<%=DateHelper.getCurDateTime()%></span>
								</div>
						</div>
					</div>
					<div id="submitdiv" style="clear:both;margin:5px 0 15px 0;padding:0 10px 0 0;">
						<div style="width:65px;float:left;padding:0 0 10px 15px;">
							<img src="/formmode/apps/ktree/images/user_wev8.png" class="discussAvtor"/>
						</div>
						<div style="margin-left:85px;">
							<textarea id="remarkContent" class="remarkContent" style="resize: none;"></textarea>
							<div style="padding:3px 0;">
								<button type="button" style="width:80px;height:22px;background-color:#da532c;border:0;color:#fff;" onclick="doSave('remarkContent','addKtreeDiscuss')"  id="btnSubmit">提交</button>
								<button type="button" style="width:80px;height:22px;background-color:#eee;border:0;">HTML</button>
							</div>
						</div>
					</div>

					<!-- 
					<div id="operationdiv" style="overflow: hidden;height: 0px;">
						<div style="float:left;">
							<button type="button" onclick="doSave('remarkContent','addKtreeDiscuss')"  id="btnSubmit" class="submitBtn"/>提交</button>
							
						</div>
						<div style="display: none;">
							<div onclick="showExtend(this)" style="float:right;" id="extendbtn" style="background:url('/cowork/images/blue/down_wev8.png') no-repeat right center;padding-right:14px;cursor: pointer;height:30px;line-height:30px;vertical-align: middle;">附加信息</div>
						</div>	
					</div>
					<div id="external" style="height: 0px;display: none;">
	   					<table id="table1">
	   						<tr>
	   							<td><%=SystemEnv.getHtmlLabelName(22194,user.getLanguage())%></td>
	   							<td><div id="uploadDiv" mainId="" subId="" secId="" maxsize=""></div></td>
	   						</tr>
	   					</table>
					</div>
					 -->
					<div id="discusslist" style="width:100%;"></div>

               </div>
               <div id="content2" class="divDiscussContent" style="display:none;">
               		
               </div>
               <div id="content3" class="divDiscussContent" style="display:none;">
               </div>
          </div>
      </div>
      <!-- 历史版本查询参数保存的input 格式 : &参数=值&  以&开头-->
      <input id="historyDocSearchParameter" type="hidden" value="">
      </form>
     </div>
  </body>
<script type="text/javascript">
 function doSave(remarkid,method){
	 var remark=jQuery("#"+remarkid);
     remarkValue=KE.html(remarkid);
	 if(remarkValue==""){
        window.top.alert("<%=SystemEnv.getHtmlLabelName(23073,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(18546,user.getLanguage())%>");
        if(remark.is(":visible"))
           remark.focus();
        else
           KE.util.focus(remarkid);   
        return;   
     }else{
       jQuery("#btnSubmit").attr("disabled","disabled"); //提交时禁用提交按钮 避免重复提交
       jQuery(".replayBtn").attr("disabled","disabled"); //提交时禁用回复按钮 避免重复提交 
       if(remark.is(":visible")) //如果可见则为文本模式  否则为html模式
          remarkValue = remarkValue.replace(/\n/g,"<br/>");     //替换换行\n
       else{
         remarkValue = remarkValue.replace(/\n/g,"");     //替换换行\n
         remarkValue = remarkValue.replace(/\r/g,"");     //替换单行\r
       }
       remarkValue = remarkValue.replace(/\\/g,"\\\\"); //替换斜杠
       remarkValue = remarkValue.replace(/'/g,"\\'");   //转义单引号
     }
	 
     var replayid=jQuery("#replayid").val();//被回复的留言id
     var floorNum=jQuery("#floorNum").val();//被回复的楼层
     var discussid=jQuery("#discussid").val();
     var param="{method:'"+method+"',content:'"+remarkValue+"',replayid:'"+replayid+"',floorNum:'"+floorNum+"',versionid:'<%=versionid%>',functionid:'<%=functionid%>',tabid:'<%=tabid%>'}";
     jQuery.post("/formmode/apps/ktree/KtreeDiscussOperation.jsp?discussid="+discussid, eval('('+param+')'),function(data){
	      clearRemark();      
	      displayLoading(0);  //提交等待显示
	      toPage(1); //加载第一页内容
	      if("saveKtreeDiscuss"!=method){
	    	 var discussionCount = parseInt(jQuery("#discussionCount").val())+1;
	      	 jQuery("#discussionCount").val(discussionCount);
	      	 $("#discount").html("讨论("+discussionCount+")");
	      }
	      jQuery("#btnSubmit").attr("disabled","");//恢复提交按钮
	      jQuery(".replayBtn").attr("disabled",""); //恢复回复按钮
     });
}

//分页
function toPage(pageNum){
  var url="/formmode/apps/ktree/KtreeDiscussRecord.jsp?versionid=<%=versionid%>&functionid=<%=functionid%>&tabid=<%=tabid%>&currentpage="+pageNum;
  displayLoading(1,"page");
  jQuery.post(url,{},function(data){
     var tempdiv=jQuery("<div>"+data+"</div>");
     jQuery("#discusslist").html("");
     jQuery("#discusslist").append(tempdiv);
     addBackGround();
     displayLoading(0);
     jQuery("#top").focus();
	 preReplayid="";
  });
}

//分页
function toPageDoc(pageNum){
	var v_historyDocSearchParameter = $("#historyDocSearchParameter").val();
  var url="/formmode/apps/ktree/documentInformality.jsp?versionid=<%=versionid%>&functionid=<%=functionid%>&tabid=<%=tabid%>&currentpage="+pageNum+v_historyDocSearchParameter;
  displayLoading(1,"page");
  jQuery.post(url,{},function(data){
     var tempdiv=jQuery("<div>"+data+"</div>");
     jQuery("#content2").html("");
     jQuery("#content2").append(tempdiv);
     displayLoading(0);
     jQuery("#top").focus();
  });
}

function toGoPage(totalpage,topage){
	var topagenum=jQuery("#"+topage);
	var topage =topagenum.val();
	if(topage <0 || topage!=parseInt(topage) ) {
       alert("<%=SystemEnv.getHtmlLabelName(25167,user.getLanguage())%>");  //请输入整数
       topagenum.val(""); //置空
       topagenum.focus();
       return;
	}
	if(topage>totalpage) topage=totalpage; //大于最大页数
	if(topage==0) topage=1;                //小于最小页数 
	toPage(topage);
}
 //编辑讨论
 function editKtreeDiscuss(discussid,replayid){
 
   if(jQuery("#replay_"+discussid).is(":visible")){
      alert("<%=SystemEnv.getHtmlLabelName(25404,user.getLanguage())%>");
      return ;
    }  
   displayLoading(1,"edit");
   jQuery.post("/formmode/apps/ktree/KtreeDiscussOperation.jsp?method=editKtreeDiscuss",{discussid:discussid},function(data){
      jQuery("#discuss_table_"+discussid).hide();
	  jQuery("#discuss_div_"+discussid).append(data);
	  jQuery("#discussid").attr("value",discussid);
	  highEditor('discussContent');
	  displayLoading(0);
   });
 }
 //取消编辑 
 function cancelEdit(discussid){
    jQuery(document.body).focus(); //避免删除div时 页面焦点丢失
    jQuery("#editdiv").remove();
    jQuery("#discussid").attr("value","");
    jQuery("#discuss_table_"+discussid).show();
 }
 //删除讨论
 function deleteKtreeDiscuss(discussid){
   if(window.confirm("<%=SystemEnv.getHtmlLabelName(25405,user.getLanguage())%>")){ //确认要删除该讨论记录
      jQuery.post("/formmode/apps/ktree/KtreeDiscussOperation.jsp?method=delKtreeDiscuss&versionid=<%=versionid%>&functionid=<%=functionid%>&tabid=<%=tabid%>",{discussid:discussid},function(data){
          toPage(1);
          $("#discount").html("讨论("+data+")");
      });
	 }      
 }
</script>
</html>
