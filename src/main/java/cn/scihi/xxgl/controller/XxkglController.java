package cn.scihi.xxgl.controller;

import javax.annotation.Resource;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import cn.scihi.sdk.base.controller.BizController;
import cn.scihi.sdk.base.ucc.IBaseUcc;
import cn.scihi.sdk.util.SysAnnotation.SysLog;

/**
* @author xiongxiaojing
* @version 创建时间：2020年4月28日 下午5:12:47
*/
@RestController
@SysLog(module = "学习库管理")
@RequestMapping("/jsp/xxkgl")
public class XxkglController extends BizController{
	@Resource
	private IBaseUcc xxkglUcc;

	@Override
	public void init() throws Exception {
		super.baseUcc = xxkglUcc;
	}
}
