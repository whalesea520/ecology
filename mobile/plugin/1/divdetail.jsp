
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
 nodeId =  request.getParameter("nodeId");
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
		//out.println(html);
	//}
//}

%>
<script>
    //动态生成编辑页面
  function  dyeditPage(groupid,rowId,fieldCount,isedit,isdisplay){
	    var isEditDisplay="";
        var elementCount = 0;
        var tableObj =  document.createElement("table");
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
                      for(var j=0;j<tdValueObjs.length;j++){
						  if(isdisplay){
							    if(tdValueObjs[j].nodeType == 1 && tdValueObjs[j].nodeName=='SPAN'){
									 var spanId= tdValueObjs[j].getAttribute("id");
									 var spanName= tdValueObjs[j].getAttribute("name");
									  DIVHTML +="<td  width=\"65%\" class=\"detailValueTD\">";
								      DIVHTML += "<span id=\""+spanId+"_d\" name=\""+spanName+"_d\">"; 
									  DIVHTML += tdValueObjs[j].innerHTML;
									  DIVHTML += "</span></td>";
								}

								if(tdValueObjs.length ==1 && tdValueObjs[j].nodeName =="#text"){
                                      DIVHTML +="<td  width=\"65%\" class=\"detailValueTD\">"+tdValueObjs[j].nodeValue+"</td>";
								}

								if(tdValueObjs[j].nodeType ==1 && tdValueObjs[j].nodeName =="INPUT"){
									if(tdValueObjs[j].getAttribute("fieldType")){
                                        DIVHTML +="<td  width=\"65%\" class=\"detailValueTD\">"+tdValueObjs[j].getAttribute("value")+"</td>";
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
																		    if(tddisplayChildObj.checked && tddisplayChildObj.checked==true){
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
										for(var k=0;k<tdTables.length;k++){
										   if(tdTables[k].nodeType==1&&tdTables[k].nodeName == 'TBODY'){
												var tdTrValues = tdTables[k].childNodes;
												for(var m=0;m<tdTrValues.length;m++){
													  if(tdTrValues[m].nodeType == 1 && tdTrValues[m].nodeName == 'TR'){
														  var TdtdValues=tdTrValues[m].childNodes;
														  for(var n=0;n<TdtdValues.length;n++){
															  if(TdtdValues[n].nodeType == 1 && TdtdValues[n].nodeName == "TD"){
																   if(TdtdValues[n].getAttribute("onclick")){
																	  var onclickVal = TdtdValues[n].getAttribute("onclick");
																	  DIVHTML  +="<td  width=\"65%\" class=\"detailValueTD\" onclick=\""+onclickVal+"\">";
																   }else{
																	  if(TdtdValues[n].childNodes[0].nodeName == 'SPAN'){
																	  }else{
																		 DIVHTML  +="<td  width=\"65%\" class=\"detailValueTD\">";
																	  }
																   }
																	if(TdtdValues[n].getAttribute("id")){ //浏览框的时候Id
																			 DIVHTML  +="<div id=\""+TdtdValues[n].getAttribute("id")+"_d\" groupid=\""+groupid+"\" rowId=\""+rowId+"\" columnId=\""+(elementCount-2)+"\">";
																	   }
																   var tdvals = TdtdValues[n].childNodes;
																   for(var o=0;o<tdvals.length;o++){
																		if(tdvals[o].nodeType == 1){
																			if(tdvals[o].nodeName == "SPAN"){//浏览框用于显示的span
																				if(tdvals[o].getAttribute("keyid")){
																					  var keyid =tdvals[o].getAttribute("keyid");
																					  DIVHTML += "<span keyid=\""+keyid+"\">"+tdvals[o].innerHTML+"</span></div>";
																				}
																			}
																			if(tdvals[o].nodeName == "A"){ //浏览框中的A标签按钮
																				 var hrefVal = "";
																				 var data_relVal = "";
																				 var data_transitionVal = "";
																				 if(tdvals[o].getAttribute("href")){
																					 hrefVal = tdvals[o].getAttribute("href");
																				 }
																				 if(tdvals[o].getAttribute("data-rel")){
																					  data_relVal = tdvals[o].getAttribute("data-rel");  
																				 }
																				 if(tdvals[o].getAttribute("data-transition")){
																					 data_transitionVal = tdvals[o].getAttribute("data-transition");
																				 }
																				DIVHTML += "<a style=\"float:left;\" herf=\""+hrefVal+"\" "+(data_transitionVal==""?"":"data-transition=\""+data_transitionVal+"\"")+"  "+(data_relVal == ""?"data-rel=\"":""+data_relVal+"\"")+" >"; 
																				DIVHTML += tdvals[o].innerHTML;
																				DIVHTML +="</a>";
																			}
																			if(tdvals[o].nodeName == "SELECT"){
																				 var tdObjs=tdvals[o];
																				 var name=tdObjs.getAttribute("name");
																				 var id = tdObjs.getAttribute("id");
																				 var namebak = tdObjs.getAttribute("namebak");
																				  DIVHTML += "<select onchange=\"onChangeClick(this,"+isedit+","+groupid+","+rowId+","+elementCount+");\"   class=\"scroller_select\" name=\""+name+"_d\" id=\""+id+"_d\" namebak=\""+namebak+"\">";
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
																				  DIVHTML +=  "<label for=\""+forVal+"\"></label>";
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
																				 
																				 DIVHTML +="<textarea onchange=\"onChangeClick(this,"+isedit+","+groupid+","+rowId+","+elementCount+");\"  id=\""+id+"_d\" style=\"height:40px;\"  name=\""+name+"_d\" rows=\""+rows+"\" cols=\""+cols+"\" verticalscrollpolicy=\""+verticalscrollpolicy+"\" horizontalscrollpolicy=\""+horizontalscrollpolicy+"\"  namebak=\""+namebak+"\"  >"+tdObjs.value+"</textarea>";
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
																						   if(idval.indexOf("lable") >=0){
																							   DIVHTML += "<input onchange=\"onChangeClick(this,"+isedit+","+groupid+","+rowId+","+elementCount+");\" onfocus=\"FormatToNumber('"+onfocus.substring(onfocus.indexOf("'")+1,onfocus.lastIndexOf("'")).replace(/field_lable/ig,"")+"_d')\" onblur=\"numberToFormat('"+onblur.substring(onblur.indexOf("'")+1,onblur.lastIndexOf("'")).replace(/field_lable/ig,"")+"_d');onChangeClick(this,"+isedit+","+groupid+","+rowId+","+elementCount+");\" onkeypress=\"ItemNum_KeyPress('"+onkeypress.substring(onkeypress.indexOf("'")+1,onkeypress.lastIndexOf("'"))+"_d');ItemNum_KeyPress('"+name+"_d');ItemNum_KeyPress('"+name+"')\" value=\""+value+"\" namebak=\""+namebak+"\" id=\""+idval+"_d\" name=\""+name+"_d\" type=\""+type+"\" datatype=\""+datatype+"\" datetype=\""+datetype+"\" datavaluetype=\""+datavaluetype+"\" datalength=\""+datalength+"\"  />";    
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
																							 DIVHTML += "<input onchange=\"onChangeClick(this,"+isedit+","+groupid+","+rowId+","+elementCount+");\"   value=\""+value+"\" onblur=\"checknumber1(this);checknumber1('"+onkeypress.substring(onkeypress.indexOf("'")+1,onkeypress.lastIndexOf("'"))+"');\" onkeypress=\"ItemNum_KeyPress('"+onkeypress.substring(onkeypress.indexOf("'")+1,onkeypress.lastIndexOf("'"))+"_d')\" type=\""+type+"\" datatype=\""+datatype+"\" datetype=\""+datetype+"\" datavaluetype=\""+datavaluetype+"\" datalength=\""+datalength+"\" name=\""+name+"_d\" id=\""+idval+"_d\" namebak=\""+namebak+"\" />";
																					   }else{
																					   } 
																				  }else{
																					 if(idval){
																						if(idval.indexOf("chinglish")>=0){
																							DIVHTML +=  "<input type=\""+type+"\" name=\""+name+"_d\" id=\""+idval+"_d\" value=\""+value+"\" readonly=\"readonly\" />";
																						}
																						if(type == 'checkbox'){
																							  var onchange = tdObjs.getAttribute("onchange");
																							  var reg =   eval("/"+idval+"/ig");
																							  onchange = onchange.replace(reg,idval+"_d");
																							DIVHTML += "<input onchange=\""+onchange+";onChangeClick(this,"+isedit+","+groupid+","+rowId+","+elementCount+");\" "+(tdObjs.checked?"checked":"")+"  name=\""+name+"_d\" id=\""+idval+"_d\" type=\""+type+"\"  />"; 
																						}else{
																						   if(tdObjs.getAttribute("onchange")){
																							  var onchange = tdObjs.getAttribute("onchange");
																							  var reg =   eval("/"+idval+"/ig");
																							  onchange = onchange.replace(reg,idval+"_d");
																							  DIVHTML += "<input type=\""+type+"\" id=\""+idval+"_d\" name=\""+name+"_d\" namebak=\""+namebak+"\" value=\""+value+"\" onchange=\""+onchange+";onChangeClick(this,"+isedit+","+groupid+","+rowId+","+elementCount+");\" />";
																						   }else{
																							  var classVal = tdObjs.getAttribute("class");
																							  if(classVal){
																								if(classVal == 'scroller_date'){ //日期
																								DIVHTML += "<input onchange=\"onChangeClick(this,"+isedit+","+groupid+","+rowId+","+elementCount+");\" class=\""+classVal+"\" type=\""+type+"\" id=\""+idval+"_d\" name=\""+name+"_d\" namebak=\""+namebak+"\" value=\""+value+"\" readonly=\"readonly\" />";
																								DIVHTML += "<script language=\"javascript\">$('#"+idval+"_d').scroller({preset: 'date',dateFormat:'yy-mm-dd',theme: 'default',display: 'bottom', mode: 'scroller',endYear:2020,nowText:'今天',setText:'确定',cancelText:'取消',monthText:'月',yearText:'年',dayText:'日',showNow:true,dateOrder: 'yymmdd',onShow: moveDataTimeContorl});<\/script>";
																							   }else if(classVal == 'scroller_time'){//时间
																								 DIVHTML += "<input onchange=\"onChangeClick(this,"+isedit+","+groupid+","+rowId+","+elementCount+");\" class=\""+classVal+"\" type=\""+type+"\" id=\""+idval+"_d\" name=\""+name+"_d\" namebak=\""+namebak+"\" value=\""+value+"\" readonly=\"readonly\" />";
																								 DIVHTML += "<script language=\"javascript\">$('#"+idval+"_d').scroller({preset: 'time',timeFormat:'HH:ii',theme: 'default',display: 'bottom',mode: 'scroller',nowText:'现在',setText:'确定',cancelText:'取消',minuteText:'分',hourText:'时',timeWheels:'HHii',showNow:true,onShow: moveDataTimeContorl});<\/script>"; 
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
                                          for(var v=0;v<tdNodes.length;v++){
                                              if(tdNodes[v].nodeType == 1){
                             //不可编辑的时候
							 if((tdNodes[v].nodeType == 1 && tdNodes[v].nodeName == "DIV")){
									isEditDisplay ="<div >"+tdNodes[v].innerHTML+"</div>";
							  }
							  if((tdNodes[v].nodeType == 1 && tdNodes[v].nodeName == "SPAN")){
									DIVHTML +="<td  width=\"60%\" class=\"detailValueTD\">"+isEditDisplay+"<span id=\""+tdNodes[v].getAttribute("id")+"_d\">"+tdNodes[v].innerHTML;
							  }
							 
							  if((tdNodes[v].nodeName=='#text'&&tdNodes[v].nodeValue.trim()!='')){
								   DIVHTML += tdNodes[v].nodeValue +"</span></td>";
									isEditDisplay ="";
							  }
                          if(tdNodes[v].nodeType == 1 && tdNodes[v].nodeName=='TABLE'){
                                var tdTables = tdNodes[v].childNodes;
	                                for(var k=0;k<tdTables.length;k++){
	                                   if(tdTables[k].nodeType==1&&tdTables[k].nodeName == 'TBODY'){
	                                        var tdTrValues = tdTables[k].childNodes;
	                                        for(var m=0;m<tdTrValues.length;m++){
	                                              if(tdTrValues[m].nodeType == 1 && tdTrValues[m].nodeName == 'TR'){
	                                                  var TdtdValues=tdTrValues[m].childNodes;
	                                                  for(var n=0;n<TdtdValues.length;n++){
	                                                      if(TdtdValues[n].nodeType == 1 && TdtdValues[n].nodeName == "TD"){
	                                                           if(TdtdValues[n].getAttribute("onclick")){
	                                                              var onclickVal = TdtdValues[n].getAttribute("onclick");
	                                                              DIVHTML  +="<td  width=\"60%\" class=\"detailValueTD\" onclick=\""+onclickVal+"\">";
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
                                                                              DIVHTML  +="<span id=\""+mandSpanId+"\" style=\"color: red;font-size: 20pt;float:right;"+displayVal+"\" >"+TdtdValues[n].childNodes[0].innerHTML+"</span>";
																		  }
																	  }else{
																		 DIVHTML  +="<td  width=\"60%\" class=\"detailValueTD\">";
																	  }
																   }catch(e){
																   }
	                                                           } 
															   if(TdtdValues[n].getAttribute("id")){ //浏览框的时候Id
                                                                     DIVHTML  +="<div id=\""+TdtdValues[n].getAttribute("id")+"_d\" groupid=\""+groupid+"\" rowId=\""+rowId+"\" columnId=\""+(elementCount-2)+"\">";
															   }
	                                                           var tdvals = TdtdValues[n].childNodes;
	                                                           for(var o=0;o<tdvals.length;o++){
	                                                                if(tdvals[o].nodeType == 1){
	                                                                    if(tdvals[o].nodeName == "SPAN"){//浏览框用于显示的span
	                                                                        if(tdvals[o].getAttribute("keyid")){
	                                                                              var keyid =tdvals[o].getAttribute("keyid");
	                                                                              DIVHTML += "<span keyid=\""+keyid+"\">"+tdvals[o].innerHTML+"</span></div>";
	                                                                        }
	                                                                    }
	                                                                    if(tdvals[o].nodeName == "A"){ //浏览框中的A标签按钮
	                                                                         var hrefVal = "";
	                                                                         var data_relVal = "";
	                                                                         var data_transitionVal = "";
	                                                                         if(tdvals[o].getAttribute("href")){
	                                                                             hrefVal = tdvals[o].getAttribute("href");
	                                                                         }
	                                                                         if(tdvals[o].getAttribute("data-rel")){
	                                                                              data_relVal = tdvals[o].getAttribute("data-rel");  
	                                                                         }
	                                                                         if(tdvals[o].getAttribute("data-transition")){
	                                                                             data_transitionVal = tdvals[o].getAttribute("data-transition");
	                                                                         }
	                                                                        DIVHTML += "<a style=\"float:left;\" herf=\""+hrefVal+"\" "+(data_transitionVal==""?"":"data-transition=\""+data_transitionVal+"\"")+"  "+(data_relVal == ""?"data-rel=\"":""+data_relVal+"\"")+" >"; 
	                                                                        DIVHTML += tdvals[o].innerHTML;
	                                                                        DIVHTML +="</a>";
	                                                                    }
	                                                                    if(tdvals[o].nodeName == "SELECT"){
	                                                                         var tdObjs=tdvals[o];
	                                                                         var name=tdObjs.getAttribute("name");
	                                                                         var id = tdObjs.getAttribute("id");
	                                                                         var namebak = tdObjs.getAttribute("namebak");
	                                                                          DIVHTML += "<select onchange=\"onChangeClick(this,"+isedit+","+groupid+","+rowId+","+elementCount+");\"   class=\"scroller_select\" name=\""+name+"_d\" id=\""+id+"_d\" namebak=\""+namebak+"\">";
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
	                                                                          DIVHTML +=  "<label for=\""+forVal+"\"></label>";
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
	                                                                         
	                                                                         DIVHTML +="<textarea onchange=\"onChangeClick(this,"+isedit+","+groupid+","+rowId+","+elementCount+");\"  id=\""+id+"_d\"  name=\""+name+"_d\" style=\"height:40px;\"  rows=\""+rows+"\" cols=\""+cols+"\" verticalscrollpolicy=\""+verticalscrollpolicy+"\" horizontalscrollpolicy=\""+horizontalscrollpolicy+"\"  namebak=\""+namebak+"\"  >"+tdObjs.value+"</textarea>";
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
	                                                                                   if(idval.indexOf("lable") >=0){
		                                                                                       DIVHTML += "<input onchange=\"onChangeClick(this,"+isedit+","+groupid+","+rowId+","+elementCount+");\" onfocus=\"FormatToNumber('"+onfocus.substring(onfocus.indexOf("'")+1,onfocus.lastIndexOf("'")).replace(/field_lable/ig,"")+"_d')\" onkeypress=\"ItemNum_KeyPress('"+name+"_d')\" value=\""+value+"\" namebak=\""+namebak+"\" id=\""+idval+"_d\" onblur=\"numberToFormat('"+onblur.substring(onblur.indexOf("'")+1,onblur.lastIndexOf("'")).replace(/field_lable/ig,"")+"_d');onChangeClick(this,"+isedit+","+groupid+","+rowId+","+elementCount+");calSum("+groupid+");ItemNum_KeyPress('"+name+"_d');ItemNum_KeyPress('"+name+"')\" name=\""+name+"_d\" type=\""+type+"\" datatype=\""+datatype+"\" datetype=\""+datetype+"\" datavaluetype=\""+datavaluetype+"\" datalength=\""+datalength+"\"  />";    
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
		                                                                                     DIVHTML += "<input onchange=\"onChangeClick(this,"+isedit+","+groupid+","+rowId+","+elementCount+");\"   value=\""+value+"\" onblur=\"checknumber1(this);calSum("+groupid+");ItemNum_KeyPress('"+onkeypress.substring(onkeypress.indexOf("'")+1,onkeypress.lastIndexOf("'"))+"');\" onkeypress=\"ItemNum_KeyPress('"+onkeypress.substring(onkeypress.indexOf("'")+1,onkeypress.lastIndexOf("'"))+"_d')\" type=\""+type+"\" datatype=\""+datatype+"\" datetype=\""+datetype+"\" datavaluetype=\""+datavaluetype+"\" datalength=\""+datalength+"\" name=\""+name+"_d\" id=\""+idval+"_d\" namebak=\""+namebak+"\" />";
	                                                                               }else{
	                                                                               } 
	                                                                          }else{
	                                                                             if(idval){
	                                                                                if(idval.indexOf("chinglish")>=0){
	                                                                                    DIVHTML +=  "<input type=\""+type+"\" name=\""+name+"_d\" id=\""+idval+"_d\" value=\""+value+"\" readonly=\"readonly\" />";
	                                                                                }
	                                                                                if(type == 'checkbox'){
	                                                                                      var onchange = tdObjs.getAttribute("onchange");
	                                                                                      var reg =   eval("/"+idval+"/ig");
	                                                                                      onchange = onchange.replace(reg,idval+"_d");
	                                                                                    DIVHTML += "<input onchange=\""+onchange+";onChangeClick(this,"+isedit+","+groupid+","+rowId+","+elementCount+");\" "+(tdObjs.checked?"checked":"")+"  name=\""+name+"_d\" id=\""+idval+"_d\" type=\""+type+"\"  />"; 
	                                                                                }else{
	                                                                                   if(tdObjs.getAttribute("onchange")){
	                                                                                      var onchange = tdObjs.getAttribute("onchange");
	                                                                                      var reg =   eval("/"+idval+"/ig");
	                                                                                      onchange = onchange.replace(reg,idval+"_d");
	                                                                                      DIVHTML += "<input type=\""+type+"\" id=\""+idval+"_d\" name=\""+name+"_d\" namebak=\""+namebak+"\" value=\""+value+"\" onchange=\""+onchange+";onChangeClick(this,"+isedit+","+groupid+","+rowId+","+elementCount+");\" />";
	                                                                                   }else{
	                                                                                       var classVal = tdObjs.getAttribute("class");
																							if(classVal){
																								if(classVal == 'scroller_date'){ //日期
																								DIVHTML += "<input onchange=\"onChangeClick(this,"+isedit+","+groupid+","+rowId+","+elementCount+");\" class=\""+classVal+"\" type=\""+type+"\" id=\""+idval+"_d\" name=\""+name+"_d\" namebak=\""+namebak+"\" value=\""+value+"\" readonly=\"readonly\" />";
																								DIVHTML += "<script language=\"javascript\">$('#"+idval+"_d').scroller({preset: 'date',dateFormat:'yy-mm-dd',theme: 'default',display: 'bottom', mode: 'scroller',endYear:2020,nowText:'今天',setText:'确定',cancelText:'取消',monthText:'月',yearText:'年',dayText:'日',showNow:true,dateOrder: 'yymmdd',onShow: moveDataTimeContorl});<\/script>";
																							 }else if(classVal == 'scroller_time'){//时间
																								 DIVHTML += "<input onchange=\"onChangeClick(this,"+isedit+","+groupid+","+rowId+","+elementCount+");\" class=\""+classVal+"\" type=\""+type+"\" id=\""+idval+"_d\" name=\""+name+"_d\" namebak=\""+namebak+"\" value=\""+value+"\" readonly=\"readonly\" />";
																								 DIVHTML += "<script language=\"javascript\">$('#"+idval+"_d').scroller({preset: 'time',timeFormat:'HH:ii',theme: 'default',display: 'bottom',mode: 'scroller',nowText:'现在',setText:'确定',cancelText:'取消',minuteText:'分',hourText:'时',timeWheels:'HHii',showNow:true,onShow: moveDataTimeContorl});<\/script>"; 
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
	                  }else{
	                      document.getElementById(copyid).checked = false;
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
	                  if(obj.checked){
						   document.getElementById(copyid).setAttribute("checked","true");
						   document.getElementById(copyid).onchange();
	                  }else{
						  document.getElementById(copyid).setAttribute("checked","false");
						  document.getElementById(copyid).onchange();
	                  }
	                  var name=obj.getAttribute("name");
	                  var checkHtml = "<input type=\"checkbox\" id=\""+id+"\" name=\""+name+"\"  "+(obj.checked?"checked":"")+" disabled  \><label for=\""+id+"\"></label>";
	                  document.getElementById("isshow"+groupId+"_"+rowId+"_"+colId+"").innerHTML = checkHtml;
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
							    if(ismandObj){
								 if(document.getElementById(id).value && document.getElementById(id).value!=""){
												 ismandObj.style.display = "none";
									 }else{
											 ismandObj.style.display = "block";
									}
								}
	                       }else if(datavaluetype == 3||datavaluetype == 2||datavaluetype == 4){ //浮点数与整数
	                            document.getElementById(id).setAttribute("value",document.getElementById(id).value);
	                             document.getElementById(copyid).setAttribute("value",document.getElementById(id).value);
	                             document.getElementById(copyid).value = document.getElementById(id).value;
								 var tempval = document.getElementById(id).value;
	                             var datalength = obj.getAttribute("datalength");
	                             if(datavaluetype == 4){ //金额转换
									  var moneyFormat = document.getElementById(id).value.replace(/,/g,'');
									    if(moneyFormat == '' || moneyFormat == '0' ){
											 moneyFormat =  "0.00";
										}else{
                                             moneyFormat = milfloatFormat(toPrecision(moneyFormat,datalength));
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
											if(ismandObj){
												   if(document.getElementById(id).value && document.getElementById(id).value!=""){
													    ismandObj.style.display = "none";
												   }else{
													    ismandObj.style.display = "block";
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
										if(ismandObj){
											 if(document.getElementById(id).value && document.getElementById(id).value!=""){
													  ismandObj.style.display = "none";
											 }else{
													  ismandObj.style.display = "block";
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
							    if(ismandObj){
								 if(document.getElementById(id).value && document.getElementById(id).value!=""){
												 ismandObj.style.display = "none";
									 }else{
											 ismandObj.style.display = "block";
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
						  if(ismandObj){
							 if(document.getElementById(id).value && document.getElementById(id).value!=""){
									ismandObj.style.display = "none";
							}else{
									 ismandObj.style.display = "block";
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
				   //判断必填的验证
					var idSplitIdStr =id+"_ismandspan";
					var ismandObj=document.getElementById(idSplitIdStr);
				    if(ismandObj){
						if(selectNameVal!=""){
								ismandObj.style.display = "none";
					    }else{
							    ismandObj.style.display = "block";
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
				    if(ismandObj){
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