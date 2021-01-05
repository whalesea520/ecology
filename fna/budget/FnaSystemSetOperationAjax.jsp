<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="org.json.JSONObject"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.conn.RecordSet"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%
User user = HrmUserVarify.getUser (request , response) ;
if(!HrmUserVarify.checkUserRight("FnaSystemSetEdit:Edit", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}

boolean flag = true;
String msg = "";

RecordSet rs = new RecordSet();

int subjectFilter = Util.getIntValue(request.getParameter("subjectFilter"),0);//启用科目过滤
int subjectCodeUniqueCtrl = Util.getIntValue(request.getParameter("subjectCodeUniqueCtrl"),0);//科目编码校验规则（预算科目编码）
int subjectCodeUniqueCtrl2 = Util.getIntValue(request.getParameter("subjectCodeUniqueCtrl2"),0);//科目编码校验规则（会计科目编码）
int fnaBudgetOAOrg = Util.getIntValue(request.getParameter("fnaBudgetOAOrg"),0);
int fnaBudgetCostCenter = Util.getIntValue(request.getParameter("fnaBudgetCostCenter"),0);

if(flag){
	if(subjectFilter!=1){
		if(subjectCodeUniqueCtrl==2){//按科目应用范围唯一
			flag = false;
			msg = SystemEnv.getHtmlLabelName(132120,user.getLanguage());//不启用【科目应用范围】则无法按科目应用范围进行科目编码的唯一控制
		}
	}
}

if(flag){
	if(subjectFilter!=1){
		if(subjectCodeUniqueCtrl2==2){//按科目应用范围唯一
			flag = false;
			msg = SystemEnv.getHtmlLabelName(132120,user.getLanguage());//不启用【科目应用范围】则无法按科目应用范围进行科目编码的唯一控制
		}
	}
}

if(flag){
	boolean successFlag = true;
	String _codeName = "";
	if(subjectCodeUniqueCtrl==0){//全局唯一
		if(successFlag){
			rs.executeQuery("select a.codeName, COUNT(*) cnt \n" +
					" from FnaBudgetfeeType a  \n" +
					" where (a.codeName is not null and a.codeName <> '')\n" +
					" group by a.codeName \n" +
					" HAVING COUNT(*) > 1 ");
			if(rs.next() && rs.getInt("cnt") > 1){
				successFlag = false;
				_codeName = Util.null2String(rs.getString("codeName")).trim();
			}
		}
	}else if(subjectFilter==1 && (subjectCodeUniqueCtrl==2 || subjectCodeUniqueCtrl==3)){//按科目应用范围唯一（分部级/部门级）
		String typ_condSql = "1=2";
		if(subjectCodeUniqueCtrl==2){//按科目应用范围唯一（分部级）
			typ_condSql = "(b.type<>0 and b.type<>2)";
		}else if(subjectCodeUniqueCtrl==3){//按科目应用范围唯一（部门级）
			typ_condSql = "(b.type<>0 and b.type<>1)";
		}
		if(fnaBudgetOAOrg==0){
			typ_condSql += " and (b.type<>0 and b.type<>1 and b.type<>2)";
		}
		if(fnaBudgetCostCenter==0){
			typ_condSql += " and (b.type<>18004)";
		}
		
		List<String> _codeNameList = new ArrayList<String>();
		if(successFlag){
			rs.executeQuery("select a.codeName, COUNT(*) cnt \n" +
					" from fnabudgetfeetype a \n" +
					" where 1=1 \n" +
					" and (\n" +
					"   NOT EXISTS (select 1 from FnabudgetfeetypeRuleSet b where "+typ_condSql+" and a.id = b.mainid)\n" +
					" ) \n" +
					" and (a.codeName is not null and a.codeName <> '')\n" +
					" group by a.codeName");
			while(rs.next()){
				int _cnt = rs.getInt("cnt");
				String _codeName1 = Util.null2String(rs.getString("codeName")).trim();
				_codeName = _codeName1;
				_codeNameList.add(_codeName1);
				if(_cnt > 1){
					successFlag = false;
					break;
				}
			}
		}
		if(successFlag){
			rs.executeQuery("select a.codeName, COUNT(*) cnt \n" +
					" from fnabudgetfeetype a \n" +
					" where 1=1 \n" +
					" and (\n" +
					"   EXISTS (select 1 from FnabudgetfeetypeRuleSet b where "+typ_condSql+" and a.id = b.mainid)\n" +
					" ) \n" +
					" and (a.codeName is not null and a.codeName <> '')\n" +
					" group by a.codeName");
			while(rs.next()){
				String _codeName1 = Util.null2String(rs.getString("codeName")).trim();
				_codeName = _codeName1;
				if(_codeNameList.contains(_codeName1)){
					successFlag = false;
					break;
				}
			}
		}
		if(successFlag){
			rs.executeQuery("select a.codeName, b.type, b.orgid, COUNT(*) cnt \n" +
					" from fnabudgetfeetype a \n" +
					" join FnabudgetfeetypeRuleSet b on a.id = b.mainid \n" +
					" where "+typ_condSql+" and (a.codeName is not null and a.codeName <> '')\n" +
					" group by a.codeName, b.type, b.orgid ");
			if(rs.next() && rs.getInt("cnt") > 1){
				successFlag = false;
				_codeName = Util.null2String(rs.getString("codeName")).trim();
			}
		}
	}
	if(!successFlag){
		flag = false;
		msg = SystemEnv.getHtmlLabelNames("132121,21108",user.getLanguage())+"："+_codeName;//科目编码存在重复！请先调整数据！
	}
}

if(flag){
	boolean successFlag = true;
	String _codeName = "";
	if(subjectCodeUniqueCtrl2==0){//全局唯一
		if(successFlag){
			rs.executeQuery("select a.codeName2, COUNT(*) cnt \n" +
					" from FnaBudgetfeeType a  \n" +
					" where (a.codeName2 is not null and a.codeName2 <> '')\n" +
					" group by a.codeName2 \n" +
					" HAVING COUNT(*) > 1 ");
			if(rs.next() && rs.getInt("cnt") > 1){
				successFlag = false;
				_codeName = Util.null2String(rs.getString("codeName2")).trim();
			}
		}
	}else if(subjectFilter==1 && (subjectCodeUniqueCtrl2==2 || subjectCodeUniqueCtrl2==3)){//按科目应用范围唯一（分部级/部门级）
		String typ_condSql = "1=2";
		if(subjectCodeUniqueCtrl2==2){//按科目应用范围唯一（分部级）
			typ_condSql = "(b.type<>0 and b.type<>2)";
		}else if(subjectCodeUniqueCtrl2==3){//按科目应用范围唯一（部门级）
			typ_condSql = "(b.type<>0 and b.type<>1)";
		}
		if(fnaBudgetOAOrg==0){
			typ_condSql += " and (b.type<>0 and b.type<>1 and b.type<>2)";
		}
		if(fnaBudgetCostCenter==0){
			typ_condSql += " and (b.type<>18004)";
		}
		
		List<String> _codeNameList = new ArrayList<String>();
		if(successFlag){
			rs.executeQuery("select a.codeName2, COUNT(*) cnt \n" +
					" from fnabudgetfeetype a \n" +
					" where 1=1 \n" +
					" and (\n" +
					"   NOT EXISTS (select 1 from FnabudgetfeetypeRuleSet b where "+typ_condSql+" and a.id = b.mainid)\n" +
					" ) \n" +
					" and (a.codeName2 is not null and a.codeName2 <> '')\n" +
					" group by a.codeName2");
			while(rs.next()){
				int _cnt = rs.getInt("cnt");
				String _codeName1 = Util.null2String(rs.getString("codeName2")).trim();
				_codeName = _codeName1;
				_codeNameList.add(_codeName1);
				if(_cnt > 1){
					successFlag = false;
					break;
				}
			}
		}
		if(successFlag){
			rs.executeQuery("select a.codeName2, COUNT(*) cnt \n" +
					" from fnabudgetfeetype a \n" +
					" where 1=1 \n" +
					" and (\n" +
					"   EXISTS (select 1 from FnabudgetfeetypeRuleSet b where "+typ_condSql+" and a.id = b.mainid)\n" +
					" ) \n" +
					" and (a.codeName2 is not null and a.codeName2 <> '')\n" +
					" group by a.codeName2");
			while(rs.next()){
				String _codeName1 = Util.null2String(rs.getString("codeName2")).trim();
				_codeName = _codeName1;
				if(_codeNameList.contains(_codeName1)){
					successFlag = false;
					break;
				}
			}
		}
		if(successFlag){
			rs.executeQuery("select a.codeName2, b.type, b.orgid, COUNT(*) cnt \n" +
					" from fnabudgetfeetype a \n" +
					" join FnabudgetfeetypeRuleSet b on a.id = b.mainid \n" +
					" where "+typ_condSql+" and (a.codeName2 is not null and a.codeName2 <> '')\n" +
					" group by a.codeName2, b.type, b.orgid ");
			if(rs.next() && rs.getInt("cnt") > 1){
				successFlag = false;
				_codeName = Util.null2String(rs.getString("codeName2")).trim();
			}
		}
	}
	if(!successFlag){
		flag = false;
		msg = SystemEnv.getHtmlLabelNames("132121,21108",user.getLanguage())+"："+_codeName;//科目编码存在重复！请先调整数据！
	}
}



out.println("{\"flag\":"+String.valueOf(flag)+",\"msg\":"+JSONObject.quote(msg)+"}");
out.flush();
return;
































%>