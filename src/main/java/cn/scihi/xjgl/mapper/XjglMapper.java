package cn.scihi.xjgl.mapper;

import cn.scihi.sdk.base.mapper.IBaseMapper;
import org.apache.ibatis.annotations.Param;

/**
 * @author uplus
 *
 */
public interface XjglMapper extends IBaseMapper {
    Long countByJdd(@Param("jddId") String jddId);
}
