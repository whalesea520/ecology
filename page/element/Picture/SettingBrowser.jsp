
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.general.Util"%>
<%@ page import="java.util.*"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
	int ppicturetype = Util.getIntValue(Util.null2String(request.getParameter("picturetype")),1);
	String eid = Util.null2String(request.getParameter("eid"));
%>
<HTML>
	<HEAD>
		<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
		<link href="/page/maint/style/common_wev8.css" type="text/css" rel=stylesheet>

		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<SCRIPT language="javascript" src="/js/jquery/jquery_wev8.js"></script>
		<link href="/js/jquery/ui/jquery-ui_wev8.css" type="text/css" rel=stylesheet>
		<link rel="stylesheet" href="/js/ecology8/jNice/jNice/jNice_wev8.css" type="text/css" />
        <script type="text/javascript" src="/js/ecology8/jNice/jNice/jquery.jNice_wev8.js"></script>
		<SCRIPT type="text/javascript" src="/js/jquery/plugins/filetree/jquery.filetree_wev8.js"></script>
		<style type="">
		body{
			scroll:no;
			margin:0px;
			padding-left:10;
			padding-right:10;
		}
		</style>
	</HEAD>
	<BODY scroll=no>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
		    
			RCMenu += "{" + SystemEnv.getHtmlLabelName(91, user.getLanguage()) + ",javascript:deleteData(),_self} ";
			RCMenuHeight += RCMenuHeightStep;

			/*RCMenu += "{" + SystemEnv.getHtmlLabelName(86, user.getLanguage()) + ",javascript:saveData(),_self} ";
			RCMenuHeight += RCMenuHeightStep;
			
			
			*/
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<FORM id="pictureForm" NAME=pictureForm STYLE="margin-bottom: 0;"
			action="/page/element/Picture/PictureOperation.jsp" method=post target="_parent">
			<input type="hidden" value="save" name="operation">
			<input type="hidden" value="<%=ppicturetype %>" name="picturetype">
			<input type="hidden" value="<%=eid %>" name="eid">
			<table width="100%" height="100%" border="0" cellspacing="0"
				cellpadding="0">
				<colgroup>
				<col width="100">
				</colgroup>
				<tr>
					<td height="10" ></td>
				</tr>
				<tr>
					<td width="*"  algin='center' valign="top" height="100%">
						<TABLE width='100%' class=Shadow height="100%">
							<tr>
								<td valign="top">
									<table width=100% height="50" class=viewform  >
										<col width="100" />
										
										<col width="*" />
										<tbody>
										<tr>
											<td class="" style='padding-top:5;padding-left:5'>  
													<%=SystemEnv.getHtmlLabelName(22930, user.getLanguage())%>
											</td>
											<td class="">
											 <table width='100%' class=viewform cellSpacing=1>
											 <TR>
												
												<TD class="Field">
													<INPUT style='' id="pictureSrcType" type="radio" checked name="pictureSrcType" selecttype="1" value='1' />
													<%=SystemEnv.getHtmlLabelName(172, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(18493, user.getLanguage())%>
												
													<input  name="pictureSrc" id="pictureSrc" class="filetree" type="hidden" value="" />
												</td>
											</TR>
											
											<TR>
												
												<TD class="Field">
													<INPUT  style='' id="pictureSrcType" type="radio" name="pictureSrcType" selecttype="2" value="2" />
													URL<%=SystemEnv.getHtmlLabelName(18499, user.getLanguage())%>
												
													<input style="width:230" name="pictureUrlOther" id="pictureUrlOther" class="inputStyle" type="text" value="">&nbsp;&nbsp;<A href='#' onclick="javascript:addPicture();"><%=SystemEnv.getHtmlLabelName(611, user.getLanguage())%></A>
												</TD>
											</TR>
										
											
											 </table>
											</td>
											</tr>
										</tbody>
									</table>
									<div id="favouritediv" style="overflow-y: auto;overflow-x: hidden; width: 100%;">
										<TABLE id="pictureTable"  class="ListStyle" cellSpacing=1 style="table-layout:fixed">
											<col width="5%" />
											<col width="30%" />
											<col width="20%" />
											<col width="20%" />
											<col width="10%" />
											<col width="10%" />
											<THEAD>
												<TR class=HeaderForXtalbe style=' height:25px! important'>
													<TH><INPUT id="pictureAllCheck" name="pictureAllCheck" value="1" type=checkbox onclick="checkAllChkBox(this.checked);"></TH>
													<TH title="<%=SystemEnv.getHtmlLabelName(74, user.getLanguage())%>">
														&nbsp;<%=SystemEnv.getHtmlLabelName(74, user.getLanguage())%>&nbsp;
													</TH>
													<TH title="<%=SystemEnv.getHtmlLabelName(22931, user.getLanguage())%>">
														&nbsp;<%=SystemEnv.getHtmlLabelName(22931, user.getLanguage())%>&nbsp;
													</TH>
													<TH title="<%=SystemEnv.getHtmlLabelName(22932, user.getLanguage())%>">
														&nbsp;<%=SystemEnv.getHtmlLabelName(22932, user.getLanguage())%>&nbsp;
													</TH>
													<TH title="<%=SystemEnv.getHtmlLabelName(88, user.getLanguage())%>">
														&nbsp;<%=SystemEnv.getHtmlLabelName(88, user.getLanguage())%>
													</TH>
													<TH title="<%=SystemEnv.getHtmlLabelName(104, user.getLanguage())%>" class=Header>
														&nbsp;<%=SystemEnv.getHtmlLabelName(104, user.getLanguage())%>
													</TH>
												</TR>
											</THEAD>
											<TBODY>
												<TR id="copydata" style="display:none;VERTICAL-ALIGN: middle" onmouseover="this.style.backgroundColor='#EAEAEA'" onmouseout="this.style.backgroundColor='#FFFFFF'">
													<TD>
														<INPUT id="pictureCheck" name="pictureCheck" value="0" type=checkbox onclick="if(this.checked){this.value='1';}else{this.value='0';}">
														<INPUT id="pictureid" name="pictureid" value="" type=hidden>
													</TD>
													<TD align=left><input nowrap id="pictureUrl" title="" style="background-color: transparent; border: 0px; width:100%;" readonly="true" name="pictureUrl" value="">
													</TD>
													<TD align=left><input id="pictureName" maxlength=1000 style="width:90%;" name="pictureName" value="" class="inputStyle">
													</TD>
													<TD align=left><input id="pictureLink" maxlength=1000 style="width:90%;" name="pictureLink" value="" class="inputStyle">
													</TD>
													<TD align=left><input id="pictureOrder" style="width:90%;" name="pictureOrder" value="0" class="inputStyle" onblur="checkNum(this);">
													</TD>
													<TD><A id="pictureOperation" href="#" onclick="javascript:deletePicture(this,'');"><%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%></A>&nbsp;
													</TD>
												</TR>
												<%
													String trclass = "";
													String sql = "select * from picture where picturetype="+ppicturetype+" and eid='"+eid+"' order by pictureOrder";
													rs.executeSql(sql);
													while(rs.next())
													{
														if(!"DataLight".equals(trclass))
														{
															trclass = "DataLight";
														}
														else
														{
															trclass = "DataDark";
														}
														String id = rs.getString("id");
														String pictureurl = rs.getString("pictureurl");
														//String picturename = Util.toHtml(rs.getString("picturename"));
														String picturename = rs.getString("picturename");
														String picturelink = rs.getString("picturelink");
														String picturetype = rs.getString("picturetype");
														int pictureOrder = Util.getIntValue(rs.getString("pictureOrder"),0);
														
												%>
												<TR class=<%=trclass %> style="VERTICAL-ALIGN: middle" id="<%=id %>" onmouseover="this.style.backgroundColor='#EAEAEA'" onmouseout="this.style.backgroundColor='#FFFFFF'">
													<TD>
														<INPUT id="pictureCheck" name="pictureCheck" value="0" type=checkbox onclick="if(!this.checked){this.value='1';}else{this.value='0';}">
														<INPUT id="pictureid" name="pictureid" value="<%=id %>" type=hidden>
													</TD>
													<TD align=left title="<%=pictureurl %>"><input nowrap title="<%=pictureurl %>" id="pictureUrl" style="background-color: transparent; border: 0px; width:100%;" readonly="true" name="pictureUrl" value="<%=pictureurl %>" class="inputStyle">
													</TD>
													<TD align=left><input id="pictureName" style="width:90%;" maxlength="1000" name="pictureName" value="<%=picturename %>" class="inputStyle">
													</TD>
													<TD align=left><input id="pictureLink" style="width:90%;" name="pictureLink" value="<%=picturelink %>" class="inputStyle">
													</TD>
													<TD align=left><input id="pictureOrder" style="width:90%;" name="pictureOrder" value="<%=pictureOrder %>" class="inputStyle" onblur="checkNum(this);">
													</TD>
													<TD><A href="#" onclick="javascript:deletePicture(this,'<%=id %>');"><%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%></A>&nbsp;
													</TD>
												</TR>
												<%
												} 
												%>
											</TBODY>
										</TABLE>
									</div>
								</td>
							</tr>
						</TABLE>
					</td>
				</tr>
			</table>
		</FORM>
		<div id="zDialog_div_bottom" class="zDialog_div_bottom" style="margin:auto;text-align:center;">
	    	<input type="button" accessKey=O  id=btnok  value="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%>" id="zd_btn_submit_0" class="zd_btn_submit" onclick="onSave();">
	    	<input type="button" accessKey=T  id=btncancel value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="onClose();">
			<script type="text/javascript">
				jQuery(document).ready(function(){
					resizeDialog(document);
				});
			</script>
		</div>
	</BODY>
</HTML>
<script type="text/javascript">
	var dialog = parent.getDialog(window);
	var parentWin = parent.getParentWindow(window);
	window.onload= function(){
		var winHeight = window.document.body.clientHeight-100;
		document.getElementById("favouritediv").style.height= winHeight+"px";
	}
	 var trclass = "<%=trclass %>";
	 var delImg = "";
	 function addPicture()
	 {
	 	//获取图片类型,1为服务器上的图片;2为图片链接
	 	var pictureSrcTypes = document.getElementsByName("pictureSrcType");
	 	var pictureSrcType = null;
	 	for(var i=0;i<pictureSrcTypes.length;i++)
	 	{
	 		pictureSrcType = pictureSrcTypes[i];
	 		if(pictureSrcType.checked)
	 		{
	 			break;
	 		}
	 	}
	 	if(pictureSrcType)
	 	{
		 	var srcType = pictureSrcType.value;
		 	//获取图片的url
		 	var pictureSrc = null;
		 	if("1"==srcType)
		 	{
		 		pictureSrc = document.getElementById("pictureSrc");
		 	}
		 	else
		 	{
		 		pictureSrc = document.getElementById("pictureUrlOther");
		 		if(!isUrl(pictureSrc.value)){
		 			pictureSrc.value='';
		 			alert("<%=SystemEnv.getHtmlLabelName(25022, user.getLanguage())%>");
		 			return;
		 		}
		 	}


		 	var pictureSrcValue = pictureSrc.value;
			var pictureSrcValues = pictureSrcValue.split(",");
			for(var i=0 ;i<pictureSrcValues.length;i++){
				pictureSrcValue=pictureSrcValues[i];
				if(""==pictureSrcValue)
				{
					alert("<%=SystemEnv.getHtmlLabelName(22933, user.getLanguage())%>");
					return;
				}else if("none"==pictureSrcValue){
					return;
				}
				else
				{
					var oTBODY = $("#pictureTable tbody")[0];
					var copydata = $("#copydata")[0];

					var newTR = copydata.cloneNode(true);

					newTR.setAttribute("id","newdata");
					if("DataLight"!=trclass)
					{
						trclass = "DataLight";
					}
					else
					{
						trclass = "DataDark";
					}
					newTR.className = trclass;
					oTBODY.insertAdjacentElement("beforeEnd",newTR);
					var newTDs = newTR.children;
					var pictureCheck = newTDs[0];
					var inputCheck=$(pictureCheck).find("input[name='pictureCheck']").clone();
					inputCheck.removeClass("jNiceHidden");
					$(pictureCheck).html("").append(inputCheck).append("<input id='pictureid' name='pictureid' value='' type='hidden'>");
					jQuery(pictureCheck).jNice();
					var pictureUrl = newTDs[1];
					var pictureName = newTDs[2];
					var pictureLink = newTDs[3];
					var pictureUrlInput = pictureUrl.children[0];
					pictureUrlInput.value = pictureSrcValue;
					pictureUrlInput.title = pictureSrcValue;
					pictureUrl.title=pictureSrcValue;
					newTR.style.display="";
					newTR.setAttribute("id","0");
					pictureSrc.value = "";

				}
			}

		 }
	 }
	 function deletePicture(o,id)
	 {
	 	var str = "<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>";
 		
 		window.top.Dialog.confirm(str,function(){
	       var oTable = document.getElementById("pictureTable");
		 	var pictureTr = o.parentNode.parentNode;
	 		var lineindex = pictureTr.rowIndex;
	 		oTable.deleteRow(lineindex);
	   });
	 }
	
	function deleteData()
	{
		if($("input[name='pictureCheck'][value='1']").length==0){
			alert("<%=SystemEnv.getHtmlLabelName(20149,user.getLanguage())%>")
			return;
		}
		var str = "<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>";
	    
	    window.top.Dialog.confirm(str,function(){
	       var chkboxElems= document.getElementsByName("pictureCheck");
	    	$("input[name='pictureCheck']").each(function(){
	    		if($(this).attr("value")=== '1'){
	    			$(this).closest("tr").remove();
	    		}
	    	})
	   });
	    
	}
	
	 
	 function onSave()
	 {
	 	var formParams = $("#pictureForm").serialize();
	 	dialog.callbackfun(formParams);
	 }
	 
	 function onClose(){
	 	dialog.callbackfun();
	 }
	 
     //切换美化checkbox是否选中
	function changeCheckboxStatus4tzCheckBox(obj, checked) {
		//jQuery(obj).attr("checked", checked);
		if (obj.checked) {
			jQuery(obj).next("span.tzCheckBox").addClass("checked");
			jQuery(obj).next("span.jNiceCheckbox").addClass("jNiceChecked");
		} else {
			jQuery(obj).next("span.tzCheckBox").removeClass("checked");
			jQuery(obj).next("span.jNiceCheckbox").removeClass("jNiceChecked");
		}
	}

	 function checkAllChkBox(btnChecked)
	{

		var chkboxElems= document.getElementsByName("pictureCheck");
	  	for (j=0;j<chkboxElems.length;j++)
	    {
			if($(chkboxElems[j]).parents("#copydata").length>0)
				continue;
	        if (!btnChecked)
	        {
	        	chkboxElems[j].value='1';
				chkboxElems[j].checked=true;
				changeCheckboxStatus4tzCheckBox(chkboxElems[j],true);

	        } 
	        else 
	        {
	            chkboxElems[j].value='0';
				chkboxElems[j].checked=false;
				changeCheckboxStatus4tzCheckBox(chkboxElems[j],false);

	        }
	    }
	}
	function checkNum(o)
	{
		var ordernum = o.value;
		var r = /^-?[0-9]+$/g;//整数
        var flag = r.test(ordernum);
        if(!flag)
        {
        	o.value = "0";
        	o.focus();
   			return;
        }
	}
	function isUrl(url)
	{
		 return url.match(/^(ht|f)tps?:\/\/[a-z0-9-\.]+\.[a-z]{2,4}\/?([^\s<>\#%"\,\{\}\\|\\\^\[\]`]+)?$/);
	}
	//for firefox
	try{
		HTMLElement.prototype.insertAdjacentElement=function(where,parsedNode){
		      switch(where){
		          case "beforeBegin":
		              this.parentNode.insertBefore(parsedNode,this);
		              break;
		          case "afterBegin":
		              this.insertBefore(parsedNode,this.firstChild);
		              break;
		          case "beforeEnd":
		              this.appendChild(parsedNode);
		              break;
		          case "afterEnd":
		              if(this.nextSibling)
		                  this.parentNode.insertBefore(parsedNode,this.nextSibling);
		              else
		                  this.parentNode.appendChild(parsedNode);
		              break;
		          }
	      }
      }catch(e){
      	
      }
	$("#pictureSrc").filetree({isSingle:false,call:addPicture});
</SCRIPT>