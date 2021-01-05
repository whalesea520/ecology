<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ page import="weaver.general.*"%>
<%@ page import="weaver.docs.docs.DocImageManager"%>
<%
	String userid = user.getUID()+"";
	String hrmid = Util.null2String(request.getParameter("hrmid"));
	if(hrmid.equals("")) hrmid = userid;
	/**
	String sql = "select top 10 t1.id,t1.content,t1.hrmid,t1.docids,t1.wfids,t1.crmids,t1.projectids,t1.meetingids,
		t1.fileids,t1.createdate,t1.createtime,t2.id as taskid,t2.name "
		+",(select top 1 tlog.operatedate+' '+tlog.operatetime from TM_TaskLog tlog where tlog.taskid=t2.id 
		and tlog.type=0 and tlog.operator="+userid+" order by tlog.operatedate desc,tlog.operatetime desc) 
		as lastviewdate"
		+" from TM_TaskFeedback t1,TM_TaskInfo t2 "
		+" where t1.taskid=t2.id and (t2.deleted=0 or t2.deleted is null)"
		+" and (t2.creater="+userid+" or t2.principalid="+userid+" 
		or exists (select 1 from TM_TaskPartner tp where tp.taskid=t2.id and tp.partnerid="+userid+"))"
		+" and t1.hrmid<>"+userid
		+" order by t1.createdate desc,t1.createtime desc";
		//System.out.println(sql);
	*/
%>
<style type="text/css">
	.datatable{width: 100%;}	
	.datatable td{padding-top:1px;padding-bottom:1px;text-align: left;}
	.datatable td.title{color: #999999;vertical-align: top;padding-top: 7px;padding-bottom: 7px;
	padding-left: 20px;background: #F6F6F6;border-top: 1px #F6F6F6 solid;border-bottom: 1px #F6F6F6 solid;}
	.datatable td.data{vertical-align: middle;border-top: 1px #fff solid;border-bottom: 1px #E8E8E8 dashed;
	padding-bottom: 10px;}
	#rightinfo a,#rightinfo a:active,#rightinfo a:visited{text-decoration: none;color: #000000;}
	#rightinfo a:hover{text-decoration: underline;color: #0080FF;}
	.feedbackshow{width: 90%;margin-left: 20px;margin-top: 5px;overflow: hidden;background:#fff;}
	.fbtime{
		float:none;
	}
	.feedbackinfo{width: auto;line-height: 24px;color: #808080;}
	.feedbackinfo a,.feedbackinfo a:active,.feedbackinfo a:visited{
	text-decoration: none !important;color: #808080 !important;}
	.feedbackinfo a:hover{text-decoration: underline !important;color: #0080FF !important;}
	.feedbackrelate{width: auto;line-height: 24px;background: #F9F9F9;overflow:hidden;);
	}
	.feedbackrelate .relatetitle{color: #808080}
	.feedbackrelate a,.feedbackrelate a:active,.feedbackrelate a:visited{
	text-decoration: none !important;color: #1D76A4 !important;}
	.feedbackrelate a:hover{text-decoration: underline !important;color: #FF0000 !important;}
	.feedbackshow p{padding: 0px;margin: 0px;line-height: 20px !important;}
	
	.dtab{line-height: 25px;float:left;margin-left: 5px;margin-top: 4px;font-weight: bold;
	width: 65px;text-align: center;font-family: 微软雅黑;color: #9D9D9D;cursor: pointer;}
	.dtab_hover{background: #E0E0E0;}
	.dtab_click{color:#000;}
	.fbreply{
		margin-right:20px;
		margin-bottom:20px;
	}
</STYLE>
<div id="rightinfo" style="width: 100%;height: 100%;position: relative;overflow: hidden;background: #f7f7f7 !important;">
	<div style="width: 100%;height: 40px;position: relative;">
		<div style="position: absolute;top: 3px;left:0px;height: 23px;width: 100%;">
			<div class="dtab dtab_click" _infoid="maininfo" style="margin-left:10px;">最新反馈</div>
			<div class="dtab" _infoid="mainiframe"></div>
			<div id="blogmore" style="float: right;margin-top: 8px;margin-right: 8px;cursor: pointer;
				font-style: italic;font-family: Arial;color: #959595;display:none;" title="我的微博" 
				onclick="openFullWindowHaveBar('/blog/blogView.jsp')">more</div>
		</div>
	</div>
	<%
	int _pagesize = 10;
	int _total = 0;//总数
	String sql = "";
	int ifMySelf = 0;//0是查看自己 1不是
	if(userid.equals(hrmid)){ 
		sql = "select count(distinct t1.id) "
			+" from TM_TaskFeedback t1,TM_TaskInfo t2 "
			+" where t1.taskid=t2.id and (t2.deleted=0 or t2.deleted is null)"
			+" and (t2.creater="+userid+" or t2.principalid="+userid
			+" or exists (select 1 from TM_TaskPartner tp where tp.taskid=t2.id and tp.partnerid="+userid+")"
			+" or exists (select 1 from TM_TaskSharer ts where ts.taskid=t2.id and ts.sharerid="+userid+"))"
			+" and t1.hrmid<>"+userid;
			//System.out.println(sql);
	}else{
		String currentDate = TimeUtil.getCurrentDateString();
		String sevenDay = TimeUtil.dateAdd(currentDate,-6);
		sql = "select count(distinct t1.id) "
			+" from TM_TaskFeedback t1,TM_TaskInfo t2 "
			+" where t1.taskid=t2.id and (t2.deleted=0 or t2.deleted is null)"
			+" and t1.hrmid="+hrmid
			+" and t1.createdate>='"+sevenDay+"' and t1.createdate <= '"+currentDate+"'";
			ifMySelf = 1;
	}
	rs.executeSql(sql);
	if(rs.next()){
		_total = rs.getInt(1);
	}
	//System.out.println("_total:"+_total);
	%>
	<div id="maininfo" style="width:100%;height: auto;position:absolute;top:40px;left:0px;bottom:0px;
		line-height: 40px;font-size: 14px;" class="scroll1 datainfo" align="center">
		<table id="feedbacktable" class="datatable" style="width: 100%;margin: 0px auto;text-align: left;" 
		cellpadding="0" cellspacing="0" border="0">
				<%if(_total==0){ %>
				<tr>
					<td class="">
						<div class="feedbackshow" style="border:1px solid #e4e4e4;">
							<div class="feedbackinfo" style="font-style:italic;color:#999999;height:30px;line-height:30px;padding-left:18px;">
								暂无相关反馈信息！
							</div>
						</div>
					</td>
				</tr>
				<%} %>
		</table>
		<div id="btn_more" class="" style="display:none;margin-bottom: 10px;cursor:pointer;color:#696969;" 
		_currentpage="0"
		 _pagesize="<%=_pagesize %>" _total="<%=_total %>" onclick="getList(this)" title="显示更多数据">更多</div>
	</div>
	
	<iframe id="mainiframe" name="mainiframe" class="datainfo" style="width: 100%;height:100%;display:none" 
	src="" frameborder="0"></iframe>
</div>
<script type="text/javascript">
	$(document).ready(function(){
		$('#maininfo').perfectScrollbar({"wheelSpeed": 40});
		<%if(_total>0){ %>getList($("#btn_more"))<%}%>

		$("div.dtab").bind("mouseover",function(){
			$(this).addClass("dtab_hover");
		}).bind("mouseout",function(){
			$(this).removeClass("dtab_hover");
		}).bind("click",function(){
			$("div.dtab").removeClass("dtab_click");
			$(this).addClass("dtab_click");
			var _infoid = $(this).attr("_infoid");
			$(".datainfo").hide();
			$("#"+_infoid).show();
			if(_infoid=="mainiframe"){
				$("#blogmore").show();
				if($("#mainiframe").attr("src")=="")
					 $("#mainiframe").attr("src","/blog/viewBlog.jsp?blogid=<%=hrmid %>");
			}else{
				$("#blogmore").hide();
			}
		});

		$("#blogmore").bind("mouseover",function(){
			$(this).css("color","#747474");
		}).bind("mouseout",function(){
			$(this).css("color","#959595");
		});

		var iframe1 = document.getElementById("mainiframe");
		if (iframe1.attachEvent){ 
			iframe1.attachEvent("onload", function(){ 
				setHidden();
			}); 
		} else { 
			iframe1.onload = function(){ 
				setHidden()
			}; 
		} 
	});

	function setHidden(){
		//alert($(window.frames["mainiframe"].document).find("div.TopTitle").html());
		$(window.frames["mainiframe"].document).find("div.TopTitle").hide();
	}
	function displayLoading(){

	}
	function getList(obj){
		var _currentpage = parseInt($(obj).attr("_currentpage"))+1;
		var _pagesize = $(obj).attr("_pagesize");
		var _total = $(obj).attr("_total");
		$(obj).html("<img src='/workrelate/task/images/loading2.gif' style='margin-top:3px;' align='absMiddle'/>");
		$.ajax({
			type: "post",
		    url: "Operation.jsp",
		    data:{"operation":"get_more_fb","currentpage":_currentpage,"hrmid":"<%=hrmid%>",
		    "pagesize":_pagesize,"total":_total,"ifMySelf":"<%=ifMySelf%>"}, 
		    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
		    complete: function(data){ 
		    	var records = $.trim(data.responseText);
		    	$("#feedbacktable").append(records);
		    	if("<%=ifMySelf%>"==0){
			    	if(_currentpage*_pagesize>=_total){
			    		$("#btn_more").hide();
				    }else{
				    	$(obj).attr("_currentpage",_currentpage).html("显示更多");
				    	$("#btn_more").show();
					}
				}
		    	$('#maininfo').perfectScrollbar("update");
			}
	    });
	}
</script>
<%!
	public String getFileDoc(String ids,String taskId) throws Exception{
		String returnstr = "";
		String docid = "";
		String docImagefileid = "";
		int docImagefileSize = 0;
		String docImagefilename = "";
		DocImageManager DocImageManager = null;
		if(ids != null && !"".equals(ids)){
			List idList = Util.TokenizerString(ids, ",");
			for (int i = 0; i < idList.size(); i++) {
				docid = Util.null2String((String)idList.get(i));
				if(!docid.equals("")){
					DocImageManager = new DocImageManager();
					DocImageManager.resetParameter();
		            DocImageManager.setDocid(Integer.parseInt((String)idList.get(i)));
		            DocImageManager.selectDocImageInfo();
		            DocImageManager.next();
		            docImagefileid = DocImageManager.getImagefileid();
		            docImagefileSize = DocImageManager.getImageFileSize(Util.getIntValue(docImagefileid));
		            docImagefilename = DocImageManager.getImagefilename();
		            returnstr += "<a href=javaScript:openFullWindowHaveBar('/workrelate/task/util/ViewDoc.jsp?id="
		            +docid+"&taskId="+taskId+"') >"+docImagefilename+"</a>";
		            returnstr += "&nbsp;<a href='/workrelate/task/util/ViewDoc.jsp?id="
		            +docid+"&taskId="+taskId+"&fileid="+docImagefileid+"'>下载("+docImagefileSize/1000+"K)</a>&nbsp;&nbsp;";
				}
			}
		}
		return returnstr;
	}
%>
