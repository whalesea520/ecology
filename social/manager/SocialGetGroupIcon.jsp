
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rci" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
 <%
 String discussid=Util.null2String(request.getParameter("discussid")); 
 String defaultUrl="/social/images/head_group.png";
 String strSql="select * from ofgroupprop where name = 'group_icon_prop' and groupName ='"+discussid+"'"; 
 rs.executeSql(strSql);
 if(rs.next()){
	 String groupIcon =Util.null2String(rs.getString("propValue"));
	 defaultUrl ="/weaver/weaver.file.FileDownload?fileid="+groupIcon;	 
 }
 String titlename = SystemEnv.getHtmlLabelName(803,user.getLanguage());
 %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(24504,user.getLanguage())+",javascript:doApply();,_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(24505,user.getLanguage())+",javascript:reSelect();,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<HTML>
	<HEAD>	
		<LINK REL="stylesheet" type="text/css" HREF="/css/Weaver_wev8.css">
		<script type="text/javascript" src="/social/js/jquery.form/jquery.form.min.js"></script>
		<script type="text/javascript">
			var parentWin = parent.parent.getParentWindow(parent);
			var dialog = parent.parent.getDialog(parent);
		</script>
	</HEAD>
	<div class="zDialog_div_content">
	<body style="margin: 0px;padding: 0px;overflow: hidden;">
	<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td>
			</td>
			<td class="rightSearchSpan" style="text-align:right;">
				<input type=button class="e8_btn_top" onclick="doApply()" value="<%=SystemEnv.getHtmlLabelName(24504, user.getLanguage())%>">
				<input type=button class="e8_btn_top" onclick="reSelect()" value="<%=SystemEnv.getHtmlLabelName(24505, user.getLanguage())%>">
				<input type=button class="e8_btn_top" onclick="dodelete()" value="<%=SystemEnv.getHtmlLabelNames("91,24513", user.getLanguage())%>">
				<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
			</td>
		</tr>
	</table>
	<form id= 'frmMain' name="frmMain" method="post" action="/social/SocialUploadOperate.jsp" enctype="multipart/form-data">
		<input name="uploadType" value="image" type="hidden"/>
		<input type="hidden" name="imagefileid" id="imagefileid"/>	
		<input type="hidden" name="formatWidth" id="formatWidth"/>	
		<input type="hidden" name="formatHeight" id="formatHeight"/>  
		<wea:layout>	
			<wea:group context='<%=SystemEnv.getHtmlLabelName(1361, user.getLanguage())%>' attributes="{'groupDisplay':'none'}">
			<wea:item><%=SystemEnv.getHtmlLabelName(24502, user.getLanguage())%></wea:item>	
			<wea:item>
				<div id="divSelected"><input class="url" id="Filedata"  type="file" name="Filedata"></div>
				<div  id="divInfo" style="display:none"> <%=SystemEnv.getHtmlLabelName(24503, user.getLanguage())%></div>		
			</wea:item>
			<wea:item attributes="{'isTableList':'true'}">
				<table style="width: 100%;height:310px">
					<tr>
						<td style="width: 100%;height: 100%;vertical-align: top;">			  												
							<iframe id="ifrmSrcImg" src="" name="ifrmSrcImg" 
							 style="border:1px solid #DDDDDD;" height="100%" width="100%" BORDER="0" 
							 FRAMEBORDER="no" NORESIZE="NORESIZE" scrolling="auto">
							</iframe>	
						</td>
						<td style="width: 2%"></td>
						<td style="width: 18%;vertical-align: top;">
							<div id="divSelect">							
								<div id="divTargetImg" style="border:1px solid #DDDDDD;height:102px;width:102px;background:#ffffff;overflow:hidden"></div>
								<div style="height: 5px"></div>
								x1:<input name="x1" style="width:25px">&nbsp;&nbsp;
								y1:<input name="y1"  style="width:25px">
								<div style="height: 5px"></div>
								x2:<input name="x2"  style="width:25px">&nbsp;&nbsp;
								y2:<input name="y2"  style="width:25px">
							</div>	
						</td>		
			</wea:item>
		</wea:group>
		</wea:layout>
		</form>
		</div>
		<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout type="2col">
	    <wea:group context="">
	    	<wea:item type="toolbar">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand();">	
	    	</wea:item>
	   	</wea:group>
	  </wea:layout>
	</div>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
	</body>
</HTML>
<SCRIPT LANGUAGE="JavaScript">
	$(document).ready( function() {
	parentwin = top.topWin.Dialog._Array[0].openerWin;
	client = parentwin.client;	
		$("#Filedata").change( function() {			
			var imgUrl=this.value;			
			if(imgUrl!=''){
				if(imgUrl.toLowerCase().indexOf(".gif")==-1 && imgUrl.toLowerCase().indexOf("jpg")==-1) {
					reSelect();
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(24506, user.getLanguage())%>。");
					return;
				}		
				$("#divSelected").hide();				
				$("#divInfo").show();
				$(ifrmSrcImg.document.body).append("<img src='/images/messageimages/loading_wev8.gif'/><%=SystemEnv.getHtmlLabelName(19819, user.getLanguage())%>...");

				$('input[name=x1]').val('0');
				$('input[name=y1]').val('0');
				$('input[name=x2]').val('100');
				$('input[name=y2]').val('100');							
				frmMain.target="ifrmSrcImg";
				frmMain.action="SocialGetGroupIconOnlyImg.jsp?method=preview";
				frmMain.submit();
			}			
		});
		showDefaultImage(); 			
	});

	
	function doApply(){
		var srcUrl=frmMain.Filedata.value;		
		if($.trim(srcUrl.value)==""&&$.trim($("#divSelected").css("display"))!="none"){
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(24506, user.getLanguage())%>");
			return;
		} else if (srcUrl.toLowerCase().indexOf(".gif")==-1 && srcUrl.toLowerCase().indexOf("jpg")==-1){
			reSelect();
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(24506, user.getLanguage())%>。");
			return;
		} else {			
			$('input[name=formatWidth]').val(jQuery("#ferret",ifrmSrcImg.document).width());
			$('input[name=formatHeight]').val(jQuery("#ferret",ifrmSrcImg.document).height());
			$("#frmMain").ajaxSubmit({
				url:'SocialGetGroupIconOnlyImg.jsp?method=setGroupIcon&discussid=<%=discussid %>',
				success:function(data){
					try{
					var data = eval("("+data+")")
					}catch(e){}
					if(data.issuccess=="1"){
					if(window.top.ChatUtil.isFromPc()&&window.top.WindowDepartUtil.isAllowWinDepart()){
                    window.top.ClientUtil.setDiscussionIcon('<%=discussid %>',""+data.imagefileid,function(info){
                            if(info){
                                dialog.closeByHand();
                            }
                        })
                    }else{
                    client.setDiscussionIcon('<%=discussid %>',""+data.imagefileid,function(info){
                            if(info){
                                dialog.closeByHand();
                            }
                        })
                    }
					}
				}
			});
			 
		}
	}

	function reSelect(){
		window.location.replace(window.location.href);
	}
	function showDefaultImage(){
		frmMain.target="ifrmSrcImg";
		frmMain.action="SocialGetGroupIconSub.jsp?defaultimageUrl=<%=defaultUrl%>";
		frmMain.submit();
	}
	function dodelete(){
		window.top.Dialog.confirm('<%=SystemEnv.getHtmlLabelName(30952, user.getLanguage())%>',
		function(){
		        if(window.top.ChatUtil.isFromPc()&&window.top.WindowDepartUtil.isAllowWinDepart()){
		            window.top.ClientUtil.setDiscussionIcon('<%=discussid %>',"",function(info){
                            if(info){
                                dialog.closeByHand();
                            }
                        })
		        }else{
		            client.setDiscussionIcon('<%=discussid %>',"",function(info){
                            if(info){
                                dialog.closeByHand();
                            }
                        })
		        }
				
			})
		}

</script>
