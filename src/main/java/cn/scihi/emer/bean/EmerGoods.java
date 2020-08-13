package cn.scihi.emer.bean;

import cn.scihi.sdk.base.pojo.BaseBean;
import lombok.Data;

import java.util.Date;

@Data
public class EmerGoods extends BaseBean {
    String id;
    String sys_id;
    String goods_no;//物品编号
    String goods_name;//物品名
    String category;//物品类型
    String rep_id;//所属仓库id
    String goods_unit;//物品单位
    String goods_count;//物品数量
    String description;//简介
    Date created;//创建时间
}
