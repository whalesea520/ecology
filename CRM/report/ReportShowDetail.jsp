
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.Map.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="cmutil" class="weaver.crm.report.CRMContants" scope="page" />
<html>
	<head>
		<script src="../js/highcharts.src_wev8.js" type="text/javascript"></script>
		<style type="text/css">
			html,body{margin: 0px;}
			*{font-size: 12px;font-family:微软雅黑; color: #616161 !important;}
			.list{width: 100%;font-size: 12px;z-index: 1;position:absolute}
			.list td{height: 22px;padding-left: 20px;z-index: 10; }
			.scroll1{overflow-y: auto;overflow-x: hidden;
				SCROLLBAR-DARKSHADOW-COLOR: #ffffff;
			  	SCROLLBAR-ARROW-COLOR: #EAEAEA;
			  	SCROLLBAR-3DLIGHT-COLOR: #EAEAEA;
			  	SCROLLBAR-SHADOW-COLOR: #E0E0E0 ;
			  	SCROLLBAR-HIGHLIGHT-COLOR: #ffffff;
			  	SCROLLBAR-FACE-COLOR: #ffffff;}
			.nodatadiv{padding-top:25%;padding-left:45%;width:120px;height:60px}  	
			.nodata{margin-left:15px;margin-bottom:8px;height:41px;width:41px;background:url(/CRM/images/nodata_wev8.png)}
		</style>
	</head>
	<%
		//1：大区  2：省份  3：城市
		int showtype = Util.getIntValue(request.getParameter("showtype"),1);
		String showname = "";
		String reportId = Util.null2String(request.getParameter("reportId"));
		
		String area = Util.null2String(request.getParameter("area"));
		
		String province = Util.null2String(request.getParameter("province"));
		
		Map provs = (Map)request.getSession().getAttribute("MR_PROVS");
		Map citys = (Map)request.getSession().getAttribute("MR_CITYS");
		Map aaaas = (Map)request.getSession().getAttribute("MR_AREAS");
		Map datas = (Map)request.getSession().getAttribute("MR_DATAS_"+reportId);
		double sumcount = (Double)request.getSession().getAttribute("MR_DATAS_SUM_"+reportId);
		Map areas = (Map)request.getSession().getAttribute("MR_AREAS_"+reportId);
	//	double areasum = (Double)request.getSession().getAttribute("MR_AREAS_SUM_"+reportId);
		Map listmap = new LinkedHashMap();//列表显示的数据集合
		if(showtype == 1){//按大区显示
			listmap = areas;
			sumcount = 0;
			showname = SystemEnv.getHtmlLabelName(30039,user.getLanguage());
		}else if(showtype == 2){//按省份显示
			if(area.equals("全部") || area.equals("")){
				listmap = datas;
				showname =SystemEnv.getHtmlLabelName(82857,user.getLanguage());
			}else{
				Object[] objs = (Object[])areas.get(area);
				if(objs != null){
					listmap = (Map)objs[1];
					listmap = sortMap(listmap);
					sumcount = Double.parseDouble((String)objs[0]);
				}
				showname = area;
			}
		}else{//按城市显示
			Object[] o_ = (Object[])datas.get(province);
			if(o_ != null){
				listmap = (Map)o_[1];
				sumcount = Double.parseDouble((String)o_[0]);
			}else
				sumcount=0;
			showname = province;
		}
		String datastr = "";
		String colorstr = "";
		String name_ = "";
		String name_2 = "";
		String value_ = "";
		Object[] oo_ = null;
		String color_ = "";
		
		int parmtype = (Integer)request.getSession().getAttribute("MR_PARMTYPE_"+reportId);
		String detailurl = (String)request.getSession().getAttribute("MR_DETAILURLSTR_"+reportId)+"?msg=report&settype=customercity";
		String provparm = (String)request.getSession().getAttribute("MR_PROVPARM_"+reportId);
		String cityparm = (String)request.getSession().getAttribute("MR_CITYPARM_"+reportId);
		String provval="";//传递的省份参数值
		String cityval="";//传递的城市参数值
		
	%>

	<body style="border-left: 1px #D1D1D1 solid;">
		<table id="table1" style="width: 100%;height:300px;" cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td style="height: 24px;">
					<div style="width: 100%;line-height: 24px;background: #FCFCFC;color: #616161;border-bottom: 1px #D1D1D1 solid;">&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(84377,user.getLanguage())%> — <%=showname %></div>
				</td>
			</tr>
			<tr>
				<td valign="top">
					<div id="container" style="margin-top: 0px;background: #F7F7F7;height:100%"></div>
				</td>
			</tr>
		</table>
		<table id="table2" style="width: 100%;" cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td style="height: 24px;">
					<div style="width: 100%;line-height: 24px;background: #FCFCFC;color: #616161;border-top: 1px #D1D1D1 solid;border-bottom: 1px #D1D1D1 solid;">&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(320,user.getLanguage())%> — <%=showname %></div>
				</td>
			</tr>
			<tr>
				<td valign="top" height="*">
					<div id="listdiv" class="scroll1" style="width: 100%;height:100%;margin-top: 0px;margin-bottom: 0px;margin-left: 0px;background: #F7F7F7;position:relative">
				    	<table class="list" cellpadding="0" cellspacing="0" border="0" >
				    		<colgroup><col width="35%"/><col width="30%"/><col width="35%"/></colgroup>
				    		<%
					    	if(sumcount==0){
				    		%>
				    			<tr>
					    			<td colspan="3">
					    				<div class='nodatadiv'><div class='nodata'></div><div><%=SystemEnv.getHtmlLabelName(83553,user.getLanguage())%>!</div></div>
					    			</td>
				    			</tr>
				    		
				    		<%}else{ %>
				    		<%
					    		for (Object e : listmap.entrySet()) {
					    			name_2 = (String)((Entry)e).getKey();
					    			name_ = (name_2.endsWith("p")||name_2.endsWith("c"))?name_2.substring(0,name_2.length()-1):name_2;
					    			
					    			if(showtype==1 || (showtype==2 && (area.equals("全部") || area.equals("")))){
					    				oo_ = (Object[])((Entry)e).getValue();
					    				value_ = (String)oo_[0];
					    			}else{
					    				value_ = (String)((Entry)e).getValue();
					    			}
					    			datastr += ",['"+name_+"',"+value_+"]";//拼接饼图数据
					    			color_ = cmutil.getRandColorCode();//随机生成不重复颜色
					    			colorstr += ",'"+color_+"'";
					    			
					    			//设置明细链接参数
					    			if(showtype==1){
					    				provval = (String)(((String[])aaaas.get(name_))[0]);
					    				cityval = (String)(((String[])aaaas.get(name_))[1]);
				    				}else if(showtype==3){
				    					provval = "";
				    					cityval = name_;
				    				}else{
				    					if(area.equals("全部") || area.equals("")){
				    						provval = name_;
					    					cityval = "";
				    					}else{
				    						if(name_2.endsWith("p")){
				    							provval = name_;
						    					cityval = "";
				    						}else{
				    							provval = "";
						    					cityval = name_;
				    						}
				    					}
				    				}
					    			//如果参数类型为id，则需要进行转化
					    			if(parmtype==1){
					    				provval = transprovid(provval,provs);
					    				cityval = transcityid(cityval,citys);
				    				}
				    		%>
				    		<tr id="<%=name_ %>" onmouseover="showLight('<%=name_ %>')" onmouseout="hideLight()" >
				    			<td valign="middle">
				    				<div style="width: 10px;height: 10px;margin-right:4px;background: <%=color_ %>;font-size:0px;float:left;margin-top:4px;">&nbsp;</div>
				    				<div style="float:left"><%=name_ %></div>
				    				<div style="clear:both"></div>
				    			</td>
				    			<td><%=value_ %></td>
				    			<td>
				    				<div style="float: left;"><%=cmutil.myRound(Double.parseDouble(value_)/sumcount*100+"",2)%>%</div>
				    			<%if(!"".equals(detailurl)){ %>
				    				<div style="float: right;margin-right: 6px;<%if(Double.parseDouble(value_)>0){%>cursor: pointer;<%}else{%>color:#9A9A9A !important;<%} %>" 
				    					<%if(Double.parseDouble(value_)>0){%>onclick="openDetail('<%=provval %>','<%=cityval %>')"<%}%>><%=SystemEnv.getHtmlLabelName(17463,user.getLanguage())%></div>
				    			<%} %>
				    			<div style="clear:both"></div>
				    			</td>
				    		</tr>
				    		<%
					    		}
					    		if(!datastr.equals("")) datastr = "[" + datastr.substring(1) + "]";
					    		if(!colorstr.equals("")) colorstr = "[" + colorstr.substring(1) + "]";
					    	}
				    		%>
				    	</table>
				    	<div id="light" style="width:100%;height: 20px;border-top: 1px #E8E8E8 solid;border-bottom: 1px #E8E8E8 solid;background: #FFFFFF;position: absolute;top: 0px;left: 0px;right: 0px;display: none;z-index: 0;">&nbsp;</div>
				    </div>
				</td>
			</tr>
		</table>
	    
		<script type="text/javascript">
		
			var datastr;
			var colorstr;
			var chart;
			var chartHeight=0;
			$(document).ready(function() {
			    
			    initHeight();
			    
				<%if(sumcount>0){%>
					doInit();
				<%}else{%>
					$("#container").html("<div class='nodatadiv'><div class='nodata'></div><div><%=SystemEnv.getHtmlLabelName(83553,user.getLanguage())%>!</div></div>");
				<%}%>
			});
			
			window.onresize=function(){
				initHeight();
			}
			
			function initHeight(){
				var mainHeight=document.body.clientHeight;
				//alert(mainHeight);
			    $("#table1").height(mainHeight/2);
			    $("#table2").height(mainHeight/2);
			    $("#listdiv").height(mainHeight/2-30);
			    
			    chartHeight=mainHeight/2-30;
			}
			
			function doInit(){
			    	datastr = <%=datastr.equals("")?0:datastr%>;
					colorstr = <%=colorstr.equals("")?0:colorstr%>;
			        chart = new Highcharts.Chart({
			            chart: {
			                renderTo: 'container',
			                plotBackgroundColor: null,
			                plotBorderWidth: 0,
			                plotShadow: false,
			                backgroundColor: '#F7F7F7',
			                borderWidth: 0,
			                height:250
			            },
			            title: {
			                text: ''
			            },
			            tooltip: {
			            	enabled: false,
			                formatter: function() {
			                    return '<b>'+ this.point.name +'</b>: '+ Math.round(this.percentage*100)/100 +' %';
			                }
			            },
			            plotOptions: {
			                pie: {
			            		borderWidth: 0,
			            		shadow: true,
			                    allowPointSelect: true,
			                    cursor: 'pointer',
			                    dataLabels: {
			                        enabled: true,
			                        color: '#000000',
			                        connectorColor: '#616161',
			                        formatter: function() {
			                            return ''+ this.point.name +'';
			                        }
			                    },
			                    events:{//监听点的鼠标事件  
			                    		
			                    		click: function() {
			                    		} 
			                	}
			
			                }
			            },
			            series: [{
			                type: 'pie',
			                name: 'Browser share',
			                data: datastr
			            }],
			            colors: colorstr
			        });
			}
			function showLight(provname){
				var t = $("#"+provname).offset().top;
				var t2 = $("#"+provname).position().top;
				var st = $(".scroll1").offset().top;
				var h = $(".scroll1").height();
				if((t+22)>=st+h){
					$(".scroll1").scrollTop($(".scroll1").scrollTop()+t-h-st+22);
				}else if(t<st){
					$(".scroll1").scrollTop($(".scroll1").scrollTop()-(st-t));
				}
				$("#light").show().animate({ top:t2 },50,null,function(){});
			}
			function hideLight(){
				$("#light").hide();
			}
			function openDetail(prov,city){
				var url = "/CRM/search/SearchOperation.jsp?msg=report&settype=province&id="+prov;
				if(city!="")
					url = "/CRM/search/SearchOperation.jsp?msg=report&settype=city&id="+city;
					
				var dialog = new window.top.Dialog();
					dialog.currentWindow = window;
					dialog.Title = "<%=SystemEnv.getHtmlLabelName(20323,user.getLanguage()) %>";
					dialog.Width = 800;
					dialog.Height = 500;
					dialog.Drag = true;
					dialog.maxiumnable = true;
					dialog.URL = url;
					dialog.show();
			}
		</script>
    </body>
</html>
<%!
	private String transprovid(String names,Map provs){
		String ids = "";
		List nameList = Util.TokenizerString(names,",");
		for(int i=0;i<nameList.size();i++){
			ids += "," + provs.get(nameList.get(i));
		}
		if(!"".equals(ids)) ids = ids.substring(1);
		return ids;
	}
	private String transcityid(String names,Map citys){
		String ids = "";
		List nameList = Util.TokenizerString(names,",");
		for(int i=0;i<nameList.size();i++){
			ids += "," + citys.get(nameList.get(i));
		}
		if(!"".equals(ids)) ids = ids.substring(1);
		return ids;
	}
	private Map sortMap(Map map){
		if(map==null){
			return map;
		}else{
			if(map.size()==0) return map;
			Map newMap = new LinkedHashMap();
			int val[]= new int [map.size()];
			String name[] = new String [map.size()];
			int index=0;
			for (Object e : map.entrySet()) {
				String name_ = (String)((Entry)e).getKey();
				String val_ = (String)((Entry)e).getValue();
				
				name[index] = name_;
				val[index]=Integer.parseInt(val_);
				index++;
	        }
			for (int i=0;i<val.length ;i++ )
			{
				for (int j=0;j<val.length ;j++ )
				{
					int temp;
					String tempn = "";
					if (val[i]<val[j])
					{
						temp=val[j];
						val[j]=val[i];
						val[i]=temp;
						
						tempn=name[j];
						name[j]=name[i];
						name[i]=tempn;
					}
				}
			}
			for(int i=name.length-1;i>-1;i--){
				newMap.put(name[i], val[i]+"");
			}
			
			return newMap;
		}
	}
%>