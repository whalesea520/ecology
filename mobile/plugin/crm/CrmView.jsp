
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@page import="weaver.hrm.resource.ResourceComInfo"%>
<%@page import="weaver.general.GCONST"%>
<%@page import="java.io.File"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SectorInfoComInfo" class="weaver.crm.Maint.SectorInfoComInfo" scope="page" />
<jsp:useBean id="CustomerDescComInfo" class="weaver.crm.Maint.CustomerDescComInfo" scope="page" />
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page"/>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<meta name="author" content="Weaver E-Mobile Dev Group" />
	<meta name="description" content="Weaver E-mobile" />
	<meta name="keywords" content="weaver,e-mobile" />
	<meta name="viewport" content="width=device-width,minimum-scale=1.0, maximum-scale=1.0" />
	<title></title>
	<script type='text/javascript' src='/js/jquery/jquery_wev8.js'></script>
	<link rel="stylesheet" href="/wui/common/css/w7OVFont_wev8.css" type="text/css">
	<link rel="stylesheet" href="/mobile/plugin/1/css/r4_wev8.css" type="text/css">
	<link rel="stylesheet" href="/mobile/plugin/crm/css/crm_wev8.css" type="text/css">
	<script language="javascript" src="https://webapi.amap.com/maps?v=1.3&key=53a92850ca00d7f77aef3297effd8d59"></script>
<body>
	<%
		String clienttype = Util.null2String((String)request.getParameter("clienttype"));
		String clientlevel = Util.null2String((String)request.getParameter("clientlevel"));
		String module=Util.null2String((String)request.getParameter("module"));
		String scope=Util.null2String((String)request.getParameter("scope"));
		String opengps = "1";//Util.null2String((String)request.getParameter("opengps"));
		//标记是从微搜模块进入start
		String fromES=Util.null2String((String)request.getParameter("fromES"));
		//标记是从微搜模块进入end
		String customerid=Util.null2String((String)request.getParameter("customerid"));
		RecordSet.executeProc("CRM_CustomerInfo_SelectByID",customerid);
		RecordSet.next();
	%>
	<div id="header"  style="<%if (clienttype.equals("Webclient")) {%>display:block;<%} else {%>display:none;<%}%>">
					<table style="width: 100%; height: 40px;">
						<tr>
							<td width="10%" align="left" valign="middle" style="padding-left:5px;">
									<a href="javascript:void(0)" onclick="doLeftButton()">
										<div style="width:56px;height:26px;background:url('/images/bg-top-btn_wev8.png') no-repeat;text-align:center;line-height:26px;color:#000;font-size: 14px">
											 返回
										</div>
									</a>
							</td>
							<td align="center" valign="middle">
								<div id="title" ><%=Util.getMoreStr(RecordSet.getString("name"), 5, "..")%></div>
							</td>
							<td width="10%" align="right" valign="middle" style="padding-right:5px;">
									
							</td>
						</tr>
					</table>
	</div>
	
	<div id="loading"><%=SystemEnv.getHtmlLabelName(30665,user.getLanguage()) %>...</div>
	<div id="loadingmask" ></div>
	
	<table  style='width:100%;border:0;cellspacing:0;cellpadding:0;table-layout:fixed;margin-top: 8px;'>
     <tr>
    	<td class='itempreview'></td>
    	<td class='itemcontent' >
		<div class="blockHead">
			<span class="m-l-14">客户信息</span>
		</div>
		<div class="tblBlock" style="width: 100%; background: #fff;" id="mainforminfoDiv">
		  <table id="head" cellspacing="0" cellpadding="0" width="100%" class="mainFormTable">
			<tr>
				<td class="mainFormRowNameTD" align="left">
					客户名称
				</td>
				<td style="width:15px;"></td>
				<td width="*" class="mainFormRowValueTD">
					<%=Util.toScreen(RecordSet.getString("name"),user.getLanguage())%>
				</td>
			</tr>	
			<tr width="100%"><td colspan="3" class="mainFromSplitLine"></td></tr>
			<tr>
				<td class="mainFormRowNameTD" align="left">
					地址
				</td>
				<td style="width:15px;"></td>
				<td width="*" class="mainFormRowValueTD">
					<%=Util.toScreen(RecordSet.getString("address1"),user.getLanguage())%>
				</td>
			</tr>	
			<tr width="100%"><td colspan="3" class="mainFromSplitLine"></td></tr>
			<tr>
				<td class="mainFormRowNameTD" align="left">
					电话
				</td>
				<td style="width:15px;"></td>
				<td width="*" class="mainFormRowValueTD">
					<a href="tel:<%=RecordSet.getString("phone")%>"><%=RecordSet.getString("phone")%></a>
				</td>
			</tr>	
			<tr width="100%"><td colspan="3" class="mainFromSplitLine"></td></tr>
			<tr>
				<td class="mainFormRowNameTD" align="left">
					传真
				</td>
				<td style="width:15px;"></td>
				<td width="*" class="mainFormRowValueTD">
					<%=RecordSet.getString("fax")%>
				</td>
			</tr>	
			<tr width="100%"><td colspan="3" class="mainFromSplitLine"></td></tr>
			<tr>
				<td class="mainFormRowNameTD" align="left">
					电子邮件
				</td>
				<td style="width:15px;"></td>
				<td width="*" class="mainFormRowValueTD">
					<a href="mailto::<%=RecordSet.getString("email")%>"><%=RecordSet.getString("email")%></a>
				</td>
			</tr>	
			<tr width="100%"><td colspan="3" class="mainFromSplitLine"></td></tr>
											
		</table>
	</div>
   	<div style="height:10px;overflow:hidden;"></div>
   	<div class="blockHead">
		<span class="m-l-14">客户分类</span>
	</div>
	<div class="tblBlock" style="width: 100%; background: #fff;" id="mainforminfoDiv">
		<table id="head" cellspacing="0" cellpadding="0" width="100%" class="mainFormTable">
			<tr>
				<td class="mainFormRowNameTD" align="left">
					类型
				</td>
				<td style="width:15px;"></td>
				<td width="*" class="mainFormRowValueTD">
					 <%=Util.toScreen(CustomerTypeComInfo.getCustomerTypename(RecordSet.getString("type")),user.getLanguage())%>
				</td>
			</tr>	
			<tr width="100%"><td colspan="3" class="mainFromSplitLine"></td></tr>
			<tr>
				<td class="mainFormRowNameTD" align="left">
					描述
				</td>
				<td style="width:15px;"></td>
				<td width="*" class="mainFormRowValueTD">
					<%=Util.toScreen(CustomerDescComInfo.getCustomerDescname(RecordSet.getString("description")),user.getLanguage())%>
				</td>
			</tr>	
			<tr width="100%"><td colspan="3" class="mainFromSplitLine"></td></tr>
			<tr>
				<td class="mainFormRowNameTD" align="left">
					行业
				</td>
				<td style="width:15px;"></td>
				<td width="*" class="mainFormRowValueTD">
					<%
				          String seclist = "";
				          String tmpsecid = RecordSet.getString("sector");
				          String tmpparid = SectorInfoComInfo.getSectorInfoParentid(tmpsecid);
				         while(!tmpsecid.equals("0")&&!tmpparid.equals("")){
				         	if(seclist.equals(""))
				         		seclist = SectorInfoComInfo.getSectorInfoname(tmpsecid) + seclist;
				         	else
				         		seclist = SectorInfoComInfo.getSectorInfoname(tmpsecid) +"->"+ seclist;
				
				          tmpsecid = tmpparid;
				          tmpparid = SectorInfoComInfo.getSectorInfoParentid(tmpsecid);
				         }
         			 %>
         			 <%=seclist%>
				</td>
			</tr>	
			<tr width="100%"><td colspan="3" class="mainFromSplitLine"></td></tr>
			<tr>
				<td class="mainFormRowNameTD" align="left">
					客户经理
				</td>
				<td style="width:15px;"></td>
				<td width="*" class="mainFormRowValueTD">
					<%=Util.toScreen(ResourceComInfo.getResourcename(RecordSet.getString("manager")),user.getLanguage())%>
				</td>
			</tr>	
			<tr width="100%"><td colspan="3" class="mainFromSplitLine"></td></tr>
			
											
		</table>
	</div>
   
   	<div style="height:10px;overflow:hidden;"></div>
   	<div class="blockHead">
		<span class="m-l-14">联系人信息</span>
	</div>
	<div class="tblBlock" style="width: 100%; background: #fff;" id="mainforminfoDiv">
		<table id="head" cellspacing="0" cellpadding="0" width="100%" class="mainFormTable">
			<%
				rs.execute("SELECT id AS contacterid,customerid,fullname,firstname,mobilephone,title,JobTitle from CRM_CustomerContacter where customerid="+customerid+" order by id");
				while(rs.next()){
					String title=rs.getString("title");
					String titleName="";
					RecordSet2.execute("select fullname from CRM_ContacterTitle WHERE id="+title);
					if(RecordSet2.next())
						titleName=RecordSet2.getString("fullname");
			%>
				<tr>
					<td class="mainFormRowNameTD" align="left">
						<%=rs.getString("firstname")%>
					</td>
					<td style="width:15px;"></td>
					<td width="*" class="mainFormRowValueTD">
						<%=titleName%>&nbsp;&nbsp;<%=rs.getString("JobTitle")%>&nbsp;&nbsp;<a href="tel:<%=rs.getString("mobilephone")%>"><%=rs.getString("mobilephone")%></a>
					</td>
				</tr>	
				<tr width="100%"><td colspan="3" class="mainFromSplitLine"></td></tr>
			<%}%>											
		</table>
	</div>
	
	<div style="height:10px;overflow:hidden;"></div>
	<div style="margin-bottom: 15px;">
	    
	    <%if(!clienttype.equals("Webclient")){%>
	    <div>
	   		<div class="operationBtright" style="width: 80px;float: left;margin-right: 0px;" onclick="doSave(this,1)">签到</div>
	   		<div class="operationBtright" style="width: 80px;float: right;margin-right: 0px;" onclick="doSave(this,2)">签退</div>
			<div style="clear: left;"></div>
		</div>
		<%}%>
	    <div style="margin-top: 8px;">
	   		<div class="operationBtright" style="width: 80px;float: left;margin-right: 0px;" onclick="viewShare()">查看共享</div>
	   		<div class="operationBtright" style="width: 80px;float: right;margin-right: 0px;" onclick="addContact()">客户联系</div>
			<div style="clear: left;"></div>
		</div>
	</div>
	<div style="height:10px;overflow:hidden;"></div>
   </td>
   <td class='itemnavpoint'></td>
  </tr>
</table>
	
	
   <script type="text/javascript">
   		function viewShare(){
   			var url = "/mobile/plugin/crm/CrmAddShare.jsp?isInternal=1&customerid=<%=customerid%>&module=<%=module%>&opengps=<%=opengps%>&scope=<%=scope%>&t="+Math.random();
   			window.location.href=url;
   		}
   		
   		//当用户点击标题上左边或右边按钮时，客户端会调用页面上的javascript方法:
		function doLeftButton() {
			var fromES="<%=fromES%>";
			if(fromES=="true"){
				 location = "/mobile/plugin/fullsearch/list.jsp?module=<%=module%>&scope=<%=scope%>&fromES=true";
			}else{
				window.location.href="/mobile/plugin/crm/CrmMain.jsp?module=<%=module%>&scope=<%=scope%>&opengps=<%=opengps%>";
			}
			return "1";
		}
		
		function getLeftButton(){ 
			return "1,<%=SystemEnv.getHtmlLabelName(1290,user.getLanguage()) %>";
		}
		
		var clienttype="<%=clienttype%>";
		var opengps="<%=opengps%>";
		var signtype="1";
		var thisBtn;
		var issign=false;
		
		function doSave(obj,type){
		
			     if(issign) return ; //正在签到
			     thisBtn=obj;
			     
				if(opengps=="0"){
					alert("请在mobile后台开启GPS");
					return ;
				}
				
				signtype=type;
				if(!confirm("是否确定"+((signtype=="1"?"签到":"签退"))+"？"))
					return ;
				//$(obj).attr("disabled","true");
				if(opengps=="1"){
					//if(clienttype=="iPhone"||clienttype=="iPad"){
						location="emobile:gps:doSaveBlog";
					//}else
						//doSaveBlog("");
					
		    	}else
		    		doSaveBlog("");
		}
		
		function doSaveBlog(gps){
			//if((clienttype=="android"||clienttype=="androidpad")&&opengps=="1"){
			 // var isGpsEnable=mobileInterface.chekGpsEnable()
			//  if(isGpsEnable==-1)
			//	 return ;
		  	//}
		
			var locationGps="";
		 	//if(clienttype!="Webclient"&&opengps=="1"){
		   	// if(clienttype=="android"){
		   	//	 locationGps=mobileInterface.getLocation();
		   	// }else if(clienttype=="iPhone"||clienttype=="iPad"){
		   	//	 locationGps=gps;
		   	// }
		    //}	
			locationGps=gps;
			//locationGps="31.179544,121.481566";
			if(opengps=="1"&&clienttype!="Webclient"&&(locationGps=="0,0"||locationGps=="")){
				alert("无法获取地理位置");
				return ;
			}
			
			$(thisBtn).html("正在"+(signtype=="1"?"签到":"签退")+"...");
			issign=true;
			
			/*
			var x=locationGps.split(",")[1];
			var y=locationGps.split(",")[0];
			
			var point = new BMap.Point(x,y);
			
			var gc = new BMap.Geocoder();
			gc.getLocation(point, function(rs){
			    var addComp = rs.addressComponents;
			    var locationLabel=addComp.district +addComp.street +addComp.streetNumber;
			    saveLocation(locationLabel,locationGps);
			});
			*/
			var x=locationGps.split(",")[2];
			var y=locationGps.split(",")[1];
			
			var lnglatXY = new AMap.LngLat(x,y);
			AMap.service(["AMap.Geocoder"], function() {        
			    MGeocoder = new AMap.Geocoder({ 
			           radius: 1000,
			           extensions: "all"
			    });
		       //逆地理编码
		       MGeocoder.getAddress(lnglatXY, function(status, result){
		       	if(status === 'complete'){
		       		 var address = result.regeocode.formattedAddress;
		       		 saveLocation(address,x+","+y);
		       	}
		       });
		   });
			
		}
		
		function saveLocation(planName,gps){
			
			var now= new Date();
			var nowdate=now.pattern("yyyy-MM-dd");
			var nowtime=now.pattern("HH:mm");
			var description=planName;
			var title=(signtype=="1"?"签到:":"签退:")+planName;
			var param={"workPlanType":"3","planName":title,"urgentLevel":"0","remindType":"1",
					    "urgentLevel":"1","beginDate":nowdate,"beginTime":nowtime,"endDate":nowdate,"endTime":nowtime,
					    "description":description,"crmIDs":"<%=customerid%>","location":gps
					  }
			//showLoading(1,1);		  
			$.post("/mobile/plugin/crm/CrmContactOperation.jsp?method=addCalendarItem",param,function(data){
			
				issign=false;
				alert((signtype=="1"?"签到":"签退")+"成功");
				$(thisBtn).html((signtype=="1"?"签到":"签退"));
				//showLoading(0,1);
			});
		
		}
		
		//时间日期格式化
		Date.prototype.pattern=function(fmt) {     
		   var o = {     
		   "M+" : this.getMonth()+1, //月份     
		   "d+" : this.getDate(), //日     
		   "h+" : this.getHours()%12 == 0 ? 12 : this.getHours()%12, //小时     
		   "H+" : this.getHours(), //小时     
		   "m+" : this.getMinutes(), //分     
		   "s+" : this.getSeconds(), //秒     
		   "q+" : Math.floor((this.getMonth()+3)/3), //季度     
		   "S" : this.getMilliseconds() //毫秒     
		   };     
		   var week = {     
		   "0" : "\u65e5",     
		   "1" : "\u4e00",     
		   "2" : "\u4e8c",     
		   "3" : "\u4e09",     
		   "4" : "\u56db",     
		   "5" : "\u4e94",     
		   "6" : "\u516d"    
		   };     
		   if(/(y+)/.test(fmt)){     
		       fmt=fmt.replace(RegExp.$1, (this.getFullYear()+"").substr(4 - RegExp.$1.length));     
		   }     
		   if(/(E+)/.test(fmt)){     
		       fmt=fmt.replace(RegExp.$1, ((RegExp.$1.length>1) ? (RegExp.$1.length>2 ? "\u661f\u671f" : "\u5468") : "")+week[this.getDay()+""]);     
		   }     
		   for(var k in o){     
		       if(new RegExp("("+ k +")").test(fmt)){     
		           fmt = fmt.replace(RegExp.$1, (RegExp.$1.length==1) ? (o[k]) : (("00"+ o[k]).substr((""+ o[k]).length)));     
		       }     
		   }     
		  return fmt;     
		 }
		
		function showLoading(type){
		   if(type==1){
			   $("#bgAlpha").show();
			   $("#loading").show();
		   }else{
		   	   $("#bgAlpha").hide();
			   $("#loading").hide();
		   }
		}
		
		function addContact(){
			location.href="/mobile/plugin/crm/CrmContact.jsp?customerid=<%=customerid%>&module=<%=module%>&scope=<%=scope%>&opengps=<%=opengps%>";
		}
		
		function showLoading(flag,msgtype){
	   	  if(flag==1){
	   	  	$("#loading").show();
	   	  	$("#loadingmask").show();
	   	  }else{
	   	  	$("#loading").hide();
	   	  	$("#loadingmask").hide();
	   	  }
	   	  var msg="";
	   	  switch(msgtype){
	   	  	case 1:
		   	  	msg="正在保存数据...";
		   	  	break;
		   	case 2:
		   		msg="正在签到...";
		   	  	break;
		   	 case 2:
		   		msg="正在签退...";
		   	  	break; 	
		   	 default:
		   	 	msg="正在获取数据...";
	   	  }
	   	  $("#loading").html(msg);
	   }
		
   </script>
</body>
</html>
