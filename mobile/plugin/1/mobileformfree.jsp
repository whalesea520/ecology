
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.workflow.datainput.DynamicDataInput" %>
<%@ page import="org.apache.commons.logging.Log" %>
<%@ page import="org.apache.commons.logging.LogFactory" %>
<%@ page import="weaver.docs.docs.DocManager" %>
<%@ page import="weaver.hrm.resource.ResourceComInfo" %>
<%@ page import="weaver.mobile.webservices.workflow.WorkflowCheckCharacter"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<%--///////////////////////////// --%>
<%if(isfreewfedit && isfreeshow){%>
<div>
<%}else{  %>
<div style="display:none;">
<%} %>
<%if (workflowHtmlShow != null && !"".equals(workflowHtmlShow)) { %>
<div style="width:100%;height: 10px;background:#f2f7f8;margin-left:-10px;padding-right:20px;margin-top:10px;"></div>
<%}else{%>
<div style="width:100%;height: 10px;background:#f2f7f8;margin-left:-10px;padding-right:20px;"></div>
<%} %>
<div class="libertynode">
	<table width="100%">
		<tr>
			<td align="center"><div class="approval">审批人</div></td>
		</tr>
		<%if(isfreewfedit){ %>
		<tr>
			<td align="center">
				<span class="switch" style="display:inline-block;">
					<div class="leftdiv">依次送达</div>
					<div class="rightdiv">同时送达</div>
					<div class="rolldiv"></div>
				</span>
			</td>
		</tr>
		<%} %>
	</table>
	<div class="intervaldiv"></div>
	<% 
	
	if(!"".equals(freeoperators)){
	String [] arrayops = Util.TokenizerString2(freeoperators,",");
	String afternode = "0";//是否审批过，0、1、2  未审批、审批、当前节点
	String currentoperator = "";//流程当前节点操作者
	boolean needcheck = false;
	String approvalpersons = "";//未操作者
	if(requestid > 0 && "2".equals(signtype)){
		String agentsql = "";
		if(RecordSet.getDBType().equals("oracle")){
			agentsql = "select receivedpersons from WORKFLOW_AGENTPERSONS where requestid = "+requestid + " and receivedpersons is not null and groupdetailid in (" +
					" SELECT id FROM workflow_groupdetail WHERE groupid IN ( SELECT id FROM workflow_nodegroup WHERE nodeid = " + freeNodeId + ") )";
		}else{
			agentsql = "select receivedpersons from WORKFLOW_AGENTPERSONS where requestid = "+requestid + " and receivedpersons != '' and groupdetailid in ("+
			" SELECT id FROM workflow_groupdetail WHERE groupid IN ( SELECT id FROM workflow_nodegroup WHERE nodeid = " + freeNodeId + ") )";
		}
		RecordSet.executeSql(agentsql);
		while(RecordSet.next()){
			approvalpersons = Util.null2String(RecordSet.getString("receivedpersons"));
		}
		if(!"".equals(approvalpersons) || !"0".equals(currentNodeType)){
			needcheck = true;
		}
		RecordSet.executeSql("select userid from workflow_currentoperator where requestid = "+requestid+" and isremark = '0'");
		while(RecordSet.next()){
			currentoperator += Util.null2String(RecordSet.getString("userid"));
		}
	}
	approvalpersons = "," + approvalpersons;
	

	%>
	<!-- 依次送达 -->
	<div class="contentorder">
		<div class="contentleft1"></div>
		<div class="contentdiv1">
			<%for(int f=0;f<arrayops.length;f++){ 
				ResourceComInfo rc = new ResourceComInfo();
				String operatorname = Util.null2String(rc.getLastname(arrayops[f]));
				String messagerurl = Util.null2String(rc.getMessagerUrls(arrayops[f]));
				String pattenname = WorkflowCheckCharacter.getCharacterName(operatorname);
				if(needcheck){
					if(approvalpersons.indexOf(","+arrayops[f]+",") > -1){
						afternode = "0";
					}else if(currentoperator.equals(arrayops[f])){
						afternode = "2";
					}else{
						afternode = "1";
					}
				}
			%>
			<div class="item1"> 
			<%if((afternode.equals("1") && currentNodeType.equals("1")) || "3".equals(currentNodeType)){%>
				<div class="intervaldiv1" attrline="showline"></div>
			<%}else{%>
				<div class="intervaldiv1"></div>
			<%}%>
			<div class="itemico">
				<%if(messagerurl.equals("/messager/images/icon_w_wev8.jpg") || messagerurl.equals("/messager/images/icon_m_wev8.jpg")){ %>
				<%if(currentoperator.equals(arrayops[f])){%>
					<div style="width:41px;height:41px;border:2px solid #649ccb;border-radius:30px;line-height:45px;text-align:center;background:#d1d1d1;color:#ffffff;font-size: 14px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;">
					<%=pattenname %>
					</div>
				<%}else{%>
					<div style="width:45px;height:45px;border-radius:30px;line-height:45px;text-align:center;background:#d1d1d1;color:#ffffff;font-size: 14px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;">
					<%=pattenname %>
					</div>
				<%} %>
				
				<%}else{ %> 
				<%if(currentoperator.equals(arrayops[f])){%>
					<img src="<%=messagerurl%>" style="width:41px;height:41px;border:2px solid #649ccb;border-radius:30px;">
				<%}else{%>
					<img src="<%=messagerurl%>" style="width:45px;height:45px;border-radius:30px;">
				<%} %>
				<%} %> 
			</div> 
			<div class="itemtitle"><%=operatorname %></div> 
			</div>
			<%} 
			%>
			<%if("0".equals(currentNodeType) && isfreewfedit){ %>
			<div class="itemadd">
				<div class="intervaldiv1"></div>
	  			<div class="itemico">
	  				<img src="/mobile/plugin/1/images/freeadd_wev8.png" >
	  			</div>
				<div class="itemtitle"></div>
			</div>
			<%} %>
		</div>
		<div class="contentright1"></div>
	</div>
	<!-- 同时送达 -->
	<div class="contentsame">
		<div class="contentleft">
			<div class="intervalline"></div>
		</div>
		<div class="contentdiv">
		<%for(int f=0;f<arrayops.length;f++){ 
				ResourceComInfo rc = new ResourceComInfo();
				String operatorname = Util.null2String(rc.getLastname(arrayops[f]));
				String messagerurl = Util.null2String(rc.getMessagerUrls(arrayops[f]));
				String pattenname = WorkflowCheckCharacter.getCharacterName(operatorname);
			%>
			<div class="item"> 
			<div class="intervaldiv1"></div> 
			<div class="itemico">
				<%if(messagerurl.equals("/messager/images/icon_w_wev8.jpg") || messagerurl.equals("/messager/images/icon_m_wev8.jpg")){ %>
				<div style="width:45px;height:45px;border-radius:30px;line-height:45px;text-align:center;background:#d1d1d1;color:#ffffff;font-size: 14px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;">
				<%=pattenname %>
				</div>
				<%}else{ %> 
				<img src="<%=messagerurl%>" style="width:45px;height:45px;border-radius:30px;">
				<%} %> 
			</div> 
			<div class="itemtitle" title=""><%=operatorname %></div>
			</div>
		<%} 
		%>
		<%if("0".equals(currentNodeType) && isfreewfedit){ %>
			<div class="itemedit">
				<div class="intervaldiv1"></div>
	  			<div class="itemico">
	  				<img src="/mobile/plugin/1/images/freeedit_wev8.png" >
	  			</div>
				<div class="itemtitle"></div>
			</div>
		<%} %>
		<div class="clear"></div>
		</div>
		<div class="contentright">
			<div class="intervalline1"></div>
			<div class="intervalimg"></div>
		</div>
		<div class="clear"></div>
	</div>
	<%}else if(isfreewfedit){ %>
		<!-- 依次送达 -->
	<div class="contentorder">
		<div class="contentleft1"></div>
		<div class="contentdiv1">
			<div class="itemadd">
				<div class="intervaldiv1"></div>
	  			<div class="itemico">
	  				<img src="/mobile/plugin/1/images/freeadd_wev8.png" >
	  			</div>
				<div class="itemtitle"></div>
			</div>
		</div>
		<div class="contentright1"></div>
	</div>
	<!-- 同时送达 -->
	<div class="contentsame" >
		<div class="contentleft">
			<div class="intervalline"></div>
		</div>
		<div class="contentdiv">
			<div class="itemedit">
				<div class="intervaldiv1"></div>
	  			<div class="itemico">
	  				<img src="/mobile/plugin/1/images/freeedit_wev8.png" >
	  			</div>
				<div class="itemtitle"></div>
			</div>
		</div>
		<div class="contentright">
			<div class="intervalline1"></div>
			<div class="intervalimg"></div>
		</div>
		<div class="clear"></div>
	</div>
	<%} %>
	<%--
	<input type="hidden" name="operators_order" id="operators_order" value="" />
	<input type="hidden" name="operators_same" id="operators_same" value="" />
	 --%>
	<input fieldtype="browse" type="hidden" name="operators_0" id="operators_0" value="<%=freeoperators%>" onchange="try{freeoperatorchange(this);}catch(e){}"/>
	<span id="operators_0_span" name="operators_0_span" style="display:none;"></span>
	
	<% 
	if(!"".equals(freeoperators) && isfreewfedit){%>
	<input type="hidden" name="rownum" value="1" />
	<input type="hidden" name="indexnum" value="1" />
	<%}else{%>
	<input type="hidden" name="rownum" value="" />
	<input type="hidden" name="indexnum" value="" />
	<%}%>
	<input type="hidden" name="floworder_0" value="1" />
	<%
		if("".equals(freeNodeName) || freeNodeName == null){
			freeNodeName = "节点1";
		}
	%>
	<input type="hidden" name="nodename_0" value="<%=freeNodeName%>" />
	<input type="hidden" name="Signtype_0" id="Signtype_0" value="<%=signtype%>" />
	<input type="hidden" name="nodetype_0" id="nodetype_0" value="1" />
	<input type="hidden" name="trust_0" id="trust_0" value="0" />
	<input type="hidden" name="nodeDo_0" id="nodeDo_0" value="1" />
	<input type="hidden" name="road_0" id="road_0" value="0" />
	<input type="hidden" name="frms_0" id="frms_0" value="1" />
</div>
<%if(requestid > 0){%>
<div style="width:100%;height: 10px;margin-top:10px;background:#f2f7f8;margin-left:-10px;padding-right:20px;margin-bottom:10px;"></div>
<% }else{%>
<div style="width:100%;height: 10px;margin-top:10px;margin-bottom:5px;"></div>
<%}%>
</div>
<script type="text/javascript">
jQuery(function(){
	jQuery(".switch").unbind("click").bind("click",function(){
		//var rolldivleft = jQuery(".rolldiv").position().left;
		var Signtype_0 = jQuery("#Signtype_0").val();//8a9fad
		if(Signtype_0 == "2"){
			//jQuery(".rolldiv").css({"left":"112px"});
			jQuery(".rolldiv").animate({ 
				left: 69
			}, 5,null,function() {
				jQuery(".rightdiv").css("color","#ffffff");
			}); 
			//jQuery(".rolldiv").html("同时送达");
			jQuery(".leftdiv").css("color","#8a9fad");
			
			jQuery("#Signtype_0").val("1");
			//jQuery("#operators_0").val(jQuery("#operators_same").val());
			jQuery(".contentorder").hide();
			jQuery(".contentsame").show();
			//freeoperatorchange(jQuery("#operators_0"));
		}else{
			//jQuery(".rolldiv").css({"left":"0px"});
			jQuery(".rolldiv").animate({ 
				left: 0
			}, 5,null,function() {
				jQuery(".leftdiv").css("color","#ffffff");
			}); 
			jQuery(".rightdiv").css("color","#8a9fad");
			//jQuery(".rolldiv").html("依次送达");
			jQuery("#Signtype_0").val("2");
			//jQuery("#operators_0").val(jQuery("#operators_order").val());
			jQuery(".contentsame").hide();
			jQuery(".contentorder").show();
			//freeoperatorchange(jQuery("#operators_0"));
		}
	});
	jQuery(".itemadd").unbind("click").bind("click",function(){
		showDialog("/browser/dialog.do","&returnIdField=operators_0&returnShowField=operators_0_span&method=listUser&isMuti=1")
	});
	jQuery(".itemedit").unbind("click").bind("click",function(){
		showDialog("/browser/dialog.do","&returnIdField=operators_0&returnShowField=operators_0_span&method=listUser&isMuti=1")
	});
	//freeoperatorchange(jQuery("#operators_0"));
	if("<%=signtype%>" == "1" && <%=isfreewfedit%>){
		jQuery(".rolldiv").animate({ 
			left: 69
		}, 5,null,function() {
			jQuery(".leftdiv").css("color","#8a9fad");
		}); 
		//jQuery(".rolldiv").html("同时送达");
		
		jQuery(".rightdiv").css("color","#ffffff");
		jQuery(".contentorder").hide();
		jQuery(".contentsame").show();
	}
	
	readyitem("<%=signtype%>");
});

function readyitem(obj){
	jQuery(".contentorder").show();
	jQuery(".contentsame").show();
	jQuery(".contentorder").height(jQuery(".contentdiv1").height());
	jQuery(".contentsame").height(jQuery(".contentdiv").height());
	jQuery(".contentright").height(jQuery(".contentdiv").height());
	jQuery(".contentleft").height(jQuery(".contentdiv").height());
	jQuery(".item1").each(function (i, e) {
		var item1left = jQuery(e).position().left;
		var item1top = jQuery(e).position().top;
		var nexttop;
		if(jQuery(e).next().position()){
			nexttop = jQuery(e).next().position().top;
			var lineclass = jQuery(e).next().attr("class");
			if(item1top == nexttop && lineclass != "intervalsameline"){
				var showline = jQuery(e).find(".intervaldiv1").attr("attrline");
				var div;
				if(showline == "showline"){
					div=jQuery("<div class=\"intervalsameline\"><div class=\"intervalsamecghildafter\"></div></div>");
				}else{
					div=jQuery("<div class=\"intervalsameline\"><div class=\"intervalsamecghild\"></div></div>");
				}
				jQuery(div).css({"top":item1top+"px","left":item1left+55+"px"});
				jQuery(".contentdiv1").append(div);
			}
		}
	});
	if(obj == "1"){
		jQuery(".contentorder").hide();
		jQuery(".contentsame").show();
	}else{
		jQuery(".contentsame").hide();
		jQuery(".contentorder").show();
	}
}

var _messagearray ={};
function freeoperatorchange(obj){
	var operator = jQuery(obj).val();
	var operatornames = jQuery("#operators_0_span").html();
	var Signtype_0 = jQuery("#Signtype_0").val();
	var html = "";
	var isfreewfedit = <%=isfreewfedit%>;
	var currentNodeType = "<%=currentNodeType%>";
	//alert(operatornames);
	if(operator != "" && operator != null && operator != "null"){
		var itemaddhtml ="";
		var itemedithtml ="";
		var rtndataarray = operator.split(",");
		var namearray = null;
		if(operatornames != "" && operatornames != null && operatornames != "null"){
			if(operatornames.indexOf(",") > -1){
				namearray = operatornames.split(",");
			}else{
				namearray = operatornames.split(" ");
			}
		}
		//
		for(var i=0;i<rtndataarray.length;i++){
			
			var operatorid,operatname;
			if(namearray != null){
				operatname = namearray[i];
			}else{
				operatname = rtndataarray[i];
			}
			operatorid = rtndataarray[i];
			var imgurl__ = _messagearray[operatorid];
			
			itemaddhtml += "<div class=\"item1\" name=\""+operatorid+"\"> " +
				"<div class=\"intervaldiv1\"></div> " + 
				"<div class=\"itemico\"> ";
				if(!!!imgurl__ || imgurl__ == ""){
					itemaddhtml += "<div style=\"width:45px;height:45px;border-radius:30px;line-height:45px;text-align:center;background:#d1d1d1;color:#ffffff;font-size: 14px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;\"></div> ";
				}else{
					itemaddhtml += "<img src=\""+imgurl__+"\" style=\"width:45px;height:45px;border-radius:30px;\"> ";
				}
				itemaddhtml += "</div> "+
				"<div class=\"itemtitle\">"+operatname+"</div> "+
				"</div> ";
			
			itemedithtml += "<div class=\"item\" name=\""+operatorid+"\"> "+
				"<div class=\"intervaldiv1\"></div> "+
  				"<div class=\"itemico\"> ";
  				if(!!!imgurl__ || imgurl__ == ""){
  					itemedithtml += "<div style=\"width:45px;height:45px;border-radius:30px;line-height:45px;text-align:center;background:#d1d1d1;color:#ffffff;font-size: 14px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;\"></div> ";
				}else{
					itemedithtml += "<img src=\""+imgurl__+"\" style=\"width:45px;height:45px;border-radius:30px;\"> ";
				}
  				itemedithtml += "</div> "+
				"<div class=\"itemtitle\" title>"+operatname+"</div> "+
				"</div>";
		}
		
		jQuery(".contentorder").show();
		jQuery(".contentsame").show();
		if(isfreewfedit){
			itemaddhtml += "<div class=\"itemadd\"> "+
			"<div class=\"intervaldiv1\"></div> "+
 				"<div class=\"itemico\"> "+
 				"<img src=\"/mobile/plugin/1/images/freeadd_wev8.png\" > "+
 				"</div> "+
			"<div class=\"itemtitle\"></div> "+
			"</div>";
			
			itemedithtml += "<div class=\"itemedit\"> "+
				"<div class=\"intervaldiv1\"></div> "+
	 				"<div class=\"itemico\"> "+
	 				"<img src=\"/mobile/plugin/1/images/freeedit_wev8.png\" > "+
	 				"</div> "+
				"<div class=\"itemtitle\"></div> "+
				"</div>";
		}
		jQuery(".contentdiv1").html(itemaddhtml);
		jQuery(".contentdiv").html(itemedithtml);
		jQuery(".contentorder").height(jQuery(".contentdiv1").height());
		
		jQuery(".contentsame").height(jQuery(".contentdiv").height());
		jQuery(".contentright").height(jQuery(".contentdiv").height());
		jQuery(".contentleft").height(jQuery(".contentdiv").height());
		
		jQuery(".item1").each(function (i, e) {
			var item1left = jQuery(e).position().left;
			var item1top = jQuery(e).position().top;
			var nexttop;
			if(jQuery(e).next().position()){
				nexttop = jQuery(e).next().position().top;
				var lineclass = jQuery(e).next().attr("class");
				if(item1top == nexttop && lineclass != "intervalsameline"){
					var showline = jQuery(e).find(".intervaldiv1").attr("attrline");
					var div;
					if(showline == "showline"){
						div=jQuery("<div class=\"intervalsameline\"><div class=\"intervalsamecghildafter\"></div></div>");
					}else{
						div=jQuery("<div class=\"intervalsameline\"><div class=\"intervalsamecghild\"></div></div>");
					}
					jQuery(div).css({"top":item1top+"px","left":item1left+55+"px"});
					jQuery(".contentdiv1").append(div);
				}
			}
		});
		if(isfreewfedit){
			jQuery(".itemadd").unbind("click").bind("click",function(){
				showDialog("/browser/dialog.do","&returnIdField=operators_0&returnShowField=operators_0_span&method=listUser&isMuti=1")
			});
			jQuery(".itemedit").unbind("click").bind("click",function(){
				showDialog("/browser/dialog.do","&returnIdField=operators_0&returnShowField=operators_0_span&method=listUser&isMuti=1")
			});
		}
		if(Signtype_0 == "2"){
			jQuery(".contentsame").hide();
			jQuery(".contentorder").show();
		}else{
			jQuery(".contentorder").hide();
			jQuery(".contentsame").show();
		}
		
		jQuery.ajax({
			type : "get",
		    url: "/mobile/plugin/1/workflowAjaxUrl.jsp?_" + new Date().getTime() + "=1&operator="+operator+"&signtype=<%=signtype%>&requestid=<%=requestid%>&currentNodeType=<%=currentNodeType%>&freeNodeId=<%=freeNodeId%>",
		    contentType : "application/x-www-form-urlencoded; charset=UTF-8",
		    complete: function(){
			},
		    error:function (XMLHttpRequest, textStatus, errorThrown) {
		    } , 
			success: function(data){
				//rtndata = data;
				var rtndata;
				if(!jQuery.isArray(data) && jQuery.trim(data) != "")
					rtndata = JSON.parse(data);
                else
                	rtndata=eval(data);
				var itemaddhtml ="";
				var itemedithtml ="";
				jQuery(".contentorder").show();
				jQuery(".contentsame").show();
				if(rtndata != null){
					for(var j=0;j<rtndata.length;j++){
						var menu = rtndata[j];
						var optid = menu.id;
						var messagerurl = menu.messagerurl;
						var operatname = menu.operatname;
						var pattenname = menu.pattenname;
						var isemptyurl = menu.isemptyurl;
						var afternode = menu.afternode;
						//if(afternode == "1" && (currentNodeType == "1" || currentNodeType == "3")){
						//	jQuery(".contentorder").find("div[name="+optid+"]").find(".intervaldiv1").attr("attrline","showline");
						//}
						
						var itemico;
						if(isemptyurl != "1"){
							_messagearray[optid] = messagerurl;
	  						itemico = "<img src=\""+messagerurl+"\" style=\"width:45px;height:45px;border-radius:30px;\"> ";
	  					}else{
  							itemico = "<div style=\"width:45px;height:45px;border-radius:30px;line-height:45px;text-align:center;background:#d1d1d1;color:#ffffff;font-size: 14px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;\">"+pattenname+"</div>"
	  					}
						jQuery(".contentorder").find("div[name="+optid+"]").find(".itemico").html(itemico);
						jQuery(".contentsame").find("div[name="+optid+"]").find(".itemico").html(itemico);
						/*itemaddhtml += "<div class=\"item1\"> ";
						if(afternode == "1" && (currentNodeType == "1" || currentNodeType == "3")){
							itemaddhtml +="<div class=\"intervaldiv1\" attrline=\"showline\"></div> ";
						}else{
							itemaddhtml +="<div class=\"intervaldiv1\"></div> ";
						}
						itemaddhtml +="<div class=\"itemico\"> ";
	  					if(isemptyurl != "1"){
	  						if(afternode == "2"){
	  							itemaddhtml += "<img src=\""+messagerurl+"\" style=\"width:41px;height:41px;border:2px solid #649ccb;border-radius:30px;\"> ";
	  						}else{
		  						itemaddhtml += "<img src=\""+messagerurl+"\" style=\"width:45px;height:45px;border-radius:30px;\"> ";
	  						}
	  					}else{
	  						if(afternode == "2"){
	  							itemaddhtml += "<div style=\"width:41px;height:41px;border:2px solid #649ccb;border-radius:30px;line-height:45px;text-align:center;background:#d1d1d1;color:#ffffff;font-size: 14px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;\">"+pattenname+"</div>"
	  						}else{
	  							itemaddhtml += "<div style=\"width:45px;height:45px;border-radius:30px;line-height:45px;text-align:center;background:#d1d1d1;color:#ffffff;font-size: 14px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;\">"+pattenname+"</div>"
	  							//itemaddhtml += "<img src=\"/messager/images/icon_w_wev8.jpg\" style=\"width:41px;height:41px;border:2px solid #649ccb;border-radius:30px;\"> ";
	  						}
	  					}
	  					itemaddhtml += "</div> "+
							"<div class=\"itemtitle\">"+operatname+"</div> "+
							"</div> ";
						
						itemedithtml += "<div class=\"item\"> "+
							"<div class=\"intervaldiv1\"></div> "+
			  				"<div class=\"itemico\"> ";
		  				if(isemptyurl != "1"){
		  					itemedithtml += "<img src=\""+messagerurl+"\" style=\"width:45px;height:45px;border-radius:30px;\"> ";
	  					}else{
	  						itemedithtml += "<div style=\"width:45px;height:45px;border-radius:30px;line-height:45px;text-align:center;background:#d1d1d1;color:#ffffff;font-size: 14px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;\">"+pattenname+"</div>"
	  					}
		  				itemedithtml += "</div> "+
						"<div class=\"itemtitle\" title>"+operatname+"</div> "+
						"</div>";
						
						*/
					}
				}
				
				
				/*
				jQuery(".contentorder").show();
				jQuery(".contentsame").show();
				if(isfreewfedit){
					itemaddhtml += "<div class=\"itemadd\"> "+
					"<div class=\"intervaldiv1\"></div> "+
		 				"<div class=\"itemico\"> "+
		 				"<img src=\"/mobile/plugin/1/images/freeadd_wev8.png\" > "+
		 				"</div> "+
					"<div class=\"itemtitle\"></div> "+
					"</div>";
					
				
					itemedithtml += "<div class=\"itemedit\"> "+
						"<div class=\"intervaldiv1\"></div> "+
			 				"<div class=\"itemico\"> "+
			 				"<img src=\"/mobile/plugin/1/images/freeedit_wev8.png\" > "+
			 				"</div> "+
						"<div class=\"itemtitle\"></div> "+
						"</div>";
				}
				
				//jQuery("#operators_same").val(operator);
				jQuery(".contentorder").height(jQuery(".contentdiv1").height());
				//jQuery("#operators_order").val(operator);
				jQuery(".item1").each(function (i, e) {
					var item1left = jQuery(e).position().left;
					var item1top = jQuery(e).position().top;
					var nexttop;
					if(jQuery(e).next().position()){
						nexttop = jQuery(e).next().position().top;
						var lineclass = jQuery(e).next().attr("class");
						if(item1top == nexttop && lineclass != "intervalsameline"){
							var showline = jQuery(e).find(".intervaldiv1").attr("attrline");
							var div;
							if(showline == "showline"){
								div=jQuery("<div class=\"intervalsameline\"><div class=\"intervalsamecghildafter\"></div></div>");
							}else{
								div=jQuery("<div class=\"intervalsameline\"><div class=\"intervalsamecghild\"></div></div>");
							}
							jQuery(div).css({"top":item1top+"px","left":item1left+55+"px"});
							jQuery(".contentdiv1").append(div);
						}
					}
				});
				jQuery(".contentsame").height(jQuery(".contentdiv").height());
				jQuery(".contentright").height(jQuery(".contentdiv").height());
				jQuery(".contentleft").height(jQuery(".contentdiv").height());
				*/
				if(Signtype_0 == "2"){
					jQuery(".contentsame").hide();
					jQuery(".contentorder").show();
				}else{
					jQuery(".contentorder").hide();
					jQuery(".contentsame").show();
				}
				jQuery("input[name=rownum]").val("1");
				jQuery("input[name=indexnum]").val("1");
				
				
				/*$(".contentdiv").sortable({
			    	revert: true
			    });
				$(".contentdiv1").sortable({
			    	revert: true
			    });*/

			}
		});
	}else{
		jQuery(".contentorder").show();
		jQuery(".contentsame").show();
		var itemaddhtml = "<div class=\"itemadd\"> "+
			"<div class=\"intervaldiv1\"></div> "+
 				"<div class=\"itemico\"> "+
 				"<img src=\"/mobile/plugin/1/images/freeadd_wev8.png\" > "+
 				"</div> "+
			"<div class=\"itemtitle\"></div> "+
			"</div>";
		jQuery(".contentdiv1").html(itemaddhtml);
		jQuery(".contentorder").height(jQuery(".contentdiv1").height());
		//jQuery("#operators_order").val(operator);
		jQuery(".itemadd").unbind("click").bind("click",function(){
			showDialog("/browser/dialog.do","&returnIdField=operators_0&returnShowField=operators_0_span&method=listUser&isMuti=1")
		});
	
		var itemedithtml = "<div class=\"itemedit\"> "+
			"<div class=\"intervaldiv1\"></div> "+
 				"<div class=\"itemico\"> "+
 				"<img src=\"/mobile/plugin/1/images/freeedit_wev8.png\" > "+
 				"</div> "+
			"<div class=\"itemtitle\"></div> "+
			"</div>";
		jQuery(".contentdiv").html(itemedithtml);
		jQuery(".contentsame").height(jQuery(".contentdiv").height());
		jQuery(".contentright").height(jQuery(".contentdiv").height());
		jQuery(".contentleft").height(jQuery(".contentdiv").height());
		//jQuery("#operators_same").val(operator);
		jQuery(".itemedit").unbind("click").bind("click",function(){
			showDialog("/browser/dialog.do","&returnIdField=operators_0&returnShowField=operators_0_span&method=listUser&isMuti=1")
		});
		jQuery("input[name=rownum]").val("0");
		jQuery("input[name=indexnum]").val("0");
		if(isfreewfedit){
			if(Signtype_0 == "2"){
				jQuery(".contentsame").hide();
				jQuery(".contentorder").show();
			}else{
				jQuery(".contentorder").hide();
				jQuery(".contentsame").show();
			}
		}else{
			jQuery(".contentsame").hide();
			jQuery(".contentorder").hide();
		}
	}
}
</script>