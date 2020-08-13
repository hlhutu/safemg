package cn.scihi.mbgl.mapper;

import cn.scihi.comm.util.Prop;
import cn.scihi.sdk.base.mapper.IBaseMapper;

import java.util.List;
import java.util.Map;

/**
 * @author uplus
 *
 */
public interface PropMapper extends IBaseMapper {
    List<Prop> selectForBean(Map<String, Object> var1);
}
