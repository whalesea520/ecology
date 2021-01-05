<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.crypto.Cipher"%>
<%@ page import="javax.crypto.spec.IvParameterSpec"%>
<%@ page import="javax.crypto.spec.SecretKeySpec"%>
<%@ page import="java.lang.reflect.Method"%>
<%@ page import="net.sf.json.JSONObject" %>
<%@ page import="weaver.conn.RecordSet"%>

<%
try{
    String clientAddr = request.getRemoteAddr();

//if("0:0:0:0:0:0:0:1".equals(clientAddr) || "127.0.0.1".equals(clientAddr) || ("localhost".equals(clientAddr) || "10.45.49.99".equals(clientAddr)) || (clientAddr != null && (clientAddr.startsWith("10.") || clientAddr.startsWith("192.168.") || clientAddr.startsWith("172.")))){
	if(!checkDb()){
        response.setStatus(500);
        return;
    }
        
	String companyName = getLnMethodValue("getCompanyname");
	if(companyName == null || companyName.trim().length() == 0){
		getLnMethodValue("CkHrmnum"); //read ln file if companyname is null.
	}
	String expireDate = getLnMethodValue("getExpiredate");
	if(expireDate != null && expireDate.equals(lastExpireDate) && encLnStr != null){
        out.println(encLnStr);
        return;
	}
	
	JSONObject json = new JSONObject();
	//json.put("companyName", ln.getCompanyname());
	//json.put("concurrentFlag", ln.getConcurrentFlag());
	//json.put("ecologyBigVersion", ln.getEcologyBigVersion());
	//json.put("expiredate", ln.getExpiredate());
	//json.put("hrmnum", ln.getHrmnum());
	//json.put("resinVersion", com.caucho.Version.VERSION);
	
	json.put("ecologyCid", getLnMethodValue("getCid"));
	json.put("ecologyCompanyName", getLnMethodValue("getCompanyname"));
	json.put("ecologyConcurrentFlag", getLnMethodValue("getConcurrentFlag"));
	json.put("ecologyBigVersion", getLnMethodValue("getEcologyBigVersion"));
	json.put("ecologyExpiredate", expireDate);
	json.put("ecologyHrmnum", getLnMethodValue("getHrmnum"));
	json.put("ecologyLicensecode", getLnMethodValue("getLicensecode"));
	json.put("ecologyResinVersion", com.caucho.Version.VERSION);
	json.put("ecologyFileEncoding", System.getProperty("file.encoding"));
	
	out.println((encLnStr = encrypt(json.toString(), AESKEY)));
	lastExpireDate = expireDate;
	
//}
} finally {
    try{
        session.invalidate();
    } catch(Throwable t){
    }
}

%>
<%!
private static String encLnStr = null;
private static String lastExpireDate = null;
private static Class lnClass = null;
private static Object lnInstance = null;

private boolean checkDb(){
    return new RecordSet().executeSql("select 1 from license");
}

private String getLnMethodValue(String methodName){
	try {
		Class lnClass = getLnClass();
		Method m = lnClass.getMethod(methodName, null);
		return (String)m.invoke(getLnInstance(), null);
	} catch (Throwable t) {
	}
	return "";
}

private Class getLnClass(){
	if(lnClass == null){
		try {
			lnClass = Class.forName("ln.LN");
		} catch (ClassNotFoundException e) {
			try {
				lnClass = Class.forName("weaver.system.License");
			} catch (ClassNotFoundException e1) {
			} 
		}
	}
	return lnClass;
}
private Object getLnInstance(){
	if(lnInstance == null){
		try {
			lnInstance = getLnClass().newInstance();
		} catch (Throwable t) {
		}
	}
	return lnInstance;
}

private static final String ENCODING = "UTF-8";
private static final String TRANSFORMATION = "AES/ECB/PKCS5Padding";
private static final String AESKEY = "afFs4fv13df71KVp";
private static final String ALGORITHM = "AES";
private static final int BASELENGTH = 255;
private static final int LOOKUPLENGTH = 64;
private static final int TWENTYFOURBITGROUP = 24;
private static final int EIGHTBIT = 8;
private static final int SIXTEENBIT = 16;
private static final int FOURBYTE = 4;
private static final int SIGN = -128;
private static final byte PAD = (byte) '=';
private static byte[] base64Alphabet = new byte[BASELENGTH];
private static byte[] lookUpBase64Alphabet = new byte[LOOKUPLENGTH];
static {
	for (int i = 0; i < BASELENGTH; i++) {
		base64Alphabet[i] = -1;
	}
	for (int i = 'Z'; i >= 'A'; i--) {
		base64Alphabet[i] = (byte) (i - 'A');
	}
	for (int i = 'z'; i >= 'a'; i--) {
		base64Alphabet[i] = (byte) (i - 'a' + 26);
	}
	for (int i = '9'; i >= '0'; i--) {
		base64Alphabet[i] = (byte) (i - '0' + 52);
	}
	base64Alphabet['+'] = 62;
	base64Alphabet['/'] = 63;
	for (int i = 0; i <= 25; i++)
		lookUpBase64Alphabet[i] = (byte) ('A' + i);
	for (int i = 26, j = 0; i <= 51; i++, j++)
		lookUpBase64Alphabet[i] = (byte) ('a' + j);
	for (int i = 52, j = 0; i <= 61; i++, j++)
		lookUpBase64Alphabet[i] = (byte) ('0' + j);
	lookUpBase64Alphabet[62] = (byte) '+';
	lookUpBase64Alphabet[63] = (byte) '/';
}

/**
 * Encodes hex octects into Base64.
 * 
 * @param binaryData
 *          Array containing binary data to encode.
 * @return Base64-encoded data.
 */
private static byte[] encode64(byte[] binaryData) {
	int lengthDataBits = binaryData.length * EIGHTBIT;
	int fewerThan24bits = lengthDataBits % TWENTYFOURBITGROUP;
	int numberTriplets = lengthDataBits / TWENTYFOURBITGROUP;
	byte encodedData[] = null;
	if (fewerThan24bits != 0) {
		// data not divisible by 24 bit
		encodedData = new byte[(numberTriplets + 1) * 4];
	} else {
		// 16 or 8 bit
		encodedData = new byte[numberTriplets * 4];
	}
	byte k = 0, l = 0, b1 = 0, b2 = 0, b3 = 0;
	int encodedIndex = 0;
	int dataIndex = 0;
	int i = 0;
	// log.debug("number of triplets = " + numberTriplets);
	for (i = 0; i < numberTriplets; i++) {
		dataIndex = i * 3;
		b1 = binaryData[dataIndex];
		b2 = binaryData[dataIndex + 1];
		b3 = binaryData[dataIndex + 2];
		// log.debug("b1= " + b1 +", b2= " + b2 + ", b3= " + b3);
		l = (byte) (b2 & 0x0f);
		k = (byte) (b1 & 0x03);
		encodedIndex = i * 4;
		byte val1 = ((b1 & SIGN) == 0) ? (byte) (b1 >> 2)
				: (byte) ((b1) >> 2 ^ 0xc0);
		byte val2 = ((b2 & SIGN) == 0) ? (byte) (b2 >> 4)
				: (byte) ((b2) >> 4 ^ 0xf0);
		byte val3 = ((b3 & SIGN) == 0) ? (byte) (b3 >> 6)
				: (byte) ((b3) >> 6 ^ 0xfc);
		encodedData[encodedIndex] = lookUpBase64Alphabet[val1];
		// log.debug( "val2 = " + val2 );
		// log.debug( "k4 = " + (k<<4) );
		// log.debug( "vak = " + (val2 | (k<<4)) );
		encodedData[encodedIndex + 1] = lookUpBase64Alphabet[val2
				| (k << 4)];
		encodedData[encodedIndex + 2] = lookUpBase64Alphabet[(l << 2)
				| val3];
		encodedData[encodedIndex + 3] = lookUpBase64Alphabet[b3 & 0x3f];
	}
	// form integral number of 6-bit groups
	dataIndex = i * 3;
	encodedIndex = i * 4;
	if (fewerThan24bits == EIGHTBIT) {
		b1 = binaryData[dataIndex];
		k = (byte) (b1 & 0x03);
		// log.debug("b1=" + b1);
		// log.debug("b1<<2 = " + (b1>>2) );
		byte val1 = ((b1 & SIGN) == 0) ? (byte) (b1 >> 2)
				: (byte) ((b1) >> 2 ^ 0xc0);
		encodedData[encodedIndex] = lookUpBase64Alphabet[val1];
		encodedData[encodedIndex + 1] = lookUpBase64Alphabet[k << 4];
		encodedData[encodedIndex + 2] = PAD;
		encodedData[encodedIndex + 3] = PAD;
	} else if (fewerThan24bits == SIXTEENBIT) {
		b1 = binaryData[dataIndex];
		b2 = binaryData[dataIndex + 1];
		l = (byte) (b2 & 0x0f);
		k = (byte) (b1 & 0x03);
		byte val1 = ((b1 & SIGN) == 0) ? (byte) (b1 >> 2)
				: (byte) ((b1) >> 2 ^ 0xc0);
		byte val2 = ((b2 & SIGN) == 0) ? (byte) (b2 >> 4)
				: (byte) ((b2) >> 4 ^ 0xf0);
		encodedData[encodedIndex] = lookUpBase64Alphabet[val1];
		encodedData[encodedIndex + 1] = lookUpBase64Alphabet[val2 | (k << 4)];
		encodedData[encodedIndex + 2] = lookUpBase64Alphabet[l << 2];
		encodedData[encodedIndex + 3] = PAD;
	}
	return encodedData;
}

/**
 * Decodes Base64 data into octects
 * 
 * @param binaryData
 *          Byte array containing Base64 data
 * @return Array containing decoded data.
 */
private static byte[] decode64(byte[] base64Data) {
	// handle the edge case, so we don't have to worry about it later
	if (base64Data.length == 0) {
		return new byte[0];
	}
	int numberQuadruple = base64Data.length / FOURBYTE;
	byte decodedData[] = null;
	byte b1 = 0, b2 = 0, b3 = 0, b4 = 0, marker0 = 0, marker1 = 0;
	// Throw away anything not in base64Data
	int encodedIndex = 0;
	int dataIndex = 0;
	{
		// this sizes the output array properly - rlw
		int lastData = base64Data.length;
		// ignore the '=' padding
		while (base64Data[lastData - 1] == PAD) {
			if (--lastData == 0) {
				return new byte[0];
			}
		}
		decodedData = new byte[lastData - numberQuadruple];
	}
	for (int i = 0; i < numberQuadruple; i++) {
		dataIndex = i * 4;
		marker0 = base64Data[dataIndex + 2];
		marker1 = base64Data[dataIndex + 3];
		b1 = base64Alphabet[base64Data[dataIndex]];
		b2 = base64Alphabet[base64Data[dataIndex + 1]];
		if (marker0 != PAD && marker1 != PAD) {
			// No PAD e.g 3cQl
			b3 = base64Alphabet[marker0];
			b4 = base64Alphabet[marker1];
			decodedData[encodedIndex] = (byte) (b1 << 2 | b2 >> 4);
			decodedData[encodedIndex + 1] = (byte) (((b2 & 0xf) << 4) | ((b3 >> 2) & 0xf));
			decodedData[encodedIndex + 2] = (byte) (b3 << 6 | b4);
		} else if (marker0 == PAD) {
			// Two PAD e.g. 3c[Pad][Pad]
			decodedData[encodedIndex] = (byte) (b1 << 2 | b2 >> 4);
		} else if (marker1 == PAD) {
			// One PAD e.g. 3cQ[Pad]
			b3 = base64Alphabet[marker0];
			decodedData[encodedIndex] = (byte) (b1 << 2 | b2 >> 4);
			decodedData[encodedIndex + 1] = (byte) (((b2 & 0xf) << 4) | ((b3 >> 2) & 0xf));
		}
		encodedIndex += 3;
	}
	return decodedData;
}

public static String encrypt(String plainText, String encryptionKey)
		throws Exception {
	Cipher cipher = Cipher.getInstance(TRANSFORMATION);
	SecretKeySpec key = new SecretKeySpec(encryptionKey.getBytes(ENCODING),
			ALGORITHM);
	cipher.init(Cipher.ENCRYPT_MODE, key);
	return new String(
			encode64(cipher.doFinal(plainText.getBytes(ENCODING))),
			ENCODING);
}

public static String decrypt(String cipherString, String encryptionKey)
		throws Exception {
	byte[] cipherText = decode64(cipherString.getBytes(ENCODING));
	Cipher cipher = Cipher.getInstance(TRANSFORMATION);
	SecretKeySpec key = new SecretKeySpec(encryptionKey.getBytes(ENCODING),
			ALGORITHM);
	cipher.init(Cipher.DECRYPT_MODE, key);
	return new String(cipher.doFinal(cipherText), ENCODING);
}
%>