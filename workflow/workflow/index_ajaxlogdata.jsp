<%@page import="net.sf.json.JSONArray"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="java.util.*"%>
<%@page import="net.sf.json.JSONObject"%>
<%
	RecordSet workflowtype = new RecordSet();
	RecordSet rs = new RecordSet();
  	String sql = "";
  	String sql2 = "";
  	
  	List datelistfirst = new ArrayList();
  	List datelistlast = new ArrayList();
  	List showdatelist = new ArrayList();
	try{
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd"); 
		SimpleDateFormat sdf=new SimpleDateFormat("yyyyMM");
		Calendar calendar = Calendar.getInstance();

		for(int n = 0;n<5;n++){
			//yyyy-MM-dd 第一天
			int index = 0;
			if(n!=0) index=-1;
			calendar.add(Calendar.MONTH, index);
			calendar.set(Calendar.DAY_OF_MONTH,1);
			datelistfirst.add(format.format(calendar.getTime()));
			//yyyyMM
			Date date = calendar.getTime();
			showdatelist.add(sdf.format(date));
			//yyyy-MM-dd 最后一天
	        calendar.set(Calendar.DAY_OF_MONTH, calendar.getActualMaximum(Calendar.DAY_OF_MONTH));  
	        datelistlast.add(format.format(calendar.getTime()));
		}
		List<Map<String, String>> logList = new ArrayList<Map<String, String>>();
		for(int m = 0;m<showdatelist.size();m++){
			String datetempfirst = datelistfirst.get(m).toString();
			String datetemplast = datelistlast.get(m).toString();
			
			String showdatetemp = showdatelist.get(m).toString();

			sql2 =  " SELECT count(DISTINCT relatedid) AS c FROM ( "+
				    " SELECT distinct relatedid FROM SysMaintenanceLog "+
				    " WHERE operateitem='85' AND relatedid IN (SELECT id FROM workflow_base) AND  operatedate >= '"+ datetempfirst+ "' AND operatedate <= '"+ datetemplast+ "'" +
				    " UNION ALL "+
				    "  SELECT DISTINCT workflowid FROM workflow_flownode WHERE nodeid IN ( "+
				    " 	SELECT count(distinct relatedid) FROM SysMaintenanceLog WHERE operateitem='86' AND  operatedate >= '"+ datetempfirst+ "' AND operatedate <= '"+ datetemplast+ "'" +
				    " ) "+
				    " UNION ALL "+
				    "  SELECT DISTINCT workflowid FROM workflow_nodelink WHERE id IN ( "+
				    " 	SELECT count(distinct relatedid) FROM SysMaintenanceLog WHERE operateitem='88' AND  operatedate >= '"+ datetempfirst+ "' AND operatedate <= '"+ datetemplast+ "'" +
				    " 	) "+
				    " 	) a ";
			
			rs.executeSql(sql2);
		  	while(rs.next()){
		  		Map<String,String> map = new HashMap<String,String>();
		  		map.put("opdate",showdatetemp);
		  		map.put("count",rs.getString("c"));
		  		//map.put();
		  		logList.add(map);
		  	}
			
		}
		
		JSONArray jsobject = JSONArray.fromObject(logList);
		response.getWriter().write(jsobject.toString());
	}catch(Exception e){
		e.printStackTrace();
	}
%>