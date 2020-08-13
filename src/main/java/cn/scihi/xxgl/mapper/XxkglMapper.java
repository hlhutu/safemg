package cn.scihi.xxgl.mapper;

import cn.scihi.sdk.base.mapper.IBaseMapper;
import org.apache.ibatis.annotations.Param;

/**
* @author xiongxiaojing
* @version 创建时间：2020年4月28日 下午3:00:10
*/

public interface XxkglMapper extends IBaseMapper{

    Long countFinished(@Param("xxkId") String id, @Param("username") String username);
}
