var queryOrgUrl_ = ctx + "/sdk/org/select.do";
var queryUserUrl_ = ctx + "/sdk/user/select.do";
var queryRoleUrl_ = ctx + "/sdk/role/select.do";
var queryDictUrl_ = ctx + "/sdk/dict/select.do";
var queryFileUrl_ = ctx + "/sdk/file/select.do";
var queryFileStrUrl_ = ctx + "/sdk/file/selectStr.do";
var deleteFileUrl_ = ctx + "/sdk/file/delete.do";
var updateFileUrl_ = ctx + "/sdk/file/update.do";
var clearUrl_ = ctx + "/sdk/clear.do"; // 刷新缓存
var orderUrl_ = ctx + "/sdk/order.do";

$(window).ready(function() {
	$(".a-clear").on("dblclick", function() {
		var obj = new Object();
		obj.url = clearUrl_;
		ajax(obj, function(result) {
			if ("error" == result.resCode) {
				layer.msg(result.resMsg);
			} else {
				$(".a-reload").click();
			}
		});
	})
	
	try {
		var viewer_;
		$("body").on("click", ".viewer img, #filespan img", function() {
			if(!viewer_) {
				viewer_ = $("#filespan,.viewer").viewer({
					title : false,
					toolbar : false,
					movable : true,
					navbar : true
				});
				$(this).click();
			}else{
				$("#filespan,.viewer").viewer('update');
				$("#filespan,.viewer").viewer('show');
			}
		});
	} catch (e) {
		viewer_ = {};
	}

	$("body").on("click", ".viewer sup", function() {
		if (confirm("您确定要删除文件吗？")) {
			var o = new Object();
			o.url = deleteFileUrl_;
			o.id = $(this).attr("fileid");
			ajax(o, function(result) {
				if ("error" == result.resCode) {
					layer.msg(result.resMsg);
				} else {
					$("." + o.id).remove();
				}
			});
		}
	});
});

function queryFileStr(fk_id, deleteflag, callback) {
	var o = new Object();
	o.url = queryFileStrUrl_;
	o.fk_id = fk_id;
	o.deleteflag = deleteflag;
	o.dataType_="text";
	ajax(o, function(result) {
		 if (typeof callback === "function") {
			callback(result);
		 }else{
			 return result;
		 }
	});
}
