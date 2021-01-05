
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.docs.category.security.*" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>

<% 
  if(!HrmUserVarify.checkUserRight("MultiDocUpload:maint", user))  {
    response.sendRedirect("/notice/noright.jsp") ;
    return ;
  }
%>



<%
	String imagefilename = "/images/hdDOC_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(21400,user.getLanguage());
	String needfav ="1";
	String needhelp ="";
	String ownerid = Util.null2String(request.getParameter("ownerid"));


	session.putValue("imagefileids_MultiDocUp","");
%>

<HTML>
  <HEAD>
    <LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/xmlextras_wev8.js"></script>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>

		<link href="/js/swfupload/default_wev8.css" rel="stylesheet" type="text/css" />
		<script type="text/javascript" src="/js/swfupload/swfupload_wev8.js"></script>
		<script type="text/javascript" src="/js/swfupload/swfupload.queue_wev8.js"></script>
		<script type="text/javascript" src="/js/swfupload/fileprogress_wev8.js"></script>
		<script type="text/javascript" src="/js/swfupload/handlers_wev8.js"></script>
		<script type="text/javascript" src="/js/selectDateTime_wev8.js"></script>
		<script language=javascript src="/js/ecology8/docs/docSearchInit_wev8.js"></script>
		<script type="text/javascript">
		function onBtnSearchClick(){
		}
		</script>
		<script type="text/javascript">
		
		
		
				var oUpload;
		
				function getSwfupload(maxfilesize) {
				  var secid = jQuery("#seccategory").val();
				  var settings = {
						flash_url : "/js/swfupload/swfupload.swf",
						upload_url: "/docs/docupload/MultiDocUpload.jsp",	// Relative to the SWF file
						//post_params: {"PHPSESSID" : "<?php echo session_id(); ?>"},
						file_size_limit : maxfilesize+" MB",
						file_types : "*.*",
						file_types_description : "All Files",
						file_upload_limit : 100,
						file_queue_limit : 0,
						custom_settings : {
							progressTarget : "fsUploadProgress",
							cancelButtonId : "btnCancel"
						},
						debug: false,
						secid: secid,

						// Button settings
						
						button_image_url : "/js/swfupload/add_wev8.png",	// Relative to the SWF file
						button_placeholder_id : "spanButtonPlaceHolder",
		
						button_width: 100,
						button_height: 18,
						button_text : '<span class="button"><%=SystemEnv.getHtmlLabelName(21406,user.getLanguage())%></span>',
						button_text_style : '.button { font-family: Helvetica, Arial, sans-serif; font-size: 12pt; } .buttonSmall { font-size: 10pt; }',
						button_text_top_padding: 0,
						button_text_left_padding: 18,
							
						button_window_mode: SWFUpload.WINDOW_MODE.TRANSPARENT,
						button_cursor: SWFUpload.CURSOR.HAND,
						
						// The event handler functions are defined in handlers.js
						file_queued_handler : fileQueued,
						file_queue_error_handler : fileQueueError,
						file_dialog_complete_handler : fileDialogComplete_1,
						upload_start_handler : uploadStart,
						upload_progress_handler : uploadProgress,
						upload_error_handler : uploadError,
						upload_success_handler : uploadSuccess,
						upload_complete_handler : uploadComplete,
						queue_complete_handler : queueComplete	// Queue plugin event
					};

					
					
					try{
						oUpload = new SWFUpload(settings);
					} catch(e){alert(e)}
				}
		
				function fileDialogComplete_1(){
					document.getElementById("btnCancel1").disabled = false;
					fileDialogComplete
				}
		
		
				function uploadComplete(fileObj) {
					try {
						/*  I want the next upload to continue automatically so I'll call startUpload here */
						if (this.getStats().files_queued === 0) {
							frmAddSubmit();
							document.getElementById(this.customSettings.cancelButtonId).disabled = true;
						} else {	
							this.startUpload();
						}
					} catch (ex) { this.debug(ex); }
		
				}
			</script>

 </HEAD>
  <BODY>
    <%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	<%
    RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSubmit(this),_top} " ;
    RCMenuHeight += RCMenuHeightStep ;
  
    /*RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:onBack(),_top} " ;
    RCMenuHeight += RCMenuHeightStep ;*/
	%>
	<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>			
	<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" name="newBtn" onclick="onSubmit(this)" class="e8_btn_top" value="<%= SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>"/>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
                <form name="frmAdd" method="post" action="MultiDocMaintOpration.jsp">
                <input type="hidden" name="doclangurage" value="<%=user.getLanguage()%>">
                
				<wea:layout attributes="{'expandAllGroup':'true'}">
					<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
						<wea:item><%=SystemEnv.getHtmlLabelName(15046,user.getLanguage())%></wea:item>
						<wea:item>
							<span>
							       <brow:browser viewType="0" name="seccategory" id="seccategory" browserValue="" idKey="id" nameKey="path" language='<%=""+user.getLanguage() %>'
									_callback="afterOnShowCreaterCatagory" temptitle='<%=SystemEnv.getHtmlLabelName(15046,user.getLanguage())%>'
									browserUrl='<%="/systeminfo/BrowserMain.jsp?mouldID=doc&url=/docs/category/MultiCategorySingleBrowser.jsp?operationcode="+MultiAclManager.OPERATION_CREATEDOC %>'
							        hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
							        completeUrl='<%="/data.jsp?type=categoryBrowser&onlySec=true&operationcode="+MultiAclManager.OPERATION_CREATEDOC%>'
							        linkUrl="#" width="30%"></brow:browser>
							 </span>
							  <font color="red"><%=request.getSession().getAttribute("msg_str")==null?"":request.getSession().getAttribute("msg_str") %></font>
							  <%request.getSession().setAttribute("msg_str",null); %>
						</wea:item>
						<wea:item attributes="{'colspan':'full','isTableList':'true','id':'divProp','samePair':'divProp','display':'none'}"> </wea:item>
					</wea:group>
					<wea:group context='<%=SystemEnv.getHtmlLabelName(33444,user.getLanguage())%>'>
						<wea:item type="groupHead">
							<div>
								<span> 
									<span id="spanButtonPlaceHolder" class="noHide"></span><!--选取多个文件-->
								</span>
								&nbsp;&nbsp;
								<span style="color:#262626;cursor:hand;TEXT-DECORATION:none" disabled onclick="oUpload.cancelQueue();"  class="noHide" id="btnCancel1">
									<span><img src="/js/swfupload/delete_wev8.gif"  border="0"   class="noHide"></span>
									<span style="height:19px"><font style="margin:0 0 0 -1"   class="noHide"><%=SystemEnv.getHtmlLabelName(21407,user.getLanguage())%></font><!--清除所有选择--></span>
								</span>

								</div>
						</wea:item>
						<wea:item attributes="{'colspan':'full'}">
							 <div class="fieldset flash" id="fsUploadProgress">											
							</div>
							<div id="divStatus"></div>
						</wea:item>
					</wea:group>
				</wea:layout>
            <script type="text/javascript">

        	function onShowResource(input,span){
        		data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
        		if (data){
        			if(data.id!=""){
        				span.innerHTML = "<a href='javaScript:openhrm("+data.id+");' onclick='pointerXY(event);'>"+data.name+"</a>"
        				input.value=data.id
        			}else{
        				span.innerHTML = " <IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
        				input.value=""
        			}
        		}
        	}
        	function onShowMutiDummy(input,span){	
    			data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/DocTreeDocFieldBrowserMulti.jsp?para="+input.value)
	    		if (data){
	    			if(data.id!=""){
		    			
	    				dummyidArray=data.id.split(",")
	    				dummynames=data.name.split(",")
	    				
						var sHtml="";
	    				for(var k=0;k<dummyidArray.length;k++){
	    					sHtml = sHtml+"<a href='/docs/docdummy/DocDummyList.jsp?dummyId="+dummyidArray[k]+"'>"+dummynames[k]+"</a>&nbsp"
	    				}
	
	    				input.value=data.id
	    				span.innerHTML=sHtml
	    			}else{			
	    				input.value=""
	    				span.innerHTML=""
	    			}
	    		}
        	}
        	function onShowHrmresID(objval,hrmresspan){
	    		data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp");
	    		if (data){
	    			if(data.id!=""){
	    				jQuery(hrmresspan).html("<A href='javaScript:openhrm("+data.id+");' onclick='pointerXY(event);'>"+data.name+"</A>");
	    				frmAdd.hrmresid.value=data.id
	
	    			}else{
	    				if (objval=="2"){
	    					jQuery(hrmresspan).html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
	    				}else{
	    					jQuery(hrmresspan).html("");
	    				}
	    				frmAdd.hrmresid.value="";
	    			}
	    		}
        	}
        	function onShowAssetId(objval){
	    		data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/cpt/capital/CapitalBrowser.jsp")
	    		if(data){
		    		if (data.id!=""){
			    		assetidspan.innerHTML = "<A href='/cpt/capital/CapitalBrowser.jsp?id="+data.id+"'>"+data.name+"</A>"
			    		frmAdd.assetid.value=data.id
		    		}else{
		    			if (objval=="2"){
		    				assetidspan.innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
		    			}else{
		    				assetidspan.innerHTML =""
		    			}
		    		frmAdd.assetid.value="0"
		    		}
	    		}
        	}
        	function onShowCrmID(objval){
    			data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp")
	    		if(data){
		    		if (data.id!=""){
			    		crmidspan.innerHTML = "<A href='/CRM/data/ViewCustomer.jsp?CustomerID="+data.id+"'>"+data.name+"</A>"
			    		frmAdd.crmid.value=data.id
		    		}else{
		    			if (objval=="2"){
		    				crmidspan.innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
		    			}else{
		   					crmidspan.innerHTML =""
		   				}
		    			frmAdd.crmid.value="0"
		    		}
	    		}
        	}

        	function onShowItemID(objval,itemspan){
        		data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/lgc/asset/LgcAssetBrowser.jsp")
        		if(data){
	        		if (data.id!=""){
	        		jQuery(itemspan).html("<A href='/lgc/asset/LgcAsset.jsp?__id="+data.id+"&paraid="+data.id+"'>"+data.name+"</A>");
	        		frmAdd.itemid.value=data.id;
	        		}else{
	        			if (objval=="2"){
	        				//itemspan.innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	        			}else{
        					jQuery(itemspan).html("");
        				}
	        		frmAdd.itemid.value="0";
	        		}
        		}
        	}
        	function onShowBrowser(id,url,linkurl,type1,ismand){
        		if(type1== 2 || type1 == 19){
        			id1 = window.showModalDialog(url)
        			document.all("customfield"+id+"span").innerHtml = id1.name
        			document.all("customfield"+id).value=id1.id
        		}else{
        			if(type1==143){
        				tmpids = document.all("customfield"+id).value;
        				id1 = window.showModalDialog(url+"?treeDocFieldIds="+tmpids);
        			}else if(type1 != 17 && type1 != 18 && type1!=27 && type1!=37 && type1!=56 && type1!=57 && type1!=65 && type1!=4 && type1!=167 && type1!=164 && type1!=169 && type1!=170 && type1!=162){
        				id1 = window.showModalDialog(url);
            		}else if(type1==4 || type1==167 || type1==164 || type1==169 || type1==170){
            			tmpids = document.all("customfield"+id).value
            			id1 = window.showModalDialog(url+"?selectedids="+tmpids)
            		}else if(type1==162){
							tmpids = document.all("customfield"+id).value;
							url = url + "&beanids=" + tmpids;
							url = url.substring(0, url.indexOf("url=") + 4) + escape(url.substr(url.indexOf("url=") + 4));
							id1 = window.showModalDialog(url);
            		}else{
            			tmpids = document.all("customfield"+id).value
            			id1 = window.showModalDialog(url+"?resourceids="+tmpids)
            		}

        			if(id1){
						if(type1 == 17 || type1 == 18 || type1==27 || type1==37 || type1==56 || type1==57 || type1==65){
							if(id1.id!=0 && id1.id!=""){
								resourceids = id1.id
								resourcename = id1.name
								sHtml = ""
								//resourceids = Mid(resourceids,2,len(resourceids))
								document.all("customfield"+id).value= resourceids
								//resourcename = Mid(resourcename,2,len(resourcename))
								resourceids = resourceids.split(",");
								resourcename = resourcename.split(",");
								for(var i=0;i<resourceids.length;i++){
									if(resourceids[i]!=""){
										sHtml = sHtml+"<a href="+linkurl+resourceids[i]+">"+resourcename[i]+"</a>&nbsp"
									}
								}
								
								//sHtml = sHtml+"<a href="&linkurl&resourceids&">"&resourcename&"</a>&nbsp"
								document.all("customfield"+id+"span").innerHTML = sHtml
							}else{
								if (ismand==0){
									document.all("customfield"+id+"span").innerHTML = "";
								}else{
									document.all("customfield"+id+"span").innerHTML ="<img src='/images/BacoError_wev8.gif' align=absmiddle>";
								}
								document.all("customfield"+id).value=""
								
							}
	            		}else if(type1 == 143){
	        				if(id1.id!=0 && id1.id!=""){
	        					resourceids = id1.id
	        					resourcename = id1.name
	        					sHtml = ""
	        					//resourceids = Mid(resourceids,2,len(resourceids))
	        					document.all("customfield"+id).value= resourceids
	        					//resourcename = Mid(resourcename,2,len(resourcename))
	        					resourceids = resourceids.split(",");
	        					resourcename = resourcename.split(",");
	        					for(var i=0;i<resourceids.length;i++){
	        						if(resourceids[i]!=""){
	        							sHtml = sHtml+"<a href="+linkurl+resourceids[i]+">"+resourcename[i]+"</a>&nbsp"
	        						}
	        					}
	        					
	        					//sHtml = sHtml+"<a href="&linkurl&resourceids&">"&resourcename&"</a>&nbsp"
	        					document.all("customfield"+id+"span").innerHTML = sHtml
	        				}else{
	        					if (ismand==0){
	        						document.all("customfield"+id+"span").innerHTML = "";
	        					}else{
	        						document.all("customfield"+id+"span").innerHTML ="<img src='/images/BacoError_wev8.gif' align=absmiddle>";
	        					}
	        					document.all("customfield"+id).value=""
	        				}
	        		
	        			}else{
		        			
	        				if(id1.id!=0 && id1.id!=""){

	               if (type1 == 162) {
				   		var ids = id1.id;
						var names =  id1.name;
						var descs =  id1.key3;
						sHtml = ""
						ids = ids.substr(1);
						document.all("customfield"+id).value= ids;
						
						names = names.substr(1);
						descs = descs.substr(1);
						var idArray = ids.split(",");
						var nameArray = names.split(",");
						var descArray = descs.split(",");
						for (var _i=0; _i<idArray.length; _i++) {
							var curid = idArray[_i];
							var curname = nameArray[_i];
							var curdesc = descArray[_i];
							sHtml += "<a title='" + curdesc + "' >" + curname + "</a>&nbsp";
						}
						
						document.all("customfield" + id + "span").innerHTML = sHtml;
						return;
	               }
				   if (type1 == 161) {
					   	var ids = id1.id;
					   	var names = id1.name;
						var descs =  id1.desc;
						document.all("customfield"+id).value = ids;
						sHtml = "<a title='" + descs + "'>" + names + "</a>&nbsp";
						document.all("customfield" + id + "span").innerHTML = sHtml;
						return ;
				   }

		       					 if (linkurl == ""){
		       						document.all("customfield"+id+"span").innerHTML = id1.name
		       					 }else{
		       						document.all("customfield"+id+"span").innerHTML = "<a href="+linkurl+id1.id+">"+id1.name+"</a>"
		       					 }
		       					document.all("customfield"+id).value=id1.id
		       				}else{
		       					if (ismand==0){
		       						document.all("customfield"+id+"span").innerHTML = "";
		       					}else{
		       						document.all("customfield"+id+"span").innerHTML ="<img src='/images/BacoError_wev8.gif' align=absmiddle>";
		       					}
		       					document.all("customfield"+id).value=""
		       				}
	
	       			}
            	}
            }
        	}
            </script>
          </BODY>
        </HTML>



 <SCRIPT LANGUAGE="JavaScript">
	<!--          

	function afterOnShowCreaterCatagory(e,datas,fieldid,params){
		if(datas){
			  if(datas.id!="" && datas.id!=0){
					if(true || datas.id!=$GetEle(fieldid).value){
						if(false && $GetEle(fieldid).value!=""){
							top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(21408,user.getLanguage())%>",function(){
									showEle("divProp");
									GetContent("divProp","/docs/docupload/DocPropCustom.jsp?secid=" +datas.id);
							},function(){
								   return;
							});
						}else {
							showEle("divProp");
							GetContent("divProp","/docs/docupload/DocPropCustom.jsp?secid=" +datas.id);
						}
					}
					//$GetEle(span).innerHTML ="<a href='#"+datas.id+"'>"+datas.name+"</a>";
					//$GetEle(input).value=datas.id;
				}else{
					//$GetEle(span).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
					//$GetEle(input).value="";
					divObj=document.getElementById("divProp");
					jQuery(divObj).html("");
					hideEle("divProp");
				}
			}
			var elements = jQuery(".swfupload");
			while(elements.length > 0){
				elements[0].parentNode.innerHTML ="<span id=\"spanButtonPlaceHolder\" class=\"noHide\"></span>";
				document.getElementById("fsUploadProgress").innerHTML ="";
				elements.length = 0;
			}
			var secid=datas.id;
			if(secid){
				 jQuery.ajax({
					type: "POST",
					url: "/docs/category/DocSecCategoryOperator.jsp",
					data: {'secid':secid},
					success: function(data){
						getSwfupload(jQuery.trim(data));
					}
				 });			
			}		
	}
		
	function onShowProjectID(objval){
		datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp");
		if (datas){
			if (datas.id!= "") {
				jQuery(projectidspan).html("<A href='/proj/data/ViewProject.jsp?__id="+datas.id+"&ProjID="+datas.id+"'>"+datas.name+"</A>");
				frmAdd.projectid.value=datas.id
			}
			else {
				if (objval=="2") {
					//projectidspan.innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
				}else{
					jQuery(projectidspan).html("");
				}
				frmAdd.projectid.value="0";
			}
		}
	}

	function  GetContent(divObj,url){
		divObj=document.getElementById(divObj);
		/*divObj.innerHTML="<img src=/images/loading2_wev8.gif> <%=SystemEnv.getHtmlLabelName(19611,user.getLanguage())%>...";
		var xmlHttp = XmlHttp.create();
		xmlHttp.open("GET",url, true);
		xmlHttp.onreadystatechange = function () {
			switch (xmlHttp.readyState) {
			   case 3 :
					divObj.innerHTML="<img src=/images/loading2_wev8.gif> <%=SystemEnv.getHtmlLabelName(19612,user.getLanguage())%>...";
					break;
			   case 4 :
				   divObj.innerHTML =xmlHttp.responseText;		
				   changeUploaderFileLimit();
				   break;
			}
		}
		xmlHttp.setRequestHeader("Content-Type","text/xml")
		xmlHttp.send(null);*/
		jQuery.ajax({
			url:url,
			dataType:"html",
			type:"get",
			beforeSend:function(){
				//jQuery(divObj).html("<img src=/images/loading2_wev8.gif> <%=SystemEnv.getHtmlLabelName(19611,user.getLanguage())%>...");
				e8showAjaxTips("<%= SystemEnv.getHtmlLabelName(81558,user.getLanguage())%>",true);
			},
			complete:function(){
				e8showAjaxTips("",false);
			},
			success:function(data){
				jQuery(divObj).html(data);
			}
		});
	}

	function changeUploaderFileLimit(){
		var limit = $GetEle("maxuploadfilesize").value
		if(limit==0||limit==""){
			oUpload.setFileSizeLimit("1");
		}else{
			oUpload.setFileSizeLimit(limit+" MB");
		}		
	}
	  function onSubmit(obj){    
		  //1。做必填字段判断
		  //a.目录为必选
		  if(!check_form(document.frmAdd,'seccategory')) return false;
		  //b.各目录相应的字段为必选
		  try{
			  var oNeedinputitems=document.getElementById("needinputitems");
			  if(oNeedinputitems!=null) {
				  if(oNeedinputitems.value!="") {
					    //alert(oNeedinputitems.value);
					    if(!check_form(document.frmAdd,oNeedinputitems.value)) return false;
				  }
			  }
			
		  } catch (e){}

		  //2。上传所有的附件
		  var oStats=oUpload.getStats();
		  //alert(oStats.files_queued);
		  if(oStats.files_queued==0){
			top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83433,user.getLanguage())%>")
		  } else {
			 //alert(oUpload.getStats());
			 obj.disabled=true ;
			 //document.getElementById("tblProp").disabled=true;
			 oUpload.startUpload();	 
		  }		 
	  }

	  function frmAddSubmit(){		
		  frmAdd.submit();

		
	  }

	   function onBack(){ 
		 window.history.go(-1);
	  }
	  
	function onshowdocmain(vartmp){
		var otrtmp = document.getElementById("otrtmp");
		if(otrtmp!=null&&otrtmp.parentElement!=null){
			if(vartmp==1){
				otrtmp.parentElement.style.display='';
				otrtmp.parentElement.parentElement.parentElement.rows(otrtmp.parentElement.rowIndex+1).style.display='';
			} else {
				otrtmp.parentElement.style.display='none';
				otrtmp.parentElement.parentElement.parentElement.rows(otrtmp.parentElement.rowIndex+1).style.display='none';
			}
		}
	}

	//-->
	</SCRIPT>
	<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
  <SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>


	


