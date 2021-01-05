
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.mobile.webservices.workflow.WorkflowRequestTableRecord" %>
<%@ page import="weaver.mobile.webservices.workflow.WorkflowRequestTableField" %>
<%@ page import="weaver.workflow.datainput.DynamicDataInput"%>
<%@ page import="weaver.general.* "%>
<%@ page import="weaver.mobile.webservices.workflow.WorkflowServiceUtil" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="java.util.* "%>
<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
 user = HrmUserVarify.getUser (request , response) ;
 String groupId = request.getParameter("groupId");
 String derecorderindex =  request.getParameter("derecorderindex");
 //workflowid =  request.getParameter("workflowid");
 //删除改变其他jsp字段值的操作
 //nodeId =  request.getParameter("nodeId");
 String rowIndex = request.getParameter("rowIndex");
String cmd = request.getParameter("cmd");
//if("createDiv".equals(cmd)){
	//if(!"".equals(groupId)&&groupId != null){
		//int groupIdInt = Integer.parseInt(groupId);
		//if("".equals(derecorderindex) || null== derecorderindex){
			//derecorderindex = "0";
		//}
		//if("".equals(rowIndex)|| null == rowIndex){
			//rowIndex = "0";
		//}
		//int rowIndexInt = Integer.parseInt(rowIndex);
		//int derecorderindexInt = Integer.parseInt(derecorderindex);
		//String html = WorkflowServiceUtil.getMouseOverJsString(workflowid,nodeId,user,derecorderindexInt,groupIdInt,rowIndexInt);
		//System.out.println(html);
		//out.println(html);r
	//}
//}

%>
<script>
	/**
	 * 预算费用动态生成明细编辑页面后，绑定事件函数
	 **/
	function dyeditPageFnaFyFun(groupid,rowId,fieldCount,isedit,isdisplay) {
		return;
	}

    //动态生成编辑页面
  function  dyeditPage(groupid,rowId,fieldCount,isedit,isdisplay){
	    var isEditDisplay="";
        var elementCount = 0;
        var tableObj =  document.createElement("table");
        var tempselfield = "";
        //var divObj =  document.createElement("DIV");
        //divObj.setAttribute("id","div"+groupid+"_"+rowId);
       
        tableObj.setAttribute("id","detailtable_"+groupid+"_"+rowId);
        //tableObj.setAttribute("onMouseOver","detailtableMouseOver("+groupid+","+rowId+")");
        //tableObj.setAttribute("onMouseOut","detailtableMouseOut("+groupid+","+rowId+")");
        var aObj = document.getElementById("a"+groupid+"_"+rowId);
        var trObj=aObj.parentNode.parentNode;
        var topPosition = jQuery(trObj).position().top;
        var leftPosiztion = jQuery(trObj).position().left;
        var heightPosition = jQuery(trObj).height();
        var tableHeightPosition = jQuery(tableObj).height();
        var widthPosition = (jQuery(document).width() - leftPosiztion *2);
        tableObj.setAttribute("width",widthPosition+"px");
        //divObj.setAttribute("style","position:absolute;width:100%;height:100%;border-left:1px solid #c3c5ce;border-bottom:1px solid #c3c5ce;");
       // divObj.setAttribute("onclick","detailtableMouseOut("+groupid+","+rowId+")");
        var tbodyObj = aObj.parentNode.parentNode.parentNode;
        elementCount = 0;
        var thValueArrays = new Array();
        //提取标题的部分
        for(var i=0;i<tbodyObj.childNodes.length;i++){
          var thObj =  tbodyObj.childNodes[i];
            if(thObj.nodeType == 1){
               if(elementCount == 0){
                  var thValueObjs = thObj.childNodes;
                  for(var j=0;j<thValueObjs.length;j++){
                       if(thValueObjs[j].nodeType == 1){
                                thValueArrays.push(thValueObjs[j].innerHTML);
                       }
                      
                  }
               }
                elementCount++;
            }
        }
        var DIVHTML = "";
        elementCount = 0;
        //td中列的信息
        for(var i=0;i<trObj.childNodes.length-1;i++){
              var tdObj  =   trObj.childNodes[i];
              var td1 = 0;
              if(tdObj.nodeType == 1){
                 if(elementCount != 0 && elementCount != 1 && elementCount < (fieldCount+3 -1)){
                      DIVHTML += "<tr width=\"100%\">";
                      if(elementCount == 2){
                           DIVHTML +="<td width=\"10%\" style=\"border-left:1px solid #c3c5ce;border-bottom:1px solid #c3c5ce;\" rowspan=\""+fieldCount+"\" onclick=\"detailtableMouseOut("+groupid+","+rowId+")\"></td>";
                      }
                    
                       DIVHTML += "<th width=\"25%\" class=\"detailFormTitleIndexTDValue\" style=\"border-width:0px 1px 1px 1px;\">";
                       DIVHTML += thValueArrays[elementCount];
                       DIVHTML +="</th>";
                      //将控件的值Id需要改变后面添加_detial的标识
                      var tdValueObjs=tdObj.childNodes;
					  var displaySpanCount =0;
					  var displaySpanTdTotal =0;
					  var displayACount =0;
					  var displayATdTotal =0;
					  for(var j=0;j<tdValueObjs.length;j++){
						    if(isdisplay){
								 if(tdValueObjs[j].nodeType == 1 && tdValueObjs[j].nodeName=='SPAN'){
									  if(tdValueObjs[j].getAttribute("keyid")){
										  displaySpanTdTotal ++;
									  }
								 }
								 if(tdValueObjs[j].nodeType == 1 && tdValueObjs[j].nodeName=='A'){
									  if(tdValueObjs[j].getAttribute("keyid")){
										  displayATdTotal ++;
									  }
								 }
								  
							}
					   }

                      for(var j=0;j<tdValueObjs.length;j++){
						  if(isdisplay){
							    if(tdValueObjs[j].nodeType == 1 && tdValueObjs[j].nodeName=='SPAN'){
									 var spanId= tdValueObjs[j].getAttribute("id");
									 var spanName= tdValueObjs[j].getAttribute("name");
									 if(tdValueObjs[j].getAttribute("id")){
                                             DIVHTML +="<td  width=\"65%\" class=\"detailValueTD\">";
											  DIVHTML += "<span id=\""+spanId+"_d\" name=\""+spanName+"_d\">"; 
											  DIVHTML += tdValueObjs[j].innerHTML;
											  DIVHTML += "</span></td>";
									 }
									 if(tdValueObjs[j].getAttribute("keyid")){
										 if(displaySpanCount ==0){
											   DIVHTML +="<td  width=\"65%\" class=\"detailValueTD\">";
												DIVHTML += "<span keyid=\""+tdValueObjs[j].getAttribute("keyid")+"\">";
												DIVHTML +=tdValueObjs[j].innerHTML;
											   DIVHTML += "</span></BR>";
										 }else if(displaySpanCount == displaySpanTdTotal){
											    DIVHTML += "<span keyid=\""+tdValueObjs[j].getAttribute("keyid")+"\">";
												 DIVHTML +=tdValueObjs[j].innerHTML;
												 DIVHTML += "</span></td>";

										 }else{
											     DIVHTML += "<span keyid=\""+tdValueObjs[j].getAttribute("keyid")+"\">";
												 DIVHTML +=tdValueObjs[j].innerHTML;
												 DIVHTML += "</span></BR>";
										 }
										 displaySpanCount++;
										  
									 } 
								}
                                if(tdValueObjs[j].nodeType == 1 && tdValueObjs[j].nodeName=='A'){
                                         if(displayACount == 0){
                                            DIVHTML +="<td  width=\"65%\" class=\"detailValueTD\">";
                                            DIVHTML +=tdValueObjs[j].innerHTML;
										    DIVHTML += "</BR>";
										 }else if(displayACount == displayATdTotal){
											 DIVHTML +=tdValueObjs[j].innerHTML;
										     DIVHTML += "</td>";
										 }else{
											  DIVHTML +=tdValueObjs[j].innerHTML;
										      DIVHTML += "</BR>";
										 }
										displayACount ++;
								}

								if(tdValueObjs.length ==1 && tdValueObjs[j].nodeName =="#text"){
                                      DIVHTML +="<td  width=\"65%\" class=\"detailValueTD\">"+tdValueObjs[j].nodeValue+"</td>";
								}

								if(tdValueObjs[j].nodeType ==1 && tdValueObjs[j].nodeName =="INPUT"){
									var detailVal = true;
									if(tdValueObjs[j].getAttribute("fieldShowId")){
										 if(tdValueObjs[j].getAttribute("fieldShowId")=='detail'){
											   detailVal =false;
										 }
									}
									if(detailVal && tdValueObjs[j].getAttribute("fieldType")){
                                        DIVHTML +="<td  width=\"65%\" class=\"detailValueTD\">"+tdValueObjs[j].getAttribute("value")+"</td>";
									} 
								}
								if(tdValueObjs[j].nodeType ==1 && tdValueObjs[j].nodeName =="TABLE"){
								        var checkboxChildNodes =    tdValueObjs[j].childNodes;
								        for(var po=0;po<checkboxChildNodes.length;po++){
								             if(checkboxChildNodes[po].nodeType == 1 && checkboxChildNodes[po].nodeName == "TBODY"){
								                  var  checkboxTbodyChildNodes =  checkboxChildNodes[po].childNodes;
								                  for(var pt=0;pt<checkboxTbodyChildNodes.length;pt++){
								                        if(checkboxTbodyChildNodes[pt].nodeType == 1 
								                              && checkboxTbodyChildNodes[pt].nodeName == "TR"){
								                              var checkboxTDChildNodes = checkboxTbodyChildNodes[pt].childNodes;
								                              for(var pd=0;pd<checkboxTDChildNodes.length;pd++){
								                                  var checkboxTDChildNode = checkboxTDChildNodes[pd];
								                                  if(checkboxTDChildNode.nodeType==1&&checkboxTDChildNode.nodeName == "TD"){
								                                        var csbox = checkboxTDChildNode.childNodes;
								                                       for(var pc=0;pc<csbox.length;pc++){
								                                             if(csbox[pc].nodeType == 1 && csbox[pc].nodeName == "INPUT" ){
								                                                if(csbox[pc].getAttribute("type") && csbox[pc].getAttribute("type") == "checkbox"){
								                                                    var idVal = "";
								                                                   if(csbox[pc].getAttribute("id")){
								                                                        idVal = csbox[pc].getAttribute("id")+"_d";
								                                                   }
								                                                   var nameVal = "";
								                                                   if(csbox[pc].getAttribute("name")){
								                                                        nameVal = csbox[pc].getAttribute("name")+"_d";
								                                                   }
								                                                   var checkedVal = "";
								                                                   if(csbox[pc].getAttribute("checked")||csbox[pc].getAttribute("checked")==""){
								                                                      checkedVal = "checked";
								                                                   }
								                                                   var disabledVal = "";
								                                                   if(csbox[pc].getAttribute("disabled")||csbox[pc].getAttribute("disabled")==""){
								                                                       disabledVal = "disabled";
								                                                   }
								                                                  DIVHTML +="<td  width=\"65%\" class=\"detailValueTD\"><input type=\"checkbox\" id=\""+idVal+"\" name=\""+nameVal+"\" "+checkedVal+" "+disabledVal+" /></td>";
								                                                }
								                                                 
								                                             }
								                                       }
								                                  }
								                              }
								                            
								                        }
								                  }
								             } 
								        }
									
								}
								var spanCount = 0;
								var spanTdTotal = 0;
								var aCount = 0;
								var aTdTotal = 0;
                                 if(tdValueObjs[j].nodeType == 1 && tdValueObjs[j].nodeName=='DIV'){
									     var divId =  tdValueObjs[j].getAttribute("id");
										 if(divId && divId != "isedit"){
											   var  disTables =  tdValueObjs[j].childNodes;
											   for(var li=0;li<disTables.length;li++){
												     if(disTables[li].nodeType==1&&disTables[li].nodeName=="SPAN"){
													    spanTdTotal ++;
												     }
													  if(disTables[li].nodeType==1&&disTables[li].nodeName=="A"){
													    aTdTotal ++;
												     }
 
											   }
      
										 }

								 }
								if(tdValueObjs[j].nodeType == 1 && tdValueObjs[j].nodeName=='DIV'){
									   var divId =  tdValueObjs[j].getAttribute("id");
									   if(divId && divId != "isedit"){
										   var  disTables =  tdValueObjs[j].childNodes;
										   for(var li=0;li<disTables.length;li++){
											   if(disTables[li].nodeType==1&&disTables[li].nodeName=="TABLE"){
												   if(disTables[li].childNodes[0] && disTables[li].childNodes[0].childNodes[0] 
													   && disTables[li].childNodes[0].childNodes[0].childNodes[0] &&
													   disTables[li].childNodes[0].childNodes[0].childNodes[0].nodeName =="TD"){
                                                        var tddisplayObj = disTables[li].childNodes[0].childNodes[0].childNodes[0];
														for(var lv=0;lv<tddisplayObj.childNodes.length;lv++){
															  tddisplayChildObj=tddisplayObj.childNodes[lv];
															  if(tddisplayChildObj){
																   if(tddisplayChildObj.nodeType == 1 && tddisplayChildObj.nodeName =="INPUT"){
                                                                        var typeck = tddisplayChildObj.getAttribute("type");
																		if(typeck == 'checkbox'){
																		    var checkedVal ="" ;
																		    if(tddisplayChildObj.checked && tddisplayChildObj.getAttribute("checked")!="false"){
                                                                                checkedVal ="checked";
																		    }
                                                                            DIVHTML +="<td  width=\"65%\" class=\"detailValueTD\">";
																			DIVHTML +="<input type=\""+typeck+"\" "+checkedVal+"  disabled   />"
																            DIVHTML +="</td>";
																		}
																   }
															  }

														}
												   }
											   }
											   if(disTables[li].nodeType==3&&disTables[li].nodeName=="#text"){
												   try{
													   if(disTables[li].nodeValue.trim() != ''){
															  DIVHTML +="<td  width=\"65%\" class=\"detailValueTD\">";
															  DIVHTML +=disTables[li].nodeValue;
																DIVHTML +="</td>";
													   }else if(disTables.length == 1){
														    DIVHTML +="<td  width=\"65%\" class=\"detailValueTD\">";
															DIVHTML +=disTables[li].nodeValue;
															DIVHTML +="</td>";
													   }
												   }catch(e){
												   }
											   }

											    if(disTables[li].nodeType==1&&disTables[li].nodeName=="SPAN"){
													if(spanCount ==0){
														  DIVHTML +="<td  width=\"65%\" class=\"detailValueTD\">";
														  var spanHtml = "<SPAN ";
														  if(disTables[li].getAttribute("style")){
                                                                spanHtml += " style=\""+disTables[li].getAttribute("style")+"\""
														  }
														  if(disTables[li].getAttribute("onclick")){
                                                                spanHtml += " onclick=\""+disTables[li].getAttribute("onclick")+"\""
														  }
														   if(disTables[li].getAttribute("keyid")){
                                                                spanHtml += " keyid=\""+disTables[li].getAttribute("keyid")+"\""
														  }
                                                           spanHtml += ">"+disTables[li].innerHTML +"</span><br>"
														  DIVHTML +=spanHtml;
																
													}else if(spanCount == spanTdTotal){
														 var spanHtml = "<SPAN  ";
														  if(disTables[li].getAttribute("style")){
                                                                spanHtml += " style=\""+disTables[li].getAttribute("style")+"\""
														  }
														  if(disTables[li].getAttribute("onclick")){
                                                                spanHtml += " onclick=\""+disTables[li].getAttribute("onclick")+"\""
														  }
														   if(disTables[li].getAttribute("keyid")){
                                                                spanHtml += " keyid=\""+disTables[li].getAttribute("keyid")+"\""
														  }
                                                           spanHtml += ">"+disTables[li].innerHTML +"</span>"
														  DIVHTML +=spanHtml+"</td>";
													}else {
														  var spanHtml = "<SPAN ";
														  if(disTables[li].getAttribute("style")){
                                                                spanHtml += " style=\""+disTables[li].getAttribute("style")+"\""
														  }
														  if(disTables[li].getAttribute("onclick")){
                                                                spanHtml += " onclick=\""+disTables[li].getAttribute("onclick")+"\""
														  }
														   if(disTables[li].getAttribute("keyid")){
                                                                spanHtml += " keyid=\""+disTables[li].getAttribute("keyid")+"\""
														  }
                                                           spanHtml += ">"+disTables[li].innerHTML +"</span><br>"
														  DIVHTML +=spanHtml;
													}
													  spanCount++;
												}
												if(disTables[li].nodeType==1&&disTables[li].nodeName=="A"){
													if(aCount ==0){
														  DIVHTML +="<td  width=\"65%\" class=\"detailValueTD\">";
														  DIVHTML +=disTables[li].innerHTML +"</BR>";
																
													}else if(aCount == aTdTotal){
														 DIVHTML +=disTables[li].innerHTML +"</td>"; 
													}else {
														 DIVHTML +=disTables[li].innerHTML +"</BR>"; 
													}
													  aCount++;
												}

										   }
									   }
								}
						  }else{
							    if(isedit){ //手机版本等
										//不可编辑的时候
									  if((tdValueObjs[j].nodeType == 1 && tdValueObjs[j].nodeName == "SPAN")){
										 if(tdValueObjs[j].getAttribute("id")){
											  DIVHTML +="<span id=\""+tdValueObjs[j].getAttribute("id")+"_d\">"+tdValueObjs[j].innerHTML;   
										 }
									  }
									  if((tdValueObjs[j].nodeName=='#text'&&tdValueObjs[j].nodeValue.trim()!='')){
										 if(tdValueObjs[j].getAttribute("id")){
											  DIVHTML += tdValueObjs[j].nodeValue +"</span>";
										 }
									  }
								  if(tdValueObjs[j].nodeType == 1 && tdValueObjs[j].nodeName=='TABLE'){
										var tdTables = tdValueObjs[j].childNodes;
										var fieldhtmltype = 0;
                                        var _fjscfieldid = "";
		                                try{
		                                	fieldhtmltype = tdNodes[v].getAttribute("fieldhtmltype");
		                                }catch(e){}
                                        try{
                                            _fjscfieldid = tdNodes[v].getAttribute("_id");
                                        }catch(e){}
										var onclickstr = "";
										for(var k=0;k<tdTables.length;k++){
										   if(tdTables[k].nodeType==1&&tdTables[k].nodeName == 'TBODY'){
												var tdTrValues = tdTables[k].childNodes;
												for(var m=0;m<tdTrValues.length;m++){
													  if(tdTrValues[m].nodeType == 1 && tdTrValues[m].nodeName == 'TR'){
														  var TdtdValues=tdTrValues[m].childNodes;
														  for(var n=0;n<TdtdValues.length;n++){
                                                                var tmpid = "";
                                                                try{
                                                                  var t = TdtdValues[n].childNodes;
                                                                  tmpid = t[0].getAttribute("id") ;
                                                                  if(tmpid==null||tmpid==''){
                                                                    tmpid = t[1].getAttribute("id") ;
                                                                  }
                                                                  tmpid =  tmpid.replace(/field_lable/,"field"); 
                                                                  if(fieldhtmltype==6){
                                                                     tmpid = _fjscfieldid ;
                                                                  }
                                                                }catch(e){
                                                                  
                                                                }
															  if(TdtdValues[n].nodeType == 1 && TdtdValues[n].nodeName == "TD"){
																   if(TdtdValues[n].getAttribute("onclick")){
																	  var onclickVal = TdtdValues[n].getAttribute("onclick");
																	  onclickstr = onclickVal;
		                                                              if(fieldhtmltype==6){
		                                                              	DIVHTML  +="<td  width=\"65%\" class=\"detailValueTD\" id=\""+_fjscfieldid+"\">";
		                                                              }else{
		                                                                DIVHTML  +="<td  width=\"65%\" class=\"detailValueTD\" onclick=\""+onclickVal+"\" id=\""+tmpid+"_tdwrap\">";
		                                                              }
																	  td1=1;
																   }else{
																	  if(TdtdValues[n].childNodes[0].nodeName == 'SPAN'){
																	  }else{
																		 if(fieldhtmltype!=6){
																		 	DIVHTML  +="<td  width=\"65%\" class=\"detailValueTD\" id=\""+tmpid+"_tdwrap\">";
																		 }
																	  }
																   }
																   
																   if(fieldhtmltype==6 && td1==0){
																   	  DIVHTML  +="<td  width=\"65%\" class=\"detailValueTD\" id=\""+_fjscfieldid+"\">";
																   	  td1=1;
																   }
																   var filehtml = "";
																   
																   var tdvals = TdtdValues[n].childNodes;
																   var detailSpanCount = 0;
																   var detailACount = 0;
																   for(var o=0;o<tdvals.length;o++){
																       if(tdvals[o].nodeType == 1){
																          if(tdvals[o].nodeName == "SPAN"){
																                detailSpanCount++;
																          }
																          if(tdvals[o].nodeName == "A"){
																             detailACount ++;
																          }  
			                                                           	  if(tdvals[o].nodeName == "DIV" && fieldhtmltype==6){
			                                                           	      if(tdvals[o].getAttribute("id")){
			                                                           		    	filehtml += "<div id=\""+tdvals[o].getAttribute("id")+"_d\">";
			                                                           		    	var _childnhtml = tdvals[o].innerHTML;
			                                                           		    	filehtml += "  "+_childnhtml;
			                                                           		    	filehtml += "</div>";
			                                                           		  }
			                                                           		  if(tdvals[o].nodeName == "SPAN"){
			                                                           			if(tdvals[o].getAttribute("remind")){
			                                                           			    filehtml += "<span style='color:#ACA899'>";
			                                                           			    filehtml += tdvals[o].innerHTML;
			                                                           			    filehtml += "</span>  ";
			                                                           			}
			                                                           		   }
			                                                           	   }
																       } 
																   }
																   
																   if(TdtdValues[n].getAttribute("id")){ //浏览框的时候Id
																			 DIVHTML  +="<div id=\""+TdtdValues[n].getAttribute("id")+"_d\" groupid=\""+groupid+"\" rowId=\""+rowId+"\" columnId=\""+(elementCount-2)+"\" style=\"margin-top:"+(detailSpanCount==1?"11":"0")+"px;\">"+filehtml;
																   }
																   var spanDig = 0;
																   var spanShowDigCount=0;
																    for(var o=0;o<tdvals.length;o++){
																         if(tdvals[o].nodeType == 1 && tdvals[o].nodeName == "SPAN"){//浏览框用于显示的span
																                if(tdvals[o].getAttribute("keyid")){
																                    spanShowDigCount++;
																                }
																         }
																    }
																   for(var o=0;o<tdvals.length;o++){
																		if(tdvals[o].nodeType == 1){
																			if(tdvals[o].nodeName == "SPAN"){//浏览框用于显示的span
																				if(tdvals[o].getAttribute("keyid")){
																				    var keyid =tdvals[o].getAttribute("keyid");
																				    if(spanShowDigCount ==1){
																				         DIVHTML += "<span keyid=\""+keyid+"\">"+tdvals[o].innerHTML+"</span></div>";
																				    }else{
																				        if(spanDig ==0){
																					      DIVHTML += "<span keyid=\""+keyid+"\">"+tdvals[o].innerHTML+"</span>";
																					     }else if(spanDig==spanShowDigCount){
																					        DIVHTML += "<span keyid=\""+keyid+"\">"+tdvals[o].innerHTML+"</span></div>";     
																					     }else{
																					        DIVHTML += "<span keyid=\""+keyid+"\">"+tdvals[o].innerHTML+"</span>";
																					     }
																				    }
																					 spanDig++;
																				}
																			}
																			
																			var Webclient = false;
	                                                                        if(fieldhtmltype==6){
	                                                                    	   Webclient = false; //(js_clienttype=="Webclient");
	                                                                        }
																			
																			if(tdvals[o].nodeName == "A" && !Webclient){ //浏览框中的A标签按钮
																				 var hrefVal = "";
																				 var data_relVal = "";
																				 var data_transitionVal = "";
																				 var _onclick ="";
																				 if(tdvals[o].getAttribute("href")){
																					 hrefVal = tdvals[o].getAttribute("href");
																				 }
																				 if(tdvals[o].getAttribute("data-rel")){
																					  data_relVal = tdvals[o].getAttribute("data-rel");  
																				 }
																				 if(tdvals[o].getAttribute("data-transition")){
																					 data_transitionVal = tdvals[o].getAttribute("data-transition");
																				 }
																				 
																				 if(fieldhtmltype==6){
					                                                                 _onclick = "onclick=\" "+onclickstr+"\" ";
					                                                             }
																				 
																				DIVHTML += "<a style=\"float:left;\" herf=\""+hrefVal+"\" "+(data_transitionVal==""?"":"data-transition=\""+data_transitionVal+"\"")+"  "+(data_relVal == ""?"data-rel=\"":""+data_relVal+"\"")+" "+_onclick+" >"; 
																				DIVHTML += tdvals[o].innerHTML;
																				DIVHTML +="</a>";
																			}
																			if(tdvals[o].nodeName == "SELECT"){
																				 var tdObjs=tdvals[o];
																				 var name=tdObjs.getAttribute("name");
																				 var id = tdObjs.getAttribute("id");
																				 var namebak = tdObjs.getAttribute("namebak");
																				 var onchangeStr =  "";
		                                                                         if(tdObjs.getAttribute("onchange")){
		                                                                           onchangeStr =  tdObjs.getAttribute("onchange");
		                                                                         }
																				  
																				  DIVHTML += "<select onchange=\"onChangeClick(this,"+isedit+","+groupid+","+rowId+","+elementCount+");"+onchangeStr+"\"   class=\"scroller_select\" name=\""+name+"_d\" id=\""+id+"_d\" namebak=\""+namebak+"\">";
																				  for(var p=0;p<tdObjs.options.length;p++){
																						DIVHTML += "<option value="+tdObjs.options[p].value+" "+(tdObjs.options[p].selected == true? "selected":"")+">";
																						DIVHTML += tdObjs.options[p].innerText;
																						DIVHTML +="</option>";
																				  }
																				  DIVHTML += "</select>";
																			}
																			
																			if(tdvals[o].nodeName == "LABEL"){
																				  var tdObjs=tdvals[o];
																				  var forVal=tdObjs.getAttribute("for");
																				    var htmlval = tdObjs.innerHTML;
																				  DIVHTML +=  "<label for=\""+forVal+"\">"+htmlval+"</label>";
																			}
																		   
																			
																			if(tdvals[o].nodeName == "TEXTAREA"){
																				 var tdObjs=tdvals[o];
																				 var cols = tdObjs.getAttribute("cols");
																				 var rows = tdObjs.getAttribute("rows");
																				 var name = tdObjs.getAttribute("name");
																				 var id = tdObjs.getAttribute("id");
																				 var namebak = tdObjs.getAttribute("namebak");
																				 var horizontalscrollpolicy = tdObjs.getAttribute("horizontalscrollpolicy");
																				 var verticalscrollpolicy = tdObjs.getAttribute("verticalscrollpolicy");
																				 
																				  DIVHTML +="<textarea onchange=\"onChangeClick(this,"+isedit+","+groupid+","+rowId+","+elementCount+");try{maindetailfieldchange(this);}catch(e){}\"  id=\""+id+"_d\" style=\"height:100px;\"  name=\""+name+"_d\" rows=\""+rows+"\" cols=\""+cols+"\" verticalscrollpolicy=\""+verticalscrollpolicy+"\" horizontalscrollpolicy=\""+horizontalscrollpolicy+"\"  namebak=\""+namebak+"\"  >"+tdObjs.value+"</textarea>";
																			}
																		
																			if(tdvals[o].nodeName == "INPUT"){
																				 var tdObjs=tdvals[o];
																				 var idval=tdObjs.getAttribute("id");
																				 var type = tdObjs.getAttribute("type");
																				 var name = tdObjs.getAttribute("name");
																				  var namebak = tdObjs.getAttribute("namebak");
																				  var value = tdObjs.getAttribute("value");
																				  if(tdObjs.getAttribute("datavaluetype")){
																				   var datavaluetype = tdObjs.getAttribute("datavaluetype");
																					   if(datavaluetype == 3 ||datavaluetype == 5 ){ //浮点数与金额千分位
																						 var reg =   eval("/"+idval+"/ig");
																						  var datatype = tdObjs.getAttribute("datatype");
																						  var datetype = tdObjs.getAttribute("datetype");
																						  var datalength = tdObjs.getAttribute("datalength");
																						  var onkeypress = tdObjs.getAttribute("onkeypress");
																						  onkeypress = onkeypress.replace(reg,idval+"_d");
																						  var onblur= tdObjs.getAttribute("onblur");
																						  onblur =  onblur.replace(reg,idval+"_d");
																						  if(datavaluetype == 5){
																							var onfocus = tdObjs.getAttribute("onfocus");
																							onfocus = onfocus.replace(reg,idval+"_d");
																						  }
																						  var onchange=tdObjs.getAttribute("onchange");
																						  if(onchange){
																							   var reg =   eval("/"+idval+"/ig");
																							  onchange = onchange.replace(reg,idval+"_d");
																						  }else{
																							 onchange = "";  
																						  }
																						  if(datavaluetype == 5){
																							  DIVHTML += "<input onfocus=\""+onfocus+"\"   onblur=\""+onblur+"\"  onkeypress=\""+onkeypress+"\" datavaluetype=\""+datavaluetype+"\" datalength=\""+datalength+"\" datatype=\""+datatype+"\" datetype=\""+datetype+"\"  type=\""+type+"\" id=\""+idval+"_d\" name=\""+name+"_d\" namebak=\""+namebak+"\" value=\""+value+"\" onchange=\""+onchange+";onChangeClick(this,"+isedit+","+groupid+","+rowId+","+elementCount+");\" />"; 
																						  }else{
																							  DIVHTML += "<input onblur=\""+onblur+"\"  onkeypress=\""+onkeypress+"\" datavaluetype=\""+datavaluetype+"\" datalength=\""+datalength+"\" datatype=\""+datatype+"\" datetype=\""+datetype+"\"  type=\""+type+"\" id=\""+idval+"_d\" name=\""+name+"_d\" namebak=\""+namebak+"\" value=\""+value+"\" onchange=\""+onchange+";onChangeClick(this,"+isedit+","+groupid+","+rowId+","+elementCount+");\" />";
																						  }
																					   }else if(datavaluetype == 4){ //金额千分位
																						  var reg =   eval("/"+idval+"/ig");
																						  var datatype = tdObjs.getAttribute("datatype");
																						  var datetype = tdObjs.getAttribute("datetype");
																						  var datalength = tdObjs.getAttribute("datalength");
																						  var onkeypress = tdObjs.getAttribute("onkeypress");
																						  var onblur= tdObjs.getAttribute("onblur");
																						   var onfocus = tdObjs.getAttribute("onfocus");
																						   var onchange=tdObjs.getAttribute("onchange");
																						  if(onchange){
																							   var reg =   eval("/"+idval+"/ig");
																							  onchange = onchange.replace(reg,idval+"_d");
																						  }else{
																							 onchange = "";  
																						  }
																						   if(idval.indexOf("lable") >=0){
																							   DIVHTML += "<input onchange=\"onChangeClick(this,"+isedit+","+groupid+","+rowId+","+elementCount+");"+onchange+"\" onfocus=\"FormatToNumber('"+onfocus.substring(onfocus.indexOf("'")+1,onfocus.lastIndexOf("'")).replace(/field_lable/ig,"")+"_d')\" onblur=\"numberToFormat('"+onblur.substring(onblur.indexOf("'")+1,onblur.lastIndexOf("'")).replace(/field_lable/ig,"")+"_d');onChangeClick(this,"+isedit+","+groupid+","+rowId+","+elementCount+");\" onkeypress=\"ItemNum_KeyPress('"+onkeypress.substring(onkeypress.indexOf("'")+1,onkeypress.lastIndexOf("'"))+"_d');ItemNum_KeyPress('"+name+"_d');ItemNum_KeyPress('"+name+"')\" value=\""+value+"\" namebak=\""+namebak+"\" id=\""+idval+"_d\" name=\""+name+"_d\" type=\""+type+"\" datatype=\""+datatype+"\" datetype=\""+datetype+"\" datavaluetype=\""+datavaluetype+"\" datalength=\""+datalength+"\"  />";    
																							   DIVHTML += "<BR>";
																						   }else{
																							   DIVHTML +=  "<input namebak=\""+namebak+"\" datalength=\""+datalength+"\" datavaluetype=\""+datavaluetype+"\" datetype=\""+datetype+"\" datatype=\""+datatype+"\" type=\""+type+"\" name=\""+name+"_d\" id=\""+idval+"_d\" value=\""+value+"\" />";
																							   DIVHTML +=  "<script language='javascript'> numberToFormat('"+idval.replace("field","")+"_d');<\/script>";
																						   }
																					   }else if(datavaluetype == 2){ //整数
																							 var datatype = tdObjs.getAttribute("datatype");
																							 var datetype = tdObjs.getAttribute("datetype");
																							 var datalength = tdObjs.getAttribute("datalength");
																							 var onkeypress = tdObjs.getAttribute("onkeypress");
																							   var onchange=tdObjs.getAttribute("onchange");
																							  if(onchange){
																								   var reg =   eval("/"+idval+"/ig");
																								  onchange = onchange.replace(reg,idval+"_d");
																							  }else{
																								 onchange = "";  
																							  }

																							 DIVHTML += "<input onchange=\"onChangeClick(this,"+isedit+","+groupid+","+rowId+","+elementCount+");"+onchange+"\"   value=\""+value+"\" onblur=\"checknumber1(this);checknumber1('"+onkeypress.substring(onkeypress.indexOf("'")+1,onkeypress.lastIndexOf("'"))+"');\" onkeypress=\"ItemNum_KeyPress('"+onkeypress.substring(onkeypress.indexOf("'")+1,onkeypress.lastIndexOf("'"))+"_d')\" type=\""+type+"\" datatype=\""+datatype+"\" datetype=\""+datetype+"\" datavaluetype=\""+datavaluetype+"\" datalength=\""+datalength+"\" name=\""+name+"_d\" id=\""+idval+"_d\" namebak=\""+namebak+"\" />";
																					   }else{
																					   } 
																				  }else{
																					 if(idval){
																						if(idval.indexOf("chinglish")>=0){
																							DIVHTML +=  "<input type=\""+type+"\" name=\""+name+"_d\" id=\""+idval+"_d\" value=\""+value+"\" readonly=\"readonly\" />";
																						}
																						if(type == 'checkbox'){
																							  var onchange = tdObjs.getAttribute("onchange");
																							  var disabledVal = "";
																							  var sourceJs = "";
																							  if(onchange){
																							        var reg =   eval("/"+idval+"/ig");
																							       onchange = onchange.replace(reg,idval+"_d"); 
																								   sourceJs = "var cks=document.getElementsByName('"+idval+"');for(var pk=0;pk<cks.length;pk++){if(cks[pk]){if(document.getElementById('"+idval+"').getAttribute('checked')&&document.getElementById('"+idval+"').getAttribute('checked')!='false'){cks[pk].setAttribute('value',1);}else{cks[pk].setAttribute('value',0);}}}";
																							  }else{
																							     disabledVal = "disabled";    
																							  }
																							   var checkedVal ="" ;
																								if(tdObjs.checked && tdObjs.getAttribute("checked")!="false"){
																									checkedVal ="checked";
																								}
																							DIVHTML += "<input onchange=\""+onchange+";onChangeClick(this,"+isedit+","+groupid+","+rowId+","+elementCount+");"+sourceJs+"\" "+(checkedVal)+"  name=\""+name+"_d\" id=\""+idval+"_d\" type=\""+type+"\"  "+disabledVal+" />"; 
																						}else{
																						   if(tdObjs.getAttribute("onchange")){
																							  var onchange = tdObjs.getAttribute("onchange");
																							  var reg =   eval("/"+idval+"/ig");
																							   if(onchange){
																								   var reg =   eval("/"+idval+"/ig");
																								  onchange = onchange.replace(reg,idval+"_d");
																							  }else{
																								 onchange = "";  
																							  }
																							  var classVal = tdObjs.getAttribute("class");
																							  if(classVal){
																							       if(classVal == 'scroller_date_h5'){ //日期
																							         	DIVHTML += "<input onchange=\""+onchange+";onChangeClick(this,"+isedit+","+groupid+","+rowId+","+elementCount+");"+onchange+"\" class=\""+classVal+"\" type=\""+type+"\" id=\""+idval+"_d\" name=\""+name+"_d\" namebak=\""+namebak+"\" value=\""+value+"\" />";
																								       // DIVHTML += "<script language=\"javascript\">$('#"+idval+"_d').scroller({preset: 'date',dateFormat:'yy-mm-dd',theme: 'default',display: 'bottom', mode: 'scroller',endYear:2020,nowText:'今天',setText:'确定',cancelText:'取消',monthText:'月',yearText:'年',dayText:'日',showNow:true,dateOrder: 'yymmdd',onShow: moveDataTimeContorl});<\/script>";
																							      }else if(classVal == 'scroller_time_h5'){//时间
																								      DIVHTML += "<input onchange=\""+onchange+";onChangeClick(this,"+isedit+","+groupid+","+rowId+","+elementCount+");"+onchange+"\" class=\""+classVal+"\" type=\""+type+"\" id=\""+idval+"_d\" name=\""+name+"_d\" namebak=\""+namebak+"\" value=\""+value+"\" />";
																								     // DIVHTML += "<script language=\"javascript\">$('#"+idval+"_d').scroller({preset: 'time',timeFormat:'HH:ii',theme: 'default',display: 'bottom',mode: 'scroller',nowText:'现在',setText:'确定',cancelText:'取消',minuteText:'分',hourText:'时',timeWheels:'HHii',showNow:true,onShow: moveDataTimeContorl});<\/script>"; 
																							     }
																							  }else{
																							    if(tdObjs.getAttribute("fieldtype")){
																							         var fieldtype = tdObjs.getAttribute("fieldtype");
																									 DIVHTML += "<input fieldtype=\""+fieldtype+"\" type=\""+type+"\" id=\""+idval+"_d\" name=\""+name+"_d\" namebak=\""+namebak+"\" value=\""+value+"\"  onchange=\""+onchange+";\" />"; 
																							    }else{
																							         if(value.indexOf("\"")!=-1){
																							            value = value.replace(/\"/g,"&quot;");
																							         }
																							        DIVHTML += "<input type=\""+type+"\" id=\""+idval+"_d\" name=\""+name+"_d\" namebak=\""+namebak+"\" value=\""+value+"\" onchange=\""+onchange+";onChangeClick(this,"+isedit+","+groupid+","+rowId+","+elementCount+");\" />";
																						        }
																						     }
																						   }else{
																							  var classVal = tdObjs.getAttribute("class");
																							  var onchange=tdObjs.getAttribute("onchange");
																							  if(onchange){
																								   var reg =   eval("/"+idval+"/ig");
																								  onchange = onchange.replace(reg,idval+"_d");
																							  }else{
																								 onchange = "";  
																							  }
																							  if(classVal){
																							    if(classVal == 'scroller_date_h5'){ //日期
																								DIVHTML += "<input onchange=\"onChangeClick(this,"+isedit+","+groupid+","+rowId+","+elementCount+");"+onchange+"\" class=\""+classVal+"\" type=\""+type+"\" id=\""+idval+"_d\" name=\""+name+"_d\" namebak=\""+namebak+"\" value=\""+value+"\" />";
																								       // DIVHTML += "<script language=\"javascript\">$('#"+idval+"_d').scroller({preset: 'date',dateFormat:'yy-mm-dd',theme: 'default',display: 'bottom', mode: 'scroller',endYear:2020,nowText:'今天',setText:'确定',cancelText:'取消',monthText:'月',yearText:'年',dayText:'日',showNow:true,dateOrder: 'yymmdd',onShow: moveDataTimeContorl});<\/script>";
																							      }else if(classVal == 'scroller_time_h5'){//时间
																								 DIVHTML += "<input onchange=\"onChangeClick(this,"+isedit+","+groupid+","+rowId+","+elementCount+");"+onchange+"\" class=\""+classVal+"\" type=\""+type+"\" id=\""+idval+"_d\" name=\""+name+"_d\" namebak=\""+namebak+"\" value=\""+value+"\" />";
																								     // DIVHTML += "<script language=\"javascript\">$('#"+idval+"_d').scroller({preset: 'time',timeFormat:'HH:ii',theme: 'default',display: 'bottom',mode: 'scroller',nowText:'现在',setText:'确定',cancelText:'取消',minuteText:'分',hourText:'时',timeWheels:'HHii',showNow:true,onShow: moveDataTimeContorl});<\/script>"; 
																							   }
																							 }else{
																								 if(tdObjs.getAttribute("fieldtype")){
																									 var fieldtype = tdObjs.getAttribute("fieldtype");
																									 DIVHTML += "<input fieldtype=\""+fieldtype+"\" type=\""+type+"\" id=\""+idval+"_d\" name=\""+name+"_d\" namebak=\""+namebak+"\" value=\""+value+"\" />"; 
																								 }
																							   
																						     }
																						   }
																						}
																					 }else{
																						  DIVHTML += "<input type=\""+type+"\" name=\""+name+"_d\" namebak=\""+namebak+"\" value=\""+value+"\" />"; 
																					 }
																					 
																  
																				  }
																				
																			}
																		}
																   }
															  }
															 
														  }
														  
													  }
												}
										   } 
										}
								  }  
                         		}else{
	                              if((tdValueObjs[j].nodeType == 1 && tdValueObjs[j].nodeName == "DIV")){
	                                   if(tdValueObjs[j].getAttribute("id")){
	                                       var id = tdValueObjs[j].getAttribute("id");
	                                       if(id == 'isedit'){
	                                          var tdNodes =  tdValueObjs[j].childNodes;
											  var spanCount = 0;
											  var  spanTdTotal = 0;
											  var aCount = 0;
											  var aTdTotal = 0;
											  var divTdTotal = 0;
											  if(tdNodes.length==0){
												   DIVHTML +="<td  width=\"60%\" class=\"detailValueTD\" id=\"\">";
	                                               DIVHTML += "";
	                                               DIVHTML += "</td>"; 
											  }
											   for(var v=0;v<tdNodes.length;v++){
												      if(tdNodes[v].nodeType == 1 && tdNodes[v].nodeName=='SPAN'){
														    spanTdTotal ++;
															divTdTotal ++;
												      }    
													 if(tdNodes[v].nodeType == 1 && tdNodes[v].nodeName=='A'){
														     aTdTotal ++;
															 divTdTotal ++;
												      }
													  if(tdNodes[v].nodeType == 1 && tdNodes[v].nodeName=='DIV'){
														     divTdTotal ++;
												      }
											   }
	                                           var moneryEquals ="";
	                                          for(var v=0;v<tdNodes.length;v++){
												  var spanEquals ="";
												  if(tdNodes[v].nodeType == 3 && tdNodes[v].nodeName=='#text' && tdNodes[v].nodeValue.trim() != ''){
													  if(moneryEquals == "1"){
														   DIVHTML += tdNodes[v].nodeValue+"</td>";
	                                                       moneryEquals = "";
													  }else{
														   DIVHTML +="<td  width=\"60%\" class=\"detailValueTD\" id=\"\">";
	                                                      DIVHTML += tdNodes[v].nodeValue;
	                                                      DIVHTML += "</td>";
													  }
												  }else if(tdNodes[v].nodeType == 3 && tdNodes[v].nodeName=='#text' && tdNodes.length ==1 ){
													   DIVHTML +="<td  width=\"60%\" class=\"detailValueTD\" id=\"\">";
	                                                      DIVHTML += tdNodes[v].nodeValue;
	                                                      DIVHTML += "</td>";
												  }else if(tdNodes[v].nodeType == 1 && tdNodes[v].nodeName=='SPAN'){
													  spanEquals = tdNodes[v];
													  if(spanTdTotal == 1){
														    DIVHTML +="<td  width=\"60%\" class=\"detailValueTD\" id=\"\">";
															   var spanHTML = "<SPAN ";
															   if(tdNodes[v].getAttribute("id")){
																	spanHTML += " id =\""+tdNodes[v].getAttribute("id")+"_d\"";
															   }
															   if(tdNodes[v].getAttribute("style")){
																	 spanHTML += " style =\""+tdNodes[v].getAttribute("style")+"\"";
															   }
															   if(tdNodes[v].getAttribute("onclick")){
																	spanHTML += " onclick =\""+tdNodes[v].getAttribute("onclick")+"\"";
															   }
															   if(tdNodes[v].getAttribute("keyid")){
																   spanHTML += " keyid =\""+tdNodes[v].getAttribute("keyid")+"\"";
															   }
															   
															   if(tdNodes[v].getAttribute("id")&&tdNodes[v].getAttribute("id").indexOf("chinglish")>=0){
																     spanHTML += ">"+tdNodes[v].innerHTML+ "</SPAN>";
																	 DIVHTML +=spanHTML;
																	 moneryEquals = "1";
															   }else{
	                                                                spanHTML += ">"+tdNodes[v].innerHTML + "</SPAN>";
																    DIVHTML +=spanHTML + "<td>";  
															  }
													  }else{
														  if(spanCount == 0){
															   DIVHTML +="<td  width=\"60%\" class=\"detailValueTD\" id=\"\">";
															   var spanHTML = "<SPAN ";
															   if(tdNodes[v].getAttribute("id")){
																	spanHTML += " id =\""+tdNodes[v].getAttribute("id")+"_d\"";
															   }
															   if(tdNodes[v].getAttribute("style")){
																	 spanHTML += " style =\""+tdNodes[v].getAttribute("style")+"\"";
															   }
															   if(tdNodes[v].getAttribute("onclick")){
																	spanHTML += " onclick =\""+tdNodes[v].getAttribute("onclick")+"\"";
															   }
															   if(tdNodes[v].getAttribute("keyid")){
																   spanHTML += " keyid =\""+tdNodes[v].getAttribute("keyid")+"\"";
															   }
															   spanHTML += ">"+tdNodes[v].innerHTML + "</SPAN>";
															  DIVHTML +=spanHTML + "</br>";
															  moneryEquals ="1";
														   }else if(spanCount == spanTdTotal){
																 var spanHTML = "<SPAN ";
															   if(tdNodes[v].getAttribute("id")){
																	spanHTML += " id =\""+tdNodes[v].getAttribute("id")+"_d\"";
															   }
															   if(tdNodes[v].getAttribute("style")){
																	 spanHTML += " style =\""+tdNodes[v].getAttribute("style")+"\"";
															   }
															   if(tdNodes[v].getAttribute("onclick")){
																	spanHTML += " onclick =\""+tdNodes[v].getAttribute("onclick")+"\"";
															   }
															   if(tdNodes[v].getAttribute("keyid")){
																   spanHTML += " keyid =\""+tdNodes[v].getAttribute("keyid")+"\"";
															   }
															   spanHTML += ">"+tdNodes[v].innerHTML + "</SPAN>";
															  DIVHTML +=spanHTML + "</td>";
	
														   }else{
																  var spanHTML = "<SPAN ";
																  if(tdNodes[v].getAttribute("id")){
																	spanHTML += " id =\""+tdNodes[v].getAttribute("id")+"_d\"";
																   }
																   if(tdNodes[v].getAttribute("style")){
																		 spanHTML += " style =\""+tdNodes[v].getAttribute("style")+"\"";
																   }
																   if(tdNodes[v].getAttribute("onclick")){
																		spanHTML += " onclick =\""+tdNodes[v].getAttribute("onclick")+"\"";
																   }
																   if(tdNodes[v].getAttribute("keyid")){
																	   spanHTML += " keyid =\""+tdNodes[v].getAttribute("keyid")+"\"";
																   }
																   spanHTML += ">"+tdNodes[v].innerHTML + "</SPAN>";
																  DIVHTML +=spanHTML + "</br>";
														   }
													  }
													   spanCount++;   
												  }else if(tdNodes[v].nodeType == 1 && tdNodes[v].nodeName=='A'){
													   if(aCount == 0){
														    DIVHTML +="<td  width=\"60%\" class=\"detailValueTD\" id=\"\">";
	                                                        DIVHTML +=tdNodes[v].innerHTML+"</br>";
													   }else if(aCount == aTdTotal){
	                                                        DIVHTML +=tdNodes[v].innerHTML+"</td>";
													   }else{
	                                                      DIVHTML +=tdNodes[v].innerHTML+"</br>";
													   }
	                                                   aCount++;
												  }else if(tdNodes[v].nodeType == 1 && tdNodes[v].nodeName=='DIV' && divTdTotal ==1){
													      DIVHTML +="<td  width=\"60%\" class=\"detailValueTD\">";
	                                                      DIVHTML += tdNodes[v].innerHTML;
	                                                      DIVHTML += "</td>";
												  }
	                                              if(tdNodes[v].nodeType == 1){
														 //不可编辑的时候
														 if((tdNodes[v].nodeType == 1 && tdNodes[v].nodeName == "DIV")){
																isEditDisplay ="<div >"+tdNodes[v].innerHTML+"</div>";
														  }
														 if(spanEquals == tdNodes[v]){
														 }else{
															  if((tdNodes[v].nodeType == 1 && tdNodes[v].nodeName == "SPAN")){
																  if(tdNodes[v].getAttribute("id")){
																		DIVHTML +="<td  width=\"60%\" class=\"detailValueTD\">"+isEditDisplay+"<span id=\""+tdNodes[v].getAttribute("id")+"_d\">"+tdNodes[v].innerHTML;
																  }
															  }
															   if((tdNodes[v].nodeName=='#text'&&tdNodes[v].nodeValue.trim()!='')){
															     DIVHTML += tdNodes[v].nodeValue +"</span></td>";
																 isEditDisplay ="";
														      }
								                         }
												 
	                          if(tdNodes[v].nodeType == 1 && tdNodes[v].nodeName=='TABLE'){
	                                var tdTables = tdNodes[v].childNodes;
	                                var fieldhtmltype = 0;
	                                var onclickstr = "";
	                                var _fjscfieldid = "";
	                                try{
	                                	fieldhtmltype = tdNodes[v].getAttribute("fieldhtmltype");
	                                }catch(e){}
	                                try{
                                        _fjscfieldid = tdNodes[v].getAttribute("_id");
                                    }catch(e){}
		                                for(var k=0;k<tdTables.length;k++){
		                                   if(tdTables[k].nodeType==1&&tdTables[k].nodeName == 'TBODY'){
		                                        var tdTrValues = tdTables[k].childNodes;
		                                        for(var m=0;m<tdTrValues.length;m++){
		                                              if(tdTrValues[m].nodeType == 1 && tdTrValues[m].nodeName == 'TR'){
		                                                  var TdtdValues=tdTrValues[m].childNodes;
		                                                  for(var n=0;n<TdtdValues.length;n++){
			                                                  var tmpid = "";
			                                                  try{
			                                                      var t = TdtdValues[n].childNodes;
				                                                  tmpid = t[0].getAttribute("id") ;
				                                                  if(tmpid==null||tmpid==''){
																    tmpid = t[1].getAttribute("id") ;
																  }
				                                               	  tmpid =  tmpid.replace(/field_lable/,"field"); 
				                                               	  if(fieldhtmltype==6){
				                                               	     tmpid = _fjscfieldid ;
				                                               	  }
			                                                  }catch(e){
				                                                  
			                                                  }
			                                                  
		                                                      if(TdtdValues[n].nodeType == 1 && TdtdValues[n].nodeName == "TD"){
		                                                           if(TdtdValues[n].getAttribute("onclick")){
		                                                              var onclickVal = TdtdValues[n].getAttribute("onclick");
		                                                              onclickstr = onclickVal;
		                                                              if(fieldhtmltype==6){
		                                                              	DIVHTML  +="<td  width=\"60%\" class=\"detailValueTD\" id=\""+_fjscfieldid+"_tdwrap\" >";
		                                                              }else{
		                                                                DIVHTML  +="<td  width=\"60%\" class=\"detailValueTD\" onclick=\""+onclickVal+"\" id=\""+tmpid+"_tdwrap\">";
		                                                              }
		                                                              
		                                                              td1 = 1;
		                                                           }else{
																	    try{
																	      
																		  if(TdtdValues[n].childNodes[0].nodeName == 'SPAN'){
																			  var ismand= TdtdValues[n].childNodes[0].getAttribute("class");
																			  if(ismand && ismand =='ismand'){
																				   var mandSpanId=  TdtdValues[n].childNodes[0].getAttribute("id");
	                                                                               mandSpanId = mandSpanId.substring(0,mandSpanId.lastIndexOf("_"))+"_d_ismandspan";
																				   var displayVal = "";
																				   var realityId = mandSpanId.substring(0,mandSpanId.lastIndexOf("_")-2);
																				  if(document.getElementById(realityId).value&&document.getElementById(realityId).value!=""){
																					    displayVal = "display:none;";
																				  }else{
																					  displayVal = "display:block;";
																				  }
																				  var mandSpanStyle=  TdtdValues[n].childNodes[0].getAttribute("style");
	                                                                              DIVHTML  +="<span id=\""+mandSpanId+"\" style=\"color: red;font-size: 16pt;float:right;"+displayVal+"\" >"+TdtdValues[n].childNodes[0].innerHTML+"</span>";
																			  }else{
																			      var mandSpanId=  TdtdValues[n].childNodes[0].getAttribute("id");
	                                                                              mandSpanId = mandSpanId.substring(0,mandSpanId.lastIndexOf("_"))+"_d_ismandspan";
																			      DIVHTML  +="<span id=\""+mandSpanId+"\" style=\"color: red;font-size: 16pt;float:right;display:none;\" >"+TdtdValues[n].childNodes[0].innerHTML+"</span>";
																			  }
																		  }else{
																			  if(TdtdValues[n].childNodes[0].nodeName == 'DIV'||TdtdValues[n].childNodes[0].nodeName == 'A'){
																			  }else{
																			      if(fieldhtmltype!=6){
																				   	DIVHTML  +="<td  width=\"60%\" class=\"detailValueTD\" id=\""+tmpid+"_tdwrap\">";
																				  }
																			  }
																		  }
																	   }catch(e){
																	   }
		                                                           }
		                                                           //htmltype=3的时候，也添加一个td标签
                                                                   //if(fieldhtmltype==6 && td1==0){
		                                                           if((fieldhtmltype==6 || fieldhtmltype==3 )&& td1==0){
																  	DIVHTML  +="<td  width=\"60%\" class=\"detailValueTD\" id=\""+_fjscfieldid+"_tdwrap\">";
																  	td1=1;
																   }
		                                                           
		                                                           var filehtml = "";
	
		                                                           var tdvals = TdtdValues[n].childNodes;
		                                                           var aspanCount = 0;
		                                                           var detailSpanCount =0;
		                                                            for(var o=0;o<tdvals.length;o++){
		                                                                  if(tdvals[o].nodeName == "A"){
		                                                                     aspanCount ++;
		                                                                  }
		                                                                  if(tdvals[o].nodeName == "SPAN"){
		                                                                     detailSpanCount ++;
		                                                                  }
		                                                                  
		                                                                  if(fieldhtmltype==6){
				                                                           		if(tdvals[o].nodeName == "DIV"){
				                                                           		    if(tdvals[o].getAttribute("id")){
				                                                           		    	filehtml += "<div id=\""+tdvals[o].getAttribute("id")+"_d\">";
				                                                           		    	var _childnhtml = tdvals[o].innerHTML;
				                                                           		    	filehtml += "  "+_childnhtml;
				                                                           		    	filehtml += "</div>";
				                                                           		    }
				                                                           		}
				                                                           		if(tdvals[o].nodeName == "SPAN"){
				                                                           			if(tdvals[o].getAttribute("remind")){
				                                                           			    filehtml += "<span style='color:#ACA899'>";
				                                                           			    filehtml += tdvals[o].innerHTML;
				                                                           			    filehtml += "</span>  ";
				                                                           			}
				                                                           		}
				                                                           		
				                                                           }
		                                                            }
		                                                           
		                                                           if(TdtdValues[n].getAttribute("id")){ //浏览框的时候Id
	                                                                     DIVHTML  +="<div id=\""+TdtdValues[n].getAttribute("id")+"_d\" groupid=\""+groupid+"\" rowId=\""+rowId+"\" columnId=\""+(elementCount-2)+"\" style=\"margin-top:"+(detailSpanCount==1?"11":"0")+"px;\">"+filehtml;
																   }
																   var spanDig = 0;
																   var spanDigCount=0;
																   for(var o=0;o<tdvals.length;o++){
																         if(tdvals[o].nodeType == 1 && tdvals[o].nodeName == "SPAN"){
																                spanDigCount ++;
																         }
																   }
		                                                           for(var o=0;o<tdvals.length;o++){
		                                                                if(tdvals[o].nodeType == 1){
		                                                                    if(tdvals[o].nodeName == "SPAN"){//浏览框用于显示的span
		                                                                        if(tdvals[o].getAttribute("keyid")){
		                                                                            var keyid =tdvals[o].getAttribute("keyid");
		                                                                            if(spanDigCount ==1){
		                                                                               DIVHTML += "<span keyid=\""+keyid+"\" >"+tdvals[o].innerHTML+"</span></div>";
		                                                                            }else{
		                                                                                if(spanDig ==0){
		                                                                                   DIVHTML += "<span keyid=\""+keyid+"\" >"+tdvals[o].innerHTML+"</span></br>";
		                                                                                }else if(spanDig == spanDigCount){
		                                                                                   DIVHTML += "<span keyid=\""+keyid+"\" >"+tdvals[o].innerHTML+"</span></div>";
		                                                                                }else{
		                                                                                   DIVHTML += "<span keyid=\""+keyid+"\" >"+tdvals[o].innerHTML+"</span></br>";
		                                                                                }
		                                                                            }
		                                                                            spanDig ++;  
		                                                                        }
		                                                                    }
		                                                                    var Webclient = false;
		                                                                    if(fieldhtmltype==6){
		                                                                    	Webclient =  (js_clienttype=="Webclient");
		                                                                    }
		                                                                    
		                                                                    
		                                                                    if(tdvals[o].nodeName == "A" && !Webclient){ //浏览框中的A标签按钮
		                                                                         var hrefVal = "";
		                                                                         var data_relVal = "";
		                                                                         var data_transitionVal = "";
	                                                                             DIVHTML += "<a style=\"float:left;\"";
		                                                                         if(tdvals[o].getAttribute("href")){
		                                                                             hrefVal = tdvals[o].getAttribute("href");
																					 DIVHTML += " herf=\""+hrefVal+"\"";
		                                                                         }
		                                                                         if(tdvals[o].getAttribute("data-rel")){
		                                                                              data_relVal = tdvals[o].getAttribute("data-rel"); 
																					  DIVHTML += " data-rel=\""+data_relVal+"\"";
		                                                                         }
		                                                                         if(tdvals[o].getAttribute("data-transition")){
		                                                                             data_transitionVal = tdvals[o].getAttribute("data-transition");
																					  DIVHTML += " data-transition=\""+data_transitionVal+"\"";
		                                                                         }
		                                                                         
		                                                                         if(fieldhtmltype==6){
		                                                                         	DIVHTML += " onclick=\""+onclickstr+"\"";
		                                                                         }
		                                                                         
		                                                                         
		                                                                        DIVHTML += ">"+tdvals[o].innerHTML;
		                                                                        DIVHTML +="</a>";
		                                                                        if(aspanCount>1){
		                                                                           DIVHTML +="<br>";
		                                                                        }
		                                                                        
		                                                                    }
		                                                                    if(tdvals[o].nodeName == "SELECT"){
		                                                                         var tdObjs=tdvals[o];
		                                                                         var name=tdObjs.getAttribute("name");
		                                                                         var id = tdObjs.getAttribute("id");
		                                                                         var namebak = tdObjs.getAttribute("namebak");
		                                                                          var onchangeStr =  "";
		                                                                         if(tdObjs.getAttribute("onchange")){
		                                                                              onchangeStr =  tdObjs.getAttribute("onchange");
		                                                                         }
		                                                                         if(onchangeStr.indexOf("changeshowattr")!=-1){
                                                                                    tempselfield += ""+id+",";
                                                                                  }
		                                                                         DIVHTML += "<select onchange=\"onChangeClick(this,"+isedit+","+groupid+","+rowId+","+elementCount+");"+onchangeStr+"\"   class=\"scroller_select\" name=\""+name+"_d\" id=\""+id+"_d\" namebak=\""+namebak+"\">";
		                                                                          var selectNameVal = "";
		                                                                          for(var p=0;p<tdObjs.options.length;p++){
		                                                                                DIVHTML += "<option value="+tdObjs.options[p].value+" "+(tdObjs.options[p].selected == true? "selected":"")+">";
		                                                                                DIVHTML += tdObjs.options[p].innerText;
		                                                                                DIVHTML +="</option>";
		                                                                                if(tdObjs.options[p].selected){
		                                                                                   selectNameVal+=tdObjs.options[p].innerText;
		                                                                                }
		                                                                          }
		                                                                          DIVHTML += "</select>";
		                                                                          
		                                                                    }
		                                                                    
		                                                                    if(tdvals[o].nodeName == "LABEL"){
		                                                                          var tdObjs=tdvals[o];
		                                                                          var forVal=tdObjs.getAttribute("for");
		                                                                          var htmlval = tdObjs.innerHTML;
																					  DIVHTML +=  "<label for=\""+forVal+"\">"+htmlval+"</label>";
		                                                                    }
		                                                                   
		                                                                    
		                                                                    if(tdvals[o].nodeName == "TEXTAREA"){
		                                                                         var tdObjs=tdvals[o];
		                                                                         var cols = tdObjs.getAttribute("cols");
		                                                                         var rows = tdObjs.getAttribute("rows");
		                                                                         var name = tdObjs.getAttribute("name");
		                                                                         var id = tdObjs.getAttribute("id");
		                                                                         var namebak = tdObjs.getAttribute("namebak");
		                                                                         var horizontalscrollpolicy = tdObjs.getAttribute("horizontalscrollpolicy");
		                                                                         var verticalscrollpolicy = tdObjs.getAttribute("verticalscrollpolicy");
		                                                                         
		                                                                         DIVHTML +="<textarea onchange=\"onChangeClick(this,"+isedit+","+groupid+","+rowId+","+elementCount+");try{maindetailfieldchange(this);}catch(e){}\"  id=\""+id+"_d\"  name=\""+name+"_d\" style=\"height:100px;\"  rows=\""+rows+"\" cols=\""+cols+"\" verticalscrollpolicy=\""+verticalscrollpolicy+"\" horizontalscrollpolicy=\""+horizontalscrollpolicy+"\"  namebak=\""+namebak+"\"  >"+tdObjs.value+"</textarea>";
		                                                                    }
		                                                                
		                                                                    if(tdvals[o].nodeName == "INPUT"){
		                                                                         var tdObjs=tdvals[o];
		                                                                         var idval=tdObjs.getAttribute("id");
		                                                                         var type = tdObjs.getAttribute("type");
		                                                                         var name = tdObjs.getAttribute("name");
		                                                                          var namebak = tdObjs.getAttribute("namebak");
		                                                                          var value = tdObjs.getAttribute("value");
		                                                                          if(tdObjs.getAttribute("datavaluetype")){
		                                                                           var datavaluetype = tdObjs.getAttribute("datavaluetype");
		                                                                               if(datavaluetype == 3 ||datavaluetype == 5 ){ //浮点数与金额千分位
		                                                                                 var reg =   eval("/"+idval+"/ig");
		                                                                                  var datatype = tdObjs.getAttribute("datatype");
		                                                                                  var datetype = tdObjs.getAttribute("datetype");
		                                                                                  var datalength = tdObjs.getAttribute("datalength");
		                                                                                  var onkeypress = tdObjs.getAttribute("onkeypress");
		                                                                                  onkeypress = onkeypress.replace(reg,idval+"_d");
		                                                                                  var onblur= tdObjs.getAttribute("onblur");
		                                                                                  onblur =  onblur.replace(reg,idval+"_d");
		                                                                                  if(datavaluetype == 5){
		                                                                                    var onfocus = tdObjs.getAttribute("onfocus");
		                                                                                    onfocus = onfocus.replace(reg,idval+"_d");
		                                                                                  }
																						   var onchange=tdObjs.getAttribute("onchange");
																							if(onchange){
																								   var reg =   eval("/"+idval+"/ig");
																								  onchange = onchange.replace(reg,idval+"_d");
																							}else{
																								 onchange = "";  
																							 }
		                                                                                  if(datavaluetype == 5){
		                                                                                      DIVHTML += "<input onfocus=\""+onfocus+"\"   onblur=\""+onblur+"\"  onkeypress=\""+onkeypress+"\" datavaluetype=\""+datavaluetype+"\" datalength=\""+datalength+"\" datatype=\""+datatype+"\" datetype=\""+datetype+"\"  type=\""+type+"\" id=\""+idval+"_d\" name=\""+name+"_d\" namebak=\""+namebak+"\" value=\""+value+"\" onchange=\""+onchange+";onChangeClick(this,"+isedit+","+groupid+","+rowId+","+elementCount+");\" />"; 
		                                                                                  }else{
		                                                                                      DIVHTML += "<input onblur=\""+onblur+"\"  onkeypress=\""+onkeypress+"\" datavaluetype=\""+datavaluetype+"\" datalength=\""+datalength+"\" datatype=\""+datatype+"\" datetype=\""+datetype+"\"  type=\""+type+"\" id=\""+idval+"_d\" name=\""+name+"_d\" namebak=\""+namebak+"\" value=\""+value+"\" onchange=\""+onchange+";onChangeClick(this,"+isedit+","+groupid+","+rowId+","+elementCount+");\" />";
		                                                                                  }
		                                                                               }else if(datavaluetype == 4){ //金额千分位
		                                                                                  var reg =   eval("/"+idval+"/ig");
		                                                                                  var datatype = tdObjs.getAttribute("datatype");
		                                                                                  var datetype = tdObjs.getAttribute("datetype");
		                                                                                  var datalength = tdObjs.getAttribute("datalength");
		                                                                                  var onkeypress = tdObjs.getAttribute("onkeypress");
		                                                                                  var onblur= tdObjs.getAttribute("onblur");
		                                                                                   var onfocus = tdObjs.getAttribute("onfocus");
																						   var onchange=tdObjs.getAttribute("onchange");
																							if(onchange){
																								   var reg =   eval("/"+idval+"/ig");
																								  onchange = onchange.replace(reg,idval+"_d");
																							}else{
																								 onchange = "";  
																							 }
		                                                                                   if(idval.indexOf("lable") >=0){
		                                                                                       DIVHTML += "<input onchange=\"onChangeClick(this,"+isedit+","+groupid+","+rowId+","+elementCount+");"+onchange+"\" onfocus=\"FormatToNumber('"+onfocus.substring(onfocus.indexOf("'")+1,onfocus.lastIndexOf("'")).replace(/field_lable/ig,"")+"_d')\" onkeypress=\"ItemNum_KeyPress('"+name+"_d')\" value=\""+value+"\" namebak=\""+namebak+"\" id=\""+idval+"_d\" onblur=\"numberToFormat('"+onblur.substring(onblur.indexOf("'")+1,onblur.lastIndexOf("'")).replace(/field_lable/ig,"")+"_d');onChangeClick(this,"+isedit+","+groupid+","+rowId+","+elementCount+");calSum("+groupid+");ItemNum_KeyPress('"+name+"_d');ItemNum_KeyPress('"+name+"')\" name=\""+name+"_d\" type=\""+type+"\" datatype=\""+datatype+"\" datetype=\""+datetype+"\" datavaluetype=\""+datavaluetype+"\" datalength=\""+datalength+"\"  />";    
		                                                                                       DIVHTML += "<BR>";
		                                                                                   }else{
		                                                                                       DIVHTML +=  "<input namebak=\""+namebak+"\" datalength=\""+datalength+"\" datavaluetype=\""+datavaluetype+"\" datetype=\""+datetype+"\" datatype=\""+datatype+"\" type=\""+type+"\" name=\""+name+"_d\" id=\""+idval+"_d\" value=\""+value+"\" />";
		                                                                                       DIVHTML +=  "<script language='javascript'> numberToFormat('"+idval.replace("field","")+"_d');<\/script>";
		                                                                                   }
		                                                                               }else if(datavaluetype == 2){ //整数
		                                                                                     var datatype = tdObjs.getAttribute("datatype");
		                                                                                     var datetype = tdObjs.getAttribute("datetype");
		                                                                                     var datalength = tdObjs.getAttribute("datalength");
		                                                                                     var onkeypress = tdObjs.getAttribute("onkeypress");
																							 var onchange=tdObjs.getAttribute("onchange");
																							 if(onchange){
																								   var reg =   eval("/"+idval+"/ig");
																								  onchange = onchange.replace(reg,idval+"_d");
																							 }else{
																								 onchange = "";  
																							 }
		                                                                                     DIVHTML += "<input onchange=\"onChangeClick(this,"+isedit+","+groupid+","+rowId+","+elementCount+");"+onchange+"\"   value=\""+value+"\" onblur=\"checknumber1(this);calSum("+groupid+");ItemNum_KeyPress('"+onkeypress.substring(onkeypress.indexOf("'")+1,onkeypress.lastIndexOf("'"))+"');\" onkeypress=\"ItemNum_KeyPress('"+onkeypress.substring(onkeypress.indexOf("'")+1,onkeypress.lastIndexOf("'"))+"_d')\" type=\""+type+"\" datatype=\""+datatype+"\" datetype=\""+datetype+"\" datavaluetype=\""+datavaluetype+"\" datalength=\""+datalength+"\" name=\""+name+"_d\" id=\""+idval+"_d\" namebak=\""+namebak+"\" />";
		                                                                               }else{
		                                                                               } 
		                                                                          }else{
		                                                                             if(idval){
		                                                                                if(idval.indexOf("chinglish")>=0){
		                                                                                    DIVHTML +=  "<input type=\""+type+"\" name=\""+name+"_d\" id=\""+idval+"_d\" value=\""+value+"\" readonly=\"readonly\" />";
		                                                                                }
		                                                                                if(type == 'checkbox'){
		                                                                                      var onchange = tdObjs.getAttribute("onchange");
		                                                                                      var disabledVal = "";
																							   var sourceJs = "";
		                                                                                      if(onchange){
		                                                                                           var reg =   eval("/"+idval+"/ig");
		                                                                                           onchange = onchange.replace(reg,idval+"_d");
																								   sourceJs = "var cks=document.getElementsByName('"+idval+"');for(var pk=0;pk<cks.length;pk++){if(cks[pk]){if(document.getElementById('"+idval+"').getAttribute('checked')&&document.getElementById('"+idval+"').getAttribute('checked')!='false'){cks[pk].setAttribute('value',1);}else{cks[pk].setAttribute('value',0);}}}";
		                                                                                      }else{
		                                                                                          disabledVal = "disabled";
		                                                                                      }
																							   var checkedVal ="" ;
																							   if(tdObjs.checked && tdObjs.getAttribute("checked")!="false"){
																										checkedVal ="checked";
																							   }
		                                                                                    DIVHTML += "<input onchange=\""+onchange+";onChangeClick(this,"+isedit+","+groupid+","+rowId+","+elementCount+");"+sourceJs+"\" "+(checkedVal)+"  name=\""+name+"_d\" id=\""+idval+"_d\" type=\""+type+"\"  "+disabledVal+" />"; 
		                                                                                }else{
		                                                                                   if(tdObjs.getAttribute("onchange")){
		                                                                                      var onchange = tdObjs.getAttribute("onchange");
		                                                                                      var reg =   eval("/"+idval+"/ig");
		                                                                                      onchange = onchange.replace(reg,idval+"_d");
		                                                                                      if(onchange.indexOf("dataInput")>=0){
		                                                                                          if(onchange.indexOf(",")>=0){
		                                                                                              var onchangeStr =   onchange.split(",");
		                                                                                              if(onchangeStr.length>1){
		                                                                                                   for(var ai=0;ai<onchangeStr.length;ai++){
		                                                                                                        if(onchangeStr[ai].indexOf("_")!=-1
		                                                                                                                &&onchangeStr[ai].indexOf("_d")==-1){
		                                                                                                               if(ai!=onchangeStr.length-1){
																														   if(onchange.indexOf("try")!=-1){
																															   onchange = onchange.replace("try{maindetailfieldchange(this);}catch(e){}","");
																															   onchange = onchange.replace(onchangeStr[ai],onchangeStr[ai]+"_d");
																															   onchange += ";try{maindetailfieldchange(this);}catch(e){}";
																															 }else{
																																onchange = onchange.replace(onchangeStr[ai],onchangeStr[ai]+"_d");
																															}
		                                                                                                               }else{
																														   if(onchange.indexOf("try")!=-1){
																															   onchange = onchange.replace("try{maindetailfieldchange(this);}catch(e){}","");
																															   onchange =onchange.substring(0,onchange.length-3)+"_d')";
																															   onchange += ";try{maindetailfieldchange(this);}catch(e){}";
																															 }else{
																																onchange =  onchange.substring(0,onchange.length-3)+"_d')";	
																															}
		                                                                                                               } 
		                                                                                                        }
		                                                                                                   }
		                                                                                              }
		                                                                                          }
		                                                                                      }
		                                                                                       var classVal = tdObjs.getAttribute("class");
																								  if(classVal){
																								        if(classVal == 'scroller_date_h5'){ //日期
																								        DIVHTML += "<input onchange=\""+onchange+";onChangeClick(this,"+isedit+","+groupid+","+rowId+","+elementCount+");\" class=\""+classVal+"\" type=\""+type+"\" id=\""+idval+"_d\" name=\""+name+"_d\" namebak=\""+namebak+"\" value=\""+value+"\"/>";
																								      //DIVHTML += "<script language=\"javascript\">$('#"+idval+"_d').scroller({preset: 'date',dateFormat:'yy-mm-dd',theme: 'default',display: 'bottom', mode: 'scroller',endYear:2020,nowText:'今天',setText:'确定',cancelText:'取消',monthText:'月',yearText:'年',dayText:'日',showNow:true,dateOrder: 'yymmdd',onShow: moveDataTimeContorl});<\/script>";
																							      }else if(classVal == 'scroller_time_h5'){//时间
																							      		DIVHTML += "<input onchange=\""+onchange+";onChangeClick(this,"+isedit+","+groupid+","+rowId+","+elementCount+");\" class=\""+classVal+"\" type=\""+type+"\" id=\""+idval+"_d\" name=\""+name+"_d\" namebak=\""+namebak+"\" value=\""+value+"\"/>";
																								     // DIVHTML += "<script language=\"javascript\">$('#"+idval+"_d').scroller({preset: 'time',timeFormat:'HH:ii',theme: 'default',display: 'bottom',mode: 'scroller',nowText:'现在',setText:'确定',cancelText:'取消',minuteText:'分',hourText:'时',timeWheels:'HHii',showNow:true,onShow: moveDataTimeContorl});<\/script>"; 
																								     }
																								  }else{
																								    if(tdObjs.getAttribute("fieldtype")){
																								         var fieldtype = tdObjs.getAttribute("fieldtype");
																										 DIVHTML += "<input fieldtype=\""+fieldtype+"\" type=\""+type+"\" id=\""+idval+"_d\" name=\""+name+"_d\" namebak=\""+namebak+"\" value=\""+value+"\"  onchange=\""+onchange+";\" />"; 
																								    }else{
																								         if(value.indexOf("\"")!=-1){
																								            value = value.replace(/\"/g,"&quot;");
																								         }
																								         DIVHTML += "<input type=\""+type+"\" id=\""+idval+"_d\" name=\""+name+"_d\" namebak=\""+namebak+"\" value=\""+value+"\" onchange=\""+onchange+";onChangeClick(this,"+isedit+","+groupid+","+rowId+","+elementCount+");\" />";
																							        }
																							     }
		                                                                                   }else{
		                                                                                       var classVal = tdObjs.getAttribute("class");
																								if(classVal){
																									   if(classVal == 'scroller_date_h5'){ //日期
																									DIVHTML += "<input onchange=\"onChangeClick(this,"+isedit+","+groupid+","+rowId+","+elementCount+");"+onchange+"\" class=\""+classVal+"\" type=\""+type+"\" id=\""+idval+"_d\" name=\""+name+"_d\" namebak=\""+namebak+"\" value=\""+value+"\" />";
																								       // DIVHTML += "<script language=\"javascript\">$('#"+idval+"_d').scroller({preset: 'date',dateFormat:'yy-mm-dd',theme: 'default',display: 'bottom', mode: 'scroller',endYear:2020,nowText:'今天',setText:'确定',cancelText:'取消',monthText:'月',yearText:'年',dayText:'日',showNow:true,dateOrder: 'yymmdd',onShow: moveDataTimeContorl});<\/script>";
																							      }else if(classVal == 'scroller_time_h5'){//时间
																									 DIVHTML += "<input onchange=\"onChangeClick(this,"+isedit+","+groupid+","+rowId+","+elementCount+");"+onchange+"\" class=\""+classVal+"\" type=\""+type+"\" id=\""+idval+"_d\" name=\""+name+"_d\" namebak=\""+namebak+"\" value=\""+value+"\" />";
																								     // DIVHTML += "<script language=\"javascript\">$('#"+idval+"_d').scroller({preset: 'time',timeFormat:'HH:ii',theme: 'default',display: 'bottom',mode: 'scroller',nowText:'现在',setText:'确定',cancelText:'取消',minuteText:'分',hourText:'时',timeWheels:'HHii',showNow:true,onShow: moveDataTimeContorl});<\/script>"; 
																								 }
																								}else{
																									 if(tdObjs.getAttribute("fieldtype")){
																										 var fieldtype = tdObjs.getAttribute("fieldtype");
																										 DIVHTML += "<input fieldtype=\""+fieldtype+"\" type=\""+type+"\" id=\""+idval+"_d\" name=\""+name+"_d\" namebak=\""+namebak+"\" value=\""+value+"\" />"; 
																									 }
																								   
																							   }
	
	
		                                                                                   }
		                                                                                }
		                                                                             }else{
		                                                                                  DIVHTML += "<input type=\""+type+"\" name=\""+name+"_d\" namebak=\""+namebak+"\" value=\""+value+"\" />"; 
		                                                                             }
		                                                                             
		                                                          
		                                                                          }
		                                                                        
		                                                                    }
		                                                                }
		                                                           }
		                                                      }
		                                                     
		                                                  }
							                         if(fieldhtmltype == 3
							                             && ((tdNodes[v].getAttribute("showtree")==1 && (tdNodes[v].getAttribute("fieldtype") == 161 || tdNodes[v].getAttribute("fieldtype") == 162))
							                                  )){
							                             if(aspanCount == 0){
							                                 DIVHTML += "<%="<span style='color:#ACA899'>["+SystemEnv.getHtmlLabelName(83659,user.getLanguage())+"]</span>"%>";
							                             }else if(aspanCount == 1){
							                                 DIVHTML += "<br><%="<span style='color:#ACA899'>["+SystemEnv.getHtmlLabelName(83657,user.getLanguage())+"]</span>"%>";
							                             }else{
							                                 DIVHTML += "<%="<span style='color:#ACA899'>["+SystemEnv.getHtmlLabelName(83657,user.getLanguage())+"]</span>"%>";
							                             }
							                         }
		                                              }
		                                        }
		                                   } 
		                                }
		                          }         
	                                                       
	                                              }
	                                          }
	                                       }
	                                   }
	                              }
                         		}
						  }
                      }
                      DIVHTML += "</td></tr>";
                  }
                  elementCount ++ ;
              }
        }      
        tableObj.innerHTML = DIVHTML;
        document.getElementById("trspace"+groupid+"_"+rowId).style.display ="block";
        jQuery(document.getElementById("tdspace"+groupid+"_"+rowId)).html("");
                //jQuery(document.getElementById("tdspace"+groupid+"_"+rowId)).append(divObj);
        jQuery(document.getElementById("tdspace"+groupid+"_"+rowId)).append(tableObj);
        jQuery(document.getElementById("tdspace"+groupid+"_"+rowId)).css("width",widthPosition);
        jQuery(document.getElementById("trspace"+groupid+"_"+rowId)).css("width",widthPosition);
        try{
            if(tempselfield!=''){
                var selfieldids = tempselfield.split(",");
                for(var i = 0 ; i < selfieldids.length ; i++){
                    if(selfieldids[i]!=''){
                        jQuery("#"+selfieldids[i]+"_d").trigger("change");
                    }
                }
            }
        }catch(e){
        }
        try{
            dyeditPageFnaFyFun(groupid,rowId,fieldCount,isedit,isdisplay);
        }catch(ex){}
   }
   
   //移动到tr上的事件
   function trMouseOver(groupId,rowId){
        var trspaceObj =  document.getElementById("trspace"+groupId+"_"+rowId);
        if(trspaceObj.style.display == "none"){
         document.getElementById("a"+groupId+"_"+rowId).onclick();
         if(document.getElementById("table"+groupId).style.width){
             jQuery(document.getElementById("table"+groupId)).css("width","");
         }
        }else{
           detailtableMouseOut(groupId,rowId);  
        }
   }
   
   //移出tr上的事件
   function trMouseOut(groupId,rowId){
      document.getElementById("trspace"+groupId+"_"+rowId).style.display ="none";
       if(document.getElementById("table"+groupId).style.width){
             jQuery(document.getElementById("table"+groupId)).css("width","");
         }
   }
   //明细表中移上去的时候显示
   function detailtableMouseOver(groupId,rowId){
       document.getElementById("trspace"+groupId+"_"+rowId).style.display ="block";
        if(document.getElementById("table"+groupId).style.width){
             jQuery(document.getElementById("table"+groupId)).css("width","");
         }
   }
   //明细表中移出的时候不显示，并且同步该表格数据到主表中
   function detailtableMouseOut(groupId,rowId){
     jQuery(document.getElementById("trspace"+groupId+"_"+rowId)).slideUp();
       if(document.getElementById("table"+groupId).style.width){
             jQuery(document.getElementById("table"+groupId)).css("width","");
       }
   }
   
   //点击明细表的数据，同步到主表相对应的字段 目前使用此方法
   function onChangeClick(obj,isedit,groupId,rowId,colId){
     colId = colId -2; //前面包含了2列
     var vtype = 0;
     var ismand = "";
     if(isedit){
           if(obj.nodeType == 1){
	           if(obj.nodeName == "INPUT"){
	               var id   = obj.getAttribute("id");
	               var type = obj.getAttribute("type");
	               var name = obj.getAttribute("name");
	               var copyid = id.substring(0,id.lastIndexOf("_d"));
	               if("" == copyid){copyid = id;}
	                  
	               if(type == 'checkbox'){
	                  if(obj.checked){
	                       document.getElementById(copyid).checked = true; 
						   document.getElementById(id).checked = true; 
	                  }else{
	                      document.getElementById(copyid).checked = false;
						  document.getElementById(copyid).removeAttribute("checked");
						  document.getElementById(id).checked = false;
						  document.getElementById(id).removeAttribute("checked");
	                  }  
	               }else{
	                  //判断是否为金额千分位
	                  if(obj.getAttribute("datavaluetype")){
	                       var datavaluetype = obj.getAttribute("datavaluetype");
	                       if(datavaluetype == 5){
	                           var re;
	                           if(obj.value.indexOf(".")<0){
	                                  re = /(\d{1,3})(?=(\d{3})+($))/g;
	                            }else{
	                                  re = /(\d{1,3})(?=(\d{3})+(\.))/g;
	                            }
	                           var tovalue = obj.value.replace(re,"$1,");
	                           document.getElementById(id).setAttribute("value",tovalue);
	                           document.getElementById(copyid).setAttribute("value",tovalue);
	                           document.getElementById(copyid).value = tovalue;
	                       }else{
	                           document.getElementById(id).setAttribute("value",document.getElementById(id).value);
	                           document.getElementById(copyid).setAttribute("value",document.getElementById(id).value);
	                           document.getElementById(copyid).value = document.getElementById(id).value; 
	                       }
	                  }else{
	                      document.getElementById(id).setAttribute("value",document.getElementById(id).value);
	                      document.getElementById(copyid).setAttribute("value",document.getElementById(id).value);
	                      document.getElementById(copyid).value = document.getElementById(id).value; 
	                  }
	               }
	           }
	           if(obj.nodeName == "SELECT"){
	               var id   = obj.getAttribute("id");
	               var name = obj.getAttribute("name");
	               var copyid = id.substring(0,id.lastIndexOf("_d"));
	               if("" == copyid){copyid = id;}
	               var targetObj = document.getElementById(copyid);
	               
	               for(var i=0;i<obj.options.length;i++){
	                    if(obj.options[i].selected){
	                         targetObj.options[i].selected = true; 
	                    }else{
	                         targetObj.options[i].selected = false; 
	                    }
	               }

				   if(document.getElementById(copyid+"child")){
	                 try{
					     var selChange = targetObj.getAttribute("onchange");
					     if(selChange.indexOf("changeChildFieldDetail")!=-1){
					          targetObj.value = obj.value;
					          jQuery(targetObj).trigger("onchange");
					     }
					   }catch(e){}
					}
	               
	           }
	           if(obj.nodeName == "TEXTAREA"){
	               var id   = obj.getAttribute("id");
	               var name = obj.getAttribute("name");
	               var copyid = id.substring(0,id.lastIndexOf("_d"));
	               if("" == copyid){copyid = id;}
	                document.getElementById(id).innerHTML = "";
	                document.getElementById(id).innerHTML = obj.value;
	                document.getElementById(id).setAttribute("value",obj.value);
	                document.getElementById(copyid).innerHTML = "";
	                document.getElementById(copyid).innerHTML =   obj.value;
	                document.getElementById(copyid).setAttribute("value",obj.value);
	               
	           }
	      }  
     }else{
	         if(obj.nodeType == 1){
	           if(obj.nodeName == "INPUT"){
	               var id   = obj.getAttribute("id");
	               var type = obj.getAttribute("type");
	               var name = obj.getAttribute("name");
	               var copyid = id.substring(0,id.lastIndexOf("_d"));
	               if("" == copyid){copyid = id;}
	                  
	               if(type == 'checkbox'){
	                   var name=obj.getAttribute("name");
	                  var checkHtml = "<input type=\"checkbox\" id=\""+id+"\" name=\""+name+"\"  "+(obj.checked?"checked":"")+" disabled  \><label for=\""+id+"\"></label>";
	                  document.getElementById("isshow"+groupId+"_"+rowId+"_"+colId+"").innerHTML = checkHtml;
	                  if(obj.checked){
						   document.getElementById(copyid).setAttribute("checked","true");
						   if(document.getElementById(copyid).getAttribute("onchange")){
							    document.getElementById(copyid).onchange(); 
						   }
						    document.getElementById(id).setAttribute("checked","true");
	                  }else{
						  document.getElementById(copyid).setAttribute("checked","false");
						 if(document.getElementById(copyid).getAttribute("onchange")){
							    document.getElementById(copyid).onchange(); 
						   }
						  document.getElementById(copyid).removeAttribute("checked");
						  document.getElementById(id).setAttribute("checked","false");
						  document.getElementById(id).removeAttribute("checked");

	                  }
	               }else{
	                  //判断是否为金额千分位
	                  if(obj.getAttribute("datavaluetype")){
	                       var datavaluetype = obj.getAttribute("datavaluetype");
	                       if(datavaluetype == 5){ //金额千分位
	                           var re;
	                           if(obj.value.indexOf(".")<0){
	                                  re = /(\d{1,3})(?=(\d{3})+($))/g;
	                            }else{
	                                  re = /(\d{1,3})(?=(\d{3})+(\.))/g;
	                            }
	                           var tovalue = obj.value.replace(re,"$1,");
	                           document.getElementById(id).setAttribute("value",tovalue);
	                           document.getElementById(copyid).setAttribute("value",tovalue);
	                           document.getElementById(copyid).value = tovalue; 
	                           document.getElementById("isshow"+groupId+"_"+rowId+"_"+colId+"").innerHTML =tovalue; 
							   //判断必填的验证
							    var idSplitIdStr =id+"_ismandspan";
							    var ismandObj=document.getElementById(idSplitIdStr);
							    vtype = document.getElementById(copyid+"_d").getAttribute("vtype");
                                ismand = ismandObj.getAttribute("class");
                                var _isedit = 0;
                                if(document.getElementById("oldfieldview"+copyid.replace("field",""))){
                                    _isedit = document.getElementById("oldfieldview"+copyid.replace("field","")).value ;
                                }
                                if(ismandObj){
                                    if(vtype==null||vtype==-1||vtype==1||vtype==3){
                                        if(ismand=='ismand'||(vtype==-1&&_isedit>2)){
                                                if(document.getElementById(id).value && document.getElementById(id)!=""){
                                                        ismandObj.style.display = "none";
                                                }else{
                                                        ismandObj.style.display = "block";
                                                }
                                        }else{
                                           ismandObj.style.display = "none";
                                        }
                                    }else if(vtype==2){
                                          if(document.getElementById(id).value && document.getElementById(id)!=""){
                                                  ismandObj.style.display = "none";
                                          }else{
                                                  ismandObj.style.display = "block";
                                          }
                                    }
                                    
                                }
	                       }else if(datavaluetype == 3||datavaluetype == 2||datavaluetype == 4){ //浮点数与整数
	                             document.getElementById(id).setAttribute("value",document.getElementById(id).value);
	                             document.getElementById(copyid).setAttribute("value",document.getElementById(id).value);
	                             document.getElementById(copyid).value = document.getElementById(id).value;
								 var tempval = document.getElementById(id).value;
	                             var datalength = obj.getAttribute("datalength");
	                             var tempvalue = "";
	                             if(datavaluetype == 4){ //金额转换
									  var moneyFormat = document.getElementById(id).value.replace(/,/g,'');
									    if(moneyFormat == '' || moneyFormat == '0' ){
											 moneyFormat =  "0.00";
										}else{
                                             moneyFormat = milfloatFormat(toPrecision(moneyFormat,datalength));
										}
										if(tempval.indexOf(',')!=-1){
										   tempval = tempval.replace(/,/g,'');
										}
										if(!isNaN(tempval)){
	                                       document.getElementById("isshow"+groupId+"_"+rowId+"_"+colId+"").innerHTML = numberChangeToChinese(toPrecision(document.getElementById(id).value.replace(/,/g,''),datalength));
	                                       document.getElementById("isshow"+groupId+"_"+rowId+"_"+colId+"").innerHTML += "("+moneyFormat+")";
										}else{
										   document.getElementById("isshow"+groupId+"_"+rowId+"_"+colId+"").innerHTML = "";
										   document.getElementById("isshow"+groupId+"_"+rowId+"_"+colId+"").innerHTML += "";
										}
											 
									   //金额转换需要将label去掉赋值
									   if(copyid.indexOf("_")>=0){
										    var copyidSplit = copyid.split("_");
											var copyidSplitIdStr =copyidSplit[0]+copyidSplit[1].replace(/lable/g,"")+"_"+copyidSplit[2];
											document.getElementById(copyidSplitIdStr).setAttribute("value",toPrecision(document.getElementById(id).value.replace(/,/g,''),datalength));
									   }
									    //判断必填的验证
									   if(id.indexOf("_")>=0){
										    var idSplit = id.split("_");
											var idSplitIdStr =idSplit[0]+idSplit[1].replace(/lable/g,"")+"_"+idSplit[2]+"_d_ismandspan";
											var ismandObj=document.getElementById(idSplitIdStr);
											vtype = document.getElementById(copyid.replace("_lable","")+"_d").getAttribute("vtype");
				                            ismand = ismandObj.getAttribute("class");
				                            var _isedit = 0;
				                            if(document.getElementById("oldfieldview"+copyid.replace("field_lable","").replace("field",""))){
				                                _isedit = document.getElementById("oldfieldview"+copyid.replace("field_lable","").replace("field","")).value ;
				                            }
				                            window.console.log("id="+id+" vtype="+vtype+" ismand="+ismand+" _isedit="+_isedit);
				                            if(ismandObj){
				                                if(vtype==null||vtype==-1||vtype==1||vtype==3){
				                                    if(ismand=='ismand'||(vtype==-1&&_isedit>2)||(ismand==null&&vtype==null&&_isedit>2)){
				                                            if(document.getElementById(id).value && document.getElementById(id)!=""){
				                                                    ismandObj.style.display = "none";
				                                            }else{
				                                                    ismandObj.style.display = "block";
				                                            }
				                                    }else{
				                                       ismandObj.style.display = "none";
				                                    }
				                                }else if(vtype==2){
				                                      if(document.getElementById(id).value && document.getElementById(id)!=""){
				                                              ismandObj.style.display = "none";
				                                      }else{
				                                              ismandObj.style.display = "block";
				                                      }
				                                }
				                                
				                            }
									   }
	                             }else{
									  var tempvalint = document.getElementById(id).value;
									  if(!isNaN(tempvalint)){
	                                  document.getElementById("isshow"+groupId+"_"+rowId+"_"+colId+"").innerHTML = toPrecision(document.getElementById(id).value,datalength);
									  }else{
									  document.getElementById("isshow"+groupId+"_"+rowId+"_"+colId+"").innerHTML ="";
									  }
									   //判断必填的验证
										var idSplitIdStr =id+"_ismandspan";
										var ismandObj=document.getElementById(idSplitIdStr);
										vtype = document.getElementById(copyid+"_d").getAttribute("vtype");
										//if(vtype==null||vtype==undefined||vtype=="") vtype = -1 ;
			                            ismand = ismandObj.getAttribute("class");
			                            var _isedit = 0;
			                            if(document.getElementById("oldfieldview"+copyid.replace("field",""))){
			                                _isedit = document.getElementById("oldfieldview"+copyid.replace("field","")).value ;
			                            }
			                            if(ismandObj){
			                                if(vtype==null||vtype==-1||vtype==1||vtype==3){
			                                    if(ismand=='ismand'||(vtype==-1&&_isedit>2)){
			                                            if(document.getElementById(id).value && document.getElementById(id)!=""){
			                                                    ismandObj.style.display = "none";
			                                            }else{
			                                                    ismandObj.style.display = "block";
			                                            }
			                                    }else{
			                                       ismandObj.style.display = "none";
			                                    }
			                                }else if(vtype==2){
			                                      if(document.getElementById(id).value && document.getElementById(id)!=""){
			                                              ismandObj.style.display = "none";
			                                      }else{
			                                              ismandObj.style.display = "block";
			                                      }
			                                }
			                                
			                            }
	                             }
	                       }else{
	                           document.getElementById(id).setAttribute("value",document.getElementById(id).value);
	                           document.getElementById(copyid).setAttribute("value",document.getElementById(id).value);
	                           document.getElementById(copyid).value = document.getElementById(id).value;
	                           document.getElementById("isshow"+groupId+"_"+rowId+"_"+colId+"").innerHTML =document.getElementById(id).value; 
							    //判断必填的验证
							    var idSplitIdStr =id+"_ismandspan";
							    var ismandObj=document.getElementById(idSplitIdStr);
							    vtype = document.getElementById(copyid+"_d").getAttribute("vtype");
							    if(vtype==null||vtype==undefined||vtype=="") vtype = -1 ;
	                            ismand = ismandObj.getAttribute("class");
	                            var _isedit = 0;
	                            if(document.getElementById("oldfieldview"+copyid.replace("field",""))){
	                                _isedit = document.getElementById("oldfieldview"+copyid.replace("field","")).value ;
	                            }
	                            if(ismandObj){
	                                if(vtype==null||vtype==-1||vtype==1||vtype==3){
	                                    if(ismand=='ismand'||(vtype==-1&&_isedit>2)){
	                                            if(document.getElementById(id).value && document.getElementById(id)!=""){
	                                                    ismandObj.style.display = "none";
	                                            }else{
	                                                    ismandObj.style.display = "block";
	                                            }
	                                    }else{
	                                       ismandObj.style.display = "none";
	                                    }
	                                }else if(vtype==2){
	                                      if(document.getElementById(id).value && document.getElementById(id)!=""){
	                                              ismandObj.style.display = "none";
	                                      }else{
	                                              ismandObj.style.display = "block";
	                                      }
	                                }
	                                
	                            }
	                       }
	                  }else{
	                      document.getElementById(id).setAttribute("value",document.getElementById(id).value);
	                      document.getElementById(copyid).setAttribute("value",document.getElementById(id).value);
	                      document.getElementById(copyid).value = document.getElementById(id).value; 
	                      document.getElementById("isshow"+groupId+"_"+rowId+"_"+colId+"").innerHTML =document.getElementById(id).value; 
						   //判断必填的验证
						  var idSplitIdStr =id+"_ismandspan";
						  var ismandObj=document.getElementById(idSplitIdStr);
						    vtype = document.getElementById(copyid+"_d").getAttribute("vtype");
		                    ismand = ismandObj.getAttribute("class");
		                    var _isedit = 0;
		                    if(document.getElementById("oldfieldview"+copyid.replace("field",""))){
		                        _isedit = document.getElementById("oldfieldview"+copyid.replace("field","")).value ;
		                    }
		                    if(ismandObj){
		                        if(vtype==null||vtype==-1||vtype==1||vtype==3){
		                            if(ismand=='ismand'||(vtype==-1&&_isedit>2)){
		                                    if(document.getElementById(id).value && document.getElementById(id)!=""){
		                                            ismandObj.style.display = "none";
		                                    }else{
		                                            ismandObj.style.display = "block";
		                                    }
		                            }else{
		                               ismandObj.style.display = "none";
		                            }
		                        }else if(vtype==2){
		                              if(document.getElementById(id).value && document.getElementById(id)!=""){
		                                      ismandObj.style.display = "none";
		                              }else{
		                                      ismandObj.style.display = "block";
		                              }
		                        }
		                        
		                    }
	                  }
	               }
	           }
	           if(obj.nodeName == "SELECT"){
	               var id   = obj.getAttribute("id");
	               var name = obj.getAttribute("name");
	               var copyid = id.substring(0,id.lastIndexOf("_d"));
	               if("" == copyid){copyid = id;}
	               var targetObj = document.getElementById(copyid);

	               var selectNameVal = "";
	               for(var i=0;i<obj.options.length;i++){
	                    if(obj.options[i].selected){
	                         targetObj.options[i].selected = true; 
	                         selectNameVal = obj.options[i].innerHTML;
	                    }else{
	                         targetObj.options[i].selected = false; 
	                    }
	               }
	               document.getElementById("isshow"+groupId+"_"+rowId+"_"+colId+"").innerHTML = selectNameVal;
	               if(document.getElementById(copyid+"child")){
	                 try{
					     var selChange = targetObj.getAttribute("onchange");
					     if(selChange.indexOf("changeChildFieldDetail")!=-1){
					          targetObj.value = obj.value;
					          jQuery(targetObj).trigger("onchange");
					     }
					   }catch(e){}
					}
				   //判断必填的验证
					var idSplitIdStr =id+"_ismandspan";
					var ismandObj=document.getElementById(idSplitIdStr);
					//var isedit = document.getElementById("oldfieldview"+copyid);
				    vtype = document.getElementById(copyid+"_d").getAttribute("vtype");
				    if(vtype==null||vtype==undefined||vtype=="") vtype = -1 ;
                    ismand = ismandObj.getAttribute("class");
                    var _isedit = 0;
                    if(document.getElementById("oldfieldview"+copyid.replace("field",""))){
                        _isedit = document.getElementById("oldfieldview"+copyid.replace("field","")).value ;
                    }
                    if(ismandObj){
                        if(vtype==null||vtype==undefined||vtype==-1||vtype==1||vtype==3){
                            if(ismand=='ismand'||(vtype==-1&&_isedit>2)){
                                    if(selectNameVal!=""){
                                            ismandObj.style.display = "none";
                                    }else{
                                            ismandObj.style.display = "block";
                                    }
                            }else{
                               ismandObj.style.display = "none";
                            }
                        }else if(vtype==2){
                              if(selectNameVal!=""){
                                      ismandObj.style.display = "none";
                              }else{
                                      ismandObj.style.display = "block";
                              }
                        }
                        
                    }
	           }
	           if(obj.nodeName == "TEXTAREA"){
	               var id   = obj.getAttribute("id");
	               var name = obj.getAttribute("name");
	               var copyid = id.substring(0,id.lastIndexOf("_d"));
	               if("" == copyid){copyid = id;}
	                document.getElementById(id).innerHTML = "";
	                document.getElementById(id).innerHTML = obj.value;
	                document.getElementById(id).setAttribute("value",obj.value);
	                document.getElementById(copyid).innerHTML = "";
	                document.getElementById(copyid).innerHTML =   obj.value;
	                document.getElementById(copyid).setAttribute("value",obj.value);
	                document.getElementById("isshow"+groupId+"_"+rowId+"_"+colId+"").innerHTML = obj.value;
					 //判断必填的验证
					var idSplitIdStr =id+"_ismandspan";
					var ismandObj=document.getElementById(idSplitIdStr);
				    
					vtype = document.getElementById(copyid+"_d").getAttribute("vtype");
                    ismand = ismandObj.getAttribute("class");
                    var _isedit = 0;
                    if(document.getElementById("oldfieldview"+copyid.replace("field",""))){
                        _isedit = document.getElementById("oldfieldview"+copyid.replace("field","")).value ;
                    }
                    if(ismandObj){
                        if(vtype==null||vtype==-1||vtype==1||vtype==3){
                            if(ismand=='ismand'||(vtype==-1&&_isedit>2)){
		                            if(obj.value&& obj.value!=""){
		                                    ismandObj.style.display = "none";
		                            }else{
		                                    ismandObj.style.display = "block";
		                            }
	                        }else{
	                           ismandObj.style.display = "none";
	                        }
                        }else if(vtype==2){
                              if(obj.value&& obj.value!=""){
                                      ismandObj.style.display = "none";
                              }else{
                                      ismandObj.style.display = "block";
                              }
                        }
                        
                    }
	           }
	      }
     }
      
   }
   
   //将value值变更成最新的数据
   function onchangeData(obj){
        if(obj.nodeType == 1){
            if(obj.nodeName == "INPUT"){
              var copyid = obj.getAttribute("id");
              if(copyid){
                   obj.setAttribute("value",obj.value);
                   //document.getElementById(copyid+"_d").value = obj.value;
                   //document.getElementById(copyid+"_d").setAttribute("value",obj.value);
              }
           }
           if(obj.nodeName == "SELECT"){
             
           }
           if(obj.nodeName == "TEXTAREA"){
               
           } 
        }
   }
   
   //同步数据到表格中去
   function sysData(groupId,rowId){
       var tdspaceObj=document.getElementById("tdspace"+groupId+"_"+rowId);
       var spacesNodes=tdspaceObj.childNodes;
       for(var i=0;i<spacesNodes.length;i++){
           if(spacesNodes[i].nodeType == 1){
              var tBodyNodesObj=spacesNodes[i].childNodes;
              for(var j=0;j<tBodyNodesObj.length;j++){
                  if(tBodyNodesObj[i].nodeType == 1){
                     var ttrNodesObjs=tBodyNodesObj[i].childNodes;
                     for(var k=0;k<ttrNodesObjs.length;k++){
                         var ttdNodesObjs=ttrNodesObjs[k].childNodes;
                          for(var m=0;m<ttdNodesObjs.length;m++){
                              var tvalueNodesObjs =  ttdNodesObjs[m].childNodes;
                              for(var n=0;n<tvalueNodesObjs.length;n++){
                                 if(tvalueNodesObjs[n].nodeType == 1){
                                     var tvlaueObjs =  tvalueNodesObjs[n];
                                     var id=tvlaueObjs.getAttribute("id");
                                     if(id){
                                         var copyid = id.substring(0,id.lastIndexOf("_d"));
                                         if("" == copyid){copyid = id;}
                                         if(tvlaueObjs.nodeName == "INPUT"){
                                              document.getElementById(id).setAttribute("value",document.getElementById(id).value);
                                              document.getElementById(copyid).setAttribute("value",document.getElementById(id).value);
                                              document.getElementById(copyid).value = document.getElementById(id).value;
                                         }
                                         if(tvlaueObjs.nodeName == "SELECT"){
                                         
                                         }
                                         if(tvlaueObjs.nodeName == "TEXTAREA"){
                                              document.getElementById(copyid).innerHTML =  document.getElementById(id).innerHTML;
                                         }   
                                     }
                                 }   
                              }
                          }
                     }
                  }
              }
           }
       }
   }
   
 /**
 * 阻止事件冒泡
 * @param e 事件event 
 * @param handler 事件源对象
 * @return 当且仅当时间源对象为handle时，返回true
 */
function isMouseLeaveOrEnter(e, handler) {
    if (e.type != 'click') return false;
    var reltg = e.relatedTarget ? e.relatedTarget : e.type == 'click' ? e.toElement : e.fromElement;
    while (reltg && reltg != handler)
        reltg = reltg.parentNode;
    return (reltg != handler);
}



</script>