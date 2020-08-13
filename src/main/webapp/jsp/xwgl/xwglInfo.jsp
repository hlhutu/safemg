<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://java.scihi.cn/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<style type="text/css">
.w-e-text-container{
    height: 300px !important; 
</style>
<jsp:include page="/jsp/base/base.jsp"></jsp:include>
<script>
	var selectUrl = "${ctx}/jsp/xwgl/select.do";
	var insertUrl = "${ctx}/jsp/xwgl/insert.do";
	var updateUrl = "${ctx}/jsp/xwgl/update.do";
	
	var closeItem = { action : "closeItem", target : document.location.toString() }; //关闭

	var obj = new Object();
	obj.node = "${param.node}";
	obj.id = "${param.orderId}";

	var minpic = null;
	var maxpic = null;
	
	$(window).ready(function() {
		$("#thisform")[0].reset(); 
		wangEditorInit(); 
		editor.txt.clear();
		display();

		if (obj.node == "0") { //新增
			$("#thisform").attr("action", insertUrl);
		} else { //修改/查看
			$("#thisform").attr("action", updateUrl);
			obj.url = selectUrl; 
			ajax(obj, function(result) { // 查询业务数据
				if ("error" == result.resCode) {
					layer.msg(result.resMsg);
				} else {
					minpic = result.datas[0].xwgl_minpic;
					maxpic = result.datas[0].xwgl_maxpic;
					if (null ==minpic || ''==minpic) {
						$("#minpic").hide();
					}
					if(null ==maxpic || ''==maxpic){
						$("#maxpic").hide(); 
					}
					result.datas[0].xwgl_minpic=null;
					result.datas[0].xwgl_maxpic=null;
					
					$("#thisform").fill(result.datas[0]);
					fillSelect("#thisform",result.datas[0]);
					editor.txt.html(result.datas[0].xwgl_content);
					display();
				}
			});
		}
		 
		$(".action button").on("click", function() {
			try {
				obj.result = $(this).attr("result");
				if ("取消" == obj.result) {
					return doMessage(closeItem);
				}

				$("*", $("#thisform")).attr("disabled", false);
				if(editor.txt.html() == "<p><br></p>") {
					layer.msg("内容不能为空！", {icon: 0});
					return;
				}
				var b = $("#thisform").validationEngine("validate"); 
				if (b && confirm("您确定要" + obj.result + "吗？")) { 
					obj.xwgl_content= editor.txt.html()
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
	});

	var display = function() {
		editor.$textElem.attr("contenteditable", true);
		
		var node = obj.node;
		if("0"==node){//新增
			$("*", $("#thisform")).attr("disabled", false);   
			$("#minpic").hide();
			$("#maxpic").hide();
			$("#xwgl_publish_time").val(formatDate(new Date()));
			$("#xwgl_publish_time").attr("disabled",true)
		}else if ("1" == node) { //修改
			if(minpic !=null){
				$("#minpic").prop("src","data:image/png;base64,"+minpic);
			}
			if(maxpic !=null){
				$("#maxpic").prop("src","data:image/png;base64,"+maxpic);
			}
			
			$("*", $("#thisform")).attr("disabled", false);  
		}else if ("-1"==node) { //查看详情
			if(minpic !=null){
				$("#minpic").prop("src","data:image/png;base64,"+minpic);
			}
			if(maxpic !=null){
				$("#maxpic").prop("src","data:image/png;base64,"+maxpic);
			}
			$("#minpic_sm").hide();
			$("#maxpic_sm").hide();
			
			$("*", $("#thisform")).attr("disabled", true);  
			$(".tj").hide();
			$("*",$(".action")).attr("disabled",false); 
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
								<class="fa fa-file-o a-clear"></i> 详情
							</h5>
							<div class="ibox-tools">
								<a class="a-reload"> <i class="fa fa-repeat"></i> 刷新
								</a>
							</div>
						</div>
						<div class="ibox-content"> 
			            	<div class="form-group">
			                  	<label class="col-sm-1 control-label">作者</label>
							    <div class="col-sm-5">
							      <input type="text" class="input-sm form-control validate[required]" name="xwgl_author" id="xwgl_author" >
							    </div>
			                  	<div id="publish_time">
			                  		<label class="col-sm-1 control-label">发布时间</label>
								    <div class="col-sm-5">
								      <input type="text" class="input-sm form-control date_select" name="xwgl_publish_time" id="xwgl_publish_time" readonly="readonly" >
								    </div>
			                  	</div>
							  </div>
			                  
							  <div class="form-group">
							    <label class="col-sm-1 control-label">标题</label>
							    <div class="col-sm-11">
							      <input type="text" class="input-sm form-control validate[required]" name="xwgl_title" id="xwgl_title" >
							    </div>
							  </div>
							
							  <div class="form-group">
								<label class="col-sm-1 control-label">内容</label>
						    	<div class="col-sm-11">
									<div class="editor"></div>
						    	</div>
						  	  </div>
							  <div class="form-group" id="filespan">
							    <label class="col-sm-1 control-label">缩略图</label>
							    <div class="col-sm-2" id="minpic_sm">
							      <input type="file" accept="image/gif,image/jpeg,image/jpg,image/png" class="input-sm form-control" name="xwgl_minpic" id="xwgl_minpic">
							    </div>
							    <div class="col-sm-3">
							    	<img id="minpic" heiht="60px" width="60px"/>
							    </div>
							    
							    <label class="col-sm-1 control-label">背景图</label>
							    <div class="col-sm-2" id="maxpic_sm">
							      <input type="file" accept="image/gif,image/jpeg,image/jpg,image/png" class="input-sm form-control" name="xwgl_maxpic" id="xwgl_maxpic">
							    </div>
							    <div class="col-sm-3">
							    	<img id="maxpic" heiht="60px" width="60px"/>
							    </div>
							  </div>
							  <div class="form-group">
							    <label class="col-sm-1 control-label"></label>
							    <div class="col-sm-4">
							      <label><input type="radio" name="status" value="1" checked="checked"><span style="color:#008B00">发布</span></label>
						      	  <label><input type="radio" name="status" value="2"><span style="color:#DAA520">草稿</span></label>
						      	  <label><input type="radio" name="status" value="3">过期</label>
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