<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.general.TimeUtil"%>
<%@ page import="weaver.general.BaseBean"%>
<%@ page import="java.util.*"%>
<%@ page import="com.alibaba.fastjson.*"%>
<%@ page import="com.alibaba.fastjson.serializer.SerializerFeature"%>
<%@ page import="weaver.hrm.HrmUserVarify"%>
<%@ page import="weaver.hrm.User"%>
<%@ page import="weaver.govern.interfaces.*"%>
<%@ page import="weaver.hrm.company.DepartmentComInfo"%>
<%@ page import="weaver.hrm.company.SubCompanyComInfo"%>
<jsp:useBean id="JobComInfo" class="weaver.hrm.check.JobComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<%
	String action = Util.null2String(request.getParameter("action"));
	User user = HrmUserVarify.getUser(request, response);
	String returnStr = "";
	JSONObject map = new JSONObject();
	if("getTextById".equals(action)){
		String ids = Util.null2String(request.getParameter("ids"));
		String selectedId = Util.null2String(request.getParameter("selectedId"));
		selectedId = selectedId.equals(selectedId)?"0":selectedId;
		SubCompanyComInfo sc = new SubCompanyComInfo();//部门缓存类
		
		String sql = "select u.id id,u.zw content,u.bt title,u.bsdw unit,u.lm typeid,l.name type from uf_xxcb_dbInfo u left join uf_xxcb_kxSet_dt1 l on u.lm=l.id where u.id in ("+ids+") order by id";
		RecordSet.execute(sql);
		
		List<Map<String,String>> list = new ArrayList<Map<String,String>>();
		while(RecordSet.next()){
			Map<String,String> map0 = new HashMap<String,String>();
			String id = Util.null2String(RecordSet.getString("id"));
			String title = Util.null2String(RecordSet.getString("title"));
			title = title.replaceAll("&nbsp;"," ").replaceAll("<br>","\n");
			String unit = Util.null2String(RecordSet.getString("unit"));
			String typeid = Util.null2String(RecordSet.getString("typeid"));
			String type = Util.null2String(RecordSet.getString("type"));
			String content = Util.null2String(RecordSet.getString("content"));
			content = content.replaceAll("&nbsp;"," ").replaceAll("<br>","\n");
			map0.put("id",id);
			map0.put("title",title);
			map0.put("unitid",unit);
			map0.put("unit",sc.getSubCompanyname(unit));
			map0.put("typeid",typeid);
			map0.put("type",type);
			map0.put("content",content);
			list.add(map0);
		}
		//Map<String, Object> apidatas = new HashMap<String, Object>();
		map.put("data",list);
		//returnStr = JSON.toJSONString(apidatas,SerializerFeature.DisableCircularReferenceDetect);
	}else if("getFields".equals(action)){
		String id = Util.null2String(request.getParameter("id"));
		String sql = "select * from uf_xxcb_dbInfo where id='"+id+"'";
		SubCompanyComInfo sc = new SubCompanyComInfo();
		RecordSet.execute(sql);
		//Map<String,String> map = new HashMap<String,String>();
		if(RecordSet.next()){
			String bt = Util.null2String(RecordSet.getString("bt"));
			String bsdw = Util.null2String(RecordSet.getString("bsdw"));
			String fj = Util.null2String(RecordSet.getString("zw"));
			String mj = Util.null2String(RecordSet.getString("mj"));
			String bsrq = Util.null2String(RecordSet.getString("bsrq"));
			String xxly = Util.null2String(RecordSet.getString("xxly"));
			
			map.put("bt",bt);
			map.put("bsdw",bsdw);
			map.put("bsdwname",sc.getSubCompanyname(bsdw));
			map.put("fj",fj);
			map.put("mj",mj);
			map.put("bt",bt);
			map.put("bsrq",bsrq);
			map.put("xxly",xxly);
		}
		//returnStr = JSON.toJSONString(map,SerializerFeature.DisableCircularReferenceDetect);
	}else if("getKxSet".equals(action)){
		String id = Util.null2String(request.getParameter("id"));
		String sql = "select * from uf_xxcb_kxSet where id='"+id+"'";
		RecordSet.execute(sql);
		//Map<String,String> map = new HashMap<String,String>();
		if(RecordSet.next()){
			String name = Util.null2String(RecordSet.getString("name"));
			map.put("name",name);
		}
		//returnStr = JSON.toJSONString(map,SerializerFeature.DisableCircularReferenceDetect);
	}else if("checkData".equals(action)){
		int billid = Util.getIntValue(Util.null2String(request.getParameter("billid")));
		CheckDetailAction cda = new CheckDetailAction();
		cda.checkDetail(user.getUID(),billid);
	}else if("onDetailChange".equals(action)){
		int billid = Util.getIntValue(Util.null2String(request.getParameter("billid")));
		String jsonData = Util.null2String(request.getParameter("jsonData"));
		CheckDetailAction cda = new CheckDetailAction();
		cda.checkDetail(jsonData,user.getUID(),billid);
		//Map<String,String> map = new HashMap<String,String>();
		map.put("success","true");
		//returnStr = JSON.toJSONString(map,SerializerFeature.DisableCircularReferenceDetect);
	}else if("checkkx".equals(action)){
		String ids = Util.null2String(request.getParameter("ids"));
		if(ids.startsWith(","))
			ids = ids.substring(1);
		if(ids.endsWith(","))
			ids = ids.substring(0,ids.length()-1);
		RecordSet.execute("select count(distinct kx) count from uf_xxcb_dbInfo where id in ("+ids+")");
		int count = 0;
		if(RecordSet.next()){
			count = RecordSet.getInt("count");
		}
		RecordSet.execute("select kx from uf_xxcb_dbInfo where id in ("+ids+")");
		String kx = "";
		if(RecordSet.next())
			kx = RecordSet.getString("kx");
		//Map<String,Object> map = new HashMap<String,Object>();
		map.put("count",count);
		map.put("kx",kx);
		map.put("selected",ids);
		//returnStr = JSON.toJSONString(map,SerializerFeature.DisableCircularReferenceDetect);
	}else if("getKxIndex".equals(action)){
		String id = Util.null2String(request.getParameter("id"));
		String year = Util.null2String(request.getParameter("year"));
		String sqlWhere = "";
		String sxzq = "";
		RecordSet.execute("select * from uf_xxcb_kxSet where id="+id);
		if(RecordSet.next()){
			String kxtype = Util.null2String(RecordSet.getString("kxtype"));
			if("1".equals(kxtype)){
				sxzq = TimeUtil.getCurrentDateString().substring(0,7);
				sqlWhere = " and sxzq='"+sxzq+"'";
			}else if("2".equals(kxtype)){
				sxzq = TimeUtil.getCurrentDateString().substring(0,4);
				sqlWhere = " and sxzq='"+sxzq+"'";
			}
		}
		RecordSet.execute("select max(periods) periods from uf_xxcb_pbInfo where journal="+id+sqlWhere);
		int index = 0;
		if(RecordSet.next()){
			index = RecordSet.getInt("periods")+1;
		}
		if(index<=0){
			index = 1;
		}
		//Map<String,Object> map = new HashMap<String,Object>();
		map.put("index",index);
		map.put("sxzq",sxzq);
		//returnStr = JSON.toJSONString(map,SerializerFeature.DisableCircularReferenceDetect);
	}else if("getDbxx".equals(action)){
		SubCompanyComInfo sc = new SubCompanyComInfo();//部门缓存类
		String id = Util.null2String(request.getParameter("id"));
		RecordSet.execute("select * from uf_xxcb_dbInfo where id="+id);
		//Map<String,Object> map = new HashMap<String,Object>();
		String[] sa = RecordSet.getColumnName();
		if(RecordSet.next()){
			for(String str : sa){
				map.put(str.toLowerCase(),Util.null2String(RecordSet.getString(str)));
				if("bsdw".equals(str.toLowerCase())){
					String bsdw = Util.null2String(RecordSet.getString(str));
					map.put(str.toLowerCase(),"<a href=\"/hrm/company/HrmSubCompanyDsp.jsp?id="+bsdw+"\" target=\"_new\">"+sc.getSubCompanyname(bsdw)+"</a>&nbsp;&nbsp");
				}else if("zw".equals(str.toLowerCase())){
					String zw = Util.null2String(RecordSet.getString(str));
					zw = zw.replaceAll("\\n","<br>");
					map.put(str.toLowerCase(),zw);
				}
			}
		}
		map.put("success",true);
		//returnStr = JSON.toJSONString(map,SerializerFeature.DisableCircularReferenceDetect);
	}else if("getPbFields".equals(action)){
		RecordSet.execute("select * from workflow_bill where tablename='uf_xxcb_pbInfo'");
		//Map<String,Object> map = new HashMap<String,Object>();
		if(RecordSet.next()){
			String formid = Util.null2String(RecordSet.getString("id"));
			RecordSet.execute("select * from workflow_billfield where billid='"+formid+"' and (detailtable is null or detailtable='')");
			while(RecordSet.next()){
				String id = Util.null2String(RecordSet.getString("id"));
				String fieldname = Util.null2String(RecordSet.getString("fieldname"));
				map.put(fieldname,id);
			}
		}
		//returnStr = JSON.toJSONString(map,SerializerFeature.DisableCircularReferenceDetect);
	}else if("saveDbxx".equals(action)){
		SubCompanyComInfo sc = new SubCompanyComInfo();//部门缓存类
		String editid = Util.null2String(request.getParameter("editid"));
		String bt = Util.null2String(request.getParameter("bt"));
		bt = bt.replaceAll("'","''");
		String bsdw = Util.null2String(request.getParameter("bsdw"));
		String zw = Util.null2String(request.getParameter("zw"));
		zw = zw.replaceAll("'","''");
		String bsrq = Util.null2String(request.getParameter("bsrq"));
		String qs = Util.null2String(request.getParameter("qs"));
		String mj = Util.null2String(request.getParameter("mj"));
		String ly = Util.null2String(request.getParameter("ly"));
		//Map<String,Object> map = new HashMap<String,Object>();
		boolean flag = false;
		if(!"".equals(editid)){
			flag = RecordSet.execute("update uf_xxcb_dbInfo set bt='"+bt+"',bsdw='"+bsdw
					+"',zw='"+zw+"',bsrq='"+bsrq+"',mj='"+mj+"',xxly='"+ly+"' where id='"+editid+"' ");
		}
		map.put("flag",flag);
		map.put("sbdw",sc.getSubCompanyname(bsdw));
		//returnStr = JSON.toJSONString(map,SerializerFeature.DisableCircularReferenceDetect);
	}else if("getOperators".equals(action)){
		String sp_zt = Util.null2String(request.getParameter("hj"));
		String settingField = ("".equals(sp_zt)||"0".equals(sp_zt))?"lgshuser":("1".equals(sp_zt)?"lgqfuser":"lgdguser");
		RecordSet.execute("select * from uf_xxcb_sysSet where id=1");
		String operator = "";
		if(RecordSet.next()){
			operator = Util.null2String(RecordSet.getString(settingField));
		}
		String[] operators = operator.split(",");
		List<Map<String,Object>> list = new ArrayList<Map<String,Object>>();
		for(int i=0;i<operators.length;i++){
			Map<String,Object> map0 = new HashMap<String,Object>();
			map0.put("id",operators[i]);
			map0.put("lastName",ResourceComInfo.getLastname(operators[i]));
			map0.put("jobTitle",JobComInfo.getJobName(ResourceComInfo.getJobTitle(operators[i])));
			list.add(map0);
		}
		//Map<String, Object> apidatas = new HashMap<String, Object>();
		map.put("data",list);
		//returnStr = JSON.toJSONString(apidatas,SerializerFeature.DisableCircularReferenceDetect);
	}else if("selectOperators".equals(action)){
		String hj = Util.null2String(request.getParameter("hj"));
		String operator = Util.null2String(request.getParameter("operator"));
		String fwid = Util.null2String(request.getParameter("fwid"));
		boolean flag = false;
		String message = "";
		if(!"".equals(hj)&&!"".equals(operator)&&!"".equals(fwid)){
			String czField = "0".equals(hj)?"sh_operator":("1".equals(hj)?"qf_operator":"dg_operator");
			String rqField = "0".equals(hj)?"sh_rq":("1".equals(hj)?"qf_rq":"dg_rq");
			String sjField = "0".equals(hj)?"sh_sj":("1".equals(hj)?"qf_sj":"dg_sj");
			String curdate = TimeUtil.getCurrentDateString();
			String curtime = TimeUtil.getOnlyCurrentTimeString().substring(0,5);
			String sql = "update uf_xxcb_pbInfo set "+czField+"='"+operator+"',"+
				rqField+"='"+curdate+"',"+sjField+"='"+curtime+"',sp_operator='"+operator+
				"',kw_zt=1,sp_zt='"+hj+"' where id="+fwid;
			new BaseBean().writeLog(sql);
			flag = RecordSet.execute(sql);
		}else{
			message = "参数错误";
		}
		//Map<String, Object> apidatas = new HashMap<String, Object>();
		map.put("flag",flag);
		map.put("message",message);
		//returnStr = JSON.toJSONString(apidatas,SerializerFeature.DisableCircularReferenceDetect);
	}
	
	out.clear();
	out.print(map.toString());
	
	/*response.setContentType("application/x-www-form-urlencoded; charset=utf-8");
	response.getWriter().write(returnStr);
	response.getWriter().flush();
	response.getWriter().close();*/
%>