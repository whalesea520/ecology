<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.general.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<% 
User user = HrmUserVarify.getUser (request , response) ;
if(user==null){
	return;
}
boolean canSendAll = false;
if(user.getUID()==1||HrmUserVarify.checkUserRight("WX_SENDALL_RIGHT", user)){
	canSendAll = true;
}
int sendType = Util.getIntValue(request.getParameter("sendType"),3);
%>
<HTML>
	<head>
		<title>����΢����Ϣ</title>
		
		<script type='text/javascript' src="../js/jquery-1.8.3.min.js"></script>
	 	<script type='text/javascript' src="../js/jquery.form.js"></script>
	 	<script type='text/javascript' src="../js/json2.js"></script>
		
		<link rel="stylesheet" href="../js/showLoading/css/showLoading.css">
		<script type='text/javascript' src="../js/showLoading/js/jquery.showLoading.js"></script>
		
		<link rel="stylesheet" href="../js/zdialog/zDialog_e8.css" />
		<script type='text/javascript' src="../js/zdialog/zDialog.js"></script>
		<script type='text/javascript' src="../js/zdialog/zDrag.js"></script>
		<script type='text/javascript' src="../js/util.js"></script>
		<script type='text/javascript' src="../js/init.js"></script>
		
		<link rel="stylesheet" type="text/css" href="../css/main.css" />
		
		<link rel="stylesheet" href="../css/new.css" />
		<style type="text/css">
			.typeSpan{
				font-weight: bold;
				color: #333;
				margin-right:2px;
			}
			.flowSpan{
				color:#666;
				margin-right:2px;
			}
			.datalist{width: 100%;}
			.datalist td{padding-left: 2px;padding-top: 8px;padding-bottom: 8px;line-height: 18px;vertical-align: top;
				border-bottom: 1px #F3F3F3 solid; }
			.datalist tr.head td{font-weight: bold;background: #F3F3F3;}
			.btn_msg{
				line-height:30px;width:90px;color:#fff;cursor:pointer;text-align:center;
				background:#30b5ff;border:1px solid #aecef1;
			}
			.bgcolor{
				background:#03a996;
			}
			.doctable{
				border:0;
				width:100%;
			}
			#openDiv .co_tblForm .doctable td{
				height:30px;
				padding-left:0 !important;
			}
			.doctable td{
				line-height:30px;
				border:1px solid #ccc;
				border-collapse:collapse;
				border-spacing: 0px;
				text-align: center;
			}
			.doctr input{
				outline:none;
				border:0;
				height:36px;
				line-height:36px;
				width:100%;
				text-indent:5px;
			}
			.doctr textarea{
				outline:none;
				border:0;
				min-height:36px;
				line-height:18px;
				width:100%;
				text-indent:5px;
			}
			.doctdtitle{
				text-align:center;
				background:#30b5ff;
				color:#fff;
			}
			.movediv{
				height:20px;float:left;margin:5px;
				line-height:20px;margin-left:22px;
				background:#30b5ff;border:1px solid #30b5ff;
				width:50px;color:#fff;cursor:pointer;text-align:center;
			}
			.movediv:hover{
				border:1px solid #03a996;
				background:#03a996;
			}
			.authorTd,.descTd{
				display:none;
			}
		</style>
	</head>
	<%@ include file="/wxinterface/util/uploader.jsp"%>
<body style="overflow: auto;">
<div id="addMConfigDiv" style="position:relative;">
	<div class="coboxhead">
		<div class="co_tablogo" style="background:url(../images/msg.png) center no-repeat;"></div>
		<div class="co_ultab">
			<div class="co_navtab">����΢����Ϣ</div>
			<div>
				<ul class="co_tab_menu" style="width:453px;display: none;"></ul>
	   			<div class="co_outbox">
		   			<div class="co_rightBox">
			   			<div>
							<div class="co_btn" id="viewlog">�鿴���ͼ�¼</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
		<div class="co_tab_box" id="openDiv" style="overflow:auto;height:auto;">
			<div class="addTableDiv">
				<table class="co_tblForm">
					<colgroup><col width="25%" /><col width="75%" /></colgroup>
					<tr>
						<td class="title">��Ϣ����</td>
						<td class="data">
							<input type="radio" id="sendType3" class="sendType" name="sendType" value="3" checked="checked"/>������Ϣ
							<input type="radio" id="sendType13" class="sendType" name="sendType" value="13" />�ĵ�Ⱥ��
							<input type="radio" id="sendType12" class="sendType" name="sendType" value="12" />΢������Ⱥ��
						</td>
					</tr>
					<tr>
						<td class="title">����Ŀ��</td>
						<td class="data">
							<% 
								rs.executeSql("select * from WX_MsgRuleSetting where (type = 3 or type = 12 or type = 13 ) and isenable = 1");
								while(rs.next()){
									int id = Util.getIntValue(rs.getString("id"));
									int type = Util.getIntValue(rs.getString("type"));
									String name = Util.null2String(rs.getString("name"));
							%>	
							<div class="sendRule sendRule_<%=type%>" style="display: none;float:left;margin-right:10px;">
								<input checked="checked" type="checkbox" name="sendRule<%=type%>" value="<%=id%>"/><%=name %>
							</div>
							<%}%>
							<div style="color:red;display:none;" id="tipsDiv">
								��ʾ�����ڡ�e-Bridge-��΢OAϵͳ����-�������á���������Ϣ����Ϊ��<span id="tipsName"></span>������������
							</div>
						</td>
					</tr>
					<tr id="resourceTr">
						<td class="title">���Ͷ���</td>
						<td class="data">
							<div style="float:left;">
								<input type="hidden" id="userids" name="userids" value=""/>
								<span class="mcBrowser" id="mcBrowser" style="display: inline-block;"></span>
								<span id="userNames"></span>
							</div>
							<div id="allOAUserDiv" style="float:left;margin-left:5px;<%if(!canSendAll){%>display:none;<%} %>">
								<input type="radio" class="userType" name="userType" value="1" id="allOAUserRadio"/>
								<span id="allUser">����OA��Ա</span>
							</div>
							<div id="allWxUserDiv" style="float:left;margin-left:5px;<%if(!canSendAll){%>display:none;<%} %>">
								<input type="radio" class="userType" name="userType" value="2" id="allWxUserRadio"/>
								<span id="allUser">����΢���û�</span>
							</div>
						</td>
					</tr>
					<tr id="contentTr">
						<td class="title">��������</td>
						<td class="data">
							<textarea class="textarea_def" id="sendContent"></textarea>
						</td>
					</tr>
					<tr id="docTr" style="display:none;">
						<td class="title">ѡ���ĵ�</td>
						<td class="data">
							<input type="hidden" id="docids" name="docids" value=""/>
							<span class="mcBrowser" id="docBrowser" style="display: inline-block;"></span>
							<span id="docNames"></span>
						</td>
					</tr>
					<tr id="rebackTr" style="display:none;">
						<td class="title">�Ƿ�ɻظ�</td>
						<td class="data">
							<input type="radio" class="ifReback" name="ifReback" value="1" checked="checked"/>��
							<input type="radio" class="ifReback" name="ifReback" value="0" />��
						</td>
					</tr>
					<tr id="safeTr" style="display:none;">
						<td class="title">�Ƿ���</td>
						<td class="data">
							<input type="radio" class="ifSafe" name="ifSafe" value="1" checked="checked"/>��
							<input type="radio" class="ifSafe" name="ifSafe" value="0" />��
							(������Ϣ�����Ĳ���ת��)
						</td>
					</tr>
					<tr><td colspan="2">&nbsp;</td></tr>
					<tr id="doctableTr">
						<td colspan="2" style="padding-right:12px;">
							<table class="doctable" id="doctable">
								<tr><td colspan="7" class="doctdtitle">�����ĵ���Ϣ</td></tr>
								<tr id="docHeadTr">
									<td width="5%">��ʾ˳��</td>
									<td width="20%">ԭ�ı���</td>
									<td width="20%">�������</td>
									<td width="10%" class="authorTd">����</td>
									<td width="20%" class="descTd">����ժҪ</td>
									<td width="12%">����ͼƬ</td>
									<td width="13%">����˳��(�������ϴ�ͼƬ)</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr><td colspan="2">&nbsp;</td></tr>
					<tr>
						<td colspan="2" align="center">
							<div class="btn_msg" id="sendMsg">����</div>
						</td>
					</tr>
					<tr>
						<td colspan="2" align="left">
							<div style="line-height:26px;font-size:12px;">
							1����ҵ��֧������������Ϣ����,�����ֻ֧��������Ϣ��΢������Ⱥ��<br/>
							2���ĵ�Ⱥ���Ὣ��ѡ����ĵ������ӵ�ַ���͸��û�������û���ĵ�Ȩ�޵��˽��޷����ĵ�����<br/>
							3��΢������Ⱥ���Ὣ��ѡ����ĵ����ݷ�����΢�ŷ������ϣ������˶���Ȩ�޲鿴�ĵ�����<br/>
							4������ʹ�����ŵ���֯�ṹͬ������,���Ͷ������ѡ������OA��Ա<br/>
							5�������ʹ��΢������Ⱥ����ռ��ÿ����ÿ����������4��������
							</div>
						</td>
					</tr>
				</table>
			</div>
		</div>
</div>
<script>
	var imageIndex = 0;
	$(document).ready(function(){
		$(".sendType").click(function(){
			var value = $(this).val();
			$(".sendRule").hide();//�Ƚ����е�����Ŀ������
			if($(".sendRule_"+value).length>0){//�жϵ�ǰ������Ϣ�Ƿ������� ����ģ��
				$(".sendRule_"+value).show();
				$("#tipsDiv").hide();
			}else{
				var name = "";
				if(value==3){
					name = "��Ϣ";
				}else if(value==12){
					name = "΢������Ⱥ��";
				}else if(value==13){
					name = "�ĵ�Ⱥ��";
				}
				$("#tipsName").html(name);
				$("#tipsDiv").show();
			}
			if(value==3){//������Ϣ չʾ�ı������
				$("#contentTr").show().find("td").show();
				$("#docTr").hide().find("td").hide();
				$("#doctableTr").hide();
			}else{//�ĵ���Ϣչʾѡ���ĵ������
				$("#contentTr").hide().find("td").hide();
				$("#docTr").show().find("td").show();
				$("#doctableTr").show();
			}
			if(value==12){//΢������Ⱥ��չʾ�Ƿ�ɻظ��Ƿ���ѡ��
				$("#safeTr").show().find("td").show();
				$("#rebackTr").show().find("td").show();
				$(".authorTd").show();
				//$(".descTd").show();
			}else{
				$("#safeTr").hide().find("td").hide();
				$("#rebackTr").show().find("td").hide();
				$(".authorTd").hide();
				//$(".descTd").hide();
			}
			//if('<%=canSendAll%>'=='true'){
				//if(value==13){//�ĵ�Ⱥ����չʾ ����΢���û�ѡ��
				//	$("#allWxUserDiv").hide();
				//	$("#allWxUserRadio").attr("checked",false);
				//}else{
				//	$("#allWxUserDiv").show();
				//}
			//	$("#allWxUserDiv").show();
			//}
		});
		
		$("#sendType<%=sendType%>").click();
		
		$("#mcBrowser").click(function(){
			var userids = $("#userids").val();
			var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="+userids);
			if (datas) {
				var userids = datas.id;
				if(userids.indexOf(",")==0){
					userids = userids.substring(1);
				}
				var userNames = datas.name;
				if(userNames.indexOf(",")==0){
					userNames = userNames.substring(1);
				}
				$("#userids").val(userids);
				$("#userNames").html(userNames);
				$(".userType").attr("checked",false);
		    }
		});
		$(".userType").click(function(){
			$("#userids").val("");
			$("#userNames").html("");
		});
		
		$("#docBrowser").click(function(){
			var docids = $("#docids").val();
			 var datas = window.showModalDialog("/docs/DocBrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp?documentids="+docids);
			if (datas) {
				docids = datas.id;
				if(docids.indexOf(",")==0){
					docids = docids.substring(1);
				}
				var docidss = docids.split(",");
				if(docidss.length>10){
					alert("�ĵ��������ܳ���10��");
					return;
				}
				var docNames = datas.name;
				if(docNames.indexOf(",")==0){
					docNames = docNames.substring(1);
				}
				$("#docids").val(docids);
				$("#docNames").html(docNames);
				setTableData(docids,docNames);
		    }
		});
		
		$(".btn_msg").bind("mouseover",function(){
			$(this).addClass("bgcolor");
		}).bind("mouseout",function(){
			$(this).removeClass("bgcolor");
		});
		
		$("#viewlog").click(function(){
			location.href = "sendMsgLog.jsp";
		})
		
		$("#sendMsg").click(function(){
			var sendType = $("input[name='sendType']:checked").val();
			if(sendType==12||sendType==13){
				imageIndex = 0;
				uploadImage(0);
			}else{
				sendMsg();
			}
		});
		
		$(".movediv").live("click",function(){
			var currentTr = $(this).parent().parent();
			var prevTr = currentTr.prev();
			var afterTr = currentTr.next();
			var docid = $(this).attr("docid");
			var type = $(this).attr("type");
			if(prevTr.attr("id")=="docHeadTr"&&type==1){
				return;
			}
			if(afterTr.length==0&&type==2){
				return;
			}
			if(type==1){
				currentTr.insertBefore(prevTr);
			}else if(type==2){
				currentTr.insertAfter(afterTr);
			}
			var oUploader = window[$("#upimagediv_"+docid).attr("oUploaderIndex")];
			oUploader.cancelUpload();
			jQuery("#fsUploadProgress_"+$("#upimagediv_"+docid).attr("oUploaderIndexId")).html(""); //����ϴ������� 
			setDocTrSort();
		});
	});
	var tr_docids = new Array();
	function setTableData(docids,docnames){
		var docidss = docids.split(",");
		var docnamess = docnames.split(",");
		for(var i=0;i<docidss.length;i++){
			var docid = docidss[i];
			var docname = docnamess[i];
			if(!ifSetDoc(docid)){
				var temp = "<tr class='doctr' docid='"+docid+"' id='tr_"+docid+"'>";
				temp += "<td id='sort_"+docid+"'>&nbsp;</td>";
				temp += "<td>"+docname+"</td>";
				temp += "<td><textarea id='title_"+docid+"'></textarea></td>";
				temp += "<td class='authorTd'><input type='text' id='author_"+docid+"'/></td>";
				temp += "<td class='descTd'><textarea id='desc_"+docid+"'></textarea></td>";
				temp += "<td><div class='upimage' maxsize='1' id='upimagediv_"+docid+"'></div></td>";
				temp += "<td><div class='movediv' type='1' docid='"+docid+"'>����</div>";
				temp += "<div class='movediv' type='2' docid='"+docid+"'>����</div></td>";
				temp +="</tr>";
				$("#doctable").append(temp);
				bindUploaderDiv($("#upimagediv_"+docid),"imagename"+docid,docid);
				tr_docids.push(docid);
			}
		}
		removeSetDoc(docidss);
		setAuthorTdHide();
		setDescTdHide();
		setDocTrSort();
	}
	//���ĵ��Ƿ����ӹ�
	function ifSetDoc(docid){
		for(var i=0;i<tr_docids.length;i++){
			if(tr_docids[i]==docid){
				return true;
			}
		}
		return false;
	}
	//ɾ������Ҫ���͵��ĵ�
	function removeSetDoc(docidss){
		if(tr_docids.length>0){
			for(var i=0;i<tr_docids.length;i++){
				var ifExist = false;
				for(var j=0;j<docidss.length;j++){
					var docid = docidss[j];
					if(tr_docids[i]=="0"||tr_docids[i]==docid){
						ifExist = true;//���ĵ�������
					}
				}
				if(!ifExist){//�ĵ���������ɾ������
					$("#tr_"+tr_docids[i]).remove();
					tr_docids[i] = "0";
				}
			}
		}
	}
	//����
	function setDocTrSort(){
		$(".doctr").each(function(i){
			var docid = $(this).attr("docid");
			$("#sort_"+docid).html(i+1);
		});
	}
	//��������һ���Ƿ�չʾ
	function setAuthorTdHide(){
		var sendType = $("input[name='sendType']:checked").val();
		if(sendType==12){
			$(".authorTd").show();
		}else{
			$(".authorTd").hide();
		}
	}
	//����ժҪһ���Ƿ�չʾ
	function setDescTdHide(){
		if($(".doctr").length>1){
			$(".descTd").hide();
		}else{
			$(".descTd").show();
		}
	}
	//�ϴ�ͼƬ
	function uploadImage(index){
		if(index<$(".doctr").length){
			$(".doctr").each(function(i){
				if(index == i){
					imageIndex++;
					var docid = $(this).attr("docid");
					var oUploader = window[$("#upimagediv_"+docid).attr("oUploaderIndex")];
					if(oUploader.getStats().files_queued > 0){
						oUploader.startUpload();
					}else{
						uploadImage(imageIndex);
					}
				}
			});
		}else{
			var newjsondata = getJsonData();
			sendMsg(newjsondata);
		}	
	}
	//��ȡ������ĵ���Ϣƴ��JSON�����ʽ
	function getJsonData(){
		var newjsondata = [];
		$(".doctr").each(function(i){
			var docid = $(this).attr("docid");
			var newtitle = $("#title_"+docid).val();
			var newauthor = $("#author_"+docid).val();
			var newdesc = $("#desc_"+docid).val();
			var newimage = $("#image_"+docid).val();
			var json = {};
			json.docid = docid;
			json.newtitle = newtitle;
			json.newauthor = newauthor;
			json.newdesc = newdesc;
			json.newimage = newimage;
			newjsondata.push(json);
		});
		return newjsondata;
	}
	//ִ�з�����Ϣ����
	function sendMsg(newjsondata){
		var sendType = $("input[name='sendType']:checked").val();
		
		var msgtps = "";
		if($(".sendRule_"+sendType).length>0){
			$("input[name='sendRule"+sendType+"']:checked").each(function(){
				var value = $(this).val();
				msgtps +=","+value;
			});
		}
		if(msgtps==""){
			alert("��ѡ������Ŀ��");
			return false;
		}else{
			msgtps = msgtps+",";
		}
		
		var userids = $("#userids").val();
		var sendContent = $.trim($("#sendContent").val());
		
		var docids = $("#docids").val();
		var ifAllOAUser = $("#allOAUserRadio").is(":checked");
		var ifAllWxUser = $("#allWxUserRadio").is(":checked");
		if(userids==""&&!ifAllOAUser&&!ifAllWxUser){
			alert("��ѡ�������");
			return;
		}
		if(sendType==3){//������Ϣ
			if(sendContent==""){
				alert("�����뷢�͵���������");
				return;
			}
		}else{
			if(docids==""){
				alert("��ѡ���ĵ�");
				return;
			}
		}
		if(ifAllWxUser){//΢������Ⱥ�� ���ݷ��͵���Ѷ
			userids = "@all";
		}else if(ifAllOAUser){//�ĵ�Ⱥ�� ��������
			userids = "@alldepart";
		}
		var userNames = $("#userNames").html();
		var docNames = $("#docNames").html();
		var ifSafe = $("input[name='ifSafe']:checked").val();
		var ifReback = $("input[name='ifReback']:checked").val();
		if(sendType==13){//�ĵ�Ⱥ��
			ifSafe = 0;
			ifReback = 0;
		}
		$("#addMConfigDiv").showLoading();
		$.ajax({
			url:"Operation.jsp",
			type:"post",
			contentType : "application/x-www-form-urlencoded;charset=UTF-8",
			data:{"operate":"sendMsg","userids":userids,"userNames":encodeURIComponent(userNames),"ifSafe":ifSafe,
				  "sendContent":encodeURIComponent(sendContent),"docids":docids,"docNames":encodeURIComponent(docNames),"sendType":sendType,
				  "ifReback":ifReback,"msgtps":msgtps,"jsonData":encodeURIComponent(JSON2.stringify(newjsondata))
				},
			dataType:"json",
			success:function(data){
				if(data.status==0){
					alert("���ͳɹ�");
					location.href = "sendMsg.jsp?sendType="+sendType;
				}else{
					alert(data.msg);
				}
			},
			complete:function(){
				$("#addMConfigDiv").hideLoading();
			}
		});
	}
</script>
</body>
</HTML>