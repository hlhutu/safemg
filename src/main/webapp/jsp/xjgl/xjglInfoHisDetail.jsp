<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://java.scihi.cn/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<jsp:include page="/jsp/base/base.jsp"></jsp:include>
<script src="${ctx}/js/plugins/jquery.jeditable.js"></script>
<link href="${ctx}/js/plugins/viewer/viewer.min.css" rel="stylesheet">
<script type="text/javascript" src="${ctx}/js/plugins/viewer/viewer.min.js?v=1.1.0"></script>
<script>
	var selectUrl = "${ctx}/biz/xjglInfo/select.do";
	var insertUrl = "${ctx}/biz/xjglInfo/insert.do";
	var updateUrl = "${ctx}/biz/xjglInfo/update.do";
	var deleteUrl = "${ctx}/biz/xjglInfo/delete.do";
	
	
	var callbackUrl = "${ctx}/sdk/callback.do";
	
	var back = { action : "click", target : ".a-back", result : "" };
	var closeItem = { action : "closeItem", target : document.location.toString() };
	var table;
	var obj = {
			id:"${param.id}"
	};
	
	$(window).ready(function() {
		$("#editForm *").attr("disabled",true);
		if(obj.id){
			obj.url = selectUrl;
			ajax(obj, function(result) { // 查询业务数据
				if ("error" == result.resCode) {
					layer.msg(result.resMsg, {icon: 2});
				} else if(result.datas && result.datas.length == 1) {
					$("#editForm").fill(result.datas[0]);
					 queryFileStr(obj.id, 99,function(res){
						$(".fileList").removeClass("hide");
						$(".files").html(res);
					}); 
				} else {
					layer.msg("未找到相关数据，请刷新页面！", {icon: 7});
				}
			});
		}
		
		
		$("#btn-query").on("click", function() {
			var b = $("#queryForm").validationEngine("validate");
			if(b) {
				dtParam.keywords = $("#keywords").val();
				table.api().settings()[0].ajax.data = dtParam;
				table.api().ajax.reload();
			}
       	});
		
		$("#btn-insert").on("click", function() {
			$("#editForm").attr("action", insertUrl);
			$("#myModal").modal("show");
       	});
          
		
		$("#btn-ok").on("click", function() {
			var b = $("#editForm").validationEngine("validate");
			if(b) {
				ajaxSubmit("#editForm", function(result) {
					if ("error" == result.resCode) {
						layer.msg(result.resMsg, {icon: 2});
					} else {
						layer.msg("数据处理成功！", {icon: 1});
						table.api().ajax.reload(null, false);
						$("#myModal").modal("hide");
					}
				});
			}
		});
		
		$("body").on("click", ".info" , function() {
			$("*", $("#editForm")).attr("disabled", true);
			var size = $(".ids_:checkbox:checked").length;
			if(size != 1) {
				layer.msg("请选择需要修改的一行数据！", {icon: 0});
				return;
			}
			
			$("#myModal").modal("show");

			var obj = new Object();
			obj.url = selectUrl;
			obj.id = $(".ids_:checkbox:checked").val();
			ajax(obj, function(result) {
				if ("error" == result.resCode) {
					layer.msg(result.resMsg, {icon: 2});
				} else if(result.datas && result.datas.length == 1) {
					$("#editForm").fill(result.datas[0]);
					 queryFileStr(obj.id, 99,function(res){
						$(".fileList").removeClass("hide");
						$(".files").html(res);
					}); 
				} else {
					layer.msg("未找到相关数据，请刷新页面！", {icon: 7});
				}
			});
       	});
		
		/* document.getElementById("map").contentDocument.getElementById("mapRef").οnclick=function(){
			var rs ={};
			rs.lat=	$('iframe').contents().find("#latY").val();
			rs.lng=$('iframe').contents().find("#lngX").val();
			rs.address=$('iframe').contents().find("#keyword").val();
			console.log(rs);
		}; */
		
	});
	
	

</script>
</head>

<body class="gray-bg">
	<div class="wrapper wrapper-content animated fadeIn">
		<div class="row">
			<div class="col-sm-12">
				<div class="ibox float-e-margins">
	           		<div class="ibox-title">
	                    <h5><i class="fa fa-pencil-square-o"></i>巡检任务详情</h5>
	                    <div class="ibox-tools">
	                       <a class="a-reload">
	                          <i class="fa fa-repeat"></i> 刷新
	                       </a>
	                    </div>
	                </div>
	            
		            <div class="ibox-content">
						<form id="editForm" class="form-horizontal key-13" role="form" onsubmit="return false;">
	            
		            <div class="ibox-content">
	                  <input type="text" id="id" name="id" style="display:none"/>
	                  <input type="text" id="sysid" name="sysid" value="${myUser.user.extMap.sys.id}" style="display:none"/>
	                  <input type="text" id="parentId" name="parentId" style="display: none;">
	                  
					  <div class="form-group">
					    <label class="col-sm-2 control-label">序号</label>
					    <div class="col-sm-4">
					    	<input type="text" class="input-sm form-control " name="xh" id="xh">
					    </div>
					    <label class="col-sm-2 control-label">任务项</label>
					    <div class="col-sm-4">
					   	 	<input type="text" class="input-sm form-control " name="rwx" id="rwx">
					    </div>
					  </div>
					  
					  <div class="form-group">
					  	<label class="col-sm-2 control-label">巡检地点</label>
					    <div class="col-sm-4">
					      <input type="text" class="input-sm form-control " name="rwdd" id="rwdd" >
					    </div>
					    <label class="col-sm-2 control-label">经纬度</label>
					    <div class="col-sm-4">
					    	<input type="text" class="input-sm form-control " name="lnglat" id="lnglat" >
					    </div>
					  </div>
					  
					  <div class="form-group">
					  	<label class="col-sm-2 control-label">执行人</label>
					    <div class="col-sm-4">
					      <input type="text" class="input-sm form-control  " name="zxr_desc" id="zxr_desc" >
					    </div>
					    <label class="col-sm-2 control-label">执行时间</label>
					    <div class="col-sm-4">
					      <input type="text" class="input-sm form-control "  name="zxsj" id="zxsj">
					    </div>
					  </div>
					  
					  <div class="form-group">
					  	<label class="col-sm-2 control-label">执行经度</label>
					    <div class="col-sm-4">
					       <input type="text" class="input-sm form-control "  name="zxjd" id="zxjd">
					    </div>
					  	<label class="col-sm-2 control-label">执行纬度</label>
					    <div class="col-sm-4">
					       <input type="text" class="input-sm form-control "  name="zxwd" id="zxwd">
					    </div>
					</div>
					
 					<div class="form-group">
					  	<label class="col-sm-2 control-label">执行结果</label>
					    <div class="col-sm-4">
					      <input type="radio" name="zxjg" id="zxjg" readonly="readonly" value="1"> 正常
					      <input type="radio" name="zxjg" id="zxjg" readonly="readonly" value="0"> 异常
					    </div>
					  </div>

					  <div class="form-group">
					    <label class="col-sm-2 control-label">执行备注</label>
					    <div class="col-sm-10">
					      <textarea class="form-control" name="zxbz" id="zxbz" ></textarea>
					    </div>
					    <div class="form-group hide fileList">
							<label class="col-sm-2 control-label">附件列表</label>
							<div class="col-sm-10 files" style="padding-top:10px;">
								
							</div>
						</div>
					  </div>
		            </div>
				</form>

		            </div>
				</div>
			</div>
		</div>
	</div>
	
	
</body>
</html>