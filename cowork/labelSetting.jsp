
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.cowork.*" %> 
<%@ page import="weaver.file.FileUpload" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<jsp:useBean id="CoTypeComInfo" class="weaver.cowork.CoTypeComInfo" scope="page" />
<%
	int userid=user.getUID();//用户id
	FileUpload fu = new FileUpload(request);
	CoworkItemMarkOperation markOperation=new CoworkItemMarkOperation();
	List labelList=markOperation.getLabelList(""+userid,"setting");
%>
<html>
<head>
<title></title>
<LINK href="/css/Weaver_wev8.css" type='text/css' rel='STYLESHEET'>

<link href="/js/jquery/ui/jquery-ui_wev8.css" type="text/css" rel=stylesheet>
<script type="text/javascript" src="/js/jquery/ui/ui.core_wev8.js"></script>
<script type="text/javascript" src="/js/jquery/ui/ui.dialog_wev8.js"></script>
<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>

<script type="text/javascript" src="/cowork/js/coworkUtil_wev8.js"></script>

</head>
<body id="ViewCoWorkBody" style="overflow: auto;">
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(),_self} ";
	RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<style>
  #coloPanel .ListStyle tr{height:24px !important;}
  #coloPanel .ListStyle td{padding-left:2px !important;
                padding-right:2px !important;
                padding-top:0px !important;
                padding-bottom:0px !important;
  }
  #colorPicker td{width:20px !important;text-align:center;cursor:pointer}
	.hoverDivChild{
			color:#0071c2;
			filter: alpha(opacity = 100);
			-moz-opacity: 1;
			opacity: 1; 
			background-color:#b6e1fd;
	        overflow:hidden;   
	        z-index:10003;
	}
		
	.operHoverSpanChild{
		height:100%;
		width:40px;
		display:-moz-inline-box;
		display:inline-block;color:#656867;padding-left:5px;padding-right:5px;
	}
	.operHover_handChild{
		cursor:pointer;
	}
	.operHoverSpan_hoverChild{
		color:#0071c2;
	}
	
	.operHoverSpanChild a{
		text-decoration: none!important;
		color:gray!important;
	}
	
	.operHoverSpanChild a:hover{
		color:#0071c2!important;
	}
	
	.e8operateChild{
		background-image:url("/images/ecology8/operate_wev8.png");
		background-repeat:no-repeat;
		width:16px;
		background-position:50% 50%;
		height:25px;
		cursor:pointer;
		float:right;
	}

</style>



<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="collaboration"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(30884,user.getLanguage()) %>"/>
</jsp:include>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<span title="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" style="font-size: 12px;cursor: pointer;">
				<input class="e8_btn_top middle" onclick="doSave(this)" type="button"  value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>"/>
			</span>
			<span title="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(176,user.getLanguage()) %>" style="font-size: 12px;cursor: pointer;">
				<input class="e8_btn_top middle" onclick="addLabel('add')" type="button"  value="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(176,user.getLanguage()) %>"/>
			</span>
			<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage())%>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<div class="zDialog_div_content" style="height: 495px;">
<div id="coloPanel" title="<%=SystemEnv.getHtmlLabelName(22975,user.getLanguage())%>">
	<div id="colorPicker">
	    <table cellpadding="0" cellspacing="5" align="center">
	       <tr>
	          <td style="background-color: #dee5f2; color: #5a6986;" colorValue="#dee5f2" textColor="#5a6986" onclick="chooseColor(this)">a</td>
	          <td style="background-color: #e0ecff; color: #206cff;" colorValue="#e0ecff" textColor="#206cff" onclick="chooseColor(this)">a</td>
	          <td style="background-color: #dfe2ff; color: #0000cc;" colorValue="#dfe2ff" textColor="#0000cc" onclick="chooseColor(this)">a</td>
	          <td style="background-color: #e0d5f9; color: #5229a3;" colorValue="#e0d5f9" textColor="#5229a3" onclick="chooseColor(this)">a</td>
	          <td style="background-color: #fde9f4; color: #854f61;" colorValue="#fde9f4" textColor="#854f61" onclick="chooseColor(this)">a</td>
	          <td style="background-color: #ffe3e3; color: #cc0000;" colorValue="#ffe3e3" textColor="#cc0000" onclick="chooseColor(this)">a</td>
	       </tr>
	       <tr>
	          <td style="background-color: #5a6986; color: #dee5f2;" colorValue="#5a6986" textColor="#dee5f2" onclick="chooseColor(this)">a</td>
	          <td style="background-color: #206cff; color: #e0ecff;" colorValue="#206cff" textColor="#e0ecff" onclick="chooseColor(this)">a</td>
	          <td style="background-color: #0000cc; color: #dfe2ff;" colorValue="#0000cc" textColor="#dfe2ff" onclick="chooseColor(this)">a</td>
	          <td style="background-color: #5229a3; color: #e0d5f9;" colorValue="#5229a3" textColor="#e0d5f9" onclick="chooseColor(this)">a</td>
	          <td style="background-color: #854f61; color: #fde9f4;" colorValue="#854f61" textColor="#fde9f4" onclick="chooseColor(this)">a</td>
	          <td style="background-color: #cc0000; color: #ffe3e3;" colorValue="#cc0000" textColor="#ffe3e3" onclick="chooseColor(this)">a</td>
	       </tr>
	       <tr>
	          <td style="background-color: #fff0e1; color: #ec7000;" colorValue="#fff0e1" textColor="#ec7000" onclick="chooseColor(this)">a</td>
	          <td style="background-color: #fadcb3; color: #b36d00;" colorValue="#fadcb3" textColor="#b36d00" onclick="chooseColor(this)">a</td>
	          <td style="background-color: #f3e7b3; color: #ab8b00;" colorValue="#f3e7b3" textColor="#ab8b00" onclick="chooseColor(this)">a</td>
	          <td style="background-color: #ffffd4; color: #636330;" colorValue="#ffffd4" textColor="#636330" onclick="chooseColor(this)">a</td>
	          <td style="background-color: #f9ffef; color: #64992c;" colorValue="#f9ffef" textColor="#64992c" onclick="chooseColor(this)">a</td>
	          <td style="background-color: #f1f5ec; color: #006633;" colorValue="#f1f5ec" textColor="#006633" onclick="chooseColor(this)">a</td>
	       </tr>
	       <tr>
	          <td style="background-color: #ec7000; color: #fff0e1;" colorValue="#ec7000" textColor="#fff0e1" onclick="chooseColor(this)">a</td>
	          <td style="background-color: #b36d00; color: #fadcb3;" colorValue="#b36d00" textColor="#fadcb3" onclick="chooseColor(this)">a</td>
	          <td style="background-color: #ab8b00; color: #f3e7b3;" colorValue="#ab8b00" textColor="#f3e7b3" onclick="chooseColor(this)">a</td>
	          <td style="background-color: #636330; color: #ffffd4;" colorValue="#636330" textColor="#ffffd4" onclick="chooseColor(this)">a</td>
	          <td style="background-color: #64992c; color: #f9ffef;" colorValue="#64992c" textColor="#f9ffef" onclick="chooseColor(this)">a</td>
	          <td style="background-color: #006633; color: #f1f5ec;" colorValue="#006633" textColor="#f1f5ec" onclick="chooseColor(this)">a</td>
	       </tr>
	       
	    </table>
	</div>
	<div align="center"><input type="text" style="color: white;" id="txtColorTemp" size="20px"  /></div>
</div>

<form action="/cowork/CoworkItemMarkOperation.jsp"  id="labelForm" method="post">
<input type="hidden" name="type" value="setLabel">
<table id='list' class="ListStyle" cellspacing="1" style="margin:0px;width:100%;font-size: 12px;width: 98%;overflow: auto;" align="center">
	 	<colgroup>
		<col width="30%">
		<col width="25%">
		<col width="10%">
		<col width="15%">
		</colgroup>
		   <tr class="HeaderForXtalbe">
		      <th><%=SystemEnv.getHtmlLabelName(176,user.getLanguage())+SystemEnv.getHtmlLabelName(22009,user.getLanguage())%></th> <!-- 标签名称 -->
		      <th><%=SystemEnv.getHtmlLabelName(176,user.getLanguage())+SystemEnv.getHtmlLabelName(495,user.getLanguage())%></th><!-- 标签颜色 -->
		      <th>TAB<%=SystemEnv.getHtmlLabelName(176,user.getLanguage())+SystemEnv.getHtmlLabelName(89,user.getLanguage())%></th><!-- 是否显示在Tab页 -->
		      <th><%=SystemEnv.getHtmlLabelName(88,user.getLanguage())%></th><!-- 顺序 -->
		   </tr>
		   <%
		   int index = 0;
		   for(int i=0;i<labelList.size();i++){ 
               CoworkLabelVO labelVO=(CoworkLabelVO)labelList.get(i);
               
               String id=labelVO.getId();
               String labelType=labelVO.getLabelType();
               String name=labelVO.getName();
               String labelOrder=labelVO.getLabelOrder();
               String isUsed=labelVO.getIsUsed();
               String labelColor=labelVO.getLabelColor();
               String textColor=labelVO.getTextColor();
               String labelName="";
               if(null == id || id.equals("")){
            	   id = --index+"";
               }
               if(labelType.equals("label")){
            	   labelName=labelVO.getName();
               }else if(labelType.equals("typePlate")){
              	   labelName = CoTypeComInfo.getCoTypename(name);
               }else{
            	   labelName=SystemEnv.getHtmlLabelName(Util.getIntValue(name),user.getLanguage());
               }
		   %>
		   <tr id="labelline_<%=id%>" CLASS=DataLight>
		      <td><input name="id" type="hidden" value="<%=id%>" /> <input name="name" type="hidden" value="<%=name%>" /> <input type="hidden" name="labelType" value="<%=labelType%>"><%=labelName%></td>
		      <td>
		        <input type="hidden" value="<%=labelColor%>" name="labelColor" id="labelColor_<%=id%>">
		        <input type="hidden" value="<%=textColor%>" name="textColor" id="textColor_<%=id%>">
		        <%if(labelType.equals("label")){%>
		         <SPAN style="BACKGROUND-COLOR: <%=labelColor%>; COLOR: <%=textColor%>;padding:2px" id="<%=id%>" class=colorblock r_attr="background-color" r_id="menuhContainer" colorValue="<%=labelColor%>" textColor="<%=textColor%>"><%=name%></SPAN>
		         <img src='/js/jquery/plugins/farbtastic/color_wev8.png' style='cursor:hand;margin-left:3px' align="absmiddle" onclick='doColorClick(this,<%=id%>)' border=0/>
		        <%}%>
		      </td>
		      <td align="center"><input name="isUsed_<%=id%>" type="checkbox" <%if(isUsed.equals("1")){%>checked="checked"<%}%> value="1"></td><!-- 启用 -->
		      <td>
		      	 <input name="labelOrder" type="text" onblur="isInt(this)" value="<%=labelOrder%>" style="text-align: center;" size="3" maxlength="3"/>
		         <%if(labelType.equals("label")){%>
		         	
		         	<div class="e8operateChild" style="position:absolute; top: 2px;right:0px;float:right; ">&nbsp;</div>
					<div class="hoverDivChild" style="position:absolute; top: 2px;right:0px;height: 30px; line-height: 30px; float:right !important;display:none; text-align: right !important;">
						<span class="operHoverSpanChild operHover_handChild">
							<a href="javascript:addLabel('edit',<%=id%>)" target="_self" title="<%=SystemEnv.getHtmlLabelName(93,user.getLanguage()) %>">
								&nbsp;<%=SystemEnv.getHtmlLabelName(93,user.getLanguage()) %>&nbsp;
							</a>
						</span>
					
						<span class="operHoverSpanChild operHover_handChild">
							<a href="javascript:void(0)" onclick="javascript:deleteLabel(<%=id%>)" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage()) %>">
								&nbsp;<%=SystemEnv.getHtmlLabelName(91,user.getLanguage()) %>&nbsp;
							</a>
						</span>
					</div>
		         <%}%> 
		      </td>
		   </tr>
		   <%}%>
  </table>
</form>
</div>

  <div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout>
		<wea:group context="" attributes="{groupDisplay:none}">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="javascript:parent.getDialog(window).close();">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>
  <script type="text/javascript">
  
  jQuery(function(){
  	jQuery(".e8operateChild").parents("td").css("position","relative");
	jQuery(".e8operateChild").hover(
		function(){
			jQuery(this).parent("td").find(".hoverDivChild").show();
		},
		function(){
			jQuery(this).parent("td").find(".hoverDivChild").hide();
		}
	)
	
	jQuery(".hoverDivChild").hover(
		function(){
			jQuery(this).show();
		},
		function(){
			jQuery(this).hide();
		}
	)
  
  
  });
  
  function chooseColor(obj){
     
     var colorValue=jQuery(obj).attr("colorValue");
     var textColor=jQuery(obj).attr("textColor");
     
     jQuery("#txtColorTemp").attr("colorValue",colorValue);
     jQuery("#txtColorTemp").attr("textColor",textColor);
     jQuery("#txtColorTemp").css("background-color",colorValue);
     jQuery("#txtColorTemp").css("color",textColor);
  }
  
   jQuery(document).ready(function(){
      if(jQuery(window.parent.document).find("#ifmCoworkItemContent")[0]!=undefined){
	     //左侧下拉框处理
	    jQuery(document.body).bind("mouseup",function(){
		   parent.jQuery("html").trigger("mouseup.jsp");	
	    });
	    jQuery(document.body).bind("click",function(){
			jQuery(parent.document.body).trigger("click");		
	    });
      }
      
	 $("#coloPanel").dialog({
				autoOpen: false,
				draggable:false,
				resizable:false,
				width:200,
				buttons: {
					"<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>":function(){  // 取消
					    $(this).dialog("close");
					},
					"<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%>": function() { //确定
						var colorValue=$("#txtColorTemp").attr("colorValue");
						var textColor=$("#txtColorTemp").attr("textColor");
						var objFormId=$("#txtColorTemp").attr("from");	
						
						$("#labelColor_"+objFormId).val(colorValue);	
						$("#textColor_"+objFormId).val(textColor);
						
						$("#"+objFormId).css("background-color",colorValue);
						$("#"+objFormId).css("color",textColor);
						
                        $("#"+objFormId).attr("colorValue",colorValue); 
                        $("#"+objFormId).attr("textColor",textColor); 
                        
						$(this).dialog("close"); 
					}
				} 
			});		
   });
   
   function deleteLabel(labelid){
   	  window.top.Dialog.confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>",function(){	
         $("#labelline_"+labelid).remove();
         $.post("/cowork/CoworkItemMarkOperation.jsp",{type:"deleteLabel",id:labelid},function(data){});
      });
    }
    
    function editLabel(type,labelid){
      window.location.href="/cowork/addLabel.jsp?type=editLabel&labelid="+labelid;      
    }
    
    function doSave(){
      $("#labelForm").submit();
    }
    
    function isInt(obj){
      var value=$(obj).val()
      if(value!=parseInt(value)){
         alert("<%=SystemEnv.getHtmlLabelName(23086,user.getLanguage())%>");//必须为整数,请重新输入
         $(obj).focus();
      }
    }
    
    //点击颜色弹出框
	function doColorClick(obj,labelid){
	    var colorSpan=jQuery("#"+labelid);
	    
		$("#txtColorTemp").val(colorSpan.text());
		$("#txtColorTemp").css("background-color",colorSpan.attr("colorValue"));
		$("#txtColorTemp").css("color",colorSpan.attr("textColor"));
		$("#txtColorTemp").attr("from",colorSpan.attr("id")); 

		$("#coloPanel").dialog('open');	
		var offset = $(obj).offset();
		

		var coloPanelWidth=$("#coloPanel")[0].parentNode.offsetWidth;
		var coloPanelHeight=$("#coloPanel")[0].parentNode.offsetHeight;


		var rightedge=document.body.clientWidth-event.clientX
		var bottomedge=document.body.clientHeight-event.clientY
		
		if (rightedge<coloPanelWidth)
			$("#coloPanel")[0].parentNode.style.left=document.body.scrollLeft+event.clientX-$("#coloPanel")[0].parentNode.offsetWidth-10
		else
			$("#coloPanel")[0].parentNode.style.left=document.body.scrollLeft+event.clientX+10
			
		
		if (bottomedge<coloPanelHeight)
			$("#coloPanel")[0].parentNode.style.top=document.body.scrollTop+event.clientY-$("#coloPanel")[0].parentNode.offsetHeight
		else
			$("#coloPanel")[0].parentNode.style.top=document.body.scrollTop+event.clientY
	}
	
	var diag;
	function addLabel(type,labelid){
	
	    var title="<%=SystemEnv.getHtmlLabelName(83263,user.getLanguage())%>";
	    if(type=="edit"){
	    	title="<%=SystemEnv.getHtmlLabelName(83264,user.getLanguage())%>";
	    }	
	    diag=getCoworkDialog(title,450,200);
	    diag.URL = "/cowork/addLabel.jsp";
	    if(type=="edit"){
	    	diag.URL="/cowork/addLabel.jsp?type=editLabel&labelid="+labelid;
	    }	
		diag.show();
		document.body.click();
	}
	
	function labelCallback(){
		diag.close();
		window.location.reload();
	}
	
  </script>
</body>
</html>
