<%@ page language="java" contentType="text/html; charset=UTF-8"%>

<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<%@ taglib uri="/browserTag" prefix="brow"%>

<%@ include file="/systeminfo/init_wev8.jsp"%>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.conn.RecordSet"%>
<%@ page import="java.sql.Timestamp" %>
<HTML>
    <HEAD>

        <SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
        <script type="text/javascript" src="/wui/theme/ecology8/page/perfect-scrollbar/perfect-scrollbar_wev8.js"></script>
        <script type="text/javascript" src="/wui/theme/ecology8/page/perfect-scrollbar/jquery.mousewheel_wev8.js"></script>
        <script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
		<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
		<script language="javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
        <LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
        <link rel="stylesheet" href="/fullsearch/css/fixedSer_wev8.css" type="text/css" />
        <style>
            .delimg{float:right;z-index:2;left:88px;bottom:36px;width:20px;height:20px;position:absolute;cursor: pointer;}
            .imgdiv{float:left;margin:5px;width:100px;height:40px;position:relative}
            .imgcontent{position:absolute;width:100px;height:40px;z-index:1;}
            .img{height:45px;width:45px;border-radius:22.5px;}
            .imgshow{display:none}
            .input-file {
                overflow:hidden;
                position:relative;
                }
                .fileSrcUrl{
                /*position:absolute;*/
                right: 0;
			    top: -5px;
			    opacity: 0;
			    filter: alpha(opacity=0);
			    opacity:0;
			    cursor: pointer;
                width:70px;
                height:30px;
            }
            
            .delButton{
                background:rgb(255,255,255);
                border:1px solid rgb(39,173,255);
                color:rgb(48,181,255);
                width:40px;
                height:25px;
            }
            
            .signButton{
                background:rgb(255,255,255);
                border:1px solid rgb(39,173,255);
                color:rgb(48,181,255);
                width:70px;
                height:30px;
                cursor: pointer;
            }
            .signButtonUn{
                background:rgb(2,161,140);
                border:1px solid rgb(39,173,255);
                color:rgb(255,255,255);
                width:70px;
                height:30px;
                cursor: pointer;
            }
            .spanLabel{
	            margin-top:5px;
				vertical-align:middle;
				padding-left:25px;
				font-family:微软雅黑 Bold;
				font-size:15px;
				color:black;
            }
            .saveButton{
            	width:100px;
            	height:30px;
            	color:#ffffff;
            	background:rgb(39,173,255);
            	margin-top:10px;
            	border:none;
            	border-radius:5px;
            	cursor: pointer;
            }
            .saveButtonUn{
            	width:100px;
            	height:30px;
            	color:#ffffff;
            	background:rgb(2,161,140);
            	margin-top:10px;
            	border:none;
            	border-radius:5px;
            	cursor: pointer;
            }
        </style>
        <script language="javascript">
            $(document).ready(function(){
                //状态 鼠标移动事件
                $(".taskstatusobj").mouseover(function(){
                     $(this).removeClass("taskunselect");
                     $(this).addClass("taskselect");
                });
                //状态鼠标移出事件
                $(".taskstatusobj").mouseout(function(){
                   if(!$(this).hasClass("taskcurrentselect")){
                        $(this).removeClass("taskselect");
                        $(this).addClass("taskunselect");
                   }
                   
                });
                // 状态点击事件
                $(".taskstatusobj").click(function(){
                    $(".taskstatusobj").each(function(){
                          $(this).removeClass("taskselect");
                          $(this).removeClass("taskcurrentselect");
                          $(this).addClass("taskunselect");
                    });
                    $(this).removeClass("taskunselect");
                    $(this).addClass("taskselect");
                    $(this).addClass("taskcurrentselect");
            
                });
                
                $("#signButton").mouseover(function(){
                    $(this).removeClass("signButton");
                    $(this).addClass("signButtonUn");
                });
                
                $("#signButton").mouseout(function(){
                    $(this).removeClass("signButtonUn");
                    $(this).addClass("signButton");
                });
                $("#saveButton").hover(function(){
                	$(this).removeClass("saveButton");
                    $(this).addClass("saveButtonUn");
                },function(){
                	$(this).removeClass("saveButtonUn");
                    $(this).addClass("saveButton");
                })
                registerDragEvent();
            });
            function registerDragEvent(){
		     var fixHelper = function(e, ui) {
		        ui.children().each(function() {  
		          jQuery(this).width(jQuery(this).width());     //在拖动时，拖动行的cell（单元格）宽度会发生改变。在这里做了处理就没问题了  
		          jQuery(this).height("30px");                      //在CSS中定义为30px,目前不能动态获取
		        });  
		        return ui;  
		    }; 
		     jQuery(".ListStyle tbody").sortable({                //这里是talbe tbody，绑定 了sortable  
		         helper: fixHelper,                  //调用fixHelper  
		         axis:"y",  
		         start:function(e, ui){
		             ui.helper.addClass("moveMousePoint");
		           ui.helper.addClass("e8_hover_tr")     //拖动时的行，要用ui.helper  
		           if(ui.item.hasClass("notMove")){
		            e.stopPropagation();
		           }
		           $(".hoverDiv").css("display","none");
		           return ui;  
		         },  
		         stop:function(e, ui){
		             //ui.item.removeClass("ui-state-highlight"); //释放鼠标时，要用ui.item才是释放的行  
		             jQuery(ui.item).hover(function(){
		                jQuery(this).addClass("e8_hover_tr");
		            },function(){
		                jQuery(this).removeClass("e8_hover_tr");
		                
		            });
		            jQuery(ui.item).removeClass("moveMousePoint");
		            sortOrderTitle();
		            return ui;  
		         }  
		     }); 
		     function sortOrderTitle()
				{
				    jQuery("#tabfield tbody tr").each(function(index){
				        jQuery(this).find("input[name=fieldorder]").val(index);
				    })
				} 
		}
        </script>
    </head>
    <%! 
    private static boolean getCanEditFlg(){
    	boolean canEditFlg = false;
    	RecordSet rs = new RecordSet();
    	String getCanEditSql = "select sValue from FullSearch_EAssistantSet where sKey = 'canEditFix'";
    	rs.execute(getCanEditSql);
    	if(rs.next()){
    		canEditFlg = rs.getString("sValue").equals("1")?true:false;
    	}
    	return canEditFlg;
    } 
    
    %>
    <% 
	    if (!HrmUserVarify.checkUserRight("eAssistant:fixedInst", user)) {
			response.sendRedirect("/notice/noright.jsp");
	        return;
	    }
        String showStatus = Util.null2String(request.getParameter("showStatus"),"0");
        String imageIdFromSelect = Util.null2String(request.getParameter("imagefileid"));
        String name = Util.null2String(request.getParameter("name"));
        String order = Util.null2String(request.getParameter("order"));
        String fromUrl = Util.null2String(request.getParameter("fromUrl"),"0");
        String method = Util.null2String(request.getParameter("method"));
        String addDescLst = Util.null2String(request.getParameter("addDescLst"));
        boolean canEditFlg = getCanEditFlg();
        if(method.equals("reShow")){
            RecordSet rs = new RecordSet();
            String reShowSql = "select * from FullSearch_FixedInst where id = "+showStatus+"";
            rs.executeSql(reShowSql);
            rs.next();
            showStatus = rs.getInt("id")+"";
            name = rs.getString("instructionName");
            imageIdFromSelect =(!"".equals(rs.getString("instructionImgSrc"))) ?  rs.getString("instructionImgSrc"):rs.getString("defaultImgSrc");
            order = rs.getString("showorder");
            
        }
        
        String imagefilename = "/images/hdReport_wev8.gif";
        String titlename =SystemEnv.getHtmlLabelName(128696,user.getLanguage());
        String needfav = "1";
        String needhelp = "";
    %>
    <BODY style="overflow-y:hidden">
        <div style="overflow:hidden;">
            <form id="weaverA" name="weaverA" method="post" action="ViewFixedInstLib.jsp" enctype="multipart/form-data">
                <input type="hidden" name="showStatus" id="showStatus" value="<%=showStatus %>">
                <input type="hidden" name="method" id="method" value="<%=method %>">
                <input type="hidden" name="imageIdFromSelect" id="imageIdFromSelect" value="<%=imageIdFromSelect %>">
                <input type="hidden" name="delFieldIds" id="delFieldIds" value="">
                <input type="hidden" name="showOrderDetail" id="showOrderDetail" value="">
                <input type="hidden" name="isCast" id="isCast" value="">
                <div style="float:left; width:35%;" >
                    <div class="taskmaindiv" style="margin-top:10px;" id ="fixedInstList">
                       <div class="fixListHeadDiv" style="padding-top:10px;background:#eef1f9">
                           <span class="spanLabel"> <%=SystemEnv.getHtmlLabelName(128715,user.getLanguage())%></span>
                           <%if(canEditFlg == true){%>
                           <div style="float:right">
                             <button type="button" class="addbtn" style="padding-right:20px;" onclick="showDetail('add','','/fullsearch/img/fullsearch_defaultInst.png','0.0','0','add');" 
                             title="<%=SystemEnv.getHtmlLabelName(456,user.getLanguage())%>" onFocus="this.blur()"></button> 
                           </div>
                           <%} %>
                       </div>
                       <div style="overflow-y:auto;height:92%;padding-left:20px;padding-right:20px;">
                           <%
                            String instSql = "";
                            RecordSet rs = new RecordSet();
                            instSql = "select id, instructionName,instructionImgSrc,showorder,showexample,defaultImgSrc,isCast from FullSearch_FixedInst order by showorder";
                               
                            rs.executeSql(instSql);
                            while(rs.next()){
                                 %> 
                           <div class="taskstatusobj <%if((rs.getInt("id")+"").equals(showStatus) ){ %> taskselect taskcurrentselect <%}else{ %>taskunselect<%}%>"  
                           		onclick="showDetail('<%=rs.getInt("id") %>','<%=rs.getString("instructionName") %>','<%=!"".equals(Util.null2String(rs.getString("instructionImgSrc")))?rs.getString("instructionImgSrc"):rs.getString("defaultImgSrc")%>',
                           		'<%=Util.getPointValue3(rs.getString("showorder"), 1, "0") %>','<%=rs.getString("isCast") %>','show')">
                               <table style="table-layout:fixed;margin-top:0px;border-top:0px;width:100%;" cellpadding="0" cellspacing="0">
                                   <colgroup>
                                       <col width=10%>
                                       <col width=80%>
                                       <col width=10%>
                                   </colgroup>
                                   <tr>
                                      <td rowspan="2" class="" style="height:50px;width:50px;">
                                             <span><img src="<%=!"".equals(Util.null2String(rs.getString("instructionImgSrc")))?rs.getString("instructionImgSrc"):rs.getString("defaultImgSrc")%>" style="height:30px;width:30px;border-radius:22.5px;"/></span>
                                      </td>
                                      <td class=" " style="text-align:left">
                                          <span class="instructionName"><%=rs.getString("instructionName")%></span>
                                      </td>
                                      <td rowspan="2">
                                        <img src="/fullsearch/img/rightArrows_wev8.png" style="width:14px;height:20px"/>
                                      </td>
                                   </tr>
                                   <tr>
                                       <td style="text-align:left">
                                           <span><%=rs.getString("showexample") %></span>
                                       </td>
                                   </tr>
                               </table>
                           </div>
                           <div class="taskstatusline"></div>
                            <%} %>
                        </div>
                   </div>
                </div>
                <%if(showStatus.equals("0")){
                    
                %>
                    <div style="float:left; width:60%;margin-left:30px;height:250px;display:block" id="show1">
                        <div class="taskmaindiv" style="margin-top:10px;">
                           <div class="fixListHeadDiv" style="padding-top:10px;background:#eef1f9">
                               <span class="spanLabel"> <%=SystemEnv.getHtmlLabelName(128716,user.getLanguage())%></span>
                           </div>
                           <div style="padding-top:80px;padding-left:400px">
                               <span><%=SystemEnv.getHtmlLabelName(128721,user.getLanguage())%></span>
                           </div>
                           
                        </div>
                    </div>
                <%} %>
                
                
                <div style="float:left; width:60%;margin-left:30px;height:530px;display:none" id="show2">
                    <div class="taskmaindiv" style="margin-top:10px;">
                       <div class="fixListHeadDiv" style="padding-top:10px;background:#eef1f9">
                           <span class="spanLabel"> <%=SystemEnv.getHtmlLabelName(128716,user.getLanguage())%></span>
                           <%if(canEditFlg == true){%>
                           <div style="float:right;padding-right:20px;display:none" id="canDeleteIns">
                             <button type='button' class=delbtn onclick=deleteInst() title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" onFocus="this.blur()"></button> 
                           </div>
                           <%} %>
                       </div>
                       <div id="orderName" style="">
                           <table style="width:100%">
                               <colgroup>
                                   <col width="20%">
                                   <col width="80%">
                               </colgroup>
                               <tr>
                                   <td style="text-align:center;padding-top:15px;padding-bottom:15px">
                                       <%=SystemEnv.getHtmlLabelName(128717,user.getLanguage())%>
                                   </td>
                                   <td>
                                       <input type="text" name="name" id="name" style="width:40%" value="<%=name%>">
                                   </td>
                               </tr>
                           </table>
                       </div>
                       <div class="orderFullLine"></div>
                       <div id="orderSign" style="">
                              <table style="width:100%">
                                  <colgroup>
                                      <col width="20%">
                                      <col width="60%">
                                      <col width="20%">
                                  </colgroup>
                                  <tr>
                                      <td style="text-align:center;padding-top:15px;padding-bottom:15px">
                                          <%=SystemEnv.getHtmlLabelName(128718,user.getLanguage())%>
                                      </td>
                                      <td>
                                          <div id="preview" style="width:100%;height:auto"></div>
                                      </td>
                                      <td style="">
                                          <span class="input-file"><input type="button" id="signButton" value="<%=SystemEnv.getHtmlLabelName(128732,user.getLanguage()) %>" class="signButton"/><input type="file" class="fileSrcUrl" name="fileSrcUrl" id="fileSrcUrl"></span>
                                      </td>
                                  </tr>
                              </table>
                          </div>
                          <div class="orderFullLine"></div>
                          <div id="orderSort" style="">
                              <table style="width:100%">
                                  <colgroup>
                                      <col width="20%">
                                      <col width="80%">
                                  </colgroup>
                                  <tr>
                                      <td style="text-align:center;padding-top:15px;padding-bottom:15px">
                                          <%=SystemEnv.getHtmlLabelName(128719,user.getLanguage())%>
                                      </td>
                                      <td>
                                          <input type="text" name="order" id="order" style="width:20%" value="<%=order %>">
                                      </td>
                                  </tr>
                              </table>
                          </div>
                          <div class="orderFullLine"></div>
                          <div id="orderDesc" style="">
                              <div style="background:RGB(247,247,247);padding:8px">
                                  <%=SystemEnv.getHtmlLabelName(128720,user.getLanguage())%>
                                  <%if(canEditFlg == true){
                                  %>
                                  <div style="float:right">
                                    <button type='button' class=addbtn onclick=addRowNew(); title="<%=SystemEnv.getHtmlLabelName(456,user.getLanguage())%>" onFocus="this.blur()"></button> 
                                    <button type='button' class=delbtn onclick=removeRowNew(); title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" onFocus="this.blur()"></button> 
                                  </div>
                                  <%
                                	  
                                  } %>
                                  
                              </div>
                              <div style="float:bottom;height:250px;overflow-y: auto; padding-left:20px;padding-right:20px" id="instrDesc">
                                  <table id="tabfield" class=ListStyle style="table-layout:fixed;margin-top:0px;border-top:0px;width:100%;border-collapse:collapse" cellpadding=0 cellspacing=0>
                                      <colgroup>
                                      <%if(canEditFlg == true){
	                                  %>
	                                      <col width=3% >
                                          <col width=3% >
                                          <col width=76% >
                                          <col width=18% >
	                                  <%
	                                      
	                                  }else{ %>
                                          <col width=4% >
                                          <col width=76% >
                                          <col width=20% >
	                                  <%} %>
                                          
                                      </colgroup>
                                      <tbody id="instrDescTbody">
                                      </tbody>
                                  </table>
                              </div>
                          </div>
                          <div style="background:RGB(247,247,247);text-align:center;height:50px;margin: 0 auto">
                                  <input type="button" id="saveButton" class="saveButton" value="<%=SystemEnv.getHtmlLabelName(30986,user.getLanguage())%>" onclick="save()">
                          </div>
                    </div>
                </div>
                
                
            </form>
        </div>
    </body>
    <script language="javascript">
    var dialog;
    var showStatus = $("#showStatus").val();
    var name = $("#name").val();
    var order = $("#order").val();
    if(showStatus != 0){
        showDetail(showStatus,name,"<%=imageIdFromSelect%>",order,'1',"show");
    }
    
    dialog = new window.top.Dialog();
    function showDetail(id,name,src,order,isCast,method){
    jQuery("body").jNice();
        $("#showStatus").val(id);
        $("#name").val(name);
        $("#order").val(order);
        $("#method").val(method);
        $("#isCast").val(isCast);
        jQuery.ajax({
        url:"ViewFixedInstLibAjax.jsp",
        dataType:"text",
        type:"post",
        method:"show",
        data:{
            showStatus:id,
            name:name,
            src:src,
            order:order,
            method:method,
            addDescLst:'<%=addDescLst%>',
            canEditFlg:'<%=canEditFlg%>'
        },
        success:function(datas){
            if(datas!=""){
                $("#show1").css("display","none");
                $("#show2").css("display","block");
                $("#instrDescTbody").html(datas);
                showPreview(id,src);
                if(isCast=='1' && '<%=canEditFlg%>' == 'true'){
                	$("#canDeleteIns").css("display","block");
                }else{
                	$("#canDeleteIns").css("display","none");
                }
                jQuery("body").jNice();
            }
        }
       });
    
    }
    
    function save(){
        var id = $("#showStatus").val();
        var name = $("#name").val();
        var order = $("#order").val();
        var imageIdFromSelect = "";
        var firstDesc = "";
        if(id == '<%=showStatus%>' && !"" == <%=fromUrl%>){
            imageIdFromSelect = $("#imageIdFromSelect").val();
        }else{
            imageIdFromSelect = "";
        }
        var method = "save";
        //固定指令说法排序列表
        var orderArr = document.getElementsByName("fieldorder");
        var fieldorder = "";
        for(var i=0; i < orderArr.length; i++){
            (fieldorder == "")?fieldorder+=orderArr[i].value : fieldorder+=","+orderArr[i].value
        }
        //固定指令说法ID列表
        var idArr = document.getElementsByName("fieldid");
        var fieldid = "";
        for(var i=0; i < idArr.length; i++){
            (fieldid == "")?fieldid+=idArr[i].value : fieldid+=","+idArr[i].value;
        }
        //固定指令说法描述列表
        //固定指令showExample字段用说法
        var descArr = document.getElementsByName("descLst");
        var desc = "";
        for(var i=0; i < descArr.length; i++){
        	if(i==0){
        		desc+=descArr[i].value;
        	}else{
        		desc+=","+descArr[i].value;
        	}
            if(firstDesc == ""){
            	firstDesc = descArr[i].value;
            }
        }
        
        //固定指令showExample字段用说法
        //if(document.getElementsByName("descLst")){
        //    firstDesc = document.getElementsByName("descLst")[0].value;
        //}
        
        //删除固定指令ID列表
        var delFieldIds = $("#delFieldIds").val();
        jQuery.ajax({
        url:"ViewFixedInstLibAjax.jsp",
        dataType:"text",
        type:"post",
        data:{
            showStatus:jQuery("#showStatus").val(),
            name:jQuery("#name").val(),
            order:jQuery("#order").val(),
            fieldorder:fieldorder,
            fieldid:fieldid,
            firstDesc:firstDesc,
            desc:desc,
            imageIdFromSelect:imageIdFromSelect,
            method:method,
            delFieldIds:delFieldIds,
        },
        success:function(datas){
            if(datas.length > 1){
                document.forms[0].action="ViewFixedInstLib.jsp?method=reShow&showStatus="+datas;
                doSubmit();
            }
        }
       });
    }
    
    $(document).ready( function() {
        var bodyheight = jQuery("body",parent.document).height();
        var fixedInstListHeig = bodyheight - 90;
        var orderDescHeig = fixedInstListHeig - 250;
        var instrDescHeig = orderDescHeig - 43;
        $("#fixedInstList").css("height",fixedInstListHeig+"px");
        $("#show2").css("height",fixedInstListHeig+"px");
        $("#orderDesc").css("height",orderDescHeig+"px");
        $("#instrDesc").css("height",instrDescHeig+"px");
        $("#fileSrcUrl").change( function() {
            var showStatus = $("#showStatus").val();
            var name = $("#name").val();
            var order = $("#order").val();
            var method = $("#method").val();
            var imgUrl=this.value;
            //如果是add的情形下就将新添加的指令详情单独保存
	        var addDescLst = '';
	        $("input[name=descLst]").each(function(){
	        	addDescLst += $(this).val() + "^";
	        })
            if(imgUrl!=""){
	            document.forms[0].action="GetFullsearchIconImg.jsp?showStatus="+showStatus+"&name="+name+"&order="+order+"&addDescLst="+addDescLst;
	            doSubmit();
            }
        }); 
    });
                
    function showPreview(id,imgid){
        var imghtml="";
                    imghtml+="<div class='imgdiv'>" ;
                    <%if(!imageIdFromSelect.equals("")){%>
                        if(id == '<%=showStatus%>' && !"reShow"=="<%=method%>"){
                           imghtml+= "<div class='imgcontent'><img src='/weaver/weaver.file.FileDownload?fileid=<%=imageIdFromSelect%>' class='img' /></div></div>";
                        }else{
                          imghtml+= "<div class='imgcontent'><img src='"+imgid+"' class='img' /></div></div>";
                        }
                        
                    <%}else{%>
                          imghtml += "<div class='imgcontent'><img src='"+imgid+"' class='img' /></div></div>";
                        <%}%>
        $("#preview").html(imghtml);
    }
    
    jQuery(function(){
		$("#tabfield").find("tr")
		.live("mouseover",function(){$(this).find("img[moveimg]").attr("src","/proj/img/move-hot_wev8.png").attr("title","<%=SystemEnv.getHtmlLabelName(82783,user.getLanguage())%>").show()})
		.live("mouseout",function(){$(this).find("img[moveimg]").attr("src","").attr("title","").hide()});
	});
    
    function removeRowNew(dspOrd){
        var chkobj = $("input:checked[name='fieldChk']");
	    if(chkobj.length<=0)
	    {
	        window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22686,user.getLanguage())%>");
	    return false;
	    }
	    window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>",function(){
	        var delfields = ""
	        $("input:checked[name='fieldChk']").each(function(){
	            
	            var delfieldid = jQuery(this).parent().parent().parent().find("input[name=fieldid]").val();
	            if(delfields.length>0)delfields+=",";
                delfields+=delfieldid;
	            jQuery(this).parent().parent().parent().remove();
	            
	        });
	        jQuery("#delFieldIds").val(delfields);
	    });
    }
    
    function addRowNew(){
    var maxOrder = getMaxOrder();
    maxOrder = parseInt(maxOrder) + 1;
	var oRow;
	var oCell;
	oRow = jQuery("#tabfield")[0].insertRow(-1);
	oRow.className="DataLight";
	oCell = oRow.insertCell(-1);
	oCell.innerHTML = "<input name='fieldChk' type='checkbox' value='' class=''>" ;

	oCell = oRow.insertCell(-1);
	oCell.innerHTML = "<span><img moveimg style='display:none'/></span>";
	
	oCell = oRow.insertCell(-1);
	oCell.style.padding="5px";
	oCell.innerHTML = "<input type='text' style='width:70%' id='descLst' name='descLst' value=''><SPAN></SPAN>";
	
	oCell = oRow.insertCell(-1);
	oCell.innerHTML = "<input  type='hidden' id='fieldid' name='fieldid' value='create' ><input name='fieldorder' id='fieldorder' type='hidden' value='"+maxOrder+"' >";
	
	jQuery("body").jNice();
}

	function getMaxOrder(){
		var maxOrder = "";
		var len = jQuery("#tabfield").find("input[name=fieldorder]").length;
		if(len > 0){
			maxOrder = jQuery("#tabfield").find("input[name=fieldorder]").eq(len-1).val();
		}else{
			maxOrder = 0;
		}
		
		return maxOrder;
	}

function deleteInst(){
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>",function(){
		jQuery.ajax({
        url:"ViewFixedInstLibAjax.jsp",
        dataType:"text",
        type:"post",
        data:{
            showStatus:jQuery("#showStatus").val(),
            method:'delete'
        },
        success:function(datas){
            if(datas == 'success'){
                document.forms[0].action="ViewFixedInstLib.jsp";
                doSubmit();
            }
        }
       });
	})
}

function doSubmit()
{
    document.forms[0].submit();
}
</script>
    <SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
    <SCRIPT language="javascript" defer="defer"
        src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</html>


<script language="javascript">

function preDo(){
    $("#topTitle").topMenuTitle({searchFn:onBtnSearchClick});
}

function onBtnSearchClick(){
    var name=$("input[name='s_name']",parent.document).val();
    $("#serviceName").val(name);
    doSubmit();
}

function doSearchsubmit(){
    $('#weaverA').submit();
}

function closeDialog(){
    _table. reLoad();
    dialog.close();
}

</script>
