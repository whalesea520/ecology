
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ page import="weaver.docs.docs.DocImageManager"%>
<jsp:useBean id="cmutil" class="weaver.task.CommonTransUtil" scope="page"/>
<%
	String userid = user.getUID()+"";
	String sql = "select top 5 t1.id,t1.content,t1.hrmid,t1.docids,t1.wfids,t1.crmids,t1.projectids,t1.meetingids,t1.fileids,t1.createdate,t1.createtime,t2.id as taskid,t2.name "
		+" from TM_TaskFeedback t1,TM_TaskInfo t2 "
		+" where t1.taskid=t2.id and (t2.deleted=0 or t2.deleted is null)"
		+" and (t2.creater="+userid+" or t2.principalid="+userid+" or exists (select 1 from TM_TaskPartner tp where tp.taskid=t2.id and tp.partnerid="+userid+"))"
		+" and t1.hrmid<>"+userid
		+" order by t1.createdate desc,t1.createtime desc";
		//System.out.println(sql);
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
		behavior:url(/express/css/PIE2.htc);
	}
	.feedbackrelate .relatetitle{color: #808080}
	.feedbackrelate a,.feedbackrelate a:active,.feedbackrelate a:visited{text-decoration: none !important;color: #1D76A4 !important;}
	.feedbackrelate a:hover{text-decoration: underline !important;color: #FF0000 !important;}
	.feedbackshow p{padding: 0px;margin: 0px;line-height: 20px !important;}
</STYLE>
<div id="rightinfo" style="width: 100%;height: 100%;position: relative;overflow: hidden;">
	<div style="width: 100%;height: 30px;position: relative;
	background:-webkit-gradient(linear, 0 0, 0 bottom, from(#F2F2F2), to(#F6F6F6)) !important;
    	background:-moz-linear-gradient(#F2F2F2, #D7D7D7) !important;
    	-pie-background:linear-gradient(#F2F2F2, #D7D7D7) !important;background: #F2F2F2 !important;">
		<div style="position: absolute;top: 3px;left:0px;height: 23px;width: 100%;">
			<div style="margin-left: 10px;margin-top: 3px;font-weight: bold;width: 65px;text-align: left;font-family: 微软雅黑;">
				最新反馈</div>
		</div>
	</div>
	<div id="maininfo" style="width:100%;height: auto;position:absolute;top:30px;left:0px;bottom:0px;border-top:1px #E8E8E8 solid;
		line-height: 40px;font-size: 14px;" class="scroll1" align="center">
		<table id="feedbacktable" class="datatable" style="width: 100%;margin: 0px auto;text-align: left;" cellpadding="0" cellspacing="0" border="0">
				<%
					boolean hasrecord = false;
					rs.executeSql(sql);
					while(rs.next()){
						hasrecord = true;
				%>
				<tr>
					<td class="data">
						<div class="feedbackshow">
							<div class="feedbackinfo" style="font-weight: bold;"><a href="javascript:refreshDetail(<%=Util.null2String(rs.getString("taskid")) %>)"><%=Util.null2String(rs.getString("name")) %></a></div>
							<div class="feedbackinfo"><%=cmutil.getHrm(rs.getString("hrmid")) %> <%=Util.null2String(rs.getString("createdate")) %> <%=Util.null2String(rs.getString("createtime")) %></div>
							<div class="feedbackrelate">
								<div><%=Util.convertDB2Input(rs.getString("content")) %></div>
								<%if(!"".equals(rs.getString("docids"))){ %>
								<div class="relatetitle">相关文档：<%=cmutil.getDocName(rs.getString("docids")) %></div>
								<%} %>
								<%if(!"".equals(rs.getString("wfids"))){ %>
								<div class="relatetitle">相关流程：<%=cmutil.getRequestName(rs.getString("wfids")) %></div>
								<%} %>
								<%if(!"".equals(rs.getString("crmids"))){ %>
								<div class="relatetitle">相关客户：<%=cmutil.getCustomer(rs.getString("crmids")) %></div>
								<%} %>
								<%if(!"".equals(rs.getString("projectids"))){ %>
								<div class="relatetitle">相关项目：<%=cmutil.getProject(rs.getString("projectids")) %></div>
								<%} %>
								<%if(!"".equals(rs.getString("fileids"))){ %>
								<div class="relatetitle">相关附件：<%=this.getFileDoc(rs.getString("fileids"),Util.null2String(rs.getString("taskid"))) %></div>
								<%} %>
							</div>
						</div>
					</td>
				</tr>
				<%} %>
				<%if(!hasrecord){%>
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
	</div>
</div>
<script type="text/javascript">
	$(document).ready(function(){
		$("#feedbacktable").find(".data").live("mouseover",function(){
			$(this).css("background-color","#F7FBFF");
		}).live("mouseout",function(){
			$(this).css("background-color","#fff");
		});
	});
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
		            returnstr += "<a href=javaScript:openFullWindowHaveBar('/express/task/util/ViewDoc.jsp?id="+docid+"&taskId="+taskId+"') >"+docImagefilename+"</a>";
		            returnstr += "&nbsp;<a href='/express/task/util/ViewDoc.jsp?id="+docid+"&taskId="+taskId+"&fileid="+docImagefileid+"'>下载("+docImagefileSize/1000+"K)</a>&nbsp;&nbsp;";
				}
			}
		}
		return returnstr;
	}
%>
