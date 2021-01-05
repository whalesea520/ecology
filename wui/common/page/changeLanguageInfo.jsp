<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.general.Util"%>
<%@ page import="net.sf.json.JSONArray" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>
<jsp:useBean id="labelinfo" class="weaver.systeminfo.label.LabelComInfo" scope="page" />
<%
    String languageid =Util.null2String(request.getParameter("languageid"));
    if("".equals(languageid)){
        languageid="7";
    }
    String loginId = labelinfo.getLabelname("83594",languageid);
    String password = labelinfo.getLabelname("409",languageid);
    String forgetPassword = labelinfo.getLabelname("81614",languageid);

    String login = labelinfo.getLabelname("674",languageid);
    String validateCode = labelinfo.getLabelname("84270",languageid);
    String tokenAuthKey = labelinfo.getLabelname("84271",languageid);
    String qrcodePrompt = labelinfo.getLabelname("84272",languageid);
    String backbtn=labelinfo.getLabelname("131938",languageid);
    
    String msg16647=labelinfo.getLabelname("16647",languageid);
    String msg16648=labelinfo.getLabelname("16648",languageid);
    String msg84270=labelinfo.getLabelname("84270",languageid);
    String msg127899=labelinfo.getLabelname("127899",languageid);
    String msg31479=labelinfo.getLabelname("31479",languageid);
    String msg16641=labelinfo.getLabelname("16641",languageid);
    String msg127901=labelinfo.getLabelname("127901",languageid);
    String msg127902=labelinfo.getLabelname("127902",languageid);
    String msg127903=labelinfo.getLabelname("127903",languageid);
    String msg20289=labelinfo.getLabelname("20289",languageid);
    String msg81913=labelinfo.getLabelname("81913",languageid);
    String msg81914=labelinfo.getLabelname("81914",languageid);
    String msg84255=labelinfo.getLabelname("84255",languageid);
    String msg22909=labelinfo.getLabelname("22909",languageid);
    String msg84271=labelinfo.getLabelname("84271",languageid);
    String msg15172=labelinfo.getLabelname("15172",languageid);
    String msg826=labelinfo.getLabelname("826",languageid);
    
    String msg132147=labelinfo.getLabelname("132147",languageid);
    

    JSONArray jsonArray = new JSONArray();

    JSONObject backbtnObj=new JSONObject();
    backbtnObj.put("key","backbtn");
    backbtnObj.put("value",backbtn);
    backbtnObj.put("id","131938");

    JSONObject loginIdObj=new JSONObject();
    loginIdObj.put("key","for_loginid");
    loginIdObj.put("value",loginId);
    loginIdObj.put("id","83594");
    JSONObject passwordObj=new JSONObject();
    passwordObj.put("key","for_userpassword");
    passwordObj.put("value",password);
    passwordObj.put("id","409");
    JSONObject forgetPasswordObj=new JSONObject();
    forgetPasswordObj.put("key","forgotpassword");
    forgetPasswordObj.put("value",forgetPassword);
    forgetPasswordObj.put("id","81614");
    JSONObject loginObj=new JSONObject();
    loginObj.put("key","login");
    loginObj.put("id","674");
    loginObj.put("value",login);
    JSONObject validateCodeObj=new JSONObject();
    validateCodeObj.put("key","for_validatecode");
    validateCodeObj.put("id","84270");
    validateCodeObj.put("value",validateCode);
    JSONObject tokenAuthKeyObj=new JSONObject();
    tokenAuthKeyObj.put("key","for_tokenAuthKey");
    tokenAuthKeyObj.put("id","84271");
    tokenAuthKeyObj.put("value",tokenAuthKey);
    JSONObject qrCodePromptObj=new JSONObject();
    qrCodePromptObj.put("key","qrcodePrompt");
    qrCodePromptObj.put("id","84272");
    qrCodePromptObj.put("value",qrcodePrompt);
    
    JSONObject errMessage16647  =new JSONObject();
	JSONObject errMessage16648  =new JSONObject();
	JSONObject errMessage84270  =new JSONObject();
	JSONObject errMessage127899 =new JSONObject();
	JSONObject errMessage31479  =new JSONObject();
	JSONObject errMessage16641  =new JSONObject();
	JSONObject errMessage127901 =new JSONObject();
	JSONObject errMessage127902 =new JSONObject();
	JSONObject errMessage127903 =new JSONObject();
	JSONObject errMessage20289  =new JSONObject();
	JSONObject errMessage81913  =new JSONObject();
	JSONObject errMessage81914  =new JSONObject();
	JSONObject errMessage84255  =new JSONObject();
	JSONObject errMessage22909  =new JSONObject();
	JSONObject errMessage84271  =new JSONObject();
	JSONObject errMessage15172  =new JSONObject();
	JSONObject errMessage826  =new JSONObject();
	JSONObject errMessage132147  =new JSONObject();
	

    errMessage16647.put("id","16647");
    errMessage16648.put("id","16648");
    errMessage84270.put("id","84270");
    errMessage127899.put("id","127899");
    errMessage31479.put("id","31479");
    errMessage16641.put("id","16641");
    errMessage127901.put("id","127901");
    errMessage127902.put("id","127902");
    errMessage127903.put("id","127903");
    errMessage20289.put("id","20289");
    errMessage81913.put("id","81913");
    errMessage81914.put("id","81914");
    errMessage84255.put("id","84255");
    errMessage22909.put("id","22909");
    errMessage84271.put("id","84271");
    errMessage15172.put("id","15172");
    errMessage826.put("id","826");
   	errMessage132147.put("id","132147");
    
    errMessage16647.put("value",msg16647);
	errMessage16648.put("value",msg16648);
	errMessage84270.put("value",msg84270);
	errMessage127899.put("value",msg127899);
	errMessage31479.put("value",msg31479);
	errMessage16641.put("value",msg16641);
	errMessage127901.put("value",msg127901);
	errMessage127902.put("value",msg127902);
	errMessage127903.put("value",msg127903);
	errMessage20289.put("value",msg20289);
	errMessage81913.put("value",msg81913);
	errMessage81914.put("value",msg81914);
	errMessage84255.put("value",msg84255);
	errMessage22909.put("value",msg22909);
    errMessage84271.put("value",msg84271);
    errMessage15172.put("value",msg15172);
    errMessage826.put("value",msg826);
   	errMessage132147.put("value",msg132147);
    
    jsonArray.add(loginIdObj);
    jsonArray.add(passwordObj);
    jsonArray.add(forgetPasswordObj);
    jsonArray.add(loginObj);
    jsonArray.add(validateCodeObj);
    jsonArray.add(tokenAuthKeyObj);
    jsonArray.add(qrCodePromptObj);
    jsonArray.add(backbtnObj);
    
    jsonArray.add(errMessage16647);
	jsonArray.add(errMessage16648);
	jsonArray.add(errMessage84270);
	jsonArray.add(errMessage127899);
	jsonArray.add(errMessage31479);
	jsonArray.add(errMessage16641);
	jsonArray.add(errMessage127901);
	jsonArray.add(errMessage127902);
	jsonArray.add(errMessage127903);
	jsonArray.add(errMessage20289);
	jsonArray.add(errMessage81913);
	jsonArray.add(errMessage81914);
	jsonArray.add(errMessage84255);
	jsonArray.add(errMessage22909);
	jsonArray.add(errMessage84271);
	jsonArray.add(errMessage15172);
	jsonArray.add(errMessage826);
	jsonArray.add(errMessage132147);
	
    for(int i=0;i<jsonArray.size();i++){
        JSONObject eachObj=(JSONObject)jsonArray.get(i);
        Object labelObj=eachObj.get("value");
        String label="";
        String id=eachObj.get("id").toString();
        if(labelObj==null||labelObj.equals("null")||"".equals(labelObj)){
            label = labelinfo.getLabelname(Integer.parseInt(id),7);
            eachObj.put("value",label);
        }else{
            label=labelObj.toString();
        }
        if(Integer.parseInt(languageid)==8){
            label+=" ";
            eachObj.put("value",label);
        }
    }
    out.println(jsonArray.toString());
%>