<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%
	User user = HrmUserVarify.getUser (request , response) ;
	if(user == null)  return ;
	String relationArr[] = new String[]{"15556","15557","15558","125399","125400","125401"};
	String eh_fromcreate = Util.null2String(request.getParameter("eh_fromcreate"));
%>
<style type="text/css">
.pageMasking{
	width:100%; height:100%; top:0px; left:0px;
	position:absolute; z-index:99; background-color:rgb(51, 51, 51); opacity:0.2;display:none;
}
.showWin{
	width:95%; top:50px; left:8px; position:absolute; z-index:999;display:none;
	-webkit-user-select:none; onselectstart:none;<!--禁止页面选中 -->
	
}
.showWin_masking{
	width:95%; position:absolute; z-index:9999; background-color:rgb(51, 51, 51); opacity:0.2;
	display:none; text-align:center; font-size:16px; color:#eeefff;
}
.winHead{
	height:40px; line-height:40px; color:#ffffff;
	background:#017bfd; border-top-left-radius:8px; border-top-right-radius:8px;
}
.winHead_title{
	width:70%; float:left; padding-left:12px; font-size:16px;
}
.winHead_close{
	width:32px; float:right; font-size:18px; font-weight:bold; cursor:pointer;
}
.winContent{
	background:#f1f6f7;
}
.operatorArea{
	width:100%; font-size:16px; color:#848484; padding-top:2px;
}
.operatorArea .oper_title{
	float:left; width:120px; height:32px; line-height:32px; padding-left:12px; 
}
.operatorArea .oper_info{
	float:right; height:32px; line-height:32px;
}
.operatorArea .oper_choose{
	float:right; padding:4px 12px 0px 12px; cursor:pointer;
}
.operatorArea .oper_add{
	clear:both; height:62px; padding-left:14px;
}
.operatorArea .oper_add_img{
	cursor:pointer; margin-top:4px;
}
.operatorArea .oper_show{
	clear:both; height:62px; padding-left:8px; display:none;
}
.operatorArea .singleUser{
	float:left; width:56px; text-align:center; font-size:12px;
}
.operatorArea .userHead{
	width:36px; height:36px; border-radius:18px; margin-top:4px; margin-bottom:2px; 
}
.operatorArea .userName{
	white-space:nowrap; text-overflow:ellipsis; overflow:hidden;
}
.relationTitle{
	height:32px; line-height:32px; padding-left:12px; font-size:16px; color:#848484;
}
.singleRelation{
	height:52px; padding-left:14px;
}
.showInfo{
	float:left; padding-top:4px; padding-bottom:2px;
}
.showInfo .showInfo_top{
	height:24px; line-height:24px; font-size:14px; color:#3f3f3f;
}
.showInfo .showInfo_bottom{
	height:22px; line-height:22px; font-size:12px; color:#afafaf;
}
.checkMark{
	float:right; margin:12px 6px 4px 4px;
}
.btnArea{
	height:40px; width:100%; margin-top:16px;
}
.btnDiv{
	width:200px; margin-left:auto; margin-right:auto;
}
.operBtn{
	width:70px; height:30px; line-height:30px; text-align:center; float:left;
	border-radius:5px; margin-left:15px; margin-right:15px; cursor:pointer; font-size:14px; color:#ffffff;
}

.borderbottom1{border-bottom:1px solid #dee1e1;}
.splitLine{background:#e7e7e7; height:1px; margin-left:12px;}
.bgcolor1{background:#ffffff;}
.bgcolor2{background:#017bfd;}
.bgcolor3{background:#aebdc9;}
</style>
<div class="pageMasking"></div>
<div class="showWin_masking">
<%=SystemEnv.getHtmlLabelName(84567, user.getLanguage()) %>
</div>
<div class="showWin">
	<div class="winHead">
		<div class="winHead_title">
			<%=SystemEnv.getHtmlLabelNames("172,124958", user.getLanguage()) %>
		</div>
		<div class="winHead_close" onclick="javascript:doCancel();">×</div>
	</div>
	<div class="winContent">
		<div class="operatorArea borderbottom1 bgcolor1">
			<div class="oper_title">
				<%=SystemEnv.getHtmlLabelName(99, user.getLanguage()) %>
			</div>
			<div class="oper_choose">
				<img src="/mobile/plugin/images/chooseOperBtn_wev8.png" style="height:22px;"/>
			</div>
			<div class="oper_info">
				<span id="operatorsNum">0</span>人
			</div>
			<div class="oper_add">
				<img class="oper_add_img" src="/mobile/plugin/images/addOperator_wev8.png"/>
			</div>
			<div class="oper_show"></div>
		</div>
		<div class="relationTitle borderbottom1">
			<%=SystemEnv.getHtmlLabelName(21790, user.getLanguage()) %>
		</div>
		<div class="relationArea borderbottom1 bgcolor1">
			<%for(int i=0; i<3; i++){ %>
				<div class="singleRelation" target="<%=i %>">
					<div class="showInfo">
						<div class="showInfo_top">
							<%=SystemEnv.getHtmlLabelNames(relationArr[i], user.getLanguage()) %>
						</div>
						<div class="showInfo_bottom">
							<%=SystemEnv.getHtmlLabelNames(relationArr[i+3], user.getLanguage()) %>
						</div>
					</div>
					<div class="checkMark" style="<%=i!=0?"display:none":"" %>">
						<img src="/mobile/plugin/images/check_wev8.png" style="width:28px;" />
					</div>
				</div>
				<%if(i<2){ %>
				<div class="splitLine"></div>
				<%} %>
			<%} %>
		</div>
		<div class="btnArea">
			<div class="btnDiv">
				<div class="operBtn bgcolor2" onclick="javascript:doConfirm();">
					<%=SystemEnv.getHtmlLabelName(615,user.getLanguage()) %>
				</div>
				<div class="operBtn bgcolor3" onclick="javascript:doCancel();">
					<%=SystemEnv.getHtmlLabelName(201,user.getLanguage()) %>
				</div>
			</div>
		</div>
	</div>
</div>
<script type="text/javascript">
	var maxOperNum = 0;		//显示头像最大个数
	jQuery(document).ready(function(){
		if(jQuery("#fromPage").val() == "client.jsp"){
			try{
				controlBottomOperArea("hidden");
				hiddenSubmitWaitInfo();
			}catch(e){}
		}
		jQuery("#view_page").css("height", "100%").css("overflow","hidden");
		//jQuery(".showWin").css("top", (jQuery(".pageMasking").height()-jQuery(".showWin").height())/2);
		jQuery(".showWin").css("left", (jQuery(".pageMasking").width()-jQuery(".showWin").width())/2);
		//生成提交隐藏域
		jQuery("form#workflowfrm").append('<input type="hidden" id="eh_fromcreate" name="eh_fromcreate" value="<%=eh_fromcreate %>" />');
		jQuery("form#workflowfrm").append('<input type="hidden" id="eh_setoperator" name="eh_setoperator" />');
		jQuery("form#workflowfrm").append('<input type="hidden" id="eh_relationship" name="eh_relationship" value="0" />');
		jQuery("form#workflowfrm").append('<input type="hidden" id="eh_operators" name="eh_operators" onchange="operatorChange();" />');
		//事件绑定
		jQuery(".singleRelation").click(function(){
			jQuery(".checkMark").hide();
			jQuery(this).find(".checkMark").show();
			jQuery("input#eh_relationship").val(jQuery(this).attr("target"));
		});
		jQuery(".oper_choose").add(".oper_add_img").click(function(){
			chooseOperators();
		});
		
		//计算最大显示人员头像个数
		var oper_showWidth = parseFloat(jQuery(".operatorArea").width())-10;
		maxOperNum = Math.floor(oper_showWidth/56);
		
		//客户端触屏效果
		jQuery(".singleRelation").each(function(){
			var obj = jQuery(this)[0];
			obj.addEventListener("touchstart",function(event){
				jQuery(this).css("background","#d7eeea");
			});
			obj.addEventListener("touchend",function(event){
				jQuery(this).css("background","#ffffff");
			});
		});
		var oper_show =jQuery(".oper_show")[0];
		oper_show.addEventListener("touchstart",function(event){
			jQuery(".operatorArea").css("background","#d7eeea");
		},false);
		oper_show.addEventListener("touchend",function(event){
			jQuery(".operatorArea").css("background","#ffffff");
			chooseOperators();
		},false);
	});
	
	function chooseOperators(){
		showDialog("/browser/dialog.do","&returnIdField=eh_operators&returnShowField=eh_operators_span&method=listUser&isMuti=1");
	}
	
	function operatorChange(){
		try{
			var eh_operators = jQuery("input#eh_operators").val();
			var ajaxUrl = "/mobile/plugin/1/workflowAjaxUrl.jsp?&operator="+eh_operators+"&random="+new Date().getTime();
			jQuery.ajax({
				type: "post",
				url: ajaxUrl,
				contentType : "application/x-www-form-urlencoded; charset=UTF-8",
				success: function(data){
					jQuery(".oper_show").html("");
					jQuery("#operatorsNum").text("0");
					data = data.trim();
					if(!!data && data !== "[]"){
						jQuery(".oper_add").hide();
						jQuery(".oper_show").show();
						
						var operJson = JSON.parse(data);
						var hasOperNum = operJson.length;
						jQuery("#operatorsNum").text(hasOperNum);
						for(var i=0; i<hasOperNum; i++){
							if(i >= maxOperNum)
								break;
							var operObj = operJson[i];
							var headUrl = !!operObj.messagerurl? operObj.messagerurl : "/messager/images/icon_w_wev8.jpg";
							var singleUser = jQuery("<div class='singleUser'><img class='userHead' src='"+headUrl+"' /><div class='userName'>"+operObj.operatname+"</div></div>");
							jQuery(".oper_show").append(singleUser);
						}
					}else{
						jQuery(".oper_add").show();
						jQuery(".oper_show").hide();
					}
				}
			});
		}catch(e){}
	}
	
	function doConfirm(){
		var eh_operators = jQuery("#eh_operators").val();
		if(eh_operators == null || eh_operators == ""){
			alert("<%=SystemEnv.getHtmlLabelName(125403,user.getLanguage()) %>");
			return;
		}
		jQuery("input#eh_setoperator").val("y");
		dosubmit_chooseOperator();
	}
	
	function doCancel(){
		jQuery("input#eh_setoperator").val("n");
		dosubmit_chooseOperator();
	}
	
	//模拟流程提交
	function dosubmit_chooseOperator(){
		showWinMarking();
		dosubback();
	}
	
	//遮罩并loading效果
	function showWinMarking(){
		var maskDiv = jQuery(".showWin_masking");
		var showWin = jQuery(".showWin");
		maskDiv.css("height", showWin.css("height")).css("line-height", showWin.css("height"))
			.css("top", showWin.css("top")).css("left", showWin.css("left"));
		maskDiv.show();
	}
	
	//客户端隐藏下方按钮及签字意见栏
	function controlBottomOperArea(par){
		var url = "emobile:controlBottomOperArea:"+par;	
    	location = url;
	} 
</script>