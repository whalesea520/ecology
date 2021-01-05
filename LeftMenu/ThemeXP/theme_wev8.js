// change this variable to update the theme directory
var ctThemeXPBase = 'ThemeXP/';

// theme node properties
var ctThemeXP1 =
{
  	// tree attributes
  	//
	// except themeLevel, all other attributes can be specified
	// for each level of depth of the tree.

  	// HTML code to the left of a folder item
  	// first one is for folder closed, second one is for folder opened
	folderLeft: [['<img alt="" src="' + ctThemeXPBase + 'folder1_wev8.gif" />', '<img alt="" src="' + ctThemeXPBase + 'folderopen1_wev8.gif" />']],
  	// HTML code to the right of a folder item
  	// first one is for folder closed, second one is for folder opened
  	folderRight: [['', '']],
	// HTML code for the connector
	// first one is for w/ having next sibling, second one is for no next sibling
	// then inside each, the first field is for closed folder form, and the second field is for open form
	folderConnect: [[['<img alt="" src="' + ctThemeXPBase + 'plus_wev8.gif" />','<img alt="" src="' + ctThemeXPBase + 'minus_wev8.gif" />'],
					 ['<img alt="" src="' + ctThemeXPBase + 'plusbottom_wev8.gif" />','<img alt="" src="' + ctThemeXPBase + 'minusbottom_wev8.gif" />']]],

	// HTML code to the left of a regular item
	itemLeft: ['<img alt="" src="' + ctThemeXPBase + 'page_wev8.gif" />'],
	// HTML code to the right of a regular item
	itemRight: [''],
	// HTML code for the connector
	// first one is for w/ having next sibling, second one is for no next sibling
	itemConnect: [['<img alt="" src="' + ctThemeXPBase + 'join_wev8.gif" />', '<img alt="" src="' + ctThemeXPBase + 'joinbottom_wev8.gif" />']],

	// HTML code for spacers
	// first one connects next, second one doesn"t
	spacer: [['<img alt="" src="' + ctThemeXPBase + 'line_wev8.gif" />', '<img alt="" src="' + ctThemeXPBase + 'spacer_wev8.gif" />']],

	// deepest level of theme style sheet specified
	themeLevel: 1
};

// theme node properties
var ctThemeXP2 =
{
	// tree attributes
	//
	// except themeLevel, all other attributes can be specified
	// for each level of depth of the tree.

  	// HTML code to the left of a folder item
  	// first one is for folder closed, second one is for folder opened
	folderLeft: [['<img alt="" src="' + ctThemeXPBase + 'folder2_wev8.gif" />', '<img alt="" src="' + ctThemeXPBase + 'folderopen2_wev8.gif" />']],
  	// HTML code to the right of a folder item
  	// first one is for folder closed, second one is for folder opened
  	folderRight: [['', '']],
	// HTML code for the connector
	// first one is for w/ having next sibling, second one is for no next sibling
	// then inside each, the first field is for closed folder form, and the second field is for open form
	folderConnect: [[['',''],['','']],[['<img alt="" src="' + ctThemeXPBase + 'plus_wev8.gif" />','<img alt="" src="' + ctThemeXPBase + 'minus_wev8.gif" />'],
					 ['<img alt="" src="' + ctThemeXPBase + 'plusbottom_wev8.gif" />','<img alt="" src="' + ctThemeXPBase + 'minusbottom_wev8.gif" />']]],

	// HTML code to the left of a regular item
	itemLeft: ['<img alt="" src="' + ctThemeXPBase + 'page_wev8.gif" />'],
	// HTML code to the right of a regular item
	itemRight: [''],
	// HTML code for the connector
	// first one is for w/ having next sibling, second one is for no next sibling
	itemConnect: [['',''],['<img alt="" src="' + ctThemeXPBase + 'join_wev8.gif" />', '<img alt="" src="' + ctThemeXPBase + 'joinbottom_wev8.gif" />']],

	// HTML code for spacers
	// first one connects next, second one doesn"t
	spacer: [['',''],['<img alt="" src="' + ctThemeXPBase + 'line_wev8.gif" />', '<img alt="" src="' + ctThemeXPBase + 'spacer_wev8.gif" />']],

	// deepest level of theme style sheet specified
	themeLevel: 1
};
