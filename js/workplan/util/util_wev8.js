/**
 * 单位数字前补0构成两位
 */
function formatSingleDateTime(singleNumber)
{
	return (singleNumber < 10 ? "0" + singleNumber.toString() : singleNumber.toString());
}

/**
 * 取时间的下方最接近00或30分钟数
 */
function floorTime(time)
{
	return time.split(":")[0] + ":" + (parseInt(time.split(":")[1]) < 30 ? "00" : "30");
}

/**
 * 日期时间之间相差数
 */
function dateTimeDifference(startDate, startTime, endDate, endTime)
//返回单位为分钟
{
	var startDateYear = startDate.split("-")[0];
	var startDateMonth = startDate.split("-")[1] - 1;
	var startDateDay = startDate.split("-")[2];
	var startDateHour = startTime.split(":")[0];
	var startDateMinute = startTime.split(":")[1];
	
	var endDateYear = endDate.split("-")[0];
	var endDateMonth = endDate.split("-")[1] - 1;
	var endDateDay = endDate.split("-")[2];
	var endDateHour = endTime.split(":")[0];
	var endDateMinute = endTime.split(":")[1];
	
	var millisecond = (new Date(endDateYear, endDateMonth, endDateDay, endDateHour, endDateMinute)).valueOf() - (new Date(startDateYear, startDateMonth, startDateDay, startDateHour, startDateMinute)).valueOf();

	return millisecond / (60 * 1000);
}

/**
 * 时间之间相差数
 */
function timeDifference(startTime, endTime)
{
	var startDateHour = startTime.split(":")[0];
	var startDateMinute = startTime.split(":")[1];
	
	var endDateHour = endTime.split(":")[0];
	var endDateMinute = endTime.split(":")[1];

	var millisecond = (new Date().setHours(endDateHour, endDateMinute)).valueOf() - (new Date().setHours(startDateHour, startDateMinute)).valueOf();

	return millisecond / (60 * 1000);
}

/**
 * 时间加分钟
 */
function dateTimeAdd(startDate, startTime, addMinute)
{
	var startDateYear = startDate.split("-")[0];
	var startDateMonth = startDate.split("-")[1] - 1;
	var startDateDay = startDate.split("-")[2];
	var startDateHour = startTime.split(":")[0];
	var startDateMinute = startTime.split(":")[1];
	
	var startDate = new Date(startDateYear, startDateMonth, startDateDay, startDateHour, startDateMinute);
	
	var finalDate = new Date(startDate.valueOf() + addMinute * 60 * 1000);
	
	return finalDate;
}

/**
 * 类转换成日期字符串
 */
function date2DateString(/*Date*/ date)
{
	return (date.getYear() + "-" + formatSingleDateTime(date.getMonth() + 1).toString() + "-" + formatSingleDateTime(date.getDate()).toString());
}

/**
 * 类转换成时间字符串
 */
function date2TimeString(/*Date*/ date)
{
	return (formatSingleDateTime(date.getHours()).toString() + ":" + formatSingleDateTime(date.getMinutes()).toString());
}

/**
 * 当前鼠标坐标
 */
function coordinateReport()
{
	var absoluteX = event.clientX + document.body.scrollLeft;
	var absoluteY = event.clientY + document.body.scrollTop;
	status = '在整个页面中的X, Y坐标 : (' + absoluteX + ', ' + absoluteY +');' +
			 '在当前窗口中的X, Y坐标 : (' + event.clientX + ', ' + event.clientY + ')';
}

/**
 * 调试日志
 */
function writeLog(id, content)
{
	id.childNodes[1].innerHTML += content + "end<br>";
}

/**
 * 页面滚动
 */
function windowScroll(x, y)
{
	window.scroll(x, y);
}


