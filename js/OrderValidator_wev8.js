/**
 * Check the order of two values validator.
 * @author	lupeng
 * @version	04/08/04 
 * 
 * @param	objStartName	the start value.
 * @param	objEndName		the end value.
 * @return	true			return true, if the order is valid, otherwise return false.
 */
function checkOrderValid(objStartName, objEndName) {
	var start = document.all(objStartName).value;
	var end = document.all(objEndName).value;

	if ((start == null || start == "") || (end == null || end == ""))
		return true;

	if (start > end)
		return false;

	return true;
}