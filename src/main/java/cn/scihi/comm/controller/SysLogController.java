package cn.scihi.comm.controller;

import cn.scihi.comm.service.SysLogService;
import cn.scihi.sdk.base.controller.BaseController;
import cn.scihi.sdk.util.SysAnnotation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@SysAnnotation.SysLog(module = "日志")
@RequestMapping("/syslog")
public class SysLogController extends BaseController {
    @Autowired
    private SysLogService sysLogService;

    /**
     * showdoc
     * @catalog 南充应急/日志
     * @title 定期删除日志
     * @description 每天凌晨00:30删除一周之前的日志
     * @method post
     * @url /syslog/clean.do
     * @param - - - -
     * @return {}
     * @return_param datas Object 返回数据
     * @remark
     * @number 0
     */
    @ResponseBody
    @RequestMapping(value = {"/clean"}, method = RequestMethod.POST)
    @SysAnnotation.SysLog(module = "日志", method = "定期删除日志")
    @Transactional(rollbackFor = Exception.class)
    @Scheduled(cron = "0 30 0 1/1 * ? ")
    //@Scheduled(cron = "0 0/1 * * * ? ")
    public synchronized String clean() throws Exception {
        Long i = sysLogService.clean();
        return this.toJSONString(i);
    }
}
