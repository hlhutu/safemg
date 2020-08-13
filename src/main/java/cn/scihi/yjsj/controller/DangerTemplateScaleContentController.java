package cn.scihi.yjsj.controller;

import javax.annotation.Resource;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import cn.scihi.sdk.base.controller.BizController;
import cn.scihi.sdk.base.ucc.IBaseUcc;
import cn.scihi.sdk.util.SysAnnotation.SysLog;

/**
* @author bayueshiwu
* @version 创建时间：2020年6月5日 下午3:46:03
*/
@RestController
@SysLog(module = "隐患排查清单管理")
@RequestMapping("/jsp/danger/template/content")
public class DangerTemplateScaleContentController extends BizController{
	@Resource
	private IBaseUcc dangerTemplateScaleContentUcc;

	@Override
	public void init() throws Exception {
		super.baseUcc = dangerTemplateScaleContentUcc;
	}
}
