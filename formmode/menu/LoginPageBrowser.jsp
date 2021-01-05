
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.page.menu.*"%>
<%@ page
	import="weaver.general.Util,weaver.general.GCONST,weaver.file.Prop,weaver.docs.category.security.AclManager,weaver.docs.category.CategoryTree,weaver.docs.category.CommonCategory"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="MenuCenterCominfo" class="weaver.page.menu.MenuCenterCominfo" scope="page"/>
<%
	String menutype = Util.null2String(request.getParameter("menutype"));
	String id = Util.null2String(request.getParameter("menuId"));
	Prop prop = Prop.getInstance();
	String hasOvertime = Util.null2String(prop.getPropValue(GCONST.getConfigFile(), "ecology.overtime"));
	String hasChangStatus = Util.null2String(prop.getPropValue(GCONST.getConfigFile(), "ecology.changestatus"));
%>
<HTML>
	<HEAD>
		<LINK REL=stylesheet type="text/css" HREF="/css/Weaver_wev8.css">
		<LINK REL=stylesheet type="text/css" HREF="/js/jquery/plugins/weavertabs/weavertabs_wev8.css">
		<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
		<SCRIPT language="javascript" src="/js/jquery/jquery_wev8.js"></script>
		<SCRIPT type="text/javascript"
			src="/js/jquery/plugins/weavertabs/jquery.weavertabs_wev8.js"></script>
		<script type="text/javascript">
			function weaverTabsData(id)
			{
				var content = $("#"+id).html();
				content = content.replace(/(^\s*)|(\s*$)/g, "");
				if(content=="")
				{
					$("#"+id).html("<img src=/images/loading2_wev8.gif>&nbsp;<%=SystemEnv.getHtmlLabelName(19819, user.getLanguage())%>...");
					$.post("/formmode/menu/LoginPageOperation.jsp", { id:id,menuId:'<%=id %>', menutype: '<%=menutype %>'},function(data){
					    	data = data.replace(/(^\s*)|(\s*$)/g, "");
					    	$("#"+id).html(data);
					    	$("#"+id+" a").each(function(i,n)
							{
								var hrefhead = location.protocol+"//"+location.host;
								var ohref = this.href;
								if(ohref.charAt(ohref.length-1)=="#"){
									ohref="#";
								}
								if(ohref!=""&&ohref!="#"&&ohref.indexOf("javascript:void")==-1)
								{
									if(ohref.indexOf(hrefhead)==0)
									{
										ohref = ohref.substring(hrefhead.length, ohref.length);
									}
									this.onclick=Function("return returnUrl('"+ohref+"','"+this.innerHTML+"');");
									this.href="#";
									this.target="";
								}
							});
					});
				}
			}
		</script>
	</HEAD>

	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	<%
		RCMenu += "{" + SystemEnv.getHtmlLabelName(826, user.getLanguage()) + ",javascript:getCustomModuleUrl(),_self} ";//确定
		RCMenuHeight += RCMenuHeightStep;
		RCMenu += "{" + SystemEnv.getHtmlLabelName(201, user.getLanguage()) + ",javascript:window.parent.close(),_self} ";//取消
		RCMenuHeight += RCMenuHeightStep;
		RCMenu += "{" + SystemEnv.getHtmlLabelName(311, user.getLanguage()) + ",javascript:btnclear_onclick(),_self} ";//清除
		RCMenuHeight += RCMenuHeightStep;
		
		
	%>
	<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
	<BODY>
		<%
		if("2".equals(menutype)){
		%>
		<div class="weavertabs">
			<table class="weavertabs-nav" border="0" cellspacing="0"
				cellpadding="0">
				<tr>
					<td target="weavertabs-left" onclick="weaverTabsData('weavertabs-left');">
						<%=SystemEnv.getHtmlLabelName(17596, user.getLanguage())%><!-- 左侧菜单 -->
					</td>
					<td target="weavertabs-top" onclick="weaverTabsData('weavertabs-top');"><!-- 顶部菜单 -->
						<%=SystemEnv.getHtmlLabelName(20611, user.getLanguage())%>
					</td>
					<td target="weavertabs-hpmenus" onclick="weaverTabsData('weavertabs-hpmenus');">
						<%=SystemEnv.getHtmlLabelName(23093, user.getLanguage())%><!-- 首页菜单 -->
					</td>
					<td target="weavertabs-cus" onclick="weaverTabsData('weavertabs-cus');">
						<%=SystemEnv.getHtmlLabelName(18773, user.getLanguage())%><!-- 自定义菜单 -->
					</td>
					<td target="weavertabs-hp" onclick="weaverTabsData('weavertabs-hp');">
						<%=SystemEnv.getHtmlLabelName(23094, user.getLanguage())%><!-- 系统门户页面 -->
					</td>
					<td target="weavertabs-sys" onclick="weaverTabsData('weavertabs-sys');">
						<%=SystemEnv.getHtmlLabelName(31560, user.getLanguage()) %>
					</td>
				</tr>
			</table>
			<div class="weavertabs-content">
				<div id="weavertabs-left">
				</div>
				<div id="weavertabs-top">
				</div>
				<div id="weavertabs-hpmenus">
				</div>
				<div id="weavertabs-cus">
				</div>
				<div id="weavertabs-hp">
				</div>
				<div id="weavertabs-sys">
					<FORM style="MARGIN-TOP: 0px" name=frmmain method=post action="MenuMaintenanceOperation.jsp" enctype="multipart/form-data">
					
					<TABLE class="Shadow">
						<tr>
							<td valign="top">
								<TABLE class=ViewForm>
									<COLGROUP>
										<COL width="20%">
										<COL width="80%">
									<TBODY>
										<%-- 模块 --%>
										<tr>
											<td><%=SystemEnv.getHtmlLabelName(19049, user.getLanguage())%></td>
											<td class=Field>
												<input type="radio" name="customModule" value="1"
													onClick="onChangeModule(this);" checked><%=SystemEnv.getHtmlLabelName(58, user.getLanguage())%><!-- 文档 -->
												<input type="radio" name="customModule" value="2"
													onClick="onChangeModule(this);"><%=SystemEnv.getHtmlLabelName(18015, user.getLanguage())%><!-- 流程 -->
												<input type="radio" name="customModule" value="3"
													onClick="onChangeModule(this);"><%=SystemEnv.getHtmlLabelName(136, user.getLanguage())%><!-- 客户 -->
												<input type="radio" name="customModule" value="4"
													onClick="onChangeModule(this);"><%=SystemEnv.getHtmlLabelName(101, user.getLanguage())%><!-- 项目 -->
											</td>
										</tr>
										<TR style="height:1px;">
											<TD class=Line colSpan=2></TD>
										</TR>

										<%-- 菜单类型 --%>
										<tr>
											<td><%=SystemEnv.getHtmlLabelName(19054, user.getLanguage())%></td>
											<td class=Field>
												<select name="customType_1" style="display: block"
													onChange="onChangeModuleType(this);">
													<option value="1" selected><%=SystemEnv.getHtmlLabelName(1986, user.getLanguage())%></option><!-- 新建文档 -->
													<option value="2"><%=SystemEnv.getHtmlLabelName(1212, user.getLanguage())%></option><!-- 我的文档 -->
													<option value="3"><%=SystemEnv.getHtmlLabelName(16397, user.getLanguage())%></option><!-- 最新文档 -->
													<option value="4"><%=SystemEnv.getHtmlLabelName(16398, user.getLanguage())%></option><!-- 文档目录 -->
												</select>
												<select name="customType_2" style="display: none"
													onChange="onChangeModuleType(this);">
													<option value="1" selected><%=SystemEnv.getHtmlLabelName(16392, user.getLanguage())%></option><!-- 新建流程 -->
													<option value="2"><%=SystemEnv.getHtmlLabelName(1207, user.getLanguage())%></option><!-- 待办事宜 -->
													<option value="3"><%=SystemEnv.getHtmlLabelName(17991, user.getLanguage())%></option><!-- 已办事宜 -->
													<option value="4"><%=SystemEnv.getHtmlLabelName(17992, user.getLanguage())%></option><!-- 办结事宜 -->
													<option value="6"><%=SystemEnv.getHtmlLabelName(21639, user.getLanguage())%></option><!-- 抄送事宜 -->
													<option value="7"><%=SystemEnv.getHtmlLabelName(21640, user.getLanguage())%></option><!-- 督办事宜 -->
													<%
														if (!"".equals(hasOvertime))
														{
													%>
													<option value="8"><%=SystemEnv.getHtmlLabelName(21641, user.getLanguage())%></option><!-- 超时事宜 -->
													<%
														}
													%>
													<%
														if (!"".equals(hasChangStatus))
														{
													%>
													<option value="9"><%=SystemEnv.getHtmlLabelName(21643, user.getLanguage())%></option><!-- 反馈事宜 -->
													<%
														}
													%>
													<option value="5"><%=SystemEnv.getHtmlLabelName(1210, user.getLanguage())%></option><!-- 我的请求 -->
												</select>
												<select name="customType_3" style="display: none"
													onChange="onChangeModuleType(this);">
													<option value="1" selected><%=SystemEnv.getHtmlLabelName(15006, user.getLanguage())%></option><!-- 新建客户 -->
												</select>
												<select name="customType_4" style="display: none"
													onChange="onChangeModuleType(this);">
													<option value="1" selected><%=SystemEnv.getHtmlLabelName(15007, user.getLanguage())%></option><!-- 新建项目 -->
													<option value="2"><%=SystemEnv.getHtmlLabelName(16408, user.getLanguage())%></option><!-- 项目执行 -->
													<option value="3"><%=SystemEnv.getHtmlLabelName(16409, user.getLanguage())%></option><!-- 审批项目 -->
													<option value="4"><%=SystemEnv.getHtmlLabelName(16410, user.getLanguage())%></option><!-- 审批任务 -->
													<option value="5"><%=SystemEnv.getHtmlLabelName(16411, user.getLanguage())%></option><!-- 当前任务 -->
													<option value="6"><%=SystemEnv.getHtmlLabelName(16412, user.getLanguage())%></option><!-- 超期任务 -->
												</select>
											</td>
										</tr>
										<TR>
											<TD class=Line colSpan=2></TD>
										</TR>
									</TBODY>
								</TABLE>
								<div id="divContent"></div>
							</TD>
						</TR>
					</TABLE>
					</FORM>
				</div>
			</div>
		</div>
		<%
		}
		else if("1".equals(menutype))
		{
		%>
		<table width="100%" height="100%" border="1" cellspacing="0"
				cellpadding="0">
			<colgroup>
				<col width="10">
				<col width="">
				<col width="10">
			<tr>
				<td height="10" colspan="3"></td>
			</tr>
			<tr>
				<td></td>
				<td valign="top">
					<TABLE class=Shadow height="100%" width="100%">
						<tr>
							<td valign="top">
								<table width=100% class=ViewForm>
									
									<TR>
										<TD width=25%><%=SystemEnv.getHtmlLabelName(23034, user.getLanguage())%></TD><!-- 登录页内容列表 -->
										<TD width=25%></TD>
										<TD width=15%></TD>
										<TD width=35%></TD>
									</TR>
									<TR class=Spacing>
										<TD class=Line1 colspan=4></TD>
									</TR>
									<TR class=separator>
										<TD class=Sep1 colspan=4></TD>
									</TR>
								</table>
								<TABLE ID=BrowseTable class=BroswerStyle cellspacing="0" width="100%" 
									cellpadding="0">
									<TR class=DataHeader>
										<TH  style="display: none"><%=SystemEnv.getHtmlLabelName(84, user.getLanguage())%></TH><!-- 标识 -->
										<TH>
											<%=SystemEnv.getHtmlLabelName(195, user.getLanguage())%><!-- 名称 -->
										</TH>
										<TH>
											<%=SystemEnv.getHtmlLabelName(433, user.getLanguage())%><!-- 描述 -->
										</TH>
									</TR>
									<TR class=Line>
										<TH colSpan=3></TH>
									</TR>
									<%
									int index = 0;
									String sql = "";
									if ("sqlserver".equals(rs.getDBType())){
										sql = "select id, "+
										 "      infoname, "+
										 "      infodesc, "+
										 "      styleid, "+
										 "      layoutid, "+
										 "      subcompanyid, "+
										 "      isuse, "+
										 "      islocked "+
										 " from hpinfo "+
										 "where creatortype = 0 "+
										 "  and subcompanyid = -1 "+
										 "  and infoname != '' "+
										 "order by subcompanyid asc, id asc";
								
									}else{
										sql = "select id, "+
										 "      infoname, "+
										 "      infodesc, "+
										 "      styleid, "+
										 "      layoutid, "+
										 "      subcompanyid, "+
										 "      isuse, "+
										 "      islocked "+
										 " from hpinfo "+
										 "where creatortype = 0 "+
										 "  and subcompanyid = -1 "+
										 "  and infoname is not null "+
										 "order by subcompanyid asc, id asc";
							
									}
									rs.executeSql(sql);
									while (rs.next())
									{
										String pid = rs.getString("id");
										String infoname = rs.getString("infoname");
										String infodesc = rs.getString("infodesc");
										index++;
									%>
								<TR class='<%if(index%2==0) out.println("DataDark"); else out.println("DataLight");%>'>
									<TD style="display: none"><A HREF=#><%=pid%></A></TD>
									<TD valign="middle" width="45%" style="padding-left:2px;">
										<%=infoname%>
									</TD>
									<TD valign="middle" width="55%" style="padding-left:2px;">
										<%=infodesc%>
									</TD>
								</TR>
								<%
									}
								%>
								</TABLE>
							</td>
						</tr>
					</TABLE>
				</td>
				<td></td>
			</tr>
			<tr>
				<td height="10" colspan="4"></td>
			</tr>
		</table>
		<%
		}
		%>
	</BODY>
</HTML>
<script LANGUAGE="JavaScript">

$(document).ready(function () {
	getData("adddoc");
});

function getData(type)
{
	$("#divContent").css("display","block"); 
	$("#divContent").html("<img src=/images/loading2_wev8.gif>&nbsp;<%=SystemEnv.getHtmlLabelName(19819, user.getLanguage())%>...");//请稍候
	
	$.get("/systeminfo/menuconfig/MenuMaintenanceAddAdvancedGet.jsp",{"type":type}, function(data)
	{
	    $("#divContent").html(data);
	});	
}

function onChangeModule(obj){
	for(var i=1;i<=4;i++){
		var typeObj = eval("frmmain.customType_"+i);
		if(typeObj!=null) typeObj.style.display = "none";
	}
	var currTypeObj = eval("frmmain.customType_"+obj.value);
	if(currTypeObj!=null){
		currTypeObj.style.display = "block";
		onChangeModuleType(currTypeObj);
	}
}

function onChangeModuleType(obj){
	var splitname = obj.name;
	var typeObj = null;
	for(var i=1;i<=15;i++){
		typeObj = document.getElementById("customSetting_"+i);
		if(typeObj!=null) typeObj.style.display = "none";
	}
	var splitstrarray = obj.name.split("_");
	var currselect = 0;
	
	if(splitstrarray[1]=="1"&&obj.value=="1"){//新建文档
		getData("adddoc");
	} else if(splitstrarray[1]=="1"&&obj.value=="2"){//我的文档
		getData("mydoc");
	} else if(splitstrarray[1]=="1"&&obj.value=="3"){//最新文档
		getData("newdoc");
	} else if(splitstrarray[1]=="1"&&obj.value=="4"){//文档目录
		getData("doccategory");
	} else if(splitstrarray[1]=="2"&&obj.value=="1"){//新建流程
		getData("addwf");
	} else if(splitstrarray[1]=="2"&&obj.value=="2"){//待办事宜
		getData("waitdowf");
	} else if(splitstrarray[1]=="2"&&obj.value=="3"){//已办事宜
		getData("donewf");
	} else if(splitstrarray[1]=="2"&&obj.value=="4"){//办结事宜
		getData("alreadydowf");
	} else if(splitstrarray[1]=="2"&&obj.value=="5"){//我的请求
		getData("mywf");
	} else if(splitstrarray[1]=="3"&&obj.value=="1"){//新建客户
		getData("addcus");
	} else if(splitstrarray[1]=="4"&&obj.value=="1"){//新建项目
		getData("addproject");
	} else if(splitstrarray[1]=="4"&&obj.value=="2"){//项目执行

	} else if(splitstrarray[1]=="4"&&obj.value=="3"){//审批项目

	} else if(splitstrarray[1]=="4"&&obj.value=="4"){//审批任务

	} else if(splitstrarray[1]=="4"&&obj.value=="5"){//当前任务

	} else if(splitstrarray[1]=="4"&&obj.value=="6"){//超期任务

	} else if(splitstrarray[1]=="2"&&obj.value=="6"){//抄送事宜
		getData("sendwf");
	} else if(splitstrarray[1]=="2"&&obj.value=="7"){//督办事宜
		getData("supervisewf");
	} else if(splitstrarray[1]=="2"&&obj.value=="8"){//超时事宜
		getData("overtimewf");
	} else if(splitstrarray[1]=="2"&&obj.value=="9"){//反馈事宜
		getData("backwf");
	}
}

function getCustomModuleUrl()
{
	var customModule = document.getElementsByName("customModule");
	var vcustomModule = "";
	for(var i=0;i<customModule.length;i++)
	{
		var cm = customModule[i];
		if(cm.checked)
		{
			vcustomModule = cm.value;
		}
	}
	var customType = document.getElementsByName("customType_"+vcustomModule);
	var vcustomType = "";
	for(var i=0;i<customType.length;i++)
	{
		var ct = customType[i];
		vcustomType = ct.value;
	}
	//alert("vcustomModule : "+vcustomModule + "   vcustomType : "+vcustomType);
	var selectCustomTypes = $("input[type='checkbox']:checked");
	var checkDisplay = $("input[type='radio']:checked");
	var selectedContent = "";
	var selectDisplay = "";
	var vlink = "";
	if(vcustomModule=="1")
	{
		if(vcustomType=="1")
		{
			$.each(selectCustomTypes, function(i, o){
			  //alert( "Name: " + i + ", Value: " + o.name );
			  var evalue = o.value;
			  if(evalue.indexOf("docdir_ND_M")!=-1||evalue.indexOf("docdir_ND_S")!=-1)
			  {
				var addedStr = evalue.substring(10);
				if (selectedContent=="")
				{
					selectedContent+=addedStr;
				} 
				else 
				{
					selectedContent+="|"+addedStr;
				}
			  }
			});
			vlink = "/docs/docs/DocList.jsp?fromadvancedmenu=1&selectedContent="+selectedContent;
		}
		else if(vcustomType=="2")
		{//我的文档
			$.each(selectCustomTypes, function(i, o){
				//alert( "Name: " + i + ", Value: " + o.name );
				var evalue = o.value;
				if(evalue.indexOf("docdir_MD_M")!=-1||evalue.indexOf("docdir_MD_S")!=-1)
				{
					var addedStr = evalue.substring(10);
					if (selectedContent=="")
					{
						selectedContent+=addedStr;
					} 
					else 
					{
						selectedContent+="|"+addedStr;
					}
				}
			});
			vlink = "/docs/search/DocView.jsp?fromadvancedmenu=1&selectedContent="+selectedContent;
		}
		else if(vcustomType=="3")
		{//最新文档
			$.each(selectCustomTypes, function(i, o){
				//alert( "Name: " + i + ", Value: " + o.name );
				var evalue = o.value;
				if(evalue.indexOf("docdir_NESTD_M")!=-1||evalue.indexOf("docdir_NESTD_S")!=-1)
				{
					var addedStr = evalue.substring(13);
					if (selectedContent=="")
					{
						selectedContent+=addedStr;
					} 
					else 
					{
						selectedContent+="|"+addedStr;
					}
				}
			});
			$.each(checkDisplay, function(i, o){
				if(o.name == "displayUsage_3") {
					selectDisplay = o.value;
				}
			});
			vlink = "/docs/search/DocSearchTemp.jsp?fromadvancedmenu=1&list=all&isNew=yes&loginType=1&containreply=1&displayUsage="+selectDisplay+"&selectedContent="+selectedContent;
		}
		else if(vcustomType=="4")
		{//最新文档
			$.each(selectCustomTypes, function(i, o){
				//alert( "Name: " + i + ", Value: " + o.name );
				var evalue = o.value;
				if(evalue.indexOf("docdir_DC_M")!=-1||evalue.indexOf("docdir_DC_S")!=-1)
				{
					var addedStr = evalue.substring(10);
					if (selectedContent=="")
					{
						selectedContent+=addedStr;
					} 
					else 
					{
						selectedContent+="|"+addedStr;
					}
				}
			});
			vlink = "/docs/search/DocSummary.jsp?fromadvancedmenu=1&selectedContent="+selectedContent;
		}
	}
	else if(vcustomModule=="2")
	{
		if(vcustomType=="1")
		{
			$.each(selectCustomTypes, function(i, o){
			  //alert( "Name: " + i + ", Value: " + o.name );
			  var evalue = o.value;
			  if(evalue.indexOf("workflow_NF_T")!=-1||evalue.indexOf("workflow_NF_W")!=-1||evalue.indexOf("workflow_NF_R")!=-1)
			  {
				var addedStr = evalue.substring(12);
				if (selectedContent=="")
				{
					selectedContent+=addedStr;
				} 
				else 
				{
					selectedContent+="|"+addedStr;
				}
			  }
			});
			vlink = "/workflow/request/RequestType.jsp?fromadvancedmenu=1&menuType=1&selectedContent="+selectedContent;
		}
		else if(vcustomType=="2")
		{
			$.each(selectCustomTypes, function(i, o){
			  //alert( "Name: " + i + ", Value: " + o.name );
			  var evalue = o.value;
			  if(evalue.indexOf("workflow_PM_T")!=-1||evalue.indexOf("workflow_PM_W")!=-1)
			  {
				var addedStr = evalue.substring(12);
				if (selectedContent=="")
				{
					selectedContent+=addedStr;
				} 
				else 
				{
					selectedContent+="|"+addedStr;
				}
				if(evalue.indexOf("workflow_PM_W")!=-1)
				{
					var t_wfid = addedStr.substring(1);
				    //alert("t_wfid : "+t_wfid);
					if(t_wfid != "0")
					{
							var t_nodeids = $("#workflow_PM_v" + t_wfid).val();
						var s_nodeName = $("#workflow_PM_n" + t_wfid).val();
						if("0"!=t_nodeids && ""!=t_nodeids)
						{
							selectedContent+="|P"+addedStr+"N"+t_nodeids + "SP^AN" + s_nodeName;
						}
					}
				}
			  }
			});
			vlink = "/workflow/request/RequestView.jsp?fromadvancedmenu=1&menuType=2&selectedContent="+selectedContent;
		}
		else if(vcustomType=="3")
		{
			$.each(selectCustomTypes, function(i, o){
			  //alert( "Name: " + i + ", Value: " + o.name );
			  var evalue = o.value;
			  if(evalue.indexOf("workflow_HM_T")!=-1||evalue.indexOf("workflow_HM_W")!=-1)
			  {
				var addedStr = evalue.substring(12);
				if (selectedContent=="")
				{
					selectedContent+=addedStr;
				} 
				else 
				{
					selectedContent+="|"+addedStr;
				}
			  }
			});
			vlink = "/workflow/request/RequestHandled.jsp?fromadvancedmenu=1&menuType=3&selectedContent="+selectedContent;
		}
		else if(vcustomType=="4")
		{
			$.each(selectCustomTypes, function(i, o){
			  //alert( "Name: " + i + ", Value: " + o.name );
			  var evalue = o.value;
			  if(evalue.indexOf("workflow_CM_T")!=-1||evalue.indexOf("workflow_CM_W")!=-1)
			  {
				var addedStr = evalue.substring(12);
				if (selectedContent=="")
				{
					selectedContent+=addedStr;
				} 
				else 
				{
					selectedContent+="|"+addedStr;
				}
			  }
			});
			vlink = "/workflow/request/RequestComplete.jsp?fromadvancedmenu=1&menuType=4&selectedContent="+selectedContent;
		}
		else if(vcustomType=="5")
		{
			$.each(selectCustomTypes, function(i, o){
			  //alert( "Name: " + i + ", Value: " + o.name );
			  var evalue = o.value;
			  if(evalue.indexOf("workflow_MR_T")!=-1||evalue.indexOf("workflow_MR_W")!=-1)
			  {
				var addedStr = evalue.substring(12);
				if (selectedContent=="")
				{
					selectedContent+=addedStr;
				} 
				else 
				{
					selectedContent+="|"+addedStr;
				}
			  }
			});
			vlink = "/workflow/request/MyRequestView.jsp?fromadvancedmenu=1&menuType=5&selectedContent="+selectedContent;
		}
		else if(vcustomType=="6")
		{
			$.each(selectCustomTypes, function(i, o){
			  //alert( "Name: " + i + ", Value: " + o.name );
			  var evalue = o.value;
			  if(evalue.indexOf("workflow_RM_T")!=-1||evalue.indexOf("workflow_RM_W")!=-1)
			  {
				var addedStr = evalue.substring(12);
				if (selectedContent=="")
				{
					selectedContent+=addedStr;
				} 
				else 
				{
					selectedContent+="|"+addedStr;
				}
			  }
			});
			vlink = "/workflow/search/WFSearchCustom.jsp?fromadvancedmenu=1&menuType=6&selectedContent="+selectedContent;
		}
		else if(vcustomType=="7")
		{
			$.each(selectCustomTypes, function(i, o){
			  //alert( "Name: " + i + ", Value: " + o.name );
			  var evalue = o.value;
			  if(evalue.indexOf("workflow_SM_T")!=-1||evalue.indexOf("workflow_SM_W")!=-1)
			  {
				var addedStr = evalue.substring(12);
				if (selectedContent=="")
				{
					selectedContent+=addedStr;
				} 
				else 
				{
					selectedContent+="|"+addedStr;
				}
			  }
			});
			vlink = "/workflow/search/WFSearchCustom.jsp?fromadvancedmenu=1&menuType=7&selectedContent="+selectedContent;
		}
		else if(vcustomType=="8")
		{
			$.each(selectCustomTypes, function(i, o){
			  //alert( "Name: " + i + ", Value: " + o.name );
			  var evalue = o.value;
			  if(evalue.indexOf("workflow_OM_T")!=-1||evalue.indexOf("workflow_OM_W")!=-1)
			  {
				var addedStr = evalue.substring(12);
				if (selectedContent=="")
				{
					selectedContent+=addedStr;
				} 
				else 
				{
					selectedContent+="|"+addedStr;
				}
			  }
			});
			vlink = "/workflow/search/WFSearchCustom.jsp?fromadvancedmenu=1&menuType=8&selectedContent="+selectedContent;
		}
		else if(vcustomType=="9")
		{
			$.each(selectCustomTypes, function(i, o){
			  //alert( "Name: " + i + ", Value: " + o.name );
			  var evalue = o.value;
			  if(evalue.indexOf("workflow_FM_T")!=-1||evalue.indexOf("workflow_FM_W")!=-1)
			  {
				var addedStr = evalue.substring(12);
				if (selectedContent=="")
				{
					selectedContent+=addedStr;
				} 
				else 
				{
					selectedContent+="|"+addedStr;
				}
			  }
			});
			vlink = "/workflow/search/WFSearchCustom.jsp?fromadvancedmenu=1&menuType=9&selectedContent="+selectedContent;
		}
	}
	else if(vcustomModule=="3")
	{
		if(vcustomType=="1")
		{//新建客户
			vlink = "/CRM/data/AddCustomerExist.jsp";
		}
	}
	else if(vcustomModule=="4")
	{
		if(vcustomType=="1")
		{
			$.each(selectCustomTypes, function(i, o){
			  //alert( "Name: " + i + ", Value: " + o.name );
			  var evalue = o.value;
			  if(evalue.indexOf("project_P")!=-1)
			  {
				var addedStr = evalue.substring(8);
				if (selectedContent=="")
				{
					selectedContent+=addedStr;
				} 
				else 
				{
					selectedContent+="|"+addedStr;
				}
			  }
			});
			vlink = "/proj/Templet/ProjTempletSele.jsp?fromadvancedmenu=1&selectedContent="+selectedContent;
		}
		else if("2"==vcustomType){//项目执行
			vlink = "/proj/data/MyProject.jsp";
		} else if("3"==vcustomType){//审批项目
			vlink = "/proj/data/ProjectApproval.jsp";
		} else if("4"==vcustomType){//审批任务
			vlink = "/proj/process/ProjectTaskApproval.jsp";
		} else if("5"==vcustomType){//当前任务
			vlink = "/proj/data/CurrentTask.jsp";
		} else if("6"==vcustomType){//超期任务
			vlink = "/proj/data/OverdueTask.jsp";
		}
	}
	returnUrl(vlink,' ');
}
function onIcoChange(obj){
	if(this.vlaue!='') spanShow.innerHTML="<img src='"+obj.value+"'>"
}

</script>
<%
if("2".equals(menutype))
{
%>
<script language="javascript">
	function openNextUl(o)
	{
		var li = o.parentNode;
		if(li&&li.tagName=="LI")
		{
			var image = li.firstChild;
			var ul = li.lastChild;
			if(ul)
			{
				var style = ul.style.display;
				if(style=="block"||style=="")
				{
					ul.style.display = "none";
					image.src = "/images/messageimages/plus_wev8.gif";
				}
				else
				{
					ul.style.display = "block";
					image.src = "/images/messageimages/minus_wev8.gif";
				}
			}
		}
	}
	$(document).ready(function(){
		$(".weavertabs").weavertabs();
		weaverTabsData("weavertabs-left");
		$("a").each(function(i,n)
		{
			var hrefhead = location.protocol+"//"+location.host;
			var ohref = this.href;
			if(ohref!=""&&ohref!="#"&&ohref.indexOf("javascript:void")==-1)
			{
				if(ohref.indexOf(hrefhead)==0)
				{
					ohref = ohref.substring(hrefhead.length, ohref.length);
				}
				this.onclick=Function("return returnUrl('"+ohref+"','"+this.innerHTML+"');");
				this.href="#";
				this.target="";
			}
			
		});
	});
</script>
<%} %>
<SCRIPT type="text/javascript">
function btnclear_onclick(){
     window.parent.parent.returnValue = {id:"",name:""};
     window.parent.parent.close();
}
<%
if("2".equals(menutype))
{
%>
function returnUrl(o,v){
	window.parent.returnValue = {id:v,name:o};
	window.parent.close();
}
<%}%>
<%
if("1".equals(menutype))
{
%>
function BrowseTable_onmouseover(e){
	e=e||event;
   var target=e.srcElement||e.target;
   if("TD"==target.nodeName){
		jQuery(target).parents("tr")[0].className = "Selected";
   }else if("A"==target.nodeName){
		jQuery(target).parents("tr")[0].className = "Selected";
   }
}
function BrowseTable_onmouseout(e){
	var e=e||event;
   var target=e.srcElement||e.target;
   var p;
	if(target.nodeName == "TD" || target.nodeName == "A" ){
      p=jQuery(target).parents("tr")[0];
      if( p.rowIndex % 2 ==0){
         p.className = "DataDark"
      }else{
         p.className = "DataLight"
      }
   }
}

function BrowseTable_onclick(e){
   var e=e||event;
   var target=e.srcElement||e.target;

   if( target.nodeName =="TD"||target.nodeName =="A"  ){
     window.parent.parent.returnValue = {id:jQuery(jQuery(target).parents("tr")[0].cells[0]).text(),name:jQuery(jQuery(target).parents("tr")[0].cells[1]).text()};
	 window.parent.parent.close();
	}
}

jQuery(document).ready(function(){
	jQuery("#BrowseTable").bind("click",BrowseTable_onclick);
	jQuery("#BrowseTable").bind("mouseover",BrowseTable_onmouseover);
	jQuery("#BrowseTable").bind("mouseout",BrowseTable_onmouseout);
})

<%
}
%>
</SCRIPT>