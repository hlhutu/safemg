<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://java.scihi.cn/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<jsp:include page="/jsp/base/base.jsp"></jsp:include>
<style type="text/css">
.w-e-text-container{
    height: 260px !important; 
    

</style>
<script>
	var selectUrl = "${ctx}/jsp/zskgl/zskgl/select.do"; 
	var insertUrl = "${ctx}/jsp/zskgl/zskgl/insert.do";
	var updateUrl = "${ctx}/jsp/zskgl/zskgl/update.do";
	var o = { action : "click", target : ".a-back", result : "" };
	var closeItem = { action : "closeItem", target : document.location.toString() };
	 
	var v = {action:"menuItem", name:"列表", target: "${basePath}/jsp/zskgl/zskList.jsp"};
//	doMessage({action:"closeItem",  target: document.location.toString()});
//	doMessage({action:"menuItem", name:"工单报表", target: target});

	var obj = new Object();
	obj.node = "${param.node}";
	obj.id = "${param.orderId}";
	obj.need_min_pic ="need_min_pic";
	var k_lx ="${param.k_lx}";

	$(window).ready(function() {
		$("#thisform")[0].reset(); 
		wangEditorInit(); 
		editor.txt.clear();
		display();
		var html = " 应急预案";
		if(k_lx=="zsklx"){
			html = " 知识库";
		}else if(k_lx=="zyklx"){
			html = " 资源库";
		}else if(k_lx=="yjyalx"){
			html = " 应急预案";
		}
		$(".a-clear").html(html);
		if (obj.node == "0") { //新增
			$("#thisform").attr("action", insertUrl);
			
		} else { //修改/查看
			obj.url = selectUrl; 
			ajax(obj, function(result) { // 查询业务数据
				if ("error" == result.resCode) {
					layer.msg(result.resMsg);
				} else {
					$("#thisform").fill(result.datas[0]);
					fillSelect("#thisform",result.datas[0]);
					editor.txt.html(result.datas[0].zskgl_content);
					$("#showImg").attr("src",result.datas[0].zskgl_minpic)
					if (null == result.datas[0].zskgl_minpic ||result.datas[0].zskgl_minpic =='') {
						$("#filespan").hide()
					}
					display();
				}
			});
			$("#thisform").attr("action", updateUrl);
		}
		 
		

		$(".action button").on("click", function() {
			try {
				obj.result = $(this).attr("result");
				if ("取消" == obj.result) {
					$("#thisform")[0].reset(); 
					return doMessage(closeItem);
				}

				$("*", $("#thisform")).attr("disabled", false);
				if(editor.txt.html() == "<p><br></p>") {
					layer.msg("内容不能为空！", {icon: 0});
					return;
				}
				var b = $("#thisform").validationEngine("validate"); 
				if (b && confirm("您确定要" + obj.result + "吗？")) { 
					obj.zskgl_content= editor.txt.html()
					var picBase = $("#showImg").attr("src");
					obj.zskgl_minpic = picBase.indexOf("data:image/jpeg;base64")==0?picBase:'';
					ajaxSubmit("#thisform", obj, function(result) {
						if ("error" == result.resCode) {
							layer.msg(result.resMsg);
						} else {
							layer.msg("数据处理成功！", {
								time:500,
								shade : [ 0.1, "#fff" ]  
							}, function() {
								return doMessage(closeItem);
							});
						}
					});
				}
				display();
			} catch (e) {
			}
		});
		
		 $("#file-input").change(function(e){
		        var file = e.target.files[0];
		        var reader = new FileReader();
		        reader.readAsDataURL(file); //读出 base64
		        reader.onloadend = function () {
		            // 图片的base64值
		            var data_64= "data:image/jpeg;base64,"+reader.result.substring(reader.result.indexOf(",")+1);
		            $("#showImg").attr("src",data_64)
		        };
		        $("#filespan").show()
		    });
		 
		 
 
	});

	var display = function() {
		editor.$textElem.attr("contenteditable", true);
		
		var node = obj.node;
		if("0"==node){//新增
			$("#thisform").attr("action", insertUrl); 
			delete obj.id;
			$("#filespan").hide()
			$("*", $("#thisform")).attr("disabled", false);  
			$("#zskgl_publish_time").val(formatDate(new Date()));
			
		} else if ("1" == node) { //修改
			$("#thisform").attr("action", updateUrl); 
			$("*", $("#thisform")).attr("disabled", false);  
		}else if ("-1"==node) { //查看
			$("*", $("#thisform")).attr("disabled", true);  
			$("#thisform").attr("action", "#"); 
			$(".tj").hide();
			$("*",$(".action")).attr("disabled",false); 
			$("#file-input").hide();
			editor.$textElem.attr('contenteditable', false)
		}
		
	}
	var wangEditorInit = function(){
		try {
			E = window.wangEditor;
			editor = new E(".editor");
		 	editor.customConfig.uploadImgShowBase64 = true;
			editor.customConfig.menus = [
                'head',  // 标题
			    'bold',  // 粗体
			    'fontSize',  // 字号
			    'fontName',  // 字体
			    'italic',  // 斜体
			    'underline',  // 下划线
			    'strikeThrough',  // 删除线
			    'foreColor',  // 文字颜色
			    'backColor',  // 背景颜色
			    'link',  // 插入链接
			    'list',  // 列表
			    'justify',  // 对齐方式
			  //'emoticon',  // 表情
			    'image',  // 图片
			    'table',  // 表格
			    'code',  // 插入代码
			    'undo',  // 撤销
			    'redo'  // 重复
            ];
			editor.create();
			E.fullscreen.init('.editor');
			editor.$textElem.attr('contenteditable', false);
			$(".editor").height("700px !important")
		} catch(ex) {}
	}
	
	
 
</script>
</head>

<body class="gray-bg">
	<div class="wrapper wrapper-content animated fadeIn">
		<div class="row">
			<div class="col-sm-12">
				<div class="ibox float-e-margins">
					<form id="thisform" class="form-horizontal" role="form" onsubmit="return false;">
					<div class="ibox-title">
						<h5>
							<i class="fa fa-file-o a-clear"></i> 详情
						</h5>
						<div class="ibox-tools">
							<a class="a-reload"> <i class="fa fa-repeat"></i> 刷新
							</a>
						</div>
					</div>
						<div class="ibox-content"> 
			                  
			                  <input type="text" id="k_lx" name="k_lx" value ="${param.k_lx}" style="display: none" />
			                  <div class="form-group"  >
			                  	<label class="col-sm-1 control-label">标题</label>
							    <div class="col-sm-5"> 
							      <input type="text" class="input-sm form-control validate[required]" name="zskgl_title" id="zskgl_title" maxtlenth='30' > 
							    </div>
							  	<label class="col-sm-1 control-label" class='publish_time'>类型</label>
							    <div class="col-sm-5" class='publish_time'>
							     	<s:dict dictType="${param.k_lx}" name="zskgl_type" clazz="input-sm form-control validate[required]"></s:dict>
							    </div>
							  </div>	
							  
							  <div class="form-group"  >  
							    <label class="col-sm-1 control-label">作者</label>
							    <div class="col-sm-5">
							    	<input type="text" name="zskgl_author" id="zskgl_author"  value="${myUser.username}" style="display: none;">
							    	<input type="text" class="input-sm form-control validate[required]" name="zskgl_author_desc" id="zskgl_author_desc" readonly="readonly" value="${myUser.user.user_alias}">
							    </div>
							    
							    <label class="col-sm-1 control-label" class='publish_time'>发布时间</label>
							    <div class="col-sm-5" class='publish_time'>
							      <input type="text" class="input-sm form-control date_select  validate[required]" name="zskgl_publish_time" id="zskgl_publish_time" readonly="readonly" >
							    </div>	
							  </div>
							   
							  
			                  
							   <div class="form-group"  >
								   <label class="col-sm-1 control-label">简述</label>
								    <div class="col-sm-11">
								      <input type="text" class="input-sm form-control validate[required]" name="zskgl_remark" id="zskgl_remark" maxtlenth='100' >
								    </div> 
							   </div>
							   
					
							
							  
							  <div class="form-group">
								<label class="col-sm-1 control-label" >内容</label>
						    	<div class="col-sm-11">
									<div class="editor"></div>
						    	</div>
						  	  </div>
						  	  <div class="form-group  btn-group1"  >
								<label class="col-sm-1 control-label"></label>
							    <div class="col-sm-4">
							      <label><input type="radio" name="status" value="1" checked="checked">发布</label>
						      	  <label><input type="radio" name="status" value="2">草稿</label>
						      	  <label><input type="radio" name="status" value="3">过期</label>
							    </div>
							</div>
						  	 <div class="form-group">
						  	 	<label class="col-sm-1 control-label" >缩略图</label>
						  	 	<div class="col-sm-2">
									<input type="file" id="file-input" name="fileContent"  accept="image/gif,image/jpeg,image/jpg,image/png" value="缩略图">
						    	</div>	
						    	<div class="col-sm-8" id="filespan">
						  	  		<img id="showImg" src="../../images/icon_star.png" />
						  		</div>
						  		
						  	 </div>
						  	   
							  
							
							<div class="form-group action">
								<div class="col-sm-12" style="text-align: center">
									<button type="button" class="btn btn-sm btn-success btn-group1 tj" result="提交">
										<i class="fa fa-check"></i> 提交
									</button>
									<button type="button" class="btn btn-sm btn-warning btn-group1 qx" result="取消">
										<i class="fa fa-remove"></i> 取消
									</button>
								</div>
							</div>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
</body>
</html>