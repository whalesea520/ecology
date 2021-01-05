/* To avoid CSS expressions while still supporting IE 7 and IE 6, use this script */
/* The script tag referencing this file must be placed before the ending body tag. */

/* Use conditional comments in order to target IE 7 and older:
	<!--[if lt IE 8]><!-->
	<script src="ie7/ie7.js"></script>
	<!--<![endif]-->
*/

(function() {
	function addIcon(el, entity) {
		var html = el.innerHTML;
		el.innerHTML = '<span style="font-family: \'icon-blog\'">' + entity + '</span>' + html;
	}
	var icons = {
		'icon-blog-down': '&#xe913;',
		'icon-blog-up': '&#xe900;',
		'icon-blog-edit': '&#xe95c;',
		'icon-blog-AddTo': '&#xe93b;',
		'icon-blog-blank': '&#xe93a;',
		'icon-blog-follow': '&#xe941;',
		'icon-blog-ArrowheadDown': '&#xe901;',
		'icon-blog-ArrowheadUp': '&#xe939;',
		'icon-blog-AlreadyConcern': '&#xe906;',
		'icon-blog-drop-down': '&#xe937;',
		'icon-blog-NewMessage': '&#xe938;',
		'icon-blog-delete': '&#xe936;',
		'icon-blog-Explain': '&#xe935;',
		'icon-blog-delay': '&#xe931;',
		'icon-blog-o': '&#xe932;',
		'icon-blog-solid': '&#xe933;',
		'icon-blog-Submit': '&#xe934;',
		'icon-blog-Pay': '&#xe922;',
		'icon-blog': '&#xe923;',
		'icon-blog-down2': '&#xe919;',
		'icon-blog-up2': '&#xe920;',
		'icon-blog-Absenteeism': '&#xe924;',
		'icon-blog-checkbox': '&#xe925;',
		'icon-blog-Explain-o': '&#xe926;',
		'icon-blog-index': '&#xe927;',
		'icon-blog-Late': '&#xe928;',
		'icon-blog-left': '&#xe929;',
		'icon-blog-normal': '&#xe92a;',
		'icon-blog-remind': '&#xe92b;',
		'icon-blog-ReportForm': '&#xe92c;',
		'icon-blog-right': '&#xe92d;',
		'icon-blog-Uncommitted-o': '&#xe92e;',
		'icon-blog-Uncommitted': '&#xe92f;',
		'icon-blog-Unhappy': '&#xe930;',
		'icon-blog-at': '&#xe902;',
		'icon-blog-branch': '&#xe903;',
		'icon-blog-CancelConcern': '&#xe904;',
		'icon-blog-Comment': '&#xe905;',
		'icon-blog-Customer': '&#xe93c;',
		'icon-blog-Document': '&#xe907;',
		'icon-blog-Emoji': '&#xe908;',
		'icon-blog-Enclosure': '&#xe909;',
		'icon-blog-Good': '&#xe90a;',
		'icon-blog-Lock': '&#xe90b;',
		'icon-blog-MessageReminder': '&#xe90c;',
		'icon-blog-Modular': '&#xe90d;',
		'icon-blog-Mood': '&#xe90e;',
		'icon-blog-MutualConcern': '&#xe90f;',
		'icon-blog-NewPacket': '&#xe910;',
		'icon-blog-NextPage': '&#xe911;',
		'icon-blog-NoData': '&#xe912;',
		'icon-blog-Note': '&#xe93d;',
		'icon-blog-Personnel': '&#xe914;',
		'icon-blog-Previous_page': '&#xe915;',
		'icon-blog-Process': '&#xe916;',
		'icon-blog-Project': '&#xe917;',
		'icon-blog-region': '&#xe918;',
		'icon-blog-Schedule': '&#xe91a;',
		'icon-blog-Score-o': '&#xe91b;',
		'icon-blog-Score': '&#xe91c;',
		'icon-blog-Task': '&#xe91d;',
		'icon-blog-VisiblePart': '&#xe91e;',
		'icon-blog-next-month': '&#xe91f;',
		'icon-blog-last-month': '&#xe921;',
		'0': 0
		},
		els = document.getElementsByTagName('*'),
		i, c, el;
	for (i = 0; ; i += 1) {
		el = els[i];
		if(!el) {
			break;
		}
		c = el.className;
		c = c.match(/icon-[^\s'"]+/);
		if (c && icons[c[0]]) {
			addIcon(el, icons[c[0]]);
		}
	}
}());
