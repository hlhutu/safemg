package cn.scihi.yjsj.service.impl;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import cn.scihi.sdk.base.mapper.IBaseMapper;
import cn.scihi.sdk.base.service.ServiceAdapter;

/**
* @author xiongxiaojing
* @version 创建时间：2020年6月2日 上午10:36:10
*/
@Service
public class DangerTemplateScaleService extends ServiceAdapter{
	@Resource
	private IBaseMapper dangerTemplateScaleMapper;

	@Override
	public void init() throws Exception {
		super.baseMapper = dangerTemplateScaleMapper;
	}
}
