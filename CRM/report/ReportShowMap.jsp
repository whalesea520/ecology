
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.Map.*" %>
<%@ page import="weaver.crm.CrmShareBase" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Contants" class="weaver.crm.report.CRMContants" scope="page" />
<jsp:useBean id="ProvinceComInfo" class="weaver.hrm.province.ProvinceComInfo" scope="page" />
<jsp:useBean id="CityComInfo" class="weaver.hrm.city.CityComInfo" scope="page" />
<html>
	<head>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<link href="../js/vectormap/jquery.vector-map_wev8.css" media="screen" rel="stylesheet" type="text/css" />
		<script type="text/javascript" src="/wui/common/jquery/jquery_wev8.js"></script>
		<script src="../js/vectormap/jquery.vector-map_wev8.js" type="text/javascript"></script>
    	<script src="../js/china-zh_wev8.js" type="text/javascript"></script>
    	<style type="text/css">
    		html,body{margin: 0px;overflow: hidden;}
    	    .btndiv{line-height: 28px;text-align: center;float: left;cursor: pointer;font-size: 12px;font-family: 微软雅黑;
    			padding-left: 10px;padding-right: 10px;color: #616161;}
    		.btn_select{}
    		
    		.tag{width: 16px;height: 8px;float: left;font-size: 0px;margin-right: 2px;margin-top: 3px;}
    	</style>
	</head>
	<%
		//获取传递参数
		String reportId = Util.null2String(request.getParameter("reportId"));
//		int showtype = Util.getIntValue(request.getParameter("showtype"),1);
		int showtype = Util.getIntValue(request.getParameter("showtype"));
//		if(showtype==3) showtype=1;//当点击地图查询城市时，再点击按时间查询，则默认改为大区显示
		String area = Util.null2String(request.getParameter("area"));
		//从session中读取字段信息
		String name = (String)request.getSession().getAttribute("MR_NAME_"+reportId);
		String unit = (String)request.getSession().getAttribute("MR_UNIT_"+reportId);
		String ds = (String)request.getSession().getAttribute("MR_DATASOURCE_"+reportId);
		String sqlstr1 = (String)request.getSession().getAttribute("MR_SQLSTR1_"+reportId);
		String sqlstr2 = (String)request.getSession().getAttribute("MR_SQLSTR2_"+reportId);
		String othersql = "";
		
		Map pros = (Map)request.getSession().getAttribute("MR_PROVS");
		//开始时间与结束时间
		/*
		String datefrom = Util.null2String(request.getParameter("datefrom"));
		datefrom = datefrom.equals("")?"1000-01-01":datefrom;
		String dateto = Util.null2String(request.getParameter("dateto"));
		dateto = dateto.equals("")?"3000-01-01":dateto;
		*/
		
		String datefrom = "1000-01-01";
		String dateto = "3000-01-01";
		
		//是否含有时间条件
		boolean datecon = false;
		if(sqlstr1.indexOf("#datefrom#")>-1 || sqlstr1.indexOf("#dateto#")>-1 || sqlstr2.indexOf("#datefrom#")>-1 || sqlstr2.indexOf("#dateto#")>-1){
			sqlstr1 = sqlstr1.replaceAll("#datefrom#",datefrom).replaceAll("#dateto#",dateto);
			sqlstr2 = sqlstr2.replaceAll("#datefrom#",datefrom).replaceAll("#dateto#",dateto);
			datecon = true;
		}
		//针对客户数据单独处理
		String sqlwhere = (String)request.getSession().getAttribute("SQLWhere"); //高级搜索处理
		if(sqlstr1.indexOf("#crmsql#")>-1) sqlstr1 = sqlstr1.replaceAll("#crmsql#",getCustomerStr(user,sqlwhere));
		if(sqlstr2.indexOf("#crmsql#")>-1) sqlstr2 = sqlstr2.replaceAll("#crmsql#",getCustomerStr(user,sqlwhere));
		if(sqlstr1.indexOf("#begin#")>-1 && sqlstr1.indexOf("#end#")>-1){
			othersql = sqlstr1.substring(sqlstr1.indexOf("#begin#")+7,sqlstr1.indexOf("#end#"));
		}
		if(sqlstr1.indexOf("#begin#")>-1) sqlstr1 = sqlstr1.replaceAll("#begin#","");
		if(sqlstr1.indexOf("#end#")>-1) sqlstr1 = sqlstr1.replaceAll("#end#","");
		if(sqlstr2.indexOf("#begin#")>-1) sqlstr2 = sqlstr2.replaceAll("#begin#","");
		if(sqlstr2.indexOf("#end#")>-1) sqlstr2 = sqlstr2.replaceAll("#end#","");
		
		
		//sqlstr1 = sqlstr1.replaceAll("where", sqlwhere);
		//sqlstr2 = sqlstr2.replaceAll("where", sqlwhere);
		
		StringBuffer dataStatus = new StringBuffer();//显示地图数据的json字符串
		String datastr = "";
		double sumcount = 0;//总数
		double maxvalue = 0;//最大值
		
		Map datas = new LinkedHashMap();//存储省份数据 每个省份中存储其城市数据  其中值为对象数组，第一个为省份的数量总和，第二个值为城市的map集合
		
		if(ds.equals("")){//内部数据
			//读取省份数据
			rs.executeSql(sqlstr1);
			while(rs.next()){
				Object[] objs = new Object[2];
				objs[0] = rs.getString(2);
				objs[1] = new LinkedHashMap();
				datas.put(rs.getString(1), objs);//放入省份集合中
				
				if(Util.getDoubleValue(rs.getString(2),0)>maxvalue) maxvalue = Util.getDoubleValue(rs.getString(2),0);
				
				dataStatus.append(",{ cha: '"+Contants.getCode(rs.getString(1))+"', name: '"+rs.getString(1)+"', des: '' ,value: "+rs.getString(2)+"}");
				sumcount += Double.parseDouble(rs.getString(2));
			}
			//读取城市数据
			rs.executeSql(sqlstr2);
			while(rs.next()){
				Object[] objs = (Object[])datas.get(rs.getString(2));
				((Map)objs[1]).put(rs.getString(1), rs.getString(3));
			}
		}else{
			RecordSetDataSource rds = new RecordSetDataSource(ds);
			rds.executeSql(sqlstr1);
			while(rds.next()){
				Object[] objs = new Object[2];
				objs[0] = rds.getString(2);
				objs[1] = new LinkedHashMap();
				datas.put(rds.getString(1), objs);
				
				if(Util.getDoubleValue(rds.getString(2),0)>maxvalue) maxvalue = Util.getDoubleValue(rds.getString(2),0);
				
				dataStatus.append(",{ cha: '"+Contants.getCode(rds.getString(1))+"', name: '"+rds.getString(1)+"', des: '' ,value: "+rds.getString(2)+"}");
				sumcount += Double.parseDouble(rds.getString(2));
			}
			//读取城市数据
			rds.executeSql(sqlstr2);
			while(rds.next()){
				Object[] objs = (Object[])datas.get(rds.getString(2));
				((Map)objs[1]).put(rds.getString(1), rds.getString(3));
			}
		}
		if(dataStatus.length()>0){
			datastr = "["+dataStatus.toString().substring(1)+"]";
		}
		
		//读取大区信息
		
		request.getSession().setAttribute("MR_DATAS_"+reportId,datas);
        request.getSession().setAttribute("MR_DATAS_SUM_"+reportId,sumcount);
        
        //如果没有设置大区 则显示类型默认为省份
        
        //设置明细链接
        String detailurl = (String)request.getSession().getAttribute("MR_DETAILURL_"+reportId);
        String datefromparm = (String)request.getSession().getAttribute("MR_DATEFROMPARM_"+reportId);
		String datetoparm = (String)request.getSession().getAttribute("MR_DATETOPARM_"+reportId);
		if(!detailurl.equals("")){
			detailurl = (detailurl.indexOf("?")<0)?detailurl+"?1=1":detailurl+"&1=1";
			if(!"".equals(othersql)) detailurl += "&othersql="+othersql;
		}
		if(datecon) detailurl += "&"+datefromparm+"="+datefrom+"&"+datetoparm+"="+dateto;
			
		request.getSession().setAttribute("MR_DETAILURLSTR_"+reportId,detailurl);
		
		String titlename = SystemEnv.getHtmlLabelName(352,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(110,user.getLanguage());
		String needfav ="1";
		String needhelp ="";
	%>

	<body>
	<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:weaver.submit(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
	%>
	<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<div id="main" style="width: 100%;height: 100%;position: relative;">
			<div id="map" style="margin-left: 0px; padding-top: 0px; padding-left: 0px;
				background: white; width: 65%; height: 100%;float: left;position: relative;">
			</div>
			<div id="detail" style="float: left;width: 35%;height: 100%;">
				<iframe id="detailview" src="" scrolling="no" frameborder="0" style="width: 100%;height: 100%;"></iframe>
			</div>
			<div id="search" style="position: absolute;top: 10px;left: 10px;z-index: 100;display: none;">
				<div id="btn3" class="btndiv btn_select">
					<div id="btn2" style="line-height: 28px;float: left;" onclick="changeSearch(2)">
					<select id="select2" onchange="changeSrc(3,this.value)" style="margin-top: 1px;" class="saveHistory" >
						<option value="全部"><%=SystemEnv.getHtmlLabelName(84378,user.getLanguage())%></option>
						<%
							for (Object e : pros.entrySet()) {
								String name_ = (String)((Entry)e).getKey();
						%>
							<option value="<%=name_ %>" <%if(pros.equals(name_)){ %> selected="selected" <%} %>><%=name_ %></option>
						<%
					        }
						%>
					</select>
					</div>
				 </div>
			</div>
			<div id="divtag" style="position: absolute;left: 10px;z-index: 100;display: none">
				<div style="line-height: 16px;float: left;margin-right: 4px;"><%=SystemEnv.getHtmlLabelName(27734,user.getLanguage())%></div>
				<div class="tag" style="background: #1556A1">&nbsp;</div>
				<div class="tag" style="background: #136BD4">&nbsp;</div>
				<div class="tag" style="background: #6C98D5">&nbsp;</div>
				<div class="tag" style="background: #9FCCFF">&nbsp;</div>
				<div class="tag" style="background: #DCECFF">&nbsp;</div>
				<div style="line-height: 16px;float: left;margin-left: 2px;"><%=SystemEnv.getHtmlLabelName(19952,user.getLanguage())%></div>
			</div>	
			<div id="total" style="position: absolute;right: 36%;z-index: 100;display: none">
				总计：<%=sumcount%>
			</div>			
		</div>
			
		
		<script type="text/javascript">
			var base = Math.round(<%=maxvalue%>/5);
			var clickpath;
			var dataStatus = <%=datastr.equals("")?"[]":datastr%>;
			var sumcount = <%=sumcount%>;
			
	        $(document).ready(function () {
		        <%if(showtype==1){%>
		        	changeSrc(1);
		        <%}else{%>
		       	 	changeSrc2(2,"<%=area%>");
		        <%}%>
	            $('#map').vectorMap({ map: 'china_zh',
	                color: "#E6E6E6", //地图颜色
	                hoverColor: "#FF8000",
	                width: '540px',
	    			height: '500px',
	                dataStatus: dataStatus,
	                onLabelShow: function (event, label, code) {//动态显示内容
	                    $.each(dataStatus, function (i, items) {
	                        if (code == items.cha) {
	                            label.html("<div style='width:100px;line-height:24px;background:#737373;color:#ffffff;padding-left:5px;'>"+items.name+"</div>"
	    	                             + "<div style='width:100px;line-height:24px;background:#EEEEEE;color:#000000;padding-left:5px;'><%=unit%>：<font style='color:#FD0000'>" + items.value + "</font></div>"
	    	                             + "<div style='width:100px;line-height:24px;background:#EEEEEE;color:#000000;padding-left:5px;'>"+SystemEnv.getHtmlLabelName(31143,user.getLanguage())+":<font style='color:#FD0000'>" + Math.round(items.value/sumcount*10000)/100 + "%</font></div>");
	                        }
	                    });
	                },
	                onRegionOver: function(event,code){
	              	},
	              	onRegionOut: function(event,code){
	              	},
	              	onRegionClick: function(event,code){
	              		$.each(dataStatus, function (i, items) {
                        	if (code == items.cha) {
                        		changeSrc(3,items.name);
                        	}
                    	});
	              	}
	            })
	            $.each(dataStatus, function (i, items) {
	                if(items.value>0){
	                	var josnStr = "";
	                	//var rate = Math.round(items.value/sumcount*10000)/100;
	                	if(items.value<=base){
	                		josnStr = "{" + items.cha + ":'#DCECFF'}";
		                }else if(items.value>base && items.value<=base*2){
		                	josnStr = "{" + items.cha + ":'#9FCCFF'}";
		                }else if(items.value>base*2 && items.value<=base*3){
		                	josnStr = "{" + items.cha + ":'#6C98D5'}";
		                }else if(items.value>base*3 && items.value<=base*4){
		                	josnStr = "{" + items.cha + ":'#136BD4'}";
		                }else{
		                	josnStr = "{" + items.cha + ":'#1556A1'}";
		                }
		                $('#map').vectorMap('set', 'colors', eval('(' + josnStr + ')'));
	                }
	            });
	           // $('.jvectormap-zoomin').click(); //放大
				<%if(datecon){%>
//					parent.showDateCon();       //显示时间选择控件
				<%}%>
				parent.setTitle("<%=name%>");
	            setFrameHeight();
	            $("#divtag").show();
				$("#total").show();
	            	$("#search").show();
	        });

	        function changeSrc(type,pname){
	        	if(pname === '全部') {
	        	   changeSrc2(2,pname);
	        	   return;
	        	}
				$("#detailview").attr("src","ReportShowDetail.jsp?datefrom=<%=datefrom%>&dateto=<%=dateto%>&showtype="+type+"&reportId=<%=reportId %>&province="+pname+"&random="+Math.floor(Math.random()*100000));
				parent.showtype = type;
		    }
	        function changeSrc2(type,aname){
				$("#detailview").attr("src","ReportShowDetail.jsp?datefrom=<%=datefrom%>&dateto=<%=dateto%>&showtype="+type+"&reportId=<%=reportId %>&area="+aname+"&random="+Math.floor(Math.random()*100000));
				parent.showtype = type;
				if(typeof(aname) != "undefined") parent.area = aname;
		    }

		    function setFrameHeight(){
			    //$("#main").height($(window).height());
				//$("#detailview").height($(window).height());
				$("#detailview").attr("src",$("#detailview").attr("src"));
				$("#divtag").css("top",$(window).height()-40);
				$("#total").css("top",$(window).height()-40);
				//$("#divtag").css("left",$("#map").width()/2-$("#divtag").width()/2);
			}
	    </script>
    </body>
</html>
<%!
	/**
	 * 获取所有具有查看权限的客户sql字符串
	 * @return
	 */
	public String getCustomerStr(User user,String sqlwhere) throws Exception{
		String condition = "";
		//找到用户能看到的所有客户
		String userid = "" + user.getUID();
		String loginType = "" + user.getLogintype();
		
		CrmShareBase crmShareBase = new CrmShareBase();
		String leftjointable = crmShareBase.getTempTable(userid);
		condition = "select distinct m1.id,m1.deleted,m1.city,m1.createdate,m1.source,m1.type "
			+ " from CRM_CustomerInfo m1 left join " + leftjointable + " m2 on m1.id = m2.relateditemid "
			+ " where m1.id = m2.relateditemid "+sqlwhere;
			//condition = " (select " + backFields + " " + sqlFrom + " " + sqlWhere1 + " ) customerIds";
		return condition;
	}
%>