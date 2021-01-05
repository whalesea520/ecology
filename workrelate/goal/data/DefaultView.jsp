<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ page import="weaver.docs.docs.DocImageManager"%>
<%
	String userid = user.getUID()+"";
	/**
	String sql = "select top 10 t1.id,t1.content,t1.hrmid,t1.docids,t1.wfids,t1.crmids,t1.projectids,t1.meetingids,t1.fileids,t1.createdate,t1.createtime,t2.id as taskid,t2.name "
		+",(select top 1 tlog.operatedate+' '+tlog.operatetime from TM_TaskLog tlog where tlog.taskid=t2.id and tlog.type=0 and tlog.operator="+userid+" order by tlog.operatedate desc,tlog.operatetime desc) as lastviewdate"
		+" from TM_TaskFeedback t1,TM_TaskInfo t2 "
		+" where t1.taskid=t2.id and (t2.deleted=0 or t2.deleted is null)"
		+" and (t2.creater="+userid+" or t2.principalid="+userid+" or exists (select 1 from TM_TaskPartner tp where tp.taskid=t2.id and tp.partnerid="+userid+"))"
		+" and t1.hrmid<>"+userid
		+" order by t1.createdate desc,t1.createtime desc";
		//System.out.println(sql);
	*/
	int _pagesize = 10;
	int _total = 0;//总数
	rs.executeSql("select count(distinct t1.id) "
			+" from GM_GoalFeedback t1,GM_GoalInfo t2 "
			+" where t1.goalid=t2.id and (t2.deleted=0 or t2.deleted is null)"
			+" and (t2.creater="+userid+" or t2.principalid="+userid+" or exists (select 1 from GM_GoalPartner tp where tp.goalid=t2.id and tp.partnerid="+userid+"))"
			+" and t1.hrmid<>"+userid);
	//System.out.println("select count(t1.id) from DocDetail t1 "+sqlwhere);
	if(rs.next()){
		_total = rs.getInt(1);
	}
%>
<style type="text/css">
	.datatable{width: 100%;}	
	.datatable td{padding-left: 5px;padding-top:1px;padding-bottom:1px;text-align: left;}
	.datatable td.title{color: #999999;vertical-align: top;padding-top: 7px;padding-bottom: 7px;padding-left: 20px;background: #F6F6F6;border-top: 1px #F6F6F6 solid;border-bottom: 1px #F6F6F6 solid;}
	.datatable td.data{vertical-align: middle;border-top: 1px #fff solid;border-bottom: 1px #E8E8E8 dashed;padding-bottom: 10px;}
	#rightinfo a,#rightinfo a:active,#rightinfo a:visited{text-decoration: none;color: #000000;}
	#rightinfo a:hover{text-decoration: underline;color: #0080FF;}
	.feedbackshow{width: 90%;margin-left: 20px;margin-top: 5px;overflow: hidden;}
	.feedbackinfo{width: auto;line-height: 24px;color: #808080;}
	.feedbackinfo a,.feedbackinfo a:active,.feedbackinfo a:visited{text-decoration: none !important;color: #808080 !important;}
	.feedbackinfo a:hover{text-decoration: underline !important;color: #0080FF !important;}
	.feedbackrelate{width: auto;line-height: 24px;background: #F9F9F9;overflow:hidden;padding:5px;
		border: 1px #E7E7E7 solid;border-radius: 2px;-moz-border-radius: 2px;-webkit-border-radius: 2px;
		box-shadow:0px 0px 2px #E7E7E7;-moz-box-shadow:0px 0px 2px #E7E7E7;-webkit-box-shadow:0px 0px 2px #E7E7E7;
		behavior:url(/workrelate/css/PIE2.htc);
	}
	.feedbackrelate .relatetitle{color: #808080}
	.feedbackrelate a,.feedbackrelate a:active,.feedbackrelate a:visited{text-decoration: none !important;color: #1D76A4 !important;}
	.feedbackrelate a:hover{text-decoration: underline !important;color: #FF0000 !important;}
	.feedbackshow p{padding: 0px;margin: 0px;line-height: 20px !important;}
</STYLE>
<div id="rightinfo" style="width: 100%;height: 100%;position: relative;overflow: hidden;">
	<div style="width: 100%;height: 40px;position: relative;
	background:-webkit-gradient(linear, 0 0, 0 bottom, from(#F2F2F2), to(#F6F6F6)) !important;
    	background:-moz-linear-gradient(#F2F2F2, #D7D7D7) !important;
    	-pie-background:linear-gradient(#F2F2F2, #D7D7D7) !important;background: #F2F2F2 !important;">
		<div style="position: absolute;top: 3px;left:0px;height: 23px;width: 100%;">
			<div style="margin-left: 10px;margin-top: 8px;font-weight: bold;width: 65px;text-align: left;font-family: 微软雅黑;">
				最新反馈</div>
		</div>
	</div>
	<div id="maininfo" style="width:100%;height: auto;position:absolute;top:40px;left:0px;bottom:0px;border-top:1px #E8E8E8 solid;
		line-height: 40px;font-size: 14px;" class="scroll1" align="center" class="scroll1">
		<table id="feedbacktable" class="datatable" style="width: 100%;margin: 0px auto;text-align: left;" cellpadding="0" cellspacing="0" border="0">
				<%if(_total==0){ %>
				<tr>
					<td class="data">
						<div class="feedbackshow">
							<div class="feedbackinfo" style="font-style: italic;color:#999999">
								暂无相关反馈信息！
							</div>
						</div>
					</td>
				</tr>
				<%} %>
		</table>
		<div id="btn_more" class="listmore" style="display: none;background-image: none;margin-bottom: 10px;" _currentpage="0" _pagesize="<%=_pagesize %>" _total="<%=_total %>" onclick="getList(this)" title="显示更多数据">更多</div>
	</div>
</div>
<script type="text/javascript">
	$(document).ready(function(){
		$("#feedbacktable").find(".data").live("mouseover",function(){
			$(this).css("background-color","#F7FBFF");
		}).live("mouseout",function(){
			$(this).css("background-color","#fff");
		});
		$('#maininfo').perfectScrollbar({"wheelSpeed": 40});
		<%if(_total>0){ %>$("#btn_more").click();<%}%>
	});
	function getList(obj){
		var _currentpage = parseInt($(obj).attr("_currentpage"))+1;
		var _pagesize = $(obj).attr("_pagesize");
		var _total = $(obj).attr("_total");
		$(obj).html("<img src='../images/loading2.gif' style='margin-top:3px;' align='absMiddle'/>");
		$.ajax({
			type: "post",
		    url: "Operation.jsp",
		    data:{"operation":"get_more_fb","currentpage":_currentpage,"pagesize":_pagesize,"total":_total}, 
		    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
		    complete: function(data){ 
		    	var records = $.trim(data.responseText);
		    	$("#feedbacktable").append(records);
		    	if(_currentpage*_pagesize>=_total){
		    		$("#btn_more").hide();
			    }else{
			    	$(obj).attr("_currentpage",_currentpage).html("显示更多");
			    	$("#btn_more").show();
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
		            returnstr += "<a href=javaScript:openFullWindowHaveBar('/workrelate/task/util/ViewDoc.jsp?id="+docid+"&taskId="+taskId+"') >"+docImagefilename+"</a>";
		            returnstr += "&nbsp;<a href='/workrelate/task/util/ViewDoc.jsp?id="+docid+"&taskId="+taskId+"&fileid="+docImagefileid+"'>下载("+docImagefileSize/1000+"K)</a>&nbsp;&nbsp;";
				}
			}
		}
		return returnstr;
	}
%>
