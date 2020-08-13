package cn.scihi.yjsj.service.impl;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import cn.scihi.sdk.base.mapper.IBaseMapper;
import cn.scihi.sdk.base.service.ServiceAdapter;

/**
* @author bayueshiwu
* @version 创建时间：2020年6月9日 上午10:16:26
*/
@Service
public class DangerTemplateTaskService extends ServiceAdapter{
	@Resource
	private IBaseMapper dangerTemplateTaskMapper;

	@Override
	public void init() throws Exception {
		super.baseMapper = dangerTemplateTaskMapper;
	}
}
