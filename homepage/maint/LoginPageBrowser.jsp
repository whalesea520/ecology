
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.page.menu.*"%>
<%@ page
	import="weaver.general.Util,weaver.general.GCONST,weaver.file.Prop,weaver.docs.category.security.AclManager,weaver.docs.category.CategoryTree,weaver.docs.category.CommonCategory"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="MenuCenterCominfo" class="weaver.page.menu.MenuCenterCominfo" scope="page"/>
<%@ page import="weaver.systeminfo.menuconfig.*" %>
<%
	String menutype = Util.null2String(request.getParameter("menutype"));
	
	//String type = Util.null2String(request.getParameter("type"));
	String id = Util.null2String(request.getParameter("menuId"));
	Prop prop = Prop.getInstance();
	String hasOvertime = Util.null2String(prop.getPropValue(GCONST.getConfigFile(), "ecology.overtime"));
	String hasChangStatus = Util.null2String(prop.getPropValue(GCONST.getConfigFile(), "ecology.changestatus"));
	//add by zouyj
	String type = Util.null2String(request.getParameter("type"));// top left 
    int resourceId = Util.getIntValue(request.getParameter("resourceId"));
    String resourceType =  request.getParameter("resourceType");
	// add end
	 String infoId=Util.null2String(request.getParameter("infoId"));
    MenuMaint  mm=new MenuMaint(type,Util.getIntValue(resourceType),resourceId,user.getLanguage());
    MenuInfoBean info = mm.getMenuInfoBean(infoId);
    //选中的目录信息
    String selectArr = "";
    //模块
    String _fromModule="1";
    //菜单类型
    String _selectType="";
    //最新文档默认显示方式
    String _displayUsage="";
    if(info!=null){
        selectArr=info.getSelectedContent();
        _fromModule=info.getFromModule()+"";
        _selectType=info.getMenuType()+"";
        _displayUsage=info.getDisplayUsage()+"";
    }
%>
<HTML>
	<HEAD>
		<LINK REL=stylesheet type="text/css" HREF="/css/Weaver_wev8.css">
		<%if(!id.equals("weavertabs-sys")){%>
		<LINK REL=stylesheet type="text/css" HREF="/js/jquery/plugins/weavertabs/weavertabs_wev8.css"> 
		<%}%>
		<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
		<SCRIPT type="text/javascript"
			src="/js/jquery/plugins/weavertabs/jquery.weavertabs_wev8.js"></script>
			<!-- for zTree -->
         <link rel="stylesheet"
             href="/wui/common/jquery/plugin/zTree3.5/css/zTreeStyle/CustomResourcezTreeStyle_wev8.css"
             type="text/css"> 
         <script type="text/javascript"
             src="/wui/common/jquery/plugin/zTree3.5/js/jquery.ztree.core.min_wev8.js"></script>
        <!-- for scrollbar -->
            <link rel="stylesheet" type="text/css"
                href="/wui/theme/ecology8/page/perfect-scrollbar/perfect-scrollbar_wev8.css" />
            <script type="text/javascript"
                src="/wui/theme/ecology8/page/perfect-scrollbar/perfect-scrollbar_wev8.js"></script>
            <script type="text/javascript"
                src="/wui/theme/ecology8/page/perfect-scrollbar/jquery.mousewheel_wev8.js"></script>
		<script type="text/javascript">
			function weaverTabsData(id)
			{
				$("#"+id).show();
				var content = $("#"+id).html();
				content = content.replace(/(^\s*)|(\s*$)/g, "");
				if(content=="")
				{
					$("#"+id).html("<img src=/images/loading2_wev8.gif>&nbsp;<%=SystemEnv.getHtmlLabelName(19819, user.getLanguage())%>...");
					$.post("/homepage/maint/LoginPageOperation.jsp", { id:id,menuId:'<%=id %>', menutype: '<%=menutype %>'},function(data){
					    	data = data.replace(/(^\s*)|(\s*$)/g, "");
					    	$("#"+id).show();
					    	$("#"+id).html(data);
					    	$("#"+id+" ul a").each(function(i,n)
							{
								var hrefhead = location.protocol+"//"+location.host;
								var ohref = this.href;
								//alert(this.href)
								if(ohref.charAt(ohref.length-1)=="#"){
									//ohref="#";
								}
								if(ohref!=""&&ohref!="#"&&ohref.indexOf("javascript:void")==-1)
								{
									if(ohref.indexOf(hrefhead)==0)
									{
										ohref = ohref.substring(hrefhead.length, ohref.length);
									}
									this.onclick=function () {return returnUrl(ohref , this.innerHTML);};
									this.href="#";
									this.target="";
								}
							});
							
							$(".weavertabs-content").find("ul:first").attr("id","test")
							$("#test>li").prepend("<em></em>");
					});
				}
			}
		</script>
	</HEAD>
	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	<%
		RCMenu += "{" + SystemEnv.getHtmlLabelName(826, user.getLanguage()) + ",javascript:getCustomModuleUrl(),_self} ";
		RCMenuHeight += RCMenuHeightStep;
		RCMenu += "{" + SystemEnv.getHtmlLabelName(201, user.getLanguage()) + ",javascript:window.parent.close(),_self} ";
		RCMenuHeight += RCMenuHeightStep;
		RCMenu += "{" + SystemEnv.getHtmlLabelName(311, user.getLanguage()) + ",javascript:btnclear_onclick(),_self} ";
		RCMenuHeight += RCMenuHeightStep;
		
		
	%>
	<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
	<BODY>
	<input type="hidden" id="selectArr" value="<%=selectArr%>"/>
    <input type="hidden" id="_fromModule" value="<%=_fromModule%>"/>
    <input type="hidden" id="_selectType" value="<%=_selectType%>"/>
    <input type="hidden" id="_displayUsage" value="<%=_displayUsage%>"/>
	<table id="topTitle" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td width="160px">
					</td>
					<td class="rightSearchSpan"
						style="text-align: right;">
					
						<input type="button" value="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%>" id="zd_btn_submit_0" class="e8_btn_top" onclick="getCustomModuleUrl()">	
						<input type="button" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" id="zd_btn_submit_0" class="e8_btn_top" onclick="window.parent.close()">		
						<input type="button" value="<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" id="zd_btn_submit_0" class="e8_btn_top" onclick="btnclear_onclick()">					
						&nbsp;&nbsp;&nbsp;
						<span title="<%=SystemEnv.getHtmlLabelName(83721,user.getLanguage())%>" class="cornerMenu"></span>
					</td>
				</tr>
			</table>
		<%
		if("2".equals(menutype)){
		%>
		<div class="weavertabs">
			<!-- <table class="weavertabs-nav" border="0" cellspacing="0"
				cellpadding="0">
				<tr>
					<td target="weavertabs-left" onclick="weaverTabsData('weavertabs-left');">
						<%=SystemEnv.getHtmlLabelName(17596, user.getLanguage())%>
					</td>
					<td target="weavertabs-top" onclick="weaverTabsData('weavertabs-top');">
						<%=SystemEnv.getHtmlLabelName(20611, user.getLanguage())%>
					</td>
					<td target="weavertabs-hpmenus" onclick="weaverTabsData('weavertabs-hpmenus');">
						<%=SystemEnv.getHtmlLabelName(23093, user.getLanguage())%>
					</td>
					<td target="weavertabs-cus" onclick="weaverTabsData('weavertabs-cus');">
						<%=SystemEnv.getHtmlLabelName(18773, user.getLanguage())%>
					</td>
					<td target="weavertabs-hp" onclick="weaverTabsData('weavertabs-hp');">
						<%=SystemEnv.getHtmlLabelName(23094, user.getLanguage())%>
					</td>
					<td target="weavertabs-sys" onclick="weaverTabsData('weavertabs-sys');">
						<%=SystemEnv.getHtmlLabelName(31560, user.getLanguage())%>
					</td>
				</tr>
			</table> 
			-->
			 <div id="menu_content" style="overflow:hidden;height:500px;padding-left:20px;position:relative;display:none;">
                <ul id="menutree" class="ztree"  style="overflow: hidden;"></ul>
              </div>  
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
					<FORM style="MARGIN-TOP: 0px" name=frmmain method=post action="/systeminfo/menuconfig/MenuMaintenanceOperation.jsp" enctype="multipart/form-data">
					
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
                                                    onClick="onChangeModule(this);" <%if(Util.getIntValue(_fromModule)==1){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(58, user.getLanguage())%>
                                                <input type="radio" name="customModule" value="2"
                                                    onClick="onChangeModule(this);" <%if(Util.getIntValue(_fromModule)==2){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(18015, user.getLanguage())%>
                                                <input type="radio" name="customModule" value="3"
                                                    onClick="onChangeModule(this);" <%if(Util.getIntValue(_fromModule)==3){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(136, user.getLanguage())%>
                                                <input type="radio" name="customModule" value="4"
                                                    onClick="onChangeModule(this);" <%if(Util.getIntValue(_fromModule)==4){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(101, user.getLanguage())%>
											</td>
										</tr>
										<TR style="height:1px;">
											<TD class=Line colSpan=2></TD>
										</TR>

										<%-- 菜单类型 --%>
										<tr>
											<td><%=SystemEnv.getHtmlLabelName(19054, user.getLanguage())%></td>
											<td class=Field>
												<select name="customType_1" style=""
													onChange="onChangeModuleType(this);">
													 <option value="1" <%if(Util.getIntValue(_fromModule)==1&&Util.getIntValue(_selectType)==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1986, user.getLanguage())%></option>
                                                    <option value="2" <%if(Util.getIntValue(_fromModule)==1&&Util.getIntValue(_selectType)==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1212, user.getLanguage())%></option>
                                                    <option value="3" <%if(Util.getIntValue(_fromModule)==1&&Util.getIntValue(_selectType)==3){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(16397, user.getLanguage())%></option>
                                                    <option value="4" <%if(Util.getIntValue(_fromModule)==1&&Util.getIntValue(_selectType)==4){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(16398, user.getLanguage())%></option>
												</select>
												<select name="customType_2" id="customType_2" style="display: none"
													onChange="onChangeModuleType(this);">
													 <option value="1" <%if(Util.getIntValue(_fromModule)==2&&Util.getIntValue(_selectType)==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(16392, user.getLanguage())%></option>
                                                    <option value="2" <%if(Util.getIntValue(_fromModule)==2&&Util.getIntValue(_selectType)==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1207, user.getLanguage())%></option>
                                                    <option value="3" <%if(Util.getIntValue(_fromModule)==2&&Util.getIntValue(_selectType)==3){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(17991, user.getLanguage())%></option>
                                                    <option value="4" <%if(Util.getIntValue(_fromModule)==2&&Util.getIntValue(_selectType)==4){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(17992, user.getLanguage())%></option>
                                                    <option value="6" <%if(Util.getIntValue(_fromModule)==2&&Util.getIntValue(_selectType)==6){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(21639, user.getLanguage())%></option>
                                                    <option value="7" <%if(Util.getIntValue(_fromModule)==2&&Util.getIntValue(_selectType)==7){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(21640, user.getLanguage())%></option>
													<%
														if (!"".equals(hasOvertime))
														{
													%>
													 <option value="8" <%if(Util.getIntValue(_fromModule)==2&&Util.getIntValue(_selectType)==8){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(21641, user.getLanguage())%></option>
													<%
														}
													%>
													<%
														if (!"".equals(hasChangStatus))
														{
													%>
													<option value="9" <%if(Util.getIntValue(_fromModule)==2&&Util.getIntValue(_selectType)==9){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(21643, user.getLanguage())%></option>
													<%
														}
													%>
													<option value="5" <%if(Util.getIntValue(_fromModule)==2&&Util.getIntValue(_selectType)==5){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1210, user.getLanguage())%></option>
												</select>
												<select name="customType_3" style="display: none"
													onChange="onChangeModuleType(this);">
													 <option value="1" <%if(Util.getIntValue(_fromModule)==3&&Util.getIntValue(_selectType)==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15006, user.getLanguage())%></option>
												</select>
												<select name="customType_4" style="display: none"
													onChange="onChangeModuleType(this);">
													 <option value="1" <%if(Util.getIntValue(_fromModule)==4&&Util.getIntValue(_selectType)==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15007, user.getLanguage())%></option>
                                                    <option value="2" <%if(Util.getIntValue(_fromModule)==4&&Util.getIntValue(_selectType)==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(16408, user.getLanguage())%></option>
                                                    <option value="3" <%if(Util.getIntValue(_fromModule)==4&&Util.getIntValue(_selectType)==3){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(16409, user.getLanguage())%></option>
                                                    <option value="4" <%if(Util.getIntValue(_fromModule)==4&&Util.getIntValue(_selectType)==4){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(16410, user.getLanguage())%></option>
                                                    <option value="5" <%if(Util.getIntValue(_fromModule)==4&&Util.getIntValue(_selectType)==5){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(16411, user.getLanguage())%></option>
                                                    <option value="6" <%if(Util.getIntValue(_fromModule)==4&&Util.getIntValue(_selectType)==6){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(16412, user.getLanguage())%></option>
												</select>
											</td>
										</tr>
										<TR style="height:1px;">
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
		<wea:layout >
		
	    
			  <wea:group context="<%=SystemEnv.getHtmlLabelName(23034,user.getLanguage())%>" >
				<wea:item >
									
							<TABLE ID=BrowseTable class=BroswerStyle cellspacing="1" style="width:100%;margin-bottom: 50px"
								cellpadding="0">
								<TR class=DataHeader>
									<TH width=0% style="display: none"><%=SystemEnv.getHtmlLabelName(84, user.getLanguage())%></TH>
									<TH>
										<%=SystemEnv.getHtmlLabelName(195, user.getLanguage())%></TH>
									<TH>
										<%=SystemEnv.getHtmlLabelName(433, user.getLanguage())%></TH>
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
										 "where creatortype = 0 and isuse=1"+
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
										 "where creatortype = 0 and isuse=1"+
										 "  and subcompanyid = -1 "+
										 "  and infoname is not null "+
										 "order by subcompanyid asc, id asc";
							
									}
									rs.executeSql(sql);
									int i=0;
									while (rs.next())
									{
										i++;
										String pid = rs.getString("id");
										String infoname = rs.getString("infoname");
										String infodesc = rs.getString("infodesc");
										index++;
									%>
								<TR <%if((i+1)%2==0) out.println(" class='DataDark' "); else out.println(" class='DataLight' ");%>>
									<TD style="display: none"><A HREF=#><%=pid%></A></TD>
									<TD valign="middle" style="padding-left: 12px;" width="15%">
										<%=infoname%>
									</TD>
									<TD valign="middle" style="padding-left: 12px;" width="40%"><%=infodesc%></TD>
								</TR>
								<%
										}
								
								%>
							</TABLE>
			  </wea:item>
	       </wea:group>
	   </wea:layout>
		
		<%
		}
		%>
	</BODY>
</HTML>
<script LANGUAGE="JavaScript">

$(document).ready(function () {
	if("<%=id%>"=="weavertabs-sys"){
		//getData("adddoc");
        var menuModule = eval("frmmain.customModule");
		for(var i=0;menuModule!=null&&i<menuModule.length;i++){
		    if(menuModule[i].value=="<%=_fromModule%>"){
		        onChangeModule(menuModule[i]);
		        break;
		    }
		}
		var menuModuleType = eval("frmmain.customType_<%=_fromModule%>");
		onChangeModuleType(menuModuleType);
	}
});

function getData(type)
{
	$("#divContent").css("display","block"); 
	$("#divContent").html("<img src=/images/loading2_wev8.gif>&nbsp;<%=SystemEnv.getHtmlLabelName(19819, user.getLanguage())%>...");
	
	var _isShow="";
     var _selectType=$("#_selectType").val();
    //文档
    var selectids="";
    if(type=="adddoc"||type=="mydoc"||type=="newdoc"||type=="doccategory"){
    
	   if(type=="adddoc"){
	        _isShow=1;
       }else if(type=="mydoc"){
            _isShow=2;
       }else if(type=="newdoc"){
            _isShow=3;
       }else if(type=="doccategory"){
            _isShow=4;
       }
       if(_isShow==_selectType){
	       var selectArr=$("#selectArr").val();
	        if(selectArr!=""){
	              selectArr=selectArr.split("C");
	              for(var i=0;i<selectArr.length;i++){
	                    var selectid=selectArr[i];
	                    if(selectid==""){
	                        continue;
	                    }else{
	                        selectids+=selectArr[i]+",";
	                    }
	              }
	        }
       }
    }
    $("#divContent").load("/systeminfo/menuconfig/MenuMaintenanceAddAdvancedGet.jsp?type="+type+"&selectids="+selectids,function(){
       //最新文档默认显示方式
       if(type=="newdoc"){
           var _displayUsage=$("#_displayUsage").val();
           $("input[name=displayUsage_3]").each(function(i,o){
                 var radioVal=$(this).val();
                 if(radioVal==_displayUsage){
                    $(this).attr("checked",true);
                 }
           });
       }
	   if(type=="adddoc"||type=="mydoc"||type=="newdoc"||type=="doccategory"){
            $('#ztreeObj li').each(function(){
                if($(this).find("div").hasClass('curSelectedNode')){
                    $(this).find("div").removeClass('curSelectedNode');
                }
                var aObj=$(this).find("div").find("a");
                if($(aObj).hasClass('curSelectedNode')){
                    $(aObj).removeClass('curSelectedNode');
                }
            });
       }
       if(type=="addwf"){
            _isShow=1;
       }else if(type=="waitdowf"){
            _isShow=2;
       }else if(type=="donewf"){
            _isShow=3;
       }else if(type=="alreadydowf"){
            _isShow=4;
       }else if(type=="mywf"){
            _isShow=5;
       }else if(type=="sendwf"){
            _isShow=6;
       }else if(type=="supervisewf"){
            _isShow=7;
       }else if(type=="overtimewf"){
            _isShow=8;
       }else if(type=="backwf"){
            _isShow=9;
       }
       //流程
       if(type=="addwf"||type=="waitdowf"||type=="donewf"||type=="alreadydowf"||type=="mywf"||type=="sendwf"||type=="supervisewf"||type=="overtimewf"||type=="backwf"){
        if(_isShow==_selectType){
             var selectArr=$("#selectArr").val();
	        if(selectArr!=""){
	              selectArr=selectArr.split("|");
	        }
	        $(":checkbox").each(function(i,o){
	              var evalue = $(this).val();
	              if(evalue.indexOf("workflow_NF_T")!=-1||evalue.indexOf("workflow_NF_W")!=-1||evalue.indexOf("workflow_NF_R")!=-1||evalue.indexOf("workflow_PM_T")!=-1||evalue.indexOf("workflow_PM_W")!=-1||evalue.indexOf("workflow_HM_T")!=-1||evalue.indexOf("workflow_HM_W")!=-1||evalue.indexOf("workflow_CM_T")!=-1||evalue.indexOf("workflow_CM_W")!=-1||evalue.indexOf("workflow_MR_T")!=-1||evalue.indexOf("workflow_MR_W")!=-1||evalue.indexOf("workflow_RM_T")!=-1||evalue.indexOf("workflow_RM_W")!=-1||evalue.indexOf("workflow_SM_T")!=-1||evalue.indexOf("workflow_SM_W")!=-1||evalue.indexOf("workflow_OM_T")!=-1||evalue.indexOf("workflow_OM_W")!=-1||evalue.indexOf("workflow_FM_T")!=-1||evalue.indexOf("workflow_FM_W")!=-1)
	              {
	                var addedStr = evalue.substring(12);
	                if (selectArr.indexOf(addedStr)!=-1)
	                {
	                    $(this).attr("checked",true);
	                } 
	              }
	        });
        
        }
       
      }
      //项目
      if(type=="addproject"){
	       if(type=="addproject"){
	            _isShow=1;
	       }
	       if(_isShow==_selectType){
	           var selectArr=$("#selectArr").val();
	            if(selectArr!=""){
	                  selectArr=selectArr.split("|");
	            }
	            $(":checkbox").each(function(i,o){
	                  var evalue = $(this).val();
	                  if(evalue.indexOf("project_P")!=-1)
	                  {
	                    var addedStr = evalue.substring(8);
	                    if (selectArr.indexOf(addedStr)!=-1)
	                    {
	                        $(this).attr("checked",true);
	                    } 
	                  }
	            });
	       
	       }
            
      }
    });
	
}

function onChangeModule(obj){
	for(var i=1;i<=4;i++){
		var typeObj = eval("frmmain.customType_"+i);
		
		if(typeObj!=null) {
			//typeObj.style.display = "none";
			$(typeObj).selectbox("hide")
			
		}
		
	}
	var currTypeObj = eval("frmmain.customType_"+obj.value);
	if(currTypeObj!=null){
		//currTypeObj.style.display = "block";
		$(currTypeObj).selectbox("show")
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
	var infoId = "";
	if(vcustomModule=="1")
	{
		if(vcustomType=="1")
		{			
			selectedContent=jQuery("#docdir_ND_m").val();		
			vlink = "/docs/docs/DocList.jsp?fromadvancedmenu=1&selectedContent="+selectedContent+"&infoId="+infoId;
		}
		else if(vcustomType=="2")
		{//我的文档
			selectedContent=jQuery("#docdir_ND_m").val();
			vlink = "/docs/search/DocView.jsp?fromadvancedmenu=1&selectedContent="+selectedContent+"&infoId="+infoId;
		}
		else if(vcustomType=="3")
		{//最新文档
			selectedContent=jQuery("#docdir_ND_m").val();
			$.each(checkDisplay, function(i, o){
				if(o.name == "displayUsage_3") {
					selectDisplay = o.value;
				}
			});
			vlink = "/docs/search/DocSearchTemp.jsp?fromadvancedmenu=1&list=all&isNew=yes&loginType=1&containreply=1&displayUsage="+selectDisplay+"&selectedContent="+selectedContent+"&infoId="+infoId;
		}
		else if(vcustomType=="4")
		{//最新文档
			selectedContent=jQuery("#docdir_ND_m").val();
			vlink = "/docs/search/DocSummary.jsp?fromadvancedmenu=1&selectedContent="+selectedContent+"&infoId="+infoId;
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
			vlink = "/workflow/request/RequestType.jsp?fromadvancedmenu=1&menuType=1&selectedContent="+selectedContent+"&infoId="+infoId;
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
			
			vlink = "/workflow/request/RequestView.jsp?fromadvancedmenu=1&menuType=2&selectedContent="+selectedContent+"&infoId="+infoId;
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
			vlink = "/workflow/request/RequestHandled.jsp?fromadvancedmenu=1&menuType=3&selectedContent="+selectedContent+"&infoId="+infoId;
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
			vlink = "/workflow/request/RequestComplete.jsp?fromadvancedmenu=1&menuType=4&selectedContent="+selectedContent+"&infoId="+infoId;
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
			vlink = "/workflow/request/MyRequestView.jsp?fromadvancedmenu=1&menuType=5&selectedContent="+selectedContent+"&infoId="+infoId;
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
			vlink = "/workflow/search/WFSearchCustom.jsp?fromadvancedmenu=1&menuType=6&selectedContent="+selectedContent+"&infoId="+infoId;
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
			vlink = "/workflow/search/WFSearchCustom.jsp?fromadvancedmenu=1&menuType=7&selectedContent="+selectedContent+"&infoId="+infoId;
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
			vlink = "/workflow/search/WFSearchCustom.jsp?fromadvancedmenu=1&menuType=8&selectedContent="+selectedContent+"&infoId="+infoId;
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
			vlink = "/workflow/search/WFSearchCustom.jsp?fromadvancedmenu=1&menuType=9&selectedContent="+selectedContent+"&infoId="+infoId;
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
			vlink = "/proj/Templet/ProjTempletSele.jsp?fromadvancedmenu=1&selectedContent="+selectedContent+"&infoId="+infoId;
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
	//alert(vlink)
	returnUrl(vlink,vlink,selectedContent,vcustomModule,vcustomType);
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
	 if("<%=id%>"=="weavertabs-cus-old"||"<%=id%>"=="weavertabs-hp-old"){
		$(".weavertabs").weavertabs();
		weaverTabsData("<%=id%>");
		$("ul a").each(function(i,n)
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
	 }
	});
</script>
<%} %>

<script type="text/javascript">
  var parentWin = parent.parent.parent.getParentWindow(parent.parent);
  var dialog = parent.parent.parent.getDialog(parent.parent);
 
	
 </script>
 
 
<SCRIPT type="text/javascript">


function btnclear_onclick(){
      if(dialog){
	    	 dialog.callback({id:"",name:""});
		 }else{  
			    window.parent.returnValue = {id:"",name:""};
				//window.parent.close();
		  }
}
<%
if("2".equals(menutype))
{
%>
function returnUrl(o,v,selContent,vcustomModule,vcustomType){
	var retJson = {id:o,name:v,sel:selContent,module:vcustomModule,ctype:vcustomType};

	if(dialog){
	   try{
          dialog.callback(retJson);
     }catch(e)
     {console.log(e)}
	}else{  
	  window.parent.returnValue = retJson;
		window.parent.close();
	}
}
<%}%>
<%
if("1".equals(menutype))
{
%>
try{
		parentWin = parent.parent.getParentWindow(parent);
		dialog = top.getDialog(parent);
	}catch(e){}
	
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
   	var curTr=jQuery(target).parents("tr")[0];
	      
	      if(dialog){
	    	 dialog.callback({id:"/homepage/LoginHomepage.jsp?hpid="+jQuery(curTr.cells[0]).text(),name:jQuery(curTr.cells[1]).text()});
		 }else{  
			    window.parent.returnValue = {id:jQuery(curTr.cells[0]).text(),name:jQuery(curTr.cells[1]).text()};
				window.parent.close();
		  }
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
<script type="text/javascript">
    $(document).ready(function(){
        if("<%=id%>"=="weavertabs-left"||"<%=id%>"=="weavertabs-top"||"<%=id%>"=="weavertabs-hp"||"<%=id%>"=="weavertabs-cus"){
            jQuery('#menu_content').show();
            jQuery('#weavertabs-content').hide();
        }
    });
    
    function menuOnAsyncSuccess(event, treeId, treeNode, msg) {
        var zTree = $.fn.zTree.getZTreeObj(treeId);
        var nodes; 
        if(treeNode){
            nodes = treeNode.children;
        }
        jQuery('#menu_content').height(document.body.clientHeight-35);
        jQuery('#menu_content').perfectScrollbar('update');
    }
    
    /**
     * 获取url（alax方式获得子节点时使用）
     */
    function getAsyncUrl(treeId, treeNode) {
        //获取子节点时
        if (treeNode != undefined && treeNode.isParent != undefined && treeNode.isParent != null) {
            return "/page/maint/menu/SystemMenuMaintListJSON.jsp?type=<%=type%>&resourceType=<%=resourceType%>&resourceId=<%=resourceId%>&parentid="+treeNode.id+"&mode=visible&e=" + new Date().getTime();
        } else {
            //初始化时
            //alert("/page/maint/menu/SystemMenuMaintListJSON.jsp?type=<%=type%>&resourceType=<%=resourceType%>&resourceId=<%=resourceId%>&parentid=0&mode=visible&e=" + new Date().getTime())
            return "/page/maint/menu/SystemMenuMaintListJSON.jsp?type=<%=type%>&resourceType=<%=resourceType%>&resourceId=<%=resourceId%>&parentid=0&mode=visible&e=" + new Date().getTime();
        }
    };
    //获取菜单的url地址
    function getMenuUrl(event,treeId,treeNode){
        if(treeNode.linkAddress!=null&&treeNode.linkAddress!=""&&treeNode.linkAddress!="javascript:void(0);"){
            return returnUrl(treeNode.linkAddress , treeNode.name);
        }else{
            Dialog.alert("当前菜单没有设置链接地址!");
        }
    }
    //zTree配置信息
    var setting = {
        async: {
            enable: true,       //启用异步加载
            dataType: "text",   //ajax数据类型
            url: getAsyncUrl    //ajax的url
        },
        data: {
            keep: {
                parent: true,
                leaf: true
            }
        },
        callback: {
           onAsyncSuccess: menuOnAsyncSuccess,
           onClick: getMenuUrl
        },
        view: {
            showLine: false,
            showIcon: false,
            selectedMulti: false,
            showTitle:false
        }
    };
	//系统门户页面setting配置
    var setting_hp = {
        async: {
            enable: true,       //启用异步加载
            dataType: "text",   //ajax数据类型
            url: getAsyncUrl_hp    //ajax的url
        },
        data: {
            keep: {
                parent: true,
                leaf: true
            }
        },
        callback: {
           onAsyncSuccess: menuOnAsyncSuccess,
           onClick: getMenuUrl
        },
        view: {
            showLine: false,
            showIcon: false,
            selectedMulti: false,
            showTitle:false
        }
    };
     /**
     * 获取url（alax方式获得子节点时使用）
     */
    function getAsyncUrl_hp(treeId, treeNode) {
        //获取子节点时
        if (treeNode != undefined && treeNode.isParent != undefined && treeNode.isParent != null) {
            return "/homepage/maint/LoginPageOperation.jsp?id=<%=id%>&parentid="+treeNode.id;
        } else {
            //初始化时
            return "/homepage/maint/LoginPageOperation.jsp?id=<%=id%>&parentid=0";
        }
    };
    //自定义菜单setting配置
     var setting_cus = {
        async: {
            enable: true,       //启用异步加载
            dataType: "text",   //ajax数据类型
            url: getAsyncUrl_cus    //ajax的url
        },
        data: {
            keep: {
                parent: true,
                leaf: true
            }
        },
        callback: {
           onAsyncSuccess: menuOnAsyncSuccess,
           onClick: getMenuUrl
        },
        view: {
            showLine: false,
            showIcon: false,
            selectedMulti: false,
            showTitle:false
        }
    };
     /**
     * 获取url（alax方式获得子节点时使用）
     */
    function getAsyncUrl_cus(treeId, treeNode) {
        //获取子节点时
        if (treeNode != undefined && treeNode.isParent != undefined && treeNode.isParent != null) {
            return "/homepage/maint/LoginPageOperation.jsp?id=<%=id%>&parentid="+treeNode.id+"&menu_type="+treeNode.menu_type;
        } else {
            //初始化时
            //alert("/page/maint/menu/SystemMenuMaintListJSON.jsp?type=<%=type%>&resourceType=<%=resourceType%>&resourceId=<%=resourceId%>&parentid=0&mode=visible&e=" + new Date().getTime())
            return "/homepage/maint/LoginPageOperation.jsp?id=<%=id%>&parentid=0";
        }
    };

    var zNodes =[];
    $(document).ready(function(){
        if("<%=id%>"=="weavertabs-left"||"<%=id%>"=="weavertabs-top"){
	         //初始化zTree
	        $.fn.zTree.init($("#menutree"), setting, zNodes);
	        jQuery('#menu_content').perfectScrollbar();
        }
		if("<%=id%>"=="weavertabs-hp"){
             //初始化zTree
            $.fn.zTree.init($("#menutree"), setting_hp, zNodes);
            jQuery('#menu_content').perfectScrollbar();
        }
         if("<%=id%>"=="weavertabs-cus"){
             //初始化zTree
            $.fn.zTree.init($("#menutree"), setting_cus, zNodes);
            jQuery('#menu_content').perfectScrollbar();
        }
    });
    </script>
<style>
	.ulDiv2{
	min-height: 708px;
	}
	.ztreeUlDiv{
		height: 100%!important;
	}
	#overFlowDivTree{
		overflow: auto!important;
		height: 100%!important;
		
	}
	.weavertabs-content{
		margin-top:10px;
		margin-left:10px;
	}
	ul{
		padding:left:10px;
		list-style: none outside none;
		font-size:12px;
	}
	li{
		padding-left:20px;
	}
	em { display:block;  border:4px solid; border-color:#fff #fff #fff #bbbbbb; float:left; margin-top:5px}
	
	.ztree li a.curSelectedNode {
     background-color: rgb(255, 255, 255)!important;
    }
    .ztree li a.curSelectedNode{
        color: #0D93F6!important;
    }
    .ztree li span.button.noline_close {
     background-position: 0 -38px !important;
    }
    .ztree li span.button.noline_docu {
      background-position: 0 -55px !important;
    }
    .ztree li span.button.noline_open {
      background-position: 0 -55px !important;
    }
    .ztree li span.button.switch {
    width: 18px;
    height: 18px;
    }
	.ztree li span.button {
	    line-height: 0;
	    margin: 0;
	    width: 16px;
	    height: 16px;
	    display: inline-block;
	    vertical-align: middle;
	    border: 0 none;
	    cursor: pointer;
	    outline: none;
	    background-color: transparent;
	    background-repeat: no-repeat;
	    background-attachment: scroll;
	    background-image: url(/wui/common/jquery/plugin/zTree3.5/css/zTreeStyle/img/newzTreeStandard_wev8.png) !important;
	}
	
</style>