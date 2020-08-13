package cn.scihi.comm.util;

import java.util.ArrayList;
import java.util.List;

public class Prop {
    String category;
    String key_;
    String value1;
    String value2;
    String value3;

    public String getValue(){
        return this.value1;
    }

    public List<String> getValues(){
        List<String> arr = new ArrayList<>();
        if(value2!=null){
            arr.add(value2);
        }
        if(value3!=null){
            arr.add(value3);
        }
        return arr;
    }
}
