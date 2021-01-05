
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.*" %>
<%@ page import="java.util.*,java.sql.Timestamp" %>
<%@ page import="java.io.*" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ include file="/datacenter/maintenance/inputreport/InputReportHrmInclude.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<!DOCTYPE html>
<%
	if (!HrmUserVarify.checkUserRight("WorkflowManage:PsSet", user)) {
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}
%>
<%@ include file="/workflow/request/CommonUtils.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{"+ $label(86,user.getLanguage()) +",javascript:pager.doSave(),_top} " ;
	RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<%
	//读取流程计划扫描频率设置
	RecordSet.executeProc("SystemSet_Select","");
	RecordSet.next();
	String scan = Util.null2String(RecordSet.getString("scan"));
	String mobilechangemode= Util.null2String(RecordSet.getString("mobilechangemode"));
	String mobilemode= Util.null2String(RecordSet.getString("mobilemode"));
	String mobileapplyworkflow= Util.null2String(RecordSet.getString("mobileapplyworkflow"));
	String mobileapplyworkflowids= Util.null2String(RecordSet.getString("mobileapplyworkflowids"));
	
	String propertyPath = GCONST.getRootPath() + "WEB-INF" + File.separator + "prop" + File.separator;
	String weaverPath = propertyPath + "weaver.properties";

	Properties weaverConfig = new Properties();
	weaverConfig.load( new FileInputStream(weaverPath) );

	//启用流程超时功能
	String overtime = weaverConfig.getProperty("ecology.overtime");
	String overtimeChecked = (overtime == null || overtime.trim().equals("")) ? "" : "checked";

	//启用流程反馈功能
	String changestatus = weaverConfig.getProperty("ecology.changestatus");
	String changestatusChecked = (changestatus == null || !changestatus.trim().equals("1")) ? "" : "checked";

	String overtimePath = propertyPath + "workflowovertime.properties";
	Properties overtimeConfig = new Properties();
	overtimeConfig.load( new FileInputStream(overtimePath) );

	//超时时跳过非工作日
	String skipNotWorkDate = overtimeConfig.getProperty("WORKFLOWOVERTIMETEMP");
	String skipNotWorkDateChecked = (skipNotWorkDate == null || !skipNotWorkDate.trim().equals("1")) ? "" : "checked";
    
	//个性化签章设置
	String signaturePath = propertyPath + "WFSignatureImg.properties";
	File f = new File(signaturePath);
	if(!f.exists()){
		f.createNewFile();
	}
	
	Properties signatureConfig = new Properties();
	signatureConfig.load( new FileInputStream(f) );
	//流程流转意见中操作人是否显示签章图片 1：为显示
	String showimg = signatureConfig.getProperty("showimg");
	//以下参数只适用与图形化
	//签章图片高度，单位（像素）
	String imgheight = signatureConfig.getProperty("imgheight");
	//图片显示方式 1：原始尺寸 2：自动缩放
	String imgshowtpe = signatureConfig.getProperty("imgshowtpe");
%>
<html>
	<head>
		<link href="/css/Weaver_wev8.css" type="text/css" rel="stylesheet">
		<script language="javascript" src="/js/weaver_wev8.js"></script>
		<script language="javascript" src="/proj/js/common_wev8.js"></script>

		<script>
			jQuery(document).ready(function(){
				pager.init();
			});
			
			var pager = {
				defaultOvertimeValue : '',
				init : function(){
					
					if( !$('#overtimeEnable').attr('checked') ){
						$('#overtime').attr("disabled","disabled");
						$('#overtime').val('');

						$('#overtime').parent().parent().hide();
						$('#overtime').parent().parent().next().hide();
						$('#skipNotWorkDate').parent().parent().hide();	
						$('#skipNotWorkDate').parent().parent().next().hide();
					}else{
						this.defaultOvertimeValue = $('#overtime').val();
					}

					pager.bind();
				},
				
				bind : function(){
					var me = this;

					$('#overtimeEnable').bind('click', function(){
						if( $('#overtimeEnable').attr('checked') ){
							$('#overtime').removeAttr("disabled");
							$('#overtime').val(me.defaultOvertimeValue);

							$('#overtime').parent().parent().show();
							$('#overtime').parent().parent().next().show();
							$('#skipNotWorkDate').parent().parent().show();	
							$('#skipNotWorkDate').parent().parent().next().show();
						}else{
							$('#overtime').attr("disabled","disabled");
							$('#overtime').val("");

							$('#overtime').parent().parent().hide();
							$('#overtime').parent().parent().next().hide();
							$('#skipNotWorkDate').parent().parent().hide();	
							$('#skipNotWorkDate').parent().parent().next().hide();
						}
					});
				},
				
				doSave : function(){
					if( $('#overtimeEnable').attr('checked') && !$('#overtime').val()){
						return alert('<%=$label(23073,user.getLanguage()) + $label(22942,user.getLanguage())%>!');
					}

					$('#weaver').submit();
				}
			};
			
			function ShowORHidden(obj,trnames,tabobj){
				var tr_names=trnames.split(',');
				for(var i=0;i<tr_names.length;i++){
				    if(obj.checked){
				    	showEle(tr_names[i]);
				    }else{
				    	hideEle(tr_names[i]);
				    }
			    }
			    if(tabobj!=''){
			   		tabobj.checked=obj.checked;
			   	}
          }
          
          function changeApplyWfid(obj){
				if($(obj).val()==0){
				    $("#mobileapplyworkflowidsSpan").css("display","none");
				}else{
				   $("#mobileapplyworkflowidsSpan").removeAttr("style");
				}
         }
         
         function  doActionBefore(){
            if($("#mobileapplyworkflow").val()=='1'||$("#mobileapplyworkflow").val()=='2'){
               var  mobileapplyworkflowids= $("#mobileapplyworkflowids").val(); 
               if(mobileapplyworkflowids==''){
                  alert('<%=$label(127158,user.getLanguage())  %>');
				   return false;
               }
            }
            return true;
         }
			
		</script>
	</head>
	<body>
		<jsp:include page="/systeminfo/commonTabHead.jsp">
		   <jsp:param name="mouldID" value="workflow"/>
		   <jsp:param name="navName" value="<%=$label(33569,user.getLanguage()) + $label(31811,user.getLanguage())%>"/>
		</jsp:include>

		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td></td>
				<td class="rightSearchSpan" style="text-align:right; width:500px!important">				
					<input id="btnSave" type="button" value="<%=$label(86,user.getLanguage()) %>" class="e8_btn_top" onclick="pager.doSave()" />
					<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage()) %>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>

		<form id="weaver" name="frmmain" action="WorkflowSettingsOperation.jsp" method="post"  onsubmit="return doActionBefore();">
			<wea:layout type="twoCol" attributes="{'expandAllGroup':'true'}">
				<wea:group context='<%=$label(18812,user.getLanguage()) + $label(21758,user.getLanguage()) + $label(68,user.getLanguage()) %>' attributes="{'class':'e8_title e8_title_1'}">
					<wea:item>
						<%=$label(21758,user.getLanguage())%>(<%=$label(15049,user.getLanguage())%>)
					</wea:item>
					<wea:item>
						<input type="text" name="scan" value="<%=scan%>" onkeyup="clearNoNum(this)" style="width:100px;"/>
						(<%=$label(21760,user.getLanguage())%>)
					</wea:item>
				</wea:group>
				
				<wea:group context='<%=$label(33569,user.getLanguage()) + $label(19081,user.getLanguage()) + $label(68,user.getLanguage())%>' attributes="{'class':'e8_title e8_title_1'}">
					<wea:item>
						<%=$label(31676,user.getLanguage()) + $label(33569,user.getLanguage()) 
						+ $label(19081,user.getLanguage()) + $label(33381,user.getLanguage())%>
					</wea:item>
					<wea:item>
						<input type="checkbox" id="overtimeEnable" name="overtimeEnable" <%=overtimeChecked%> tzCheckbox="true"/>
						(<%=$label(21760,user.getLanguage())%>)
					</wea:item>
					<wea:item>
						<%=$label(126733,user.getLanguage())%>(<%=$label(15049,user.getLanguage())%>)
					</wea:item>
					<wea:item>
						<input type="text" id="overtime" name="overtime" value="<%=overtime%>" onkeyup="clearNoNum(this)" style="width:100px;"/>
						<span id="remind" style="cursor:hand" title="<%=$label(33738,user.getLanguage())%>">
				        	<img src="/images/remind_wev8.png" align="absMiddle">
				        </span>
					</wea:item>
					<wea:item>
						<%=$label(33737,user.getLanguage())%>
					</wea:item>
					<wea:item>
						<input type="checkbox" id='skipNotWorkDate' name="skipNotWorkDate" <%=skipNotWorkDateChecked%> tzCheckbox="true">
						<span id="remind" style="cursor:hand;padding-left:65px;" title="<%=$label(33739,user.getLanguage())%>">
				        	<img src="/images/remind_wev8.png" align="absMiddle">
				        </span>
					</wea:item>
				</wea:group>
				<wea:group context='<%=$label(33569,user.getLanguage()) + $label(21950,user.getLanguage()) + $label(68,user.getLanguage())%>' attributes="{'class':'e8_title e8_title_1'}">
					<wea:item>
						<%=$label(31676,user.getLanguage()) + $label(33569,user.getLanguage())
						 + $label(21950,user.getLanguage()) + $label(33381,user.getLanguage())%>
					</wea:item>
					<wea:item>
						<input type="checkbox" id='changestatus' name="changestatus" <%=changestatusChecked%> tzCheckbox="true">
						(<%=$label(21760,user.getLanguage())%>)
					</wea:item>
				</wea:group>
				<wea:group context='<%=$label(81760,user.getLanguage())%>' attributes="{'class':'e8_title e8_title_1'}">
					<wea:item>
                        <%=$label(131275,user.getLanguage())%>
					</wea:item>				
					<wea:item>
					    <script>
					       $(function(){
					       	checkImgStatus()
					       });
					       function checkImgStatus(){
					          if($("#showimg").is(":checked")){
					          	showEle("noImg");
					          	$("#signbtn").show();
					          }else{
					            hideEle("noImg");
					            $("#signbtn").hide();
					          }
					       }
					    </script>
						<input type="checkbox" id='showimg' onclick="checkImgStatus()" name="showimg" <%if(null != showimg&&showimg.equals("1")){%>checked<%}%> value="1" tzCheckbox="true">
						<%=$label(81765,user.getLanguage())%>
						<%
						if(HrmUserVarify.checkUserRight("SignatureList:List", user)||HrmUserVarify.checkUserRight("SignatureList:Add", user)||HrmUserVarify.checkUserRight("SignatureList:Delete", user)){						
						%>
						&nbsp;&nbsp;
                        <input  type="button" id="signbtn" onclick="showSignatureSetting()" style="color:#42ACE8;background:#fff;border:1px solid #42ACE8 !important;font-size:12px;line-height:12px;margin:3px;padding:3px" value="<%=SystemEnv.getHtmlLabelName(16627,user.getLanguage()) %>">
					    <script>
					       function	showSignatureSetting(){
					       	  	var dialog = new window.top.Dialog();
								dialog.currentWindow = window;
								dialog.URL = "/systeminfo/BrowserMain.jsp?url=/docs/docs/SignatureList.jsp?action=yingyongsetting";
								dialog.Title = "<%=SystemEnv.getHtmlLabelName(16473, user.getLanguage())%>";
								dialog.Width = 600;
								dialog.Height = 600;
								dialog.Drag = true;
								dialog.show();
					       }
					    </script>
					    <%}%>
					</wea:item>
					
					<wea:item attributes="{'samePair':'noImg'}">
						<%=$label(81762,user.getLanguage())%>
					</wea:item>
					<wea:item attributes="{'samePair':'noImg'}">
						<input type="text" id='imgheight' name="imgheight" style="width:120px;" value="<%=null == imgheight||imgheight.equals("")?"60":imgheight%>">
					</wea:item>
					
					<wea:item attributes="{'samePair':'noImg'}">
						<%=$label(81763,user.getLanguage())%>
					</wea:item>
					<wea:item attributes="{'samePair':'noImg'}">
						<select id='imgshowtpe' name="imgshowtpe">
						  <option value="2" <%if(null!=imgshowtpe&&imgshowtpe.equals("2")){%>selected<%}%>><%=$label(81766,user.getLanguage()) %></option>
						  <option value="1" <%if(null!=imgshowtpe&&imgshowtpe.equals("1")){%>selected<%}%>><%=$label(81767,user.getLanguage()) %></option>
						</select>
					</wea:item>
				</wea:group>
				
				<wea:group context='<%=$label(132072,user.getLanguage())%>' attributes="{'class':'e8_title e8_title_1'}">
					<wea:item>
						<%=$label(132071,user.getLanguage()) %>
					</wea:item>
					<wea:item>
						<input type="checkbox" id='mobilechangemode' name="mobilechangemode"   <% if("1".equals(mobilechangemode)) {%> checked <%}%>  onclick="ShowORHidden(this,'mobileModeAttr','showUploadTab')" tzCheckbox="true">
						&nbsp;&nbsp;&nbsp;
						<SPAN class=".e8tips" style="CURSOR: hand" id="remind" title="<%=SystemEnv.getHtmlLabelName(132077,user.getLanguage())%>" ><IMG id=ext-gen124 align=absMiddle src="/images/remind_wev8.png"></SPAN>
					</wea:item>
					<%
						String 	mobileModeAttr = "{'samePair':'mobileModeAttr','display':''}";
						if(!"1".equals(mobilechangemode)) mobileModeAttr = "{'samePair':'mobileModeAttr','display':'none'}";
		        %>
					<wea:item attributes='<%=mobileModeAttr %>'>
						<%=$label(132073,user.getLanguage()) %>
					</wea:item>
					<wea:item attributes='<%=mobileModeAttr %>'>
						<input type="radio"   name="mobilemode"  tzCheckbox="true"   <%="".equals(mobilemode)||"0".equals(mobilemode)?"checked":"" %> value="0"/><%=$label(132074,user.getLanguage()) %> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<input type="radio"   name="mobilemode"  tzCheckbox="true"  <%="1".equals(mobilemode)?"checked":"" %> value="1"/><%=$label(132075,user.getLanguage()) %>
					</wea:item>
					<wea:item attributes='<%=mobileModeAttr %>'>
						<%=$label(132076,user.getLanguage()) %>
					</wea:item>
					<wea:item attributes='<%=mobileModeAttr %>'>
					     <select class=inputstyle  name="mobileapplyworkflow" id="mobileapplyworkflow" style="float: left;" onchange="changeApplyWfid(this);">
					        <option value="0" <%="".equals(mobileapplyworkflow)||"0".equals(mobileapplyworkflow)?"selected":"" %>><%=$label(126831,user.getLanguage())%></option>
					        <option value="1" <%="1".equals(mobileapplyworkflow)?"selected":"" %>><%=$label(128807,user.getLanguage())%></option>
					        <option value="2" <%="2".equals(mobileapplyworkflow)?"selected":"" %>><%=$label(126833,user.getLanguage())%></option>
					     </select>
					    <%
					       String browserSpanValue="";
					       if(mobileapplyworkflowids.indexOf(",")!=-1){
					    	  String[] wfids=  Util.splitString(mobileapplyworkflowids,",");
					    	  int i=0,wfidlength=wfids.length;
					    	  for(i=0;i<wfidlength;i++){
					    		  browserSpanValue += WorkflowComInfo.getWorkflowname( wfids[i]);
					    		  if(i!=(wfidlength-1)){
					    			  browserSpanValue += ",";
					    		  }
					    	  }
					    	   
					       }else if(!"".equals(mobileapplyworkflowids)){
					    	   browserSpanValue = WorkflowComInfo.getWorkflowname(mobileapplyworkflowids);
					       }
					    %>
					   <span id="mobileapplyworkflowidsSpan" style="<%="".equals(mobileapplyworkflow)||"0".equals(mobileapplyworkflow)?"display:none":"" %>">
					    <brow:browser  viewType="0" name="mobileapplyworkflowids" browserValue="<%=mobileapplyworkflowids %>" browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/MutiWorkflowBrowser.jsp?selectedids=" idKey="id" nameKey="name"  hasInput="true"  width="50%" isSingle="false" hasBrowser = "true" isMustInput='2' completeUrl="/data.jsp?type=workflowBrowser"  browserSpanValue="<%=browserSpanValue %>"></brow:browser>
					   </span>
					</wea:item>
				</wea:group>
				
				</wea:layout>
		</form>
	</body>
</html>
