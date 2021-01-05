<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%@ page import="java.text.*" %>
<%@ page import="weaver.general.*"%>
<jsp:useBean id="AccessItemComInfo" class="weaver.gp.cominfo.AccessItemComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
	String accessitemid = Util.null2String(request.getParameter("accessitemid"));
	String itemdesc = Util.null2String(request.getParameter("itemdesc"));
	String userid = user.getUID() + "";
	//读取定量指标的报表统计
	
	int yearto = Util.getIntValue(TimeUtil.getCurrentDateString().substring(0,4));
	int monthto = Util.getIntValue(TimeUtil.getCurrentDateString().substring(5,7));
	
	int yearfrom = yearto;
	int monthfrom = monthto-5;
	
	if(monthfrom<=0){
		yearfrom = yearfrom - 1;
		monthfrom = 12 + monthfrom;
	}
	
	String sql = "select t1.year,t1.type2,t2.target1,t2.result1 from GP_AccessScore t1,GP_AccessScoreDetail t2 where t1.id=t2.scoreid and t2.accessitemid="+accessitemid+" and t1.isvalid=1 and t1.type1=1 and t1.userid="+userid;
	if(!itemdesc.equals("-1")) sql += " and t2.description='"+itemdesc+"'";
	if(yearfrom==yearto){
		sql += " and t1.year="+yearfrom+" and t1.type2>="+monthfrom+" and t1.type2<="+ monthto;
	}else{
		sql += " and ((t1.year="+yearfrom+" and t1.type2>="+monthfrom+") or (t1.year="+yearto+" t1.type2<="+ monthto+"))";
	}
	sql += " order by t1.year,t1.type2";
	//System.out.println(sql);
	rs.executeSql(sql);
	int year = 0;
	int month = 0;
	Map targetmap = new HashMap();
	Map resultmap = new HashMap();
	while(rs.next()){
		year = Util.getIntValue(rs.getString("year"));
		month = Util.getIntValue(rs.getString("type2"));
		targetmap.put(year+"-"+((month<10)?"0"+month:month),rs.getString("target1"));
		resultmap.put(year+"-"+((month<10)?"0"+month:month),rs.getString("result1"));
	}
	
	String targets = "";
	String results = "";
	String titles = ""; 
	String ymstr = "";
	
	double target = 0;
	double result = 0;
	double maxval = 0;
	String maxvalue = "";
	
	if(yearfrom!=yearto){
		for(int i=monthfrom;i<=12;i++){
			ymstr = yearfrom+"-"+((i<10)?"0"+i:i);
			titles += ",'" + ymstr.substring(5,7) + "'";
			target = Util.getDoubleValue((String)targetmap.get(ymstr),0);
			targets += "," + this.round(target+"",2);
			result = Util.getDoubleValue((String)resultmap.get(ymstr),0);
			results += "," + this.round(result+"",2);
			
			if(target>maxval) maxval = Util.getDoubleValue(this.round(target*1.1+"",2));
			if(result>maxval) maxval = Util.getDoubleValue(this.round(result*1.1+"",2));
		}
		for(int i=1;i<=monthto;i++){
			ymstr = yearto+"-"+((i<10)?"0"+i:i);
			titles += ",'" + ymstr.substring(5,7) + "'";
			target = Util.getDoubleValue((String)targetmap.get(ymstr),0);
			targets += "," + this.round(target+"",2);
			result = Util.getDoubleValue((String)resultmap.get(ymstr),0);
			results += "," + this.round(result+"",2);
			
			if(target>maxval) maxval = Util.getDoubleValue(this.round(target*1.1+"",2));
			if(result>maxval) maxval = Util.getDoubleValue(this.round(result*1.1+"",2));
		}
	}else{
		for(int i=monthfrom;i<=monthto;i++){
			ymstr = yearto+"-"+((i<10)?"0"+i:i);
			titles += ",'" + ymstr.substring(5,7) + "'";
			target = Util.getDoubleValue((String)targetmap.get(ymstr),0);
			targets += "," + this.round(target+"",2);
			result = Util.getDoubleValue((String)resultmap.get(ymstr),0);
			results += "," + this.round(result+"",2);
			
			if(target>maxval) maxval = Util.getDoubleValue(this.round(target*1.1+"",2));
			if(result>maxval) maxval = Util.getDoubleValue(this.round(result*1.1+"",2));
		}
	}
	titles = "[" + titles.substring(1) + "]";
	targets = "[" + targets.substring(1) + "]";
	results = "[" + results.substring(1) + "]";
	
	
%>
	<div id="reportdiv" style="width: 100%;height: 100%"></div>
	<script type="text/javascript" >
		$(document).ready(function() {
	        var chart = new Highcharts.Chart({
	            chart: {
	        		borderWidth: 0,
	        		plotShadow: false,
	        		backgroundColor: 'none',
	                renderTo: 'reportdiv',
	                zoomType: 'xy'
	            },
	            title: {
	                text: ''
	            },
	            subtitle: {
	                text: ''
	            },
	            xAxis: [{
	                categories: <%=titles%>
	            }],
	            yAxis: [{ // Primary yAxis
	            	//tickInterval:50,
	            	max:<%=maxval%>,
	                min:0,
	                labels: {
	            	 	enabled: true
	                },
	                title: {
	                    text: ''
	                }
	            }, { // Secondary yAxis
	            	//tickInterval:50,
	            	max:<%=maxval%>,
	                min:0,
	            	labels: {
	            	 	enabled: false
	                },
	                title: {
	                    text: ''
	                }
	            }],
	            tooltip: {
	            	borderRadius: 2,
	            	borderWidth: 1,
	            	shadow: false,
	                formatter: function() {
	                    var unit = {
	                        '目标值': '<%=AccessItemComInfo.getUnit(accessitemid)%>',
	                        '完成值': '<%=AccessItemComInfo.getUnit(accessitemid)%>'
	                    }[this.series.name];
	    
	                    return ''+
	                        this.x +'月'+this.series.name+': '+ this.y +' '+ unit;
	                }
	            },
	            legend: {
	            	borderWidth:0
	            },
	            series: [{
	            	borderWidth: 0,
	            	plotShadow: false,
	                name: '目标值',
	                color: '#4572A7',
	                type: 'column',
	                yAxis: 0,
	                data: <%=targets%>,
	                dataLabels: {
	                    enabled: true,
	                    rotation: 0,
	                    color: '#4572A7',
	                    align: 'center',
	                    x: 0,
	                    y: 0,
	                    style: {
	                        fontSize: '13px',
	                        fontFamily: 'Verdana, sans-serif'
	                    }
	                }
	            }, {
	                name: '完成值',
	                type: 'spline',
	                color: '#AA4643',
	                yAxis: 1,
	                data: <%=results%>,
	                marker: {
	                    enabled: false
	                }
	    
	            }]
	        });
	    });
	</script>
<%!
	/**
	 * 对金额进行四舍五入
	 * @param s 金额字符串
	 * @param len 小数位数
	 * @return
	 */
	public static String round(String s,int len){
		if (s == null || s.length() < 1) {
			return "";
		}
		NumberFormat formater = null;
		double num = Double.parseDouble(s);
		if (len == 0) {
			formater = new DecimalFormat("##0");
		} else {
			StringBuffer buff = new StringBuffer();
			buff.append("##0.");
			for (int i = 0; i < len; i++) {
				buff.append("0");
			}
			formater = new DecimalFormat(buff.toString());
		}
		return formater.format(num);
	}
%>