
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@page import="weaver.hrm.resource.ResourceComInfo"%>
<%@page import="weaver.general.GCONST"%>
<%@page import="java.io.File"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
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
	<script type='text/javascript' src='/mobile/plugin/crm/js/crm_wev8.js'></script>
	<link rel="stylesheet" href="/wui/common/css/w7OVFont_wev8.css" type="text/css">
	<link rel="stylesheet" href="/mobile/plugin/1/css/r4_wev8.css" type="text/css">
	<link rel="stylesheet" href="/mobile/plugin/crm/css/crm_wev8.css" type="text/css">
	<script language="javascript" src="https://webapi.amap.com/maps?v=1.3&key=53a92850ca00d7f77aef3297effd8d59"></script>
	<style>
		.itemtd{text-align: left;padding-top: 0px;}
		.itemdiv{background: rgb(239, 242, 246);border-bottom: 1px solid #e5e5e5;border-top: 1px solid #e5e5e5;height: 24px;line-height: 24px;padding-left: 5px;}
		.itemname{color:#2475c8;font-weight: 400;font-size: 14px;}
		.itemtime{color:#8c8c8c;font-weight: 400;font-size: 14px;}
		.planname{color:#2475c8;height: 20px;line-height: 20px;padding-left:5px;}
		.description{padding:8px 8px 8px 5px;}
	</style>
<body>
	<%
		String clienttype = Util.null2String((String)request.getParameter("clienttype"));
		String clientlevel = Util.null2String((String)request.getParameter("clientlevel"));
		String module=Util.null2String((String)request.getParameter("module"));
		String scope=Util.null2String((String)request.getParameter("scope"));
		String opengps = Util.null2String((String)request.getParameter("opengps"));
		
		String customerid=Util.null2String((String)request.getParameter("customerid"));
		String userid=""+user.getUID();
		
		RecordSet.executeProc("CRM_CustomerInfo_SelectByID",customerid);
		RecordSet.next();
		
		String sql = "" ;
		if (rs.getDBType().equals("oracle"))
			sql = " SELECT id, begindate, begintime, resourceid, description, name, status, urgentLevel, createrid, createrType, taskid, crmid, requestid, docid,location " 
				+ " FROM WorkPlan WHERE id IN ( " 
			    + " SELECT DISTINCT a.id FROM WorkPlan a "
		        + " WHERE " 
				+ " a.crmid = '" + customerid + "'"
				+ " AND a.type_n = '3')";
		else
			sql = "SELECT id, begindate , begintime, resourceid, description, name, status, urgentLevel, createrid, createrType, taskid, crmid, requestid, docid,location " 
				+ " FROM WorkPlan WHERE id IN ( " 
			    + " SELECT DISTINCT a.id FROM WorkPlan a WHERE " 
				+ " a.crmid = '" + customerid + "'" 
				+ " AND a.type_n = '3')";

		sql += " ORDER BY begindate DESC, begintime DESC";
		rs.execute(sql);
	%>
	<div id="header"  style="<%if (clienttype.equals("Webclient")) {%>display:block;<%} else {%>display:none;<%}%>">
					<table style="width: 100%; height: 40px;">
						<tr>
							<td width="10%" align="left" valign="middle" style="padding-left:5px;">
									<a href="/mobile/plugin/crm/CrmView.jsp?module=<%=module%>&scope=<%=scope%>&opengps=<%=opengps%>">
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
			<span class="m-l-14">添加联系</span>
		</div>
		<div class="tblBlock" style="width: 100%; background: #fff;" id="mainforminfoDiv">
		  <table id="head" cellspacing="0" cellpadding="0" width="100%" class="mainFormTable">
			<tr>
				<td class="mainFormRowNameTD" style="width: 10%" align="left">
					标题
				</td>
				<td style="width:15px;"></td>
				<td width="*" class="mainFormRowValueTD">
					<input type="text" name="planName" style="width: 90%" id="planName" onblur="checkinput02('planName','planNamespan')">
					<span  id=planNamespan >
						<img src='/images/BacoError_wev8.gif' align="absMiddle" >
					</span>
				</td>
			</tr>	
			<tr width="100%"><td colspan="3" class="mainFromSplitLine"></td></tr>
			<tr>
				<td class="mainFormRowNameTD" style="width: 10%" align="left">
					内容
				</td>
				<td style="width:15px;"></td>
				<td width="*" class="mainFormRowValueTD">
					<textarea style="width:90%;height:80px;" name="description" id="description" onblur="checkinput02('description','descriptionspan')"></textarea>
					<span  id=descriptionspan >
						<img src='/images/BacoError_wev8.gif' align="absMiddle" >
					</span>
				</td>
			</tr>	
			<tr width="100%"><td colspan="3" class="mainFromSplitLine"></td></tr>
			<tr>
				<td  align="center" colspan="3" class="mainFormRowNameTD">
					<div class="operationBtright" style="margin-left: 10px;" onclick="doSave(this,1)">保存</div>
				</td>
			</tr>	
			<tr width="100%"><td colspan="3" class="mainFromSplitLine"></td></tr>
		  </table>
		  
		</div>
   	<div style="height:10px;overflow:hidden;"></div>
   	<div class="blockHead">
		<span class="m-l-14">联系记录</span>
	</div>
	<div class="tblBlock" style="width: 100%; background: #fff;" id="mainforminfoDiv">
		<table id="contactList" cellspacing="0" cellpadding="0" width="100%" class="mainFormTable">
			<%
			if(rs.getCounts()>0){
			while(rs.next()){
			  String location=Util.null2String(rs.getString("location"));
			  String description=Util.null2String(rs.getString("description"));
			%>
			<tr>
				<td class="mainFormRowNameTD itemtd" align="left" colspan="3">
					<div class="itemdiv">
						<span class="itmename"><%=ResourceComInfo.getLastname(rs.getString("resourceid"))%></span> 
						<span class="itmetime"><%=rs.getString("begindate")+" "+rs.getString("begintime")%></span>
					</div>
					<div class="planname"><%=rs.getString("name")%></div>
					<div class="description">
						<%=rs.getString("description")%>
						<br>
						<%if(!location.equals("")){%>
					    	&nbsp;&nbsp;<a href='javascript:return false' onclick="showLocation('<%=location%>','<%=rs.getString("begintime")%>','<%=description%>');return false;"><img src='/blog/images/location_icon_1_wev8.png' border='0'/>地图位置</a>
						<%}%>
					</div>
				</td>
			</tr>	
			<tr width="100%"><td colspan="3" class="mainFromSplitLine"></td></tr>
			<%}
			}else{
			%>	
				<tr width="100%" id="norecord">
					<td colspan="3" class="mainFormRowNameTD" align="center">暂时没有记录</td> 
				</tr>
			<%
			}
			%>
		</table>
	</div>
	<div style="height:10px;overflow:hidden;"></div>
   </td>
   <td class='itemnavpoint'></td>
  </tr>
</table>
	
	
   <script type="text/javascript">
   
   		//当用户点击标题上左边或右边按钮时，客户端会调用页面上的javascript方法:
		function doLeftButton() {
			window.location.href="/mobile/plugin/crm/CrmView.jsp?module=<%=module%>&scope=<%=scope%>&opengps=<%=opengps%>&customerid=<%=customerid%>";
			return "1";
		}
		
		function getLeftButton(){ 
			return "1,<%=SystemEnv.getHtmlLabelName(1290,user.getLanguage()) %>";
		}
		
		var clienttype="<%=clienttype%>";
		var opengps="<%=opengps%>";
		var signtype="1";
		
		function doSave(obj,type){
		
				if(!checkInput("planName,description"))
				   return;
				var issign=$(obj).attr("_issign");
				if(issign=="1") return ;
				signtype=type;
				
				if(opengps=="1"){
					//if(clienttype=="iPhone"||clienttype=="iPad"){
						location="emobile:gps:doSaveBlog";
					//}else
					//	doSaveBlog("");
					
		    	}else
		    		doSaveBlog("");
		}
		
		function doSaveBlog(gps){
		
			//if((clienttype=="android"||clienttype=="androidpad")&&opengps=="1"){
			//  var isGpsEnable=mobileInterface.chekGpsEnable()
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
		    //}else{
			//	saveLocation("","");
			//	return ;
			//}
		    locationGps=gps;
			//locationGps="31.179544,121.481566";
			if(opengps=="1"&&clienttype!="Webclient"&(locationGps=="0,0"||locationGps=="")){
				alert("无法获取地理位置");
				return ;
			}
			
			$("#signBtn").attr("_issign","1").html("正在签到...");
			
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
		
		var flag=true;
		function saveLocation(planName,gps){
			var now= new Date();
			var nowdate=now.pattern("yyyy-MM-dd");
			var nowtime=now.pattern("HH:mm");
			
			var description=$("#description").val();
			var title=$("#planName").val();
			
			var param={"workPlanType":"3","planName":title,"urgentLevel":"0","remindType":"1",
					    "urgentLevel":"1","beginDate":nowdate,"beginTime":nowtime,"endDate":nowdate,"endTime":nowtime,
					    "description":description,"crmIDs":"<%=customerid%>","location":gps
					  }
			showLoading(1,1);
			if(!flag) return ;
			flag=false;	  
			$.post("/mobile/plugin/crm/CrmContactOperation.jsp?method=addCalendarItem",param,function(data){
				//$("#signBtn").attr("_issign","0").html("签到");
				alert("保存成功");
				clearData();
				if("<%=clienttype%>"!="Webclient"&&opengps=="1")
			    	description=description+"&nbsp;&nbsp;<br/><a href='javascript:return false' onclick=\"showLocation('"+gps+"','"+nowtime+"','"+planName+"');return false;\"><img src='/blog/images/location_icon_1_wev8.png' border='0'/>地图位置</a>";
				var htmlstr='<tr>'+
							'<td class="mainFormRowNameTD itemtd" align="left" colspan="3">'+
							'<div class="itemdiv">'+
							' <span class="itmename"><%=ResourceComInfo.getLastname(userid)%></span>'+ 
							' <span class="itmetime">'+nowdate+' '+nowtime+'</span>'+
							'</div>'+
							'<div class="planname">'+title+'</div>'+
							'<div class="description">'+description+'</div>'+
							'</td>'+
							'</tr>'+	
							'<tr width="100%"><td colspan="3" class="mainFromSplitLine"></td></tr>';
				$("#contactList tr:first").before(htmlstr);
				$("#norecord").remove();			
				showLoading(0,1);	
				flag=true;		
			});
		
		}
		
		function clearData(){
			$("#planName").val("");
			$("#planNamespan").html("<img src='/images/BacoError_wev8.gif' align='absMiddle' >");
			
			$("#description").val("");
			$("#descriptionspan").html("<img src='/images/BacoError_wev8.gif' align='absMiddle' >");
		}
		
		function checkInput(element){
			var elements=element.split(",");
			for(var i=0;i<elements.length;i++){
				if(elements[i]=="") continue;
				var value=$.trim($("#"+elements[i]).val());
				if(value==""){
					alert("必填信息不全！");
					return false;
				}
			}
			return true;
		}
		
		
		// 取消输入框后面跟随的红色惊叹号
		function checkinput02(elementname,spanid){
			var tmpvalue = $.trim($("#"+elementname).val());
			if(tmpvalue != ""){
				while(tmpvalue.indexOf("\r\n") >= 0){
					tmpvalue = tmpvalue.replace("\r\n", "");
				}
				if(tmpvalue != ""){
					$("#"+spanid).html("");
				}else{
					$("#"+spanid).html( "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
				}
			}else{
				$("#"+spanid).html( "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
			}
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
	   function showLocation(gps,nowtime,description){
	   	  	location.href="/mobile/plugin/crm/CrmShowLocation.jsp?customerid=<%=customerid%>&module=<%=module%>&scope=<%=scope%>&opengps=<%=opengps%>&gps="+gps+"&nowtime="+nowtime+"&description="+encodeURI(description);
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
