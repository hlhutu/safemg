/**
 * 
 */
window.wangEditor.fullscreen = {
	// editor create之后调用
	init: function(editorSelector){
		$(editorSelector + " .w-e-toolbar").append('<div class="w-e-menu"><a class="_wangEditor_btn_fullscreen" onclick="window.wangEditor.fullscreen.toggleFullscreen(\'' + editorSelector + '\')">Max</a></div>');
	},
	toggleFullscreen: function(editorSelector){
		$(editorSelector).toggleClass('fullscreen-editor');
		if($(editorSelector + ' ._wangEditor_btn_fullscreen').text() == 'Max'){
			$(editorSelector + ' ._wangEditor_btn_fullscreen').text('Min');
		}else{
			$(editorSelector + ' ._wangEditor_btn_fullscreen').text('Max');
		}
	}
};