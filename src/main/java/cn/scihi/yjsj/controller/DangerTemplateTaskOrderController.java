package cn.scihi.yjsj.controller;

import javax.annotation.Resource;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import cn.scihi.sdk.base.controller.BizController;
import cn.scihi.sdk.base.ucc.IBaseUcc;
import cn.scihi.sdk.util.SysAnnotation.SysLog;

/**
* @author bayueshiwu
* @version 创建时间：2020年6月9日 上午10:18:05
*/
@RestController
@SysLog(module = "执法任务项完成情况管理")
@RequestMapping("/jsp/template/user/order")
public class DangerTemplateTaskOrderController extends BizController{
	@Resource
	private IBaseUcc dangerTemplateTaskOrderUcc;

	@Override
	public void init() throws Exception {
		super.baseUcc = dangerTemplateTaskOrderUcc;
	}
}
