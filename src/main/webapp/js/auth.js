// portal = 'http://localhost:8080/portal';
var setMyUser = function(result) {
	if (result.resCode == 'error') {
		var d = new Date(0).toGMTString();
		document.cookie = 'jsid=;expires=' + d + ';path=/';
		document.cookie = 'token=;expires=' + d + ';path=/';
		if (confirm('获取认证信息失败，请先登录！')) {
			location.href = portal + '/j_security_logout';
		}
	} else {
		myUser = result.datas;
		document.cookie = 'jsid=' + result.jsid + ';path=/';
		document.cookie = 'token=' + myUser.user.extMap.token + ';path=/';
	}
};
document.write('<script src="' + portal
		+ '/api/sys/myUser.do?ajax=1&callback=setMyUser"></script>');
