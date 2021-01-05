<%@ page import="weaver.general.Util" %>
<%@page import="weaver.workflow.request.RevisionConstants"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*,java.sql.Timestamp" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>



<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="FieldFormSelect" class="weaver.workflow.field.FieldFormSelect" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo1" class="weaver.docs.category.SecCategoryComInfo" scope="page" />



<link rel="stylesheet" type="text/css" href="/kindeditor/skins/default_wev8.css" />
<script type="text/javascript" language="javascript" src="/kindeditor/kindeditor_wev8.js"></script>
<script type="text/javascript" language="javascript" src="/kindeditor/kindeditor-Lang_wev8.js"></script>



<script type="text/javascript" src="/js/swfupload/swfupload_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/swfupload.queue_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/fileprogress_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/handlers_wev8.js"></script>


<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/freeWorkflowShow_wev8.js"></script>




<script type="text/javascript" src="/wui/common/js/ckeditor/ckeditor_wev8.js"></script>
<script type="text/javascript" src="/wui/common/js/ckeditor/ckeditorext_wev8.js"></script>

<script type="text/javascript" src="/js/ecology8/jquery.fix.clone_wev8.js"></script>





<!--签字意见-->
<link rel="stylesheet" type="text/css" href="/css/ecology8/workflowsign_wev8.css" />

<!--自由流程样式-->
<link rel="stylesheet" type="text/css" href="/css/ecology8/freeworkflow_wev8.css" />


<style>
 #topcontaienr {
	position:relative; 
	margin:0px auto; 
	padding:0px; 
	width: 100%;
	height: 459px;
	overflow: hidden;
}

#contaienr {
	width: 100%;
	height: 457px;
	margin-top: -2px;
	
}

.formtable {
  padding-bottom: 0;
}


.addformtable{

 position:absolute;
 right:0px;
 top:2px;

}

.tablearea{

  clear:both;
  padding:2px;
  display:none;

}

.tableoptionbutton{
  margin-right:5px;
}

.freewfformtablefields{
 
  display:none;

}

table.ke-container {
    border-top: none !important;
	border-left: none !important;
	border-right: none !important;
}




</style>


<script>


    jQuery(document).ready(function ($) {
       "use strict";
       $('#topcontaienr').perfectScrollbar({minScrollbarLength:30});
    });

    var pdocument=jQuery(parent.document);


	

   //隐藏父菜单
  //  pdocument.find("#toolbarmenudiv").css("display","none");
	//pdocument.find("#requestTabButton").css("display","none");
    pdocument.find("#mainRequestFrame").show();

    
	pdocument.find("#mainRequestFrame").css("height","100%");
	//pdocument.find("#divWfBill").css("height","100%");
	//pdocument.find("#divWfBill").css("padding","0px");

    

</script>







<%	
String newfromdate="a";
String newenddate="b";
String workflowid=Util.null2String(request.getParameter("workflowid"));
String nodeid=Util.null2String(request.getParameter("nodeid"));
String formid=Util.null2String(request.getParameter("formid"));
//对不同的模块来说,可以定义自己相关的工作流
String prjid = Util.null2String(request.getParameter("prjid"));
String docid = Util.null2String(request.getParameter("docid"));
String crmid = Util.null2String(request.getParameter("crmid"));
String hrmid = Util.null2String(request.getParameter("hrmid"));
//......
String topage = Util.null2String(request.getParameter("topage"));


String[] createrids=Util.null2String(request.getParameter("handdata")).split(",");


int userid=user.getUID();
String logintype = user.getLogintype();
Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String currentdate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
String currenttime = (timestamp.toString()).substring(11,13) +":" +(timestamp.toString()).substring(14,16)+":"+(timestamp.toString()).substring(17,19);
String username = "";
if(logintype.equals("1"))
	username = Util.toScreen(ResourceComInfo.getResourcename(""+userid),user.getLanguage()) ;
if(logintype.equals("2"))
	username = Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(""+userid),user.getLanguage());

String workflowname=WorkflowComInfo.getWorkflowname(workflowid);
String needcheck="name";
int rowsum=0;
String isSignDoc_add="";
String isSignWorkflow_add="";
RecordSet.execute("select titleFieldId,keywordFieldId,isSignDoc,isSignWorkflow from workflow_base where id="+workflowid);
if(RecordSet.next()){
    isSignDoc_add=Util.null2String(RecordSet.getString("isSignDoc"));
    isSignWorkflow_add=Util.null2String(RecordSet.getString("isSignWorkflow"));
}
//获取常用联系人,如果为空，则默认为同部门的10人,如果常用联系人少于10人，则用同部门人替补
String sql="select top 10 operator,COUNT(*) as times  from bill_FreeWorkflowConnector where  creater ="+userid+" group by  operator order by times  desc";
RecordSet.execute(sql);

int languageid = Util.getIntValue(user.getLanguage()+"");

int operator=-1;
List<Integer>  commonusers=new ArrayList<Integer>();
while(RecordSet.next())
{
   operator=RecordSet.getInt("operator");
   if(operator!=userid)
   {
      commonusers.add(operator);
   }   
}
String  excludeitem="";

for(Integer i:commonusers)
{
  excludeitem=excludeitem+"'"+i+"',";
}
if(commonusers.size()>0)
 excludeitem="("+excludeitem.substring(0,excludeitem.length()-1)+")";
if(commonusers.size()<10) {
   int needadd=10-commonusers.size();
   if(!excludeitem.equals(""))
		sql="select top "+needadd+" id from  HrmResource a  where  departmentid in(select  b.departmentid  from HrmResource b ) and a.id!="+userid +"  and a.id not in "+excludeitem;
   else
		sql="select top "+needadd+" id from  HrmResource a  where  departmentid in(select  b.departmentid  from HrmResource b ) and a.id!="+userid ;

   RecordSet.execute(sql);
   while(RecordSet.next()) {
	   operator=RecordSet.getInt("id");
       commonusers.add(operator);
   } 

}
  int annexmainId=0;
  int annexsubId=0;
  int annexsecId=0;
  boolean haveattachment=false;
  
  //查找附件上传路径
  sql="select  a.docCategory,a.docPath  from workflow_base a where a.id="+workflowid;
  RecordSet.execute(sql);
  
  if(RecordSet.next())
  {
    
	 String  docinfo=RecordSet.getString("docCategory");
     String[] docitems=docinfo.split(",");
     
     if (docitems.length > 0) {
	     annexmainId=Integer.valueOf(docitems[0]);
		 annexsubId=Integer.valueOf(docitems[1]);
		 annexsecId=Integer.valueOf(docitems[2]);
	     haveattachment=true;
     }
  }




%>
<iframe id="downloadFrame" style="display: none"></iframe>
<form name="frmmain" method="post" action="BillFreeWorkflowOperation.jsp">
<input type=hidden name="workflowid" value=<%=workflowid%>>
<input type=hidden name="nodeid" value=<%=nodeid%>>
<input type=hidden name="nodetype" value="0">
<input type=hidden name="src">
<input type=hidden name="iscreate" value="1">
<input type=hidden name="isbill" value="1">
<input type=hidden name="fc_formid" >
<input type=hidden name="formmodeid" >

<input type=hidden name="isfreeworkflowbindform" value=0>

<input type=hidden name="formid" value=<%=formid%>>
<input type="hidden" value="0" name="nodesnum">
<input type=hidden name ="topage" value="<%=topage%>">
<input type=hidden name ="needcheck" value="0">
<input type=hidden name ="inputcheck" value="0">
<input type=hidden id ="needwfback">
<input type=hidden name="wfcreater" value=<%=userid%>>
<input type=hidden name="isfreewfcreater" value='1'>

 <!-- 自由流程节点信息 -->
  <div class="freeNode" style="display:none;">
		<input type='hidden' name="freeNode" value="0"/>	
		<input type='hidden' name="freeDuty" value="1"/>
  </div>

 <div id="topcontaienr">
    <div  id="contaienr">

      <div  class='freewfformtablefields'></div>

	  <div class="formarea">

         

          <div class="formtable">

               <div class='switch'><img src='/images/ecology8/wf_freehide_wev8.png'></div>

               <table class='addfreewftable'  style='width:100%;'>

                   <col style="width: 12%">
                   <col style="width: 90%">
                   <tr>

                       <td class='tdfirst tditem'><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%></td>
					   <td class='tditem'>

                        
                       <% 
					   
					   if(createrids.length==1)
					   {
					   %>
					   <span class="titleinfo"><%=Util.toScreen(ResourceComInfo.getResourcename(createrids[0]),user.getLanguage())%></span>
                       <input  type='hidden' name='createid' value='<%=createrids[0]%>'>
					   <%
					   }else{   
                        String cidname="";
                       
					   %>
                            <span class="titleinfo"><select name='createid'>
							
							  <%
								 for(String cid:createrids)
								 {
							       cidname=Util.toScreen(ResourceComInfo.getResourcename(cid),user.getLanguage());	  
							   %>

                                   <option  value='<%=cid%>'><%=cidname%></option>

                              <%
							     }	  
							  %>

							</select></span>
                            <script>

                                   jQuery("select[name='createid']").selectbox({onOpen:function(){

									var optionsItems=$(this).next().find(".sbOptions");
									var selectValue=$(this).val();

									optionsItems.find("a").removeClass("selectorfontstyle");

									var item=optionsItems.find("a[href='#"+selectValue+"']");

									item.addClass("selectorfontstyle");


                              }});
 
                            </script>
                            


					   <%
					   }   
					   %>
					   
					   <span class="titleinfo"><input type="radio" value='0' name='requestlevel' checked>&nbsp;<%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%></span><span class="titleinfo"><input value='1' name='requestlevel'  type="radio">&nbsp;<%=SystemEnv.getHtmlLabelName(25397,user.getLanguage())%></span><span class="titleinfo"><input name='requestlevel' value='2'  type="radio">&nbsp;<%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%></span></td>

                   </tr>
                   <tr>

                       <td class='tdfirst tditem'><%=SystemEnv.getHtmlLabelName(15525,user.getLanguage())%></td><td class='tditem'>
					      <input type='hidden' name='indexnum' value='1'>
					      <input type='hidden' name='rownum' value='1'>
						  <input type='hidden' name='nodename_0' value='<%=SystemEnv.getHtmlLabelName(83284,user.getLanguage())%>'> 
						  
					   <span>	

					   <brow:browser  viewType="0" name="operator_0" browserValue="" browserOnClick=""  browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids=" hasInput="true"  width="87%" isSingle="false" hasBrowser = "true" completeUrl="/data.jsp"  browserSpanValue=""  isMustInput="2"     > 

	                   </brow:browser>
					   </span>
					   <script>
                            //  $(".e8_spanFloat").hide();

							  $(".mutiselect").click(function(){
							  
							      $(".e8_spanFloat").find(".Browser").trigger("click");
							  
							  });
							

					   </script>
					   <div class='definewf' title="<%=SystemEnv.getHtmlLabelName(84460,user.getLanguage())%>" style="float:right;margin-right:15px;" onmouseover="$('#wf_freeset_img').attr('src','/images/ecology8/wf_freeset_over_wev8.png')" onmouseout="$('#wf_freeset_img').attr('src','/images/ecology8/wf_freeset_wev8.png')">
					      <span><img id="wf_freeset_img" src='/images/ecology8/wf_freeset_wev8.png' style='margin-top:2px;margin-bottom:2px;margin-left: 8px;margin-right: 8px;'></span>
					   </div>
					</td>
                   </tr>
                   <tr>

                       <td  class='tdfirst tditem'><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></td><td class='tditem' style='padding-top: 1px;'><input name='requestname' style="width: 98%"><span style='margin-left: 3px;'><img src="/images/BacoError_wev8.gif" align="absMiddle"></span></td>

                   </tr>

                    <tr   class='optionitem' style='display:none;height:39px; color:#000'> 
 
                       <td colspan='3' >
					   
					   &nbsp;&nbsp;<input  type='radio' name='contenttype' value='0' checked> 内&nbsp;容 &nbsp;&nbsp; <input value='1' name='contenttype' type='radio' > 表&nbsp;单
					   
					   
					         
							&nbsp;&nbsp; <span class='formmodules' style='height:21px;display: inline-block;margin-top: -7px;margin-left: 3px;'></span>
					         
					   </td>

                   </tr>
 
				   <script>
                                

                                  //切换表单
                                  function   changeForm(data)
								  {
								  
								     //模块id
									var modeid=data.substring(0,data.indexOf("_"));
									jQuery("input[name='formmodeid']").val(modeid);
									
									//表单id
									var formid=data.substr(data.indexOf("_")+1);
									jQuery("input[name='fc_formid']").val(formid);


									var addUrl="/formmode/worklfowinterface/addformForFreeWorkflow.jsp?modeId="+modeid+"&formId="+formid+"&type=1&billid=";
									//表单添加页面
									var iframeadd=jQuery("<iframe  style='margin-top: 0px;' width='100%'  align='center'  id='freeformwin' name='freeformwin'  frameborder='0' scrolling='no' src='"+addUrl+"'></iframe>");
								   
									//清空当前区域
									jQuery(".formtdarea").html("");                  
									jQuery(".formtdarea").append(iframeadd);
									jQuery(".formtrarea").show();
									jQuery("input[name='isfreeworkflowbindform']").val(1);
								  
								  
								  }

                                  function   changeFormForSelect(obj)
								  {
								     var data=jQuery(obj).val();
                                     changeForm(data);
								  
								  }



                                   //ajax请求获取模板数据
								  jQuery.ajax({
								  type: "POST",
								  url: "/formmode/worklfowinterface/ModeInfoHaveCreateRight.jsp",
								  success:function(msg)
								  {
								  
										 var models=eval('('+$.trim(msg)+')');
										 if(models.length===0)
										 {
											   //不存在表单,默认则为正文
                                               jQuery(".optionitem").html("");       

										 }else
										 {    
											  jQuery(".optionitem").show();
											  var selectitem=[];
											  selectitem.push("<select name='formmodedata' onchange='changeFormForSelect(this);'  style='width:120px;display:none;'>");
											  var option="";
											  for(var i=0;i<models.length;i++)
											  {
												  option="<option  value='"+models[i].modeid+"_"+models[i].formid+"'>"+models[i].modename+"</option>"
												  selectitem.push(option);
											  }
											  selectitem.push("</select>");
                                             
											  jQuery(".formmodules").append(jQuery(selectitem.join("")));
                                            
											  jQuery("select[name='formmodedata']").selectbox();

                                              jQuery("input[name='contenttype']").click(function(){
											  
											       var data=~~jQuery(this).val();
												   //表单
												   if(data===1)
												   {
													    jQuery("#contaienr").css("height","800px");
                                                        //隐藏正文
                                                        jQuery(".contentareaonly").hide();

												        jQuery("select[name='formmodedata']").next().show();

														jQuery("select[name='formmodedata']").next().find(".sbHolder").show();

													    data=jQuery("select[name='formmodedata']").val();

                                                        //改变表单
														changeForm(data);
														



												   }else
												   {
													  jQuery("#contaienr").css("height","457px");
													 //显示正文
                                                      jQuery(".contentareaonly").show();

													  jQuery("select[name='formmodedata']").next().hide();
													  jQuery("input[name='isfreeworkflowbindform']").val(0);
													    //隐藏表单区域
													  jQuery(".formtrarea").hide();
													  //清空当前区域
													  jQuery(".formtdarea").html("");  

												   }
											    
											  });
                                              



										 }


								   },fail:function()
								   {
										 alert('<%=SystemEnv.getHtmlLabelName(84461,user.getLanguage())%>');
								   }
								   
								 });


				   </script>

                   
				   <tr class='formtrarea'  style='display:none;'>
				   
				     <td colspan='2'  class='formtdarea'  >
					          
					 </td>

				   </tr>


                   <tr class='contentareaonly'>
                       <td colspan='2' class='tditem' style='position:relative;padding-top: 0px;padding-left:0px;'>
                                <!--上传进度区域(非签章)-->
                          <div class="fieldset flash" id="fsUploadProgressannexuploadSimple"  style='position: absolute;left:10px;width:300px;opacity: 1;'></div>

	                          <textarea id='content' ></textarea>  <span class='contentinput' style='position:absolute;right: 3px;top: 40%;'><img src="/images/BacoError_wev8.gif" align="absMiddle"></span>
							  <input type='hidden' name='remarkinfo' id='remarkinfo'>
							  

     					      <!--附加操作-->
							  <div class='appendtool'>                               
                                    <ol class='appendtools'>


                                        <%  
											//根据用户流程配置设置用户附件操作
											if(haveattachment) { %>
									     <li>
                                         <input  class=InputStyle  type=hidden size=60 id="field-annexupload" name="field-annexupload" >
										 <img src='/images/ecology8/top_icons/2-1_wev8.png'/>
										 <div class='swfup'>
                                            <div class='swfwrapper'>
                                            <span id='attachmentPlaceHolderannexupload' style='cursor: pointer;'></span>
										     </div>
										 </div>
										   <script>
											  var oUploadannexupload;
											  function fileuploadannexupload() {
											  var settings = {
													flash_url : "/js/swfupload/swfupload.swf",
													post_params: {
														"mainId":"<%=annexmainId%>",
														"subId":"<%=annexsubId%>",
														"secId":"<%=annexsecId%>",
														"userid":"<%=user.getUID()%>",
														"logintype":"<%=user.getLogintype()%>"
													},        
													upload_url: "/docs/docupload/MultiDocUploadByWorkflow.jsp",
													file_size_limit :"5MB",
													file_types : "*.*",
													file_types_description : "All Files",
													file_upload_limit : "50",
													file_queue_limit : "0",
													custom_settings : {
																progressTarget : "fsUploadProgressannexuploadSimple",
																uploadfiedid:"field-annexupload"
																		},
													debug: false,
													
													//button_image_url : "/cowork/images/add_wev8.png",	// Relative to the SWF file
													button_placeholder_id : "attachmentPlaceHolderannexupload",
											
													button_width: 55,
													button_height: 18,
													button_text : '<span class="button"><%=SystemEnv.getHtmlLabelName(22194,user.getLanguage())%></span>',
													button_text_style : '.button { font-family: "微软雅黑",Helvetica, Arial, sans-serif; font-size: 12pt;color:#929393 } .buttonSmall { font-size: 10pt; }',
													button_text_top_padding: 0,
													button_text_left_padding: 0,
														
													button_window_mode: SWFUpload.WINDOW_MODE.TRANSPARENT,
													button_cursor: SWFUpload.CURSOR.HAND,
													
													file_queued_handler : fileQueued,
													file_queue_error_handler : fileQueueError,				
													file_dialog_complete_handler : function(numFilesSelected, numFilesQueued){		
														  if (numFilesSelected > 0) {		
																	
																	   jQuery("#fsUploadProgressannexuploadSimple").show();
																	   this.startUpload();				
																}

													},
													upload_start_handler : uploadStart,
													upload_progress_handler : uploadProgress,			
													upload_error_handler : uploadError,
													queue_complete_handler : queueComplete,
											
													upload_success_handler : function (file, server_data) {	
														  //文件名称
														  var filename=file.name;
														  //文件名称
														  var htmlstr="&nbsp;<a contentEditable=false style='cursor:pointer;text-decoration:none !important;margin-right:8px;color:#000000'  onclick='try{parent.opendoc1("+jQuery.trim(server_data)+",this);return false;}catch(e){}' ><img src='/images/ecology8/top_icons/4-1_wev8.png'/>"+filename+"</a>&nbsp;&nbsp;<a contentEditable=false href='javascript:void(0)' unselectable='off' contenteditable='false' linkid='1535541' onclick='try{parent.downloads("+jQuery.trim(server_data)+",this);return false;}catch(e){}' style='cursor:pointer;text-decoration:none !important;margin-right:8px;color:#000000'>下载("+file.size/1024+"K)</a><br />"
														  
														  KE.insertHtml('content',htmlstr);

														  var  itemval=jQuery("#field-annexupload").val();
														  if(itemval)
														  {
														  itemval=itemval+","+jQuery.trim(server_data);
														  }
														  else
														  itemval=jQuery.trim(server_data);

														  jQuery("#field-annexupload").val(itemval);

													},				
													upload_complete_handler : function(file){
													   if(this.getStats().files_queued==0){
																//清空上传进度条 
														jQuery("#fsUploadProgressannexuploadSimple").html("");
													   }  
													}
												};


											try {
												oUploadannexupload=new SWFUpload(settings);
											} catch(e) {
												alert(e)
											}
											}
											
										   fileuploadannexupload();
										  </script>
										 </li>
                                         <% }%>
 

 
										 <li>
										 <!--相关流程-->
										 <input type="hidden" id="signworkflowids" name="signworkflowids" >
										 <img src='/images/ecology8/top_icons/3-1_wev8.png'/><a class='appenditem' onclick="onShowSignBrowserForFreeWf('/workflow/request/MultiRequestBrowser.jsp','/workflow/request/ViewRequest.jsp?isrequest=1&requestid=','signworkflowids','signworkflowspan',152)"><%=SystemEnv.getHtmlLabelName(22105,user.getLanguage())%></a></li>
										 
										 <li>
										 <!--相关文档-->
                                         <input type="hidden" id="signdocids" name="signdocids">
										 <img src='/images/ecology8/top_icons/1-1_wev8.png'/><a class='appenditem' onclick="onShowSignBrowserForFreeWf('/docs/docs/MutiDocBrowser.jsp','/docs/docs/DocDsp.jsp?isrequest=1&id=','signdocids','signdocspan',37)"><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%></a></li> 
									</ol>
							  
							  </div>
						  </td>
                   </tr>
               </table>
               <script>

                      $("input[name='requestname']").blur(function(){
					     var val=$(this).val();
						 if(val==='')
						 {
                           $(this).next().show();

						 }else{

						   $(this).next().hide();
						 }

					  
					  });

                     
					   var  items=[
						'source','justifyleft', 'justifycenter', 'justifyright', 'insertorderedlist', 'insertunorderedlist',
						'title', 'fontname', 'fontsize',  'textcolor', 'bold','italic',  'strikethrough', 'image', 'advtable'
					    ];

						KE.init({
							id : 'content',
							height :263+'px',
							width:'100%',
							resizeMode:1,
							imageUploadJson : '/kindeditor/jsp/upload_json.jsp',
							allowFileManager : false,
							newlineTag:'br',
							items : items,
							afterCreate : function(id) {
								KE.util.focus(id);
								KE.event.add(KE.g['content'].iframeWin, 'blur', function(e) {

                                    var data=KE.util.getData('content');
       
	                                if(data==='')
									{
									  jQuery(".contentinput").show();
									}else{
									  jQuery(".contentinput").hide();
									}
	                                

                                });
							}
						});

                       KE.create('content');


			   </script>
          </div>

      </div>

      <div class="connectlist">
      
	    <div  class='connectusers'>
           <ol class='nav' >
              <li class='itemselected  commonusers'>常用联系人</li>
		   </ol>
           <div  class='commonusersitem' >

		        <ol >
                   <%
				   int count=0;
				   for(Integer uid:commonusers)
				      {
                        count++;
						if(count==1)
						  {
				         %>
				             <li class='userselected'><%=Util.toScreen(ResourceComInfo.getResourcename(""+uid),user.getLanguage())%><input type='hidden' name='uid' value='<%=uid%>'><input  type='hidden'  name='uname' value='<%=Util.toScreen(ResourceComInfo.getResourcename(""+uid),user.getLanguage())%>'></li>
                     	 <%
						  }
					     else
						  {
                          %>
				            <li><%=Util.toScreen(ResourceComInfo.getResourcename(""+uid),user.getLanguage())%><input type='hidden' name='uid' value='<%=uid%>'><input  type='hidden'  name='uname' value='<%=Util.toScreen(ResourceComInfo.getResourcename(""+uid),user.getLanguage())%>'></li>
                         <%
				          }	
				    }
					%>
				</ol>
		   
		   </div>
		   <div  class='selfdefineitem' style='display:none'>

		        所有自定义    
		   
		   </div>
		</div>

         <script>

			  $("#operator_0").bind("propertychange", function() { 
				    alert($(this).val()); 
				});


              $(".connectlist .nav  li").click(function(){

                   var oppsite;
				   var lis= $(".connectlist .nav  li");
                  if($(this).hasClass("commonusers"))
				  {
					oppsite=$(".connectlist .nav  li.selfdefine");					
				    oppsite.css("border-left",'1px solid #cccccc');
                    $(this).css("border-right","none");
					$(".commonusersitem").show();
                    $(".selfdefineitem").hide();

				  }else  if($(this).hasClass("itemunselected"))
				  {
					 oppsite=$(".connectlist .nav  li.commonusers");
				     oppsite.css("border-right",'1px solid #cccccc');
                     $(this).css("border-left","none"); 
					 $(".commonusersitem").hide();
                     $(".selfdefineitem").show();
		
				  }

                    lis.removeClass("itemselected");
					lis.removeClass("itemunselected");
                    $(this).addClass("itemselected");
                    oppsite.addClass("itemunselected");
   
                    
			  
			  });

	     jQuery(".commonusersitem li").mouseover(function(){
		  
		      jQuery(".commonusersitem li").removeClass("userselected");     
		      jQuery(this).addClass("userselected");
		 
		 });


         jQuery(".commonusersitem li").click(function(){
		  
           
		       var  uids=","+jQuery("#operator_0").val()+",";
			   var  uid=jQuery(this).find("input[name='uid']").val();
			   
               if(uids.indexOf(","+uid+",")<0)
			   {
              
			   var  uname=jQuery(this).find("input[name='uname']").val(); 
			   var data={id:uid,name:"<a href='#"+uid+"'>"+uname+"</a>"};
               _writeBackData('operator_0',1,data,{isSingle:false,hasInput:true}); 
               }
 


		 
		 });


		   //iframe自适应高度
		 	function SetWinHeight(obj) 
				{ 
					var win=obj; 
					if (document.getElementById) 
					{ 
						if (win && !window.opera) 
						{ 
							if (win.contentDocument && win.contentDocument.body.offsetHeight) 
							win.height = win.contentDocument.body.offsetHeight; 
							else if(win.Document && win.Document.body.scrollHeight) 
							win.height = win.Document.body.scrollHeight; 
						} 
					} 

		       } 
		  
		 </script>

		  

      </div>



	  <div class='tablearea' >
         
           
            

	      </div>
      </div>
 </div>



         <%

        
				String isannexupload_add=(String)session.getAttribute(userid+"_"+workflowid+"isannexupload");
				
 
				boolean isSuccess  = RecordSet.executeProc("sysPhrase_selectByHrmId",""+userid);
				String workflowPhrases[] = new String[RecordSet.getCounts()];
				String workflowPhrasesContent[] = new String[RecordSet.getCounts()];
				int m = 0 ;
				if (isSuccess) {
					while (RecordSet.next()){
						workflowPhrases[m] = Util.null2String(RecordSet.getString("phraseShort"));
						workflowPhrasesContent[m] = Util.toHtml(Util.null2String(RecordSet.getString("phrasedesc")));
						m ++ ;
					}
				}
				//end by cyril on 2008-09-30 for td:9014
				
				String isSignMustInput="0";
				String isHideInput="0";
				String isFormSignature=null;
				int formSignatureWidth=RevisionConstants.Form_Signature_Width_Default;
				int formSignatureHeight=RevisionConstants.Form_Signature_Height_Default;
				RecordSet.executeSql("select isFormSignature,formSignatureWidth,formSignatureHeight,issignmustinput,ishideinput from workflow_flownode where workflowId="+workflowid+" and nodeId="+nodeid);
				if(RecordSet.next()){
				isFormSignature = Util.null2String(RecordSet.getString("isFormSignature"));
				formSignatureWidth= Util.getIntValue(RecordSet.getString("formSignatureWidth"),RevisionConstants.Form_Signature_Width_Default);
				formSignatureHeight= Util.getIntValue(RecordSet.getString("formSignatureHeight"),RevisionConstants.Form_Signature_Height_Default);
				isSignMustInput = ""+Util.getIntValue(RecordSet.getString("issignmustinput"), 0);
				isHideInput = ""+Util.getIntValue(RecordSet.getString("ishideinput"), 0);
				}
				int isUseWebRevision_t = Util.getIntValue(new weaver.general.BaseBean().getPropValue("weaver_iWebRevision","isUseWebRevision"), 0);
				if(isUseWebRevision_t != 1){
				isFormSignature = "";
				}

	String workflowRequestLogId = "";
	String isSignDoc_edit=isSignDoc_add;
	String signdocids = "";
	String signdocname = "";
	String isSignWorkflow_edit = isSignWorkflow_add; 
	String signworkflowids = "";
	String signworkflowname = "";
	
	String isannexupload_edit = isannexupload_add;
	String annexdocids = "";
	String requestid = "-1";
	
	int annexmaxUploadImageSize = 0;
	String myremark = "";
	 
	%>
	<div style="padding:0 10px;">
     <%@ include file="/workflow/request/WorkflowSignInput.jsp" %>
     </div>
<br>

</form> 

<script>

 
    //关闭窗口
    function clostWin()
	{
	   
       //关闭对话框
	   parent.top.windowdialog.close(); 
	
	
	}

	function checkFormIsCurrect()
	{

       var data=KE.util.getData('content');
       
	   $("#remarkinfo").val(data);

       var operators=$("#operator_0").val();

	   if(operators==='')
		{
		   alert("<%=SystemEnv.getHtmlLabelName(84463,user.getLanguage())%>!!!");
		   return false;
        }

		var requestname=$("input[name='requestname']").val();
           
		 if(requestname==='')
		{
		   alert("<%=SystemEnv.getHtmlLabelName(84462,user.getLanguage())%>");
		   return false;
        }




	   return true;
	}

	//TD4262 增加提示信息  开始
//提示窗口
function showPrompt(content)
{

     var showTableDiv  = $GetEle('contaienr');
     var message_table_Div = document.createElement("div")
     message_table_Div.id="message_table_Div";
     message_table_Div.className="xTable_message";
     showTableDiv.appendChild(message_table_Div);
     var message_table_Div  = $GetEle("message_table_Div");
     message_table_Div.style.display="inline";
     message_table_Div.innerHTML=content;
     var pTop= document.body.offsetHeight/2+document.body.scrollTop-50;
     var pLeft= document.body.offsetWidth/2-50;
     message_table_Div.style.position="absolute"
     message_table_Div.style.top=pTop;
     message_table_Div.style.left=pLeft;

     message_table_Div.style.zIndex=1002;
     var oIframe = document.createElement('iframe');
     oIframe.id = 'HelpFrame';
     showTableDiv.appendChild(oIframe);
     oIframe.frameborder = 0;
     oIframe.style.position = 'absolute';
     oIframe.style.top = pTop;
     oIframe.style.left = pLeft;
     oIframe.style.zIndex = message_table_Div.style.zIndex - 1;
     oIframe.style.width = parseInt(message_table_Div.offsetWidth);
     oIframe.style.height = parseInt(message_table_Div.offsetHeight);
     oIframe.style.display = 'block';
}


//检测表单是否填写完整
function  checkFormIsReady()
{

  // var childwin=document.getElementById("#freeformmwin").contentWindow;

   var isready=true;
   var frame=jQuery(".formtdarea").find("#freeformwin");
   if(frame.length>0)
	{
     var doc=frame[0];
     isready=doc.contentWindow.doSubmit("",1);
	}

   return isready;

}



//保存操作
function doSave(){              <!-- 点击保存按钮 -->
		

         var flag=checkFormIsReady();
		 if(!flag)
	     {
			return;		 
		 }else
	    {
		   var container=jQuery(".formtdarea").find("#freeformwin");
		   var hiddencontainer=jQuery(".freewfformtablefields");
		   if(container.length>0)
			{
			   var doc=container.contents();
		       var maintable=doc.find(".maintable").clone();
			   var detailtable=doc.find(".detailtable").clone();
               var hiddenarea=doc.find(".formtablehiddenarea").clone();

		       hiddencontainer.append(maintable);
			   hiddencontainer.append(detailtable);
			   hiddencontainer.append(hiddenarea);
			}
		     
		}


		addFreeNode();

        var ischeckok="";

        try{
        if(check_form(document.frmmain,$GetEle("needcheck").value+$GetEle("inputcheck").value))
          ischeckok="true";
        }catch(e){
          ischeckok="false";
        }
        if(ischeckok=="false"){
            if(check_form(document.frmmain,'requestname'))
                ischeckok="true";
        }

        if(ischeckok=="true"){
            if(checkFormIsCurrect()) {
					
					jQuery(".freeNode").find("input[name='freeNode']").val(1);

                    document.frmmain.src.value='save';
                    jQuery($GetEle("flowbody")).attr("onbeforeunload", "");//added by xwj for td3247 20051201

                         //保存签章数据
                        //TD4262 增加提示信息  开始
						var content="<%=SystemEnv.getHtmlLabelName(18979,user.getLanguage())%>";
						showPrompt(content);
						//TD4262 增加提示信息  结束
						//附件上传
					  if(jQuery(".formtdarea").find("#freeformwin").length===0)
				       {
                        //附件上传
						StartUploadAll();
						checkuploadcomplet();
					   }else
				       {
						      document.frmmain.submit();
                              enableAllmenu();
							frmmain.target = nowtarget;
							frmmain.action = nowaction;
					   
					   }


                }
            }
    }




function doSubmit(obj){            <!-- 点击提交 -->

        
         var flag=checkFormIsReady();
		 if(!flag)
	     {
			return;		 
		 }else
	    {
		   var container=jQuery(".formtdarea").find("#freeformwin");
		   var hiddencontainer=jQuery(".freewfformtablefields");
		   if(container.length>0)
			{
			   var doc=container.contents();
		       var maintable=doc.find(".maintable").clone();
			   var detailtable=doc.find(".detailtable").clone();
               var hiddenarea=doc.find(".formtablehiddenarea").clone();

		       hiddencontainer.append(maintable);
			   hiddencontainer.append(detailtable);
			   hiddencontainer.append(hiddenarea);
			}
		     
		}
 
       

		addFreeNode();

      //modify by xhheng @20050328 for TD 1703
      //明细部必填check，通过try $GetEle("needcheck")来检查,避免对原有无明细单据的修改

        var ischeckok="";
        try{
            
        if(check_form(document.frmmain,$GetEle("needcheck").value+$GetEle("inputcheck").value))
          ischeckok="true";
        }catch(e){
          ischeckok="false";
        }
        if(ischeckok=="false"){
          if(check_form(document.frmmain,'requestname,field4,field13,field247,field274,field275,field276,field292,field5,field114,field35,field36,field47,field44,field45,field37,field38,field40,field55,field301'))
            ischeckok="true";
        }

        if(ischeckok=="true"){
			CkeditorExt.updateContent();
            if(checkFormIsCurrect()) {
				
				jQuery(".freeNode").find("input[name='freeNode']").val(1);
								
                document.frmmain.src.value='submit';
                jQuery($GetEle("flowbody")).attr("onbeforeunload", "");//added by xwj for td3247 20051201

    	if("83"==201&&"0"==1){//资产报废单据明细中的资产报废数量大于库存数量，不能提交。
            try{
	    	nodesnum = $GetEle("nodesnum").value;
	    	for(var tempindex1=0;tempindex1<nodesnum;tempindex1++){
	    		var capitalcount = $GetEle("node_"+tempindex1+"_capitalcount").value*1;
	    		var fetchingnumber=$GetEle("node_"+tempindex1+"_number").value*1;
	    		for(var tempindex2=0;tempindex2<nodesnum;tempindex2++){
	    			if(tempindex2!=tempindex1&&$GetEle("node_"+tempindex1+"_capitalid").value==$GetEle("node_"+tempindex2+"_capitalid").value){
	    				fetchingnumber = fetchingnumber*1 + $GetEle("node_"+tempindex2+"_number").value*1;
	    			}
	    		}
	    		if(fetchingnumber>capitalcount){
	    			alert("<%=SystemEnv.getHtmlLabelName(84464,user.getLanguage())%>");
	    			return;
	    		}
	    	}
            }catch(e){}
    	}

//保存签章数据

						//TD4262 增加提示信息  开始
						var content="<%=SystemEnv.getHtmlLabelName(18978,user.getLanguage())%>";
						showPrompt(content);
						//TD4262 增加提示信息  结束
						obj.disabled=true;
                       
					   if(jQuery(".formtdarea").find("#freeformwin").length===0)
				       {
                        //附件上传
						StartUploadAll();
						checkuploadcomplet();
					   }else
				       {
						    document.frmmain.submit();
                            enableAllmenu();
							frmmain.target = nowtarget;
							frmmain.action = nowaction;
					   
					   }

            }
        }

		//关闭对话框
	//	parent.top.windowdialog.close(); 
    }

        
    function onShowSignBrowserForFreeWf(url, linkurl, inputname, spanname, type1) {

				//var tmpids = $GetEle(inputname).value;
				var tmpids="";
				if (type1 === 37) {
					id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=" + url
							+ "?documentids=" + tmpids);
				} else {
					id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=" + url
							+ "?resourceids=" + tmpids);
				}
				if (id1) {
					if (wuiUtil.getJsonValueByIndex(id1, 0) != "" && wuiUtil.getJsonValueByIndex(id1, 0) != "0") {
						var resourceids = wuiUtil.getJsonValueByIndex(id1, 0);
						var resourcename = wuiUtil.getJsonValueByIndex(id1, 1);
						
						var sHtml = "";
						resourceids = resourceids.substr(1);
						resourcename = resourcename.substr(1);

                    	
						var resourceidArray = resourceids.split(",");
						
						var resourcenameArray = resourcename.split(",");
						
						var inputResourceidArray = resourceids.split(",");
						
                        var tempval="";
						 var items=[];

                         var editorel=jQuery(".ke-iframe").contents();

                        //确认并生成该签字意见所关联的文档或流程 
                        if (type1 === 37)
						{
					        items=editorel.find(".relatedoc"); 
                       
					    }else
						{
                            items=editorel.find(".relatewf"); 

						}

						 for(var i=0,length=items.length;i<length;i++)
						  {
						     tempval=jQuery(items[i]).attr("relateid");
						     if((","+resourceids).indexOf(","+tempval)<0)
							  {
							    inputResourceidArray.push(tempval);
							  }
						  }


                       	$GetEle(inputname).value = inputResourceidArray.join(",");

						for (var _i=0; _i<resourceidArray.length; _i++) {
							var curid = resourceidArray[_i];
							var curname = resourcenameArray[_i];
							
							if (type1 === 37) 
							sHtml = sHtml+"&nbsp<a contentEditable=false onclick='try{parent.openfreewin(this);return false;}catch(e){}' class='relatedoc' relateid="+curid+" unselectable='off'  style='cursor:pointer;text-decoration:none !important;margin-right:8px;color:#000000' href=" + linkurl + curid
									+ " target='_blank'><img src='/images/ecology8/top_icons/1-1_wev8.png'/>" + curname + "</a>&nbsp";
                             else
                             sHtml = sHtml+"&nbsp<a contentEditable=false onclick='try{parent.openfreewin(this);return false;}catch(e){}' class='relatewf' relateid="+curid+" unselectable='off'  style='cursor:pointer;text-decoration:none !important;margin-right:8px;color:#000000' href=" + linkurl + curid
									+ " target='_blank'><img src='/images/ecology8/top_icons/3-1_wev8.png'/>" + curname + "</a>&nbsp";

						}

					     KE.insertHtml('content',sHtml);

					} else {
						//$GetEle(spanname).innerHTML = "";
						//$GetEle(inputname).value = "";
					}
				}
			}

	 //更新#freeNode中的数据
	 function addFreeNode(){
		 var ids=jQuery("#operator_0").val();
		
		 if(ids.indexOf(",")==0){
			ids=ids.substr(1);
		 }
		 
		 var names="";
		 
		 if(ids.length>0){

			jQuery("#operator_0").parent().find("a").each(function (){
				names=names+","+jQuery(this).text();
			})
			if(names.indexOf(",")==0){
				names=names.substr(1);
			}
		 }
		if(jQuery(".freeNode").find("input[name='indexnum']").length>0){
			//存在自由节点
			//获取下一个自由节点
			var id=jQuery(".freeNode").find("#indexnum").val();
			var floworder=id;
			var minfloworder;
			var index=0;
			for(var i=0;i<id;i++){
				if(jQuery(".freeNode").find("input[name='floworder_"+i+"']").length>0){
					minfloworder=jQuery(".freeNode").find("input[name='floworder_"+i+"']").val();
					if(floworder>minfloworder){
						floworder=minfloworder;
						index=i;
					}
				}
			}
			jQuery(".freeNode").find("input[name='operatornames_"+index+"']").val(names);
			jQuery(".freeNode").find("input[name='operators_"+index+"']").val(ids);

		}else{

			 if(ids.length==0){
				return;
			 }

			//不存在自由节点
			jQuery(".freeNode").append("<input type='hidden' name='floworder_0' value='1'/>");//顺序
			jQuery(".freeNode").append("<input type='hidden' name='nodename_0' value='<%=SystemEnv.getHtmlLabelName(15070, user.getLanguage())%>'/>");//名称
			jQuery(".freeNode").append("<input type='hidden' name='nodetype_0' value='1'/>");//名称
			jQuery(".freeNode").append("<input type='hidden' name='Signtype_0' value='1'/>");//会签类型
			jQuery(".freeNode").append("<input type='hidden' name='operators_0' value='"+ids+"'/>");//操作者id
			jQuery(".freeNode").append("<input type='hidden' name='operatornames_0' value='"+names+"'/>");//操作者name
			
			/**其他设置信息，填写的均是测试值**/
			jQuery(".freeNode").append("<input type='hidden' name='road_0' value='1' />");//路径编辑
			jQuery(".freeNode").append("<input type='hidden' name='frms_0' value='0'/>");//表单编辑
			jQuery(".freeNode").append("<input type='hidden' name='trust_0' value='0'/>");//节点签章
	//		jQuery(".freeNode").append("<input type='hidden' name='sync_0' value='0'/>");//同步所有节点
			jQuery(".freeNode").append("<input type='hidden' name='nodeDo_0' value='1'/>");//节点操作
				
			jQuery(".freeNode").append("<input type='hidden' id='rownum' name='rownum' value='1'/>");
			jQuery(".freeNode").append("<input type='hidden' id='indexnum' name='indexnum' value='1'/>");
			jQuery(".freeNode").append("<input type='hidden' id='checkfield' name='checkfield' value='nodename_0,operators_0'/>");
		}
	 }

    //定义流程
	$(".definewf").click(function(){

		addFreeNode();

    	openDialog("<%=SystemEnv.getHtmlLabelName(83284,user.getLanguage())%>","/workflow/request/FreeNodeShow.jsp?workflowid=<%=workflowid%>");

		//打开转发对话框
		function openDialog(title,url) {
		　　var dlg=new window.top.Dialog();//定义Dialog对象
			// dialog.currentWindow = window;
		　　dlg.Model=false;
		　　dlg.Width=1000;//定义长度
		　　dlg.Height=550;
		　　dlg.URL=url;
		　　dlg.Title=title;
			dlg.maxiumnable=false;
		　　dlg.show();
			// 保留对话框对象
			window.top.freewindow=window;
			window.top.freedialog=dlg;
	　	}

    });

   //开启隐藏常用联系人
    jQuery(".switch").click(function(){
       
	    var connectlist=jQuery(".connectlist");
		if(connectlist.is(":visible"))
		{
			connectlist.hide();
		    //jQuery(".formtable").css("margin-right","0px");
			jQuery(".formtable").animate({"margin-right": '-=210'});
            jQuery(this).find("img").attr("src","/images/ecology8/wf_freeshow_wev8.png");

		}else
		{
            //jQuery(".formtable").css("margin-right","250px");
			jQuery(".formtable").animate({"margin-right": '+=210'});
            connectlist.show().animate({duration: 10000});
			jQuery(this).find("img").attr("src","/images/ecology8/wf_freehide_wev8.png");
		
		}
	
	
	});

   	//打开附件
	function opendoc1(showid,obj){
	   openFullWindowHaveBar("/docs/docs/DocDsp.jsp?id="+showid+"&isOpenFirstAss=0");
	}

	//下载附件
	function downloads(files,obj){
	   //jQuery("#downloadFrame").attr("src","/weaver/weaver.file.FileDownload?fileid="+files+"&download=1");
	   openFullWindowHaveBar("/weaver/weaver.file.FileDownload?fileid="+files+"&download=1")
	}

    function openfreewin(arg)
	{
	  var a=jQuery(arg);
	  var href=a.attr("href");
      openFullWindowHaveBar(href);
	
	}


</script>