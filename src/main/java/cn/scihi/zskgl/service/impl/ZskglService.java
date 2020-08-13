/**
 * 
 */
package cn.scihi.zskgl.service.impl;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import cn.scihi.sdk.base.service.ServiceAdapter;
import cn.scihi.zskgl.mapper.ZskglMapper;

/**
 * @author wyc
 *
 */
@Service
public class ZskglService extends ServiceAdapter {

	@Resource
	private ZskglMapper zskglMapper;

	public void init() {
		super.baseMapper = zskglMapper;
	} 
}
