package cn.scihi.yjsj.service.impl;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import cn.scihi.sdk.base.mapper.IBaseMapper;
import cn.scihi.sdk.base.service.ServiceAdapter;

/**
* @author bayueshiwu
* @version 创建时间：2020年6月5日 下午3:44:23
*/
@Service
public class DangerTemplateScaleContentService extends ServiceAdapter{
	@Resource
	private IBaseMapper dangerTemplateScaleContentMapper;

	@Override
	public void init() throws Exception {
		super.baseMapper = dangerTemplateScaleContentMapper;
	}
}
