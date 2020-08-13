package cn.scihi.app;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import cn.scihi.sdk.base.controller.BizController;
import cn.scihi.sdk.base.ucc.IBaseUcc;
import cn.scihi.sdk.util.SysAnnotation.SysLog;

/**
 * @author uplus
 *
 */
@Controller
@SysLog(module = "版本更新")
@RequestMapping("/biz/app")
public class AppController extends BizController {

	@Autowired
	private IBaseUcc appUcc;

	public void init() {
		super.setBaseUcc(appUcc);
	}
}
