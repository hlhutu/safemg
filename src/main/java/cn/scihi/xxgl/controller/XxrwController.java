package cn.scihi.xxgl.controller;

import javax.annotation.Resource;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import cn.scihi.sdk.base.controller.BizController;
import cn.scihi.sdk.base.ucc.IBaseUcc;
import cn.scihi.sdk.util.SysAnnotation.SysLog;

/**
* @author xiongxiaojing
* @version 创建时间：2020年6月2日 下午5:56:27
*/
@RestController
@SysLog(module = "学习任务管理")
@RequestMapping("/jsp/xxrwgl")
public class XxrwController extends BizController{
	@Resource
	private IBaseUcc xxrwUcc;

	@Override
	public void init() throws Exception{
		super.baseUcc = xxrwUcc;
	}
}
