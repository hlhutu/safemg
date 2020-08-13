package cn.scihi.xxgl.service.impl;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import cn.scihi.sdk.base.mapper.IBaseMapper;
import cn.scihi.sdk.base.service.ServiceAdapter;

/**
* @author xiongxiaojing
* @version 创建时间：2020年4月28日 下午5:06:10
*/
@Service
public class XxjlglService extends ServiceAdapter{
	@Resource
	private IBaseMapper xxjlglMapper;

	@Override
	public void init() throws Exception {
		super.baseMapper = xxjlglMapper;
	}
}
