<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@ page import="weaver.hrm.*" %>
<%@ page import="java.io.*"%>
<%@ page import="weaver.general.GCONST"%>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="TransUtil" class="weaver.wxinterface.TransUtil" scope="page" />
<%
	response.setHeader("cache-control", "no-cache");
	response.setHeader("pragma", "no-cache");
	response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
	
	User user = HrmUserVarify.getUser (request , response) ;
	if(user==null){
		return;
	}
	if(user.getUID()!=1){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	
	String docbpage = "/wxinterface/util/MutilCategoryBrowser.jsp";
	File bf = new File(GCONST.getRootPath()+"docs"+File.separatorChar+"category"+File.separatorChar+"MultiCategoryMBrowser.jsp");
	if(bf.exists()){
		docbpage = "/wxinterface/util/MultiCategoryMBrowser.jsp";
	}
	
	String name= Util.null2String(request.getParameter("name"));

	String backfields = " id,name,type,ifrepeat,typeids,flowsordocs,names,msgtpids,msgtpnames,freqtime,isenable";
	String fromSql = " WX_MsgRuleSetting ";
	String sqlWhere = " where 1=1";
	if(!"".equals(name)){
		sqlWhere += " and name like '%"+name+"%'";
	}
	
	String sql = "select "+ backfields + " from " + fromSql + sqlWhere + " order by type,id";
	
%>
<HTML>
	<head>
		<title>΢����Ϣ��������</title>
		
		<script type='text/javascript' src="../js/jquery-1.8.3.min.js"></script>
	 	<script type='text/javascript' src="../js/jquery.form.js"></script>
		
		<link rel="stylesheet" href="../js/showLoading/css/showLoading.css">
		<script type='text/javascript' src="../js/showLoading/js/jquery.showLoading.js"></script>
		
		<link rel="stylesheet" href="../js/zdialog/zDialog_e8.css" />
		<script type='text/javascript' src="../js/zdialog/zDialog.js"></script>
		<script type='text/javascript' src="../js/zdialog/zDrag.js"></script>
		<script type='text/javascript' src="../js/util.js?100"></script>
		<script type='text/javascript' src="../js/init.js"></script>
		
		<link rel="stylesheet" type="text/css" href="../css/main.css" />
		
		<link rel="stylesheet" href="../css/new.css?100" />
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
			.scroll{max-height: 100px;overflow: auto;}
		</style>
	</head>
	<body style="overflow: auto;">
		<form id="searchForm" name="searchForm" action="" method="post">
			<table style="width: 100%;">
				<colgroup>
					<col width="10px"/>
					<col width="*"/>
					<col width="10px"/>
				</colgroup>
				<tr>
					<td></td>
					<td>
						<div class="coboxhead" id="searchTable">
							<div class="co_tablogo"></div>
							<div class="co_ultab">
								<div class="co_navtab">΢����Ϣ��������</div>
								<div>
									<ul class="co_tab_menu" style="display: none;">
						   			</ul>
						   			<div class="co_outbox">
							   			<div class="co_rightBox">
							   				<div class="co_searchDiv" style="margin-right:4px;">
													<input type="text" id="searchText" name="name" value="<%=name%>"/>
													<div id="co_searchBtn"></div>
											</div>
								   			<div style="float:left;">
												<div class="co_btn" id="newAgent">�½�</div>
												<div class="co_btn" id="allDelete">����ɾ��</div>
											</div>
											<div style="float:left;">
												<div class="co_btn" id="scanlog">��Ϣ���ͼ�¼</div>
												<div class="co_btn" id="locationSetting">���ڵ���λ������</div>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
						<div class="co_tab_box" id="co_tab_box">
							<table class="datalist" width=100% border="0" cellspacing="0" cellpadding="0">
								<colgroup>
									<col width="40px"/>
									<col width="15%"/>
									<col width="6%"/>
									<col width="20%"/>
									<col width="*"/>
									<col width="60px"/>
								</colgroup>
								<tr class="head">
									<td style="text-align: center;"><input type="checkbox" id="checkall" onclick="checkAll()"/></td>
									<td>����</td>
									<td>����</td>
									<td>������Ϣ����</td>
									<td>��������</td>
									<td>�Ƿ�����</td>
								</tr>
							<%
								int isenable = 1;
								rs.executeSql(sql);
								while(rs.next()){
									isenable = Util.getIntValue(rs.getString("isenable"),0);
							%>
								<tr>
									<td style="text-align: center;"><input type="checkbox" class="check" _val="<%=Util.null2String(rs.getString("id")) %>"/></td>
									<td><%=TransUtil.getCoWeChatFunctionLink(Util.null2String(rs.getString("id")), Util.null2String(rs.getString("name"))) %></td>
									<td><%=TransUtil.getWDTypeName(Util.null2String(rs.getString("type"))) %></td>
									<td><%=Util.null2String(rs.getString("msgtpnames")) %></td>
									<td>
										<div class="scroll">
											<%=Util.null2String(rs.getString("names")) %>
										</div>
									</td>
									<td><%if(isenable==1){ %>��<%}else{ %>��<%} %></td>
								</tr>
							<%	} %>
								<%-- <tr>
									<td valign="top">
										<%//xTable.myToString("5")%>			
									</td>
								</tr> --%>
							</table>
						</div>
					</td>
					<td></td>
				</tr>
			
			</table>
			
			
		</form>
		
		<div id="addMConfigDiv" style="position:relative ;display:none;">
			<div class="coboxhead">
				<div class="co_tablogo"></div>
				<div class="co_ultab">
					<div class="co_navtab">�½�����</div>
					<div>
						<ul class="co_tab_menu" style="width:453px;display: none;"></ul>
			   			<div class="co_outbox">
				   			<div class="co_rightBox">
					   			<div>
									<div class="co_btn saveMConfig">����</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="co_tab_box" id="openDiv" style="overflow:auto;height:300px;">
				<form action="Operation.jsp" method="post" id="addForm">
				<input type="hidden" name="operate" value="addmsgrule"/>
				<input type="hidden" name="fdid" id="fdid" value=""/>
				<div class="addTableDiv">
					<table class="co_tblForm">
						<colgroup><col width="25%" /><col width="75%" /></colgroup>
						<tr>
							<td class="title">��ʾ����</td>
							<td class="data">
						  		<input type="text" id="name" class="input_def" name="name" placeholder="��������ʾ����"/>
						  	</td>
						</tr>
						<tr>
							<td class="title">����</td>
							<td class="data">
								<select id="type" name="type">
									<option value="1">����</option>
									<option value="2">�ĵ�</option>
									<option value="3">��Ϣ</option>
									<option value="4">Э��</option>
									<option value="5">�ճ�</option>
									<option value="6">����</option>
									<!-- 
									<option value="7">��Ŀ</option>
									 -->
									<option value="8">�ͻ�</option>
									<option value="9">����</option>
									<option value="10">΢��</option>
									<option value="11">�ʼ�</option>
								</select>
								
								<span id="typemsg" style="color:green;padding-left:4px;"></span>
						  	</td>
						</tr>
						<tr id="remindTypeTr" class="dynTr" style="display:none;">
							<td class="title">���ѷ�ʽ</td>
							<td class="data">
								<select id="remindType" name="remindtype">
									<option value="1">�µ���</option>
									<option value="2">��ʼǰ</option>
								</select>
							</td>
						</tr>
						<tr id="remindTypeForXzTr" class="dynTr" style="display:none;">
							<td class="title">���ѷ�ʽ</td>
							<td class="data">
								<input type="checkbox" class="rtfx" name="remindTypeForXz" value="1"/>��Э��
								<input type="checkbox" class="rtfx" name="remindTypeForXz" value="2"/>�½���
								<input type="checkbox" class="rtfx" name="remindTypeForXz" value="3"/>�»ظ�
							</td>
						</tr>	
						<tr id="timeBeforeTr" class="dynTr" style="display:none;">
							<td class="title">��ǰ֪ͨʱ��</td>
							<td class="data">
						  		<input type="text" style="width:60px;" id="timeBefore" class="input_def" name="timeBefore"/>&nbsp;&nbsp;����
						  	</td>
						</tr>
						<tr id="docTr" class="dynTr" style="display:none;">
							<td class="title">�Ƿ����������޸ĺ��ĵ�</td>
							<td class="data">
								<select id="ifrepeat" name="ifrepeat">
									<option value="1">��</option>
									<option value="2">��</option>
								</select>
							</td>
						</tr>	
						<tr id="docTr3" class="dynTr" style="display:none;">
							<td class="title">�Ƿ����͸��Ѳ��ĵ���Ա</td>
							<td class="data">
								<select id="iftoall" name="iftoall">
									<option value="2">��</option>
									<option value="1">��</option>
								</select>
							</td>
						</tr>	
						<tr id="docTr2" class="dynTr" style="display:none;">
							<td class="title">����ɨ��Ƶ��</td>
							<td class="data">
								<select id="freqtime" name="freqtime">
									<option value="10">10</option>
									<option value="20">20</option>
									<option value="30">30</option>
								</select>&nbsp;&nbsp;����
							</td>
						</tr>	
						<tr>
							<td class="title">������Ϣ����
							<input type="hidden" id="msgtpid"/>
							</td>
							<td class="data" id="msgtpTd">
								
							</td>
						</tr>
						<tr id="csetting"  class="dynTr">
							<td class="title">��������</td>
							<td class="data" >
								<input type="hidden" id="types" name="types"/>
								<input type="hidden" id="flows" name="flows"/>
								<span class="mcBrowser" style="display: inline-block;"></span>
								<span id="names"></span>
								
								<input type="checkbox" id="isall" name="isall" style="margin-left: 10px;"/>ȫ��
							</td>
						</tr>
						<tr>
							<td class="title">�Ƿ�����</td>
							<td class="data">
								<select id="isenable" name="isenable">
									<option value="1">��</option>
									<option value="0">��</option>
								</select>
							</td>
						</tr>
					</table>
				</div>
				</form>
			</div>
			<div class="co_dialog_bottom">
				<table width="100%">
					<tr>
						<td align="right">
							<div class="co_dig_btn saveMConfig">����</div>
						</td >
						<td align="left">
							<div class="co_dig_btn" id="closeDialog">�ر�</div>
						</td>
					</tr>
				</table>
			</div>
		</div>
		
		<script type="text/javascript">
			$(document).ready(function(){
				
				$("#newAgent").click(function(){
					reset();
					openDialog("�½�����","",1,"addMConfigDiv");
				});
				  
				$("#allDelete").click(function(){//ȫ��ɾ����ť��������
					deleteBatch();
				});
				$("#co_searchBtn").click(function(){
					doSearch();
				});
				
				$("#remindType").change(function(){
					var value = $(this).val();
					if(value==1){
						$("#timeBeforeTr").hide();
					}else{
						$("#timeBeforeTr").show();
					}
				});
				
				$("#type").change(function(){
					$("#flows").val("");
					$("#names").html("");
					$("#types").val("");
					var type = $(this).val();
					$(".dynTr").hide();
					if(type==1){
						$("#docTr3").hide();
						$("#csetting").show();
						
						$("#typemsg").html("����ϵͳ�����̵����ѹ���");
					}else if(type==2){
						$("#docTr").show();
						$("#docTr2").show();
						$("#docTr3").show();
						$("#csetting").show();
						
						$("#typemsg").html("����ϵͳ���ĵ������ѹ���");
					}else if(type==3){
						$("#typemsg").html("����ϵͳ������������Ϣ�����ѹ���");
					}else if(type==4){//Э��
						$("#remindTypeForXzTr").show();
						$("#docTr2").show();
						$("#typemsg").html("����ϵͳ��Э�������ѹ���");
					}else if(type==5||type==6){//�ճ� ����
						$("#remindTypeTr").show();
						$("#remindType").change();
						$("#docTr2").show();
						$("#typemsg").html("����ϵͳ��"+(type==5?"�ճ�":"����")+"�����ѹ���");
					}else{
						if(type!=9)//������Ҫ��ѭ
							$("#docTr2").show();
					}
				});
				
				$("#isall").bind("click",function(){
					if($(this).attr("checked")){
						var type = $("#type").val();
						if(type==1){
							$("#names").html("ȫ������");
						}else{
							$("#names").html("ȫ���ĵ�");
						}
						$("#flows").val("-1");
						$(".mcBrowser").hide();
					}else{
						$("#flows").val("");
						$("#names").html("");
						$(".mcBrowser").show();
					}
				});
				
				$(".mcBrowser").click(function(){
					var type = $("#type").val();
					var types = $("#types").val();
					var flows = $("#flows").val();
					if(type==1){
						openDialog2("������Դ","/wxinterface/data/workflowTree.jsp?types="+types+"&flows="+flows,0);
					}else if(type==2){
						var vbid = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=<%=docbpage%>?para="+flows,null,"dialogHeight=600px");
						if(vbid) {
							var ids = vbid.id+"";
							var names = vbid.name+"";
							try{
								if(ids.indexOf(",")==0) ids = ids.substring(1);
								if(names.indexOf(",")==0) names = names.substring(1);
							}catch(e){}
							if(ids!=""){
								$("#flows").val(ids);
								$("#names").html(names); 
							}else{
								$("#flows").val("");
								$("#names").html("");
							}
						}
					}
				});
				
				$(".saveMConfig").click(function(){
					var name = $.trim($("#name").val());
					if(name==""){
						CoDialog.alert("��ʾ���Ʋ���Ϊ��");
						return false;
					}
					if(getLength(name)>200){
						CoDialog.alert("��ʾ���Ʋ��ܴ���200���ַ�");
						return false;
					}
					var msgtpids = "",msgtpnames="";
					$("input[name=msgtpidss]:checked").each(function(){
						msgtpids +=","+$(this).val();
						msgtpnames +=","+$(this).attr("msgname");
					});
					if(msgtpids==""){
						CoDialog.alert("��ѡ�������Ϣ����");
						return false;
					}
					msgtpids += ",";
					msgtpnames = msgtpnames.substring(1);
					var flows = $("#flows").val();
					var type = $("#type").val();
					if(flows=="" && (type==1 || type==2)){
						CoDialog.alert("��ѡ����������");
						return false;
					}
					var remindType = $("#remindType").val();
					if(remindType==2&&(type==5||type==6)){
						var r = /^[0-9]*[1-9][0-9]*$/;
						var timeBefore = $.trim($("#timeBefore").val());
						if(isNaN(timeBefore)||!r.test(timeBefore)){
							CoDialog.alert("��ǰ֪ͨʱ������Ǵ���0������");
							return false;
						}
					}
					var remindTypeForXz = "";
					if(type==4){
						$("input[name=remindTypeForXz]:checked").each(function(){
							remindTypeForXz +=","+$(this).val();
						});
						if(remindTypeForXz==""){
							CoDialog.alert("��ѡ�����ѷ�ʽ");
							return false;
						}
						remindTypeForXz +=",";
					}
					$("#addMConfigDiv").showLoading();
					$("#addForm").ajaxSubmit({
						data:{"names":$("#names").html(),"msgtpids":msgtpids,"msgtpnames":msgtpnames,"rtfx":remindTypeForXz},
						dataType:"json",
						success:function(data){
							if(data.status==0){
								CoDialog.alert("����ɹ�");
								reset();
								dlg.close();
								onRefresh();
							}else{
								CoDialog.alert(data.msg);
							}
						},
						complete:function(){
							$("#addMConfigDiv").hideLoading();
						}
					});
				});
				
				$("#locationSetting").click(function(){
					location.href = "locationSetting.jsp";
				});
				$("#scanlog").click(function(){
					location.href = "scanlog.jsp";
				});
				
				getMsgTp();
			});
			
			function checkAll(){
				if($("#checkall").attr("checked")){
					$(".check").attr("checked",true);
				}else{
					$(".check").attr("checked",false);
				}
			}
			
			function reset(){
				$("#fdid").val("");
				$("#name").val("");
				$("#type").val("1").change();
				$("#remindType").val("1").change();
				$("#timeBefore").val("");
				$("#types").val("");
				$("#flows").val("");
				$("#names").html("");
				$("#cowechatid").val("");
				$(".msgtpids").attr("checked",false);
				$(".rtfx").attr("checked",false);
			}
			
		   	document.onkeydown=keyListener;
			function keyListener(e){
			    e = e ? e : event;   
			    if(e.keyCode == 13){
			    	doSearch();
			    }    
			}
			function doSearch(){
				$("#searchForm").submit();
			}
			
			function onRefresh(){
				//_table.refresh();
				window.location.reload();
			}
			
			function doSetCoWechatFunction(id) {
				reset();
				$.ajax({
					url:"Operation.jsp?t="+new Date().getTime(),
					data:{"id":id,"operate":"getmsgrule"},
					dataType:"json",
					success:function(data){
						if(data.status==0){
							$("#fdid").val(data.id);
							$("#name").val(data.name);
							$("#type").val(data.type).change();
							$("#ifrepeat").val(data.ifrepeat);
							$("#iftoall").val(data.iftoall);
							$("#msgtpid").val(data.msgtpids);
							$("#types").val(data.types);
							$("#flows").val(data.flows);
							$("#names").html(data.names);
							$("#freqtime").val(data.freqtime);
							$("#isenable").val(data.isenable);
							if(data.flows=="-1"){
								$("#isall").attr("checked",true);
								$(".mcBrowser").hide();
							}else{
								$("#isall").attr("checked",false);
								$(".mcBrowser").show();
							}
							if(data.type==5||data.type==6){
								$("#remindType").val(data.types).change();
								$("#timeBefore").val(data.ifrepeat);
							}else if(data.type==4){
								$(".rtfx").each(function(){
									if(data.types.indexOf(","+$(this).val()+",")>-1){
										$(this).attr("checked",true);
									}
								});
							}
							var msgtpids = $("#msgtpid").val();
							$(".msgtpids").each(function(){
								if(msgtpids.indexOf(","+$(this).val()+",")>-1){
									$(this).attr("checked",true);
								}
							});
							
							openDialog("�༭����","",1,"addMConfigDiv");
						}else{
							CoDialog.alert(data.msg);
						}
					}
				});
			}
			
			function getMsgTp(){
				$.ajax({
					url:"Operation.jsp",
					data:{"operate":"getMsgTp"},
					dataType:"json",
					success:function(data){
						if(data.status==0){
							var temp = "";
							for(var i=0;i<data.msgtps.length;i++){
								var mt = data.msgtps[i];
								temp+='<input type="checkbox" msgname="'+mt.name+'" class="msgtpids" name="msgtpidss" value="'+mt.id+'"/>'+mt.name+'&nbsp;&nbsp;';
							}
							$("#msgtpTd").html(temp);
							var msgtpids = $("#msgtpid").val();
							$(".msgtpids").each(function(){
								if(msgtpids.indexOf(","+$(this).val()+",")>-1){
									$(this).attr("checked",true);
								}
							});
						}else if(data.status==2){
							$("#msgtpTd").html("<span style='color:red'>��ȡģ�����ݳ������⣬��ȷ�϶�Ӧ��΢�ż���ƽ̨���������ʲ�������������״̬�ġ��ⲿϵͳ��Ϣģ�塿��</span>");
						}else{
							CoDialog.alert(data.msg);
						}
					}
				});
			}
			
			function getLength(value){
				var length = value.length;
			 	for ( var i = 0; i < value.length; i++) {
			 		if (value.charCodeAt(i) > 127) {
			 			length++;
			 		}
			 	}
			 	return length;
			}	
			
			function doDelete(ids) {
				CoDialog.confirm("ȷ��ɾ����������?",function(){
					$("#co_tab_box").showLoading();
					jQuery.ajax({
						type: "post",
						url: "Operation.jsp",
					    data:{"operate":"delmsgrule","ids":ids},
					    dataType:"json",
					    success:function(data){
					    	if(data.status==0){
					    		//onRefresh();
					    		$(".check:checked").parent().parent("tr").remove();
					    	}else{
					    		CoDialog.alert(data.msg);
					    	}
					    },
					    complete: function(data){
						    $("#co_tab_box").hideLoading();
					    }
				    });
				});
			}
			
			function deleteBatch(){
				/* var selectedIds = _table._xtable_CheckedCheckboxId();
				if(selectedIds == ""){
					CoDialog.alert("��ѡ��Ҫɾ��������!");
					return;
				}else{
					selectedIds = selectedIds.substring(0,selectedIds.length-1);
				} */
				var selectedIds = "";
				$(".check:checked").each(function(){
					if($(this).attr("_val")!=""){
						selectedIds += "," + $(this).attr("_val");
					}
				});
				if(selectedIds == ""){
					CoDialog.alert("��ѡ��Ҫɾ��������!");
					return;
				}else{
					selectedIds = selectedIds.substring(1);
				}
				doDelete(selectedIds);
			}
			
			var dlg2=null;
			function openDialog2(title,url,type,eid,width,height) {
				dlg2 = new CoDialog();
				dlg2.currentWindow = window;
				dlg2.Model=true;
				if(typeof(width)=="undefined"){
					dlg2.Width=500;//���峤��
				}else{
					dlg2.Width=width;//���峤��
				}
				if(typeof(height)=="undefined"){
					dlg2.Height=400;
				}else{
					dlg2.Height=height;
				}
				if(type==0){
					dlg2.URL=url;
				}else{
					dlg2.InvokeElementId=eid;
				}
				dlg2.Title=title;
				dlg2.maxiumnable=true;
				dlg2.show();
			}
		</script>
	</body>
</html>