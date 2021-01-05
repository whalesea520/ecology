
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<script language="javascript">
<%
   String detailtableoutfit=Util.null2String(new weaver.general.BaseBean().getPropValue("Mobile","detailtableoutfit"));
    boolean editMode = true;        //true当前行编辑，false下方弹出Table编辑
    if (clienttype.equalsIgnoreCase("ipad")) {
        editMode = true;
    } else if (clienttype.equalsIgnoreCase("iphone")){
        editMode = false;
    } else if (clienttype.equalsIgnoreCase("Webclient")){
        editMode = true;
    } else if (clienttype.equalsIgnoreCase("Android")){
        editMode = false;
    } else if (clienttype.equalsIgnoreCase("AndPad")){
        editMode = true;
    }
    editMode=false;
%>

/**
 * 预算费用动态生成明细编辑页面后，绑定事件函数
 **/
function dyeditPageFnaFyFun(groupid,rowId,fieldCount,isedit,isdisplay) {
    return;
}

/**
 * 明细表不可编辑时，可点击撑宽
 **/
jQuery(document).ready(function(){
    try{
        jQuery("table.excelDetailTable[_canedit]").each(function(){
            var oTable = jQuery(this);
            var triObj;
            //if($(this).attr("_canedit") === "y")
            //    triObj = $(this).find("tr.exceldetailtitle").last();\
			<%if("1".equals(isDetailRowShow)){%>
			<%}else{%>
            if($(this).attr("_canedit") === "n"){
                triObj = $(this);
		 <%if(!"1".equals(detailcardshow)){%>
            //绑定事件
            triObj.click(function(){
                extendHtmlDetail(oTable);
            });
			  <%}%>
            }
			<%}%>
			 <%if(!"1".equals(detailcardshow)){%>
            var detailButtonDiv = oTable.find(".detailButtonDiv");
            if(detailButtonDiv.size() > 0){		//添加展开按钮
            	var deploybutton = jQuery("<button class=\"deploybutton\" type=\"button\" name=\"deploybutton\" title=\"展开\"></button>");
            	if(detailButtonDiv.children().size() > 0)
            		detailButtonDiv.children().first().before(deploybutton);
            	else
            		detailButtonDiv.append(deploybutton);
            	detailButtonDiv.find(".deploybutton").click(function(){
	                extendHtmlDetail(oTable);
	            });
            }
			  <%}%>
        });
    }catch(e){}
});
function extendHtmlDetail(oTable){
    var detaildiv = oTable.parent();
    var colcount = oTable.find("tr[name='controlwidth']").children().length;
    var detaildiv_width = parseInt(detaildiv.width());
    if(colcount>2 && colcount*100>detaildiv_width){
		<%if(ismobilehtml){%>
	    <%}else{%>
          oTable.css("width", colcount*100);
		<%}%>
        detaildiv.css({"overflow-x":"auto", "width":detaildiv_width});
    }
    if(oTable.find(".deploybutton")){
    	oTable.find(".deploybutton").remove();
    }
}



function controlEditMode(){     //控制编辑模式，平板直接在行上编辑
    <%if(editMode){ %>
        var hiddenEditDiv=jQuery("div[name='hiddenEditdiv']");
        hiddenEditDiv.each(function(){
            var editHtml=jQuery(this).html();
            var currentTd=jQuery(this).closest("td");
            currentTd.html(editHtml);
            if(!!currentTd.parent().attr("onclick")){
                currentTd.parent().removeAttr("onclick");
            }
        });
    <%} %>
}

<% 
int wdtiCount = 0;
boolean canedit = false;
    if(workflowRequestInfo!=null&&workflowRequestInfo.getVersion()==2){
        canedit = workflowRequestInfo.isCanEdit();
        WorkflowDetailTableInfo[] detailTableInfoArr=workflowRequestInfo.getWorkflowDetailTableInfos();
        if(detailTableInfoArr !=null && detailTableInfoArr.length>0){
        %>
                    jQuery(document).ready(function(){
                        controlEditMode();
                    }); 
        <%
            for(int groupid=0;groupid<detailTableInfoArr.length;groupid++){
                WorkflowDetailTableInfo detailTableInfo=detailTableInfoArr[groupid];
                String addRowStr = detailTableInfo.getAddStr();
                addRowStr = addRowStr.replaceAll("\r\n","").replaceAll("\r","").replaceAll("\n","");
                addRowStr = addRowStr.replaceAll("/","\\\\/");
                addRowStr = addRowStr.replaceAll("\"","\\\\\"");
        %>
            function addRow<%=groupid %>(groupid,type){
                var addRowStr = "<%=addRowStr %>";
                var recordNum = jQuery("#nodenum"+groupid).val();
                var reger=new RegExp("[$]rowIndex[$]","g"); 
                addRowStr = addRowStr.replace(reger, recordNum);
                //if(window.console)	console.log(addRowStr);
                var oTable = jQuery("#oTable"+groupid);
                var detailIndexSpanStr = "span[name='detailIndexSpan"+groupid+"']";
                var lastSerialNum = oTable.find(detailIndexSpanStr).last().text();
                //新增行追加
				if(oTable.find("tr[_target='datarow']").size() > 0)
					oTable.find("tr[_target='datarow']").last().after(addRowStr);
				else
					oTable.find("tr[_target='headrow']").last().after(addRowStr);
                //总记录个数加1
                jQuery("#nodenum"+groupid).val(parseInt(recordNum)+1);
                if(jQuery(detailIndexSpanStr).size() > 0){	//模板含序号，新增行序号加一
                	if(!!!lastSerialNum)
                		lastSerialNum = 0;
	            	jQuery("tr[name='trView_"+groupid+"_"+recordNum+"']").find(detailIndexSpanStr).text(parseInt(lastSerialNum)+1);
                }
                controlEditMode();
                try{
                    calSum(groupid);
                }catch(e){}
                try{        //自定义新增行后函数接口
                    if(typeof _customMobileAddFun_<%=groupid %> === 'function')
                        _customMobileAddFun_<%=groupid %>();
                }catch(e){}
								//公式使用
				try{
					$("td[_cellattr]").each(function(){
						var _cellattr =  $(this).attr("_cellattr");
						  if(_cellattr.indexOf("$[")!=-1){
					         $(this).attr("_cellattr",_cellattr.replace("$[","").replace("]$","")+"_"+recordNum);
						  }
					});

				    $("td[_fieldid]").each(function(){
						var _fieldid =  $(this).attr("_fieldid");
						 if(_fieldid.indexOf("$[")!=-1){
					     $(this).attr("_fieldid",_fieldid.replace("$[","").replace("]$","")+"_"+recordNum);
						 }
					});

				      $("td[_formula]").each(function(){
						var _formula =  $(this).attr("_formula");
						if(_formula.indexOf("$[")!=-1){
					       $(this).attr("_formula",_formula.replace("$[","").replace("]$",""));
						}
					});
				}catch(e){
				}
           <%if("1".equals(detailcardshow)){%>
				   if(type!='init'){
					var trrowindex = (new Number($("#nodenum<%=groupid %>").val())-1);
					try{
						 <%if(isremark!=2&&isremark!=4){%>
					       detailattrshow(trrowindex);
				        <%}%>
												
					 }catch(e){}
					try{
						var tableheadObj = new Array();
						 var trtableheadClass="";
						 var  checkalldetailTr= oTable.find("tr[class='exceldetailtitle ']");
						if(checkalldetailTr.length>0){
								if(checkalldetailTr[1]!=null && checkalldetailTr[1]!=undefined && $(checkalldetailTr[1]).find("td").length>0){
									$(checkalldetailTr[1]).find("td").each(function(tdindex){
									   tableheadObj[tdindex] = {"html":""+$(this).html()+"","classStr":""+$(this).attr("class")+""};
									});
								}
						}
						if(type=='trigroupinfo'){
							initCardShow("trigroupinfo",groupid,trtableheadClass,oTable,tableheadObj,recordNum,(parseInt(lastSerialNum)+1));
							 try{
							   formuaAttrShowDetail(trrowindex);
						     }catch(e){}
						}else{
							initCardShow("add",groupid,trtableheadClass,oTable,tableheadObj,recordNum,(parseInt(lastSerialNum)+1));
						}
					}catch(e){}
					}
               <%}%>
				 
            }
            
           	function deleteRowInfo(groupid,delRecords,oTable,typeinfo,trIndex){
                    delRecords.each(function(){
						 var rowIndex = jQuery(this).attr("_rowindex");
					  if(typeinfo=='delcard'&&rowIndex==trIndex){
                        var recordid = jQuery(this).val();
                        if(recordid != "on"){
                            jQuery("#deleteId"+groupid).val(jQuery("#deleteId"+groupid).val()+recordid+",");
                        }
                       	jQuery("#deleteRowIndex"+groupid).val(jQuery("#deleteRowIndex"+groupid).val()+rowIndex+",");
							jQuery("tr[name='trView_"+groupid+"_"+rowIndex+"']").remove();
							  <%if("1".equals(detailcardshow)){%>
								try{
									jQuery("tr[name='trView_"+groupid+"_"+rowIndex+"_card']").remove();  
								}catch(e){}
							<%}%>
							jQuery("tr#trEdit_"+groupid+"_"+rowIndex).remove();
					  }
					  if(typeinfo==''){
                        var recordid = jQuery(this).val();
                        if(recordid != "on"){
                            jQuery("#deleteId"+groupid).val(jQuery("#deleteId"+groupid).val()+recordid+",");
                        }
                        jQuery("#deleteRowIndex"+groupid).val(jQuery("#deleteRowIndex"+groupid).val()+rowIndex+",");
                        jQuery("tr[name='trView_"+groupid+"_"+rowIndex+"']").remove();
							<%if("1".equals(detailcardshow)){%>
							try{
							    jQuery("tr[name='trView_"+groupid+"_"+rowIndex+"_card']").remove();  
							}catch(e){}
						<%}%>
                        jQuery("tr#trEdit_"+groupid+"_"+rowIndex).remove();
						}
                    });
                    var detailIndexSpanStr = "span[name='detailIndexSpan"+groupid+"']";
                    //模板含序号，序号排列
                    if(jQuery(detailIndexSpanStr).size() > 0){
                    	jQuery("input[name='check_node_"+groupid+"']").each(function(index){
	                    	var rowIndex = jQuery(this).attr("_rowindex");
	                    	jQuery("tr[name='trView_"+groupid+"_"+rowIndex+"']").find(detailIndexSpanStr).text(index+1);
	                    });
                    }
                    oTable.find("input[name='check_all_record']").attr("checked", false);
                    try{
	                    calSum(groupid);        //行列规则计算
	                }catch(e){}
	                try{        //自定义删除行后函数接口
	                    if(typeof _customMobileDelFun_<%=groupid %> === 'function')
	                        _customMobileDelFun_<%=groupid %>();
	                }catch(e){}
					 <%if("1".equals(detailcardshow)){%>
						 try{
						   if(jQuery("tr[name^='trView_"+groupid+"_']").length==0){
						       var   checkalldetailTr= oTable.find("tr[class='exceldetailtitle ']");  
								 var trtableheadClass="";
								 if(checkalldetailTr.length>0){
								    if(checkalldetailTr[1]!=null && checkalldetailTr[1]!=undefined && $(checkalldetailTr[1]).find("td").length>0){
									   $(checkalldetailTr[1]).find("td").each(function(tdindex){
											if(tdindex==0){
												 trtableheadClass = $(this).attr("class");
											}
										});
									}
									
									if(trtableheadClass.indexOf(" ")!=-1){
										trtableheadClass= trtableheadClass.split(" ")[0];
									}
								    var bbottomwidth=$("."+trtableheadClass).css("border-bottom-width");
									var bbottomstyle=$("."+trtableheadClass).css("border-bottom-style");
									var bbottomcolor=$("."+trtableheadClass).css("border-bottom-color");
									 $(checkalldetailTr[0]).css("border-bottom-width",bbottomwidth);
									 $(checkalldetailTr[0]).css("border-bottom-style",bbottomstyle);
									 $(checkalldetailTr[0]).css("border-bottom-color",bbottomcolor);
								 }

								
					       }
					   }catch(e){}
                     <%}%>
            }

		   function deleteRow<%=groupid %>(groupid,typeinfo,trIndex){
            	var oTable = jQuery("#oTable"+groupid);
                var delRecords = oTable.find("input[name='check_node_"+groupid+"']:checked");
                if(delRecords.size() == 0){
                    alert("<%=SystemEnv.getHtmlLabelName(22686,user.getLanguage())%>");
                    return;
                }
				if("delcard" == typeinfo){
                   deleteRowInfo(groupid,delRecords,oTable,typeinfo,trIndex);
				}else{
				   if(confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>")){
                     deleteRowInfo(groupid,delRecords,oTable,'','');
                   }
                }
            }
        
        <%      boolean allowDefaultRow = "1".equals(Util.null2String(detailTableInfo.getDefaultRow()))?true:false;
                int detailDefaultRowCount=Util.getIntValue(detailTableInfo.getDefaultRowCount(),0);
				String needAddRow = detailTableInfo.getNeedAddRow(); //必须新增明细
				WorkflowDetailTableInfo[] workflowDetailTableInfos = workflowRequestInfo.getWorkflowDetailTableInfos();
				wdtiCount = workflowDetailTableInfos.length;
				%>
			</script>
			<input type="hidden" id="needAddRow<%=groupid%>" value="<%=needAddRow %>" />		
<script language="javascript">
					<%
                if(allowDefaultRow && detailDefaultRowCount>0){
        %>
                    jQuery(document).ready(function(){
                       var nodenum = jQuery("#nodenum<%=groupid%>").val();
                       if(nodenum == "0"){
                           var defaultCount=<%=detailDefaultRowCount %>;
                           for(var s=0;s<defaultCount;s++){
                                addRow<%=groupid %>(<%=groupid %>,'init');
							    var trrowindex = (new Number($("#nodenum<%=groupid %>").val())-1);
							   <%if(isremark!=2&&isremark!=4&&takisremark!=-2){%>
			                   detailattrshow(trrowindex);
							   <%}%>
								   try{
								formuaAttrShowDetail(trrowindex);
							   }catch(e){}
								
                           }
                       }
                    });
        <%
                }
        %>  
        <%
            }
        }
    }
%>
</script>

<script language="javascript">
//验证是否选择为必须新增的
function  needAddRow(){
	var messageInfo = "";
    var tableCount = <%=wdtiCount%>;
	var canedit = <%=canedit%>;
	for(var i=0;i<tableCount;i++){
		try{
			var oTable = jQuery("table#oTable"+i);
			if(canedit && oTable.length>0 && oTable.find("tr[_target='datarow']").size() == 0){
				var needAddRowObj = jQuery("input[id='"+("needAddRow"+i)+"']").val();
				if(needAddRowObj == "1"){
					messageInfo = "必须填写第"+(i+1)+"个明细表数据，请填写";
					break;
				}
			}
		}catch(e){
		   continue;
		}
	}
    return messageInfo;
}

//点击行转列编辑
function detailTrClick(groupid, rowIndex){
    var oTable = jQuery("table#oTable"+groupid);
    var viewTrObj = oTable.find("tr[name='trView_"+groupid+"_"+rowIndex+"']");
    var editTr_id = "trEdit_"+groupid+"_"+rowIndex;
    var editTrObj = oTable.find("tr#"+editTr_id);
    if(editTrObj.length>0){     //存在，点击则remove
        editTrObj.slideUp();
        editTrObj.remove();
    }else{
    	var colNum = oTable.find("tr[name='controlwidth']").children().length;
        var editTr_new = jQuery("<tr _target=\"datarow\" id=\""+editTr_id+"\" width=\"100%\"><td colspan=\""+colNum+"\" width=\"100%\"></td></tr>");
        editTr_new.find("td:first").append(getEditTable(groupid, rowIndex));		//编辑区
        viewTrObj.last().after(editTr_new);		//多行模板只能取最后一行
        //由于第一个字段未解析左边框，特殊处理(最后一个字段右边框由于rowspan机制不需处理)
        jQuery("td[lackLeftBorder='y']").each(function(){
            jQuery(this).css("border-left-width", jQuery(this).css("border-right-width"));
            jQuery(this).css("border-left-style", jQuery(this).css("border-right-style"));
            jQuery(this).css("border-left-color", jQuery(this).css("border-right-color"));
        });
        //控制最后一行增加bottom线
        var last_tr_id = jQuery("table#oTable"+groupid+">tbody>tr:last").attr("id");
        if(last_tr_id == editTr_id){
        	var outerTd = oTable.closest("td");
            jQuery("#"+editTr_id).css("border-bottom-width", outerTd.css("border-left-width"))
                .css("border-bottom-style", outerTd.css("border-left-style"))
                .css("border-bottom-color", outerTd.css("border-left-color"));
        }
        //最后三个参数无用
        try{dyeditPageFnaFyFun(groupid,rowIndex,0,0,0);}catch(ex){}
        try{        //自定义明细行编辑函数，传参数明细表ID及行号
            if(typeof _customDetailTrClickFun === 'function')
                _customDetailTrClickFun(groupid,rowIndex);
        }catch(e){}
    }
}

//行转列生成编辑table
function getEditTable(groupid, rowIndex){
	var oTable = jQuery("table#oTable"+groupid);
    var editTableObj = jQuery("<table style=\"width:100%;border-collapse:collapse;border:0px;margin:0px;padding:0px;\"></table>");
    var eachObj = jQuery("tr[name='trView_"+groupid+"_"+rowIndex+"']").find("div[name='hiddenEditdiv']");
    eachObj.each(function(index){
        var newTr=jQuery("<tr></tr>");
        var newTd=null;
        //空列用于收缩编辑TR
        if(index == 0){
            newTd=jQuery("<td width=\"10%\"></td>");
            newTd.attr("rowspan",eachObj.size());
            newTd.attr("onclick","javacsript:detailTrClick("+groupid+","+rowIndex+")");
            newTr.append(newTd);
        }
        //取得字段id，生成字段名称TD
        var isshow_id = jQuery(this).closest("td").find("div[id^=isshow]").attr("id").replace("isshow","");
        var fieldinfo = isshow_id.split("_");
        //生成字段名称TD
        var fieldLableObj = oTable.find("td[_fieldlabel='"+fieldinfo[2]+"']");
        newTd=jQuery("<td width=\"30%\"></td>");
        <%if("1".equals(detailtableoutfit)){%>
			var classStr = fieldLableObj.closest("td").attr("class");
		    if(classStr!=null&&classStr!=undefined){
				 classStr = classStr.replace("detail_hide_col","");
			}
			newTd.attr("class",classStr);
		<%}else{%>
            newTd.attr("class",fieldLableObj.closest("td").attr("class"));
	    <%}%>
        if(index == 0){
            newTd.attr("lackLeftBorder","y");
        }
        newTd.html(fieldLableObj.html());
        newTr.append(newTd);
        //生成字段编辑TD
        var editTdObj=getEditTd(jQuery(this),fieldinfo);
         <%if("1".equals(detailtableoutfit)){%>
			 var classStr = jQuery(this).closest("td").attr("class");
		    if(classStr!=null&&classStr!=undefined){
				 classStr = classStr.replace("detail_hide_col","");
			}
			editTdObj.attr("class",classStr);
		<%}else{%>
             editTdObj.attr("class",jQuery(this).closest("td").attr("class"));
	    <%}%>
        editTdObj.attr("id","field"+fieldinfo[2]+"_"+fieldinfo[1]+"_tdwrap");
		if (editTdObj.children().length==0){
			if( $("input[name='fieldformart"+fieldinfo[2]+"_"+fieldinfo[1]+"']").length>0){
				var fieldformarthtml = $("input[name='fieldformart"+fieldinfo[2]+"_"+fieldinfo[1]+"']").val();
				if(fieldformarthtml!=''){
					 editTdObj.html(fieldformarthtml);
				}
			}
		}
        newTr.append(editTdObj);
        //空列间隔
        if(index == 0){
            newTd=jQuery("<td width=\"5%\"></td>");
            newTd.attr("rowspan",eachObj.size())
            newTr.append(newTd);
        }
        //将编辑TR放入Table
        editTableObj.append(newTr);
    });
    return editTableObj;
}


function dialogDefault(editTdObj,brows){
   var browseText="";
   if(editTdObj.find("span[keyid='"+brows+"']").size()>0){
				browseText=editTdObj.find("span[keyid='"+brows+"']").text();
				editTdObj.find("span[keyid='"+brows+"']").remove();
	}
	if(editTdObj.find("a[keyid='"+brows+"']").size()>0){
		browseText="<a";
		var titleStr = editTdObj.find("a[keyid='"+brows+"']").text();
		if(editTdObj.find("a[keyid='"+brows+"']").attr("title")!=null && editTdObj.find("a[keyid='"+brows+"']").attr("title")!=undefined){
				browseText += " title = \""+editTdObj.find("a[keyid='"+brows+"']").attr("title")+"\"";
		}
		if(editTdObj.find("a[keyid='"+brows+"']").attr("href")!=null && editTdObj.find("a[keyid='"+brows+"']").attr("href")!=undefined){
			browseText += " href = \""+editTdObj.find("a[keyid='"+brows+"']").attr("href")+"\"";
		}
		if(editTdObj.find("a[keyid='"+brows+"']").attr("onclick")!=null && editTdObj.find("a[keyid='"+brows+"']").attr("onclick")!=undefined){
						  browseText +=" onclick = \""+editTdObj.find("a[keyid='"+brows+"']").attr("onclick")+"\"";
		}
		browseText +=">"+titleStr+"</a>";
		editTdObj.find("a[keyid='"+brows+"']").remove();
	}
	browseText +=" ";
	return  browseText;
}


function getEditTd(is_editObj,fieldinfo){
    var cloneObj=is_editObj.children().clone();
    var editTdObj=jQuery("<td width=\"55%\"></td>");
    var fieldid=fieldinfo[2];
    var fieldhtmltype = is_editObj.children("table").attr("fieldhtmltype");  //fieldhtmltype==6
    if(cloneObj[0].tagName.toLowerCase()=="table"){
        
        if(fieldhtmltype=="6"){
            editTdObj.append(is_editObj.html());
            var fieldname = fieldinfo[2]+"_"+fieldinfo[1]
            editTdObj.find("td[id='field"+fieldname+"_span']").each(function(){
                var newspanid = jQuery(this).attr("id")+"_d";
                jQuery(this).attr("id",newspanid);
            });
            
            editTdObj.find("input[id='cntfield"+fieldname+"']").remove();
            //editTdObj.find("input[id='field"+fieldname+"']").remove();
            
            //如果当前表单不可编辑 或者 是非客户端登录方式，需对附件上传类型字段中各附件之后的删除按钮作删除。
            flagDelAppendix = <%=(!workflowRequestInfo.isCanEdit() || clienttype.equalsIgnoreCase("Webclient"))%>;
            if(flagDelAppendix){
                var $delAppend = editTdObj.find("a[name='appendixDelField']");
                $delAppend.each(
                    function(i){
                        jQuery(this).remove();
                    });
            }
            //仅当非客户端登录方式，支持对附件上传字段的编辑操作
            flagEditAppendix = <%=(clienttype.equalsIgnoreCase("Webclient"))%>;
            if(flagEditAppendix){
                var $editAppend = editTdObj.find("td[name='appendixEditField']");
                $editAppend.each(
                    function(i){
                        jQuery(this).remove();
                    });
            }
            
        }else{
            //循环每个TD取内容
            cloneObj.find("tbody>tr>td").each(function(index){
                if(!!jQuery(this).attr("onclick")){
                    editTdObj.attr("onclick",jQuery(this).attr("onclick"));
                }
                editTdObj.append(jQuery(this).html());
            });
        }
        
        
        
        
        //处理编辑/隐藏的input对象
        editTdObj.find("input[name^='field'][name$='_"+fieldinfo[1]+"']").each(function(){
            var elmName=jQuery(this).attr("name");
            var fieldStr=elmName.replace("field_lable","").replace("field_chinglish","").replace("field","");
            var replaceStr=fieldStr+"_d";
            //属性处理
            jQuery(this).attr("name",jQuery(this).attr("name").replace(new RegExp(fieldStr,"g"),replaceStr));
            if(!!jQuery(this).attr("id")){
                //由于chrome中对原对象修改value值html未修改，需手动赋值
                jQuery(this).attr("value",jQuery("#"+jQuery(this).attr("id")).val());
                jQuery(this).attr("id",jQuery(this).attr("id").replace(new RegExp(fieldStr,"g"),replaceStr));
            }
            if(!!jQuery(this).attr("onkeypress")){
                jQuery(this).attr("onkeypress",jQuery(this).attr("onkeypress").replace(new RegExp(fieldStr,"g"),replaceStr));
            }
            if(!!jQuery(this).attr("onblur")){
                jQuery(this).attr("onblur",jQuery(this).attr("onblur").replace(new RegExp(fieldStr,"g"),replaceStr));
            }
            if(!!jQuery(this).attr("onfocus")){
                jQuery(this).attr("onfocus",jQuery(this).attr("onfocus").replace(new RegExp(fieldStr,"g"),replaceStr));
            }
            if(!!jQuery(this).attr("onchange")){
                jQuery(this).attr("onchange",jQuery(this).attr("onchange").replace(new RegExp(fieldStr,"g"),replaceStr));
            }
            
            //处理金额转换字段、浏览按钮、日期、时间
            if(elmName.indexOf("field_chinglish")>-1)   return true;
            if(jQuery(this).attr("type")=="hidden"&&jQuery(this).attr("fieldtype")=="browse"){
                if(jQuery(this).closest("td").children("a").size()>0){
                    jQuery(this).closest("td").children("a:first-child").css("float","left");
                }
                var browserVal=jQuery(this).val();
                var browseText="";
                if(!!browserVal){
                   if(browserVal.indexOf(",")!=-1){
						   var browsers = 	 browserVal.split(",");
						   for(var b=0;b<browsers.length;b++){
								 var brows=browsers[b];
								 browseText+=dialogDefault(editTdObj,brows);

						   }
					}else{
						browseText =dialogDefault(editTdObj,browserVal);
					}
                }
                jQuery(this).after("<div id=\""+elmName+"_span_d\" groupid=\""+fieldinfo[0]+"\" rowid=\""+fieldinfo[1]+"\" columnid=\""+fieldinfo[2]+"\" style=\"margin-top:11px;\">"+browseText+"</div>");
            }
            if(jQuery(this).attr("class")=="scroller_date"){
                jQuery(this).scroller({preset: 'date',dateFormat:'yy-mm-dd',theme: 'default',display: 'bottom', mode: 'scroller',endYear:2020,nowText:'今天',setText:'确定',cancelText:'取消',monthText:'月',yearText:'年',dayText:'日',showNow:true,dateOrder: 'yymmdd',onShow: moveDataTimeContorl});
            }else if(jQuery(this).attr("class")=="scroller_time"){
                jQuery(this).scroller({preset: 'time',timeFormat:'HH:ii',theme: 'default',display: 'bottom',mode: 'scroller',nowText:'现在',setText:'确定',cancelText:'取消',minuteText:'分',hourText:'时',timeWheels:'HHii',showNow:true,onShow: moveDataTimeContorl});
            }
            
            //增加绑定onchange事件
            if(jQuery(this).attr("type")!="hidden"){
                var changeFun="";
                if(!!jQuery(this).attr("onchange")){
                    changeFun=jQuery.trim(jQuery(this).attr("onchange"));
                    if(changeFun.length>1&&changeFun.substr(changeFun.length-1)!=";"){
                        changeFun += ";";
                    }
                }
                changeFun = "dynamicModify(this);"+changeFun;
                jQuery(this).attr("onchange",changeFun);
            }
            
            //必填SPAN处理
            if(editTdObj.find("span[class='ismand'][id^='"+elmName+"']").size()>0){
                editTdObj.find("input[type='hidden'][name='ismandfield']").remove();
                var mandSpanObj=editTdObj.find("span[class='ismand'][id^='"+elmName+"']");
                mandSpanObj.attr("id",mandSpanObj.attr("id").replace(new RegExp(fieldStr,"g"),replaceStr));
                mandSpanObj.removeClass("ismand");
                mandSpanObj.css("color","red").css("font-size","16pt").css("float","right");
                if(!!jQuery(this).val()){
                    mandSpanObj.css("display","none");
                }else{
                    mandSpanObj.css("display","block");
                }
                if(jQuery(this).attr("type")=="hidden"&&jQuery(this).attr("fieldtype")=="browse"){
                    mandSpanObj.css("margin-top","-10px");
                }
            }
            //ismandspan
            if(editTdObj.find("span[id='"+elmName+"_ismandspan']").size()>0){
                var mandSpanObj=editTdObj.find("span[id='"+elmName+"_ismandspan']");
                mandSpanObj.attr("id",mandSpanObj.attr("id").replace(new RegExp(fieldStr,"g"),replaceStr));
                mandSpanObj.css("color","red").css("font-size","16pt").css("float","right");
            }
        });
        //处理checkbox对象
        editTdObj.find("input[type='checkbox'][id^='field'][id$='_"+fieldinfo[1]+"'][name!^='field']").each(function(){
            var elmId=jQuery(this).attr("id");
            if(elmId.substr(elmId.length-2)=="_d")  return true;
            var elmId_d=elmId+"_d";
            //属性处理
            jQuery(this).attr("id",elmId_d);
            var changeFun="";
            if(!!jQuery(this).attr("onchange")){
                changeFun=jQuery.trim(jQuery(this).attr("onchange"));
                if(changeFun.length>1&&changeFun.substr(changeFun.length-1)!=";"){
                    changeFun += ";";
                }
                changeFun=changeFun.replace(new RegExp(elmId,"g"),elmId_d);
            }
            changeFun = "dynamicModify(this);"+changeFun;
            jQuery(this).attr("onchange",changeFun);
        });
        //处理textarea对象
        editTdObj.find("textarea[name^='field'][name$='_"+fieldinfo[1]+"'],select[name^='field'][name$='_"+fieldinfo[1]+"']").each(function(){
            var elmName=jQuery(this).attr("name");
            var elmName_d=elmName+"_d";
            jQuery(this).attr("name",elmName_d);
            if(!!jQuery(this).attr("id")){
                jQuery(this).attr("id",jQuery(this).attr("id").replace(new RegExp(elmName,"g"),elmName_d));
            }
            //增加绑定onchange事件
            var changeFun="";
            if(!!jQuery(this).attr("onchange")){
                changeFun=jQuery.trim(jQuery(this).attr("onchange"));
                if(changeFun.length>1&&changeFun.substr(changeFun.length-1)!=";"){
                    changeFun += ";";
                }
            }
            changeFun = "dynamicModify(this);"+changeFun;
            jQuery(this).attr("onchange",changeFun);
            if(changeFun.indexOf("changeshowattr")!=-1){
                jQuery(this).trigger("change");
            }
            //textarea所在TD高度增加
            if(jQuery(this)[0].tagName.toLowerCase()=="textarea"){
                editTdObj.css("height","80px");
                jQuery(this).css("width","95%");
            }
            //必填SPAN处理
            if(editTdObj.find("span[class='ismand'][id^='"+elmName+"']").size()>0){
                editTdObj.find("input[type='hidden'][name='ismandfield']").remove();
                var mandSpanObj=editTdObj.find("span[class='ismand'][id^='"+elmName+"']");
                mandSpanObj.attr("id",mandSpanObj.attr("id").replace(new RegExp(elmName,"g"),elmName_d));
                mandSpanObj.removeClass("ismand");
                mandSpanObj.css("color","red").css("font-size","16pt").css("float","right");
                if(!!jQuery(this).val()){
                    mandSpanObj.css("display","none");
                }else{
                    mandSpanObj.css("display","block");
                }
            }
            
            if(editTdObj.find("span[id='"+elmName+"_ismandspan']").size()>0){
                var mandSpanObj=editTdObj.find("span[id='"+elmName+"_ismandspan']");
                mandSpanObj.attr("id",mandSpanObj.attr("id").replace(new RegExp(elmName,"g"),elmName_d));
                mandSpanObj.css("color","red").css("font-size","16pt").css("float","right");
            }
        });
    }else{
        editTdObj.append(cloneObj);
        editTdObj.find("input,div").remove();
        editTdObj.find("span").each(function(){
            if(!!jQuery(this).attr("id")){
                if(jQuery(this).attr("id").indexOf("field"+fieldid)>-1)
                    jQuery(this).attr("id",jQuery(this).attr("id")+"_d");
            }
            if(!!jQuery(this).attr("name")){
                if(jQuery(this).attr("name").indexOf("field"+fieldid)>-1)
                    jQuery(this).attr("name",jQuery(this).attr("name")+"_d");
            }
        });
    }
    return editTdObj;
}

//同步修改显示的span及input
function dynamicModify(vthis){
    try{
        var tagName=jQuery(vthis)[0].tagName.toLowerCase();
        var objId=jQuery(vthis).attr("id");
        var objId_hidden="";
        if(objId.substr(objId.length-2)=="_d"){
            objId_hidden = objId.substring(0,objId.length-2);
        }
        //文本反向修改
        if(tagName=="input"&&jQuery(vthis).attr("type")=="text"){
            try{
                var objVal=jQuery(vthis).val();
                if(jQuery(vthis).attr("datavaluetype")=="4"){
                    var fieldIndex=objId.replace("field_lable","");
                    var fieldIndex_hidden=objId_hidden.replace("field_lable","");
                    var isshowObj=jQuery("[name='"+objId_hidden+"']").closest("div[name='hiddenEditdiv']").closest("td").find("div[id^=isshow]");
                    if(!!objVal){
						if(objVal.indexOf(',')!=-1){
							objVal = objVal.replace(/,/g,'');
						}
                        var val_1 = floatFormat(objVal);            //补零
                        var val_2 = milfloatFormat(val_1);          //转千分位
                        var val_3 = numberChangeToChinese(val_1);   //转大写
                        //不能给编辑的input赋值，因为onblur事件会调用1_wev8.js的numberToFormat方法计算赋值
                        jQuery("input[name='field" + fieldIndex_hidden + "']").attr("value",val_1);
                        jQuery("input[name='field_lable" + fieldIndex_hidden + "']").attr("value",val_2);
                        jQuery("input[name='field_chinglish" + fieldIndex_hidden + "']").attr("value",val_3);
                        isshowObj.text(val_3+"("+val_2+")");
                    }else{
                        jQuery("input[name='field" + fieldIndex_hidden + "']").attr("value","");
                        jQuery("input[name='field_lable" + fieldIndex_hidden + "']").attr("value","");
                        jQuery("input[name='field_chinglish" + fieldIndex_hidden + "']").attr("value","");
                        isshowObj.text("");
                    }
                }else{
                    if(jQuery(vthis).attr("datavaluetype")=="2"){
                        objVal=toPrecision(objVal,0);
                        jQuery(vthis).attr("value",objVal);
                    }else if(jQuery(vthis).attr("datavaluetype")=="3"||jQuery(vthis).attr("datavaluetype")=="5"){
                        var datalength=2;
                        datalength=jQuery(vthis).attr("datalength");
                        objVal=toPrecision(objVal,parseInt(datalength));
                        if(jQuery(vthis).attr("datavaluetype")=="3"){
                            jQuery(vthis).attr("value",objVal);
                        }else if(jQuery(vthis).attr("datavaluetype")=="5"){
                            objVal=changeToThousandsVal(objVal);
                        }
                    }
                    var inputElement=jQuery("input#"+objId_hidden+"[type='text']");
                    inputElement.attr("value",objVal);
                    inputElement.closest("div[name='hiddenEditdiv']").closest("td").find("div[id^=isshow]").text(objVal);
                }
            }catch(ev){}
        }

		  //日期反向修改
        if(tagName=="input"&&jQuery(vthis).attr("type")=="date"){
			 var objVal=jQuery(vthis).val();
			 var inputElement=jQuery("input#"+objId_hidden+"[type='date']");
                    inputElement.attr("value",objVal);
                    inputElement.closest("div[name='hiddenEditdiv']").closest("td").find("div[id^=isshow]").text(objVal);
		}

		  //时间反向修改
        if(tagName=="input"&&jQuery(vthis).attr("type")=="time"){
			 var objVal=jQuery(vthis).val();
			 var inputElement=jQuery("input#"+objId_hidden+"[type='time']");
                    inputElement.attr("value",objVal);
                    inputElement.closest("div[name='hiddenEditdiv']").closest("td").find("div[id^=isshow]").text(objVal);
		}
        //checkbox反向修改
        if(tagName=="input"&&jQuery(vthis).attr("type")=="checkbox"){
            var checkboxObj=jQuery("input[type='checkbox'][id='"+objId_hidden+"']");
            var checkbox_hiddenObj = jQuery("input[type='hidden'][name='"+objId_hidden+"']");
            if(jQuery(vthis).attr("checked")){
                checkboxObj.attr("checked",true);
                checkbox_hiddenObj.attr("value", "1");
            }else{
                checkboxObj.attr("checked",false);
                checkbox_hiddenObj.attr("value", "0");
            }
        }
        //多行文本反向修改
        if(tagName=="textarea"){
            var objVal=jQuery(vthis).val();
            var textareaElement=jQuery("textarea#"+objId_hidden);
            textareaElement.text(objVal);
            textareaElement.closest("div[name='hiddenEditdiv']").closest("td").find("div[id^=isshow]").text(objVal);
        }
        //下拉框反向修改
        if(tagName=="select"){
            var selectOption=jQuery(vthis).find("option:selected");
            var selectElement=jQuery("select#"+objId_hidden);
            selectElement.find("option").removeAttr("selected");
            selectElement.find("option[value='"+selectOption.val()+"']").attr("selected", "selected");
            //selectElement.val(selectOption.val());
            selectElement.closest("div[name='hiddenEditdiv']").closest("td").find("div[id^=isshow]").text(selectOption.text());
        }
        //控制必填标示
        if(tagName=="input"&&jQuery(vthis).attr("datavaluetype")=="4"){     //金额转换字段找必填SPAN
            objId=objId.replace("field_lable","field");
        }
        if(jQuery("span#"+objId+"_ismandspan").size()>0){
            /*
            var isedit = jQuery("oldfieldview"+objId);
            //if(isedit>2){
	            if(!!jQuery(vthis).val()){
	                jQuery("span#"+objId+"_ismandspan").css("display","none");
	            }else{
	                jQuery("span#"+objId+"_ismandspan").css("display","block");
	            }
            //}
            */
            try{
            var idSplitIdStr =objId+"_ismandspan";
            var ismandObj=document.getElementById(idSplitIdStr);
            vtype = jQuery("#"+objId+"").attr("vtype");
            if(vtype==null||vtype==undefined||vtype=="") vtype = -1 ;
            ismand = ismandObj.getAttribute("class");
            var _isedit = 0;
            
            if(document.getElementById("oldfieldview"+objId.replace("field","").replace("_d",""))){
                _isedit = document.getElementById("oldfieldview"+objId.replace("field","").replace("_d","")).value ;
            }
            var tempvalue = jQuery("#"+objId).val();
            var tempojbId = objId.replace("field","field_lable");
            if(jQuery("#"+tempojbId).length>0){
                tempvalue = jQuery("#"+tempojbId).val();
            }
            //if(window.console) console.log("objId="+objId+" vtype = "+vtype+" _isedit="+_isedit+" tempvalue="+tempvalue+"");
            if(ismandObj){
                if(vtype==-1||vtype==1||vtype==3){
                    if(ismand=='ismand'||(vtype==-1&&_isedit>2)){
                            if(tempvalue!=""){
                                    ismandObj.style.display = "none";
                            }else{
                                    ismandObj.style.display = "block";
                            }
                    }else{
                       ismandObj.style.display = "none";
                    }
                }else if(vtype==2){
                      if(tempvalue!=""){
                              ismandObj.style.display = "none";
                      }else{
                              ismandObj.style.display = "block";
                      }
                }
                
            }
            }catch(e){
                if(window.console) console.log("objId = "+objId+"  "+e.message);
            }
        }
    }catch(e){
        if(window.console) console.log("objId = "+objId+"  >>"+e.message);
    }
}
</script>
<%
if("1".equals(detailcardshow)){ 
   weaver.general.BaseBean  MobileERConfig=  new weaver.general.BaseBean();
   String MobileERConfigFormid=Util.null2String(MobileERConfig.getPropValue("MobileERConfig","formid"));
   String detailSpecialInfo = "";
   String detailSpecialRowConfig="";
   if(!"".equals(MobileERConfigFormid)&&(","+MobileERConfigFormid+",").indexOf(","+formId+",")!=-1){
	    detailSpecialInfo = "1";
		detailSpecialRowConfig = Util.null2String(MobileERConfig.getPropValue("MobileERConfig",formId));
   }
%>
  <script type="text/javascript">
    var  detailSpecialInfo="<%=detailSpecialInfo%>";
    var  detailSpecialRowConfig="<%=detailSpecialRowConfig%>";
  </script>
	<link rel="stylesheet" href="/mobile/plugin/1/css/detailcardshow_wev8.css" type="text/css">
    <script type="text/javascript" src="/mobile/plugin/1/js/view/detailcardshow_wev8.js"></script>
<%} %>