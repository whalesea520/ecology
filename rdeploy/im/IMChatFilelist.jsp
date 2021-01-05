
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.social.SocialUtil"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="weaver.hrm.resource.ResourceComInfo"%>
<%@page import="weaver.social.service.SocialIMService"%>
<%@page import="weaver.social.po.SocialIMFile"%>
<%@ include file="/social/im/SocialIMInit.jsp"%>
<jsp:useBean id="SocialIMService" class="weaver.social.service.SocialIMService" scope="page" />
<jsp:useBean id="iMService" class="weaver.social.rdeploy.im.IMService" scope="page" />
<%
	int userid=user.getUID();
	String targetid=Util.null2String(request.getParameter("targetid"));
	String targettype=Util.null2String(request.getParameter("targettype"));
	String attachmentMaxsize="50";
	
	List<SocialIMFile> imFileList=SocialIMService.getIMFileList(""+userid,targetid,targettype,"1");
	//List<Map<String, String>> docResList = iMService.getChatResources(userid+"",acceptId,targettype, "1");
	//抓取文档附件
	
	ResourceComInfo resourceComInfo=SocialUtil.getResourceComInfo();
%>
<style>
	.dataLoading{
		position:absolute;
		top:0px;bottom:0px;left:0px;right:0px;
		background: url('/social/images/loading_large_wev8.gif') no-repeat center 200px;
		display: block;
		z-index:1000
	}
	
	.fileList .fileoptPane .checkallwrap {
		display: inline-block;
  		cursor: pointer;
	}
</style>
<!-- 主显示区域 -->
<div class="fileList">
	<div class="acclist" style="height:480px;overflow-y:auto;">
		<%
		SocialIMFile sif;
		for(int i = 0; i < imFileList.size(); ++i){ 
			sif = imFileList.get(i);
			String fileid=sif.getFileid();
		%>
			<div class="accitem"  _fileid="<%=sif.getFileid() %>" _filename="<%=sif.getFileName() %>" _filetype="<%=sif.getFileType() %>"
				style="display:block;" onclick="doSelectItem(this);">
				<div class="accItemLeftPad"></div>
				<div class="accchk" style="display:none;"><input type="checkbox"/></div>
				<div class="accicon" style="background:url('/social/images/acc_<%=sif.getFileType() %>_wev8.png') no-repeat center center;"></div>
				<div class="acccdiv">
					<div>
						<a href="javascript:void(0)" class="fileName opdiv" onclick="previewIMFile(this);"><%=sif.getFileName() %></a>
					</div>
					<div style="margin-top:10px;">
						<span class="fileSize">
							<script> 
								var size = getSizeFormate('<%=sif.getFileSize()%>');
								$(".accitem[_fileid='<%=sif.getFileid()%>']").find(".fileSize").html(size);
							</script>
						</span>
						<span class="senderName"><%=resourceComInfo.getLastname(sif.getUserid()) %>&nbsp;&nbsp;<%=sif.getCreatedate() %></span>
					</div>
				</div>
				<div class="accItemRightPad"></div>
				<div class="btn1 download imDownload opdiv" _fileId="<%=fileid%>" onclick="downAccFile(this)">下载</div>
				<div class="clear"></div>
			</div>
		<%} %>
		<%if(imFileList.size() <= 0){ %>
			<div class='accNoneBg'></div>;
			<div class='accNoneCap'>在这里，你可以分享知识文件给大家</div>;
		<%} %>
	</div>
	<!-- 文件操作区域 -->
	<div class="fileoptPane" style="display:none;">
		<div class="optLeftPane">
			<div class="checkallwrap" onclick="doSelectAll(this)">
				<input type="checkbox" id="checkall" name="checkall"/>
				<label for="checkall" style="margin-right: 20px;">全选</label>
			</div>
			<span>共<span class="checkcnt">0</span>个文件</span>
		</div>
		<div class="optRightPane">
			<div class="fileOptBtn fileDelBtn" onclick="delCheckedFiles();" style="display:none;">删除</div>
			<div class="fileOptBtn fileDownloadBtn" onclick="downloadCheckedFiles(this);">下载</div>
		</div>
	</div>
	<div style="height:40px;line-height:40px;text-align: center;display:none;">暂时没有附件</div>
</div>
<script>
	$(".dataLoading").hide();
	$('.acclist').perfectScrollbar();
	
	$(".acclist .accchk input[type='checkbox']").click(function(event){
		event = event || window.event;
		var obj = this;
		mytrigger(obj);
		updateCheckCnt(obj);
		stopEvt(event);
	});
	if('<%=targettype%>' == '1' && !DiscussUtil.isDiscussCreator('<%=userid%>', '<%=targetid%>')){
		$('.fileDelBtn').remove();
	}
	
	$("#chatdiv_<%=targetid%>").find(".accitem").hover(
		function(event){
 				$(this).find(".download").show(); 
		},function(){
  				$(this).find(".download").hide(); 
		}
	)
	
	//预览文件
	function previewIMFile(obj) {
		obj = $(obj).parents(".accitem")[0];
		viewIMFile(obj);
		stopEvt(event || window.event);
	}
	//自定义stopEvent
	function stopEvt(evt){
		evt.stopPropagation();
		evt.cancelBubble = true;
		evt.preventDefault();
	}
	//自定义trigger
	function mytrigger(obj, checked) {
		var chk = $(obj);
		var ischecked = chk.data("ischecked");
		var span = chk.parent().find(".jNiceCheckbox");
		var hascheck = checked==undefined?!ischecked: checked;
		if(hascheck){
			span.addClass("jNiceChecked");
			chk.attr("checked", "true")
		}else{
			span.removeClass("jNiceChecked");
			chk.removeAttr("checked");
		}
		chk.data("ischecked", hascheck);
	}
	function downloadIMFiles(ids){
		$("#downloadFrame").attr("src","/weaver/weaver.file.FileDownload?fieldids="+ids+
			"&downloadBatch=1&onlydownloadfj=1&download=1");
	}
	//下载
	function downloadCheckedFiles(obj){
		var flist = getflist(obj);
		var fids = [];
		var chks = flist.find(".acclist .accchk input[type='checkbox']");
		for(var i = 0; i < chks.length; ++i){
			var ch = $(chks[i]);
			if(ch.data("ischecked")){
				var accitem = ch.parents(".accitem");
				var fileid = accitem.attr("_fileid");
				fids.push(fileid);
				downAccFile(accitem);
			}
		}
		//downloadIMFiles(fids.join(","));
	}
	//全选
	function doSelectAll(obj) {
		var flist = getflist(obj);
		obj = $(obj).find("input[type='checkbox']");
		flist.find(".acclist .accchk input[type='checkbox']").each(function(){
			mytrigger(this, !obj.data("ischecked"));
		});
		mytrigger(obj);
		updateCheckCnt(obj);
	}
	
	//选择
	function doSelectItem(obj){
		var chk = $(obj).find("input[type='checkbox']");
		mytrigger(chk);
		updateCheckCnt(obj);
	}
	
	//更新选择统计
	function updateCheckCnt(obj){
		var flist = getflist(obj);
		var chks = flist.find(".acclist .accchk input[type='checkbox']");
		var cnt = 0;
		for(var i = 0; i < chks.length; ++i){
			if($(chks[i]).data("ischecked")){
				cnt++;
			}
		}
		flist.find(".fileoptPane .checkcnt").html(cnt);
		if(cnt < chks.length){
			var checkallwrap = flist.find(".checkallwrap");
			mytrigger(checkallwrap[0],false);
		}else if(cnt == chks.length){
			var checkallwrap = flist.find(".checkallwrap");
			mytrigger(checkallwrap[0],true);
		}
	}
	
	function getflist(obj){
		var flist = $(obj).parents(".fileList");
		return flist;
	}
</script>

